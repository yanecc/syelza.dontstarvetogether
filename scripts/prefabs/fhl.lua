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
    "bj_11",

    "dragonpie",
    "dragonfruit",
    "dragonfruit_cooked",
    "dragonchilisalad",

    "berries",
    "berries_cooked",
    "berries_juicy",
    "berries_juicy_cooked",

    "powcake"
}

-- 自定义启动项
local start_inv = {
    "fhl_bz",
    "fhl_cake",
    "fhl_cy",
    "bj_11"
}

local function onkillother(inst, data)
    local victim = data.victim
    if not victim.components.lootdropper then return end
    -- if victim.components.freezable or victim:HasTag("monster") then
    -- if victim:HasTag("monster") or victim:HasTag("hostile") or victim:HasTag("scarytoprey") then
    --     if victim:HasTag("epic") or math.random() < TUNING.FHL_COS then
    --         victim.components.lootdropper:SpawnLootPrefab("ancient_soul")
    --     end
    -- end
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
    local max_upgrades = 10
    local upgrades = math.min(inst.level, max_upgrades)

    local hunger_percent = inst.components.hunger:GetPercent()
    local health_percent = inst.components.health:GetPercent()
    local sanity_percent = inst.components.sanity:GetPercent()

    inst.components.hunger.max = 150 + upgrades * 15                  --300
    inst.components.health.maxhealth = 150 + upgrades * 15            --300
    inst.components.sanity.max = 150 + upgrades * 15                  --300

    inst.components.locomotor.walkspeed = math.ceil(7 + upgrades / 4) --10
    inst.components.locomotor.runspeed = math.ceil(9 + upgrades / 4)  --12


    inst.components.talker:Say("QWQ Level now: " .. (inst.level) ..
        "\n你还有" .. (inst.jnd) .. "点技能点!\n加点帮助请按R,当前状态请按T!" ..
        "\nyou have " .. (inst.jnd) .. " skill points!\nClick R for help, Click T for State!")

    if inst.level >= 10 then
        inst.components.talker:Say("W.W Level Max!\n你还有" .. (inst.level) ..
            "\n你还有" .. (inst.jnd) .. "点技能点!\n加点帮助请按R,当前状态请按T!" ..
            "\nyou have " .. (inst.jnd) .. " skill points!\nClick R for help, Click T for State!")
    end

    inst.components.hunger:SetPercent(hunger_percent)
    inst.components.health:SetPercent(health_percent)
    inst.components.sanity:SetPercent(sanity_percent)
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
    local jgeat = TUNING.JGEAT                          -- 吃浆果升级
    local jgeatsl = TUNING.JGEATSL                      -- 吃浆果升级的临界值
    local levelmax = inst.level == 10                   -- 是否已满级
    local failureFactor = TUNING.LEVELUP_FAILURE_FACTOR -- 升级失败的概率

    if (food and food.components.edible) then
        -- 包括 浆果 烤浆果 多汁浆果 烤多汁浆果
        if (jgeat == true and food.prefab == "berries" or food.prefab == "berries_cooked" or food.prefab == "berries_juicy" or food.prefab == "berries_juicy_cooked") then
            -- inst.eatsl 已经吃了的数量
            -- inst.eatsj 满足升级条件
            inst.eatsl = inst.eatsl + 1
            if inst.eatsl % 5 == 0 then
                inst.components.talker:Say("已经吃了: " .. inst.eatsl .. " / " .. jgeatsl .. " 个浆果" ..
                    "\nHave eaten " .. inst.eatsl .. " / " .. jgeatsl .. " berries")
            end
            if not levelmax and inst.eatsl >= jgeatsl then
                inst.eatsj = true
                inst.eatsl = inst.eatsl - jgeatsl
            end
        end

        -- 火龙果和浆果的升级处理  浆果的升级处理依赖于 inst.eatsj 的值
        -- 辣龙椒沙拉、火龙果派、火龙果、烤火龙果
        if (food.prefab == "dragonchilisalad" or food.prefab == "dragonpie" or food.prefab == "dragonfruit" or food.prefab == "dragonfruit_cooked" or inst.eatsj == true) then
            if (levelmax) then
                inst.components.talker:Say("QWQ 满级了!\nQWQ level Max!")
            elseif math.random() > failureFactor * math.tan(inst.level * 0.1) then
                -- inst.jnd 技能点
                inst.level = inst.level + 1
                inst.jnd = inst.jnd + 1
                inst.eatsj = false
                applyupgrades(inst)
                inst.SoundEmitter:PlaySound("dontstarve/characters/wx78/levelup")
            else
                inst.eatsj = false
                inst.components.talker:Say("QWQ 升级失败了!\nlevel up failed!")
            end
        end

        -- 吃芝士蛋糕会降一级
        if (food.prefab == "powcake") and inst.level > 0 then
            inst.level = inst.level - 1
            applyupgrades(inst)
            inst.SoundEmitter:PlaySound("dontstarve/characters/wx78/levelup")
        end
    end
