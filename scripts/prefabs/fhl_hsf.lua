local assets =
{
    Asset("ANIM", "anim/fhl_hsf.zip"),
    Asset("ATLAS", "images/inventoryimages/fhl_hsf.xml")
}

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
        local hsf_repaired = TUNING.ARMORMARBLE * 1.2
        inst.components.armor.condition = inst.components.armor.condition + hsf_repaired
        if inst.components.armor:GetPercent() > 1 then
            inst.components.armor:SetCondition(TUNING.ARMORMARBLE * 3)
        end
    end
end

local function saniup(inst)
    if inst.isWeared and not inst.isDropped then
        --inst:AddComponent("dapperness")
        inst.components.equippable.dapperness = 1
    end
end

local function onequip(inst, owner)
    --owner.AnimState:OverrideSymbol("swap_hat", "faroz_gls", "swap_hat")

    --owner.AnimState:Show("HAT")
    --owner.AnimState:Show("HAT_HAIR")
    --owner.AnimState:Hide("HAIR_NOHAT")
    --owner.AnimState:Hide("HAIR")

    --if owner:HasTag("player") then
    --    owner.AnimState:Hide("HEAD")
    --    owner.AnimState:Show("HEAD_HAT")
    --end
    inst.isWeared = true
    inst.isDropped = false
    saniup(inst)
end

local function onunequip(inst, owner)
    --owner.AnimState:Hide("HAT")
    --owner.AnimState:Hide("HAT_HAIR")
    --owner.AnimState:Show("HAIR_NOHAT")
    --owner.AnimState:Show("HAIR")

    --if owner:HasTag("player") then
    --    owner.AnimState:Show("HEAD")
    --    owner.AnimState:Hide("HEAD_HAT")
    --end
    inst.isWeared = false
    inst.isDropped = false
    saniup(inst)
end

local function ondrop(inst)
    inst.isDropped = true
    inst.isWeared = false
    saniup(inst)
end

local function fn(Sim)
    local inst = CreateEntity()
    local trans = inst.entity:AddTransform()
    local anim = inst.entity:AddAnimState()
    MakeInventoryPhysics(inst)
    inst.entity:AddNetwork()

    inst:AddTag("sharp")
    --inst:AddTag("hat")
    inst:AddTag("trader")

    inst.isWeared = false
    inst.isDropped = false

    --anim:SetBank("beehat")
    --anim:SetBuild("fhl_hsf")
    --anim:PlayAnimation("anim")

    anim:SetBank("fhl_hsf")
    anim:SetBuild("fhl_hsf")
    anim:PlayAnimation("idel")

    inst:AddComponent("inspectable") --�����

    inst.entity:SetPristine()
    if not TheWorld.ismastersim then
        return inst
    end

    -- 意义不明 待测试
    if glassesdrop == 1 then
        inst:AddTag("irreplaceable")
    end
    --

    inst:AddComponent("inventoryitem")
    inst.components.inventoryitem.atlasname = "images/inventoryimages/fhl_hsf.xml"

    inst:AddComponent("equippable")
    inst.components.equippable.equipslot = EQUIPSLOTS.HEAD

    if inst and TUNING.BUFFGO then
        inst:AddComponent("armor")
        inst.components.armor:InitCondition(TUNING.ARMORMARBLE * 3, 0.5)
        inst:AddComponent("trader")
        inst.components.trader:SetAcceptTest(AcceptTest)
        inst.components.trader.onaccept = OnGetItemFromPlayer
    end
    inst.components.equippable:SetOnEquip(onequip)
    inst.components.equippable:SetOnUnequip(onunequip)
    inst.components.inventoryitem:SetOnDroppedFn(ondrop)

    -- 作祟复活
    --inst:AddTag("resurrector")
    inst:AddComponent("hauntable")
    -- inst.components.hauntable:SetHauntValue(TUNING.HAUNT_INSTANT_REZ)

    -- 我真不会写作祟之后消失啊
    AddHauntableCustomReaction(inst,
        function(inst, haunter)
            if haunter:HasTag("playerghost") then
                haunter:PushEvent("respawnfromghost")
                inst:Remove()
            end
        end
        , true, false, true)
    --

    inst:ListenForEvent("phasechanged", function() saniup(inst) end, TheWorld)
    return inst
end

return Prefab("common/inventory/fhl_hsf", fn, assets)
