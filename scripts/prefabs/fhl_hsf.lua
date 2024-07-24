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
            if data.amount > -1 then return end
            for k, v in pairs(owner.components.inventory.equipslots) do
                if v and v:HasTag("hsf_protection") then
                    local fuelrate = TUNING.SKILL_TREE and 0.01 or 0.02
                    inst.components.fueled:DoDelta(-fuelrate * inst.components.fueled.maxfuel)
                    break
                end
            end
        end
        inst:AddTag("hsf_protection")
        inst:AddTag("bramble_resistant")
        inst:AddTag("foodharm_resistant")
        owner:ListenForEvent("healthdelta", inst.consumefn)
        owner.components.health.externalabsorbmodifiers:SetModifier(inst, 0.5)
    end
end

local function OnUnequip(inst, owner)
    if TUNING.BUFFGO and inst.components.fueled then
        owner:RemoveEventCallback("healthdelta", inst.consumefn)
        owner.components.health.externalabsorbmodifiers:RemoveModifier(inst)
    end

    inst.components.fueled:StopConsuming()
    owner.AnimState:ClearOverrideSymbol("swap_hat")
end

local function OnEquipToModel(inst, owner)
    if TUNING.BUFFGO and inst.components.fueled then
        owner:RemoveEventCallback("healthdelta", inst.consumefn)
        owner.components.health.externalabsorbmodifiers:RemoveModifier(inst)
    end

    inst.components.fueled:StopConsuming()
end

local function AcceptTest(inst, item)
    if item.prefab == "ancient_soul" and inst.components.fueled:GetPercent() < 1 then
        return true
    elseif inst.components.fueled:GetPercent() == 1 then
        local owner = item.components.inventoryitem:GetGrandOwner()
        owner.components.talker:Say("Durability is full!")
    else
        local owner = item.components.inventoryitem:GetGrandOwner()
        owner.components.talker:Say("qwq!\nThis can't be used to repairing the amulet!")
    end
end

local function OnGetItem(inst, giver, item)
    if item.prefab == "ancient_soul" and inst.components.fueled:GetPercent() < 1 then
        inst.components.fueled:DoDelta(inst.components.fueled.maxfuel * 0.5)
    end
end

local function UpdateLightState(inst)
    if not inst.components.container:IsEmpty() then
        local item = inst.components.container:GetItemInSlot(1)
        if item.prefab == "horrorfuel" then
            inst.components.equippable.dapperness = -1
        end
    else
        inst.components.equippable.dapperness = 1
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
    inst:AddTag("trader")
    inst:AddComponent("inspectable")

    inst.entity:SetPristine()
    if not TheWorld.ismastersim then
        inst.OnEntityReplicated = function(inst)
            inst.replica.container:WidgetSetup("hsf_addon")
        end
        return inst
    end

    inst:AddTag("cattoy")
    inst:AddTag("nosteal")
    inst:AddComponent("inventoryitem")
    inst.components.inventoryitem.atlasname = "images/inventoryimages/fhl_hsf.xml"

    inst:AddComponent("fueled")
    local fuelLevel = TUNING.SKILL_TREE and 10 or 2
    inst.components.fueled.fueltype = FUELTYPE.MAGIC
    inst.components.fueled:SetDepletedFn(inst.Remove)
    inst.components.fueled:InitializeFuelLevel(fuelLevel * TUNING.TOTAL_DAY_TIME)

    inst:AddComponent("container")
    inst.components.container:WidgetSetup("hsf_addon")
    inst.components.container.acceptsstacks = false

    inst:AddComponent("equippable")
    inst.components.equippable.equipslot = EQUIPSLOTS.HEAD
    inst.components.equippable.dapperness = 1
    inst.components.equippable.is_magic_dapperness = true
    inst.components.equippable:SetOnEquip(OnEquip)
    inst.components.equippable:SetOnUnequip(OnUnequip)
    inst.components.equippable:SetOnEquipToModel(OnEquipToModel)

    inst:AddComponent("trader")
    inst.components.trader:SetAcceptTest(AcceptTest)
    inst.components.trader.onaccept = OnGetItem

    -- inst:AddComponent("armor")
    -- inst.components.armor:InitCondition(TUNING.ARMORBRAMBLE * 2, 0.5) -- 1050

    -- inst:AddComponent("resistance")
    -- inst.components.resistance:AddResistance("quakedebris")
    -- inst.components.resistance:AddResistance("lunarhaildebris")
    -- inst.components.resistance:SetOnResistDamageFn(fns.woodcarved_onhitbyquakedebris)


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
        -- AddHauntableCustomReaction(inst,
        --     function(inst, haunter)
        --         if haunter:HasTag("playerghost") then
        --             haunter:PushEvent("respawnfromghost", { source = inst })
        --             inst:Remove()
        --         end
        --     end
        --     , true, false, true)
    elseif TUNING.HSF_RESPAWN == -1 then
        inst.components.hauntable:SetHauntValue(TUNING.HAUNT_INSTANT_REZ)
    end

    inst:ListenForEvent("itemget", UpdateLightState)
    inst:ListenForEvent("itemlose", UpdateLightState)

    return inst
end

return Prefab("common/inventory/fhl_hsf", fn, assets)
