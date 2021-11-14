require strings
require drawing

let levels_src: array<array<string>> <- [{auto

[{auto
    "OOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOO";
    "O                        O                O";
    "O                        O                O";
    "O                                         O";
    "O                X                        O";
    "O        .       X            OOOOOOO     O";
    "O        O       X                        O";
    "O      ~ O@                       O       O";
    "O     OOOOOO                      O       O";
    "O        .                        O       O";
    "O                                 O       O";
    "O                                 O       O";
    "O                                 O       O";
    "O                                         O";
    "OOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOO"
}]
}];

let EMPTY = 0u
let START = 1u
let WALL = 2u
let LAVA = 4u
let ITEM = 8u
let EXIT = 16u
let UNEXPECTED = 255u

var current_level : array<array<uint>>
var start_pos : int2
var count_items : int

def ResolveCellChar(cell_char: int)
    let cell_type_map : table<int; uint> <- {{
        ' ' => EMPTY;
        'O' => WALL;
        'X' => LAVA;
        '@' => START;
        '.' => ITEM;
        '~' => EXIT
    }}
    let val = find(cell_type_map, cell_char) ?? UNEXPECTED
    if val == UNEXPECTED
        panic(format("Unexpected char '%c' in level source", cell_char))
    return val

def LoadLevel(level: int)
    var level_arr <- [{for row in levels_src[level];
        [{for cell in row;
            ResolveCellChar(cell)
        }]
    }]
    current_level <- level_arr

    count_items = 0
    for row in levels_src[level]
        for cell in row
            if ResolveCellChar(cell) == ITEM
                count_items++

    let y = find_index_if(levels_src[level]) <| $(row) { return find(row, '@') >= 0; }
    let x = find(levels_src[level][y], '@')
    start_pos = int2(x, y)

def DrawLevel(open_exit: bool)
    let level_dim <- int2(length(current_level), length(current_level[0]))
    for row, y in current_level, range(level_dim[0])
        for cell, x in row, range(level_dim[1])
            if cell == WALL
                DrawTile(x, y, 0xFF718B8F)
            elif cell == LAVA
                DrawTile(x, y, 0xFFFF6551)
            elif cell == EXIT
                if open_exit
                    DrawFrame(x, y, 0xFF672DEE)
                else
                    DrawTile(x, y, 0xFF672DEE)
            elif cell == ITEM
                DrawCircle(float(x) + 0.5, float(y) + 0.5, 0.2, 0xFFDEDBE6)

def GetTile(x, y: float)
    let int_x = int(x)
    let int_y = int(y)
    if (int_y < 0 || int_y >= current_level |> length())
        return EMPTY
    if (int_x < 0 || int_x >= current_level[0] |> length())
        return EMPTY
    let tile = current_level[int_y][int_x]
    return tile

def CheckCollision(coord: float2)
    var tile : uint
    tile |= GetTile(coord[0] + 0.01, coord[1] + 0.01)
    tile |= GetTile(coord[0] + 0.99, coord[1] + 0.01)
    tile |= GetTile(coord[0] + 0.01, coord[1] + 0.99)
    tile |= GetTile(coord[0] + 0.99, coord[1] + 0.99)
    return tile

def SetTile(x, y: float; tile: uint)
    let int_x = int(x)
    let int_y = int(y)
    if (int_y < 0 || int_y >= current_level |> length())
        return
    if (int_x < 0 || int_x >= current_level[0] |> length())
        return
    current_level[int_y][int_x] = tile

def ClearTile(coord: float2)
    SetTile(coord[0] + 0.01, coord[1] + 0.01, EMPTY)
    SetTile(coord[0] + 0.99, coord[1] + 0.01, EMPTY)
    SetTile(coord[0] + 0.01, coord[1] + 0.99, EMPTY)
    SetTile(coord[0] + 0.99, coord[1] + 0.99, EMPTY)