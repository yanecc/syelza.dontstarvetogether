local require = GLOBAL.require
local STRINGS = GLOBAL.STRINGS
local resolvefilepath = GLOBAL.resolvefilepath
local Ingredient = GLOBAL.Ingredient
local RECIPETABS = GLOBAL.RECIPETABS
local Recipe = GLOBAL.Recipe
local TECH = GLOBAL.TECH
local ACTIONS = GLOBAL.ACTIONS
local TheNet = GLOBAL.TheNet
local next = GLOBAL.next
local ThePlayer = GLOBAL.ThePlayer
local IsServer = GLOBAL.TheNet:GetIsServer()
local containers = require("containers")
local TheInput = GLOBAL.TheInput


modimport("fhl_util/fhl_util.lua")


PrefabFiles = {
    "fhl",
    "bj_11",
    "fhl_zzj",
    "fhl_zzj1",
    "fhl_zzj2",
    "fhl_zzj3",
    "fhl_zzj4",
    "fhl_zzj5",
    "fhl_hsf",
    "fhl_bz",
    "fhl_cake",
    "fhl_x",
    "fhl_x2",
    "fhl_cy",
    "personal_licking",
    "personal_licking_eyebone",
    "ancient_soul",
    "ancient_gem",
    "fhl_tree",
    --"krampus_sack",
    "fhl_bb",
}



if GetModConfigData("fhl_language") == 0 then
    GLOBAL.TUNING.FHL = {}

    GLOBAL.STRINGS.NAMES.BJ_11 = "萌妹子的宝具"
    GLOBAL.STRINGS.CHARACTERS.GENERIC.DESCRIBE.BJ_11 = "我可以用它来做所有事情。"
    GLOBAL.STRINGS.RECIPE_DESC.BJ_11 = "这是生产工具。"

    GLOBAL.STRINGS.NAMES.ANCIENT_GEM = "耀古之晶"
    GLOBAL.STRINGS.CHARACTERS.GENERIC.DESCRIBE.ANCIENT_GEM = "我感受到了上古的气息."
    GLOBAL.STRINGS.RECIPE_DESC.ANCIENT_GEM = "充斥着澎湃的\n古老的气息"

    GLOBAL.STRINGS.NAMES.FHL_TREE = "希雅蕾丝树枝"
    GLOBAL.STRINGS.CHARACTERS.GENERIC.DESCRIBE.FHL_TREE = "我感受到了生命的气息."
    GLOBAL.STRINGS.RECIPE_DESC.FHL_TREE = "生命之树的枝条\n恩,有股香蕉的味道."

    GLOBAL.STRINGS.NAMES.ANCIENT_SOUL = "符文结晶"
    GLOBAL.STRINGS.CHARACTERS.GENERIC.DESCRIBE.ANCIENT_SOUL = "这是符文的结晶."
    GLOBAL.STRINGS.RECIPE_DESC.ANCIENT_SOUL = "这是符文的结晶"

    STRINGS.NAMES.FHL_ZZJ = "金芜菁之杖-初阶"
    STRINGS.RECIPE_DESC.FHL_ZZJ = "金芜菁之杖 Lv1\n伤害: 20 冰冻概率:4%"
    STRINGS.CHARACTERS.GENERIC.DESCRIBE.FHL_ZZJ = "胸大无脑的智障剑"

    STRINGS.NAMES.FHL_ZZJ1 = "金芜菁之杖-中阶"
    STRINGS.RECIPE_DESC.FHL_ZZJ1 = "金芜菁之杖 Lv2\n伤害: 35 冰冻概率:8%"
    STRINGS.CHARACTERS.GENERIC.DESCRIBE.FHL_ZZJ1 = "胸大无脑的智障剑"

    STRINGS.NAMES.FHL_ZZJ2 = "金芜菁之杖-高阶"
    STRINGS.RECIPE_DESC.FHL_ZZJ2 = "金芜菁之杖 Lv3\n伤害: 50 冰冻概率:12%"
    STRINGS.CHARACTERS.GENERIC.DESCRIBE.FHL_ZZJ2 = "胸大无脑的智障剑"

    STRINGS.NAMES.FHL_ZZJ3 = "金芜菁之杖-史诗"
    STRINGS.RECIPE_DESC.FHL_ZZJ3 = "金芜菁之杖 Lv4\n伤害: 65 冰冻概率:16%"
    STRINGS.CHARACTERS.GENERIC.DESCRIBE.FHL_ZZJ3 = "胸大无脑的智障剑"

    STRINGS.NAMES.FHL_ZZJ4 = "金芜菁之杖-传说"
    STRINGS.RECIPE_DESC.FHL_ZZJ4 = "金芜菁之杖 Lv5\n伤害: 85 冰冻概率:20%"
    STRINGS.CHARACTERS.GENERIC.DESCRIBE.FHL_ZZJ4 = "胸大无脑的智障剑"

    STRINGS.NAMES.FHL_ZZJ5 = "诸神黄昏之杖"
    STRINGS.RECIPE_DESC.FHL_ZZJ5 = "金芜菁之杖 Lv6\n伤害: 120 冰冻概率:30%"
    STRINGS.CHARACTERS.GENERIC.DESCRIBE.FHL_ZZJ5 = "胸大无脑的智障剑"

    STRINGS.CHARACTER_TITLES.fhl = "风幻龙-瑟尔泽"
    STRINGS.CHARACTER_NAMES.fhl = "风幻龙-瑟尔泽"
    STRINGS.CHARACTER_DESCRIPTIONS.fhl = "*吃火龙果升级! (满级10),移动速度随等级提高加快\n*自带武器金芜菁之杖(附带冰柱/着火特效).\n*是图书管理员的朋友!"
    STRINGS.CHARACTER_QUOTES.fhl = "\"风幻龙-瑟尔泽.\""

    STRINGS.NAMES.FHL_HSF = "瑟尔泽的护身符"
    STRINGS.RECIPE_DESC.FHL_HSF = "由塞尔泽的羽毛制成\n守护持有者"
    STRINGS.CHARACTERS.GENERIC.DESCRIBE.FHL_HSF = "这是守护者的神器啊!"

    STRINGS.NAMES.FHL_BZ = "彩虹糕"
    STRINGS.CHARACTERS.GENERIC.DESCRIBE.FHL_BZ = "这是传说中的彩虹糕啊"
    STRINGS.RECIPE_DESC.FHL_BZ = "美味可口的彩虹糕"

    STRINGS.NAMES.FHL_CAKE = "南瓜布丁"
    STRINGS.CHARACTERS.GENERIC.DESCRIBE.FHL_CAKE = "看上去似乎很美味."
    STRINGS.RECIPE_DESC.FHL_CAKE = "简单的点心"

    STRINGS.NAMES.FHL_X = "黑夜祝福X型"
    STRINGS.CHARACTERS.GENERIC.DESCRIBE.FHL_X = "这是...一瓶药水?"
    STRINGS.RECIPE_DESC.FHL_X = "祝您长命百岁!"

    STRINGS.NAMES.FHL_X2 = "黑夜祝福X型"
    STRINGS.CHARACTERS.GENERIC.DESCRIBE.FHL_X2 = "这是...一瓶药水?"
    STRINGS.RECIPE_DESC.FHL_X2 = "祝您长命百岁!"

    STRINGS.NAMES.FHL_CY = "放松茶叶"
    STRINGS.CHARACTERS.GENERIC.DESCRIBE.FHL_CY = "看起来不错？"
    STRINGS.RECIPE_DESC.FHL_CY = "回复生命和脑力的饮品"

    STRINGS.NAMES.PERSONAL_LICKING = "风幻的苹果"
    STRINGS.CHARACTERS.GENERIC.DESCRIBE.PERSONAL_LICKING = "这是......葫芦娃?"
    STRINGS.NAMES.PERSONAL_LICKING_EYEBONE = "风幻的铃铛"
    STRINGS.CHARACTERS.GENERIC.DESCRIBE.PERSONAL_LICKING_EYEBONE = "铃铛的声音很好听."

    --GLOBAL.STRINGS.CHARACTERS.GENERIC.DESCRIBE.KRAMPUS_SACK = "it looks great."
    --GLOBAL.STRINGS.RECIPE_DESC.KRAMPUS_SACK = "集冰箱护甲暖石一身的\n高级背包"

    STRINGS.NAMES.FHL_BB = "瑟尔泽的背包"
    STRINGS.CHARACTERS.GENERIC.DESCRIBE.FHL_BB = "它看起来很棒。"
    STRINGS.RECIPE_DESC.FHL_BB = "集冰箱护甲于一身的高级背包"
