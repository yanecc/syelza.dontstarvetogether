local assets =
{
    Asset("ANIM", "anim/fhl_bb.zip"),
    Asset("ANIM", "anim/swap_fhl_bb.zip"),

    Asset("ATLAS", "images/map_icons/fhl_data.xml"),
    Asset("ATLAS", "images/inventoryimages/fhl_bb.xml")
}

local function OnEquip(inst, owner)
    owner.AnimState:OverrideSymbol("backpack", "swap_fhl_bb", "backpack")
    owner.AnimState:OverrideSymbol("swap_body", "swap_fhl_bb", "swap_body")
    if inst.components.container ~= nil then
        inst.components.container:Open(owner)
    end
end

local function OnUnequip(inst, owner)
    owner.AnimState:ClearOverrideSymbol("backpack")
    owner.AnimState:ClearOverrideSymbol("swap_body")
    if inst.components.container ~= nil then
        inst.components.container:Close(owner)
    end
end

local function KeepLives(inst, data)
    if data.item and data.item.components.perishable and data.item:HasAnyTag("smallcreature", "smalloceancreature") then
        data.item.components.perishable:StopPerishing()
        data.item:AddTag("fhlpet")
    elseif data.prev_item and data.prev_item:HasTag("fhlpet") then
        data.prev_item.components.perishable:StartPerishing()
        data.prev_item:RemoveTag("fhlpet")
    end
end

local function AcceptTest(inst, item)
    if item.prefab == "ancient_soul" and inst.components.armor:IsDamaged() then
        return true
    elseif item.prefab ~= "ancient_soul" then
        local owner = item.components.inventoryitem:GetGrandOwner()
        owner.components.talker:Say("qwq这个无法用来修复背包哦!\nThis can't be used to repairing the backpack!")
    else
        local owner = item.components.inventoryitem:GetGrandOwner()
        owner.components.talker:Say("耐久已满!\nDurability is full!")
    end
    return false
end

local function OnTakeDamage(inst, damage_amount)
    local owner = inst.components.inventoryitem:GetGrandOwner()
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

local function OnBroken(inst)
    if inst.components.container ~= nil then
        inst.components.container:DropEverything()
        inst.components.container:Close()
        inst:RemoveComponent("container")
        -- inst:RemoveAllEventCallbacks()
    end
end

local function fn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddMiniMapEntity()
    inst.entity:AddNetwork()

    MakeInventoryPhysics(inst)

    inst.MiniMapEntity:SetIcon("fhl_bb.tex")

    inst.AnimState:SetBank("fhl_bb")
    inst.AnimState:SetBuild("fhl_bb")
    inst.AnimState:PlayAnimation("anim")

    inst.foleysound = "dontstarve/movement/foley/krampuspack"

    inst:AddTag("trader")
    inst:AddTag("fridge")
    inst:AddTag("backpack")

    --waterproofer (from waterproofer component) added to pristine state for optimization
    inst:AddTag("waterproofer")

    inst.entity:SetPristine()
    if not TheWorld.ismastersim then
        return inst
    end

    inst:AddComponent("inspectable")

    inst:AddComponent("inventoryitem")
    inst.components.inventoryitem.cangoincontainer = false
    inst.components.inventoryitem.atlasname = "images/inventoryimages/fhl_bb.xml"

    inst:AddComponent("waterproofer")
    inst.components.waterproofer:SetEffectiveness(TUNING.BB_WATERPROOFNESS)

    if TUNING.BB_HJOPEN then
        inst:AddComponent("armor")
        inst.components.armor:InitCondition(TUNING.BB_DURABILITY, 0.8)
        inst.components.armor.ontakedamage = OnTakeDamage
        inst.components.armor:SetOnFinished(OnBroken)

        inst:AddComponent("trader")
        inst.components.trader:SetAcceptTest(AcceptTest)
        inst.components.trader.onaccept = function(inst, giver, item)
            inst.components.armor:Repair(TUNING.BB_DURABILITY * 0.2)
        end
    end

    inst:AddComponent("equippable")
    inst.components.equippable.equipslot = EQUIPSLOTS.BACK or EQUIPSLOTS.BODY
    inst.components.equippable:SetOnEquip(OnEquip)
    inst.components.equippable:SetOnUnequip(OnUnequip)

    inst:AddComponent("container")
    inst.components.container:WidgetSetup("krampus_sack")

    inst:ListenForEvent("itemget", KeepLives)
    inst:ListenForEvent("itemlose", KeepLives)

    MakeHauntableLaunchAndDropFirstItem(inst)

    return inst
end

return Prefab("common/inventory/fhl_bb", fn, assets)
