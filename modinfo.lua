name = "Syelza风幻龙 (new)"
description = [[居于塞尔菲亚镇掌握符文之力的圣龙, 击杀怪物掉落符文结晶
吃火龙果和浆果(可选)升级! (满级10级, 等级越高, 失败概率越高)
最喜欢的食物是香蕉奶昔, 在食用它时会额外恢复15点饱腹
专属武器金芜菁之杖, 附带冰柱/着火(夜间)特效, 触发概率自选
移动速度随等级提高加快! 是图书管理员的朋友!

重制内容:
1. 加快成长速度, 优化等级系统, 允许重新分配技能点
2. 萌妹子的宝具添加支持划水、劈砍、犁地、强力开采
3. 可以使用8个采下的芦苇和1个符文结晶制作2个猴尾草
4. 击败怪物、敌对生物概率掉落符文结晶, 击败Boss必定掉落
5. 护身符有一个格子, 可放入一个符文结晶/纯粹恐惧/纯粹辉煌
6. 专属食品黑夜祝福X将会在月圆夜得到祝福
7. 暗影苹果和冰雪苹果具有额外的魔法/保鲜效果
8. 专属食品南瓜布丁可以下锅, 提供1乳制品度、1甜味剂度

(更多信息请前往mod主页查看)]]
author = "Sunrise"
version = "2.2.4"

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
        label = "语言设置",
        hover = "Language setting",
        options = {
            { description = "中文", data = 0, hover = "Default" },
            { description = "English", data = 1 },
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
            { description = "T", data = "KEY_T", hover = "Default" },
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
            { description = "R", data = "KEY_R", hover = "Default" },
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
            { description = "off", data = false, hover = "Default" },
            { description = "on",  data = true },
        },

        default = false,
    },

    {
        name = "fhl_jgeatsl",
        label = "吃多少个浆果升级",
        hover = "How many berries to upgrade",
        options = {
            { description = "20", data = 20 },
            { description = "40", data = 40 },
            { description = "60", data = 60, hover = "Default" },
            { description = "80", data = 80 },
        },

        default = 60,
    },

    {
        name = "fhl_levelup_failure_factor",
        label = "升级失败的计算因子(与失败概率正相关)",
        hover = "Probability of levelup failure",
        options = {
            { description = "0",   data = 0 },
            { description = "0.4", data = 0.4 },
            { description = "0.5", data = 0.5 },
            { description = "0.6", data = 0.6, hover = "Default" },
            { description = "0.7", data = 0.7, hover = "why?" },
        },

        default = 0.6,
    },

    {
        name = "fhl_cos",
        label = "符文结晶爆率",
        hover = "Drop probability of the Ancient soul",
        options = {
            { description = "0",   data = 0 },
            { description = "5%",  data = 0.05 },
            { description = "10%", data = 0.1, hover = "Default" },
            { description = "20%", data = 0.2 },
            { description = "40%", data = 0.4 },
            { description = "50%", data = 0.5 },
        },

        default = 0.1,
    },

    {
        name = "bb_hjopen",
        label = "背包护甲功能",
        hover = "The Backpack's armor function",
        options = {
            { description = "off", data = false, hover = "Default" },
            { description = "on",  data = true },
        },

        default = false,
    },

    {
        name = "bb_durability",
        label = "背包护甲耐久度",
        hover = "The Backpack's armor durability",
        options = {
            { description = "1200", data = 1200 },
            { description = "1800", data = 1800 },
            { description = "2400", data = 2400, hover = "Default" },
            { description = "3000", data = 3000 },
            { description = "3600", data = 3600 },
            { description = "4800", data = 4800 },
        },

        default = 2400,
    },

    {
        name = "bb_waterproofness",
        label = "背包的防水效果",
        hover = "The Backpack's waterproofer degree",
        options = {
            { description = "0",    data = 0,  hover = "Default" },
            { description = "20%",  data = 0.2 },
            { description = "40%",  data = 0.4 },
            { description = "60%",  data = 0.6 },
            { description = "80%",  data = 0.8 },
            { description = "100%", data = 1 },
        },

        default = 0,
    },

    {
        name = "zzj_finiteuses",
        label = "金芜菁之杖耐久度",
        hover = "The Golden wujing's finiteuses",
        options = {
            { description = "120",     data = 120 },
            { description = "240",     data = 240, hover = "Default" },
            { description = "480",     data = 480 },
            { description = "960",     data = 960 },
            { description = "endless", data = 0 },
        },
        default = 240,
    },

    {
        name = "zzj_gjbl",
        label = "金芜菁之杖普通攻击伤害倍率",
        hover = "Normal attack multiplier with sword",
        options = {
            { description = "50%",  data = 0.5 },
            { description = "75%",  data = 0.75 },
            { description = "100%", data = 1,   hover = "Default" },
            { description = "125%", data = 1.25 },
            { description = "150%", data = 1.5 },
            { description = "175%", data = 1.75 },
            { description = "200%", data = 2.0 },
            { description = "300%", data = 3.0 },
        },
        default = 1,
    },

    {
        name = "zzj_pre",
        label = "金芜菁之杖特效伤害倍率",
        hover = "Sword special effect damage percentage",
        options = {
            { description = "50%",  data = 0.5 },
            { description = "100%", data = 1,  hover = "Default" },
            { description = "150%", data = 1.5 },
            { description = "200%", data = 2.0 },
            { description = "300%", data = 3.0 },
        },
        default = 1,
    },

    {
        name = "zzj_fireopen",
        label = "金芜菁之杖火焰特效",
        hover = "With sword and flame special effects",
        options = {
            { description = "off", data = false, hover = "Default" },
            { description = "on",  data = true },
        },
        default = false,
    },

    {
        name = "zzj_cankanshu",
        label = "金芜菁之杖可以用做斧子",
        hover = "Can The Golden wujing cut down trees?",
        options = {
            { description = "off", data = false, hover = "Default" },
            { description = "on",  data = true },
        },
        default = false,
    },

    {
        name = "zzj_canwakuang",
        label = "金芜菁之杖可以用做镐头",
        hover = "Can The Golden wujing mining?",
        options = {
            { description = "off", data = false, hover = "Default" },
            { description = "on",  data = true },
        },
        default = false,
    },

    {
        name = "zzj_canuseasshovel",
        label = "金芜菁之杖可以用做铲子",
        hover = "Can The Golden wujing use as shovel?",
        options = {
            { description = "off", data = false, hover = "Default" },
            { description = "on",  data = true },
        },
        default = false,
    },

    {
        name = "zzj_canuseashammer",
        label = "金芜菁之杖可以用做锤子",
        hover = "Can The Golden wujing use as hammer?",
        options = {
            { description = "off", data = false, hover = "Default" },
            { description = "on",  data = true },
        },
        default = false,
    },

    {
        name = "openlight",
        label = "幻儿自己发光",
        hover = "Can Syelza herself shine all the time?",
        options = {
            { description = "off", data = false, hover = "Default" },
            { description = "on",  data = true },
        },
        default = false,
    },

    {
        name = "openli",
        label = "风幻的苹果(狗箱)发光",
        hover = "Can the Apple(chester) shine?",
        options = {
            { description = "off", data = false, hover = "Default" },
            { description = "on",  data = true },
        },

        default = false,
    },

    {
        name = "applestore",
        label = "苹果新零售(铃铛在物品栏方可交易)",
        hover = "Enable trading with the Apple(chester)?",
        options = {
            { description = "off", data = false, hover = "Default" },
            { description = "on",  data = true },
        },

        default = false,
    },

    {
        name = "buffgo",
        label = "护身符吸收一半伤害",
        hover = "Can the Amulet absorbs half damage?",
        options = {
            { description = "on",  data = true, hover = "Default" },
            { description = "off", data = false },
        },

        default = true,
    },

    {
        name = "hsf_respawn",
        label = "作祟护身符重生效果",
        hover = "Can the Amulet respawn haunting ghost?",
        options = {
            { description = "off",     data = 0, hover = "Default" },
            { description = "one-off", data = 1 },
            { description = "once",    data = 2 },
            { description = "always",  data = 3 },
        },

        default = 0,
    },

    {
        name = "hsf_position",
        label = "护身符格子显示在第几个装备格上方",
        hover = "Which grid should the Amulet be shown above?",
        options = {
            { description = "3", data = 108, hover = "Default" },
            { description = "4", data = 160 },
            { description = "5", data = 214 },
        },

        default = 108,
    },

    {
        name = "skill_tree",
        label = "技能树预览功能中的数值型增强",
        hover = "Enable the preview functions about the skill tree?",
        options = {
            { description = "off", data = false, hover = "Default" },
            { description = "on",  data = true },
        },

        default = false,
    }
}
