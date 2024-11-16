local require = GLOBAL.require
local STRINGS = GLOBAL.STRINGS
local ACTIONS = GLOBAL.ACTIONS
local Vector3 = GLOBAL.Vector3
local TheNet = GLOBAL.TheNet
local Recipe = GLOBAL.Recipe
local TECH = GLOBAL.TECH
local next = GLOBAL.next
local deepcopy = GLOBAL.deepcopy
local ThePlayer = GLOBAL.ThePlayer
local AllPlayers = GLOBAL.AllPlayers
local Ingredient = GLOBAL.Ingredient
local RECIPETABS = GLOBAL.RECIPETABS
local TechTree = require("techtree")
local containers = require("containers")
local curse = require("curse_monkey_util")

modimport("fhl_util/fhl_util.lua")

PrefabFiles = {
    "fhl",
    "bj_11",
    "fhl_zzj2",
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
    "fhl_bb",
    "buff_x2",
    "buff_zzj",
}

if GetModConfigData("fhl_language") == 0 then
    STRINGS.NAMES.BJ_11 = "萌妹子的宝具"
    STRINGS.CHARACTERS.GENERIC.DESCRIBE.BJ_11 = "我可以用它来做所有事情。"
    STRINGS.RECIPE_DESC.BJ_11 = "这是生产工具。"

    STRINGS.NAMES.ANCIENT_GEM = "耀古之晶"
    STRINGS.CHARACTERS.GENERIC.DESCRIBE.ANCIENT_GEM = "我感受到了上古的气息。"
    STRINGS.RECIPE_DESC.ANCIENT_GEM = "充斥着澎湃的\n古老的气息"

    STRINGS.NAMES.FHL_TREE = "希雅蕾丝树枝"
    STRINGS.CHARACTERS.GENERIC.DESCRIBE.FHL_TREE = "我感受到了生命的气息。"
    STRINGS.RECIPE_DESC.FHL_TREE = "生命之树的枝条\n恩,有股香蕉的味道."

    STRINGS.NAMES.ANCIENT_SOUL = "符文结晶"
    STRINGS.CHARACTERS.GENERIC.DESCRIBE.ANCIENT_SOUL = "这是符文的结晶。"
    STRINGS.RECIPE_DESC.ANCIENT_SOUL = "这是符文的结晶"

    STRINGS.NAMES.FHL_ZZJ2 = "仿金芜菁之杖"
    STRINGS.RECIPE_DESC.FHL_ZZJ2 = "金芜菁之杖 Lv1\n伤害: 50 冰冻概率:10%"
    STRINGS.CHARACTERS.GENERIC.DESCRIBE.FHL_ZZJ2 = "胸大无脑的智障剑也有仿品"

    STRINGS.NAMES.FHL_ZZJ4 = "金芜菁之杖"
    STRINGS.RECIPE_DESC.FHL_ZZJ4 = "金芜菁之杖 Lv2\n伤害: 80 冰冻概率:20%"
    STRINGS.CHARACTERS.GENERIC.DESCRIBE.FHL_ZZJ4 = "胸大无脑的智障剑"

    STRINGS.NAMES.FHL_ZZJ5 = "诸神黄昏之杖"
    STRINGS.RECIPE_DESC.FHL_ZZJ5 = "金芜菁之杖 Lv3\n伤害: 120 冰冻概率:40%"
    STRINGS.CHARACTERS.GENERIC.DESCRIBE.FHL_ZZJ5 = "真正的神灵也要避其锋芒!"

    STRINGS.NAMES.FHL = "瑟尔泽"
    STRINGS.CHARACTER_TITLES.fhl = "风幻龙-瑟尔泽"
    STRINGS.CHARACTER_NAMES.fhl = "瑟尔泽"
    STRINGS.CHARACTER_DESCRIPTIONS.fhl = "*掌管永恒的风之神, 击杀怪物掉落符文结晶\n*吃火龙果升级!(满级10) 变得更加强大!\n*会做超好吃的甜点! 是图书管理员的朋友!"
    STRINGS.CHARACTER_QUOTES.fhl = "\"谢谢汝……选择了妾身！\""
    STRINGS.CHARACTER_SURVIVABILITY.fhl = "严峻"

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
    STRINGS.CHARACTERS.GENERIC.DESCRIBE.FHL_X2 = "像月亮一样...冰冰凉凉"
    STRINGS.RECIPE_DESC.FHL_X2 = "祝您长命百岁!"

    STRINGS.NAMES.FHL_CY = "放松茶叶"
    STRINGS.CHARACTERS.GENERIC.DESCRIBE.FHL_CY = "看起来不错？"
    STRINGS.RECIPE_DESC.FHL_CY = "回复生命和脑力的饮品"

    STRINGS.NAMES.PERSONAL_LICKING = "风幻的苹果"
    STRINGS.CHARACTERS.GENERIC.DESCRIBE.PERSONAL_LICKING = "这是......葫芦娃?"
    STRINGS.NAMES.PERSONAL_LICKING_EYEBONE = "风幻的铃铛"
    STRINGS.CHARACTERS.GENERIC.DESCRIBE.PERSONAL_LICKING_EYEBONE = "铃铛的声音很好听."

    STRINGS.NAMES.FHL_BB = "瑟尔泽的背包"
    STRINGS.CHARACTERS.GENERIC.DESCRIBE.FHL_BB = "噢，真漂亮，宠物们该会很高兴住进去"
    STRINGS.RECIPE_DESC.FHL_BB = "防火防潮、提供护甲的冰箱背包\n收纳的小生命会得到最好的照料"
