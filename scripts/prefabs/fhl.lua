local MakePlayerCharacter = require "prefabs/player_common"
-- local skilltreedefs = require "prefabs/skilltree_defs"

-- skilltreedefs.CreateSkillTreeFor("fhl", {
--     fhl_alchemy_1 = {
--         title = "fhl_skill_1",
--         desc = "fhl_skill_description_1",
--         icon = "wilson_alchemy_1",
--         pos = {-62,176},
--         --pos = {1,0},
--         group = "alchemy",
--         tags = {"alchemy"},
--         onactivate = function(inst, fromload)
--                 inst:AddTag("alchemist")
--             end,
--         root = true,
--         connects = {
--             "fhl_skill_2",
--         },
--     },
--     fhl_alchemy_2 = {
--         title = "fhl_skill_2",
--         desc = "fhl_skill_description_2",
--         icon = "wilson_alchemy_gem_1",
--         pos = {-62,176-54},
--         --pos = {0,-1},
--         group = "alchemy",
--         tags = {"alchemy"},
--         onactivate = function(inst, fromload)
--                 inst:AddTag("gem_alchemistI")
--             end,
--         connects = {
--         },
--     },
-- })

-- skilltreedefs.SKILLTREE_ORDERS["fhl"] = {
--             {"alchemy",   { -62       , 176 + 30 }},
--         }

local assets = {

    Asset("ANIM", "anim/player_basic.zip"),
    Asset("ANIM", "anim/player_idles_shiver.zip"),
    Asset("ANIM", "anim/player_actions.zip"),
    Asset("ANIM", "anim/player_actions_axe.zip"),
    Asset("ANIM", "anim/player_actions_pickaxe.zip"),
    Asset("ANIM", "anim/player_actions_shovel.zip"),
    Asset("ANIM", "anim/player_actions_blowdart.zip"),
    Asset("ANIM", "anim/player_actions_eat.zip"),
    Asset("ANIM", "anim/player_actions_item.zip"),
    Asset("ANIM", "anim/player_actions_uniqueitem.zip"),
    Asset("ANIM", "anim/player_actions_bugnet.zip"),
    Asset("ANIM", "anim/player_actions_fishing.zip"),
    Asset("ANIM", "anim/player_actions_boomerang.zip"),
    Asset("ANIM", "anim/player_bush_hat.zip"),
    Asset("ANIM", "anim/player_attacks.zip"),
    Asset("ANIM", "anim/player_idles.zip"),
    Asset("ANIM", "anim/player_rebirth.zip"),
    Asset("ANIM", "anim/player_jump.zip"),
    Asset("ANIM", "anim/player_amulet_resurrect.zip"),
    Asset("ANIM", "anim/player_teleport.zip"),
    Asset("ANIM", "anim/wilson_fx.zip"),
    Asset("ANIM", "anim/player_one_man_band.zip"),
    Asset("ANIM", "anim/shadow_hands.zip"),
    Asset("SOUND", "sound/sfx.fsb"),
    Asset("SOUND", "sound/wilson.fsb"),
    Asset("ANIM", "anim/beard.zip"),

    Asset("ANIM", "anim/fhl.zip"),
    Asset("ANIM", "anim/ghost_fhl_build.zip"),
}

local prefabs = {
    "fhl_bz",
    "fhl_cake",
    "fhl_cy",
    "bj_11"
}

-- 自定义启动项
local start_inv = {
    "fhl_bz",
    "fhl_cake",
    "fhl_cy",
    "bj_11"
}

local function OnKillOther(inst, data)
    local victim = data.victim
    if not victim.components.lootdropper then return end
    if victim:HasTag("epic") or victim:HasAnyTag("hostile", "killer", "merm", "monkey", "monster", "spat", "tallbird", "walrus") and math.random() < TUNING.FHL_COS then
        victim.components.lootdropper:SpawnLootPrefab("ancient_soul")
    end
end

local function FhlFire(inst)
    if TheWorld.state.isnight and TUNING.OPENLIGHT then
        inst.Light:Enable(true)
        inst.Light:SetRadius(6)
        inst.Light:SetFalloff(.8)
        inst.Light:SetIntensity(.8)
        inst.Light:SetColour(237 / 255, 237 / 255, 209 / 255)
    end
end

