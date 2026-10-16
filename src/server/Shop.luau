-- Handles buying upgrades. The server checks everything; the client only asks.
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Config = require(ReplicatedStorage.Shared.Config)

local Shop = {}

local function applySpeed(player: Player)
	local character = player.Character
	local humanoid = character and character:FindFirstChildOfClass("Humanoid")
	if humanoid then
		local level = player:GetAttribute("SpeedLevel") or 0
		humanoid.WalkSpeed = Config.BaseWalkSpeed + level * Config.SpeedPerLevel
	end
end

local function onPlayerAdded(player: Player)
	player.CharacterAdded:Connect(function(character)
		character:WaitForChild("Humanoid")
		applySpeed(player)
	end)
	player:GetAttributeChangedSignal("SpeedLevel"):Connect(function()
		applySpeed(player)
	end)
	applySpeed(player)
end

function Shop.start(PlayerData)
	local buySpeed = Instance.new("RemoteFunction")
	buySpeed.Name = "BuySpeed"
	buySpeed.Parent = ReplicatedStorage

	-- Returns (success, message) to the client
	buySpeed.OnServerInvoke = function(player: Player)
		local level = player:GetAttribute("SpeedLevel") or 0
		if level >= Config.MaxSpeedLevel then
			return false, "Max level!"
		end

		local cost = Config.speedCost(level)
		if PlayerData.getCoins(player) < cost then
			return false, "Need " .. cost .. " coins"
		end

		PlayerData.addCoins(player, -cost)
		player:SetAttribute("SpeedLevel", level + 1)
		return true, "Speed up!"
	end

	Players.PlayerAdded:Connect(onPlayerAdded)
	for _, player in Players:GetPlayers() do
		task.spawn(onPlayerAdded, player)
	end
end

return Shop
