local assets =
{
    Asset("ANIM", "anim/licking_eyebone.zip"),

    Asset("ATLAS", "images/map_icons/fhl_data.xml"),
    Asset("ATLAS", "images/inventoryimages/licking_eyebone.xml")
}

local prefabs =
{
    "personal_licking"
}

local SPAWN_DIST = 30

local function OpenEye(inst)
    inst.isOpenEye = true
    inst.components.inventoryitem:ChangeImageName(inst.openEye)
end

local function CloseEye(inst)
    inst.isOpenEye = nil
    inst.components.inventoryitem:ChangeImageName(inst.closedEye)
end

local function RefreshEye(inst)
    if inst.isOpenEye then
        OpenEye(inst)
    else
        CloseEye(inst)
    end
end

local function MorphShadowEyebone(inst)
    inst.AnimState:SetBuild("licking_eyebone")

    inst.openEye = "licking_eyebone"
    inst.closedEye = "licking_eyebone"
    RefreshEye(inst)

    inst.EyeboneState = "SHADOW"
end

local function MorphSnowEyebone(inst)
    inst.AnimState:SetBuild("licking_eyebone")

    inst.openEye = "licking_eyebone"
    inst.closedEye = "licking_eyebone"
    RefreshEye(inst)

    inst.EyeboneState = "SNOW"
end

--[[
local function MorphNormalEyebone(inst)
    inst.AnimState:SetBuild("licking_eyebone")

    inst.openEye = "licking_eyebone"
    inst.closedEye = "licking_eyebone_closed"
    RefreshEye(inst)

    inst.EyeboneState = "NORMAL"
end
]]

local function GetSpawnPoint(pt)
    local theta = math.random() * 2 * PI
    local radius = SPAWN_DIST
    local offset = FindWalkableOffset(pt, theta, radius, 12, true)
    return offset ~= nil and (pt + offset) or nil
end

local function Spawnlicking(inst)
    if not inst.owner then
        print("Error: Eyebone has no linked player!")
        return
    end

    local pt = inst:GetPosition()

    local spawn_pt = GetSpawnPoint(pt)
    if spawn_pt ~= nil then
        local licking = SpawnPrefab("personal_licking")
        if licking ~= nil then
            licking.Physics:Teleport(spawn_pt:Get())
            licking:FacePoint(pt:Get())
            if inst.owner then
                inst.owner.licking = licking
            end
            return licking
        end
    end
end

local StartRespawn

local function StopRespawn(inst)
    if inst.respawntask ~= nil then
        inst.respawntask:Cancel()
        inst.respawntask = nil
        inst.respawntime = nil
    end
end

local function RebindLicking(inst, licking)
    licking = licking or (inst.owner and inst.owner.licking)
    if licking ~= nil then
        if inst.owner then
            licking.components.named:SetName(inst.owner.name .. "的苹果")
        end
        inst.AnimState:PlayAnimation("idle_loop", true)
        OpenEye(inst)
        inst:ListenForEvent("death", function()
            if inst.owner then
                inst.owner.licking = nil
            end
            StartRespawn(inst, TUNING.CHESTER_RESPAWN_TIME)
        end, licking)

        if licking.components.follower.leader ~= inst then
            licking.components.follower:SetLeader(inst)
        end
        return true
    end
end

local function Respawnlicking(inst)
    StopRespawn(inst)
    RebindLicking(inst, (inst.owner and inst.owner.licking) or Spawnlicking(inst))
end

StartRespawn = function(inst, time)
    StopRespawn(inst)

    time = time or 0
    inst.respawntask = inst:DoTaskInTime(time, Respawnlicking)
    inst.respawntime = GetTime() + time
    inst.AnimState:PlayAnimation("dead", true)
    CloseEye(inst)
end

