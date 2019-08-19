local https = require("ssl.https")
local json = require("bw.lib.json")
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

function bots.get_bot()
    local available = bots.get_sscait_bots()
end

function bots.try_download()
end

local available = bots.get_sscait_bots()

print(available)

return bots
