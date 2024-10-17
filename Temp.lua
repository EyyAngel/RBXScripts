local TextServ = game:GetService("TextChatService")
local generalChat = TextServ:WaitForChild("TextChannels"):WaitForChild("RBXGeneral") :: TextChannel

SendMessage = function(msg)
    local message = `<font size="20" color="#FF7000">{msg}</font>`
    generalChat:DisplaySystemMessage(message)
end

SendMessage("Hello World")
-- loadstring(game:HttpGet("https://raw.githubusercontent.com/EyyAngel/RBXScripts/refs/heads/main/Temp.lua"))()
