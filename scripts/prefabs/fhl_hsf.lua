local assets =
{
    Asset("ANIM", "anim/fhl_hsf.zip"),
    Asset("ATLAS", "images/inventoryimages/fhl_hsf.xml")
}

local function OnEquip(inst, owner)
    inst.components.fueled:StartConsuming()
    owner.AnimState:OverrideSymbol("swap_hat", "fhl_hsf", "swap_hat")

    if TUNING.BUFFGO and inst.components.fueled then
        inst.consumefn = function(owner, data)
            if data.amount > 0 then return end
            local fuelrate = TUNING.SKILL_TREE and 0.01 or 0.02
            inst.components.fueled:DoDelta(-fuelrate * inst.components.fueled.maxfuel)
        end
        inst:AddTag("bramble_resistant")
        inst:AddTag("foodharm_resistant")
        inst:ListenForEvent("healthdelta", inst.consumefn, owner)
        owner.components.health.externalabsorbmodifiers:SetModifier(inst, 0.5)
    end
end

local function OnUnequip(inst, owner)
    if TUNING.BUFFGO and inst.components.fueled then
        inst:RemoveEventCallback("healthdelta", inst.consumefn, owner)
        owner.components.health.externalabsorbmodifiers:RemoveModifier(inst)
    end

    inst.components.container:Close()
    inst.components.fueled:StopConsuming()
    owner.AnimState:ClearOverrideSymbol("swap_hat")
end

local function OnEquipToModel(inst, owner)
    if TUNING.BUFFGO and inst.components.fueled then
        inst:RemoveEventCallback("healthdelta", inst.consumefn, owner)
        owner.components.health.externalabsorbmodifiers:RemoveModifier(inst)
    end

    inst.components.fueled:StopConsuming()
end

local function OnDepleted(inst)
    if inst.components.container:IsEmpty() then
        inst:Remove()
    else
        local item = inst.components.container:GetItemInSlot(1)
        if item.prefab == "ancient_soul" then
            inst.components.fueled:DoDelta(inst.components.fueled.maxfuel * 0.5)
            item:Remove()
        else
            inst.components.container:DropEverything()
            inst:Remove()
        end
    end
end

local function UpdateHSFAddon(inst)
    if inst.components.container:IsEmpty() then
        inst.components.equippable.dapperness = 1
        inst.components.planardefense:SetBaseDefense(0)
    else
        local item = inst.components.container:GetItemInSlot(1)
        if item.prefab == "horrorfuel" then
            inst.components.equippable.dapperness = -2
        elseif item.prefab == "purebrilliance" then
            inst.components.planardefense:SetBaseDefense(20)
        elseif item.prefab == "ancient_soul" and not inst.components.fueled:IsFull() then
            inst.components.fueled:DoDelta(inst.components.fueled.maxfuel * 0.5)
            item:Remove()
        else
            local owner = item.components.inventoryitem:GetGrandOwner()
            owner.components.talker:Say("Durability is full!")
        end
    end
end

local function fn(Sim)
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddNetwork()

    MakeInventoryPhysics(inst)

    inst.AnimState:SetBank("fhl_hsf")
    inst.AnimState:SetBuild("fhl_hsf")
    inst.AnimState:PlayAnimation("idel")

    inst:AddTag("sharp")
    inst:AddTag("cattoy")
    inst:AddTag("nosteal")

    inst.entity:SetPristine()
    if not TheWorld.ismastersim then
        inst.OnEntityReplicated = function(inst)
            inst.replica.container:WidgetSetup("hsf_addon")
        end
        return inst
    end

    inst:AddComponent("inspectable")

    inst:AddComponent("inventoryitem")
    inst.components.inventoryitem.atlasname = "images/inventoryimages/fhl_hsf.xml"

    inst:AddComponent("waterproofer")
    inst.components.waterproofer:SetEffectiveness(0)

    inst:AddComponent("fueled")
    local fuelLevel = TUNING.SKILL_TREE and 10 or 2
    inst.components.fueled.fueltype = FUELTYPE.MAGIC
    inst.components.fueled:SetDepletedFn(OnDepleted)
    inst.components.fueled:InitializeFuelLevel(fuelLevel * TUNING.TOTAL_DAY_TIME)

    inst:AddComponent("equippable")
    inst.components.equippable.equipslot = EQUIPSLOTS.HEAD
    inst.components.equippable.dapperness = 1
    inst.components.equippable.is_magic_dapperness = true
    inst.components.equippable:SetOnEquip(OnEquip)
    inst.components.equippable:SetOnUnequip(OnUnequip)
    inst.components.equippable:SetOnEquipToModel(OnEquipToModel)

    inst:AddComponent("planardefense")

    inst:AddComponent("hauntable")
    if TUNING.HSF_RESPAWN == 1 then
        inst.components.hauntable:SetOnHauntFn(function(inst, haunter)
            if haunter:HasTag("playerghost") then
                haunter:PushEvent("respawnfromghost", { source = inst })
                inst:Remove()
                return true
            end
            return false
        end)
    elseif TUNING.HSF_RESPAWN == -1 then
        inst.components.hauntable:SetHauntValue(TUNING.HAUNT_INSTANT_REZ)
    end

    inst:AddComponent("container")
    inst.components.container:WidgetSetup("hsf_addon")
    inst.components.container.acceptsstacks = false

    inst:ListenForEvent("itemget", UpdateHSFAddon)
    inst:ListenForEvent("itemlose", UpdateHSFAddon)

    return inst
end

return Prefab("common/inventory/fhl_hsf", fn, assets)
