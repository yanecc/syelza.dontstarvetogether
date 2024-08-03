local function OnAttached(inst, target, followsymbol, followoffset, data)
    inst.entity:SetParent(target.entity)
    inst.Transform:SetPosition(0, 0, 0) --in case of loading
    inst:ListenForEvent("death", function()
        inst.components.debuff:Stop()
    end, target)
    inst._onattackother = function(attacker, attackData)
        if attackData.weapon:HasTag("fhlzzj") then
            if attackData.projectile == nil then
                --in combat, this is when we're just launching a projectile, so don't do FX yet
                if attackData.weapon.components.projectile ~= nil then
                    return
                elseif attackData.weapon.components.complexprojectile ~= nil then
                    return
                elseif attackData.weapon.components.weapon:CanRangedAttack() then
                    return
                end
            end
            if attacker.zzjFeedBack then
                attacker.zzjFeedBack = attacker.zzjFeedBack + data.damage * attacker.level * 0.1
            end
        end
        inst.components.debuff:Stop()
    end
    inst:ListenForEvent("onattackother", inst._onattackother, target)
end

local function OnDetached(inst, target)
    if target ~= nil and target:IsValid() then
        target.zzjFeedBack = 0
    end
    inst:Remove()
end

local function OnExtended(inst, target)
    -- inst.components.debuff:Stop()
    inst.components.timer:StopTimer("zzjbuffover")
    inst.components.timer:StartTimer("zzjbuffover", 10)
end

local function fn()
    local inst = CreateEntity()

    if not TheWorld.ismastersim then
        --Not meant for client!
        inst:DoTaskInTime(0, inst.Remove)
        return inst
    end

    inst.entity:AddTransform()

    --[[Non-networked entity]]
    --inst.entity:SetCanSleep(false)
    inst.entity:Hide()
    inst.persists = false

    inst:AddTag("CLASSIFIED")

    inst:AddComponent("debuff")
    inst.components.debuff:SetAttachedFn(OnAttached)
    inst.components.debuff:SetDetachedFn(OnDetached)
    inst.components.debuff:SetExtendedFn(OnExtended)
    inst.components.debuff.keepondespawn = true

    inst:AddComponent("timer")
    inst.components.timer:StartTimer("zzjbuffover", 10)
    inst:ListenForEvent("timerdone", function(inst, data)
        if data.name == "zzjbuffover" then
            inst.components.debuff:Stop()
        end
    end)

    return inst
end

return Prefab("buff_zzj", fn)
