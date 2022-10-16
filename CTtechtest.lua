-- "CTtechtest.lua"
--
-- todo: description

init_frame = nil
data = ""
dofile("lib/get_version.lua")
dofile("lib/log_helpers.lua")
dofile("lib/enums.lua")
dofile("lib/tech_data_" .. version .. ".lua")

local addr_tech_id = 0x93F4
local addr_enemy_hp = {
    0x5FB0,
    0x6030,
    0x60B0
}
local addr_pc3_hp = 0x5F30
local addr_target_selection = 0x960D

local log_addrs = {
    {name = "script", address = 0x9895, type = "u8"},
    {name = "ptr01", address = 0x5DBD, type = "u24le"},
    {name = "ptr02", address = 0x5DC9, type = "u24le"},
    {name = "ptr03", address = 0x5DCD, type = "u24le"},
    {name = "ptr04", address = 0x5DDD, type = "u24le"},
    {name = "ptr05", address = 0x5DE1, type = "u24le"},
    {name = "ptr06", address = 0x5DE5, type = "u24le"},
    {name = "ptr07", address = 0x5DE9, type = "u24le"},
    {name = "ptr08", address = 0x5DED, type = "u24le"},
    {name = "ptr09", address = 0x5DF1, type = "u24le"},
    {name = "ptr10", address = 0x5DF5, type = "u24le"},
    {name = "ptr11", address = 0x5DF9, type = "u24le"}
}

local frame = 0
local tech_index = 1
local file

tech_id = 0x80

function init()
    tech_id = tech_data[tech_index].id
    init_frame = nil
    data = "Frame,Address,Name,Value\n"
    local filename = "data/" .. hex(tech_id, true) .. ".csv"
    file = io.open(filename, "w")
end

function terminate()
    for i = 1, #log_addrs do
        event.unregisterbyname(log_addrs[i].name)
    end
    console.log("done!")
end

function freeze_hp()
    for i = 1, #addr_enemy_hp do
        mainmemory.write_u16_le(addr_enemy_hp[i], 0x7fff)
    end
end

function display_info()
    local text_height = 14
    local column = 3
    local tech = tech_data[tech_index]
    local users = tech.pc1
    if (tech.pc2 ~= "") then
        users = users .. ", " .. tech.pc2
    end
    if (tech.pc3 ~= "") then
        users = users .. ", " .. tech.pc3
    end
    local type = types[tech.type1]
    if (tech.type2 ~= "") then
        type = type .. ", " .. types[tech.type2]
    end
    if (tech.type3 ~= "") then
        type = type .. ", " .. types[tech.type3]
    end
    local info = {
        "ID: " .. hex(tech_id, true),
        "Name: " .. tech.name,
        "Users: " .. users,
        "Target: " .. targets[tech.target].desc,
        "Types: " .. type,
        "Status: " .. (statuses[tech.status] or "none"),
        "Frames: " .. frame
    }
    for i = 1, #info do
        gui.text(0, (column + i) * text_height, info[i])
    end
end

function attack()
    local start_frame = 0
    if tech_data[tech_index].status == "LIFE" then
        start_frame = 3
        if frame == 0 then
            memory.write_s16_le(addr_pc3_hp, 0)
        end
    end
    if frame == start_frame then
        memory.writebyte(addr_target_selection, targets[tech_data[tech_index].target].val)
        joypad.set({A=1}, 1)
    elseif frame < start_frame + 5 then
        mainmemory.writebyte(addr_tech_id, tech_id)
    end
    frame = frame + 1
end

function write_log()
    file:write(data)
    file:close()
end

function new_tech()
    write_log()
    frame = 0
    local pc1
    while true do
        tech_index = tech_index + 1
        if tech_index > #tech_data then
            return
        end
        pc1 = tech_data[tech_index].pc1
        if pc1 ~= "" then
            break
        end
    end
    local pc2 = tech_data[tech_index].pc2
    local pc3 = tech_data[tech_index].pc3
    savestate.load("techs/" .. pc1 .. pc2 .. pc3 .. ".State")
end

savestate.load("techs/Crono.State")
init()

for i = 1, #log_addrs do
    create_event(log_addrs[i], i, true)
end

while true do
    display_info()
    -- freeze_hp()
    attack()
    if frame > 5 and mainmemory.readbyte(addr_tech_id) == 0 then
        new_tech()
        if tech_index > #tech_data then
            terminate()
            break
        end
        init()
    end
    emu.frameadvance()
end
