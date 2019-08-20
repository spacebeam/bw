#!/usr/bin/env luajit
--
-- StarCraft:Brood War bots running inside a Singularity Linux® Container
--
local argparse = require("argparse")
local socket = require("socket")
local http = require("socket.http")
local uuid = require("uuid")
local messages = require("bw.messages")
local options = require("bw.options")
local version = require("bw.version")
-- init random seed
uuid.randomseed(socket.gettime()*10000)
-- Session UUID
local session_uuid = uuid()
-- CLI argument parser
local parser = argparse() {
   name = "bw",
   description = "bw command line tool.",
   epilog = "It can download and launch Win32 C++ and Java bots " .. 
   "or any Linux® bot with support for BWAPI 4.1.2, 4.2.0, 4.4.0."
}
local conf = options.get_options("../include/bw.yml")
-- Spawning fighting bots at 
parser:option("-d --directory", "StarCraft 1.16.1 directory", "/opt/StarCraft")
parser:option("-b --bots", "Prepare to fight", "Ophelia")
parser:option("-m --map", "is not territory", "maps/download/Fighting\\ Spirit.scx")
-- CLI bw command
parser:command_target("command")
parser:command("start")
parser:command("status")
parser:command("stop")
-- Show your version
parser:command("version")
-- Parse your arguments
local args = parser:parse()
local config = options.get_session_conf(args['directory'])
if args['command'] == 'start' then
    print(config)
    stars = {}
    for w in args['bots']:gmatch("%S+") do table.insert(stars, w) end
    if #stars == 1 then
        print("CPU 1 vs Player 1")
    elseif #stars == 2 then
        print("CPU 1 vs CPU 2")
    else
        print(#stars)
    end

    --bots.get_bot()
    --bots.get_sscait_bots()
    --bots.try_download()

    print(args['map'])
    print(args['directory'])
    -- Something completely different
elseif args['command'] == 'stop' then
    print('Stop ' .. messages[math.random(#messages)])
elseif args['command'] == 'status' then
    local url = "http://" .. conf['host'] .. ":" .. tostring(conf['port']) .. "/status/"
    local res, code, response_headers = http.request{
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
    print(messages[math.random(#messages)])
elseif args['command'] == 'version' then
    print('bw version ' .. version)
else
    -- do something else
    print(messages[1])
end