else
    STRINGS.NAMES.BJ_11 = "Cute girl's treasure"
    STRINGS.CHARACTERS.GENERIC.DESCRIBE.BJ_11 = "I can use this to do everything."
    STRINGS.RECIPE_DESC.BJ_11 = "this is the Production tools."

    STRINGS.NAMES.ANCIENT_GEM = "Yaogu Crystal"
    STRINGS.CHARACTERS.GENERIC.DESCRIBE.ANCIENT_GEM = "I felt the ancient's smell."
    STRINGS.RECIPE_DESC.ANCIENT_GEM = "The seeds of the ancient tower."

    STRINGS.NAMES.FHL_TREE = "ShiaLace Branch"
    STRINGS.CHARACTERS.GENERIC.DESCRIBE.FHL_TREE = "I felt the banana's smell."
    STRINGS.RECIPE_DESC.FHL_TREE = "The seeds of the banana trees."

    STRINGS.NAMES.ANCIENT_SOUL = "Rune Crystal"
    STRINGS.CHARACTERS.GENERIC.DESCRIBE.ANCIENT_SOUL = "this is the ancient soul."
    STRINGS.RECIPE_DESC.ANCIENT_SOUL = "this is the ancient soul."

    STRINGS.NAMES.FHL_ZZJ2 = "Golden wujing Lv1"
    STRINGS.RECIPE_DESC.FHL_ZZJ2 = "Golden wujing Lv1\nATK: 50 Ice chance:10%"
    STRINGS.CHARACTERS.GENERIC.DESCRIBE.FHL_ZZJ2 = "This is the Golden wujing Lv1"

    STRINGS.NAMES.FHL_ZZJ4 = "Golden wujing Lv2"
    STRINGS.RECIPE_DESC.FHL_ZZJ4 = "Golden wujing Lv2\nATK: 80 Ice chance:20%"
    STRINGS.CHARACTERS.GENERIC.DESCRIBE.FHL_ZZJ4 = "This is the Golden wujing Lv2"

    STRINGS.NAMES.FHL_ZZJ5 = "Golden wujing Lv3"
    STRINGS.RECIPE_DESC.FHL_ZZJ5 = "Golden wujing Lv3\nATK: 120 Ice chance:40%"
    STRINGS.CHARACTERS.GENERIC.DESCRIBE.FHL_ZZJ5 = "This is the Golden wujing Lv3"

    STRINGS.NAMES.FHL = "Syelza"
    STRINGS.CHARACTER_TITLES.fhl = "Syelza"
    STRINGS.CHARACTER_NAMES.fhl = "Syelza"
    STRINGS.CHARACTER_DESCRIPTIONS.fhl =
    "*The Dragonfruit can strengthen her force\n*Using The Golden wujing\n*She is the friend of Wickerbottom"
    STRINGS.CHARACTER_QUOTES.fhl = "\"Syelza.\""
    STRINGS.CHARACTER_SURVIVABILITY.fhl = "Grim"

    STRINGS.NAMES.FHL_HSF = "Syelza's Amulet"
    STRINGS.RECIPE_DESC.FHL_HSF = "Made from Syelza's feathers"
    STRINGS.CHARACTERS.GENERIC.DESCRIBE.FHL_HSF = "This is the guardian's artifact!"

    STRINGS.NAMES.FHL_BZ = "Rainbow Cake"
    STRINGS.CHARACTERS.GENERIC.DESCRIBE.FHL_BZ = "This is the legendary rainbow cake"
    STRINGS.RECIPE_DESC.FHL_BZ = "Delicious rainbow cake"

    STRINGS.NAMES.FHL_CAKE = "Pumpkin Pudding"
    STRINGS.CHARACTERS.GENERIC.DESCRIBE.FHL_CAKE = "It seems delicious."
    STRINGS.RECIPE_DESC.FHL_CAKE = "Simple dim sum"

    STRINGS.NAMES.FHL_X = "Black Night Blessing Type-X"
    STRINGS.CHARACTERS.GENERIC.DESCRIBE.FHL_X = "This is ... a potion?"
    STRINGS.RECIPE_DESC.FHL_X = "I wish you a long life!"

    STRINGS.NAMES.FHL_X2 = "Black Night Blessing Type-X"
    STRINGS.CHARACTERS.GENERIC.DESCRIBE.FHL_X2 = "It's cold ... like the moon."
    STRINGS.RECIPE_DESC.FHL_X2 = "I wish you a long life!"

    STRINGS.NAMES.FHL_CY = "Relax tea"
    STRINGS.CHARACTERS.GENERIC.DESCRIBE.FHL_CY = "looks great."
    STRINGS.RECIPE_DESC.FHL_CY = "Drinks to restore life and brainpower"

    STRINGS.NAMES.PERSONAL_LICKING = "Syelza's Apple"
    STRINGS.CHARACTERS.GENERIC.DESCRIBE.PERSONAL_LICKING = "This is ... Calabash Baby?"
    STRINGS.NAMES.PERSONAL_LICKING_EYEBONE = "Syelza's Bell"
    STRINGS.CHARACTERS.GENERIC.DESCRIBE.PERSONAL_LICKING_EYEBONE = "The sound of the bell is nice."

    STRINGS.NAMES.FHL_BB = "Syelza's Backpack"
    STRINGS.CHARACTERS.GENERIC.DESCRIBE.FHL_BB = "Oh, Nice. Why are my pets still out there?"
    STRINGS.RECIPE_DESC.FHL_BB = "fridge/armor/animal's heaven"
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

