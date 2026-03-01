-- Performance Boost Script
-- Adjusts various settings for higher FPS on lower-end PCs

local settings = {
    shadow_quality = 1,        -- 0=Low, 1=Medium, 2=High, 3=Max
    texture_quality = 1,       -- 0=Low, 1=Medium, 2=High
    volumetric_fog = false,
    motion_blur = false,
    depth_of_field = false,
    screen_percentage = 90,    -- Resolution scale
    auto_optimize = true
}

local renderer = nil
local graphics_config = nil

re.on_frame(function()
    if renderer == nil then
        renderer = sdk.get_managed_singleton("via.Renderer")
    end
    if graphics_config == nil then
        graphics_config = sdk.get_managed_singleton("via.GraphicsConfig")
    end
end)

imgui.on_menu("Performance Boost", function()
    imgui.text("Performance Settings (apply immediately)")
    imgui.separator()
    
    local changed_shadow, new_shadow = imgui.slider_int("Shadow Quality", settings.shadow_quality, 0, 3)
    if changed_shadow then settings.shadow_quality = new_shadow end
    
    local changed_tex, new_tex = imgui.slider_int("Texture Quality", settings.texture_quality, 0, 2)
    if changed_tex then settings.texture_quality = new_tex end
    
    local changed_fog, new_fog = imgui.checkbox("Disable Volumetric Fog", settings.volumetric_fog)
    if changed_fog then settings.volumetric_fog = new_fog end
    
    local changed_mb, new_mb = imgui.checkbox("Disable Motion Blur", settings.motion_blur)
    if changed_mb then settings.motion_blur = new_mb end
    
    local changed_dof, new_dof = imgui.checkbox("Disable Depth of Field", settings.depth_of_field)
    if changed_dof then settings.depth_of_field = new_dof end
    
    local changed_perc, new_perc = imgui.slider_int("Resolution Scale %", settings.screen_percentage, 50, 100)
    if changed_perc then settings.screen_percentage = new_perc end
    
    imgui.separator()
    local changed_auto, new_auto = imgui.checkbox("Auto-apply every frame", settings.auto_optimize)
    if changed_auto then settings.auto_optimize = new_auto end
    
    if imgui.button("Apply Settings Now") then
        apply_settings()
    end
    
    imgui.text("Lower settings improve FPS. Resolution scale <100% helps most.")
end)

function apply_settings()
    if not renderer then return end
    
    -- Apply shadow quality
    renderer:set_field("ShadowQuality", settings.shadow_quality)
    
    -- Apply texture quality
    renderer:set_field("TextureQuality", settings.texture_quality)
    
    -- Toggle volumetric fog
    if settings.volumetric_fog then
        renderer:set_field("VolumetricFog", false)
    end
    
    -- Toggle motion blur
    if settings.motion_blur then
        renderer:set_field("MotionBlur", false)
    end
    
    -- Toggle depth of field
    if settings.depth_of_field then
        renderer:set_field("DepthOfField", false)
    end
    
    -- Set resolution scale
    renderer:set_field("ScreenPercentage", settings.screen_percentage / 100.0)
end

re.on_frame(function()
    if settings.auto_optimize and renderer then
        apply_settings()
    end
end)