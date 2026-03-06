--[[ PUTZZHUB MOBILE PRO VERSION ]]

local player = game.Players.LocalPlayer
local char = player.Character or player.CharacterAdded:Wait()
local humanoid = char:WaitForChild("Humanoid")
local root = char:WaitForChild("HumanoidRootPart")

local flying = false
local speedOn = false
local espOn = false
local flySpeed = 70

local RunService = game:GetService("RunService")

-- GUI
local gui = Instance.new("ScreenGui",player.PlayerGui)
gui.ResetOnSpawn = false

local frame = Instance.new("Frame",gui)
frame.BackgroundColor3 = Color3.fromRGB(30,30,30)
frame.Size = UDim2.new(0,200,0,200)
frame.Position = UDim2.new(0.1,0,0.3,0)
frame.Active = true
frame.Draggable = true

local title = Instance.new("TextLabel",frame)
title.Size = UDim2.new(1,0,0,30)
title.BackgroundColor3 = Color3.fromRGB(20,20,20)
title.Text = "Putzzdev-HUB"
title.TextColor3 = Color3.fromRGB(255,255,0)

-- OPEN CLOSE
local toggleBtn = Instance.new("TextButton",gui)
toggleBtn.Size = UDim2.new(0,60,0,30)
toggleBtn.Position = UDim2.new(0,10,0.5,0)
toggleBtn.Text = "CLOSE"
toggleBtn.BackgroundColor3 = Color3.fromRGB(40,40,40)

local menuOpen = true
toggleBtn.MouseButton1Click:Connect(function()
	menuOpen = not menuOpen
	frame.Visible = menuOpen
	toggleBtn.Text = menuOpen and "CLOSE" or "OPEN"
end)

-- BUTTONS
local btnFly = Instance.new("TextButton",frame)
btnFly.Text = "Fly OFF"
btnFly.Size = UDim2.new(0.8,0,0,30)
btnFly.Position = UDim2.new(0.1,0,0.25,0)

local btnSpeed = Instance.new("TextButton",frame)
btnSpeed.Text = "Speed OFF"
btnSpeed.Size = UDim2.new(0.8,0,0,30)
btnSpeed.Position = UDim2.new(0.1,0,0.5,0)

local btnESP = Instance.new("TextButton",frame)
btnESP.Text = "ESP OFF"
btnESP.Size = UDim2.new(0.8,0,0,30)
btnESP.Position = UDim2.new(0.1,0,0.75,0)

-- FLY SYSTEM (Camera Control)
local bv

btnFly.MouseButton1Click:Connect(function()

	flying = not flying

	if flying then

		btnFly.Text = "Fly ON"

		bv = Instance.new("BodyVelocity")
		bv.MaxForce = Vector3.new(1e6,1e6,1e6)
		bv.Parent = root

		humanoid.PlatformStand = true

		RunService.RenderStepped:Connect(function()

			if flying and bv then

				local cam = workspace.CurrentCamera
				local dir = humanoid.MoveDirection

				bv.Velocity =
				(cam.CFrame.LookVector * dir.Z +
				cam.CFrame.RightVector * dir.X) * flySpeed

			end

		end)

	else

		btnFly.Text = "Fly OFF"

		if bv then
			bv:Destroy()
		end

		humanoid.PlatformStand = false

	end

end)

-- SPEED
btnSpeed.MouseButton1Click:Connect(function()

	speedOn = not speedOn

	if speedOn then
		btnSpeed.Text = "Speed ON"
		humanoid.WalkSpeed = 60
	else
		btnSpeed.Text = "Speed OFF"
		humanoid.WalkSpeed = 16
	end

end)

-- ESP
local espFolder = Instance.new("Folder",gui)

local function createESP(plr)

	if plr == player then return end

	local c = plr.Character
	if not c then return end

	local head = c:FindFirstChild("Head")
	local hrp = c:FindFirstChild("HumanoidRootPart")

	if not head or not hrp then return end

	local billboard = Instance.new("BillboardGui")
	billboard.Adornee = head
	billboard.Size = UDim2.new(4,0,5,0)
	billboard.AlwaysOnTop = true
	billboard.Parent = espFolder

	local box = Instance.new("Frame",billboard)
	box.Size = UDim2.new(1,0,1,0)
	box.BackgroundTransparency = 1
	box.BorderSizePixel = 2
	box.BorderColor3 = Color3.fromRGB(255,0,0)

	local label = Instance.new("TextLabel",billboard)
	label.Size = UDim2.new(1,0,0.2,0)
	label.Position = UDim2.new(0,0,-0.2,0)
	label.BackgroundTransparency = 1
	label.TextColor3 = Color3.new(1,1,1)
	label.TextScaled = true

	RunService.RenderStepped:Connect(function()

		if espOn and hrp and root then
			local dist = (root.Position - hrp.Position).Magnitude
			label.Text = plr.Name.." ["..math.floor(dist).."m]"
		end

	end)

end

btnESP.MouseButton1Click:Connect(function()

	espOn = not espOn

	if espOn then

		btnESP.Text = "ESP ON"

		for _,plr in pairs(game.Players:GetPlayers()) do
			createESP(plr)
		end

	else

		btnESP.Text = "ESP OFF"
		espFolder:ClearAllChildren()

	end

end)