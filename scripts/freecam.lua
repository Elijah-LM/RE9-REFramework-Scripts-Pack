-- Freecam for Resident Evil Requiem
-- Detach camera from player for screenshots and exploration [citation:1]

local freecam_active = false
local camera = nil
local player = nil
local cam_pos = { x = 0, y = 0, z = 0 }
local cam_rot = { pitch = 0, yaw = 0, roll = 0 }
local move_speed = 0.1
local original_camera_pos = nil
local original_camera_target = nil

-- Save original camera state
function save_original_camera()
    if not camera then return end
    original_camera_pos = {
        x = camera:get_field("Position").x,
        y = camera:get_field("Position").y,
        z = camera:get_field("Position").z
    }
    original_camera_target = {
        x = camera:get_field("Target").x,
        y = camera:get_field("Target").y,
        z = camera:get_field("Target").z
    }
end

-- Restore original camera
function restore_original_camera()
    if not camera or not original_camera_pos then return end
    camera:set_field("Position", original_camera_pos)
    camera:set_field("Target", original_camera_target)
end

re.on_frame(function()
    if camera == nil then
        camera = sdk.get_managed_singleton("via.Camera")
    end
    if player == nil then
        player = sdk.get_managed_singleton("via.Player")
    end
    
    -- Freecam movement
    if freecam_active and camera then
        -- Save original position when first activating
        if not original_camera_pos then
            save_original_camera()
            -- Initialize freecam position at current camera
            local pos = camera:get_field("Position")
            cam_pos = { x = pos.x, y = pos.y, z = pos.z }
        end
        
        -- WASD movement
        local move = { x = 0, y = 0, z = 0 }
        if imgui.is_key_down(imgui.key.W) then move.z = move.z - move_speed end
        if imgui.is_key_down(imgui.key.S) then move.z = move.z + move_speed end
        if imgui.is_key_down(imgui.key.A) then move.x = move.x - move_speed end
        if imgui.is_key_down(imgui.key.D) then move.x = move.x + move_speed end
        if imgui.is_key_down(imgui.key.Q) then move.y = move.y - move_speed end
        if imgui.is_key_down(imgui.key.E) then move.y = move.y + move_speed end
        
        cam_pos.x = cam_pos.x + move.x
        cam_pos.y = cam_pos.y + move.y
        cam_pos.z = cam_pos.z + move.z
        
        -- Apply position
        camera:set_field("Position", cam_pos)
        
        -- Mouse look (simplified)
        if imgui.is_mouse_down(1) then -- Right mouse button
            local mouse_delta = imgui.get_mouse_delta()
            cam_rot.yaw = cam_rot.yaw + mouse_delta.x * 0.01
            cam_rot.pitch = cam_rot.pitch - mouse_delta.y * 0.01
            
            -- Calculate target based on rotation
            local target = {
                x = cam_pos.x + math.sin(cam_rot.yaw) * math.cos(cam_rot.pitch) * 10,
                y = cam_pos.y + math.sin(cam_rot.pitch) * 10,
                z = cam_pos.z + math.cos(cam_rot.yaw) * math.cos(cam_rot.pitch) * 10
            }
            camera:set_field("Target", target)
        end
    elseif not freecam_active and original_camera_pos then
        restore_original_camera()
        original_camera_pos = nil
        original_camera_target = nil
    end
end)

imgui.on_menu("Freecam", function()
    local changed, new_val = imgui.checkbox("Enable Freecam", freecam_active)
    if changed then
        freecam_active = new_val
        if not freecam_active then
            original_camera_pos = nil -- Force restore next frame
        end
    end
    
    if freecam_active then
        imgui.text("Controls:")
        imgui.text("WASD: Move forward/left/back/right")
        imgui.text("Q/E: Move down/up")
        imgui.text("Hold RMB + mouse: Look around")
        
        local speed_changed, new_speed = imgui.slider_float("Move Speed", move_speed, 0.01, 1.0)
        if speed_changed then move_speed = new_speed end
        
        if imgui.button("Reset Position") then
            if original_camera_pos then
                cam_pos = { x = original_camera_pos.x, y = original_camera_pos.y, z = original_camera_pos.z }
                cam_rot = { pitch = 0, yaw = 0, roll = 0 }
            end
        end
    end
end)