﻿local F = {}
local C = {}
if IsAddOnLoaded("Aurora") then 
	F, C = unpack(Aurora)
else
	F.Reskin = function() end
	F.ReskinCheck = function() end
	F.ReskinSlider = function() end
	F.CreateBD = function() end
	F.ReskinScroll = function() end
end

local addon, ns = ...
local L = ns.L

local checkbuttons = {}
local editboxes = {}
local sliders = {}
local anchorboxes = {}
local raidsizeboxes = {}

local function createcheckbutton(parent, index, name, value, tip)
	local bu = CreateFrame("CheckButton", "oUF_Mlight GUI"..name.."Button", parent, "InterfaceOptionsCheckButtonTemplate")
	bu.value = value
	bu:SetPoint("TOPLEFT", 16, 10-index*30)
	bu.text = bu:CreateFontString(nil, "ARTWORK", "GameFontHighlight")
	bu.text:SetPoint("LEFT", bu, "RIGHT", 1, 1)
	bu.text:SetText(name)
	bu:SetScript("OnEnter", function(self) 
		GameTooltip:SetOwner(bu, "ANCHOR_RIGHT", 10, 10)
		GameTooltip:AddLine(tip)
		GameTooltip:Show() 
	end)
	bu:SetScript("OnLeave", function(self) GameTooltip:Hide() end)
	bu:SetScript("OnClick", function()
		if bu:GetChecked() then
			oUF_MlightDB[bu.value] = true
		else
			oUF_MlightDB[bu.value] = false
		end
	end)
	tinsert(checkbuttons, bu)
	return bu
end

local function createeditbox(parent, index, name, value, tip)
	local box = CreateFrame("EditBox", "oUF_Mlight GUI"..name.."EditBox", parent)
	box.value = value
	box:SetSize(150, 20)
	box:SetPoint("TOPLEFT", 16, 10-index*30)
	box.name = box:CreateFontString(nil, "ARTWORK", "GameFontHighlight")
	box.name:SetPoint("LEFT", box, "RIGHT", 10, 1)
	box.name:SetText(name)
	box:SetFont(GameFontHighlight:GetFont(), 12, "OUTLINE")
	box:SetAutoFocus(false)
	box:SetTextInsets(3, 0, 0, 0)
	box:SetScript("OnShow", function(self) self:SetText(oUF_MlightDB[box.value]) end)
	box:SetScript("OnEscapePressed", function(self) self:SetText(oUF_MlightDB[box.value]) self:ClearFocus() end)
	box:SetScript("OnEnterPressed", function(self)
		self:ClearFocus()
		oUF_MlightDB[box.value] = self:GetText()
	end)
	if tip then
		box:SetScript("OnEnter", function(self) 
			GameTooltip:SetOwner(box, "ANCHOR_RIGHT", 10, 10)
			GameTooltip:AddLine(tip)
			GameTooltip:Show() 
		end)
		box:SetScript("OnLeave", function(self) GameTooltip:Hide() end)
	end
	tinsert(editboxes, box)
	return box
end

local function createslider(parent, index, name, value, min, max, step, tip)
	local slider = CreateFrame("Slider", "oUF_Mlight"..name.."Slider", parent, "OptionsSliderTemplate")
	slider.value = value
	slider:SetWidth(150)
	slider:SetPoint("TOPLEFT", 16, 10-index*30)
	slider.name = slider:CreateFontString(nil, "ARTWORK", "GameFontHighlight")
	slider.name:SetPoint("LEFT", slider, "RIGHT", 10, 1)
	slider.name:SetText(name)
	BlizzardOptionsPanel_Slider_Enable(slider)
	slider:SetMinMaxValues(min, max)
	slider:SetValueStep(step)
	slider:SetScript("OnValueChanged", function(self, getvalue)
		oUF_MlightDB[slider.value] = getvalue
	end)
	if tip then
		slider:SetScript("OnEnter", function(self) 
			GameTooltip:SetOwner(slider, "ANCHOR_RIGHT", 10, 10)
			GameTooltip:AddLine(tip)
			GameTooltip:Show() 
		end)
		slider:SetScript("OnLeave", function(self) GameTooltip:Hide() end)
	end
	tinsert(sliders, slider)
	return slider
end

local function createanchorbox(parent, index, name, value)
	local ab = CreateFrame("Button", "oUF_Mlight"..name.."AnchorButton", parent, "UIPanelButtonTemplate")
	ab.value = value
	ab:SetPoint("TOPLEFT", 16, 10-index*30)
	ab:SetSize(150, 20)
	ab.name = ab:CreateFontString(nil, "ARTWORK", "GameFontHighlight")
	ab.name:SetPoint("LEFT", ab, "RIGHT", 10, 1)
	ab.name:SetText(name)
	ab:SetScript("OnClick", function()
		if ab:GetText() == "LEFT" then
			oUF_MlightDB[ab.value] = "TOP"
		else
			oUF_MlightDB[ab.value] = "LEFT"
		end
		ab:SetText(oUF_MlightDB[ab.value])
	end)
	tinsert(anchorboxes, ab)
	return ab
