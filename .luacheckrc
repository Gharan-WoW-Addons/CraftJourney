-- Luacheck configuration: https://luacheck.readthedocs.io/en/stable/config.html
std = "lua51"
max_line_length = 120

exclude_files = {
  "lua_modules/",
  ".luarocks/",
  ".release/",
}

-- Tests run with busted: allow its globals (describe, it, assert...) in specs only.
files["spec/"] = {
  std = "+busted",
}

-- WoW API globals are declared here as the addon starts using them, e.g.:
-- read_globals = { "CreateFrame" }
