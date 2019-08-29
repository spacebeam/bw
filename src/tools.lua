--
-- Everyone's tool library
--
local http = require("socket.http")
local https = require("ssl.https")
local lfs = require("lfs")
local ini = require("inifile")

local tools = {}

-- (=

function tools.update_registry()
    --
    -- Playing with regedit!
    --
    os.execute("bash /opt/bw/include/wine_registry.sh")
end

function tools.prepare_bwapi(bwapi, bot, map, conf, config)
    --
    -- Preparing bwapi.ini
    --
    print('Feel the vibration of tectonic motion')

    bwapi["ai"]["ai"] = "bwapi-data\\AI\\" .. bot['name'] .. ".dll"
    bwapi["ai"]["tournament"] = conf["tournament"]["module"]
    bwapi["auto_menu"]["race"] = bot["race"]
    bwapi["auto_menu"]["wait_for_min_players"] = 2
    bwapi["starcraft"]["speed_override"] = conf["tournament"]["local_speed"]
    bwapi["auto_menu"]["game"] = bot["name"]
    bwapi["auto_menu"]["map"] = map
    -- 
    print(config)

end

function tools.prepare_tm(bot)
    --
    -- Preparing tm.dll
    --
    print('binary stream')
    print(bot)
    -- cp ${TM_DIR}/${BOT_BWAPI}.dll $SC_DIR/tm.dll

end

function tools.start_bot()
    --
    -- Launch the bot!
    --
end

function tools.start_game()
    --
    -- Launch the game!
    --
end

function tools.run_proxy_script()
    --
    -- Bot might use an server/client infrastructure, so connect it after the game has started
    --
end

function tools.detect_game_finished()
    -- 
    -- Checking game status...
    --
end

function tools.clean_starcraft() 
    --
    -- Delete the old game state file
    --
end

function tools.kill_starcraft()
    --
    -- Killing StarCraft...
    --
end

-- O=

-- beginning maps
function tools.download_sscait_maps()
    -- 0
end

function tools.download_btwa_caches()
    -- 1
end

function tools.check_maps_exist()
    -- 2
end
-- end of maps

function tools.check_status_code(host, port)
    local url = "http://" .. host .. ":" .. port .. "/status/"
    local res, code, res_headers = http.request{
        url = url,
        method = "GET",
        headers = {
            ["Content-Type"] = "application/json"
        },
    }
    if code == 'connection refused' then
        print(code)
    else
        print(code .. ' connection established')
    end
    return code
end

function tools.download_file(url, destination)
    local file = ltn12.sink.file(io.open(destination, 'w'))
    https.request {
        url = url,
        sink = file,
    }
end

function tools.download_extract_zip(url, destination)
    lfs.mkdir(destination)    
    lfs.chdir(destination)
    tools.download_file(url, './bot.zip')
    os.execute("unzip bot.zip && rm bot.zip")
end

function tools.read_file(file)
    local f = assert(io.open(file, "rb"))
    local content = f:read("*all")
    f:close()
    return content
end

function tools.all_trim(s)
    return s:match("^%s*(.-)%s*$")
end

function tools.md5value(value)
    local command = "echo -n '" .. value .."' | md5sum | cut -f1 -d' ' "
    local handle = io.popen(command)
    local result = handle:read("*a")
    handle:close()
    return tools.all_trim(result)
end

function tools.md5file(file)
    local command = "md5sum " .. file .. " | cut -f1 -d' '"
    local handle = io.popen(command)
    local result = handle:read("*a")
    handle:close()
    return tools.all_trim(result)
end

function tools.get_bwapi_ini()
    local bwapi = ini.parse("/opt/bw/include/bwapi-data/bwapi.ini")
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
