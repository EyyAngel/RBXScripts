local url = "https://raw.githubusercontent.com/EyyAngel/RBXScripts/refs/heads/main/TDS"

do
    local pass, result = pcall(function() return require('TDS/Funcs.lua') end)
    Funcs = pass and result or loadstring(game:HttpGet(url.."/Funcs.lua"))() :: typeof(result)

    local pass, result = pcall(function() return require('TDS/FileIO.lua') end)
    FileIO = pass and result or loadstring(game:HttpGet(url.."/FileIO.lua"))() :: typeof(result)
end

;(function()
    Funcs.SendMessage("Script Executed...")

    if game.PlaceId == Funcs.lobbyId then
        FileIO.Init()
        Funcs.PrivateMatch(FileIO.GetConfig()["difficulty"])
    elseif game.PlaceId == Funcs.matchId then
        Funcs.SendMessage("You are in a private match...")
        -- Check for whitelisted maps
        Funcs.SendMessage("Checking maps...")
        local result = Funcs.AttemptPlay(FileIO.GetConfig()["maps"])
        Funcs.SendMessage("Whitelisted Map?:"..result)
        -- If no whitelisted map, return to lobby
        -- Else record or replay
    end
end)()