-- 人物说话
STRINGS.CHARACTERS.ESCTEMPLATE = require "speech_fhl"

Assets = {
    --存档界面人物头像
    Asset("IMAGE", "images/saveslot_portraits/fhl.tex"),
    Asset("ATLAS", "images/saveslot_portraits/fhl.xml"),
    --选择人物界面的人物头像
    Asset("IMAGE", "images/selectscreen_portraits/fhl.tex"),
    Asset("ATLAS", "images/selectscreen_portraits/fhl.xml"),
    --选择人物界面的角色名字图像
    Asset("IMAGE", "images/names_fhl.tex"),
    Asset("ATLAS", "images/names_fhl.xml"),

    Asset("IMAGE", "images/names_gold_cn_fhl.tex"),
    Asset("ATLAS", "images/names_gold_cn_fhl.xml"),
    --人物大图
    Asset("IMAGE", "bigportraits/fhl.tex"),
    Asset("ATLAS", "bigportraits/fhl.xml"),
    --地图上的人物图标
    Asset("IMAGE", "images/map_icons/fhl.tex"),
    Asset("ATLAS", "images/map_icons/fhl.xml"),
    --地图上的物品图标
    Asset("IMAGE", "images/map_icons/fhl_atlas.tex"),
    Asset("ATLAS", "images/map_icons/fhl_data.xml"),
    --人物头像
    Asset("IMAGE", "images/avatars/avatar_fhl.tex"),
    Asset("ATLAS", "images/avatars/avatar_fhl.xml"),
    --人物死后图像
    Asset("IMAGE", "images/avatars/avatar_ghost_fhl.tex"),
    Asset("ATLAS", "images/avatars/avatar_ghost_fhl.xml"),

    Asset("IMAGE", "images/avatars/self_inspect_fhl.tex"),
    Asset("ATLAS", "images/avatars/self_inspect_fhl.xml"),
    --剑小图标
    Asset("ATLAS", "images/inventoryimages/bj_11.xml"),
    Asset("IMAGE", "images/inventoryimages/bj_11.tex"),
    --剑小图标
    Asset("ATLAS", "images/inventoryimages/fhl_zzj2.xml"),
    Asset("IMAGE", "images/inventoryimages/fhl_zzj2.tex"),

    Asset("ATLAS", "images/inventoryimages/fhl_zzj4.xml"),
    Asset("IMAGE", "images/inventoryimages/fhl_zzj4.tex"),

    Asset("ATLAS", "images/inventoryimages/fhl_zzj5.xml"),
    Asset("IMAGE", "images/inventoryimages/fhl_zzj5.tex"),

    Asset("ATLAS", "images/inventoryimages/fhl_hsf.xml"),
    Asset("IMAGE", "images/inventoryimages/fhl_hsf.tex"),

    Asset("ANIM", "anim/fhl_torte.zip"),
    Asset("IMAGE", "images/inventoryimages/fhl_bz.tex"),
    Asset("ATLAS", "images/inventoryimages/fhl_bz.xml"),

    Asset("ANIM", "anim/fhl_pudding.zip"),
    Asset("IMAGE", "images/inventoryimages/fhl_cake.tex"),
    Asset("ATLAS", "images/inventoryimages/fhl_cake.xml"),

    Asset("ANIM", "anim/fhl_x.zip"),
    Asset("IMAGE", "images/inventoryimages/fhl_x.tex"),
    Asset("ATLAS", "images/inventoryimages/fhl_x.xml"),

    Asset("ANIM", "anim/fhl_x.zip"),
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

    Asset("ATLAS", "images/inventoryimages/licking_eyebone.xml"),
    Asset("IMAGE", "images/inventoryimages/licking_eyebone.tex"),

    Asset("ATLAS", "images/inventoryimages/applestore.xml"),
    Asset("IMAGE", "images/inventoryimages/applestore.tex"),
}

TUNING.FHL = {}
TUNING.FHL_GROWTH = 15
TUNING.FHL_HEALTH = 150
TUNING.FHL_HUNGER = 150
TUNING.FHL_SANITY = 150
TUNING.GAMEMODE_STARTING_ITEMS.DEFAULT.FHL = { "fhl_bz", "fhl_cake", "fhl_cy", "bj_11" }

TUNING.BJ_11_PLANAR_DAMAGE = 15

TUNING.STATUS_KEY = GetModConfigData("status_key")
TUNING.SKILL_POINT_KEY = GetModConfigData("skill_point_key")
TUNING.LEVELUP_FAILURE_FACTOR = GetModConfigData("fhl_levelup_failure_factor")

TUNING.JGEAT = GetModConfigData("fhl_jgeat")           -- 吃浆果升级
TUNING.JGEATSL = GetModConfigData("fhl_jgeatsl")       -- 升级需要浆果数量
TUNING.FHL_COS = GetModConfigData("fhl_cos")           -- 符文结晶爆率

