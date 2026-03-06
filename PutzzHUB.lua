--[[
    PUTZZHUB - Gunung Edition (Optimasi HP)
    Developer : PutzzHUB
    Version : 3.5
]]

-- Library lebih ringan
local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/XNEOFF/Simple-Gui/main/Source%20Code"))()

-- Buat GUI sederhana
local GUI = Library:Create("PutzzHUB Gunung")

-- Services
local Players = game:GetService("Players")
local player = Players.LocalPlayer

-- Variables
local flying = false
local speedEnabled = false
local flySpeed = 50

-- MAIN MENU
local Main = GUI:Tab("Utama", "Fitur utama")

-- FLY SEDERHANA (KHUSUS HP)
Main:Toggle("Mode Terbang", false, function(value)
    flying = value
    local char = player.Character
    if not char then return end
    
    local root = char:FindFirstChild("HumanoidRootPart")
    local humanoid = char:FindFirstChild("Humanoid")
    
    if flying then
        humanoid.PlatformStand = true
        local bv = Instance.new("BodyVelocity")
        bv.MaxForce = Vector3.new(4000, 4000, 4000)
        bv.Parent = root
        
        -- Loop terbang
        spawn(function()
            while flying do
                local move = Vector3.new(0, 0, 0)
                if _G.up then move = move + Vector3.new(0, flySpeed, 0) end
                if _G.down then move = move - Vector3.new(0, flySpeed, 0) end
                if bv and bv.Parent then
                    bv.Velocity = move
                end
                wait(0.1)
            end
            if bv then bv:Destroy() end
        end)
    else
        humanoid.PlatformStand = false
    end
end)

-- Tombol kontrol terbang (khusus HP)
Main:Button("🔼 Naik", function()
    _G.up = true
    wait(0.2)
    _G.up = false
end)

Main:Button("🔽 Turun", function()
    _G.down = true
    wait(0.2)
    _G.down = false
end)

Main:Slider("Kecepatan Terbang", 10, 200, 50, function(value)
    flySpeed = value
end)

-- SPEED HACK
Main:Toggle("Speed Hack", false, function(value)
    speedEnabled = value
    local char = player.Character
    if char and char:FindFirstChild("Humanoid") then
        if value then
            char.Humanoid.WalkSpeed = 50
        else
            char.Humanoid.WalkSpeed = 16
        end
    end
end)

-- AUTO EXP
Main:Toggle("Auto EXP", false, function(value)
    _G.autoExp = value
    if value then
        spawn(function()
            while _G.autoExp do
                for _, v in pairs(workspace:GetDescendants()) do
                    if v:IsA("BasePart") and (v.Name:lower():find("exp") or v.Name:lower():find("xp")) then
                        local char = player.Character
                        if char and char:FindFirstChild("HumanoidRootPart") then
                            char.HumanoidRootPart.CFrame = v.CFrame
                            wait(0.2)
                            break
                        end
                    end
                end
                wait(1)
            end
        end)
    end
end)

-- TELEPORT MENU
local Teleport = GUI:Tab("Teleport", "TP ke player")

-- Daftar player
Teleport:Button("📋 Refresh Player", function()
    local list = {}
    for _, v in pairs(Players:GetPlayers()) do
        if v ~= player then
            table.insert(list, v.Name)
        end
    end
    
    -- Tampilkan dalam notifikasi
    local msg = "Player online:\n"
    for i, name in ipairs(list) do
        msg = msg .. i .. ". " .. name .. "\n"
    end
    GUI:Notify(msg)
end)

-- Teleport ke player
Teleport:TextBox("Cari & TP", "Ketik nama player", function(text)
    if text and text ~= "" then
        for _, v in pairs(Players:GetPlayers()) do
            if v ~= player and v.Name:lower():find(text:lower()) then
                local target = v.Character
                local me = player.Character
                if target and target:FindFirstChild("HumanoidRootPart") and me and me:FindFirstChild("HumanoidRootPart") then
                    me.HumanoidRootPart.CFrame = target.HumanoidRootPart.CFrame + Vector3.new(0, 3, 0)
                    GUI:Notify("✅ TP ke " .. v.Name)
                end
                break
            end
        end
    end
end)

-- Random TP
Teleport:Button("🎲 Random TP", function()
    local list = {}
    for _, v in pairs(Players:GetPlayers()) do
        if v ~= player then table.insert(list, v) end
    end
    if #list > 0 then
        local target = list[math.random(1, #list)].Character
        local me = player.Character
        if target and target:FindFirstChild("HumanoidRootPart") and me and me:FindFirstChild("HumanoidRootPart") then
            me.HumanoidRootPart.CFrame = target.HumanoidRootPart.CFrame + Vector3.new(0, 3, 0)
            GUI:Notify("✅ TP random")
        end
    end
end)

-- INFO MENU
local Info = GUI:Tab("Info", "Tentang script")

Info:Button("👤 Developer: PutzzHUB", function() end)
Info:Button("📌 Version: 3.5 (HP)", function() end)
Info:Button("💬 Discord: discord.gg/putzzhub", function()
    setclipboard("discord.gg/putzzhub")
    GUI:Notify("✅ Link Discord disalin!")
end)

-- Notifikasi siap
GUI:Notify("✅ PutzzHUB siap digunakan!")

-- Cek karakter
spawn(function()
    while not player.Character do wait(1) end
    GUI:Notify("✅ Karakter ditemukan!")
end)