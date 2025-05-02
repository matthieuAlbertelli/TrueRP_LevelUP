-- ui_talents.lua

function TrueRP_LevelUp:BuildTalentUI()
    if self.talentUI then
        self.talentUI:SetFrameStrata("FULLSCREEN_DIALOG")
        self.talentUI:Show()
        self:BuildTalentGrids() -- forcer l'affichage au cas où
        return
    end

    local ui = CreateFrame("Frame", nil, UIParent)
    ui:SetAllPoints(UIParent)
    ui:SetFrameStrata("FULLSCREEN_DIALOG")
    ui:SetBackdrop({ bgFile = "Interface\\DialogFrame\\UI-DialogBox-Background" })
    ui:SetBackdropColor(0, 0, 0, 0.85)
    self.talentUI = ui

    local close = CreateFrame("Button", nil, ui, "UIPanelCloseButton")
    close:SetPoint("TOPRIGHT", -10, -10)
    close:SetScript("OnClick", function() ui:Hide() end)

    self.talentPanels = {}

    local screenWidth = UIParent:GetWidth()
    local screenHeight = UIParent:GetHeight()
    local panelWidth = screenWidth / 3
    local panelHeight = screenHeight

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
    self:RenderTalentTree()
    -- appel direct ici
end

local function CountPointsSpentInTab(tab)
    local total = 0
    for i = 1, GetNumTalents(tab) do
        local _, _, _, _, rank = GetTalentInfo(tab, i)
        total = total + rank
    end
    return total
end

function TrueRP_LevelUp:RenderTalentTree()
    local iconSize = 80
    local spacingX = 48
    local spacingY = 32
    local numCols = 4

    local function CountPointsSpentInTab(tab)
        local total = 0
        for i = 1, GetNumTalents(tab) do
            local _, _, _, _, rank = GetTalentInfo(tab, i)
            total = total + rank
        end
        return total
    end

    for tab = 1, GetNumTalentTabs() do
        local container = self.talentPanels[tab]
        if not container then return end

        if container.talentButtons then
            for _, btn in ipairs(container.talentButtons) do
                btn:Hide()
                btn:SetParent(nil)
            end
        end
        container.talentButtons = {}

        local containerWidth = container:GetWidth()
        local containerHeight = container:GetHeight()

        local numRows = 9
        local gridWidth = numCols * iconSize + (numCols - 1) * spacingX
        local gridHeight = numRows * iconSize + (numRows - 1) * spacingY

        local offsetX = (containerWidth - gridWidth) / 2
        local offsetY = (containerHeight - gridHeight) / 2

        local pointsSpent = CountPointsSpentInTab(tab)

        for i = 1, GetNumTalents(tab) do
            local name, iconPath, tier, column, rank, maxRank, isExceptional = GetTalentInfo(tab, i)

            local row = tier + 1
            local col = column

            local x = offsetX + (col - 1) * (iconSize + spacingX)
            local y = -offsetY - (row - 1) * (iconSize + spacingY)

            local btn = CreateFrame("Button", nil, container)
            btn:SetSize(iconSize, iconSize)
            btn:SetPoint("TOPLEFT", x, y)

            local icon = btn:CreateTexture(nil, "ARTWORK")
            icon:SetAllPoints()
            icon:SetTexture(iconPath)

            -- Bloc contenant le rang
            local rankFrame = CreateFrame("Frame", nil, btn)
            rankFrame:SetSize(38, 24)
            rankFrame:SetPoint("CENTER", btn, "BOTTOM", 0, 0)
            rankFrame:SetBackdrop({
                bgFile = "Interface\\ChatFrame\\ChatFrameBackground",
                edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border",
                tile = true,
                tileSize = 16,
                edgeSize = 12,
                insets = { left = 4, right = 4, top = 4, bottom = 4 }
            })
            rankFrame:SetBackdropColor(0, 0, 0, 0.95)

            if rank == maxRank and maxRank > 0 then
                rankFrame:SetBackdropBorderColor(1.0, 0.82, 0.0)
            else
                rankFrame:SetBackdropBorderColor(0.7, 0.7, 0.7)
            end

            local text = rankFrame:CreateFontString(nil, "OVERLAY", "GameFontNormal")
            text:SetFont("Fonts\\FRIZQT__.TTF", 18, "OUTLINE")
            text:SetPoint("CENTER")
            text:SetText(rank .. "/" .. maxRank)

            -- Déterminer si talent disponible
            local isAvailable = false
            if rank < maxRank then
                if tier == 1 then
                    isAvailable = true
                elseif pointsSpent >= (tier - 1) * 5 then
                    isAvailable = true
                end
            end

            -- Effets visuels : vert / gris
            if rank < maxRank then
                if isAvailable then
                    local green = btn:CreateTexture(nil, "OVERLAY")
                    green:SetAllPoints()
                    green:SetTexture(0.2, 0.8, 0.2, 0.3)
                    text:SetTextColor(0.2, 1.0, 0.2) -- texte en vert
                else
                    local gray = btn:CreateTexture(nil, "OVERLAY")
                    gray:SetAllPoints()
                    gray:SetTexture(0.3, 0.3, 0.3, 0.5)
                    text:SetTextColor(0.5, 0.5, 0.5) -- texte grisé
                end
            end


            table.insert(container.talentButtons, btn)
        end
    end
end

-- function TrueRP_LevelUp:BuildTalentGrids()
--     local iconSize = 80
--     local spacingX = 48
--     local spacingY = 32
--     local numCols = 4
--     local numRows = 9

--     for _, container in ipairs(self.talentPanels) do
--         local gridWidth = numCols * iconSize + (numCols - 1) * spacingX
--         local gridHeight = numRows * iconSize + (numRows - 1) * spacingY

--         local containerWidth = container:GetWidth()
--         local containerHeight = container:GetHeight()
--         local offsetX = (containerWidth - gridWidth) / 2
--         local offsetY = (containerHeight - gridHeight) / 2

--         for row = 1, numRows do
--             for col = 1, numCols do
--                 local btn = CreateFrame("Button", nil, container)
--                 btn:SetSize(iconSize, iconSize)

--                 local x = offsetX + (col - 1) * (iconSize + spacingX)
--                 local y = -offsetY - (row - 1) * (iconSize + spacingY)
--                 btn:SetPoint("TOPLEFT", x, y)

--                 local icon = btn:CreateTexture(nil, "BACKGROUND")
--                 icon:SetAllPoints()
--                 icon:SetTexture("Interface\\Icons\\Ability_Warrior_Charge")
--             end
--         end
--     end
-- end