TUNING.GJBL = GetModConfigData("zzj_gjbl")             -- 普攻伤害倍率
TUNING.ZZJ_PRE = GetModConfigData("zzj_pre")           -- 特效伤害倍率
TUNING.ZZJ_FIREOPEN = GetModConfigData("zzj_fireopen") -- 火焰特效
TUNING.ZZJ_CANKANSHU = GetModConfigData("zzj_cankanshu")
TUNING.ZZJ_CANWAKUANG = GetModConfigData("zzj_canwakuang")
TUNING.ZZJ_FINITE_USES = GetModConfigData("zzj_finiteuses")
TUNING.ZZJ_CAN_USE_AS_HAMMER = GetModConfigData("zzj_canuseashammer")
TUNING.ZZJ_CAN_USE_AS_SHOVEL = GetModConfigData("zzj_canuseasshovel")

TUNING.OPENLIGHT = GetModConfigData("openlight")     -- 风幻发光
TUNING.OPENLI = GetModConfigData("openli")           -- 苹果发光
TUNING.APPLESTORE = GetModConfigData("applestore")   -- 苹果新零售

TUNING.BUFFGO = GetModConfigData("buffgo")           -- 护身符减伤
TUNING.HSF_RESPAWN = GetModConfigData("hsf_respawn") -- 护身符重生选项
TUNING.HSF_POS_X = GetModConfigData("hsf_position")  -- 护身符格子位置

TUNING.BB_HJOPEN = GetModConfigData("bb_hjopen")
TUNING.BB_DURABILITY = GetModConfigData("bb_durability")
TUNING.BB_WATERPROOFNESS = GetModConfigData("bb_waterproofness")

TUNING.SKILL_TREE = GetModConfigData("skill_tree")

ACTIONS.ADDFUEL.priority = 1
GLOBAL.FUELTYPE.ANCIENTSOUL = "ANCIENTSOUL"

----------------------------------------------------------------------------------------
-- 注册图片
RegisterInventoryItemAtlas("images/inventoryimages/ancient_gem.xml", "ancient_gem.tex")
RegisterInventoryItemAtlas("images/inventoryimages/ancient_soul.xml", "ancient_soul.tex")
RegisterInventoryItemAtlas("images/inventoryimages/bj_11.xml", "bj_11.tex")
RegisterInventoryItemAtlas("images/inventoryimages/fhl_bb.xml", "fhl_bb.tex")
RegisterInventoryItemAtlas("images/inventoryimages/fhl_bz.xml", "fhl_bz.tex")
RegisterInventoryItemAtlas("images/inventoryimages/fhl_cake.xml", "fhl_cake.tex")
RegisterInventoryItemAtlas("images/inventoryimages/fhl_cy.xml", "fhl_cy.tex")
RegisterInventoryItemAtlas("images/inventoryimages/fhl_x.xml", "fhl_x.tex")
RegisterInventoryItemAtlas("images/inventoryimages/fhl_x2.xml", "fhl_x2.tex")
RegisterInventoryItemAtlas("images/inventoryimages/fhl_hsf.xml", "fhl_hsf.tex")
RegisterInventoryItemAtlas("images/inventoryimages/fhl_zzj2.xml", "fhl_zzj2.tex")
RegisterInventoryItemAtlas("images/inventoryimages/fhl_zzj4.xml", "fhl_zzj4.tex")
RegisterInventoryItemAtlas("images/inventoryimages/fhl_zzj5.xml", "fhl_zzj5.tex")
RegisterInventoryItemAtlas("images/inventoryimages/fhl_tree.xml", "fhl_tree.tex")
RegisterInventoryItemAtlas("images/inventoryimages/licking_eyebone.xml", "licking_eyebone.tex")

----------------------------------------------------------------------------------------------------
GLOBAL.c_returnbell = function(inst)
    inst = inst or ThePlayer or AllPlayers[1]
    if inst and inst.ReturnBell then
        inst:ReturnBell()
    else
        print("Error: No bell to get")
    end
end

----------------------------------------------------------------------------------------------------
containers.params.fhl_bb = deepcopy(containers.params.krampus_sack)
containers.params.fhl_hsf = {
    widget = {
        slotpos = {
            Vector3(-2, 18, 0),
        },
        animbank = "ui_alterguardianhat_1x1",
        animbuild = "ui_alterguardianhat_1x1",
        pos = Vector3(TUNING.HSF_POS_X, 50, 0),
    },
    type = "hand_inv",
    acceptsstacks = false,
    excludefromcrafting = true,
    itemtestfn = function(container, item, slot)
        return table.contains({ "horrorfuel", "purebrilliance", "glommerwings", "ancient_soul" }, item.prefab)
    end
}

----------------------------------------------------------------------------------------------------
local STORE_FN = ACTIONS.STORE.fn
ACTIONS.STORE.fn = function(act)
    if act.target and act.target.prefab == "personal_licking" and act.target.components.container and
        act.invobject.components.inventoryitem ~= nil and act.doer.components.inventory ~= nil and
        act.target.components.follower ~= nil and act.doer ~= act.target.components.follower.leader.owner and
        not act.doer.components.inventory:FindItem(function(item) return item == act.target.components.follower.leader end) then
        return false, "NOTALLOWED"
    else
        return STORE_FN(act)
    end
end

