local assets =
{
    Asset("ANIM", "anim/fhl_x.zip"),
    Asset("ATLAS", "images/inventoryimages/fhl_x.xml"),
}

local prefabs =
{
    "fhl_x2",
    "spoiled_food"
}

local function OnFullMoon(inst, isfullmoon)
    local owner = inst.components.inventoryitem:GetGrandOwner()
    if not isfullmoon or not owner or not owner:HasTag("player") then return end
    local holder = inst.components.inventoryitem:GetContainer()
    local slot = holder:GetItemSlot(inst)
    local newItem = SpawnPrefab("fhl_x2")
    newItem.components.stackable:SetStackSize(inst.components.stackable:StackSize())
    newItem.components.perishable:SetPercent(inst.components.perishable:GetPercent())
    inst:Remove()
    holder:GiveItem(newItem, slot)
end

local function fn()
    local inst = CreateEntity()
    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddNetwork()

    MakeInventoryPhysics(inst)
    inst.Transform:SetScale(1.5, 1.5, 1.5)

    inst.AnimState:SetBank("fhl_x")
    inst.AnimState:SetBuild("fhl_x")
    inst.AnimState:PlayAnimation("idle")

    inst:AddTag("catfood")
    inst:AddTag("preparedfood")
    inst:AddTag("saltbox_valid")

    inst.entity:SetPristine()
    if not TheWorld.ismastersim then
        return inst
    end

    inst:AddComponent("edible")
    inst.components.edible.foodtype = "MEAT"
    inst.components.edible.healthvalue = -90
    inst.components.edible.hungervalue = 40
    inst.components.edible.getsanityfn = function(inst, eater)
        return eater and eater.components.sanity and -0.75 * eater.components.sanity.current or 0
    end

    inst:AddComponent("inspectable")

    inst:AddComponent("inventoryitem")
    inst.components.inventoryitem.atlasname = "images/inventoryimages/fhl_x.xml"

    inst:AddComponent("stackable")
    inst.components.stackable.maxsize = TUNING.STACK_SIZE_SMALLITEM

    inst:AddComponent("perishable")
    inst.components.perishable:SetPerishTime(TUNING.PERISH_PRESERVED * 5)
    inst.components.perishable:StartPerishing()
    inst.components.perishable.onperishreplacement = "spoiled_food"

    inst:AddComponent("halloweenmoonmutable")
    inst.components.halloweenmoonmutable:SetPrefabMutated("fhl_x2")

    inst:AddComponent("bait")

    inst:AddComponent("tradable")

    inst:WatchWorldState("isfullmoon", OnFullMoon)

    return inst
end

return Prefab("common/inventory/fhl_x", fn, assets, prefabs)
