repeat
	task.wait()
until game:IsLoaded() and game.Players and game.Players.LocalPlayer and game.Players.LocalPlayer.Character

---------------------------------------------// GLOBAL SCRIPT ENV //---------------------------------------

getgenv().FolderName = "ALS"

getgenv().Settings = {
	PlaybackMacro = nil,
	MacroName = nil,
    AutoReady = nil,
	AutoRetry = nil,
	AutoCollectOrb = nil,
}

getgenv().ScriptSettings = {
	RecordingMacro = false,
}

getgenv().IgnoreUnit = {
	"GodlyBellion",
	"GodlyTusk",
	"GodlyIron",
	"GodlyIgris",
	"GodlyBeru",
}

---------------------------------------------// FLUENT //---------------------------------------

local function CreateToggle()
	local toggleGui = Instance.new("ScreenGui")
	toggleGui.Name = "ToggleGui"
	toggleGui.DisplayOrder = 1e+04
	toggleGui.IgnoreGuiInset = true
	toggleGui.ScreenInsets = Enum.ScreenInsets.DeviceSafeInsets
	toggleGui.ResetOnSpawn = false
	toggleGui.Parent = game:GetService("CoreGui")

	local mainFrame = Instance.new("Frame")
	mainFrame.Name = "MainFrame"
	mainFrame.AnchorPoint = Vector2.new(0.5, 0.5)
	mainFrame.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	mainFrame.BackgroundTransparency = 1
	mainFrame.BorderColor3 = Color3.fromRGB(0, 0, 0)
	mainFrame.BorderSizePixel = 0
	mainFrame.Position = UDim2.fromScale(0.925, 0.116)
	mainFrame.Size = UDim2.fromScale(0.083, 0.148)

	local uICorner = Instance.new("UICorner")
	uICorner.Name = "UICorner"
	uICorner.CornerRadius = UDim.new(1, 0)
	uICorner.Parent = mainFrame

	local toggleButton = Instance.new("ImageButton")
	toggleButton.Name = "ToggleButton"
	toggleButton.Image = "rbxassetid://112196145837803"
	toggleButton.ImageTransparency = 0.3
	toggleButton.AnchorPoint = Vector2.new(0.5, 0.5)
	toggleButton.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	toggleButton.BackgroundTransparency = 1
	toggleButton.BorderColor3 = Color3.fromRGB(0, 0, 0)
	toggleButton.BorderSizePixel = 0
	toggleButton.Position = UDim2.fromScale(0.491, 0.482)
	toggleButton.Size = UDim2.fromScale(1, 1)

	local uICorner1 = Instance.new("UICorner")
	uICorner1.Name = "UICorner"
	uICorner1.CornerRadius = UDim.new(1, 0)
	uICorner1.Parent = toggleButton

	toggleButton.Parent = mainFrame

	local uIAspectRatioConstraint = Instance.new("UIAspectRatioConstraint")
	uIAspectRatioConstraint.Name = "UIAspectRatioConstraint"
	uIAspectRatioConstraint.AspectRatio = 1
	uIAspectRatioConstraint.Parent = mainFrame

	mainFrame.Parent = toggleGui

	return toggleButton
end

local Device
function checkDevice()
	local player = game.Players.LocalPlayer
	if player then
		local UserInputService = game:GetService("UserInputService")

		if UserInputService.TouchEnabled and not UserInputService.KeyboardEnabled then
			local FeariseToggle = CreateToggle()
			FeariseToggle.MouseButton1Click:Connect(function()
				for _, guiObject in ipairs(game:GetService("CoreGui"):GetChildren()) do
					if guiObject.Name == "ArcX" and guiObject:IsA("ScreenGui") then
						for FrameIndex, FrameValue in pairs(guiObject:GetChildren()) do
							if FrameValue:IsA("Frame") and FrameValue:FindFirstChild("CanvasGroup") then
								FrameValue.Visible = not FrameValue.Visible
							end
						end
					end
				end
			end)
			game:GetService("CoreGui").ChildRemoved:Connect(function(Value)
				if Value.Name == "ArcX" then
					FeariseToggle.Parent.Parent:Destroy()
				end
			end)
			Device = UDim2.fromOffset(480, 360)
		else
			Device = UDim2.fromOffset(580, 460)
		end
	end
end
checkDevice()