local RUMMAGE_FN = ACTIONS.RUMMAGE.fn
ACTIONS.RUMMAGE.fn = function(act)
    if act.target and act.target.prefab == "personal_licking" and act.target.components.container and
        act.target.components.follower ~= nil and act.doer ~= act.target.components.follower.leader.owner and
        not act.doer.components.inventory:FindItem(function(item) return item == act.target.components.follower.leader end) then
        return false, "NOTALLOWED"
    else
        return RUMMAGE_FN(act)
    end
end

----------------------------------------------------------------------------------------
AddComponentPostInit("thief", function(self)
    local _StealItem = self.StealItem
    self.StealItem = function(self, victim, itemtosteal, attack)
        if victim.prefab == "personal_licking" and victim.components.container and victim.components.follower and
            victim.components.container:IsHolding(victim.components.follower.leader, true) then
            if self.inst.components.inventory ~= nil then
                self.inst.components.inventory:DropEverything(false)
            end
            return false
        end
        return _StealItem(self, victim, itemtosteal, attack)
    end
end)

----------------------------------------------------------------------------------------
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

----------------------------------------------------------------------------------------
AddPrefabPostInit("world", function(inst)
    if TUNING.APPLESTORE then
        inst:WatchWorldState("cycles", function()
            for _, player in ipairs(AllPlayers) do
                if GLOBAL.TheWorld.state.issummer then
                    player:RemoveTag("firstorder")
                    player:AddTag("summerorder")
                else
                    player:RemoveTag("summerorder")
                    player:AddTag("firstorder")
                end
            end
        end)
    end
    inst:ListenForEvent("ms_playerjoined", CheckFullMoon)
    inst:WatchWorldState("isfullmoon", function(inst, isfullmoon)
        if isfullmoon then
            UseFullMoonRecipe()
        else
            RestoreOriginalRecipe()
        end
    end)
end)

----------------------------------------------------------------------------------------
local function OnDeploy(inst, pt, doer)
    local flower = GLOBAL.SpawnPrefab("flower_evil")
    if flower then
        flower.Transform:SetPosition(pt:Get())
        inst.components.stackable:Get():Remove()
        if doer and doer.SoundEmitter then
            doer.SoundEmitter:PlaySound("dontstarve/common/plant")
        end
    end
    if GLOBAL.FindEntity(inst, 10, function(guy)
            return guy.prefab == "personal_licking" and guy.lickingState == "SHADOW"
        end, { "spoiler" }, { "fridge" }) == nil then
        if math.random() < 0.8 then
            doer.components.playerlightningtarget:SetHitChance(1)
            GLOBAL.TheWorld:PushEvent("ms_sendlightningstrike", doer:GetPosition())
            doer.components.playerlightningtarget:SetHitChance(0.3)
            GLOBAL.TheWorld:PushEvent("ms_miniquake", { rad = 10, num = 20, duration = 2, target = doer })
        else
            local pos = GLOBAL.TheWorld.Map:FindRandomPointWithFilter(50, function(map, x, y, z)
                -- 远古档案馆除外
                return map:IsLandTileAtPoint(x, y, z) and not map:NodeAtPointHasTag(x, y, z, "nocavein")
            end)
            if pos ~= nil then
                doer.Physics:Teleport(pos.x, 0, pos.z)
                doer:ResetMinimapOffset()
                doer:SnapCamera()
            end
        end
    end
    if doer.components.cursable ~= nil then
        doer.components.cursable.curses["MONKEY"] = math.max(0, (doer.components.cursable.curses["MONKEY"] or 0) - 1)
        curse.uncurse(doer, doer.components.cursable.curses["MONKEY"])
    end
end

AddPrefabPostInit("cursed_monkey_token", function(inst)
    inst:AddComponent("deployable")
    inst.components.deployable.ondeploy = OnDeploy
    inst.components.deployable.restrictedtag = "fhl"
    inst.components.deployable:SetDeployMode(GLOBAL.DEPLOYMODE.PLANT)
    inst.components.deployable:SetDeploySpacing(GLOBAL.DEPLOYSPACING.LESS)
end)

----------------------------------------------------------------------------------------
local function OnMinHealth(inst, data)
    if data.afflicter and data.afflicter.prefab == "fhl" and not inst:HasTag("defeated") then
        inst.components.lootdropper:SpawnLootPrefab("ancient_soul")
        inst:AddTag("defeated")
    end
end

for i, v in pairs({ "daywalker", "daywalker2", "sharkboi" }) do
    AddPrefabPostInit(v, function(inst)
        inst:AddComponent("lootdropper")
        inst:ListenForEvent("minhealth", OnMinHealth)
    end)
end

----------------------------------------------------------------------------------------
AddPrefabPostInit("rock_avocado_fruit", function(inst)
    inst:AddTag("stonefruit")
end)

----------------------------------------------------------------------------------------
local function OnSpawnedForHunt(inst, data)
    if GLOBAL.FindEntity(inst, 40, function(guy)
            return guy.prefab == "personal_licking" and guy.lickingState == "SNOW"
        end, { "fridge" }, { "spoiler" }) then
        GLOBAL.ReplacePrefab(inst, "koalefant_winter")
    end
end

AddPrefabPostInit("koalefant_summer", function(inst)
    inst:ListenForEvent("spawnedforhunt", OnSpawnedForHunt)
end)

