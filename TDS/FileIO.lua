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
    return HttpServ:JSONDecode(readfile("TDS/config.json"))
end

return FileIO
