require strings
require drawing

let levels_src: array<array<string>> <- [{auto

[{auto
    "OOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOO";
    "O                        O                O";
    "O                        O                O";
    "O                                         O";
    "O                X              ~         O";
    "O                X            OOOOOOO     O";
    "O                X                        O";
    "O      ~  @                       O       O";
    "O     OOOOOO                      O       O";
    "O                                 O       O";
    "O                                 O       O";
    "O                                 O       O";
    "O                                 O       O";
    "O                                         O";
    "OOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOO"
}]
}];

let EMPTY = 0u
let WALL = 1u
let LAVA = 2u
let START = 3u
let EXIT = 4u
let UNEXPECTED = 255u

var current_level : array<array<uint>>
var start_pos : int2

def ResolveCellChar(cell_char: int)
    let cell_type_map : table<int; uint> <- {{' ' => EMPTY; 'O' => WALL; 'X' => LAVA; '@' => START; '~' => EXIT}}
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

    let y = find_index_if(levels_src[level]) <| $(row) { return find(row, '@') >= 0; }
    let x = find(levels_src[level][y], '@')
    start_pos = int2(x, y)

def DrawLevel()
    let level_dim <- int2(length(current_level), length(current_level[0]))
    for row, y in current_level, range(level_dim[0])
        for cell, x in row, range(level_dim[1])
            if (cell == WALL)
                DrawTile(x, y, 0xFF718B8F)
            elif (cell == LAVA)
                DrawTile(x, y, 0xFFCF1A09)
            elif (cell == EXIT)
                DrawFrame(x, y, 0xFF672DEE)

// def CheckCollision(x, y: float)
//     let int_x = int(x)
//     let int_y = int(y)
//     let tile = 

// def CheckCollision(tile: float2)

