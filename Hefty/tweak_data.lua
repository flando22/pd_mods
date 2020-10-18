local _hefty={
	bank_manager_key=999,
	lance_part=999,
	boards=999,
	planks=999,
	thermite_paste=999,
	gas=999,
	acid=999,
	caustic_soda=999,
	hydrogen_chloride=999,
	evidence=999
	}

for name, quantity in pairs(_hefty) do
	tweak_data.equipments.specials[name].quantity=1
	tweak_data.equipments.specials[name].max_quantity=quantity
	end