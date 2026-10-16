-- Spawns spinning coins around the map. Touching one gives the player coins.
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Config = require(ReplicatedStorage.Shared.Config)

local CoinSpawner = {}

local coinsFolder = Instance.new("Folder")
coinsFolder.Name = "Coins"
coinsFolder.Parent = workspace

local totalWeight = 0
for _, coinType in Config.CoinTypes do
	totalWeight += coinType.Weight
end

local function pickCoinType()
	local roll = math.random() * totalWeight
	for _, coinType in Config.CoinTypes do
		roll -= coinType.Weight
		if roll <= 0 then
			return coinType
		end
	end
	return Config.CoinTypes[1]
end

local function makeCoin(coinType, position: Vector3)
	local coin = Instance.new("Part")
	coin.Name = coinType.Name .. "Coin"
	coin.Shape = Enum.PartType.Cylinder
	coin.Size = Vector3.new(0.4, coinType.Size, coinType.Size)
	coin.Color = coinType.Color
	coin.Material = Enum.Material.Neon
	coin.Anchored = true
	coin.CanCollide = false
	coin.CFrame = CFrame.new(position) * CFrame.Angles(0, 0, math.rad(90))
	coin.Parent = coinsFolder

	-- Rare coins glow so they're easy to spot
	if coinType.Value > 1 then
		local light = Instance.new("PointLight")
		light.Color = coinType.Color
		light.Range = 12
		light.Brightness = 2
		light.Parent = coin
	end

	return coin
end

local function randomSpawnPosition()
	local r = Config.CoinSpawnRadius
	return Vector3.new(math.random(-r, r), 3, math.random(-r, r))
end

function CoinSpawner.start(PlayerData, coinCollected: RemoteEvent)
	-- Spawn loop
	task.spawn(function()
		while true do
			if #coinsFolder:GetChildren() < Config.MaxCoins then
				local coinType = pickCoinType()
				local coin = makeCoin(coinType, randomSpawnPosition())
				local collected = false

				coin.Touched:Connect(function(hit)
					if collected then
						return
					end
					local player = Players:GetPlayerFromCharacter(hit.Parent)
					if player then
						collected = true
						coin:Destroy()
						PlayerData.addCoins(player, coinType.Value)
						coinCollected:FireClient(player, coinType.Value, coinType.Color)
					end
				end)
			end
			task.wait(Config.CoinSpawnInterval)
		end
	end)

	-- Spin every coin
	task.spawn(function()
		while true do
			local dt = task.wait()
			for _, coin in coinsFolder:GetChildren() do
				coin.CFrame *= CFrame.Angles(dt * 3, 0, 0)
			end
		end
	end)
end

return CoinSpawner
