local url = "https://raw.githubusercontent.com/EyyAngel/RBXScripts/refs/heads/main/TDS/Funcs.lua"
local Funcs = loadstring(game:HttpGet(url))()


;(function()
    if game.PlaceId == Funcs.lobbyId then
        Funcs.PrivateMatch()
    end
end)()
