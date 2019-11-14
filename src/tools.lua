-- very self-explanatory
local http = require("socket.http")
local https = require("ssl.https")
local lfs = require("lfs")
local ini = require("inifile")

local tools = {}

function tools.update_registry()
    --
    -- Playing with regedit!
    --
    os.execute("bash /opt/bw/include/wine_registry.sh")
end

function tools.prepare_ai(bot, session)
    --
    -- Preparing to fight
    --
    local name = bot["name"]:gsub("% ", "+")
    os.execute("cp " .. "/opt/bw/include/bwapi-data/"
        .. bot["bwapi"] .. ".dll " 
        .. session["bwapi"]["data"] .. "BWAPI.dll")
    os.execute("cp -r " .. session["bots"] .. name .. "/AI/* " .. session["bwapi"]["ai"])
    if bot["name"] == "Hao+Pan" then
        os.execute("mv " .. session["bwapi"]["ai"] .. "/Halo.dll " .. session["bwapi"]["ai"] .. "/" ..  bot["name"] .. ".dll")
    elseif bot["name"] == "Marian+Devecka" then
        os.execute("mv " .. session["bwapi"]["ai"] .. "/KillerBot.dll " .. session["bwapi"]["ai"] .. "/" ..  bot["name"] .. ".dll")
    elseif bot["name"] == "Chris+Coxe" then
        os.execute("mv " .. session["bwapi"]["ai"] .. "/ZZZKBot.dll " .. session["bwapi"]["ai"] .. "/" ..  bot["name"] .. ".dll")
    elseif bot["name"] == "Lukas+Moravec" then
        os.execute("mv " .. session["bwapi"]["ai"] .. "/UAlbertaBot.dll " .. session["bwapi"]["ai"] .. "/" ..  bot["name"] .. ".dll")
    elseif bot["name"] == "Bryan+Weber" then
        os.execute("mv " .. session["bwapi"]["ai"] .. "/CUNYAIModule.dll " .. session["bwapi"]["ai"] .. "/" ..  bot["name"] .. ".dll")
    elseif bot["name"] == "Antiga" then
        os.execute("mv " .. session["bwapi"]["ai"] .. "/Steamhammer.dll " .. session["bwapi"]["ai"] .. "/" ..  bot["name"] .. ".dll")
    elseif bot["name"] == "Feint" then
        os.execute("mv " .. session["bwapi"]["ai"] .. "/Steamhammer.dll " .. session["bwapi"]["ai"] .. "/" ..  bot["name"] .. ".dll")
    elseif bot["name"] == "Proxy" then
        os.execute("mv " .. session["bwapi"]["ai"] .. "/ZergBot.dll " .. session["bwapi"]["ai"] .. "/" ..  bot["name"] .. ".dll")
    elseif bot["name"] == "XIAOYICOG2019" then
        os.execute("mv " .. session["bwapi"]["ai"] .. "/XIAOYI.dll " .. session["bwapi"]["ai"] .. "/" ..  bot["name"] .. ".dll")
    elseif bot["name"] == "Iron+bot" then
        os.execute("mv " .. session["bwapi"]["ai"] .. "/Iron.dll " .. session["bwapi"]["ai"] .. "/" .. bot["name"] .. ".dll")
    end
end

function tools.prepare_bwapi(bwapi, bot, map, conf, session)
    --
    -- Preparing bwapi.ini
    --
    bwapi["ai"]["ai"] = "/opt/StarCraft/bwapi-data/AI/" .. bot['name'] .. ".dll"
    bwapi["ai"]["tournament"] = "NULL" --conf["tournament"]["module"]
    bwapi["auto_menu"]["race"] = bot["race"]
    bwapi["auto_menu"]["wait_for_min_players"] = 2
    bwapi["starcraft"]["speed_override"] = conf["tournament"]["local_speed"]
    bwapi["auto_menu"]["game"] = bot["name"]
    bwapi["auto_menu"]["map"] = map
    -- save bwapi.ini 
    ini.save(session["bwapi"]["data"] .. "bwapi.ini", bwapi)
end

function tools.prepare_tm(bot)
    --
    -- Preparing tm.dll
    --
    --print(bot)
    print('binary stream')
    -- cp ${TM_DIR}/${BOT_BWAPI}.dll $SC_DIR/tm.dll
end

function tools.run_proxy_script(bot, session)
    --
    -- Bot might use an server/client infrastructure, so connect it after the game has started
    --
    print(bot)
    print('start proxy')
end

function tools.start_game(bot, map, session)
    --
    -- Launch the game!
    --
    lfs.chdir('/opt/StarCraft')
    local cmd = "wine bwheadless.exe -e /opt/StarCraft/StarCraft.exe -l /opt/StarCraft/bwapi-data/BWAPI.dll --host --name " 
        .. bot['name'] .. " --game " .. bot['name'] .. " --race " .. string.sub(bot['race'], 1, 1) .. " --map " .. map 
        .. " & wine Chaoslauncher/Chaoslauncher.exe"
    
    local file = assert(io.popen(cmd, 'r'))
    local output = file:read('*all')
    file:close()
    print(output)
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
