local TextServ = game:GetService("TextChatService")
local generalChat = TextServ:WaitForChild("TextChannels"):WaitForChild("RBXGeneral") :: TextChannel

SendMessage = function(message)
    message = `<font size="20" color="#FF7000">{message}</font>`
    generalChat:DisplaySystemMessage(message)
end

SendMessage("Maps:")
for board in workspace:WaitForChild("IntermissionLobby").Boards:GetChildren() do
    local mapName = board.Hitboxes.Bottom.MapDisplay.Title.Text
    SendMessage("\t"..mapName)
end