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
  license = "AGPL3"
}

dependencies = {
  "lua == 5.1",
  "argparse",
  "luasocket",
  "luafilesystem",
  "inspect",
  "lyaml",
  "lzmq-ffi",
  "inifile",
  "turbo",
  "uuid"
}

build = {
  type = 'builtin',
  modules = {
    ['bw.lib.json'] = "src/lib/json.lua",
    ['bw.lib.yaml'] = "src/lib/YAMLParserLite.lua",
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