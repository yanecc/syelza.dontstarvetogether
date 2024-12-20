local MakePlayerCharacter = require "prefabs/player_common"

local assets =
{
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
    "ancient_soul"
}

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
    if TUNING.OPENLIGHT and (TheWorld:HasTag("cave") or TheWorld.state.isnight) then
        inst.Light:Enable(true)
        inst.Light:SetRadius(6)
        inst.Light:SetFalloff(.8)
        inst.Light:SetIntensity(.8)
        inst.Light:SetColour(237 / 255, 237 / 255, 209 / 255)
    else
        inst.Light:Enable(false)
    end
end

local function ApplyUpgrades(inst)
    inst.level = math.min(inst.level, 10)
    local growth = inst.level * TUNING.FHL_GROWTH
    local pointsKey = TUNING.SKILL_POINT_KEY:sub(-1)
    local statusKey = TUNING.STATUS_KEY:sub(-1)

    inst.components.hunger.max = TUNING.FHL_HUNGER + growth       --300
    inst.components.health.maxhealth = TUNING.FHL_HEALTH + growth --300
    inst.components.sanity.max = TUNING.FHL_SANITY + growth       --300
    inst.components.hunger:DoDelta(0)
    inst.components.health:DoDelta(0)
    inst.components.sanity:DoDelta(0)

    inst.components.locomotor.walkspeed = math.ceil(6 + inst.level / 3) --10
    inst.components.locomotor.runspeed = math.ceil(8 + inst.level / 3)  --12

    local message = inst.level == 10 and "W.W Level Max!" or "QWQ Level now: " .. inst.level
    inst.components.talker:Say(message ..
        "\n你还有" .. inst.jnd .. "点技能点!" ..
        "\n加点帮助请按" .. pointsKey .. ",当前状态请按" .. statusKey .. "!" ..
        "\nyou have " .. inst.jnd .. " skill points!" ..
        "\nClick " .. pointsKey .. " for HELP, Click " .. statusKey .. " for STATE!")
end

local function EatBonus(inst, health_delta, hunger_delta, sanity_delta, food, feeder)
    if debugstack():rfind_plain("scripts/components/eater.lua") then
        local berryUp = TUNING.JGEAT                        -- 吃浆果升级
        local berryLimit = TUNING.JGEATSL                   -- 吃浆果升级的临界值
        local levelmax = inst.level == 10                   -- 是否已满级
        local failureFactor = TUNING.LEVELUP_FAILURE_FACTOR -- 升级失败的概率

        -- 浆果、烤浆果、多汁浆果、烤多汁浆果
        -- 吃浆果可以升级，满级以后获取技能点只能吃火龙果
        if berryUp and table.contains({ "berries", "berries_cooked", "berries_juicy", "berries_juicy_cooked" }, food.prefab) then
            inst.berrycount = inst.berrycount + 1
            if inst.berrycount % 5 == 0 then
                inst.components.talker:Say("已经吃了: " .. inst.berrycount .. " / " .. berryLimit .. " 个浆果" ..
                    "\nHave eaten " .. inst.berrycount .. " / " .. berryLimit .. " berries")
            end
            if not levelmax and inst.berrycount >= berryLimit then
                inst.berryenough = true
                inst.berrycount = inst.berrycount - berryLimit
            end
        end

        -- 火龙果、烤火龙果、火龙果派、辣龙椒沙拉
        if table.contains({ "dragonfruit", "dragonfruit_cooked", "dragonpie", "dragonchilisalad" }, food.prefab) or
            food.prefab:find("dragonpie_spice") or food.prefab:find("dragonchilisalad_spice") or inst.berryenough then
            local hasGoodLuck = math.random() > failureFactor * math.tan(inst.level * 0.1)
            -- 满级以后再吃浆果inst.berryenough不会为true
            if levelmax then
                if inst.totalpoints < 42 and hasGoodLuck then
                    local points = math.max(inst.totalpoints + 1, inst.level, inst.jnd)
                    inst.totalpoints = points
                    inst.jnd = inst.jnd + 1
                    ApplyUpgrades(inst)
                    inst.SoundEmitter:PlaySound("dontstarve/characters/wx78/levelup")
                else
                    inst.components.talker:Say("QWQ 满级了! 没获得技能点!\nQWQ level Max! Got no skill point!")
                end
            elseif hasGoodLuck then
                -- inst.jnd 技能点
                -- inst.totalpoints 总技能点42可以将全部方向点满 抗寒8 减伤16 增伤10 抗饿8
                if inst.totalpoints < 42 then
                    local points = math.max(inst.totalpoints + 1, inst.level, inst.jnd)
                    inst.totalpoints = points
                    inst.jnd = inst.jnd + 1
                end
                inst.level = inst.level + 1
                inst.berryenough = false
                ApplyUpgrades(inst)
                inst.SoundEmitter:PlaySound("dontstarve/characters/wx78/levelup")
            else
                inst.berryenough = false
                inst.components.talker:Say("QWQ 升级失败了!\nlevel up failed!")
            end
        end

        -- 吃芝士蛋糕会重置等级和技能点，必须等级大于0才能洗点
        if food.prefab == "powcake" and inst.level > 0 then
            inst.level = 0
            inst.jnd = inst.totalpoints
            inst.je = 0
            inst.components.health.absorb = 0
            inst.components.combat.damagemultiplier = 1
            inst.components.temperature.inherentinsulation = 0
            inst.components.hunger.hungerrate = TUNING.WILSON_HUNGER_RATE
            ApplyUpgrades(inst)
            inst.SoundEmitter:PlaySound("dontstarve/characters/wx78/levelup")
        end
    end

    return health_delta, hunger_delta, sanity_delta
