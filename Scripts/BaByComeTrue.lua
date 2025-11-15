local BCT = GameMain:GetMod("BaByComeTrue");
local Chat = GameMain:GetMod("_LogicMode"):CreateMode("BaByChat")
BCT.Need = {0,0,0}
BCT.Npcs = {[1] = 0,[2]= 0}

function BCT:FirstNeedPD()
if BCT.Need[1] == 0 then
return true;
else
return false;
end
end

function BCT:AddFirst()
local npc = me.npcObj;
local item = nil;
local num  =npc.Bag:GetItemCount("Item_Nvxiuluohong")
local bag = npc.Bag.m_lisItems
if num ~= 0 then
for k,v in pairs(bag) do
	if v.def.Name == "Item_Nvxiuluohong" then
		item = v
	end
end
npc.Bag:CostItem(item.def.Name,1)
BCT:NeedChange(1,1)
me:AddMsg(npc.Name.."贡献了处女落红。")
else
me:AddMsg(npc.Name.."身上没有处女落红，无法贡献。")
end
end

function BCT:SecondNeedPD()
if BCT.Need[2] < 5 then
return true;
else
return false;
end
end

function BCT:AddSecond()
local npc = me.npcObj;
local item = nil;
local nums  =npc.Bag:GetItemCount("Item_yinjin6")
local bag = npc.Bag.m_lisItems
if nums ~= 0 then
for k,v in pairs(bag) do
	if v.def.Name == "Item_yinjin6" then
		item = v
	end
end
npc.Bag:CostItem(item.def.Name,1)
BCT:NeedChange(2,1)
local num = BCT:GetNeed(2)
me:AddMsg(npc.Name.."贡献了一份真仙阴精，目前有"..num.."份阴精。")
else
me:AddMsg(npc.Name.."身上没有真仙阴精，无法贡献。")
end
end

function BCT:ThirdNeedPD()
if BCT.Need[3] < 50000000 then
return true;
else
return false;
end
end

function BCT:AddThird()
local npc = me.npcObj;
local item = story:GetBindThing();
if npc.LingV > 0 and BCT:GetNeed(3) < 50000000 then
local num = npc.LingV - npc.LingV%1
BCT:NeedChange(3,num)
local num2 =  BCT:GetNeed(3)
npc:AddLing(-num)
me:AddMsg(npc.Name.."注入了"..num.."点灵气，目前有"..num2.."点灵气注入。")
else
me:AddMsg(npc.Name.."灵气不足驱动，无法完成灵气注入。")
end
end

function BCT:ComeTruePD()
if BCT.Need[1] == 1 and BCT.Need[2] == 5 and BCT.Need[3] > 50000000 then
return true;
else
return false;
end
end

function BCT.ComeTrue()
local npc1 = me.npcObj;
local item = story:GetBindThing();
BCT:NeedChange(1,-BCT:GetNeed(1))
BCT:NeedChange(2,-BCT:GetNeed(2))
BCT:NeedChange(3,-BCT:GetNeed(3))

me:AddMsg("女偶觉醒成功")

local npc = CS.XiaWorld.NpcRandomMechine.RandomNpc("Human",CS.XiaWorld.g_emNpcSex.Female);
CS.XiaWorld.NpcMgr.Instance:AddNpc(npc,item.Key,Map,CS.XiaWorld.Fight.g_emFightCamp.Player);
npc.PropertyMgr.Practice:Up2Disciple("Gong_HappyWoman")
npc.PropertyMgr:ChangeName("帝王","女偶")
npc.PropertyMgr:AddMaxAge(1000)
npc.PropertyMgr.Age = 1;

local count = npc.PropertyMgr.FeatureList.Count-1
local flag = 0;
for k,v in ipairs(npc.PropertyMgr.BackStory) do
npc.PropertyMgr.BackStory[k] = nil
end
npc.PropertyMgr.BackStory[0] = nil
for i=0,count,1 do
if npc.PropertyMgr.FeatureList[0].Name == "Sys_Disciple" then
flag = 1
else
npc.PropertyMgr:RemoveFeature(npc.PropertyMgr.FeatureList[0].Name);
end
end
npc.PropertyMgr.BackStory[0] = {["Name"]="帝王女偶",["Desc"]="[IT]是帝王女偶本体"}
if flag == 1 then
npc.PropertyMgr:AddFeature("Sys_Disciple");
end
npc.PropertyMgr:AddFeature("BeautifulFace2");
npc.PropertyMgr:AddFeature("Affinity");
npc.PropertyMgr:AddFeature("YinDang");
npc.PropertyMgr:AddFeature("YinBody");
npc.PropertyMgr:AddFeature("LunHui_4");
npc.PropertyMgr:AddFeature("Anatman");

