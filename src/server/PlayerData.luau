-- Loads and saves each player's coins and upgrades, and shows coins on the leaderboard.
local DataStoreService = game:GetService("DataStoreService")
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Config = require(ReplicatedStorage.Shared.Config)

-- GetDataStore errors in places that aren't published yet, so the game still runs without saving
local storeOk, store = pcall(function()
	return DataStoreService:GetDataStore(Config.DataStoreName)
end)
if not storeOk then
	warn("Saving is off (publish the place and enable API access to turn it on): " .. tostring(store))
	store = nil
end

local PlayerData = {}

local function keyFor(player: Player)
	return "player_" .. player.UserId
end

local function onPlayerAdded(player: Player)
	local leaderstats = Instance.new("Folder")
	leaderstats.Name = "leaderstats" -- this exact name makes Roblox show the leaderboard
	leaderstats.Parent = player

	local coins = Instance.new("IntValue")
	coins.Name = "Coins"
	coins.Value = Config.StartingCoins
	coins.Parent = leaderstats

	-- Attributes replicate to the client, so the shop UI can read this
	player:SetAttribute("SpeedLevel", 0)

	if not store then
		return
	end

	-- DataStore calls can fail (and don't work in Studio unless API access is on), so wrap in pcall
	local ok, saved = pcall(function()
		return store:GetAsync(keyFor(player))
	end)
	if ok and saved then
		coins.Value = saved.Coins or Config.StartingCoins
		player:SetAttribute("SpeedLevel", saved.SpeedLevel or 0)
	elseif not ok then
		warn("Could not load data for " .. player.Name .. ": " .. tostring(saved))
	end
end

local function save(player: Player)
	local leaderstats = player:FindFirstChild("leaderstats")
	if not store or not leaderstats then
		return
	end

	local ok, err = pcall(function()
		store:SetAsync(keyFor(player), {
			Coins = leaderstats.Coins.Value,
			SpeedLevel = player:GetAttribute("SpeedLevel") or 0,
		})
	end)
	if not ok then
		warn("Could not save data for " .. player.Name .. ": " .. tostring(err))
	end
end

function PlayerData.getCoins(player: Player): number
	local leaderstats = player:FindFirstChild("leaderstats")
	return if leaderstats then leaderstats.Coins.Value else 0
end

function PlayerData.addCoins(player: Player, amount: number)
	local leaderstats = player:FindFirstChild("leaderstats")
	if leaderstats then
		leaderstats.Coins.Value += amount
	end
end

function PlayerData.start()
	Players.PlayerAdded:Connect(onPlayerAdded)
	Players.PlayerRemoving:Connect(save)

	-- Players who joined before this script ran
	for _, player in Players:GetPlayers() do
		task.spawn(onPlayerAdded, player)
	end

	-- Save everyone when the server shuts down
	game:BindToClose(function()
		for _, player in Players:GetPlayers() do
			save(player)
		end
	end)
end

return PlayerData
