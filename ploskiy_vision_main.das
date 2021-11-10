require daslib/media
options debugger            // uncomment for debug in VS Code
require daslib/debug        // uncomment for debug in VS Code

def draw_smooth_quad_frame(x: int; y: int; w: int; r: int; color: uint)
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

def draw_smooth_quad(x: int; y: int; w: int; r: int; color: uint)
    draw_smooth_quad_frame(x, y, w, r, color)
    // fill inside
    fill_rect(x + r, y + r, w - 2 * r, w - 2 * r, color)

def draw_quad_with_border(x: int; y: int; size: int; r: int; color: uint; border: int; border_color: uint)
    assert(border < r, "Border should be less then radius")
    draw_smooth_quad_frame(x, y, size, r, border_color)
    draw_smooth_quad(x + border, y + border, size - 2 * border, r - border, color)

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
    draw_smooth_quad(10, 10, 100, 10, 0xff7845ff)
    draw_quad_with_border(400, 400, 100, 10, 0xff7845ff, 4, 0x2389ff90)
    return
