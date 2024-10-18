local HttpServ = game:GetService("HttpService")

export type config = {
    difficulty: string,
    maps: {string}
}

local FileIO = {}

FileIO.Init = function()
    if not isfolder("TDS") then
        makefolder("TDS")
        makefolder("TDS/replays")
        writefile("TDS/config.json", '{"difficulty": "Easy", "maps": ["Grass Isle", "Toy Board"]}')
    end
end

FileIO.GetConfig = function(): config
    FileIO.Init()
    return HttpServ:JSONDecode(readfile("TDS/config.json"))
end

FileIO.GetMapReplay = function(mapName)
    local filePath = "TDS/replays/"..mapName..".json"
    if not isfile(filePath) then
        return false
    end

    return HttpServ:JSONDecode(readfile(filePath))
end

return FileIO
