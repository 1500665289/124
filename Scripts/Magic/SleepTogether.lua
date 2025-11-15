local tbTable = GameMain:GetMod("MagicHelper");
local tbMagic = tbTable:GetMagic("SleepTogether");
local msc = {100,500,1000,1200}--女突破增加门派影响力
local msp = {100,500,1000,1500}--女突破增加门派声望
local msn = {50,100,200,300}--女突破增加门派恶名
local xw = {100,500,1000,2000}
local hglist = {}
local nowlist = {}


function tbMagic:EnableCheck(npc)
	if npc.LuaHelper:GetGongName() == "Gong_HappyWoman" and npc.Sex == CS.XiaWorld.g_emNpcSex.Female then
	return true;
	else
	return false;
	end
end

function tbMagic:MagicEnter(IDs, IsThing)
	local count = Map.Things:GetActiveNpcs(g_emNpcRaceType.Wisdom).Count

	for i=0,count - 1,1 do
		local npc = Map.Things:GetActiveNpcs()[i]
		if npc.Camp == self.bind.Camp and npc.IsDeath == false and npc.IsDisciple then
			table.insert(hglist,npc)
		end
	end

	self:EnterChoice(hglist)
end

function tbMagic:MagicStep(dt, duration)
	self:SetProgress(duration/200);
	if duration >= 200 then
		return 1;
	end
	return 0;
end

function tbMagic:MagicLeave(success)
	if success == true then
		local num1 = self.bind.LingV;
		local num2 = 0;
		local num3 = npc.Needs:GetNeedValue(CS.XiaWorld.g_emNeedType.MindState) - npc.Needs:GetNeedValue(CS.XiaWorld.g_emNeedType.MindState)%1;
		local nan = 0;
		local nv = 1;
		local flag = 0;
		for i=1,#nowlist,1 do
		local npc = nowlist[i]
		num1 = num1 + (npc.LingV - npc.LingV%1)
		if npc.Sex == CS.XiaWorld.g_emNpcSex.Male then
		num2 = num2 + (npc.Needs:GetNeedValue(CS.XiaWorld.g_emNeedType.Practice) - npc.Needs:GetNeedValue(CS.XiaWorld.g_emNeedType.Practice)%1)*0.3
		npc.Needs:AddNeedValue(CS.XiaWorld.g_emNeedType.Practice,(npc.Needs:GetNeedValue(CS.XiaWorld.g_emNeedType.Practice) - npc.Needs:GetNeedValue(CS.XiaWorld.g_emNeedType.Practice)%1)*0.3)
		nan = nan + 1;
		else
		nv = nv + 1;
		end
		num3 = num3 + npc.Needs:GetNeedValue(CS.XiaWorld.g_emNeedType.MindState) - npc.Needs:GetNeedValue(CS.XiaWorld.g_emNeedType.MindState)%1;
		if npc.PropertyMgr.Practice.EsotericaV ~= nil then
		local playerInfo = npc.PropertyMgr.Practice.EsotericaV
		local iter = playerInfo:GetEnumerator()
		while iter:MoveNext() do
		local name = iter.Current.Key
			if CS.XiaWorld.EsotericaMgr.Instance:GetEsoterica(name).IsSys == false and self.bind.LuaHelper:IsLearnedEsoteric(name) == false and flag == 0 then
				self.bind.PropertyMgr.Practice:LearnEsotericaEx(name,1,false,true)
				flag = 1
			end
		end
		flag = 0;
		end
		end
		for i=1,#nowlist,1 do
		if npc.Sex == CS.XiaWorld.g_emNpcSex.Male then
		npc:AddLing(num1 * 0.2 *  (npc.Needs:GetNeedValue(CS.XiaWorld.g_emNeedType.MindState) - npc.Needs:GetNeedValue(CS.XiaWorld.g_emNeedType.MindState)%1)/num3)
		else
			if self.bind.Equip:FindTool("Item_GetYinJingTool") then
				local item1 = self:GetYinJingItem(npc)
				local itemThing1 = ThingMgr:AddItemThing(0, item1, Map, 1, false);
				itemThing1.Author = npc:GetName();
				Map:DropItem(itemThing1, npc.Key, false, false, false, false, 0, false);
			end
		npc:AddLing(num1 * 0.2 *  (npc.Needs:GetNeedValue(CS.XiaWorld.g_emNeedType.MindState) - npc.Needs:GetNeedValue(CS.XiaWorld.g_emNeedType.MindState)%1)/num3)
		npc.Needs:AddNeedValue(CS.XiaWorld.g_emNeedType.Practice,num2 / nv)
		npc.LuaHelper:DropAwardItem("Item_Human_Milk",1)
		end
		end
		if self.bind.Equip:FindTool("Item_GetYinJingTool") then
			local item2 = self:GetYinJingItem(self.bind)
			local itemThing2 = ThingMgr:AddItemThing(0, item2, Map, 1, false);
			itemThing2.Author = self.bind:GetName();
			Map:DropItem(itemThing2, self.bind.Key, false, false, false, false, 0, false);
		end
		self.bind.Needs:AddNeedValue(CS.XiaWorld.g_emNeedType.Practice,num2 / nv)
		self.bind.LuaHelper:DropAwardItem("Item_Human_Milk",1)
		self.bind:AddLing(num1 * 0.2 *  (self.bind.Needs:GetNeedValue(CS.XiaWorld.g_emNeedType.MindState) - self.bind.Needs:GetNeedValue(CS.XiaWorld.g_emNeedType.MindState)%1)/num3)
		hglist = {};
		nowlist = {};
	end
end

function tbMagic:EnterChoice(hglist)
local NameList = self:GetListName(hglist)
	world:ShowStoryBox(""..self.bind.Name.."将从中选择合适的人物进行双修。", "双修选择",NameList,
	function(Key)
		local key = Key + 1;
		if key == #NameList then
		else
		local npc = hglist[key]
		table.insert(nowlist,npc)
		table.remove(hglist,key)
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
	return {NowList=nowlist,HgList=hglist};
end


function tbMagic:OnLoadData(tbData,IDs, IsThing)
	nowlist = tbData.NowList or 0;
	hglist = tbData.HgList or 0;
end