local assets =
{
    Asset("ANIM", "anim/fhl_hsf.zip"),
    Asset("ATLAS", "images/inventoryimages/fhl_hsf.xml")
}

local function OnEquip(inst, owner)
    owner.AnimState:OverrideSymbol("swap_hat", "fhl_hsf", "swap_hat")
    owner.components.health.externalabsorbmodifiers:SetModifier(inst, 0.5)
end

local function OnUnequip(inst, owner)
    owner.AnimState:ClearOverrideSymbol("swap_hat")
    owner.components.health.externalabsorbmodifiers:RemoveModifier(inst)
end

local function OnTakeDamage(inst, data)
    if inst.components.fueled then
        inst.components.fueled:DoDelta(-inst.components.fueled.maxfuel * 0.02)
    end
end

local function AcceptTest(inst, item)
    if item.prefab == "ancient_soul" and inst.components.armor:GetPercent() < 1 then
        return true
    elseif inst.components.armor:GetPercent() == 1 then
        local owner = item.components.inventoryitem:GetGrandOwner()
        owner.components.talker:Say("�;�����!\nDurability is full!")
    else
        local owner = item.components.inventoryitem:GetGrandOwner()
        owner.components.talker:Say("qwq����޷������޸�������Ŷ!\nThis can't be used to repairing the amulet!")
    end
end

local function OnGetItemFromPlayer(inst, giver, item)
    if item.prefab == "ancient_soul" and inst.components.armor:GetPercent() < 1 then
        local hsf_repaired = TUNING.ARMORBRAMBLE
        inst.components.armor.condition = inst.components.armor.condition + hsf_repaired
        if inst.components.armor:GetPercent() > 1 then
            inst.components.armor:SetCondition(TUNING.ARMORBRAMBLE * 2)
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
    inst:AddTag("trader")
    inst:AddComponent("inspectable")

    inst.entity:SetPristine()
    if not TheWorld.ismastersim then
        return inst
    end

    inst:AddTag("cattoy")
    inst:AddTag("nosteal")
    inst:AddComponent("inventoryitem")
    inst.components.inventoryitem.atlasname = "images/inventoryimages/fhl_hsf.xml"

    inst:AddComponent("equippable")
    inst.components.equippable.equipslot = EQUIPSLOTS.HEAD
    inst.components.equippable.dapperness = 1
    inst.components.equippable.is_magic_dapperness = true


    if inst and TUNING.BUFFGO then
        inst:AddTag("bramble_resistant")
        -- inst:AddComponent("armor")
        -- inst.components.armor:InitCondition(TUNING.ARMORBRAMBLE * 2, 0.5) -- 1050
        -- inst:AddComponent("trader")
        -- inst.components.trader:SetAcceptTest(AcceptTest)
        -- inst.components.trader.onaccept = OnGetItemFromPlayer
        -- -- inst:AddComponent("resistance")
        -- -- inst.components.resistance:AddResistance("quakedebris")
        -- -- inst.components.resistance:AddResistance("lunarhaildebris")
        -- -- inst.components.resistance:SetOnResistDamageFn(fns.woodcarved_onhitbyquakedebris)
        inst:AddComponent("fueled")
        inst.components.fueled.fueltype = FUELTYPE.MAGIC
        inst.components.fueled:InitializeFuelLevel(TUNING.TOTAL_DAY_TIME * 10)
        inst.components.fueled:SetDepletedFn(inst.Remove)
        inst.components.fueled:SetFirstPeriod(TUNING.TURNON_FUELED_CONSUMPTION, TUNING.TURNON_FULL_FUELED_CONSUMPTION)
    end

    inst:AddComponent("hauntable")
    if inst and TUNING.HSF_RESPAWN == 1 then
        AddHauntableCustomReaction(inst,
            function(inst, haunter)
                if haunter:HasTag("playerghost") then
                    haunter:PushEvent("respawnfromghost")
                    inst:Remove()
                end
            end
            , true, false, true)
    elseif inst and TUNING.HSF_RESPAWN == -1 then
        inst.components.hauntable:SetHauntValue(TUNING.HAUNT_INSTANT_REZ)
    end

    return inst
end

return Prefab("common/inventory/fhl_hsf", fn, assets)
