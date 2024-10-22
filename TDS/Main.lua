local url = "https://raw.githubusercontent.com/EyyAngel/RBXScripts/refs/heads/main/TDS"

do
    local pass, result = pcall(function() return require('TDS/Funcs.lua') end)
    Funcs = pass and result or loadstring(game:HttpGet(url.."/Funcs.lua"))() :: typeof(result)

    local pass, result = pcall(function() return require('TDS/FileIO.lua') end)
    FileIO = pass and result or loadstring(game:HttpGet(url.."/FileIO.lua"))() :: typeof(result)

    local pass, result = pcall(function() return require('TDS/Recorder.lua') end)
    Recorder = pass and result or loadstring(game:HttpGet(url.."/Recorder.lua")) :: typeof(result)
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

        Recorder.Hook()
        local mapReplay = FileIO.GetMapReplay(mapName)
        if not mapReplay then
            Funcs.SendMessage("No replay found, begin recording...")
            Recorder.recording = true
        else
            -- Replay map recording
            Funcs.SendMessage("Replay found, waiting for match...")
            Recorder.matchStart.Event:Wait()
        end

        Funcs.ListenForEnd()
        Funcs.matchEnded.Event:Connect(function()
            Funcs.SendMessage("Match ended...")
            if Recorder.recording then
                Recorder.SaveRecording(mapName)
                Funcs.SendMessage("Recording saved...")
            end

            task.wait(3)
            Funcs.ReturnToLobby()
        end)
    end
end

local pass, msg = pcall(Start)
if not pass then Funcs.SendMessage(msg) end