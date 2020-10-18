local old_init = WeaponTweakData.init
function WeaponTweakData:init(tweak_data)
	old_init(self, tweak_data)
	self.ray.CLIP_AMMO_MAX = 2
	self.ray.AMMO_MAX = 4
	self.ray.AMMO_PICKUP = {0,0.4}
end
