local https = require("ssl.https")
local tools = require("bw.tools")
local json = require("bw.lib.json")
local lfs = require("lfs")

--
supported_bwapi = {
    ["4.4.0"] = "cf7a19fe79fad87f88177c6e327eaedc",
    ["4.2.0"] = "2f6fb401c0dcf65925ee7ad34dc6414a",
    ["4.1.2"] = "1364390d0aa085fba6ac11b7177797b0",
}
--
local bots = {}
--
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
    
    tools.download_extract_zip(spec['botBinary'], home .. "/AI")
    tools.download_file(spec['bwapiDLL'], home .. "/BWAPI.dll")
    
    lfs.mkdir(home.."/read")
    lfs.mkdir(home.."/write")
end

function bots.get_bot(name, bots_directory)
    local available = bots.get_sscait_bots()
    local names = {}
    local spec = {}
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
                print(name .. ' already installed')
            end
            break
        end
    end
    return spec 
end

return bots