else
    GLOBAL.TUNING.FHL = {}

    GLOBAL.STRINGS.NAMES.BJ_11 = "Cute girl's treasure"
    GLOBAL.STRINGS.CHARACTERS.GENERIC.DESCRIBE.BJ_11 = "I can use this to do everything."
    GLOBAL.STRINGS.RECIPE_DESC.BJ_11 = "this is the Production tools."

    GLOBAL.STRINGS.NAMES.ANCIENT_GEM = "Yaogu Crystal"
    GLOBAL.STRINGS.CHARACTERS.GENERIC.DESCRIBE.ANCIENT_GEM = "I felt the ancient's smell."
    GLOBAL.STRINGS.RECIPE_DESC.ANCIENT_GEM = "The seeds of the ancient tower."

    GLOBAL.STRINGS.NAMES.FHL_TREE = "ShiaLace Branch"
    GLOBAL.STRINGS.CHARACTERS.GENERIC.DESCRIBE.FHL_TREE = "I felt the banana's smell."
    GLOBAL.STRINGS.RECIPE_DESC.FHL_TREE = "The seeds of the banana trees."

    GLOBAL.STRINGS.NAMES.ANCIENT_SOUL = "Rune Crystal"
    GLOBAL.STRINGS.CHARACTERS.GENERIC.DESCRIBE.ANCIENT_SOUL = "this is the ancient soul."
    GLOBAL.STRINGS.RECIPE_DESC.ANCIENT_SOUL = "this is the ancient soul."

    STRINGS.NAMES.FHL_ZZJ = "Golden wujing Lv1"
    STRINGS.RECIPE_DESC.FHL_ZZJ = "Golden wujing Lv1\nATK: 20 Ice chance:4%"
    STRINGS.CHARACTERS.GENERIC.DESCRIBE.FHL_ZZJ = "This is the Golden wujing Lv1"

    STRINGS.NAMES.FHL_ZZJ1 = "Golden wujing Lv2"
    STRINGS.RECIPE_DESC.FHL_ZZJ1 = "Golden wujing Lv2\nATK: 35 Ice chance:8%"
    STRINGS.CHARACTERS.GENERIC.DESCRIBE.FHL_ZZJ1 = "This is the Golden wujing Lv2"

    STRINGS.NAMES.FHL_ZZJ2 = "Golden wujing Lv3"
    STRINGS.RECIPE_DESC.FHL_ZZJ2 = "Golden wujing Lv3\nATK: 50 Ice chance:12%"
    STRINGS.CHARACTERS.GENERIC.DESCRIBE.FHL_ZZJ2 = "This is the Golden wujing Lv3"

    STRINGS.NAMES.FHL_ZZJ3 = "Golden wujing Lv4"
    STRINGS.RECIPE_DESC.FHL_ZZJ3 = "Golden wujing Lv4\nATK: 65 Ice chance:16%"
    STRINGS.CHARACTERS.GENERIC.DESCRIBE.FHL_ZZJ3 = "This is the Golden wujing Lv4"

    STRINGS.NAMES.FHL_ZZJ4 = "Golden wujing Lv5"
    STRINGS.RECIPE_DESC.FHL_ZZJ4 = "Golden wujing Lv5\nATK 85 Ice chance:20%"
    STRINGS.CHARACTERS.GENERIC.DESCRIBE.FHL_ZZJ4 = "This is the Golden wujing Lv5"

    STRINGS.NAMES.FHL_ZZJ5 = "Golden wujing Lv6"
    STRINGS.RECIPE_DESC.FHL_ZZJ5 = "Golden wujing Lv6\nATK 120 Icechance30%"
    STRINGS.CHARACTERS.GENERIC.DESCRIBE.FHL_ZZJ5 = "This is the Golden wujing Lv6"

    STRINGS.CHARACTER_TITLES.fhl = "Syelza"
    STRINGS.CHARACTER_NAMES.fhl = "Syelza"
    STRINGS.CHARACTER_DESCRIPTIONS.fhl =
    "*The Dragonfruit can strengthen her force\n*Using The Golden wujing\n*She is the friend of the librarian"
    STRINGS.CHARACTER_QUOTES.fhl = "\"Syelza.\""

    STRINGS.NAMES.FHL_HSF = "Syelza's Amulet"
    STRINGS.RECIPE_DESC.FHL_HSF = "Made from Syelza's feathers"
    STRINGS.CHARACTERS.GENERIC.DESCRIBE.FHL_HSF = "This is the guardian's artifact!"

    STRINGS.NAMES.FHL_BZ = "Rainbow Cake"
    STRINGS.CHARACTERS.GENERIC.DESCRIBE.FHL_BZ = "This is the legendary rainbow cake"
    STRINGS.RECIPE_DESC.FHL_BZ = "Delicious rainbow cake"

    STRINGS.NAMES.FHL_CAKE = "Pumpkin Pudding"
    STRINGS.CHARACTERS.GENERIC.DESCRIBE.FHL_CAKE = "It seems delicious.."
    STRINGS.RECIPE_DESC.FHL_CAKE = "Simple dim sum"

    STRINGS.NAMES.FHL_X = "Black Night Blessing Type-X"
    STRINGS.CHARACTERS.GENERIC.DESCRIBE.FHL_X = "This is... a potion?"
    STRINGS.RECIPE_DESC.FHL_X = "I wish you a long life!"

    STRINGS.NAMES.FHL_X2 = "Black Night Blessing Type-X"
    STRINGS.CHARACTERS.GENERIC.DESCRIBE.FHL_X2 = "This is... a potion?"
    STRINGS.RECIPE_DESC.FHL_X2 = "I wish you a long life!"

    STRINGS.NAMES.FHL_CY = "Relax tea"
    STRINGS.CHARACTERS.GENERIC.DESCRIBE.FHL_CY = "looks great."
    STRINGS.RECIPE_DESC.FHL_CY = "Drinks to restore life and brainpower"

    STRINGS.NAMES.PERSONAL_LICKING = "Syelza's Apple"
    STRINGS.CHARACTERS.GENERIC.DESCRIBE.PERSONAL_LICKING = "This is...Calabash Baby?"
    STRINGS.NAMES.PERSONAL_LICKING_EYEBONE = "Syelza's Bell"
    STRINGS.CHARACTERS.GENERIC.DESCRIBE.PERSONAL_LICKING_EYEBONE = "The sound of the bell is nice."

    --GLOBAL.STRINGS.CHARACTERS.GENERIC.DESCRIBE.KRAMPUS_SACK = "it looks great."
    --GLOBAL.STRINGS.RECIPE_DESC.KRAMPUS_SACK = "集冰箱护甲暖石一身的\n高级背包"

    STRINGS.NAMES.FHL_BB = "Syelza's Backpack"
    STRINGS.CHARACTERS.GENERIC.DESCRIBE.FHL_BB = "it looks great."
    STRINGS.RECIPE_DESC.FHL_BB = "fridge/raincoat/armor"
