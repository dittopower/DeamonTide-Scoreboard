local mod = get_mod("DeamonTide Scoreboard")
local scoreboard_extension = nil
-- Global imports
local pl = require'pl.import_into'()
local tablex = require'pl.tablex'

-- UI Strings
mod:hook("Localize", function (func, id, ...)
	-- If from this mod, use this mod's localisations file
	if string.find(id, "deamontide_") then
		return mod:localize(id)
	end
	return func(id, ...)
end)

-- Declare re-usable sort function for scoreboard rankings
mod.sort_function_greater = function (a, b)
	return b.score < a.score
end

-- pre-define scoreboard entries for later registration
mod.extended_stats = {
	{
		name = "kills_storm_vermin",
		display_text = "deamontide_score_storm_vermin",
		stat_types = {
			{
				"kills_per_breed",
				"skaven_storm_vermin"
			},
			{
				"kills_per_breed",
				"skaven_storm_vermin_commander"
			},
			{
				"kills_per_breed",
				"skaven_storm_vermin_with_shield"
			}
		},
		sort_function = mod.sort_function_greater,
		sort_order = "highest"
	},
	{
		name = "kills_berzerker",
		display_text = "deamontide_score_berzerker",
		stat_types = {
			{
				"kills_per_breed",
				"skaven_plague_monk"
			},
			{
				"kills_per_breed",
				"chaos_berzerker"
			}
		},
		sort_function = mod.sort_function_greater,
		sort_order = "highest"
	},
	{
		name = "kills_chaos_warrior",
		display_text = "deamontide_score_chaos_warrior",
		stat_types = {
			{
				"kills_per_breed",
				"chaos_warrior"
			},
		},
		sort_function = mod.sort_function_greater,
		sort_order = "highest"
	},
	{
		name = "kills_bestigor",
		display_text = "deamontide_score_bestigor",
		stat_types = {
			{
				"kills_per_breed",
				"beastmen_bestigor"
			}
		},
		sort_function = mod.sort_function_greater,
		sort_order = "highest"
	},
	{
		name = "kills_gutter_runner",
		display_text = "deamontide_score_gutter_runner",
		stat_types = {
			{
				"kills_per_breed",
				"skaven_gutter_runner"
			}
		},
		sort_function = mod.sort_function_greater,
		sort_order = "highest"
	},
	{
		name = "kills_globadier",
		display_text = "deamontide_score_globadier",
		stat_types = {
			{
				"kills_per_breed",
				"skaven_poison_wind_globadier"
			}
		},
		sort_function = mod.sort_function_greater,
		sort_order = "highest"
	},
	{
		name = "kills_pack_master",
		display_text = "deamontide_score_pack_master",
		stat_types = {
			{
				"kills_per_breed",
				"skaven_pack_master"
			}
		},
		sort_function = mod.sort_function_greater,
		sort_order = "highest"
	},
	{
		name = "kills_ratling_gunner",
		display_text = "deamontide_score_ratling_gunner",
		stat_types = {
			{
				"kills_per_breed",
				"skaven_ratling_gunner"
			}
		},
		sort_function = mod.sort_function_greater,
		sort_order = "highest"
	},
	{
		name = "kills_warpfire_thrower",
		display_text = "deamontide_score_warpfire_thrower",
		stat_types = {
			{
				"kills_per_breed",
				"skaven_warpfire_thrower"
			}
		},
		sort_function = mod.sort_function_greater,
		sort_order = "highest"
	},
	{
		name = "kills_chaos_sorcerer",
		display_text = "deamontide_score_chaos_sorcerer",
		stat_types = {
			{
				"kills_per_breed",
				"chaos_corruptor_sorcerer"
			},
			{
				"kills_per_breed",
				"chaos_vortex_sorcerer"
			}
		},
		sort_function = mod.sort_function_greater,
		sort_order = "highest"
	},
	{
		name = "kills_standard_bearer",
		display_text = "deamontide_score_standard_bearer",
		stat_types = {
			{
				"kills_per_breed",
				"beastmen_standard_bearer"
			}
		},
		sort_function = mod.sort_function_greater,
		sort_order = "highest"
	}
}

-- Array to store stats
mod.recordedStats = {}

-- function for scoreboard to get stat
mod.getStat = function(peer_id, local_player_id, stats_id, entry_id)
	local id = mod.simplifyStatId(stats_id)
	if mod.recordedStats[id] then
		if mod.recordedStats[id][entry_id] then
			return mod.recordedStats[id][entry_id] or 0
		end
	end
	return 0
end

mod.simplifyStatId = function (inputstr)
	return string.gsub(inputstr, "[^:]+:", "")
end

-- Load scores into recordedStats at end of game
mod:hook(EndViewStateScore, "_setup_player_scores", function(func, self, players_session_scores)
	if pcall(function ()
		local i = 1
		for index, player_data in pairs(players_session_scores) do
			local id = mod.simplifyStatId(index)
			if not mod.recordedStats[id] then
				mod.recordedStats[id] = {}
			end
			for _, statData in pairs(mod.extended_stats) do
				mod.recordedStats[id][statData.name] = player_data[statData.name] or 0
			end
			i = i + 1
		end
	end) then
		mod:echo("_setup_player_scores ok")
	else
		mod:echo("_setup_player_scores ko")
	end
	return func(self, players_session_scores)
end)

-- Check mod options and update scoreboard entry visibility
mod.toggleStats = function ()
	if scoreboard_extension then
		for _, statData in pairs(mod.extended_stats) do
			if (mod:get("deamontide_"..statData.name)) then
				scoreboard_extension:set_entry(statData.name, true)
			else
				scoreboard_extension:set_entry(statData.name, false)
			end
		end
	end
end

-- Once all mods are loaded register scoreboard additions via scoreboard_extension mod
mod.on_all_mods_loaded = function ()
	scoreboard_extension = get_mod("scoreboard_extension")
	if scoreboard_extension then
		for index, statData in pairs(mod.extended_stats) do
			if not tablex.find_if(ScoreboardHelper.scoreboard_topic_stats, function(scoreboard_topic_stat)
				return scoreboard_topic_stat.name == statData.name
			end) then
				table.insert(ScoreboardHelper.scoreboard_topic_stats, statData)
			end

			if not tablex.find_if(ScoreboardHelper.scoreboard_grouped_topic_stats[1].stats, function(name)
				return name == statData.name
			end) then
				table.insert(ScoreboardHelper.scoreboard_grouped_topic_stats[1].stats, statData.name)
			end

		for _, statData in pairs(mod.extended_stats) do
			local created = scoreboard_extension:register_entry(statData.name, mod:localize(statData.display_text), statData.statData, mod.getStat)
		end
	end
	mod.toggleStats()
end

-- Update visability 
mod.on_setting_changed = function ()
	mod.toggleStats()
end
