local TheInput = GLOBAL.TheInput

local MajorKey = {}
for i = 97, 122 do
    MajorKey["KEY_" .. string.char(i):upper()] = i
end

local function IsDefaultScreen()
    return GLOBAL.ThePlayer and GLOBAL.TheFrontEnd and GLOBAL.TheFrontEnd:GetActiveScreen() and
        GLOBAL.ThePlayer.HUD and GLOBAL.TheFrontEnd:GetActiveScreen().name and
        GLOBAL.TheFrontEnd:GetActiveScreen().name:find("HUD") and
        not GLOBAL.ThePlayer.HUD:IsChatInputScreenOpen() and
        not GLOBAL.ThePlayer.HUD:IsConsoleScreenOpen() and
        not GLOBAL.ThePlayer.HUD:IsCraftingOpen() and
        not GLOBAL.ThePlayer.HUD:HasInputFocus() and
        not GLOBAL.ThePlayer.HUD.writeablescreen
end

-- local KEY_T = GLOBAL.KEY_T
AddModRPCHandler(modname, "T", function(player)
    if not player:HasTag("playerghost") and player.prefab == "fhl" then
        if player.level > 10 then player.level = 10 end
        if player.jnd and player.je then
            player.components.talker:Say("Current State: Lv " .. (player.level) .. "  Sp " .. player.jnd ..
                "\n寒冷抗性(The cold resistance): " ..
                (player.components.temperature.inherentinsulation) .. "/240" ..
                "\n伤害减免(Damage reduction): " ..
                (player.components.health.absorb * 100) .. "%" ..
                "\n伤害提升(Damage ascension): " ..
                ((player.components.combat.damagemultiplier - 1) * 100) .. "%" ..
                "\n饥饿抗性(Hunger resistance): " .. (player.je * 5) .. "%")
        end
    end
end)

local KEY_UP = GLOBAL.KEY_UP
AddModRPCHandler(modname, "UP", function(player)
    if not player:HasTag("playerghost") and player.prefab == "fhl" then
        if player.jnd > 0 and player.components.temperature.inherentinsulation < 230 then
            player.jnd = player.jnd - 1
            player.components.temperature.inherentinsulation = player.components.temperature.inherentinsulation + 30
            player.components.talker:Say("寒冷抗性已上升!\nThe cold resistance is improved!")
        elseif player.jnd == 0 then
            player.components.talker:Say("技能点不足!\nNo skill points left!")
        else
            player.components.talker:Say("寒冷抗性已至上限!\nThe cold resistance has reached the limit!")
        end
    end
end)

local KEY_DOWN = GLOBAL.KEY_DOWN
AddModRPCHandler(modname, "DOWN", function(player)
    if not player:HasTag("playerghost") and player.prefab == "fhl" then
        if player.jnd > 0 and player.components.health.absorb < 0.8 then
            player.jnd = player.jnd - 1
            player.components.health.absorb = player.components.health.absorb + 0.05
            player.components.talker:Say("伤害减免已提升5%!\nDamage reduction is increased by 5%!")
        elseif player.jnd == 0 then
            player.components.talker:Say("技能点不足!\nNo skill points left!")
        else
            player.components.talker:Say("伤害减免已至上限!\nDamage reduction has reached the limit!")
        end
    end
end)

local KEY_LEFT = GLOBAL.KEY_LEFT
AddModRPCHandler(modname, "LEFT", function(player)
    if not player:HasTag("playerghost") and player.prefab == "fhl" then
        if player.jnd > 0 and player.components.combat.damagemultiplier < 2 then
            player.jnd = player.jnd - 1
            player.components.combat.damagemultiplier = player.components.combat.damagemultiplier + 0.1
            player.components.talker:Say("输出伤害已提升10%!\nDamage ascension has up 10%!")
        elseif player.jnd == 0 then
            player.components.talker:Say("技能点不足!\nNo skill points left!")
        else
            player.components.talker:Say("输出伤害已至上限!\nDamage ascension has reached the limit!")
        end
    end
end)

local KEY_RIGHT = GLOBAL.KEY_RIGHT
AddModRPCHandler(modname, "RIGHT", function(player)
    if not player:HasTag("playerghost") and player.prefab == "fhl" then
        if player.jnd > 0 and player.je then
            if player.components.hunger.hungerrate > 0.1 then
                -- 最多8次，达到0.09375
                player.jnd = player.jnd - 1
                player.je = player.je + 1
                player.components.hunger.hungerrate = (1 - 0.05 * player.je) * TUNING.WILSON_HUNGER_RATE
                player.components.talker:Say("饥饿抗性已提升5%!\nHunger resistance has up 5%!")
            else
                player.components.talker:Say("饥饿抗性已至上限!\nHunger resistance has to limit!")
            end
        else
            player.components.talker:Say("技能点不足!\nNo skill points left!")
        end
    end
end)

-- local KEY_R = GLOBAL.KEY_R
AddModRPCHandler(modname, "R", function(player)
    if not player:HasTag("playerghost") and player.prefab == "fhl" then
        player.components.talker:Say("你还有" .. (player.jnd) .. "点技能点!" ..
            "\nyou have " .. (player.jnd) .. " skill points!" ..
            "\n向上键提升寒冷抗性,向下键提升伤害减免" ..
            "\n向左键提升输出伤害,向右键提升饥饿抗性" ..
            "\nUsing KEY_UP to up The cold resistance, Using KEY_DOWN to up The Damage reduction" ..
            "\nUsing KEY_LEFT to up The Damage ascension, Using KEY_RIGHT to up The Hunger resistance.")
    end
end)

AddPlayerPostInit(function(inst)
    -- We hack
    inst:DoTaskInTime(0, function()
        -- We check if the character is ourselves
        -- So if another horo player joins, we don't get the handlers
        if inst == GLOBAL.ThePlayer then
            TheInput:AddKeyDownHandler(MajorKey[TUNING.STATUS_KEY], function()
                if IsDefaultScreen() then SendModRPCToServer(MOD_RPC[modname]["T"]) end
            end)
            TheInput:AddKeyDownHandler(KEY_UP, function()
                if IsDefaultScreen() then SendModRPCToServer(MOD_RPC[modname]["UP"]) end
            end)
            TheInput:AddKeyDownHandler(KEY_DOWN, function()
                if IsDefaultScreen() then SendModRPCToServer(MOD_RPC[modname]["DOWN"]) end
            end)
            TheInput:AddKeyDownHandler(KEY_LEFT, function()
                if IsDefaultScreen() then SendModRPCToServer(MOD_RPC[modname]["LEFT"]) end
            end)
            TheInput:AddKeyDownHandler(KEY_RIGHT, function()
                if IsDefaultScreen() then SendModRPCToServer(MOD_RPC[modname]["RIGHT"]) end
            end)
            TheInput:AddKeyDownHandler(MajorKey[TUNING.SKILL_POINT_KEY], function()
                if IsDefaultScreen() then SendModRPCToServer(MOD_RPC[modname]["R"]) end
            end)
        end
    end)
end)
