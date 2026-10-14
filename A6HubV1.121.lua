--[[
    A6HubV1.121 - Custom Green UI (no Linoria cursor)
    Mobile friendly | Toggle button | All features
]]

local Players = game:GetService("Players")
local RS = game:GetService("ReplicatedStorage")
local UIS = game:GetService("UserInputService")
local SoundService = game:GetService("SoundService")
local TweenService = game:GetService("TweenService")
local LP = Players.LocalPlayer
local Char = LP.Character or LP.CharacterAdded:Wait()
local Hum = Char:WaitForChild("Humanoid")
local Root = Char:WaitForChild("HumanoidRootPart")
local PlayerGui = LP:WaitForChild("PlayerGui")

LP.CharacterAdded:Connect(function(c)
    Char = c
    Hum = c:WaitForChild("Humanoid")
    Root = c:WaitForChild("HumanoidRootPart")
end)

-- FLAGS
local flags = {
    AutoFish=false, AutoSell=false, SellFull=true, FishMode="Legit",
    AutoCraft=false, CraftTarget="Fortune Potion I", CraftType="Stella",
    AutoBoss=false, AutoMari=false, AutoJester=false, AutoRin=false,
    UseTele=false, AutoDaily=false, AutoBoard=false,
    AutoLimbo=false, FixLag=false, PlayMusic=true, UIVisible=true
}

-- ========== CUSTOM GREEN UI ==========
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "A6HubUI"
ScreenGui.ResetOnSpawn = false
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
ScreenGui.Parent = PlayerGui

local Main = Instance.new("Frame")
Main.Name = "Main"
Main.Size = UDim2.new(0, 360, 0, 420)
Main.Position = UDim2.new(0.5, -180, 0.5, -210)
Main.BackgroundColor3 = Color3.fromRGB(12, 18, 12)
Main.BorderSizePixel = 0
Main.Active = true
Main.Draggable = true
Main.Parent = ScreenGui

local MainCorner = Instance.new("UICorner")
MainCorner.CornerRadius = UDim.new(0, 8)
MainCorner.Parent = Main

local MainStroke = Instance.new("UIStroke")
MainStroke.Color = Color3.fromRGB(0, 180, 70)
MainStroke.Thickness = 1.5
MainStroke.Parent = Main

-- Title bar
local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, -40, 0, 32)
Title.Position = UDim2.new(0, 8, 0, 4)
Title.BackgroundTransparency = 1
Title.Text = "A6HubV1.121"
Title.TextColor3 = Color3.fromRGB(0, 220, 90)
Title.Font = Enum.Font.GothamBold
Title.TextSize = 16
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.Parent = Main

-- Close / Toggle button
local CloseBtn = Instance.new("TextButton")
CloseBtn.Size = UDim2.new(0, 28, 0, 28)
CloseBtn.Position = UDim2.new(1, -32, 0, 4)
CloseBtn.BackgroundColor3 = Color3.fromRGB(30, 50, 30)
CloseBtn.Text = "X"
CloseBtn.TextColor3 = Color3.fromRGB(255, 80, 80)
CloseBtn.Font = Enum.Font.GothamBold
CloseBtn.TextSize = 14
CloseBtn.Parent = Main
local CloseCorner = Instance.new("UICorner")
CloseCorner.CornerRadius = UDim.new(0, 6)
CloseCorner.Parent = CloseBtn

-- Tab bar
local TabBar = Instance.new("ScrollingFrame")
TabBar.Size = UDim2.new(1, -12, 0, 28)
TabBar.Position = UDim2.new(0, 6, 0, 36)
TabBar.BackgroundTransparency = 1
TabBar.ScrollBarThickness = 0
TabBar.CanvasSize = UDim2.new(0, 520, 0, 0)
TabBar.Parent = Main

local TabLayout = Instance.new("UIListLayout")
TabLayout.FillDirection = Enum.FillDirection.Horizontal
TabLayout.Padding = UDim.new(0, 4)
TabLayout.Parent = TabBar