--升级机制
local function applyupgrades(inst)
    local maxLevel = 10
    local curLevel = math.min(inst.level, maxLevel)
    local pointsKey = TUNING.SKILL_POINT_KEY:sub(-1)
    local statusKey = TUNING.STATUS_KEY:sub(-1)

    local hungerPercent = inst.components.hunger:GetPercent()
    local healthPercent = inst.components.health:GetPercent()
    local sanityPercent = inst.components.sanity:GetPercent()

    inst.components.hunger.max = 150 + curLevel * 15                  --300
    inst.components.health.maxhealth = 150 + curLevel * 15            --300
    inst.components.sanity.max = 150 + curLevel * 15                  --300

    inst.components.locomotor.walkspeed = math.ceil(7 + curLevel / 4) --10
    inst.components.locomotor.runspeed = math.ceil(9 + curLevel / 4)  --12


    inst.components.talker:Say("QWQ Level now: " .. (inst.level) ..
        "\n你还有" .. (inst.jnd) .. "点技能点!" ..
        "\n加点帮助请按" .. pointsKey .. ",当前状态请按" .. statusKey .. "!" ..
        "\nyou have " .. (inst.jnd) .. " skill points!" ..
        "\nClick " .. pointsKey .. " for help, Click " .. statusKey .. " for State!")

    if inst.level >= 10 then
        inst.components.talker:Say("W.W Level Max!\n" ..
            "\n你还有" .. (inst.jnd) .. "点技能点!" ..
            "\n加点帮助请按" .. pointsKey .. ",当前状态请按" .. statusKey .. "!" ..
            "\nyou have " .. (inst.jnd) .. " skill points!" ..
            "\nClick " .. pointsKey .. " for help, Click " .. statusKey .. " for State!")
    end

    inst.components.hunger:SetPercent(hungerPercent)
    inst.components.health:SetPercent(healthPercent)
    inst.components.sanity:SetPercent(sanityPercent)
end

-- 当这个角色从人类复活
local function onbecamehuman(inst)
    -- 设置速度加载或恢复时从鬼(可选)
    inst.components.locomotor.walkspeed = 7
    inst.components.locomotor.runspeed = 9
    applyupgrades(inst)
end


local function onload(inst)
    inst:ListenForEvent("ms_respawnedfromghost", onbecamehuman)

    if not inst:HasTag("playerghost") then
        onbecamehuman(inst)
    end
end


local function oneat(inst, food)
    local berryUp = TUNING.JGEAT                        -- 吃浆果升级
    local berryLimit = TUNING.JGEATSL                   -- 吃浆果升级的临界值
    local levelmax = inst.level == 10                   -- 是否已满级
    local failureFactor = TUNING.LEVELUP_FAILURE_FACTOR -- 升级失败的概率

    -- 浆果 烤浆果 多汁浆果 烤多汁浆果
    -- 吃浆果可以升级，满级以后获取技能点只能吃火龙果
    if berryUp and (food.prefab == "berries" or food.prefab == "berries_cooked" or food.prefab == "berries_juicy" or food.prefab == "berries_juicy_cooked") then
        inst.berryCount = inst.berryCount + 1
        if inst.berryCount % 5 == 0 then
            inst.components.talker:Say("已经吃了: " .. inst.berryCount .. " / " .. berryLimit .. " 个浆果" ..
                "\nHave eaten " .. inst.berryCount .. " / " .. berryLimit .. " berries")
        end
        if not levelmax and inst.berryCount >= berryLimit then
            inst.berryEnough = true
            inst.berryCount = inst.berryCount - berryLimit
        end
    end

    -- 火龙果、烤火龙果、火龙果派、辣龙椒沙拉
    if food.prefab == "dragonfruit" or food.prefab == "dragonfruit_cooked" or food.prefab == "dragonpie" or food.prefab == "dragonchilisalad" or inst.berryEnough then
        local hasGoodLuck = math.random() > failureFactor * math.tan(inst.level * 0.1)
        -- 满级以后再吃浆果inst.berryEnough不会为true
        if (levelmax) then
            if inst.totalPoints < 42 and hasGoodLuck then
                -- inst.jnd 技能点
                local points = math.max(inst.totalPoints + 1, inst.level, inst.jnd)
                inst.totalPoints = points
                inst.jnd = inst.jnd + 1
                applyupgrades(inst)
                inst.SoundEmitter:PlaySound("dontstarve/characters/wx78/levelup")
            else
                inst.components.talker:Say("QWQ 满级了! 没获得技能点!\nQWQ level Max! Got no skill point!")
            end
        elseif hasGoodLuck then
            -- inst.jnd 技能点
            -- inst.totalPoints 总技能点42可以将全部方向点满 抗寒8 减伤16 增伤10 抗饿8
            if inst.totalPoints < 42 then
                local points = math.max(inst.totalPoints + 1, inst.level, inst.jnd)
                inst.totalPoints = points
                inst.jnd = inst.jnd + 1
            end
            inst.level = inst.level + 1
            inst.berryEnough = false
            applyupgrades(inst)
            inst.SoundEmitter:PlaySound("dontstarve/characters/wx78/levelup")
        else
            inst.berryEnough = false
            inst.components.talker:Say("QWQ 升级失败了!\nlevel up failed!")
        end
    end

    -- 吃芝士蛋糕会重置等级和技能点，必须等级大于0才能洗点
    if food.prefab == "powcake" and inst.level > 0 then
        inst.level = 0
        inst.jnd = inst.totalPoints

        inst.je = 0
        inst.components.health.absorb = 0
        inst.components.combat.damagemultiplier = 1
        inst.components.temperature.inherentinsulation = 0
        inst.components.hunger.hungerrate = TUNING.WILSON_HUNGER_RATE
        applyupgrades(inst)
        inst.SoundEmitter:PlaySound("dontstarve/characters/wx78/levelup")
    end
