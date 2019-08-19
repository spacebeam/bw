local https = require("ssl.https")
--
supported_bwapi = {
    ["4.4.0"] = "cf7a19fe79fad87f88177c6e327eaedc",
    ["4.2.0"] = "2f6fb401c0dcf65925ee7ad34dc6414a",
    ["4.1.2"] = "1364390d0aa085fba6ac11b7177797b0",
}
--
local bots = {}
--

-- !
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
    print(response)
end

function bots.get_bot()
    local sscait = bots.get_sscait_bots()
end

function bots.try_download()
end


bots.get_sscait_bots()


--
return bots
