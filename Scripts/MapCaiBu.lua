local MCB = GameMain:GetMod("MapCaiBu");
local CB = GameMain:GetMod("_LogicMode"):CreateMode("MapCaiBu")
local Target = {};
local time = 0;
local flag = 0;
local xw1 = {500,5000,20000,50000}
local xw2 = {100,500,1000,2000}
local buff = {40,80,160,320}
local cd = {75,150,200,300}


function MCB:OnStep(dt)
if flag == 0 then
time = time + dt
end
if time > 2 and flag == 0 then
flag = 1
time = 0

if CS.GameMain.Instance.FightMap then
xlua.private_accessible(CS.XiaWorld.FightMapMgr)
	local count = CS.XiaWorld.FightMapMgr.Instance.PlayerAttackNpcs.Count - 1
	for i=0,count,1 do
		local npc = ThingMgr:FindThingByID(CS.XiaWorld.FightMapMgr.Instance.PlayerAttackNpcs[i])
		if npc.LuaHelper:GetGongName() == "Gong_HappyWoman" then
			npc:AddBtnData("采补","res/Sprs/ui/icon_hand","world:EnterUILuaMode('MapCaiBu',bind)","在其他门派进行采补。")
			npc:AddBtnData("取消","res/Sprs/ui/icon_hand","GameMain:GetMod('MapCaiBu'):RemoveModifier(bind)","取消正在进行的采补行为。")
		elseif npc.LuaHelper:GetGongName() == "Gong_HappyMan" then
			npc:AddBtnData("采补","res/Sprs/ui/icon_hand","world:EnterUILuaMode('MapCaiBu',bind)","在其他门派进行采补。")
			npc:AddBtnData("取消","res/Sprs/ui/icon_hand","GameMain:GetMod('MapCaiBu'):RemoveModifier(bind)","取消正在进行的采补行为。")
		end
	end
else
	local count = Map.Things:GetActiveNpcs(g_emNpcRaceType.Wisdom).Count - 1
	for i=0,count,1 do
		local npc = Map.Things:GetActiveNpcs(g_emNpcRaceType.Wisdom)[i]
		if npc.LuaHelper:GetGongName() == "Gong_HappyWoman" then
			npc:RemoveBtnData("采补")
			npc:RemoveBtnData("取消")
		elseif npc.LuaHelper:GetGongName() == "Gong_HappyMan" then
			npc:RemoveBtnData("采补")
			npc:RemoveBtnData("取消")
		end
	end
end
end
end


function MCB:RemoveModifier(npc)
if npc.PropertyMgr:FindModifier("Happy_MapCaiBu") then
npc.PropertyMgr:RemoveModifier("Happy_MapCaiBu")
end
end

function MCB:AddNpc(npc1,npc2)
	Target[1] = npc1
	Target[2] = npc2
end

function MCB:GetNpc()
	return Target;
end


function MCB:NeedSyncData()
	 return false;
end

function CB:OnModeEnter(p)
	self:SetKeyCondition("Npc")
	self:OpenThingCheck()
	self:ShowLine(p[1])
	self:SetHeadMsg("请在隐匿状态下近距离选择一名角色进行采补")
	self.Npc = bind;
end

