local HttpServ = game:GetService("HttpService")

local Recorder = {
    matchStart = Instance.new("BindableEvent"),
    recording = false,
    startTime = nil,
    clientActions = {}
}

local function ProcessAction(args)
    local action = {
        delay = tick() - Recorder.startTime,
        data = {} :: {any}
    }

    for _, v in ipairs(args) do
        if typeof(v) == "string" then
            table.insert(action.data, v)
        end
    end

    if args[1] == "Troops" then
        if args[2] == "Place" then
            local pos = args[4]["Position"] :: Vector3
            action.data[4] = {["Position"] = {X = pos.X, Y = pos.Y, Z = pos.Z}}
        elseif args[2] == "Upgrade" then
            local pos = args[4]["Troop"]
            action.data[4] = {["Position"] = {X = pos.X, Y = pos.Y, Z = pos.Z}, ["Path"]=args[4]["Path"]}
        elseif args[2] == "Sell" then
            local pos = args[3]["Troop"]
            action.data[3] = {["Position"] = {X = pos.X, Y = pos.Y, Z = pos.Z}}
        end
    end

    table.insert(Recorder.clientActions, action)
end

Recorder.SaveRecording = function(mapName: string)
    local filePath = "TDS/replays/"..mapName..".json"
    writefile(filePath, HttpServ:JSONEncode(Recorder.clientActions))
end

Recorder.Hook = function()
    local Old
    Old = hookmetamethod(game, "__namecall", function(Self, ...)
        local args = {...}
        local method = getnamecallmethod()
    
        if method == "InvokeServer" then
            if args[1] == "StatePaths" then
                Recorder.startTime = tick()
                Recorder.matchStart:Fire()
            elseif (args[1] == "Troops" or "Voting") and Recorder.recording then
                ProcessAction(args)
            end
        end
    
        return Old(Self, ...)
    end)
end

return Recorder