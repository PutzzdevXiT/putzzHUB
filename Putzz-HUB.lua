--// PUTZZDEV-HUB FINAL (Dengan ESP Skeleton)
-- Ukuran: Sedang (350x450), semua fitur siap pakai + Skeleton ESP

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local Camera = workspace.CurrentCamera
local LocalPlayer = Players.LocalPlayer

-- ================== VARIABEL FITUR ==================
-- ESP
local espEnabled = false
local lineEnabled = false
local healthEnabled = false
local skeletonEnabled = false
local ESPTable = {}
local SkeletonESP = {}

-- Fly
local flyEnabled = false
local flySpeed = 60
local bv, bg

-- Speed
local speedEnabled = false
local normalSpeed = 16
local fastSpeed = 60

-- NoClip
local noclipEnabled = false

-- ================== FUNGSI ESP BOX ==================
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

-- ================== FUNGSI ESP SKELETON ==================
local function createSkeleton(player)
    if player == LocalPlayer then return end
    
    local lines = {}
    
    -- Definisi sambungan tulang (bone connections)
    local connections = {
        {"Head", "Torso"},
        {"Torso", "Left Shoulder"}, {"Left Shoulder", "Left Arm"}, {"Left Arm", "Left Hand"},
        {"Torso", "Right Shoulder"}, {"Right Shoulder", "Right Arm"}, {"Right Arm", "Right Hand"},
        {"Torso", "Left Hip"}, {"Left Hip", "Left Leg"}, {"Left Leg", "Left Foot"},
        {"Torso", "Right Hip"}, {"Right Hip", "Right Leg"}, {"Right Leg", "Right Foot"}
    }
    
    -- Buat Drawing.Line untuk setiap sambungan
    for i = 1, #connections do
        local line = Drawing.new("Line")
        line.Thickness = 2
        line.Color = Color3.fromRGB(0, 255, 0)
        line.Visible = false
        table.insert(lines, {line, connections[i][1], connections[i][2]})
    end
    
    SkeletonESP[player] = lines
end

-- ================== UPDATE ESP SKELETON ==================
local function updateSkeleton(player, lines)
    local char = player.Character
    if not char then
        for _, lineData in pairs(lines) do
            lineData[1].Visible = false
        end
        return
    end
    
    for _, lineData in pairs(lines) do
        local line, part1Name, part2Name = unpack(lineData)
        
        local part1 = char:FindFirstChild(part1Name)
        local part2 = char:FindFirstChild(part2Name)
        
        -- Fallback untuk part yang mungkin berbeda nama
        if not part1 then
            if part1Name == "Left Shoulder" then part1 = char:FindFirstChild("Left Arm") end
            if part1Name == "Right Shoulder" then part1 = char:FindFirstChild("Right Arm") end
            if part1Name == "Left Hip" then part1 = char:FindFirstChild("Left Leg") end
            if part1Name == "Right Hip" then part1 = char:FindFirstChild("Right Leg") end
            if part1Name == "Torso" then part1 = char:FindFirstChild("UpperTorso") or char:FindFirstChild("LowerTorso") end
        end
        
        if not part2 then
            if part2Name == "Left Shoulder" then part2 = char:FindFirstChild("Left Arm") end
            if part2Name == "Right Shoulder" then part2 = char:FindFirstChild("Right Arm") end
            if part2Name == "Left Hip" then part2 = char:FindFirstChild("Left Leg") end
            if part2Name == "Right Hip" then part2 = char:FindFirstChild("Right Leg") end
            if part2Name == "Torso" then part2 = char:FindFirstChild("UpperTorso") or char:FindFirstChild("LowerTorso") end
        end
        
        if part1 and part2 then
            local pos1, vis1 = Camera:WorldToViewportPoint(part1.Position)
            local pos2, vis2 = Camera:WorldToViewportPoint(part2.Position)
            
            if vis1 and vis2 then
                line.From = Vector2.new(pos1.X, pos1.Y)
                line.To = Vector2.new(pos2.X, pos2.Y)
                line.Visible = skeletonEnabled
                
                -- Warna berdasarkan tim
                if player.Team and LocalPlayer.Team and player.Team ~= LocalPlayer.Team then
                    line.Color = Color3.fromRGB(255, 0, 0)  -- Merah untuk musuh
                else
                    line.Color = Color3.fromRGB(0, 255, 0)  -- Hijau untuk teman
                end
            else
                line.Visible = false
            end
        else
            line.Visible = false
        end
    end
