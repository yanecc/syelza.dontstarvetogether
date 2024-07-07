-- A:\Steam\steamapps\workshop\content\322330
name = "Syelza风幻龙 (new)"
description =
"\n\n居于塞尔菲亚镇掌握符文之力的圣龙\n击杀怪物掉落符文结晶\n黑夜中提高移速,适度降低受到的伤害,稍微提高饥饿速度,稍微降低攻击力.\n白天稍微降低受到的伤害,适度提高攻击力,适度降低饥饿速度\n吃火龙果和浆果升级!(满级10,等级越高,升级几率越低)\n自带武器金芜菁之杖(附带冰柱/着火(是夜)特效,触发几率自选)\n移动速度随等级提高加快!\n是图书管理员的朋友"
author = "老熊&小北"
version = "1.9.4"

--------更新网址
forumthread = ""

api_version = 10

dst_compatible = true
dont_starve_compatible = false
reign_of_giants_compatible = false
all_clients_require_mod = true

icon_atlas = "modicon.xml"
icon = "modicon.tex"

configuration_options = {
	{
		name = "fhl_language",
		label = "设置语言",
		hover = "Language setting",
		options = {
			{ description = "Chinses(default)", data = 0 },
			{ description = "English",          data = 1 },
		},

		default = 0,
	},

	{
		name = "fhl_jgeat",
		label = "吃浆果升级功能",
		hover = "Eating berry upgrade function",
		options = {
			{ description = "open",           data = true },
			{ description = "close(default)", data = false },
		},

		default = false,
	},

	{
		name = "fhl_jgeatsl",
		label = "吃多少个浆果升级",
		hover = "How many berries to upgrade",
		options = {
			{ description = "20",          data = 20 },
			{ description = "40",          data = 40 },
			{ description = "60(default)", data = 60 },
			{ description = "80",          data = 80 },
		},

		default = 60,
	},

	{
		name = "fhl_levelup_fail_probability",
		label = "升级失败的计算因子（与失败概率正相关）",
		hover = "Probability of levelup failure",
		options = {
			{ description = "0",            data = 0 },
			{ description = "0.4",          data = 0.4 },
			{ description = "0.5",          data = 0.5 },
			{ description = "0.6(default)", data = 0.6 },
			{ description = "0.7",          data = 0.7 },
		},

		default = 0.6,
	},

	{
		name = "fhl_cos",
		label = "符文结晶爆率",
		hover = "Drop probability of The Ancient soul",
		options = {
			{ description = "0",           data = 0 },
			{ description = "1%",          data = 0.01 },
			{ description = "5%(default)", data = 0.05 },
			{ description = "10%",         data = 0.1 },
			{ description = "20%",         data = 0.2 },
			{ description = "30%",         data = 0.3 },
		},

		default = 0.05,
	},

	{
		name = "fhl_hjopen",
		label = "背包护甲功能",
		hover = "The Backpack's armor function",
		options = {
			{ description = "open(default)", data = true },
			{ description = "close",         data = false },
		},

		default = true,
	},

	{
		name = "zzj_gjbl",
		label = "配剑普通攻击倍率",
		hover = "Normal attack multiplier with sword",
		options = {
			{ description = "50%",           data = 0.5 },
			{ description = "75%",           data = 0.75 },
			{ description = "100%(default)", data = 1 },
			{ description = "125%",          data = 1.25 },
			{ description = "150%",          data = 1.5 },
			{ description = "175%",          data = 1.75 },
			{ description = "200%",          data = 2.0 },
			{ description = "300%",          data = 3.0 },
		},
		default = 1,
	},

	{
		name = "zzj_fireopen",
		label = "配剑火焰特效:",
		hover = "With sword and flame special effects",
		options = {
			{ description = "open",           data = true },
			{ description = "close(default)", data = false },
		},
		default = false,
	},

	{
		name = "zzj_pre",
		label = "配剑特效伤害百分比:",
		hover = "Sword special effect damage percentage",
		options = {
			{ description = "50%",           data = 0.5 },
			{ description = "100%(default)", data = 1 },
			{ description = "150%",          data = 1.5 },
			{ description = "200%",          data = 2.0 },
			{ description = "300%",          data = 3.0 },
		},
		default = 1,
	},

	{
		name = "openlight",
		label = "幻儿会自己持久发光吗:",
		hover = "Can Syelza herself shine all the time?",
		options = {
			{ description = "yes",         data = true },
			{ description = "no(default)", data = false },
		},
		default = false,
	},

	{
		name = "zzj_cankanshu",
		label = "配剑可以当做斧子:",
		hover = "Can The Golden wujing cut down trees?",
		options = {
			{ description = "yes(default)", data = true },
			{ description = "no",           data = false },
		},
		default = true,
	},

	{
		name = "zzj_canwakuang",
		label = "配剑可以当做镐头:",
		hover = "Can The Golden wujing mining?",
		options = {
			{ description = "yes(default)", data = true },
			{ description = "no",           data = false },
		},
		default = true,
	},

	{
		name = "zzj_canuseasshovel",
		label = "配剑可当做铲子:",
		hover = "Can The Golden wujing use as shovel?",
		options = {
			{ description = "yes",         data = true },
			{ description = "no(default)", data = false },
		},
		default = false,
	},

	{
		name = "zzj_canuseashammer",
		label = "配剑可以当做锤子:",
		hover = "Can The Golden wujing use as hammer?",
		options = {
			{ description = "yes",         data = true },
			{ description = "no(default)", data = false },
		},
		default = false,
	},

	{
		name = "zzj_finiteuses",
		label = "配剑耐久度:",
		hover = "The Golden wujing's finiteuses",
		options = {
			{ description = "120",          data = 120 },
			{ description = "240(default)", data = 240 },
			{ description = "480",          data = 480 },
			{ description = "960",          data = 960 },
			{ description = "endless",      data = 0 },
		},
		default = 240,
	},

	{
		name = "openli",
		label = "狗箱发光",
		hover = "Can the apple(chester) shine?",
		options = {
			{ description = "yes(default)", data = true },
			{ description = "no",           data = false },
		},

		default = true,
	},

	{
		name = "buffgo",
		label = "护身符吸收一半伤害",
		hover = "Can the Amulet absorbs half damage?",
		options = {
			{ description = "yes(default)", data = true },
			{ description = "no",           data = false },
		},

		default = true,
	},
}
