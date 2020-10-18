local tweaker = UpgradesTweakData.init
function UpgradesTweakData:init(tweak_data)
	tweaker(self, tweak_data)
	self.values.cable_tie.quantity_1 = {62}
end