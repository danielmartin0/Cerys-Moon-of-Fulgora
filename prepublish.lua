local function ensure_debug_flags_disabled()
	local common_path = "Cerys-Moon-of-Fulgora/common.lua"
	local file = io.open(common_path, "r")
	if not file then
		error("Could not open common.lua")
	end

	local content = file:read("*all")
	file:close()

	-- Check if any debug flags are true
	local debug_enabled = content:match("DEBUG_%w+ = true")
	-- if not debug_enabled then
	if debug_enabled then
		error("Debug flags must be disabled before publishing.")
	end
end

ensure_debug_flags_disabled()