----------------------------------------------------------------------------------------
AddPrefabPostInit("fhl", function(inst)
    local _SaveForReroll = inst.SaveForReroll
    inst.SaveForReroll = function(inst)
        local data = _SaveForReroll(inst) or {}
        local fhl = {}
        fhl.level = inst.level or 0
        fhl.totalpoints = inst.totalpoints or 0
        fhl.applestate = inst.licking and inst.licking.lickingState
        data.fhl = fhl
        return data
    end

    local _LoadForReroll = inst.LoadForReroll
    inst.LoadForReroll = function(inst, data)
        if type(data.fhl) == "table" then
            inst.level = data.fhl.level or 0
            inst.jnd = data.fhl.totalpoints or 0
            inst.totalpoints = data.fhl.totalpoints or 0
            inst.applestate = data.fhl.applestate or "NORMAL"
        end
        _LoadForReroll(inst, data)
    end
end)

AddPrefabPostInit("wonkey", function(inst)
    local _SaveForReroll = inst.SaveForReroll
    inst.SaveForReroll = function(inst)
        local data = _SaveForReroll(inst) or {}
        data.fhl = inst.fhl
        return next(data) and data or nil
    end

    local _LoadForReroll = inst.LoadForReroll
    inst.LoadForReroll = function(inst, data)
        inst.fhl = data.fhl
        _LoadForReroll(inst, data)
    end

    local _OnSave = inst.OnSave or function() end
    inst.OnSave = function(inst, data)
        data.fhl = inst.fhl
        _OnSave(inst, data)
    end

    local _OnLoad = inst.OnLoad or function() end
    inst.OnLoad = function(inst, data)
        inst.fhl = data.fhl
        _OnLoad(inst, data)
    end
end)

