local ADDON_NAME, NS = ...

local DEFAULTS = {
    tooltipEnabled = true,
    colorize = true,
    cacheDays = 7,
    groupFrameShown = false,
    groupFrameLocked = false,
    groupFramePoint = { "CENTER", 0, 0 },
}

local MAX_CACHE_ENTRIES = 500
local PENDING_TIMEOUT = 5

local QUALITY_HEX = {
    higher  = "ffff8000",
    equal   = "ffa335ee",
    blue    = "ff0070dd",
    green   = "ff1eff00",
    lower   = "ffffffff",
    pending = "ff888888",
}

NS.db = nil
NS.readyHandlers = {}
NS.cacheCallbacks = {}

local pending = { guid = nil, unit = nil, time = 0 }

local function CacheTTL()
    return (NS.db and NS.db.cacheDays or DEFAULTS.cacheDays) * 86400
end

local function GetCachedIlvl(guid)
    if not NS.db or not NS.db.cache then return nil end
    local entry = NS.db.cache[guid]
    if entry and (time() - entry.time) < CacheTTL() then
        return entry.ilvl
    end
    return nil
end

local function StoreIlvl(guid, ilvl, unit)
    NS.db.cache = NS.db.cache or {}
    local name, _, class
    if unit then
        name = UnitName(unit)
        _, class = UnitClass(unit)
    end
    NS.db.cache[guid] = {
        ilvl = math.floor(ilvl + 0.5),
        time = time(),
        name = name,
        class = class,
    }
    for _, fn in ipairs(NS.cacheCallbacks) do
        pcall(fn, guid, NS.db.cache[guid].ilvl)
    end
end

local function GarbageCollectCache()
    if not NS.db.cache then return end
    local ttl = CacheTTL()
    local now = time()
    local entries = {}
    for guid, entry in pairs(NS.db.cache) do
        if (now - entry.time) >= ttl then
            NS.db.cache[guid] = nil
        else
            entries[#entries + 1] = { guid = guid, t = entry.time }
        end
    end
    if #entries > MAX_CACHE_ENTRIES then
        table.sort(entries, function(a, b) return a.t < b.t end)
        for i = 1, #entries - MAX_CACHE_ENTRIES do
            NS.db.cache[entries[i].guid] = nil
        end
    end
end

local function ColorHexForIlvl(ilvl)
    if not NS.db or not NS.db.colorize then return QUALITY_HEX.blue end
    local playerIlvl = math.floor(GetAverageItemLevel() or 0)
    if playerIlvl == 0 then return QUALITY_HEX.blue end
    local diff = ilvl - playerIlvl
    if diff >= 10 then return QUALITY_HEX.higher
    elseif diff >= 0 then return QUALITY_HEX.equal
    elseif diff >= -10 then return QUALITY_HEX.blue
    elseif diff >= -20 then return QUALITY_HEX.green
    else return QUALITY_HEX.lower end
end

local function FormatTooltipLine(ilvl)
    return string.format("|cff7eb3ffItem Level:|r |c%s%d|r", ColorHexForIlvl(ilvl), ilvl)
end

local function RequestInspect(unit, guid)
    if not CanInspect(unit) then return false end
    if InspectFrame and InspectFrame:IsShown() then return false end
    if pending.guid == guid and (GetTime() - pending.time) < PENDING_TIMEOUT then
        return false
    end
    pending.guid = guid
    pending.unit = unit
    pending.time = GetTime()
    NotifyInspect(unit)
    return true
end

function NS:GetIlvl(guid)
    return GetCachedIlvl(guid)
end

function NS:ColorHex(ilvl)
    return ColorHexForIlvl(ilvl)
end

function NS:RegisterCacheCallback(fn)
    table.insert(self.cacheCallbacks, fn)
end

function NS:OnReady(fn)
    if self.db then fn() else table.insert(self.readyHandlers, fn) end
end

function NS:RequestInspectForUnit(unit)
    if not UnitExists(unit) or not UnitIsPlayer(unit) then return false end
    local guid = UnitGUID(unit)
    if not guid then return false end
    if GetCachedIlvl(guid) then return false end
    if not UnitIsVisible(unit) then return false end
    return RequestInspect(unit, guid)
end

function NS:ClearCache()
    NS.db.cache = {}
end

local frame = CreateFrame("Frame")
frame:RegisterEvent("ADDON_LOADED")
frame:RegisterEvent("INSPECT_READY")
frame:SetScript("OnEvent", function(self, event, arg1)
    if event == "ADDON_LOADED" and arg1 == ADDON_NAME then
        HoverIlvlDB = HoverIlvlDB or {}
        for k, v in pairs(DEFAULTS) do
            if HoverIlvlDB[k] == nil then HoverIlvlDB[k] = v end
        end
        HoverIlvlDB.cache = HoverIlvlDB.cache or {}
        NS.db = HoverIlvlDB
        GarbageCollectCache()
        for _, fn in ipairs(NS.readyHandlers) do pcall(fn) end
        NS.readyHandlers = nil
    elseif event == "INSPECT_READY" then
        local guid = arg1
        if guid ~= pending.guid then return end
        local unit = pending.unit
        if unit and UnitExists(unit) and UnitGUID(unit) == guid then
            local ilvl = C_PaperDollInfo.GetInspectItemLevel(unit)
            if ilvl and ilvl > 0 then
                StoreIlvl(guid, ilvl, unit)
                if GameTooltip:IsShown() and UnitExists("mouseover") and UnitGUID("mouseover") == guid then
                    GameTooltip:SetUnit("mouseover")
                end
            end
        end
        pending.guid = nil
        pending.unit = nil
        ClearInspectPlayer()
    end
end)

local function OnTooltipUnit(tooltip, data)
    if tooltip ~= GameTooltip then return end
    if not NS.db or not NS.db.tooltipEnabled then return end

    local guid = data and data.guid
    local unit
    if not guid then
        _, unit = tooltip:GetUnit()
        if unit then guid = UnitGUID(unit) end
    end
    if not guid or not guid:match("^Player%-") then return end

    local ilvl = GetCachedIlvl(guid)
    if ilvl then
        tooltip:AddLine(FormatTooltipLine(ilvl))
        return
    end

    if not unit then
        _, unit = tooltip:GetUnit()
    end
    if unit and UnitIsVisible(unit) and CanInspect(unit) then
        RequestInspect(unit, guid)
    end
end

if TooltipDataProcessor and Enum and Enum.TooltipDataType then
    TooltipDataProcessor.AddTooltipPostCall(Enum.TooltipDataType.Unit, OnTooltipUnit)
else
    GameTooltip:HookScript("OnTooltipSetUnit", OnTooltipUnit)
end