end

-- ================== RENDER STEP UNTUK SEMUA ESP ==================
RunService.RenderStepped:Connect(function()
    -- Update ESP Box
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

                if healthEnabled and humanoid then
                    local healthPercent = humanoid.Health / humanoid.MaxHealth
                    local barWidth = width * 0.8
                    local barHeight = 4
                    local barX = pos.X - barWidth/2
                    local barY = top.Y - 20

                    healthBg.Size = Vector2.new(barWidth, barHeight)
                    healthBg.Position = Vector2.new(barX, barY)
                    healthBg.Visible = true

                    healthFg.Size = Vector2.new(barWidth * healthPercent, barHeight)
                    healthFg.Position = Vector2.new(barX, barY)
                    healthFg.Color = Color3.fromRGB(255 * (1 - healthPercent), 255 * healthPercent, 0)
                    healthFg.Visible = true
                else
                    healthBg.Visible = false
                    healthFg.Visible = false
                end

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
    
    -- Update ESP Skeleton
    if skeletonEnabled then
        for player, lines in pairs(SkeletonESP) do
            updateSkeleton(player, lines)
        end
    else
        for _, lines in pairs(SkeletonESP) do
            for _, lineData in pairs(lines) do
                lineData[1].Visible = false
            end
        end
    end
end)

-- Inisialisasi untuk player yang sudah ada
for _, p in pairs(Players:GetPlayers()) do
    createESP(p)
    createSkeleton(p)
end

-- Untuk player yang join belakangan
Players.PlayerAdded:Connect(function(p)
    createESP(p)
    createSkeleton(p)
end)

-- ================== FUNGSI FLY ==================
local function startFly()
    local char = LocalPlayer.Character
    if not char then return end
    local hrp = char:FindFirstChild("HumanoidRootPart")
    if not hrp then return end

    bv = Instance.new("BodyVelocity")
    bv.MaxForce = Vector3.new(9e9,9e9,9e9)
    bv.Parent = hrp

    bg = Instance.new("BodyGyro")
    bg.MaxTorque = Vector3.new(9e9,9e9,9e9)
    bg.Parent = hrp

    RunService.RenderStepped:Connect(function()
        if flyEnabled then
            bg.CFrame = Camera.CFrame
            bv.Velocity = Camera.CFrame.LookVector * flySpeed
        end
    end)
end

local function stopFly()
    if bv then bv:Destroy() bv = nil end
    if bg then bg:Destroy() bg = nil end
end

-- ================== FUNGSI NOCLIP ==================
RunService.Stepped:Connect(function()
    if noclipEnabled and LocalPlayer.Character then
        for _, v in pairs(LocalPlayer.Character:GetDescendants()) do
            if v:IsA("BasePart") then
                v.CanCollide = false
            end
        end
    end
end)

-- ================== GUI SUPER KECE ==================
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Parent = game.CoreGui
ScreenGui.Name = "PutzzdevHubFinal"
ScreenGui.ResetOnSpawn = false
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

-- Fungsi rounded frame
local function makeRounded(parent, size, pos, color, radius)
    local f = Instance.new("Frame")
    f.Parent = parent
    f.Size = size
    f.Position = pos
    f.BackgroundColor3 = color or Color3.fromRGB(30,30,30)
    f.BorderSizePixel = 0
    f.ClipsDescendants = true

    local c = Instance.new("UICorner")
    c.Parent = f
    c.CornerRadius = UDim.new(0, radius or 8)
    return f
end

