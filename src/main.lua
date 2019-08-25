#!/usr/bin/env luajit
--
-- StarCraft:Brood War bots running inside a Singularity Linux® Container
--
local lfs = require("lfs")
local argparse = require("argparse")
local socket = require("socket")
local uuid = require("uuid")
local bots = require("bw.bots")
local messages = require("bw.messages")
local options = require("bw.options")
local tools = require("bw.tools")
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
local conf = options.get_options("/opt/bw/include/bw.yml")
-- Spawning fighting bots at 
parser:option("-d --directory", "StarCraft 1.16.1 directory", "/opt/StarCraft")
parser:option("-b --bots", "Prepare to fight", "Ophelia")
parser:option("-m --map", "is not territory", "maps/download/Fighting\\ Spirit.scx")
-- CLI bw command
parser:command_target("command")
parser:command("play")
parser:command("status")
parser:command("version")
-- Parse your arguments
local args = parser:parse()
local config = options.get_session_conf(args['directory'])
if args['command'] == 'play' then
    -- show configuration from file
    --print(conf) 
    -- this session's configuration
    --print(config)
    -- this are two different things since we can call bw with 
    -- custom StarCraft 1.16.1 directory, fighting bots and map. 
    local status = tools.check_status_code(conf["host"], conf["port"])
    if status == 200 then
        local stars = {}
        for w in args['bots']:gmatch("%S+") do table.insert(stars, w) end
        if #stars == 1 then
            print("CPU 1 vs Player 1")
            if lfs.chdir(config['bots']) then
                print(stars[1] .. " against you!")
                cpu_1 = bots.get_bot(stars[1], config['bots'])
                print(cpu_1)
            end
        elseif #stars == 2 then
            print("CPU 1 vs CPU 2")
        else
            print(#stars)
        end
        print(args['map'])
        print(args['directory'])
    else
        -- Something completely different
        print(messages[math.random(#messages)])
    end
elseif args['command'] == 'status' then
    local code = tools.check_status_code(conf['host'], conf['port'])
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