end

local function createraidsizebox(parent, index, name, value)
	local rsb = CreateFrame("Button", "oUF_Mlight"..name.."RaidSizeButton", parent, "UIPanelButtonTemplate")
	rsb.value = value
	rsb:SetPoint("TOPLEFT", 16, 10-index*30)
	rsb:SetSize(150, 20)
	rsb.name = rsb:CreateFontString(nil, "ARTWORK", "GameFontHighlight")
	rsb.name:SetPoint("LEFT", rsb, "RIGHT", 10, 1)
	rsb.name:SetText(name)
	rsb:SetScript("OnClick", function()
		if oUF_MlightDB[rsb.value] == "1,2,3,4,5" then
			oUF_MlightDB[rsb.value] = "1,2,3,4,5,6,7,8"
			rsb:SetText("40-man")
		else
			oUF_MlightDB[rsb.value] = "1,2,3,4,5"
			rsb:SetText("25-man")
		end
	end)
	tinsert(raidsizeboxes, rsb)
	return rsb
end

local function creatfontflagbu(parent, index, name, value)
	local ffb = CreateFrame("Button", "oUF_Mlight"..name.."FontFlagButton", parent, "UIPanelButtonTemplate")
	ffb.value = value
	ffb:SetPoint("TOPLEFT", 16, 10-index*30)
	ffb:SetSize(150, 20)
	ffb.name = ffb:CreateFontString(nil, "ARTWORK", "GameFontHighlight")
	ffb.name:SetPoint("LEFT", ffb, "RIGHT", 10, 1)
	ffb.name:SetText(name)
	ffb:SetScript("OnClick", function()
		if oUF_MlightDB[ffb.value] == "OUTLINE" then
			oUF_MlightDB[ffb.value] = "MONOCHROME"
		elseif oUF_MlightDB[ffb.value] == "MONOCHROME" then
			oUF_MlightDB[ffb.value] = "NONE"
		elseif oUF_MlightDB[ffb.value] == "NONE" then
			oUF_MlightDB[ffb.value] = "OUTLINE"
		end
		ffb:SetText(oUF_MlightDB[ffb.value])
	end)
	return ffb
end

local function createcolorpickerbu(parent, index, name, value, tip)
	local cpb = CreateFrame("Button", "oUF_Mlight"..name.."ColorPickerButton", parent, "UIPanelButtonTemplate")
	cpb.value = value
	cpb:SetPoint("TOPLEFT", 16, 10-index*30)
	cpb:SetSize(150, 20)
	
	cpb.tex = cpb:CreateTexture(nil, "OVERLAY")
	cpb.tex:SetTexture("Interface\\ChatFrame\\ChatFrameBackground")
	cpb.tex:SetPoint"CENTER"
	cpb.tex:SetSize(120, 12)

	cpb.name = cpb:CreateFontString(nil, "ARTWORK", "GameFontHighlight")
	cpb.name:SetPoint("LEFT", cpb, "RIGHT", 10, 1)
	cpb.name:SetText(name)
		
	cpb:SetScript("OnClick", function()
		local r, g, b, a = oUF_MlightDB[value].r, oUF_MlightDB[value].g, oUF_MlightDB[value].b, oUF_MlightDB[value].a
		ColorPickerFrame:SetPoint("TOPLEFT", cpb, "TOPRIGHT", 20, 0)
		
		ColorPickerFrame.hasOpacity = oUF_MlightDB.transparentmode -- Opacity slider only available for reverse filling
		ColorPickerFrame.func = function() 
			oUF_MlightDB[value].r, oUF_MlightDB[value].g, oUF_MlightDB[value].b = ColorPickerFrame:GetColorRGB()
			cpb.tex:SetVertexColor(ColorPickerFrame:GetColorRGB())
		end
		ColorPickerFrame.opacityFunc = function()
			oUF_MlightDB[value].a = OpacitySliderFrame:GetValue()
		end
		ColorPickerFrame.previousValues = {r = r, g = g, b = b, opacity = a}
		ColorPickerFrame.opacity = oUF_MlightDB[value].a
		ColorPickerFrame.cancelFunc = function()
			oUF_MlightDB[value].r, oUF_MlightDB[value].g, oUF_MlightDB[value].b, oUF_MlightDB[value].a = r, g, b, a
			cpb.tex:SetVertexColor(oUF_MlightDB[value].r, oUF_MlightDB[value].g, oUF_MlightDB[value].b)
		end
		ColorPickerFrame:SetColorRGB(r, g, b)
		ColorPickerFrame:Hide()
		ColorPickerFrame:Show()
	end)
	if tip then
		cpb:SetScript("OnEnter", function(self) 
			GameTooltip:SetOwner(cpb, "ANCHOR_RIGHT", 10, 10)
			GameTooltip:AddLine(tip)
			GameTooltip:Show() 
		end)
		cpb:SetScript("OnLeave", function(self) GameTooltip:Hide() end)
	end
	return cpb
