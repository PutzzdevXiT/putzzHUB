--// PUTZZDEV HUB

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local Camera = workspace.CurrentCamera
local LocalPlayer = Players.LocalPlayer

-- GUI
local ScreenGui = Instance.new("ScreenGui", game.CoreGui)

local Open = Instance.new("TextButton")
Open.Parent = ScreenGui
Open.Size = UDim2.new(0,50,0,50)
Open.Position = UDim2.new(0,20,0.4,0)
Open.Text = "P"
Open.BackgroundColor3 = Color3.fromRGB(0,170,255)
Open.TextColor3 = Color3.new(1,1,1)
Open.TextScaled = true

local Frame = Instance.new("Frame")
Frame.Parent = ScreenGui
Frame.Size = UDim2.new(0,200,0,260)
Frame.Position = UDim2.new(0,80,0.35,0)
Frame.BackgroundColor3 = Color3.fromRGB(20,20,20)
Frame.Visible = false

Open.MouseButton1Click:Connect(function()
Frame.Visible = not Frame.Visible
end)

-- TITLE
local Title = Instance.new("TextLabel")
Title.Parent = Frame
Title.Size = UDim2.new(1,0,0,35)
Title.BackgroundTransparency = 1
Title.Text = "Putzzdev-HUB"
Title.TextColor3 = Color3.fromRGB(0,200,255)
Title.TextScaled = true

-- BUTTON CREATOR
local function createButton(text,y)
local b = Instance.new("TextButton")
b.Parent = Frame
b.Size = UDim2.new(1,-10,0,40)
b.Position = UDim2.new(0,5,0,y)
b.Text = text
b.BackgroundColor3 = Color3.fromRGB(40,40,40)
b.TextColor3 = Color3.new(1,1,1)
return b
end

local espBtn = createButton("ESP PLAYER",40)
local lineBtn = createButton("ESP LINE",90)
local flyBtn = createButton("FLY",140)
local speedBtn = createButton("SPEED",190)
local skeletonBtn = createButton("SKELETON",190)

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

-- ESP LINE
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

-- BOX
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

-- LINE
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
local cam = workspace.CurrentCamera
bg.CFrame = cam.CFrame
bv.Velocity = cam.CFrame.LookVector * speed
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

-- ESP SKELETON
local ESP_SKELETON = false
local skeletonLines = {}

function ToggleSkeleton()
ESP_SKELETON = not ESP_SKELETON

if not ESP_SKELETON then
for i,v in pairs(skeletonLines) do
v:Remove()
end
skeletonLines = {}
end
end

local function drawLine(a,b)

local line = Drawing.new("Line")
line.Thickness = 2
line.Color = Color3.fromRGB(0,255,0)
line.Transparency = 1

game:GetService("RunService").RenderStepped:Connect(function()

if not ESP_SKELETON then
line.Visible = false
return
end

if a.Parent and b.Parent then

local ap,vis1 = workspace.CurrentCamera:WorldToViewportPoint(a.Position)
local bp,vis2 = workspace.CurrentCamera:WorldToViewportPoint(b.Position)

if vis1 and vis2 then
line.From = Vector2.new(ap.X,ap.Y)
line.To = Vector2.new(bp.X,bp.Y)
line.Visible = true
else
line.Visible = false
end

end

end)

table.insert(skeletonLines,line)

end