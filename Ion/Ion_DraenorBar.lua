--Ion Stance Action Bar, a World of Warcraft® user interface addon.
--Copyright© 2006-2012 Connor H. Chenoweth, aka Maul - All rights reserved.

local ION, GDB, CDB, PEW = Ion

ION.DRAENORBTNIndex = {}

local DRAENORBTNIndex = ION.DRAENORBTNIndex


local draenorbarsGDB, draenorbarsCDB, draenorbtnsGDB, draenorbtnsCDB

local BUTTON = ION.BUTTON
local BAR = ION.BAR

local DRAENORBTN = setmetatable({}, { __index = CreateFrame("CheckButton") })

local STORAGE = CreateFrame("Frame", nil, UIParent)

local L = LibStub("AceLocale-3.0"):GetLocale("Ion")

local	SKIN = LibStub("Masque", true)

local sIndex = ION.sIndex

local gDef = {
	hidestates = ":",
	snapTo = false,
	snapToFrame = false,
	snapToPoint = false,
	point = "BOTTOM",
	x = 0,
	y = 226,
	border = true,
}


local GetParentKeys = ION.GetParentKeys


local configData = {
	stored = false,
}

local keyData = {
	hotKeys = ":",
	hotKeyText = ":",
	hotKeyLock = false,
	hotKeyPri = false,
}

local alphaTimer, alphaDir = 0, 0

local function controlOnUpdate(self, elapsed)

	alphaTimer = alphaTimer + elapsed * 2.5

	if (alphaDir == 1) then
		if (1-alphaTimer <= 0) then
			alphaDir = 0; alphaTimer = 0
		end
	else
		if (alphaTimer >= 1) then
			alphaDir = 1; alphaTimer = 0
		end
	end

end

--- Updates button's texture
--@pram: force - (boolean) will force a texture update

--UPDATE?
function DRAENORBTN:STANCE_UpdateButton(actionID)
	if (self.editmode) then
		self.iconframeicon:SetVertexColor(0.2, 0.2, 0.2)
	elseif (self.spellName) then
		self.iconframeicon:SetVertexColor(1.0, 1.0, 1.0)
	else
		self.iconframeicon:SetVertexColor(0.4, 0.4, 0.4)

	end
	self.iconframeicon:SetVertexColor(1.0, 1.0, 1.0)

end

function DRAENORBTN:OnUpdate(elapsed)
	self.elapsed = self.elapsed + elapsed

	if (self.elapsed > IonGDB.throttle) then
		self:STANCE_UpdateButton(self.actionID)
	end
end


function DRAENORBTN:PLAYER_ENTERING_WORLD(event, ...)
	self.binder:ApplyBindings(self)
	self.updateRightClick = false
	--self:STANCE_UpdateCooldown()
end

local function DraenorZoneAbilityFrame_Update(self)
	if (not self.baseName) then
		return;
	end
	local name, _, tex, _, _, _, spellID = GetSpellInfo(self.baseName);

	self.CurrentTexture = tex;
	self.CurrentSpell = name;
	self.style:SetTexture(ZONE_SPELL_ABILITY_TEXTURES_BASE[spellID] or ZONE_SPELL_ABILITY_TEXTURES_BASE_FALLBACK);
	self.iconframeicon:SetTexture(tex);

	--self.SpellButton.Style:SetTexture(ZONE_SPELL_ABILITY_TEXTURES_BASE[spellID] or ZONE_SPELL_ABILITY_TEXTURES_BASE_FALLBACK);
	--self.SpellButton.Icon:SetTexture(tex);


	if draenorbarsGDB[1].border then 

		self.style:Show()
	else
		self.style:Hide()
	end


	local charges, maxCharges, chargeStart, chargeDuration = GetSpellCharges(spellID);

	local usesCharges = false;
	if (maxCharges and maxCharges > 1) then
		self.count:SetText(charges);
		usesCharges = true;
	else
		self.count:SetText("");
	end

	local start, duration, enable = GetSpellCooldown(name);
	
	if (usesCharges and charges < maxCharges) then
		StartChargeCooldown(self, chargeStart, chargeDuration, enable);
	end

				--if (duration and duration >= IonGDB.timerLimit and self.iconframeaurawatch.active) then
				--self.auraQueue = self.iconframeaurawatch.queueinfo
				--self.iconframeaurawatch.duration = 0
				--self.iconframeaurawatch:Hide()
			--end
	if (start) then
		--CooldownFrame_SetTimer(self.SpellButton.Cooldown, start, duration, enable);
		self:SetTimer(self.iconframecooldown, start, duration, enable, self.cdText, self.cdcolor1, self.cdcolor2, self.cdAlpha)
	end

	self.spellName = self.CurrentSpell;
	self.spellID = spellID;

	if (self.spellName and not InCombatLockdown()) then
			self:SetAttribute("*macrotext1", "/cast Garrison Ability();")
	end
