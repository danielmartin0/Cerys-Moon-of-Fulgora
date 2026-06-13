local Public = {}

function Public.current_lab_inputs()
	local names = {}
	for _, lab in pairs(data.raw.lab or {}) do
		for _, input in pairs(lab.inputs or {}) do
			names[input] = true
		end
	end
	return names
end

return Public