-- Fungsi gradient
local function addGradient(frame, c1, c2, rot)
    local g = Instance.new("UIGradient")
    g.Parent = frame
    g.Color = ColorSequence.new({ColorSequenceKeypoint.new(0, c1), ColorSequenceKeypoint.new(1, c2)})
    g.Rotation = rot or 90
    return g
end

-- Fungsi button
local function makeButton(parent, text, yPos, callback)
    local btn = makeRounded(parent, UDim2.new(0.9,0,0,40), UDim2.new(0.05,0,0,yPos), Color3.fromRGB(45,45,55), 6)
    addGradient(btn, Color3.fromRGB(60,60,70), Color3.fromRGB(40,40,50), 90)

    local label = Instance.new("TextLabel")
    label.Parent = btn
    label.Size = UDim2.new(1,0,1,0)
    label.BackgroundTransparency = 1
    label.Text = text
    label.TextColor3 = Color3.new(1,1,1)
    label.Font = Enum.Font.GothamBold
    label.TextSize = 15

    local click = Instance.new("TextButton")
    click.Parent = btn
    click.Size = UDim2.new(1,0,1,0)
    click.BackgroundTransparency = 1
    click.Text = ""

    click.MouseButton1Click:Connect(callback)
    return btn
end

-- Fungsi toggle
local function makeToggle(parent, text, yPos, default, callback)
    local tog = makeRounded(parent, UDim2.new(0.9,0,0,40), UDim2.new(0.05,0,0,yPos), Color3.fromRGB(45,45,55), 6)
    addGradient(tog, Color3.fromRGB(60,60,70), Color3.fromRGB(40,40,50), 90)

    local label = Instance.new("TextLabel")
    label.Parent = tog
    label.Size = UDim2.new(0.6,0,1,0)
    label.Position = UDim2.new(0.05,0,0,0)
    label.BackgroundTransparency = 1
    label.Text = text
    label.TextColor3 = Color3.new(1,1,1)
    label.Font = Enum.Font.Gotham
    label.TextSize = 15
    label.TextXAlignment = Enum.TextXAlignment.Left

    local switch = makeRounded(tog, UDim2.new(0,46,0,24), UDim2.new(0.8,0,0.5,-12), default and Color3.fromRGB(0,180,0) or Color3.fromRGB(100,100,100), 12)
    switch.BackgroundColor3 = default and Color3.fromRGB(0,180,0) or Color3.fromRGB(100,100,100)

    local circle = makeRounded(switch, UDim2.new(0,20,0,20), default and UDim2.new(1,-22,0.5,-10) or UDim2.new(0.05,0,0.5,-10), Color3.new(1,1,1), 10)

    local state = default
    local click = Instance.new("TextButton")
    click.Parent = tog
    click.Size = UDim2.new(1,0,1,0)
    click.BackgroundTransparency = 1
    click.Text = ""

    click.MouseButton1Click:Connect(function()
        state = not state
        TweenService:Create(switch, TweenInfo.new(0.2), {BackgroundColor3 = state and Color3.fromRGB(0,180,0) or Color3.fromRGB(100,100,100)}):Play()
        TweenService:Create(circle, TweenInfo.new(0.2), {Position = state and UDim2.new(1,-22,0.5,-10) or UDim2.new(0.05,0,0.5,-10)}):Play()
        callback(state)
    end)
    return tog
end

-- Main window (350x450)
local mainFrame = makeRounded(ScreenGui, UDim2.new(0,350,0,450), UDim2.new(0.5,-175,0.5,-225), Color3.fromRGB(20,20,30), 16)
addGradient(mainFrame, Color3.fromRGB(25,25,35), Color3.fromRGB(35,35,45), 45)

-- Header
local header = Instance.new("Frame")
header.Parent = mainFrame
header.Size = UDim2.new(1,0,0,55)
header.BackgroundTransparency = 1

local title = Instance.new("TextLabel")
title.Parent = header
title.Size = UDim2.new(1,0,1,0)
title.BackgroundTransparency = 1
title.Text = "PUTZZDEV-HUB"
title.TextColor3 = Color3.fromRGB(0,200,255)
title.Font = Enum.Font.GothamBlack
title.TextSize = 24
title.TextStrokeTransparency = 0.7

