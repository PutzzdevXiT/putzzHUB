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
Frame.Size = UDim2.new(0,200,0,220)
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
local flyBtn = createButton("FLY",90)

-- ESP
local espEnabled = false
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

ESPTable[player] = {box,name,dist}

RunService.RenderStepped:Connect(function()

if not espEnabled then
box.Visible = false
name.Visible = false
dist.Visible = false
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