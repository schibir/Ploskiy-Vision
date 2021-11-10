require daslib/media
options debugger            // uncomment for debug in VS Code
require daslib/debug        // uncomment for debug in VS Code
require levels

let TILE_SIZE = 50
let BORDER_SIZE = 2

def DrawSmoothQuadFrame(x: int; y: int; w: int; r: int; color: uint)
    for i in range(2)
        for j in range(2)
            let corner_x = x + w * i + r - 2 * r * i
            let corner_y = y + w * j + r - 2 * r * j
            fill_circle(corner_x, corner_y, r, color)
    // fill x
    fill_rect(x + r, y, w - 2 * r, r, color)
    fill_rect(x + r, y + w - r, w - 2 * r, r, color)
    // fill y
    fill_rect(x, y + r , r, w - 2 * r, color)
    fill_rect(x + w - r, y + r, r, w - 2 * r, color)

def DrawSmoothQuad(x: int; y: int; w: int; r: int; color: uint)
    DrawSmoothQuadFrame(x, y, w, r, color)
    // fill inside
    fill_rect(x + r, y + r, w - 2 * r, w - 2 * r, color)

def DrawQuadWithBorder(x: int; y: int; size: int; r: int; color: uint; border: int; border_color: uint)
    assert(border < r, "Border should be less then radius")
    DrawSmoothQuadFrame(x, y, size, r, border_color)
    DrawSmoothQuad(x + border, y + border, size - 2 * border, r - border, color)

def DrawTile(x: int; y: int; color: uint)
    DrawQuadWithBorder(x, y, TILE_SIZE, TILE_SIZE / 10, color, BORDER_SIZE, 0xff89ff90)

// 'initialize' runs once when game starts and every hot-reload
[export]
def initialize
    set_window_title("Ploskiy Vision")
    return

// this function is called to update game data,
// dt - time elapsed since the previous update (in seconds)
[export]
def act(dt: float)
    if get_key(VK_ESCAPE)
        schedule_quit_game()

// this function will be called every frame after 'act',
// you can draw anything in this function
[export]
def draw
    DrawTile(400, 400, 0xff7845ff)
    DrawTile(400 + TILE_SIZE - BORDER_SIZE, 400, 0xff7845ff)
    return
