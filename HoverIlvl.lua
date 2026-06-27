local ADDON_NAME = ...

local CACHE_DURATION = 120
local PENDING_TIMEOUT = 5

local cache = {}
local pending = { guid = nil, unit = nil, time = 0 }

local function FormatLine(ilvl)
    return string.format("|cff7eb3ffItem Level:|r |cffffd100%d|r", ilvl)
end

local function GetCachedIlvl(guid)
    local entry = cache[guid]
    if entry and (GetTime() - entry.time) < CACHE_DURATION then
        return entry.ilvl
    end
    return nil
end

local function RequestInspect(unit, guid)
    if not CanInspect(unit) then return end
    if InspectFrame and InspectFrame:IsShown() then return end
    if pending.guid == guid and (GetTime() - pending.time) < PENDING_TIMEOUT then
        return
    end
    pending.guid = guid
    pending.unit = unit
    pending.time = GetTime()
    NotifyInspect(unit)
end

local frame = CreateFrame("Frame")
frame:RegisterEvent("INSPECT_READY")
frame:SetScript("OnEvent", function(self, event, guid)
    if event ~= "INSPECT_READY" then return end
    if guid ~= pending.guid then return end

    local unit = pending.unit
    if unit and UnitExists(unit) and UnitGUID(unit) == guid then
        local ilvl = C_PaperDollInfo.GetInspectItemLevel(unit)
        if ilvl and ilvl > 0 then
            cache[guid] = { ilvl = math.floor(ilvl + 0.5), time = GetTime() }
            if GameTooltip:IsShown() and UnitExists("mouseover") and UnitGUID("mouseover") == guid then
                GameTooltip:SetUnit("mouseover")
            end
        end
    end

    pending.guid = nil
    pending.unit = nil
    ClearInspectPlayer()
end)

local function OnTooltipUnit(tooltip)
    if tooltip ~= GameTooltip then return end

    local _, unit = tooltip:GetUnit()
    if not unit or not UnitIsPlayer(unit) then return end

    local guid = UnitGUID(unit)
    if not guid then return end

    local ilvl = GetCachedIlvl(guid)
    if ilvl then
        tooltip:AddLine(FormatLine(ilvl))
    elseif UnitIsVisible(unit) and CanInspect(unit) then
        RequestInspect(unit, guid)
    end
end

if TooltipDataProcessor and Enum and Enum.TooltipDataType then
    TooltipDataProcessor.AddTooltipPostCall(Enum.TooltipDataType.Unit, OnTooltipUnit)
else
    GameTooltip:HookScript("OnTooltipSetUnit", OnTooltipUnit)
end