end

local function onpreload(inst, data)
    inst.je = data.je or 0
    inst.level = data.level or 0
    inst.jnd = data.jnd or data.level
    inst.berryCount = data.berryCount or 0
    inst.totalPoints = data.totalPoints or data.level
    inst.zzjFeedBack = data.zzjFeedBack or 0

    applyupgrades(inst)

    inst.components.health.absorb = data.absorb or 0.00
    inst.components.hunger.hungerrate = data.hungerrate or TUNING.WILSON_HUNGER_RATE
    inst.components.combat.damagemultiplier = data.damagemultiplier or 1.00
    inst.components.temperature.inherentinsulation = data.inherentinsulation or 0.00
end

local function onsave(inst, data)
    data.je = inst.je
    data.jnd = inst.jnd
    data.level = inst.level
    data.totalPoints = inst.totalPoints
    data.zzjFeedBack = inst.zzjFeedBack

    -- 保存已经吃的浆果数量
    data.berryCount = inst.berryCount

    data.hungerrate = inst.components.hunger.hungerrate
    data.absorb = inst.components.health.absorb
    data.damagemultiplier = inst.components.combat.damagemultiplier
    data.inherentinsulation = inst.components.temperature.inherentinsulation
end

-- 这对服务器和客户端初始化。可以添加标注。
local common_postinit = function(inst)
    -- 小地图图标
    inst.MiniMapEntity:SetIcon("fhl.tex")
    inst.soundsname = "willow"
    inst:AddTag("fhl")
    inst:AddTag("speciallickingowner")
    inst:AddTag("bookbuilder")
    --inst:AddTag("insomniac")
end

-- 这对于服务器初始化。组件被添加。
local master_postinit = function(inst)
    inst.level = 0
    inst.jnd = 0
    inst.je = 0
    inst.totalPoints = 0
    inst.berryCount = 0
    inst.berryEnough = false
    inst.zzjFeedBack = 0
    inst.starting_inventory = start_inv
    inst.components.eater:SetOnEatFn(oneat)
    applyupgrades(inst)

    inst:AddComponent("reader")
    ------------------------------------------
    inst:AddComponent("leader")
    ------------------------------------------
    inst:AddComponent("knownlocations")

    inst:WatchWorldState("phase", FhlFire)
    inst:ListenForEvent("hungerdelta", FhlFire)

    -- 属性设置
    inst.components.health:SetMaxHealth(TUNING.FHL_HEALTH)
    inst.components.hunger:SetMax(TUNING.FHL_HUNGER)
    inst.components.sanity:SetMax(TUNING.FHL_SANITY)

    inst.components.locomotor.walkspeed = 7
    inst.components.locomotor.runspeed = 9
    inst.components.health.absorb = 0.00
    inst.components.combat.damagemultiplier = 1.00
    inst.components.hunger.hungerrate = (TUNING.WILSON_HUNGER_RATE * 1.00)
    inst.components.temperature.inherentinsulation = (TUNING.INSULATION_PER_BEARD_BIT * 0.00)

    -- food affinity multipliers to add 15 calories
    -- AFFINITY_15_CALORIES_TINY = 2.6
    -- AFFINITY_15_CALORIES_SMALL = 2.2
    -- AFFINITY_15_CALORIES_MED = 1.6
    -- AFFINITY_15_CALORIES_LARGE = 1.4
    -- AFFINITY_15_CALORIES_HUGE = 1.2
    -- AFFINITY_15_CALORIES_SUPERHUGE = 1.1
    -- 香蕉奶昔 至少两个(烤)香蕉，不能有鱼度、肉度、怪物度、冰 8,25+15,33
    inst.components.foodaffinity:AddPrefabAffinity("bananajuice", TUNING.AFFINITY_15_CALORIES_MED)

    if TUNING.SKILL_TREE then
        inst:AddComponent("damagetypebonus")
        inst.components.damagetypebonus:AddBonus("epic", inst, 1.2)
        inst.components.combat.bonusdamagefn = function(inst, target, damage, weapon)
            local bonusDamage = weapon and weapon:HasTag("fhlzzj") and inst.zzjFeedBack or 0
            inst.zzjFeedBack = 0
            return bonusDamage
        end

        inst:ListenForEvent("picksomething", function(inst, data)
            if data.object.prefab == "reeds" and math.random() < 0.5 then
                data.loot.components.stackable:SetStackSize(data.loot.components.stackable.stacksize + 1)
            end
        end)
    end

    -- 增加击杀掉落
    inst:ListenForEvent("killed", OnKillOther)

    inst.OnSave = onsave
    inst.OnPreLoad = onpreload
    inst.OnLoad = onload
    inst.OnNewSpawn = onload
end

return MakePlayerCharacter("fhl", prefabs, assets, common_postinit, master_postinit)
