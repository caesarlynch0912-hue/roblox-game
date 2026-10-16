-- Game settings shared by server and client. Tweak these to change the feel of the game.
local Config = {
	DataStoreName = "PlayerData_v1",
	StartingCoins = 0,

	CoinValue = 1,
	MaxCoins = 25, -- max coins in the world at once
	CoinSpawnInterval = 2, -- seconds between spawns
	CoinSpawnRadius = 100, -- studs from the center of the map
}

return Config
