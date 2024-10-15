local remote = game:GetService("ReplicatedStorage"):WaitForChild("RemoteFunction") :: RemoteFunction

remote:InvokeServer(
    "Multiplayer",
    "v2:start",
    {
        count = 1,
        mode = "survival"
    }
)
