require "prefabutil"

local WAKE_TO_FOLLOW_DISTANCE = 4
local SLEEP_NEAR_LEADER_DISTANCE = 6

local assets =
{
    Asset("ANIM", "anim/ui_chester_shadow_3x4.zip"),
    Asset("ANIM", "anim/ui_chest_3x3.zip"),

    Asset("ANIM", "anim/chester.zip"),
    Asset("ANIM", "anim/fhl_licking.zip"),

    Asset("SOUND", "sound/chester.fsb"),

    Asset("ATLAS", "images/map_icons/fhl_data.xml")
}

local prefabs =
{
    "personal_licking_eyebone"
}

local sounds =
{
    hurt = "dontstarve/creatures/chester/hurt",
    pant = "dontstarve/creatures/chester/pant",
    death = "dontstarve/creatures/chester/death",
    open = "dontstarve/creatures/chester/open",
    close = "dontstarve/creatures/chester/close",
    pop = "dontstarve/creatures/chester/pop",
    boing = "dontstarve/creatures/chester/boing",
    lick = "dontstarve/creatures/chester/lick",
}

local function ShouldWakeUp(inst)
    return DefaultWakeTest(inst) or not inst.components.follower:IsNearLeader(WAKE_TO_FOLLOW_DISTANCE)
end

local function ShouldSleep(inst)
    --print(inst, "ShouldSleep", DefaultSleepTest(inst), not inst.sg:HasStateTag("open"), inst.components.follower:IsNearLeader(SLEEP_NEAR_LEADER_DISTANCE))
    return DefaultSleepTest(inst) and not inst.sg:HasStateTag("open") and
        inst.components.follower:IsNearLeader(SLEEP_NEAR_LEADER_DISTANCE) and not TheWorld.state.isfullmoon
end

local function OnOpen(inst)
    if not inst.components.health:IsDead() then
        inst.sg:GoToState("open")
    end
end

local function OnClose(inst)
    if not inst.components.health:IsDead() and inst.sg.currentstate.name ~= "transition" then
        inst.sg.statemem.closing = true
        inst.sg:GoToState("close")
    end
end

-- eye bone was killed/destroyed
local function OnStopFollowing(inst)
    inst:RemoveTag("companion")
end

local function OnStartFollowing(inst)
    inst:AddTag("companion")
end

local function MorphShadowlicking(inst)
    inst.AnimState:SetBuild("fhl_licking")
    inst:RemoveTag("fridge")
    inst:AddTag("spoiler")

    inst.components.container:WidgetSetup("shadowchester")

    local leader = inst.components.follower.leader
    if leader ~= nil then
        inst.components.follower.leader:MorphShadowEyebone()
    end

    inst.lickingState = "SHADOW"
    inst._isshadowlicking:set(true)
end


local function MorphSnowlicking(inst)
    inst.AnimState:SetBuild("fhl_licking")
    inst:RemoveTag("spoiler")
    inst:AddTag("fridge")

    local leader = inst.components.follower.leader
    if leader ~= nil then
        inst.components.follower.leader:MorphSnowEyebone()
    end

    inst.lickingState = "SNOW"
    inst._isshadowlicking:set(false)
end

--[[
local function MorphNormallicking(inst)
    inst.AnimState:SetBuild("fhl_licking")
    inst:RemoveTag("fridge")
    inst:RemoveTag("spoiler")

    inst.components.container:WidgetSetup("chester")

    local leader = inst.components.follower.leader
    if leader ~= nil then
        inst.components.follower.leader:MorphNormalEyebone()
    end

    inst.lickingState = "NORMAL"
    inst._isshadowlicking:set(false)
end
]]


local function CanMorph(inst)
    if inst.lickingState ~= "NORMAL" or not TheWorld.state.isfullmoon then
        return false, false
    end

    local container = inst.components.container
    if container:IsOpen() then
        return false, false
    end

    local canShadow = true
    local canSnow = true

    for i = 1, container:GetNumSlots() do
        local item = container:GetItemInSlot(i)
        if item == nil then
            return false, false
        end

        canShadow = canShadow and item.prefab == "nightmarefuel"
        canSnow = canSnow and item.prefab == "bluegem"

        if not (canShadow or canSnow) then
            return false, false
        end
    end

    return canShadow, canSnow
