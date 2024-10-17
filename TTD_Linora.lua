if not game:IsLoaded() then game.Loaded:Wait() end
local LOBBY_ID, MATCH_ID, MAIN_FOLDER = 13775256536, 14082129854, 'LinoriaTTD'

local VirtualUser = game:GetService('VirtualUser')
local RepStore = game:GetService('ReplicatedStorage')

local MultiboxFramework
local recording = false
local player = game.Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()

-------------------------------------------------- [GUI SETUP] --------------------------------------------------
local repo = 'https://raw.githubusercontent.com/violin-suzutsuki/LinoriaLib/main/'

local Library: {GiveSignal: (self, RBXScriptSignal) -> nil, Notify: (self, string) -> nil}
local ThemeManager, SaveManager

repeat task.wait()
	pcall(function()
		Library = loadstring(game:HttpGet(repo..'Library.lua'))()
		ThemeManager = loadstring(game:HttpGet(repo .. 'addons/ThemeManager.lua'))()
		SaveManager = loadstring(game:HttpGet(repo..'addons/SaveManager.lua'))()
	end)
until Library and ThemeManager and SaveManager

-- Elemets: Toggles/Options.INDEX:OnChange(value): RBXScriptSignal 'Fire On Initial Load'
-- Toggles.INDEX:SetValue(value: boolean)

local Window = Library:CreateWindow({
	Title = 'Angel\'s TTD Exploit | 09/2023',
	AutoShow = true,
	MenuFadeTime = 0.1
})

local Tabs = {
	Main = Window:AddTab('--- Main ---'),
	Misc = Window:AddTab('--- Misc ---'),
}

-------------------------------------------------- [MAIN TAB]
local AutomationGroupBox = Tabs.Main:AddLeftGroupbox('Automation') -------------------- [AUTOMATION] --------------------
AutomationGroupBox:AddDivider()

AutomationGroupBox:AddDropdown('mapSelection', { -- Options.mapSelection.Value, :SetValue('string'), :SetValues({})
	Values = {},
	Default = '',
	Text = 'Map To Farm',
})

AutomationGroupBox:AddDropdown('difficultySelection', {
	Values = {},
	Default = '',
	Text = 'Map Difficulty'
})

AutomationGroupBox:AddDropdown('replaySelection', {
	Values = {},
	Default = '',
	Text = 'Replay To use',
})

AutomationGroupBox:AddButton({
	Text = 'Refresh Replays',
	Func = function() updateReplays() end
})

AutomationGroupBox:AddLabel('')
AutomationGroupBox:AddToggle('autoPlay', {
	Text = 'Auto Farm',
	Tooltip = 'Choose a map and replay first',
	Callback = function(state)
		--SaveManager:Save(Options.SaveManager_ConfigList.Value)
		
		if state then
			if game.PlaceId == LOBBY_ID then
				JoinMatch()
			elseif game.PlaceId == MATCH_ID then
				ReplayRecording()
			end
		end
	end,
})

local RecordingGroupBox = Tabs.Main:AddRightGroupbox('Recording') -------------------- [RECORDING] --------------------
RecordingGroupBox:AddDivider()

RecordingGroupBox:AddInput('recordingName', {
	Text = 'Replay File Name',
	Placeholder = 'Choose name before recording',
})

RecordingGroupBox:AddButton({
	Text = 'Begin Recording',
	Tooltip = 'Records Gameplay',
	Func = function()
		if recording then
			Library:Notify('ALREADY RECORDING GAMEPLAY')
		else
			BeginRecording()
		end
	end,
}):AddButton({
	Text = 'Save Recording',
	Tooltip = 'Saves Recording For Replay',
	Func = function()
		if not recording then
			Library:Notify('NOT CURRENTLY RECORING')
		else
			recording = false
			local _filePath = MAIN_FOLDER..'/Replays/'..Options.recordingName.Value..'.json'
			writefile(_filePath, game.HttpService:JSONEncode(Entries))
			Library:Notify('REPLAY SAVED')
			updateReplays()
		end
	end,
})

RecordingGroupBox:AddDivider()
RecordingGroupBox:AddLabel('Skip Wave Shortcut'):AddKeyPicker('skipWave', {Default = 'Q', NoUI = true, Text = 'Skip Wave Keybind', Callback = function()
	MultiboxFramework.Network.Fire('VoteSkipWave')
end,})

RecordingGroupBox:AddButton({
	Text = 'Sell Units',
	Tooltip = 'Sell all placed troops',
	Func = function() massTroopAction('SellTroop') end,
}):AddButton({
	Text = 'Upgrade Units',
	Tooltip = 'Cost money, only upgrades once',
	Func = function() massTroopAction('UpgradeTroop') end,
})