function CB:CheckThing(key)
	local npc = self:GetMap().Things:GetThingAtGrid(key, g_emThingType.Npc)
	local my = self.Npc
	if GridMgr:Distance(my.Key,npc.Key) > 3 then
	self:SetHeadMsg("距离太远")
	return false;
	end
	if my.FightBody.IsFighting then
	self:SetHeadMsg("当前正在战斗")
	return false;
	end
	if npc.Race.RaceType ~= CS.XiaWorld.g_emNpcRaceType.Wisdom then
	self:SetHeadMsg("当前对象非人类")
	return false;
	end
	if my:HasSpecialFlag(CS.XiaWorld.g_emNpcSpecailFlag.FLAG_CONCEALMENT) == false then
	self:SetHeadMsg("当前未进入隐匿状态")
	return false;
	end
	if npc.Camp == CS.XiaWorld.Fight.g_emFightCamp.Player then
	self:SetHeadMsg("当前对象为己方NPC")
	return false;
	end
	if my.LuaHelper:GetGLevel() < npc.LuaHelper:GetGLevel() then
	self:SetHeadMsg("当前对象境界大于己方")
	return false;
	end
	if npc.PropertyMgr:FindModifier("HappyGetDebuff") then
	self:SetHeadMsg("当前对象已经采补过")
	return false;
	end
	if my.LuaHelper:GetGongName() == "Gong_HappyMan" and my.Sex == CS.XiaWorld.g_emNpcSex.Male and my.Sex == npc.Sex and my.LuaHelper:IsLearnedEsoteric("Gong_HappyMan_5") == false then
	self:SetHeadMsg("未学会炼精化气(同性)")
	return false;
	end
	if my.LuaHelper:GetGongName() == "Gong_HappyWoman" and my.Sex == CS.XiaWorld.g_emNpcSex.Female and my.Sex == npc.Sex and my.Equip:FindTool("Item_Shuangtoulong") == nil then
	self:SetHeadMsg("未装备双头龙道具")
	return false;
	end
	self:SetHeadMsg("可以进行采补");
	return true;
end


function CB:Apply(key)
	local npc = self:GetMap().Things:GetThingAtGrid(key, g_emThingType.Npc)
	local my = self.Npc;
	GameMain:GetMod("MapCaiBu"):AddNpc(my,npc)
	npc.JobEngine:ClearJob()
	npc:Face2Pos(my.Pos, false)
	CS.Wnd_DialogboxWindow.Get("(=m=）", npc, 5, 0, 0.5, 0)
	npc.PropertyMgr:AddModifier("Happy_MapCaiBued")
	my.PropertyMgr:AddModifier("Happy_MapCaiBu")
end


