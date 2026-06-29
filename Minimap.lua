local ADDON_NAME, NS = ...

local BUTTON_NAME = "HoverIlvlMinimapButton"
local EDGE_OFFSET = 8
local mmButton

local function GetEdgeRadius()
    return (Minimap:GetWidth() / 2) + EDGE_OFFSET
end

local function PositionAtAngle(angle)
    if not mmButton then return end
    local radius = GetEdgeRadius()
    local rad = math.rad(angle)
    local x = math.cos(rad) * radius
    local y = math.sin(rad) * radius
    mmButton:ClearAllPoints()
    mmButton:SetPoint("CENTER", Minimap, "CENTER", x, y)
end

local function CreateMinimapButton()
    mmButton = CreateFrame("Button", BUTTON_NAME, Minimap)
    mmButton:SetSize(32, 32)
    mmButton:SetFrameStrata("MEDIUM")
    mmButton:SetFrameLevel(8)
    mmButton:RegisterForClicks("LeftButtonUp", "RightButtonUp")
    mmButton:RegisterForDrag("LeftButton")
    mmButton:SetMovable(true)

    local bg = mmButton:CreateTexture(nil, "BACKGROUND")
    bg:SetSize(20, 20)
    bg:SetPoint("CENTER", -1, 1)
    bg:SetTexture("Interface\\Minimap\\UI-Minimap-Background")
    bg:SetVertexColor(1, 1, 1, 0.6)

    local icon = mmButton:CreateTexture(nil, "ARTWORK")
    icon:SetSize(20, 20)
    icon:SetPoint("CENTER", -1, 1)
    icon:SetTexture("Interface\\AddOns\\HoverIlvl\\assets\\icon_minimap")
    icon:SetTexCoord(0.06, 0.94, 0.06, 0.94)

    local border = mmButton:CreateTexture(nil, "OVERLAY")
    border:SetSize(54, 54)
    border:SetPoint("TOPLEFT")
    border:SetTexture("Interface\\Minimap\\MiniMap-TrackingBorder")

    mmButton:SetHighlightTexture("Interface\\Minimap\\UI-Minimap-ZoomButton-Highlight")

    mmButton:SetScript("OnClick", function(self, button)
        if button == "LeftButton" then
            local shown = not NS.db.groupFrameShown
            NS.db.groupFrameShown = shown
            if NS.GroupFrame then NS.GroupFrame:SetShown(shown) end
        elseif button == "RightButton" then
            if NS.settingsCategory and Settings and Settings.OpenToCategory then
                Settings.OpenToCategory(NS.settingsCategory:GetID())
            end
        end
    end)

    mmButton:SetScript("OnEnter", function(self)
        GameTooltip:SetOwner(self, "ANCHOR_LEFT")
        GameTooltip:AddLine("|cffffd100HoverIlvl|r")
        GameTooltip:AddLine("|cffffffffLeft-click|r: toggle group/raid panel", 0.9, 0.9, 0.9)
        GameTooltip:AddLine("|cffffffffRight-click|r: open settings", 0.9, 0.9, 0.9)
        GameTooltip:AddLine("|cffffffffDrag|r: move around the minimap", 0.9, 0.9, 0.9)
        GameTooltip:Show()
    end)
    mmButton:SetScript("OnLeave", function() GameTooltip:Hide() end)

    mmButton:SetScript("OnDragStart", function(self)
        self:LockHighlight()
        self:SetScript("OnUpdate", function()
            local mx, my = GetCursorPosition()
            local scale = Minimap:GetEffectiveScale()
            mx, my = mx / scale, my / scale
            local mmX, mmY = Minimap:GetCenter()
            if not mmX then return end
            local angle = math.deg(math.atan2(my - mmY, mx - mmX))
            NS.db.minimapAngle = angle
            PositionAtAngle(angle)
        end)
    end)
    mmButton:SetScript("OnDragStop", function(self)
        self:UnlockHighlight()
        self:SetScript("OnUpdate", nil)
    end)

    PositionAtAngle(NS.db.minimapAngle or 220)
end

NS:OnReady(function()
    CreateMinimapButton()
    mmButton:SetShown(NS.db.minimapButtonShown ~= false)
    NS.MinimapButton = mmButton
end)
