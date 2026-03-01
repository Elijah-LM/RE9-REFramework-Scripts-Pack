-- Timescale Control
-- Slow down or speed up game time [citation:1]

local timescale = 1.0
local timescale_enabled = false
local time_manager = nil

re.on_frame(function()
    if time_manager == nil then
        time_manager = sdk.get_managed_singleton("via.Time")
    end
end)

imgui.on_menu("Timescale Control", function()
    local enabled_changed, new_enabled = imgui.checkbox("Enable Timescale Control", timescale_enabled)
    if enabled_changed then
        timescale_enabled = new_enabled
        if not timescale_enabled then
            -- Reset to normal speed when disabled
            if time_manager then
                time_manager:set_field("TimeScale", 1.0)
            end
        end
    end
    
    if timescale_enabled then
        local changed, new_scale = imgui.slider_float("Timescale", timescale, 0.1, 5.0)
        if changed then
            timescale = new_scale
        end
        
        imgui.text("Presets:")
        if imgui.button("Slow Motion (0.5x)") then timescale = 0.5 end
        imgui.same_line()
        if imgui.button("Normal (1.0x)") then timescale = 1.0 end
        imgui.same_line()
        if imgui.button("Fast (2.0x)") then timescale = 2.0 end
        
        imgui.text("Note: Timescale affects game speed, animations,")
        imgui.text("and physics. Useful for slow-mo combat or fast travel.")
    end
end)

re.on_frame(function()
    if timescale_enabled and time_manager then
        time_manager:set_field("TimeScale", timescale)
    end
end)