function MCB:CaiBu()
local my = GameMain:GetMod("MapCaiBu"):GetNpc()[1]
local npc = GameMain:GetMod("MapCaiBu"):GetNpc()[2]
	if my.Sex == g_emNpcSex.Male then
		if npc.LuaHelper:CheckFeature("Pogua") == false and npc.Sex ~= g_emNpcSex.Male then
		local num = 0.015 * my.PropertyMgr:GetProperty("NpcLingMaxValue") + 2000
		if num >= 1000000 then
			num = 1000000
		end
		npc.PropertyMgr:AddFeature("Pogua");
		my.PropertyMgr:ModifierProperty("NpcLingMaxValue", num,0)
		npc.PropertyMgr:AddMaxAge(-30)
		npc.PropertyMgr:AddModifier("HappyGetFirstBuff")
		npc.PropertyMgr:AddModifier("HappyGetDebuff")
		my.PropertyMgr:AddModifier("HappyGetBuff")
		local elevel =MCB:GetELevel1(my);
		my.PropertyMgr.Practice:AddPractice(xw1[elevel])
		my.PropertyMgr:FindModifier("HappyGetBuff").Duration = 640 - buff[elevel];
		if my.PropertyMgr.Practice.StageValue == my.PropertyMgr.Practice.CurStage.Value and npc.PropertyMgr.Practice.GongStateLevel == my.PropertyMgr.Practice.GongStateLevel then
			my.PropertyMgr.Practice:BrokenNeck(); 
			world:ShowMsgBox(""..my.Name.."突破成功！","突破成功");
		end
		else
		local elevel =MCB:GetELevel1(my);
		my.PropertyMgr.Practice:AddPractice(xw1[elevel])
		my.PropertyMgr:AddModifier("HappyGetBuff")
		my.PropertyMgr:FindModifier("HappyGetBuff").Duration = 640 - buff[elevel];
		my.PropertyMgr:FindModifier("HappyGetBuff"):UpdateTime();
		npc.PropertyMgr:AddModifier("HappyGetDebuff")
		if npc.Sex ~= my.Sex then
		npc.PropertyMgr:AddModifier("HappyGetOpenBuff")
		if npc.LuaHelper:CheckFeature("YinDang") == false then
		if npc.PropertyMgr:FindModifier("HappyGetOffBuff") == nil and npc.PropertyMgr:FindModifier("HappyGetFirstBuff") == nil then
		npc.PropertyMgr:AddModifier("HappyGetOffBuff")
		npc.PropertyMgr:FindModifier("HappyGetOffBuff").Duration =300 + npc.PropertyMgr:FindModifier("HappyGetOpenBuff").Stack * 20;
		end
		end
		npc.PropertyMgr:FindModifier("HappyGetOpenBuff"):UpdateTime();
		local stack = npc.PropertyMgr:FindModifier("HappyGetOpenBuff").Stack
		if stack >= 7 and npc.LuaHelper:CheckFeature("YinDang") == false then
			npc.PropertyMgr:AddFeature("YinDang");
		end
		if stack >= 10 and npc.LuaHelper:CheckFeature("CrazyDown") == false then
			npc.PropertyMgr:AddFeature("CrazyDown");
		end
		if my.Equip:FindTool("Item_GetYinJingTool") then
			local item1 = MCB:GetYinJingItem(npc)
			local itemThing1 = ThingMgr:AddItemThing(0, item1, Map, 1, false);
			itemThing1.Author = npc:GetName();
			Map:DropItem(itemThing1, npc.Key, false, false, false, false, 0, false);
		end
		end
		end
		me:AddMsg(GameMain:GetMod('CaiBuStory'):CaiBu(my,npc))
	else
		if npc.Sex ~= g_emNpcSex.Male then
		local elevel =MCB:GetELevel2(my);
		my.PropertyMgr.Practice:AddPractice(xw2[elevel])
		my.PropertyMgr:AddModifier("HappyGetBuff")
		my.PropertyMgr:FindModifier("HappyGetBuff"):UpdateTime();
		npc.PropertyMgr:AddModifier("HappyGetDebuff")
		npc.PropertyMgr:AddModifier("HappyGetOpenBuff")
		if npc.LuaHelper:CheckFeature("YinDang") == false then
		if npc.PropertyMgr:FindModifier("HappyGetOffBuff") == nil and npc.PropertyMgr:FindModifier("HappyGetFirstBuff") == nil then
		npc.PropertyMgr:AddModifier("HappyGetOffBuff")
		npc.PropertyMgr:FindModifier("HappyGetOffBuff").Duration =300 + npc.PropertyMgr:FindModifier("HappyGetOpenBuff").Stack * 20;
		end
		end
		npc.PropertyMgr:FindModifier("HappyGetOpenBuff"):UpdateTime();
		local stack = npc.PropertyMgr:FindModifier("HappyGetOpenBuff").Stack
		if stack >= 7 and npc.LuaHelper:CheckFeature("YinDang") == false then
			npc.PropertyMgr:AddFeature("YinDang");
		end
		if stack >= 10 and npc.LuaHelper:CheckFeature("CrazyDown") == false then
			npc.PropertyMgr:AddFeature("CrazyDown");
		end
		if my.Equip:FindTool("Item_GetYinJingTool") then
			local item1 = MCB:GetYinJingItem(npc)
			local itemThing1 = ThingMgr:AddItemThing(0, item1, Map, 1, false);
			itemThing1.Author = npc:GetName();
			Map:DropItem(itemThing1, npc.Key, false, false, false, false, 0, false);
			local item2 = MCB:GetYinJingItem(my)
			local itemThing2 = ThingMgr:AddItemThing(0, item2, Map, 1, false);
			itemThing2.Author = my:GetName();
			Map:DropItem(itemThing2, my.Key, false, false, false, false, 0, false);
		end
		local elevel =MCB:GetELevel2(my);
		local num = npc.MaxLing - npc.MaxLing%1
		local num1 = npc.Needs:GetNeedValue(CS.XiaWorld.g_emNeedType.Practice) - npc.Needs:GetNeedValue(CS.XiaWorld.g_emNeedType.Practice)%1
		my.PropertyMgr.Practice:AddPractice(xw2[elevel])
		npc.Needs:AddNeedValue(CS.XiaWorld.g_emNeedType.Practice, - 0.3 * num1)
		my.Needs:AddNeedValue(CS.XiaWorld.g_emNeedType.Practice,0.3 * num1)
		npc.PropertyMgr:ModifierProperty("NpcLingMaxValue",- 0.1 * num,0)
		my.PropertyMgr:ModifierProperty("NpcLingMaxValue", 0.1 * num,0)
		if npc.LingV < 1000 then
			npc.PropertyMgr:AddMaxAge(-5)
			my.PropertyMgr:AddMaxAge(5)
		end


		else
		local elevel =MCB:GetELevel2(my);
		local num = npc.MaxLing - npc.MaxLing%1
		local num1 = npc.Needs:GetNeedValue(CS.XiaWorld.g_emNeedType.Practice) - npc.Needs:GetNeedValue(CS.XiaWorld.g_emNeedType.Practice)%1
		my.PropertyMgr.Practice:AddPractice(xw2[elevel])
		npc.Needs:AddNeedValue(CS.XiaWorld.g_emNeedType.Practice, - 0.3 * num1)
		my.Needs:AddNeedValue(CS.XiaWorld.g_emNeedType.Practice,0.3 * num1)
		npc.PropertyMgr:ModifierProperty("NpcLingMaxValue",- 0.1 * num,0)
		my.PropertyMgr:ModifierProperty("NpcLingMaxValue", 0.1 * num,0)
		if npc.LingV < 1000 then
			npc.PropertyMgr:AddMaxAge(-5)
			my.PropertyMgr:AddMaxAge(5)
		end

		local elevel =MCB:GetELevel2(my);
		my.PropertyMgr.Practice:AddPractice(xw2[elevel])
		my.PropertyMgr:AddModifier("HappyGetBuff")
		my.PropertyMgr:FindModifier("HappyGetBuff"):UpdateTime();
		npc.PropertyMgr:AddModifier("HappyGetDebuff")

		if my.Equip:FindTool("Item_GetYinJingTool") then
			local item2 = MCB:GetYinJingItem(my)
			local itemThing2 = ThingMgr:AddItemThing(0, item2, Map, 1, false);
			itemThing2.Author = my:GetName();
			Map:DropItem(itemThing2, my.Key, false, false, false, false, 0, false);
		end

		if my.PropertyMgr.Practice.StageValue == my.PropertyMgr.Practice.CurStage.Value and npc.PropertyMgr.Practice.GongStateLevel == my.PropertyMgr.Practice.GongStateLevel and npc.Sex ~= my.Sex and npc.Needs:GetNeedValue(CS.XiaWorld.g_emNeedType.Practice) > 100 then
			my.PropertyMgr.Practice:BrokenNeck();
			npc:DoDeath()
			world:ShowMsgBox(""..my.Name.."突破成功！","突破成功");
		end
		end
		me:AddMsg(GameMain:GetMod('CaiBuStory'):CaiBu(my,npc))
	end
