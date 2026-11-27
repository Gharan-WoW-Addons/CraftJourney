local _, ns = ...

local Message = {}

function Message.welcome(L, version)
  local template = L.WELCOME_MESSAGE
  local message = string.format(template, version)

  return message
end

ns.Message = Message