end

-- dependency relationship
local function createDR(parent, ...)
    for i=1, select("#", ...) do
		local object = select(i, ...)
		if object:GetObjectType() == "Slider" then
			parent:HookScript("OnShow", function(self)
				if self:GetChecked() then
					BlizzardOptionsPanel_Slider_Enable(object)
				else
					BlizzardOptionsPanel_Slider_Disable(object)
				end
			end)
			parent:HookScript("OnClick", function(self)
				if self:GetChecked() then
					BlizzardOptionsPanel_Slider_Enable(object)
				else
					BlizzardOptionsPanel_Slider_Disable(object)
				end
			end)	
		else
			parent:HookScript("OnShow", function(self)
				if self:GetChecked() then
					object:Enable()
				else
					object:Disable()
				end
			end)
			parent:HookScript("OnClick", function(self)
				if self:GetChecked() then
					object:Enable()
				else
					object:Disable()
				end
			end)
		end
    end
end
--====================================================--
--[[                   -- GUI --                    ]]--
--====================================================--
local gui = CreateFrame("Frame", "oUF_Mlight GUI", UIParent)
gui.name = ("oUF_Mlight")
InterfaceOptions_AddCategory(gui)

gui.title = gui:CreateFontString(nil, "ARTWORK", "GameFontNormalLarge")
gui.title:SetPoint("TOPLEFT", 15, -20)
gui.title:SetText("oUF_Mlight v."..GetAddOnMetadata("oUF_Mlight", "Version"))

gui.line = gui:CreateTexture(nil, "ARTWORK")
gui.line:SetSize(600, 1)
gui.line:SetPoint("TOP", 0, -50)
gui.line:SetTexture(1, 1, 1, .2)

gui.intro = gui:CreateFontString(nil, "ARTWORK", "GameFontNormalLeftGrey")
gui.intro:SetText(L["apply"])
gui.intro:SetPoint("TOPLEFT", 20, -60)

local reloadbu = CreateFrame("Button", nil, gui, "UIPanelButtonTemplate")
reloadbu:SetPoint("TOPRIGHT", -16, -20)
reloadbu:SetSize(150, 25)
reloadbu:SetText(APPLY)
reloadbu:SetScript("OnClick", function()
	ReloadUI()
end)

local resetbu = CreateFrame("Button", nil, gui, "UIPanelButtonTemplate")
resetbu:SetPoint("RIGHT", reloadbu,"LEFT", -5, 0)
resetbu:SetSize(150, 25)
resetbu:SetText(NEWBIE_TOOLTIP_STOPWATCH_RESETBUTTON)
resetbu:SetScript("OnClick", function()
	ns.LoadVariables()
	ReloadUI()
end)

local scrollFrame = CreateFrame("ScrollFrame", "oUF_Mlight GUI Frame_ScrollFrame", gui, "UIPanelScrollFrameTemplate")
scrollFrame:SetPoint("TOPLEFT", gui, "TOPLEFT", 10, -80)
scrollFrame:SetPoint("BOTTOMRIGHT", gui, "BOTTOMRIGHT", -35, 0)
scrollFrame:SetFrameLevel(gui:GetFrameLevel()+1)
	
scrollFrame.Anchor = CreateFrame("Frame", "oUF_Mlight GUI Frame_ScrollAnchor", scrollFrame)
scrollFrame.Anchor:SetPoint("TOPLEFT", scrollFrame, "TOPLEFT", 0, -3)
scrollFrame.Anchor:SetWidth(scrollFrame:GetWidth()-30)
scrollFrame.Anchor:SetHeight(scrollFrame:GetHeight()+200)
scrollFrame.Anchor:SetFrameLevel(scrollFrame:GetFrameLevel()+1)
scrollFrame:SetScrollChild(scrollFrame.Anchor)

local fadetext = scrollFrame.Anchor:CreateFontString(nil, "ARTWORK", "GameFontNormalLarge")
fadetext:SetPoint("TOPLEFT", 16, 3-1*30)
fadetext:SetText(L["fade"])

local enablefadebu = createcheckbutton(scrollFrame.Anchor, 2, L["enablefade"], "enablefade", L["enablefade2"])
local fadingalphaslider = createslider(scrollFrame.Anchor, 3, L["fadingalpha"], "fadingalpha", 0, 0.8, 0.05, L["fadingalpha2"])
createDR(enablefadebu, fadingalphaslider)

local fonttext = scrollFrame.Anchor:CreateFontString(nil, "ARTWORK", "GameFontNormalLarge")
fonttext:SetPoint("TOPLEFT", 16, 3-4*30)
fonttext:SetText(L["font"])

