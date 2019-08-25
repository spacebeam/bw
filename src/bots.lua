local https = require("ssl.https")
local tools = require("bw.tools")
local lyaml = require("lyaml")
local json = require("bw.lib.json")
local lfs = require("lfs")

local bots = {}

function bots.supported_bwapi(md5sum)
    local bwapi = {
        ["1364390d0aa085fba6ac11b7177797b0"] = "4.1.2",
        ["2f6fb401c0dcf65925ee7ad34dc6414a"] = "4.2.0",
        ["cf7a19fe79fad87f88177c6e327eaedc"] = "4.4.0",
    }
    return bwapi[md5sum]
end

function bots.get_sscait_bots()
    local url = "https://sscaitournament.com/api/bots.php"
    local chunks = {}
    local r, c, h, s = https.request {
        url = url,
        method = "GET",
        headers = {["Content-Type"] = "application/json"},
        sink = ltn12.sink.table(chunks)
    }
    local response = table.concat(chunks)
    return json.decode(response)
end

function bots.try_download(spec, home)
    print("Trying download " .. spec['name'] .. " into " .. home)
    lfs.mkdir(home)
    local bot = {}
    tools.download_extract_zip(spec['botBinary'], home .. "/AI")
    local file = home .. "/BWAPI.dll"
    tools.download_file(spec['bwapiDLL'], file)
    lfs.mkdir(home.."/read")
    lfs.mkdir(home.."/write")
    bot["name"] = spec['name']
    bot["race"] = spec['race']
    if spec['botType'] ==  "AI_MODULE" then
        bot['type'] = "DLL"
    elseif spec['botType'] == "JAVA_MIRROR" then
        bot["type"] = "Java"
    elseif spec['botType'] == "EXE" then
        bot["type"] = "EXE"
    end
    bot["bwapi"] = bots.supported_bwapi(tools.md5file(file))
    local file = io.open(home .. "/bot.yml",'w')
    file:write(lyaml.dump({bot}))
    file:close()
    return bot
end

function bots.get_bot(name, bots_directory)
    local available = bots.get_sscait_bots()
    local names = {}
    local spec = {}
    local bot = false
    for i, v in ipairs(available) do names[i] = v["name"] end
    for _, v in pairs(names) do
        if v == name then
            local home = bots_directory .. name
            if not lfs.chdir(home) then
                for i, v in ipairs(available) do
                    if v['name'] == name then
                        spec = v
                        break
                    end
                end
                bot = bots.try_download(spec, home)
                if bot then
                    print("Successfully downloaded " .. name .. " from SSCAIT")
                end
            else
                -- if already exists load bot.yml
                print(name .. ' already installed')
                local file = tools.read_file(home .. "/bot.yml")
                bot = lyaml.load(file)
            end
            break
        end
    end
    return bot 
end

return bots
