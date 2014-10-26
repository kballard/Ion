local spacingX = 225
local spacingY = -19

local GDB = IonGDB
local ION, BAR = Ion
local L = LibStub("AceLocale-3.0"):GetLocale("Ion")

--[[
local IonOptionsFrame = {}
IonOptionsFrame.Frame = IonMainMenu

IonOptionsFrame.Done = CreateFrame("Button", "IonOptionsDoneButton", IonOptionsFrame.Frame, "OptionsButtonTemplate")
IonOptionsFrame.Done:SetPoint("BOTTOMRIGHT", IonOptionsFrame.Frame, "BOTTOMRIGHT", -10, 10)
IonOptionsFrame.Done:SetScript("OnClick", function() IonOptionsFrame.Frame:Hide() end)
IonOptionsFrame.Done:SetText(DONE)
--Title
IonOptionsFrame.Title = IonOptionsFrame.Frame:CreateFontString("Title")
IonOptionsFrame.Title:SetPoint("Center", IonOptionsFrame.Frame, "TOP", 0, -25)
IonOptionsFrame.Title:SetFontObject("GameFontHighlight")
IonOptionsFrame.Title:SetText("Ion Options")
--Ruled Line
IonOptionsFrame.Line1 = IonOptionsFrame.Frame:CreateTexture("Line1")
IonOptionsFrame.Line1:SetTexture(1,1,1,0.2)
IonOptionsFrame.Line1:SetHeight(2)
IonOptionsFrame.Line1:SetWidth(300)
IonOptionsFrame.Line1:SetPoint("Center", IonOptionsFrame.Title, "TOP", 0, -20)
--Animation Checbox
IonOptionsFrame.Animate = CreateFrame("CheckButton", "IonOptionsAnimateCheckbox", IonOptionsFrame.Frame, "ChatConfigCheckButtonTemplate");
IonOptionsFrame.Animate:SetPoint("TOPLEFT", 75, -65);
getglobal(IonOptionsFrame.Animate:GetName() .. 'Text'):SetText(L.OPTIONS_ANIMATE);
IonOptionsFrame.Animate:SetChecked(GDB.animate)
IonOptionsFrame.Animate:SetScript("OnClick", 
  function()
	if (IonOptionsFrame.Animate:GetChecked() ) then
		PlaySound("igMainMenuOptionCheckBoxOn");
	else
		PlaySound("igMainMenuOptionCheckBoxOff");
	end				
	ION:Animate()
  end
);

--Blizzardbar Checbox
IonOptionsFrame.Blizzbar = CreateFrame("CheckButton", "IonOptionsBlizzbarCheckbox", IonOptionsFrame.Frame, "ChatConfigCheckButtonTemplate");
IonOptionsFrame.Blizzbar:SetPoint("TOPLEFT", IonOptionsFrame.Animate , "BOTTOMLEFT", 0, spacingY);
getglobal(IonOptionsFrame.Blizzbar:GetName() .. 'Text'):SetText(L.OPTIONS_BLIZZBAR);
IonOptionsFrame.Blizzbar:SetChecked(GDB.mainbar)
IonOptionsFrame.Blizzbar:SetScript("OnClick", 
  function()
	if (IonOptionsFrame.Blizzbar:GetChecked() ) then
		PlaySound("igMainMenuOptionCheckBoxOn");
		GDB.mainbar= true;
	else
		PlaySound("igMainMenuOptionCheckBoxOff");
		GDB.mainbar= false;
	end				
	ION:ToggleBlizzBar(GDB.mainbar)
  end
);

--Draenarbar Checbox
IonOptionsFrame.Draenorbar = CreateFrame("CheckButton", "IonOptionsDraenorbarCheckbox", IonOptionsFrame.Frame, "ChatConfigCheckButtonTemplate");
IonOptionsFrame.Draenorbar:SetPoint("TOPLEFT", IonOptionsFrame.Blizzbar , "BOTTOMLEFT", 0, spacingY);
getglobal(IonOptionsFrame.Draenorbar:GetName() .. 'Text'):SetText(L.OPTIONS_DRAENORBAR);
IonOptionsFrame.Draenorbar:SetChecked(GDB.draenorbar)
IonOptionsFrame.Draenorbar:SetScript("OnClick", 
  function()
	if (IonOptionsFrame.Blizzbar:GetChecked() ) then
		PlaySound("igMainMenuOptionCheckBoxOn");
		GDB.draenor= true;
	else
		PlaySound("igMainMenuOptionCheckBoxOff");
		GDB.draenor= false;
	end				
	ION:ToggleDraenorBar(GDB.draenor)
  end
);

--Updates checkboxes in case any were changed via slash commands
local function Option_OnShow()
	IonOptionsFrame.Blizzbar:SetChecked(GDB.mainbar)
	IonOptionsFrame.Draenorbar:SetChecked(GDB.draenorbar)
	IonOptionsFrame.Animate:SetChecked(GDB.animate)
end
IonOptionsFrame.Frame:SetScript("OnShow", Option_OnShow)
 ]]--