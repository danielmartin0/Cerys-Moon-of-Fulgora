if not storage.cerys then
	return
end

for _, rod in pairs(storage.cerys.charging_rods) do
	if rod.circuit_controlled == nil then
		rod.circuit_controlled = false
	end
	if not rod.control_signal then
		rod.control_signal = { type = "virtual", name = "signal-P" }
	end
end
