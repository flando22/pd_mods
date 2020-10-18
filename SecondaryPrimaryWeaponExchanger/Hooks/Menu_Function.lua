Hooks:Add("LocalizationManagerPostInit", "SecondaryPrimaryWeapon_loc", function(loc)
	LocalizationManager:add_localized_strings({
		["SecondaryPrimaryWeapon_menu_title"] = "Weapon Exchanger",
		["SecondaryPrimaryWeapon_menu_desc"] = "Clone weapon and change it from secondary to primary or primary to secondary",
		["SecondaryPrimaryWeapon_menu_forced_update_officially_title"] = "Update , Only Officially",
		["SecondaryPrimaryWeapon_menu_forced_update_officially_desc"] = " ",
		["SecondaryPrimaryWeapon_menu_forced_update_all_title"] = "Update , All",
		["SecondaryPrimaryWeapon_menu_forced_update_all_desc"] = " ",
	})
end)

Hooks:Add("MenuManagerSetupCustomMenus", "SecondaryPrimaryWeaponOptions", function( menu_manager, nodes )
	MenuHelper:NewMenu( "SecondaryPrimaryWeapon_menu" )
end)

Hooks:Add("MenuManagerPopulateCustomMenus", "SecondaryPrimaryWeaponOptions", function( menu_manager, nodes )
	MenuCallbackHandler.SecondaryPrimaryWeapon_menu_forced_update_all_callback = function(self, item)
		item = item or {}
		item.update_all = true
		MenuCallbackHandler.SecondaryPrimaryWeapon_menu_forced_update_callback(self, item)
	end	
	MenuCallbackHandler.SecondaryPrimaryWeapon_menu_forced_update_callback = function(self, item)
		local _file = io.open('assets/mod_overrides/SecondaryPrimaryWeaponExchanger/main.xml', "w")
		local banned = {saw = true, saw_secondary = true}
		if _file then
			_file:write('<table name=\"SecondaryPrimaryWeaponExchanger\"> \n')
			_file:write('	<AssetUpdates id="15378" name="asset_updates" version="20" folder_name="SecondaryPrimaryWeaponExchanger" provider="modworkshop"/>\n')
			local _, _, _, _weapon_lists, _, _, _, _, _ = tweak_data.statistics:statistics_table()
			local _factory_id = ""
			if item.update_all then
				_weapon_lists = {}
				for _weapon_id, _ in pairs(tweak_data.weapon) do
					_factory_id = managers.weapon_factory:get_factory_id_by_weapon_id(_weapon_id)
					if _factory_id then
						table.insert(_weapon_lists, _weapon_id)
					end
				end
			end
			for _, _weapon_id in pairs(_weapon_lists) do
				if not banned[_weapon_id] and not _weapon_id:find('_besecondary') then
					_factory_id = managers.weapon_factory:get_factory_id_by_weapon_id(_weapon_id)
					if _factory_id then
						local _wd = tweak_data.weapon[_weapon_id] or nil
						local _wfd = tweak_data.weapon.factory[_factory_id] or nil
						if _wd and _wd.use_data and (_wd.use_data.selection_index == 1 or _wd.use_data.selection_index == 2) and ((not _wd.custom and not item.update_all) or item.update_all) and _wfd then
							local _locked = ''
							_base_states = string.format('%s %s %s %s %s', (_wd.DAMAGE and 'DAMAGE="'.. _wd.DAMAGE ..'"' or ''), 
								(_wd.CLIP_AMMO_MAX and 'CLIP_AMMO_MAX="'.. _wd.CLIP_AMMO_MAX ..'"' or ''), 
								(_wd.NR_CLIPS_MAX and 'NR_CLIPS_MAX="'.. _wd.NR_CLIPS_MAX ..'"' or ''), 
								(_wd.AMMO_MAX and 'AMMO_MAX="'.. _wd.AMMO_MAX ..'"' or ''), 
								(_wd.weapon_hold and 'weapon_hold="'.. _wd.weapon_hold ..'"' or ''))
							_locked = string.format('%s %s', (_wd.global_value and 'global_value="'.. _wd.global_value ..'"' or ''), (_wd.texture_bundle_folder and 'texture_bundle_folder="'.. _wd.texture_bundle_folder ..'"' or ''))
							_file:write('	<WeaponNew> \n')
							_file:write('		<weapon id="'.. _weapon_id ..'_besecondary" based_on="'.. _weapon_id ..'" name_id="'.. _wd.name_id ..'" desc_id ="'.. _wd.desc_id ..'" description_id="'.. _wd.description_id ..'" '.. _base_states..' '.. _locked..'> \n')
							--category
							_file:write('			<categories>\n')
							for _, _category in pairs(_wd.categories) do
								_file:write('				<value_node value="'.._category..'"/> \n')
							end
							_file:write('			</categories>\n')
							--selection_index
							if _wd.use_data.selection_index == 1 then
								_file:write('			<use_data selection_index="2"/>\n')
							elseif _wd.use_data.selection_index == 2 then
								_file:write('			<use_data selection_index="1"/>\n')
							end
							--stats
							if _wd.stats and type(_wd.stats) == "table" then
								local stats = ''
								for _stat, _value in pairs(_wd.stats) do
									stats = stats .. ' '.. _stat ..'="'.. _value ..'"'
								end
								_file:write('			<stats'.. stats ..'/>\n')
							end
							--stats_modifiers
							if _wd.stats_modifiers and type(_wd.stats_modifiers) == "table" then
								local stats_modifiers = ''
								for _stat, _value in pairs(_wd.stats_modifiers) do
									stats_modifiers = stats_modifiers .. ' '.. _stat ..'="'.. _value ..'"'
								end
								_file:write('			<stats_modifiers'.. stats_modifiers ..'/>\n')
							end
							--optional_types
							_file:write('			<optional_types>\n')
							_wfd.optional_types = _wfd.optional_types or {}
							for _, _optional_type in pairs(_wfd.optional_types) do
								_file:write('				<value_node value="'.._optional_type..'"/> \n')
							end
							_file:write('			</optional_types>\n')
							--default_blueprint
							_file:write('		</weapon> \n')
							_file:write('		<factory id="'.. _factory_id ..'_besecondary" based_on="'.. _factory_id ..'" unit="'.. _wfd.unit ..'"> \n')
							_file:write('			<default_blueprint> \n')
							for _, _part in pairs(_wfd.default_blueprint) do
								_file:write('				<value_node value="'.. _part ..'"/>\n')
							end
							_file:write('			</default_blueprint> \n')
							--uses_parts
							_file:write('			<uses_parts> \n')
							for _, _part in pairs(_wfd.uses_parts) do
								_file:write('				<value_node value="'.. _part ..'"/>\n')
							end
							_file:write('			</uses_parts> \n')
							--
							_file:write('		</factory> \n')
							_file:write('		<stance/>\n')
							_file:write('	</WeaponNew> \n')
						end
					end
				end
			end
			_file:write('	<Hooks directory="Hooks"> \n')
			_file:write('		<hook file="Menu_Function.lua" source_file="lib/managers/menumanager"/>\n')
			_file:write('		<hook file="blackmarketmanager.lua" source_file="lib/managers/blackmarketmanager"/>\n')
			_file:write('		<hook file="tweakdata.lua" source_file="lib/tweak_data/tweakdata"/>\n')
			_file:write('		<hook file="playerinventory.lua" source_file="lib/units/beings/player/playerinventory"/>\n')
			_file:write('	</Hooks> \n')
			_file:write('</table>')
			_file:close()
			local _dialog_data = {
				title = "[Secondary\\Primary Weapon Exchanger]",
				text = "Please reboot the game.",
				button_list = {{ text = "[OK]", is_cancel_button = true }},
				id = tostring(math.random(0,0xFFFFFFFF))
			}
			managers.system_menu:show(_dialog_data)
		end
	end
	MenuHelper:AddButton({
		id = "SecondaryPrimaryWeapon_menu_forced_update_callback",
		title = "SecondaryPrimaryWeapon_menu_forced_update_officially_title",
		desc = "SecondaryPrimaryWeapon_menu_forced_update_officially_desc",
		callback = "SecondaryPrimaryWeapon_menu_forced_update_callback",
		menu_id = "SecondaryPrimaryWeapon_menu",
	})
	MenuHelper:AddButton({
		id = "SecondaryPrimaryWeapon_menu_forced_update_all_callback",
		title = "SecondaryPrimaryWeapon_menu_forced_update_all_title",
		desc = "SecondaryPrimaryWeapon_menu_forced_update_all_desc",
		callback = "SecondaryPrimaryWeapon_menu_forced_update_all_callback",
		menu_id = "SecondaryPrimaryWeapon_menu",
	})
end)

Hooks:Add("MenuManagerBuildCustomMenus", "SecondaryPrimaryWeaponOptions", function(menu_manager, nodes)
	nodes["SecondaryPrimaryWeapon_menu"] = MenuHelper:BuildMenu( "SecondaryPrimaryWeapon_menu" )
	MenuHelper:AddMenuItem(nodes["blt_options"], "SecondaryPrimaryWeapon_menu", "SecondaryPrimaryWeapon_menu_title", "SecondaryPrimaryWeapon_menu_desc")
end)

if Announcer then
	Announcer:AddHostMod('Weapon Exchanger, (Clone weapon and change it from secondary to primary or primary to secondary)')
	Announcer:AddClientMod('Weapon Exchanger, (Clone weapon and change it from secondary to primary or primary to secondary)')
end