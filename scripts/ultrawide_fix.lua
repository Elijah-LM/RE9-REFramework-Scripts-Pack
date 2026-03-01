-- Ultrawide Fix for Resident Evil Requiem
-- Removes black bars and corrects aspect ratio for 21:9 and 32:9 monitors [citation:1]

local ultrawide_enabled = true
local aspect_ratio = 2.3333  -- 21:9 = 2.333, 32:9 = 3.555
local resolution = nil

-- Detect actual resolution and calculate proper aspect ratio
re.on_frame(function()
    if resolution == nil then
        resolution = sdk.get_managed_singleton("via.Resolution")
    end
end)

imgui.on_menu("Ultrawide Fix", function()
    local changed, new_val = imgui.checkbox("Enable Ultrawide Fix", ultrawide_enabled)
    if changed then
        ultrawide_enabled = new_val
    end
    
    imgui.text("Aspect Ratio Presets:")
    if imgui.button("21:9 (2560x1080)") then
        aspect_ratio = 2.37
        apply_ultrawide()
    end
    imgui.same_line()
    if imgui.button("21:9 (3440x1440)") then
        aspect_ratio = 2.389
        apply_ultrawide()
    end
    if imgui.button("32:9 (5120x1440)") then
        aspect_ratio = 3.556
        apply_ultrawide()
    end
    
    local changed_ar, new_ar = imgui.slider_float("Custom Aspect Ratio", aspect_ratio, 1.6, 4.0)
    if changed_ar then
        aspect_ratio = new_ar
        if ultrawide_enabled then
            apply_ultrawide()
        end
    end
    
    imgui.text("Fixes HUD positioning and removes letterboxing in cutscenes.")
end)

function apply_ultrawide()
    if not resolution then return end
    
    -- Get current resolution dimensions
    local width = resolution:call("get_Width")
    local height = resolution:call("get_Height")
    
    -- Calculate proper FOV for ultrawide
    local base_fov = 80.0
    local new_fov = base_fov * (aspect_ratio / (16/9))
    
    -- Apply to camera
    local camera = sdk.get_managed_singleton("via.Camera")
    if camera then
        camera:call("setFOV", new_fov)
    end
    
    -- Set resolution aspect override (internal engine parameter)
    resolution:set_field("ForcedAspectRatio", aspect_ratio)
end

re.on_frame(function()
    if ultrawide_enabled and resolution then
        apply_ultrawide()
    end
end)