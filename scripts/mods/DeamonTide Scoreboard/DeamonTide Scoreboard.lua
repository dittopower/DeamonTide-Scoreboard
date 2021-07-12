local mod = get_mod("DeamonTide Scoreboard")

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
		sort_function = mod.sort_function_greater
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
		sort_function = mod.sort_function_greater
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
		sort_function = mod.sort_function_greater
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
		sort_function = mod.sort_function_greater
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
		sort_function = mod.sort_function_greater
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
		sort_function = mod.sort_function_greater
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
		sort_function = mod.sort_function_greater
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
		sort_function = mod.sort_function_greater
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
		sort_function = mod.sort_function_greater
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
		sort_function = mod.sort_function_greater
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
		sort_function = mod.sort_function_greater
	}
}
mod.total_extra_rows = 0

mod.registerStat = function(newStat)
	-- mod:echo("Add "..newStat.name)
	if mod.total_extra_rows >= 8 then
		mod:warning("Vermintide 2 only allows up to 8 additions to the scoreboard, if any other mods add to it, your game will crash! Consider Disabling some DeamonTide Scoreboard catagories.")
	end
	if mod.total_extra_rows <= 8 then
		if not tablex.find_if(ScoreboardHelper.scoreboard_topic_stats, function(scoreboard_topic_stat)
			return scoreboard_topic_stat.name == newStat.name
		end) then
			table.insert(ScoreboardHelper.scoreboard_topic_stats, newStat)
		end

		if not tablex.find_if(ScoreboardHelper.scoreboard_grouped_topic_stats[1].stats, function(name)
			return name == newStat.name
		end) then
			table.insert(ScoreboardHelper.scoreboard_grouped_topic_stats[1].stats, newStat.name)
		end

		if not StatisticsDefinitions.player[newStat.name] then
			StatisticsDefinitions.player[newStat.name] = {
				value = 0,
				name = newStat.name
			}
		end
		mod.total_extra_rows = mod.total_extra_rows + 1
	else
		mod:error("Exceeded Maximum 8 additions to the scoreboard... Skipping adding")
	end
end

mod.unregisterStat = function(oldStatName)
	-- mod:echo("Remove "..oldStatName)
	indexa, reta = tablex.find_if(ScoreboardHelper.scoreboard_topic_stats, function(scoreboard_topic_stat)
		return scoreboard_topic_stat.name == oldStatName
	end)
	if reta then
		table.remove(ScoreboardHelper.scoreboard_topic_stats, indexa)
	end

	indexb, retb = tablex.find_if(ScoreboardHelper.scoreboard_grouped_topic_stats[1].stats, function(name)
		return name == oldStatName
	end)
	if retb then
		table.remove(ScoreboardHelper.scoreboard_grouped_topic_stats[1].stats, indexb)
	end

	if not (not StatisticsDefinitions.player[oldStatName]) then
		StatisticsDefinitions.player[oldStatName] = nil
	end
	-- mod.total_extra_rows = mod.total_extra_rows - 1
end

-- Check mod options and update registered scoreboard entries
mod:pcall(function()
	mod.total_extra_rows = 0
	for index, extended_stat in pairs(mod.extended_stats) do
		if (mod:get("deamontide_"..extended_stat.name)) then
			mod.registerStat(extended_stat)
		else
			mod.unregisterStat(extended_stat.name)
		end
	end
end)

mod.intial_draw_sizes = {}
-- Redraw the table
mod:hook(EndViewStateScore, "draw", function(func, self, ...)
	mod:pcall(function()
		local row_size = 30
		local size_delta = mod.total_extra_rows * row_size
		
		local total_rows = 12 + mod.total_extra_rows
		local total_size = total_rows * row_size;

		local modifier = 5
		local frame_off_modifier = -modifier
		local glass_off_modifier = -2.5 * modifier

		local hero_widget_size = 7 * row_size

		-- Player columns
		for i = 1, 4 do
			self._hero_widgets[i].offset[2] = size_delta
			local sw = self._score_widgets[i]
			sw.offset[1] = -0
			sw.offset[2] = size_delta

			sw.style.background_left_glow.offset[2] = -size_delta
			sw.style.background_right_glow.offset[2] = -size_delta
			sw.style.background.offset[2] = -modifier - size_delta - row_size/2
			sw.style.background.size[2] = total_size + hero_widget_size + row_size/2

			-- Little white lines at the top/bottom of columns
			sw.style.glass_top.offset[2] = total_size + hero_widget_size - row_size/2 - size_delta + 1
			sw.style.glass_bottom.offset[2] = -size_delta - row_size/2 + 1

			-- Column borders
			sw.style.frame.offset[2] = frame_off_modifier - size_delta - row_size/2
			sw.style.frame.size[2] = total_size + hero_widget_size + row_size/2

			sw.style.edge_fade.offset[2] = -modifier - size_delta
			sw.style.edge_fade.size[2] = row_size
		end

		-- Center scoreboard column
		for i = 1, 3 do
			self._widgets[i].offset[2] = size_delta
		end
		self._widgets[2].style.background.offset[2] = -size_delta - row_size/2
		self._widgets[2].style.background.size[2] = total_size + ( hero_widget_size /2 ) + row_size/2

		self._widgets[2].style.frame.offset[2] = - size_delta -row_size/2
		self._widgets[2].style.frame.size[2] = total_size + ( hero_widget_size /2 ) + row_size/2

		self._widgets[2].style.edge_fade.offset[2] = -modifier - size_delta
		self._widgets[2].style.edge_fade.size[2] = size_delta

		self._widgets[2].style.glass_top.offset[2] = total_size + ( hero_widget_size /2 ) - row_size/2 - size_delta + modifier
		self._widgets[2].style.glass_bottom.offset[2] = modifier - size_delta -row_size/2
	end)

	return func(self, ...)
end)
