local TextServ = game:GetService("TextChatService")
local generalChat = TextServ:WaitForChild("TextChannels"):WaitForChild("RBXGeneral") :: TextChannel

SendMessage = function(message)
    message = `<font size="20" color="#FF7000">{message}</font>`
    generalChat:DisplaySystemMessage(message)
end

local maps = workspace.IntermissionLobby.Boards:GetChildren()

for map in maps do
    local mapName = map.Hitboxes.Bottom.MapDisplay.Title.Text
    SendMessage(mapName)
end