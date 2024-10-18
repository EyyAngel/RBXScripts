local url = "https://raw.githubusercontent.com/EyyAngel/RBXScripts/refs/heads/main/TDS"

do
    local pass, result = pcall(function() return require('TDS/Funcs.lua') end)
    Funcs = pass and result or loadstring(game:HttpGet(url.."/Funcs.lua"))() :: typeof(result)

    local pass, result = pcall(function() return require('TDS/FileIO.lua') end)
    FileIO = pass and result or loadstring(game:HttpGet(url.."/FileIO.lua"))() :: typeof(result)
end

;(function()
    local config = FileIO.GetConfig()

    if game.PlaceId == Funcs.lobbyId then
        FileIO.Init()
        Funcs.PrivateMatch(config["difficulty"])
    elseif game.PlaceId == Funcs.matchId then
        local result = Funcs.AttemptPlay(config["maps"])

        if not result then
            Funcs.ReturnToLobby()
        else
            -- Record or replay
        end
    end
end)()