end

local function GiveNewBell(inst)
    local bell = SpawnPrefab("personal_licking_eyebone")
    if bell then
        bell.owner = inst
        inst.lickingbone = bell
        inst.components.inventory.ignoresound = true
        inst.components.inventory:GiveItem(bell)
        inst.components.inventory.ignoresound = false
        bell.components.named:SetName(inst.name .. "的铃铛")
        return bell
    end
end

local function GetSpawnPoint(pt)
    local theta = math.random() * 2 * PI
    local radius = 4
    local offset = FindWalkableOffset(pt, theta, radius, 12, true)
    return offset ~= nil and (pt + offset) or nil
end

local function ReturnBell(inst)
    if inst.lickingbone and inst.lickingbone:IsValid() then
        if inst.lickingbone.components.inventoryitem.owner ~= inst then
            inst.components.inventory:GiveItem(inst.lickingbone)
        end
    else
        GiveNewBell(inst)
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

local function ondeath(inst, data)
    if inst.licking then
        inst.licking.components.health:Kill()
    end
    if inst.lickingbone then
        inst.lickingbone:Remove()
    end
end

local function OnDespawn(inst)
    local apple = inst.licking
    local bell = inst.lickingbone

    inst.bellinv = bell and bell.components.inventoryitem:IsHeld() and
        bell.components.inventoryitem:GetGrandOwner().components.inventory and true
    if apple and apple:IsValid() and apple.components.container then
        if GetGameModeProperty("drop_everything_on_despawn") then
            apple.components.container:DropEverything()
        else
            apple.components.container:DropEverythingWithTag("irreplaceable")
        end
        apple:DoTaskInTime(FRAMES, apple.Remove)
    end
    if bell ~= nil and bell:IsValid() then
        bell:DoTaskInTime(FRAMES, bell.Remove)
    end
end

local function OnNewSpawn(inst)
    ApplyUpgrades(inst)
    GiveNewBell(inst)
    inst:DoTaskInTime(2, function()
        if inst.licking and inst.applestate then
            inst.licking:ForceMorph(inst.applestate)
        end
    end)
end

