local assets =
{
	Asset("ANIM", "anim/fhl_zzj.zip"),
	Asset("ANIM", "anim/swap_fhl_zzj.zip"),

	Asset("ATLAS", "images/inventoryimages/bj_11.xml"),
	Asset("IMAGE", "images/inventoryimages/bj_11.tex"),
}

local prefabs = {
}

local function onequip(inst, owner)
	owner.AnimState:OverrideSymbol("swap_object", "swap_fhl_zzj", "swap_myitem")
	owner.AnimState:Show("ARM_carry")
	owner.AnimState:Hide("ARM_normal")
end

local function OnUnequip(inst, owner)
	owner.AnimState:Hide("ARM_carry")
	owner.AnimState:Show("ARM_normal")
end

local function fn()
	local inst = CreateEntity()
	local trans = inst.entity:AddTransform()
	local anim = inst.entity:AddAnimState()
	local sound = inst.entity:AddSoundEmitter()
	MakeInventoryPhysics(inst)
	inst.entity:AddNetwork()

	anim:SetBank("fhl_zzj")
	anim:SetBuild("fhl_zzj")
	anim:PlayAnimation("idle")

	inst:AddTag("sharp")

	inst.entity:SetPristine()
	if not TheWorld.ismastersim then
		return inst
	end

	inst:AddComponent("tool")

	inst.components.tool:SetAction(ACTIONS.CHOP, 5) --可砍树

	inst.components.tool:SetAction(ACTIONS.MINE, 5) --可挖矿

	inst.components.tool:SetAction(ACTIONS.DIG)  --可挖掘

	inst.components.tool:SetAction(ACTIONS.HAMMER) --可锤击

	inst:AddInherentAction(ACTIONS.TERRAFORM)    --可铲草

	inst:AddComponent("weapon")
	inst.components.weapon:SetDamage(15)

	inst:AddComponent("inspectable")

	inst:AddComponent("inventoryitem")
	inst.components.inventoryitem.atlasname = "images/inventoryimages/bj_11.xml"
	inst.components.inventoryitem.imagename = "bj_11"

	inst:AddComponent("equippable")
	inst.components.equippable:SetOnEquip(onequip)
	inst.components.equippable:SetOnUnequip(OnUnequip)
	inst.components.equippable.walkspeedmult = 1.0

	return inst
end

return Prefab("common/inventory/bj_11", fn, assets)
