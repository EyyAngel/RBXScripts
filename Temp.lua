local TextServ = game:GetService("TextChatService")
local generalChat = TextServ:WaitForChild("TextChannels"):WaitForChild("RBXGeneral") :: TextChannel

SendMessage = function(message)
    message = `<font size="20" color="#FF7000">{message}</font>`
    generalChat:DisplaySystemMessage(message)
end

SendMessage(tostring( workspace.IntermissionLobby.Boards ))
SendMessage(tostring( workspace.IntermissionLobby.Boards:GetChildren() ))