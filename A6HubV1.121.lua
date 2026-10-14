--[[
    A6HubV1.121 - Linoria UI (ShowCustomCursor = false)
]]

local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/violin-suzutsuki/LinoriaLib/main/Library.lua"))()
local ThemeManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/violin-suzutsuki/LinoriaLib/main/addons/ThemeManager.lua"))()
local SaveManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/violin-suzutsuki/LinoriaLib/main/addons/SaveManager.lua"))()

Library.ShowCustomCursor = false

local Window = Library:CreateWindow({
    Title = "A6HubV1.121",
    Center = true,
    AutoShow = true,
    TabPadding = 4,
    MenuFadeTime = 0.15,
    Size = UDim2.fromOffset(420, 380),
    ShowCustomCursor = false
})

Library.ShowCustomCursor = false

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

-- MAIN
local MainBox = Tabs.Main:AddLeftGroupbox("Quick")
MainBox:AddToggle("qFish", {Text="Auto Fish", Default=false, Callback=function(v) flags.AutoFish=v end})
MainBox:AddToggle("qSell", {Text="Auto Sell", Default=false, Callback=function(v) flags.AutoSell=v end})
MainBox:AddToggle("qCraft", {Text="Auto Craft", Default=false, Callback=function(v) flags.AutoCraft=v end})
MainBox:AddToggle("qBoss", {Text="Auto Boss", Default=false, Callback=function(v) flags.AutoBoss=v end})
MainBox:AddToggle("qMerch", {Text="Auto Merch", Default=false, Callback=function(v) flags.AutoMari=v; flags.AutoJester=v; flags.AutoRin=v end})
MainBox:AddToggle("qQuest", {Text="Auto Quest", Default=false, Callback=function(v) flags.AutoDaily=v; flags.AutoBoard=v end})
MainBox:AddToggle("qLimbo", {Text="Auto Limbo", Default=false, Callback=function(v) flags.AutoLimbo=v end})
MainBox:AddButton("Toggle UI", function() Library:Toggle() end)

-- FISH
local FishBox = Tabs.Fish:AddLeftGroupbox("Auto Fish")
FishBox:AddToggle("fAuto", {Text="Auto Fish", Default=false, Callback=function(v) flags.AutoFish=v end})
FishBox:AddDropdown("fMode", {Values={"Legit","Fast"}, Default=1, Text="Mode", Callback=function(v) flags.FishMode=v end})
FishBox:AddToggle("fSell", {Text="Auto Sell", Default=false, Callback=function(v) flags.AutoSell=v end})
FishBox:AddToggle("fFull", {Text="Sell When Full", Default=true, Callback=function(v) flags.SellFull=v end})
local fishStatus = FishBox:AddLabel("Status: Idle")

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
            fishStatus:SetText("Status: "..flags.FishMode)
        else
            went = false
            fishStatus:SetText("Status: Idle")
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
local CraftBox = Tabs.Craft:AddLeftGroupbox("Craft")
local potions = {"Fortune Potion I","Fortune Potion II","Fortune Potion III","Haste Potion I","Heavenly Potion","Godlike Potion","Glass Candle"}
local gloves = {"Luck Glove","Exo Gauntlet","Strange Controller","Item Collector"}
CraftBox:AddToggle("cAuto", {Text="Auto Craft", Default=false, Callback=function(v) flags.AutoCraft=v end})
CraftBox:AddDropdown("cType", {Values={"Stella","Jake"}, Default=1, Text="NPC", Callback=function(v) flags.CraftType=v end})
CraftBox:AddDropdown("cPot", {Values=potions, Default=1, Text="Stella", Callback=function(v) if flags.CraftType=="Stella" then flags.CraftTarget=v end end})
CraftBox:AddDropdown("cGlove", {Values=gloves, Default=1, Text="Jake", Callback=function(v) if flags.CraftType=="Jake" then flags.CraftTarget=v end end})

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
local BossBox = Tabs.Boss:AddLeftGroupbox("Boss")
BossBox:AddToggle("bAuto", {Text="Auto Boss", Default=false, Callback=function(v) flags.AutoBoss=v end})

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
local MerchBox = Tabs.Merch:AddLeftGroupbox("Merchant")
MerchBox:AddToggle("mMari", {Text="Auto Mari", Default=false, Callback=function(v) flags.AutoMari=v end})
MerchBox:AddToggle("mJester", {Text="Auto Jester", Default=false, Callback=function(v) flags.AutoJester=v end})
MerchBox:AddToggle("mRin", {Text="Auto Rin", Default=false, Callback=function(v) flags.AutoRin=v end})
MerchBox:AddToggle("mTele", {Text="Use Teleporter", Default=false, Callback=function(v) flags.UseTele=v end})

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
local QuestBox = Tabs.Quest:AddLeftGroupbox("Quest")
QuestBox:AddToggle("qDaily", {Text="Auto Daily", Default=false, Callback=function(v) flags.AutoDaily=v end})
QuestBox:AddToggle("qBoard", {Text="Auto Board", Default=false, Callback=function(v) flags.AutoBoard=v end})

