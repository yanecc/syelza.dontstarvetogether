local assets =
{
    Asset("ANIM", "anim/fhl_zzj.zip"),
    Asset("ANIM", "anim/swap_fhl_zzj.zip"),

    Asset("ATLAS", "images/inventoryimages/bj_11.xml"),
    Asset("IMAGE", "images/inventoryimages/bj_11.tex"),
}

local prefabs = {
}

local function SleepAttack(inst, attacker, target)
    if not target:IsValid() or not target.components.combat or target.components.combat.defaultdamage == 0 then
        --target killed or removed in combat damage phase
        return
    end
    if target.SoundEmitter ~= nil then
        target.SoundEmitter:PlaySound("dontstarve/wilson/blowdart_impact_sleep")
    end

    target:DoTaskInTime(math.random(), function(target)
        if target.components.sleeper ~= nil then
            target.components.sleeper:AddSleepiness(10, 5, inst)
        elseif target.components.grogginess ~= nil then
            target.components.grogginess:AddGrogginess(10, 5)
        else
            target:PushEvent("knockedout")
        end
    end)
end

local function OnEquip(inst, owner)
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
    inst:AddTag("hammer")
    inst:AddTag("weapon")
	inst:AddTag("aquatic")
	inst:AddTag("machete")
    inst:AddTag("nosteal")
    inst:AddTag("allow_action_on_impassable")

    inst:AddComponent("symbolswapdata")
    inst.components.symbolswapdata:SetData("swap_fhl_zzj", "swap_myitem")

    inst.entity:SetPristine()
    if not TheWorld.ismastersim then
        return inst
    end

    inst:AddComponent("inspectable")

    inst:AddComponent("inventoryitem")
    inst.components.inventoryitem.atlasname = "images/inventoryimages/bj_11.xml"
    inst.components.inventoryitem.imagename = "bj_11"

    inst:AddComponent("equippable")
    inst.components.equippable:SetOnEquip(OnEquip)
    inst.components.equippable:SetOnUnequip(OnUnequip)

    inst:AddComponent("tool")

    inst.components.tool:SetAction(ACTIONS.CHOP, 5) -- 可砍树

    inst.components.tool:SetAction(ACTIONS.MINE, 5) -- 可挖矿

    inst.components.tool:EnableToughWork(true)      -- 可强力开采

    inst.components.tool:SetAction(ACTIONS.DIG)     -- 可挖掘

    inst.components.tool:SetAction(ACTIONS.HAMMER)  -- 可锤击

    inst:AddComponent("oar")                        -- 可划水
    inst.components.oar.force = 0.6
    inst.components.oar.max_velocity = 6

    inst:AddComponent("farmtiller")                 -- 可犁地
    inst.components.farmtiller.Till = function(self, pt, doer)
        local tilling = false
        local tile_x, tile_y, tile_z = TheWorld.Map:GetTileCenterPoint(pt.x, 0, pt.z)
        for x = -1, 1 do
            for y = -1, 1 do
                local till_x = tile_x + x * 1.3
                local till_y = tile_z + y * 1.3
                if TheWorld.Map:CanTillSoilAtPoint(till_x, 0, till_y, false) then
                    TheWorld.Map:CollapseSoilAtPoint(till_x, 0, till_y)
                    SpawnPrefab("farm_soil").Transform:SetPosition(till_x, 0, till_y)
                    tilling = true
                end
            end
        end
        if tilling and doer ~= nil then
            doer:PushEvent("tilling")
            return true
        end
        return false
    end

    if ACTIONS.HACK ~= nil then
	    inst.components.tool:SetAction(ACTIONS.HACK, 4) -- 可劈砍
    end

    inst:AddComponent("weapon")
    inst.components.weapon:SetDamage(0)
    inst.components.weapon:SetOnAttack(SleepAttack)

    inst:AddComponent("planardamage")
    inst.components.planardamage:SetBaseDamage(15)

    return inst
end

return Prefab("common/inventory/bj_11", fn, assets)
