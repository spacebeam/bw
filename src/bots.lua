local https = require("ssl.https")
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

function bots.try_download()
end

function bots.get_bot(name)
    local available = bots.get_sscait_bots()
    local names = {}
    for i, v in ipairs(available) do names[i] = v["name"] end
    for _, v in pairs(names) do
        if v == name then

            print(name)

            -- SELF_BOT_DIR/NAME !?
            
            --local home = SELF_BOT_DIR/NAME
            --if not os.path.exists(home)
            --    bot = json available
            --    print(bot)
            --    bot_spec = bots.try_download(bot)

            --    if bot_spec then
            --        print("Successfully downloaded " .. name .. " from SSCAIT")
            --    end
            --end

            break
        end
    end
    --return home 
end

--  
bots.get_bot('Ophelia')
bots.get_bot('BananaBrain')

return bots
