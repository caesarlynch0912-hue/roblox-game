-- Our own shift lock: press Left Shift to lock the camera behind your character.
-- Roblox's built-in one depends on each player's settings, so we do it ourselves.
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")

local ShiftLock = {}

local CAMERA_OFFSET = Vector3.new(1.75, 0, 0) -- over-the-shoulder, like the real one

function ShiftLock.start(gui: ScreenGui)
	local player = Players.LocalPlayer
	local enabled = false

	-- Small icon in the corner so you can tell when it's on
	local icon = Instance.new("TextLabel")
	icon.AnchorPoint = Vector2.new(1, 1)
	icon.Position = UDim2.new(1, -20, 1, -20)
	icon.Size = UDim2.fromOffset(130, 36)
	icon.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
	icon.BackgroundTransparency = 0.3
	icon.Font = Enum.Font.FredokaOne
	icon.TextSize = 18
	icon.TextColor3 = Color3.new(1, 1, 1)
	icon.Text = "🔓 Shift Lock"
	icon.Parent = gui

	local corner = Instance.new("UICorner")
	corner.CornerRadius = UDim.new(0, 8)
	corner.Parent = icon

	local function getHumanoid()
		local character = player.Character
		return character and character:FindFirstChildOfClass("Humanoid")
	end

	local function setEnabled(on: boolean)
		enabled = on
		icon.Text = if on then "🔒 Shift Lock" else "🔓 Shift Lock"
		icon.BackgroundColor3 = if on then Color3.fromRGB(60, 140, 220) else Color3.fromRGB(30, 30, 30)

		local humanoid = getHumanoid()
		if humanoid then
			humanoid.AutoRotate = not on
			humanoid.CameraOffset = if on then CAMERA_OFFSET else Vector3.zero
		end
		if not on then
			UserInputService.MouseBehavior = Enum.MouseBehavior.Default
		end
	end

	UserInputService.InputBegan:Connect(function(input, typing)
		if typing then
			return -- don't toggle while typing in chat
		end
		if input.KeyCode == Enum.KeyCode.LeftShift then
			setEnabled(not enabled)
		end
	end)

	-- Re-apply after respawning
	player.CharacterAdded:Connect(function(character)
		character:WaitForChild("Humanoid")
		setEnabled(enabled)
	end)

	-- Runs right after the camera updates each frame
	RunService:BindToRenderStep("ShiftLock", Enum.RenderPriority.Camera.Value + 1, function()
		if not enabled then
			return
		end

		-- The default camera scripts reset this, so set it every frame
		UserInputService.MouseBehavior = Enum.MouseBehavior.LockCenter

		local character = player.Character
		local root = character and character:FindFirstChild("HumanoidRootPart")
		if root then
			-- Turn the character to face where the camera looks (only left/right)
			local look = workspace.CurrentCamera.CFrame.LookVector
			local flat = Vector3.new(look.X, 0, look.Z)
			if flat.Magnitude > 0.01 then
				root.CFrame = CFrame.lookAt(root.Position, root.Position + flat)
			end
		end
	end)
end

return ShiftLock