local fontfilebox = createeditbox(scrollFrame.Anchor, 5, L["fontfile"], "fontfile", L["fontfile2"])
fontfilebox:SetWidth(300)
local fontsizebox = createeditbox(scrollFrame.Anchor, 6, L["fontsize"], "fontsize", L["fontsize2"])
local fontflagbu = creatfontflagbu(scrollFrame.Anchor, 7, L["fontflag"], "fontflag")

local colormodtext = scrollFrame.Anchor:CreateFontString(nil, "ARTWORK", "GameFontNormalLarge")
colormodtext:SetPoint("TOPLEFT", 16, 3-8*30)
colormodtext:SetText(L["colormode"])

local classcolormodebu = createcheckbutton(scrollFrame.Anchor, 9, L["classcolormode"], "classcolormode", L["classcolormode2"])
local transparentmodebu = createcheckbutton(scrollFrame.Anchor, 10, L["transparentmode"], "transparentmode", L["transparentmode2"])
local startcolorpicker = createcolorpickerbu(scrollFrame.Anchor, 11, L["startcolor"], "startcolor", L["onlywhentransparent"])
local endcolorpicker = createcolorpickerbu(scrollFrame.Anchor, 12, L["endcolor"], "endcolor", L["onlywhentransparent"])
local nameclasscolormodebu = createcheckbutton(scrollFrame.Anchor, 13, L["nameclasscolormode"], "nameclasscolormode", L["nameclasscolormode2"])

local portraittext = scrollFrame.Anchor:CreateFontString(nil, "ARTWORK", "GameFontNormalLarge")
portraittext:SetPoint("TOPLEFT", 14, 3-14*30)
portraittext:SetText(L["portrait"])

local portraitbu = createcheckbutton(scrollFrame.Anchor, 15, L["enableportrait"], "portrait")
local portraitalphaslider = createslider(scrollFrame.Anchor, 16, L["portraitalpha"], "portraitalpha", 0.1, 1, 0.05, L["portraitalpha2"])
createDR(portraitbu, portraitalphaslider)

local sizetext = scrollFrame.Anchor:CreateFontString(nil, "ARTWORK", "GameFontNormalLarge")
sizetext:SetPoint("TOPLEFT", 14, 3-17*30)
sizetext:SetText(L["framesize"])

local heightbox = createeditbox(scrollFrame.Anchor, 18, L["height"], "height", L["height2"])
local widthbox = createeditbox(scrollFrame.Anchor, 19, L["width"], "width", L["width2"])
local widthpetbox = createeditbox(scrollFrame.Anchor, 20, L["widthpet"], "widthpet", L["widthpet2"])
local widthbossbox = createeditbox(scrollFrame.Anchor, 21, L["widthboss"], "widthboss", L["widthboss2"])
local scaleslider = createslider(scrollFrame.Anchor, 22, L["scale"], "scale", 0.5, 3, 0.05, L["scale2"])
local hpheightslider = createslider(scrollFrame.Anchor, 23, L["hpheight"], "hpheight", 0.2, 0.95, 0.05, L["hpheight2"])

local castbartext = scrollFrame.Anchor:CreateFontString(nil, "ARTWORK", "GameFontNormalLarge")
castbartext:SetPoint("TOPLEFT", 16, 3-24*30)
castbartext:SetText(L["castbar"])

local castbarsbu = createcheckbutton(scrollFrame.Anchor, 25, L["enablecastbars"], "castbars", L["enablecastbars2"])
local cbIconsizebox = createeditbox(scrollFrame.Anchor, 26, L["cbIconsize"], "cbIconsize", L["cbIconsize2"])
createDR(castbarsbu, cbIconsizebox)

local auratext = scrollFrame.Anchor:CreateFontString(nil, "ARTWORK", "GameFontNormalLarge")
auratext:SetPoint("TOPLEFT", 16, 3-27*30)
auratext:SetText(L["aura"])

