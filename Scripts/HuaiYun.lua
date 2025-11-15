local Sheng = GameMain:GetMod("HappyGet_HuaiYun");
local Gold = GameMain:GetMod("HappyGold");
local shengercao = {[1]={0,0,"未生产","邪欲生"}}

function Sheng:huaiyun1(npc1,npc2)
	local lenth = #shengercao;
	if npc2.Sex ==CS.XiaWorld.g_emNpcSex.Female then
		shengercao[lenth][1] = npc1.ID;
		shengercao[lenth][2] = npc2.ID;
	else
		shengercao[lenth][1] = npc2.ID;
		shengercao[lenth][2] = npc1.ID;
	end
		print(shengercao[lenth][1],shengercao[lenth][2])
	local father = ThingMgr:FindThingByID(shengercao[lenth][1])
	local mother = ThingMgr:FindThingByID(shengercao[lenth][2])
		mother.PropertyMgr:AddFeature("YunFu");
		shengercao[lenth][3] = 0;
		shengercao[lenth][4] = "邪欲生"
		shengercao[lenth+1] = {0,0,"未生产","邪欲生"}
end

function Sheng:huaiyun2(npc1,npc2)
	local lenth = #shengercao;
	if npc2.Sex ==CS.XiaWorld.g_emNpcSex.Female then
		shengercao[lenth][1] = npc1.ID;
		shengercao[lenth][2] = npc2.ID;
	else
		shengercao[lenth][1] = npc2.ID;
		shengercao[lenth][2] = npc1.ID;
	end
		print(shengercao[lenth][1],shengercao[lenth][2])
	local father = ThingMgr:FindThingByID(shengercao[lenth][1])
	local mother = ThingMgr:FindThingByID(shengercao[lenth][2])
		mother.PropertyMgr:AddFeature("YunFu");
		shengercao[lenth][3] = 0;
		shengercao[lenth][4] = "帝偶生"
		shengercao[lenth+1] = {0,0,"未生产","邪欲生"}
end


function Sheng:OnStep(dt)
	for k,v in ipairs(shengercao) do
		if type(shengercao[k][3]) == "number" then
			shengercao[k][3] = shengercao[k][3] + dt;
			if shengercao[k][3] >=  12000 then
				shengercao[k][3] = "生产完";
				if shengercao[k][4] == "邪欲生" then
				Sheng:shenger(k);
				else
				Sheng:diwang(k);
				end
				table.remove(shengercao,k)
			end
		end
	end
end

function Sheng:shenger(n)
world:SetRandomSeed();
local mother = ThingMgr:FindThingByID(shengercao[n][2])
local father = ThingMgr:FindThingByID(shengercao[n][1])
mother.PropertyMgr:RemoveFeature("YunFu");
local mother1 = mother.LuaHelper:GetCharisma();
local mother2 = mother.LuaHelper:GetLuck();
local mother3 = mother.LuaHelper:GetIntelligence();
local mother4 = mother.LuaHelper:GetPerception();
local mother5 = mother.LuaHelper:GetPhysique();
local fathername = father.Name;
local mothername = mother.Name;
local sex = nil;

local Race =nil;
if father.Race.Name == "Human" and mother.Race.Name == "Human" then
Race = father.Race.Name
elseif father.Race.Name ~= "Human" and mother.Race.Name ~= "Human" then
local random = npc.LuaHelper:RandomInt(0,1)
if random == 0 then
Race = father.Race.Name
else
Race = mother.Race.Name
end
elseif mother.Race.Name ~= "Human" then
Race = mother.Race.Name
else
Race = father.Race.Name
end

local npc = CS.XiaWorld.NpcRandomMechine.RandomNpc(Race);	
local npc1 = npc.PropertyMgr.Charisma;
local npc2 = npc.PropertyMgr.Luck;
local npc3 = npc.PropertyMgr.Intelligence;
local npc4 = npc.PropertyMgr.Perception;
local npc5 = npc.PropertyMgr.Physique;
CS.XiaWorld.NpcMgr.Instance:AddNpc(npc,mother.Key,Map,CS.XiaWorld.Fight.g_emFightCamp.Player);
npc.PropertyMgr.RelationData:AddRelationShip(mother, "Parent");
npc.PropertyMgr.RelationData:AddRelationShip(father, "Parent");
npc.PropertyMgr.Age = 1;
npc:ChangeRank(CS.XiaWorld.g_emNpcRank.Worker);
CS.MapCamera.Instance:LookPos(npc.Pos)
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

npc.PropertyMgr.BackStory[0] = {["Name"]="魔种",["Desc"]="[IT]是魔种"}
if flag == 1 then
npc.PropertyMgr:AddFeature("Sys_Disciple");
end
npc.PropertyMgr:AddFeature("BeautifulFace2");
npc.PropertyMgr:AddFeature("Affinity");
npc.PropertyMgr:AddFeature("DemonBlood");

npc.PropertyMgr.BaseData:AddAddion(CS.XiaWorld.g_emNpcBasePropertyType.Charisma,mother1-npc1);
npc.PropertyMgr.BaseData:AddAddion(CS.XiaWorld.g_emNpcBasePropertyType.Luck,mother2-npc2);
npc.PropertyMgr.BaseData:AddAddion(CS.XiaWorld.g_emNpcBasePropertyType.Intelligence,mother3-npc3);
npc.PropertyMgr.BaseData:AddAddion(CS.XiaWorld.g_emNpcBasePropertyType.Perception,mother4-npc4);
npc.PropertyMgr.BaseData:AddAddion(CS.XiaWorld.g_emNpcBasePropertyType.Physique,mother5-npc5);

