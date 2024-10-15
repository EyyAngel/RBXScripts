local TextServ = game:GetService("TextChatService")
local generalChat = TextServ:WaitForChild("TextChannels"):WaitForChild("RBXGeneral") :: TextChannel
local Functions = {}

Functions.SendMessage = function(message)
    generalChat:DisplaySystemMessage(message)
end

return Functions