end




-- 人物语言反馈
STRINGS.CHARACTERS.GENERIC.DESCRIBE.fhl =
{
    GENERIC = "这是风幻妹子啊!",
    ATTACKER = "风幻妹妹攻击很强啊...",
    MURDERER = "谋杀啊!",
    REVIVER = "风幻将一生一世守护塞尔菲亚大陆.",
    GHOST = "风幻虽死不悔.",
}

-- 人物的名字出现在游戏中
STRINGS.NAMES.fhl = "风幻龙"

-- 人物说话
STRINGS.CHARACTERS.ESCTEMPLATE = require "speech_fhl"

Assets = {
    --存档界面人物头像
    Asset("IMAGE", "images/saveslot_portraits/fhl.tex"),
    Asset("ATLAS", "images/saveslot_portraits/fhl.xml"),

    --选择人物界面的人物头像
    Asset("IMAGE", "images/selectscreen_portraits/fhl.tex"),
    Asset("ATLAS", "images/selectscreen_portraits/fhl.xml"),
    --人物大图
    Asset("IMAGE", "bigportraits/fhl.tex"),
    Asset("ATLAS", "bigportraits/fhl.xml"),
    --地图上的人物图标
    Asset("IMAGE", "images/map_icons/fhl.tex"),
    Asset("ATLAS", "images/map_icons/fhl.xml"),
    --人物头像
    Asset("IMAGE", "images/avatars/avatar_fhl.tex"),
    Asset("ATLAS", "images/avatars/avatar_fhl.xml"),
    --人物死后图像
    Asset("IMAGE", "images/avatars/avatar_ghost_fhl.tex"),
    Asset("ATLAS", "images/avatars/avatar_ghost_fhl.xml"),
    --剑小图标
    Asset("ATLAS", "images/inventoryimages/fhl_zzj.xml"),
    Asset("IMAGE", "images/inventoryimages/fhl_zzj.tex"),

    Asset("ATLAS", "images/inventoryimages/fhl_zzj1.xml"),
    Asset("IMAGE", "images/inventoryimages/fhl_zzj1.tex"),

    Asset("ATLAS", "images/inventoryimages/fhl_zzj2.xml"),
    Asset("IMAGE", "images/inventoryimages/fhl_zzj2.tex"),

    Asset("ATLAS", "images/inventoryimages/fhl_zzj3.xml"),
    Asset("IMAGE", "images/inventoryimages/fhl_zzj3.tex"),

    Asset("ATLAS", "images/inventoryimages/fhl_zzj4.xml"),
    Asset("IMAGE", "images/inventoryimages/fhl_zzj4.tex"),

    Asset("ATLAS", "images/inventoryimages/fhl_zzj5.xml"),
    Asset("IMAGE", "images/inventoryimages/fhl_zzj5.tex"),

    Asset("ATLAS", "images/inventoryimages/fhltab.xml"),
    Asset("IMAGE", "images/inventoryimages/fhltab.tex"),

    Asset("ATLAS", "images/inventoryimages/fhl_hsf.xml"),

    Asset("ANIM", "anim/sweet_n_sour.zip"),
    Asset("IMAGE", "images/inventoryimages/fhl_bz.tex"),
    Asset("ATLAS", "images/inventoryimages/fhl_bz.xml"),

    Asset("ANIM", "anim/cake.zip"),
    Asset("IMAGE", "images/inventoryimages/fhl_cake.tex"),
    Asset("ATLAS", "images/inventoryimages/fhl_cake.xml"),

    Asset("ANIM", "anim/dy_x.zip"),
    Asset("IMAGE", "images/inventoryimages/fhl_x.tex"),
    Asset("ATLAS", "images/inventoryimages/fhl_x.xml"),

    Asset("ANIM", "anim/dy_x.zip"),
    Asset("IMAGE", "images/inventoryimages/fhl_x2.tex"),
    Asset("ATLAS", "images/inventoryimages/fhl_x2.xml"),

    Asset("ANIM", "anim/fhl_cy.zip"),
    Asset("IMAGE", "images/inventoryimages/fhl_cy.tex"),
    Asset("ATLAS", "images/inventoryimages/fhl_cy.xml"),

    Asset("ANIM", "anim/ancient_soul.zip"),
    Asset("ATLAS", "images/inventoryimages/ancient_soul.xml"),
    Asset("IMAGE", "images/inventoryimages/ancient_soul.tex"),

    Asset("ANIM", "anim/ancient_gem.zip"),
    Asset("ATLAS", "images/inventoryimages/ancient_gem.xml"),
    Asset("IMAGE", "images/inventoryimages/ancient_gem.tex"),

    Asset("ANIM", "anim/fhl_tree.zip"),
    Asset("ATLAS", "images/inventoryimages/fhl_tree.xml"),
    Asset("IMAGE", "images/inventoryimages/fhl_tree.tex"),

    Asset("ATLAS", "images/inventoryimages/fhl_bb.xml"),
    Asset("IMAGE", "images/inventoryimages/fhl_bb.tex"),

    Asset("ATLAS", "images/inventoryimages/fhltab.xml"),
    Asset("IMAGE", "images/inventoryimages/fhltab.tex"),
}

--function Addtradableprefab(inst)
--if not inst.components.tradable then
--inst:AddComponent("tradable")
--end end

------------------box


local oldwidgetsetup = containers.widgetsetup
containers.widgetsetup = function(container, prefab)
    if not prefab and container.inst.prefab == "fhl_bb" then
        prefab = "krampus_sack"
    end
    oldwidgetsetup(container, prefab)
end

