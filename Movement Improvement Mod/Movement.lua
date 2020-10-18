local init_original = PlayerTweakData.init

local jump_height_multiplicator = 1.1
local jump_speed_multiplicator_run = 2.1
local jump_speed_multiplicator_walk = 1.3

function PlayerTweakData:init()
	init_original(self)
	self.movement_state.standard.movement.jump_velocity.z = 470 * jump_height_multiplicator
	self.movement_state.standard.movement.jump_velocity.xy.run = self.movement_state.standard.movement.jump_velocity.xy.run * jump_speed_multiplicator_run
	self.movement_state.standard.movement.jump_velocity.xy.walk = self.movement_state.standard.movement.jump_velocity.xy.walk * jump_speed_multiplicator_walk
end