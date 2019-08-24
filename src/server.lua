--
-- The Computer League server.lua file
--
local argparse = require("argparse")
local turbo = require("turbo")
local socket = require("socket")
local uuid = require("uuid")
local options = require("bw.options")

local parser = argparse("server.lua, handles the bot fights")
    parser:option("-c --config", "configuration file.", "/opt/bw/include/bw.yml")

local args = parser:parse()

local config = options.get_options(args['config'])

-- init random seed
uuid.randomseed(socket.gettime()*10000)
-- Session ID
local session_uuid = uuid()

turbo.log.warning("bw.server.lua " .. session_uuid)

-- Handler that control the bots
local BotsHandler = class("BotsHandler", turbo.web.RequestHandler)

function BotsHandler:post()
    local data = self:get_json(true)
    turbo.log.warning('post received ' .. data)
end

function BotsHandler:get()
    turbo.log.warning('get received')
end

-- Ping/pong handler
local StatusHandler = class("StatusHandler", turbo.web.RequestHandler)

function StatusHandler:get()
    self:write("pong")
end

-- Games handler
local GamesHandler = class("GamesHandler", turbo.web.RequestHandler)

function GamesHandler:get()
    -- !
    self:write(tostring(0))
end

local application = turbo.web.Application:new({
    {"/bots/", BotsHandler},
    {"/games/", GamesHandler},
    {"/status/", StatusHandler}
})
-- I/O application start listen on TCP port.
application:listen(config['port'])
turbo.ioloop.instance():start()