local MiscGroupBox = Tabs.Main:AddRightGroupbox('Misc') -------------------- [MISC] --------------------
MiscGroupBox:AddButton('Rejoin Server', function()
	game:GetService("TeleportService"):TeleportToPlaceInstance(game.PlaceId, game.JobId, player)
end)

MiscGroupBox:AddButton('Join New Lobby', function()
	game:GetService("TeleportService"):Teleport(13775256536, player)
end)

MiscGroupBox:AddButton('Unload GUI', function() Library:Unload() end)

MiscGroupBox:AddLabel('Menu Bind'):AddKeyPicker('MenuKeybind', { Default = 'LeftControl', NoUI = true, Text = 'Menu keybind' })
Library.ToggleKeybind = Options.MenuKeybind

-------------------------------------------------- [FUNCTIONS] --------------------------------------------------
local function processNetworkEvent(event) -- 'PlaceTroop', 'UpgradeTroop', 'SellTroop', 'VoteSkipWave', 'ChangeTargetting'
	local _action = event[1]
	local _entry = {action = _action}
	
	if _action == 'PlaceTroop' then
		_entry.troop = event[2]
		_entry.position = {x = event[3].X, y = event[3].Y, z = event[3].Z}
		_entry.rotation = event[4]
	elseif _action == 'UpgradeTroop' or _action == 'SellTroop' or _action == 'ChangeTargetting' then
		local _troopPos = event[2].PrimaryPart.Position
		_entry.position = {x = _troopPos.X, y = _troopPos.Y, z = _troopPos.Z}
	elseif _action == 'VoteSkipWave' then else return end
	
	_entry.timestamp = getgenv().MatchTimer.Value
	table.insert(Entries, _entry)
end

BeginRecording = function()
	if game.PlaceId == LOBBY_ID then
		Library:Notify('JOIN A MATCH FIRST')
		return
	elseif Options.recordingName.Value:len() < 1 then
		Library:Notify('NAME REPLAY BEFORE RECORDING')
		return
	end
	
	recording = true
	Library:Notify('WAITING FOR VOTING TO END')
	
	repeat task.wait() until RepStore:FindFirstChild('MatchData') and RepStore.MatchData.Voting.Value == 0
	getgenv().MatchTimer = RepStore.MatchData.MatchTimer
	getgenv().Entries = {}
	
	Library:Notify('RECORDING GAMEPLAY')
	local _old
	_old = hookfunction(MultiboxFramework.Network.Fire, function(...)
		processNetworkEvent({...})
		return _old(...)
	end)
end

JoinMatch = function()
	local _teleporting
	
	if not Options.mapSelection.Value then
		Library:Notify('CHOOSE A MAP TO FARM')
	end
	
	local _conn = MultiboxFramework.Network.Fired('QueueLeaderChanged'):Connect(function(id, map, numPlayers, max, host)
		if host == player then
			MultiboxFramework.Network.Fire('StartTeleport', id)
			_teleporting = true
		end
	end)
	
	repeat task.wait()
		if Options.mapSelection.Value then
			for _, lift in next, workspace.Lifts:GetChildren() do
				if lift.Name == Options.mapSelection.Value and lift.Base.StatusGui.PlayersCount.Text == '0/5' then
					character:PivotTo( lift.Base.CFrame * CFrame.new(0, 2, 0) )
					task.wait(1)

					if _teleporting then break end
				end
			end
		end
	until _teleporting or not Toggles.autoPlay.Value
	_conn:Disconnect()
end

-------------------------------------------------- [REPLAYING]
local _placedTroops = {}

local function _exactPosition(troop: Instance, pos: Vector3)
	local _magnitude = (troop.PrimaryPart.Position - pos).Magnitude
	return _magnitude <= 0.1
end

local function _getTroopInstance(pos: Vector3)
	local _troopInstance

	repeat task.wait()
		pcall(function()
			for _, _troop in next, workspace.Troops:GetChildren() do
				if _troop.TroopOwner.Value == player and _exactPosition(_troop, pos) then
					_troopInstance = _troop
					break
				end
			end
		end)
	until _troopInstance

	table.insert(_placedTroops, _troopInstance)
end

