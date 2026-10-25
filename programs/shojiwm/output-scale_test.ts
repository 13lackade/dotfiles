import {
  edidPhysicalSize,
  readPhysicalSizes,
  reportSizes,
} from "./output-scale.ts";
import { displayScale } from "./src/display-scale.ts";

function equal(actual: unknown, expected: unknown): void {
  if (JSON.stringify(actual) !== JSON.stringify(expected)) {
    throw new Error(
      `Expected ${JSON.stringify(expected)}, got ${JSON.stringify(actual)}`,
    );
  }
}

function edid(width: number, height: number): Uint8Array {
  const bytes = new Uint8Array(128);
  bytes.set([0, 255, 255, 255, 255, 255, 255, 0]);
  bytes[54] = 1; // Mark the descriptor as a detailed timing.
  bytes[66] = width & 255;
  bytes[67] = height & 255;
  bytes[68] = ((width >> 8) << 4) | (height >> 8);
  checksum(bytes);
  return bytes;
}

function checksum(bytes: Uint8Array): void {
  bytes[127] = 0;
  bytes[127] = (256 - bytes.reduce((sum, value) => sum + value, 0) % 256) % 256;
}

Deno.test("EDID detailed timings decode millimetres including high bits", () => {
  equal(edidPhysicalSize(edid(527, 296)), { width: 527, height: 296 });
});

Deno.test("base EDID centimetres are used when timing size is absent", () => {
  const bytes = edid(0, 0);
  bytes[21] = 30;
  bytes[22] = 19;
  checksum(bytes);
  equal(edidPhysicalSize(bytes), { width: 300, height: 190 });
});

Deno.test("missing, truncated and corrupt EDID do not produce dimensions", () => {
  equal(edidPhysicalSize(edid(0, 0)), undefined);
  equal(edidPhysicalSize(new Uint8Array()), undefined);
  const bytes = edid(302, 188);
  bytes[66] ^= 1;
  equal(edidPhysicalSize(bytes), undefined);
  bytes.fill(0);
  equal(edidPhysicalSize(bytes), undefined);
});

Deno.test("scale distinguishes laptop HiDPI, ordinary external and VM outputs", () => {
  equal(
    displayScale({ width: 1920, height: 1200 }, { width: 302, height: 188 }),
    1.5,
  );
  equal(
    displayScale({ width: 1920, height: 1080 }, { width: 527, height: 296 }),
    1,
  );
  equal(
    displayScale({ width: 3840, height: 2160 }, { width: 600, height: 340 }),
    1.5,
  );
  equal(
    displayScale({ width: 2560, height: 1600 }, { width: 300, height: 190 }),
    2,
  );
  equal(displayScale({ width: 1920, height: 1080 }, undefined), 1);
  equal(displayScale(undefined, { width: 302, height: 188 }), 1);
  equal(
    displayScale({ width: 1200, height: 1920 }, { width: 302, height: 188 }),
    1.5,
  );
  equal(
    displayScale({ width: 1920, height: 1200 }, { width: 1, height: 1 }),
    1,
  );
});

Deno.test("physical dimensions are sent using ShojiWM's Unix IPC protocol", async () => {
  const root = Deno.makeTempDirSync();
  const path = `${root}/shojiwm-test.sock`;
  const listener = Deno.listen({ transport: "unix", path });
  try {
    const sizes = { "eDP-1": { width: 302, height: 188 } };
    const sent = reportSizes(path, sizes);
    const connection = await listener.accept();
    let message = "";
    try {
      const buffer = new Uint8Array(1024);
      const decoder = new TextDecoder();
      for (;;) {
        const length = await connection.read(buffer);
        if (length === null) break;
        message += decoder.decode(buffer.subarray(0, length));
      }
    } finally {
      connection.close();
    }
    await sent;
    equal(JSON.parse(message), {
      method: "outputs.physicalSizes",
      params: sizes,
    });
  } finally {
    listener.close();
    Deno.removeSync(root, { recursive: true });
  }
});

Deno.test("helper exits after reporting dimensions once", async () => {
  const root = Deno.makeTempDirSync();
  const listener = Deno.listen({
    transport: "unix",
    path: `${root}/shojiwm-test.sock`,
  });
  const child = new Deno.Command("deno", {
    args: [
      "run",
      "--no-config",
      "--no-lock",
      "--allow-all",
      new URL("./output-scale.ts", import.meta.url).pathname,
    ],
    env: { XDG_RUNTIME_DIR: root, WAYLAND_DISPLAY: "test" },
    stdout: "piped",
    stderr: "piped",
  }).spawn();
  const result = child.output();
  const timeout = setTimeout(() => child.kill("SIGKILL"), 5000);
  try {
    const connection = await Promise.race([
      listener.accept(),
      result.then(() => {
        throw new Error("Helper exited before connecting");
      }),
    ]);
    let message = "";
    try {
      const buffer = new Uint8Array(1024);
      const decoder = new TextDecoder();
      for (;;) {
        const length = await connection.read(buffer);
        if (length === null) break;
        message += decoder.decode(buffer.subarray(0, length));
      }
    } finally {
      connection.close();
    }
    equal(JSON.parse(message).method, "outputs.physicalSizes");
    equal((await result).code, 0);
  } finally {
    clearTimeout(timeout);
    try {
      child.kill("SIGKILL");
    } catch { /* Already exited. */ }
    await result;
    listener.close();
    Deno.removeSync(root, { recursive: true });
  }
});

Deno.test("disconnected, missing and ambiguous DRM connectors are ignored", () => {
  const root = Deno.makeTempDirSync();
  try {
    for (
      const [name, status] of [
        ["card0-eDP-1", "connected"],
        ["card0-HDMI-A-1", "disconnected"],
        ["card0-DP-1", "connected"],
        ["card1-DP-1", "connected"],
      ]
    ) {
      const path = `${root}/${name}`;
      Deno.mkdirSync(path);
      Deno.writeTextFileSync(`${path}/status`, status);
      Deno.writeFileSync(`${path}/edid`, edid(302, 188));
    }
    equal(readPhysicalSizes(root), { "eDP-1": { width: 302, height: 188 } });
    equal(readPhysicalSizes(`${root}/missing`), {});
  } finally {
    Deno.removeSync(root, { recursive: true });
  }
});
