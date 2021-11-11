require daslib/media
require level
require drawing
options debugger            // uncomment for debug in VS Code
require daslib/debug        // uncomment for debug in VS Code

var player : float2
var player_vertical_vel : float
var jump_timer : float
var last_move_to_left : bool
var rotate_vel : float

let PLAYER_SPEED = 4.0
let PLAYER_JUMP = 7.7
let JUMP_TIMER = 0.25
let GRAVITY = 6.0

def ResetLevel()
    LoadLevel(0)
    player = float2(start_pos)
    player_vertical_vel = 0.0
    jump_timer = 0.0
    last_move_to_left = false
    rotate_vel = 0.0
    transform2d_reset()

def DrawPlayer()
    DrawTile(player[0], player[1], 0xFF869409)
    let dx = last_move_to_left ? -0.15 : 0.15
    let dy = player_vertical_vel * 0.02
    DrawCircle(player[0] + 1.0 / 3.0 + dx, player[1] + 1.0 / 3.0 + dy, 1.0 / 10.0, 0xffffffff)
    DrawCircle(player[0] + 2.0 / 3.0 + dx, player[1] + 1.0 / 3.0 + dy, 1.0 / 10.0, 0xffffffff)

// 'initialize' runs once when game starts and every hot-reload
[export]
def initialize
    set_window_title("Ploskiy Vision")
    ResetLevel()

// this function is called to update game data,
// dt - time elapsed since the previous update (in seconds)
[export]
def act(dt: float)
    if get_key(VK_ESCAPE)
        schedule_quit_game()
    if get_key(VK_R)
        ResetLevel()

    if (abs(rotate_vel) > 0.5)
        transform2d_translate(ToScreenSpace(player[0] + 0.5), ToScreenSpace(player[1] + 0.5))
        transform2d_rotate(rotate_vel * dt)
        transform2d_translate(-ToScreenSpace(player[0] + 0.5), -ToScreenSpace(player[1] + 0.5))

    var horizontal_vel : float
    if get_key(VK_LEFT)
        horizontal_vel = -PLAYER_SPEED
        last_move_to_left = true
    if get_key(VK_RIGHT)
        horizontal_vel = PLAYER_SPEED
        last_move_to_left = false
    if get_key_down(VK_UP) && jump_timer > 0.0
        player_vertical_vel = -PLAYER_JUMP
    if get_key_down(VK_W)
        rotate_vel = 1.0

    player_vertical_vel += GRAVITY * dt
    player_vertical_vel = min(player_vertical_vel, PLAYER_JUMP)

    jump_timer -= dt
    player[1] += player_vertical_vel * dt;
    if ((CheckCollision(player) & WALL) == WALL)
        player[1] -= player_vertical_vel * dt
        if (player_vertical_vel > 0.0)
            jump_timer = JUMP_TIMER
        player_vertical_vel = 0.0

    player[0] += horizontal_vel * dt;
    if ((CheckCollision(player) & WALL) == WALL)
        player[0] -= horizontal_vel * dt

// this function will be called every frame after 'act',
// you can draw anything in this function
[export]
def draw
    DrawLevel()
    DrawPlayer()
    return
