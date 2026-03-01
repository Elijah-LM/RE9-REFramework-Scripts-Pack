-- Disable Vignette Effect
-- Removes dark edges around screen that reduce visibility

local vignette_disabled = true
local post_process = nil

re.on_frame(function()
    if post_process == nil then
        post_process = sdk.get_managed_singleton("via.PostProcess")
    end
end)

imgui.on_menu("Vignette Control", function()
    local changed, new_value = imgui.checkbox("Disable Vignette", vignette_disabled)
    if changed then
        vignette_disabled = new_value
    end
    
    if imgui.button("Apply Now") and post_process then
        post_process:set_field("VignetteIntensity", vignette_disabled and 0.0 or 0.5)
    end
    
    imgui.text("Vignette darkens screen edges. Disabling gives cleaner image.")
end)

re.on_frame(function()
    if post_process and vignette_disabled then
        post_process:set_field("VignetteIntensity", 0.0)
    end
end)