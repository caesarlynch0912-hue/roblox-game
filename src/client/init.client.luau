-- Client entry point. Starts every client system.
local Players = game:GetService("Players")

local gui = Instance.new("ScreenGui")
gui.Name = "GameUI"
gui.ResetOnSpawn = false
gui.Parent = Players.LocalPlayer:WaitForChild("PlayerGui")

require(script.CoinPopups).start(gui)
require(script.ShopButton).start(gui)
require(script.ShiftLock).start(gui)
