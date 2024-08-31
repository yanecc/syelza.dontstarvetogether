local require = GLOBAL.require
local STRINGS = GLOBAL.STRINGS
local resolvefilepath = GLOBAL.resolvefilepath
local Ingredient = GLOBAL.Ingredient
local RECIPETABS = GLOBAL.RECIPETABS
local Recipe = GLOBAL.Recipe
local TECH = GLOBAL.TECH
local TechTree = require("techtree")
local ACTIONS = GLOBAL.ACTIONS
local TheNet = GLOBAL.TheNet
local next = GLOBAL.next
local ThePlayer = GLOBAL.ThePlayer
local IsServer = GLOBAL.TheNet:GetIsServer()
local TheInput = GLOBAL.TheInput
local Vector3 = GLOBAL.Vector3

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

GLOBAL.TUNING.FHL = {}
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

    local _OnDespawn = inst.OnDespawn
    inst.OnDespawn = function(inst)
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
        if _OnDespawn then
            return _OnDespawn(inst)
        end
    end

    local _OnSave = inst.OnSave
    inst.OnSave = function(inst, data)
        local references = _OnSave and _OnSave(inst, data)
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

    local _OnLoad = inst.OnLoad
    inst.OnLoad = function(inst, data, newents)
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

        if _OnLoad then
            return _OnLoad(inst, data, newents)
        end
    end

    local _OnNewSpawn = inst.OnNewSpawn
    inst.OnNewSpawn = function(inst)
        -- Give new lickingbone. Let licking spawn naturally.
        Givelickingbone(inst)
        if _OnNewSpawn then
            return _OnNewSpawn(inst)
        end
    end

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

-- 检查范围：（递归）物品栏、背包、（递归）苹果
local STORE_FN = GLOBAL.ACTIONS.STORE.fn
GLOBAL.ACTIONS.STORE.fn = function(act)
    if act.target and act.target.prefab == "personal_licking" and act.target.components.container and
        act.invobject.components.inventoryitem ~= nil and act.doer.components.inventory ~= nil and
        not act.doer.components.inventory:FindItem(function(item) return item == act.target.components.follower.leader end) and
        not act.target.components.container:IsHolding(act.target.components.follower.leader, true) and
        not act.doer.components.inventory:IsHolding(act.target.components.follower.leader, true) then
        return false, "NOTALLOWED"
    else
        return STORE_FN(act)
    end
end

local RUMMAGE_FN = GLOBAL.ACTIONS.RUMMAGE.fn
GLOBAL.ACTIONS.RUMMAGE.fn = function(act)
    if act.target and act.target.prefab == "personal_licking" and act.target.components.container and
        not act.doer.components.inventory:FindItem(function(item) return item == act.target.components.follower.leader end) and
        not act.target.components.container:IsHolding(act.target.components.follower.leader, true) and
        not act.doer.components.inventory:IsHolding(act.target.components.follower.leader, true) then
        return false, "NOTALLOWED"
    else
        return RUMMAGE_FN(act)
    end
end

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
        local season = GLOBAL.TheWorld.state.season
        inst:WatchWorldState("cycles", function()
            for _, player in ipairs(GLOBAL.AllPlayers) do
                if season == "summer" then
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
for i, v in pairs({ "gestalt", "gestalt_guard", "lunar_grazer" }) do
    AddPrefabPostInit(v, function(inst)
        inst.components.combat:AddNoAggroTag("lunarprayer")
    end)
end

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
        { product = "giftwrap", numtogive = 2, nounlock = true, builder_tag = "bellholder", no_deconstruction = true })     -- 礼物包装
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
    AddRecipe2("raw_scrap", { Ingredient("goldnugget", 5) }, TECH.APPLESTORE,
        { product = "wagpunk_bits", nounlock = true, builder_tag = "bellholder", no_deconstruction = true })                -- 废料
    AddRecipe2("raw_emptybottle", { Ingredient("goldnugget", 5) }, TECH.APPLESTORE,
        { product = "messagebottleempty", nounlock = true, builder_tag = "bellholder", no_deconstruction = true })          -- 空瓶子
    AddRecipe2("raw_voidcloth", { Ingredient("goldnugget", 5) }, TECH.APPLESTORE,
        { product = "voidcloth", nounlock = true, builder_tag = "bellholder", no_deconstruction = true })                   -- 暗影碎布
    AddRecipe2("raw_dreadstone", { Ingredient("goldnugget", 10) }, TECH.APPLESTORE,
        { product = "dreadstone", nounlock = true, builder_tag = "bellholder", no_deconstruction = true })                  -- 绝望石
    AddRecipe2("raw_horrorfuel", { Ingredient("goldnugget", 10) }, TECH.APPLESTORE,
        { product = "horrorfuel", nounlock = true, builder_tag = "bellholder", no_deconstruction = true })                  -- 纯粹恐惧
    AddRecipe2("raw_lunarplant_husk", { Ingredient("goldnugget", 5) }, TECH.APPLESTORE,
        { product = "lunarplant_husk", nounlock = true, builder_tag = "bellholder", no_deconstruction = true })             -- 亮茄外壳
    AddRecipe2("raw_moonglass_charged", { Ingredient("goldnugget", 5) }, TECH.APPLESTORE,
        { product = "moonglass_charged", nounlock = true, builder_tag = "bellholder", no_deconstruction = true })           -- 充能月亮碎片
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

-- AddDeconstructRecipe("ancient_gem",
--     { Ingredient("ancient_soul", 10), Ingredient("nightmarefuel", 8), Ingredient("opalpreciousgem", 1) })

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
