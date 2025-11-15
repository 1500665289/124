local tbTable = GameMain:GetMod("MagicHelper");
local tbMagic = tbTable:GetMagic("HappyGet1");
local msc = {100,500,1000,1200}--女突破增加门派影响力
local msp = {100,500,1000,1500}--女突破增加门派声望
local msn = {50,100,200,300}--女突破增加门派恶名
local xw = {100,500,1000,2000}
local hglist = {}
local nowlist = {}
local jump = 0;
local i = 1;
local flag = 0;



function tbMagic:EnableCheck(npc)
	if npc.LuaHelper:GetGongName() == "Gong_HappyWoman" and npc.Sex == CS.XiaWorld.g_emNpcSex.Female then
	return true;
	else
	return false;
	end
end

function tbMagic:TargetCheck(key, t)
	return true;
end

function tbMagic:MagicEnter(IDs, IsThing)
	self.curIndex = 0;
	self.grids = IDs;
	for i=1,self.grids.Count,1 do
	local key = self.grids[self.curIndex];
	local target = Map.Things:GetThingAtGrid(key, 1);
	if target ~= nil and target ~= self.bind and target.Race.RaceType == CS.XiaWorld.g_emNpcRaceType.Wisdom then
	if self:GetLevel(target) <= self:GetLevel(self.bind) then
		if target.PropertyMgr:FindModifier("HappyGetDebuff") == nil and target.Needs:GetNeedValue(CS.XiaWorld.g_emNeedType.Practice) > 100 then
			if self.bind.Equip:FindTool("Item_Shuangtoulong") == true or target.Sex ~= self.bind.Sex then
				table.insert(hglist,target)
			end
		end
	end
	end
	self.curIndex = self.curIndex + 1;
	end
	self:EnterChoice(hglist)
end

function tbMagic:MagicStep(dt, duration)
	if jump >= 40 and flag == 1 then
		local count = #nowlist
		print(i)
		if i > count then
			return 1;	
		else
		local npc = nowlist[i];
		self:EnterHappy(npc)
		jump = 0;
		i = i + 1;
		end
	elseif jump >= 40 then
		jump = 0;
	end
	jump = jump + dt;
	self:SetProgress(duration/1000);
	if duration >= 1000 then
		return 1;
	end
	return 0;
end

function tbMagic:MagicLeave(success)
	if success == true then
		print("成功")
		self.grids = nil;
		hglist = {};
		nowlist = {};
		jump = 0;
		i = 1;
		flag = 0;
	end
end