----------------------------------------------------------------------------------------
if TUNING.APPLESTORE then
    GLOBAL.PROTOTYPER_DEFS.personal_licking = {
        icon_atlas = "images/inventoryimages/applestore.xml",
        icon_image = "applestore.tex",
        is_crafting_station = true,
        action_str = "TRADE",
        filter_text = "苹果杂货铺",
    }

    GLOBAL.RECIPETABS.PROPERTY = {
        str = "PROPERTY",
        sort = 666,
        icon = "applestore.tex",
        icon_atlas = "images/inventoryimages/applestore.xml",
        crafting_station = true,
        shop = true
    }
    ----------------------------------------------------------------------------------------
    TechTree.Make = function(t)
        t = t or {}
        for i, v in ipairs(TechTree.AVAILABLE_TECH) do
            t[v] = t[v] or 0
        end
        return t
    end
    table.insert(TechTree.AVAILABLE_TECH, "PROPERTY")
    table.insert(TechTree.BONUS_TECH, "PROPERTY")
    for k, v in pairs(TUNING.PROTOTYPER_TREES) do
        v.PROPERTY = 0
    end

    TECH.NONE.PROPERTY = 0
    TECH.APPLESTORE = { PROPERTY = 1 }
    TUNING.PROTOTYPER_TREES.APPLESTORE = TechTree.Make({
        PROPERTY = 1,
    })
    -- TECH.ONCESUPPLY = { PROPERTY = 2 }
    -- TUNING.PROTOTYPER_TREES.ONCESUPPLY = TechTree.Make({
    --     PROPERTY = 2,
    -- })
    for i, v in pairs(GLOBAL.AllRecipes) do
        if v.level.PROPERTY == nil then
            v.level.PROPERTY = 0
        end
    end

    -- ----SHOPPING----
    AddRecipe2("free_hot_drink", {}, TECH.APPLESTORE,
        { product = "winter_food8", nounlock = true, builder_tag = "firstorder", no_deconstruction = true })                -- 热可可
    AddRecipe2("free_cold_drink", {}, TECH.APPLESTORE,
        { product = "winter_food9", nounlock = true, builder_tag = "summerorder", no_deconstruction = true })               -- 美味的蛋酒
    AddRecipe2("gold_exchange", { Ingredient("goldnugget", 5) }, TECH.APPLESTORE,
        { product = "ancient_soul", nounlock = true, builder_tag = "bellholder", no_deconstruction = true })                -- 符文结晶
    AddRecipe2("entree_voltgoatjelly", { Ingredient("goldnugget", 5) }, TECH.APPLESTORE,
        { product = "voltgoatjelly", nounlock = true, builder_tag = "bellholder", no_deconstruction = true })               -- 伏特羊肉冻
    AddRecipe2("entree_glowberrymousse", { Ingredient("goldnugget", 5) }, TECH.APPLESTORE,
        { product = "glowberrymousse", nounlock = true, builder_tag = "bellholder", no_deconstruction = true })             -- 发光浆果慕斯
    AddRecipe2("entree_dragonchilisalad", { Ingredient("goldnugget", 5) }, TECH.APPLESTORE,
        { product = "dragonchilisalad", nounlock = true, builder_tag = "bellholder", no_deconstruction = true })            -- 辣龙椒沙拉
    AddRecipe2("entree_frogfishbowl", { Ingredient("goldnugget", 5) }, TECH.APPLESTORE,
        { product = "frogfishbowl", nounlock = true, builder_tag = "bellholder", no_deconstruction = true })                -- 蓝带鱼排
    AddRecipe2("entree_nightmarepie", { Ingredient("goldnugget", 5) }, TECH.APPLESTORE,
        { product = "nightmarepie", nounlock = true, builder_tag = "bellholder", no_deconstruction = true })                -- 恐怖国王饼
    AddRecipe2("treasure_mosquitobomb", { Ingredient("goldnugget", 5) }, TECH.APPLESTORE,
        { product = "mosquitobomb", numtogive = 2, nounlock = true, builder_tag = "bellholder", no_deconstruction = true }) -- 蚊子炸弹
    AddRecipe2("treasure_luckyfan", { Ingredient("goldnugget", 5) }, TECH.APPLESTORE,
        { product = "perdfan", nounlock = true, builder_tag = "bellholder", no_deconstruction = true })                     -- 幸运火鸡扇
    AddRecipe2("treasure_luckywhistle", { Ingredient("goldnugget", 5) }, TECH.APPLESTORE,
        { product = "houndwhistle", nounlock = true, builder_tag = "bellholder", no_deconstruction = true })                -- 幸运猎犬哨子
    AddRecipe2("treasure_giftwrap", { Ingredient("goldnugget", 5) }, TECH.APPLESTORE,
        { product = "giftwrap", numtogive = 4, nounlock = true, builder_tag = "bellholder", no_deconstruction = true })     -- 礼物包装
    AddRecipe2("treasure_seedpacket_rare", { Ingredient("goldnugget", 5) }, TECH.APPLESTORE,
        { product = "yotc_seedpacket_rare", nounlock = true, builder_tag = "bellholder", no_deconstruction = true })        -- 高级种子包
    AddRecipe2("treasure_surprisingseed", { Ingredient("goldnugget", 5) }, TECH.APPLESTORE,
        { product = "ancienttree_seed", nounlock = true, builder_tag = "bellholder", no_deconstruction = true })            -- 惊喜种子
    AddRecipe2("treasure_normaltree", { Ingredient("goldnugget", 5) }, TECH.APPLESTORE,
        { product = "livingtree_root", nounlock = true, builder_tag = "bellholder", no_deconstruction = true })             -- 完全正常的树根
    AddRecipe2("treasure_redlantern", { Ingredient("goldnugget", 10) }, TECH.APPLESTORE,
        { product = "redlantern", nounlock = true, builder_tag = "bellholder", no_deconstruction = true })                  -- 红灯笼
    AddRecipe2("treasure_dragonboat_lamp", { Ingredient("goldnugget", 10) }, TECH.APPLESTORE,
        { product = "mastupgrade_lamp_item_yotd", nounlock = true, builder_tag = "bellholder", no_deconstruction = true })  -- 龙蝇灯套装
    AddRecipe2("treasure_archaic_boat", { Ingredient("goldnugget", 20) }, TECH.APPLESTORE,
        { product = "boat_ancient_item", nounlock = true, builder_tag = "bellholder", no_deconstruction = true })           -- 古董船套装
    AddRecipe2("treasure_dragonboat_pack", { Ingredient("goldnugget", 40) }, TECH.APPLESTORE,
        { product = "dragonboat_pack", nounlock = true, builder_tag = "bellholder", no_deconstruction = true })             -- 豪华龙蝇船套装
    AddRecipe2("raw_horrorfuel", { Ingredient("goldnugget", 5) }, TECH.APPLESTORE,
        { product = "horrorfuel", nounlock = true, builder_tag = "bellholder", no_deconstruction = true })                  -- 纯粹恐惧
    AddRecipe2("raw_voidcloth", { Ingredient("goldnugget", 5) }, TECH.APPLESTORE,
        { product = "voidcloth", nounlock = true, builder_tag = "bellholder", no_deconstruction = true })                   -- 暗影碎布
    AddRecipe2("raw_dreadstone", { Ingredient("goldnugget", 10) }, TECH.APPLESTORE,
        { product = "dreadstone", nounlock = true, builder_tag = "bellholder", no_deconstruction = true })                  -- 绝望石
    AddRecipe2("raw_infusedheart", { Ingredient("goldnugget", 40) }, TECH.APPLESTORE,
        { product = "shadowheart_infused", nounlock = true, builder_tag = "bellholder", no_deconstruction = true })         -- 附身暗影心房
    AddRecipe2("raw_emptybottle", { Ingredient("goldnugget", 5) }, TECH.APPLESTORE,
        { product = "messagebottleempty", nounlock = true, builder_tag = "bellholder", no_deconstruction = true })          -- 空瓶子
    AddRecipe2("raw_scrap", { Ingredient("goldnugget", 5) }, TECH.APPLESTORE,
        { product = "wagpunk_bits", nounlock = true, builder_tag = "bellholder", no_deconstruction = true })                -- 废料
    AddRecipe2("raw_lunarplant_husk", { Ingredient("goldnugget", 5) }, TECH.APPLESTORE,
        { product = "lunarplant_husk", nounlock = true, builder_tag = "bellholder", no_deconstruction = true })             -- 亮茄外壳
    AddRecipe2("raw_moonglass_charged", { Ingredient("goldnugget", 5) }, TECH.APPLESTORE,
        { product = "moonglass_charged", nounlock = true, builder_tag = "bellholder", no_deconstruction = true })           -- 注能月亮碎片
    AddRecipe2("raw_purebrilliance", { Ingredient("goldnugget", 10) }, TECH.APPLESTORE,
        { product = "purebrilliance", nounlock = true, builder_tag = "bellholder", no_deconstruction = true })              -- 纯粹辉煌
    AddRecipe2("raw_enlightened_shard", { Ingredient("goldnugget", 20) }, TECH.APPLESTORE,
        { product = "alterguardianhatshard", nounlock = true, builder_tag = "bellholder", no_deconstruction = true })       -- 启迪碎片
    AddRecipe2("raw_spark_ark", { Ingredient("goldnugget", 40) }, TECH.APPLESTORE,
        { product = "security_pulse_cage_full", nounlock = true, builder_tag = "bellholder", no_deconstruction = true })    -- 充能火花柜

    AddPlayerPostInit(function(inst)
        inst:ListenForEvent("makerecipe", function(inst, data)
            if data.recipe.name == "free_hot_drink" then
                inst:RemoveTag("firstorder")
            end
            if data.recipe.name == "free_cold_drink" then
                inst:RemoveTag("summerorder")
            end
        end)
    end)
