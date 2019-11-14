local lfs = require("lfs")
local yaml = require("bw.lib.yaml")
local tools = require("bw.tools")

local options = {}

function options.get_options(config_file)
    local raw = tools.read_file(config_file)
    local conf = yaml.parse(raw)
    return conf
end

function options.get_session_conf(dir)
    -- get configuration
    local conf = {}
    conf.bwapi = {}
    conf.bots = dir .. '/bots/'
    conf.games = dir .. '/games/'
    conf.maps = dir .. '/maps/'
    conf.errors = dir .. '/Errors/'
    conf.bwapi.data = dir .. '/bwapi-data/' 
    conf.bwapi.save = conf.bwapi.data .. 'save'
    conf.bwapi.read = conf.bwapi.data .. 'read'
    conf.bwapi.write = conf.bwapi.data .. 'write'
    conf.bwapi.ai = conf.bwapi.data .. 'AI'
    conf.bwapi.logs = conf.bwapi.data .. 'logs'
    -- making some dirs
    lfs.mkdir(conf['bots'])
    lfs.mkdir(conf['games'])
    lfs.mkdir(conf['errors'])
    lfs.mkdir(conf['bwapi']['data'])
    lfs.mkdir(conf['bwapi']['save'])
    lfs.mkdir(conf['bwapi']['read'])
    lfs.mkdir(conf['bwapi']['write'])
    lfs.mkdir(conf['bwapi']['ai'])
    lfs.mkdir(conf['bwapi']['logs'])
    return conf
end

return options
