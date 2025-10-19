if not storage.cerys then
	return
end

if not storage.cerys.charging_rod_is_negative then
	return
end

storage.cerys.charging_rod_is_positive = {}

for unit_number, is_positive in pairs(storage.cerys.charging_rod_is_negative) do
	storage.cerys.charging_rod_is_positive[unit_number] = is_positive
end
