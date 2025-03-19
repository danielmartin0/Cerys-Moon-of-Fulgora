if not storage.cerys then
	return
end

for _, rod in pairs(storage.cerys.charging_rods) do
	if rod.red_light_rendering and rod.red_light_rendering.valid then
		rod.red_light_rendering.destroy()
	end
end
