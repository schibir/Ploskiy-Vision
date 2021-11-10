require daslib/media
require levels
require drawing
options debugger            // uncomment for debug in VS Code
require daslib/debug        // uncomment for debug in VS Code

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