local FileName = tostring(game.Players.LocalPlayer.Name) .. "_Settings.json"
local BaseFolder = "ArcX"
local SubFolder = "Settings"

function SaveSetting()
	local json
	local HttpService = game:GetService("HttpService")

	if writefile then
		json = HttpService:JSONEncode(getgenv().Settings)

		if not isfolder(BaseFolder) then
			makefolder(BaseFolder)
		end
		if not isfolder(BaseFolder .. "/" .. getgenv().FolderName) then
			makefolder(BaseFolder .. "/" .. getgenv().FolderName)
		end
		if not isfolder(BaseFolder .. "/" .. getgenv().FolderName .. "/" .. SubFolder) then
			makefolder(BaseFolder .. "/" .. getgenv().FolderName .. "/" .. SubFolder)
		end

		writefile(BaseFolder .. "/" .. getgenv().FolderName .. "/" .. SubFolder .. "/" .. FileName, json)
	else
		error("ERROR: Can't save your settings")
	end
end

function LoadSetting()
	local HttpService = game:GetService("HttpService")
	if
		readfile
		and isfile
		and isfile(BaseFolder .. "/" .. getgenv().FolderName .. "/" .. SubFolder .. "/" .. FileName)
	then
		getgenv().Settings = HttpService:JSONDecode(
			readfile(BaseFolder .. "/" .. getgenv().FolderName .. "/" .. SubFolder .. "/" .. FileName)
		)
	end
end

LoadSetting()

local Fluent = loadstring(game:HttpGet("https://github.com/dawid-scripts/Fluent/releases/latest/download/main.lua"))()
local SaveManager =
	loadstring(game:HttpGet("https://raw.githubusercontent.com/dawid-scripts/Fluent/master/Addons/SaveManager.lua"))()
local InterfaceManager = loadstring(
	game:HttpGet("https://raw.githubusercontent.com/dawid-scripts/Fluent/master/Addons/InterfaceManager.lua")
)()

local Window = Fluent:CreateWindow({
	Title = "ArcX" .. " | " .. "Anime Last Stand" .. " | " .. "[Version 1.0]",
	SubTitle = "by Archevont.",
	TabWidth = 160,
	Size = Device, --UDim2.fromOffset(480, 360), --default size (580, 460)
	Acrylic = false, -- การเบลออาจตรวจจับได้ การตั้งค่านี้เป็น false จะปิดการเบลอทั้งหมด
	Theme = "Dark", --Amethyst
	MinimizeKey = Enum.KeyCode.RightControl, --RightControl
})

local Tabs = {
	--[[ Tabs --]]
	pageMacro = Window:AddTab({ Title = "Macro", Icon = "rotate-ccw" }),
	pageGame = Window:AddTab({ Title = "Game", Icon = "play" }),
	pageLicense = Window:AddTab({ Title = "License", Icon = "key" }),
	pageSettings = Window:AddTab({ Title = "Settings", Icon = "settings" }),
}

