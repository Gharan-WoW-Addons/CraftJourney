local Addon = require("spec.support.addon")

describe("Message", function()
  it("should display message", function()
    local ns = Addon.load("src/Domain/Message.lua")
    local version = "0.1.0"

    local ActualMessage = ns.Message.welcome(version)
    local ExpectedMessage = "Craft Journey 0.1.0 loaded."

    assert.are.equal(ExpectedMessage, ActualMessage)
  end)
end)
