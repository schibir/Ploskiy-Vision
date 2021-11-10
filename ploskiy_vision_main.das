require daslib/media
require levels
require drawing
options debugger            // uncomment for debug in VS Code
require daslib/debug        // uncomment for debug in VS Code

var level : array<array<uint>>
var player : float2

def DrawPlayer()
    let pos : float2 = CoordToPos(player[0], player[1]);
    DrawTile(pos[0], pos[1], 0xFFABAD0F)

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
