-- Tunggu game load
repeat task.wait() until game:IsLoaded()

local player = game.Players.LocalPlayer
local char = player.Character or player.CharacterAdded:Wait()
local humanoid = char:WaitForChild("Humanoid")

-- GUI
local gui = Instance.new("ScreenGui")
gui.Name = "PutzzHub"
gui.Parent = player:WaitForChild("PlayerGui")

local frame = Instance.new("Frame")
frame.Parent = gui
frame.Size = UDim2.new(0,250,0,260)
frame.Position = UDim2.new(0.35,0,0.25,0)
frame.BackgroundColor3 = Color3.fromRGB(35,35,35)
frame.Active = true
frame.Draggable = true

-- Title
local title = Instance.new("TextLabel")
title.Parent = frame
title.Size = UDim2.new(1,0,0,30)
title.BackgroundColor3 = Color3.fromRGB(20,20,20)
title.Text = "PUTZZ HUB"
title.TextColor3 = Color3.new(1,1,1)
title.Font = Enum.Font.GothamBold
title.TextSize = 16

-- Close
local close = Instance.new("TextButton")
close.Parent = frame
close.Size = UDim2.new(0,30,0,30)
close.Position = UDim2.new(1,-30,0,0)
close.Text = "X"
close.BackgroundColor3 = Color3.fromRGB(200,50,50)

close.MouseButton1Click:Connect(function()
gui:Destroy()
end)

-- FLY
local fly = false
local flyBtn = Instance.new("TextButton")
flyBtn.Parent = frame
flyBtn.Size = UDim2.new(0.8,0,0,30)
flyBtn.Position = UDim2.new(0.1,0,0,50)
flyBtn.Text = "FLY OFF"
flyBtn.BackgroundColor3 = Color3.fromRGB(60,60,60)

flyBtn.MouseButton1Click:Connect(function()

fly = not fly

if fly then
flyBtn.Text = "FLY ON"

local bv = Instance.new("BodyVelocity")
bv.MaxForce = Vector3.new(99999,99999,99999)
bv.Parent = char.HumanoidRootPart

spawn(function()
while fly do
bv.Velocity = Vector3.new(0,50,0)
task.wait()
end
bv:Destroy()
end)

else
flyBtn.Text = "FLY OFF"
end

end)

-- SPEED
local speedBtn = Instance.new("TextButton")
speedBtn.Parent = frame
speedBtn.Size = UDim2.new(0.8,0,0,30)
speedBtn.Position = UDim2.new(0.1,0,0,90)
speedBtn.Text = "SPEED"
speedBtn.BackgroundColor3 = Color3.fromRGB(60,60,60)

speedBtn.MouseButton1Click:Connect(function()
humanoid.WalkSpeed = 80
end)

-- NORMAL SPEED
local normalBtn = Instance.new("TextButton")
normalBtn.Parent = frame
normalBtn.Size = UDim2.new(0.8,0,0,30)
normalBtn.Position = UDim2.new(0.1,0,0,130)
normalBtn.Text = "NORMAL SPEED"
normalBtn.BackgroundColor3 = Color3.fromRGB(60,60,60)

normalBtn.MouseButton1Click:Connect(function()
humanoid.WalkSpeed = 16
end)

-- JUMP
local jumpBtn = Instance.new("TextButton")
jumpBtn.Parent = frame
jumpBtn.Size = UDim2.new(0.8,0,0,30)
jumpBtn.Position = UDim2.new(0.1,0,0,170)
jumpBtn.Text = "SUPER JUMP"
jumpBtn.BackgroundColor3 = Color3.fromRGB(60,60,60)

jumpBtn.MouseButton1Click:Connect(function()
humanoid.JumpPower = 120
end)

-- TELEPORT PLAYER
local box = Instance.new("TextBox")
box.Parent = frame
box.Size = UDim2.new(0.8,0,0,30)
box.Position = UDim2.new(0.1,0,0,210)
box.PlaceholderText = "Nama Player"

box.FocusLost:Connect(function()

local target = game.Players:FindFirstChild(box.Text)

if target and target.Character then
char.HumanoidRootPart.CFrame =
target.Character.HumanoidRootPart.CFrame * CFrame.new(0,3,0)
end

box.Text = ""

end)