--== Flare stack ==--

if settings.startup["cerys-disable-flare-stack-item-venting"].value then
	data.raw.item["electric-incinerator"].hidden = true
	data.raw.item["incinerator"].hidden = true
end
