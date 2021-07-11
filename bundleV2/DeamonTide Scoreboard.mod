return {
	run = function()
		fassert(rawget(_G, "new_mod"), "`DeamonTide Scoreboard` mod must be lower than Vermintide Mod Framework in your launcher's load order.")

		new_mod("DeamonTide Scoreboard", {
			mod_script       = "scripts/mods/DeamonTide Scoreboard/DeamonTide Scoreboard",
			mod_data         = "scripts/mods/DeamonTide Scoreboard/DeamonTide Scoreboard_data",
			mod_localization = "scripts/mods/DeamonTide Scoreboard/DeamonTide Scoreboard_localization",
		})
	end,
	packages = {
		"resource_packages/DeamonTide Scoreboard/DeamonTide Scoreboard",
	},
}
