local mod = get_mod("DeamonTide Scoreboard")

-- Global imports
local pl = require'pl.import_into'()
local tablex = require'pl.tablex'

-- UI Strings
mod:hook("Localize", function (func, id, ...)
	if id == "scoreboard_topic_storm_vermin" then
		return "Storm Vermin Killed"
	end
	if id == "scoreboard_topic_berzerker" then
		return "Berzerkers Killed"
	end
	if id == "scoreboard_topic_chaos_warrior" then
		return "Chaos Warriors Killed"
	end
	if id == "scoreboard_topic_bestigor" then
		return "Bestigors Killed"
	end
	return func(id, ...)
end)

-- Types kill kills to count
mod.extended_stats = {
	{
		name = "kills_storm_vermin",
		display_text = "scoreboard_topic_storm_vermin",
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
		sort_function = function (a, b)
			return b.score < a.score
		end
	},
	{
		name = "kills_berzerker",
		display_text = "scoreboard_topic_berzerker",
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
		sort_function = function (a, b)
			return b.score < a.score
		end
	},
	{
		name = "kills_chaos_warrior",
		display_text = "scoreboard_topic_chaos_warrior",
		stat_types = {
			{
				"kills_per_breed",
				"chaos_warrior"
			},
		},
		sort_function = function (a, b)
			return b.score < a.score
		end
	},
	{
		name = "kills_bestigor",
		display_text = "scoreboard_topic_bestigor",
		stat_types = {
			{
				"kills_per_breed",
				"beastmen_bestigor"
			}
		},
		sort_function = function (a, b)
			return b.score < a.score
		end
	}
}



mod:pcall(function()
	for index, extended_stat in pairs(mod.extended_stats) do
		if not tablex.find_if(ScoreboardHelper.scoreboard_topic_stats, function(scoreboard_topic_stat)
			return scoreboard_topic_stat.name == extended_stat.name
		end) then
			table.insert(ScoreboardHelper.scoreboard_topic_stats, extended_stat)
		end
		if not tablex.find_if(ScoreboardHelper.scoreboard_grouped_topic_stats[1].stats, function(name)
			return name == extended_stat.name
		end) then
			table.insert(ScoreboardHelper.scoreboard_grouped_topic_stats[1].stats, extended_stat.name)
		end

		if not StatisticsDefinitions.player[extended_stat.name] then
			StatisticsDefinitions.player[extended_stat.name] = {
				value = 0,
				name = extended_stat.name
			}
		end
	end
end)

mod.intial_draw_sizes = {}
-- Redraw the table?
mod:hook(EndViewStateScore, "draw", function(func, self, ...)
	mod:pcall(function()
		local extra_rows = table.getn(mod.extended_stats)
		local row_size = 30
		local size_delta = extra_rows * row_size
		
		local total_rows = 12 + extra_rows
		local total_size = total_rows * row_size;

		local modifier = 5
		local frame_off_modifier = -modifier
		local glass_off_modifier = -2.5 * modifier

		local hero_widget_size = 7 * row_size

		-- Player columns
		for i = 1, 4 do
			self._hero_widgets[i].offset[2] = size_delta
			-- mod:echo( i .. ": " .. "_score_widgets: " .. i)
			local sw = self._score_widgets[i]
			-- mod:echo( i .. ": " .. "offset[1]: " .. sw.offset[1])
			-- mod:echo( i .. ": " .. "offset[2]: " .. sw.offset[2])
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
