local Addon = require("spec.support.addon")

describe("Addon.load", function()
  it("passes the addon name to each file", function()
    local ns = Addon.load("spec/fixtures/namespace.lua")

    assert.are.equal("CraftJourney", ns.addonName)
  end)

  it("shares one namespace between the loaded files", function()
    local ns = Addon.load("spec/fixtures/namespace.lua", "spec/fixtures/namespace.lua")

    assert.are.equal(2, ns.loaded)
  end)
end)