end

----------------------------------------------------------------------------------------
if TUNING.SKILL_TREE then
    AddComponentPostInit("edible", function(self)
        local _GetHealth = self.GetHealth
        self.GetHealth = function(self, eater)
            local health = _GetHealth(self, eater)
            if self.healthvalue < -2 and eater and eater.components.inventory and
                eater.components.inventory:EquipHasTag("foodharm_resistant") then
                health = -2
            end
            return health
        end
    end)

    AddCharacterRecipe("book_gardening", { Ingredient("papyrus", 2), Ingredient("seeds", 1), Ingredient("poop", 1) },
        TECH.NONE, { product = "book_gardening", builder_tag = "fhl" })
end

AddCharacterRecipe("fhl_zzj2", { Ingredient("twigs", 6), Ingredient("ancient_soul", 2), Ingredient("goldnugget", 4) },
    TECH.NONE, { product = "fhl_zzj2", builder_tag = "fhl" })

AddCharacterRecipe("fhl_zzj4", { Ingredient("fhl_zzj2", 1), Ingredient("ancient_soul", 5), Ingredient("goldnugget", 10) },
    TECH.NONE, { product = "fhl_zzj4", builder_tag = "fhl" })

AddCharacterRecipe("fhl_zzj5", { Ingredient("fhl_zzj4", 1), Ingredient("ancient_soul", 8), Ingredient("goldnugget", 16) },
    TECH.NONE, { product = "fhl_zzj5", builder_tag = "fhl" })

AddCharacterRecipe("fhl_bb", { Ingredient("waxpaper", 3), Ingredient("rope", 2), Ingredient("ancient_soul", 8) },
    TECH.NONE, { product = "fhl_bb", builder_tag = "fhl" })

AddCharacterRecipe("fhl_hsf", { Ingredient("feather_robin", 2), Ingredient("feather_crow", 2),
    Ingredient("ancient_soul", 2) }, TECH.NONE, { product = "fhl_hsf", builder_tag = "fhl" })

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

AddCharacterRecipe("ancient_workstation",
    { Ingredient("ancient_soul", 10), Ingredient("nightmarefuel", 8), Ingredient("purplegem", 2) },
    TECH.NONE, { product = "ancient_gem", builder_tag = "fhl", no_deconstruction = true })

AddCharacterRecipe("fhl_reeds", { Ingredient("cutreeds", 8), Ingredient("ancient_soul", 1) }, TECH.NONE,
    { product = "dug_monkeytail", numtogive = 2, builder_tag = "fhl", no_deconstruction = true })

AddCharacterRecipe("fhl_tree", { Ingredient("twigs", 4), Ingredient("ancient_soul", 1) }, TECH.NONE,
    { product = "fhl_tree", builder_tag = "fhl" })

AddCharacterRecipe("bj_11", { Ingredient("ancient_soul", 6), Ingredient("goldnugget", 6), Ingredient("twigs", 6) },
    TECH.NONE, { product = "bj_11", builder_tag = "fhl" })

AddIngredientValues({ "fhl_cake" }, { dairy = 1, sweetener = 1 })

AddDeconstructRecipe("fhl_cake", { Ingredient("bird_egg", 2), Ingredient("pumpkin", 1) })

AddDeconstructRecipe("fhl_x", { Ingredient("berries", 2), Ingredient("lunarfrog", 2), Ingredient("petals_evil", 1) })

AddDeconstructRecipe("fhl_x2",
    { Ingredient("halloweenpotion_moon", 1), Ingredient("moonbutterfly", 2), Ingredient("petals_evil", 1) })

-- ----BOOK----
AddRecipe2("book_sleep", { Ingredient("papyrus", 2), Ingredient("nightmarefuel", 2) }, TECH.NONE,
    { product = "book_sleep", builder_tag = "bookbuilder" })

AddRecipe2("book_brimstone", { Ingredient("papyrus", 2), Ingredient("redgem", 1) }, TECH.NONE,
    { product = "book_brimstone", builder_tag = "bookbuilder" })

AddRecipe2("book_tentacles", { Ingredient("papyrus", 2), Ingredient("tentaclespots", 1) }, TECH.NONE,
    { product = "book_tentacles", builder_tag = "bookbuilder" })

-----------创建地图图标和角色基础属性
AddMinimapAtlas("images/map_icons/fhl_data.xml")
AddMinimapAtlas("images/map_icons/fhl.xml")
AddModCharacter("fhl", "FEMALE")