---------------
--small icebox1
local params = {}
local OVERRIDE_WIDGETSETUP = false
local containers_widgetsetup_base = containers.widgetsetup
function containers.widgetsetup(container, prefab)
    local t = params[prefab or container.inst.prefab]
    if t ~= nil then
        for k, v in pairs(t) do
            container[k] = v
        end
        container:SetNumSlots(container.widget.slotpos ~= nil and #container.widget.slotpos or 0)
        if OVERRIDE_WIDGETSETUP then
            container.type = "frostsmall"
        end
    else
        containers_widgetsetup_base(container, prefab)
    end
end

local function frostsmall()
    local container =
    {
        widget =
        {
            slotpos = {},
            animbank = "ui_backpack_2x4",
            animbuild = "ui_chest_frosthammer",
            pos = GLOBAL.Vector3(-5, 100, 0),
            side_align_tip = 160,
        },
        issidewidget = true,
        type = "chest",
    }

    for y = 0, 1 do
        table.insert(container.widget.slotpos, GLOBAL.Vector3(-126, -y * 75 + 114, -126 + 75, -y * 75 + 114))
    end
    return container
end
params.frostsmall = frostsmall()
for k, v in pairs(params) do
    containers.MAXITEMSLOTS = math.max(containers.MAXITEMSLOTS, v.widget.slotpos ~= nil and #v.widget.slotpos or 0)
end
local containers_widgetsetup_custom = containers.widgetsetup
local MAXITEMSLOTS = containers.MAXITEMSLOTS
AddPrefabPostInit("world_network", function(inst)
    if containers.widgetsetup ~= containers_widgetsetup_custom then
        OVERRIDE_WIDGETSETUP = true
        local containers_widgetsetup_base2 = containers.widgetsetup
        function containers.widgetsetup(container, prefab)
            containers_widgetsetup_base2(container, prefab)
            if container.type == "frostsmall" then
                container.type = "chest"
            end
        end
    end
    if containers.MAXITEMSLOTS < MAXITEMSLOTS then
        containers.MAXITEMSLOTS = MAXITEMSLOTS
    end
end)

function params.frostsmall.itemtestfn(container, item, slot)
    return not item:HasTag("heatrock")
end

--------------------------------------------------
--icebox1
local params = {}
local OVERRIDE_WIDGETSETUP = false
local containers_widgetsetup_base = containers.widgetsetup
function containers.widgetsetup(container, prefab)
    local t = params[prefab or container.inst.prefab]
    if t ~= nil then
        for k, v in pairs(t) do
            container[k] = v
        end
        container:SetNumSlots(container.widget.slotpos ~= nil and #container.widget.slotpos or 0)
        if OVERRIDE_WIDGETSETUP then
            container.type = "frostbox"
        end
    else
        containers_widgetsetup_base(container, prefab)
    end
end

local function frostbox()
    local container =
    {
        widget =
        {
            slotpos = {},
            animbank = "ui_backpack_2x4",
            animbuild = "ui_chest_frosthammer2",
            pos = GLOBAL.Vector3(-5, -70, 0),
            side_align_tip = 160,
        },
        issidewidget = true,
        type = "pack",
    }
    for y = 0, 4 do
        table.insert(container.widget.slotpos, GLOBAL.Vector3(-162, -y * 58 + 124, 0))
        table.insert(container.widget.slotpos, GLOBAL.Vector3(-162 + 75, -y * 58 + 124, 0))
    end
    return container
end
params.frostbox = frostbox()
for k, v in pairs(params) do
    containers.MAXITEMSLOTS = math.max(containers.MAXITEMSLOTS, v.widget.slotpos ~= nil and #v.widget.slotpos or 0)
end
local containers_widgetsetup_custom = containers.widgetsetup
local MAXITEMSLOTS = containers.MAXITEMSLOTS
AddPrefabPostInit("world_network", function(inst)
    if containers.widgetsetup ~= containers_widgetsetup_custom then
        OVERRIDE_WIDGETSETUP = true
        local containers_widgetsetup_base2 = containers.widgetsetup
        function containers.widgetsetup(container, prefab)
            containers_widgetsetup_base2(container, prefab)
            if container.type == "frostbox" then
                container.type = "pack"
            end
        end
    end
    if containers.MAXITEMSLOTS < MAXITEMSLOTS then
        containers.MAXITEMSLOTS = MAXITEMSLOTS
    end
end)

function params.frostbox.itemtestfn(container, item, slot)
    return not item:HasTag("heatrock")
end

--------------------------------------------------

--box1
local params = {}
local OVERRIDE_WIDGETSETUP = false
local containers_widgetsetup_base = containers.widgetsetup
function containers.widgetsetup(container, prefab)
    local t = params[prefab or container.inst.prefab]
    if t ~= nil then
        for k, v in pairs(t) do
            container[k] = v
        end
        container:SetNumSlots(container.widget.slotpos ~= nil and #container.widget.slotpos or 0)
        if OVERRIDE_WIDGETSETUP then
            container.type = "chest_yamche0"
        end
    else
        containers_widgetsetup_base(container, prefab)
    end
end

local function chest_yamche0()
    local container =
    {
        widget =
        {
            slotpos = {},
            animbank = "ui_chest_3x2",
            animbuild = "ui_chest_yamche0",
            pos = GLOBAL.Vector3(0, 200, 0),
            side_align_tip = 160,
        },
        type = "chest",
    }
    for y = 1, 0, -1 do
        table.insert(container.widget.slotpos, GLOBAL.Vector3(74 * y - 74 * 2 + 70, 0))
    end
    return container
end
params.chest_yamche0 = chest_yamche0()
for k, v in pairs(params) do
    containers.MAXITEMSLOTS = math.max(containers.MAXITEMSLOTS, v.widget.slotpos ~= nil and #v.widget.slotpos or 0)
end
local containers_widgetsetup_custom = containers.widgetsetup
local MAXITEMSLOTS = containers.MAXITEMSLOTS
AddPrefabPostInit("world_network", function(inst)
    if containers.widgetsetup ~= containers_widgetsetup_custom then
        OVERRIDE_WIDGETSETUP = true
        local containers_widgetsetup_base2 = containers.widgetsetup
        function containers.widgetsetup(container, prefab)
            containers_widgetsetup_base2(container, prefab)
            if container.type == "chest_yamche0" then
                container.type = "chest"
            end
        end
    end
    if containers.MAXITEMSLOTS < MAXITEMSLOTS then
        containers.MAXITEMSLOTS = MAXITEMSLOTS
    end
end)
---------------------------------------------------------------
--box2
local params = {}
local OVERRIDE_WIDGETSETUP = false
local containers_widgetsetup_base = containers.widgetsetup
function containers.widgetsetup(container, prefab)
    local t = params[prefab or container.inst.prefab]
    if t ~= nil then
        for k, v in pairs(t) do
            container[k] = v
        end
        container:SetNumSlots(container.widget.slotpos ~= nil and #container.widget.slotpos or 0)
        if OVERRIDE_WIDGETSETUP then
            container.type = "chest_yamche1"
        end
    else
        containers_widgetsetup_base(container, prefab)
    end
end

local function chest_yamche1()
    local container =
    {
        widget =
        {
            slotpos = {},
            animbank = "ui_chest_3x3",
            animbuild = "ui_chest_yamche1",
            pos = GLOBAL.Vector3(0, 200, 0),
            side_align_tip = 160,
        },
        type = "chest",
    }
    for y = 1, 0, -1 do
        for x = 0, 1 do
            table.insert(container.widget.slotpos, GLOBAL.Vector3(80 * x - 80 * 2 + 78, 80 * y - 80 * 2 + 80, 0))
        end
    end
    return container
end
params.chest_yamche1 = chest_yamche1()
for k, v in pairs(params) do
    containers.MAXITEMSLOTS = math.max(containers.MAXITEMSLOTS, v.widget.slotpos ~= nil and #v.widget.slotpos or 0)
end
local containers_widgetsetup_custom = containers.widgetsetup
local MAXITEMSLOTS = containers.MAXITEMSLOTS
AddPrefabPostInit("world_network", function(inst)
    if containers.widgetsetup ~= containers_widgetsetup_custom then
        OVERRIDE_WIDGETSETUP = true
        local containers_widgetsetup_base2 = containers.widgetsetup
        function containers.widgetsetup(container, prefab)
            containers_widgetsetup_base2(container, prefab)
            if container.type == "chest_yamche1" then
                container.type = "chest"
            end
        end
    end
    if containers.MAXITEMSLOTS < MAXITEMSLOTS then
        containers.MAXITEMSLOTS = MAXITEMSLOTS
    end
end)
---------------------------------------------------------------
--box3
local params = {}
local OVERRIDE_WIDGETSETUP = false
local containers_widgetsetup_base = containers.widgetsetup
function containers.widgetsetup(container, prefab)
    local t = params[prefab or container.inst.prefab]
    if t ~= nil then
        for k, v in pairs(t) do
            container[k] = v
        end
        container:SetNumSlots(container.widget.slotpos ~= nil and #container.widget.slotpos or 0)
        if OVERRIDE_WIDGETSETUP then
            container.type = "chest_yamche2"
        end
    else
        containers_widgetsetup_base(container, prefab)
    end
end

local function chest_yamche2()
    local container =
    {
        widget =
        {
            slotpos = {},
            animbank = "ui_chest_3x3",
            animbuild = "ui_chest_yamche2",
            pos = GLOBAL.Vector3(0, 200, 0),
            side_align_tip = 160,
        },
        type = "chest",
    }

    for y = 2, 0, -1 do
        for x = 0, 1 do
            table.insert(container.widget.slotpos, GLOBAL.Vector3(80 * x - 80 * 2 + 78, 80 * y - 80 * 2 + 80, 0))
        end
    end
    return container
end
params.chest_yamche2 = chest_yamche2()
for k, v in pairs(params) do
    containers.MAXITEMSLOTS = math.max(containers.MAXITEMSLOTS, v.widget.slotpos ~= nil and #v.widget.slotpos or 0)
end
local containers_widgetsetup_custom = containers.widgetsetup
local MAXITEMSLOTS = containers.MAXITEMSLOTS
AddPrefabPostInit("world_network", function(inst)
    if containers.widgetsetup ~= containers_widgetsetup_custom then
        OVERRIDE_WIDGETSETUP = true
        local containers_widgetsetup_base2 = containers.widgetsetup
        function containers.widgetsetup(container, prefab)
            containers_widgetsetup_base2(container, prefab)
            if container.type == "chest_yamche2" then
                container.type = "chest"
            end
        end
    end
    if containers.MAXITEMSLOTS < MAXITEMSLOTS then
        containers.MAXITEMSLOTS = MAXITEMSLOTS
    end
end)
---------------------------------------------------------------
--box5
local params = {}
local OVERRIDE_WIDGETSETUP = false
local containers_widgetsetup_base = containers.widgetsetup
function containers.widgetsetup(container, prefab)
    local t = params[prefab or container.inst.prefab]
    if t ~= nil then
        for k, v in pairs(t) do
            container[k] = v
        end
        container:SetNumSlots(container.widget.slotpos ~= nil and #container.widget.slotpos or 0)
        if OVERRIDE_WIDGETSETUP then
            container.type = "chest_yamche4"
        end
    else
        containers_widgetsetup_base(container, prefab)
    end
end

local function chest_yamche4()
    local container =
    {
        widget =
        {
            slotpos = {},
            animbank = "ui_chest_3x3",
            animbuild = "ui_chest_3x3",
            pos = GLOBAL.Vector3(0, 200, 0),
            side_align_tip = 160,
        },
        type = "chest",
    }
    for y = 3, 0, -1 do
        for x = 0, 2 do
            table.insert(container.widget.slotpos, GLOBAL.Vector3(75 * x - 75 * 2 + 75, 60 * y - 60 * 2 + 32, 0))
        end
    end
    return container
end
params.chest_yamche4 = chest_yamche4()
for k, v in pairs(params) do
    containers.MAXITEMSLOTS = math.max(containers.MAXITEMSLOTS, v.widget.slotpos ~= nil and #v.widget.slotpos or 0)
end
local containers_widgetsetup_custom = containers.widgetsetup
local MAXITEMSLOTS = containers.MAXITEMSLOTS
AddPrefabPostInit("world_network", function(inst)
    if containers.widgetsetup ~= containers_widgetsetup_custom then
        OVERRIDE_WIDGETSETUP = true
        local containers_widgetsetup_base2 = containers.widgetsetup
        function containers.widgetsetup(container, prefab)
            containers_widgetsetup_base2(container, prefab)
            if container.type == "chest_yamche4" then
                container.type = "chest"
            end
        end
    end
    if containers.MAXITEMSLOTS < MAXITEMSLOTS then
        containers.MAXITEMSLOTS = MAXITEMSLOTS
    end
end)
---------------------------------------------------------------
--box6
local params = {}
local OVERRIDE_WIDGETSETUP = false
local containers_widgetsetup_base = containers.widgetsetup
function containers.widgetsetup(container, prefab)
    local t = params[prefab or container.inst.prefab]
    if t ~= nil then
        for k, v in pairs(t) do
            container[k] = v
        end
        container:SetNumSlots(container.widget.slotpos ~= nil and #container.widget.slotpos or 0)
        if OVERRIDE_WIDGETSETUP then
            container.type = "chest_yamche5"
        end
    else
        containers_widgetsetup_base(container, prefab)
    end
end

local function chest_yamche5()
    local container =
    {
        widget =
        {
            slotpos = {},
            animbank = "ui_chest_3x3",
            animbuild = "ui_chest_3x3",
            pos = GLOBAL.Vector3(0, 200, 0),
            side_align_tip = 160,
        },
        type = "chest",
    }
    for y = 3, 0, -1 do
        for x = 0, 3 do
            table.insert(container.widget.slotpos, GLOBAL.Vector3(60 * x - 60 * 2 + 30, 60 * y - 60 * 2 + 30, 0))
        end
    end
    return container
end
params.chest_yamche5 = chest_yamche5()
for k, v in pairs(params) do
    containers.MAXITEMSLOTS = math.max(containers.MAXITEMSLOTS, v.widget.slotpos ~= nil and #v.widget.slotpos or 0)
end
local containers_widgetsetup_custom = containers.widgetsetup
local MAXITEMSLOTS = containers.MAXITEMSLOTS
AddPrefabPostInit("world_network", function(inst)
    if containers.widgetsetup ~= containers_widgetsetup_custom then
        OVERRIDE_WIDGETSETUP = true
        local containers_widgetsetup_base2 = containers.widgetsetup
        function containers.widgetsetup(container, prefab)
            containers_widgetsetup_base2(container, prefab)
            if container.type == "chest_yamche5" then
                container.type = "chest"
            end
        end
    end
    if containers.MAXITEMSLOTS < MAXITEMSLOTS then
        containers.MAXITEMSLOTS = MAXITEMSLOTS
    end
end)

---------------------------------------------------------------
---------------------------------------------------------------
--box7
local params = {}
local OVERRIDE_WIDGETSETUP = false
local containers_widgetsetup_base = containers.widgetsetup
function containers.widgetsetup(container, prefab)
    local t = params[prefab or container.inst.prefab]
    if t ~= nil then
        for k, v in pairs(t) do
            container[k] = v
        end
        container:SetNumSlots(container.widget.slotpos ~= nil and #container.widget.slotpos or 0)
        if OVERRIDE_WIDGETSETUP then
            container.type = "chest_yamche6"
        end
    else
        containers_widgetsetup_base(container, prefab)
    end
end

local function chest_yamche6()
    local container =
    {
        widget =
        {
            slotpos = {},
            animbank = "ui_chest_3x3",
            animbuild = "", --"ui_chest_moon",
            pos = GLOBAL.Vector3(0, 200, 0),
            side_align_tip = 160,
        },
        type = "chest",
    }
    for y = 5, 0, -1 do
        for x = 0, 14 do
            table.insert(container.widget.slotpos, GLOBAL.Vector3(60 * x - 60 * 2 + -150, 60 * y - 60 * 2 + 10, 0))
        end
    end
    return container
end
params.chest_yamche6 = chest_yamche6()
for k, v in pairs(params) do
    containers.MAXITEMSLOTS = math.max(containers.MAXITEMSLOTS, v.widget.slotpos ~= nil and #v.widget.slotpos or 0)
end
local containers_widgetsetup_custom = containers.widgetsetup
local MAXITEMSLOTS = containers.MAXITEMSLOTS
AddPrefabPostInit("world_network", function(inst)
    if containers.widgetsetup ~= containers_widgetsetup_custom then
        OVERRIDE_WIDGETSETUP = true
        local containers_widgetsetup_base2 = containers.widgetsetup
        function containers.widgetsetup(container, prefab)
            containers_widgetsetup_base2(container, prefab)
            if container.type == "chest_yamche6" then
                container.type = "chest"
            end
        end
    end
    if containers.MAXITEMSLOTS < MAXITEMSLOTS then
        containers.MAXITEMSLOTS = MAXITEMSLOTS
    end
end)


--AddPrefabPostInit("ancient_soul", Addtradableprefab)
--AddPrefabPostInit("maxwellintro", InoriMaxwellIntro)
----------------------------------------------------------------------------------------------------

local function Givelickingbone(inst)
    local lickingbone = GLOBAL.SpawnPrefab("personal_licking_eyebone")
    if lickingbone then
        lickingbone.owner = inst
        inst.lickingbone = lickingbone
        inst.components.inventory.ignoresound = true
        inst.components.inventory:GiveItem(lickingbone)
        inst.components.inventory.ignoresound = false
        lickingbone.components.named:SetName(inst.name .. "的铃铛")
        return lickingbone
    end
end
local function GetSpawnPoint(pt)
    local theta = math.random() * 2 * GLOBAL.PI
    local radius = 4
    local offset = GLOBAL.FindWalkableOffset(pt, theta, radius, 12, true)
    return offset ~= nil and (pt + offset) or nil
end
local function Personallicking(inst)
    if not inst:HasTag("speciallickingowner") then
        return
    end

    local OnDespawn_prev = inst.OnDespawn
    local OnDespawn_new = function(inst)
        -- Remove licking
        if inst.licking then
            -- Don't allow licking to despawn with irreplaceable items
            inst.licking.components.container:DropEverythingWithTag("irreplaceable")

            -- We need time to save before despawning.
            inst.licking:DoTaskInTime(0.1, function(inst)
                if inst and inst:IsValid() then
                    inst:Remove()
                end
            end)
        end

        if inst.lickingbone then
            -- lickingbone drops from whatever its in
            local owner = inst.lickingbone.components.inventoryitem.owner
            if owner then
                -- Remember if lickingbone is held
                if owner == inst then
                    inst.lickingbone.isheld = true
                else
                    inst.lickingbone.isheld = false
                end
                if owner.components.container then
                    owner.components.container:DropItem(inst.lickingbone)
                elseif owner.components.inventory then
                    owner.components.inventory:DropItem(inst.lickingbone)
                end
            end
            -- Remove lickingbone
            inst.lickingbone:DoTaskInTime(0.1, function(inst)
                if inst and inst:IsValid() then
                    inst:Remove()
                end
            end)
        else
            print("Error: Player has no linked lickingbone!")
        end
        if OnDespawn_prev then
            return OnDespawn_prev(inst)
        end
    end
    inst.OnDespawn = OnDespawn_new

    local OnSave_prev = inst.OnSave
    local OnSave_new = function(inst, data)
        local references = OnSave_prev and OnSave_prev(inst, data)
        if inst.licking then
            -- Save licking
            local refs = {}
            if not references then
                references = {}
            end
            data.licking, refs = inst.licking:GetSaveRecord()
            if refs then
                for k, v in pairs(refs) do
                    table.insert(references, v)
                end
            end
        end
        if inst.lickingbone then
            -- Save lickingbone
            local refs = {}
            if not references then
                references = {}
            end
            data.lickingbone, refs = inst.lickingbone:GetSaveRecord()
            if refs then
                for k, v in pairs(refs) do
                    table.insert(references, v)
                end
            end
            -- Remember if was holding lickingbone
            if inst.lickingbone.isheld then
                data.holdinglickingbone = true
            else
                data.holdinglickingbone = false
            end
        end
        return references
    end
    inst.OnSave = OnSave_new

    local OnLoad_prev = inst.OnLoad
    local OnLoad_new = function(inst, data, newents)
        if data.licking ~= nil then
            -- Load licking
            inst.licking = GLOBAL.SpawnSaveRecord(data.licking, newents)
        else
            --print("Warning: No licking was loaded from save file!")
        end

        if data.lickingbone ~= nil then
            -- Load licking
            inst.lickingbone = GLOBAL.SpawnSaveRecord(data.lickingbone, newents)

            -- Look for lickingbone at spawn point and re-equip
            inst:DoTaskInTime(0, function(inst)
                if data.holdinglickingbone or (inst.lickingbone and inst:IsNear(inst.lickingbone, 4)) then
                    --inst.components.inventory:GiveItem(inst.lickingbone)
                    inst:Returnlickingbone()
                end
            end)
        else
            print("Warning: No lickingbone was loaded from save file!")
        end

        -- Create new lickingbone if none loaded
        if not inst.lickingbone then
            Givelickingbone(inst)
        end

        inst.lickingbone.owner = inst


        if OnLoad_prev then
            return OnLoad_prev(inst, data, newents)
        end
    end
    inst.OnLoad = OnLoad_new

    local OnNewSpawn_prev = inst.OnNewSpawn
    local OnNewSpawn_new = function(inst)
        -- Give new lickingbone. Let licking spawn naturally.
        Givelickingbone(inst)
        if OnNewSpawn_prev then
            return OnNewSpawn_prev(inst)
        end
    end
    inst.OnNewSpawn = OnNewSpawn_new

    if GLOBAL.TheNet:GetServerGameMode() == "wilderness" then
        local function ondeath(inst, data)
            -- Kill player's licking in wilderness mode :(
            if inst.licking then
                inst.licking.components.health:Kill()
            end
            if inst.lickingbone then
                inst.lickingbone:Remove()
            end
        end
        inst:ListenForEvent("death", ondeath)
    end

    -- Debug function to return lickingbone
    inst.Returnlickingbone = function()
        if inst.lickingbone and inst.lickingbone:IsValid() then
            if inst.lickingbone.components.inventoryitem.owner ~= inst then
                inst.components.inventory:GiveItem(inst.lickingbone)
            end
        else
            Givelickingbone(inst)
        end
        if inst.licking and not inst:IsNear(inst.licking, 20) then
            local pt = inst:GetPosition()
            local spawn_pt = GetSpawnPoint(pt)
            if spawn_pt ~= nil then
                inst.licking.Physics:Teleport(spawn_pt:Get())
                inst.licking:FacePoint(pt:Get())
            end
        end
    end
end

GLOBAL.c_returnlickingbone = function(inst)
    if not inst then
        inst = GLOBAL.ThePlayer or GLOBAL.AllPlayers[1]
    end
    if not inst or not inst.Returnlickingbone then
        print("Error: Cannot return lickingbone")
        return
    end
    inst:Returnlickingbone()
end

AddPlayerPostInit(Personallicking)

--No One Enters Chester cept the one with the licking bone!

local function HaslickingBone(doer)
    if doer.components.inventory and doer.components.inventory:FindItem(function(item)
            if item.prefab == "personal_licking_eyebone" then return true end
        end) ~= nil then
        return true
    else
        return false
    end
end

local oldACTIONSTORE = GLOBAL.ACTIONS.STORE.fn
GLOBAL.ACTIONS.STORE.fn = function(act)
    if act.target and act.target.prefab == "personal_licking" and act.target.components.container ~= nil and act.invobject.components.inventoryitem ~= nil and act.doer.components.inventory ~= nil then
        print(act.doer.name, "is trying to do something with a licking")
        if HaslickingBone(act.doer) then
            print(act.doer.name, "has licking Bone, proceed")
            return oldACTIONSTORE(act)
        else
            print(act.doer.name, "doesn't has the licking Bone, exit")
            if act.doer.components.talker then act.doer.components.talker:Say("No Can Do!") end
            return true
        end
    else
        return oldACTIONSTORE(act)
    end
end

local old_RUMMAGE = GLOBAL.ACTIONS.RUMMAGE.fn
GLOBAL.ACTIONS.RUMMAGE.fn = function(act)
    if act.target and act.target.prefab == "personal_licking" then
        print("GLOBAL.ACTIONS.RUMMAGE--" .. tostring(act.doer.components.inventory))
        result = act.doer.components.inventory:FindItem(function(item)
            if item.prefab == "personal_licking_eyebone" then
                print("GLOBAL.ACTIONS.RUMMAGE--" .. tostring(item) .. "--ok--")
                return true
            end
        end)
        if result then
            return old_RUMMAGE(act)
        else
            print("GLOBAL.ACTIONS.RUMMAGE--" .. tostring(item) .. "--fail--")
            act.doer:DoTaskInTime(1, function()
                act.doer.components.talker:Say("No Can Do!")
            end)
            return false
        end
    else
        return old_RUMMAGE(act)
    end
end

AddMinimapAtlas("images/inventoryimages/personal_licking.xml")


local function UseFullMoonRecipe()
    AddRecipePostInit("fhl_x_1", function(recipe)
        recipe.product = "fhl_x2"
    end)
    AddRecipePostInit("fhl_x_2", function(recipe)
        recipe.product = "fhl_x2"
    end)
end

local function RestoreOriginalRecipe()
    AddRecipePostInit("fhl_x_1", function(recipe)
        recipe.product = "fhl_x"
    end)
    AddRecipePostInit("fhl_x_2", function(recipe)
        recipe.product = "fhl_x"
    end)
end
local function CheckFullMoon()
    if GLOBAL.TheWorld.state.isfullmoon then
        UseFullMoonRecipe()
    end
end

AddPrefabPostInit("world", function(inst)
    inst:ListenForEvent("ms_playerjoined", CheckFullMoon)
    inst:WatchWorldState("isfullmoon", function(inst, isfullmoon)
        if isfullmoon then
            UseFullMoonRecipe()
        else
            RestoreOriginalRecipe()
        end
    end)
end)


TUNING.LEVELUP_FAILURE_FACTOR = GetModConfigData("fhl_levelup_failure_factor")

TUNING.GJBL = GetModConfigData("zzj_gjbl")
TUNING.JGEAT = GetModConfigData("fhl_jgeat")
TUNING.JGEATSL = GetModConfigData("fhl_jgeatsl")

--TUNING.LIKEORNOT = GetModConfigData("likeornot")
--TUNING.ZZJ_DAMAGE = GetModConfigData("zzj_damage")
TUNING.ZZJ_TIMES = .4 --GetModConfigData("zzj_times")

TUNING.FHL_COS = GetModConfigData("fhl_cos")
TUNING.ZZJ_CAN_USE_AS_HAMMER = GetModConfigData("zzj_canuseashammer")
TUNING.ZZJ_CAN_USE_AS_SHOVEL = GetModConfigData("zzj_canuseasshovel")
TUNING.ZZJ_FINITE_USES = GetModConfigData("zzj_finiteuses")
TUNING.ZZJ_CANKANSHU = GetModConfigData("zzj_cankanshu")
TUNING.ZZJ_CANWAKUANG = GetModConfigData("zzj_canwakuang")
TUNING.ZZJ_PRE = GetModConfigData("zzj_pre")
--TUNING.ZZJ_RANGE = GetModConfigData("zzj_range")
TUNING.OPENLIGHT = GetModConfigData("openlight")
TUNING.OPENLI = GetModConfigData("openli")
TUNING.BUFFGO = GetModConfigData("buffgo")
TUNING.FHL_HJOPEN = GetModConfigData("fhl_hjopen")
TUNING.ZZJ_FIREOPEN = GetModConfigData("zzj_fireopen")

-- 注册图片
RegisterInventoryItemAtlas("images/inventoryimages/ancient_soul.xml", "ancient_soul.tex")
RegisterInventoryItemAtlas("images/inventoryimages/fhl_zzj.xml", "fhl_zzj.tex")
RegisterInventoryItemAtlas("images/inventoryimages/fhl_zzj1.xml", "fhl_zzj1.tex")
RegisterInventoryItemAtlas("images/inventoryimages/fhl_zzj2.xml", "fhl_zzj2.tex")
RegisterInventoryItemAtlas("images/inventoryimages/fhl_zzj3.xml", "fhl_zzj3.tex")
RegisterInventoryItemAtlas("images/inventoryimages/fhl_zzj4.xml", "fhl_zzj4.tex")
RegisterInventoryItemAtlas("images/inventoryimages/fhl_zzj5.xml", "fhl_zzj5.tex")
RegisterInventoryItemAtlas("images/inventoryimages/fhl_hsf.xml", "fhl_hsf.tex")
RegisterInventoryItemAtlas("images/inventoryimages/fhl_bz.xml", "fhl_bz.tex")
RegisterInventoryItemAtlas("images/inventoryimages/fhl_cake.xml", "fhl_cake.tex")
RegisterInventoryItemAtlas("images/inventoryimages/fhl_x.xml", "fhl_x.tex")
RegisterInventoryItemAtlas("images/inventoryimages/fhl_cy.xml", "fhl_cy.tex")
RegisterInventoryItemAtlas("images/inventoryimages/ancient_gem.xml", "ancient_gem.tex")
RegisterInventoryItemAtlas("images/inventoryimages/fhl_tree.xml", "fhl_tree.tex")
RegisterInventoryItemAtlas("images/inventoryimages/fhl_bb.xml", "fhl_bb.tex")
RegisterInventoryItemAtlas("images/inventoryimages/bj_11.xml", "bj_11.tex")

AddCharacterRecipe("fhl_zzj", { Ingredient("ancient_soul", 1), Ingredient("goldnugget", 2) }, TECH.NONE,
    { product = "fhl_zzj", builder_tag = "fhl" })

AddCharacterRecipe("fhl_zzj1", { Ingredient("fhl_zzj", 1), Ingredient("ancient_soul", 2), Ingredient("goldnugget", 4) },
    TECH.NONE, { product = "fhl_zzj1", builder_tag = "fhl" })

AddCharacterRecipe("fhl_zzj2", { Ingredient("fhl_zzj1", 1), Ingredient("ancient_soul", 4), Ingredient("goldnugget", 8) },
    TECH.NONE, { product = "fhl_zzj2", builder_tag = "fhl" })

AddCharacterRecipe("fhl_zzj3", { Ingredient("fhl_zzj2", 1), Ingredient("ancient_soul", 5), Ingredient("goldnugget", 10) },
    TECH.NONE, { product = "fhl_zzj3", builder_tag = "fhl" })

AddCharacterRecipe("fhl_zzj4", { Ingredient("fhl_zzj3", 1), Ingredient("ancient_soul", 8), Ingredient("goldnugget", 16) },
    TECH.NONE, { product = "fhl_zzj4", builder_tag = "fhl" })

AddCharacterRecipe("fhl_zzj5",
    { Ingredient("fhl_zzj4", 1), Ingredient("ancient_soul", 10), Ingredient("goldnugget", 20) },
    TECH.NONE, { product = "fhl_zzj5", builder_tag = "fhl" })

AddCharacterRecipe("fhl_bb", { Ingredient("cutgrass", 5), Ingredient("twigs", 5), Ingredient("ancient_soul", 8) },
    TECH.NONE, { product = "fhl_bb", builder_tag = "fhl" })

AddCharacterRecipe("fhl_hsf",
    { Ingredient("feather_robin", 1), Ingredient("feather_crow", 1), Ingredient("ancient_soul", 3) }, TECH.NONE,
    { product = "fhl_hsf", builder_tag = "fhl" })

AddCharacterRecipe("fhl_bz", { Ingredient("honey", 4), Ingredient("bird_egg", 4), Ingredient("cave_banana", 2) },
    TECH.NONE, { product = "fhl_bz", builder_tag = "fhl" })

AddCharacterRecipe("fhl_cake_1", { Ingredient("bird_egg", 2), Ingredient("pumpkin", 1) }, TECH.NONE,
    { product = "fhl_cake", builder_tag = "fhl" })

AddCharacterRecipe("fhl_cake_2", { Ingredient("bird_egg", 2), Ingredient("carrot", 2) }, TECH.NONE,
    { product = "fhl_cake", builder_tag = "fhl" })

AddCharacterRecipe("fhl_x_1",
    { Ingredient("berries", 2), Ingredient("froglegs_cooked", 2), Ingredient("petals_evil", 1) }, TECH.NONE,
    { product = "fhl_x", builder_tag = "fhl" })

AddCharacterRecipe("fhl_x_2",
    { Ingredient("berries_juicy", 2), Ingredient("froglegs_cooked", 2), Ingredient("petals_evil", 1) }, TECH.NONE,
    { product = "fhl_x", builder_tag = "fhl" })

AddCharacterRecipe("fhl_cy", { Ingredient("cactus_meat_cooked", 1), Ingredient("ice", 1) }, TECH.NONE,
    { product = "fhl_cy", builder_tag = "fhl" })

AddCharacterRecipe("ancient_gem",
    { Ingredient("ancient_soul", 10), Ingredient("nightmarefuel", 8), Ingredient("purplegem", 2) },
    TECH.NONE, { product = "ancient_gem", builder_tag = "fhl" })

AddCharacterRecipe("fhl_tree", { Ingredient("twigs", 4), Ingredient("ancient_soul", 1) }, TECH.NONE,
    { product = "fhl_tree", builder_tag = "fhl" })

AddCharacterRecipe("bj_11",
    { Ingredient("twigs", 6), Ingredient("ancient_soul", 6), Ingredient("goldnugget", 6) },
    TECH.NONE, { product = "bj_11", builder_tag = "fhl" })

-- ----BOOK----
-- 降低了科技等级，相当于老奶奶

AddRecipe2("book_sleep", { Ingredient("papyrus", 2), Ingredient("nightmarefuel", 2) }, TECH.NONE,
    { product = "book_sleep", builder_tag = "bookbuilder" })

AddRecipe2("book_brimstone", { Ingredient("papyrus", 2), Ingredient("redgem", 1) }, TECH.NONE,
    { product = "book_brimstone", builder_tag = "bookbuilder" })

AddRecipe2("book_tentacles", { Ingredient("papyrus", 2), Ingredient("tentaclespots", 1) }, TECH.NONE,
    { product = "book_tentacles", builder_tag = "bookbuilder" })

-----------创建地图图标和角色基础属性
AddMinimapAtlas("images/map_icons/fhl.xml")
AddModCharacter("fhl", "FEMALE")

GLOBAL.glassesdrop = 0 --GetModConfigData("DROPGLASSES")
