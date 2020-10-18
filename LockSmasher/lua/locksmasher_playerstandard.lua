_G.LockSmasher = _G.LockSmasher or {}

if not PlayerStandard._stock_do_action_melee then
	PlayerStandard._stock_do_action_melee = PlayerStandard._do_action_melee
end

function PlayerStandard:_calc_melee_locksmasher_ray(t)
	local melee_entry = managers.blackmarket:equipped_melee_weapon()
	local range = tweak_data.blackmarket.melee_weapons[melee_entry].stats.range or 175
	local from = self._unit:movement():m_head_pos()
	local to = from + self._unit:movement():m_head_rot():y() * range
	if not LockSmasher.Settings.Enabled then return end
	if LockSmasher.Settings.Mode == 1 and not LockSmasher.Settings.PowerToolsEntries[melee_entry] then return end
	if LockSmasher.Settings.Mode == 2 and not melee_entry == "cs" then return end
	
	return self._unit:raycast("ray", from, to, "slot_mask", InstantBulletBase:bullet_slotmask(), "ignore_unit", {}, "ray_type", "body bullet lock")
end

function PlayerStandard:_do_action_melee(t, ...)
	local raytrace = self:_calc_melee_locksmasher_ray(t)
	if raytrace then
		local damage = 200
		local hit_unit = raytrace.unit
		if hit_unit:damage() and raytrace.body:extension() and raytrace.body:extension().damage then
			--do the thing
			raytrace.body:extension().damage:damage_lock(user_unit, raytrace.normal, raytrace.position, raytrace.direction, damage)
			--sync to peers
			if hit_unit:id() ~= -1 then
				managers.network:session():send_to_peers_synched("sync_body_damage_lock", raytrace.body, damage)
			end
			if LockSmasher.Settings.Sparks then
				--spawn the fancy sawing particles
				local effect = World:effect_manager():spawn({
				effect = Idstring("effects/payday2/particles/weapons/saw/sawing"),
				position = raytrace.hit_position,
				normal = math.UP})
				--make the fancy sawing particles sod off
				DelayedCalls:Add("LockSmasher.ParticleKill", 0.1, function() World:effect_manager():fade_kill(effect) end)
			end
		end
	end
	PlayerStandard._stock_do_action_melee(self, t, ...)
end