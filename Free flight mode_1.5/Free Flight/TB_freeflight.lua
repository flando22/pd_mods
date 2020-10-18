if RequiredScript == "lib/entry" then
	core:import("CoreFreeFlight")
	Global.DEBUG_MENU_ON = true
	local FF_ON, FF_OFF, FF_ON_NOCON = 0, 1, 2
	

	function isSinglePlayer()
		return Global.game_settings.single_player or false
	end

	
	function CoreFreeFlight.FreeFlight:_setup_actions()
		local FFA = CoreFreeFlight.CoreFreeFlightAction.FreeFlightAction
		local FFAT = CoreFreeFlight.CoreFreeFlightAction.FreeFlightActionToggle
		
		local ef = FFA:new( "EXIT FREEFLIGHT",
						callback( self, self, "_exit_freeflight" ) )
						
		self._actions = {ef}
		self._action_index = 1
	end
	
	function CoreFreeFlight.FreeFlight:_on_F9()		
	    if isSinglePlayer() then
			if self._state == FF_ON then
				self:disable()
			elseif self._state == FF_OFF then
				self:enable()
			elseif self._state == FF_ON_NOCON then
				self._state = FF_ON
				self._con:enable()
			end
		else
			if managers.hud then
				managers.hud:show_hint( { text = "Free Flight doesn't work in multiplayer mode" } )
			else
				if self._state == FF_ON then
					self:disable()
				elseif self._state == FF_OFF then
					self:enable()
				elseif self._state == FF_ON_NOCON then
					self._state = FF_ON
					self._con:enable()
				end
			end
		end
	end
end