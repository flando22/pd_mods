local mic_original_coplogictravel_enter = CopLogicTravel.enter
function CopLogicTravel.enter(data, new_logic_name, enter_params)
	if not data.unit:base().mic_is_being_moved then
		mic_original_coplogictravel_enter(data, new_logic_name, enter_params)
		return
	end

	local weap_name = data.unit:base():default_weapon_name()
	if weap_name then
		data.unit:inventory():add_unit_by_name(weap_name, true, true)
	end

	mic_original_coplogictravel_enter(data, new_logic_name, enter_params)
	data.unit:brain():set_attention_settings({corpse_sneak = true})

	data.internal_data.weapon_range = nil
	data.unit:inventory():destroy_all_items()

	data.unit:movement():action_request({ type = "act", body_part = 1, variant = "stand" })
end

local mic_original_coplogictravel_updenemydetection = CopLogicTravel._upd_enemy_detection
function CopLogicTravel._upd_enemy_detection(data)
	if data.unit:base().mic_is_being_moved then
		return 1
	else
		return mic_original_coplogictravel_updenemydetection(data)
	end
end

local mic_original_coplogictravel_onalert = CopLogicTravel.on_alert
function CopLogicTravel.on_alert(data, alert_data)
	if data.unit:base().mic_is_being_moved then
		CopLogicIntimidated.on_alert(data, alert_data)
	else
		mic_original_coplogictravel_onalert(data, alert_data)
	end
end

local mic_original_coplogictravel_determinedestinationoccupation = CopLogicTravel._determine_destination_occupation
function CopLogicTravel._determine_destination_occupation(data, objective)
	local occupation

	if (objective.type == "follow" or objective.type == "dont_follow") and data.unit:base().mic_is_being_moved then
		occupation = {type = "defend", cover = false, pos = data.unit:base().mic_destination or objective.follow_unit:movement():nav_tracker():field_position()}
	else
		occupation = mic_original_coplogictravel_determinedestinationoccupation(data, objective)
	end

	return occupation
end

local mic_original_coplogictravel_getexactmovepos = CopLogicTravel._get_exact_move_pos
function CopLogicTravel._get_exact_move_pos(data, nav_index)
	local coarse_path = data.internal_data.coarse_path
	if nav_index < #coarse_path and data.unit:base().mic_is_being_moved then
		return coarse_path[nav_index][2]
	end
	
	return mic_original_coplogictravel_getexactmovepos(data, nav_index)
end

local mic_original_coplogictravel_ondestinationreached = CopLogicTravel._on_destination_reached
function CopLogicTravel._on_destination_reached(data)
	if data.unit:base().mic_destination then
		data.unit:base().mic_destination = nil
		data.unit:brain():on_hostage_move_interaction(data.unit:base().mic_is_being_moved, "fail")
		return
	end

	mic_original_coplogictravel_ondestinationreached(data)
end

local mic_original_coplogictravel_begincoarsepathing = CopLogicTravel._begin_coarse_pathing
function CopLogicTravel._begin_coarse_pathing(data, my_data)
	if data.unit:base().mic_is_being_moved then
		my_data.path_safely = nil
	end

	mic_original_coplogictravel_begincoarsepathing(data, my_data)
end
