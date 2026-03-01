-- FOV Slider for Resident Evil Requiem
-- Adds adjustable Field of View slider to REFramework menu
-- Based on REFramework ImGui API [citation:3]

local fov_value = 90.0
local min_fov = 60.0
local max_fov = 120.0
local camera = nil

-- Find camera singleton on first frame
re.on_frame(function()
    if camera == nil then
        camera = sdk.get_managed_singleton("via.Camera")
    end
end)

-- Draw UI in REFramework menu
imgui.on_menu("FOV Slider", function()
    local changed, new_value = imgui.slider_float("Field of View", fov_value, min_fov, max_fov)
    if changed then
        fov_value = new_value
        if camera then
            -- Call game's setFOV method
            camera:call("setFOV", fov_value)
        end
    end
    
    -- Reset button
    if imgui.button("Reset to Default (90)") then
        fov_value = 90.0
        if camera then
            camera:call("setFOV", fov_value)
        end
    end
    
    -- Info text
    imgui.text("Default RE9 FOV is 80. Higher values recommended for ultrawide.")
end)

-- Apply FOV every frame (in case game resets it)
re.on_frame(function()
    if camera and fov_value ~= 90.0 then
        -- Only apply if not default (optimization)
        local current = camera:call("getFOV")
        if math.abs(current - fov_value) > 0.1 then
            camera:call("setFOV", fov_value)
        end
    end
end)