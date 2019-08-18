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
parser:option("-m --map", "is not the territory", "maps/download/Fighting\\ Spirit.scx")
-- CLI bw command
parser:command_target("command")

-- Live for the swarm! 
parser:command("start")
-- No computer, no cry
parser:command("stop")

-- Computer, how are you? 
parser:command("status")
-- Show your version
parser:command("version")
-- Parse your arguments
local args = parser:parse()
local config = options.get_session_conf(args['directory'])
-- WHAT IF I GET STUFF FROM YML?
-- KIND OF GETTING THERE...
-- PLAY, PLAY, PLAY
if args['command'] == 'start' then
    print(config)
    print(args['bots'])
    print(args['map'])
    print(args['directory'])
    -- Something completely different
elseif args['command'] == 'stop' then
    print('Stop ' .. messages[math.random(#messages)])
-- STATUS, STATUS, STATUS 
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
