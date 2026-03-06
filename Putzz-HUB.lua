--[[ PUTZZHUB STANDALONE (WORKING FEATURES) ]]

repeat task.wait() until game:IsLoaded()

local player = game.Players.LocalPlayer
local char = player.Character or player.CharacterAdded:Wait()
local humanoid = char:WaitForChild("Humanoid")
local root = char:WaitForChild("HumanoidRootPart")

-- GUI
local gui = Instance.new("ScreenGui")
local frame = Instance.new("Frame")
local title = Instance.new("TextLabel")
local btnFly = Instance.new("TextButton")
local btnSpeed = Instance.new("TextButton")

gui.Parent = player:WaitForChild("PlayerGui")

frame.Parent = gui
frame.BackgroundColor3 = Color3.new(0.2,0.2,0.2)
frame.Size = UDim2.new(0,200,0,150)
frame.Position = UDim2.new(0.1,0,0.3,0)
frame.Active = true
frame.Draggable = true

title.Parent = frame
title.Text = "PutzzHUB"
title.Size = UDim2.new(1,0,0,30)
title.BackgroundColor3 = Color3.new(0.1,0.1,0.1)
title.TextColor3 = Color3.new(1,1,0)

btnFly.Parent = frame
btnFly.Text = "Fly OFF"
btnFly.Size = UDim2.new(0.8,0,0,30)
btnFly.Position = UDim2.new(0.1,0,0.3,0)

btnSpeed.Parent = frame
btnSpeed.Text = "Speed OFF"
btnSpeed.Size = UDim2.new(0.8,0,0,30)
btnSpeed.Position = UDim2.new(0.1,0,0.6,0)

-- ======================
-- FLY SYSTEM
-- ======================

local flying = false
local bodyVelocity

btnFly.MouseButton1Click:Connect(function()

    flying = not flying

    if flying then
        btnFly.Text = "Fly ON"

        bodyVelocity = Instance.new("BodyVelocity")
        bodyVelocity.MaxForce = Vector3.new(99999,99999,99999)
        bodyVelocity.Velocity = Vector3.new(0,50,0)
        bodyVelocity.Parent = root

    else
        btnFly.Text = "Fly OFF"

        if bodyVelocity then
            bodyVelocity:Destroy()
        end
    end

end)

-- ======================
-- SPEED SYSTEM
-- ======================

local speedOn = false

btnSpeed.MouseButton1Click:Connect(function()

    speedOn = not speedOn

    if speedOn then
        btnSpeed.Text = "Speed ON"
        humanoid.WalkSpeed = 80
    else
        btnSpeed.Text = "Speed OFF"
        humanoid.WalkSpeed = 16
    end

end)