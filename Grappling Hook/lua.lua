local zipline_motor_alt_ids = Idstring("units/payday2/equipment/gen_equipment_zipline_motor_alt/gen_equipment_zipline_motor_alt")

Zipline_Units = Zipline_Units or {}

if DB:has(Idstring("unit"), zipline_motor_alt_ids) then
	function spawn_zipline_motor_alt(pos)
		return safe_spawn_unit(zipline_motor_alt_ids, 
			pos, 
			managers.player:player_unit():rotation()
		)
	end
	if managers.player and managers.player:player_unit() and managers.player:player_unit():movement() then
		local camera = managers.player:player_unit():movement()._current_state._ext_camera
		local mvec_to = Vector3()
		local from_pos = camera:position()
		mvector3.set(mvec_to, camera:forward())
		mvector3.multiply(mvec_to, 20000)
		mvector3.add(mvec_to, from_pos)
		local col_ray = World:raycast("ray", from_pos, mvec_to, "slot_mask", managers.slot:get_mask( "all" ))
		if col_ray and col_ray.unit and col_ray.hit_position then
			if Zipline_Units[1] then
				Zipline_Units[1]:destroy()
				Zipline_Units[1]:set_slot(0)
				Zipline_Units[1] = nil
			end
			if Zipline_Units[2] then
				Zipline_Units[2]:destroy()
				Zipline_Units[2]:set_slot(0)
				Zipline_Units[2] = nil
			end
			local pos1 = managers.player:player_unit():position() + Vector3(0, 0, 50)
			local pos2 = col_ray.hit_position + Vector3(0, 0, 50)
			local distance = mvector3.distance(pos1, pos2)
			Zipline_Units[1] = spawn_zipline_motor_alt(pos1)
			Zipline_Units[2] = spawn_zipline_motor_alt(pos2)
			Zipline_Units[1]:zipline():set_end_pos(pos2)
			Zipline_Units[2]:zipline():set_end_pos(pos1)
			DelayedCalls:Add('Zipline_Units_Delay_Interaction', 0.1, function()
				if Zipline_Units[1]:interaction() then
					Zipline_Units[1]:interaction():interact(managers.player:player_unit())
				end
			end)
		end
	end
end