end


function MCB:GetLevel(npc)
local num = 0;
local enum = npc.LuaHelper:GetGLevel();
if enum == 0 then
num = 0;
elseif enum <= 3 then
num = 1;
elseif enum <= 6 then
num = 2;
elseif enum <= 9 then
num = 3;
else
num = 4;
end
return num;
end


function MCB:GetELevel1(npc)
local num = 0;
if npc.LuaHelper:IsLearnedEsoteric("Gong_HappyMan_17") == true then
num = 4;
elseif npc.LuaHelper:IsLearnedEsoteric("Gong_HappyMan_11") == true  then
num = 3;
elseif npc.LuaHelper:IsLearnedEsoteric("Gong_HappyMan_6") == true  then
num = 2;
else
num = 1;
end
return num;
end

function MCB:GetELevel2(npc)
local num = 0;
if npc.LuaHelper:IsLearnedEsoteric("Gong_HappyWoman_13") == true then
num = 4;
elseif npc.LuaHelper:IsLearnedEsoteric("Gong_HappyWoman_8") == true then
num = 3;
elseif npc.LuaHelper:IsLearnedEsoteric("Gong_HappyWoman_3") == true then
num = 2;
else
num = 1;
end
return num;
end

function MCB:GetYinJingItem(npc)
local item = nil;
local level = npc.LuaHelper:GetGLevel();
if npc.PropertyMgr.Practice.GodCount ~= 0 then
item = "Item_yinjin6"
elseif level > 9 then
item = "Item_yinjin5"
elseif level > 6 then
item = "Item_yinjin4"
elseif level > 3 then
item = "Item_yinjin3"
elseif level > 0 then
item = "Item_yinjin2"
else
item = "Item_yinjin1"
end
return item;
end
