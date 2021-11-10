require strings
require drawing

let levels_src: array<array<string>> <- [{auto

[{auto
    "OOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOO";
    "O                                         O";
    "O                                         O";
    "O                X              ~         O";
    "O                X            OOOOOOO     O";
    "O                X                        O";
    "O                                 O       O";
    "O     OOOOOO                      O       O";
    "O                                 O       O";
    "O                                 O       O";
    "O                @                        O";
    "OOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOO"
}]

}];

let EMPTY = 0u
let WALL = 1u
let LAVA = 2u
let START = 3u
let EXIT = 4u
let UNEXPECTED = 255u

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
    return <- level_arr

def LevelDim(level)
    return <- int2(length(level), length(level[0]))

def DrawLevel(level)
    let level_dim <- LevelDim(level)
    for row, y in level, range(level_dim[0])
        for cell, x in row, range(level_dim[1])
            let pos : int2 = int2((TILE_SIZE - BORDER_SIZE) * x, (TILE_SIZE - BORDER_SIZE) * y);
            if (cell == WALL)
                DrawTile(pos[0], pos[1], 0xff7845ff)
