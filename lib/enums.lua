pcs = {
    [0] = "Crono",
    [1] = "Marle",
    [2] = "Lucca",
    [3] = "Robo",
    [4] = "Frog",
    [5] = "Ayla",
    [6] = "Magus",
    [0xff] = ""
}

statuses = {
    CONFUSE = "confusion",
    DEF = "defense up",
    HEAL = "heal",
    OHKO = "instant ko",
    LIFE = "revive",
    SLEEP = "sleep",
    SPEED = "speed",
    STEAL = "steal item",
    STOP = "stop"
}

types = {
    PHYS = "physical",
    LIGHT = "light",
    WATER = "water",
    FIRE = "fire",
    SHAD = "shadow",
    STAT = "status"
}

targets = {
    ONE_ENEMY = {val = 0x7, desc = "single enemy"},
    LINE_ENEMY = {val = 0xb, desc = "enemies in a line"},
    RAD_ENEMY = {val = 0x12, desc = "enemies in a radius"},
    ALL_ENEMY = {val = 0x8, desc = "all enemies"},
    ONE_ALLY = {val = 0x80, desc = "single ally"},
    ALL_ALLY = {val = 0x81, desc = "all allies"},
    DOWN_ALLY = {val = 0x3, desc = "downed ally"}
}
