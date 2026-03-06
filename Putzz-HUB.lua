--[[ 
    PUTZZHUB MOBILE PRO VERSION (FULL UPGRADE)
    - ESP box + health + jarak + nama
    - Fly admin style (WASD + Space/Ctrl) + tombol layar
    - Slider kecepatan terbang
    - Tetap mempertahankan semua fitur asli
]]

local player = game.Players.LocalPlayer
local char = player.Character or player.CharacterAdded:Wait()
local humanoid = char:WaitForChild("Humanoid")
local root = char:WaitForChild("HumanoidRootPart")

local flying = false
local speedOn = false
local espOn = false
local flySpeed = 70

local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")

-- GUI
local gui = Instance.new("ScreenGui", player.PlayerGui)
gui.ResetOnSpawn = false

local frame = Instance.new("Frame", gui)
frame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
frame.Size = UDim2.new(0, 220, 0, 320)  -- diperbesar sedikit
frame.Position = UDim2.new(0.1, 0, 0.3, 0)
frame.Active = true
frame.Draggable = true

local title = Instance.new("TextLabel", frame)
title.Size = UDim2.new(1, 0, 0, 30)
title.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
title.Text = "Putzzdev-HUB PRO"
title.TextColor3 = Color3.fromRGB(255, 255, 0)
title.Font = Enum.Font.GothamBold

-- OPEN/CLOSE BUTTON (tetap)
local toggleBtn = Instance.new("TextButton", gui)
toggleBtn.Size = UDim2.new(0, 60, 0, 30)
toggleBtn.Position = UDim2.new(0, 10, 0.5, 0)
toggleBtn.Text = "CLOSE"
toggleBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 40)

local menuOpen = true
toggleBtn.MouseButton1Click:Connect(function()
    menuOpen = not menuOpen
    frame.Visible = menuOpen
    toggleBtn.Text = menuOpen and "CLOSE" or "OPEN"
end)

-- BUTTONS ASLI (posisi disesuaikan)
local btnFly = Instance.new("TextButton", frame)
btnFly.Text = "Fly OFF"
btnFly.Size = UDim2.new(0.8, 0, 0, 30)
btnFly.Position = UDim2.new(0.1, 0, 0.15, 0)

local btnSpeed = Instance.new("TextButton", frame)
btnSpeed.Text = "Speed OFF"
btnSpeed.Size = UDim2.new(0.8, 0, 0, 30)
btnSpeed.Position = UDim2.new(0.1, 0, 0.3, 0)

local btnESP = Instance.new("TextButton", frame)
btnESP.Text = "ESP OFF"
btnESP.Size = UDim2.new(0.8, 0, 0, 30)
btnESP.Position = UDim2.new(0.1, 0, 0.45, 0)

-- TAMBAHAN: Tombol naik/turun untuk HP
local btnUp = Instance.new("TextButton", frame)
btnUp.Text = "⬆ Naik"
btnUp.Size = UDim2.new(0.35, 0, 0, 30)
btnUp.Position = UDim2.new(0.1, 0, 0.6, 0)
btnUp.BackgroundColor3 = Color3.fromRGB(50, 50, 150)

local btnDown = Instance.new("TextButton", frame)
btnDown.Text = "⬇ Turun"
btnDown.Size = UDim2.new(0.35, 0, 0, 30)
btnDown.Position = UDim2.new(0.55, 0, 0.6, 0)
btnDown.BackgroundColor3 = Color3.fromRGB(150, 50, 50)

-- TAMBAHAN: Slider kecepatan (tombol + -)
local speedFrame = Instance.new("Frame", frame)
speedFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
speedFrame.Size = UDim2.new(0.9, 0, 0, 30)
speedFrame.Position = UDim2.new(0.05, 0, 0.75, 0)

local speedLabel = Instance.new("TextLabel", speedFrame)
speedLabel.Size = UDim2.new(0.5, 0, 1, 0)
speedLabel.BackgroundTransparency = 1
speedLabel.Text = "Speed: " .. flySpeed
speedLabel.TextColor3 = Color3.new(1, 1, 1)
speedLabel.TextXAlignment = Enum.TextXAlignment.Left

local minusBtn = Instance.new("TextButton", speedFrame)
minusBtn.Size = UDim2.new(0.2, 0, 1, 0)
minusBtn.Position = UDim2.new(0.6, 0, 0, 0)
minusBtn.Text = "-"
minusBtn.BackgroundColor3 = Color3.fromRGB(150, 0, 0)
minusBtn.MouseButton1Click:Connect(function()
    flySpeed = math.max(20, flySpeed - 10)
    speedLabel.Text = "Speed: " .. flySpeed
end)

local plusBtn = Instance.new("TextButton", speedFrame)
plusBtn.Size = UDim2.new(0.2, 0, 1, 0)
plusBtn.Position = UDim2.new(0.8, 0, 0, 0)
plusBtn.Text = "+"
plusBtn.BackgroundColor3 = Color3.fromRGB(0, 150, 0)
plusBtn.MouseButton1Click:Connect(function()
    flySpeed = math.min(200, flySpeed + 10)
    speedLabel.Text = "Speed: " .. flySpeed
end)

-- ================== FLY IMPROVED (ADMIN STYLE) ==================
local bodyVelocity
local bodyGyro

local function stopFly()
    if bodyVelocity then bodyVelocity:Destroy() bodyVelocity = nil end
    if bodyGyro then bodyGyro:Destroy() bodyGyro = nil end
    if humanoid then humanoid.PlatformStand = false end
end