ReplayRecording = function()
	if getgenv().replaying then return end
	
	if not Options.replaySelection.Value then
		Library:Notify('WAITING FOR REPLAY')
		repeat task.wait() until Options.replaySelection.Value or not Toggles.autoPlay.Value
		if not Toggles.autoPlay.Value then return end
	elseif Options.replaySelection.Value:len() < 1 then
		Library:Notify('INVALID REPLAY FILE')
		Toggles.autoPlay:SetValue(false)
		return
	end
	
	getgenv().replaying = true
	MultiboxFramework.Network.Fire('VoteMap', Options.difficultySelection.Value)
	local _replayFile = readfile(MAIN_FOLDER..'/Replays/'..Options.replaySelection.Value)
	local _replayEntries = game.HttpService:JSONDecode(_replayFile)
	
	Library:Notify('WAITING FOR VOTING TO END')
	repeat task.wait() until RepStore:FindFirstChild('MatchData') and RepStore.MatchData.Voting.Value == 0
	local _matchTimer = RepStore:WaitForChild('MatchData'):WaitForChild('MatchTimer')
	
	for _, entry in _replayEntries do
		local _action = entry.action
		
		repeat
			local _time = _matchTimer.Changed:Wait()
		until _time >= entry.timestamp or Library.Unloaded
		
		if _action == 'PlaceTroop' then
			local _pos = entry.position
			local _vec = Vector3.new(_pos.x, _pos.y, _pos.z)
			MultiboxFramework.Network.Fire(_action, entry.troop, _vec, entry.rotation)
			coroutine.wrap(_getTroopInstance)(_vec)
		elseif _action == 'UpgradeTroop' or _action == 'SellTroop' or _action == 'ChangeTargetting' then
			local _pos = entry.position
			for _, _troop in _placedTroops do
				if _exactPosition(_troop, Vector3.new(_pos.x, _pos.y, _pos.z)) then
					MultiboxFramework.Network.Fire(_action, _troop)
					break
				end
			end
		elseif _action == 'VoteSkipWave' then
			MultiboxFramework.Network.Fire(_action)
		end
	end
	getgenv().replaying = false
end

--------------------------------------------------
massTroopAction = function(action)
	for _, _troop in next, workspace.Troops:GetChildren() do
		if _troop.TroopOwner.Value == player then
			MultiboxFramework.Network.Fire(action, _troop)
		end
	end
end

updateReplays = function()
	local _files = {''}

	for _, _file: string in next, listfiles(MAIN_FOLDER..'/Replays') do
		table.insert(_files, _file:match('\\(.+)'))
	end

	Options.replaySelection:SetValues(_files)
end

local function updateDropdowns()
	local _maps = {}
	local _diffs = {}
	
	for _map, _ in MultiboxFramework.SharedSettings.MapDatas do
		table.insert(_maps, _map)
	end
	
	for _diff, _ in MultiboxFramework.SharedSettings.DifficultyDatas do
		table.insert(_diffs, _diff)
	end
	
	updateReplays()
	Options.mapSelection:SetValues(_maps)
	Options.difficultySelection:SetValues(_diffs)
end

local function watermark()
	Library:SetWatermarkVisibility(true)
	local FrameTimer = tick()
	local FrameCounter = 0;
	local FPS = 60;

	Library:GiveSignal(game:GetService('RunService').RenderStepped:Connect(function()
		FrameCounter += 1;

		if (tick() - FrameTimer) >= 1 then
			FPS = FrameCounter;
			FrameTimer = tick();
			FrameCounter = 0;
		end;

		Library:SetWatermark(('FPS: %s | PING: %s ms'):format(
			math.floor(FPS),
			math.floor(game:GetService('Stats').Network.ServerStatsItem['Data Ping']:GetValue())
			));
	end))
end

-------------------------------------------------- [CONNECTIONS] --------------------------------------------------

-------------------------------------------------- [INITIALIZATION] --------------------------------------------------
ThemeManager:SetLibrary(Library)
ThemeManager:SetFolder(MAIN_FOLDER)
ThemeManager:ApplyToTab(Tabs.Misc)

SaveManager:SetLibrary(Library)
SaveManager:SetFolder(MAIN_FOLDER)
SaveManager:IgnoreThemeSettings()
SaveManager:SetIgnoreIndexes({ 'recordingName' })
SaveManager:BuildConfigSection(Tabs.Misc)

;(function()
	if not isfolder(MAIN_FOLDER..'/Replays') then makefolder(MAIN_FOLDER..'/Replays') end
	repeat task.wait(.1)
		pcall(function()
			MultiboxFramework = require(game.ReplicatedStorage.MultiboxFramework)
		end)
	until MultiboxFramework and MultiboxFramework.Network
	
	updateDropdowns()
	watermark()
	SaveManager:LoadAutoloadConfig()
	
	if game.PlaceId == MATCH_ID then
		player.Idled:Connect(function()
			VirtualUser:Button2Down(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
			task.wait(1)
			VirtualUser:Button2Up(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
		end)
	end
end)()