local function FixLicking(inst)
    inst.fixtask = nil
    if not RebindLicking(inst) then
        inst.AnimState:PlayAnimation("dead", true)
        CloseEye(inst)

        if inst.components.inventoryitem.owner ~= nil then
            local time_remaining = 0
            local time = GetTime()
            if inst.respawntime and inst.respawntime > time then
                time_remaining = inst.respawntime - time
            end
            StartRespawn(inst, time_remaining)
        end
    end
end

local function OnPickUp(inst)
    if inst.fixtask == nil then
        inst.fixtask = inst:DoTaskInTime(1, FixLicking)
    end
    -- 仅在物品栏中有效，放入背包或箱子不行
    local owner = inst.components.inventoryitem:GetGrandOwner()
    if owner == nil then return end
    if inst.components.inventoryitem:IsHeldBy(owner) then
        owner:AddTag("bellholder")
    else
        owner:RemoveTag("bellholder")
    end
end

local function OnRemoved(self)
    local owner = self.inst.components.inventoryitem:GetGrandOwner()
    if owner then owner:RemoveTag("bellholder") end

    if self.owner then
        self.owner:RemoveChild(self.inst)
    end
    self:ClearOwner()
    self.inst:ReturnToScene()
    self:WakeLivingItem()
end

local function OnSave(inst, data)
    if inst.respawntime ~= nil then
        local time = GetTime()
        if inst.respawntime > time then
            data.respawntimeremaining = inst.respawntime - time
        end
    end
end

local function OnLoad(inst, data)
    if data == nil then
        return
    end

    if data.EyeboneState == "SHADOW" then
        MorphShadowEyebone(inst)
    elseif data.EyeboneState == "SNOW" then
        MorphSnowEyebone(inst)
    end

    if data.respawntimeremaining ~= nil then
        inst.respawntime = data.respawntimeremaining + GetTime()
    end
end


local function GetStatus(inst)
    if inst.respawntask ~= nil then
        return "WAITING"
    end
end

local function fn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddMiniMapEntity()
    inst.entity:AddNetwork()

    MakeInventoryPhysics(inst)
    inst.Transform:SetScale(1.2, 1.2, 1.2)

    inst:AddTag("_named")
    inst:AddTag("nosteal")
    inst:AddTag("nonpotatable")
    inst:AddTag("irreplaceable")

    inst.MiniMapEntity:SetIcon("personal_licking_eyebone.tex")

    inst.AnimState:SetBank("licking_eyebone")
    inst.AnimState:SetBuild("licking_eyebone")
    inst.AnimState:PlayAnimation("idle_loop", true)

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    inst.persists = false

    inst:AddComponent("inventoryitem")
    inst.components.inventoryitem.atlasname = "images/inventoryimages/licking_eyebone.xml"
    inst.components.inventoryitem:ChangeImageName("licking_eyebone")
    inst.components.inventoryitem.OnRemoved = OnRemoved
    inst.components.inventoryitem:SetOnPickupFn(OnPickUp)
    inst.components.inventoryitem:SetOnPutInInventoryFn(OnPickUp)

    inst.EyeboneState = "NORMAL"
    inst.openEye = "licking_eyebone"
    inst.closedEye = "licking_eyebone"

    inst.isOpenEye = nil
    OpenEye(inst)

    inst:AddComponent("inspectable")
    inst.components.inspectable.getstatus = GetStatus
    inst.components.inspectable:RecordViews()
    inst.components.inspectable.nameoverride = "licking_eyebone"

    inst:AddComponent("named")

    inst:AddComponent("leader")

    MakeHauntableLaunch(inst)

    inst.MorphSnowEyebone = MorphSnowEyebone
    inst.MorphShadowEyebone = MorphShadowEyebone

    inst.OnLoad = OnLoad
    inst.OnSave = OnSave

    inst.fixtask = inst:DoTaskInTime(1, FixLicking)
    inst.RebindLicking = RebindLicking

    return inst
end

return Prefab("common/inventory/personal_licking_eyebone", fn, assets, prefabs)