end


local function CheckForMorph(inst)
    local canShadow, canSnow = CanMorph(inst)
    if canShadow or canSnow then
        inst.sg:GoToState("transition")
    end
end

local function DoMorph(inst, fn)
    inst.MorphChester = nil
    inst:StopWatchingWorldState("isfullmoon", CheckForMorph)
    inst:RemoveEventCallback("onclose", CheckForMorph)
    fn(inst)
end
local function Morphlicking(inst)
    local canShadow, canSnow = CanMorph(inst)
    if not (canShadow or canSnow) then
        return
    end

    local container = inst.components.container
    for i = 1, container:GetNumSlots() do
        container:RemoveItem(container:GetItemInSlot(i)):Remove()
    end

    DoMorph(inst, canShadow and MorphShadowlicking or MorphSnowlicking)
end

local function OnSave(inst, data)
    data.lickingState = inst.lickingState
end

local function OnPreLoad(inst, data)
    if data == nil then
        return
    elseif data.lickingState == "SHADOW" then
        DoMorph(inst, MorphShadowlicking)
    elseif data.lickingState == "SNOW" then
        DoMorph(inst, MorphSnowlicking)
    end
end

local function OnIsShadowlickingDirty(inst)
    if inst._isshadowlicking:value() ~= inst._clientshadowmorphed then
        inst._clientshadowmorphed = inst._isshadowlicking:value()
        inst.replica.container:WidgetSetup(inst._clientshadowmorphed and "shadowchester" or nil)
    end
end

local function RestoreBooks(inst)
    local wickerBonus = 1
    local x, y, z = inst.Transform:GetWorldPosition()
    local players = FindPlayersInRange(x, y, z, TUNING.BOOKSTATION_BONUS_RANGE, true)

    for _, player in ipairs(players) do
        if player:HasTag("bookbuilder") then
            wickerBonus = TUNING.BOOKSTATION_WICKER_BONUS
            break
        end
    end

    for k, v in pairs(inst.components.container.slots) do
        if v:HasTag("book") and v.components.finiteuses then
            local percent = v.components.finiteuses:GetPercent()
            if percent < 1 then
                v.components.finiteuses:SetPercent(
                    math.min(1, percent + (TUNING.BOOKSTATION_RESTORE_AMOUNT * wickerBonus)))
            end
        end
    end
end

local function ItemGet(inst, data)
    if inst.lickingState == "SHADOW" and inst.RestoreTask == nil then
        if inst.components.container:HasItemWithTag("book", 1) then
            inst.RestoreTask = inst:DoPeriodicTask(TUNING.BOOKSTATION_RESTORE_TIME, RestoreBooks)
        end
    end
    if inst.lickingState == "SNOW" and data.item and not data.item:HasTag("frozen") and
        data.item.components.perishable and data.item.components.equippable then
        data.item:AddTag("applefrozen")
        data.item:AddTag("frozen")
    end
end

local function ItemLose(inst, data)
    if inst.RestoreTask ~= nil and not inst.components.container:HasItemWithTag("book", 1) then
        inst.RestoreTask:Cancel()
        inst.RestoreTask = nil
    end
    if data.prev_item and data.prev_item:HasTag("applefrozen") then
        data.prev_item:RemoveTag("applefrozen")
        data.prev_item:RemoveTag("frozen")
    end
end

