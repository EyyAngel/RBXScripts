local startTime
local Recorder = {
    recording = false
}

local function ProcessAction(args)
    
end

Recorder.Hook = function()
    local Old
    Old = hookmetamethod(game, "__namecall", function(Self, ...)
        local args = {...}
        local method = getnamecallmethod()
    
        if method == "InvokeServer" then
            if args[1] == "StatePaths" then
                startTime = tick()
            elseif (args[1] == "Troops" or "Voting") and Recorder.recording then
                ProcessAction(args)
            end
        end
    
        return Old(Self, ...)
    end)
end

return Recorder