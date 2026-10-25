interface PhysicalSize {
  width: number;
  height: number;
}

export function edidPhysicalSize(edid: Uint8Array): PhysicalSize | undefined {
  const header = [0, 255, 255, 255, 255, 255, 255, 0];
  if (
    edid.length < 128 || header.some((value, index) => edid[index] !== value)
  ) {
    return undefined;
  }
  if (
    edid.subarray(0, 128).reduce((sum, value) => sum + value, 0) % 256 !== 0
  ) {
    return undefined;
  }

  // Detailed timings have millimetre precision; the base size is in cm.
  for (let offset = 54; offset < 126; offset += 18) {
    if (edid[offset] === 0 && edid[offset + 1] === 0) continue;
    const width = edid[offset + 12] | ((edid[offset + 14] & 0xf0) << 4);
    const height = edid[offset + 13] | ((edid[offset + 14] & 0x0f) << 8);
    if (width > 0 && height > 0) return { width, height };
  }
  if (edid[21] > 0 && edid[22] > 0) {
    return { width: edid[21] * 10, height: edid[22] * 10 };
  }
  return undefined;
}

export function readPhysicalSizes(
  root = "/sys/class/drm",
): Record<string, PhysicalSize> {
  const sizes: Record<string, PhysicalSize> = {};
  const seen = new Set<string>();
  try {
    const entries = Array.from(Deno.readDirSync(root)).sort((a, b) =>
      a.name.localeCompare(b.name)
    );
    for (const entry of entries) {
      const name = /^card\d+-(.+)$/.exec(entry.name)?.[1];
      if (!name) continue;
      try {
        const path = `${root}/${entry.name}`;
        if (Deno.readTextFileSync(`${path}/status`).trim() !== "connected") {
          continue;
        }
        // Connector names may be duplicated across GPUs. Do not guess which
        // physical panel corresponds to an ambiguous compositor output name.
        if (seen.has(name)) {
          delete sizes[name];
          continue;
        }
        seen.add(name);
        const size = edidPhysicalSize(Deno.readFileSync(`${path}/edid`));
        if (size) sizes[name] = size;
      } catch {
        // A connector may disappear during a hotplug, or expose no EDID.
      }
    }
  } catch {
    // Nested/virtual backends may have no accessible DRM connectors.
  }
  return sizes;
}

export async function reportSizes(
  path: string,
  sizes: Record<string, PhysicalSize>,
): Promise<void> {
  const message = new TextEncoder().encode(
    JSON.stringify({
      method: "outputs.physicalSizes",
      params: sizes,
    }) + "\n",
  );
  const connection = await Deno.connect({ transport: "unix", path });
  try {
    let offset = 0;
    while (offset < message.length) {
      offset += await connection.write(message.subarray(offset));
    }
  } finally {
    connection.close();
  }
}

if (import.meta.main) {
  if (Deno.args.includes("--print")) {
    console.log(JSON.stringify(readPhysicalSizes(), null, 2));
  } else {
    const runtimeDir = Deno.env.get("XDG_RUNTIME_DIR") ?? "/tmp";
    const display = Deno.env.get("WAYLAND_DISPLAY") ?? "wayland-0";
    const path = `${runtimeDir}/shojiwm-${display}.sock`;
    await reportSizes(path, readPhysicalSizes());
  }
}