local Content = Instance.new("ScrollingFrame")
Content.Size = UDim2.new(1, -12, 1, -72)
Content.Position = UDim2.new(0, 6, 0, 68)
Content.BackgroundColor3 = Color3.fromRGB(16, 22, 16)
Content.BorderSizePixel = 0
Content.ScrollBarThickness = 4
Content.ScrollBarImageColor3 = Color3.fromRGB(0, 180, 70)
Content.CanvasSize = UDim2.new(0, 0, 0, 600)
Content.Parent = Main
local ContentCorner = Instance.new("UICorner")
ContentCorner.CornerRadius = UDim.new(0, 6)
ContentCorner.Parent = Content

local pages = {}
local currentTab = nil

local function makeToggle(parent, text, flagKey, y)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, -16, 0, 28)
    btn.Position = UDim2.new(0, 8, 0, y)
    btn.BackgroundColor3 = Color3.fromRGB(22, 32, 22)
    btn.Text = ""
    btn.Parent = parent
    local c = Instance.new("UICorner")
    c.CornerRadius = UDim.new(0, 5)
    c.Parent = btn

    local box = Instance.new("Frame")
    box.Size = UDim2.new(0, 18, 0, 18)
    box.Position = UDim2.new(0, 6, 0.5, -9)
    box.BackgroundColor3 = flags[flagKey] and Color3.fromRGB(0, 200, 80) or Color3.fromRGB(40, 50, 40)
    box.Parent = btn
    local bc = Instance.new("UICorner")
    bc.CornerRadius = UDim.new(0, 4)
    bc.Parent = box

    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, -35, 1, 0)
    label.Position = UDim2.new(0, 30, 0, 0)
    label.BackgroundTransparency = 1
    label.Text = text
    label.TextColor3 = Color3.fromRGB(220, 255, 220)
    label.Font = Enum.Font.Gotham
    label.TextSize = 13
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = btn

    btn.MouseButton1Click:Connect(function()
        flags[flagKey] = not flags[flagKey]
        box.BackgroundColor3 = flags[flagKey] and Color3.fromRGB(0, 200, 80) or Color3.fromRGB(40, 50, 40)
    end)
    return btn
end

local function makeLabel(parent, text, y)
    local l = Instance.new("TextLabel")
    l.Size = UDim2.new(1, -16, 0, 20)
    l.Position = UDim2.new(0, 8, 0, y)
    l.BackgroundTransparency = 1
    l.Text = text
    l.TextColor3 = Color3.fromRGB(140, 200, 140)
    l.Font = Enum.Font.Gotham
    l.TextSize = 12
    l.TextXAlignment = Enum.TextXAlignment.Left
    l.Parent = parent
    return l
end

local function makeButton(parent, text, y, callback)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, -16, 0, 28)
    btn.Position = UDim2.new(0, 8, 0, y)
    btn.BackgroundColor3 = Color3.fromRGB(0, 140, 55)
    btn.Text = text
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.Font = Enum.Font.GothamBold
    btn.TextSize = 13
    btn.Parent = parent
    local c = Instance.new("UICorner")
    c.CornerRadius = UDim.new(0, 5)
    c.Parent = btn
    btn.MouseButton1Click:Connect(callback)
    return btn
end

local function createPage(name)
    local page = Instance.new("Frame")
    page.Size = UDim2.new(1, 0, 0, 800)
    page.BackgroundTransparency = 1
    page.Visible = false
    page.Parent = Content
    pages[name] = page
    return page
end

local function switchTab(name)
    for n,p in pairs(pages) do p.Visible = (n == name) end
    currentTab = name
end