task.spawn(function()
    while task.wait(3.5) do
        if flags.AutoDaily then pcall(function() local r=RS.Remotes and RS.Remotes:FindFirstChild("ClaimDaily") if r then r:FireServer() end end) end
        if flags.AutoBoard then pcall(function() local r=RS.Remotes and RS.Remotes:FindFirstChild("AcceptQuest") if r then r:FireServer() end end) end
    end
end)

-- VISUAL
local VisBox = Tabs.Visual:AddLeftGroupbox("Visual")
VisBox:AddToggle("vMusic", {Text="Play Music", Default=true, Callback=function(v) flags.PlayMusic=v end})
VisBox:AddButton("Dreammetric Music", function()
    pcall(function()
        local s = Instance.new("Sound")
        s.SoundId = "rbxassetid://9047050075"
        s.Volume = 1.5
        s.Looped = true
        s.Parent = SoundService
        s:Play()
    end)
end)
VisBox:AddButton("Stop Music", function()
    for _,s in pairs(SoundService:GetChildren()) do
        if s:IsA("Sound") then s:Stop() s:Destroy() end
    end
end)

-- LIMBO
local LimboBox = Tabs.Limbo:AddLeftGroupbox("Limbo")
LimboBox:AddToggle("lAuto", {Text="Auto Limbo", Default=false, Callback=function(v) flags.AutoLimbo=v end})
local limboStatus = LimboBox:AddLabel("Progress: ...")
LimboBox:AddLabel("Stella 2nd: 30 Ink + 20 Ash + 13 LEAK + 1 Undefined")
LimboBox:AddLabel("Craft Glass Candle -> Cave -> Unnamed Entity")
LimboBox:AddLabel("C1: NULL stand 20s | C2: TRUE VISION + symbols")
LimboBox:AddLabel("C3: Torch + Undefined | C4: NULL? Grail")

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
        limboStatus:SetText("Recipe:"..(hasRecipe and "Y" or "N").." Glass:"..(hasGlass and "Y" or "N").." Limbo:"..(inLimbo and "Y" or "N"))
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

-- MISC
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
MiscBox:AddButton("Toggle UI", function() Library:Toggle() end)
MiscBox:AddToggle("ShowCursor", {Text="Custom Cursor", Default=false, Callback=function(v)
    Library.ShowCustomCursor = v
end})

ThemeManager:SetLibrary(Library)
SaveManager:SetLibrary(Library)
SaveManager:IgnoreThemeSettings()
SaveManager:SetFolder("A6HubV1.121")
SaveManager:BuildConfigSection(Tabs.Misc)
ThemeManager:ApplyToTab(Tabs.Misc)

-- force no cursor
Library.ShowCustomCursor = false
pcall(function()
    if Library.Options and Library.Options.ShowCustomCursor then
        Library.Options.ShowCustomCursor:SetValue(false)
    end
end)

Library:Notify("A6HubV1.121 | Cursor OFF", 4)
