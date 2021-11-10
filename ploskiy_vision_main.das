require daslib/media
require levels
require drawing
options debugger            // uncomment for debug in VS Code
require daslib/debug        // uncomment for debug in VS Code

var level : array<array<uint>>
var player : float2

def DrawPlayer()
    DrawTile(player[0], player[1], 0xFF869409)
    DrawCircle(player[0] + 1.0 / 3.0, player[1] + 1.0 / 3.0, 1.0 / 10.0, 0xffffffff)
    DrawCircle(player[0] + 2.0 / 3.0, player[1] + 1.0 / 3.0, 1.0 / 10.0, 0xffffffff)

// 'initialize' runs once when game starts and every hot-reload
[export]
def initialize
    set_window_title("Ploskiy Vision")
    level <- LoadLevel(0)
    player = float2(ParsePlayerPos(0))
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
    DrawLevel(level)
    DrawPlayer()
    return