end

local function onpreload(inst, data)
    if data then
        if data.jnd then
            inst.jnd = data.jnd
        else
            inst.jnd = data.level
        end

        if data.je then
            inst.je = data.je
        else
            inst.je = 0
        end

        -- 加载已经吃的浆果数量
        if data.eatsl then
            inst.eatsl = data.eatsl
        else
            inst.eatsl = 0
        end

        if data.level then
            inst.level = data.level
            applyupgrades(inst)
            if data.health and data.health.health then inst.components.health.currenthealth = data.health.health end
            if data.hunger and data.hunger.hunger then inst.components.hunger.current = data.hunger.hunger end
            if data.sanity and data.sanity.current then inst.components.sanity.current = data.sanity.current end
            inst.components.health:DoDelta(0)
            inst.components.hunger:DoDelta(0)
            inst.components.sanity:DoDelta(0)
        end
        applyupgrades(inst)
    end

    if data.absorb then
        inst.components.health.absorb = data.absorb
    end
    if data.hungerrate then
        inst.components.hunger.hungerrate = data.hungerrate
    end
    if data.damagemultiplier then
        inst.components.combat.damagemultiplier = data.damagemultiplier
    end
    if data.inherentinsulation then
        inst.components.temperature.inherentinsulation = data.inherentinsulation
    end
end

local function onsave(inst, data)
    data.level = inst.level
    data.jnd = inst.jnd
    data.je = inst.je

    -- 保存已经吃的浆果数量
    data.eatsl = inst.eatsl

    data.hungerrate = inst.components.hunger.hungerrate or nil
    data.absorb = inst.components.health.absorb or nil
    data.damagemultiplier = inst.components.combat.damagemultiplier or nil
    data.inherentinsulation = inst.components.temperature.inherentinsulation or nil
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
    -- 选择这个角色的声音
    inst.eatsl = 0
    inst.eatsj = false
    inst.level = 0
    inst.jnd = 0
    inst.je = 0
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
    inst.components.health:SetMaxHealth(150)
    inst.components.hunger:SetMax(150)
    inst.components.sanity:SetMax(150)

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
    -- 香蕉奶昔（至少有两个香蕉/烤香蕉，不能有肉度，鱼度，怪物度） 8,25+15,33
    inst.components.foodaffinity:AddPrefabAffinity("bananajuice", TUNING.AFFINITY_15_CALORIES_MED)

    --inst.components.health:StartRegen(1,4)
    -- 增加击杀掉落
    inst:ListenForEvent("killed", onkillother)

    inst.OnSave = onsave
    inst.OnPreLoad = onpreload
    inst.OnLoad = onload
    inst.OnNewSpawn = onload
end

return MakePlayerCharacter("fhl", prefabs, assets, common_postinit, master_postinit)
