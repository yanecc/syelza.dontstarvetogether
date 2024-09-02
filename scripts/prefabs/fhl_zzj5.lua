local assets =
{
    Asset("ANIM", "anim/fhl_zzj.zip"),
    Asset("ANIM", "anim/swap_fhl_zzj.zip"),

    Asset("ATLAS", "images/inventoryimages/fhl_zzj5.xml"),
    Asset("IMAGE", "images/inventoryimages/fhl_zzj5.tex"),
}

local prefabs = {
    "buff_zzj",
    "ancienttree_seed",
    "icespike_fx_1",
    "icespike_fx_2",
    "icespike_fx_3",
    "icespike_fx_4"
}

local function MakeBroken(inst)
    if TUNING.SKILL_TREE then
        inst.components.equippable.restrictedtag = "notequippable"
        local owner = inst.components.inventoryitem ~= nil and inst.components.inventoryitem.owner or nil
        if owner and owner:HasTag("player") and inst.components.equippable:IsEquipped() then
            if inst.components.inventoryitem.cangoincontainer then
                owner.components.inventory.silentfull = true
                owner.components.inventory:GiveItem(inst)
                owner.components.inventory.silentfull = false
            else
                owner.components.inventory:DropItem(inst, true, true)
            end
        end
    else
        SpawnPrefab("ancienttree_seed").Transform:SetPosition(inst.Transform:GetWorldPosition())
        inst:Remove()
    end
end

local function OnFiniteUsesChanged(inst, data)
    if data.percent > 0 then
        if inst.components.equippable.restrictedtag ~= nil then
            inst.components.equippable.restrictedtag = nil
        end
    else
        MakeBroken(inst)
    end
end

local function AcceptTest(inst, item)
    if (item.prefab == "ancient_soul" or item.prefab == "goldnugget") and inst.components.finiteuses:GetPercent() < 1 then
        return true
    elseif inst.components.finiteuses:GetPercent() == 1 then
        local owner = item.components.inventoryitem:GetGrandOwner()
        owner.components.talker:Say("耐久已满!\nDurability is full!")
    else
        local owner = item.components.inventoryitem:GetGrandOwner()
        owner.components.talker:Say("qwq金芜菁不喜欢吃这些东西!\nThe Golden Wujin don't like eating this!")
    end
end

local function OnGetItemFromPlayer(inst, giver, item)
    if item.prefab == "ancient_soul" and inst.components.finiteuses:GetPercent() < 1 then
        inst.components.finiteuses:Repair(TUNING.ZZJ_FINITE_USES * 0.2)
    elseif item.prefab == "goldnugget" and inst.components.finiteuses:GetPercent() < 1 then
        inst.components.finiteuses:Repair(TUNING.ZZJ_FINITE_USES * 0.1)
    end
    if inst.components.finiteuses:GetPercent() > 1 then
        inst.components.finiteuses:SetUses(TUNING.ZZJ_FINITE_USES)
    end
end

local function onzzjremove(inst)
    SpawnPrefab("moonrocknugget").Transform:SetPosition(inst.Transform:GetWorldPosition())
    inst:Remove()
end

local function SpawnIceFx(attacker, target)
    local numFX = math.random(15, 20)
    local pos = attacker:GetPosition()
    local targetPos = target and target:GetPosition()
    local vec = (targetPos - pos):Normalize()
    local dist = pos:Dist(targetPos)
    local angle = attacker:GetAngleToPoint(targetPos:Get())
    local leader = attacker.components.follower ~= nil and attacker.components.follower:GetLeader()

    attacker.SoundEmitter:PlaySound("dontstarve/creatures/deerclops/swipe")

    for i = 1, numFX do
        attacker:DoTaskInTime(math.random() * 0.25, function(attacker)
            local prefab = "icespike_fx_" .. math.random(1, 4)
            local fx = SpawnPrefab(prefab)
            if fx then
                local x = GetRandomWithVariance(0, 5)
                local z = GetRandomWithVariance(0, 5)
                local offset = (vec * math.random(dist * 0.25, dist)) + Vector3(x, 0, z)
                fx.Transform:SetPosition((offset + pos):Get())

                local x, y, z = fx.Transform:GetWorldPosition()

                --每根冰柱的伤害半径
                local r = 2.5

                --每根冰柱的伤害
                local dmg = math.random() * 65 * TUNING.ZZJ_PRE

                local count = 0

                local ents = TheSim:FindEntities(x, y, z, r)
                for k, v in pairs(ents) do
                    local isAlly = attacker.components.combat:IsAlly(v) or leader and leader.components.combat:IsAlly(v)
                    if not TheNet:GetPVPEnabled() then
                        isAlly = isAlly or v:HasAnyTag("player", "companion") or v.components.follower and
                            v.components.follower:GetLeader() and v.components.follower.leader:HasTag("player")
                    end
                    if v:IsValid() and v.entity:IsVisible() and
                        not (v.components.health and v.components.health:IsDead()) and
                        attacker.components.combat:CanTarget(v) and not isAlly then
                        v.components.combat:GetAttacked(attacker, dmg)
                        count = count + 1

                        if v.components.freezable then
                            v.components.freezable:AddColdness(2)
                            v.components.freezable:SpawnShatterFX()
                        end
                    end
                end
                if TUNING.SKILL_TREE and attacker:HasTag("fhl") then
                    attacker.components.health:DoDelta(count)
                end
            end
        end)
    end