-- Garis biru
local lineBlue = Instance.new("Frame")
lineBlue.Parent = header
lineBlue.Size = UDim2.new(0.8,0,0,2)
lineBlue.Position = UDim2.new(0.1,0,1,-2)
lineBlue.BackgroundColor3 = Color3.fromRGB(0,200,255)
Instance.new("UICorner", lineBlue).CornerRadius = UDim.new(0,2)

-- Tab bar
local tabBar = Instance.new("Frame")
tabBar.Parent = mainFrame
tabBar.Size = UDim2.new(1,0,0,40)
tabBar.Position = UDim2.new(0,0,0,55)
tabBar.BackgroundTransparency = 1

local tabs = {}
local contents = {}

local function createTab(name, icon)
    local idx = #tabs + 1
    local btn = Instance.new("TextButton")
    btn.Parent = tabBar
    btn.Size = UDim2.new(0.25,0,1,0)
    btn.Position = UDim2.new((idx-1)*0.25,0,0,0)
    btn.BackgroundTransparency = 1
    btn.Text = icon.." "..name
    btn.TextColor3 = Color3.fromRGB(180,180,180)
    btn.Font = Enum.Font.GothamBold
    btn.TextSize = 14

    local content = Instance.new("ScrollingFrame")
    content.Parent = mainFrame
    content.Size = UDim2.new(1,0,1,-95)
    content.Position = UDim2.new(0,0,0,95)
    content.BackgroundTransparency = 1
    content.BorderSizePixel = 0
    content.ScrollBarThickness = 5
    content.CanvasSize = UDim2.new(0,0,0,0)
    content.Visible = false

    local layout = Instance.new("UIListLayout")
    layout.Parent = content
    layout.Padding = UDim.new(0,6)
    layout.HorizontalAlignment = Enum.HorizontalAlignment.Center

    table.insert(tabs, btn)
    table.insert(contents, content)

    btn.MouseButton1Click:Connect(function()
        for i,b in ipairs(tabs) do
            b.TextColor3 = Color3.fromRGB(180,180,180)
            contents[i].Visible = false
        end
        btn.TextColor3 = Color3.fromRGB(0,200,255)
        content.Visible = true
    end)
    return content
end

-- Buat tab
local tabMain = createTab("MAIN", "🏠")
local tabESP = createTab("ESP", "👁️")
local tabMove = createTab("MOVE", "🏃")
local tabMisc = createTab("MISC", "⚙️")

-- ===== TAB MAIN =====
local y = 10
makeToggle(tabMain, "Fly", y, false, function(s)
    flyEnabled = s
    if s then startFly() else stopFly() end
end); y = y + 46

makeToggle(tabMain, "Speed", y, false, function(s)
    speedEnabled = s
    local hum = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
    if hum then
        hum.WalkSpeed = s and fastSpeed or normalSpeed
    end
end); y = y + 46

makeToggle(tabMain, "NoClip", y, false, function(s)
    noclipEnabled = s
end); y = y + 46

tabMain.CanvasSize = UDim2.new(0,0,0,y+10)

-- ===== TAB ESP =====
y = 10
makeToggle(tabESP, "ESP Player", y, false, function(s) espEnabled = s end); y = y + 46
makeToggle(tabESP, "ESP Line", y, false, function(s) lineEnabled = s end); y = y + 46
makeToggle(tabESP, "Health Bar", y, false, function(s) healthEnabled = s end); y = y + 46
makeToggle(tabESP, "ESP Skeleton", y, false, function(s) skeletonEnabled = s end); y = y + 46
tabESP.CanvasSize = UDim2.new(0,0,0,y+10)

-- ===== TAB MOVE =====
y = 10
makeButton(tabMove, "⬆ Naik (Fly)", y, function()
    if flyEnabled then
        local hrp = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
        if hrp then hrp.Velocity = hrp.Velocity + Vector3.new(0,50,0) end
    end
end); y = y + 46

