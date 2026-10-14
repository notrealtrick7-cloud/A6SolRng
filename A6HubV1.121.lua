--[[
    A6HubV1.121
    Full Auto Hub for Sol's RNG
    Fish: nearest spot + Fast/Legit
    Craft: walk to Stella/Jake
    Merchant: full Mari/Jester/Rin
    Limbo: full progress + detailed steps
    Visual + Music
    No tele / No speed
]]

local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/violin-suzutsuki/LinoriaLib/main/Library.lua"))()
local ThemeManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/violin-suzutsuki/LinoriaLib/main/addons/ThemeManager.lua"))()
local SaveManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/violin-suzutsuki/LinoriaLib/main/addons/SaveManager.lua"))()

local Window = Library:CreateWindow({
    Title = "A6HubV1.121",
    Center = true,
    AutoShow = true,
    TabPadding = 4,
    MenuFadeTime = 0.15,
    Size = UDim2.fromOffset(470, 450)
})

local Tabs = {
    Main = Window:AddTab("Main"),
    Fish = Window:AddTab("Fish"),
    Craft = Window:AddTab("Craft"),
    Boss = Window:AddTab("Boss"),
    Merch = Window:AddTab("Merch"),
    Quest = Window:AddTab("Quest"),
    Visual = Window:AddTab("Visual"),
    Limbo = Window:AddTab("Limbo"),
    Misc = Window:AddTab("Misc")
}

local Players = game:GetService("Players")
local RS = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local SoundService = game:GetService("SoundService")
local LP = Players.LocalPlayer
local Char = LP.Character or LP.CharacterAdded:Wait()
local Hum = Char:WaitForChild("Humanoid")
local Root = Char:WaitForChild("HumanoidRootPart")

LP.CharacterAdded:Connect(function(c)
    Char = c
    Hum = c:WaitForChild("Humanoid")
    Root = c:WaitForChild("HumanoidRootPart")
end)

local flags = {
    AutoFish=false, AutoSell=false, SellFull=true, FishMode="Legit",
    AutoCraft=false, CraftTarget="Fortune Potion I", CraftType="Stella",
    AutoBoss=false, AutoMari=false, AutoJester=false, AutoRin=false,
    UseTele=false, AutoDaily=false, AutoBoard=false,
    AutoLimbo=false, FixLag=false, PlayMusic=true
}

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

-- ========== FISH SPOTS ==========
local FishSpots = {
    Vector3.new(150, 5, 0), Vector3.new(-150, 5, 0),
    Vector3.new(0, 5, 150), Vector3.new(0, 5, -150),
    Vector3.new(120, 5, 120), Vector3.new(-120, 5, 120),
    Vector3.new(120, 5, -120), Vector3.new(-120, 5, -120),
    Vector3.new(80, 5, 180), Vector3.new(-80, 5, 180),
}

local function getNearestFishSpot()
    local nearest, dist = nil, math.huge
    for _,pos in ipairs(FishSpots) do
        local d = (Root.Position - pos).Magnitude
        if d < dist then dist = d nearest = pos end
    end
    for _,v in pairs(workspace:GetDescendants()) do
        if v:IsA("BasePart") and (v.Name:lower():find("water") or v.Name:lower():find("ocean") or v.Name:lower():find("sea")) then
            local d = (Root.Position - v.Position).Magnitude
            if d < dist and d < 300 then
                dist = d
                nearest = v.Position + Vector3.new(0, 3, 0)
            end
        end
    end
    return nearest
end

