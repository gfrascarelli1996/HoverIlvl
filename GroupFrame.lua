local ADDON_NAME, NS = ...

local PADDING = 10
local LINE_HEIGHT = 16
local INSPECT_INTERVAL = 2
local FRAME_WIDTH = 180

local frame
local rows = {}
local elapsed = 0
local roundRobin = 0

local function GetMembers()
    local list = {}
    if not IsInGroup() then return list end
    if IsInRaid() then
        for i = 1, GetNumGroupMembers() do
            local unit = "raid" .. i
            if UnitExists(unit) then list[#list + 1] = unit end
        end
    else
        list[#list + 1] = "player"
        for i = 1, GetNumGroupMembers() - 1 do
            local unit = "party" .. i
            if UnitExists(unit) then list[#list + 1] = unit end
        end
    end
    return list
end

local function ClassColorHex(class)
    if not class then return "ffffffff" end
    local c = RAID_CLASS_COLORS and RAID_CLASS_COLORS[class]
    if not c then return "ffffffff" end
    if c.GenerateHexColor then return c:GenerateHexColor() end
    return string.format("ff%02x%02x%02x", (c.r or 1) * 255, (c.g or 1) * 255, (c.b or 1) * 255)
end

local function Refresh()
    if not frame then return end

    local members = GetMembers()

    if #members == 0 then
        for _, row in ipairs(rows) do row:Hide() end
        frame.empty:Show()
        frame:SetHeight(PADDING * 2 + LINE_HEIGHT)
        return
    end

    frame.empty:Hide()

    for i = #rows + 1, #members do
        local fs = frame:CreateFontString(nil, "OVERLAY", "GameFontNormal")
        fs:SetPoint("TOPLEFT", frame, "TOPLEFT", PADDING, -PADDING - (i - 1) * LINE_HEIGHT)
        fs:SetPoint("RIGHT", frame, "RIGHT", -PADDING, 0)
        fs:SetJustifyH("LEFT")
        rows[i] = fs
    end

    for i = 1, #rows do
        if i <= #members then
            local unit = members[i]
            local name = UnitName(unit) or "?"
            local _, class = UnitClass(unit)
            local guid = UnitGUID(unit)
            local ilvl = guid and NS:GetIlvl(guid)
            local ilvlStr
            if ilvl then
                ilvlStr = string.format("|c%s%d|r", NS:ColorHex(ilvl), ilvl)
            else
                ilvlStr = "|cff888888…|r"
            end
            rows[i]:SetText(string.format("|c%s%s|r  %s", ClassColorHex(class), name, ilvlStr))
            rows[i]:Show()
        else
            rows[i]:Hide()
        end
    end

    frame:SetHeight(PADDING * 2 + #members * LINE_HEIGHT)
end

local function OnUpdate(self, dt)
    if not frame:IsShown() then return end
    elapsed = elapsed + dt
    if elapsed < INSPECT_INTERVAL then return end
    elapsed = 0

    local members = GetMembers()
    if #members == 0 then return end
    for _ = 1, #members do
        roundRobin = roundRobin + 1
        if roundRobin > #members then roundRobin = 1 end
        local unit = members[roundRobin]
        local guid = unit and UnitGUID(unit)
        if guid and not NS:GetIlvl(guid) then
            if NS:RequestInspectForUnit(unit) then return end
        end
    end
end

local function CreateGroupFrame()
    frame = CreateFrame("Frame", "HoverIlvlGroupFrame", UIParent, "BackdropTemplate")
    frame:SetSize(FRAME_WIDTH, 60)
    frame:SetBackdrop({
        bgFile = "Interface\\DialogFrame\\UI-DialogBox-Background",
        edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border",
        tile = true, tileSize = 16, edgeSize = 12,
        insets = { left = 3, right = 3, top = 3, bottom = 3 }
    })
    frame:SetBackdropColor(0, 0, 0, 0.75)

    local title = frame:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
    title:SetPoint("BOTTOM", frame, "TOP", 0, 2)
    title:SetText("|cffffd100HoverIlvl|r")

    local empty = frame:CreateFontString(nil, "OVERLAY", "GameFontDisableSmall")
    empty:SetPoint("CENTER", frame, "CENTER", 0, 0)
    empty:SetText("Not in a group")
    frame.empty = empty

    frame:SetMovable(true)
    frame:EnableMouse(not NS.db.groupFrameLocked)
    frame:SetClampedToScreen(true)
    frame:RegisterForDrag("LeftButton")
    frame:SetScript("OnDragStart", frame.StartMoving)
    frame:SetScript("OnDragStop", function(self)
        self:StopMovingOrSizing()
        local p, _, _, x, y = self:GetPoint()
        NS.db.groupFramePoint = { p, x, y }
    end)

    local pt = NS.db.groupFramePoint or { "CENTER", 0, 0 }
    frame:ClearAllPoints()
    frame:SetPoint(pt[1], UIParent, pt[1], pt[2], pt[3])

    frame:RegisterEvent("GROUP_ROSTER_UPDATE")
    frame:RegisterEvent("PLAYER_ENTERING_WORLD")
    frame:RegisterEvent("PARTY_MEMBER_ENABLE")
    frame:RegisterEvent("PARTY_MEMBER_DISABLE")
    frame:SetScript("OnEvent", Refresh)
    frame:SetScript("OnUpdate", OnUpdate)
end

NS:OnReady(function()
    CreateGroupFrame()
    NS.GroupFrame = frame
    NS:RegisterCacheCallback(function() Refresh() end)
    if NS.db.groupFrameShown then frame:Show() else frame:Hide() end
    Refresh()
end)
