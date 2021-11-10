require daslib/media

let TILE_SIZE = 50.0
let BORDER_SIZE = 2.0

def DrawSmoothQuadFrame(x, y, w, r: float; color: uint)
    for i in range(2)
        for j in range(2)
            let corner_x = x + w * float(i) + r - 2.0 * r * float(i)
            let corner_y = y + w * float(j) + r - 2.0 * r * float(j)
            fill_circle(corner_x, corner_y, r, color)
    // fill x
    fill_rect(x + r, y, w - 2.0 * r, r, color)
    fill_rect(x + r, y + w - r, w - 2.0 * r, r, color)
    // fill y
    fill_rect(x, y + r , r, w - 2.0 * r, color)
    fill_rect(x + w - r, y + r, r, w - 2.0 * r, color)

def DrawSmoothQuad(x, y, w, r: float; color: uint)
    DrawSmoothQuadFrame(x, y, w, r, color)
    // fill inside
    fill_rect(x + r, y + r, w - 2.0 * r, w - 2.0 * r, color)

def DrawQuadWithBorder(x, y, size, r: float; color: uint; border: float; border_color: uint)
    assert(border < r, "Border should be less then radius")
    DrawSmoothQuadFrame(x, y, size, r, border_color)
    DrawSmoothQuad(x + border, y + border, size - 2.0 * border, r - border, color)

def DrawTile(x, y: float; color: uint)
    DrawQuadWithBorder(x, y, TILE_SIZE, TILE_SIZE / 10.0, color, BORDER_SIZE, 0xFFB9BEB9)

def DrawFrame(x, y: float; color: uint)
    DrawSmoothQuadFrame(x, y, TILE_SIZE, TILE_SIZE / 10.0, color)

def CoordToPos(x, y: auto)
    return float2((TILE_SIZE - BORDER_SIZE) * float(x), (TILE_SIZE - BORDER_SIZE) * float(y));