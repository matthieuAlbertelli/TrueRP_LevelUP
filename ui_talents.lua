function TrueRP_LevelUp:BuildTalentUI()
    if self.talentUI then
        self.talentUI:SetFrameStrata("FULLSCREEN_DIALOG")
        self.talentUI:Show()
        return
    end

    local ui = CreateFrame("Frame", nil, UIParent)
    ui:SetAllPoints(UIParent)
    ui:SetFrameStrata("FULLSCREEN_DIALOG")
    ui:SetBackdrop({ bgFile = "Interface\\DialogFrame\\UI-DialogBox-Background" })
    ui:SetBackdropColor(0, 0, 0, 0.85)
    self.talentUI = ui

    -- Fermer
    local close = CreateFrame("Button", nil, ui, "UIPanelCloseButton")
    close:SetPoint("TOPRIGHT", -10, -10)
    close:SetScript("OnClick", function()
        ui:Hide()
    end)

    -- Dimensions plein écran, 1/3 chacun
    local screenWidth = UIParent:GetWidth()
    local screenHeight = UIParent:GetHeight()
    local panelWidth = screenWidth / 3
    local panelHeight = screenHeight

    self.talentPanels = {}

    for i = 1, 3 do
        local panel = CreateFrame("Frame", nil, ui)
        panel:SetSize(panelWidth, panelHeight)
        panel:SetPoint("TOPLEFT", (i - 1) * panelWidth, 0)
        panel:SetBackdrop({ bgFile = "Interface\\Tooltips\\UI-Tooltip-Background" })
        panel:SetBackdropColor(0.1, 0.1, 0.1, 0.9)

        local header = CreateFrame("Frame", nil, panel)
        header:SetPoint("TOPLEFT", 10, -10)
        header:SetPoint("TOPRIGHT", -10, -10)
        header:SetHeight(36)

        local icon = header:CreateTexture(nil, "ARTWORK")
        icon:SetSize(36, 36)
        icon:SetPoint("LEFT")
        icon:SetTexture("Interface\\Icons\\INV_Misc_QuestionMark")

        local title = header:CreateFontString(nil, "OVERLAY", "GameFontNormalLarge")
        title:SetPoint("LEFT", icon, "RIGHT", 10, 0)
        title:SetText("Spécialisation " .. i)

        local points = header:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
        points:SetPoint("RIGHT")
        points:SetText("0/61")

        local talentContainer = CreateFrame("Frame", nil, panel)
        talentContainer:SetPoint("TOPLEFT", 10, -50)
        talentContainer:SetPoint("BOTTOMRIGHT", -10, 10)


        self.talentPanels[i] = talentContainer
    end

    ui:Show()

    -- Crée les icônes immédiatement et proprement
    self:BuildTalentIcons()
end

function TrueRP_LevelUp:BuildTalentIcons()
    print("Building icons")
    local iconSize = 40
    local spacing = 4

    for _, container in ipairs(self.talentPanels) do
        print("Container width", container:GetWidth(), "height", container:GetHeight())

        for row = 1, 11 do
            for col = 1, 4 do
                local btn = CreateFrame("Button", nil, container)
                btn:SetSize(iconSize, iconSize)
                btn:SetPoint("TOPLEFT", (col - 1) * (iconSize + spacing), -((row - 1) * (iconSize + spacing)))
                btn:SetBackdrop({ bgFile = "Interface\\Buttons\\WHITE8x8" })
                btn:SetBackdropColor(1, 0, 0, 0.3)
                local icon = btn:CreateTexture(nil, "BACKGROUND")
                icon:SetAllPoints()
                -- icon:SetTexture("Interface\\Icons\\Spell_Nature_Null")
                icon:SetTexture("Interface\\Icons\\Ability_Warrior_Charge")
                -- (optionnel) effet survol
                btn:SetHighlightTexture("Interface\\Buttons\\ButtonHilight-Square")
            end
        end
    end
end
