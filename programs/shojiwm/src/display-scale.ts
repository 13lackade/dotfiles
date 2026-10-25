export interface PhysicalSize {
  width: number;
  height: number;
}

export function displayScale(
  resolution: { width: number; height: number } | undefined,
  size: PhysicalSize | undefined,
): number {
  if (!resolution || !size || size.width <= 0 || size.height <= 0) {
    return 1;
  }

  // Diagonal DPI is unaffected by screen rotation. Aim for roughly 110
  // logical DPI, in half steps, without shrinking ordinary desktop displays.
  const dpi = 25.4 * Math.hypot(resolution.width, resolution.height) /
    Math.hypot(size.width, size.height);
  if (!Number.isFinite(dpi) || dpi < 50 || dpi > 600) {
    return 1;
  }
  return Math.max(1, Math.round(dpi / 110 * 2) / 2);
}
