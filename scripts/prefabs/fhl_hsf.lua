local assets =
{
    Asset("ANIM", "anim/fhl_hsf.zip"),
    Asset("ATLAS", "images/inventoryimages/fhl_hsf.xml")
}

local function AvoidShadowAggro(inst, owner, isworking)
    if not owner.components.combat then return end
    if isworking then
        inst._shouldavoidaggrofn = owner.components.combat.shouldavoidaggrofn
        owner.components.combat.shouldavoidaggrofn = function(attacker, owner)
            return not attacker:HasAnyTag("shadowcreature", "nightmarecreature") or -- 是暗影生物
                attacker.components.combat.lastattacker == owner                    -- 返回true才能攻击
        end
    else
        owner.components.combat.shouldavoidaggrofn = inst._shouldavoidaggrofn
    end
end

local function ResistGrogginess(inst, owner, isworking)
    if not owner.components.grogginess then return end
    if isworking then
        inst._enablespeedmod = owner.components.grogginess.enablespeedmod
        inst._knockouttestfn = owner.components.grogginess.knockouttestfn
        owner.components.grogginess.knockouttestfn = function() return false end
        owner.components.grogginess:SetEnableSpeedMod(false)
    else
        owner.components.grogginess:ResetGrogginess()
        owner.components.grogginess:SetKnockOutTest(inst._knockouttestfn)
        owner.components.grogginess:SetEnableSpeedMod(inst._enablespeedmod)
    end
end

local function LevitateHeavy(inst, owner, isworking)
    if isworking then
        owner:PushEvent("glommerup")
        owner:AddTag("glommerprayer")
    else
        owner:PushEvent("glommerdown")
        owner:RemoveTag("glommerprayer")
    end
end

local function ResistSlip(inst, owner, isworking)
    if isworking then
        inst._slipthreshold = owner.components.slipperyfeet.threshold
        owner.components.slipperyfeet.threshold = 100000
    else
        owner.components.slipperyfeet.slippiness = 0
        owner.components.slipperyfeet.threshold = inst._slipthreshold
    end
end

local function ReduceDamage(inst, owner, isworking)
    if isworking then
        inst._deltamodifierfn = owner.components.health.deltamodifierfn
        owner.components.health.deltamodifierfn = function(owner, amount, overtime, cause, ig_inv, afflicter, ig_abs)
            if amount < 0 and not (overtime or cause == "acidrain" or cause == "poison") then
                local fuelrate = TUNING.SKILL_TREE and owner:HasTag("fhl") and 0.015 or 0.02
                inst.components.fueled:DoDelta(-fuelrate * inst.components.fueled.maxfuel)
                amount = amount / 2
            end
            return inst._deltamodifierfn == nil and amount or
                inst._deltamodifierfn(owner, amount, overtime, cause, ig_inv, afflicter, ig_abs)
        end
    else
        owner.components.health.deltamodifierfn = inst._deltamodifierfn
    end
end

local function OnEquip(inst, owner)
    inst.components.fueled:StartConsuming()
    owner.AnimState:OverrideSymbol("swap_hat", "fhl_hsf", "swap_hat")
    if inst.components.container:Has("purebrilliance", 1) then
        ResistGrogginess(inst, owner, true)
    elseif inst.components.container:Has("horrorfuel", 1) then
        AvoidShadowAggro(inst, owner, true)
    elseif inst.components.container:Has("glommerwings", 1) then
        LevitateHeavy(inst, owner, true)
        ResistSlip(inst, owner, true)
    end

    if TUNING.BUFFGO then
        ReduceDamage(inst, owner, true)
        inst:AddTag("bramble_resistant")
        inst:AddTag("foodharm_resistant")
    end
end

local function OnUnequip(inst, owner)
    if TUNING.BUFFGO then
        ReduceDamage(inst, owner, false)
    end

    inst.components.container:Close()
    inst.components.fueled:StopConsuming()
    owner.AnimState:ClearOverrideSymbol("swap_hat")
    AvoidShadowAggro(inst, owner, false)
    ResistGrogginess(inst, owner, false)
    LevitateHeavy(inst, owner, false)
    ResistSlip(inst, owner, false)
end

local function OnEquipToModel(inst, owner)
    inst.components.fueled:StopConsuming()
    owner.components.health.deltamodifierfn = nil
end

local function CanAddFuel(inst, item, doer)
    if inst.components.fueled:IsFull() then
        doer:DoTaskInTime(0, function()
            doer.components.talker:Say("Durability is full!")
        end)
        return false
    end
    return true
end

local function OnFuelChanged(inst, data)
    if TUNING.SKILL_TREE and data.percent < 1 then
        inst:AddTag("needssewing")
    else
        inst:RemoveTag("needssewing")
    end
end

local function OnDepleted(inst)
    if inst.components.container:IsEmpty() then
        inst:Remove()
    else
        local item = inst.components.container:GetItemInSlot(1)
        if item.prefab == "ancient_soul" then
            inst.components.fueled:TakeFuelItem(item)
        else
            inst.components.container:DropEverything()
            inst:Remove()
        end
    end
