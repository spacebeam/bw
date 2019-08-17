--
-- The Computer League server.lua file
--
local argparse = require("argparse")
local turbo = require("turbo")
local uuid = require("uuid")
local options = require("bw.options")

local parser = argparse("server.lua, handles the bot fights")
    parser:option("-c --config", "configuration file.", "../include/bw.yml")

local args = parser:parse()

local config = options.get_options(args['config'])

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

function BotsHandler:patch()
    local data = self:get_json(true)
    turbo.log.warning('patch received ' .. data)    
end

local application = turbo.web.Application:new({
    {"/bots/", BotsHandler}
})
-- I/O application start listen on TCP port.
application:listen(config['port'])
turbo.ioloop.instance():start()
