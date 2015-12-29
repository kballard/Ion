--Ion, a World of Warcraft® user interface addon.
--Copyright© 2006-2014 Connor H. Chenoweth, aka Maul - All rights reserved.

Ion = {
	SLASHCMDS = {},
	SLASHHELP = {},
	sIndex = {},
	iIndex = { [1] = "INTERFACE\\ICONS\\INV_MISC_QUESTIONMARK" },
	cIndex = {},
	StanceIndex = {},
	ShowGrids = {},
	HideGrids = {},
	BARIndex = {},
	BARNameIndex = {},
	BTNIndex = {},
	EDITIndex = {},
	BINDIndex = {},
	SKINIndex = {},
	ModuleIndex = 0,
	RegisteredBarData = {},
	RegisteredGUIData = {},
	MacroDrag = {},
	StartDrag = false,
	maxActionID = 132,
	maxPetID = 10,
	OpDep = false,
}


--GlobalDB ?
IonGDB = {

	bars = {},
	buttons = {},

	xbars = {},
	xbtns = {},

	buttonLoc = { -0.85, -111.45 },
	buttonRadius = 87.5,

	throttle = 0.2,
	timerLimit = 4,
	snapToTol = 28,

	mainbar = false,
	draenorbar = false,
	vehicle = false,

	firstRun = true,
	xbarFirstRun = true,

	betaWarning = true,

	animate = true,
}

--CharacterDB?
IonCDB = {

	bars = {},
	buttons = {},

	xbars = {},
	xbtns = {},

	selfCast = false,
	focusCast = false,

	layOut = 1,

	perCharBinds = false,

	fix07312012 = false,
	fix03312014 = false,
	
	firstRun = true,

	debug = {},
}

IonSpec = { cSpec = 1 }

IonItemCache = {}

local L = LibStub("AceLocale-3.0"):GetLocale("Ion")

local ION, BAR = Ion

local BARIndex, BARNameIndex, BTNIndex, ICONS = ION.BARIndex, ION.BARNameIndex, ION.BTNIndex, ION.iIndex

local icons = {}

ION.GameVersion, ION.GameBuild, ION.GameDate, ION.TOCVersion = GetBuildInfo()

ION.GameVersion = tonumber(ION.GameVersion); ION.TOCVersion = tonumber(ION.TOCVersion)

ION.Points = { R = "RIGHT", L = "LEFT", T = "TOP", B = "BOTTOM", TL = "TOPLEFT", TR = "TOPRIGHT", BL = "BOTTOMLEFT", BR = "BOTTOMRIGHT", C = "CENTER" }

ION.Stratas = { "BACKGROUND", "LOW", "MEDIUM", "HIGH", "DIALOG", "TOOLTIP" }

ION.STATES = {

	homestate = L.HOMESTATE,
	laststate = L.LASTSTATE,
	paged1 = L.PAGED1,
	paged2 = L.PAGED2,
	paged3 = L.PAGED3,
	paged4 = L.PAGED4,
	paged5 = L.PAGED5,
	paged6 = L.PAGED6,
	pet0 = L.PET0,
	pet1 = L.PET1,
	alt0 = L.ALT0,
	alt1 = L.ALT1,
	ctrl0 = L.CTRL0,
	ctrl1 = L.CTRL1,
	shift0 = L.SHIFT0,
	shift1 = L.SHIFT1,
	stealth0 = L.STEALTH0,
	stealth1 = L.STEALTH1,
	reaction0 = L.REACTION0,
	reaction1 = L.REACTION1,
	combat0 = L.COMBAT0,
	combat1 = L.COMBAT1,
	group0 = L.GROUP0,
	group1 = L.GROUP1,
	group2 = L.GROUP2,
	fishing0 = L.FISHING0,
	fishing1 = L.FISHING1,
	vehicle0 = L.VEHICLE0,
	vehicle1 = L.VEHICLE1,
	possess0 = L.POSSESS0,
	possess1 = L.POSSESS1,
	override0 = L.OVERRIDE0,
	override1 = L.OVERRIDE1,
	extrabar0 = L.EXTRABAR0,
	extrabar1 = L.EXTRABAR1,
	prowl0 = L.PROWL0,
	prowl1 = L.PROWL1,
	custom0 = L.CUSTOM0,

}

ION.STATEINDEX = {

	paged = L.PAGED,
	stance = L.STANCE,
	pet = L.PET,
	alt = L.ALT,
	ctrl = L.CTRL,
	shift = L.SHIFT,
	stealth = L.STEALTH,
	reaction = L.REACTION,
	combat = L.COMBAT,
	group = L.GROUP,
	fishing = L.FISHING,
	vehicle = L.VEHICLE,
	possess = L.POSSESS,
	override = L.OVERRIDE,
	extrabar = L.EXTRABAR,
	prowl = L.PROWL,
	custom = L.CUSTOM,

	[L.PAGED] = "paged",
	[L.STANCE] = "stance",
	[L.PET] = "pet",
	[L.ALT] = "alt",
	[L.CTRL] = "ctrl",
	[L.SHIFT] = "shift",
	[L.STEALTH] = "stealth",
	[L.REACTION] = "reaction",
	[L.COMBAT] = "combat",
	[L.GROUP] = "group",
	[L.FISHING] = "fishing",
	[L.VEHICLE] = "vehicle",
	[L.POSSESS] = "possess",
	[L.OVERRIDE] = "override",
	[L.EXTRABAR] = "extrabar",
	[L.PROWL] = "prowl",
	[L.CUSTOM] = "custom",
}

local handler = CreateFrame("Frame", nil, UIParent, "SecureHandlerStateTemplate")

local opDepList = { "BarKeep", "Bartender4", "Dominos", "MagnetButtons", "nMainbar", "rActionBarStyler", "Orbs", "RazerNaga", "StellarBars", "Tukui", "XBar" }

local level, stanceStringsUpdated, PEW


IonProfile = LibStub("AceAddon-3.0"):NewAddon("IonProfile")

local options = {
	name = "Ion",
	type = 'group',
	args = {
		moreoptions={
			name = "Options",
			type = "group",
			args={
				AnimateIcon = {
				 name = "Animate Icon",
				 desc = "Toggles the Animation of the Ion Icon",
				 type = "toggle",
				 set = function() ION:Animate() end,
				 get = function() return IonGDB.animate end,
				 width = "full",
				},
				BlizzardBar = {
				 name = "Display Blizzard Bar",
				 desc = "Shows / Hides the Default Blizzard Bar",
				 type = "toggle",
				 set = function() ION:BlizzBar() end,
				 get = function() return IonGDB.mainbar end,
				 width = "full",
				},
				DraenorBar = {
				 name = "Display Draenor Garrison Bar",
				 desc = "Shows / Hides the Draenor Garrison Bar",
				 type = "toggle",
				 set = function() ION:DraenorBar() end,
				 get = function() return IonGDB.draenorbar end,
				 width = "full",
				},
			},
		},
	} ,
}
--ION:BlizzBar()

local defaults = {
	profile = {
		IonGDB = {

			bars = {},
			buttons = {},

			xbars = {},
			xbtns = {},

			buttonLoc = { -0.85, -111.45 },
			buttonRadius = 87.5,

			throttle = 0.2,
			timerLimit = 4,
			snapToTol = 28,

			mainbar = false,
			draenorbar = true,
			vehicle = false,

			firstRun = true,
			xbarFirstRun = true,

			betaWarning = true,

			animate = true,
		},
		IonCDB = {

			bars = {},
			buttons = {},

			xbars = {},
			xbtns = {},

			selfCast = false,
			focusCast = false,

			layOut = 1,

			perCharBinds = false,

			fix07312012 = false,
			fix03312014 = false,
			
			firstRun = true,

			debug = {},
		},
		IonSpec = { cSpec = 1 },
	},
}

local defGDB, GDB, defCDB, CDB, defSPEC, SPEC = CopyTable(IonGDB), CopyTable(IonGDB), CopyTable(IonCDB), CopyTable(IonCDB), CopyTable(IonSpec), CopyTable(IonSpec)


function ION:GetParentKeys(frame)

	if (frame == nil) then
		return
	end

	local data, childData = {}, {}
	local children, regions = { frame:GetChildren() }, { frame:GetRegions() }

	for k,v in pairs(children) do
		tinsert(data, v:GetName())
		childData = ION:GetParentKeys(v)
		for key,value in pairs(childData) do
			tinsert(data, value)
		end
	end

	for k,v in pairs(regions) do
		tinsert(data, v:GetName())
	end

	return data
end


local slashFunctions = {
	[1] = "ToggleMainMenu",
	[2] = "CreateNewBar",
	[3] = "DeleteBar",
	[4] = "ToggleBars",
	[5] = "AddObjects",
	[6] = "RemoveObjects",
	[7] = "ToggleEditFrames",
	[8] = "ToggleBindings",
	[9] = "ScaleBar",
	[10] = "SnapToBar",
	[11] = "AutoHideBar",
	[12] = "ConcealBar",
	[13] = "ShapeBar",
	[14] = "NameBar",
	[15] = "StrataSet",
	[16] = "AlphaSet",
	[17] = "AlphaUpSet",
	[18] = "ArcStartSet",
	[19] = "ArcLengthSet",
	[20] = "ColumnsSet",
	[21] = "PadHSet",
	[22] = "PadVSet",
	[23] = "PadHVSet",
	[24] = "XAxisSet",
	[25] = "YAxisSet",
	[26] = "SetState",
	[27] = "SetVisibility",
	[28] = "ShowGridSet",
	[29] = "LockSet",
	[30] = "ToolTipSet",
	[31] = "SpellGlowSet",
	[32] = "BindTextSet",
	[33] = "MacroTextSet",
	[34] = "CountTextSet",
	[35] = "CDTextSet",
	[36] = "CDAlphaSet",
	[37] = "AuraTextSet",
	[38] = "AuraIndSet",
	[39] = "UpClicksSet",
	[40] = "DownClicksSet",
	[41] = "SetTimerLimit",
	[42] = "PrintStateList",
	[43] = "PrintBarTypes",
	[44] = "BlizzBar",
	[45] = "",
	[46] = "Animate",
	[47] = "DraenorBar",
}

