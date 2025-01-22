--== Flare stack ==--

if settings.startup["cerys-disable-flare-stack-item-venting"].value then
	if data.raw.item["electric-incinerator"] then
		data.raw.item["electric-incinerator"].hidden = true
	end
	if data.raw.item["incinerator"] then
		data.raw.item["incinerator"].hidden = true
	end
end
