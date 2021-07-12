local mod = get_mod("DeamonTide Scoreboard")

return {
	name = "DeamonTide Scoreboard",
	description = mod:localize("mod_description"),
	is_togglable = true,
	options = {
	  widgets = {
		{
		  setting_id    = "DeamonTideScoreboard",
		  type          = "group",
		  title         = "deamontide_board_opt_title",
		  tooltip       = "deamontide_board_opt_tip",
		  sub_widgets   = {
			{
				setting_id    = "kills_storm_vermin",
				title         = "kills_storm_vermin_opt",
				tooltip       = "kills_storm_vermin_opt_tip",
				type          = "checkbox",
				default_value = true,
			},
			{
				setting_id    = "kills_berzerker",
				title         = "kills_berzerker_opt",
				tooltip       = "kills_berzerker_opt_tip",
				type          = "checkbox",
				default_value = true,
			},
			{
				setting_id    = "kills_chaos_warrior",
				title         = "kills_chaos_warrior_opt",
				tooltip       = "kills_chaos_warrior_opt_tip",
				type          = "checkbox",
				default_value = true,
			},
			{
				setting_id    = "kills_bestigor",
				title         = "kills_bestigor_opt",
				tooltip       = "kills_bestigor_opt_tip",
				type          = "checkbox",
				default_value = false,
			},
			{
				setting_id    = "kills_gutter_runner",
				title         = "kills_gutter_runner_opt",
				tooltip       = "kills_gutter_runner_opt_tip",
				type          = "checkbox",
				default_value = true,
			},
			{
				setting_id    = "kills_globadier",
				title         = "kills_globadier_opt",
				tooltip       = "kills_globadier_opt_tip",
				type          = "checkbox",
				default_value = false,
			},
			{
				setting_id    = "kills_pack_master",
				title         = "kills_pack_master_opt",
				tooltip       = "kills_pack_master_opt_tip",
				type          = "checkbox",
				default_value = true,
			},
			{
				setting_id    = "kills_ratling_gunner",
				title         = "kills_ratling_gunner_opt",
				tooltip       = "kills_ratling_gunner_opt_tip",
				type          = "checkbox",
				default_value = true,
			},
			{
				setting_id    = "kills_warpfire_thrower",
				title         = "kills_warpfire_thrower_opt",
				tooltip       = "kills_warpfire_thrower_opt_tip",
				type          = "checkbox",
				default_value = false,
			},
			{
				setting_id    = "kills_chaos_sorcerer",
				title         = "kills_chaos_sorcerer_opt",
				tooltip       = "kills_chaos_sorcerer_opt_tip",
				type          = "checkbox",
				default_value = true,
			},
			{
				setting_id    = "kills_standard_bearer",
				title         = "kills_standard_bearer_opt",
				tooltip       = "kills_standard_bearer_opt_tip",
				type          = "checkbox",
				default_value = false,
			},
		  }
		},
	  },
	},
}