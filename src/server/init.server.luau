-- Server entry point. Starts every server system.
local ReplicatedStorage = game:GetService("ReplicatedStorage")

-- RemoteEvent the server fires to tell a player they picked up a coin
local coinCollected = Instance.new("RemoteEvent")
coinCollected.Name = "CoinCollected"
coinCollected.Parent = ReplicatedStorage

local PlayerData = require(script.PlayerData)
local CoinSpawner = require(script.CoinSpawner)

PlayerData.start()
CoinSpawner.start(PlayerData, coinCollected)
