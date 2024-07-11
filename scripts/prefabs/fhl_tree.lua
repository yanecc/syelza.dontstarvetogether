local assets =
{
	Asset("ANIM", "anim/fhl_tree.zip"),

	Asset("ATLAS", "images/inventoryimages/fhl_tree.xml"),
	Asset("IMAGE", "images/inventoryimages/fhl_tree.tex"),
}


local function fn()
	local inst = CreateEntity()
	inst.entity:AddTransform()
	inst.entity:AddAnimState()
	inst.entity:AddNetwork()
	inst.entity:AddLight()

	MakeInventoryPhysics(inst)
	RemovePhysicsColliders(inst)

	inst:AddTag("plant")
	inst.AnimState:SetBank("fhl_tree")
	inst.AnimState:SetBuild("fhl_tree")
	inst.AnimState:PlayAnimation("dropped_banana")
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

	inst:AddComponent("stackable")
	inst:AddComponent("inspectable")
	inst:AddComponent("tradable")
	inst:AddComponent("lootdropper")
	inst:AddComponent("deployable")
	inst:AddComponent("inventoryitem")
	inst:AddComponent("fuel")

	inst.components.tradable.goldvalue = 4
	inst.components.tradable.rocktribute = 2

	inst.components.lootdropper:SetLoot({ "twigs", "twigs", "ancient_soul", "ancient_soul" })
	inst.components.lootdropper:AddChanceLoot("cave_banana", 0.5)

	local function OnDeploy(inst, pt)
		local tree = SpawnPrefab("cave_banana_tree")
		if tree then
			tree.Transform:SetPosition(pt.x, pt.y, pt.z)
			inst.components.stackable:Get():Remove()
			tree.SoundEmitter:PlaySound("dontstarve/wilson/plant_tree")
		end
	end
	inst.components.deployable.ondeploy = OnDeploy
	inst.components.deployable.mode = DEPLOYMODE.PLANT
	inst.components.deployable.min_spacing = 6

	inst.components.inventoryitem.atlasname = "images/inventoryimages/fhl_tree.xml"
	inst.components.fuel.fuelvalue = TUNING.LARGE_FUEL

	return inst
end

return Prefab("common/inventory/fhl_tree", fn, assets),
	MakePlacer("common/fhl_tree_placer", "cave_banana_tree", "cave_banana_tree", "idle_loop")
