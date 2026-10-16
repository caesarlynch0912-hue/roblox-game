-- Shows a "+N" popup in the coin's color when the player picks up a coin.
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")

local CoinPopups = {}

function CoinPopups.start(gui: ScreenGui)
	local coinCollected = ReplicatedStorage:WaitForChild("CoinCollected")

	coinCollected.OnClientEvent:Connect(function(amount: number, color: Color3)
		local label = Instance.new("TextLabel")
		label.Text = "+" .. amount
		label.Font = Enum.Font.FredokaOne
		label.TextSize = if amount >= 10 then 56 else 36 -- big coins get big popups
		label.TextColor3 = color
		label.TextStrokeTransparency = 0
		label.BackgroundTransparency = 1
		label.AnchorPoint = Vector2.new(0.5, 0.5)
		label.Position = UDim2.fromScale(0.5 + (math.random() - 0.5) * 0.1, 0.6)
		label.Size = UDim2.fromOffset(200, 60)
		label.Parent = gui

		local tween = TweenService:Create(label, TweenInfo.new(0.8), {
			Position = label.Position - UDim2.fromScale(0, 0.1),
			TextTransparency = 1,
			TextStrokeTransparency = 1,
		})
		tween:Play()
		tween.Completed:Wait()
		label:Destroy()
	end)
end

return CoinPopups
