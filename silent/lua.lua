-- Increased / Slower detection time
-- Author: DvD
 
local detection_multiplier = 5 -- How many times slower the detection time is
 
---------------------------------------------------------------------------
 
old_init = old_init or CharacterTweakData.init
function CharacterTweakData:init(tweak_data)
	old_init(self, tweak_data)
	
	for _,preset in pairs(self.presets.detection) do
		for _,v in pairs(preset) do
			v.delay[1] = v.delay[1] * detection_multiplier
			v.delay[2] = v.delay[2] * detection_multiplier
		end
	end
end-- Lasers do not activate alarm
-- Author: DvD
function ElementLaserTrigger:on_executed(instigator, alternative) end