-- Game settings shared by server and client. Tweak these to change the feel of the game.
local Config = {
	DataStoreName = "PlayerData_v1",
	StartingCoins = 0,

	MaxCoins = 25, -- max coins in the world at once
	CoinSpawnInterval = 2, -- seconds between spawns
	CoinSpawnRadius = 100, -- studs from the center of the map

	-- Coin types. Weight = how often it spawns compared to the others.
	CoinTypes = {
		{ Name = "Gold", Value = 1, Weight = 80, Size = 3, Color = Color3.fromRGB(255, 200, 40) },
		{ Name = "Silver", Value = 3, Weight = 15, Size = 3.5, Color = Color3.fromRGB(200, 220, 255) },
		{ Name = "Diamond", Value = 10, Weight = 5, Size = 4.5, Color = Color3.fromRGB(80, 220, 255) },
	},

	-- Speed upgrade shop
	BaseWalkSpeed = 16, -- Roblox default
	SpeedPerLevel = 2,
	MaxSpeedLevel = 10,
	SpeedBaseCost = 10,
	SpeedCostMultiplier = 1.5, -- each level costs this much more than the last
}

function Config.speedCost(level: number): number
	-- Cost to buy the next level when you're currently at `level`
	return math.floor(Config.SpeedBaseCost * Config.SpeedCostMultiplier ^ level)
end

return Config
