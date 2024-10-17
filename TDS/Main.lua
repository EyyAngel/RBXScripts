
do
    local url = "https://raw.githubusercontent.com/EyyAngel/RBXScripts/refs/heads/main/TDS/Funcs.lua"
    Funcs = loadstring(game:HttpGet(url))() :: {
        SendMessage: (string) -> (),
        PrivateMatch: (difficulty: string) -> (),
        ReturnToLobby: () -> (),
    }

    url = "https://raw.githubusercontent.com/EyyAngel/RBXScripts/refs/heads/main/TDS/FileIO"
    FileIO = loadstring(game:HttpGet(url))() :: {
        Init: () -> (),
        GetConfig: () -> ({difficulty: string, maps: {string}});
    }
end


;(function()
    Funcs.SendMessage("Main.lua Was Loaded...")
    if game.PlaceId == Funcs.lobbyId then
        FileIO.Init()
        Funcs.SendMessage("You are in the lobby!\nStarting private match...")
        Funcs.PrivateMatch(FileIO.GetConfig()["difficulty"])
    else
        Funcs.SendMessage(string.format("PlaceId: %s", tostring(game.PlaceId)))
    end
end)()
