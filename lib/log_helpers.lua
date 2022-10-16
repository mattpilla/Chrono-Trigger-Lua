-- "log_helpers.lua"

memory.usememorydomain("WRAM")
local bank = 0x7E0000

function hex(num, prepend)
    local str = ""
    if prepend then
        str = "0x"
    end
    return string.format(str .. "%x", num)
end

function read_mem(type)
    local fun_list = {
        s8 = memory.read_s8,
        u8 = memory.read_u8,
        s16be = memory.read_s16_be,
        u16be = memory.read_u16_be,
        s16le = memory.read_s16_le,
        u16le = memory.read_u16_le,
        s24be = memory.read_s24_be,
        u24be = memory.read_u24_be,
        s24le = memory.read_s24_le,
        u24le = memory.read_u24_le,
        s32be = memory.read_s32_be,
        u32be = memory.read_u32_be,
        s32le = memory.read_s32_le,
        u32le = memory.read_u32_le,
        f = memory.readfloat
    }
    return fun_list[type]
end

function create_event(addr, index, prepend)
    event.onmemorywrite(
        function ()
            if init_frame == nil then
                init_frame = emu.framecount()
            end
            local str_addr = hex(bank + addr.address, prepend)
            local str_value = hex(read_mem(addr.type)(addr.address), prepend)
            local frame = emu.framecount() - init_frame
            data = data .. frame .. "," .. str_addr .. "," .. addr.name .. "," .. str_value .. "\n"
        end,
        bank + addr.address,
        addr.name
    )
end
