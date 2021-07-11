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
		return "Choas Warriors Killed"
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