local function startFly()
    stopFly()
    humanoid.PlatformStand = true

    bodyVelocity = Instance.new("BodyVelocity")
    bodyVelocity.MaxForce = Vector3.new(1e6, 1e6, 1e6)
    bodyVelocity.Parent = root

    bodyGyro = Instance.new("BodyGyro")
    bodyGyro.MaxTorque = Vector3.new(1e6, 1e6, 1e6)
    bodyGyro.P = 1e4
    bodyGyro.CFrame = root.CFrame
    bodyGyro.Parent = root

    RunService.RenderStepped:Connect(function()
        if not flying then return end

        local move = Vector3.new(0, 0, 0)
        local cam = workspace.CurrentCamera

        -- Keyboard WASD + Space/Ctrl
        if UserInputService:IsKeyDown(Enum.KeyCode.W) then
            move = move + cam.CFrame.LookVector
        end
        if UserInputService:IsKeyDown(Enum.KeyCode.S) then
            move = move - cam.CFrame.LookVector
        end
        if UserInputService:IsKeyDown(Enum.KeyCode.A) then
            move = move - cam.CFrame.RightVector
        end
        if UserInputService:IsKeyDown(Enum.KeyCode.D) then
            move = move + cam.CFrame.RightVector
        end
        if UserInputService:IsKeyDown(Enum.KeyCode.Space) then
            move = move + Vector3.new(0, 1, 0)
        end
        if UserInputService:IsKeyDown(Enum.KeyCode.LeftControl) then
            move = move - Vector3.new(0, 1, 0)
        end

        -- Tombol layar
        if _G.up then move = move + Vector3.new(0, 1, 0) end
        if _G.down then move = move - Vector3.new(0, 1, 0) end

        if move.Magnitude > 0 then
            move = move.Unit * flySpeed
        end

        bodyVelocity.Velocity = move
        bodyGyro.CFrame = cam.CFrame
    end)
end

-- Event tombol fly (tetap menggunakan toggle asli)
btnFly.MouseButton1Click:Connect(function()
    flying = not flying
    btnFly.Text = flying and "Fly ON" or "Fly OFF"
    if flying then
        startFly()
    else
        stopFly()
    end
end)

-- Tombol naik/turun untuk HP
btnUp.MouseButton1Click:Connect(function()
    _G.up = true
    wait(0.2)
    _G.up = false
end)

btnDown.MouseButton1Click:Connect(function()
    _G.down = true
    wait(0.2)
    _G.down = false
end)

-- ================== SPEED (tetap sama) ==================
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

-- ================== ESP IMPROVED (box + health + jarak) ==================
local espFolder = Instance.new("Folder", gui)
espFolder.Name = "ESP"

local function createESP(plr)
    if plr == player then return end

    local function onCharacterAdded(char)
        local head = char:WaitForChild("Head")
        local hrp = char:WaitForChild("HumanoidRootPart")
        local hum = char:WaitForChild("Humanoid")

        local bill = Instance.new("BillboardGui")
        bill.Adornee = head
        bill.Size = UDim2.new(5, 0, 6, 0)
        bill.AlwaysOnTop = true
        bill.Parent = espFolder

        -- Box
        local box = Instance.new("Frame", bill)
        box.Size = UDim2.new(1, 0, 1, 0)
        box.BackgroundTransparency = 1
        box.BorderSizePixel = 2
        box.BorderColor3 = Color3.fromRGB(255, 50, 50)

        -- Nama + jarak
        local nameLabel = Instance.new("TextLabel", bill)
        nameLabel.Size = UDim2.new(1, 0, 0.2, 0)
        nameLabel.Position = UDim2.new(0, 0, -0.2, 0)
        nameLabel.BackgroundTransparency = 1
        nameLabel.TextColor3 = Color3.new(1, 1, 1)
        nameLabel.TextStrokeTransparency = 0.5
        nameLabel.TextScaled = true
        nameLabel.Font = Enum.Font.GothamBold

        -- Health bar background
        local healthBg = Instance.new("Frame", bill)
        healthBg.Size = UDim2.new(1, 0, 0.05, 0)
        healthBg.Position = UDim2.new(0, 0, 1, 0)
        healthBg.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
        healthBg.BorderSizePixel = 0

        -- Health bar fill
        local healthBar = Instance.new("Frame", healthBg)
        healthBar.Size = UDim2.new(1, 0, 1, 0)
        healthBar.BackgroundColor3 = Color3.fromRGB(0, 255, 0)
        healthBar.BorderSizePixel = 0

        -- Update loop
        RunService.RenderStepped:Connect(function()
            if espOn and plr.Parent and char and root then
                local dist = (root.Position - hrp.Position).Magnitude
                nameLabel.Text = string.format("%s [%dm]", plr.Name, math.floor(dist))

                local health = hum.Health / hum.MaxHealth
                healthBar.Size = UDim2.new(health, 0, 1, 0)
                healthBar.BackgroundColor3 = Color3.fromRGB(255 * (1 - health), 255 * health, 0)

                if dist < 30 then
                    box.BorderColor3 = Color3.fromRGB(255, 0, 0)
                elseif dist < 70 then
                    box.BorderColor3 = Color3.fromRGB(255, 255, 0)
                else
                    box.BorderColor3 = Color3.fromRGB(0, 255, 0)
                end
            end
        end)
    end

    if plr.Character then
        onCharacterAdded(plr.Character)
    end
    plr.CharacterAdded:Connect(onCharacterAdded)
end

btnESP.MouseButton1Click:Connect(function()
    espOn = not espOn
    btnESP.Text = espOn and "ESP ON" or "ESP OFF"

    if espOn then
        espFolder:ClearAllChildren()
        for _, plr in pairs(game.Players:GetPlayers()) do
            createESP(plr)
        end
        game.Players.PlayerAdded:Connect(createESP)
    else
        espFolder:ClearAllChildren()
    end
end)

-- Notifikasi siap
print("PutzzHUB PRO loaded")