name = "Syelza风幻龙 (new)"
description =
"\n居于塞尔菲亚镇掌握符文之力的圣龙,击杀怪物掉落符文结晶\n吃火龙果和浆果(可选)升级!(满级10级,等级越高,失败概率越高)\n专属武器金芜菁之杖(附带冰柱/着火(夜间)特效,触发概率自选)\n移动速度随等级提高加快!是图书管理员的朋友!\n\n重制内容:\n1. 风幻专属食品黑夜祝福X将会在月圆夜得到祝福\n2. 加快成长速度,食用芝士蛋糕会重置等级和技能点\n3. 专属制作物配方及属性平衡性调整\n4. 修正风幻的苹果(狗箱)发光效果及始终生效\n5. 希雅蕾丝树枝和耀古之晶放置适配几何布局mod\n6. 萌妹子的宝具添加支持锄草、犁地(一键九格)、强力开采(绝望石等)\n7. 南瓜布丁可以下锅,提供1乳制品度、1甜味剂度\n8. 大幅增强风幻与新版饥荒联机版世界的互动性\n  (更多信息请前往mod主页查看)"
author = "Sunrise"
version = "2.1.5"

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
        name = "status_key",
        label = "查看当前状态的快捷键",
        hover = "The key to check current status",
        options = {
            { description = "B", data = "KEY_B" },
            { description = "G", data = "KEY_G" },
            { description = "H", data = "KEY_H" },
            { description = "J", data = "KEY_J" },
            { description = "K", data = "KEY_K" },
            { description = "L", data = "KEY_L" },
            { description = "N", data = "KEY_N" },
            { description = "O", data = "KEY_O" },
            { description = "P", data = "KEY_P" },
            { description = "R", data = "KEY_R" },
            { description = "T", data = "KEY_T" },
            { description = "V", data = "KEY_V" },
            { description = "X", data = "KEY_X" },
            { description = "Z", data = "KEY_Z" },
        },

        default = "KEY_T",
    },

    {
        name = "skill_point_key",
        label = "查看加点提示的快捷键",
        hover = "The key to show available skill points",
        options = {
            { description = "B", data = "KEY_B" },
            { description = "G", data = "KEY_G" },
            { description = "H", data = "KEY_H" },
            { description = "J", data = "KEY_J" },
            { description = "K", data = "KEY_K" },
            { description = "L", data = "KEY_L" },
            { description = "N", data = "KEY_N" },
            { description = "O", data = "KEY_O" },
            { description = "P", data = "KEY_P" },
            { description = "R", data = "KEY_R" },
            { description = "T", data = "KEY_T" },
            { description = "V", data = "KEY_V" },
            { description = "X", data = "KEY_X" },
            { description = "Z", data = "KEY_Z" },
        },

        default = "KEY_R",
    },

    {
        name = "fhl_jgeat",
        label = "吃浆果升级功能",
        hover = "Eating berry upgrade function",
        options = {
            { description = "close(default)", data = false },
            { description = "open",           data = true },
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
        name = "fhl_levelup_failure_factor",
        label = "升级失败的计算因子(与失败概率正相关)",
        hover = "Probability of levelup failure",
        options = {
            { description = "0",            data = 0 },
            { description = "0.4",          data = 0.4 },
            { description = "0.5",          data = 0.5 },
            { description = "0.6(default)", data = 0.6 },
            { description = "0.7(why?)",    data = 0.7 },
        },

        default = 0.6,
    },

    {
        name = "fhl_cos",
        label = "符文结晶爆率",
        hover = "Drop probability of the Ancient soul",
        options = {
            { description = "0",            data = 0 },
            { description = "5%",           data = 0.05 },
            { description = "10%(default)", data = 0.1 },
            { description = "20%",          data = 0.2 },
            { description = "40%",          data = 0.4 },
            { description = "50%",          data = 0.5 },
        },

        default = 0.1,
    },

    {
        name = "bb_hjopen",
        label = "背包护甲功能",
        hover = "The Backpack's armor function",
        options = {
            { description = "close(default)", data = false },
            { description = "open",           data = true },
        },

        default = false,
    },

    {
        name = "bb_durability",
        label = "背包护甲耐久(耐久耗尽会消失)",
        hover = "The Backpack's armor function",
        options = {
            { description = "1200",          data = 1200 },
            { description = "1800",          data = 1800 },
            { description = "2400(default)", data = 2400 },
            { description = "3000",          data = 3000 },
            { description = "3600",          data = 3600 },
            { description = "4800",          data = 4800 },
        },

        default = 2400,
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
            { description = "close(default)", data = false },
            { description = "open",           data = true },
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
            { description = "no(default)", data = false },
            { description = "yes",         data = true },
        },
        default = false,
    },

    {
        name = "zzj_cankanshu",
        label = "配剑可以当做斧子:",
        hover = "Can The Golden wujing cut down trees?",
        options = {
            { description = "no(default)", data = false },
            { description = "yes",         data = true },
        },
        default = false,
    },

    {
        name = "zzj_canwakuang",
        label = "配剑可以当做镐头:",
        hover = "Can The Golden wujing mining?",
        options = {
            { description = "no(default)", data = false },
            { description = "yes",         data = true },
        },
        default = false,
    },

    {
        name = "zzj_canuseasshovel",
        label = "配剑可当做铲子:",
        hover = "Can The Golden wujing use as shovel?",
        options = {
            { description = "no(default)", data = false },
            { description = "yes",         data = true },
        },
        default = false,
    },

    {
        name = "zzj_canuseashammer",
        label = "配剑可以当做锤子:",
        hover = "Can The Golden wujing use as hammer?",
        options = {
            { description = "no(default)", data = false },
            { description = "yes",         data = true },
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
        hover = "Can the Apple(chester) shine?",
        options = {
            { description = "no(default)", data = false },
            { description = "yes",         data = true },
        },

        default = false,
    },

    {
        name = "applestore",
        label = "苹果新零售(铃铛在物品栏方可交易)",
        hover = "Enable trading with the Apple(chester)?",
        options = {
            { description = "no(default)", data = false },
            { description = "yes",         data = true },
        },

        default = false,
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

    {
        name = "hsf_respawn",
        label = "作祟护身符重生效果",
        hover = "Can the Amulet respawn haunting ghost?",
        options = {
            { description = "no(default)", data = 0 },
            { description = "one-off",     data = 1 },
            { description = "always",      data = -1 },
        },

        default = 0,
    },

    {
        name = "hsf_position",
        label = "护身符格子显示在第几个装备格上方",
        hover = "Which grid should the Amulet be shown above?",
        options = {
            { description = "3(default)", data = "threegrid" },
            { description = "4",          data = "fourgrid" },
            { description = "5",          data = "fivegrid" },
        },

        default = "threegrid",
    },

    {
        name = "skill_tree",
        label = "开启技能树预览功能中的数值型增强",
        hover = "Enable the preview functions about the skill tree?",
        options = {
            { description = "no(default)", data = false },
            { description = "yes",         data = true },
        },

        default = false,
    }
}
