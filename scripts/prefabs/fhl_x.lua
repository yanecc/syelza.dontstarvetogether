local assets =
{
    Asset("ANIM", "anim/dy_x.zip"),
    Asset("ATLAS", "images/inventoryimages/fhl_x.xml"),
}

local prefabs =
{
    "fhl_x2",
    "spoiled_food"
}

local function OnFullMoon(inst)
    if not TheWorld.state.isfullmoon then return end
    for _, player in ipairs(AllPlayers) do
        local inventory = player.components.inventory
        local items = inventory:FindItems(function(item) return item.prefab == "fhl_x" end)
        for _, item in ipairs(items) do
            local newItem = SpawnPrefab("fhl_x2")
            local slot = inventory:GetItemSlot(item)
            newItem.components.stackable:SetStackSize(item.components.stackable:StackSize())
            newItem.components.perishable:SetPercent(item.components.perishable:GetPercent())
            inventory:RemoveItem(item, false)
            item:Remove()
            inventory:GiveItem(newItem, slot)
        end
    end
end

local function OnEat(inst, eater)
    if eater.components.sanity then
        local currentSanity = eater.components.sanity.current
        eater.components.sanity:DoDelta(-currentSanity * 0.75)
    end
end

local function fn(Sim)
    local inst = CreateEntity()
    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddNetwork()

    MakeInventoryPhysics(inst)
    MakeSmallBurnable(inst)
    MakeSmallPropagator(inst)

    inst.AnimState:SetBank("dy_x")
    inst.AnimState:SetBuild("dy_x")
    inst.AnimState:PlayAnimation("idle")

    inst:AddTag("catfood")
    inst:AddTag("preparedfood")
    inst:AddTag("saltbox_valid")

    --if not TheNet:GetIsServer() then
    --    return inst
    --end

    inst.entity:SetPristine()
    if not TheWorld.ismastersim then
        return inst
    end

    inst:AddComponent("edible")
    inst.components.edible.foodtype = "MEAT"
    inst.components.edible.healthvalue = -90
    inst.components.edible.hungervalue = 40
    inst.components.edible.sanityvalue = 0
    inst.components.edible:SetOnEatenFn(OnEat)

    inst:AddComponent("inspectable")

    inst:AddComponent("halloweenmoonmutable")
    inst.components.halloweenmoonmutable:SetPrefabMutated("fhl_x2")

    inst:AddComponent("inventoryitem")
    inst.components.inventoryitem.atlasname = "images/inventoryimages/fhl_x.xml"

    inst:AddComponent("stackable")
    inst.components.stackable.maxsize = TUNING.STACK_SIZE_SMALLITEM

    inst:AddComponent("perishable")
    inst.components.perishable:SetPerishTime(TUNING.PERISH_PRESERVED * 5)
    inst.components.perishable:StartPerishing()
    inst.components.perishable.onperishreplacement = "spoiled_food"

    inst:AddComponent("bait")

    inst:AddComponent("tradable")

    inst:WatchWorldState("isfullmoon", OnFullMoon)

    return inst
end

return Prefab("common/inventory/fhl_x", fn, assets, prefabs)