end

local function OnEquip(inst, owner, target)
    if owner.prefab == "fhl" then
        inst.onownerattackedfn = function(owner, data)
            owner.zzjFeedBack = owner.zzjFeedBack + data.damage * owner.level * 0.1
            owner:AddDebuff("buff_zzj", "buff_zzj")
        end
        if owner.level == 10 then
            owner.AnimState:OverrideSymbol("swap_object", "swap_fhl_zzj", "swap_myitem")
            owner.AnimState:Show("ARM_carry")
            owner.AnimState:Hide("ARM_normal")
            if TUNING.SKILL_TREE and not owner.components.health:IsDead() and not owner:HasTag("playerghost") then
                inst:ListenForEvent("attacked", inst.onownerattackedfn, owner)
            end
        else
            owner:DoTaskInTime(0, function()
                local inv = owner.components.inventory
                if inv then
                    inv:GiveItem(inst)
                end
                local talker = owner.components.talker
                if talker then
                    talker:Say("只有当我达到满级才能驾驭这件神兵!\nI should at least Lv up to lv10!")
                end
            end)
        end
    else
        owner:DoTaskInTime(0, function()
            local inv = owner.components.inventory
            if inv then
                inv:GiveItem(inst)
            end
            local talker = owner.components.talker
            if talker then
                talker:Say("我的力量无法驱使这把剑!\nI can't use this sword!")
            end
        end)
    end
end

--攻击燃烧
local function OnAttack(weapon, attacker, target)
    --普攻燃烧
    if attacker and attacker:IsValid() and TUNING.ZZJ_FIREOPEN then
        if TheWorld.state.isnight and math.random() < 0.4 then
            if target ~= nil and target.components.burnable ~= nil and
                math.random() < TUNING.TORCH_ATTACK_IGNITE_PERCENT * target.components.burnable.flammability then
                target.components.burnable:Ignite(nil, attacker)
            end
        end
    end

    if attacker and attacker:IsValid() and math.random() < 0.4 then
        SpawnIceFx(attacker, target)
        attacker.components.hunger:DoDelta(-2)
    end
end

local function OnUnequip(inst, owner)
    owner.AnimState:Hide("ARM_carry")
    owner.AnimState:Show("ARM_normal")
    if TUNING.SKILL_TREE and owner.prefab == "fhl" then
        inst:RemoveEventCallback("attacked", inst.onownerattackedfn, owner)
    end
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
    inst:AddTag("fhlzzj")
    inst:AddTag("trader")
    inst:AddTag("weapon")
    inst:AddTag("nosteal")

    inst.entity:SetPristine()
    if not TheWorld.ismastersim then
        return inst
    end

    inst:AddComponent("inspectable")

    inst:AddComponent("inventoryitem")
    inst.components.inventoryitem.atlasname = "images/inventoryimages/fhl_zzj5.xml"
    --inst.components.inventoryitem.keepondeath = true
    inst.components.inventoryitem.imagename = "fhl_zzj5"

    inst:AddComponent("tool")

    if TUNING.ZZJ_CANKANSHU then
        inst.components.tool:SetAction(ACTIONS.CHOP, 3) --可砍树
    end
    if TUNING.ZZJ_CANWAKUANG then
        inst.components.tool:SetAction(ACTIONS.MINE, 3) --可挖矿
    end
    if TUNING.ZZJ_CAN_USE_AS_SHOVEL then
        inst.components.tool:SetAction(ACTIONS.DIG) --可挖掘
    end
    if TUNING.ZZJ_CAN_USE_AS_HAMMER then
        inst.components.tool:SetAction(ACTIONS.HAMMER) --可锤击
    end

    inst:AddComponent("weapon")
    inst.components.weapon:SetDamage(120 * TUNING.GJBL)
    inst.components.weapon:SetRange(TUNING.SKILL_TREE and 3.5 or 3)
    inst.components.weapon:SetOnAttack(OnAttack)

    if TUNING.ZZJ_FINITE_USES > 0 then
        inst:AddComponent("finiteuses")
        inst.components.finiteuses:SetMaxUses(TUNING.ZZJ_FINITE_USES)
        inst.components.finiteuses:SetUses(TUNING.ZZJ_FINITE_USES)
        inst.components.finiteuses:SetOnFinished(MakeBroken)
        inst.components.finiteuses:SetConsumption(ACTIONS.CHOP, 1)
        inst.components.finiteuses:SetConsumption(ACTIONS.MINE, 1)
        inst.components.finiteuses:SetConsumption(ACTIONS.HAMMER, 1)
        inst.components.finiteuses:SetConsumption(ACTIONS.DIG, 1)
    end

    inst:AddComponent("equippable")
    inst.components.equippable.insulated = true
    inst.components.equippable.walkspeedmult = 1.3
    inst.components.equippable:SetOnEquip(OnEquip)
    inst.components.equippable:SetOnUnequip(OnUnequip)

    inst:AddComponent("trader")
    inst.components.trader:SetAcceptTest(AcceptTest)
    inst.components.trader.onaccept = OnGetItemFromPlayer

    inst:ListenForEvent("percentusedchange", OnFiniteUsesChanged)

    return inst
end

return Prefab("common/inventory/fhl_zzj5", fn, assets, prefabs)
