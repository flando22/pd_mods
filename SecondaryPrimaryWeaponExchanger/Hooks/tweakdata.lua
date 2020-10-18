local new_buy_weapon_categories = {primaries = {}, secondaries = {}}
	
for name, data in pairs(tweak_data.weapon) do
	if data.categories and data.use_data and data.use_data.selection_index then
		local idx = data.use_data.selection_index == 1 and "secondaries" or "primaries"
		local cat_ids = Idstring(table.concat(data.categories, ",")):key()
		local is_sp_cat = false
		for _, d in pairs(data.categories) do
			if d == "revolver" or tweak_data.gui.buy_weapon_category_aliases[d] then
				is_sp_cat = true
				break
			end
		end
		if not is_sp_cat and not new_buy_weapon_categories[idx][cat_ids] then
			new_buy_weapon_categories[idx][cat_ids] = data.categories
		end
	end
end
	
tweak_data.gui.buy_weapon_categories = {primaries = {{"wpn_special"}}, secondaries = {{"wpn_special"}}}
	
for _, cat in pairs(new_buy_weapon_categories.primaries) do
	table.insert(tweak_data.gui.buy_weapon_categories.primaries, cat)
end
	
for _, cat in pairs(new_buy_weapon_categories.secondaries) do
	table.insert(tweak_data.gui.buy_weapon_categories.secondaries, cat)
end