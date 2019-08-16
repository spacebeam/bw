local options = {}

function options.get_conf(dir)
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
    return conf
end

return options
