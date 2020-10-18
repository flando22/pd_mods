local mic_original_coplogicidle_enter = CopLogicIdle.enter
function CopLogicIdle.enter(data, new_logic_name, enter_params)
	if not data.unit:base().mic_is_being_moved then
		mic_original_coplogicidle_enter(data, new_logic_name, enter_params)
		return
	end

	local weap_name = data.unit:base():default_weapon_name()
	if weap_name then
		data.unit:inventory():add_unit_by_name(weap_name, true, true)
	end

	mic_original_coplogicidle_enter(data, new_logic_name, enter_params)
	data.unit:brain():set_attention_settings({corpse_sneak = true})

	data.internal_data.weapon_range = nil
	data.unit:inventory():destroy_all_items()

	data.unit:movement():action_request({ type = "act", body_part = 1, variant = "hands_up" })
end

local mic_original_coplogicidle_getpriorityattention = CopLogicIdle._get_priority_attention
function CopLogicIdle._get_priority_attention(data, attention_objects, reaction_func)
	if data.internal_data and data.internal_data.weapon_range then
		return mic_original_coplogicidle_getpriorityattention(data, attention_objects, reaction_func)
	end
end

local mic_original_coplogicidle_onalert = CopLogicIdle.on_alert
function CopLogicIdle.on_alert(data, alert_data)
	if data.unit:base().mic_is_being_moved then
		CopLogicIntimidated.on_alert(data, alert_data)
	else
		mic_original_coplogicidle_onalert(data, alert_data)
	end
end

local mic_original_coplogicidle_updenemydetection = CopLogicIdle._upd_enemy_detection
function CopLogicIdle._upd_enemy_detection(data)
	if data.unit:base().mic_is_being_moved then
		return 1
	else
		return mic_original_coplogicidle_updenemydetection(data)
	end
end
