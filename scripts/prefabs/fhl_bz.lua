local assets =
{
    Asset("ANIM", "anim/fhl_torte.zip"),
    Asset("ATLAS", "images/inventoryimages/fhl_bz.xml"),
}

local prefabs =
{
    "spoiled_food"
}

-- 彩虹糕
local function fn()
    local inst = CreateEntity()
    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddNetwork()
    MakeInventoryPhysics(inst)

    inst.AnimState:SetBank("fhl_torte")
    inst.AnimState:SetBuild("fhl_torte")
    inst.AnimState:PlayAnimation("idle")

    inst:AddTag("preparedfood")
    inst:AddTag("honeyed")
    inst:AddTag("catfood")

    inst.entity:SetPristine()
    if not TheWorld.ismastersim then
        return inst
    end

    inst:AddComponent("edible")
    inst.components.edible.foodtype = "GOODIES"
    inst.components.edible.healthvalue = 120
    inst.components.edible.hungervalue = 160
    inst.components.edible.sanityvalue = 30

    inst:AddComponent("inspectable")

    inst:AddComponent("inventoryitem")
    inst.components.inventoryitem.atlasname = "images/inventoryimages/fhl_bz.xml"

    inst:AddComponent("stackable")
    inst.components.stackable.maxsize = TUNING.STACK_SIZE_SMALLITEM

    inst:AddComponent("perishable")
    inst.components.perishable:SetPerishTime(TUNING.PERISH_PRESERVED * 5)
    inst.components.perishable:StartPerishing()
    inst.components.perishable.onperishreplacement = "spoiled_food"

    inst:AddComponent("bait")

    inst:AddComponent("tradable")

    return inst
end

return Prefab("common/inventory/fhl_bz", fn, assets, prefabs)
