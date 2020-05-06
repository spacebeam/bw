#!/usr/bin/env luajit
--
-- StarCraft:Brood War bots running inside a Singularity Linux® Container
--
local inspect = require("inspect")
local lfs = require("lfs")
local argparse = require("argparse")
local socket = require("socket")
local uuid = require("uuid")
-- required bw modules
local bots = require("bw.bots")
local messages = require("bw.messages")
local options = require("bw.options")
local tools = require("bw.tools")
local version = require("bw.version")
-- init random seed
uuid.randomseed(socket.gettime()*10000)
-- Session UUID
local session_uuid = uuid()
print("bw session " .. session_uuid)
-- CLI argument parser
local parser = argparse() {
   name = "bw",
   description = "bw command line tool.",
   epilog = "It can download and launch Win32 C++ and Java bots " ..
   "or any Linux® bot with support for BWAPI 4.1.2, 4.2.0, 4.4.0."
}
local conf = options.get_options("/opt/bw/include/bw.yml")
-- Spawning fighting bots at
parser:option("-b --bots", "Prepare to fight", "Ophelia")
parser:option("-m --map", "is not territory", "maps/TorchUp/\\(4\\)FightingSpirit.scx")
-- CLI bw command
parser:command_target("command")
parser:command("play")
parser:command("status")
parser:command("version")
-- Parse your arguments
local args = parser:parse()

-- internal session variables

local cpu_1, cpu_2  = nil, nil
inspect(cpu_1)
inspect(cpu_2)

-- StarCraft 1.16.1 directory
args['directory'] = "/opt/StarCraft"
local session = options.get_session_conf(args['directory'])
if args['command'] == 'play' then
    local status = tools.check_status_code(conf["host"], conf["port"])
    if status == 200 then
        local stars = tools.split(args['bots'], ':')
        if #stars == 1 then
            print("CPU 1 vs Player 1")
            if lfs.chdir(session['bots']) then
                print(stars[1] .. " against you!")
                cpu_1 = bots.get_bot(stars[1], session['bots'])
                tools.update_registry()
                tools.prepare_bwapi(
                    tools.get_bwapi_ini(),
                    cpu_1,
                    args['map'],
                    conf,
                    session
                )
                tools.prepare_tm(cpu_1, session)
                tools.prepare_ai(cpu_1, session)
                tools.start_game(
                    cpu_1,
                    args['map'],
                    session
                )
            end
        elseif #stars == 2 then
            print("CPU 1 vs CPU 2 ")
            tools.update_registry()
            cpu_2 = bots.get_bot(stars[2], session['bots'])
            print(inspect(cpu_2))
            tools.prepare_ai(cpu_2, session)
            tools.prepare_tm(cpu_2, session)
            cpu_1 = bots.get_bot(stars[1], session['bots'])
            print(inspect(cpu_1))
            tools.prepare_ai(cpu_1, session)
            tools.prepare_tm(cpu_1, session)
            -- is a little different to prepare a bwapi.ini for bot vs bot
            tools.prepare_bwapi(
                tools.get_bwapi_ini(),
                -- to do this thing and have the same list of arguments, pass a list or a bot.
                {cpu_1, cpu_2},
                args['map'],
                conf,
                session
            )
            tools.start_game(
                {cpu_1, cpu_2},
                args['map'],
                session
            )
        else
            print(#stars)
        end
    else
        -- Something completely different
        print(messages[math.random(#messages)])
    end
elseif args['command'] == 'status' then
    tools.check_status_code(conf['host'], conf['port'])
    print(messages[math.random(#messages)])
elseif args['command'] == 'version' then
    print('bw version ' .. version)
else
    -- do something else
    print(messages[1])
end
