-- Spawns spinning coins around the map. Touching one gives the player coins.
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Config = require(ReplicatedStorage.Shared.Config)

local CoinSpawner = {}

local coinsFolder = Instance.new("Folder")
coinsFolder.Name = "Coins"
coinsFolder.Parent = workspace

local function makeCoin(position: Vector3)
	local coin = Instance.new("Part")
	coin.Name = "Coin"
	coin.Shape = Enum.PartType.Cylinder
	coin.Size = Vector3.new(0.4, 3, 3)
	coin.Color = Color3.fromRGB(255, 200, 40)
	coin.Material = Enum.Material.Neon
	coin.Anchored = true
	coin.CanCollide = false
	coin.CFrame = CFrame.new(position) * CFrame.Angles(0, 0, math.rad(90))
	coin.Parent = coinsFolder
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
				local coin = makeCoin(randomSpawnPosition())
				local collected = false

				coin.Touched:Connect(function(hit)
					if collected then
						return
					end
					local player = Players:GetPlayerFromCharacter(hit.Parent)
					if player then
						collected = true
						coin:Destroy()
						PlayerData.addCoins(player, Config.CoinValue)
						coinCollected:FireClient(player, Config.CoinValue)
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