-- ========== MAIN ==========
local MainBox = Tabs.Main:AddLeftGroupbox("Quick")
MainBox:AddToggle("qFish", {Text="Auto Fish", Default=false, Callback=function(v) flags.AutoFish=v end})
MainBox:AddToggle("qSell", {Text="Auto Sell", Default=false, Callback=function(v) flags.AutoSell=v end})
MainBox:AddToggle("qCraft", {Text="Auto Craft", Default=false, Callback=function(v) flags.AutoCraft=v end})
MainBox:AddToggle("qBoss", {Text="Auto Boss", Default=false, Callback=function(v) flags.AutoBoss=v end})
MainBox:AddToggle("qMerch", {Text="Auto Merch", Default=false, Callback=function(v) flags.AutoMari=v; flags.AutoJester=v; flags.AutoRin=v end})
MainBox:AddToggle("qQuest", {Text="Auto Quest", Default=false, Callback=function(v) flags.AutoDaily=v; flags.AutoBoard=v end})
MainBox:AddToggle("qLimbo", {Text="Auto Limbo", Default=false, Callback=function(v) flags.AutoLimbo=v end})

-- ========== FISH ==========
local FishBox = Tabs.Fish:AddLeftGroupbox("Auto Fish")
FishBox:AddToggle("fAuto", {Text="Auto Fish", Default=false, Callback=function(v) flags.AutoFish=v end})
FishBox:AddDropdown("fMode", {
    Values = {"Legit", "Fast"},
    Default = 1,
    Text = "Mode",
    Callback = function(v) flags.FishMode = v end
})
FishBox:AddToggle("fSell", {Text="Auto Sell", Default=false, Callback=function(v) flags.AutoSell=v end})
FishBox:AddToggle("fFull", {Text="Sell When Full", Default=true, Callback=function(v) flags.SellFull=v end})
local fishStatus = FishBox:AddLabel("Status: Idle")
FishBox:AddLabel("Legit = click minigame dung cach\nFast = dung im + remote")

local function fishFast()
    pcall(function()
        local rem = RS:FindFirstChild("Remotes")
        if rem then
            local start = rem:FindFirstChild("StartFishing") or rem:FindFirstChild("Fish") or rem:FindFirstChild("Cast")
            if start then start:FireServer() end
            local reel = rem:FindFirstChild("Reel") or rem:FindFirstChild("CatchFish") or rem:FindFirstChild("FinishFishing")
            if reel then reel:FireServer(true) end
        end
        local gui = LP.PlayerGui:FindFirstChild("Fishing") or LP.PlayerGui:FindFirstChild("Fish")
        if gui then
            local btn = gui:FindFirstChild("FishButton") or gui:FindFirstChild("Cast")
            if btn then firesignal(btn.MouseButton1Click) end
        end
    end)
end

local function fishLegit()
    pcall(function()
        local gui = LP.PlayerGui:FindFirstChild("Fishing") or LP.PlayerGui:FindFirstChild("Fish") or LP.PlayerGui:FindFirstChild("FishingGui")
        if gui then
            local btn = gui:FindFirstChild("FishButton") or gui:FindFirstChild("Cast") or gui:FindFirstChild("Start")
            if btn and btn.Visible then firesignal(btn.MouseButton1Click) end
        end
        local reelGui = LP.PlayerGui:FindFirstChild("Reel") or LP.PlayerGui:FindFirstChild("FishingMinigame") or LP.PlayerGui:FindFirstChild("Minigame")
        if reelGui then
            mouse1press()
            task.wait(0.12)
            for i=1,10 do mouse1click() task.wait(0.07) end
            mouse1release()
        end
    end)
end

task.spawn(function()
    local wentToSpot = false
    while task.wait(0.4) do
        if flags.AutoFish then
            if not wentToSpot then
                local spot = getNearestFishSpot()
                if spot then
                    fishStatus:SetText("Going to nearest spot...")
                    walkTo(spot)
                    wentToSpot = true
                    task.wait(0.5)
                end
            end
            if flags.FishMode == "Fast" then
                fishStatus:SetText("Fast fishing...")
                fishFast()
            else
                fishStatus:SetText("Legit fishing...")
                fishLegit()
            end
        else
            wentToSpot = false
            fishStatus:SetText("Status: Idle")
        end
        if flags.AutoSell or flags.SellFull then
            pcall(function()
                local rem = RS:FindFirstChild("Remotes")
                if rem then
                    local s = rem:FindFirstChild("SellFish") or rem:FindFirstChild("SellAllFish") or rem:FindFirstChild("FishSell")
                    if s then s:FireServer("All") end
                end
            end)
        end
    end
end)

