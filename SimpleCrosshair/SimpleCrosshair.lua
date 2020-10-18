if not _G.SimpleCrosshair then
	_G.SimpleCrosshair = {}
	SimpleCrosshair.mod_path = ModPath
end

SimpleCrosshair.hook_files = {
	["lib/managers/hud/hudhitconfirm"] = "HudHitConfirm.lua"
}

if RequiredScript then
	local requiredScript = RequiredScript:lower()
	if SimpleCrosshair.hook_files[requiredScript] then
		dofile( ModPath .. SimpleCrosshair.hook_files[requiredScript] )
	end
end

if Hooks then
	if HUDHitConfirm then
		Hooks:PostHook( HUDHitConfirm, "init", "Crosshair_define", function(self)
			self._main = self._hud_panel:bitmap({
				visible = false,
				name = "_main",
				layer = 0,
				w = 3,
				h = 3,
			})
			self._main:set_center(self._hud_panel:center())
            
            self._offset = self._hud_panel:bitmap({
				visible = false,
				name = "_offset",
				layer = 0,
				w = 1,
				h = 52,
			})
			self._offset:set_center(self._hud_panel:center())
			self._offset:set_bottom(self._main:top())
			
			self._left = self._hud_panel:bitmap({
				visible = true,
				name = "_left",
				layer = 0,
				w = 5,
				h = 1,
			})
			self._left:set_center(self._hud_panel:center())
			self._left:set_right(self._main:left())
			
			self._right = self._hud_panel:bitmap({
				visible = true,
				name = "_right",
				layer = 0,
				w = 5,
				h = 1,
			})
			self._right:set_center(self._hud_panel:center())
			self._right:set_left(self._main:right())
			
			self._above = self._hud_panel:bitmap({
				visible = true,
				name = "_above",
				layer = 0,
				w = 1,
				h = 5,
			})
			self._above:set_center(self._hud_panel:center())
			self._above:set_bottom(self._main:top())
			
			self._below = self._hud_panel:bitmap({
				visible = true,
				name = "_below",
				layer = 0,
				w = 1,
				h = 5,
			})
			self._below:set_center(self._hud_panel:center())
			self._below:set_top(self._main:bottom())
            
            self._above_left = self._hud_panel:bitmap({
				visible = true,
				name = "_above_left",
				color = Color(0,0,0),
				layer = 0,
                rotation = 315,
				w = 0.5,
				h = 5,
			})
			self._above_left:set_center(self._left:center())
			self._above_left:set_bottom(self._main:top())
			
			self._below_left = self._hud_panel:bitmap({
				visible = true,
				name = "_below_left",
				color = Color(0,0,0),
				layer = 0,
                rotation = 45,
				w = 0.5,
				h = 5,
			})
			self._below_left:set_center(self._left:center())
			self._below_left:set_top(self._main:bottom())
            
            self._above_right = self._hud_panel:bitmap({
				visible = true,
				name = "_above_right",
				color = Color(0,0,0),
				layer = 0,
                rotation = 45,
				w = 0.5,
				h = 5,
			})
			self._above_right:set_center(self._right:center())
			self._above_right:set_bottom(self._main:top())
			
			self._below_right = self._hud_panel:bitmap({
				visible = true,
				name = "_below_right",
				color = Color(0,0,0),
				layer = 0,
                rotation = 315,
				w = 0.5,
				h = 5,
			})
			self._below_right:set_center(self._right:center())
			self._below_right:set_top(self._main:bottom())
			managers.hud:add_updator("CrosshairUpdater", callback(self, self, "tick"))
		end)
	end
end