npc.PropertyMgr.BaseData:AddAddion(CS.XiaWorld.g_emNpcBasePropertyType.Charisma,20);
npc.PropertyMgr.BaseData:AddAddion(CS.XiaWorld.g_emNpcBasePropertyType.Luck,20);
npc.PropertyMgr.BaseData:AddAddion(CS.XiaWorld.g_emNpcBasePropertyType.Intelligence,20);
npc.PropertyMgr.BaseData:AddAddion(CS.XiaWorld.g_emNpcBasePropertyType.Perception,20);
npc.PropertyMgr.BaseData:AddAddion(CS.XiaWorld.g_emNpcBasePropertyType.Physique,20);

npc.PropertyMgr.SkillData:AddSkillLove(CS.XiaWorld.g_emNpcSkillType.Qi,2)
npc.PropertyMgr.SkillData:AddSkillLove(CS.XiaWorld.g_emNpcSkillType.Fight,2)
npc.PropertyMgr.SkillData:AddSkillLove(CS.XiaWorld.g_emNpcSkillType.SocialContact,2)
npc.PropertyMgr.SkillData:AddSkillLove(CS.XiaWorld.g_emNpcSkillType.Medicine,2)
npc.PropertyMgr.SkillData:AddSkillLove(CS.XiaWorld.g_emNpcSkillType.Cooking,2)
npc.PropertyMgr.SkillData:AddSkillLove(CS.XiaWorld.g_emNpcSkillType.Building,2)
npc.PropertyMgr.SkillData:AddSkillLove(CS.XiaWorld.g_emNpcSkillType.Farming,2)
npc.PropertyMgr.SkillData:AddSkillLove(CS.XiaWorld.g_emNpcSkillType.Mining,2)
npc.PropertyMgr.SkillData:AddSkillLove(CS.XiaWorld.g_emNpcSkillType.Art,2)
npc.PropertyMgr.SkillData:AddSkillLove(CS.XiaWorld.g_emNpcSkillType.Manual,2)
npc.PropertyMgr.SkillData:AddSkillLove(CS.XiaWorld.g_emNpcSkillType.DouFa,2)
npc.PropertyMgr.SkillData:AddSkillLove(CS.XiaWorld.g_emNpcSkillType.DanQi,2)
npc.PropertyMgr.SkillData:AddSkillLove(CS.XiaWorld.g_emNpcSkillType.Fabao,2)
npc.PropertyMgr.SkillData:AddSkillLove(CS.XiaWorld.g_emNpcSkillType.FightSkill,2)
npc.PropertyMgr.SkillData:AddSkillLove(CS.XiaWorld.g_emNpcSkillType.Barrier,2)
npc.PropertyMgr.SkillData:AddSkillLove(CS.XiaWorld.g_emNpcSkillType.Zhen,2)

npc.PropertyMgr.SkillData:AddSkillLevelAddion(CS.XiaWorld.g_emNpcSkillType.Qi,20)
npc.PropertyMgr.SkillData:AddSkillLevelAddion(CS.XiaWorld.g_emNpcSkillType.Fight,20)
npc.PropertyMgr.SkillData:AddSkillLevelAddion(CS.XiaWorld.g_emNpcSkillType.SocialContact,20)
npc.PropertyMgr.SkillData:AddSkillLevelAddion(CS.XiaWorld.g_emNpcSkillType.Medicine,20)
npc.PropertyMgr.SkillData:AddSkillLevelAddion(CS.XiaWorld.g_emNpcSkillType.Cooking,20)
npc.PropertyMgr.SkillData:AddSkillLevelAddion(CS.XiaWorld.g_emNpcSkillType.Building,20)
npc.PropertyMgr.SkillData:AddSkillLevelAddion(CS.XiaWorld.g_emNpcSkillType.Farming,20)
npc.PropertyMgr.SkillData:AddSkillLevelAddion(CS.XiaWorld.g_emNpcSkillType.Mining,20)
npc.PropertyMgr.SkillData:AddSkillLevelAddion(CS.XiaWorld.g_emNpcSkillType.Art,20)
npc.PropertyMgr.SkillData:AddSkillLevelAddion(CS.XiaWorld.g_emNpcSkillType.Manual,20)
npc.PropertyMgr.SkillData:AddSkillLevelAddion(CS.XiaWorld.g_emNpcSkillType.DouFa,20)
npc.PropertyMgr.SkillData:AddSkillLevelAddion(CS.XiaWorld.g_emNpcSkillType.DanQi,20)
npc.PropertyMgr.SkillData:AddSkillLevelAddion(CS.XiaWorld.g_emNpcSkillType.Fabao,20)
npc.PropertyMgr.SkillData:AddSkillLevelAddion(CS.XiaWorld.g_emNpcSkillType.FightSkill,20)
npc.PropertyMgr.SkillData:AddSkillLevelAddion(CS.XiaWorld.g_emNpcSkillType.Barrier,20)
npc.PropertyMgr.SkillData:AddSkillLevelAddion(CS.XiaWorld.g_emNpcSkillType.Zhen,20)

