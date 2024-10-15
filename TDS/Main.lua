if not game:IsLoaded() then game.Loaded:Wait() end

local TextServ = game:GetService("TextChatService")
local general = TextServ:WaitForChild("TextChannels"):WaitForChild("RBXGeneral") :: TextChannel

general:DisplaySystemMessage(tostring(game.PlaceId))
