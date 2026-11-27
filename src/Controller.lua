local addonName, ns = ...

local frame = CreateFrame("Frame")
frame:RegisterEvent("PLAYER_LOGIN")
frame:SetScript("OnEvent", function()
  local L = ns.Locales[GetLocale()] or ns.Locales.enUS
  local version = C_AddOns.GetAddOnMetadata(addonName, "Version")

  print(ns.Message.welcome(L, version))
end)
