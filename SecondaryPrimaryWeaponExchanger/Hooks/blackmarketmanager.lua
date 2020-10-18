local BeSecondary_BlackMarketManager_get_weapon_icon_path = BlackMarketManager.get_weapon_icon_path

function BlackMarketManager:get_weapon_icon_path(weapon_id, ...)
	if weapon_id and type(weapon_id) == "string" and weapon_id:find("_besecondary") then
		weapon_id = weapon_id:gsub("_besecondary", "")
	end
	return BeSecondary_BlackMarketManager_get_weapon_icon_path(self, weapon_id, ...)
end

Hooks:PostHook(BlackMarketManager, "_load_done", "BeSecondary_BlackMarketManager__load_done", function(bb, ...)
	bb:BeSecondary_CheckUnlock()
end )

local BeSecondary_BlackMarketManager_equipped_item = BlackMarketManager.equipped_item

function BlackMarketManager:equipped_item(...)
	self:BeSecondary_CheckUnlock()
	return BeSecondary_BlackMarketManager_equipped_item(self, ...)
end

function BlackMarketManager:BeSecondary_CheckUnlock()
	local _weapons = Global.blackmarket_manager.weapons or {}
	if _weapons then
		for _weapon_id, v in pairs(_weapons) do
			local _second_weapon_id = _weapon_id .. "_besecondary"
			if _weapon_id and _weapon_id ~= "" and _weapons[_weapon_id] and _weapons[_second_weapon_id] then
				_weapons[_second_weapon_id].unlocked = _weapons[_weapon_id].unlocked
				if not _weapons[_second_weapon_id].unlocked then
					_weapons[_second_weapon_id].equipped = false
					managers.blackmarket:_verfify_equipped_category("primaries")
					managers.blackmarket:_verfify_equipped_category("secondaries")
				end
			end
		end
	end
end