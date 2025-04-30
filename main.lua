TrueRP_LevelUp = TrueRP_LevelUp or {}

-- Commande slash de test
SLASH_TRPLEVELUP1 = "/trplevelup"
SlashCmdList["TRPLEVELUP"] = function()
    TrueRP_LevelUp:TriggerFakeLevelUp()
end

-- Fonction de test simulant une montée de niveau
function TrueRP_LevelUp:TriggerFakeLevelUp()
    local simulatedLevel = UnitLevel("player") + 1
    self:StartCinematicLevelUp(simulatedLevel)
end

-- (Ancien debug remplacé par le lancement réel)
function TrueRP_LevelUp:OnLevelUp(level)
    self:StartCinematicLevelUp(level)
end

-- Gestion différée si en combat
local f = CreateFrame("Frame")
f:RegisterEvent("PLAYER_REGEN_ENABLED")
f:SetScript("OnEvent", function(_, event)
    if event == "PLAYER_REGEN_ENABLED" and TrueRP_LevelUp.PLAYER_REGEN_ENABLED then
        TrueRP_LevelUp:PLAYER_REGEN_ENABLED()
    end
end)