makeButton(tabMove, "⬇ Turun (Fly)", y, function()
    if flyEnabled then
        local hrp = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
        if hrp then hrp.Velocity = hrp.Velocity - Vector3.new(0,50,0) end
    end
end); y = y + 46

tabMove.CanvasSize = UDim2.new(0,0,0,y+10)

-- ===== TAB MISC =====
y = 10
makeButton(tabMisc, "🔄 Refresh ESP", y, function()
    for p,_ in pairs(ESPTable) do ESPTable[p] = nil end
    for p,_ in pairs(SkeletonESP) do SkeletonESP[p] = nil end
    for _, p in pairs(Players:GetPlayers()) do 
        createESP(p)
        createSkeleton(p)
    end
end); y = y + 46

makeButton(tabMisc, "📋 Copy Discord", y, function()
    if setclipboard then
        setclipboard("discord.gg/putzzhub")
        notify("Discord copied!")
    end
end); y = y + 46

tabMisc.CanvasSize = UDim2.new(0,0,0,y+10)

-- Aktifkan tab pertama
tabs[1].TextColor3 = Color3.fromRGB(0,200,255)
contents[1].Visible = true

-- Notifikasi
local function notify(msg)
    local n = makeRounded(ScreenGui, UDim2.new(0,250,0,40), UDim2.new(0.5,-125,0.9,0), Color3.fromRGB(30,30,40), 6)
    addGradient(n, Color3.fromRGB(50,50,60), Color3.fromRGB(30,30,40), 90)
    local l = Instance.new("TextLabel", n)
    l.Size = UDim2.new(1,0,1,0)
    l.BackgroundTransparency = 1
    l.Text = msg
    l.TextColor3 = Color3.new(1,1,1)
    l.Font = Enum.Font.Gotham
    l.TextSize = 14

    TweenService:Create(n, TweenInfo.new(0.3), {Position = UDim2.new(0.5,-125,0.8,0)}):Play()
    wait(2)
    TweenService:Create(n, TweenInfo.new(0.3), {Position = UDim2.new(0.5,-125,0.9,0)}):Play()
    wait(0.3)
    n:Destroy()
end

notify("Putzzdev-HUB + Skeleton ESP Loaded!")

-- Animasi masuk
mainFrame.Position = UDim2.new(0.5,-175,0.6,-225)
TweenService:Create(mainFrame, TweenInfo.new(0.4, Enum.EasingStyle.Back), {Position = UDim2.new(0.5,-175,0.5,-225)}):Play()

-- ================= OPEN / CLOSE BUTTON =================

local openBtn = Instance.new("TextButton")
openBtn.Parent = ScreenGui
openBtn.Size = UDim2.new(0,55,0,55)
openBtn.Position = UDim2.new(0,20,0.5,-27)
openBtn.BackgroundColor3 = Color3.fromRGB(0,200,255)
openBtn.Text = "P"
openBtn.TextColor3 = Color3.new(1,1,1)
openBtn.Font = Enum.Font.GothamBlack
openBtn.TextSize = 22
openBtn.AutoButtonColor = true
openBtn.ZIndex = 10

local corner = Instance.new("UICorner")
corner.Parent = openBtn
corner.CornerRadius = UDim.new(1,0)

local stroke = Instance.new("UIStroke")
stroke.Parent = openBtn
stroke.Color = Color3.fromRGB(255,255,255)
stroke.Thickness = 1.5

-- toggle
local menuOpen = true

openBtn.MouseButton1Click:Connect(function()

	menuOpen = not menuOpen

	if menuOpen then
		mainFrame.Visible = true
		TweenService:Create(mainFrame,TweenInfo.new(0.25),{
			Position = UDim2.new(0.5,-175,0.5,-225)
		}):Play()
	else
		TweenService:Create(mainFrame,TweenInfo.new(0.25),{
			Position = UDim2.new(0.5,-175,1,0)
		}):Play()

		task.wait(0.25)
		mainFrame.Visible = false
	end

end)