local function create_licking()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    inst.entity:AddDynamicShadow()
    inst.entity:AddMiniMapEntity()
    inst.entity:AddNetwork()

    MakeCharacterPhysics(inst, 75, .5)
    inst.Physics:SetCollisionGroup(COLLISION.CHARACTERS)
    inst.Physics:ClearCollisionMask()
    inst.Physics:CollidesWith(COLLISION.WORLD)
    inst.Physics:CollidesWith(COLLISION.OBSTACLES)
    inst.Physics:CollidesWith(COLLISION.CHARACTERS)

    inst:AddTag("_named")
    inst:AddTag("character")
    inst:AddTag("companion")
    inst:AddTag("scarytoprey")
    inst:AddTag("noauradamage")
    inst:AddTag("notraptrigger")
    if TUNING.APPLESTORE then
        inst:AddTag("prototyper")
    end

    inst.MiniMapEntity:SetIcon("personal_licking.tex")
    inst.MiniMapEntity:SetCanUseCache(false)

    inst.AnimState:SetBank("fhl_licking")
    inst.AnimState:SetBuild("fhl_licking")

    inst.DynamicShadow:SetSize(2, 1.5)

    inst.Transform:SetFourFaced()

    inst._isshadowlicking = net_bool(inst.GUID, "_isshadowlicking", "onisshadowlickingdirty")

    if TUNING.OPENLI then
        local light = inst.entity:AddLight()
        inst:AddComponent("lighttweener")
        inst.components.lighttweener:StartTween(light, 5, 0.8, 0.5, { 240 / 255, 160 / 255, 200 / 255 }, 0)
        light:Enable(true)
    end

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        inst.OnEntityReplicated = function(inst)
            inst.replica.container:WidgetSetup(inst._isshadowlicking:value() and "shadowchester" or "chester")
        end
        inst._clientshadowmorphed = false
        inst:ListenForEvent("onisshadowlickingdirty", OnIsShadowlickingDirty)
        return inst
    end

    -- licking will not be saved normally. He is saved with the player.
    inst.persists = false

    ------------------------------------------
    inst:AddComponent("health")
    inst.components.health:SetMaxHealth(TUNING.CHESTER_HEALTH)
    inst.components.health:StartRegen(TUNING.CHESTER_HEALTH_REGEN_AMOUNT, TUNING.CHESTER_HEALTH_REGEN_PERIOD)

    inst:AddComponent("inspectable")
    inst.components.inspectable:RecordViews()
    --inst.components.inspectable.getstatus = GetStatus
    inst.components.inspectable.nameoverride = "licking"

    inst:AddComponent("locomotor")
    inst.components.locomotor.walkspeed = 14
    inst.components.locomotor.runspeed = 14

    inst:AddComponent("follower")
    inst:ListenForEvent("stopfollowing", OnStopFollowing)
    inst:ListenForEvent("startfollowing", OnStartFollowing)

    inst:AddComponent("knownlocations")

    if TUNING.APPLESTORE then
        inst:AddComponent("prototyper")
        inst.components.prototyper.trees = TUNING.PROTOTYPER_TREES.APPLESTORE
    end

    inst:AddComponent("container")
    inst.components.container:WidgetSetup("chester")
    inst.components.container.onopenfn = OnOpen
    inst.components.container.onclosefn = OnClose

    inst:AddComponent("sleeper")
    inst.components.sleeper:SetResistance(3)
    inst.components.sleeper.testperiod = GetRandomWithVariance(6, 2)
    inst.components.sleeper:SetSleepTest(ShouldSleep)
    inst.components.sleeper:SetWakeTest(ShouldWakeUp)

    inst:AddComponent("named")

    local brain = require "brains/lickingbrain"
    inst:SetBrain(brain)
    inst:SetStateGraph("SGchester")
    inst.sg:GoToState("idle")

    inst.lickingState = "NORMAL"
    inst.MorphChester = Morphlicking
    inst:WatchWorldState("isfullmoon", CheckForMorph)
    inst:ListenForEvent("onclose", CheckForMorph)

    inst.sounds = sounds

    inst.OnSave = OnSave
    inst.OnPreLoad = OnPreLoad

    inst:ListenForEvent("itemget", ItemGet)
    inst:ListenForEvent("itemlose", ItemLose)

    MakeHauntableDropFirstItem(inst)
    MakeSmallBurnableCharacter(inst, "licking_body")
    AddHauntableCustomReaction(inst, function(inst, haunter)
        if math.random() <= TUNING.HAUNT_CHANCE_ALWAYS then
            inst.components.hauntable.panic = true
            inst.components.hauntable.panictimer = TUNING.HAUNT_PANIC_TIME_SMALL
            inst.components.hauntable.hauntvalue = TUNING.HAUNT_SMALL
            return true
        end
        return false
    end, false, false, true)

    return inst
end

return Prefab("common/personal_licking", create_licking, assets, prefabs)
