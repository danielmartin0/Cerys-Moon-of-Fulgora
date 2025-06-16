-- Runtime script.

local Public = {}

function Public.add_picker_dollies_blacklists()
	if remote.interfaces["PickerDollies"] then
		remote.call("PickerDollies", "add_blacklist_name", "cerys-charging-rod", true)

		remote.call("PickerDollies", "add_blacklist_name", "cerys-fulgoran-radiative-tower", true)
		remote.call("PickerDollies", "add_blacklist_name", "cerys-fulgoran-radiative-tower-frozen", true)
		remote.call("PickerDollies", "add_blacklist_name", "cerys-fulgoran-radiative-tower-rising-reactor-base", true)
		remote.call(
			"PickerDollies",
			"add_blacklist_name",
			"cerys-fulgoran-radiative-tower-rising-reactor-tower-1",
			true
		)
		remote.call(
			"PickerDollies",
			"add_blacklist_name",
			"cerys-fulgoran-radiative-tower-rising-reactor-tower-2",
			true
		)
		remote.call(
			"PickerDollies",
			"add_blacklist_name",
			"cerys-fulgoran-radiative-tower-rising-reactor-tower-3",
			true
		)
		remote.call("PickerDollies", "add_blacklist_name", "cerys-fulgoran-radiative-tower-base", true)
		remote.call("PickerDollies", "add_blacklist_name", "cerys-fulgoran-radiative-tower-base-frozen", true)
		remote.call("PickerDollies", "add_blacklist_name", "cerys-fulgoran-radiative-tower-contracted-container", true)

		remote.call("PickerDollies", "add_blacklist_name", "cerys-radiative-tower", true) -- Heating logic is attached to position

		remote.call("PickerDollies", "add_blacklist_name", "cerys-fulgoran-cryogenic-plant", true)
		remote.call("PickerDollies", "add_blacklist_name", "cerys-fulgoran-cryogenic-plant-wreck", true)
		remote.call("PickerDollies", "add_blacklist_name", "cerys-fulgoran-cryogenic-plant-wreck-frozen", true)

		remote.call("PickerDollies", "add_blacklist_name", "cerys-fulgoran-reactor", true)
		remote.call("PickerDollies", "add_blacklist_name", "cerys-fulgoran-reactor-wreck", true)
		remote.call("PickerDollies", "add_blacklist_name", "cerys-fulgoran-reactor-wreck-frozen", true)
		remote.call("PickerDollies", "add_blacklist_name", "cerys-fulgoran-reactor-wreck-cleared", true)
		remote.call("PickerDollies", "add_blacklist_name", "cerys-fulgoran-reactor-scaffold", true)
		remote.call("PickerDollies", "add_blacklist_name", "cerys-fulgoran-reactor-wreck-scaffolded", true)
		remote.call("PickerDollies", "add_blacklist_name", "cerys-fulgoran-reactor-scaffolded", true)

		remote.call("PickerDollies", "add_blacklist_name", "cerys-fulgoran-crusher", true)
		remote.call("PickerDollies", "add_blacklist_name", "cerys-fulgoran-crusher-wreck", true)
		remote.call("PickerDollies", "add_blacklist_name", "cerys-fulgoran-crusher-wreck-frozen", true)

		for _, quality in pairs(prototypes.quality) do
			if quality.level and quality.level > 0 then
				remote.call(
					"PickerDollies",
					"add_blacklist_name",
					"cerys-fulgoran-crusher-quality-" .. quality.level,
					true
				)
			end
		end
	end
end

return Public
