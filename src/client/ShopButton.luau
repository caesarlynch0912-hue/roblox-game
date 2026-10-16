-- A button at the bottom of the screen for buying speed upgrades.
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Config = require(ReplicatedStorage.Shared.Config)

local ShopButton = {}

function ShopButton.start(gui: ScreenGui)
	local player = Players.LocalPlayer
	local buySpeed = ReplicatedStorage:WaitForChild("BuySpeed")

	local button = Instance.new("TextButton")
	button.AnchorPoint = Vector2.new(0.5, 1)
	button.Position = UDim2.new(0.5, 0, 1, -20)
	button.Size = UDim2.fromOffset(280, 60)
	button.BackgroundColor3 = Color3.fromRGB(60, 180, 90)
	button.Font = Enum.Font.FredokaOne
	button.TextSize = 22
	button.TextColor3 = Color3.new(1, 1, 1)
	button.TextStrokeTransparency = 0.5
	button.AutoButtonColor = true
	button.Parent = gui

	local corner = Instance.new("UICorner")
	corner.CornerRadius = UDim.new(0, 12)
	corner.Parent = button

	local function refresh()
		local level = player:GetAttribute("SpeedLevel") or 0
		if level >= Config.MaxSpeedLevel then
			button.Text = "⚡ Speed MAXED"
			button.BackgroundColor3 = Color3.fromRGB(120, 120, 120)
		else
			button.Text = "⚡ Speed Lv " .. (level + 1) .. " — " .. Config.speedCost(level) .. " coins"
			button.BackgroundColor3 = Color3.fromRGB(60, 180, 90)
		end
	end

	player:GetAttributeChangedSignal("SpeedLevel"):Connect(refresh)
	refresh()

	local busy = false
	button.Activated:Connect(function()
		if busy then
			return
		end
		busy = true

		local ok, message = buySpeed:InvokeServer()
		if not ok then
			-- Flash red with the reason, then go back to normal
			button.Text = message
			button.BackgroundColor3 = Color3.fromRGB(200, 60, 60)
			task.wait(1)
			refresh()
		end

		busy = false
	end)
end

return ShopButton
