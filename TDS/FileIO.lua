local HttpServ = game:GetService("HttpService")
local FileIO = {}

FileIO.Init = function()
    if not isfolder("TDS") then
        makefolder("TDS")
        writefile("TDS/config.json", '{"difficulty": "Easy", "maps": ["Grass Isle", "Toy Board"]}')
    end
end

FileIO.GetConfig = function()
    return HttpServ:JSONDecode(readfile("TDS/config.json"))
end

return FileIO
