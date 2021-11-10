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

def ToScreenSpace(v: auto)
    return float((TILE_SIZE - BORDER_SIZE) * float(v))

def PosToCoord(x, y: auto)
    return float2(ToScreenSpace(x), ToScreenSpace(y));

def DrawTile(x, y: auto; color: uint)
    let coord = PosToCoord(x, y)
    DrawQuadWithBorder(coord[0], coord[1], TILE_SIZE, TILE_SIZE / 10.0, color, BORDER_SIZE, 0xFFB9BEB9)

def DrawFrame(x, y: auto; color: uint)
    let coord = PosToCoord(x, y)
    DrawSmoothQuadFrame(coord[0], coord[1], TILE_SIZE, TILE_SIZE / 10.0, color)

def DrawCircle(x, y, r: float; color: uint)
    let coord = PosToCoord(x, y)
    fill_circle(coord[0], coord[1], ToScreenSpace(r), color)