local tabNames = {"Main","Fish","Craft","Boss","Merch","Quest","Visual","Limbo","Misc"}
for i,name in ipairs(tabNames) do
    local tbtn = Instance.new("TextButton")
    tbtn.Size = UDim2.new(0, 52, 0, 24)
    tbtn.BackgroundColor3 = Color3.fromRGB(25, 40, 25)
    tbtn.Text = name
    tbtn.TextColor3 = Color3.fromRGB(180, 255, 180)
    tbtn.Font = Enum.Font.Gotham
    tbtn.TextSize = 11
    tbtn.Parent = TabBar
    local tc = Instance.new("UICorner")
    tc.CornerRadius = UDim.new(0, 4)
    tc.Parent = tbtn
    tbtn.MouseButton1Click:Connect(function()
        switchTab(name)
        for _,b in pairs(TabBar:GetChildren()) do
            if b:IsA("TextButton") then
                b.BackgroundColor3 = Color3.fromRGB(25, 40, 25)
            end
        end
        tbtn.BackgroundColor3 = Color3.fromRGB(0, 160, 60)
    end)
    createPage(name)
end

-- MAIN PAGE
local mainPage = pages["Main"]
makeToggle(mainPage, "Auto Fish", "AutoFish", 8)
makeToggle(mainPage, "Auto Sell", "AutoSell", 40)
makeToggle(mainPage, "Auto Craft", "AutoCraft", 72)
makeToggle(mainPage, "Auto Boss", "AutoBoss", 104)
makeToggle(mainPage, "Auto Merch", "AutoMari", 136)
makeToggle(mainPage, "Auto Quest", "AutoDaily", 168)
makeToggle(mainPage, "Auto Limbo", "AutoLimbo", 200)
makeButton(mainPage, "TOGGLE UI (An/Hien)", 240, function()
    flags.UIVisible = not flags.UIVisible
    Main.Visible = flags.UIVisible
end)

-- FISH PAGE
local fishPage = pages["Fish"]
makeToggle(fishPage, "Auto Fish", "AutoFish", 8)
makeToggle(fishPage, "Auto Sell", "AutoSell", 40)
makeToggle(fishPage, "Sell When Full", "SellFull", 72)
makeLabel(fishPage, "Mode: Legit = click | Fast = remote", 104)
makeButton(fishPage, "Mode: Legit", 128, function() flags.FishMode="Legit" end)
makeButton(fishPage, "Mode: Fast", 160, function() flags.FishMode="Fast" end)
local fishStatus = makeLabel(fishPage, "Status: Idle", 200)

-- CRAFT PAGE
local craftPage = pages["Craft"]
makeToggle(craftPage, "Auto Craft (walk NPC)", "AutoCraft", 8)
makeLabel(craftPage, "NPC: Stella / Jake", 40)
makeButton(craftPage, "Set Stella", 64, function() flags.CraftType="Stella" end)
makeButton(craftPage, "Set Jake", 96, function() flags.CraftType="Jake" end)
makeLabel(craftPage, "Target: "..flags.CraftTarget, 130)
makeButton(craftPage, "Fortune Potion I", 154, function() flags.CraftTarget="Fortune Potion I" end)
makeButton(craftPage, "Heavenly Potion", 186, function() flags.CraftTarget="Heavenly Potion" end)
makeButton(craftPage, "Glass Candle", 218, function() flags.CraftTarget="Glass Candle" end)
makeButton(craftPage, "Luck Glove", 250, function() flags.CraftTarget="Luck Glove" end)
makeButton(craftPage, "Exo Gauntlet", 282, function() flags.CraftTarget="Exo Gauntlet" end)

-- BOSS PAGE
local bossPage = pages["Boss"]
makeToggle(bossPage, "Auto Boss Float+Spam", "AutoBoss", 8)
makeLabel(bossPage, "Bay len + spam E T F R Q", 40)

-- MERCH PAGE
local merchPage = pages["Merch"]
makeToggle(merchPage, "Auto Mari", "AutoMari", 8)
makeToggle(merchPage, "Auto Jester", "AutoJester", 40)
makeToggle(merchPage, "Auto Rin", "AutoRin", 72)
makeToggle(merchPage, "Use Teleporter", "UseTele", 104)
makeLabel(merchPage, "Mari/Jester/Rin full items", 140)

-- QUEST PAGE
local questPage = pages["Quest"]
makeToggle(questPage, "Auto Daily", "AutoDaily", 8)
makeToggle(questPage, "Auto Board", "AutoBoard", 40)

