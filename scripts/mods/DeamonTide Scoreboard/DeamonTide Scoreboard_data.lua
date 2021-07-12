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
				setting_id    = "deamontide_kills_storm_vermin",
				title         = "deamontide_kills_storm_vermin_opt",
				tooltip       = "deamontide_kills_storm_vermin_opt_tip",
				type          = "checkbox",
				default_value = true,
			},
			{
				setting_id    = "deamontide_kills_berzerker",
				title         = "deamontide_kills_berzerker_opt",
				tooltip       = "deamontide_kills_berzerker_opt_tip",
				type          = "checkbox",
				default_value = true,
			},
			{
				setting_id    = "deamontide_kills_chaos_warrior",
				title         = "deamontide_kills_chaos_warrior_opt",
				tooltip       = "deamontide_kills_chaos_warrior_opt_tip",
				type          = "checkbox",
				default_value = true,
			},
			{
				setting_id    = "deamontide_kills_bestigor",
				title         = "deamontide_kills_bestigor_opt",
				tooltip       = "deamontide_kills_bestigor_opt_tip",
				type          = "checkbox",
				default_value = false,
			},
			{
				setting_id    = "deamontide_kills_gutter_runner",
				title         = "deamontide_kills_gutter_runner_opt",
				tooltip       = "deamontide_kills_gutter_runner_opt_tip",
				type          = "checkbox",
				default_value = true,
			},
			{
				setting_id    = "deamontide_kills_globadier",
				title         = "deamontide_kills_globadier_opt",
				tooltip       = "deamontide_kills_globadier_opt_tip",
				type          = "checkbox",
				default_value = false,
			},
			{
				setting_id    = "deamontide_kills_pack_master",
				title         = "deamontide_kills_pack_master_opt",
				tooltip       = "deamontide_kills_pack_master_opt_tip",
				type          = "checkbox",
				default_value = true,
			},
			{
				setting_id    = "deamontide_kills_ratling_gunner",
				title         = "deamontide_kills_ratling_gunner_opt",
				tooltip       = "deamontide_kills_ratling_gunner_opt_tip",
				type          = "checkbox",
				default_value = true,
			},
			{
				setting_id    = "deamontide_kills_warpfire_thrower",
				title         = "deamontide_kills_warpfire_thrower_opt",
				tooltip       = "deamontide_kills_warpfire_thrower_opt_tip",
				type          = "checkbox",
				default_value = false,
			},
			{
				setting_id    = "deamontide_kills_chaos_sorcerer",
				title         = "deamontide_kills_chaos_sorcerer_opt",
				tooltip       = "deamontide_kills_chaos_sorcerer_opt_tip",
				type          = "checkbox",
				default_value = true,
			},
			{
				setting_id    = "deamontide_kills_standard_bearer",
				title         = "deamontide_kills_standard_bearer_opt",
				tooltip       = "deamontide_kills_standard_bearer_opt_tip",
				type          = "checkbox",
				default_value = false,
			},
		  }
		},
	  },
	},
}