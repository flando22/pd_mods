local _init_melee_weapons_actual = BlackMarketTweakData._init_melee_weapons

function BlackMarketTweakData:_init_melee_weapons(...)
    _init_melee_weapons_actual(self, ...)
	
	self.melee_weapons.taser.stats.range = 10000
end	