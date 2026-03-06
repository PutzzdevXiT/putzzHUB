--// PUTZZDEV HUB

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local Camera = workspace.CurrentCamera
local LocalPlayer = Players.LocalPlayer

-- GUI
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Parent = game.CoreGui

local MainFrame = Instance.new("Frame")
MainFrame.Parent = ScreenGui
MainFrame.Size = UDim2.new(0,220,0,300)
MainFrame.Position = UDim2.new(0,100,0,100)
MainFrame.BackgroundColor3 = Color3.fromRGB(25,25,25)
MainFrame.Active = true
MainFrame.Draggable = true

-- TITLE
local Title = Instance.new("TextLabel")
Title.Parent = MainFrame
Title.Size = UDim2.new(1,0,0,30)
Title.Text = "Putzzdev-HUB"
Title.BackgroundTransparency = 1
Title.TextColor3 = Color3.fromRGB(0,200,255)
Title.TextScaled = true

-- Scroll
local Scroll = Instance.new("ScrollingFrame")
Scroll.Parent = MainFrame
Scroll.Position = UDim2.new(0,0,0,30)
Scroll.Size = UDim2.new(1,0,1,-30)
Scroll.CanvasSize = UDim2.new(0,0,0,500)
Scroll.ScrollBarThickness = 6
Scroll.BackgroundTransparency = 1

local Layout = Instance.new("UIListLayout")
Layout.Parent = Scroll
Layout.Padding = UDim.new(0,5)

-- Button maker
local function makeButton(text)
	local b = Instance.new("TextButton")
	b.Parent = Scroll
	b.Size = UDim2.new(1,-10,0,40)
	b.Text = text
	b.BackgroundColor3 = Color3.fromRGB(40,40,40)
	b.TextColor3 = Color3.new(1,1,1)
	return b
end

local espBtn = makeButton("ESP PLAYER")
local lineBtn = makeButton("ESP LINE")
local skeletonBtn = makeButton("SKELETON OFF")
local flyBtn = makeButton("FLY")
local speedBtn = makeButton("SPEED OFF")
local noclipBtn = makeButton("NOCLIP OFF")

-- ESP
local espEnabled = false
local lineEnabled = false
local ESPTable = {}

local function createESP(player)

	if player == LocalPlayer then return end

	local box = Drawing.new("Square")
	box.Thickness = 2
	box.Color = Color3.fromRGB(0,255,0)
	box.Filled = false

	local name = Drawing.new("Text")
	name.Size = 16
	name.Color = Color3.new(1,1,1)
	name.Center = true
	name.Outline = true

	local dist = Drawing.new("Text")
	dist.Size = 13
	dist.Color = Color3.new(1,1,1)
	dist.Center = true
	dist.Outline = true

	local line = Drawing.new("Line")
	line.Thickness = 1
	line.Color = Color3.fromRGB(255,255,255)

	ESPTable[player] = {box,name,dist,line}

	RunService.RenderStepped:Connect(function()

		if not espEnabled and not lineEnabled then
			box.Visible = false
			name.Visible = false
			dist.Visible = false
			line.Visible = false
			return
		end

		local char = player.Character
		if char and char:FindFirstChild("HumanoidRootPart") then

			local hrp = char.HumanoidRootPart
			local head = char:FindFirstChild("Head")

			local pos,visible = Camera:WorldToViewportPoint(hrp.Position)

			if visible then

				local top = Camera:WorldToViewportPoint(head.Position + Vector3.new(0,0.5,0))
				local bottom = Camera:WorldToViewportPoint(hrp.Position - Vector3.new(0,3,0))

				local height = math.abs(top.Y - bottom.Y)
				local width = height / 2

				if espEnabled then

					box.Size = Vector2.new(width,height)
					box.Position = Vector2.new(pos.X - width/2, top.Y)
					box.Visible = true

					name.Position = Vector2.new(pos.X, top.Y - 16)
					name.Text = player.Name
					name.Visible = true

					local distance = (LocalPlayer.Character.HumanoidRootPart.Position - hrp.Position).Magnitude
					dist.Position = Vector2.new(pos.X, bottom.Y + 2)
					dist.Text = math.floor(distance).."m"
					dist.Visible = true

				else
					box.Visible = false
					name.Visible = false
					dist.Visible = false
				end

				if lineEnabled then
					line.From = Vector2.new(Camera.ViewportSize.X/2, Camera.ViewportSize.Y)
					line.To = Vector2.new(pos.X,pos.Y)
					line.Visible = true
				else
					line.Visible = false
				end

			else
				box.Visible = false
				name.Visible = false
				dist.Visible = false
				line.Visible = false
			end
		end
	end)
end

for _,p in pairs(Players:GetPlayers()) do
	createESP(p)
end

Players.PlayerAdded:Connect(createESP)

espBtn.MouseButton1Click:Connect(function()
	espEnabled = not espEnabled
end)

lineBtn.MouseButton1Click:Connect(function()
	lineEnabled = not lineEnabled
end)

-- FLY
local fly = false
local speed = 60
local bv
local bg

flyBtn.MouseButton1Click:Connect(function()

	fly = not fly

	local char = LocalPlayer.Character
	local hrp = char:WaitForChild("HumanoidRootPart")

	if fly then

		bv = Instance.new("BodyVelocity")
		bv.MaxForce = Vector3.new(9e9,9e9,9e9)
		bv.Parent = hrp

		bg = Instance.new("BodyGyro")
		bg.MaxTorque = Vector3.new(9e9,9e9,9e9)
		bg.Parent = hrp

		RunService.RenderStepped:Connect(function()

			if fly then
				bg.CFrame = Camera.CFrame
				bv.Velocity = Camera.CFrame.LookVector * speed
			end

		end)

	else

		if bv then bv:Destroy() end
		if bg then bg:Destroy() end

	end

end)

-- SPEED
local speedEnabled = false
local normalSpeed = 16
local fastSpeed = 60

speedBtn.MouseButton1Click:Connect(function()

	speedEnabled = not speedEnabled

	local humanoid = LocalPlayer.Character:FindFirstChildOfClass("Humanoid")

	if humanoid then
		if speedEnabled then
			humanoid.WalkSpeed = fastSpeed
			speedBtn.Text = "SPEED ON"
		else
			humanoid.WalkSpeed = normalSpeed
			speedBtn.Text = "SPEED OFF"
		end
	end

end)

-- NOCLIP
local noclipEnabled = false

noclipBtn.MouseButton1Click:Connect(function()

	noclipEnabled = not noclipEnabled

	if noclipEnabled then
		noclipBtn.Text = "NOCLIP ON"
	else
		noclipBtn.Text = "NOCLIP OFF"
	end

end)

RunService.Stepped:Connect(function()

	if noclipEnabled and LocalPlayer.Character then
		for _,v in pairs(LocalPlayer.Character:GetDescendants()) do
			if v:IsA("BasePart") then
				v.CanCollide = false
			end
		end
	end

end)