end

local function UpdateHSFAddon(inst)
    local item = inst.components.container:GetItemInSlot(1)
    local owner = inst.components.inventoryitem:GetGrandOwner()
    if item == nil then
        inst:RemoveTag("acidrainimmune")
        inst:RemoveTag("gestaltprotection")
        inst.components.equippable.dapperness = 1
        cleartable(inst.components.resistance.tags)
        inst.components.planardefense:SetBaseDefense(0)
        if owner ~= nil then
            ResistSlip(inst, owner, false)
            LevitateHeavy(inst, owner, false)
            AvoidShadowAggro(inst, owner, false)
            ResistGrogginess(inst, owner, false)
        end
    elseif item.prefab == "horrorfuel" then
        inst:AddTag("acidrainimmune")
        inst.components.equippable.dapperness = -2
        if inst.components.equippable:IsEquipped() and owner ~= nil then
            AvoidShadowAggro(inst, owner, true)
        end
    elseif item.prefab == "purebrilliance" then
        inst:AddTag("gestaltprotection")
        inst.components.planardefense:SetBaseDefense(20)
        if inst.components.equippable:IsEquipped() and owner ~= nil then
            ResistGrogginess(inst, owner, true)
        end
    elseif item.prefab == "glommerwings" then
        inst.components.resistance:AddResistance("coconut")
        inst.components.resistance:AddResistance("stonefruit")
        inst.components.resistance:AddResistance("quakedebris")
        inst.components.resistance:AddResistance("caveindebris")
        inst.components.resistance:AddResistance("lunarhaildebris")
        if inst.components.equippable:IsEquipped() and owner ~= nil then
            LevitateHeavy(inst, owner, true)
            ResistSlip(inst, owner, true)
        end
    end
end

local function fn()
    local inst = CreateEntity()
    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddNetwork()

    MakeInventoryPhysics(inst)
    inst.Transform:SetScale(1.2, 1.2, 1.2)

    inst:AddTag("sharp")
    inst:AddTag("cattoy")
    inst:AddTag("nosteal")
    inst:AddTag("open_top_hat")

    inst.AnimState:SetBank("fhl_hsf")
    inst.AnimState:SetBuild("fhl_hsf")
    inst.AnimState:PlayAnimation("idel")

    inst.entity:SetPristine()
    if not TheWorld.ismastersim then
        return inst
    end

    inst:AddComponent("inspectable")

    inst:AddComponent("inventoryitem")
    inst.components.inventoryitem.atlasname = "images/inventoryimages/fhl_hsf.xml"
    inst.components.inventoryitem:EnableMoisture(false)

    inst:AddComponent("fueled")
    inst.components.fueled.fueltype = FUELTYPE.ANCIENTSOUL
    inst.components.fueled.accepting = true
    inst.components.fueled.bonusmult = 5
    inst.components.fueled:SetDepletedFn(OnDepleted)
    inst.components.fueled:SetCanTakeFuelItemFn(CanAddFuel)
    inst.components.fueled:InitializeFuelLevel(10 * TUNING.TOTAL_DAY_TIME)

    inst:AddComponent("equippable")
    inst.components.equippable.equipslot = EQUIPSLOTS.HEAD
    inst.components.equippable.dapperness = 1
    inst.components.equippable.is_magic_dapperness = true
    inst.components.equippable:SetOnEquip(OnEquip)
    inst.components.equippable:SetOnUnequip(OnUnequip)
    inst.components.equippable:SetOnEquipToModel(OnEquipToModel)

    inst:AddComponent("planardefense")

    inst:AddComponent("resistance")

    inst:AddComponent("hauntable")
    if TUNING.HSF_RESPAWN == 1 then -- 复活1次后消失
        inst.components.hauntable:SetOnHauntFn(function(inst, haunter)
            if haunter:HasTag("playerghost") then
                haunter:PushEvent("respawnfromghost", { source = inst })
                inst.components.container:DropEverything()
                inst:Remove()
                return true
            end
            return false
        end)
    elseif TUNING.HSF_RESPAWN == 2 then -- 复活1次后失效
        inst.components.hauntable.hauntvalue = TUNING.HAUNT_INSTANT_REZ
    elseif TUNING.HSF_RESPAWN == 3 then -- 无限复活
        inst.components.hauntable:SetHauntValue(TUNING.HAUNT_INSTANT_REZ)
    end

    inst:AddComponent("container")
    inst.components.container:WidgetSetup("fhl_hsf")
    inst.components.container.acceptsstacks = false

    inst:ListenForEvent("itemget", UpdateHSFAddon)
    inst:ListenForEvent("itemlose", UpdateHSFAddon)
    inst:ListenForEvent("percentusedchange", OnFuelChanged)

    return inst
end

return Prefab("common/inventory/fhl_hsf", fn, assets)
