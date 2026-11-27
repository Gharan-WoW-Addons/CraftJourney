local Addon = require("spec.support.addon")

describe("Message", function()
  it("should display message in English", function()
    local ns = Addon.load("src/Locales/enUS.lua", "src/Domain/Message.lua")
    local version = "0.1.0"

    local ActualMessage = ns.Message.welcome(ns.Locales.enUS, version)
    local ExpectedMessage = "Craft Journey 0.1.0 loaded."

    assert.are.equal(ExpectedMessage, ActualMessage)
  end)

  it("should display message in French", function()
    local ns = Addon.load("src/Locales/frFR.lua", "src/Domain/Message.lua")
    local version = "0.1.0"

    local ActualMessage = ns.Message.welcome(ns.Locales.frFR, version)
    local ExpectedMessage = "Craft Journey 0.1.0 chargé."

    assert.are.equal(ExpectedMessage, ActualMessage)
  end)
end)
