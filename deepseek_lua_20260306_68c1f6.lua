--[[
    PutzzHUB - Fly & EXP Only Script
    Developer : PutzzHUB
    Version : 1.0
]]

-- Memuat Library UI (WindUI)
local WindUI = loadstring(game:HttpGet("https://raw.githubusercontent.com/MZEEN2424/Graphics/main/WindUI%20Library.lua"))()
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local player = Players.LocalPlayer
local mouse = player:GetMouse()

-- Variabel untuk fitur
local flying = false
local flySpeed = 50
local expOnly = false
local bodyVelocity = nil

-- Membuat GUI
local Window = WindUI:CreateWindow({
    Title = "PutzzHUB",
    SubTitle = "Fly & EXP Only",
    Icon = "rbxassetid://6035145364",
    Size = UDim2.fromOffset(450, 350),
    Position = UDim2.new(0.3, 0, 0.3, 0)
})

-- Tab Utama
local MainTab = Window:Tab("Utama", "rbxassetid://6034287594")

-- Section Fly
local FlySection = MainTab:Section("Fitur Terbang", true)

FlySection:Toggle({
    Name = "Aktifkan Fly",
    Default = false,
    Callback = function(value)
        flying = value
        local character = player.Character
        if not character then return end
        
        local humanoid = character:FindFirstChild("Humanoid")
        local rootPart = character:FindFirstChild("HumanoidRootPart")
        
        if not humanoid or not rootPart then return end
        
        if flying then
            -- Membuat BodyVelocity untuk terbang
            bodyVelocity = Instance.new("BodyVelocity")
            bodyVelocity.MaxForce = Vector3.new(4000, 4000, 4000)
            bodyVelocity.Velocity = Vector3.new(0, 0, 0)
            bodyVelocity.Parent = rootPart
            
            -- Loop untuk mengontrol terbang
            spawn(function()
                while flying and bodyVelocity and bodyVelocity.Parent do
                    local moveDirection = Vector3.new(0, 0, 0)
                    
                    -- Kontrol WASD
                    if UserInputService:IsKeyDown(Enum.KeyCode.W) then
                        moveDirection = moveDirection + (workspace.CurrentCamera.CFrame.LookVector * flySpeed)
                    end
                    if UserInputService:IsKeyDown(Enum.KeyCode.S) then
                        moveDirection = moveDirection - (workspace.CurrentCamera.CFrame.LookVector * flySpeed)
                    end
                    if UserInputService:IsKeyDown(Enum.KeyCode.A) then
                        moveDirection = moveDirection - (workspace.CurrentCamera.CFrame.RightVector * flySpeed)
                    end
                    if UserInputService:IsKeyDown(Enum.KeyCode.D) then
                        moveDirection = moveDirection + (workspace.CurrentCamera.CFrame.RightVector * flySpeed)
                    end
                    
                    -- Kontrol Naik/Turun (Space dan Ctrl)
                    if UserInputService:IsKeyDown(Enum.KeyCode.Space) then
                        moveDirection = moveDirection + Vector3.new(0, flySpeed, 0)
                    end
                    if UserInputService:IsKeyDown(Enum.KeyCode.LeftControl) then
                        moveDirection = moveDirection - Vector3.new(0, flySpeed, 0)
                    end
                    
                    if bodyVelocity then
                        bodyVelocity.Velocity = moveDirection
                    end
                    
                    RunService.Heartbeat:Wait()
                end
            end)
        else
            -- Hancurkan BodyVelocity jika tidak terbang
            if bodyVelocity then
                bodyVelocity:Destroy()
                bodyVelocity = nil
            end
        end
    end
})

FlySection:Slider({
    Name = "Kecepatan Terbang",
    Min = 10,
    Max = 200,
    Default = 50,
    Callback = function(value)
        flySpeed = value
    end
})

-- Section EXP Only
local ExpSection = MainTab:Section("EXP Only", true)

ExpSection:Toggle({
    Name = "Aktifkan EXP Only",
    Default = false,
    Callback = function(value)
        expOnly = value
        
        if expOnly then
            -- Loop untuk mencari dan mengumpulkan EXP
            spawn(function()
                while expOnly do
                    -- Cari semua part yang mungkin berisi EXP
                    -- Catatan: Nama object EXP berbeda-beda tiap game
                    -- Kamu perlu menyesuaikan dengan game yang dimainkan
                    for _, v in pairs(workspace:GetDescendants()) do
                        -- Contoh: Mencari object dengan nama "Experience" atau "Exp"
                        if v.Name:lower():match("exp") or v.Name:lower():match("experience") then
                            if v:IsA("BasePart") and v:FindFirstChild("TouchInterest") then
                                -- Teleport ke EXP
                                local character = player.Character
                                if character and character:FindFirstChild("HumanoidRootPart") then
                                    character.HumanoidRootPart.CFrame = v.CFrame
                                    wait(0.1)
                                end
                            end
                        end
                    end
                    wait(1) -- Jeda 1 detik untuk menghindari lag
                end
            end)
            
            -- Notifikasi
            game:GetService("StarterGui"):SetCore("SendNotification", {
                Title = "PutzzHUB",
                Text = "EXP Only Diaktifkan!",
                Duration = 3
            })
        end
    end
})

-- Tab Info
local InfoTab = Window:Tab("Info", "rbxassetid://6034363792")

InfoTab:Paragraph({
    Title = "PutzzHUB",
    Content = "Developer : PutzzHUB\n" ..
              "Version : 1.0\n" ..
              "Fitur :\n" ..
              "- Fly Mode\n" ..
              "- EXP Only (Auto Collect)\n\n" ..
              "Cara Penggunaan:\n" ..
              "1. Aktifkan toggle Fly untuk terbang\n" ..
              "2. Gunakan WASD + Space/Ctrl untuk kontrol\n" ..
              "3. Aktifkan EXP Only untuk auto collect exp\n\n" ..
              "Catatan: Fitur EXP Only mungkin perlu\n" ..
              "disesuaikan dengan nama object di game-mu."
})

InfoTab:Button({
    Name = "Copy Discord",
    Callback = function()
        setclipboard("discord.gg/putzzhub")
        game:GetService("StarterGui"):SetCore("SendNotification", {
            Title = "PutzzHUB",
            Text = "Link Discord disalin!",
            Duration = 2
        })
    end
})

-- Menampilkan window pertama kali
Window:Select(1)

-- Notifikasi script berhasil dimuat
game:GetService("StarterGui"):SetCore("SendNotification", {
    Title = "PutzzHUB",
    Text = "Script berhasil dimuat!",
    Duration = 3
})

print("PutzzHUB - Script Fly & EXP Only telah dimuat!")