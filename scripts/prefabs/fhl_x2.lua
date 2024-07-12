local Assets =
{
	Asset("ANIM", "anim/dy_x.zip"),
	Asset("ATLAS", "images/inventoryimages/fhl_x2.xml"),
}

local prefabs =
{
	"spoiled_food",
}

local function OnEat(inst, eater)
	if eater and eater.components.health and eater.components.sanity then
		local lostHealth = eater.components.health:GetMaxWithPenalty() - eater.components.health.currenthealth
		local lostSanity = eater.components.sanity.max - eater.components.sanity.current

		eater.components.health:DoDelta(math.ceil(lostHealth / 2))
		eater.components.sanity:DoDelta(math.ceil(lostSanity / 2))
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

	inst:AddTag("preparedfood")
	inst:AddTag("honeyed")

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
	inst.components.edible:SetOnEatenFn(OnEat)

	inst:AddComponent("inspectable")

	inst:AddComponent("inventoryitem")
	inst.components.inventoryitem.atlasname = "images/inventoryimages/fhl_x2.xml"

	inst:AddComponent("stackable")
	inst.components.stackable.maxsize = TUNING.STACK_SIZE_SMALLITEM

	inst:AddComponent("perishable")
	inst.components.perishable:SetPerishTime(TUNING.PERISH_PRESERVED * 100)
	inst.components.perishable:StartPerishing()
	inst.components.perishable.onperishreplacement = "spoiled_food"

	inst:AddComponent("bait")

	inst:AddComponent("tradable")

	return inst
end


return Prefab("common/inventory/fhl_x2", fn, Assets)
