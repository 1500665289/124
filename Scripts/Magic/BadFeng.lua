local tbTable = GameMain:GetMod("MagicHelper");
local tbMagic = tbTable:GetMagic("BadFeng");
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

	for i=0,count - 1,1 do
		local npc = Map.Things:GetActiveNpcs(g_emNpcRaceType.Wisdom)[i]
		if npc.LuaHelper:GetGLevel() > 0 and npc.Sex == CS.XiaWorld.g_emNpcSex.Female and npc.IsDeath == false then
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
		self.bind:Reborn();
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
	world:ShowStoryBox(""..self.bind.Name.."将与"..npc.Name.."进行双修。", "双修选择",{"双修","放弃"},
	function(Key)
		local key = Key + 1;
		if key == 2 then
			flag = 1;
			return self.bind.Name.."想了想，决定放弃与其双修。"
		else
			if npc.LuaHelper:CheckFeature("Pogua") == false then
			npc.PropertyMgr:AddFeature("Pogua");
			if npc.IsDisciple then
			local pnum = self.bind.Needs:GetNeedValue(CS.XiaWorld.g_emNeedType.Practice)
			local mnum = self.bind.Needs:GetNeedValue(CS.XiaWorld.g_emNeedType.MindState)
			local mnum2 = npc.Needs:GetNeedValue(CS.XiaWorld.g_emNeedType.MindState)
			npc.Needs:AddNeedValue(CS.XiaWorld.g_emNeedType.Practice,pnum * 0.3)
			npc.PropertyMgr:ModifierProperty("NpcLingMaxValue", self.bind.PropertyMgr:GetProperty("NpcLingMaxValue") * 0.05,0)
			npc:AddLing((self.bind.MaxLing + npc.MaxLing) * 0.2 * mnum / (mnum + mnum2))
			npc.PropertyMgr:ModifierProperty("NpcLingMaxValue", self.bind.PropertyMgr:GetProperty("NpcLingMaxValue") / self.bind:GetProperty("NpcFight_FabaoNum") ,0)
			local playerInfo = self.bind.PropertyMgr.Practice.EsotericaV
			local iter = playerInfo:GetEnumerator()
			while iter:MoveNext() do
				local name = iter.Current.Key
				if CS.XiaWorld.EsotericaMgr.Instance:GetEsoterica(name).IsSys == false then
					npc.PropertyMgr.Practice:LearnEsotericaEx(name,1,false,true)
				end
			end
			end
			npc.PropertyMgr.BaseData:AddAddion(CS.XiaWorld.g_emNpcBasePropertyType.Charisma,2);
			npc.PropertyMgr.BaseData:AddAddion(CS.XiaWorld.g_emNpcBasePropertyType.Luck,2);
			npc.PropertyMgr.BaseData:AddAddion(CS.XiaWorld.g_emNpcBasePropertyType.Intelligence,2);
			npc.PropertyMgr.BaseData:AddAddion(CS.XiaWorld.g_emNpcBasePropertyType.Perception,2);
			npc.PropertyMgr.BaseData:AddAddion(CS.XiaWorld.g_emNpcBasePropertyType.Physique,2);
			GameMain:GetMod("HappyGet_HuaiYun"):huaiyun1(self.bind,npc)
			if self.bind.Equip:FindTool("Item_GetYinJingTool") then
				local item1 = self:GetYinJingItem(npc)
				local itemThing1 = ThingMgr:AddItemThing(0, item1, Map, 1, false);
				itemThing1.Author = npc:GetName();
				Map:DropItem(itemThing1, npc.Key, false, false, false, false, 0, false);
			end
			return ".....邪欲双修一血怀孕"
			else
			if npc.IsDisciple then
			local pnum = self.bind.Needs:GetNeedValue(CS.XiaWorld.g_emNeedType.Practice)
			local mnum = self.bind.Needs:GetNeedValue(CS.XiaWorld.g_emNeedType.MindState)
			local mnum2 = npc.Needs:GetNeedValue(CS.XiaWorld.g_emNeedType.MindState)
			npc.Needs:AddNeedValue(CS.XiaWorld.g_emNeedType.Practice,pnum * 0.3)
			npc:AddLing((self.bind.MaxLing + npc.MaxLing) * 0.2 * mnum / (mnum + mnum2))
			npc.PropertyMgr:ModifierProperty("NpcLingMaxValue", self.bind.PropertyMgr:GetProperty("NpcLingMaxValue") / self.bind:GetProperty("NpcFight_FabaoNum"),0)
			npc.PropertyMgr.Practice:AddTreeExp(self.bind.PropertyMgr.Practice.TreeExp - self.bind.PropertyMgr.Practice.TreeExp % 1,true);
			local playerInfo = self.bind.PropertyMgr.Practice.EsotericaV
			local iter = playerInfo:GetEnumerator()
			while iter:MoveNext() do
				local name = iter.Current.Key
				if CS.XiaWorld.EsotericaMgr.Instance:GetEsoterica(name).IsSys == false then
					npc.PropertyMgr.Practice:LearnEsotericaEx(name,1,false,true)
				end
			end
			end
			npc.PropertyMgr.BaseData:AddAddion(CS.XiaWorld.g_emNpcBasePropertyType.Charisma,2);
			npc.PropertyMgr.BaseData:AddAddion(CS.XiaWorld.g_emNpcBasePropertyType.Luck,2);
			npc.PropertyMgr.BaseData:AddAddion(CS.XiaWorld.g_emNpcBasePropertyType.Intelligence,2);
			npc.PropertyMgr.BaseData:AddAddion(CS.XiaWorld.g_emNpcBasePropertyType.Perception,2);
			npc.PropertyMgr.BaseData:AddAddion(CS.XiaWorld.g_emNpcBasePropertyType.Physique,2);
			GameMain:GetMod("HappyGet_HuaiYun"):huaiyun1(self.bind,npc)
			if self.bind.Equip:FindTool("Item_GetYinJingTool") then
				local item1 = self:GetYinJingItem(npc)
				local itemThing1 = ThingMgr:AddItemThing(0, item1, Map, 1, false);
				itemThing1.Author = npc:GetName();
				Map:DropItem(itemThing1, npc.Key, false, false, false, false, 0, false);
			end
			return ".....邪欲双修怀孕"

			end
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