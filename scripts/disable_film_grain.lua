-- Disable Film Grain for Resident Evil Requiem
-- Removes distracting film grain effect [citation:1]

local film_grain_disabled = true
local render_settings = nil

-- Find render settings singleton
re.on_frame(function()
    if render_settings == nil then
        render_settings = sdk.get_managed_singleton("via.render")
    end
end)

-- Draw UI
imgui.on_menu("Film Grain Control", function()
    local changed, new_value = imgui.checkbox("Disable Film Grain", film_grain_disabled)
    if changed then
        film_grain_disabled = new_value
    end
    
    if imgui.button("Force Apply Now") then
        -- Immediate apply
        if render_settings then
            render_settings:set_field("FilmGrain", not film_grain_disabled)
        end
    end
    
    imgui.text("Film grain causes blurring and visual noise.")
    imgui.text("Disabling improves clarity, especially at lower resolutions.")
end)

-- Apply every frame
re.on_frame(function()
    if render_settings and film_grain_disabled then
        render_settings:set_field("FilmGrain", false)
    end
end)