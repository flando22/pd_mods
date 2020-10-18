CloneClass(HUDHitConfirm)

function HUDHitConfirm:update()
	self._left:set_center(self._main:center())
	self._left:set_right(self._main:left())
	
	self._right:set_center(self._main:center())
	self._right:set_left(self._main:right())
	
	self._above:set_center(self._main:center())
	self._above:set_bottom(self._main:top())
	
	self._below:set_center(self._main:center())
	self._below:set_top(self._main:bottom())
    
    
	self._above_left:set_center(self._left:center())
	self._above_left:set_bottom(self._main:top())
	
    self._below_left:set_center(self._left:center())
	self._below_left:set_top(self._main:bottom())
    
	self._above_right:set_center(self._right:center())
	self._above_right:set_bottom(self._main:top())
    
	self._below_right:set_center(self._right:center())
	self._below_right:set_top(self._main:bottom())
end

function HUDHitConfirm:tick(t, dt)
	if managers.player:is_current_weapon_of_category("bow") then
        self._main:set_center(self._offset:center())
        managers.hud._hud_hit_confirm:update()
	else
        self._main:set_center(self._hud_panel:center())
        managers.hud._hud_hit_confirm:update()
	end
end