local aurasbu = createcheckbutton(scrollFrame.Anchor, 28, L["enableauras"], "auras", L["enableauras2"])
local aurabordersbu = createcheckbutton(scrollFrame.Anchor, 29, L["auraborders"], "auraborders", L["auraborders2"])
local auraperrowslider = createslider(scrollFrame.Anchor, 30, L["aurasperrow"], "auraperrow", 4, 20, 1, L["aurasperrow2"])
local playerdebuffbu = createcheckbutton(scrollFrame.Anchor, 31, L["enableplayerdebuff"], "playerdebuffenable", L["enableplayerdebuff2"])
local playerdebuffperrowslider = createslider(scrollFrame.Anchor, 32, L["playerdebuffsperrow"], "playerdebuffnum", 4, 20, 1, L["playerdebuffsperrow2"])
local AuraFilterignoreBuffbu = createcheckbutton(scrollFrame.Anchor, 33, L["AuraFilterignoreBuff"], "AuraFilterignoreBuff", L["AuraFilterignoreBuff2"])
local AuraFilterignoreDebuffbu = createcheckbutton(scrollFrame.Anchor, 34, L["AuraFilterignoreDebuff"], "AuraFilterignoreDebuff", L["AuraFilterignoreDebuff2"])
local AuraFiltertext = scrollFrame.Anchor:CreateFontString(nil, "ARTWORK", "GameFontNormalLeftYellow")
AuraFiltertext:SetPoint("TOPLEFT", 16, 3-35*30)
AuraFiltertext:SetText(L["aurafilterinfo"])
createDR(aurasbu, auraperrowslider, aurabordersbu, playerdebuffbu, playerdebuffperrowslider, AuraFilterignoreBuffbu, AuraFilterignoreDebuffbu)
createDR(playerdebuffbu, playerdebuffperrowslider)

local threatbartext = scrollFrame.Anchor:CreateFontString(nil, "ARTWORK", "GameFontNormalLarge")
threatbartext:SetPoint("TOPLEFT", 16, 3-36*30)
threatbartext:SetText(L["threatbar"])

local showthreatbarbu = createcheckbutton(scrollFrame.Anchor, 37, L["showthreatbar"], "showthreatbar", L["showthreatbar2"])
local tbvergradientbu = createcheckbutton(scrollFrame.Anchor, 38, L["tbvergradient"], "tbvergradient", L["tbvergradient2"])
createDR(showthreatbarbu, tbvergradientbu)

local bosstext = scrollFrame.Anchor:CreateFontString(nil, "ARTWORK", "GameFontNormalLarge")
bosstext:SetPoint("TOPLEFT", 16, 3-39*30)
bosstext:SetText(L["bossframe"])

local bossframesbu = createcheckbutton(scrollFrame.Anchor, 40, L["bossframes"], "bossframes", L["bossframes2"])
--====================================================--
--[[                 -- Raid --                     ]]--
--====================================================--
local raidgui = CreateFrame("Frame", "oUF_Mlight Raid", UIParent)
raidgui.name = ("oUF_Mlight Raid")
raidgui.parent = ("oUF_Mlight")
InterfaceOptions_AddCategory(raidgui)

raidgui.title = raidgui:CreateFontString(nil, "ARTWORK", "GameFontNormalLarge")
raidgui.title:SetPoint("TOPLEFT", 15, -20)
raidgui.title:SetText("oUF_Mlight Raid Frames")

raidgui.line = raidgui:CreateTexture(nil, "ARTWORK")
raidgui.line:SetSize(600, 1)
raidgui.line:SetPoint("TOP", 0, -50)
raidgui.line:SetTexture(1, 1, 1, .2)

raidgui.intro = raidgui:CreateFontString(nil, "ARTWORK", "GameFontNormalLeftGrey")
raidgui.intro:SetText(L["apply"])
raidgui.intro:SetPoint("TOPLEFT", 20, -60)

local reloadbu2 = CreateFrame("Button", nil, raidgui, "UIPanelButtonTemplate")
reloadbu2:SetPoint("TOPRIGHT", -16, -20)
reloadbu2:SetSize(150, 25)
reloadbu2:SetText(APPLY)
reloadbu2:SetScript("OnClick", function()
	ReloadUI()
end)

local scrollFrame2 = CreateFrame("ScrollFrame", "oUF_Mlight Raid GUI Frame_ScrollFrame", raidgui, "UIPanelScrollFrameTemplate")
scrollFrame2:SetPoint("TOPLEFT", raidgui, "TOPLEFT", 10, -80)
scrollFrame2:SetPoint("BOTTOMRIGHT", raidgui, "BOTTOMRIGHT", -35, 0)
scrollFrame2:SetFrameLevel(raidgui:GetFrameLevel()+1)
	
scrollFrame2.Anchor = CreateFrame("Frame", "oUF_Mlight Raid GUI Frame_ScrollAnchor", scrollFrame2)
scrollFrame2.Anchor:SetPoint("TOPLEFT", scrollFrame2, "TOPLEFT", 0, -3)
scrollFrame2.Anchor:SetWidth(scrollFrame2:GetWidth()-30)
scrollFrame2.Anchor:SetHeight(scrollFrame2:GetHeight()+200)
scrollFrame2.Anchor:SetFrameLevel(scrollFrame2:GetFrameLevel()+1)
scrollFrame2:SetScrollChild(scrollFrame2.Anchor)

local sharetext = scrollFrame2.Anchor:CreateFontString(nil, "ARTWORK", "GameFontNormalLarge")
sharetext:SetPoint("TOPLEFT", 16, 3-1*30)
sharetext:SetText(L["raidshare"])

