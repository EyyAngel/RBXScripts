local TextServ = game:GetService("TextChatService")
local TPServ = game:GetService("TeleportService")

local player = game:GetService("Players").LocalPlayer
local _char = player.Changed or player.CharacterAdded:Wait()
local generalChat = TextServ:WaitForChild("TextChannels"):WaitForChild("RBXGeneral") :: TextChannel
local remoteFunc = game:GetService("ReplicatedStorage"):WaitForChild("RemoteFunction") :: RemoteFunction
local remoteEvent = game:GetService("ReplicatedStorage"):WaitForChild("RemoteEvent") :: RemoteEvent

--[[
    Local Functions
]]
do
    VoteForMap = function(mapName)
        remoteEvent:FireServer("LobbyVoting", "Vote", mapName, Vector3.zero)
        remoteEvent:FireServer("LobbyVoting", "Ready")
    end
end

--[[
    "Module" Functions
]]
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
    local boards = workspace:WaitForChild("IntermissionLobby"):WaitForChild("Boards") :: Folder
    local count = 0

    repeat
        local maps = {}

        for _, board in boards:GetChildren() do
            local mapName = board.Hitboxes.Bottom.MapDisplay.Title.Text
            if table.find(maps, mapName) then break end
            table.insert(maps, mapName)
            count += 1
            
            Functions.SendMessage(mapName)
            if table.find(whitelist, mapName) then
                VoteForMap(mapName)
                return mapName
            end
        end

        if count < 2 then
            remoteEvent:FireServer("LobbyVoting", "Veto")
            task.wait(1)
        end
    until count >= 2

    return false
end

return Functions