local PreName = father.PropertyMgr.PrefixName
if npc.Sex == CS.XiaWorld.g_emNpcSex.Female then
	npc.PropertyMgr:ChangeName(PreName,NpcMgr:GetRandomSuffixName("Human", CS.XiaWorld.g_emNpcSex.Female))
	npc.PropertyMgr:AddFeature("YinDang");
	sex = "女孩"
else
	npc.PropertyMgr:ChangeName(PreName,NpcMgr:GetRandomSuffixName("Human", CS.XiaWorld.g_emNpcSex.Male))
	npc.PropertyMgr:AddFeature("Tiancilonggen");
	sex = "男孩"
end
if  npc.view ~= nil then
       npc.view.needUpdateMod = true;
end
local YING = npc:GetName()
local FGong = nil
local MGong = nil
local Cancel = "不继承"
local FDisplayName = nil
local MDisplayName = nil
if father.IsDisciple == true then
FDisplayName = CS.XiaWorld.PracticeMgr.Instance:GetGongDef(father.LuaHelper:GetGongName()).DisplayName
FGong = "父系传承——（"..FDisplayName.."）"
else
FGong = "父系无传承功法"
end
if mother.IsDisciple == true then
MDisplayName = CS.XiaWorld.PracticeMgr.Instance:GetGongDef(mother.LuaHelper:GetGongName()).DisplayName
MGong = "母系继承——（"..MDisplayName.."）"
else
MGong = "母系无传承功法"
end
world:ShowStoryBox("恭喜！出生的是个"..sex.."！是否要继承父母的功法？","婴儿出生",{FGong,MGong,Cancel},
function(key)
	if key == 0 then
	if father.IsDisciple == true then
	npc.PropertyMgr.Practice:Up2Disciple(father.LuaHelper:GetGongName())
	return ""..YING.."继承了父亲"..fathername.."的功法——"..FDisplayName.."！"
	else
	return "父亲不是内门弟子，所以不能传承功法！"
	end
	end
	if key == 1 then
	if mother.IsDisciple == true then
	npc.PropertyMgr.Practice:Up2Disciple(mother.LuaHelper:GetGongName())
	return ""..YING.."继承了母亲"..mothername.."的功法——"..MDisplayName.."！"
	else
	return "母亲不是内门弟子，所以不能传承功法！"
	end
	end
	if key == 2 then
	return ""..YING.."并没有继承父母的衣钵（你们好狠心！）。"
	end
end
);
end

function diwang(n)
world:SetRandomSeed();
local mother = ThingMgr:FindThingByID(shengercao[n][2])
local father = ThingMgr:FindThingByID(shengercao[n][1])
mother.PropertyMgr:RemoveFeature("YunFu");
local npc = CS.XiaWorld.NpcRandomMechine.RandomNpc("Human",CS.XiaWorld.g_emNpcSex.Female);
CS.XiaWorld.NpcMgr.Instance:AddNpc(npc,mother.Key,Map,CS.XiaWorld.Fight.g_emFightCamp.Player);
npc:ChangeRank(CS.XiaWorld.g_emNpcRank.Worker);
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
npc.PropertyMgr.BackStory[0] = {["Name"]="帝王女偶",["Desc"]="[IT]是帝王女偶生下的孩子"}
if flag == 1 then
npc.PropertyMgr:AddFeature("Sys_Disciple");
end
npc.PropertyMgr:AddFeature("BeautifulFace2");
npc.PropertyMgr:AddFeature("Affinity");
npc.PropertyMgr:AddFeature("YinDang");
npc.PropertyMgr:AddFeature("YinBody");
npc.PropertyMgr:AddFeature("LunHui_4");
npc.PropertyMgr:AddFeature("Anatman");
npc.PropertyMgr.Age = 1;
npc.PropertyMgr.BaseData:AddAddion(CS.XiaWorld.g_emNpcBasePropertyType.Charisma,10);
npc.PropertyMgr.BaseData:AddAddion(CS.XiaWorld.g_emNpcBasePropertyType.Luck,10);
npc.PropertyMgr.BaseData:AddAddion(CS.XiaWorld.g_emNpcBasePropertyType.Intelligence,10);
npc.PropertyMgr.BaseData:AddAddion(CS.XiaWorld.g_emNpcBasePropertyType.Perception,10);
npc.PropertyMgr.BaseData:AddAddion(CS.XiaWorld.g_emNpcBasePropertyType.Physique,10);
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
CS.MapCamera.Instance:LookPos(npc.Pos)
end




function Sheng:OnSave()
	local tbSave = shengercao;
	return tbSave;
end

function Sheng:OnLoad(tbLoad)
	shengercao = tbLoad or {a = 0, b = 0};
end

function Gold:Recovery()
local npc = me.npcObj
local item = it;
	if npc.IsDisciple== true then
		npc:AddLing(item.LingV)
		npc.Needs:AddNeedValue(CS.XiaWorld.g_emNeedType.Practice,item.Beauty)
		npc.PropertyMgr:AddMaxAge(item.Rate * 3)
	end
end



