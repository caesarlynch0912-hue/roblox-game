-- Our own shift lock: press Left Shift to lock the camera behind your character.
-- Roblox's built-in one depends on each player's settings, so we do it ourselves.
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")

local ShiftLock = {}

local CAMERA_OFFSET = Vector3.new(1.75, 0, 0) -- over-the-shoulder, like the real one

function ShiftLock.start()
	local player = Players.LocalPlayer
	local enabled = false

	local function getHumanoid()
		local character = player.Character
		return character and character:FindFirstChildOfClass("Humanoid")
	end

	local function setEnabled(on: boolean)
		enabled = on

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