end

function DRAENORBTN:OnEvent(event, ...)
	local spellID, garrisonType = GetZoneAbilitySpellInfo();

	--if (event == "SPELLS_CHANGED") then
	if ((event == "SPELLS_CHANGED" or event=="UNIT_AURA") and self.spellID ~= spellID) then
		--if (not self.baseName) then
			self.baseName = GetSpellInfo(spellID);
		--end
	end

	if (not self.baseName) then
		return;
	end

	self.spellID = spellID;
	local lastState = self.BuffSeen;
	self.BuffSeen = (spellID ~= 0);

	--local display = false
	--self:SetChecked(nil)
	--self.BuffSeen = HasDraenorZoneAbility();

	if (self.BuffSeen) then
		--if ( not GetCVarBitfield("closedInfoFrames", LE_FRAME_TUTORIAL_GARRISON_ZONE_ABILITY) ) then
		if ( not GetCVarBitfield("closedInfoFrames", LE_FRAME_TUTORIAL_GARRISON_ZONE_ABILITY) and garrisonType == LE_GARRISON_TYPE_6_0 ) then

			ZoneAbilityButtonAlert:SetParent("IonDraenorActionButton1")
			ZoneAbilityButtonAlert:SetPoint("BOTTOM" ,"IonDraenorActionButton1" ,"TOP" ,0,8)
			ZoneAbilityButtonAlert:SetHeight(ZoneAbilityButtonAlert.Text:GetHeight()+42);
			
			SetCVarBitfield( "closedInfoFrames", LE_FRAME_TUTORIAL_GARRISON_ZONE_ABILITY, true );
		end

		display = true
		DraenorZoneAbilityFrame_Update(self);
	else
		if (not self.CurrentTexture) then
			self.CurrentTexture = select(3, GetSpellInfo(self.baseName));
		end
		display = false
	end

	if (not InCombatLockdown() and display) then
		self:Show();
		ZoneAbilityButtonAlert:Show();
	elseif (not InCombatLockdown() and not display) then
		self:Hide();
		ZoneAbilityButtonAlert:Hide();
	end
end


function DRAENORBTN:SetTooltip()
	if (GetSpellInfo(DraenorZoneAbilitySpellID)) then
		if (self.UberTooltips) then
			GameTooltip:SetSpellByID(self.spellID)
		else
			GameTooltip:SetText(self.tooltipName)
		end

		if (not edit) then
			self.UpdateTooltip = self.SetTooltip
		end
	elseif (edit) then
		GameTooltip:SetText(L.EMPTY_PETBTN)
	end

end


function DRAENORBTN:OnEnter(...)

	if (self.bar) then
		if (self.tooltipsCombat and InCombatLockdown()) then
			return
		end
		if (self.tooltips) then
			if (self.tooltipsEnhanced) then
				self.UberTooltips = true
				GameTooltip_SetDefaultAnchor(GameTooltip, self)
			else
				self.UberTooltips = false
				GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
			end

			self:SetTooltip()

			GameTooltip:Show()
		end
	end
end


function DRAENORBTN:OnLeave ()
	GameTooltip:Hide()
end


function DRAENORBTN:SetData(bar)

	if (bar) then

		self.bar = bar

		self.cdText = bar.cdata.cdText

		if (bar.cdata.cdAlpha) then
			self.cdAlpha = 0.2
		else
			self.cdAlpha = 1
		end

		self.barLock = bar.cdata.barLock
		self.barLockAlt = bar.cdata.barLockAlt
		self.barLockCtrl = bar.cdata.barLockCtrl
		self.barLockShift = bar.cdata.barLockShift

		self.upClicks = bar.cdata.upClicks
		self.downClicks = bar.cdata.downClicks

		self.bindText = bar.cdata.bindText

		self.tooltips = bar.cdata.tooltips
		self.tooltipsEnhanced = bar.cdata.tooltipsEnhanced
		self.tooltipsCombat = bar.cdata.tooltipsCombat

		self:SetFrameStrata(bar.gdata.objectStrata)

		self:SetScale(bar.gdata.scale)

	end

	local down, up = "", ""

	if (self.upClicks) then up = up.."LeftButtonUp" end
	if (self.downClicks) then down = down.."LeftButtonDown" end

	self:RegisterForClicks(down, up)
	self:RegisterForDrag("LeftButton", "RightButton")

	self.cdcolor1 = { 1, 0.82, 0, 1 }
	self.cdcolor2 = { 1, 0.1, 0.1, 1 }
	self.auracolor1 = { 0, 0.82, 0, 1 }
	self.auracolor2 = { 1, 0.1, 0.1, 1 }
	self.buffcolor = { 0, 0.8, 0, 1 }
	self.debuffcolor = { 0.8, 0, 0, 1 }
	self.manacolor = { 0.5, 0.5, 1.0 }
	self.rangecolor = { 0.7, 0.15, 0.15, 1 }
	self.skincolor = {1,1,1,1,1}
	self:SetFrameLevel(4)
	self.iconframe:SetFrameLevel(2)
	self.iconframecooldown:SetFrameLevel(3)
	--self.iconframeaurawatch:SetFrameLevel(3)
	self.iconframeicon:SetTexCoord(0.05,0.95,0.05,0.95)

	self:GetSkinned()