do
	function Notify(text, duration, subcontent)
		Fluent:Notify({
			Title = "Notification",
			Content = text,
			SubContent = subcontent, -- Optional
			Duration = duration, -- Set to nil to make the notification not disappear
		})
	end

	-------------------------------------------------------[[ MACRO PAGE ]]-------------------------------------------------------

	Tabs.pageMacro:AddSection("Macro")

	local function getMacroFileNames()
		local FolderPath = "ArcX" .. "/" .. getgenv().FolderName
		if listfiles and isfolder(FolderPath) then
			local listFilePaths = listfiles(FolderPath)
			local fileNames = {}
			for _, path in ipairs(listFilePaths) do
				if path:lower():match("%.json$") then
					local filename = path:match("([^/\\]+)$")
					local base = filename:gsub("%.json$", "")
					table.insert(fileNames, base)
				end
			end

			return fileNames
		else
			return "None"
		end
	end

	local SelectMacroDropdown = Tabs.pageMacro:AddDropdown("SelectMacroDropdown", {
		Title = "Select Macro",
		Default = getgenv().Settings.MacroName or false,
		Values = getMacroFileNames(),
		Multi = false,
		Callback = function(value)
			if value then
				Notify("Chosen File: " .. value, 5)
				getgenv().Settings.MacroName = value
				SaveSetting()
			end
		end,
	})

	local PlayMacroToggle = Tabs.pageMacro:AddToggle(
		"PlayMacroToggle",
		{ Title = "Play Macro", Default = getgenv().Settings.PlaybackMacro or false }
	)

	local RecordSection = Tabs.pageMacro:AddSection("Record")
	local CreateMacroInput = Tabs.pageMacro:AddInput("CreateMacroInput", {
		Title = "Create Macro",
		Default = nil,
		Finished = true,
		Callback = function(value)
			writefile("ArcX" .. "/" .. getgenv().FolderName .. "/" .. value .. ".json", "ArcX On Top!")
			Notify("Created Macro: " .. value, 5)
		end,
	})

	local RecordMacroToggle = Tabs.pageMacro:AddToggle("RecordMacroToggle", {
		Title = "Record Macro",
	})

	Tabs.pageMacro:AddButton({
		Title = "Refresh Macro List",
		Callback = function()
			SelectMacroDropdown:SetValues(getMacroFileNames())
			Notify("Refreshed Macro List.", 5)
		end,
	})

	Tabs.pageMacro:AddButton({
		Title = "Delete Selected Macro",
		Callback = function()
			delfile("ArcX" .. "/" .. getgenv().FolderName .. "/" .. getgenv().Settings.MacroName .. ".json")
			SelectMacroDropdown:SetValues(getMacroFileNames())
			Notify("Deleted Macro: " .. getgenv().Settings.MacroName, 5)
			getgenv().Settings.MacroName = nil
		end,
	})

	---------------------------------------------// GAME PAGE //-------------------------------------------

	Tabs.pageGame:AddSection("Game")

    local AutoReadyToggle = Tabs.pageGame:AddToggle(
        "AutoReadyToggle",
        { Title = "Auto Ready", Description = "when playing macro only" ,Default = getgenv().Settings.AutoReady or false}
    )

	local AutoRetryToggle = Tabs.pageGame:AddToggle(
		"AutoRetryToggle",
		{ Title = "Auto Retry", Default = getgenv().Settings.AutoRetry or false }
	)

	Tabs.pageGame:AddSection("Halloween")
	local AutoCollectOrbToggle = Tabs.pageGame:AddToggle(
		"AutoCollectOrbToggle",
		{ Title = "Auto Collect Orb", Default = getgenv().Settings.AutoCollectOrb or false }
	)

	--------------------------------------------// LICENSE PAGE //-----------------------------------------

	--------------------------------------------// SERVICES //---------------------------------------------

	local HttpService = game:GetService("HttpService")
	local Player = game:GetService("Players")
	local LocalPlayer = Player.LocalPlayer
	local ReplicatedStorage = game:GetService("ReplicatedStorage")
	local VirtualInputManager = game:GetService("VirtualInputManager")
	local GuiService = game:GetService("GuiService")

	-------------------------------------------// IN-GAME CONSTANTS //-------------------------------------

	local TowersFolder = workspace:WaitForChild("Towers")
	local AbilityRemotes = ReplicatedStorage:WaitForChild("Remotes"):WaitForChild("AbilityRemotes")
	local CollectibleOrbs = workspace:WaitForChild("Collectibles"):WaitForChild("ClientModels")

	------------------------------------------// GAME REQUESTS //------------------------------------------

	local PlaceTowerRequest = ReplicatedStorage:WaitForChild("Remotes"):WaitForChild("PlaceTower") --// [1] = tower name, [2] = position (Vector3)
	local UpgradeRequest = ReplicatedStorage:WaitForChild("Remotes"):WaitForChild("Upgrade") --// [1] = tower instance
	local ChangeTargetingRequest = ReplicatedStorage:WaitForChild("Remotes"):WaitForChild("ChangeTargeting") --// [1] = tower instance, [2] = target type (string)
	local SellRequest = ReplicatedStorage:WaitForChild("Remotes"):WaitForChild("Sell") --// [1] = tower instance
	local AbilityRequest = ReplicatedStorage:WaitForChild("Remotes"):WaitForChild("Ability") --// [1] = tower instance, [2] = ability type (string)
	local AutoAbilityRequest = ReplicatedStorage:WaitForChild("Remotes"):WaitForChild("ToggleAutoUse") --// [1] = tower instance, [2] = Value (string), [3] = boolean
	local AutoUpgradeRequest =
		ReplicatedStorage:WaitForChild("Remotes"):WaitForChild("UnitManager"):WaitForChild("SetAutoUpgrade") --// [1] = tower instance, [2] = boolean
	local SellAllRequest = ReplicatedStorage:WaitForChild("Remotes"):WaitForChild("UnitManager"):WaitForChild("SellAll")
	local ChangeUpgradePriorityRequest =
		ReplicatedStorage:WaitForChild("Remotes"):WaitForChild("UnitManager"):WaitForChild("ChangeAutoPriority") --// [1] = tower instance
	local PlayerReadyRequest = ReplicatedStorage:WaitForChild("Remotes"):WaitForChild("PlayerReady")
	local AbilitySelectionRequest = ReplicatedStorage:WaitForChild("Remotes"):WaitForChild("AbilitySelection") --// [1] = ability index, [2] = ability name (string)
    local SelectUnitInWorkspaceRequest = AbilityRemotes:WaitForChild("SelectUnitInWorkspace") --// [1] = tower instance
    local CFrameSelectionRequest = ReplicatedStorage:WaitForChild("Remotes"):WaitForChild("CFrameSelection") --// [1] = number, [2] = CFrame

	---------------------------------------------// SCRIPT //-----------------------------------------------

	local initialized = false

	local SelectedMacro = {
		Name = getgenv().Settings.MacroName,
		Data = nil,
		Unit = {},
	}
    _G.CurrentMacro = SelectedMacro

	-----------------// GAMEDATA SECTION //------------------

	local function getTimeElapsed()
		if not game.ReplicatedStorage:FindFirstChild("ElapsedTime") then
			return false
		end
		return game.ReplicatedStorage.ElapsedTime.Value
	end

	local function getWave()
		if not game.ReplicatedStorage:FindFirstChild("Wave") then
			return false
		end
		return game.ReplicatedStorage.Wave.Value
	end

	local function getMapName()
		if not game.Workspace:WaitForChild("Map"):FindFirstChild("MapName") then
			return false
		end
		return workspace.Map.MapName.Value
	end

	local function getGameMode()
		if not game.ReplicatedStorage:FindFirstChild("Gamemode") then
			return false
		end
		return game.ReplicatedStorage.Gamemode.Value
	end

	local function isInGame()
		if not getGameMode() and not getMapName() then
			return false
		elseif getGameMode() and getMapName() then
			return true
		end
	end

	-----------------// MACRO RECORDER FUNCTION //------------------

	local function saveMacroToFile(name, data)
		local filePath = "ArcX" .. "/" .. getgenv().FolderName .. "/" .. name .. ".json"
		local jsonData = HttpService:JSONEncode(data)
		writefile(filePath, jsonData)
		print("Macro saved to file:", filePath)
	end

	local function createMacroData(dataName)
		if not isInGame() then
			return false
		end

		local macroData = {
			Map = getMapName(),
			Mode = getGameMode(),
			Index = 0,
			Macro_Data = {},
		}
		saveMacroToFile(dataName, macroData)
		SelectedMacro.Data = macroData
	end

	local function addMacroDataEntry(wave, time, method, position, value, target, unitIndex, unitName)
		if not getgenv().ScriptSettings.RecordMacro then
			return
		end

		local dataEntry = {
			Index = #SelectedMacro.Data.Macro_Data + 1,
			Wave = wave,
			Time = time,
			Method = method,
			Position = position,
			Value = value,
			Target = target,
			UnitIndex = unitIndex,
			UnitName = unitName,
		}
		print("adding macro data entry:", method, position, value, target, unitIndex, unitName)
		table.insert(SelectedMacro.Data.Macro_Data, dataEntry)
	end

	local function findUnitIndex(unitValue)
		for index, unit in pairs(SelectedMacro.Unit) do
			if unitValue == unit then
				return index
			end
		end
	end

	local function arrangeMacroData(data, methodName)
		if not getgenv().ScriptSettings.RecordMacro then
			return
		end
		task.spawn(function()
			local wave = getWave()
			local timeElapsed = getTimeElapsed()
			if methodName == "PlaceTower" then
				addMacroDataEntry(wave, timeElapsed, methodName, data[2], nil, nil, nil, data[1])
			elseif methodName == "Upgrade" then
				local unitIndex = findUnitIndex(data[1])
				addMacroDataEntry(wave, timeElapsed, methodName, nil, nil, nil, unitIndex)
			elseif methodName == "ChangeTargeting" then
				local unitIndex = findUnitIndex(data[1])
				addMacroDataEntry(wave, timeElapsed, methodName, nil, nil, data[2], unitIndex)
			elseif methodName == "Ability" then
				local unitIndex = findUnitIndex(data[1])
				addMacroDataEntry(wave, timeElapsed, methodName, nil, data[2], nil, unitIndex)
			elseif methodName == "ToggleAutoUse" then
				local unitIndex = findUnitIndex(data[1])
				local value = { data[2], data[3] }
				addMacroDataEntry(wave, timeElapsed, methodName, nil, value, nil, unitIndex)
			elseif methodName == "SetAutoUpgrade" then
				local unitIndex = findUnitIndex(data[1])
				addMacroDataEntry(wave, timeElapsed, methodName, nil, data[2], nil, unitIndex)
			elseif methodName == "ChangeAutoPriority" then
				local unitIndex = findUnitIndex(data[1])
				addMacroDataEntry(wave, timeElapsed, methodName, nil, nil, nil, unitIndex)
			elseif methodName == "Sell" then
				local unitIndex = findUnitIndex(data[1])
                addMacroDataEntry(wave, timeElapsed, methodName, nil, nil, nil, unitIndex)
			elseif methodName == "SellAll" then
				addMacroDataEntry(wave, timeElapsed, methodName)
            elseif methodName == "SelectUnitInWorkspace" then
                local unitIndex = findUnitIndex(data[1])
                addMacroDataEntry(wave, timeElapsed, methodName, nil, nil, nil, unitIndex)
            elseif methodName == "CFrameSelection" then
                addMacroDataEntry(wave, timeElapsed, methodName, nil, tostring(data[2]))
            elseif methodName == "AbilitySelection" then
                addMacroDataEntry(wave, timeElapsed, methodName, nil, tostring(data[2]))
			end
		end)
	end

	function recordMacro(dataName)
		if not isInGame() then
			Notify("Record Macro Failed: You are not in game.", 5)
			return
		end

		if getgenv().Settings.PlaybackMacro then
			Notify("Cannot record macro while playing macro.", 5)
		end

		if getgenv().ScriptSettings.RecordMacro then
			getgenv().ScriptSettings.RecordMacro = true
			SelectedMacro.Name = dataName
			createMacroData(dataName)
			SelectedMacro.Unit = {}
		elseif not getgenv().ScriptSettings.RecordMacro then
			getgenv().ScriptSettings.RecordMacro = false
            if SelectedMacro.Data.Macro_Data[#SelectedMacro.Data.Macro_Data] then
                SelectedMacro.Data.Index = SelectedMacro.Data.Macro_Data[#SelectedMacro.Data.Macro_Data].Index
			    saveMacroToFile(dataName, SelectedMacro.Data)
            end
			SelectedMacro.Unit = {}
		end
	end

	RecordMacroToggle:OnChanged(function(value)
		if not initialized then
			return
		end

		getgenv().ScriptSettings.RecordMacro = value

		if getgenv().ScriptSettings.RecordMacro then
			Notify("Recording Macro: " .. getgenv().Settings.MacroName, 5)
			recordMacro(getgenv().Settings.MacroName)
		elseif not getgenv().ScriptSettings.RecordMacro then
			Notify("Recorded Macro: " .. getgenv().Settings.MacroName, 5)
			recordMacro(getgenv().Settings.MacroName)
		end
	end)

	--------------------// MACRO PLAYER FUNCTION //------------------

	local function getMacroData()
		if not getgenv().Settings.MacroName then
			Notify("No Macro Chosen.", 5)
		end
		local filePath = "ArcX" .. "/" .. getgenv().FolderName .. "/" .. getgenv().Settings.MacroName .. ".json"
		if isfile(filePath) then
			local jsonData = readfile(filePath)
			local data = HttpService:JSONDecode(jsonData)
			SelectedMacro.Data = data
			return true
		else
			Notify("Macro file not found: " .. filePath, 5)
			return false
		end
	end

	local AbilityIndex = 0
	local function getAbilityIndex()
		AbilityIndex += 1
		return AbilityIndex
	end

	function playbackMacro()
		task.spawn(function()
			if not getgenv().HookMethod or not getgenv().Settings.PlaybackMacro then
				return
			end

			if getgenv().ScriptSettings.RecordMacro then
				print("Cannot play macro while recording is in progress.")
				return
			end

			if SelectedMacro.Data == nil then
				local getData = getMacroData()
				if not getData then
					Notify("No Data Exist.", 5)
					return
				end
			end

			if not isInGame() then
				Notify("Cannot Play Macro: You are not in game.", 5)
				return
			end

			if getMapName() ~= SelectedMacro.Data.Map then
				Notify("Macro is not match the map.", 5)
				return
			end

			repeat
				task.wait()
			until game:IsLoaded() and game.Players and game.Players.LocalPlayer and game.Players.LocalPlayer.Character

			Notify("Playing Macro: " .. getgenv().Settings.MacroName, 5)
            
            task.wait(0.5)

			if getgenv().Settings.AutoReady == true then
				PlayerReadyRequest:FireServer()
                Notify("Auto Starting...", 5)
			end
			
            task.wait(0.5)

			for index, entry in pairs(SelectedMacro.Data.Macro_Data) do
				if not getgenv().Settings.PlaybackMacro then
					print("Macro playback stopped.")
					break
				end
				-- wait until the specified wave and time
				while getWave() < entry.Wave or (getWave() == entry.Wave and getTimeElapsed() < entry.Time) do
					task.wait(.1)
					if not getgenv().Settings.PlaybackMacro then
						print("Macro playback stopped.")
						break
					end
				end

				-- execute the recorded action
				if entry.Method == "PlaceTower" then
					local positionString = entry.Position
					local positionTable = positionString:split(", ")
					local position = CFrame.new(unpack(positionTable))
					print("Index: " .. tostring(index), "Placing tower:", entry.UnitName, "at", position)
					PlaceTowerRequest:FireServer(entry.UnitName, position)
					print("Placed Tower.")
					task.wait(.5)
				elseif entry.Method == "Upgrade" then
					local unit = SelectedMacro.Unit[entry.UnitIndex]
					if unit then
						print("Index: " .. tostring(index), "Upgrading tower at index:", entry.UnitIndex)
						UpgradeRequest:InvokeServer(unit)
					end
				elseif entry.Method == "ChangeTargeting" then
					local unit = SelectedMacro.Unit[entry.UnitIndex]
					if unit then
						print("Index: " .. tostring(index), "Change Target To: ", entry.Target)
						ChangeTargetingRequest:InvokeServer(unit, entry.Target)
					end
				elseif entry.Method == "Ability" then
					local unit = SelectedMacro.Unit[entry.UnitIndex]
					if unit then
						print("Index: " .. tostring(index), "Using ability: ", entry.Value)
						AbilityRequest:InvokeServer(unit, entry.Value)
						task.wait(.5)
					end
				elseif entry.Method == "ToggleAutoUse" then
					print("Toggle Auto Use Ability: " .. tostring(entry.Value[2]))
					local unit = SelectedMacro.Unit[entry.UnitIndex]
					if unit then
						AutoAbilityRequest:FireServer(unit, entry.Value[1], entry.Value[2])
					end
				elseif entry.Method == "SetAutoUpgrade" then
					local unit = SelectedMacro.Unit[entry.UnitIndex]
					if unit then
						print(
							"Index: " .. tostring(index),
							"Firing AutoUpgradeRequest for unit:",
							unit,
							"with value:",
							entry.Value
						)
						AutoUpgradeRequest:FireServer(unit, entry.Value)
					end
				elseif entry.Method == "ChangeAutoPriority" then
					local unit = SelectedMacro.Unit[entry.UnitIndex]
					if unit then
						print(
							"Index: " .. tostring(index),
							"Changing upgrade priority for unit at index:",
							entry.UnitIndex
						)
						ChangeUpgradePriorityRequest:FireServer(unit)
					end
				elseif entry.Method == "Sell" then
					local unit = SelectedMacro.Unit[entry.UnitIndex]
                    if unit then
                        print("Index: " .. tostring(index), "Selling tower at index:", entry.UnitIndex)
                        SellRequest:InvokeServer(unit)
                    end
				elseif entry.Method == "SellAll" then
					print("Index: " .. tostring(index), "Selling all towers.")
					SellAllRequest:FireServer()
                elseif entry.Method == "SelectUnitInWorkspace" then
                    local unit = SelectedMacro.Unit[entry.UnitIndex]
                    if unit then
                        print("Index: ".. tostring(index), "Selecting unit in workspace: " .. tostring(unit) .. " UnitIndex: " .. tostring(entry.UnitIndex))
						SelectUnitInWorkspaceRequest:FireServer(unit)
						task.wait(.5)
                    else
                        print("WHERE TF IS MY UNIT BRU :SKULL:")
						print(unit, SelectedMacro.Unit[entry.UnitIndex])
						for i, v in next, SelectedMacro.Unit do
							print("Index: " .. i, v)
						end
                    end
                elseif entry.Method == "CFrameSelection" then
                    local positionString = entry.Value
					local positionTable = positionString:split(", ")
					local position = CFrame.new(unpack(positionTable))
                    print("Index: " .. tostring(index), "Using CFrame selection to: " .. tostring(position) .. " AbilityIndex: " .. tostring(AbilityIndex + 1))
                    CFrameSelectionRequest:FireServer(getAbilityIndex(), position)
					task.wait(.5)
                elseif entry.Method == "AbilitySelection" then
                    print("Index: " .. tostring(index), "Selecting Ability: " .. tostring(entry.Value) .. " AbilityIndex: " .. tostring(AbilityIndex + 1))
                    AbilitySelectionRequest:FireServer(getAbilityIndex(), entry.Value)
					task.wait(.5)
                end

			end

			print("Macro playback finished.")
			print("Total Indexes Played:", SelectedMacro.Data.Index)
			SelectedMacro.Unit = {}
		end)
	end	

	--------------------// HOOK METAMETHODS //------------------

	getgenv().HookMethod = false
	local originalNamecall -- will hold the original function returned by hookmetamethod
	local ok, ret = pcall(function()
		if getgenv().HookMethod then
			return
		end
		getgenv().HookMethod = true

		-- create the hook closure (use newcclosure if available)
		local hookFn = newcclosure
			and newcclosure(function(self, ...)
				local method = getnamecallmethod()
				-- only handle remote calls we care about and only when not checkcaller()
				if
					(method == "FireServer" or method == "InvokeServer")
					and (
                        tostring(self) == "Upgrade"
						or tostring(self) == "ChangeTargeting"
						or tostring(self) == "Ability"
						or tostring(self) == "ToggleAutoUse"
						or tostring(self) == "SetAutoUpgrade"
                        or tostring(self) == "Sell"
						or tostring(self) == "SellAll"
						or tostring(self) == "ChangeAutoPriority"
                        or tostring(self) == "SelectUnitInWorkspace"
                        or tostring(self) == "CFrameSelection"
                        or tostring(self) == "AbilitySelection"
					)
				then
					if getgenv().ScriptSettings.RecordMacro then
						local args = { ... }
						local methodName = tostring(self)

						-- run arrangeMacroData on a separate task to avoid hook-thread restrictions
						task.spawn(function()
							-- pass args as a table so arrangeMacroData can use it safely
							arrangeMacroData(args, methodName)
						end)
					end
				end

				-- call the original namecall if it exists
				if type(originalNamecall) == "function" then
					return originalNamecall(self, ...)
				else
					-- fallback: if original doesn't exist, just return nil or try a safe default
					return nil
				end
			end)

		-- hookmetamethod should return the original; store it
		originalNamecall = hookmetamethod(game, "__namecall", hookFn)
		return originalNamecall
	end)

	if not ok then
		warn("hookmetamethod call failed:", ret)
		originalNamecall = nil
	else
		if type(originalNamecall) ~= "function" then
			warn("hookmetamethod didn't return a function; originalNamecall is", type(originalNamecall))
			-- still okay: our hook will fallback to returning nil if original is missing
		else
			print("Hook installed successfully.")
		end
	end

	----------------// DETECT TOWER ADDED & REMOVED //-----------------

	local function isIgnoreUnit(unitName)
		for _, v in next, getgenv().IgnoreUnit do
			if v == unitName then
				return true
			end
		end
		return false
	end

	TowersFolder.ChildAdded:Connect(function(unit)
		if getgenv().ScriptSettings.RecordMacro or getgenv().Settings.PlaybackMacro then
			if unit:IsA("Model") and unit:WaitForChild("Owner").Value == LocalPlayer then
				local unitName = unit.Name
				if isIgnoreUnit(unitName) then
					return
				end

				local position = tostring(unit:GetAttribute("PlacePosition"))
				if SelectedMacro.Unit then
					SelectedMacro.Unit[#SelectedMacro.Unit + 1] = unit
					for i, v in next, SelectedMacro.Unit do
						if v == SelectedMacro.Unit[#SelectedMacro.Unit] then
							print("Added Unit: " .. tostring(unit) .. " to UnitIndex: " .. tostring(i))
						end
					end
				end
				arrangeMacroData({ unitName, position }, "PlaceTower")

			end
		end
	end)

	LocalPlayer.PlayerGui.ChildAdded:Connect(function(gui)
		if getgenv().Settings.AutoRetry then
			if gui and gui:IsA("ScreenGui") and gui.Name == "EndGameUI" then
				print("Detect Gui Added.")
				local retryButton = gui:WaitForChild("BG"):WaitForChild("Buttons"):FindFirstChild("Retry")
				if retryButton and retryButton:IsA("TextButton") then
					print("Retrying...")
					GuiService.SelectedCoreObject = retryButton
					VirtualInputManager:SendKeyEvent(true, Enum.KeyCode.Return, false, game)
					VirtualInputManager:SendKeyEvent(false, Enum.KeyCode.Return, false, game)

					SelectedMacro.Unit = {}
					if getgenv().ScriptSettings.AutoPlayMacro then
						task.wait(5)
						playbackMacro()
					end
				end
			end
		end
	end)

	----------------// MISCELLANEOUS //-----------------

	local function AutoCollectOrb(bool)
		task.spawn(function()
			while getgenv().Settings.AutoCollectOrb and task.wait(1) do
				if not getgenv().Settings.AutoCollectOrb then
					break
				end
				if not getMapName() == "" then
					break
				end

				for _, v in pairs(CollectibleOrbs:GetChildren()) do
					if v:IsA("Part") and v.Name == "Candy" then
						task.wait(1)
						LocalPlayer.Character.HumanoidRootPart.CFrame = v.CFrame
					end
				end
			end
		end)
	end

	----------------// EXECUTE //-----------------

	task.spawn(function()
		while wait(320) do
			pcall(function()
				local anti = game:GetService("VirtualUser")
				game:GetService("Players").LocalPlayer.Idled:Connect(function()
					anti:Button2Down(Vector2.new(0, 0), workspace.CurrentCamera.CFrame)
					task.wait(1)
					anti:Button2Up(Vector2.new(0, 0), workspace.CurrentCamera.CFrame)
				end)
			end)
		end
	end)

    AutoReadyToggle:OnChanged(function(value)
        if not initialized then return end

		getgenv().Settings.AutoReady = value
		SaveSetting()
		Notify("Auto Ready: " .. tostring(getgenv().Settings.AutoReady), 5)
	end)

	AutoRetryToggle:OnChanged(function(value)
        if not initialized then return end

		getgenv().Settings.AutoRetry = value
		SaveSetting()
		Notify("Auto Retry: " .. tostring(getgenv().Settings.AutoRetry), 5)
	end)

	AutoCollectOrbToggle:OnChanged(function(value)
        if not initialized then return end

		getgenv().Settings.AutoCollectOrb = value
		SaveSetting()
		if getgenv().Settings.AutoCollectOrb then
			AutoCollectOrb(true)
			Notify("Auto Collect Orb: " .. tostring(value), 5)
		elseif not getgenv().Settings.AutoCollectOrb then
			AutoCollectOrb(false)
			Notify("Auto Collect Orb: " .. tostring(value), 5)
		end
	end)

	PlayMacroToggle:OnChanged(function(value)
        getgenv().Settings.PlaybackMacro = value
		if getgenv().Settings.PlaybackMacro == true then
			playbackMacro()
		elseif getgenv().Settings.PlaybackMacro == false then
            if not initialized then return end
			Notify("Stopped Playing Macro", 5)
			playbackMacro()
		end
        SaveSetting()
	end)

	initialized = true
end

SaveManager:SetLibrary(Fluent)
InterfaceManager:SetLibrary(Fluent)

SaveManager:IgnoreThemeSettings()

InterfaceManager:SetFolder("ArcX")
SaveManager:SetFolder("ArcX")

InterfaceManager:BuildInterfaceSection(Tabs.pageSettings)
SaveManager:BuildConfigSection(Tabs.pageSettings)

Window:SelectTab(1)

Notify("Script Loaded. - Anime Last Stand 🏯", 5, "ArcX")

SaveManager:LoadAutoloadConfig()
