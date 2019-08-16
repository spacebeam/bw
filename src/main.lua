#!/usr/bin/env luajit
--
-- StarCraft:Brood War bots running inside a Singularity Linux® Container
--
local argparse = require("argparse")
local socket = require("socket")
local uuid = require("uuid")
-- init random seed
uuid.randomseed(socket.gettime()*10000)
-- Session UUID
local session_uuid = uuid()
-- CLI argument parser
local parser = argparse() {
   name = "bw",
   description = "bw command line toolkit.",
   epilog = "It can download and launch Win32 C++ and Java bots " .. 
   "or any Linux® bot with support for BWAPI 4.1.2, 4.2.0, 4.4.0."
}

local yaml = require("bw.lib.yaml")

local tools = require("bw.tools")

local options = require("bw.options")

local messages = require("bw.messages")

local raw = tools.read_file("../include/bw.yml")

-- first load bw.yml configuration file 
local conf = yaml.parse(raw)

-- Spawning bots at directory
parser:option("-d --directory", "StarCraft bots directory", "/opt/StarCraft")
-- Fighting bots
parser:option("-b --bots", "Prepare to fight", "Ophelia BananaBrain")
-- Map is not territory
parser:option("-m --map", "for territory", "maps/download/Fighting\\ Spirit.scx")

-- CLI pkg command
parser:command_target("command")
-- How are you? 
parser:command("status")
-- Live for the swarm! 
parser:command("play")

-- Parse your arguments
local args = parser:parse()

local config = options.get_conf(args['directory'])

print(config)

-- WHAT IF I GET STUFF FROM YML?
-- KIND OF GETTING THERE...

-- STATUS, STATUS, STATUS 
if args['command'] == 'status' then
    print('status')
-- PLAY, PLAY, PLAY
elseif args['command'] == 'play' then
    print('play')
    print(args['bots'])
    print(args['map'])
    print(args['directory'])
else
    -- do something else
    print(messages[1])
end
