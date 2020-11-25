-- very self-explanatory
local fun = require("moses")
local inspect = require("inspect")
local http = require("socket.http")
local https = require("ssl.https")
local lfs = require("lfs")
local ini = require("inifile")

local tools = {}

function tools.update_registry()
    os.execute("bash /opt/bw/include/wine_registry.sh")
end

function tools.prepare_ai(bot, session)
    --
    -- Preparing to fight
    --
    local name = bot["name"]:gsub("% ", "+")
    os.execute("cp " .. "/opt/bw/include/bwapi-data/"
        .. bot["bwapi"] .. ".dll "
        .. session["bwapi"]["data"] .. "bwapi/")
    os.execute("cp " .. "/opt/bw/include/bwapi-data/"
        .. bot["bwapi"] .. ".dll "
        .. session["bwapi"]["data"] .. "BWAPI.dll")
    os.execute("cp -r " .. session["bots"] .. name .. "/AI/* " .. session["bwapi"]["ai"])
end

function tools.prepare_bwapi(bwapi, bot, map, conf, session)
    --
    -- Preparing bwapi.ini
    --
    if fun.size(bot) > 2 then
        bwapi["ai"]["ai"] = "/opt/StarCraft/bwapi-data/AI/" .. bot['name'] .. ".dll, HUMAN"
        --bwapi["ai"]["tournament"] = "bwapi-data/tm.dll"
        bwapi["auto_menu"]["race"] = bot["race"]
        bwapi["auto_menu"]["wait_for_min_players"] = 2
        bwapi["starcraft"]["speed_override"] = 42
        bwapi["auto_menu"]["game"] = bot["name"]
        bwapi["auto_menu"]["map"] = map
    elseif fun.size(bot) == 2 then
        -- is very diffrent to handle things for bot vs bot!
        bwapi["ai"]["ai"] = "/opt/StarCraft/bwapi-data/AI/"
            .. bot[1]['name']
            .. ".dll, "
            .. "/opt/StarCraft/bwapi-data/AI/"
            .. bot[2]['name']
            .. ".dll"
        bwapi["ai"]["tournament"] = "bwapi-data/tm/"
            .. bot[1]['bwapi']
            .. ".dll"
        bwapi["auto_menu"]["race"] = bot[1]["race"]
        bwapi["auto_menu"]["wait_for_min_players"] = 2
        bwapi["starcraft"]["speed_override"] = 0
        bwapi["auto_menu"]["game"] = bot[1]["name"]
        bwapi["auto_menu"]["map"] = map
    else
        print('crash tools.prepare_bwapi()')
    end
    -- save bwapi.ini
    ini.save(session["bwapi"]["data"] .. "bwapi.ini", bwapi)
end

function tools.prepare_tm(bot, session)
    --
    -- Preparing tm.dll
    --
    os.execute("cp /opt/bw/include/tm/" .. bot["bwapi"] .. ".dll " .. session["bwapi"]["data"] .. "/tm.dll")
end

function tools.start_game(bot, map, session)
    --
    -- Launch the game!
    --
    -- currenty i need to both host and join games, can I add those as arguments or include them in the session that I already have?
    --
    --
    lfs.chdir('/opt/StarCraft')
    if fun.size(bot) > 2 then

        if bot['type'] == 'Java' then
            tools.pass()
        elseif bot['type'] == 'EXE' then
            tools.pass()
        elseif bot['type'] == 'Linux' then
            cmd = "wine bwheadless.exe -e /opt/StarCraft/StarCraft.exe "
                .. "-l /opt/StarCraft/bwapi-data/BWAPI.dll --host --name "
                .. bot['name'] .. " --game " .. bot['name'] .. " --race "
                .. string.sub(bot['race'], 1, 1) .. " --map " .. map
                .. "& ophelia& wine Chaoslauncher/Chaoslauncher.exe"
        else
            cmd = "wine bwheadless.exe -e /opt/StarCraft/StarCraft.exe "
                .. "-l /opt/StarCraft/bwapi-data/BWAPI.dll --host --name "
                .. bot['name'] .. " --game " .. bot['name'] .. " --race "
                .. string.sub(bot['race'], 1, 1) .. " --map " .. map
                .. "& wine Chaoslauncher/Chaoslauncher.exe"
        end
        print(cmd)
        local file = assert(io.popen(cmd, 'r'))
        local output = file:read('*all')
        file:close()
        print(output)
    elseif fun.size(bot) == 2 then
        -- zmq and I'm ready to fuck shit up
    else
        --
        print("crash tools.start_game()")
    end
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

function tools.download_maps()
    -- 0.1
end

function tools.check_maps_exist()
    -- 2
end

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
    print(res)
    print(inspect(res_headers))
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

function tools.split(s, delimiter)
    result = {};
    for match in (s..delimiter):gmatch("(.-)"..delimiter) do
        table.insert(result, match);
    end
    return result;
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
    --local character_name = "FIRST"
    -- BWAPI version 4.2.0 and higher ONLY
    -- Text that appears in the drop-down list below the Game Type.
    --local game_type_extra = ""
    --print(character_name, game_type_extra)
    return bwapi
end

return tools
