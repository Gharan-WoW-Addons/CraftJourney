local _, ns = ...

local Message = {}

function Message.welcome(version)
  local template = "Craft Journey %s loaded."
  local message = string.format(template, version)

  return message
end

ns.Message = Message