-- ========== CRAFT ==========
local CraftBox = Tabs.Craft:AddLeftGroupbox("Craft")
local potions = {"Fortune Potion I","Fortune Potion II","Fortune Potion III","Haste Potion I","Haste Potion II","Haste Potion III","Jewelry Potion","Zombie Potion","Rage Potion","Diver Potion","Potion of Bound","Heavenly Potion","Godlike Potion","Glass Candle"}
local gloves = {"Luck Glove","Desire Glove","Lunar Device","Solar Device","Frozen Gauntlet","Jackpot Gauntlet","Subzero Device","Galactic Device","Gravitational Device","Exo Gauntlet","Singularity Gauntlet","Strange Controller","Item Collector"}

CraftBox:AddToggle("cAuto", {Text="Auto Craft (walk NPC)", Default=false, Callback=function(v) flags.AutoCraft=v end})
CraftBox:AddDropdown("cType", {Values={"Stella","Jake"}, Default=1, Text="NPC", Callback=function(v) flags.CraftType=v end})
CraftBox:AddDropdown("cPot", {Values=potions, Default=1, Text="Stella Potion", Callback=function(v) if flags.CraftType=="Stella" then flags.CraftTarget=v end end})
CraftBox:AddDropdown("cGlove", {Values=gloves, Default=1, Text="Jake Item", Callback=function(v) if flags.CraftType=="Jake" then flags.CraftTarget=v end end})
local craftStatus = CraftBox:AddLabel("Status: Idle")

task.spawn(function()
    while task.wait(4) do
        if flags.AutoCraft then
            pcall(function()
                local npc = findNPC(flags.CraftType)
                if npc then
                    craftStatus:SetText("Walking to "..flags.CraftType)
                    walkTo(npc.Position)
                    task.wait(0.7)
                    local rem = RS:FindFirstChild("Remotes")
                    if rem then
                        local r = rem:FindFirstChild("CraftItem") or rem:FindFirstChild("Craft") or rem:FindFirstChild("Brew")
                        if r then r:FireServer(flags.CraftTarget) end
                    end
                    craftStatus:SetText("Crafted: "..flags.CraftTarget)
                end
            end)
        end
    end
end)

-- ========== BOSS ==========
local BossBox = Tabs.Boss:AddLeftGroupbox("Boss")
local flyH = 55
BossBox:AddToggle("bAuto", {Text="Auto Boss", Default=false, Callback=function(v) flags.AutoBoss=v end})
BossBox:AddSlider("bH", {Text="Height", Default=55, Min=25, Max=130, Rounding=0, Callback=function(v) flyH=v end})