end

function DRAENORBTN:SaveData()
	-- empty
end

function DRAENORBTN:LoadData(spec, state)

	local id = self.id

	self.GDB = draenorbtnsGDB
	self.CDB = draenorbtnsCDB

	if (self.GDB and self.CDB) then

		if (not self.GDB[id]) then
			self.GDB[id] = {}
		end

		if (not self.GDB[id].config) then
			self.GDB[id].config = CopyTable(configData)
		end

		if (not self.GDB[id].keys) then
			self.GDB[id].keys = CopyTable(keyData)
		end

		if (not self.CDB[id]) then
			self.CDB[id] = {}
		end

		if (not self.CDB[id].keys) then
			self.CDB[id].keys = CopyTable(keyData)
		end

		if (not self.CDB[id].data) then
			self.CDB[id].data = {}
		end

		ION:UpdateData(self.GDB[id].config, configData)
		ION:UpdateData(self.GDB[id].keys, keyData)

		self.config = self.GDB [id].config

		if (CDB.perCharBinds) then
			self.keys = self.CDB[id].keys
		else
			self.keys = self.GDB[id].keys
		end

		self.data = self.CDB[id].data
	end
end

function DRAENORBTN:SetGrid(show, hide)

	if (true) then return end

	if (not InCombatLockdown()) then

		local texture, name, isActive, isCastable = GetShapeshiftFormInfo(self.id);
		self:SetAttribute("isshown", self.showGrid)
		self:SetAttribute("showgrid", show)

		if (show or self.showGrid) then
			self:Show()
		elseif (not (self:IsMouseOver() and self:IsVisible()) and not texture) then
			self:Hide()
		end
	end
end

function DRAENORBTN:SetAux()
	self:SetSkinned()
end

function DRAENORBTN:LoadAux()
	self.spellID = DraenorZoneAbilitySpellID;
	self:CreateBindFrame(self.objTIndex)
	self.style = self:CreateTexture(nil, "OVERLAY")
	self.style:SetPoint("CENTER", -2, 1)
	self.style:SetWidth(190)
	self.style:SetHeight(95)
	self.hotkey:SetPoint("TOPLEFT", -4, -6)
	self.style:SetTexture("Interface\\ExtraButton\\GarrZoneAbility-Armory")
	self:Hide()
end


function DRAENORBTN:OnLoad()
	-- empty
end

function DRAENORBTN:OnShow()
	--DraenorZoneAbilityFrame_Update(self);
end
function DRAENORBTN:OnHide()
	--DraenorZoneAbilityButtonAlert:Hide();
	-- empty
end


function DRAENORBTN:UpdateFrame()
if draenorbarsGDB[1].border then 

IonDraenorActionButton1.style:Show()
else
IonDraenorActionButton1.style:Hide()
end
	-- empty
end

function DRAENORBTN:OnDragStart()
	PickupSpell(DraenorZoneAbilitySpellID)
end

function DRAENORBTN:SetDefaults()
	-- empty
end

function DRAENORBTN:GetDefaults()
	--empty
end