-- VISUAL PAGE
local visualPage = pages["Visual"]
makeToggle(visualPage, "Play Music", "PlayMusic", 8)
makeButton(visualPage, "Equip Dreammetric", 40, function()
    pcall(function()
        local s = Instance.new("Sound")
        s.SoundId = "rbxassetid://9047050075"
        s.Volume = 1.5
        s.Looped = true
        s.Parent = SoundService
        s:Play()
    end)
end)
makeButton(visualPage, "Stop Music", 72, function()
    for _,s in pairs(SoundService:GetChildren()) do
        if s:IsA("Sound") then s:Stop() s:Destroy() end
    end
end)

-- LIMBO PAGE
local limboPage = pages["Limbo"]
makeToggle(limboPage, "Auto Limbo", "AutoLimbo", 8)
makeLabel(limboPage, "Stella 2nd: 30 Ink + 20 Ash + 13 LEAK + 1 Undefined", 40)
makeLabel(limboPage, "Craft Glass Candle (Stella Candle + NULL?)", 62)
makeLabel(limboPage, "Cave -> Unnamed Entity -> use Glass Candle", 84)
makeLabel(limboPage, "Candle1: NULL + stand 20s no roll", 106)
makeLabel(limboPage, "Candle2: TRUE VISION + 3/8 symbols", 128)
makeLabel(limboPage, "Candle3: Torch + Undefined -> black fire", 150)
makeLabel(limboPage, "Candle4: NULL? -> Grail of Resonance", 172)
makeLabel(limboPage, "Portal opens -> THE LIMBO", 194)
local limboStatus = makeLabel(limboPage, "Progress: detecting...", 230)

