-- Client entry point. Shows a "+1" popup when the player picks up a coin.
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")

local player = Players.LocalPlayer
local coinCollected = ReplicatedStorage:WaitForChild("CoinCollected")

local gui = Instance.new("ScreenGui")
gui.Name = "CoinPopups"
gui.ResetOnSpawn = false
gui.Parent = player:WaitForChild("PlayerGui")

coinCollected.OnClientEvent:Connect(function(amount: number)
	local label = Instance.new("TextLabel")
	label.Text = "+" .. amount
	label.Font = Enum.Font.FredokaOne
	label.TextSize = 36
	label.TextColor3 = Color3.fromRGB(255, 210, 60)
	label.TextStrokeTransparency = 0
	label.BackgroundTransparency = 1
	label.AnchorPoint = Vector2.new(0.5, 0.5)
	label.Position = UDim2.fromScale(0.5, 0.6)
	label.Size = UDim2.fromOffset(200, 50)
	label.Parent = gui

	local tween = TweenService:Create(label, TweenInfo.new(0.8), {
		Position = UDim2.fromScale(0.5, 0.5),
		TextTransparency = 1,
		TextStrokeTransparency = 1,
	})
	tween:Play()
	tween.Completed:Wait()
	label:Destroy()
end)