local enableraidbu = createcheckbutton(scrollFrame2.Anchor, 2, L["enableraid"], "enableraid", L["enableraid2"])
local raidfontsizebox = createeditbox(scrollFrame2.Anchor, 3, L["raidfontsize"], "raidfontsize", L["raidfontsize2"])
local showsolobu = createcheckbutton(scrollFrame2.Anchor, 4, L["showsolo"], "showsolo", L["showsolo2"])
local autoswitchbu = createcheckbutton(scrollFrame2.Anchor, 5, L["autoswitch"], "autoswitch", L["autoswitch2"])
local raidonlyhealerbu = createcheckbutton(scrollFrame2.Anchor, 6, L["raidonlyhealer"], "raidonlyhealer", L["raidonlyhealer2"])
local raidonlydpsbu = createcheckbutton(scrollFrame2.Anchor, 7, L["raidonlydps"], "raidonlydps", L["raidonlydps2"])
createDR(autoswitchbu, raidonlyhealerbu, raidonlydpsbu)
local raidtoggletext = scrollFrame2.Anchor:CreateFontString(nil, "ARTWORK", "GameFontNormalLeftYellow")
raidtoggletext:SetPoint("TOPLEFT", 16, 3-8*30)
raidtoggletext:SetText(L["toggleinfo"])

local enablearrowbu = createcheckbutton(scrollFrame2.Anchor, 10, L["enablearrow"], "enablearrow", L["enablearrow2"])
local arrowsacleslider = createslider(scrollFrame2.Anchor, 11, L["arrowsacle"], "arrowsacle", 0.5, 2, 0.05, L["arrowsacle2"])
createDR(enablearrowbu, arrowsacleslider)

local healerraidtext = scrollFrame2.Anchor:CreateFontString(nil, "ARTWORK", "GameFontNormalLarge")
healerraidtext:SetPoint("TOPLEFT", 16, 3-12*30)
healerraidtext:SetText(L["healerraidtext"])

local healergroupfilterbox = createraidsizebox(scrollFrame2.Anchor, 13, L["groupsize"], "healergroupfilter")
local healerraidheightbox = createeditbox(scrollFrame2.Anchor, 14, L["healerraidheight"], "healerraidheight", L["healerraidheight2"])
local healerraidwidthbox = createeditbox(scrollFrame2.Anchor, 15, L["healerraidwidth"], "healerraidwidth", L["healerraidwidth2"])
local healerraidanchorddm = createanchorbox(scrollFrame2.Anchor, 16, L["anchor"], "anchor")
local healerraidpartyanchorddm = createanchorbox(scrollFrame2.Anchor, 17, L["partyanchor"], "partyanchor")
local showgcdbu = createcheckbutton(scrollFrame2.Anchor, 18, L["showgcd"], "showgcd", L["showgcd2"])
local healpredictionbu = createcheckbutton(scrollFrame2.Anchor, 19, L["healprediction"], "healprediction", L["healprediction2"])

local dpstankraidtext = scrollFrame2.Anchor:CreateFontString(nil, "ARTWORK", "GameFontNormalLarge")
dpstankraidtext:SetPoint("TOPLEFT", 18, 3-20*30)
dpstankraidtext:SetText(L["dpstankraidtext"])

local dpsgroupfilterbox = createraidsizebox(scrollFrame2.Anchor, 21, L["groupsize"], "dpsgroupfilter")
local dpsraidheightbox = createeditbox(scrollFrame2.Anchor, 22, L["dpsraidheight"], "dpsraidheight", L["dpsraidheight2"])
local dpsraidwidthbox = createeditbox(scrollFrame2.Anchor, 23, L["dpsraidwidth"], "dpsraidwidth", L["dpsraidwidth2"])
local dpsraidgroupbyclassbu = createcheckbutton(scrollFrame2.Anchor, 24, L["dpsraidgroupbyclass"], "dpsraidgroupbyclass", L["dpsraidgroupbyclass2"])
local unitnumperlinebox = createeditbox(scrollFrame2.Anchor, 25, L["unitnumperline"], "unitnumperline", L["unitnumperline2"])

--====================================================--
--[[           -- Aura White List --                ]]--
--====================================================--
local whitelist = CreateFrame("Frame", "oUF_Mlight WhiteList", UIParent)
whitelist.name = ("Aura Fliter WhiteList")
whitelist.parent = ("oUF_Mlight")
InterfaceOptions_AddCategory(whitelist)

whitelist.title = whitelist:CreateFontString(nil, "ARTWORK", "GameFontNormalLarge")
whitelist.title:SetPoint("TOPLEFT", 15, -20)
whitelist.title:SetText("oUF_Mlight Aura Fliter WhiteList")

whitelist.line = whitelist:CreateTexture(nil, "ARTWORK")
whitelist.line:SetSize(600, 1)
whitelist.line:SetPoint("TOP", 0, -50)
whitelist.line:SetTexture(1, 1, 1, .2)

