require "behaviours/follow"
require "behaviours/faceentity"
require "behaviours/panic"

local MIN_FOLLOW_DIST = 0
local MAX_FOLLOW_DIST = 6
local TARGET_FOLLOW_DIST = 6

local function GetFaceTargetFn(inst)
    return inst.components.follower.leader
end

local function KeepFaceTargetFn(inst, target)
    return inst.components.follower.leader == target
end

local LickingBrain = Class(Brain, function(self, inst)
    Brain._ctor(self, inst)
end)

function LickingBrain:OnStart()
    local root = PriorityNode({
        Follow(self.inst, function() return self.inst.components.follower.leader end, MIN_FOLLOW_DIST,
            TARGET_FOLLOW_DIST, MAX_FOLLOW_DIST),
        FaceEntity(self.inst, GetFaceTargetFn, KeepFaceTargetFn),

    }, 0.25)
    self.bt = BT(self.inst, root)
end

return LickingBrain
