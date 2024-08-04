local function OnAttached(inst, target, followsymbol, followoffset, data)
    inst.entity:SetParent(target.entity)
    inst.Transform:SetPosition(0, 0, 0) --in case of loading
    inst:ListenForEvent("death", function()
        inst.components.debuff:Stop()
    end, target)
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
    inst.components.timer:StartTimer("zzjbuffover", 5)
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
    inst.components.timer:StartTimer("zzjbuffover", 5)
    inst:ListenForEvent("timerdone", function(inst, data)
        if data.name == "zzjbuffover" then
            inst.components.debuff:Stop()
        end
    end)

    return inst
end

return Prefab("buff_zzj", fn)