function DRAENORBTN:SetType(save)

	self:RegisterUnitEvent("UNIT_AURA", "player");
	self:RegisterEvent("SPELL_UPDATE_COOLDOWN");
	self:RegisterEvent("SPELL_UPDATE_USABLE");
	self:RegisterEvent("SPELL_UPDATE_CHARGES");
	self:RegisterEvent("SPELLS_CHANGED");
	self:RegisterEvent("ACTIONBAR_SLOT_CHANGED");

	self:RegisterEvent("UNIT_SPELLCAST_FAILED")
	--BUTTON.MACRO_UNIT_SPELLCAST_FAILED



	self.actionID = self.id

	self:SetAttribute("type1", "macro")
	self:SetAttribute("*action1", self.actionID)

	self:SetAttribute("useparent-unit", false)
	self:SetAttribute("unit", ATTRIBUTE_NOOP)

	self:SetScript("OnEvent", DRAENORBTN.OnEvent)
	self:SetScript("OnDragStart", DRAENORBTN.OnDragStart)
	self:SetScript("OnLoad", DRAENORBTN.OnLoad)
	self:SetScript("OnShow", DRAENORBTN.OnShow)
	self:SetScript("OnHide", DRAENORBTN.OnHide)



	self:SetScript("OnEnter", DRAENORBTN.OnEnter)
	self:SetScript("OnLeave", DRAENORBTN.OnLeave)
	self:SetScript("OnUpdate", DRAENORBTN.OnUpdate)
	self:SetScript("OnAttributeChanged", nil)
end

local function controlOnEvent(self, event, ...)

	if (event == "ADDON_LOADED" and ... == "Ion") then

		GDB = IonGDB; CDB = IonCDB

		draenorbarsGDB = GDB.draenorbars
		draenorbarsCDB = CDB.draenorbars

		draenorbtnsGDB = GDB.draenorbtns
		draenorbtnsCDB = CDB.draenorbtns

		DRAENORBTN.SetTimer = BUTTON.SetTimer
		DRAENORBTN.SetSkinned = BUTTON.SetSkinned
		DRAENORBTN.GetSkinned = BUTTON.GetSkinned
		DRAENORBTN.CreateBindFrame = BUTTON.CreateBindFrame

		ION:RegisterBarClass("draenorbar", "Draenor Action Bar", "Draenor Action Button", draenorbarsGDB, draenorbarsCDB, DRAENORBTNIndex, draenorbtnsGDB, "CheckButton", "IonActionButtonTemplate", { __index = DRAENORBTN }, 1, false, STORAGE, gDef, nil, false)

		ION:RegisterGUIOptions("draenorbar", { AUTOHIDE = true,
		                                SHOWGRID = false,
		                                SNAPTO = true,
		                                UPCLICKS = true,
		                                DOWNCLICKS = true,
		                                HIDDEN = true,
		                                LOCKBAR = false,
		                                TOOLTIPS = true,
							  BINDTEXT = true,
							  RANGEIND = true,
							  CDTEXT = true,
							  CDALPHA = true,
							  DRAENOR = true}, false, 65)

		if (GDB.draenorbarFirstRun) then

			local bar = ION:CreateNewBar("draenorbar", 1, true)
			local object = ION:CreateNewObject("draenorbar", 1)

			bar:AddObjectToList(object)

			GDB.draenorbarFirstRun = false

		else

		for id,data in pairs(draenorbarsGDB) do
				if (data ~= nil) then
					ION:CreateNewBar("draenorbar", id)
				end
			end

			for id,data in pairs(draenorbtnsGDB) do
				if (data ~= nil) then
					ION:CreateNewObject("draenorbar", id)
				end
			end
		end

		STORAGE:Hide()

	elseif (event == "PLAYER_LOGIN") then

	elseif (event == "PLAYER_ENTERING_WORLD" and not PEW) then

		PEW = true
	end
end

local frame = CreateFrame("Frame", nil, UIParent)
frame:SetScript("OnEvent", controlOnEvent)
frame:SetScript("OnUpdate", controlOnUpdate)
frame:RegisterEvent("ADDON_LOADED")
frame:RegisterEvent("PLAYER_LOGIN")
frame:RegisterEvent("PLAYER_ENTERING_WORLD")

--hooking original bar check to hide
ZoneAbilityFrame:SetScript('OnEvent', nil)
ZoneAbilityFrame:Hide()


function BAR:HideDraenorBorder(msg, gui, checked, query)
	if (query) then
		return Ion.CurrentBar.gdata.border
	end

	if (gui) then

		if (checked) then
			Ion.CurrentBar.gdata.border = true
		else
			Ion.CurrentBar.gdata.border = false
		end

	else

		local toggle = Ion.CurrentBar.gdata.border

		if (toggle) then
			Ion.CurrentBar.gdata.border = false
		else
			Ion.CurrentBar.gdata.border = true
		end
	end
	self:Update()
	DRAENORBTN:UpdateFrame()
end

--local alertframe = n