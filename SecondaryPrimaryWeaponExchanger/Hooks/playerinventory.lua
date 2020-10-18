Hooks:PreHook(PlayerInventory, "add_unit", "BeSecondary_PlayerInventory_add_unit", function(pinv, new_unit, ...)
	local new_selection = {}
	local use_data = new_unit:base():get_use_data(pinv._use_data_alias)
	new_selection.use_data = use_data
	new_selection.unit = new_unit
	new_unit:base():add_destroy_listener(pinv._listener_id, callback(pinv, pinv, "clbk_weapon_unit_destroyed"))
	local selection_index = use_data.selection_index
	local _factory_id = new_unit:base()._factory_id or ""
	if _factory_id:find("_besecondary") then
		use_data.selection_index = use_data.selection_index == 1 and 2 or 1
	end
end )