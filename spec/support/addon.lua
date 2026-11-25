--- Test helper: loads addon files the way the game does.
-- In game, each file of the addon receives two arguments: the addon name and
-- a namespace table shared by all the files of the addon (`local addonName, ns = ...`).
local Addon = {}

local ADDON_NAME = "CraftJourney"

--- Loads the given files, in order, into a fresh namespace and returns it.
-- @param ... file paths relative to the repository root
-- @return the namespace table filled by the files
function Addon.load(...)
  local ns = {}
  for i = 1, select("#", ...) do
    local path = select(i, ...)
    local chunk = assert(loadfile(path))
    chunk(ADDON_NAME, ns)
  end
  return ns
end

return Addon
