--
-- Everyone's tool library
--
local https = require("ssl.https")
local ini = require("inifile")

local tools = {}

function tools.download_extract_zip(url, destination)
    print(url)
    print(destination)
end

function tools.download_file(url, destination)
    local file = ltn12.sink.file(io.open(destination, 'w'))
    https.request {
        url = url,
        sink = file,
    }
end

function tools.read_file(file)
    local f = assert(io.open(file, "rb"))
    local content = f:read("*all")
    f:close()
    return content
end

function tools.all_trim()
    return s:match("^%s*(.-)%s*$")
end

function tools.md5sum(value)
    local command = "echo -n '" .. value .."' | md5sum | cut -f1 -d' ' "
    local handle = io.popen(command)
    local result = handle:read("*a")
    handle:close()
    return tools.all_trim(result)
end

function tools.get_bwapi_ini()
    local bwapi = ini.parse("../include/bwapi-data/bwapi.ini")
    -- BWAPI version 4.2.0 and higher ONLY
    -- FIRST (default), use the first character in the list
    -- WAIT, stop at this screen
    -- else the character with the given value is used/created
    local character_name = "FIRST"
    -- BWAPI version 4.2.0 and higher ONLY
    -- Text that appears in the drop-down list below the Game Type.
    local game_type_extra = ""
    return bwapi
end

return tools
