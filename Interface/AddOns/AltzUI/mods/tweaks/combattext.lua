-- LightCT by Alza
local T, C, L, G = unpack(select(2, ...))
local dragFrameList = G.dragFrameList

if not aCoreCDB.combattext then return end

local frames = {}
local font = GameFontHighlight:GetFont()
local timer = 0
local number

for i = 1, 2 do
	local f = CreateFrame("ScrollingMessageFrame", "Combat Text"..i, UIParent)
	if i == 1 then
		f.movingname = L["damageCT"]
	else
		f.movingname = L["healingCT"]
	end
	f:SetFont(font, 12, "OUTLINE")
	f:SetShadowColor(0, 0, 0, 0)
	f:SetFadeDuration(0.2)
	f:SetTimeVisible(3)
	f:SetMaxLines(100)
	f:SetSpacing(2)
	f:SetWidth(84)
	f:SetHeight(150)
	
	if i == 1 then
		f:SetJustifyH"RIGHT"
		f:SetPoint("RIGHT", UIParent, "CENTER", -185, 0)
	else
		f:SetJustifyH"LEFT"
		f:SetPoint("LEFT", UIParent, "CENTER", -365, 0)
	end

	T.CreateDragFrame(f, dragFrameList, -2 , true) --frame, dragFrameList, inset, clamp

	f.dragFrame:SetScript("OnUpdate", function(self, elapsed)
		timer = timer + elapsed
		if timer > 1 then	
			number = random(1 , 10000)
			frames[1]:AddMessage("-"..number, 1, 0, 0)
			frames[2]:AddMessage("+"..number, 0, 1, 0)
			timer = 0
		end
	end)

	frames[i] = f
end

local tbl = {
	["DAMAGE"] = 			{frame = 1, prefix =  "-", 		arg2 = true, 	r = 1, 		g = 0.1, 	b = 0.1},
	["DAMAGE_CRIT"] = 		{frame = 1, prefix = "c-", 		arg2 = true, 	r = 1, 		g = 0.1, 	b = 0.1},
	["SPELL_DAMAGE"] = 		{frame = 1, prefix =  "-", 		arg2 = true, 	r = 0.79, 	g = 0.3, 	b = 0.85},
	["SPELL_DAMAGE_CRIT"] = 	{frame = 1, prefix = "c-", 		arg2 = true, 	r = 0.79, 	g = 0.3, 	b = 0.85},
	["HEAL"] = 			{frame = 2, prefix =  "+", 		arg3 = true, 	r = 0.1, 	g = 1, 		b = 0.1},
	["HEAL_CRIT"] = 		{frame = 2, prefix = "c+", 		arg3 = true, 	r = 0.1, 	g = 1, 		b = 0.1},
	["PERIODIC_HEAL"] = 		{frame = 2, prefix =  "+", 		arg3 = true, 	r = 0.1, 	g = 1, 		b = 0.1},
	["MISS"] = 			{frame = 1, prefix = "Miss", 				r = 1, 		g = 0.1, 	b = 0.1},
	["SPELL_MISS"] = 		{frame = 1, prefix = "Miss", 				r = 0.79, 	g = 0.3, 	b = 0.85},
	["SPELL_REFLECT"] = 		{frame = 1, prefix = "Reflect", 			r = 1, 		g = 1, 		b = 1},
	["DODGE"] = 			{frame = 1, prefix = "Dodge", 				r = 1, 		g = 0.1, 	b = 0.1},
	["PARRY"] = 			{frame = 1, prefix = "Parry", 				r = 1, 		g = 0.1, 	b = 0.1},
	["BLOCK"] = 			{frame = 1, prefix = "Block", 	spec = true,		r = 1, 		g = 0.1, 	b = 0.1},
	["RESIST"] = 			{frame = 1, prefix = "Resist", 	spec = true, 		r = 1, 		g = 0.1, 	b = 0.1},
	["SPELL_RESIST"] = 		{frame = 1, prefix = "Resist", 	spec = true, 		r = 0.79, 	g = 0.3, 	b = 0.85},
	["ABSORB"] = 			{frame = 1, prefix = "Absorb", 	spec = true, 		r = 1, 		g = 0.1, 	b = 0.1},
	["SPELL_ABSORBED"] = 		{frame = 1, prefix = "Absorb", 	spec = true, 		r = 0.79, 	g = 0.3, 	b = 0.85},
}

local info
local template = "-%s (%s)"

local eventframe = CreateFrame"Frame"
eventframe:RegisterEvent"COMBAT_TEXT_UPDATE"
eventframe:SetScript("OnEvent", function(self, event, subev, arg2, arg3)
	info = tbl[subev]
	if(info) then
		local msg = info.prefix or ""
		if(info.spec) then
			if(arg3) then
				msg = template:format(arg2, arg3)
			end
		else
			if(info.arg2) then msg = msg..arg2 end
			if(info.arg3) then msg = msg..arg3 end
		end
		frames[info.frame]:AddMessage(msg, info.r, info.g, info.b)
	end
end)

if not IsAddOnLoaded("Blizzard_CombatText") then LoadAddOn("Blizzard_CombatText") end

if IsAddOnLoaded("Blizzard_CombatText") then
	CombatText:SetScript("OnUpdate", nil)
	CombatText:SetScript("OnEvent", nil)
	CombatText:UnregisterAllEvents()
end