local count = 1

for index,func in ipairs(slashFunctions) do

	ION.SLASHCMDS[L["SLASH_CMD"..index]:lower()] = { L["SLASH_CMD"..index], L["SLASH_CMD"..index.."_DESC"], func }

	if (func and #func > 0) then
		ION.SLASHHELP[count] = "       |cff00ff00"..L["SLASH_CMD"..index].."|r: "..L["SLASH_CMD"..index.."_DESC"]
		count = count + 1
	end
end

-- "()" indexes added because the Blizzard macro parser uses that to determine the difference of a spell versus a usable item if the two happen to have the same name.
-- I forgot this fact and removed using "()" and it made some macros not represent the right spell /sigh. This note is here so I do not forget again :P


local OverlapTalentNames = {
	[106707] = true,
	[175682] = true, --Druid l45 talent spell placeholder
	[102355] = true, --Fairy Swarm Spell
}

--- Returns a list of the available spell icon filenames for use in macros
-- @param spellIndexName, index, bookType, spellName, altName, subName, spellID, spellID_Alt, spellType, spellLvl, isPassive, icon
-- @return N/A
local function SetSpellInfo(spellIndexName, index, bookType, spellName, altName, subName, spellID, spellID_Alt, spellType, spellLvl, isPassive, icon)

	local curSpell = spellIndexName
	curSpell.index = index
	curSpell.booktype = bookType
	curSpell.spellName = spellName
	curSpell.altName = altName
	curSpell.subName = subName
	curSpell.spellID = spellID
	curSpell.spellID_Alt = spellID_Alt
	curSpell.spellType = spellType
	curSpell.spellLvl = spellLvl
	curSpell.isPassive = isPassive
	curSpell.icon = icon
end



--- Scans Character Spell Book and creates a table of all known spells 
-- @param N/A
-- @return N/A
function ION:UpdateSpellIndex()

	local sIndexMax = 0

	for i=1,8 do

		local _, _, _, numSlots = GetSpellTabInfo(i)

		sIndexMax = sIndexMax + numSlots
	end

	local spellName, subName, altName, spellID, spellID_Alt, tempID, spellType, spellLvl, isPassive, icon, cost, powerType, curSpell, link, _,astTime, minRange, maxRange

	for i = 1,sIndexMax do

		spellName, _ = GetSpellBookItemName(i, BOOKTYPE_SPELL)
		spellType, spellID = GetSpellBookItemInfo(i, BOOKTYPE_SPELL)
		spellID_Alt = spellID
		spellLvl = GetSpellAvailableLevel(i, BOOKTYPE_SPELL)
		icon = GetSpellBookItemTexture(i, BOOKTYPE_SPELL)
		isPassive = IsPassiveSpell(i, BOOKTYPE_SPELL)

		if (spellName and spellType ~= "FUTURESPELL") then


--if spellID == 106707 then print(spellID)

--print(spellName)
--
			link = GetSpellLink(spellName)
			if (link) then
				_, spellID = link:match("(spell:)(%d+)")
				tempID = tonumber(spellID)
				if (tempID) then
					spellID = tempID
					--print(spellID)
				end
			end
--end
			altName, subName, icon, castTime, minRange, maxRange = GetSpellInfo(spellID)
			if spellID ~= spellID_Alt then
				altName = GetSpellInfo(spellID_Alt)
			end

			if (subName and #subName > 0) then
				if (not ION.sIndex[(spellName.."("..subName..")"):lower()]) then
					ION.sIndex[(spellName.."("..subName..")"):lower()] = {}
				end
				SetSpellInfo(ION.sIndex[(spellName.."("..subName..")"):lower()], i, BOOKTYPE_SPELL, spellName, altName, subName, spellID, spellID_Alt, spellType, spellLvl, isPassive, icon)
			else
				
				if (not ION.sIndex[(spellName):lower()]) then
					ION.sIndex[(spellName):lower()] = {}
				end
				SetSpellInfo(ION.sIndex[(spellName):lower()], i, BOOKTYPE_SPELL, spellName, altName, subName, spellID, spellID_Alt, spellType, spellLvl, isPassive, icon)

				if (not ION.sIndex[(spellName):lower().."()"]) then
					ION.sIndex[(spellName):lower().."()"] = {}
				end
				SetSpellInfo(ION.sIndex[(spellName):lower().."()"], i, BOOKTYPE_SPELL, spellName, altName, subName, spellID, spellID_Alt, spellType, spellLvl, isPassive, icon)
			end

			if (altName and altName ~= spellName) then

				if (subName and #subName > 0) then
					if (not ION.sIndex[(altName.."("..subName..")"):lower()]) then
						ION.sIndex[(altName.."("..subName..")"):lower()] = {}
					end
					SetSpellInfo(ION.sIndex[(altName.."("..subName..")"):lower()], i, BOOKTYPE_SPELL, spellName, altName, subName, spellID, spellID_Alt, spellType, spellLvl, isPassive, icon)
				else
					if (not ION.sIndex[(altName):lower()]) then
						ION.sIndex[(altName):lower()] = {}
					end

					SetSpellInfo( ION.sIndex[(altName):lower()], i, BOOKTYPE_SPELL, spellName, altName, subName, spellID, spellID_Alt, spellType, spellLvl, isPassive, icon)

					if (not ION.sIndex[(altName):lower().."()"]) then
						ION.sIndex[(altName):lower().."()"] = {}
					end
					SetSpellInfo(ION.sIndex[(altName):lower().."()"], i, BOOKTYPE_SPELL, spellName, altName, subName, spellID, spellID_Alt, spellType, spellLvl, isPassive, icon)
				end
			end

			if (spellID) then
				if (not ION.sIndex[spellID]) then
					ION.sIndex[spellID] = {}
				end
				SetSpellInfo(ION.sIndex[spellID], i, BOOKTYPE_SPELL, spellName, altName, subName, spellID, spellID_Alt, spellType, spellLvl, isPassive, icon)
			end

			if (icon and not icons[icon:upper()]) then
				ICONS[#ICONS+1] = icon:upper(); icons[icon:upper()] = true
			end
		end

	end

	-- maybe a temp fix to get the Sunfire spell to show for balance druids
	--May not be needed for 6.0 recheck 
	--[[
	if (ION.class == "DRUID") then

		--local spellName, _, icon, cost, _, powerType = GetSpellInfo(93402)
		local spellName, rank, icon, castTime, minRange, maxRange = GetSpellInfo(8921)

		if (ION.sIndex[8921]) then

			if (not ION.sIndex[(spellName):lower()]) then
				ION.sIndex[(spellName):lower()] = {}
			end

			curSpell = ION.sIndex[(spellName):lower()]

			curSpell.index = ION.sIndex[8921].index
			curSpell.booktype = ION.sIndex[8921].booktype
			curSpell.spellName = spellName
			curSpell.subName = nil
			curSpell.spellID = 93402
			curSpell.spellType = "SPELL"
			curSpell.spellLvl = ION.sIndex[8921].spellLvl
			curSpell.isPassive = nil
			curSpell.icon = icon

			if (not ION.sIndex[(spellName):lower().."()"]) then
				ION.sIndex[(spellName):lower().."()"] = {}
			end

			curSpell = ION.sIndex[(spellName):lower().."()"]

			curSpell.index = ION.sIndex[8921].index
			curSpell.booktype = ION.sIndex[8921].booktype
			curSpell.spellName = spellName
			curSpell.subName = nil
			curSpell.spellID = 93402
			curSpell.spellType = "SPELL"
			curSpell.spellLvl = ION.sIndex[8921].spellLvl
			curSpell.isPassive = nil
			curSpell.icon = icon

			if (not ION.sIndex[93402]) then
				ION.sIndex[93402] = {}
			end

			curSpell = ION.sIndex[(spellName):lower().."()"]

			curSpell.index = ION.sIndex[8921].index
			curSpell.booktype = ION.sIndex[8921].booktype
			curSpell.spellName = spellName
			curSpell.subName = nil
			curSpell.spellID = 93402
			curSpell.spellType = "SPELL"
			curSpell.spellLvl = ION.sIndex[8921].spellLvl
			curSpell.isPassive = nil
			curSpell.icon = icon
		end
	end
]]--
	for i = 1, select("#", GetProfessions()) do

		local index = select(i, GetProfessions())

		if (index) then

			local _, _, _, _, numSpells, spelloffset = GetProfessionInfo(index)

			for i=1,numSpells do
				local offsetIndex = i + spelloffset
				spellName, _ = GetSpellBookItemName(offsetIndex, BOOKTYPE_PROFESSION)
				spellType, spellID = GetSpellBookItemInfo(offsetIndex, BOOKTYPE_PROFESSION)
				spellID_Alt = spellID
				spellLvl = GetSpellAvailableLevel(offsetIndex, BOOKTYPE_PROFESSION)
				icon = GetSpellBookItemTexture(offsetIndex, BOOKTYPE_PROFESSION)
				isPassive = IsPassiveSpell(offsetIndex, BOOKTYPE_PROFESSION)

				if (spellName and spellType ~= "FUTURESPELL") then

					altName, subName, icon, castTime, minRange, maxRange = GetSpellInfo(spellID)

					if (subName and #subName > 0) then
						if (not ION.sIndex[(spellName.."("..subName..")"):lower()]) then
							ION.sIndex[(spellName.."("..subName..")"):lower()] = {}
						end
						SetSpellInfo(ION.sIndex[(spellName.."("..subName..")"):lower()], offsetIndex, BOOKTYPE_PROFESSION, spellName, altName, subName, spellID, spellID_Alt, spellType, spellLvl, isPassive, icon)
					else
						if (not ION.sIndex[(spellName):lower()]) then
							ION.sIndex[(spellName):lower()] = {}
						end
						SetSpellInfo(ION.sIndex[(spellName):lower()], offsetIndex, BOOKTYPE_PROFESSION, spellName, altName, subName, spellID, spellID_Alt, spellType, spellLvl, isPassive, icon)
						
						if (not ION.sIndex[(spellName):lower().."()"]) then
							ION.sIndex[(spellName):lower().."()"] = {}
						end
						SetSpellInfo(ION.sIndex[(spellName):lower().."()"], offsetIndex, BOOKTYPE_PROFESSION, spellName, altName, subName, spellID, spellID_Alt, spellType, spellLvl, isPassive, icon)
					end

					if (altName and altName ~= spellName) then
						if (subName and #subName > 0) then
							if (not ION.sIndex[(altName.."("..subName..")"):lower()]) then
								ION.sIndex[(altName.."("..subName..")"):lower()] = {}
							end
							SetSpellInfo(ION.sIndex[(altName.."("..subName..")"):lower()], offsetIndex, BOOKTYPE_PROFESSION, spellName, altName, subName, spellID, spellID_Alt, spellType, spellLvl, isPassive, icon)
						else
							if (not ION.sIndex[(altName):lower()]) then
								ION.sIndex[(altName):lower()] = {}
							end
							SetSpellInfo(ION.sIndex[(altName):lower()], offsetIndex, BOOKTYPE_PROFESSION, spellName, altName, subName, spellID, spellID_Alt, spellType, spellLvl, isPassive, icon)
							
							if (not ION.sIndex[(altName):lower().."()"]) then
								ION.sIndex[(altName):lower().."()"] = {}
							end
							SetSpellInfo(ION.sIndex[(altName):lower().."()"], offsetIndex, BOOKTYPE_PROFESSION, spellName, altName, subName, spellID, spellID_Alt, spellType, spellLvl, isPassive, icon)
						end
					end

					if (spellID) then
						if (not ION.sIndex[spellID]) then
							ION.sIndex[spellID] = {}
						end
						SetSpellInfo(ION.sIndex[spellID], offsetIndex, BOOKTYPE_PROFESSION, spellName, altName, subName, spellID, spellID_Alt, spellType, spellLvl, isPassive, icon)
					end

					if (icon and not icons[icon:upper()]) then
						ICONS[#ICONS+1] = icon:upper(); icons[icon:upper()] = true
					end
				end
			end
		end
	end
--[[
	spellID = 161691  --Draenor Garrison Ability not currently in spellbook
	spellName, subName, icon, castTime, minRange, maxRange = GetSpellInfo(spellID)

						if (not ION.sIndex[(spellName):lower()]) then
							ION.sIndex[(spellName):lower()] = {}
						end

						curSpell = ION.sIndex[(spellName):lower()]
						curSpell.spellName = spellName
						curSpell.subName = subName
						curSpell.spellID = spellID
						curSpell.icon = icon

						if (not ION.sIndex[(spellName):lower().."()"]) then
							ION.sIndex[(spellName):lower().."()"] = {}
						end

						curSpell = ION.sIndex[(spellName):lower().."()"]
						curSpell.spellName = spellName
						curSpell.subName = subName
						curSpell.spellID = spellID
						curSpell.icon = icon
					

]]--


end

--- Compiles a list of spells that a player's pet has.
-- @param N/A
-- @return N/A
function ION:UpdatePetSpellIndex()

	local numPetSpells = HasPetSpells() or 0

	local spellName, subName, altName, spellID, spellID_Alt, tempID, spellType, spellLvl, isPassive, icon, cost, powerType, curSpell, link, _, astTime, minRange, maxRange

	for i=1,numPetSpells do

		spellName, _ = GetSpellBookItemName(i, BOOKTYPE_PET)
		spellType, spellID = GetSpellBookItemInfo(i, BOOKTYPE_PET)
		spellID_Alt = spellID
		spellLvl = GetSpellAvailableLevel(i, BOOKTYPE_PET)
		icon = GetSpellBookItemTexture(i, BOOKTYPE_PET)
		isPassive = IsPassiveSpell(i, BOOKTYPE_PET)

		if (spellName and spellType ~= "FUTURESPELL") then

		--_, _, icon, cost, _, powerType = GetSpellInfo(spellName)
			altName, subName, icon, castTime, minRange, maxRange = GetSpellInfo(spellName)


			if (subName and #subName > 0) then
				if (not ION.sIndex[(spellName.."("..subName..")"):lower()]) then
					ION.sIndex[(spellName.."("..subName..")"):lower()] = {}
				end
				SetSpellInfo(ION.sIndex[(spellName.."("..subName..")"):lower()], i, BOOKTYPE_PET, spellName, altName, subName, spellID, spellID_Alt, spellType, spellLvl, isPassive, icon)
			else
				if (not ION.sIndex[(spellName):lower()]) then
					ION.sIndex[(spellName):lower()] = {}
				end
				SetSpellInfo(ION.sIndex[(spellName):lower()], i, BOOKTYPE_PET, spellName, altName, subName, spellID, spellID_Alt, spellType, spellLvl, isPassive, icon)
				
				if (not ION.sIndex[(spellName):lower().."()"]) then
					ION.sIndex[(spellName):lower().."()"] = {}
				end
				SetSpellInfo(ION.sIndex[(spellName):lower().."()"], i, BOOKTYPE_PET, spellName, altName, subName, spellID, spellID_Alt, spellType, spellLvl, isPassive, icon)
			end

			if (spellID) then
				if (not ION.sIndex[spellID]) then
					ION.sIndex[spellID] = {}
				end
				SetSpellInfo(ION.sIndex[spellID], i, BOOKTYPE_PET, spellName, altName, subName, spellID, spellID_Alt, spellType, spellLvl, isPassive, icon)
			end

			if (icon and not icons[icon:upper()]) then
				ICONS[#ICONS+1] = icon:upper(); icons[icon:upper()] = true
			end
		end

		i = i + 1

	end

	-- a lot of work to associate the Call Pet spell with the pet's name so that tooltips work on Call Pet spells. /sigh
	local _, _, numSlots, isKnown = GetFlyoutInfo(9)
	local petIndex, petName

	for i=1, numSlots do

		spellID, isKnown = GetFlyoutSlotInfo(9, i)
		petIndex, petName = GetCallPetSpellInfo(spellID)

		if (isKnown and petIndex and petName and #petName > 0) then

			spellName = GetSpellInfo(spellID)

			for k,v in pairs(ION.sIndex) do

				if (v.spellName:find(petName.."$")) then
					if (not ION.sIndex[(spellName):lower()]) then
						ION.sIndex[(spellName):lower()] = {}
					end
					SetSpellInfo(ION.sIndex[(spellName):lower()], v.index, v.booktype, v.spellName, nil, v.subName, spellID, spellID_Alt, v.spellType, v.spellLvl, v.isPassive, v.icon)

					if (not ION.sIndex[(spellName):lower().."()"]) then
						ION.sIndex[(spellName):lower().."()"] = {}
					end
					SetSpellInfo(ION.sIndex[(spellName):lower().."()"], v.index, v.booktype, v.spellName, nil, v.subName, spellID, spellID_Alt, v.spellType, v.spellLvl, v.isPassive, v.icon)
					
					if (not ION.sIndex[spellID]) then
						ION.sIndex[spellID] = {}
					end
					SetSpellInfo(ION.sIndex[spellID], v.index, v.booktype, v.spellName, nil, v.subName, spellID, spellID_Alt, v.spellType, v.spellLvl, v.isPassive, v.icon)
				end
			end
		end
	end
end


local function SetCompanionData(creatureIndexName,creatureType, index, creatureID, creatureName, spellID, icon)
local curComp = creatureIndexName
				curComp.creatureType = "CRITTER"
				curComp.index = index
				curComp.creatureID = creatureID
				curComp.creatureName = creatureName
				curComp.spellID = spellID
				curComp.icon = icon

end

--- Compiles a list of battle pets & mounts a player has
-- @param N/A
-- @return N/A
function ION:UpdateCompanionData()

	local creatureID, creatureName, spellID, icon, spell, curComp

	for i=1,GetNumCompanions("CRITTER") do

		creatureID, creatureName, spellID, icon = GetCompanionInfo("CRITTER", i)

		if (spellID) then

			spell = GetSpellInfo(spellID)

			if (spell) then

				if (not ION.cIndex[spell:lower()]) then
					ION.cIndex[spell:lower()] = {}
				end
				SetCompanionData(ION.cIndex[spell:lower()],"CRITTER", i, creatureID, creatureName, spellID, icon)


				if (not ION.cIndex[spell:lower().."()"]) then
					ION.cIndex[spell:lower().."()"] = {}
				end
				SetCompanionData(ION.cIndex[spell:lower().."()"],"CRITTER", i, creatureID, creatureName, spellID, icon)

				if (not ION.cIndex[spellID]) then
					ION.cIndex[spellID] = {}
				end
				SetCompanionData(ION.cIndex[spellID],"CRITTER", i, creatureID, creatureName, spellID, icon)

				if (icon and not icons[icon:upper()]) then
					ICONS[#ICONS+1] = icon:upper(); icons[icon:upper()] = true
				end
			end
		end
	end


	for i=1,C_MountJournal.GetNumMounts() do
		local creatureName, creatureID, _, active, summonable, source, isFavorite, isFactionSpecific, faction, unknown, owned = C_MountJournal.GetMountInfo(i)
		local link = GetSpellLink(creatureName)

		if (link) then
			_, spellID = link:match("(spell:)(%d+)")
			spellID = tonumber(spellID)
		end

		if (spellID) then

			spell, _, icon = GetSpellInfo(spellID)
			if (spell) then

				if (not ION.cIndex[spell:lower()]) then
					ION.cIndex[spell:lower()] = {}
				end
				SetCompanionData(ION.cIndex[spell:lower()],"MOUNT", i, creatureID, creatureName, spellID, icon)

				if (not ION.cIndex[spell:lower().."()"]) then
					ION.cIndex[spell:lower().."()"] = {}
				end
				SetCompanionData(ION.cIndex[spell:lower().."()"],"MOUNT", i, creatureID, creatureName, spellID, icon)

				if (not ION.cIndex[spellID]) then
					ION.cIndex[spellID] = {}
				end
				SetCompanionData(ION.cIndex[spellID],"MOUNT", i, creatureID, creatureName, spellID, icon)

				if (icon and not icons[icon:upper()]) then
					ICONS[#ICONS+1] = icon:upper(); icons[icon:upper()] = true
				end
			end
		end
		
	end
end

local temp = {}

local TempTexture = (CreateFrame("Button", nil, UIParent)):CreateTexture()
--textf:Hide()


--- Returns a list of the available spell icon filenames for use in macros
-- @param N/A
-- @return N/A
function ION:UpdateIconIndex()

	local icon

	wipe(temp)

	GetMacroIcons(temp)

	for k,v in ipairs(temp) do
		if(type(v) == "number") then
			TempTexture:SetToFileData(v);
			icon = TempTexture:GetTexture()
		else
			icon = "INTERFACE\\ICONS\\"..v:upper()
		end

		if (not icons[icon:upper()]) then
			ICONS[#ICONS+1] = icon:upper(); icons[icon:upper()] = true
		end
	end

	--wipe(temp)

	--GetMacroItemIcons(temp)

	--for k,v in ipairs(temp) do

	--	icon = "INTERFACE\\ICONS\\"..v:upper()

   	--	if (not icons[icon:upper()]) then
   	--		ICONS[#ICONS+1] = icon:upper(); icons[icon:upper()] = true
   	--	end
   	--end
end

function ION:UpdateStanceStrings()

	if (ION.class == "DRUID" or
	    ION.class == "MONK" or
	    ION.class == "PRIEST" or
	    ION.class == "ROGUE" or
	    ION.class == "WARRIOR" or
	    ION.class == "WARLOCK") then

	    	wipe(ION.StanceIndex)

		--local _, name, spellID
local icon, name, active, castable, spellID, UJU
		local states = "[stance:0] stance0; "

		for i=1,8 do
			ION.STATES["stance"..i] = nil
		end

		for i=1,GetNumShapeshiftForms() do

			--_, name = GetShapeshiftFormInfo(i)
			 icon, name, active, castable, spellID = GetShapeshiftFormInfo(i)

			if (name) then
			--print(name)
				--link = GetSpellLink(name)

				--if (link) then

					--_, spellID = link:match("(spell:)(%d+)")

					--spellID = tonumber(spellID)

					if (spellID) then
					--print(spellID)
						ION.StanceIndex[i] = spellID

						if (ION.class == "DRUID" and spellID == 768) then
							ION.kitty = i
							--print(i)
						end
					end
				--end

				ION.STATES["stance"..i] = name

				states = states.."[stance:"..i.."] stance"..i.."; "
			end
		end

		states = states:gsub("; $", "")

		if (not stanceStringsUpdated) then

			if (ION.class == "DRUID") then

				ION.STATES.stance0 = L.DRUID_CASTER

				ION.STATES.prowl = L.DRUID_PROWL

			end

			if (ION.class == "MONK") then

				ION.STATES.stance0 = ATTRIBUTE_NOOP

				ION.MAS.stance.homestate = "stance1"
			end

			if (ION.class == "PRIEST") then

				ION.STATES.stance0 = L.PRIEST_HEALER

			end

			if (ION.class == "ROGUE") then

				ION.STATES.stance0 = L.ROGUE_MELEE

				states = states.."[stance:2] stance1; "

			end

			if (ION.class == "WARLOCK") then

				ION.STATES.stance0 = L.WARLOCK_CASTER

			end

			if (ION.class == "WARRIOR") then

				ION.STATES.stance0 = ATTRIBUTE_NOOP

				ION.MAS.stance.homestate = "stance1"
			end

			stanceStringsUpdated = true
		end

		ION.MAS.stance.states = states
	end
end



local function printSlashHelp()

	print(L.SLASH_HINT1)
	print(L.SLASH_HINT2)

	for k,v in ipairs(ION.SLASHHELP) do
		print(v)
	end
end

local commands = {}

local function slashHandler(msg)

	wipe(commands)

	if ((not msg) or (strlen(msg) <= 0)) then

		printSlashHelp()

		return
	end

	(msg):gsub("(%S+)", function(cmd) tinsert(commands, cmd) end)

	if (ION.SLASHCMDS[commands[1]:lower()]) then

		local command

		for k,v in ipairs(commands) do
			if (k ~= 1) then
				if (not command) then
					command = v
				else
					command = command.." "..v
				end
			end
		end

		if (commands) then

			local func = ION.SLASHCMDS[commands[1]:lower()][3]
			local bar = ION.CurrentBar

			if (ION[func]) then

				ION[func](ION, command)

			elseif (bar and bar[func]) then

				bar[func](bar, command)

			else
				print(L.SELECT_BAR)
			end

		end
	else
		printSlashHelp()
	end

end


function ION.EditBox_PopUpInitialize(popupFrame, data)

	popupFrame.func = ION.PopUp_Update
	popupFrame.data = data

	ION.PopUp_Update(popupFrame)
end

function ION.PopUp_Update(popupFrame)

	local data, count, height, width, option, anchor, last, text = popupFrame.data, 1, 0, 0

	if (popupFrame.options) then
		for k,v in pairs(popupFrame.options) do
			v.text:SetText(""); v:Hide()
		end
	end

	if (not popupFrame.array) then
		popupFrame.array = {}
	else
		wipe(popupFrame.array)
	end

	if (not data) then
		return
	end

	for k,v in pairs(data) do

		if (type(v) == "string") then
			popupFrame.array[count] = k..","..v
		else
			popupFrame.array[count] = k
		end

		count = count + 1
	end

	table.sort(popupFrame.array)

	for i=1,#popupFrame.array do

		popupFrame.array[i] = gsub(popupFrame.array[i], "%s+", " ")
		popupFrame.array[i] = gsub(popupFrame.array[i], "^%s+", "")

		if (not popupFrame.options[i]) then

			option = CreateFrame("Button", popupFrame:GetName().."Option"..i, popupFrame, "IonPopupButtonTemplate")
			option:SetHeight(20)

			popupFrame.options[i] = option
		else
			option = _G[popupFrame:GetName().."Option"..i]
			popupFrame.options[i] = option
		end

		text = popupFrame.array[i]:match("^[^,]+") or ""

		option:SetText(text:gsub("^%d+_", ""))

		option.value = popupFrame.array[i]:match("[^,]+$")

		if (option:GetTextWidth() > width) then
			width = option:GetTextWidth()
		end

		option:ClearAllPoints()

		if (not anchor) then
			option:SetPoint("TOP", popupFrame, "TOP", 0, -5); anchor = option
		else
			option:SetPoint("TOP", last, "BOTTOM", 0, -1)
		end

		last = option

		height = height + 21

		option:Show()
	end

	if (popupFrame.options) then
		for k,v in pairs(popupFrame.options) do
			v:SetWidth(width+40)
		end
	end

	popupFrame:SetWidth(width+40)

	if (height < popupFrame:GetParent():GetHeight()) then
		popupFrame:SetHeight(popupFrame:GetParent():GetHeight())
	else
		popupFrame:SetHeight(height + 10)
	end
end

--From http://www.wowpedia.org/GetMinimapShape
local minimapShapes = {

	-- quadrant booleans (same order as SetTexCoord)
	-- {upper-left, lower-left, upper-right, lower-right}
	-- true = rounded, false = squared

	["ROUND"] 				= {true, true, true, true},
	["SQUARE"] 				= {false, false, false, false},
	["CORNER-TOPLEFT"] 			= {true, false, false, false},
	["CORNER-TOPRIGHT"] 		= {false, false, true, false},
	["CORNER-BOTTOMLEFT"] 		= {false, true, false, false},
	["CORNER-BOTTOMRIGHT"]		= {false, false, false, true},
	["SIDE-LEFT"] 				= {true, true, false, false},
	["SIDE-RIGHT"] 			= {false, false, true, true},
	["SIDE-TOP"] 				= {true, false, true, false},
	["SIDE-BOTTOM"] 			= {false, true, false, true},
	["TRICORNER-TOPLEFT"]		= {true, true, true, false},
	["TRICORNER-TOPRIGHT"] 		= {true, false, true, true},
	["TRICORNER-BOTTOMLEFT"]		= {true, true, false, true},
	["TRICORNER-BOTTOMRIGHT"]	= {false, true, true, true},
}

local function updatePoint(self, elapsed)

	if (GDB.animate) then

		self.elapsed = self.elapsed + elapsed

		if (self.elapsed > 0.025) then

			self.l = self.l + 0.0625
			self.r = self.r + 0.0625

			if (self.r > 1) then
				self.l = 0
				self.r = 0.0625
				self.b = self.b + 0.0625
			end

			if (self.b > 1) then
				self.l = 0
				self.r = 0.0625
				self.b = 0.0625
			end

			self.t = self.b - (0.0625 * self.tadj)

			if (self.t < 0) then self.t = 0 end
			if (self.t > 1) then self.t = 1 end

			self.texture:SetTexCoord(self.l, self.r, self.t, self.b)

			self.elapsed = 0
		end
	end
end

local function createMiniOrb(parent, index, prefix)

	local point = CreateFrame("Frame", prefix..index, parent, "IonMiniOrbTemplate")

	point:SetScript("OnUpdate", updatePoint)
	point.tadj = 1
	point.elapsed = 0

	local row, col = random(0,15), random(0,15)

	point.l = 0.0625 * row; point.r = point.l + 0.0625
	point.t = 0.0625 * col; point.b = point.t + 0.0625

	point.texture:SetTexture("Interface\\AddOns\\Ion\\Images\\seq_smoke")
	point.texture:SetTexCoord(point.l, point.r, point.t, point.b)

	return point
end

function ION:DragFrame_OnUpdate(x, y)

	local pos, quad, round, radius = nil, nil, nil, GDB.buttonRadius - IonMinimapButton:GetWidth()/math.pi
	local sqRad = sqrt(2*(radius)^2)

	local xmin, ymin = Minimap:GetLeft(), Minimap:GetBottom()

	local minimapShape = GetMinimapShape and GetMinimapShape() or "ROUND"
	local quadTable = minimapShapes[minimapShape]

	local xpos, ypos = x, y

	if (not xpos or not ypos) then
		xpos, ypos = GetCursorPosition()
	end

	xpos = xmin - xpos / Minimap:GetEffectiveScale() + radius
	ypos = ypos / Minimap:GetEffectiveScale() - ymin - radius

	pos = math.deg(math.atan2(ypos,xpos))

	xpos = cos(pos)
	ypos = sin(pos)

	if (xpos > 0 and ypos > 0) then
		quad = 1 --topleft
	elseif (xpos > 0 and ypos < 0) then
		quad = 2 --bottomleft
	elseif (xpos < 0 and ypos > 0) then
		quad = 3 --topright
	elseif (xpos < 0 and ypos < 0) then
		quad = 4 --bottomright
	end

	round = quadTable[quad]

	if (round) then
		xpos = xpos * radius
		ypos = ypos * radius
	else
		xpos = max(-radius, min(xpos * sqRad, radius))
		ypos = max(-radius, min(ypos * sqRad, radius))
	end

	IonMinimapButton:SetPoint("TOPLEFT", "Minimap", "TOPLEFT", 52-xpos, ypos-55)

	GDB.buttonLoc = { 52-xpos, ypos-55 }
end

function ION:MinimapButton_OnLoad(minimap)

	minimap:RegisterForClicks("AnyUp")
	minimap:RegisterForDrag("LeftButton")
	minimap:RegisterEvent("PLAYER_LOGIN")
	minimap.elapsed = 0
	minimap.x = 0
	minimap.y = 0
	minimap.count = 1
	minimap.angle = 0
	minimap:SetFrameStrata(MinimapCluster:GetFrameStrata())
	minimap:SetFrameLevel(MinimapCluster:GetFrameLevel()+3)
	minimap:GetHighlightTexture():SetAlpha(0.3)

end

function ION:MinimapButton_OnEvent(minimap)

	minimap.orb = createMiniOrb(minimap, 1, "IonMinimapOrb")
	minimap.orb:SetPoint("CENTER", minimap, "CENTER", 0.5, 0.5)
	minimap.orb:SetScale(2)
	minimap.orb:SetFrameLevel(minimap:GetFrameLevel())
	minimap.orb.texture:SetVertexColor(1,0,0)

	ION:MinimapButton_OnDragStop(minimap)

end

function ION:MinimapButton_OnDragStart(minimap)

	minimap:LockHighlight()
	minimap:StartMoving()
	IonMinimapButtonDragFrame:Show()
end

function ION:MinimapButton_OnDragStop(minimap)

	if (minimap) then

		minimap:UnlockHighlight()
		minimap:StopMovingOrSizing()
		minimap:SetUserPlaced(false)
		minimap:ClearAllPoints()
		if (GDB and GDB.buttonLoc) then
			minimap:SetPoint("TOPLEFT", "Minimap","TOPLEFT", GDB.buttonLoc[1], GDB.buttonLoc[2])
		end
		IonMinimapButtonDragFrame:Hide()
	end
end

function ION:MinimapButton_OnShow(minimap)

	if (GDB) then
		ION:MinimapButton_OnDragStop(minimap)
	end
end

function ION:MinimapButton_OnHide(minimap)

	minimap:UnlockHighlight()
	IonMinimapButtonDragFrame:Hide()
end

function ION:MinimapButton_OnEnter(minimap)

	GameTooltip_SetDefaultAnchor(GameTooltip, minimap)

	GameTooltip:SetText(L.ION, 1, 1, 1)
	GameTooltip:AddLine(L.MINIMAP_TOOLTIP1, 1, 1, 1)
	GameTooltip:AddLine(L.MINIMAP_TOOLTIP2, 1, 1, 1)
	GameTooltip:AddLine(L.MINIMAP_TOOLTIP3, 1, 1, 1)
	GameTooltip:AddLine(L.MINIMAP_TOOLTIP4, 1, 1, 1)

	GameTooltip:Show()
end

function ION:MinimapButton_OnLeave(minimap)

	GameTooltip:Hide()
end

function ION:MinimapButton_OnClick(minimap, button)

	PlaySound("igChatScrollDown")

	if (InCombatLockdown()) then return end

	if (button == "RightButton") then
		ION:ToggleEditFrames()
	elseif (IsShiftKeyDown()) then
		ION:ToggleMainMenu()
	elseif (IsAltKeyDown() or button == "MiddleButton") then
		ION:ToggleBindings()
	else
		ION:ToggleBars()
	end
end

function ION:MinimapMenuClose()
	IonMinimapButton.popup:Hide()
end

function ION.SubFramePlainBackdrop_OnLoad(self)

	self:SetBackdrop({
		bgFile = "",
		edgeFile = "Interface\\AddOns\\Ion\\Images\\UI-Tooltip-Border",
		tile = true,
		tileSize = 16,
		edgeSize = 22,
		insets = { left = 5, right = 5, top = 5, bottom = 5 },})
	self:SetBackdropBorderColor(0.35, 0.35, 0.35, 1)
	self:SetBackdropColor(0,0,0,0)
	self:GetParent().backdrop = self

	self.bg = self:CreateTexture(nil, "BACKGROUND")
	self.bg:SetTexture("Interface\\FriendsFrame\\UI-Toast-Background", true)
	self.bg:SetVertexColor(0.65,0.65,0.65,0.85)
	self.bg:SetPoint("TOPLEFT", 3, -3)
	self.bg:SetPoint("BOTTOMRIGHT", -3, 3)
	self.bg:SetHorizTile(true)
	self.bg:SetVertTile(true)

end

function ION.SubFrameBlackBackdrop_OnLoad(self)

	self:SetBackdrop({
		bgFile = "",
		edgeFile = "Interface\\AddOns\\Ion\\Images\\UI-Tooltip-Border",
		tile = true,
		tileSize = 16,
		edgeSize = 18,
		insets = { left = 5, right = 5, top = 5, bottom = 5 },})
	self:SetBackdropBorderColor(0.25, 0.25, 0.25, 1)
	self:SetBackdropColor(0,0,0,0)
	self:GetParent().backdrop = self

	self.bg = self:CreateTexture(nil, "BACKGROUND")
	self.bg:SetTexture("Interface\\FriendsFrame\\UI-Toast-Background", true)
	self.bg:SetVertexColor(0.65,0.65,0.65,1)
	self.bg:SetPoint("TOPLEFT", 3, -3)
	self.bg:SetPoint("BOTTOMRIGHT", -3, 3)
	self.bg:SetHorizTile(true)
	self.bg:SetVertTile(true)

end

function ION.SubFrameBlankBackdrop_OnLoad(self)

	self:SetBackdrop({
		bgFile = "",
		edgeFile = "Interface\\AddOns\\Ion\\Images\\UI-Tooltip-Border",
		tile = true,
		tileSize = 16,
		edgeSize = 12,
		insets = { left = 5, right = 5, top = 5, bottom = 5 },})
	self:SetBackdropBorderColor(0.25, 0.25, 0.25, 1)
	self:SetBackdropColor(0,0,0,0)
	self:GetParent().backdrop = self
end

function ION.SubFrameHoneycombBackdrop_OnLoad(self)

	self:SetBackdrop({
		bgFile = "",
		edgeFile = "Interface\\AddOns\\Ion\\Images\\UI-Tooltip-Border",
		tile = true,
		tileSize = 16,
		edgeSize = 18,
		insets = { left = 5, right = 5, top = 5, bottom = 5 },})
	self:SetBackdropBorderColor(0.25, 0.25, 0.25, 1)
	self:SetBackdropColor(0,0,0,0)
	self:GetParent().backdrop = self

	self.bg = self:CreateTexture(nil, "BACKGROUND")
	self.bg:SetTexture("Interface\\AddOns\\Ion\\Images\\honeycomb_small", true)
	self.bg:SetVertexColor(0.65,0.65,0.65,1)
	self.bg:SetPoint("TOPLEFT", 3, -3)
	self.bg:SetPoint("BOTTOMRIGHT", -3, 3)
	self.bg:SetHorizTile(true)
	self.bg:SetVertTile(true)
end

function ION.IonAdjustOption_AddOnClick(frame, button, down)

	frame.elapsed = 0
	frame.pushed = frame:GetButtonState()

	if (not down) then
		if (frame:GetParent():GetParent().addfunc) then
			frame:GetParent():GetParent().addfunc(frame:GetParent():GetParent())
		end
	end
end

function ION.IonAdjustOption_AddOnUpdate(frame, elapsed)

	frame.elapsed = frame.elapsed + elapsed

	if (frame.pushed == "NORMAL") then

		if (frame.elapsed > 1 and frame:GetParent():GetParent().addfunc) then
			frame:GetParent():GetParent().addfunc(frame:GetParent():GetParent(), true)
		end
	end
end

function ION.IonAdjustOption_SubOnClick(frame, button, down)

	frame.elapsed = 0
	frame.pushed = frame:GetButtonState()

	if (not down) then
		if (frame:GetParent():GetParent().subfunc) then
			frame:GetParent():GetParent().subfunc(frame:GetParent():GetParent())
		end
	end
end

function ION.IonAdjustOption_SubOnUpdate(frame, elapsed)

	frame.elapsed = frame.elapsed + elapsed

	if (frame.pushed == "NORMAL") then

		if (frame.elapsed > 1 and frame:GetParent():GetParent().subfunc) then
			frame:GetParent():GetParent().subfunc(frame:GetParent():GetParent(), true)
		end
	end
end

function ION:UpdateData(data, defaults)

	-- Add new vars
	for key,value in pairs(defaults) do

		if (data[key] == nil) then

			if (data[key:lower()] ~= nil) then

				data[key] = data[key:lower()]
				data[key:lower()] = nil
			else
				data[key] = value
			end
		end
	end
	-- Add new vars

	-- Var fixes

		---none

	-- Var fixes

	-- Kill old vars
	for key,value in pairs(data) do
		if (defaults[key] == nil) then
			data[key] = nil
		end

		if (not CDB.fix07312012 and key == "actionID") then
			data.actionID = false
		end
	end
	-- Kill old vars
end

function ION:ToggleBlizzBar(on)

	if (InCombatLockdown()) then return end

	if (ION.OpDep) then return end

	if (on) then


		local button

		for i=1, NUM_OVERRIDE_BUTTONS do
			button = _G["OverrideActionBarButton"..i]
			handler:WrapScript(button, "OnShow", [[
				local key = GetBindingKey("ACTIONBUTTON"..self:GetID())
				if (key) then
					self:SetBindingClick(true, key, self:GetName())
				end
			]])
			handler:WrapScript(button, "OnHide", [[
				local key = GetBindingKey("ACTIONBUTTON"..self:GetID())
				if (key) then
					self:ClearBinding(key)
				end
			]])
		end

		TextStatusBar_Initialize(MainMenuExpBar)
		MainMenuExpBar:RegisterEvent("PLAYER_ENTERING_WORLD")
		MainMenuExpBar:RegisterEvent("PLAYER_XP_UPDATE")
		MainMenuExpBar.textLockable = 1
		MainMenuExpBar.cvar = "xpBarText"
		MainMenuExpBar.cvarLabel = "XP_BAR_TEXT"
		MainMenuExpBar.alwaysPrefix = true
		MainMenuExpBar_SetWidth(1024)

		MainMenuBar_OnLoad(MainMenuBarArtFrame)
		MainMenuBarVehicleLeaveButton_OnLoad(MainMenuBarVehicleLeaveButton)

		MainMenuBar:SetPoint("BOTTOM", 0, 0)
		MainMenuBar:Show()

		OverrideActionBar_OnLoad(OverrideActionBar)
		OverrideActionBar:SetPoint("BOTTOM", 0, 0)

		ExtraActionBarFrame:SetPoint("BOTTOM", 0, 160)

		ActionBarController_OnLoad(ActionBarController)


	else

		local button

		for i=1, NUM_OVERRIDE_BUTTONS do
			button = _G["OverrideActionBarButton"..i]
			handler:UnwrapScript(button, "OnShow")
			handler:UnwrapScript(button, "OnHide")
		end

		MainMenuExpBar:UnregisterAllEvents()
		MainMenuBarArtFrame:UnregisterAllEvents()
		MainMenuBarArtFrame:RegisterEvent("CURRENCY_DISPLAY_UPDATE")
		MainMenuBarArtFrame:RegisterEvent("UNIT_LEVEL")
		MainMenuBarVehicleLeaveButton:UnregisterAllEvents()

		MainMenuBar:SetPoint("BOTTOM", 0, -200)
		MainMenuBar:Hide()

		OverrideActionBar:UnregisterAllEvents()
		OverrideActionBar:SetPoint("BOTTOM", 0, -200)
		OverrideActionBar:Hide()

		ExtraActionBarFrame:SetPoint("BOTTOM", 0, -200)
		ExtraActionBarFrame:Hide()

		ActionBarController:UnregisterAllEvents()

	end
end

function ION:BlizzBar()

	if (GDB.mainbar) then
		GDB.mainbar = false
	else
		GDB.mainbar = true
	end

	ION:ToggleBlizzBar(GDB.mainbar)

end


function ION:ToggleDraenorBar(on)
	if (InCombatLockdown()) then return end

	if (ION.OpDep) then return end

	if (on) and (HasDraenorZoneAbility()) then
	DraenorZoneAbilityFrame:Show()
	DraenorZoneAbilityFrame:SetAttribute("statehidden", nil);
	else
	DraenorZoneAbilityFrame:Hide()
	DraenorZoneAbilityFrame:SetAttribute("statehidden", true);
	end
end

--work arround to get the garrison button to reilably hide by adding it to the default bar if it is not allready on it.
local function DraenorButtonCheck()
	if not HasDraenorZoneAbility() then return end

	if not HasDraenorZoneSpellOnBar(DraenorZoneAbilityFrame)then
		PickupSpell(161691)
		PlaceAction(72)
		ClearCursor ()
	end

end

function ION:DraenorBar()
	if (GDB.draenorbar) then
		GDB.draenorbar = false
		DraenorButtonCheck()
	else
		GDB.draenorbar = true
	end

	ION:ToggleDraenorBar(GDB.draenorbar)
end

function ION:Animate()

	if (GDB.animate) then
		GDB.animate = false
	else
		GDB.animate = true
	end

end

function ION:CreateBar(index, class, id)

	local data, show = ION.RegisteredBarData[class]

	if (data) then

		if (not id) then

			id = 1

			for _ in ipairs(data.GDB) do
				id = id + 1
			end

			newBar = true
		end

		local bar

		if (_G["Ion"..data.barType..id]) then
			bar = _G["Ion"..data.barType..id]
		else
			bar = CreateFrame("CheckButton", "Ion"..data.barType..id, UIParent, "IonBarTemplate")
		end

		for key,value in pairs(data) do
			bar[key] = value
		end

		setmetatable(bar, { __index = BAR })

		bar.index = index
		bar.class = class
		bar.stateschanged = true
		bar.vischanged =true
		bar.elapsed = 0
		bar.click = nil
		bar.dragged = false
		bar.selected = false
		bar.toggleframe = bar
		bar.microAdjust = false
		bar.vis = {}
		bar.text:Hide()
		bar.message:Hide()
		bar.messagebg:Hide()

		bar:SetID(id)
		bar:SetWidth(375)
		bar:SetHeight(40)
		bar:SetBackdrop({ bgFile = "Interface/Tooltips/UI-Tooltip-Background",
		                  edgeFile = "Interface/Tooltips/UI-Tooltip-Border",
		                  tile = true, tileSize = 16, edgeSize = 12,
		                  insets = { left = 4, right = 4, top = 4, bottom = 4 } })
		bar:SetBackdropColor(0,0,0,0.4)
		bar:SetBackdropBorderColor(0,0,0,0)
		bar:SetFrameLevel(2)
		bar:RegisterForClicks("AnyDown", "AnyUp")
		bar:RegisterForDrag("LeftButton")
		bar:SetMovable(true)
		bar:EnableKeyboard(false)
		bar:SetPoint("CENTER", "UIParent", "CENTER", 0, 0)

		bar:SetScript("OnClick", BAR.OnClick)
		bar:SetScript("OnDragStart", BAR.OnDragStart)
		bar:SetScript("OnDragStop", BAR.OnDragStop)
		bar:SetScript("OnEnter", BAR.OnEnter)
		bar:SetScript("OnLeave", BAR.OnLeave)
		bar:SetScript("OnEvent", BAR.OnEvent)
		bar:SetScript("OnKeyDown", BAR.OnKeyDown)
		bar:SetScript("OnKeyUp", BAR.OnKeyUp)
		bar:SetScript("OnMouseWheel", BAR.OnMouseWheel)
		bar:SetScript("OnShow", BAR.OnShow)
		bar:SetScript("OnHide", BAR.OnHide)
		bar:SetScript("OnUpdate", BAR.OnUpdate)

		bar:RegisterEvent("ACTIONBAR_SHOWGRID")
		bar:RegisterEvent("ACTIONBAR_HIDEGRID")
		bar:RegisterEvent("ACTIVE_TALENT_GROUP_CHANGED")

		bar:CreateDriver()
		bar:CreateHandler()
		bar:CreateWatcher()

		bar:LoadData()

		if (not newBar) then
			bar:Hide()
		end

		BARIndex[index] = bar

		BARNameIndex[bar:GetName()] = bar

		return bar, newBar
	end
end

function ION:CreateNewBar(class, id, firstRun)

	if (class and ION.RegisteredBarData[class]) then

		local index = 1

		for _ in ipairs(BARIndex) do
			index = index + 1
		end

		local bar, newBar = ION:CreateBar(index, class, id)

		if (firstRun) then
			bar:SetDefaults(bar.gDef, bar.cDef)
		end

		if (newBar) then
			bar:Load(); ION:ChangeBar(bar)
		end

		return bar
	else
		ION.PrintBarTypes()
	end
end

function ION:CreateNewObject(class, id, firstRun)

	local data = ION.RegisteredBarData[class]

	if (data) then

		local index = 1

		for _ in ipairs(data.objTable) do
			index = index + 1
		end

		local object = CreateFrame(data.objFrameT, data.objPrefix..id, UIParent, data.objTemplate)

		setmetatable(object, data.objMetaT)

		object.elapsed = 0

		local objects = ION:GetParentKeys(object)

		for k,v in pairs(objects) do
			local name = (v):gsub(object:GetName(), "")
			object[name:lower()] = _G[v]
		end

		object.class = class
		object.id = id
		object:SetID(0)
		object.objTIndex = index
		object.objType = data.objType:gsub("%s", ""):upper()

		object:LoadData(GetActiveSpecGroup(), "homestate")

		if (firstRun) then
			object:SetDefaults(object:GetDefaults())
		end

		object:LoadAux()

		data.objTable[index] = { object, 1 }

		return object
	end
end

function ION:ChangeBar(bar)

	local newBar = false

	if (PEW) then

		if (bar and ION.CurrentBar ~= bar) then

			ION.CurrentBar = bar

			bar.selected = true
			bar.action = nil

			bar:SetFrameLevel(3)

			if (bar.gdata.hidden) then
				bar:SetBackdropColor(1,0,0,0.6)
			else
				bar:SetBackdropColor(0,0,1,0.5)
			end

			newBar = true
		end

		if (not bar) then
			ION.CurrentBar = nil
		elseif (bar.text) then
			bar.text:Show()
		end

		for k,v in pairs(BARIndex) do
			if (v ~= bar) then

				if (v.cdata.conceal) then
					v:SetBackdropColor(1,0,0,0.4)
				else
					v:SetBackdropColor(0,0,0,0.4)
				end

				v:SetFrameLevel(2)
				v.selected = false
				v.microAdjust = false
				v:EnableKeyboard(false)
				v.text:Hide()
				v.message:Hide()
				v.messagebg:Hide()
				v.mousewheelfunc = nil
				v.action = nil
			end
		end

		if (ION.CurrentBar) then
			ION.CurrentBar:OnEnter()
		end
	end

	return newBar
end

function ION:ToggleBars(show, hide)

	if (PEW) then

		if ((ION.BarsShown or hide) and not show) then

			ION.BarsShown = nil

			for index, bar in pairs(BARIndex) do
				bar:Hide(); bar:Update(nil, true)
			end

			ION:ChangeBar(nil)

			if (IonBarEditor)then
				IonBarEditor:Hide()
			end

			collectgarbage()
		else

			--ION:ToggleMainMenu(nil, true)
			ION:ToggleEditFrames(nil, true)

			ION.BarsShown = true

			for index, bar in pairs(BARIndex) do
				bar:Show(); bar:Update(true)
			end
		end
	end

	if (ION.BarsShown)then
		IonMinimapButton:SetFrameStrata("TOOLTIP")
		IonMinimapButton:SetFrameLevel(MinimapCluster:GetFrameLevel()+3)
	else
		IonMinimapButton:SetFrameStrata(MinimapCluster:GetFrameStrata())
		IonMinimapButton:SetFrameLevel(MinimapCluster:GetFrameLevel()+3)
	end
end

function ION:ToggleButtonGrid(show, hide)

	for id,btn in pairs(BTNIndex) do
		btn[1]:SetGrid(show, hide)
	end
end

function ION:ToggleMainMenu(show, hide)

	if (not IsAddOnLoaded("Ion-GUI")) then
		LoadAddOn("Ion-GUI")
	end
--[[
	if ((IonMainMenu:IsVisible() or hide) and not show) then
		IonMainMenu:Hide()
	else
		IonMainMenu:Show()
	end
	]]--
	InterfaceOptionsFrame_OpenToCategory("Ion");

end

function ION:PrintStateList()

	local data, list = {}

	for k,v in pairs(ION.MANAGED_ACTION_STATES) do
		if (ION.STATEINDEX[k]) then
			data[v.order] = ION.STATEINDEX[k]
		end
	end

	for k,v in ipairs(data) do

		if (not list) then
			list = L.VALIDSTATES..v
		else
			list = list..", "..v
		end
	end

	print(list..L.CUSTOM_OPTION)
end

function ION:PrintBarTypes()

	local data, index, high = {}, 1, 0

	for k,v in pairs(ION.RegisteredBarData) do

		if (v.barCreateMore) then

			index = tonumber(v.createMsg:match("%d+"))
			barType = v.createMsg:gsub("%d+","")

			if (index and barType) then
				data[index] = { k, barType }
				if (index > high) then high = index end
			end
		end
	end

	for i=1,high do if (not data[i]) then data[i] = 0 end end

	print(L.BARTYPES_USAGE)
	print(L.BARTYPES_TYPES)

	for k,v in ipairs(data) do
		if (type(v) == "table") then
			print("       |cff00ff00"..v[1].."|r: "..format(L.BARTYPES_LINE, v[2]))
		end
	end

end

function ION:RegisterBarClass(class, ...)

	ION.ModuleIndex = ION.ModuleIndex + 1

	ION.RegisteredBarData[class] = {
		barType = select(1,...):gsub("%s+", ""),
		barLabel = select(1,...),
		barReverse = select(11,...),
		barCreateMore = select(15,...),
		GDB = select(3,...),
		CDB = select(4,...),
		gDef = select(13,...),
		cDef = select(14,...),
		objTable = select(5,...),
		objGDB = select(6,...),
		objPrefix = "Ion"..select(2,...):gsub("%s+", ""),
		objFrameT = select(7,...),
		objTemplate = select(8,...),
		objMetaT = select(9,...),
		objType = select(2,...),
		objMax = select(10,...),
		objStorage = select(12,...),
		createMsg = ION.ModuleIndex..select(2,...),
	}

end

function ION:RegisterGUIOptions(class, ...)

	ION.RegisteredGUIData[class] = {
		chkOpt = select(1,...),
		stateOpt = select(2,...),
		adjOpt = select(3,...),
	}
end

function ION:SetTimerLimit(msg)

	local limit = tonumber(msg:match("%d+"))

	if (limit and limit > 0) then
		GDB.timerLimit = limit
		print(format(L.TIMERLIMIT_SET, GDB.timerLimit))
	else
		print(L.TIMERLIMIT_INVALID)
	end
end

local function runUpdater(self, elapsed)

	self.elapsed = elapsed

	if (self.elapsed > 0) then

		ION:UpdateSpellIndex()
		ION:UpdateStanceStrings()

		self:Hide()
	end
end

local updater = CreateFrame("Frame", nil, UIParent)
updater:SetScript("OnUpdate", runUpdater)
updater.elapsed = 0
updater:Hide()

local function control_OnEvent(self, event, ...)

	ION.CurrEvent = event

	if (event == "PLAYER_REGEN_DISABLED") then

		if (ION.EditFrameShown) then
			ION:ToggleEditFrames(nil, true)
		end

		if (ION.BindingMode) then
			ION:ToggleBindings(nil, true)
		end

		if (ION.BarsShown) then
			ION:ToggleBars(nil, true)
		end

	elseif (event == "ADDON_LOADED" and ... == "Ion") then

		ION.MAS = Ion.MANAGED_ACTION_STATES
		ION.MBS = Ion.MANAGED_BAR_STATES

		BAR = ION.BAR

		ION.player, ION.class, ION.level, ION.realm = UnitName("player"), select(2, UnitClass("player")), UnitLevel("player"), GetRealmName()

		for k,v in pairs(opDepList) do
			if (IsAddOnLoaded(v)) then
				ION.OpDep = true
			end
		end
		
		if (not fix03312014) then
		
		end
		

		GDB = IonGDB; CDB = IonCDB; SPEC = IonSpec

		for k,v in pairs(defGDB) do
			if (GDB[k] == nil) then
				GDB[k] = v
			end
		end

		for k,v in pairs(defCDB) do
			if (CDB[k] == nil) then
				CDB[k] = v
			end
		end

		for k,v in pairs(defSPEC) do
			if (SPEC[k] == nil) then
				SPEC[k] = v
			end
		end

		ION:UpdateStanceStrings()

		GameMenuFrame:HookScript("OnShow", function(self)

				--if (IonMainMenu and IonMainMenu:IsShown()) then
					--HideUIPanel(self); ION:ToggleMainMenu(nil, true)
				--end

				if (ION.BarsShown) then
					HideUIPanel(self); ION:ToggleBars(nil, true)
				end

				if (ION.EditFrameShown) then
					HideUIPanel(self); ION:ToggleEditFrames(nil, true)
				end

				if (ION.BindingMode) then
					HideUIPanel(self); ION:ToggleBindings(nil, true)
				end

				end)

		StaticPopupDialogs["ION_BETA_WARNING"] = {
			text = L.BETA_WARNING,
			button1 = OKAY,
			timeout = 0,
			OnAccept = function() GDB.betaWarning = false end,
		}

	elseif (event == "VARIABLES_LOADED") then

		local index, button, texture = 1

		SlashCmdList["ION"] = slashHandler
		SLASH_ION1 = L.SLASH1

		InterfaceOptionsFrame:SetFrameStrata("HIGH")


	elseif (event == "PLAYER_LOGIN") then

		local function hideAlerts(frame)
			if (not GDB.mainbar) then
				frame:Hide()
			end
		end

		if (CompanionsMicroButtonAlert) then
			CompanionsMicroButtonAlert:HookScript("OnShow", hideAlerts)
		end

	elseif (event == "PLAYER_ENTERING_WORLD" and not PEW) then

		GDB.firstRun = false
		CDB.firstRun = false

		ION:UpdateSpellIndex()
		ION:UpdatePetSpellIndex()
		ION:UpdateStanceStrings()
		ION:UpdateCompanionData()
		ION:UpdateIconIndex()
		--Fix for Titan causing the Main Bar to not be hidden
		if (IsAddOnLoaded("Titan")) then TitanUtils_AddonAdjust("MainMenuBar", true) end
		ION:ToggleBlizzBar(GDB.mainbar)
		ION:ToggleDraenorBar(GDB.draenorbar)
		DraenorButtonCheck()

		CDB.fix07312012 = true

		collectgarbage(); PEW = true

		if (GDB.betaWarning) then
			StaticPopup_Show("ION_BETA_WARNING")
		end

	elseif (event == "PLAYER_SPECIALIZATION_CHANGED" or event == "PLAYER_TALENT_UPDATE" or event == "PLAYER_LOGOUT" or event == "PLAYER_LEAVING_WORLD") then

		SPEC.cSpec = GetActiveSpecGroup()

	elseif (event == "ACTIVE_TALENT_GROUP_CHANGED" or
		  event == "LEARNED_SPELL_IN_TAB" or
		  event == "CHARACTER_POINTS_CHANGED" or
		  event == "SPELLS_CHANGED") then

		updater.elapsed = 0
		updater:Show()
		ION:ToggleDraenorBar(GDB.draenorbar)
		DraenorButtonCheck()

	elseif (event == "PET_UI_CLOSE" or event == "COMPANION_LEARNED" or event == "COMPANION_UPDATE") then

		ION:UpdateCompanionData()

	elseif (event == "UNIT_PET" and ... == "player") then

		if (PEW) then
			ION:UpdatePetSpellIndex()
		end

	elseif (event == "UNIT_LEVEL" and ... == "player") then

		ION.level = UnitLevel("player")
	else
		--ION:ToggleDraenorBar(GDB.draenorbar)
	end
end

local frame = CreateFrame("Frame", "IonControl", UIParent)

frame.elapsed = 0
frame:SetScript("OnEvent", control_OnEvent)
frame:RegisterEvent("ADDON_LOADED")
frame:RegisterEvent("VARIABLES_LOADED")
frame:RegisterEvent("PLAYER_LOGIN")
frame:RegisterEvent("PLAYER_LOGOUT")
frame:RegisterEvent("PLAYER_ENTERING_WORLD")
frame:RegisterEvent("PLAYER_LEAVING_WORLD")
frame:RegisterEvent("PLAYER_REGEN_DISABLED")
frame:RegisterEvent("PLAYER_SPECIALIZATION_CHANGED")
frame:RegisterEvent("ACTIVE_TALENT_GROUP_CHANGED")
frame:RegisterEvent("SPELLS_CHANGED")
frame:RegisterEvent("CHARACTER_POINTS_CHANGED")
frame:RegisterEvent("LEARNED_SPELL_IN_TAB")
frame:RegisterEvent("CURSOR_UPDATE")
frame:RegisterEvent("PET_UI_CLOSE")
frame:RegisterEvent("COMPANION_LEARNED")
frame:RegisterEvent("COMPANION_UPDATE")
frame:RegisterEvent("UNIT_LEVEL")
frame:RegisterEvent("UNIT_PET")
--Needed to check to hide the garrison button
frame:RegisterUnitEvent("UNIT_AURA", "player");
frame:RegisterEvent("SPELL_UPDATE_COOLDOWN");
frame:RegisterEvent("SPELL_UPDATE_USABLE");
frame:RegisterEvent("SPELL_UPDATE_CHARGES");
frame:RegisterEvent("ACTIONBAR_SLOT_CHANGED");


frame = CreateFrame("GameTooltip", "IonTooltipScan", UIParent, "GameTooltipTemplate")
frame:SetOwner(UIParent, "ANCHOR_NONE")
frame:SetFrameStrata("TOOLTIP")
frame:Hide()


StaticPopupDialogs["ReloadUI"] = {
	text = "ReloadUI",
	button1 = "Yes",
	OnAccept = function()
		 ReloadUI()
	end,
	preferredIndex = 3,  -- avoid some UI taint, see http://www.wowace.com/announcements/how-to-avoid-some-ui-taint/
}

function IonProfile:RefreshConfig()
	IonCDB = self.db.profile["IonCDB"]
	IonGDB = self.db.profile["IonGDB"]
	IonSpec = {cSpec = GetActiveSpecGroup()}
	defGDB, GDB, defCDB, CDB, defSPEC, SPEC = CopyTable(IonGDB), CopyTable(IonGDB), CopyTable(IonCDB), CopyTable(IonCDB), CopyTable(IonSpec), CopyTable(IonSpec)
	




	IONButtonProfileUpdate()
--IONBarProfileUpdate()
	StaticPopup_Show("ReloadUI")
end


local addonName = ...

function IonProfile:OnInitialize()

--[[
  self.db = LibStub("AceDB-3.0"):New("MyAddonDB")
  self.db.char.money = GetMoney()
if not GDB.firstRun then
print("XF-GBD")
	defaults.profile["IonGDB"] = CopyTable(IonGDB)
end

if  not GDB.firstRun then
print("XF-IonCDB")
	defaults.profile["IonCDB"] = CopyTable(IonCDB)
end
]]--
--if not GDB.firstRun and not CDB.firstRun then
--print("XF-GBD")
	--defaults.profile["IonSpec"] = CopyTable(IonSpec)
--end
	self.db = LibStub("AceDB-3.0"):New("IonProfilesDB", defaults)
	LibStub("AceConfigRegistry-3.0"):ValidateOptionsTable(options, addonName)
	LibStub("AceConfig-3.0"):RegisterOptionsTable(addonName, options)

	options.args.profile = LibStub("AceDBOptions-3.0"):GetOptionsTable(self.db)
	LibStub("AceConfigDialog-3.0"):AddToBlizOptions(addonName, addonName)
	self.db.RegisterCallback(self, "OnProfileChanged", "RefreshConfig")
	self.db.RegisterCallback(self, "OnProfileCopied", "RefreshConfig")
	self.db.RegisterCallback(self, "OnProfileReset", "RefreshConfig")
	self.db.RegisterCallback(self, "OnDatabaseReset", "RefreshConfig")

	--Check to see if character has stored bars/buttons that need to be imported to profile
	if not IonProfilesDB["Saved"] then
		IonProfilesDB["Saved"] = CopyTable(IonGDB)
	end

	if not self.db.char.firstrun then 
		self.db.profile["IonCDB"] = CopyTable(IonCDB)
		self.db.profile["IonGDB"] = CopyTable(IonProfilesDB["Saved"])

		self.db.char.firstrun = true
	end
--if not GDB.firstRun and not CDB.firstRun then

	--defaults.profile["IonSpec"] = CopyTable(IonSpec)
	IonCDB = self.db.profile["IonCDB"]
	IonGDB = self.db.profile["IonGDB"]
	IonSpec = self.db.profile["IonSpec"]

	defGDB, GDB, defCDB, CDB, defSPEC, SPEC = CopyTable(IonGDB), CopyTable(IonGDB), CopyTable(IonCDB), CopyTable(IonCDB), CopyTable(IonSpec), CopyTable(IonSpec)
end


--local defGDB, GDB, defCDB, CDB, defSPEC, SPEC = CopyTable(IonGDB), CopyTable(IonGDB), CopyTable(IonCDB), CopyTable(IonCDB), CopyTable(IonSpec), CopyTable(IonSpec)

--Hooking on DraenorZoneAbilityFrame_OnShow in case it tries to get displayed
--[[
local function DreanorCheck()
	ION:ToggleDraenorBar(GDB.draenorbar)
end
hooksecurefunc("DraenorZoneAbilityFrame_OnShow", DreanorCheck);
--]]

--[[
local origDraenorZoneAbilityFrame_OnEvent = DraenorZoneAbilityFrame_OnEvent

DraenorZoneAbilityFrame_OnEvent = function(...)
	if (InCombatLockdown()) then return end
	print("nocom")
	origDraenorZoneAbilityFrame_OnEvent(...);
	
end


DraenorZoneAbilityFrame:SetScript("OnEvent", DraenorZoneAbilityFrame_OnEvent)



local origHasDraenorZoneSpellOnBar = HasDraenorZoneSpellOnBar

HasDraenorZoneSpellOnBar = function(...)
print("Call")
	if not GDB.draenorbar then 
		return true;
	else
		return origHasDraenorZoneSpellOnBar(...);
	end
end
--]]




--161691

