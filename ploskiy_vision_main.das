require daslib/media
require levels
require drawing
options debugger            // uncomment for debug in VS Code
require daslib/debug        // uncomment for debug in VS Code

var level : array<array<uint>>
var player : float2

let PLAYER_SPEED = 4.0

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
    if get_key(VK_LEFT)
        player[0] -= PLAYER_SPEED * dt
    if get_key(VK_RIGHT)
        player[0] += PLAYER_SPEED * dt
    if get_key(VK_UP)
        player[1] -= PLAYER_SPEED * dt
    if get_key(VK_DOWN)
        player[1] += PLAYER_SPEED * dt

// this function will be called every frame after 'act',
// you can draw anything in this function
[export]
def draw
    DrawLevel(level)
    DrawPlayer()
    return
