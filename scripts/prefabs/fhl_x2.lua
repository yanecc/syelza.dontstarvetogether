local assets =
{
    Asset("ANIM", "anim/fhl_x.zip"),
    Asset("ATLAS", "images/inventoryimages/fhl_x2.xml"),
}

local prefabs =
{
    "fhl_x",
    "buff_x2",
    "spoiled_food"
}

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
    inst.components.edible.healthvalue = 0
    inst.components.edible.hungervalue = 40
    inst.components.edible.sanityvalue = 0
    inst.components.edible.degrades_with_spoilage = false
    inst.components.edible.oneaten = function(inst, eater)
        if eater.components.debuffable and eater.components.debuffable:IsEnabled() and
            not (eater.components.health and eater.components.health:IsDead()) and
            not eater:HasTag("playerghost") then
            eater:AddDebuff("buff_x2", "buff_x2")
        end
    end

    inst:AddComponent("inspectable")

    inst:AddComponent("inventoryitem")
    inst.components.inventoryitem.atlasname = "images/inventoryimages/fhl_x2.xml"

    inst:AddComponent("stackable")
    inst.components.stackable.maxsize = TUNING.STACK_SIZE_SMALLITEM

    inst:AddComponent("perishable")
    inst.components.perishable:SetPerishTime(TUNING.PERISH_PRESERVED * 5)
    inst.components.perishable:StartPerishing()
    inst.components.perishable.onperishreplacement = "spoiled_food"

    inst:AddComponent("bait")

    inst:AddComponent("tradable")

    MakeHauntableChangePrefab(inst, "fhl_x")

    return inst
end

return Prefab("common/inventory/fhl_x2", fn, assets, prefabs)
