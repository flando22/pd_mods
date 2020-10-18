-- based on YaPh1l's fix
-- https://bitbucket.org/YaPh1l/payday-2-fixes/src/bad7a2cc9e36e53f2c2079f08db9c509cb1da525/ElementAreaTrigger.lua?at=master
local mic_original_elementareatrigger_projectinstigators = ElementAreaTrigger.project_instigators
function ElementAreaTrigger:project_instigators()
	local instigators = mic_original_elementareatrigger_projectinstigators(self)

	if self._values.instigator == "enemies" and type(instigators) == "table" and Network:is_server() then
		if managers.groupai:state():police_hostage_count() > 0 then
			for i = #instigators, 1, -1 do
				if instigators[i]:base().mic_is_being_moved then
					table.remove(instigators, i)
				end
			end
		end

		if managers.groupai:state():get_amount_enemies_converted_to_criminals() > 0 then
			for i = #instigators, 1, -1 do
				if instigators[i]:brain()._logic_data.is_converted then
					table.remove(instigators, i)
				end
			end
		end
	end

	return instigators
end
