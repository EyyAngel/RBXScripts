local TextServ = game:GetService("TextChatService")
local TPServ = game:GetService("TeleportService")

local player = game:GetService("Players").LocalPlayer
local generalChat = TextServ:WaitForChild("TextChannels"):WaitForChild("RBXGeneral") :: TextChannel
local remoteFunc = game:GetService("ReplicatedStorage"):WaitForChild("RemoteFunction") :: RemoteFunction
local remoteEvent = game:GetService("ReplicatedStorage"):WaitForChild("RemoteEvent") :: RemoteEvent

local Functions = {
    lobbyId = 3260590327
}

Functions.SendMessage = function(message)
    generalChat:DisplaySystemMessage(message)
end

Functions.PrivateMatch = function()
    remoteFunc:InvokeServer("Multiplayer", "v2:start", {
        difficulty = "Easy",
        count = 1,
        mode = "survival"
    })
end

Functions.ReturnToLobby = function()
    TPServ:Teleport(Functions.lobbyId, player)
end

return Functions