task.spawn(function()
    while task.wait(0.22) do
        if flags.AutoBoss then
            pcall(function()
                local bv = Root:FindFirstChild("A6Float") or Instance.new("BodyVelocity")
                bv.Name = "A6Float"
                bv.MaxForce = Vector3.new(0,60000,0)
                bv.Velocity = Vector3.zero
                bv.Parent = Root
                Root.CFrame = CFrame.new(Root.Position.X, flyH, Root.Position.Z)
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

-- ========== MERCHANT ==========
local MerchBox = Tabs.Merch:AddLeftGroupbox("Merchant")
local tradeAmt = 1
local mariItems = {"Lucky Potion","Lucky Potion L","Lucky Potion XL","Speed Potion","Speed Potion L","Speed Potion XL","Mixed Potion","Fortune Spoid I","Fortune Spoid II","Fortune Spoid III","Gear A","Gear B","Lucky Penny","Void Coin"}
local jesterTrade = {"Icicle","Wind Essence","Rainy Bottle","Hour Glass","Eternal Flame","Piece of Star","Curruptaine","NULL?","Feather Vial"}
local jesterBuy = {"Lucky Potion","Speed Potion","Random Potion Sack","Stella's Star","Rune of Wind","Rune of Frost","Rune of Rainstorm","Rune of Hell","Rune of Galaxy","Rune of Corruption","Rune of Nothing","Rune of Everything","Strange Potion I","Strange Potion II","Stella's Candle","Potion of Bound","Heavenly Potion","Merchant Tracker","Oblivion Potion"}
local rinItems = {"Sunstone Talisman","Moonstone Talisman","Day and Night Talisman","Overtime Talisman","Soul Collector's Talisman","Soul Master's Talisman"}

MerchBox:AddToggle("mMari", {Text="Auto Mari", Default=false, Callback=function(v) flags.AutoMari=v end})
MerchBox:AddToggle("mJester", {Text="Auto Jester", Default=false, Callback=function(v) flags.AutoJester=v end})
MerchBox:AddSlider("mAmt", {Text="Trade Amount", Default=1, Min=1, Max=9999, Rounding=0, Callback=function(v) tradeAmt=v end})
MerchBox:AddToggle("mRin", {Text="Auto Rin", Default=false, Callback=function(v) flags.AutoRin=v end})
MerchBox:AddToggle("mTele", {Text="Use Teleporter", Default=false, Callback=function(v) flags.UseTele=v end})
local merchStatus = MerchBox:AddLabel("Waiting...")

task.spawn(function()
    while task.wait(1.2) do
        pcall(function()
            local found = false
            for _,npc in pairs(workspace:GetChildren()) do
                if npc:IsA("Model") and (npc.Name=="Mari" or npc.Name=="Jester" or npc.Name=="Rin") then
                    found = true
                    merchStatus:SetText("Found: "..npc.Name)
                    if flags.UseTele then
                        local t = LP.Backpack:FindFirstChild("Merchant Teleporter") or Char:FindFirstChild("Merchant Teleporter")
                        if t then t:Activate() end
                    else
                        local hrp = npc:FindFirstChild("HumanoidRootPart") or npc.PrimaryPart
                        if hrp then walkTo(hrp.Position) end
                    end
                    task.wait(0.5)
                    local rem = RS:FindFirstChild("Remotes")
                    if npc.Name=="Mari" and flags.AutoMari and rem then
                        local buy = rem:FindFirstChild("BuyItem") or rem:FindFirstChild("Purchase")
                        if buy then for _,i in ipairs(mariItems) do buy:FireServer(i) end end
                    elseif npc.Name=="Jester" and flags.AutoJester and rem then
                        local ex = rem:FindFirstChild("Exchange") or rem:FindFirstChild("Trade")
                        if ex then for _,i in ipairs(jesterTrade) do ex:FireServer(i, tradeAmt) end end
                        local buy = rem:FindFirstChild("BuyItem") or rem:FindFirstChild("Purchase")
                        if buy then for _,i in ipairs(jesterBuy) do buy:FireServer(i) end end
                    elseif npc.Name=="Rin" and flags.AutoRin and rem then
                        local buy = rem:FindFirstChild("BuyItem") or rem:FindFirstChild("Purchase")
                        if buy then for _,i in ipairs(rinItems) do buy:FireServer(i) end end
                        local q = rem:FindFirstChild("RinQuest")
                        if q then q:FireServer() end
                    end
                end
            end
            if not found then merchStatus:SetText("Waiting merchant...") end
        end)
    end
end)

-- ========== QUEST ==========
local QuestBox = Tabs.Quest:AddLeftGroupbox("Quest")
QuestBox:AddToggle("qDaily", {Text="Auto Daily", Default=false, Callback=function(v) flags.AutoDaily=v end})
QuestBox:AddToggle("qBoard", {Text="Auto Board", Default=false, Callback=function(v) flags.AutoBoard=v end})

task.spawn(function()
    while task.wait(3.5) do
        if flags.AutoDaily then pcall(function() local r=RS.Remotes and RS.Remotes:FindFirstChild("ClaimDaily") if r then r:FireServer() end end) end
        if flags.AutoBoard then pcall(function() local r=RS.Remotes and RS.Remotes:FindFirstChild("AcceptQuest") if r then r:FireServer() end end) end
    end
end)

-- ========== VISUAL ==========
local VisBox = Tabs.Visual:AddLeftGroupbox("Visual")
local selectedAura = "Equinox"
local currentSound = nil
local auraList = {"Equinox","Dreammetric","Glitch","Luminosity","Oppression","Pixelation","Monarch","Leviathan","Oblivion","Memory"}
local AuraMusic = {Dreammetric=9047050075}

VisBox:AddDropdown("vAura", {Values=auraList, Default=1, Text="Aura", Callback=function(v) selectedAura=v end})
VisBox:AddToggle("vMusic", {Text="Play Music", Default=true, Callback=function(v) flags.PlayMusic=v end})
VisBox:AddButton("Equip Visual", function()
    pcall(function()
        for _,a in pairs(auraList) do local o=Char:FindFirstChild(a) if o then o:Destroy() end end
        if currentSound then currentSound:Stop() currentSound:Destroy() currentSound=nil end
        local folder = RS:FindFirstChild("Auras") or RS:FindFirstChild("AuraAssets")
        if folder and folder:FindFirstChild(selectedAura) then
            local c = folder[selectedAura]:Clone()
            c.Name = selectedAura
            c.Parent = Char
        else
            local p = Instance.new("Part")
            p.Name = selectedAura
            p.Size = Vector3.new(0.2,0.2,0.2)
            p.Transparency = 1
            p.CanCollide = false
            p.Parent = Char
            local w = Instance.new("Weld")
            w.Part0 = Root
            w.Part1 = p
            w.Parent = p
            local att = Instance.new("Attachment", p)
            local pe = Instance.new("ParticleEmitter", att)
            pe.Rate = 45
            pe.Lifetime = NumberSequence.new(0.65)
            pe.Color = ColorSequence.new(Color3.fromRGB(170,90,255))
        end
        if flags.PlayMusic and AuraMusic[selectedAura] then
            currentSound = Instance.new("Sound")
            currentSound.SoundId = "rbxassetid://"..AuraMusic[selectedAura]
            currentSound.Volume = 1.5
            currentSound.Looped = true
            currentSound.Parent = SoundService
            currentSound:Play()
        end
    end)
end)
VisBox:AddButton("Remove Visual", function()
    pcall(function()
        for _,a in pairs(auraList) do local o=Char:FindFirstChild(a) if o then o:Destroy() end end
        if currentSound then currentSound:Stop() currentSound:Destroy() currentSound=nil end
    end)
end)

-- ========== LIMBO FULL DETAILED ==========
local LimboBox = Tabs.Limbo:AddLeftGroupbox("Limbo Full")
local limboStatus = LimboBox:AddLabel("Detecting progress...")
local limboStep = LimboBox:AddLabel("Current step: ...")

LimboBox:AddToggle("lAuto", {Text="Auto Limbo (claim/craft/remote)", Default=false, Callback=function(v) flags.AutoLimbo=v end})

LimboBox:AddLabel([[
=== BUOC 1: STELLA 2ND QUEST ===
Yeu cau: xong Portal quest + >=10k rolls
Can roll:
• 30 Ink (1/700 any biome)
• 20 Ash (1/2300 any biome)
• 13 LEAK (1/14000 any biome)
• 1 Undefined (1/1.111M → 1/1111 o NULL)

Nop → nhan Glass Candle Recipe
Craft: 1 Stella's Candle + 1 NULL? (hoac Jester Candle)
]])

LimboBox:AddLabel([[
=== BUOC 2: VAO PHONG NEN ===
1. Vao Cave gan Stella Sanctuary
2. Lam hidden obby (waterfall)
3. Toi tuong Unnamed Entity (con mat dong)
4. Dung Glass Candle → mat mo → vao Limbo Room
]])

LimboBox:AddLabel([[
=== BUOC 3: 4 NEN (permanent khi sang) ===
Nen 1 (NULL Idle):
• Doi biome NULL xuat hien
• Vao lai phong nen
• Tat auto-roll + unequip aura
• Dung DUNG TREN nen 20 giay khong roll

Nen 2 (Symbols):
• Bat TRUE VISION tu Glass Candle
• Tim 3 symbol (trong 8 vi tri random moi server)
• Om tuong / cham symbol (khong can sang)
• Phai lam trong 1 session (rejoin reset)

Nen 3 (Black Torch):
• Lay torch o giua phong / truoc Cave Obby
• Equip Undefined / Nihility / Defined
• Doi lua doi thanh den
• Dua den nen 3

Nen 4 (NULL Resonance):
• Lay item NULL? khi biome NULL
• Dua len nui → bo vao Grail of Resonance
• Co buff NULL Resonance → nen sang
]])

LimboBox:AddLabel([[
=== BUOC 4: VAO LIMBO ===
Khi 4 nen sang → cutscene + portal mo
Nhay vao portal → THE LIMBO
Nhan Portable Crack (de quay lai sau)
]])

LimboBox:AddLabel([[
=== SYMBOL LOCATIONS (8 cho) ===
1. Ra Stella Sanctuary → trai → duoi crystal
2. Duong Stella → nhay trai → khe nuoc (safe zone)
3. Lava Obby → phai Torchbearer → cot da nam xanh
4. Lava Obby → trai Torchbearer → khe tuong nam lon
5. Duong Unnamed Entity → nam xanh (truoc leo)
6. Goc xa nhat nam xanh lon → nhin xuong lava
7. Tuong tren nam xanh (dung camera)
8. Goc xa nhat khi vao cave thuong
Can TRUE VISION moi thay ro
]])

-- Progress detect chi tiet
local function detectLimboFull()
    local p = {
        hasRecipe = false,
        hasGlass = false,
        hasStellaCandle = false,
        hasNullItem = false,
        candle1 = false, candle2 = false, candle3 = false, candle4 = false,
        inLimbo = false,
        hasPortableCrack = false,
        currentStep = "Chua bat dau"
    }
    pcall(function()
        local function checkInv(container)
            if not container then return end
            for _,i in pairs(container:GetChildren()) do
                local n = i.Name:lower()
                if n:find("glass candle recipe") or (n:find("recipe") and n:find("glass")) then p.hasRecipe = true end
                if n:find("glass candle") and not n:find("recipe") then p.hasGlass = true end
                if n:find("stella") and n:find("candle") then p.hasStellaCandle = true end
                if n:find("null?") or n == "null?" then p.hasNullItem = true end
                if n:find("portable crack") then p.hasPortableCrack = true end
            end
        end
        checkInv(LP.Backpack)
        checkInv(Char)
        if LP:FindFirstChild("Inventory") then checkInv(LP.Inventory) end

        local stats = LP:FindFirstChild("leaderstats") or LP:FindFirstChild("Stats") or LP:FindFirstChild("Data") or LP:FindFirstChild("PlayerData")
        if stats then
            for _,v in pairs(stats:GetDescendants()) do
                if v:IsA("BoolValue") or v:IsA("IntValue") or v:IsA("NumberValue") then
                    local n = v.Name:lower()
                    local val = (v.Value == true) or (type(v.Value)=="number" and v.Value >= 1)
                    if n:find("candle1") or n:find("candle_1") or n:find("limbo1") then p.candle1 = val end
                    if n:find("candle2") or n:find("candle_2") or n:find("limbo2") then p.candle2 = val end
                    if n:find("candle3") or n:find("candle_3") or n:find("limbo3") then p.candle3 = val end
                    if n:find("candle4") or n:find("candle_4") or n:find("limbo4") then p.candle4 = val end
                    if n:find("limbo") and (n:find("unlock") or n:find("enter") or n:find("access")) then p.inLimbo = val end
                end
            end
        end

        if workspace:FindFirstChild("Limbo") or workspace:FindFirstChild("THE LIMBO") or workspace:FindFirstChild("TheLimbo") then
            p.inLimbo = true
        end
        if Root and Root.Position.Y < -80 then p.inLimbo = true end

        -- determine step
        if p.inLimbo or p.hasPortableCrack then
            p.currentStep = "Da vao Limbo / co Portable Crack"
        elseif p.candle1 and p.candle2 and p.candle3 and p.candle4 then
            p.currentStep = "4 nen xong → vao portal"
        elseif p.hasGlass then
            p.currentStep = "Co Glass Candle → di light 4 nen"
        elseif p.hasRecipe then
            p.currentStep = "Co Recipe → craft Glass Candle"
        else
            p.currentStep = "Can Stella 2nd quest (Ink/Ash/LEAK/Undefined)"
        end
    end)
    return p
end

task.spawn(function()
    while task.wait(2.2) do
        local p = detectLimboFull()
        limboStatus:SetText(
            "Recipe:"..(p.hasRecipe and "Y" or "N")..
            " Glass:"..(p.hasGlass and "Y" or "N")..
            " C1:"..(p.candle1 and "Y" or "N")..
            " C2:"..(p.candle2 and "Y" or "N")..
            " C3:"..(p.candle3 and "Y" or "N")..
            " C4:"..(p.candle4 and "Y" or "N")..
            " Limbo:"..(p.inLimbo and "Y" or "N")
        )
        limboStep:SetText("Step: "..p.currentStep)

        if flags.AutoLimbo then
            pcall(function()
                local rem = RS:FindFirstChild("Remotes")
                if rem then
                    for _,n in ipairs({"ClaimQuest","StellaQuest","LimboQuest","CraftItem","Craft","SubmitQuest","Brew","UseItem"}) do
                        local r = rem:FindFirstChild(n)
                        if r then
                            pcall(function() r:FireServer() end)
                            pcall(function() r:FireServer("Glass Candle") end)
                            pcall(function() r:FireServer(p.currentStep) end)
                        end
                    end
                end
            end)
        end
    end
end)

-- ========== MISC ==========
local MiscBox = Tabs.Misc:AddLeftGroupbox("Misc")
MiscBox:AddToggle("mLag", {Text="Fix Lag", Default=false, Callback=function(v)
    flags.FixLag=v
    if v then
        settings().Rendering.QualityLevel=1
        for _,o in pairs(workspace:GetDescendants()) do
            if o:IsA("ParticleEmitter") or o:IsA("Trail") or o:IsA("Beam") then o.Enabled=false end
        end
    end
end})
MiscBox:AddButton("Anti AFK", function()
    local vu = game:GetService("VirtualUser")
    LP.Idled:Connect(function()
        vu:Button2Down(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
        task.wait(1)
        vu:Button2Up(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
    end)
    Library:Notify("Anti AFK ON", 3)
end)
MiscBox:AddLabel("A6HubV1.121\nNo tele / No walkspeed")

ThemeManager:SetLibrary(Library)
SaveManager:SetLibrary(Library)
SaveManager:IgnoreThemeSettings()
SaveManager:SetFolder("A6HubV1.121")
SaveManager:BuildConfigSection(Tabs.Misc)
ThemeManager:ApplyToTab(Tabs.Misc)

Library:Notify("A6HubV1.121 loaded - Full Limbo", 5)
