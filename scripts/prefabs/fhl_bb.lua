local assets =
{
    Asset("ANIM", "anim/swap_fhl_bb.zip"),
    Asset("ANIM", "anim/fhl_bb.zip"),

    Asset("ATLAS", "images/inventoryimages/fhl_bb.xml")
}

local function AcceptTest(inst, item)
    if item.prefab == "ancient_soul" and inst.components.armor:GetPercent() < 1 then
        return true
    elseif inst.components.armor:GetPercent() == 1 then
        local owner = item.components.inventoryitem:GetGrandOwner()
        owner.components.talker:Say("耐久已满!\nDurability is full!")
    else
        local owner = item.components.inventoryitem:GetGrandOwner()
        owner.components.talker:Say("qwq这个无法用来修复背包哦!\nThis can't be used to repairing the backpack!")
    end
    return false
end

local function OnGetItemFromPlayer(inst, giver, item)
    if item.prefab == "ancient_soul" and inst.components.armor:GetPercent() < 1 then
        inst.components.armor.condition = inst.components.armor.condition + TUNING.BB_DURABILITY * 0.2
        if inst.components.armor:GetPercent() > 1 then
            inst.components.armor:SetCondition(TUNING.BB_DURABILITY)
        end
    end
end

local function onbreak(owner, data)
    local armor = data ~= nil and data.armor or nil
    if armor and armor.components.container then
        armor.components.container:DropEverything()
        armor.components.container:Close()
        armor:RemoveComponent("container")
    end
end

local function OnTakeDamage(inst, damage_amount)
    local owner = inst.components.inventoryitem.owner
    local durability = inst.components.armor:GetPercent()
    if durability < 0.05 and not inst.thirdLowDurabilityWarning then
        inst.thirdLowDurabilityWarning = true
        owner.components.talker:Say("Warning: " .. inst:GetDisplayName() .. " is about to break!")
    elseif durability < 0.1 and not inst.secondLowDurabilityWarning then
        inst.secondLowDurabilityWarning = true
        owner.components.talker:Say("Warning: " .. inst:GetDisplayName() .. " durability is below 10%!")
    elseif durability < 0.2 and not inst.firstLowDurabilityWarning then
        inst.firstLowDurabilityWarning = true
        owner.components.talker:Say("Warning: " .. inst:GetDisplayName() .. " durability is below 20%!")
    end
end

local function onequip(inst, owner)
    owner.AnimState:OverrideSymbol("swap_body", "swap_fhl_bb", "symbol_15220700")
    owner.AnimState:OverrideSymbol("swap_body", "swap_fhl_bb", "symbol_b6d8e12e")
    inst.components.container:Open(owner)
    inst:ListenForEvent("armorbroke", onbreak, owner)
end

local function onunequip(inst, owner)
    owner.AnimState:ClearOverrideSymbol("swap_body")
    owner.AnimState:ClearOverrideSymbol("backpack")
    if inst.components.container ~= nil then
        inst.components.container:Close(owner)
    end
    inst:RemoveEventCallback("armorbroke", onbreak, owner)
end

local function fn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddMiniMapEntity()
    inst.entity:AddNetwork()

    MakeInventoryPhysics(inst)

    inst.MiniMapEntity:SetIcon("krampus_sack.png")

    inst.AnimState:SetBank("pirate_booty_bag")
    inst.AnimState:SetBuild("swap_fhl_bb")
    inst.AnimState:PlayAnimation("anim")

    --inst.foleysound = "dontstarve/movement/foley/krampuspack"

    inst:AddTag("trader")
    inst:AddTag("fridge")
    inst:AddTag("backpack")

    --waterproofer (from waterproofer component) added to pristine state for optimization
    inst:AddTag("waterproofer")

    inst:AddComponent("talker")
    inst.components.talker.fontsize = 20
    inst.components.talker.font = TALKINGFONT
    inst.components.talker.colour = Vector3(0.6, 0.9, 0.9, 1)
    inst.components.talker.offset = Vector3(0, 100, 0)
    inst.components.talker.symbol = "swap_object"

    inst.entity:SetPristine()
    if not TheWorld.ismastersim then
        return inst
    end

    inst:AddComponent("inspectable")

    inst:AddComponent("inventoryitem")
    inst.components.inventoryitem.cangoincontainer = false
    inst.components.inventoryitem.foleysound = "dontstarve/movement/foley/marblearmour"
    inst.components.inventoryitem.atlasname = "images/inventoryimages/fhl_bb.xml"

    inst:AddComponent("waterproofer")
    inst.components.waterproofer:SetEffectiveness(TUNING.WATERPROOFNESS_HUGE)

    if TUNING.BB_HJOPEN then
        inst:AddComponent("armor")
        inst.components.armor:InitCondition(TUNING.BB_DURABILITY, 0.8)
        inst.components.armor.ontakedamage = OnTakeDamage
        inst:AddComponent("trader")
        inst.components.trader:SetAcceptTest(AcceptTest)
        inst.components.trader.onaccept = OnGetItemFromPlayer
    end

    inst:AddComponent("equippable")
    inst.components.equippable.equipslot = EQUIPSLOTS.BACK or EQUIPSLOTS.BODY

    inst.components.equippable:SetOnEquip(onequip)
    inst.components.equippable:SetOnUnequip(onunequip)

    inst:AddComponent("container")
    inst.components.container:WidgetSetup("krampus_sack")

    MakeHauntableLaunchAndDropFirstItem(inst)

    return inst
end

return Prefab("common/inventory/fhl_bb", fn, assets)
