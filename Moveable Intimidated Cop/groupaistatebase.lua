local mic_original_groupaistatebase_onenemyunregistered = GroupAIStateBase.on_enemy_unregistered
function GroupAIStateBase:on_enemy_unregistered(unit)
	local interacting_unit = unit:base().mic_is_being_moved
	if interacting_unit and alive(interacting_unit) then
		self:on_hostage_follow(interacting_unit, unit, false)
	end

	mic_original_groupaistatebase_onenemyunregistered(self, unit)
end

local mic_original_groupaistatebase_onobjectivefailed = GroupAIStateBase.on_objective_failed
function GroupAIStateBase:on_objective_failed(unit, objective, no_new_objective)
	local owner = unit:base().mic_is_being_moved
	if owner and alive(owner) then
		unit:brain():on_hostage_move_interaction(owner, "fail")
		return
	end

	mic_original_groupaistatebase_onobjectivefailed(self, unit, objective, no_new_objective)
end
