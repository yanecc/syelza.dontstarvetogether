local function OnTick(inst, target)
    if target.components.health and
        target.components.sanity and
        not target.components.health:IsDead() and
        not target:HasTag("playerghost") then
        local restorePercent = math.random(5, 15) / 100
        if target.components.sanity:GetPercent() < target.components.health:GetPercent() then
            target.components.sanity:DoDelta(math.ceil(target.components.sanity.max * restorePercent))
        else
            target.components.health:DoDelta(
                math.ceil(target.components.health:GetMaxWithPenalty() * restorePercent), nil, "fhl_x2")
        end
    else
        inst.components.debuff:Stop()
    end
end

local function OnAttached(inst, target)
    inst.entity:SetParent(target.entity)
    inst.Transform:SetPosition(0, 0, 0) --in case of loading
    inst.task = inst:DoPeriodicTask(2, OnTick, nil, target)
    inst:ListenForEvent("death", function()
        inst.components.debuff:Stop()
    end, target)
end

local function OnTimerDone(inst, data)
    if data.name == "x2buffover" then
        inst.components.debuff:Stop()
    end
end

local function OnExtended(inst, target)
    inst.components.timer:StopTimer("x2buffover")
    inst.components.timer:StartTimer("x2buffover", 21)
    inst.task:Cancel()
    inst.task = inst:DoPeriodicTask(2, OnTick, nil, target)
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
    inst.components.debuff:SetDetachedFn(inst.Remove)
    inst.components.debuff:SetExtendedFn(OnExtended)
    inst.components.debuff.keepondespawn = true

    inst:AddComponent("timer")
    inst.components.timer:StartTimer("x2buffover", 21)
    inst:ListenForEvent("timerdone", OnTimerDone)

    return inst
end

return Prefab("buff_x2", fn)