whitelist.intro = whitelist:CreateFontString(nil, "ARTWORK", "GameFontNormalLeftGrey")
whitelist.intro:SetText(L["don't have to rl"])
whitelist.intro:SetPoint("TOPLEFT", 20, -60)

local scrollFrame3 = CreateFrame("ScrollFrame", "oUF_Mlight WhiteList Frame_ScrollFrame", whitelist, "UIPanelScrollFrameTemplate")
scrollFrame3:SetPoint("TOPLEFT", whitelist, "TOPLEFT", 10, -130)
scrollFrame3:SetPoint("BOTTOMRIGHT", whitelist, "BOTTOMRIGHT", -35, 0)
scrollFrame3:SetFrameLevel(whitelist:GetFrameLevel()+1)
	
scrollFrame3.Anchor = CreateFrame("Frame", "oUF_Mlight WhiteList Frame_ScrollAnchor", scrollFrame3)
scrollFrame3.Anchor:SetPoint("TOPLEFT", scrollFrame3, "TOPLEFT", 0, -3)
scrollFrame3.Anchor:SetWidth(scrollFrame3:GetWidth()-30)
scrollFrame3.Anchor:SetHeight(scrollFrame3:GetHeight()+200)
scrollFrame3.Anchor:SetFrameLevel(scrollFrame3:GetFrameLevel()+1)
scrollFrame3:SetScrollChild(scrollFrame3.Anchor)

local function updateanchors()
	sort(oUF_MlightDB.AuraFilterwhitelist)
	local index = 1
	for spellID, name in pairs(oUF_MlightDB.AuraFilterwhitelist) do
		if not spellID then return end
		_G["oUF_Mlight WhiteList Button"..spellID]:SetPoint("TOPLEFT", scrollFrame3.Anchor, "TOPLEFT", 10, 20-index*30)
		index = index + 1
	end
end

local function CreateWhiteListButton(name, icon, spellID)
	local wb = CreateFrame("Frame", "oUF_Mlight WhiteList Button"..spellID, scrollFrame3.Anchor)
	wb:SetSize(350, 20)

	wb.icon = CreateFrame("Button", nil, wb)
	wb.icon:SetSize(18, 18)
	wb.icon:SetNormalTexture(icon)
	wb.icon:GetNormalTexture():SetTexCoord(0.1,0.9,0.1,0.9)
	wb.icon:SetPoint"LEFT"
	
	wb.iconbg = wb:CreateTexture(nil, "BACKGROUND")
	wb.iconbg:SetPoint("TOPLEFT", -1, 1)
	wb.iconbg:SetPoint("BOTTOMRIGHT", 1, -1)
	wb.iconbg:SetTexture("Interface\\Buttons\\WHITE8x8")
	wb.iconbg:SetVertexColor(0, 0, 0, 0.5)
	
	wb.spellid = wb:CreateFontString(nil, "OVERLAY")
	wb.spellid:SetFont(GameFontHighlight:GetFont(), 12, "OUTLINE")
	wb.spellid:SetPoint("LEFT", 40, 0)
	wb.spellid:SetTextColor(1, .2, .6)
    wb.spellid:SetJustifyH("LEFT")
	wb.spellid:SetText(spellID)
	
	wb.spellname = wb:CreateFontString(nil, "OVERLAY")
	wb.spellname:SetFont(GameFontHighlight:GetFont(), 12, "OUTLINE")
	wb.spellname:SetPoint("LEFT", 140, 0)
	wb.spellname:SetTextColor(1, 1, 0)
    wb.spellname:SetJustifyH("LEFT")
	wb.spellname:SetText(name)
	
	wb.close = CreateFrame("Button", nil, wb, "UIPanelButtonTemplate")
	wb.close:SetSize(18,18)
	wb.close:SetPoint("RIGHT")
	F.Reskin(wb.close)
	wb.close:SetText("x")
	wb.close:SetScript("OnClick", function() 
	wb:Hide()
	oUF_MlightDB.AuraFilterwhitelist[spellID] = nil
	print("|cffFF0000"..name.." |r"..L["remove frome white list"])
	updateanchors()
	end)
	
	return wb
end

local function CreateWhiteListButtonList()
	for spellID, name in pairs(oUF_MlightDB.AuraFilterwhitelist) do
		if spellID then
			local icon = select(3, GetSpellInfo(spellID))
			CreateWhiteListButton(name, icon, spellID)
		end
	end
	updateanchors()
end

