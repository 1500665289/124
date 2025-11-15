local tbTable = GameMain:GetMod("MagicHelper");
local tbMagic = tbTable:GetMagic("TrueDragon");
local msc = {100,500,700,1000} --男突破增加门派影响力
local msp = {100,200,500,800}--男突破增加门派声望
local msn = {10,50,100,150}--男突破增加门派恶名
local xw = {500,5000,20000,50000}
local buff = {40,80,160,320}
local cd = {75,150,200,300}
local hglist = {}
local nowlist = {}
local jump = 0;
local i = 1;
local flag = 0;
local num = 0;


function tbMagic:EnableCheck(npc)
	if npc.LuaHelper:GetGongName() == "Gong_HappyMan" and npc.Sex == CS.XiaWorld.g_emNpcSex.Male then
	return true;
	else
	return false;
	end
end

function tbMagic:MagicEnter(IDs, IsThing)
	local count = Map.Things:GetActiveNpcs(g_emNpcRaceType.Wisdom).Count
	local sum = 0;

	if self.bind.LuaHelper:IsLearnedEsoteric("Gong_HappyMan_15") == true then
		sum = 3
	end

	for i=0,count - 1,1 do
		local npc = Map.Things:GetActiveNpcs()[i]
		if npc.LuaHelper:GetGLevel() <= sum then
			npc.PropertyMgr:AddModifier("MOD_LostSoul")
			table.insert(hglist,npc)
		end
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
	self:SetProgress(duration/300);
	if duration >= 300 then
		return 1;
	end
	return 0;
end

function tbMagic:MagicLeave(success)
	if success == true then
		print("成功")
		hglist = {};
		nowlist = {};
		jump = 0;
		i = 1;
		flag = 0;
		num = 0;
	end
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

		num = num + 1

		if num >=self.bind:GetProperty("NpcFight_FabaoNum") then
			hglist = {}
		end

		for k,v in ipairs(nowlist) do
		print(v.Name)
		end

		self:EnterChoice(hglist)
		end
	end)
end


function tbMagic:EnterHappy(npc)
	world:ShowStoryBox(""..self.bind.Name.."将与"..npc.Name.."进行采补。", "采补选择",{"采补","放弃"},
	function(Key)
		local key = Key + 1;
		if key == 2 then
			flag = 1;
			return self.bind.Name.."想了想，决定放弃采补。"
		else
		npc.PropertyMgr:RemoveModifier("MOD_LostSoul")
		if npc.LuaHelper:CheckFeature("Pogua") == false and npc.Sex ~= g_emNpcSex.Male then
		local num = 0.015 * self.bind.PropertyMgr:GetProperty("NpcLingMaxValue") + 2000
		if num >= 1000000 then
			num = 1000000
		end
		npc.PropertyMgr:AddFeature("Pogua");
		self.bind.PropertyMgr:ModifierProperty("NpcLingMaxValue", num,0)
		npc.PropertyMgr:AddMaxAge(-30)
		npc.PropertyMgr:AddModifier("HappyGetFirstBuff")
		npc.PropertyMgr:AddModifier("HappyGetDebuff")
		self.bind.PropertyMgr:AddModifier("HappyGetBuff")
		local DFdedengjiji = npc.PropertyMgr.Practice.GongStateLevel
		local WFdedengjiji = self.bind.PropertyMgr.Practice.GongStateLevel
			if self.bind.PropertyMgr.Practice.TouchNeck and (self.bind.PropertyMgr.Practice.StageValue ~= 4000 or self.bind.PropertyMgr.Practice.StageValue ~= 6560000) and DFdedengjiji == WFdedengjiji then
			self.bind.PropertyMgr.Practice:BrokenNeck();
			local level = self:GetLevel(self.bind)
			world:ShowMsgBox(""..self.bind.Name.."突破成功！\n获得"..msc[level].."点门派影响力。\n获得"..msp[level].."点门派声望。\n获得"..msn[level].."点门派恶名","突破成功");
			local schoolmgr = CS.XiaWorld.SchoolMgr.Instance;
			schoolmgr.BaseScore = schoolmgr.BaseScore + msp[level];
			schoolmgr.BadScore = schoolmgr.BadScore + msn[level];
			xlua.private_accessible(CS.Wnd_OpenOutsWindow)
			CS.Wnd_OpenOutsWindow.Instance.region:Influencial(msc[level])
			end
		local elevel =self:GetELevel();
		self.bind.PropertyMgr.Practice:AddPractice(xw[elevel])
		self.bind.PropertyMgr:FindModifier("HappyGetBuff").Duration = 640 - buff[elevel];
			if self.bind.Equip:FindTool("Item_GetYinJingTool") then
				local item1 = self:GetYinJingItem(npc)
				local itemThing1 = ThingMgr:AddItemThing(0, item1, Map, 1, false);
				itemThing1.Author = npc:GetName();
				Map:DropItem(itemThing1, npc.Key, false, false, false, false, 0, false);
			end
		else
		local elevel =self:GetELevel();
		self.bind.PropertyMgr.Practice:AddPractice(xw[elevel])
		self.bind.PropertyMgr:AddModifier("HappyGetBuff")
		self.bind.PropertyMgr:FindModifier("HappyGetBuff").Duration = 640 - buff[elevel];
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
		end
		if stack >= 10 and npc.LuaHelper:CheckFeature("CrazyDown") == false then
			npc.PropertyMgr:AddFeature("CrazyDown");
		end
			if self.bind.Equip:FindTool("Item_GetYinJingTool") then
				local item1 = self:GetYinJingItem(npc)
				local itemThing1 = ThingMgr:AddItemThing(0, item1, Map, 1, false);
				itemThing1.Author = npc:GetName();
				Map:DropItem(itemThing1, npc.Key, false, false, false, false, 0, false);
			end
		end
		local adesc = GameMain:GetMod('CaiBuStory'):CaiBu(self.bind,npc)
		return adesc
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
if self.bind.LuaHelper:IsLearnedEsoteric("Gong_HappyMan_17") == true then
num = 4;
elseif self.bind.LuaHelper:IsLearnedEsoteric("Gong_HappyMan_11") == true then
num = 3;
elseif self.bind.LuaHelper:IsLearnedEsoteric("Gong_HappyMan_6") == true then
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
	return {NowList=nowlist,HgList=hglist,Jump=jump,I=i,Flag=flag,Num=num};
end


function tbMagic:OnLoadData(tbData,IDs, IsThing)
	nowlist = tbData.NowList or 0;
	hglist = tbData.HgList or 0;
	jump = tbData.Jump or 0;
	i = tbData.I or 0;
	flag = tbData.Flag or 0;
	num = tbData.Num or 0;
end