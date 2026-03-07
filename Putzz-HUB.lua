--// PUTZZDEV HUB (with Health Bar)

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local Camera = workspace.CurrentCamera
local LocalPlayer = Players.LocalPlayer

-- GUI
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Parent = game.CoreGui

-- BUTTON OPEN
local Open = Instance.new("TextButton")
Open.Parent = ScreenGui
Open.Size = UDim2.new(0,50,0,50)
Open.Position = UDim2.new(0,20,0.4,0)
Open.Text = "P"
Open.BackgroundColor3 = Color3.fromRGB(0,170,255)
Open.TextColor3 = Color3.new(1,1,1)
Open.TextScaled = true

-- MAIN MENU
local MainFrame = Instance.new("Frame")
MainFrame.Parent = ScreenGui
MainFrame.Size = UDim2.new(0,220,0,350)  -- Tinggi ditambah untuk button baru
MainFrame.Position = UDim2.new(0,100,0,100)
MainFrame.BackgroundColor3 = Color3.fromRGB(25,25,25)
MainFrame.Active = true
MainFrame.Draggable = true
MainFrame.Visible = true

Open.MouseButton1Click:Connect(function()
	MainFrame.Visible = not MainFrame.Visible
end)

-- TITLE
local Title = Instance.new("TextLabel")
Title.Parent = MainFrame
Title.Size = UDim2.new(1,0,0,30)
Title.Text = "Putzzdev-HUB"
Title.BackgroundTransparency = 1
Title.TextColor3 = Color3.fromRGB(0,200,255)
Title.TextScaled = true

-- SCROLL
local Scroll = Instance.new("ScrollingFrame")
Scroll.Parent = MainFrame
Scroll.Position = UDim2.new(0,0,0,30)
Scroll.Size = UDim2.new(1,0,1,-30)
Scroll.CanvasSize = UDim2.new(0,0,0,500)  -- Canvas diperbesar
Scroll.ScrollBarThickness = 6
Scroll.BackgroundTransparency = 1

local Layout = Instance.new("UIListLayout")
Layout.Parent = Scroll
Layout.Padding = UDim.new(0,5)

-- BUTTON MAKER
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
local healthBtn = makeButton("HEALTH BAR OFF")  -- Tombol baru
local flyBtn = makeButton("FLY")
local speedBtn = makeButton("SPEED OFF")
local noclipBtn = makeButton("NOCLIP OFF")

-- ESP
local espEnabled = false
local lineEnabled = false
local healthEnabled = false  -- Variabel baru
local ESPTable = {}

local function createESP(player)
	if player == LocalPlayer then return end

	-- Box
	local box = Drawing.new("Square")
	box.Thickness = 2
	box.Color = Color3.fromRGB(0,255,0)
	box.Filled = false

	-- Nama
	local name = Drawing.new("Text")
	name.Size = 16
	name.Color = Color3.new(1,1,1)
	name.Center = true
	name.Outline = true

	-- Jarak
	local dist = Drawing.new("Text")
	dist.Size = 13
	dist.Color = Color3.new(1,1,1)
	dist.Center = true
	dist.Outline = true

	-- Line
	local line = Drawing.new("Line")
	line.Thickness = 1
	line.Color = Color3.fromRGB(255,255,255)

	-- Health bar (background dan foreground)
	local healthBg = Drawing.new("Square")
	healthBg.Thickness = 1
	healthBg.Color = Color3.fromRGB(30,30,30)
	healthBg.Filled = true

	local healthFg = Drawing.new("Square")
	healthFg.Thickness = 0
	healthFg.Color = Color3.fromRGB(0,255,0)
	healthFg.Filled = true

	ESPTable[player] = {box, name, dist, line, healthBg, healthFg}
end

