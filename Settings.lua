local ADDON_NAME, NS = ...

local function BuildPanel()
    local category, layout = Settings.RegisterVerticalLayoutCategory(ADDON_NAME)
    NS.settingsCategory = category

    local function AddCheckbox(varKey, label, tooltip)
        local setting = Settings.RegisterAddOnSetting(
            category,
            ADDON_NAME .. "_" .. varKey,
            varKey,
            HoverIlvlDB,
            Settings.VarType.Boolean,
            label,
            HoverIlvlDB[varKey]
        )
        Settings.CreateCheckbox(category, setting, tooltip)
        return setting
    end

    local function AddSlider(varKey, label, tooltip, minV, maxV, step)
        local setting = Settings.RegisterAddOnSetting(
            category,
            ADDON_NAME .. "_" .. varKey,
            varKey,
            HoverIlvlDB,
            Settings.VarType.Number,
            label,
            HoverIlvlDB[varKey]
        )
        local options = Settings.CreateSliderOptions(minV, maxV, step)
        Settings.CreateSlider(category, setting, options, tooltip)
        return setting
    end

    AddCheckbox("tooltipEnabled", "Show item level in tooltip",
        "Adds an Item Level line to the player tooltip on hover.")
    AddCheckbox("colorize", "Colorize by gear quality",
        "Colors the number based on how it compares to your own item level.")
    AddSlider("cacheDays", "Cache duration (days)",
        "How long to remember a player's item level before re-inspecting them.", 1, 30, 1)

    local groupSet = AddCheckbox("groupFrameShown", "Show group/raid item level panel",
        "Floating panel that lists every party/raid member with their item level.")
    groupSet:SetValueChangedCallback(function(_, value)
        if NS.GroupFrame then NS.GroupFrame:SetShown(value) end
    end)

    local lockSet = AddCheckbox("groupFrameLocked", "Lock group panel position",
        "Prevent the group/raid panel from being dragged.")
    lockSet:SetValueChangedCallback(function(_, value)
        if NS.GroupFrame then NS.GroupFrame:EnableMouse(not value) end
    end)

    Settings.RegisterAddOnCategory(category)
end

SLASH_HOVERILVL1 = "/hoverilvl"
SLASH_HOVERILVL2 = "/hilvl"
SlashCmdList["HOVERILVL"] = function(msg)
    msg = (msg or ""):lower():gsub("^%s+", ""):gsub("%s+$", "")
    if msg == "show" then
        HoverIlvlDB.groupFrameShown = true
        if NS.GroupFrame then NS.GroupFrame:Show() end
    elseif msg == "hide" then
        HoverIlvlDB.groupFrameShown = false
        if NS.GroupFrame then NS.GroupFrame:Hide() end
    elseif msg == "reset" then
        NS:ClearCache()
        print("|cff7eb3ffHoverIlvl:|r cache cleared.")
    else
        if NS.settingsCategory then
            Settings.OpenToCategory(NS.settingsCategory:GetID())
        end
    end
end

NS:OnReady(function() BuildPanel() end)
