require daslib/media
require level
require drawing
options debugger            // uncomment for debug in VS Code
require daslib/debug        // uncomment for debug in VS Code

var level_no : int
var player_pos : float2
var player_vertical_vel : float
var jump_timer : float
var last_move_to_left : bool
var rotate_dir : int
var pivot : float2
var current_angle : int
var target_angle : int
var prev_angle : int
var level_diff : float2
var items_left : int

let PLAYER_SPEED = 4.0
let PLAYER_JUMP = 7.7
let JUMP_TIMER = 0.25
let GRAVITY = 6.0
let RIGHT_ANGLE : int = 10000
let ROTAION_SPEED = 1.7

def ResetLevel()
    LoadLevel(level_no)
    player_pos = float2(start_pos)
    player_vertical_vel = 0.0
    jump_timer = 0.0
    last_move_to_left = false
    rotate_dir = 0
    pivot = float2(0.0, 0.0)
    current_angle = 0
    target_angle = 0
    prev_angle = 0
    level_diff = float2(0.0, 0.0)
    items_left = count_items
    transform2d_reset()

def Transform()
    transform2d_reset()
    transform2d_translate(level_diff)
    transform2d_translate(pivot)
    transform2d_rotate(AngleToRad(current_angle))
    transform2d_translate(-pivot)

def DrawPlayer()
    DrawTile(player_pos[0], player_pos[1], 0xFF869409)
    let dx = last_move_to_left ? -0.15 : 0.15
    let dy = player_vertical_vel * 0.02
    DrawCircle(player_pos[0] + 1.0 / 3.0 + dx, player_pos[1] + 1.0 / 3.0 + dy, 1.0 / 10.0, 0xffffffff)
    DrawCircle(player_pos[0] + 2.0 / 3.0 + dx, player_pos[1] + 1.0 / 3.0 + dy, 1.0 / 10.0, 0xffffffff)

def IsRotating()
    return rotate_dir != 0

def StartRotating(dir: int)
    assert(dir == 1 || dir == -1)
    if !IsRotating()
        target_angle = prev_angle + RIGHT_ANGLE * dir
        let screen_coord = world_to_screen(ToScreenSpace(player_pos[0] + 0.5), ToScreenSpace(player_pos[1] + 0.5))
        transform2d_reset()
        pivot = world_to_screen(ToScreenSpace(player_pos[0] + 0.5), ToScreenSpace(player_pos[1] + 0.5))
        level_diff = screen_coord - pivot
    elif rotate_dir != dir
        swap(target_angle, prev_angle)

    rotate_dir = dir

def CheckForStopRotating()
    if (abs(current_angle - prev_angle) > RIGHT_ANGLE)
        rotate_dir = 0
        current_angle = (target_angle + 4 * RIGHT_ANGLE) % (4 * RIGHT_ANGLE)
        prev_angle = current_angle

def RadToAngle(rad: float) : int
    return int(2.0 * rad * float(RIGHT_ANGLE) / PI)

def AngleToRad(angle: int): float
    return PI * float(angle) / (2.0 * float(RIGHT_ANGLE))

def PerformRotating(dt: float)
    current_angle += rotate_dir * RadToAngle(dt * ROTAION_SPEED)
    CheckForStopRotating()

def GameOver()
    ResetLevel()

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
    if get_key_down(VK_R)
        ResetLevel()

    if get_key(VK_D)
        StartRotating(1)
    if get_key(VK_A)
        StartRotating(-1)

    if IsRotating()
        PerformRotating(dt)
        return

    assert(items_left >= 0)
    assert(current_angle % RIGHT_ANGLE == 0)
    assert(current_angle >= 0)
    prev_angle = current_angle

    var horizontal_vel : float
    if get_key(VK_LEFT)
        horizontal_vel = -PLAYER_SPEED
        last_move_to_left = true
    if get_key(VK_RIGHT)
        horizontal_vel = PLAYER_SPEED
        last_move_to_left = false
    if get_key_down(VK_UP) && jump_timer > 0.0
        player_vertical_vel = -PLAYER_JUMP
    if get_key(VK_DOWN)
        player_vertical_vel = PLAYER_JUMP

    player_vertical_vel += GRAVITY * dt
    player_vertical_vel = min(player_vertical_vel, PLAYER_JUMP)

    var x_ind = 0
    var y_ind = 1
    var x_dir = 1.0
    var y_dir = 1.0

    if (current_angle / RIGHT_ANGLE == 1)
        swap(x_ind, y_ind)
        x_dir = -1.0
    elif (current_angle / RIGHT_ANGLE == 2)
        x_dir = -1.0
        y_dir = -1.0
    elif (current_angle / RIGHT_ANGLE == 3)
        swap(x_ind, y_ind)
        y_dir = -1.0

    jump_timer -= dt
    player_pos[y_ind] += player_vertical_vel * dt * y_dir
    if (CheckCollision(player_pos) & WALL) == WALL
        player_pos[y_ind] -= player_vertical_vel * dt * y_dir
        if (player_vertical_vel > 0.0)
            jump_timer = JUMP_TIMER
        player_vertical_vel = 0.0

    player_pos[x_ind] += horizontal_vel * dt * x_dir
    if (CheckCollision(player_pos) & WALL) == WALL
        player_pos[x_ind] -= horizontal_vel * dt * x_dir

    let tile = CheckCollision(player_pos)
    if (tile & ITEM) == ITEM
        items_left--
        ClearTile(player_pos)
    elif (tile & LAVA) == LAVA
        GameOver()
    elif (tile & EXIT) == EXIT && items_left == 0
        level_no++
        ResetLevel()

    let screen_coord = world_to_screen(ToScreenSpace(player_pos[0] + 0.5), ToScreenSpace(player_pos[1] + 0.5))
    if screen_coord[0] < 0.0 || screen_coord[0] > float(get_screen_width())
        GameOver()
    if screen_coord[1] < 0.0 || screen_coord[1] > float(get_screen_height())
        GameOver()

// this function will be called every frame after 'act',
// you can draw anything in this function
[export]
def draw
    Transform()
    DrawLevel(items_left == 0)
    DrawPlayer()

    transform2d_push()
    transform2d_reset()
    text_out(10, 10, "{count_items - items_left} / {count_items} items taken", 0xFFFFFFFF)
    transform2d_pop()
