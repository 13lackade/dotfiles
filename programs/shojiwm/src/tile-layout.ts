export interface TileRect {
  x: number;
  y: number;
  width: number;
  height: number;
}

/** Keep every tile inside the viewport, splitting the last slot for new tiles. */
export function layoutTiles(
  viewport: TileRect,
  count: number,
  gap: number,
): TileRect[] {
  if (count === 0) {
    return [];
  }

  const rects = [{ ...viewport }];
  while (rects.length < count) {
    const rect = rects.pop()!;
    // The first pair is always side by side, including on portrait outputs.
    const horizontal = rects.length === 0 || rect.width >= rect.height;
    const extent = horizontal ? rect.width : rect.height;
    const spacing = Math.min(gap, extent / 3);
    const size = (extent - spacing) / 2;
    rects.push(
      horizontal
        ? { ...rect, width: size }
        : { ...rect, height: size },
      horizontal
        ? { ...rect, x: rect.x + size + spacing, width: size }
        : { ...rect, y: rect.y + size + spacing, height: size },
    );
  }
  return rects;
}

/** Resolve the nearest slot in both axes, including the gaps between tiles. */
export function tileIndexAtPoint(
  rects: readonly TileRect[],
  x: number,
  y: number,
): number {
  let nearestIndex = 0;
  let nearestDistance = Number.POSITIVE_INFINITY;
  rects.forEach((rect, index) => {
    const dx = Math.max(rect.x - x, 0, x - (rect.x + rect.width));
    const dy = Math.max(rect.y - y, 0, y - (rect.y + rect.height));
    const distance = dx * dx + dy * dy;
    if (distance < nearestDistance) {
      nearestDistance = distance;
      nearestIndex = index;
    }
  });
  return nearestIndex;
}
