local Old
Old = hookmetamethod(game, "__namecall", function(Self, ...)
    local method = getnamecallmethod()

    if method == "FireServer" or method == "InvokeServer" or method == "Fire" then
        print(Self, method, ...)
    end

    return Old(Self, ...)
end)