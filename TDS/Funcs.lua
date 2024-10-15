local TextServ = game:GetService("TextChatService")

local generalChat = TextServ:WaitForChild("TextChannels"):WaitForChild("RBXGeneral") :: TextChannel
local remoteFunc = game:GetService("ReplicatedStorage"):WaitForChild("RemoteFunction") :: RemoteFunction
local remoteEvent = game:GetService("ReplicatedStorage"):WaitForChild("RemoteEvent") :: RemoteEvent

local Functions = {}

Functions.SendMessage = function(message)
    generalChat:DisplaySystemMessage(message)
end

Functions.PrivateMatch = function()
    remoteFunc:InvokeServer("Multiplayer", "v2:start", {
        count = 1,
        mode = "survival"
    })
end

return Functions
