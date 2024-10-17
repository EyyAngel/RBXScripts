local url = "https://raw.githubusercontent.com/EyyAngel/RBXScripts/refs/heads/main/TDS"

do
    Funcs = loadstring(game:HttpGet(url.."/Funcs.lua"))() :: {
        SendMessage: (string) -> (),
        PrivateMatch: (difficulty: string) -> (),
        ReturnToLobby: () -> (),
    }

    FileIO = loadstring(game:HttpGet(url.."/FileIO.lua"))() :: {
        Init: () -> (),
        GetConfig: () -> ({difficulty: string, maps: {string}});
    }
end

;(function()
    Funcs.SendMessage("Script Executed...")
    Funcs.SendMessage(string.format("PlaceID: %s", game.PlaceId))

    if game.PlaceId == Funcs.lobbyId then
        FileIO.Init()
        Funcs.SendMessage("Starting private match...")
        Funcs.PrivateMatch(FileIO.GetConfig()["difficulty"])
    elseif game.PlaceId == Funcs.matchId then
        Funcs.SendMessage("You are in a private match...")
    end
end)()
