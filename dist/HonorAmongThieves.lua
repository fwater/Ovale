local OVALE, Ovale = ...
local OvaleHonorAmongThieves = Ovale:NewModule("OvaleHonorAmongThieves", "AceEvent-3.0")
Ovale.OvaleHonorAmongThieves = OvaleHonorAmongThieves
local OvaleAura = nil
local OvaleData = nil
local API_GetTime = GetTime
local INFINITY = math.huge
local self_playerGUID = nil
local HONOR_AMONG_THIEVES = 51699
local MEAN_TIME_TO_HAT = 2.2
OvaleHonorAmongThieves.spellName = "Honor Among Thieves Cooldown"
OvaleHonorAmongThieves.spellId = HONOR_AMONG_THIEVES
OvaleHonorAmongThieves.start = 0
OvaleHonorAmongThieves.ending = 0
OvaleHonorAmongThieves.duration = MEAN_TIME_TO_HAT
OvaleHonorAmongThieves.stacks = 0
local OvaleHonorAmongThieves = __class()
function OvaleHonorAmongThieves:OnInitialize()
    OvaleAura = Ovale.OvaleAura
    OvaleData = Ovale.OvaleData
end
function OvaleHonorAmongThieves:OnEnable()
    if Ovale.playerClass == "ROGUE" then
        self_playerGUID = Ovale.playerGUID
        self:RegisterMessage("Ovale_SpecializationChanged")
    end
end
function OvaleHonorAmongThieves:OnDisable()
    if Ovale.playerClass == "ROGUE" then
        self:UnregisterMessage("Ovale_SpecializationChanged")
    end
end
function OvaleHonorAmongThieves:Ovale_SpecializationChanged(event, specialization, previousSpecialization)
    if specialization == "subtlety" then
        self:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED")
    else
        self:UnregisterEvent("COMBAT_LOG_EVENT_UNFILTERED")
    end
end
function OvaleHonorAmongThieves:COMBAT_LOG_EVENT_UNFILTERED(event, timestamp, cleuEvent, hideCaster, sourceGUID, sourceName, sourceFlags, sourceRaidFlags, destGUID, destName, destFlags, destRaidFlags, ...)
    local arg12, arg13, arg14, arg15, arg16, arg17, arg18, arg19, arg20, arg21, arg22, arg23, arg24, arg25 = ...
    if sourceGUID == self_playerGUID and destGUID == self_playerGUID and cleuEvent == "SPELL_ENERGIZE" then
        local spellId, powerType = arg12, arg16
        if spellId == HONOR_AMONG_THIEVES and powerType == 4 then
            local now = API_GetTime()
            self.start = now
            local duration = OvaleData:GetSpellInfoProperty(HONOR_AMONG_THIEVES, now, "duration", destGUID) or MEAN_TIME_TO_HAT
            self.duration = duration
            self.ending = self.start + duration
            self.stacks = 1
            OvaleAura:GainedAuraOnGUID(self_playerGUID, self.start, self.spellId, self_playerGUID, "HELPFUL", nil, nil, self.stacks, nil, self.duration, self.ending, nil, self.spellName, nil, nil, nil)
        end
    end
end