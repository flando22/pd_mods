local damage_fall_original = PlayerDamage.damage_fall

local stealth_protection_only = false

function PlayerDamage:damage_fall(data)
	if stealth_protection_only and managers.groupai:state():whisper_mode() then
		data.height = data.height - 100 + 100 * managers.player:upgrade_value("player", "fall_health_damage_multiplier", 1)

		damage_fall_original(self, data)

		if die then
			return true
		end
	end

	return false
end