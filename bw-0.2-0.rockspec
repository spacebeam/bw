-- And Now For Something Completely Different
package = "bw"
version = "0.2-0"

source = {
  url = "git://github.com/spacebeam/bw",
  tag = "0.2.0",
}

description = {
  summary = "bw command line tool",
  detailed = "It can download and launch Win32 C++ and Java bots " ..
  "or any Linux® bot with support for BWAPI 4.1.2, 4.2.0, 4.4.0.",
  homepage = "https://github.com/spacebeam",
  license = "Apache-2.0"
}

dependencies = {
  "lua == 5.1",
  "argparse",
  "luasocket",
  "luafilesystem",
  "inspect",
  "lyaml", -- WHY?
  "lzmq-ffi",
  "inifile",
  "turbo", -- WHY? I'm hosting a lua http server?
  "uuid"
}

build = {
  type = 'builtin',
  modules = {
    ['bw.lib.json'] = "src/lib/json.lua",
    ['bw.lib.yaml'] = "src/lib/YAMLParserLite.lua", -- WHY IF THERE IS ALSO LYAML?
    ['bw.bots'] = "src/bots.lua",
    ['bw.messages'] = "src/messages.lua",
    ['bw.options'] = "src/options.lua",
    ['bw.tools'] = "src/tools.lua",
    ['bw.version'] = "src/version.lua"
  },
  install = {
    bin = {
      ['bw'] = "src/main.lua"
    }
  }
}