local count1 = Map.Things:GetActiveNpcs(g_emNpcRaceType.Wisdom).Count
for i=0,count1 - 1,1 do
	local npc2 = Map.Things:GetActiveNpcs(g_emNpcRaceType.Wisdom)[i]
	if npc2.Camp == CS.XiaWorld.Fight.g_emFightCamp.Player and 
	npc2.LuaHelper:GetGLevel() > 0 and 
	npc2.Sex == CS.XiaWorld.g_emNpcSex.Male and 
	npc2.IsDeath == false and
	npc2.PropertyMgr.Practice.EsotericaV ~=nil  then
		local playerInfo = npc2.PropertyMgr.Practice.EsotericaV
		local iter = playerInfo:GetEnumerator()
		while iter:MoveNext() do
			local name = iter.Current.Key
			if CS.XiaWorld.EsotericaMgr.Instance:GetEsoterica(name).IsSys == false then
				npc.PropertyMgr.Practice:LearnEsotericaEx(name,1,false,true)
			end
		end
	end
end

npc:AddBtnData("交互","res/Sprs/ui/icon_hand","world:EnterUILuaMode('BaByChat',bind)","与帝王女偶进行互动。")
CS.MapCamera.Instance:LookPos(npc.Pos)
ThingMgr:RemoveThing(item)
end

function BCT:GetNeed(key)
return BCT.Need[key];
end

function BCT:NeedChange(key,num)
BCT.Need[key] = BCT.Need[key] + num
end

function BCT:OnSave()
	local tbSave = BCT.Need;
	return tbSave;
end

function BCT:OnLoad(tbLoad)
	BCT.Need = tbLoad or {a = 0, b = 0};
end

function BCT:AddNpcs(npc1,npc2)
	BCT.Npcs[1] = npc1;
	BCT.Npcs[2] = npc2;
end

function BCT:GetNpcs()
	return BCT.Npcs
end

function BCT:SEXPD()
local npc1 = BCT:GetNpcs()[1]
local npc2 = BCT:GetNpcs()[2]
if npc2.PropertyMgr:CheckFeature("YunFu") then
	return false;
else
	return true;
end
end

function BCT:SEX()
local npc1 = BCT:GetNpcs()[1]
local npc2 = BCT:GetNpcs()[2]
GameMain:GetMod("HappyGet_HuaiYun"):huaiyun2(npc1,npc2)
me:AddMsg(npc1.Name.."让"..npc2.Name.."怀孕了");
end



function Chat:OnModeEnter(p)
	self:SetKeyCondition("Npc")
	self:OpenThingCheck()
	self:ShowLine(p[1])
	self:SetHeadMsg("请选择一名角色进行交互")
	self.Npc = bind
end

function Chat:CheckThing(key)
	local npc = self:GetMap().Things:GetThingAtGrid(key, g_emThingType.Npc)
	if npc.Camp == CS.XiaWorld.Fight.g_emFightCamp.Player and npc.IsDeath == false then
	return true;
	else
	return false;
	end
end

function Chat:Apply(key)
	local npc1 = self:GetMap().Things:GetThingAtGrid(key, g_emThingType.Npc)
	local npc2 = self.Npc;
	BCT:AddNpcs(npc1,npc2)
	MapStoryMgr:TriggerStorySelection("Story_BaByChat",npc1)
end


