-- cinematic.lua

TrueRP_LevelUp = TrueRP_LevelUp or {}

local cinematicFrame, levelText, narrativeText, continueButton
local cameraActive = false

function TrueRP_LevelUp:StartCinematicLevelUp(level)
    if InCombatLockdown() then
        self.pendingCinematic = level
        self:RegisterEvent("PLAYER_REGEN_ENABLED")
        return
    end

    self:BuildCinematicFrame()

    SetCVar("Sound_EnableAmbience", 0)

    StopMusic()
    C_Timer.After(0.1, function()
        PlayMusic("Interface\\AddOns\\TrueRP_LevelUp\\Media\\arbiters_chamber_revelation_heroic.mp3")
    end)

    cameraActive = true
    MoveViewRightStart(0.03)

    narrativeText:SetText("|cffaaaaffVous poursuivez votre ascension vers le niveau|r")
    levelText:SetText("|cffffff00" .. level .. "|r")

    cinematicFrame:Show()
    cinematicFrame:SetAlpha(0)
    cinematicFrame:SetScript("OnUpdate", function(self, elapsed)
        local alpha = self:GetAlpha() + elapsed / 2
        if alpha >= 1 then
            self:SetAlpha(1)
            self:SetScript("OnUpdate", nil)
        else
            self:SetAlpha(alpha)
        end
    end)

    C_Timer.After(3, function()
        continueButton:Show()
    end)
end

function TrueRP_LevelUp:PLAYER_REGEN_ENABLED()
    self:UnregisterEvent("PLAYER_REGEN_ENABLED")
    if self.pendingCinematic then
        local level = self.pendingCinematic
        self.pendingCinematic = nil
        self:StartCinematicLevelUp(level)
    end
end

function TrueRP_LevelUp:StopCinematicCamera()
    if cameraActive then
        CameraZoomOut(2)
        MoveViewRightStop()
        cameraActive = false
    end
end

function TrueRP_LevelUp:BuildCinematicFrame()
    local blackoutFrame = CreateFrame("Frame", nil, UIParent)
    blackoutFrame:SetAllPoints(UIParent)
    blackoutFrame:SetFrameStrata("FULLSCREEN")
    blackoutFrame:SetBackdrop({ bgFile = "Interface\\DialogFrame\\UI-DialogBox-Background" })
    blackoutFrame:SetBackdropColor(0, 0, 0, 0.25)
    blackoutFrame:Show()

    cinematicFrame = CreateFrame("Frame", nil, blackoutFrame)
    cinematicFrame:SetAllPoints(UIParent)
    cinematicFrame:SetFrameStrata("FULLSCREEN_DIALOG")

    SetCVar("Sound_EnableAmbience", 1)
    cinematicFrame:Hide()

    narrativeText = cinematicFrame:CreateFontString(nil, "ARTWORK", "GameFontNormalHuge")
    narrativeText:SetPoint("CENTER", 0, 50)
    narrativeText:SetTextColor(1, 1, 1)
    narrativeText:SetJustifyH("CENTER")

    levelText = cinematicFrame:CreateFontString(nil, "OVERLAY")
    levelText:SetFontObject(nil)
    levelText:SetFont("Fonts\\FRIZQT__.TTF", 120, "OUTLINE")
    levelText:SetPoint("CENTER", 0, 0)

    continueButton = CreateFrame("Button", nil, cinematicFrame, "UIPanelButtonTemplate")
    continueButton:SetText("|cffffff88Montée de niveau|r")
    continueButton:GetFontString():SetFont("Fonts\\FRIZQT__.TTF", 20, "OUTLINE")
    continueButton:SetWidth(240)
    continueButton:SetHeight(60)
    continueButton:SetPoint("TOP", levelText, "BOTTOM", 0, -20)
    continueButton:Hide()
    continueButton:SetBackdrop({ bgFile = "Interface\\Buttons\\WHITE8x8" })
    continueButton:SetBackdropBorderColor(1, 1, 0.3, 0.8)
    continueButton:SetBackdropColor(1, 1, 0.3, 0.2)
    continueButton:SetSize(280, 80)

    local t = 0
    continueButton:SetScript("OnUpdate", function(self, elapsed)
        t = t + elapsed
        local alpha = 0.2 + 0.1 * math.sin(t * 4)
        self:SetBackdropColor(1, 1, 0.3, alpha)
    end)

    continueButton:SetScript("OnClick", function()
        StopMusic()
        TrueRP_LevelUp:StopCinematicCamera()
        cinematicFrame:Hide()
        PlayMusic("Interface\\AddOns\\TrueRP_LevelUp\\Media\\arbiters_chamber_revelation_C.mp3")
        TrueRP_LevelUp:BuildTalentUI()
    end)
end
