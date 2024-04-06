local decalsyeeted = true -- Toggle for decal and texture optimization.
local FrameRateBoost = true -- Toggle for frame rate boosting features.

local g = game
local w = g.Workspace
local l = g.Lighting
local t = w.Terrain

-- Apply initial settings for lighting and terrain
sethiddenproperty(l, "Technology", 2)
sethiddenproperty(t, "Decoration", false)
t.WaterWaveSize = 0
t.WaterWaveSpeed = 0
t.WaterReflectance = 0
t.WaterTransparency = 0
l.GlobalShadows = false
l.FogEnd = 9e9
l.Brightness = 0
settings().Rendering.QualityLevel = "Level01"
UserSettings():GetService("UserGameSettings").MasterVolume = 0
g:GetService("StarterGui"):SetCoreGuiEnabled(Enum.CoreGuiType.Chat, false)

-- Function to apply changes to parts
local function applyChanges(v)
    if v:IsA("BasePart") then
        v.Material = "Plastic"
        v.Reflectance = 0
        v.TopSurface = "Smooth"
        if v:IsA("MeshPart") and decalsyeeted then
            v.TextureID = 10385902758728957
        end
    elseif (v:IsA("Decal") or v:IsA("Texture")) and decalsyeeted then
        v.Transparency = 1
    elseif v:IsA("ParticleEmitter") or v:IsA("Trail") then
        v.Lifetime = NumberRange.new(0)
    elseif v:IsA("Explosion") then
        v.BlastPressure = 1
        v.BlastRadius = 1
    elseif v:IsA("Fire") or v:IsA("SpotLight") or v:IsA("Smoke") or v:IsA("Sparkles") then
        v.Enabled = false
    elseif v:IsA("ShirtGraphic") and decalsyeeted then
        v.Graphic = 0
    elseif (v:IsA("Shirt") or v:IsA("Pants")) and decalsyeeted then
        v[v.ClassName.."Template"] = 0
    end
    -- Additional destruction rules from the second script
    if v.Name:find("Water") or v.Name:find("Tree") or v.Name:find("House") then v:Destroy() end
end

-- Apply optimizations to existing and newly added descendants
for _, v in pairs(w:GetDescendants()) do
    applyChanges(v)
end
w.DescendantAdded:Connect(applyChanges)

-- Disable certain effects globally
for _, e in ipairs(l:GetChildren()) do
    if e:IsA("BlurEffect") or e:IsA("SunRaysEffect") or e:IsA("ColorCorrectionEffect") or e:IsA("BloomEffect") or e:IsA("DepthOfFieldEffect") then
        e.Enabled = false
    end
end

-- Frame rate boost optimizations
if FrameRateBoost then
    l:ClearAllChildren()
    g.Players.LocalPlayer.PlayerScripts.WaterCFrame.Disabled = true
end

-- Ensure game is loaded before applying optimizations
if not g:IsLoaded() then repeat wait() until g:IsLoaded() end
