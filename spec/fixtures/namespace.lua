-- Fixture for the test helper: stores what the game passes to an addon file.
local addonName, ns = ...

ns.addonName = addonName
ns.loaded = (ns.loaded or 0) + 1
