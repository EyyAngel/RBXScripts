local TextServ = game:GetService("TextChatService")
local TPServ = game:GetService("TeleportService")

local player = game:GetService("Players").LocalPlayer
local generalChat = TextServ:WaitForChild("TextChannels"):WaitForChild("RBXGeneral") :: TextChannel
local remoteFunc = game:GetService("ReplicatedStorage"):WaitForChild("RemoteFunction") :: RemoteFunction
local remoteEvent = game:GetService("ReplicatedStorage"):WaitForChild("RemoteEvent") :: RemoteEvent

local Functions = {
    lobbyId = 3260590327,
    matchId = 5591597781
}

Functions.SendMessage = function(message)
    message = `<font size="20" color="#FF7000">{message}</font>`
    generalChat:DisplaySystemMessage(message)
end

Functions.PrivateMatch = function(difficulty)
    remoteFunc:InvokeServer("Multiplayer", "v2:start", {
        difficulty = difficulty,
        count = 1,
        mode = "survival"
    })
end

Functions.ReturnToLobby = function()
    TPServ:Teleport(Functions.lobbyId, player)
end

Functions.AttemptPlay = function(whitelist)
    for i=1, 2 do
        for board in workspace.IntermissionLobby.Boards:GetChildren() do
            local mapName = board.Hitboxes.Bottom.MapDisplay.Title.Text
            if table.find(whitelist, mapName) then
                return mapName
            end
        end

        remoteEvent:FireServer("LobbyVoting", "Veto")
        task.wait(1)
    end

    return false
end

return Functions
