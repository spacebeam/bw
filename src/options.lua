-- add work on bwapi.ini
local ini = require("inifile")

-- BWAPI and TorchCraft use .ini files
bwapi = ini.parse("../include/bwapi-data/bwapi.ini")

local options = {}

function options.get_conf(dir)
    -- 
    --
    --
    local conf = {}
    conf.bwapi = {}
    conf.bots = dir .. '/bots/'
    conf.games = dir .. '/games/'
    conf.maps = dir .. '/maps/'
    conf.errors = dir .. '/Errors/'
    conf.bwapi.data = dir .. '/bwapi-data/' 
    conf.bwapi.save = conf.bwapi.data .. 'save'
    conf.bwapi.read = conf.bwapi.data .. 'read'
    conf.bwapi.write = conf.bwapi.data .. 'write'
    conf.bwapi.ai = conf.bwapi.data .. 'AI'
    conf.bwapi.logs = conf.bwapi.data .. 'logs'
    return conf
end
-- BWAPI version 4.2.0 and higher ONLY
-- FIRST (default), use the first character in the list
-- WAIT, stop at this screen
-- else the character with the given value is used/created
local character_name = "FIRST"
-- BWAPI version 4.2.0 and higher ONLY
-- Text that appears in the drop-down list below the Game Type.
local game_type_extra = ""

print(bwapi)

return options