RunService.RenderStepped:Connect(function()
	for player, esp in pairs(ESPTable) do
		local box, name, dist, line, healthBg, healthFg = unpack(esp)

		local char = player.Character
		if char and char:FindFirstChild("HumanoidRootPart") and char:FindFirstChild("Head") then
			local hrp = char.HumanoidRootPart
			local head = char.Head
			local humanoid = char:FindFirstChildOfClass("Humanoid")

			local pos, visible = Camera:WorldToViewportPoint(hrp.Position)

			if visible then
				local top = Camera:WorldToViewportPoint(head.Position + Vector3.new(0,0.5,0))
				local bottom = Camera:WorldToViewportPoint(hrp.Position - Vector3.new(0,3,0))

				local height = math.abs(top.Y - bottom.Y)
				local width = height / 2

				-- ESP Box
				if espEnabled then
					box.Size = Vector2.new(width, height)
					box.Position = Vector2.new(pos.X - width/2, top.Y)
					box.Visible = true

					name.Position = Vector2.new(pos.X, top.Y - 16)
					name.Text = player.Name
					name.Visible = true

					local myChar = LocalPlayer.Character
					if myChar and myChar:FindFirstChild("HumanoidRootPart") then
						local distance = (myChar.HumanoidRootPart.Position - hrp.Position).Magnitude
						dist.Text = math.floor(distance).."m"
						dist.Position = Vector2.new(pos.X, bottom.Y + 2)
						dist.Visible = true
					end
				else
					box.Visible = false
					name.Visible = false
					dist.Visible = false
				end

				-- Health Bar
				if healthEnabled and humanoid then
					local healthPercent = humanoid.Health / humanoid.MaxHealth
					local barWidth = width * 0.8
					local barHeight = 4
					local barX = pos.X - barWidth/2
					local barY = top.Y - 20  -- Di bawah nama

					-- Background
					healthBg.Size = Vector2.new(barWidth, barHeight)
					healthBg.Position = Vector2.new(barX, barY)
					healthBg.Visible = true

					-- Foreground
					healthFg.Size = Vector2.new(barWidth * healthPercent, barHeight)
					healthFg.Position = Vector2.new(barX, barY)
					healthFg.Color = Color3.fromRGB(255 * (1 - healthPercent), 255 * healthPercent, 0)
					healthFg.Visible = true
				else
					healthBg.Visible = false
					healthFg.Visible = false
				end

				-- Line
				if lineEnabled then
					line.From = Vector2.new(Camera.ViewportSize.X/2, 0)
					line.To = Vector2.new(pos.X, pos.Y)
					line.Visible = true
				else
					line.Visible = false
				end

			else
				box.Visible = false
				name.Visible = false
				dist.Visible = false
				line.Visible = false
				healthBg.Visible = false
				healthFg.Visible = false
			end
		end
	end
end)

for _, p in pairs(Players:GetPlayers()) do
	createESP(p)
end

Players.PlayerAdded:Connect(createESP)

espBtn.MouseButton1Click:Connect(function()
	espEnabled = not espEnabled
end)

lineBtn.MouseButton1Click:Connect(function()
	lineEnabled = not lineEnabled
end)

healthBtn.MouseButton1Click:Connect(function()
	healthEnabled = not healthEnabled
	healthBtn.Text = healthEnabled and "HEALTH BAR ON" or "HEALTH BAR OFF"
end)

-- FLY
local fly = false
local speed = 60
local bv
local bg

flyBtn.MouseButton1Click:Connect(function()
	fly = not fly
	local char = LocalPlayer.Character
	if not char then return end
	local hrp = char:FindFirstChild("HumanoidRootPart")
	if not hrp then return end

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
	local humanoid = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
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
	noclipBtn.Text = noclipEnabled and "NOCLIP ON" or "NOCLIP OFF"
end)

RunService.Stepped:Connect(function()
	if noclipEnabled and LocalPlayer.Character then
		for _, v in pairs(LocalPlayer.Character:GetDescendants()) do
			if v:IsA("BasePart") then
				v.CanCollide = false
			end
		end
	end
end)