local function OnPreLoad(inst, data)
    inst.je = data.je or 0
    inst.level = data.level or 0
    inst.jnd = data.jnd or inst.level
    inst.berrycount = data.berrycount or 0
    inst.zzjFeedBack = data.zzjFeedBack or 0
    inst.totalpoints = data.totalpoints or inst.jnd

    ApplyUpgrades(inst)

    inst.components.health.absorb = data.absorb or 0.00
    inst.components.hunger.hungerrate = data.hungerrate or TUNING.WILSON_HUNGER_RATE
    inst.components.combat.damagemultiplier = data.damagemultiplier or 1.00
    inst.components.temperature.inherentinsulation = data.inherentinsulation or 0.00
end

local function OnLoad(inst, data)
    inst.lickingbone = data.lickingbone and SpawnSaveRecord(data.lickingbone)
    if inst.lickingbone and data.licking then
        inst.lickingbone.owner = inst
        inst.licking = SpawnSaveRecord(data.licking)
        if inst.licking then
            inst.lickingbone:RebindLicking(inst.licking)
        end
        inst:DoTaskInTime(0, function(inst)
            if data.bellinv or inst.lickingbone:IsNear(inst, 1) then
                inst:ReturnBell()
            end
        end)
    else
        GiveNewBell(inst)
    end
end

local function OnSave(inst, data)
    data.je = inst.je
    data.jnd = inst.jnd
    data.level = inst.level
    data.berrycount = inst.berrycount
    data.totalpoints = inst.totalpoints
    data.zzjFeedBack = inst.zzjFeedBack

    data.hungerrate = inst.components.hunger.hungerrate
    data.absorb = inst.components.health.absorb
    data.damagemultiplier = inst.components.combat.damagemultiplier
    data.inherentinsulation = inst.components.temperature.inherentinsulation

    data.lickingbone = inst.lickingbone and inst.lickingbone:GetSaveRecord()
    data.licking = inst.licking and inst.licking:GetSaveRecord()
    data.bellinv = inst.bellinv
end

-- 服务器和客户端初始化，添加标签
local common_postinit = function(inst)
    -- 小地图图标
    inst.MiniMapEntity:SetIcon("fhl.tex")
    inst.soundsname = "willow"
    inst:AddTag("fhl")
    inst:AddTag("bookbuilder")
end

-- 服务器端初始化，添加组件
local master_postinit = function(inst)
    inst.je = 0
    inst.jnd = 0
    inst.level = 0
    inst.berrycount = 0
    inst.totalpoints = 0
    inst.zzjFeedBack = 0
    inst.starting_inventory = start_inv

    inst.licking = nil
    inst.lickingbone = nil
    inst.ReturnBell = ReturnBell

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
    inst.components.locomotor.walkspeed = 6
    inst.components.locomotor.runspeed = 8
    inst.components.slipperyfeet.threshold = 48
    inst.components.eater.custom_stats_mod_fn = EatBonus

    inst.components.health.absorb = 0.00
    inst.components.combat.damagemultiplier = 1.00
    inst.components.temperature.inherentinsulation = 0
    inst.components.hunger.hungerrate = TUNING.WILSON_HUNGER_RATE

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

    inst.OnSave = OnSave
    inst.OnLoad = OnLoad
    inst.OnPreLoad = OnPreLoad
    inst.OnDespawn = OnDespawn
    inst.OnNewSpawn = OnNewSpawn

    -- 增加击杀掉落
    inst:ListenForEvent("killed", OnKillOther)
    if TheNet:GetServerGameMode() == "wilderness" then
        inst:ListenForEvent("death", ondeath)
    end
    inst:ListenForEvent("ms_playerreroll", inst.OnDespawn)
    inst:ListenForEvent("ms_respawnedfromghost", ApplyUpgrades)
    inst:ListenForEvent("ms_playerseamlessswaped", inst.OnNewSpawn)
end

return MakePlayerCharacter("fhl", prefabs, assets, common_postinit, master_postinit)
