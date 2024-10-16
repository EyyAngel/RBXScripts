local url = "https://raw.githubusercontent.com/EyyAngel/RBXScripts/refs/heads/main/TDS"

do
    local pass, result = pcall(function() return require('TDS/Funcs.lua') end)
    Funcs = pass and result or loadstring(game:HttpGet(url.."/Funcs.lua"))() :: typeof(result)

    local pass, result = pcall(function() return require('TDS/FileIO.lua') end)
    FileIO = pass and result or loadstring(game:HttpGet(url.."/FileIO.lua"))() :: typeof(result)
end

Start = function()
    FileIO.Init()
    local config = FileIO.GetConfig()

    if game.PlaceId == Funcs.lobbyId then
        Funcs.PrivateMatch(config["difficulty"])
    elseif game.PlaceId == Funcs.matchId then
        local mapName = Funcs.AttemptPlay(config["maps"])

        if not mapName then
            Funcs.SendMessage("Returning to lobby in 5s...")
            task.wait(5)
            Funcs.ReturnToLobby()
        end

        local mapReplay = FileIO.GetMapReplay(mapName)
        if not mapReplay then
            Funcs.SendMessage("No Replay For: "..mapName)
        end
    end
end

local pass, msg = pcall(Start)
if not pass then Funcs.SendMessage(msg) end