function tbMagic:EnterHappy(npc)
	world:ShowStoryBox(""..self.bind.Name.."将与"..npc.Name.."进行采补。", "采补选择",{"采补","放弃"},
	function(Key)
		local key = Key + 1;
		if key == 2 then
			flag = 1;
			return self.bind.Name.."想了想，决定放弃采补。"
		else
		if npc.Sex ~= g_emNpcSex.Male then
		local elevel =self:GetELevel();
		self.bind.PropertyMgr.Practice:AddPractice(xw[elevel])
		self.bind.PropertyMgr:AddModifier("HappyGetBuff")
		self.bind.PropertyMgr:FindModifier("HappyGetBuff"):UpdateTime();
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
			self.bind.LuaHelper:AddMsg(".....获得淫荡")
		end
		if stack >= 10 and npc.LuaHelper:CheckFeature("CrazyDown") == false then
			npc.PropertyMgr:AddFeature("CrazyDown");
			self.bind.LuaHelper:AddMsg(".....获得狂堕")
		end
		if self.bind.Equip:FindTool("Item_GetYinJingTool") then
			local item1 = self:GetYinJingItem(npc)
			local itemThing1 = ThingMgr:AddItemThing(0, item1, Map, 1, false);
			itemThing1.Author = npc:GetName();
			Map:DropItem(itemThing1, npc.Key, false, false, false, false, 0, false);
			local item2 = self:GetYinJingItem(self.bind)
			local itemThing2 = ThingMgr:AddItemThing(0, item2, Map, 1, false);
			itemThing2.Author = self.bind:GetName();
			Map:DropItem(itemThing2, self.bind.Key, false, false, false, false, 0, false);
		end
		local elevel =self:GetELevel();
		local num = npc.MaxLing - npc.MaxLing%1
		local num1 = npc.Needs:GetNeedValue(CS.XiaWorld.g_emNeedType.Practice) - npc.Needs:GetNeedValue(CS.XiaWorld.g_emNeedType.Practice)%1
		self.bind.PropertyMgr.Practice:AddPractice(xw[elevel])
		npc.Needs:AddNeedValue(CS.XiaWorld.g_emNeedType.Practice, - 0.3 * num1)
		self.bind.Needs:AddNeedValue(CS.XiaWorld.g_emNeedType.Practice,0.3 * num1)
		npc.PropertyMgr:ModifierProperty("NpcLingMaxValue",- 0.1 * num,0)
		self.bind.PropertyMgr:ModifierProperty("NpcLingMaxValue", 0.1 * num,0)
		if npc.LingV < 1000 then
			npc.PropertyMgr:AddMaxAge(-5)
			self.bind.PropertyMgr:AddMaxAge(5)
		end


		else
		local elevel =self:GetELevel();
		local num = npc.MaxLing - npc.MaxLing%1
		local num1 = npc.Needs:GetNeedValue(CS.XiaWorld.g_emNeedType.Practice) - npc.Needs:GetNeedValue(CS.XiaWorld.g_emNeedType.Practice)%1
		self.bind.PropertyMgr.Practice:AddPractice(xw[elevel])
		npc.Needs:AddNeedValue(CS.XiaWorld.g_emNeedType.Practice, - 0.3 * num1)
		self.bind.Needs:AddNeedValue(CS.XiaWorld.g_emNeedType.Practice,0.3 * num1)
		npc.PropertyMgr:ModifierProperty("NpcLingMaxValue",- 0.1 * num,0)
		self.bind.PropertyMgr:ModifierProperty("NpcLingMaxValue", 0.1 * num,0)
		if npc.LingV < 1000 then
			npc.PropertyMgr:AddMaxAge(-5)
			self.bind.PropertyMgr:AddMaxAge(5)
		end

		if self.bind.Equip:FindTool("Item_GetYinJingTool") then
			local item2 = MCB:GetYinJingItem(self.bind)
			local itemThing2 = ThingMgr:AddItemThing(0, item2, Map, 1, false);
			itemThing2.Author = self.bind:GetName();
			Map:DropItem(itemThing2, self.bind.Key, false, false, false, false, 0, false);
		end

		local elevel =self:GetELevel();
		self.bind.PropertyMgr.Practice:AddPractice(xw[elevel])
		self.bind.PropertyMgr:AddModifier("HappyGetBuff")
		self.bind.PropertyMgr:FindModifier("HappyGetBuff"):UpdateTime();
		npc.PropertyMgr:AddModifier("HappyGetDebuff")

			local DFdedengjiji = npc.PropertyMgr.Practice.GongStateLevel
			local WFdedengjiji = self.bind.PropertyMgr.Practice.GongStateLevel
		if self.bind.PropertyMgr.Practice.TouchNeck and (self.bind.PropertyMgr.Practice.StageValue ~= 4000 or self.bind.PropertyMgr.Practice.StageValue ~= 6560000) and DFdedengjiji == WFdedengjiji  and npc.Sex ~= self.bind.Sex and npc.Needs:GetNeedValue(CS.XiaWorld.g_emNeedType.Practice) > 100 then
			self.bind.PropertyMgr.Practice:BrokenNeck();
			npc:DoDeath()
			local level = self:GetLevel(self.bind)
			world:ShowMsgBox(""..self.bind.Name.."突破成功！\n获得"..msc[level].."点门派影响力。\n获得"..msp[level].."点门派声望。\n获得"..msn[level].."点门派恶名","突破成功");
			local schoolmgr = CS.XiaWorld.SchoolMgr.Instance;
			schoolmgr.BaseScore = schoolmgr.BaseScore + msp[level];
			schoolmgr.BadScore = schoolmgr.BadScore + msn[level];
			xlua.private_accessible(CS.Wnd_OpenOutsWindow)
			CS.Wnd_OpenOutsWindow.Instance.region:Influencial(msc[level])
		end
		end
		local adesc = GameMain:GetMod('CaiBuStory'):CaiBu(self.bind,npc)
		return adesc
		end
	end)
end


function tbMagic:EnterChoice(hglist)
local NameList = self:GetListName(hglist)
	world:ShowStoryBox(""..self.bind.Name.."将从中选择合适的人物进行采补。", "采补选择",NameList,
	function(Key)
		local key = Key + 1;
		if key == #NameList then
			flag = 1;
		else
		local npc = hglist[key]
		table.insert(nowlist,npc)
		table.remove(hglist,key)

		for k,v in ipairs(nowlist) do
		print(v.Name)
		end

		self:EnterChoice(hglist)
		end
	end)
end

function tbMagic:GetListName(hglist)
local list = {}
for k,v in pairs(hglist) do
	local sex = nil;
	local gua = nil;
	local level = nil;
	local age = nil;
	if v.Sex == g_emNpcSex.Male then
		sex = "[男性]"
	else
		sex = "[女性]"
	end
	if v.Sex == g_emNpcSex.Male then
		gua = ""
	elseif v.LuaHelper:CheckFeature("Pogua") == true then
		gua = "[非处]"
	else
		gua = "[处女]"
	end
	if v.IsDisciple then
		level = "[内门]"
	else
		level = "[外门]"
	end
	local AGE = v.Age - v.Age%1
	age = "["..AGE.."岁]";
	list[k] = v.Name..sex..age..level..gua;
end
list[#list+ 1] = "选择完成"
return list;
end

function tbMagic:GetLevel(npc)
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

function tbMagic:GetELevel()
local num = 0;
if self.bind.LuaHelper:IsLearnedEsoteric("Gong_HappyWoman_13") == true then
num = 4;
elseif self.bind.LuaHelper:IsLearnedEsoteric("Gong_HappyWoman_8") == true then
num = 3;
elseif self.bind.LuaHelper:IsLearnedEsoteric("Gong_HappyWoman_3") == true then
num = 2;
else
num = 1;
end
return num;
end

function tbMagic:GetYinJingItem(npc)
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

function tbMagic:OnGetSaveData()
	return {Index = self.curIndex,NowList=nowlist,HgList=hglist,Jump=jump,I=i,Flag=flag};
end


function tbMagic:OnLoadData(tbData,IDs, IsThing)
	self.grids = IDs;
	self.curIndex = tbData.Index or 0;
	nowlist = tbData.NowList or 0;
	hglist = tbData.HgList or 0;
	jump = tbData.Jump or 0;
	i = tbData.I or 0;
	flag = tbData.Flag or 0;
end