local wlbox = CreateFrame("EditBox", "oUF_Mlight WhiteList Input", whitelist)
wlbox:SetSize(250, 20)
wlbox:SetPoint("TOPLEFT", 16, -80)
wlbox:SetFont(GameFontHighlight:GetFont(), 12, "OUTLINE")
wlbox:SetAutoFocus(false)
wlbox:SetTextInsets(3, 0, 0, 0)
wlbox:SetScript("OnShow", function(self) self:SetText(L["input spellID"]) end)
wlbox:SetScript("OnEditFocusGained", function(self) self:HighlightText() end)
wlbox:SetScript("OnEscapePressed", function(self)
	self:ClearFocus()
	wlbox:SetText(L["input spellID"])
end)
wlbox:SetScript("OnEnterPressed", function(self)
	local spellID = self:GetText()
	self:ClearFocus()
	local name, _, icon = GetSpellInfo(spellID)
	if name then
		CreateWhiteListButton(name, icon, spellID)
		oUF_MlightDB.AuraFilterwhitelist[spellID] = name
		print("|cff7FFF00"..name.." |r"..L["add to white list"])
		updateanchors()
	else
		print("|cff7FFF00"..spellID.." |r"..L["not a corret Spell ID"])
	end
end)

--====================================================--
--[[                -- Init --                      ]]--
--====================================================--
local eventframe = CreateFrame("Frame")
eventframe:RegisterEvent("ADDON_LOADED")
eventframe:SetScript("OnEvent", function(self, event, ...) self[event](self, ...) end)

function eventframe:ADDON_LOADED(arg1)
	if arg1 ~= "oUF_Mlight" then return end
	if oUF_MlightDB == nil then 
		ns.LoadVariables()
	end
	for i = 1, #checkbuttons do
		F.ReskinCheck(checkbuttons[i])
	end
	for i = 1, #sliders do
		F.ReskinSlider(sliders[i])
	end
	for i = 1, #editboxes do
		F.CreateBD(editboxes[i])
	end
	for i = 1, #anchorboxes do
		F.Reskin(anchorboxes[i])
	end
	for i = 1, #raidsizeboxes do
		F.Reskin(raidsizeboxes[i])
	end
	F.Reskin(fontflagbu)
	F.Reskin(startcolorpicker)
	F.Reskin(endcolorpicker)
	F.CreateBD(wlbox)
	sort(oUF_MlightDB.AuraFilterwhitelist)
	F.Reskin(reloadbu)
	F.Reskin(resetbu)
	F.Reskin(reloadbu2)
	F.ReskinScroll(_G["oUF_Mlight GUI Frame_ScrollFrameScrollBar"])
	F.ReskinScroll(_G["oUF_Mlight Raid GUI Frame_ScrollFrameScrollBar"])
	F.ReskinScroll(_G["oUF_Mlight WhiteList Frame_ScrollFrameScrollBar"])
	self:RegisterEvent("PLAYER_ENTERING_WORLD")
end

function eventframe:PLAYER_ENTERING_WORLD(arg1)
	for i = 1, #checkbuttons do
		checkbuttons[i]:SetChecked(oUF_MlightDB[checkbuttons[i].value] == true)
	end
	for i = 1, #sliders do
		sliders[i]:SetValue(oUF_MlightDB[sliders[i].value])
	end
	for i = 1, #anchorboxes do
		anchorboxes[i]:SetText(oUF_MlightDB[anchorboxes[i].value])
	end
	for i = 1, #raidsizeboxes do
		if oUF_MlightDB[raidsizeboxes[i].value] == "1,2,3,4,5" then
			oUF_MlightDB[raidsizeboxes[i].value] = "1,2,3,4,5,6,7,8"
			raidsizeboxes[i]:SetText("40-man")
		else
			oUF_MlightDB[raidsizeboxes[i].value] = "1,2,3,4,5"
			raidsizeboxes[i]:SetText("25-man")
		end
	end
	fontflagbu:SetText(oUF_MlightDB[fontflagbu.value])
	startcolorpicker.tex:SetVertexColor(oUF_MlightDB[startcolorpicker.value].r, oUF_MlightDB[startcolorpicker.value].g, oUF_MlightDB[startcolorpicker.value].b)
	endcolorpicker.tex:SetVertexColor(oUF_MlightDB[endcolorpicker.value].r, oUF_MlightDB[endcolorpicker.value].g, oUF_MlightDB[endcolorpicker.value].b)
	CreateWhiteListButtonList()
	self:UnregisterEvent("PLAYER_ENTERING_WORLD")
end

--[[ CPU and Memroy testing
local interval = 0
cfg:SetScript("OnUpdate", function(self, elapsed)
 	interval = interval - elapsed
	if interval <= 0 then
		UpdateAddOnMemoryUsage()
			print("----------------------")
			print("|cffBF3EFFoUF_Mlight|r CPU  "..GetAddOnCPUUsage("oUF_Mlight").." Memory "..format("%.1f kb", floor(GetAddOnMemoryUsage("oUF_Mlight"))))
			print("|cffFFFF00oUF|r CPU  "..GetAddOnCPUUsage("oUF").."  Memory  "..format("%.1f kb", floor(GetAddOnMemoryUsage("oUF"))))
			print("----------------------")
		interval = 4
	end
end)
]]--