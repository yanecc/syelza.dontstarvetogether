local assets =
{
    Asset("ANIM", "anim/fhl_cy.zip"),
    Asset("ATLAS", "images/inventoryimages/fhl_cy.xml"),
}

local prefabs =
{
    "spoiled_food"
}

local function fn()
    local inst = CreateEntity()
    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddNetwork()

    MakeInventoryPhysics(inst)
    inst.Transform:SetScale(1.3, 1.3, 1.3)

    inst.AnimState:SetBank("fhl_cy")
    inst.AnimState:SetBuild("fhl_cy")
    inst.AnimState:PlayAnimation("idle")

    inst:AddTag("catfood")
    inst:AddTag("preparedfood")

    inst.entity:SetPristine()
    if not TheWorld.ismastersim then
        return inst
    end

    inst:AddComponent("edible")
    inst.components.edible.foodtype = "GOODIES"
    inst.components.edible.healthvalue = 40
    inst.components.edible.hungervalue = 0
    inst.components.edible.sanityvalue = 20

    inst:AddComponent("inspectable")

    inst:AddComponent("inventoryitem")
    inst.components.inventoryitem.atlasname = "images/inventoryimages/fhl_cy.xml"

    inst:AddComponent("stackable")
    inst.components.stackable.maxsize = TUNING.STACK_SIZE_SMALLITEM

    inst:AddComponent("perishable")
    inst.components.perishable:SetPerishTime(TUNING.PERISH_PRESERVED * 10)
    inst.components.perishable:StartPerishing()
    inst.components.perishable.onperishreplacement = "spoiled_food"

    inst:AddComponent("bait")

    inst:AddComponent("tradable")

    return inst
end

return Prefab("common/inventory/fhl_cy", fn, assets, prefabs)
