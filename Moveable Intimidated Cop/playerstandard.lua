local mic_original_playerstandard_getintimidationaction = PlayerStandard._get_intimidation_action
function PlayerStandard:_get_intimidation_action(prime_target, char_table, amount, primary_only, detect_only)
	if prime_target and prime_target.unit and prime_target.unit:base() and prime_target.unit:base().mic_is_being_moved then
		if self._unit == prime_target.unit:base().mic_is_being_moved then
			prime_target.unit:brain():on_intimidated(0, self._unit)
			
			local wp = managers.hud and managers.hud._hud and managers.hud._hud.waypoints["CustomWaypoint_localplayer"]
			local wp_position = wp and wp.position or nil
			if wp_position then
				prime_target.unit:base().mic_destination = wp_position
				return "stop", false, prime_target
			end
		end
		return "come", false, prime_target
	end

	return mic_original_playerstandard_getintimidationaction(self, prime_target, char_table, amount, primary_only, detect_only)
end
