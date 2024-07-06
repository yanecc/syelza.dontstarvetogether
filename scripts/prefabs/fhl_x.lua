local Assets =
{
	Asset("ANIM", "anim/dy_x.zip"),
	Asset("ATLAS", "images/inventoryimages/fhl_x.xml"),
}

local prefabs =
{
	"spoiled_food",
}

local function define(inst)
	if inst and TheWorld.state.isnight then
		inst.components.edible.healthvalue = 5
		inst.components.edible.hungervalue = 40
		inst.components.edible.sanityvalue = 0
	else
		inst.components.edible.healthvalue = -75
		inst.components.edible.hungervalue = -40
		inst.components.edible.sanityvalue = 0
	end
end

local function OnEat(inst, eater)
	if eater and eater.components.sanity then
		local currentSanity = eater.components.sanity.current
		local maxSanity = eater.components.sanity.max
		local lostSanity = max_sanity - current_sanity
		eater.components.sanity:DoDelta(lostSanity / 2)
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
	define(inst)
	inst.components.edible.foodtype = "MEAT"
	inst.components.edible:SetOnEatenFn(OnEat)

	--inst.components.edible.healthvalue = -100
	--inst.components.edible.hungervalue = 120
	--inst.components.edible.sanityvalue = -60

	inst:AddComponent("inspectable")

	inst:AddComponent("inventoryitem")
	inst.components.inventoryitem.atlasname = "images/inventoryimages/fhl_x.xml"

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


return Prefab("common/inventory/fhl_x", fn, Assets)
