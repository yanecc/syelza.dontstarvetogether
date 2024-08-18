local assets =
{
    Asset("ANIM", "anim/dy_x.zip"),
    Asset("ATLAS", "images/inventoryimages/fhl_x2.xml"),
}

local prefabs =
{
    "fhl_x",
    "buff_x2",
    "spoiled_food"
}

-- It works fine, but will stop for a logout
-- local function OnEat(inst, eater)
--     if eater.components.health and eater.components.sanity then
--         local function restoreBuff()
--             local restorePercent = math.random(5, 15) / 100
--             if eater.components.sanity:GetPercent() < eater.components.health:GetPercent() then
--                 eater.components.sanity:DoDelta(math.ceil(eater.components.sanity:GetMaxWithPenalty() * restorePercent))
--             else
--                 eater.components.health:DoDelta(math.ceil(eater.components.health:GetMaxWithPenalty() * restorePercent))
--             end
--         end

--         for i = 1, 10 do
--             inst:DoTaskInTime(2 * i - 1, restoreBuff)
--         end
--     end
-- end

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
    inst.components.edible.healthvalue = 0
    inst.components.edible.hungervalue = 40
    inst.components.edible.sanityvalue = 0
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
