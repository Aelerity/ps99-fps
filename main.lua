-- Enhanced FPS optimization script for Roblox with additional improvements

local decalsyeeted = true -- Toggle for decal and texture optimization.
local FrameRateBoost = true -- Toggle for frame rate boosting features.

local g = game
local w = g.Workspace
local l = g.Lighting
local t = w.Terrain

-- Apply initial settings for lighting and terrain
-- Reducing terrain detail and disabling unnecessary lighting properties to save CPU/GPU resources.
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

-- Enhanced function to apply changes to parts
-- This function now includes additional checks and optimizations for various object properties.
local function applyChanges(v)
    if v:IsA("BasePart") then
        -- Reduce rendering load by simplifying part materials and surfaces.
        v.Material = "Plastic"
        v.Reflectance = 0
        v.TopSurface = "Smooth"
        -- Disable physics influence for static parts to save processing power.
        if not v.Anchored then
            v.Anchored = true
        end
        -- MeshParts get additional texture optimizations.
        if v:IsA("MeshPart") and decalsyeeted then
            v.TextureID = 10385902758728957
        end
    end
    -- Optimize or disable visual elements like decals, textures, and effects.
    if (v:IsA("Decal") or v:IsA("Texture")) and decalsyeeted then
        v.Transparency = 1
    elseif v:IsA("ParticleEmitter") or v:IsA("Trail") then
        v.Lifetime = NumberRange.new(0)
    elseif v:IsA("Explosion") then
        v.BlastPressure = 0  -- Reduced from 1 to 0 for further optimization.
        v.BlastRadius = 0  -- Reduced from 1 to 0 for further optimization.
    elseif v:IsA("Fire") or v:IsA("SpotLight") or v:IsA("Smoke") or v:IsA("Sparkles") then
        v.Enabled = false
    end

    -- Additional destruction rules from the second script, with a check to avoid destroying essential objects.
    if (v.Name:find("Water") or v.Name:find("Tree") or v.Name:find("House")) and not v:IsA("Model") then 
        v:Destroy() 
    end
end

-- Apply optimizations to existing and newly added descendants
for _, v in pairs(w:GetDescendants()) do
    applyChanges(v)
end
w.DescendantAdded:Connect(applyChanges)

-- Disable unnecessary effects globally to reduce GPU load.
for _, e in ipairs(l:GetChildren()) do
    if e:IsA("BlurEffect") or e:IsA("SunRaysEffect") or e:IsA("ColorCorrectionEffect") or e:IsA("BloomEffect") or e:IsA("DepthOfFieldEffect") then
        e.Enabled = false
    end
end

-- Additional optimizations for frame rate boost
if FrameRateBoost then
    -- Clearing all children of lighting to remove any potential performance-draining effects.
    l:ClearAllChildren()
    -- Disabling player script that might interfere with water rendering optimizations.
    g.Players.LocalPlayer.PlayerScripts.WaterCFrame.Disabled = true
end

-- Ensure game is loaded before applying optimizations
if not g:IsLoaded() then repeat wait() until g:IsLoaded() end
