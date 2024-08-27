local assets =
{
    Asset("ANIM", "anim/ancient_gem.zip"),

    Asset("ATLAS", "images/inventoryimages/ancient_gem.xml"),
    Asset("IMAGE", "images/inventoryimages/ancient_gem.tex"),
}

local prefabs = {
    "ancient_altar",
    "opalpreciousgem"
}

local function fn()
    local inst = CreateEntity()
    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    --inst.entity:AddSoundEmitter()
    --inst.entity:AddPhysics()
    inst.entity:AddNetwork()
    inst.entity:AddLight()

    MakeInventoryPhysics(inst)
    RemovePhysicsColliders(inst)

    inst.AnimState:SetBank("ancient_gem")
    inst.AnimState:SetBuild("ancient_gem")
    inst.AnimState:PlayAnimation("idle")
    inst.AnimState:SetBloomEffectHandle("shaders/anim.ksh")

    inst.Light:Enable(true)
    inst.Light:SetRadius(.5)
    inst.Light:SetFalloff(.7)
    inst.Light:SetIntensity(.5)
    inst.Light:SetColour(238 / 255, 155 / 255, 143 / 255)

    inst.entity:SetPristine()
    if not TheWorld.ismastersim then
        return inst
    end

    inst:AddComponent("edible")
    inst.components.edible.foodtype = "ELEMENTAL"
    inst.components.edible.hungervalue = 2
    inst:AddComponent("tradable")
    inst.components.tradable.goldvalue = 9   -- 9金块
    inst.components.tradable.rocktribute = 9 -- 3天

    inst:AddComponent("inspectable")
    inst:AddComponent("burnable")
    inst.components.burnable:SetFXLevel(2)
    inst.components.burnable:SetBurnTime(10)
    inst.components.burnable:AddBurnFX("fire", Vector3(0, 0, 0))
    inst.components.burnable:SetOnIgniteFn(DefaultBurnFn)
    inst.components.burnable:SetOnExtinguishFn(DefaultExtinguishFn)
    inst.components.burnable:SetOnBurntFn(function(inst)
        local crystal = SpawnPrefab("opalpreciousgem")
        crystal.Transform:SetPosition(inst.Transform:GetWorldPosition())

        if inst.components.stackable then
            crystal.components.stackable:SetStackSize(math.min(crystal.components.stackable.maxsize,
                inst.components.stackable.stacksize))
        end

        inst:Remove()
    end)

    MakeSmallPropagator(inst)

    local function onDeploy(inst, pt)
        SpawnPrefab("ancient_altar").Transform:SetPosition(pt.x, pt.y, pt.z)
        inst.components.stackable:Get():Remove()
    end
    inst:AddComponent("deployable")
    inst.components.deployable.ondeploy = onDeploy
    inst.components.deployable:SetDeployMode(DEPLOYMODE.DEFAULT)
    inst.components.deployable:SetDeploySpacing(DEPLOYSPACING.PLACER_DEFAULT) -- 3.2

    inst:AddComponent("stackable")
    inst:AddComponent("inventoryitem")
    inst.components.inventoryitem.atlasname = "images/inventoryimages/ancient_gem.xml"

    return inst
end

return Prefab("common/inventory/ancient_gem", fn, assets, prefabs),
    MakePlacer("common/ancient_gem_placer", "crafting_table", "crafting_table", "idle_full")
