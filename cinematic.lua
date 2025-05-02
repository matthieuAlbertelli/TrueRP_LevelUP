-- cinematic.lua

TrueRP_LevelUp = TrueRP_LevelUp or {}

local cameraActive = false

local cinematicFrame = TRP_CinematicFrame
local levelText = TRP_CinematicFrameLevelText
local narrativeText = TRP_CinematicFrameNarrativeText
local continueButton = TRP_CinematicFrameContinueButton

function TrueRP_LevelUp:StartCinematicLevelUp(level)
    if not cinematicFrame or not levelText or not narrativeText or not continueButton then
        print("Erreur: interface cinématique non prête.")
        return
    end

    if InCombatLockdown() then
        self.pendingCinematic = level
        self:RegisterEvent("PLAYER_REGEN_ENABLED")
        return
    end

    SetCVar("Sound_EnableAmbience", 0)
    StopMusic()
    PlayMusic("Interface\\AddOns\\TrueRP_LevelUp\\Media\\arbiters_chamber_revelation_heroic.mp3")

    cameraActive = true
    MoveViewRightStart(0.03)

    narrativeText:SetFont("Fonts\\FRIZQT__.TTF", 32, "")
    narrativeText:SetText("|cffaaaaffVous poursuivez votre ascension vers le niveau|r")

    levelText:SetFont("Fonts\\FRIZQT__.TTF", 120, "OUTLINE")
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

    continueButton:Hide()
    continueButton:SetText("|cffffff88Montée de niveau|r")
    continueButton:GetFontString():SetFont("Fonts\\FRIZQT__.TTF", 28, "OUTLINE")

    continueButton:SetScript("OnClick", function()
        StopMusic()
        self:StopCinematicCamera()
        cinematicFrame:Hide()
        PlayMusic("Interface\\AddOns\\TrueRP_LevelUp\\Media\\arbiters_chamber_revelation_C.mp3")
        self:BuildTalentUI()
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
