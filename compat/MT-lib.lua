if mods["MT-lib"] then
local tau = 2*math.pi
data.raw["planet"]["cerys"].orbit = {
	polar = {1.3345,0.51779695*tau},
	parent={
		type="planet",
		name="fulgora"
	},
	sprite={
		type="sprite",
		filename="__Cerys-Moon-of-Fulgora__/graphics/orbits/orbit_cerys.png",
		size=86
	}
}
end