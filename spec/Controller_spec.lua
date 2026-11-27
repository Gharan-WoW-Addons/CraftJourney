local Addon = require("spec.support.addon")

describe("Controller", function()
  local handler
  local printed
  local originalPrint = print

  before_each(function()
    _G.GetLocale = function()
      return "frFR"
    end
    _G.C_AddOns = {
      GetAddOnMetadata = function()
        return "0.1.0"
      end,
    }

    _G.CreateFrame = function()
      return {
        RegisterEvent = function() end,
        SetScript = function(_, _, fn)
          handler = fn
        end,
      }
    end

    _G.print = function(text)
      printed = text
    end
  end)

  after_each(function()
    _G.GetLocale = nil
    _G.C_AddOns = nil
    _G.CreateFrame = nil
    _G.print = originalPrint
  end)

  it("should greet the player in French at login", function()
    Addon.load("src/Locales/enUS.lua", "src/Locales/frFR.lua", "src/Domain/Message.lua", "src/Controller.lua")
    local expectedMessage = "Craft Journey 0.1.0 chargé."

    handler(nil, "PLAYER_LOGIN")
    local actualMessage = printed

    assert.are.equal(expectedMessage, actualMessage)
  end)

  it("should greet the player in English when the language is not translated", function()
    _G.GetLocale = function()
      return "deDE"
    end
    Addon.load("src/Locales/enUS.lua", "src/Locales/frFR.lua", "src/Domain/Message.lua", "src/Controller.lua")
    local expectedMessage = "Craft Journey 0.1.0 loaded."

    handler(nil, "PLAYER_LOGIN")
    local actualMessage = printed

    assert.are.equal(expectedMessage, actualMessage)
  end)
end)
