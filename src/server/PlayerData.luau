-- Loads and saves each player's coins, and shows them on the leaderboard.
local DataStoreService = game:GetService("DataStoreService")
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Config = require(ReplicatedStorage.Shared.Config)

local store = DataStoreService:GetDataStore(Config.DataStoreName)

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

	-- DataStore calls can fail (and don't work in Studio unless API access is on), so wrap in pcall
	local ok, saved = pcall(function()
		return store:GetAsync(keyFor(player))
	end)
	if ok and saved then
		coins.Value = saved.Coins or Config.StartingCoins
	elseif not ok then
		warn("Could not load data for " .. player.Name .. ": " .. tostring(saved))
	end
end

local function save(player: Player)
	local leaderstats = player:FindFirstChild("leaderstats")
	if not leaderstats then
		return
	end

	local ok, err = pcall(function()
		store:SetAsync(keyFor(player), { Coins = leaderstats.Coins.Value })
	end)
	if not ok then
		warn("Could not save data for " .. player.Name .. ": " .. tostring(err))
	end
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