-- MISC PAGE
local miscPage = pages["Misc"]
makeToggle(miscPage, "Fix Lag", "FixLag", 8)
makeButton(miscPage, "Anti AFK ON", 40, function()
    local vu = game:GetService("VirtualUser")
    LP.Idled:Connect(function()
        vu:Button2Down(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
        task.wait(1)
        vu:Button2Up(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
    end)
end)
makeButton(miscPage, "TOGGLE UI", 80, function()
    flags.UIVisible = not flags.UIVisible
    Main.Visible = flags.UIVisible
end)

CloseBtn.MouseButton1Click:Connect(function()
    flags.UIVisible = false
    Main.Visible = false
end)

-- default tab
switchTab("Main")
for _,b in pairs(TabBar:GetChildren()) do
    if b:IsA("TextButton") and b.Text=="Main" then
        b.BackgroundColor3 = Color3.fromRGB(0, 160, 60)
    end
end

-- floating reopen button (when UI hidden)
local OpenBtn = Instance.new("TextButton")
OpenBtn.Size = UDim2.new(0, 50, 0, 50)
OpenBtn.Position = UDim2.new(0, 10, 0.5, -25)
OpenBtn.BackgroundColor3 = Color3.fromRGB(0, 160, 60)
OpenBtn.Text = "A6"
OpenBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
OpenBtn.Font = Enum.Font.GothamBold
OpenBtn.TextSize = 16
OpenBtn.Visible = false
OpenBtn.Parent = ScreenGui
local oc = Instance.new("UICorner")
oc.CornerRadius = UDim.new(1, 0)
oc.Parent = OpenBtn

OpenBtn.MouseButton1Click:Connect(function()
    flags.UIVisible = true
    Main.Visible = true
    OpenBtn.Visible = false
end)

-- watch visibility
task.spawn(function()
    while task.wait(0.3) do
        OpenBtn.Visible = not Main.Visible
    end
end)

print("[A6Hub] Custom Green UI loaded - no cursor")

-- ========== LOGIC ==========
local function walkTo(pos)
    if not Root or not Hum then return end
    Hum:MoveTo(pos)
    local t = tick()
    while (Root.Position - pos).Magnitude > 6 and tick()-t < 15 do
        Hum:MoveTo(pos)
        task.wait(0.25)
    end
end

local function findNPC(name)
    for _,v in pairs(workspace:GetDescendants()) do
        if v:IsA("Model") and v.Name:lower():find(name:lower()) then
            return v:FindFirstChild("HumanoidRootPart") or v.PrimaryPart
        end
    end
end

local FishSpots = {
    Vector3.new(150,5,0), Vector3.new(-150,5,0),
    Vector3.new(0,5,150), Vector3.new(0,5,-150),
    Vector3.new(120,5,120), Vector3.new(-120,5,120),
}

local function getNearestFishSpot()
    local nearest, dist = nil, math.huge
    for _,pos in ipairs(FishSpots) do
        local d = (Root.Position - pos).Magnitude
        if d < dist then dist=d nearest=pos end
    end
    for _,v in pairs(workspace:GetDescendants()) do
        if v:IsA("BasePart") and (v.Name:lower():find("water") or v.Name:lower():find("ocean")) then
            local d = (Root.Position - v.Position).Magnitude
            if d < dist and d < 300 then dist=d nearest=v.Position+Vector3.new(0,3,0) end
        end
    end
    return nearest
end

-- FISH
task.spawn(function()
    local went = false
    while task.wait(0.4) do
        if flags.AutoFish then
            if not went then
                local spot = getNearestFishSpot()
                if spot then walkTo(spot) went=true end
            end
            pcall(function()
                if flags.FishMode == "Fast" then
                    local rem = RS:FindFirstChild("Remotes")
                    if rem then
                        local s = rem:FindFirstChild("StartFishing") or rem:FindFirstChild("Fish") or rem:FindFirstChild("Cast")
                        if s then s:FireServer() end
                        local r = rem:FindFirstChild("Reel") or rem:FindFirstChild("CatchFish")
                        if r then r:FireServer(true) end
                    end
                else
                    local gui = LP.PlayerGui:FindFirstChild("Fishing") or LP.PlayerGui:FindFirstChild("Fish")
                    if gui then
                        local btn = gui:FindFirstChild("FishButton") or gui:FindFirstChild("Cast")
                        if btn then firesignal(btn.MouseButton1Click) end
                    end
                    local reel = LP.PlayerGui:FindFirstChild("Reel") or LP.PlayerGui:FindFirstChild("FishingMinigame")
                    if reel then
                        mouse1press()
                        for i=1,8 do mouse1click() task.wait(0.06) end
                        mouse1release()
                    end
                end
            end)
            if fishStatus then fishStatus.Text = "Status: "..flags.FishMode.." fishing" end
        else
            went = false
            if fishStatus then fishStatus.Text = "Status: Idle" end
        end
        if flags.AutoSell or flags.SellFull then
            pcall(function()
                local rem = RS:FindFirstChild("Remotes")
                if rem then
                    local s = rem:FindFirstChild("SellFish") or rem:FindFirstChild("SellAllFish")
                    if s then s:FireServer("All") end
                end
            end)
        end
    end
end)

-- CRAFT
task.spawn(function()
    while task.wait(4) do
        if flags.AutoCraft then
            pcall(function()
                local npc = findNPC(flags.CraftType)
                if npc then
                    walkTo(npc.Position)
                    task.wait(0.6)
                    local rem = RS:FindFirstChild("Remotes")
                    if rem then
                        local r = rem:FindFirstChild("CraftItem") or rem:FindFirstChild("Craft") or rem:FindFirstChild("Brew")
                        if r then r:FireServer(flags.CraftTarget) end
                    end
                end
            end)
        end
    end
end)

-- BOSS
task.spawn(function()
    while task.wait(0.22) do
        if flags.AutoBoss then
            pcall(function()
                local bv = Root:FindFirstChild("A6Float") or Instance.new("BodyVelocity")
                bv.Name = "A6Float"
                bv.MaxForce = Vector3.new(0,60000,0)
                bv.Velocity = Vector3.zero
                bv.Parent = Root
                Root.CFrame = CFrame.new(Root.Position.X, 55, Root.Position.Z)
                for _,k in ipairs({"E","T","F","R","Q"}) do
                    keypress(Enum.KeyCode[k]) task.wait(0.04) keyrelease(Enum.KeyCode[k])
                end
            end)
        else
            local bv = Root:FindFirstChild("A6Float")
            if bv then bv:Destroy() end
        end
    end
end)

-- MERCH
local mariItems = {"Lucky Potion","Lucky Potion L","Speed Potion","Speed Potion L","Mixed Potion","Lucky Penny","Void Coin"}
local jesterTrade = {"Icicle","Wind Essence","Rainy Bottle","Hour Glass","Eternal Flame","Piece of Star","Curruptaine","NULL?"}
local rinItems = {"Sunstone Talisman","Moonstone Talisman","Day and Night Talisman","Overtime Talisman"}

task.spawn(function()
    while task.wait(1.2) do
        pcall(function()
            for _,npc in pairs(workspace:GetChildren()) do
                if npc:IsA("Model") and (npc.Name=="Mari" or npc.Name=="Jester" or npc.Name=="Rin") then
                    if flags.UseTele then
                        local t = LP.Backpack:FindFirstChild("Merchant Teleporter") or Char:FindFirstChild("Merchant Teleporter")
                        if t then t:Activate() end
                    else
                        local hrp = npc:FindFirstChild("HumanoidRootPart") or npc.PrimaryPart
                        if hrp then walkTo(hrp.Position) end
                    end
                    task.wait(0.4)
                    local rem = RS:FindFirstChild("Remotes")
                    if npc.Name=="Mari" and flags.AutoMari and rem then
                        local buy = rem:FindFirstChild("BuyItem") or rem:FindFirstChild("Purchase")
                        if buy then for _,i in ipairs(mariItems) do buy:FireServer(i) end end
                    elseif npc.Name=="Jester" and flags.AutoJester and rem then
                        local ex = rem:FindFirstChild("Exchange") or rem:FindFirstChild("Trade")
                        if ex then for _,i in ipairs(jesterTrade) do ex:FireServer(i, 1) end end
                    elseif npc.Name=="Rin" and flags.AutoRin and rem then
                        local buy = rem:FindFirstChild("BuyItem") or rem:FindFirstChild("Purchase")
                        if buy then for _,i in ipairs(rinItems) do buy:FireServer(i) end end
                    end
                end
            end
        end)
    end
end)

-- QUEST
task.spawn(function()
    while task.wait(3.5) do
        if flags.AutoDaily then pcall(function() local r=RS.Remotes and RS.Remotes:FindFirstChild("ClaimDaily") if r then r:FireServer() end end) end
        if flags.AutoBoard then pcall(function() local r=RS.Remotes and RS.Remotes:FindFirstChild("AcceptQuest") if r then r:FireServer() end end) end
    end
end)

-- LIMBO detect
task.spawn(function()
    while task.wait(2.5) do
        local hasGlass, hasRecipe, inLimbo = false, false, false
        pcall(function()
            for _,i in pairs(LP.Backpack:GetChildren()) do
                local n = i.Name:lower()
                if n:find("glass candle") and not n:find("recipe") then hasGlass=true end
                if n:find("recipe") then hasRecipe=true end
            end
            if workspace:FindFirstChild("Limbo") or (Root and Root.Position.Y < -80) then inLimbo=true end
        end)
        if limboStatus then
            limboStatus.Text = "Recipe:"..(hasRecipe and "Y" or "N").." Glass:"..(hasGlass and "Y" or "N").." Limbo:"..(inLimbo and "Y" or "N")
        end
        if flags.AutoLimbo then
            pcall(function()
                local rem = RS.Remotes
                if rem then
                    for _,n in ipairs({"ClaimQuest","StellaQuest","CraftItem","Craft"}) do
                        local r = rem:FindFirstChild(n)
                        if r then r:FireServer() end
                    end
                end
            end)
        end
    end
end)

-- FIX LAG
task.spawn(function()
    while task.wait(2) do
        if flags.FixLag then
            pcall(function()
                settings().Rendering.QualityLevel = 1
                for _,o in pairs(workspace:GetDescendants()) do
                    if o:IsA("ParticleEmitter") or o:IsA("Trail") or o:IsA("Beam") then o.Enabled=false end
                end
            end)
        end
    end
end)
