local Hudong = GameMain:GetMod("Lua_hudong");
local npc1 = nil;
local npc2 = nil;
local flag = nil;
---------------------------------------------------------------------------------------------存档
function Hudong:OnBeforeInit()
local bnt = CS.XiaWorld.MenuData()
bnt.Name = "互动"
bnt.Desc = "与这位角色互动"
bnt.Story = "Story_Hujiao"
bnt.Cost = "0.1"
bnt.Icon = "res/Sprs/ui/icon_hand"
bnt.Appoint = "3"
if CS.XiaWorld.ThingMgr.Instance:GetDef(CS.XiaWorld.g_emThingType.Npc,"NpcBase").StoryBnts == nil then
CS.XiaWorld.ThingMgr.Instance:GetDef(CS.XiaWorld.g_emThingType.Npc,"NpcBase").StoryBnts = {}
CS.XiaWorld.ThingMgr.Instance:GetDef(CS.XiaWorld.g_emThingType.Npc,"NpcBase").StoryBnts:Add(bnt)
else
local count = CS.XiaWorld.ThingMgr.Instance:GetDef(CS.XiaWorld.g_emThingType.Npc,"NpcBase").StoryBnts.Count
flag = 0;
for i = 0 , count - 1 , 1 do
if CS.XiaWorld.ThingMgr.Instance:GetDef(CS.XiaWorld.g_emThingType.Npc,"NpcBase").StoryBnts[i].Name == "互动" then
flag = 1;
end
end
if flag == 0 then
CS.XiaWorld.ThingMgr.Instance:GetDef(CS.XiaWorld.g_emThingType.Npc,"NpcBase").StoryBnts:Add(bnt)
end
end
end

-------------------互动
function Hudong:LiaoTian()
world:SetRandomSeed();
npc1 = ThingMgr:FindThingByID(story:GetBindThing().ID)
npc2 = ThingMgr:FindThingByID(me.npcObj.ID)
local JHseed = npc1.JiangHuSeed
	if shiqidejiance ~= 1 then
		if JHseed > 0 then
		CS.Wnd_JianghuTalk.Instance:Talk(npc1,npc2)
		else
		me:TriggerStory("Story_Hujiaowuzhongzi");
		end
	else
	me:AddMsg(""..npc1.Name..":对不起，你可能是非正常途径获得的本mod，我不能互动熬。");
	end
end

function Hudong:Guancha()
npc1 = ThingMgr:FindThingByID(me.npcObj.ID)
npc2 = ThingMgr:FindThingByID(story:GetBindThing().ID)
local Dfxg = CS.XiaWorld.JianghuMgr.Instance:GetJHNpcDataBySeed(npc2.JiangHuSeed).Feature
	if Dfxg == CS.XiaWorld.g_emJHNpc_Feature.Tenacity then
	me:AddMsg("通过观察，"..npc1.Name.."确定"..npc2.Name.."是个坚韧的人");
	elseif Dfxg == CS.XiaWorld.g_emJHNpc_Feature.Greedy then
	me:AddMsg("通过观察，"..npc1.Name.."确定"..npc2.Name.."是个贪婪的人");
	elseif Dfxg == CS.XiaWorld.g_emJHNpc_Feature.Naive then
	me:AddMsg("通过观察，"..npc1.Name.."确定"..npc2.Name.."是个天真的人");
	elseif Dfxg == CS.XiaWorld.g_emJHNpc_Feature.Weak then
	me:AddMsg("通过观察，"..npc1.Name.."确定"..npc2.Name.."是个软弱的人");
	elseif Dfxg == CS.XiaWorld.g_emJHNpc_Feature.Apathy then
	me:AddMsg("通过观察，"..npc1.Name.."确定"..npc2.Name.."是个冷漠的人");
	else
	me:AddMsg("通过观察，"..npc1.Name.."确定"..npc2.Name.."无性格，默认判定为冷漠");
	end
end

function Hudong:Zichan()
npc2 = ThingMgr:FindThingByID(me.npcObj.ID)
local name2 = npc2.Name;
local LD1 = npc2.LuaHelper:GetModifierStack("Luding");
local LD2 = npc2.LuaHelper:GetModifierStack("Luding2");
local LD3 = npc2.LuaHelper:GetModifierStack("Luding3");
local LD4 = npc2.LuaHelper:GetModifierStack("Luding4");
local LD5 = npc2.LuaHelper:GetModifierStack("Luding5");
local LD6 = npc2.LuaHelper:GetModifierStack("Luding6");
local Qian = npc2.LuaHelper:GetModifierStack("Qian");
me:AddMsg(""..name2.."拥有：\n男俘虏"..LD1.."人，女俘虏"..LD2.."人，帅哥俘虏"..LD3.."人，美女俘虏"..LD4.."人，男修士俘虏"..LD5.."人，女修士俘虏"..LD6.."人。\n银子"..Qian.."两");
me:TriggerStory("Secrets_shiqi_4");
end

function Hudong:Xiangyong()
npc2 = ThingMgr:FindThingByID(me.npcObj.ID)
local name2 = npc2.Name;
local LD1 = npc2.LuaHelper:GetModifierStack("Luding");
local LD2 = npc2.LuaHelper:GetModifierStack("Luding2");
local LD3 = npc2.LuaHelper:GetModifierStack("Luding3");
local LD4 = npc2.LuaHelper:GetModifierStack("Luding4");
local LD5 = npc2.LuaHelper:GetModifierStack("Luding5");
local LD6 = npc2.LuaHelper:GetModifierStack("Luding6");
local Qian = npc2.LuaHelper:GetModifierStack("Qian");
local LDM = LD1 +  LD3 + LD5
local LDF = LD2 +  LD4 + LD6
	if me:GetSex() > 1 then
		if LDM > 0 then
		me:AddMsg(""..name2.."拥有男俘虏"..LD1.."人，帅哥俘虏"..LD3.."人，男修士俘虏"..LD5.."人。");
		me:TriggerStory("Secrets_xiangyong_1");
		else
		me:AddMsg("没有属于自己的男性俘虏");
		me:TriggerStory("Secrets_shiqi_4");
		end
	else
		if me.npcObj.PropertyMgr.BodyData:PartIsBroken("Genitals") then
		me:AddMsg(""..name2.."是个太监，没法享用俘虏");
		me:TriggerStory("Secrets_shiqi_4");
		else
			if LDF > 0 then
			me:AddMsg(""..name2.."拥有女俘虏"..LD2.."人，美女俘虏"..LD4.."人，女修士俘虏"..LD6.."人。");
			me:TriggerStory("Secrets_xiangyong_2");
			else
			me:AddMsg("没有属于自己的女性俘虏");
			me:TriggerStory("Secrets_shiqi_4");
			end
		end
	end
end

function Hudong:JDcaibu()
npc2 = ThingMgr:FindThingByID(me.npcObj.ID)
local name2 = npc2.Name;
local Gongfa = npc2.PropertyMgr.Practice.Gong.Name
	if Gongfa == ("Gong_1701_Tu") then
		if me:GetSex() > 1 then
		me:TriggerStory("Secrets_JDcaibu1");
		else
		me:TriggerStory("Secrets_JDcaibu2");
		end
	else
	me:AddMsg(""..name2.."不会采补功法");
	me:TriggerStory("Secrets_shiqi_4");
	end
end


-------------------无种子角色互动


function Hudong:QiouhunPD()--求婚判定
npc1 = ThingMgr:FindThingByID(me.npcObj.ID)
npc2 = ThingMgr:FindThingByID(story:GetBindThing().ID)
if npc2.LuaHelper:GetModifierStack("Prison_Modifier2")~= 0 and npc1.Sex ~= npc2.Sex then
return true;
elseif npc2.Camp ~= npc1.Camp or npc1.Sex == npc2.Sex or npc1.Sex ~= CS.XiaWorld.g_emNpcSex.Male or npc1.PropertyMgr.RelationData:IsRelationShipWith("Spouse",npc2) or npc2.IsLingShou then
return false;
else
return true;
end
return false;
end

function Hudong:Qiouhun()
npc1 = ThingMgr:FindThingByID(me.npcObj.ID)
npc2 = ThingMgr:FindThingByID(story:GetBindThing().ID)
local Dfxg = CS.XiaWorld.JianghuMgr.Instance:GetJHNpcDataBySeed(npc2.JiangHuSeed).Feature
	if npc2.PropertyMgr:CheckFeature("BeautifulFace3") then
	local tiancangnian = GameMain:GetMod("Lua_shijian"):formatNumber(World.YearCount + 246)
	local dangqianri = GameMain:GetMod("Lua_shijian"):formatNumber(World.YearDayCount + 1 )
		if (npc1.PropertyMgr:CheckFeature("BeautifulFace2") or npc1.LuaHelper:GetModifierStack("Qian") > 300000 or npc1.LuaHelper:GetGLevel() > 9 ) and npc1.PropertyMgr.RelationData.m_mapRelationShips:ContainsKey("Spouse") == false then
			if npc1.LuaHelper:GetGLevel() > 9 then
			me:AddMsg(""..npc2.Name.."看了一眼"..npc1.Name.."：你要与我结为道侣？我看你的修为还不错，那就答应你吧，但是成为我的道侣之后，你便不能在与其他女子不清不楚了，得是我的专属打手，你可愿否？！\n垂涎与"..npc2.Name.."那倾世面容的"..npc1.Name.."连声答应，并且保证忠诚与"..npc2.Name.."，无论"..npc2.Name.."还有多少其他的道侣。\n"..npc1.Name.."和"..npc2.Name.."结合了。");
			npc1.LuaHelper:AddTitle(""..npc2.Name.."的打手","在天苍"..tiancangnian.."年第"..dangqianri.."日，"..npc1.Name.."成功的凭借着自己高超的修为，成为了"..npc2.Name.."的丈夫",1)
			elseif npc1.LuaHelper:GetModifierStack("Qian") > 300000 then
			me:AddMsg(""..npc2.Name.."看了一眼"..npc1.Name.."：你要与我结为道侣？我看你的家底颇丰，那就答应你吧，但是成为我的道侣之后，你便不能在与其他女子不清不楚了，得是我的专属钱包，你可愿否？！\n垂涎与"..npc2.Name.."那倾世面容的"..npc1.Name.."连声答应，并且保证忠诚与"..npc2.Name.."，无论"..npc2.Name.."还有多少其他的道侣。\n"..npc1.Name.."和"..npc2.Name.."结合了。");
			npc1.LuaHelper:AddTitle(""..npc2.Name.."的钱包","在天苍"..tiancangnian.."年第"..dangqianri.."日，"..npc1.Name.."成功的凭借着自己丰厚的身家，成为了"..npc2.Name.."的丈夫",1)
			else
			me:AddMsg(""..npc2.Name.."看了一眼"..npc1.Name.."：你要与我结为道侣？我看你的家底颇丰，那就答应你吧，但是成为我的道侣之后，你便不能在与其他女子不清不楚了，得是我的专属面首，你可愿否？！\n垂涎与"..npc2.Name.."那倾世面容的"..npc1.Name.."连声答应，并且保证忠诚与"..npc2.Name.."，无论"..npc2.Name.."还有多少其他的道侣。\n"..npc1.Name.."和"..npc2.Name.."结合了。");
			npc1.LuaHelper:AddTitle(""..npc2.Name.."的面首","在天苍"..tiancangnian.."年第"..dangqianri.."日，"..npc1.Name.."成功的凭借着自己出色的容貌，成为了"..npc2.Name.."的丈夫",1)
			end
		npc1.PropertyMgr.RelationData:AddRelationShip(npc2,"Spouse");
		elseif npc1.PropertyMgr.RelationData.m_mapRelationShips:ContainsKey("Spouse") and (npc1.PropertyMgr:CheckFeature("BeautifulFace2") or npc1.LuaHelper:GetModifierStack("Qian") > 300000 or npc1.LuaHelper:GetGLevel() > 9 ) then
		me:AddMsg(""..npc2.Name.."看了一眼"..npc1.Name.."：虽然你还是不错，可以有资格当我的裙下之臣，可是我是不会接受一个已婚男人的。");
		elseif npc1.PropertyMgr.RelationData.m_mapRelationShips:ContainsKey("Spouse") then
		me:AddMsg(""..npc2.Name.."鄙夷的看着"..npc1.Name.."：你这种既没有钱，又没有貌，还没实力的人，而且还结了婚的男人，为什么会舔着你的逼脸幻想可以成为我的男人，麻烦您麻溜的赶紧滚！");
		else
		me:AddMsg(""..npc2.Name.."鄙夷的看着"..npc1.Name.."：你这种既没有钱，又没有貌，还没实力的人，为什么会舔着你的逼脸想要成为我的男人，麻烦您麻溜的赶紧滚！");
		end
	elseif npc2.LuaHelper:GetModifierStack("Prison_Modifier2")~= 0 then
	me:AddMsg("作为"..SchoolMgr.Name.."的囚犯"..npc2.Name.."自然是无法拒绝"..SchoolMgr.Name.."弟子的，于是"..npc2.Name.."成为了"..npc1.Name.."的妻子并加入了"..SchoolMgr.Name.."。");
	npc2.PropertyMgr:RemoveModifier("Prison_Modifier2");
	npc1.PropertyMgr.RelationData:AddRelationShip(npc2,"Spouse");
	npc2.LuaHelper:SetCamp(g_emFightCamp.Player, false)
		if npc2.LuaHelper:GetGLevel() > 0 then
		npc2:ChangeRank(g_emNpcRank.Disciple);
		end
	elseif npc2.PropertyMgr.RelationData.m_mapRelationShips:ContainsKey("Spouse") == false then
		if npc2.RaceDefName == "Human_JGZT" then--判定对象为通灵精怪
		local Jg = ThingMgr:FindThingByID(npc2.ThingToHuman.thingid)
		JgName = Jg.def.ThingName
		end
		if npc2.PropertyMgr:CheckFeature("Tianyuannvquan") or npc2.LuaHelper:GetGongName() == "Body_Gong_nvquan" then
			if npc1.RaceDefName == "Human" then
			me:AddMsg(""..npc2.Name.."一脸鄙夷的看着"..npc1.Name.."愤愤然道："..npc1.Name.."你也配向我求婚？你不会脑子有问题吧，你为什么觉得我会嫁给你？\n"..npc1.Name.."我告诉你，我这辈子都不可能嫁给你这种人族男性当婚驴的，滚！");
			else
			me:AddMsg(""..npc2.Name.."作为女拳师，光是闻到"..npc1.Name.."身上散发的那浓郁的妖族荷尔蒙变就情难自禁了，对于"..npc1.Name.."的求婚，"..npc1.Name.."自是毫不犹豫的答应了。\n"..npc1.Name.."与"..npc2.Name.."结合成了夫妻。");
			npc1.PropertyMgr.RelationData:AddRelationShip(npc2,"Spouse");
			end
		elseif JgName == "宝贝儿" then
			if npc1.PropertyMgr:CheckFeature("Tiancilonggen") and npc1.GongKind == g_emGongKind.Body and npc2.PropertyMgr:CheckFeature("Pogua") then--吊精（女）只和天赐龙根男体修结婚，女吊是不是处子
			me:AddMsg(""..npc2.Name.."作为先天女宝贝儿精，光是闻到"..npc1.Name.."身上散发的那浓郁的纯阳之气便浑身发软了，对于"..npc1.Name.."的求婚，"..npc1.Name.."自是毫不犹豫的答应了。\n"..npc1.Name.."与"..npc2.Name.."结合成了夫妻。");
			npc1.PropertyMgr.RelationData:AddRelationShip(npc2,"Spouse");
			elseif npc1.PropertyMgr:CheckFeature("Tiancilonggen") and npc1.GongKind == g_emGongKind.Body and npc2.PropertyMgr:CheckFeature("Pogua") == false then--吊精（女）只和天赐龙根男体修结婚，女吊是处子获得秘体
				if npc1.PropertyMgr.Practice.BodyPracticeData.SuperParts:ContainsKey("SuperPart_Base_shiqi_1") then
				me:AddMsg(""..npc2.Name.."作为先天女宝贝儿精，光是闻到"..npc1.Name.."身上散发的那浓郁的纯阳之气便浑身发软了，对于"..npc1.Name.."的求婚，"..npc1.Name.."自是毫不犹豫的答应了。\n"..npc1.Name.."与"..npc2.Name.."结合成了夫妻。");
				else
				me:AddMsg(""..npc2.Name.."作为先天女宝贝儿精，光是闻到"..npc1.Name.."身上散发的那浓郁的纯阳之气便浑身发软了，对于"..npc1.Name.."的求婚，"..npc1.Name.."自是毫不犹豫的答应了。\n"..npc1.Name.."与"..npc2.Name.."结合成了夫妻，在洞房花烛之夜，"..npc1.Name.."破"..npc2.Name.."瓜之时，从对方的血脉中，习得了上古传承秘体《定海神针》。");
				npc1.PropertyMgr.Practice.BodyPracticeData:UnLockSuperPart("SuperPart_Base_shiqi_1");
				end
			npc1.PropertyMgr.RelationData:AddRelationShip(npc2,"Spouse");
			npc2.PropertyMgr:AddFeature("Pogua");
			else
			me:AddMsg(""..npc2.Name.."鄙夷的看着"..npc1.Name.."：还没我原型大的废物男人，麻烦滚！");
			end
		elseif Dfxg == CS.XiaWorld.g_emJHNpc_Feature.Tenacity then
			if npc1.LuaHelper:GetGLevel() > 9 then--坚毅人格，只愿意和元婴以上强者结婚
			me:AddMsg("看到来自元婴强者的求婚"..npc2.Name.."感动的下半身都软了，毕竟"..npc2.Name.."从小的梦想就是和修真界中顶天立地的大人物结婚，于是"..npc2.Name.."毫不犹豫的答应了。\n"..npc1.Name.."与"..npc2.Name.."结合成了夫妻！");
			npc1.PropertyMgr.RelationData:AddRelationShip(npc2,"Spouse");
			npc1.PropertyMgr.RelationData:RemoveRelationShip(npc2,"Lover");
			else
				if npc2.Sex == CS.XiaWorld.g_emNpcSex.Male then
				me:AddMsg(""..npc2.Name.."：对不起，我们不合适，我是那种宁可每天给元婴肥婆舔脚，也不愿意和练气美女相爱的男人。");
				else
				me:AddMsg(""..npc2.Name.."：对不起，我们不合适，我是那种宁可坐在元婴老头身边哭，也不愿意坐在练气帅哥身边笑的女人。");
				end
			end
		else
			if Dfxg == CS.XiaWorld.g_emJHNpc_Feature.Greedy then
				if npc1.LuaHelper:GetModifierStack("Qian") > 300000 then--贪婪人格，需要30W彩礼就可以结婚
				npc1:AddModifier("Qian");
				npc2:AddModifier("Qian");
				local WDQ = npc1.PropertyMgr:FindModifier("Qian")
				local DDQ = npc2.PropertyMgr:FindModifier("Qian")
				WDQ:UpdateStack(-300001);
				DDQ:UpdateStack(299999);
				me:AddMsg("整整三十万两白银砸在了"..npc2.Name.."面前，只听"..npc1.Name.."一句：“这是聘礼！”，"..npc2.Name.."感觉自己激动的快要喷射了，凡间的金钱虽说对修真者没有太大的价值，可是从小喜欢亮闪闪的"..npc2.Name.."可管不了这些许多。\n"..npc1.Name.."与"..npc2.Name.."结合成了夫妻！");
				npc1.PropertyMgr.RelationData:AddRelationShip(npc2,"Spouse");
				npc1.PropertyMgr.RelationData:RemoveRelationShip(npc2,"Lover");
				else
					if npc2.Sex == CS.XiaWorld.g_emNpcSex.Male then
					me:AddMsg(""..npc2.Name.."：对不起，我们不合适，我是那种每天宁愿被富婆刷刷乐刷吊，也不想和美少女一起奋斗的男人。");
					else
					me:AddMsg(""..npc2.Name.."：对不起，我们不合适，在我眼里，没有钱的男人，连狗都不如。");
					end
				end
			else
				if Dfxg == CS.XiaWorld.g_emJHNpc_Feature.Naive then--天真人格，是情侣就可以结婚
					if npc1.PropertyMgr.RelationData:IsRelationShipWith("Lover",npc2) then
					me:AddMsg(""..npc1.Name.."与"..npc2.Name.."顺其自然的结合成了夫妻！");
					npc1.PropertyMgr.RelationData:AddRelationShip(npc2,"Spouse");
					npc1.PropertyMgr.RelationData:RemoveRelationShip(npc2,"Lover");
					else
					me:AddMsg(""..npc2.Name.."：我们还没确定情侣关系，直接求婚是不是发展的太快了一些。");
					end
				else
					if Dfxg == CS.XiaWorld.g_emJHNpc_Feature.Weak then--软弱人格，主角比对方强就可以结婚
						if npc1.LuaHelper:GetGLevel() > npc2.LuaHelper:GetGLevel() then
						me:AddMsg(""..npc1.Name.."将"..npc2.Name.."拦住，板着脸认真的说：“和我结婚，听到了没有？”\n"..npc2.Name.."被吓住就不小心答应并与"..npc1.Name.."结婚了。");
						npc1.PropertyMgr.RelationData:AddRelationShip(npc2,"Spouse");
						npc1.PropertyMgr.RelationData:RemoveRelationShip(npc2,"Lover");
						else
						me:AddMsg(""..npc2.Name.."：对不起，我不喜欢你。");
						end
					else
						if npc1.PropertyMgr.RelationData:IsRelationShipWith("Luding2",npc2) and npc1.Sex == CS.XiaWorld.g_emNpcSex.Male then--主角男，对方是你的狗
						me:AddMsg(""..npc1.Name.."一脚踹在了"..npc2.Name.."脸上，并吩咐道：“母狗，老子想娶你了。”\n"..npc2.Name.."“汪，是的，我的主人，嫁给你是我的荣幸。”\n"..npc1.Name.."与"..npc2.Name.."结合成了夫妻！");
						npc1.PropertyMgr.RelationData:AddRelationShip(npc2,"Spouse");
						npc1.PropertyMgr.RelationData:RemoveRelationShip(npc2,"Lover");
						npc1.PropertyMgr.RelationData:RemoveRelationShip(npc2,"Luding2");
						else
							if npc1.PropertyMgr.RelationData:IsRelationShipWith("Luding2",npc2) and npc1.Sex ~= CS.XiaWorld.g_emNpcSex.Male then--主角女，对方是你的狗
							me:AddMsg(""..npc1.Name.."坐在"..npc2.Name.."脸上不时还用脚踩着"..npc1.Name.."的肉棒，并吩咐道：“狗狗，女王想嫁给你了。”\n"..npc2.Name.."“汪，是的，我的主人，娶你是我的毕生的梦想。”\n"..npc1.Name.."与"..npc2.Name.."结合成了夫妻！");
							npc1.PropertyMgr.RelationData:AddRelationShip(npc2,"Spouse");
							npc1.PropertyMgr.RelationData:RemoveRelationShip(npc2,"Lover");
							npc1.PropertyMgr.RelationData:RemoveRelationShip(npc2,"Luding2");
							else
							me:AddMsg(""..npc2.Name.."：滚！");
							end
						end
					end
				end
			end
		end
	else
	me:AddMsg(""..npc2.Name.."看到"..npc1.Name.."向自己求婚的行为，气的浑身发抖，大热天的全身发冷手脚冰凉，这个修仙界还能不能好了，我们女孩子难道在你们男人眼里就是人尽可夫的婊子么，想到此时眼泪不禁夺眶而出嘶吼着什么：“到底要怎么样你们才能满意，这个世界充斥着对女性的压迫，女性到底何时才能真正的站起了！”反正不管别怎么想，至少"..npc2.Name.."绝对不会接受，成为多个男性的妻子，古老的一妻多夫制度，是对女性的侮辱和不尊重，女孩子明明就应该是香香的，纯洁的，晶莹剔透如水晶一般的！\n\n身为微博派女拳大师，精通古武的作者十七：“自20200205起，落后邪恶而又不女拳的一妻多夫制度，就要从本mod消失了！至于为什么男性可以一夫多妻……因为牛累不累死本女拳拳法家完全不在乎，反正地不能耕坏！爱护地球环境从你我做起。”");
	end
end


function Hudong:ShuangxiuPD()--双修判定
npc1 = ThingMgr:FindThingByID(me.npcObj.ID)
npc2 = ThingMgr:FindThingByID(story:GetBindThing().ID)
if npc2.LuaHelper:GetModifierStack("Prison_Modifier2")~= 0 or npc1.Sex == npc2.Sex or npc1.LuaHelper:GetGLevel() < 1 or npc2.LuaHelper:GetGLevel() < 1 or npc1.PropertyMgr.BodyData:PartIsBroken("Genitals") or npc2.PropertyMgr.BodyData:PartIsBroken("Genitals") or npc2.IsSmartRace == false then
return false;
else
return true;
end
return false;
end

function Hudong:Shuangxiu()--双修判定
npc1 = ThingMgr:FindThingByID(me.npcObj.ID)
npc2 = ThingMgr:FindThingByID(story:GetBindThing().ID)
	local random = npc1.LuaHelper:RandomInt(1,100);
	local tmeili = npc2.LuaHelper:GetCharisma()
	local pmeili = npc1.LuaHelper:GetCharisma()
	local tsCD = npc2.LuaHelper:GetModifierStack("ShuangxiuCD");
	local psCD = npc1.LuaHelper:GetModifierStack("ShuangxiuCD");
	local zCD = tsCD + psCD
	local Dfxg = CS.XiaWorld.JianghuMgr.Instance:GetJHNpcDataBySeed(npc2.JiangHuSeed).Feature
	if zCD == 0 then --双方双修CD判定
		if npc2.IsBrokenNeck == true and npc2.PropertyMgr.Practice.CurNeck.Kind == CS.XiaWorld.g_emGongBottleNeckType.Gold and npc1.Sex == CS.XiaWorld.g_emNpcSex.Male and npc1.LuaHelper:GetDaoHang() > npc2.LuaHelper:GetDaoHang() and npc2.LuaHelper:GetModifierStack("Zhenchaosuo")== 0 and npc2.LuaHelper:GetModifierStack("Zhenchaozhou") == 0 and npc1.LuaHelper:GetModifierStack("Zhenchaosuo")== 0 and npc1.LuaHelper:GetModifierStack("Zhenchaozhou") == 0 then--对方正在结丹主动者是比对方道行高的男性
		local shouyuan = npc1.LuaHelper:GetProperty("MaxAge") - 60
			if shouyuan > 0 then
			me:AddMsg(""..npc2.Name.."正在结丹的关键时刻，"..npc1.Name.."提议帮对方补补魔，"..npc2.Name.."闻之大喜任"..npc1.Name.."在自己身上驰骋……\n事毕，"..npc2.Name.."吸收了"..npc1.Name.."注入自己体内的精元，化为了灵气……\n此次双修"..npc1.Name.."损耗了一甲子的寿元……");
			npc2.LuaHelper:AddPracticeResource("Ling",npc2.LuaHelper:GetProperty("NpcLingMaxValue"))
			npc1:AddModifier("ShuangxiuCD");
			npc2:AddModifier("ShuangxiuCD");
			npc1.PropertyMgr:AddMaxAge(- 60);
			else
			me:AddMsg(""..npc1.Name.."已经不足一甲子了，想来就算用命去换，也对"..npc2.Name.."结丹帮助不大了……");
			end
		return false;
		end
		if npc2.IsBrokenNeck == true and npc2.PropertyMgr.Practice.CurNeck.Kind == CS.XiaWorld.g_emGongBottleNeckType.Thunder and npc1.Sex ~= npc2.Sex and npc1.PropertyMgr.Practice:CheckIsLearnedEsoteric("Gong1701_Esoterica_999") == true then
		me:AddMsg(""..npc2.Name.."真值渡劫的关键时刻，"..npc1.Name.."无论如何也想要为"..npc2.Name.."做些什么！\n片刻迟疑之后，"..npc1.Name.."决定为了"..npc2.Name.."即使放弃自己的一切也在所不惜！\n"..npc1.Name.."来到"..npc2.Name.."面前，表示要为其渡劫尽到自己最后的一份力，"..npc2.Name.."含泪答应了对方……\n在交合双修之际，"..npc1.Name.."默运献身秘法，将自己的一切均炼化成最精纯的灵力，灌注到了"..npc2.Name.."的身体之中……");
		npc2.LuaHelper:AddPracticeResource("Ling",npc2.LuaHelper:GetProperty("NpcLingMaxValue"))
		npc2:AddModifier("Naocanfendexianshen");
		ThingMgr:RemoveThing(npc1,false,true)
		return false;
		end
		if npc2.PropertyMgr:CheckFeature("Chastity") and npc1.PropertyMgr.RelationData:IsRelationShipWith("Spouse",npc2) == false then
		me:AddMsg(""..npc1.Name.."对"..npc2.Name.."提出了双修的请求，然而"..npc2.Name.."是一个贞洁的女子，她拒绝了"..npc1.Name.."。");
		return false;
		end
		if npc1.LuaHelper:GetModifierStack("Zhenchaosuo")~= 0 or npc1.LuaHelper:GetModifierStack("Zhenchaozhou") ~= 0 then--1带着贞操锁/咒
			if npc1.Sex == CS.XiaWorld.g_emNpcSex.Male and npc1.PropertyMgr.RelationData:IsRelationShipWith("Luding2",npc2) == true then--1是男，且是2的奴隶
			me:AddMsg(""..npc2.Name.."想要侍奉自己的主人，许是"..npc1.Name.."心情很好，她解开了贞操锁/咒，让"..npc1.Name.."用胯下肉棒侍奉了自己");
			Hudong:xuexi()
			else
				if npc1.Sex ~= CS.XiaWorld.g_emNpcSex.Male and npc1.PropertyMgr.RelationData:IsRelationShipWith("Luding2",npc2) == true then--1是女，且是2的奴隶
				me:AddMsg(""..npc2.Name.."想要侍奉自己的主人，许是"..npc1.Name.."心情很好，他解开了贞操锁/咒，让"..npc1.Name.."使用小穴侍奉了自己");
				Hudong:xuexi()
				else
					me:AddMsg(""..npc1.Name.."的下体被阳锁/贞操咒封住了，并不能对对方做什么，于是转身离开了。");
				end
			end
		return false;
		end
		if npc2.LuaHelper:GetModifierStack("Zhenchaosuo")~= 0 or npc2.LuaHelper:GetModifierStack("Zhenchaozhou") ~= 0 then--2带着贞操锁/咒
			if npc1.Sex == CS.XiaWorld.g_emNpcSex.Male and npc1.PropertyMgr.RelationData:IsRelationShipWith("Luding2",npc2) == true then--1是男，且是2的主人
			me:AddMsg(""..npc1.Name.."一时性起，想要干自己的女奴"..npc2.Name.."一炮，他解开了贞操锁/咒，在"..npc2.Name.."身上耕耘许久直到心满意足后转身离去了。");
			Hudong:xuexi()
			else
				if npc1.Sex ~= CS.XiaWorld.g_emNpcSex.Male and npc1.PropertyMgr.RelationData:IsRelationShipWith("Luding2",npc2) == true then--1是女，且是2的主人
				me:AddMsg(""..npc1.Name.."一时性起，感觉下身湿润了，想要自己的公狗"..npc2.Name.."来干上自己一炮，他解开了贞操锁/咒，"..npc2.Name.."用胯下肉棒侍奉了"..npc1.Name.."。");
				Hudong:xuexi()
				else
					if npc1.PropertyMgr.RelationData:IsRelationShipWith("Spouse",npc2) == true then--是夫妻，离婚
					me:AddMsg(""..npc1.Name.."开口向"..npc2.Name.."要求双修，"..npc2.Name.."百般推脱不成，反倒激怒了"..npc1.Name.."一把揽住"..npc2.Name.."便伸手往下探去。直到触及一硬物……\n只闻"..npc1.Name.."留下了一句“贱人”……\n"..npc1.Name.."与"..npc2.Name.."解除了婚姻关系。");
					npc1.PropertyMgr.RelationData:RemoveRelationShip(npc2,"Spouse");
					else--带锁拒绝
					me:AddMsg(""..npc2.Name.."因为下身被锁，故拒绝了双修。");
					end
				end
			end
		return false;
		end
		if npc1.Sex == CS.XiaWorld.g_emNpcSex.Male then--性别判定
			if npc1.PropertyMgr.RelationData:IsRelationShipWith("Spouse",npc2) == true then--是否夫妻
			npc2.PropertyMgr:AddFeature("Pogua");
			me:AddMsg(""..npc1.Name.."向"..npc2.Name.."提出双修的邀请，"..npc2.Name.."作为妻子，自然不会拒绝"..npc1.Name.."的要求，于是双方进行了一次和谐的双修。");
			Hudong:xuexi()
			else
				if npc1.PropertyMgr.RelationData:IsRelationShipWith("Luding2",npc2) == true then--是否主人
				me:AddMsg("对于主人的需求，身为母狗的"..npc2.Name.."自然是万万不敢拒绝的，于是"..npc2.Name.."跪伏下身子开始为她的主人服务……\n这是一次双方都很满意的双修。");
				Hudong:xuexi()
				else
					if npc2.PropertyMgr:CheckFeature("Pogua") ~= true then--对方是处女
						if Dfxg == CS.XiaWorld.g_emJHNpc_Feature.Tenacity then--坚毅性格，只愿意被比自己强且是金丹以上的大佬破处
							if npc1.LuaHelper:GetGLevel() > npc2.LuaHelper:GetGLevel() and npc1.LuaHelper:GetGLevel() > 6 then
							npc2.PropertyMgr:AddFeature("Pogua");
							npc1:AddModifier("Diyidixue");
							npc1.PropertyMgr.RelationData:AddRelationShip(npc2,"Chunv");
							me:AddMsg(""..npc1.Name.."向"..npc2.Name.."提出双修的邀请，"..npc2.Name.."本想拒绝，可对方那强悍的修为着实让"..npc2.Name.."心动不已，只听"..npc2.Name.."呢喃一句：“为了成就大道，这处女之身，弃了便弃了罢”。\n"..npc1.Name.."闻言大喜，褪下裤子露出胯下巨物，便与对方缠绵了起来……\n一番云雨过后，看着身旁滴滴落红，"..npc1.Name.."兴致又起再次拖着"..npc2.Name.."酣战了数番。");
							Hudong:xuexi()
							else
							me:AddMsg(""..npc2.Name.."表示自己一心修行，无心想着那些旁门左道的双修之法，所以并不愿意和"..npc1.Name.."双修。");
							end
						else
							if Dfxg == CS.XiaWorld.g_emJHNpc_Feature.Greedy then--贪婪性格，会被身价百万的男性草服，成为对方母狗，也原意被拥有10W以上的男修破处
								if npc1.LuaHelper:GetModifierStack("Qian") > 1000000 then
								npc2.PropertyMgr:AddFeature("Pogua");
								npc1:AddModifier("Diyidixue");
								npc1.PropertyMgr.RelationData:AddRelationShip(npc2,"Chunv");
								npc1.PropertyMgr.RelationData:AddRelationShip(npc2,"Luding2");
								me:AddMsg(""..npc1.Name.."向"..npc2.Name.."提出双修的邀请，没想到这种身家百万的巨富会愿意给自己开苞，不禁下身湿透意乱情迷……\n许是那财富的光环迷人眼眸，"..npc2.Name.."不但没有感受到破瓜之痛，反而一边挨炮一边360度无死角的跪舔着"..npc1.Name.."\n事毕，"..npc2.Name.."自甘化身母狗用舌头清理着"..npc1.Name.."肉棒上的污渍，并试图继续求欢，奈何"..npc1.Name.."却已没了兴致，一脚踹在了"..npc2.Name.."脸上并呵斥道：“母狗，快舔干净，我还有别的事呢。”……");
								Hudong:xuexi()
								else
									if npc1.LuaHelper:GetModifierStack("Qian") > 100000 then
									npc2.PropertyMgr:AddFeature("Pogua");
									npc1:AddModifier("Diyidixue");
									npc1.PropertyMgr.RelationData:AddRelationShip(npc2,"Chunv");
									me:AddMsg(""..npc1.Name.."向"..npc2.Name.."提出双修的邀请，没想到这种富甲一方的男人会愿意给自己开苞，不禁下身湿透意乱情迷……\n许是那财富的光环迷人眼眸，"..npc2.Name.."不但没有感受到破瓜之痛，反而越挨炮越来劲，口中淫言浪语不断……\n事毕，"..npc2.Name.."的蜜穴里还插着"..npc1.Name.."的肉棒，两人均非常满足的拥在了一起……");
									Hudong:xuexi()
									else
									me:AddMsg(""..npc2.Name.."嫖了一眼"..npc1.Name.."后，清冷的吐出了一个“滚”字。");
									end
								end
							else
								if Dfxg == CS.XiaWorld.g_emJHNpc_Feature.Naive then--天真人格，天真脑瘫无破处条件
								npc2.PropertyMgr:AddFeature("Pogua");
								npc1:AddModifier("Diyidixue");
								npc1.PropertyMgr.RelationData:AddRelationShip(npc2,"Lover");
								npc1.PropertyMgr.RelationData:AddRelationShip(npc2,"Chunv");
								me:AddMsg(""..npc1.Name.."向"..npc2.Name.."提出双修的邀请，却听"..npc2.Name.."拒绝道：“可人家还是处子之身”……\n"..npc1.Name.."闻言大喜，于花言巧语之后成功将自己的肉棒插入了对方的蜜穴，一鼓作气突破了那道关卡，"..npc2.Name.."惊叫了一声“好疼”却未换来"..npc1.Name.."任何的怜悯，"..npc1.Name.."自顾自的一顿猪突于蜜穴猛烈的抽插了起来……\n事毕"..npc2.Name.."的蜜穴里还插着"..npc1.Name.."的肉棒，两人均非常满足的拥在了一起……");
								Hudong:xuexi()
								else
									if Dfxg == CS.XiaWorld.g_emJHNpc_Feature.Weak then--软弱人格，只被比自己强的人强推
										if npc1.LuaHelper:GetGLevel() > npc2.LuaHelper:GetGLevel() then
										npc2.PropertyMgr:AddFeature("Pogua");
										npc1:AddModifier("Diyidixue");
										npc1.PropertyMgr.RelationData:AddRelationShip(npc2,"Chunv");
										me:AddMsg(""..npc1.Name.."向"..npc2.Name.."提出双修的邀请，却听"..npc2.Name.."拒绝道：“对，对，对不起，我，我还是……&还是处子之身”。\n"..npc1.Name.."闻言大喜凭着强悍的实力将对方压倒在地，肉棒插入了对方的蜜穴，一鼓作气突破了那道关卡，"..npc2.Name.."惊叫了一声“好疼”却未换来"..npc1.Name.."任何的怜悯，"..npc1.Name.."自顾自的一顿猪突于蜜穴猛烈的抽插了起来……\n事毕"..npc2.Name.."的蜜穴里还插着"..npc1.Name.."的肉棒，一个人悄悄的抹着眼泪时，只闻"..npc1.Name.."道“你的处是我破的，从今以后你就是我的人了，听到没！”\n"..npc2.Name.."含泪点头称诺……");
										Hudong:xuexi()
										else
										me:AddMsg(""..npc2.Name.."：“对，对，对不起，我，我还是……&还是处子之身”。\n"..npc2.Name.."拒绝了双修。");
										end
									else--冷漠人格，不给破处，请通过事件破处后在使用双修功能
									me:AddMsg(""..npc2.Name.."冷冷的看了"..npc1.Name.."一眼后，清冷的吐出了一个“滚字”。");
									end
								end
							end
						end
					else
						if npc1.LuaHelper:GetGLevel() > npc2.LuaHelper:GetGLevel() then--男性主角，且比对象强
							if random > 40 then--60%概率发生以下事件
							me:AddMsg(""..npc1.Name.."向"..npc2.Name.."提出双修的邀请，"..npc2.Name.."显然不太擅长拒绝强者的要求，毕竟在修真界与强者双修本身就是一件挺划得来的事情，对觊觎仙途的修真者们来说，所谓贞洁大不抵只是个笑话罢了\n"..npc2.Name.."褪下衣衫后便与"..npc1.Name.."搂作一团翻云覆雨了起来。\n这是一次不错的双修，双方都获得了满足。");
							Hudong:xuexi()
							else
								if random > 20 and tmeili > 8 then--对方魅力大于8有20%概率发生以下事件
								npc1.PropertyMgr:AddMaxAge(- 60);
								npc2.PropertyMgr:AddMaxAge(30);
								me:AddMsg(""..npc1.Name.."向"..npc2.Name.."提出双修的邀请，"..npc2.Name.."却显得不太情愿，可"..npc2.Name.."这等绝世容颜显然让"..npc1.Name.."欲火焚身难以自持了\n只见"..npc1.Name.."三下五除二的褪下对方衣衫，信手掏出胯下之物便如急色鬼附身一样在"..npc2.Name.."身上奋战了起来，"..npc1.Name.."的肉棒于于"..npc2.Name.."的蜜穴中来回冲杀，战至酣时"..npc1.Name.."甚至忘记了双修的本意，也管不得什么交而不泄止泄固元了。\n随着一声怒吼声，"..npc1.Name.."将自己滚热的阳精全部灌注于"..npc2.Name.."的蜜穴里。\n虽然这次双修最后还是成功了，但是这次精关失守"..npc1.Name.."损失了近一甲子的寿元。");
								Hudong:xuexi()
								else
									if random > 10 then--如果没有发生上面的事件，那有30%触发此事件
									me:AddMsg(""..npc1.Name.."向"..npc2.Name.."提出双修的邀请，"..npc2.Name.."却显得不太情愿，然而实力的差距容不得"..npc2.Name.."摇头说不，只见"..npc1.Name.."施术摄住"..npc2.Name.."后便掏出肉棒不管不顾的捅进"..npc2.Name.."小穴之中，一阵阵猛烈的活塞运动让尚未做好准备的"..npc2.Name.."被干的两眼翻白几度昏死过去后又被操醒过来……\n酣畅之后，心满意足的"..npc1.Name.."放过了"..npc2.Name.."。");
									Hudong:xuexi()
									else--10%概率发生以下事件
									npc1.PropertyMgr.RelationData:AddRelationShip(npc2,"Luding2");
									me:AddMsg(""..npc1.Name.."刚向"..npc2.Name.."提出双修的邀请，"..npc2.Name.."就好像显得特别高兴并露出迫不及待的样子，还没等"..npc1.Name.."准备做些什么，"..npc2.Name.."便已经伸手掏出了"..npc1.Name.."的肉棒，一口猛的吞了进去，"..npc1.Name.."只觉下体被那温暖的小口含住……\n事毕，"..npc2.Name.."用着香舌帮着"..npc1.Name.."清理肉棒上的污渍，还满脸淫贱相的说着什么“主人在干我一次吧”之类的话语。");
									Hudong:xuexi()
									end
								end
							end
						else
							if npc1.LuaHelper:GetGLevel() < npc2.LuaHelper:GetGLevel() then--男主，没女目标实力强
								if pmeili > 9 then--男主魅力大于9
								npc1.PropertyMgr.RelationData:AddRelationShip(npc2,"Luding2");
								me:AddMsg(""..npc1.Name.."向"..npc2.Name.."提出双修，虽然这是一个看实力的修真世界，但是偶尔英俊的脸庞还是能起一些作用的，比如眼前的女修"..npc2.Name.."便是轻点足尖仿佛等待着些什么，"..npc1.Name.."仿佛领悟到了，伏下身子捧起对方的玉足，伸出舌头在"..npc2.Name.."玉足的每一寸肌肤上均舔舐了数个来回……\n精心的侍奉让"..npc2.Name.."感到愉悦，心情大好的"..npc2.Name.."甚至主动跨坐于"..npc1.Name.."腿上摇摆不止。\n对"..npc1.Name.."来说这是一次成功的双修，而对"..npc2.Name.."来说，则是获得了一条公狗，但至少这是各取所需不是么。");
								Hudong:xuexi()
								else
								me:AddMsg(""..npc1.Name.."刚向"..npc2.Name.."提出双修的邀请，之听"..npc2.Name.."口中冷清冷的吐出了一个“滚”字，便灰溜溜的离开了。");
								end
							else--男主，和女目标境界相同
							me:AddMsg(""..npc1.Name.."的境界与"..npc2.Name.."相差无几，开口提出双修对方也没有拒绝。\n这是一次成功的双修。");
							Hudong:xuexi()
							end
						end
					end
				end
			end
		else--主角为女性
			if npc1.PropertyMgr.RelationData:IsRelationShipWith("Spouse",npc2) == true then--女主，夫妻
			me:AddMsg(""..npc1.Name.."向"..npc2.Name.."提出双修的邀请，"..npc2.Name.."作为丈夫，自然不会拒绝"..npc1.Name.."的要求，于是双方进行了一次和谐的双修。");
			Hudong:xuexi()
			else
				if npc1.PropertyMgr.RelationData:IsRelationShipWith("Luding2",npc2) == true then--女主，主仆
				me:AddMsg(""..npc2.Name.."一听到自己的主人邀请自己双修，激动地跪倒在地匍匐在"..npc1.Name.."脚边做摇尾乞怜状，"..npc1.Name.."大喜，恩赐似的跨坐于"..npc2.Name.."脸上道：“乖狗狗，来舔”……\n随即双方进行了一次和谐的双修。");
				Hudong:xuexi()
				elseif npc1.PropertyMgr:CheckFeature("BeautifulFace3") then
				npc1.PropertyMgr.RelationData:AddRelationShip(npc2,"Luding2");
					if npc1.PropertyMgr:CheckFeature("Pogua") ~= true then
					npc1.PropertyMgr:AddFeature("Pogua");
					npc1.PropertyMgr.RelationData:AddRelationShip(npc2,"Chunv");
					end
				me:AddMsg("没有任何男人可能拒绝的了"..npc1.Name.."，"..npc1.Name.."对"..npc2.Name.."提出了双修的要求，"..npc2.Name.."大喜之余化身为最卑微的公狗，四肢着地的舔舐起了"..npc1.Name.."玉足。\n在"..npc1.Name.."的面前，"..npc2.Name.."没有丝毫尊严的倾服于"..npc1.Name.."，经过"..npc2.Name.."努力且卑微的服侍之后，"..npc1.Name.."同意了"..npc2.Name.."成为自己的狗。\n这是一场双方都很满意的双修。");
				Hudong:xuexi()
				else
					if npc1.PropertyMgr:CheckFeature("Pogua") ~= true then--我是处女
					npc1.PropertyMgr:AddFeature("Pogua");
					npc2:AddModifier("Diyidixue");
					npc1.PropertyMgr.RelationData:AddRelationShip(npc2,"Chunv");
					me:AddMsg(""..npc1.Name.."向"..npc2.Name.."提出双修，"..npc2.Name.."整个人都因为狂喜而呆滞住了几秒，毕竟修真界的处子女修，就是有着这样那样的特权，"..npc2.Name.."完全没有想到居然有给女修士破处这样的好处会轮到自己，狂喜之余"..npc2.Name.."褪下裤子露出胯下巨物，伸手拖住那肉棒便向"..npc1.Name.."蜜穴攻去，只听"..npc1.Name.."惊叫连连，引得"..npc2.Name.."欲火更盛，只见"..npc2.Name.."掰过"..npc1.Name.."脸庞一口吻在"..npc1.Name.."嘴上，舌头在"..npc1.Name.."口中纠缠着对方的香舌……\n酣战之后，"..npc1.Name.."心满意足的躺在"..npc2.Name.."怀里……");
					Hudong:xuexi()
					else
						if Dfxg == CS.XiaWorld.g_emJHNpc_Feature.Tenacity then--女主，对方坚毅人格
							if npc1.LuaHelper:GetGLevel() > 6 then--女主实力大于金丹
							me:AddMsg(""..npc2.Name.."大打量了一眼"..npc1.Name.."，觉得"..npc1.Name.."修为还是不错的，于是"..npc2.Name.."接受了"..npc1.Name.."的双修邀请。\n随即双方进行了一次和谐的双修。");
							Hudong:xuexi()
							else
							me:AddMsg(""..npc2.Name.."侧目瞟了"..npc1.Name.."一眼道：“很抱歉，你的修为太低了，和你双修对我的修炼毫提升”\n对方拒绝与"..npc1.Name.."双修。");
							end
						else
							if Dfxg == CS.XiaWorld.g_emJHNpc_Feature.Greedy or Dfxg == CS.XiaWorld.g_emJHNpc_Feature.Naive or Dfxg == CS.XiaWorld.g_emJHNpc_Feature.Weak then--女主，对方贪婪天真或者软弱人格
								if npc1.LuaHelper:GetGLevel() > npc2.LuaHelper:GetGLevel() then--女主，比男目标实力强
								npc1.PropertyMgr.RelationData:AddRelationShip(npc2,"Luding2");
								me:AddMsg(""..npc1.Name.."向"..npc2.Name.."提出双修，"..npc2.Name.."甚至完全没想到会有此等好事发生在自己身上，居然有实力高强的女修士愿意给自己送干还外带修炼的，只要脑子没坏自是不会错过这等好事。\n这是一次成功的双修，双修结束后"..npc2.Name.."还久久不愿离去，腆着脸要给"..npc1.Name.."当狗。");
								Hudong:xuexi()
								else
									if npc1.LuaHelper:GetGLevel() < npc2.LuaHelper:GetGLevel() then--女主，没男目标实力强
									npc1.PropertyMgr:AddMaxAge(10);
									me:AddMsg(""..npc1.Name.."的境界与"..npc2.Name.."相差甚远，但谁让"..npc1.Name.."女修呢，女性在大部分时候都要更占便宜一点，"..npc1.Name.."刚提出双修，对方便同意了，随后便是数个时辰的疯狂，"..npc1.Name.."甚至感觉自己被操的快断片了，数次的昏死过去在被活活操醒，让"..npc1.Name.."了解到高位修士的持久力是多么“恐怖如斯”，不过这一切都是值得的，随着对方虎躯颤了那么几颤，"..npc1.Name.."只觉一股滚烫且极具生命活力的精元灌注进自己的身体……");
									Hudong:xuexi()
									else--女主，和男目标一样强
									me:AddMsg(""..npc1.Name.."的境界与"..npc2.Name.."相差无几，开口提出双修对方也没有拒绝。\n这是一次成功的双修。");
									Hudong:xuexi()
									end
								end
							else
								if npc1.LuaHelper:GetGLevel() > npc2.LuaHelper:GetGLevel() then--女主，比男目标实力强
									if random > 5 then
									me:AddMsg(""..npc1.Name.."向"..npc2.Name.."提出双修，"..npc2.Name.."只冷冷的吐出了一个：“滚！”字。\n然而修真界是讲实力的地方女神仙比你实力强，你就算在冷在傲娇，也是无用，只见"..npc1.Name.."轻而易举的制住了"..npc2.Name.."，随即便扒下裤子托着"..npc2.Name.."的肉棒进入自己的蜜穴……\n事毕，只听"..npc1.Name.."冷笑一句：“你活不错，下次本座还来找你双修。”");
									Hudong:xuexi()
									else
									npc1.PropertyMgr.RelationData:AddRelationShip(npc2,"Luding2");
									me:AddMsg(""..npc1.Name.."向"..npc2.Name.."提出双修，"..npc2.Name.."只冷冷的吐出了一个：“滚！”字。\n然而修真界是讲实力的地方女神仙比你实力强，你就算在冷在傲娇，也是无用，只见"..npc1.Name.."轻而易举的制住了"..npc2.Name.."，随即便扒下裤子托着"..npc2.Name.."的肉棒进入自己的蜜穴……\n事毕，只见"..npc2.Name.."乖巧的用着舌头帮"..npc1.Name.."清理下身，"..npc1.Name.."抚掌大笑道：“瞧你刚刚冷若冰霜，怎么现在却形同本座裙下公狗来着了？”。\n"..npc2.Name.."被"..npc1.Name.."收服为犬奴");
									Hudong:xuexi()
									end
								else
								me:AddMsg(""..npc2.Name.."：“滚！”");
								end
							end
						end
					end
				end
			end
		end
	else
		if tsCD == 0 then
		me:AddMsg(""..npc1.Name.."刚双修完毕，体内阴阳二气无比和谐，暂时无法双修。");
		else
		me:AddMsg(""..npc2.Name.."刚双修完毕，体内阴阳二气无比和谐，暂时无法双修。");
		end
	end
end



function Hudong:CaibuPD()--采补判定
npc1 = ThingMgr:FindThingByID(me.npcObj.ID)
npc2 = ThingMgr:FindThingByID(story:GetBindThing().ID)
if npc1.LuaHelper:GetGLevel() == 0 or npc2.IsLingShou then
return false;
else
	if npc1.PropertyMgr.Practice:CheckIsLearnedEsoteric("Gong1701_Esoterica_1") == true and npc1.PropertyMgr.RelationData:IsRelationShipWith("Spouse",npc2) == false and (npc2.IsPlayerThing or npc2.LuaHelper:GetModifierStack("Prison_Modifier2") ~= 0) then
	return true;
	end
end
return false;
end

function Hudong:Caibu()--采补
npc1 = ThingMgr:FindThingByID(me.npcObj.ID)
npc2 = ThingMgr:FindThingByID(story:GetBindThing().ID)
local random = npc1.LuaHelper:RandomInt(0,100);
	local CaibuCD = npc2.LuaHelper:GetModifierStack("CaibuCD");
	if npc2.IsDeath then
	me:AddMsg(""..npc2.Name.."已经死了……");
	elseif npc2.LuaHelper:GetModifierStack("Prison_Modifier2")~= 0 then
	me:AddMsg("作为"..SchoolMgr.Name.."的囚犯"..npc2.Name.."自然是无法以任何理由拒绝"..SchoolMgr.Name.."弟子的，于是"..npc2.Name.."作为炉鼎被"..npc1.Name.."采补了一番。");
		if npc1.Sex == CS.XiaWorld.g_emNpcSex.Female and npc1.PropertyMgr:CheckFeature("Pogua")then
		npc1.PropertyMgr:AddFeature("Pogua");
		end
		if npc2.Sex == CS.XiaWorld.g_emNpcSex.Female and npc2.PropertyMgr:CheckFeature("Pogua")then
		npc2.PropertyMgr:AddFeature("Pogua");
		end
	npc2:AddModifier("CaibuCD");
	npc1:AddModifier("Story_Caibuzhidao1");
	npc1.PropertyMgr:AddMaxAge(1);
	npc2.PropertyMgr:AddMaxAge(- 10);
	elseif CaibuCD == 0 then
		if npc2.RaceDefName ~= "Human" then
			if npc2.Name == "卓十七" then
			me:AddMsg(""..npc1.Name.."：别的咱们不多哔哔，兄弟你妈没了！");
			elseif npc1.Sex == CS.XiaWorld.g_emNpcSex.Male and npc1.PropertyMgr.BodyData:PartIsBroken("Genitals") and npc2.Sex == CS.XiaWorld.g_emNpcSex.Male then--主角太监，动物公
			me:AddMsg(""..npc1.Name.."一把抓住了"..npc2.Name.."，面露淫光的"..npc1.Name.."一把握在"..npc2.Name.."生殖器上，上下撸动着……\n见"..npc2.Name.."并没有太大反应，身为太监的"..npc1.Name.."居然伏下身子，对着"..npc2.Name.."生殖器便是一阵吹拉弹唱……\n事毕，"..npc1.Name.."用嘴吸干了"..npc2.Name.."的精元、");
			elseif npc1.Sex == CS.XiaWorld.g_emNpcSex.Male and npc1.PropertyMgr.BodyData:PartIsBroken("Genitals") and npc2.Sex ~= CS.XiaWorld.g_emNpcSex.Male then--主角太监，动物母
			me:AddMsg(""..npc1.Name.."一把抓住了"..npc2.Name.."，面露淫光的"..npc1.Name.."将对方按在地上，伸出舌头舔弄着"..npc2.Name.."肉穴……\n事毕，"..npc1.Name.."用嘴吸干了"..npc2.Name.."的精元。");
			elseif npc1.Sex == CS.XiaWorld.g_emNpcSex.Male and npc2.Sex == CS.XiaWorld.g_emNpcSex.Male then--主角男，动物公
			me:AddMsg(""..npc1.Name.."一把抓住了"..npc2.Name.."，面露淫光的"..npc1.Name.."一把握在"..npc2.Name.."生殖器上，上下撸动着……\n见"..npc2.Name.."并没有太大反应，身为男性的"..npc1.Name.."居然伏下身子，对着"..npc2.Name.."生殖器便是一阵吹拉弹唱……\n事毕，"..npc1.Name.."用嘴吸干了"..npc2.Name.."的精元、");
			elseif npc1.Sex == CS.XiaWorld.g_emNpcSex.Male and npc2.Sex ~= CS.XiaWorld.g_emNpcSex.Male then--主角男，动物母
			me:AddMsg(""..npc1.Name.."一把抓住了"..npc2.Name.."，面露淫光的"..npc1.Name.."将对方按在地上，伸出舌头舔弄着"..npc2.Name.."肉穴，见"..npc2.Name.."放下戒备后，便褪下裤子露出胯下巨龙，狠狠的插入了"..npc2.Name.."的肉穴，全然不顾"..npc2.Name.."的惨叫，抽送百余下后，"..npc1.Name.."突然提速……\n事毕，"..npc1.Name.."吸干了"..npc2.Name.."的精元、");
			elseif npc1.Sex ~= CS.XiaWorld.g_emNpcSex.Male and npc2.Sex == CS.XiaWorld.g_emNpcSex.Male then--主角女，动物公
			me:AddMsg(""..npc1.Name.."露出肉穴，肉穴中散发出极度催情的气味，"..npc2.Name.."狂性大发，跨上"..npc1.Name.."的身体将肉棒插了进去……一阵狂风暴雨般的抽插后，"..npc2.Name.."将精元灌满了"..npc1.Name.."的子宫……");
			elseif npc1.Sex ~= CS.XiaWorld.g_emNpcSex.Male and npc2.Sex ~= CS.XiaWorld.g_emNpcSex.Male then--主角女，动物母
			me:AddMsg(""..npc1.Name.."一把抓住了"..npc2.Name.."，将对方按在地上，伸出舌头舔弄着"..npc2.Name.."肉穴……\n事毕，"..npc1.Name.."用嘴吸干了"..npc2.Name.."的精元。");
			else
			me:AddMsg("如果出现这文本，请上报bug至810116969。");
			end
			npc2:AddModifier("CaibuCD");
			npc1:AddModifier("Story_Caibuzhidao1");
			npc1.PropertyMgr:AddMaxAge(1);
			npc2.PropertyMgr:AddMaxAge(- 10);
		return false;
		end
		if npc1.LuaHelper:GetModifierStack("Zhenchaosuo")~= 0 or npc1.LuaHelper:GetModifierStack("Zhenchaozhou") ~= 0 then--1带着贞操锁/咒
			if npc1.Sex == CS.XiaWorld.g_emNpcSex.Male and npc1.PropertyMgr.RelationData:IsRelationShipWith("Luding2",npc2) == true then--1是男，且是2的奴隶
			me:AddMsg(""..npc1.Name.."被"..npc2.Name.."的贞操锁/咒封着"..npc1.Name.."不能采补自己的主人");
			else
				if npc1.Sex ~= CS.XiaWorld.g_emNpcSex.Male and npc1.PropertyMgr.RelationData:IsRelationShipWith("Luding2",npc2) == true then--1是女，且是2的奴隶
				me:AddMsg(""..npc1.Name.."被"..npc2.Name.."的贞操锁/咒封着"..npc1.Name.."不能采补自己的主人");
				else
					me:AddMsg(""..npc1.Name.."的下体被阳锁/贞操咒封住了，并不能对对方做什么，于是转身离开了。");
				end
			end
		return false;
		end
		if npc2.LuaHelper:GetModifierStack("Zhenchaosuo")~= 0 or npc2.LuaHelper:GetModifierStack("Zhenchaozhou") ~= 0 then--2带着贞操锁/咒
			if npc1.Sex == CS.XiaWorld.g_emNpcSex.Male and npc1.PropertyMgr.RelationData:IsRelationShipWith("Luding2",npc2) == true then--1是男，且是2的主人
			me:AddMsg(""..npc1.Name.."一时性起，想要干自己的女奴"..npc2.Name.."一炮，他解开了贞操锁/咒，把"..npc2.Name.."干到不省人事后，采补了一番后心满意足的离开了。");
			npc2:AddModifier("CaibuCD");
			npc1:AddModifier("Story_Caibuzhidao1");
			npc1.PropertyMgr:AddMaxAge(1);
			npc2.PropertyMgr:AddMaxAge(- 10);
			else
				if npc1.Sex ~= CS.XiaWorld.g_emNpcSex.Male and npc1.PropertyMgr.RelationData:IsRelationShipWith("Luding2",npc2) == true then--1是女，且是2的主人
				me:AddMsg(""..npc1.Name.."一时性起，感觉下身湿润了，想要自己的公狗"..npc2.Name.."来干上自己一炮，他解开了贞操锁/咒，让"..npc2.Name.."在自己身上努力耕耘着，地自然耕不坏，但牛是会累到的。\n事毕，"..npc1.Name.."采补了一番后心满意足的离开了。");
				npc2:AddModifier("CaibuCD");
				npc1:AddModifier("Story_Caibuzhidao1");
				npc1.PropertyMgr:AddMaxAge(1);
				npc2.PropertyMgr:AddMaxAge(- 10);
				else
					me:AddMsg(""..npc1.Name.."想要采补"..npc2.Name.."却见对方指了指下身，"..npc1.Name.."定睛一看，吐了个“靠”字，便转身离去了。");
				end
			end
		return false;
		end
		if npc1.PropertyMgr.BodyData:PartIsBroken("Genitals") or npc2.PropertyMgr.BodyData:PartIsBroken("Genitals") then
			me:AddMsg("双方中有人是阴阳人的话，是不可以采补的嗷");
		else
			if npc1.Sex == npc2.Sex then
				if npc1.Sex == CS.XiaWorld.g_emNpcSex.Male then
					if random >= 90 then
					npc1.PropertyMgr:AddMaxAge(10);
					npc2.PropertyMgr:AddMaxAge(- 100);
					npc2:AddModifier("CaibuCD");
					npc1:AddModifier("Story_Caibuzhidao1");
					npc1.PropertyMgr:FindModifier("Story_Caibuzhidao1"):UpdateStack(9);
					me:AddMsg(""..npc1.Name.."后背贴着"..npc2.Name.."的前胸，菊花深深的坐在"..npc2.Name.."的巨根上 两个人就好像被贴在一起一样，"..npc1.Name.."运转合欢功法，"..npc2.Name.."就射了三十多次，原本结实的"..npc2.Name.."被"..npc1.Name.."吸的仿佛一个年过古稀的老人一般，头发随风脱落，下体顺着马眼不停的流出鲜红的液体。\n事毕，"..npc1.Name.."发现一不小心吸过头了。");
					elseif random >= 80 then
					npc2:AddModifier("CaibuCD");
					npc1:AddModifier("Story_Caibuzhidao1");
					npc1.PropertyMgr:AddMaxAge(1);
					npc2.PropertyMgr:AddMaxAge(- 10);
					me:AddMsg(""..npc1.Name.."将用力搓弄着"..npc2.Name.."的肉棒和囊袋，"..npc2.Name.."吃痛的浪叫，"..npc1.Name.."将脚往"..npc2.Name.."嘴里一戳，"..npc2.Name.."舌头不停的舔着入侵异物开始淫叫，"..npc2.Name.."一时精关不守，一泻千里。\n事毕，"..npc1.Name.."运转心法将精元吸入体内。");
					elseif random >= 60 then
					npc2:AddModifier("CaibuCD");
					npc1:AddModifier("Story_Caibuzhidao1");
					npc1.PropertyMgr:AddMaxAge(1);
					npc2.PropertyMgr:AddMaxAge(- 10);
					me:AddMsg(""..npc1.Name.."拔下"..npc2.Name.."的袜子，一阵痴迷，用自己的鼻尖在"..npc2.Name.."的脚心轻轻蹭弄，两只手从衣下伸进去，"..npc2.Name.."抱着"..npc1.Name.."的头使劲的在"..npc1.Name.."嘴里抽插起来，不一会便从"..npc1.Name.."的嘴里流出了乳白的液体。\n事毕，"..npc1.Name.."将口中的精元吞入腹中开始炼化……");
					elseif random >= 40 then
					npc2:AddModifier("CaibuCD");
					npc1:AddModifier("Story_Caibuzhidao1");
					npc1.PropertyMgr:AddMaxAge(1);
					npc2.PropertyMgr:AddMaxAge(- 10);
					me:AddMsg(""..npc1.Name.."把下巴支在"..npc2.Name.."肩膀上，对着"..npc2.Name.."耳边说我想吃奶，说罢便俯下身含住"..npc2.Name.."的阳具，又是舔又是吮吸，巨大的刺激让"..npc2.Name.."很快高潮来临，小哥哥出奶了，"..npc1.Name.."细细品尝着口中的精元……。\n事毕，"..npc1.Name.."将品尝完毕的精元吞入腹中开始炼化……");
					elseif random >= 5 then
					npc2:AddModifier("CaibuCD");
					npc1:AddModifier("Story_Caibuzhidao1");
					npc1.PropertyMgr:AddMaxAge(1);
					npc2.PropertyMgr:AddMaxAge(- 10);
					me:AddMsg(""..npc1.Name.."掐了一个御水诀，让水流变成细流从"..npc2.Name.."马眼注射进去，"..npc2.Name.."被刺激的痛苦的呻吟，慢慢的小腹隆起，脚趾都被刺激的屈了起来，在巨大的刺激下"..npc2.Name.."，痛苦的射出了带血的阳精。\n事毕，"..npc1.Name.."将"..npc2.Name.."射出带有丝丝精血的阳精吞入腹中炼化……");
					else
					npc1.PropertyMgr:AddMaxAge(10);
					npc2.PropertyMgr:AddMaxAge(- 100);
					npc2:AddModifier("CaibuCD");
					npc1:AddModifier("Story_Caibuzhidao1");
					npc1.PropertyMgr:FindModifier("Story_Caibuzhidao1"):UpdateStack(19);
					npc2.LuaHelper:AddDamage("Destroy","Genitals",1, "被割断……");
					me:AddMsg(""..npc1.Name.."看到"..npc2.Name.."高大威猛，阳气旺盛，顿时心生邪念，念出一段夺魄诀让"..npc2.Name.."陷入色念迷境幻想当中，渐渐的"..npc1.Name.."下身阳具慢慢挺起，马眼流出泪珠，不一会"..npc2.Name.."阳具越来越粗，一抖一抖，"..npc1.Name.."顺势赶紧用嘴接上"..npc2.Name.."泄出的元阳，吞入腹后，只见银光一闪，"..npc1.Name.."割下了"..npc2.Name.."的阳具放入盒中，阴阴的一笑道：这下补充阳元的丹药又有着落了，遍飘然而去。\n事毕，"..npc1.Name.."用"..npc2.Name.."的阳根混合着他的精元催使秘法炼制了一颗秘药吞服入腹……");
					end
				else
					if random >= 66 then
					npc2:AddModifier("CaibuCD");
					npc1:AddModifier("Story_Caibuzhidao1");
					npc1.PropertyMgr:AddMaxAge(1);
					npc2.PropertyMgr:AddMaxAge(- 10);
					me:AddMsg(""..npc1.Name.."掰开"..npc2.Name.."的玉腿就舔了上去，用舌尖翻开花瓣的外层，直入花心，半盏茶之后，一口接一口香甜的蜜露被吸入腹中……");
					elseif random >= 33 then
					npc2:AddModifier("CaibuCD");
					npc1:AddModifier("Story_Caibuzhidao1");
					npc1.PropertyMgr:AddMaxAge(1);
					npc2.PropertyMgr:AddMaxAge(- 10);
					me:AddMsg(""..npc1.Name.."一之手掐着绵软的双峰，一只手探入"..npc2.Name.."蜜穴之中轻轻扣弄，只感觉那蜜穴越吸越紧，"..npc1.Name.."猛地将手指往中心一挑，只见"..npc2.Name.."就这么瘫软在怀中，蜜水喷湿了整个下摆……");
					else
					npc2:AddModifier("CaibuCD");
					npc1:AddModifier("Story_Caibuzhidao1");
					npc1.PropertyMgr:AddMaxAge(1);
					npc2.PropertyMgr:AddMaxAge(- 10);
					me:AddMsg(""..npc1.Name.."用脚撑开对方双腿，两手用力揉搓着"..npc2.Name.."那丰满的双峰，只见"..npc2.Name.."越来越骚，"..npc1.Name.."把脚探入那秘洞之中，那"..npc2.Name.."不停扭动屁股，"..npc1.Name.."按着对方肩膀张开嘴运转心法对着那双峰使劲的吸，一股暖流渐入腹中。");
					end
				end
			else
				if npc1.LuaHelper:GetGLevel() > npc2.LuaHelper:GetGLevel() then
					if random >= 80 then
						me:AddMsg("虽然"..npc1.Name.."施展迷魂术失败了，但双方境界上的差距让对方完全无法察觉");
					else
						if npc1.Sex == CS.XiaWorld.g_emNpcSex.Male then
							if npc2.PropertyMgr:CheckFeature("Pogua") ~= true then--对方是处女
							npc2.PropertyMgr:AddFeature("Pogua");
							npc1:AddModifier("Diyidixue");
							npc1:AddModifier("Story_Caibuzhidao1");
							npc2:AddModifier("CaibuCD");
							npc1.PropertyMgr.RelationData:AddRelationShip(npc2,"Chunv");
							me:AddMsg(""..npc1.Name.."使用幻术迷住了"..npc2.Name.."后，将她按倒在地，一把撕去了"..npc2.Name.."的裤子，"..npc2.Name.."的惊呼也没让他产生半点怜悯，请出自己胯下的小兄弟，刺入了对方的蜜穴。\n"..npc1.Name.."的肉棒前端阻碍，不禁暗道一声“没想到"..npc2.Name.."竟是个处子之身，赚到了！”后，便在对方对方蜜穴中来来回回抽插了百余下，虽过程中"..npc2.Name.."大声哭喊呼救，但最终还是在"..npc1.Name.."高超的技巧下达到了高潮，"..npc2.Name.."那处子的精元混合着精血喷洒在了"..npc1.Name.."的肉棒之上。\n"..npc1.Name.."感觉自己的灵气和潜力均有所提升。");
							else
							npc2:AddModifier("CaibuCD");
							npc1:AddModifier("Story_Caibuzhidao1");
							npc1.PropertyMgr:AddMaxAge(1);
							npc2.PropertyMgr:AddMaxAge(- 10);
							me:AddMsg(""..npc1.Name.."使用幻术迷住了"..npc2.Name.."后，将她按倒在地，一把撕去了"..npc2.Name.."的裤子，"..npc2.Name.."的惊呼也没让他产生半点怜悯，请出自己胯下的小兄弟，便在对方对方蜜穴中来来回回抽插了百余下，于"..npc2.Name.."高潮之际，掠走了对方不少精元后。\n"..npc1.Name.."感觉自己的灵气有所提升。");
							end
						else
							if npc1.PropertyMgr:CheckFeature("Pogua") ~= true then--我是处女
							npc1.PropertyMgr:AddFeature("Pogua");
							npc2:AddModifier("Diyidixue");
							npc2:AddModifier("CaibuCD");
							npc1.PropertyMgr:AddMaxAge(- 5);
							npc2.PropertyMgr:AddMaxAge(5);
							npc1.PropertyMgr.RelationData:AddRelationShip(npc2,"Chunv");
							me:AddMsg(""..npc1.Name.."刚掀起自己的裙角，"..npc2.Name.."便急不可待的像条公狗一样冲了上来，将自己的小兄弟插入了"..npc1.Name.."蜜壶中，破瓜的巨痛让"..npc1.Name.."心神失守，随着"..npc2.Name.."一阵猪突蒙进，"..npc2.Name.."直觉到大量的快感充斥脑海，随着一个冷战，大量的阴元喷射在对方肉棒上，这是一次失败的采补。\n"..npc1.Name.."感觉自己损失了不少精血。");
							else
								npc2:AddModifier("CaibuCD");
								npc1:AddModifier("Story_Caibuzhidao1");
								npc1.PropertyMgr:AddMaxAge(1);
								npc2.PropertyMgr:AddMaxAge(- 10);
								me:AddMsg(""..npc1.Name.."刚掀起自己的裙角，"..npc2.Name.."便急不可待的像条公狗一样冲了上来，将自己的小兄弟插入了"..npc1.Name.."蜜壶中，随后便是一阵猪突蒙进，直到元阳不守一泄如注，大量的元阳灌注与"..npc1.Name.."蜜穴之中以供"..npc1.Name.."炼化。\n"..npc1.Name.."感觉自己的灵气有所提升。");
							end
						end
					end
				else
					if npc1.PropertyMgr:CheckFeature("BeautifulFace3") then
						npc2:AddModifier("CaibuCD");
						npc1:AddModifier("Story_Caibuzhidao1");
						npc1.PropertyMgr:AddMaxAge(1);
						npc2.PropertyMgr:AddMaxAge(- 10);
						me:AddMsg("没有任何男人可能拒绝的了"..npc1.Name.."的要求，"..npc1.Name.."正大光明的告诉了"..npc2.Name.."她想要他的精元用于修炼，"..npc2.Name.."便跪倒在了"..npc1.Name.."的面前，看着"..npc1.Name.."那全世界为其倾倒的绝美容颜，想着其竟向自己索取阳精"..npc2.Name.."的针线活还没开始便已经结束，子弹便如连珠炮射而出，"..npc1.Name.."将"..npc2.Name.."的精元炼化，感觉自身的灵气有所提升。");
					elseif npc1.LuaHelper:GetGLevel() == npc2.LuaHelper:GetGLevel() then
						if random >= 50 then
							me:AddMsg("施展迷魂术失败后，反被对方精神力反伤，心神大损导致折寿十年。");
							npc1.PropertyMgr:AddMaxAge(-10);
						else
							if npc1.Sex == CS.XiaWorld.g_emNpcSex.Male then
								if npc2.PropertyMgr:CheckFeature("Pogua") ~= true then--对方是处女
								npc2.PropertyMgr:AddFeature("Pogua");
								npc1:AddModifier("Story_Caibuzhidao1");
								npc1:AddModifier("Diyidixue");
								npc2:AddModifier("CaibuCD");
								npc1.PropertyMgr.RelationData:AddRelationShip(npc2,"Chunv");
								me:AddMsg(""..npc1.Name.."使用幻术迷住了"..npc2.Name.."后，将她按倒在地，一把撕去了"..npc2.Name.."的裤子，"..npc2.Name.."的惊呼也没让他产生半点怜悯，请出自己胯下的小兄弟，刺入了对方的蜜穴。\n"..npc1.Name.."的肉棒前端阻碍，不禁暗道一声“没想到"..npc2.Name.."竟是个处子之身，赚到了！”后，便在对方对方蜜穴中来来回回抽插了百余下，虽过程中"..npc2.Name.."大声哭喊呼救，但最终还是在"..npc1.Name.."高超的技巧下达到了高潮，"..npc2.Name.."那处子的精元混合着精血喷洒在了"..npc1.Name.."的肉棒之上。\n"..npc1.Name.."感觉自己的灵气和潜力均有所提升。");
								else
								npc2:AddModifier("CaibuCD");
								npc1:AddModifier("Story_Caibuzhidao1");
								npc1.PropertyMgr:AddMaxAge(1);
								npc2.PropertyMgr:AddMaxAge(- 10);
								me:AddMsg(""..npc1.Name.."使用幻术迷住了"..npc2.Name.."后，将她按倒在地，一把撕去了"..npc2.Name.."的裤子，"..npc2.Name.."的惊呼也没让他产生半点怜悯，请出自己胯下的小兄弟，便在对方对方蜜穴中来来回回抽插了百余下，于"..npc2.Name.."高潮之际，掠走了对方不少精元后。\n"..npc1.Name.."感觉自己的灵气有所提升。");
								end
							else
								if npc1.PropertyMgr:CheckFeature("Pogua") ~= true then--我是处女
								npc1.PropertyMgr:AddFeature("Pogua");
								npc2:AddModifier("CaibuCD");
								npc2:AddModifier("Diyidixue");
								npc1.PropertyMgr:AddMaxAge(- 5);
								npc2.PropertyMgr:AddMaxAge(5);
								npc1.PropertyMgr.RelationData:AddRelationShip(npc2,"Chunv");
								me:AddMsg(""..npc1.Name.."刚掀起自己的裙角，"..npc2.Name.."便急不可待的像条公狗一样冲了上来，将自己的小兄弟插入了"..npc1.Name.."蜜壶中，破瓜的巨痛让"..npc1.Name.."心神失守，随着"..npc2.Name.."一阵猪突蒙进，"..npc2.Name.."直觉到大量的快感充斥脑海，随着一个冷战，大量的阴元喷射在对方肉棒上，这是一次失败的采补。\n"..npc1.Name.."感觉自己损失了不少精血。");
								else
									npc2:AddModifier("CaibuCD");
									npc1:AddModifier("Story_Caibuzhidao1");
									npc1.PropertyMgr:AddMaxAge(1);
									npc2.PropertyMgr:AddMaxAge(- 10);
									me:AddMsg(""..npc1.Name.."刚掀起自己的裙角，"..npc2.Name.."便急不可待的像条公狗一样冲了上来，将自己的小兄弟插入了"..npc1.Name.."蜜壶中，随后便是一阵猪突蒙进，直到元阳不守一泄如注，大量的元阳灌注与"..npc1.Name.."蜜穴之中以供"..npc1.Name.."炼化。\n"..npc1.Name.."感觉自己的灵气有所提升。");
								end
							end
						end
					else
						me:AddMsg(""..npc1.Name.."看了对方一眼，被对方身上强大的气势所摄，仔细想想还是不要搞事情了。");
					end
				end
			end
		end
	else
		me:AddMsg(""..npc2.Name.."已经被你采补过了。");
	end
end

------------------色诱未完成
function Hudong:NTRPD()--目标已婚，并且对象不是我
npc1 = ThingMgr:FindThingByID(me.npcObj.ID)
npc2 = ThingMgr:FindThingByID(story:GetBindThing().ID)
	if npc2.PropertyMgr.BodyData:PartIsBroken("Genitals") or npc1.PropertyMgr.BodyData:PartIsBroken("Genitals") then--太监和夫妻除外
	return false;
	else
	return true;
	end
return false;
end

function Hudong:NTR()
npc1 = ThingMgr:FindThingByID(me.npcObj.ID)
npc2 = ThingMgr:FindThingByID(story:GetBindThing().ID)
	local random = npc1.LuaHelper:RandomInt(0,10);
	local meili = npc1.LuaHelper:GetCharisma()
	local juqing = npc1.LuaHelper:RandomInt(1,5)
	local Wfxg = CS.XiaWorld.JianghuMgr.Instance:GetJHNpcDataBySeed(npc1.JiangHuSeed).Feature
	local Dfxg = CS.XiaWorld.JianghuMgr.Instance:GetJHNpcDataBySeed(npc2.JiangHuSeed).Feature
	local XianzheCD = npc2.LuaHelper:GetModifierStack("XianzheCD");
	local NalitongCD = npc2.LuaHelper:GetModifierStack("NalitongCD");
	local seyouCD = NalitongCD + XianzheCD
	if npc2.IsDeath then
	me:AddMsg(""..npc2.Name.."已经死了……");
	elseif npc2.LuaHelper:GetModifierStack("Prison_Modifier2")~= 0 then
	me:AddMsg("作为"..SchoolMgr.Name.."的囚犯"..npc2.Name.."自然是无法以任何理由拒绝"..SchoolMgr.Name.."弟子的，于是"..npc2.Name.."被"..npc1.Name.."操弄了一番。");
		if npc1.Sex == CS.XiaWorld.g_emNpcSex.Female and npc1.PropertyMgr:CheckFeature("Pogua")then
		npc1.PropertyMgr:AddFeature("Pogua");
		end
		if npc2.Sex == CS.XiaWorld.g_emNpcSex.Female and npc2.PropertyMgr:CheckFeature("Pogua")then
		npc2.PropertyMgr:AddFeature("Pogua");
		end
	npc2:AddModifier("XianzheCD");
	npc1:AddModifier("XianzheCD");
	elseif seyouCD == 0 then--cd判定，成功开始剧本
		if npc2.RaceDefName ~= "Human" then
			if npc1.LuaHelper:GetModifierStack("Zhenchaosuo")~= 0 or npc1.LuaHelper:GetModifierStack("Zhenchaozhou") ~= 0 then
			me:AddMsg(""..npc1.Name.."的下面被锁住了……");
			elseif npc1.Name == "卓十七" then
			me:AddMsg(""..npc1.Name.."：别的咱们不多哔哔，兄弟你妈没了！");
			elseif npc2.IsLingShou then
			Hudong:LingshouSex()
			elseif npc1.Sex == CS.XiaWorld.g_emNpcSex.Male and npc2.Sex == CS.XiaWorld.g_emNpcSex.Male then--主角男，动物公
			me:AddMsg(""..npc1.Name.."一把抓住了"..npc2.Name.."，面露淫光的"..npc1.Name.."一把握在"..npc2.Name.."生殖器上，上下撸动着……\n见"..npc2.Name.."并没有太大反应，身为男性的"..npc1.Name.."居然伏下身子，对着"..npc2.Name.."生殖器便是一阵吹拉弹唱……\n事毕，"..npc1.Name.."觉得自己舔的很爽");
			elseif npc1.Sex == CS.XiaWorld.g_emNpcSex.Male and npc2.Sex ~= CS.XiaWorld.g_emNpcSex.Male then--主角男，动物母
			me:AddMsg(""..npc1.Name.."一把抓住了"..npc2.Name.."，面露淫光的"..npc1.Name.."将对方按在地上，伸出舌头舔弄着"..npc2.Name.."肉穴，见"..npc2.Name.."放下戒备后，便褪下裤子露出胯下巨龙，狠狠的插入了"..npc2.Name.."的肉穴，全然不顾"..npc2.Name.."的惨叫，抽送百余下后，"..npc1.Name.."突然提速……\n事毕，"..npc1.Name.."觉得"..npc2.Name.."肉穴好玩极了……");
			elseif npc1.Sex ~= CS.XiaWorld.g_emNpcSex.Male and npc2.Sex == CS.XiaWorld.g_emNpcSex.Male then--主角女，动物公
			me:AddMsg(""..npc1.Name.."露出肉穴，肉穴中散发出极度催情的气味，"..npc2.Name.."狂性大发，跨上"..npc1.Name.."的身体将肉棒插了进去……一阵狂风暴雨般的抽插后，"..npc2.Name.."将精元灌满了"..npc1.Name.."的子宫……");
			if npc1.PropertyMgr:CheckFeature("Pogua") ~= true then
			npc1.PropertyMgr:AddFeature("Pogua");
			npc1.PropertyMgr.RelationData:AddRelationShip(npc2,"Chunv");
			npc1.PropertyMgr.RelationData:AddRelationShip(npc2,"Luding2");
			end
			elseif npc1.Sex ~= CS.XiaWorld.g_emNpcSex.Male and npc2.Sex ~= CS.XiaWorld.g_emNpcSex.Male then--主角女，动物母
			me:AddMsg(""..npc1.Name.."一把抓住了"..npc2.Name.."，将对方按在地上，伸出舌头舔弄着"..npc2.Name.."肉穴……\n事毕，"..npc1.Name.."觉得自己舔的很爽");
			else
			me:AddMsg("如果出现这文本，请上报bug至810116969。");
			end
			npc2:AddModifier("XianzheCD");
			npc1:AddModifier("XianzheCD");
		return false;
		end
		if npc2.PropertyMgr:CheckFeature("Chastity") and npc1.PropertyMgr.RelationData:IsRelationShipWith("Spouse",npc2) == false then
		me:AddMsg(""..npc1.Name.."对"..npc2.Name.."提出了性爱的请求，然而"..npc2.Name.."是一个贞洁的女子，她拒绝了"..npc1.Name.."。");
		return false;
		end
		if npc1.LuaHelper:GetModifierStack("Zhenchaosuo")~= 0 or npc1.LuaHelper:GetModifierStack("Zhenchaozhou") ~= 0 then--1带着贞操锁/咒
			if npc1.Sex == CS.XiaWorld.g_emNpcSex.Male and npc1.PropertyMgr.RelationData:IsRelationShipWith("Luding2",npc2) == true then--1是男，且是2的奴隶
			me:AddMsg(""..npc2.Name.."想要侍奉自己的主人，许是"..npc1.Name.."心情很好，她解开了贞操锁/咒，让"..npc1.Name.."用胯下肉棒侍奉了自己");
			npc2:AddModifier("XianzheCD");
			npc1:AddModifier("XianzheCD");
			else
				if npc1.Sex ~= CS.XiaWorld.g_emNpcSex.Male and npc1.PropertyMgr.RelationData:IsRelationShipWith("Luding2",npc2) == true then--1是女，且是2的奴隶
				me:AddMsg(""..npc2.Name.."想要侍奉自己的主人，许是"..npc1.Name.."心情很好，他解开了贞操锁/咒，让"..npc1.Name.."使用小穴侍奉了自己");
				npc2:AddModifier("XianzheCD");
				npc1:AddModifier("XianzheCD");
				else
					me:AddMsg(""..npc1.Name.."的下体被阳锁/贞操咒封住了，并不能对对方做什么，于是转身离开了。");
				end
			end
		return false;
		end
		if npc2.LuaHelper:GetModifierStack("Zhenchaosuo")~= 0 or npc2.LuaHelper:GetModifierStack("Zhenchaozhou") ~= 0 then--2带着贞操锁/咒
			if npc1.Sex == CS.XiaWorld.g_emNpcSex.Male and npc1.PropertyMgr.RelationData:IsRelationShipWith("Luding2",npc2) == true then--1是男，且是2的主人
			me:AddMsg(""..npc1.Name.."一时性起，想要干自己的女奴"..npc2.Name.."一炮，他解开了贞操锁/咒，在"..npc2.Name.."身上耕耘许久直到心满意足后转身离去了。");
			npc2:AddModifier("XianzheCD");
			npc1:AddModifier("XianzheCD");
			else
				if npc1.Sex ~= CS.XiaWorld.g_emNpcSex.Male and npc1.PropertyMgr.RelationData:IsRelationShipWith("Luding2",npc2) == true then--1是女，且是2的主人
				me:AddMsg(""..npc1.Name.."一时性起，感觉下身湿润了，想要自己的公狗"..npc2.Name.."来干上自己一炮，他解开了贞操锁/咒，"..npc2.Name.."用胯下肉棒侍奉了"..npc1.Name.."。");
				npc2:AddModifier("XianzheCD");
				npc1:AddModifier("XianzheCD");
				else
					me:AddMsg("还未等"..npc1.Name.."开口，只见"..npc2.Name.."摸了摸下身，也不理会"..npc1.Name.."便转身离去了。");
				end
			end
		return false;
		end
		if npc1.PropertyMgr.RelationData:IsRelationShipWith("Spouse",npc2) then
			if npc2.Sex ~= CS.XiaWorld.g_emNpcSex.Male and npc2.PropertyMgr:CheckFeature("Pogua") ~= true then
			me:AddMsg(""..npc2.Name.."的初夜一直为"..npc1.Name.."守护到了现在，从来没有任何污秽进入过她的身体，她是一个圣洁的处子，而这一份圣洁也是天道所喜的，"..npc1.Name.."与"..npc2.Name.."度过了美好的一夜……");
			npc2.PropertyMgr:AddFeature("Pogua");
			npc2.PropertyMgr:AddFeature("Chastity");
			elseif npc1.Sex ~= CS.XiaWorld.g_emNpcSex.Male and npc1.PropertyMgr:CheckFeature("Pogua") ~= true then
			me:AddMsg(""..npc1.Name.."的初夜一直为"..npc2.Name.."守护到了现在，从来没有任何污秽进入过她的身体，她是一个圣洁的处子，而这一份圣洁也是天道所喜的，"..npc1.Name.."与"..npc2.Name.."度过了美好的一夜……");
			npc1.PropertyMgr:AddFeature("Pogua");
			npc1.PropertyMgr:AddFeature("Chastity");
			else
			me:AddMsg(""..npc1.Name.."和"..npc2.Name.."是夫妻关系，想要干一炮显然是合理合法的需求，于是两个人开心的干了一炮。");
			end
		npc2:AddModifier("XianzheCD");
		npc1:AddModifier("XianzheCD");
		return false;
		end
		if npc1.PropertyMgr.RelationData:IsRelationShipWith("FancyFlag",npc2) then
		me:AddMsg(""..npc1.Name.."忽一时欲起，找到了自己的舔狗"..npc2.Name.."提出帮自己泻火，"..npc2.Name.."被这突来的幸运砸蒙了，兴奋的跪倒在地，用自己嘴侍奉了"..npc1.Name.."，"..npc1.Name.."心满意足后便离去了。");
		npc1:AddModifier("XianzheCD");
		return false;
		end
	for key,npcs in pairs(npc2.PropertyMgr.RelationData.m_mapRelationShips) do
		if (key == "Spouse") and npcs.Count > 0 then 
			print("找到夫妻或恋人关系")
			local isSpouse = false
			local Spouse = ""
			for _,npc in pairs(npcs) do
				Spouse = npc
				if npc1.ID == npc.ID then 
					isSpouse = true
					break
				end
			end
			if isSpouse == false then--判定NTR成功
				if npc1.Sex == CS.XiaWorld.g_emNpcSex.Male then
					if npc2.Sex == CS.XiaWorld.g_emNpcSex.Male then--男男ntr
					local npc3 = npc1.PropertyMgr.Practice.Master
						if npc1.LuaHelper:GetGLevel() > npc2.LuaHelper:GetGLevel() and npc1.LuaHelper:GetGLevel() > Spouse.LuaHelper:GetGLevel() then
						me:AddMsg("一日，"..npc1.Name.."拦住了"..npc2.Name.."吩咐道："..npc2.Name.."啊，我觉得你的老婆"..Spouse.Name.."姿色不错，哪来给兄弟日以下可好？\n这绿油油的帽子"..npc2.Name.."自然不愿意带在头上，可实力不济的"..npc2.Name.."又无法反抗……只能将自己的妻子"..Spouse.Name.."迷晕之后送与"..npc1.Name.."对方玩弄……\n"..Spouse.Name.."成了"..npc1.Name.."的母狗……");
						npc1.PropertyMgr.RelationData:AddRelationShip(npc2,"Kuzhu");
						npc1.PropertyMgr.RelationData:AddRelationShip(Spouse,"Luding2");
							if Spouse.PropertyMgr:CheckFeature("Pogua") ~= true then
							Spouse.PropertyMgr:AddFeature("Pogua");
							end
						elseif npc1.LuaHelper:GetGLevel() > npc2.LuaHelper:GetGLevel() and npc3 ~= nil and npc3.LuaHelper:GetGLevel() > Spouse.LuaHelper:GetGLevel() and npc3.Sex == CS.XiaWorld.g_emNpcSex.Male then
						me:AddMsg("一日，"..npc1.Name.."拦住了"..npc2.Name.."吩咐道："..npc2.Name.."啊，我觉得你的老婆"..Spouse.Name.."姿色不错，哪来给兄弟日以下可好？\n这绿油油的帽子"..npc2.Name.."自然不愿意带在头上，可实力不济的"..npc2.Name.."又无法反抗，只能将"..npc1.Name.."带入家中……\n"..npc1.Name.."欲行不轨之事时，只见"..Spouse.Name.."三两下间便击倒"..npc1.Name.."……\n奈何"..npc1.Name.."早就料到自己的实力不及"..Spouse.Name.."，于是其早早就请了自己师傅一起享用此女……\n只见"..npc3.Name.."轻而易举的制住了"..Spouse.Name.."与弟子"..npc1.Name.."一同将"..npc2.Name.."的妻子"..Spouse.Name.."按在地上干了个爽……");
						npc1.PropertyMgr.RelationData:AddRelationShip(npc2,"Kuzhu");
						npc3.PropertyMgr.RelationData:AddRelationShip(npc2,"Kuzhu");
						npc1.PropertyMgr.RelationData:AddRelationShip(Spouse,"Luding2");
						npc3.PropertyMgr.RelationData:AddRelationShip(Spouse,"Luding2");
							if Spouse.PropertyMgr:CheckFeature("Pogua") ~= true then
							Spouse.PropertyMgr:AddFeature("Pogua");
							end
						elseif npc1.LuaHelper:GetGLevel() > npc2.LuaHelper:GetGLevel() then
						me:AddMsg("一日，"..npc1.Name.."拦住了"..npc2.Name.."吩咐道："..npc2.Name.."啊，我觉得你的老婆"..Spouse.Name.."姿色不错，哪来给兄弟日以下可好？\n这绿油油的帽子"..npc2.Name.."自然不愿意带在头上，可实力不济的"..npc2.Name.."又无法反抗，只能将"..npc1.Name.."带入家中……\n"..npc1.Name.."欲行不轨之事时，只见"..Spouse.Name.."三两下间便击倒"..npc1.Name.."，还没等"..npc2.Name.."来得及舔上两句，"..npc2.Name.."便被"..Spouse.Name.."踹倒在地上……\n"..Spouse.Name.."觉得"..npc2.Name.."不是良配，便与其终结了这段夫妻关系……");
						Spouse.PropertyMgr.RelationData:RemoveRelationShip(npc2,"Spouse");
						else
						me:AddMsg(""..npc2.Name.."实力远胜于"..npc1.Name.."，"..npc1.Name.."这样正大光明的夫目前犯，怕不是要被打出屎来……。");
						end
					else--男女ntr
						if npc2.PropertyMgr:CheckFeature("Pogua") == true and npc1.PropertyMgr.Practice.Gong.Name == ("Gong_1701_Tu") and npc2.PropertyMgr:CheckFeature("Chinvguchong") == true then--主角会采补，女非处，被蛊寄生
						me:AddMsg(""..npc2.Name.."感觉最近自己的欲念越来越强烈，经常不自觉想起和"..Spouse.Name.."缠绵的情景，想着想着脑海了的"..Spouse.Name.."竟然变成了这几天时有来往的"..npc1.Name.."。其实"..npc2.Name.."不知道，这都是阴阳和合蛊寄生后起的作用。"..npc2.Name.."失常欲火难耐，独自一人白天在小屋里自己抚慰自己，释放心中的欲望。\n这一日垂涎"..npc2.Name.."已久的"..npc1.Name.."待其不备封住了正在自摸的"..npc2.Name.."，"..npc1.Name.."一边脱下衣裤一边淫笑道：「"..npc2.Name.."，你已被我封住了灵力，放弃抵抗好好享受吧，我的鸡巴会让你欲仙欲死的。」\n说着"..npc1.Name.."立即向"..npc2.Name.."扑了过去。\n "..npc1.Name.."一只手扣住"..npc2.Name.."的双手，另一只手扶着"..npc2.Name.."的芊腰，用两个膝盖分开对方的双腿一边悄声道：「是不是觉得你的小骚穴痒痒的，特别想要？你被阴阳合欢蛊寄生了，此蛊会催发自身淫欲化为淫毒，如不与男子交合，只是自行抚弄，怕是要不了多久，就会被毒蛊变成一只欲求不满，只知淫欲的母狗……」\n"..npc2.Name.."的脸色一下子变得苍白，身子无助的发抖着。\n "..npc1.Name.."晃动屁股，使龟头对准"..npc2.Name.."的小穴后，缓缓用力，一根粗长的肉棒缓缓的插入到"..npc2.Name.."的深处。\n「不要！…………」感觉到火热的龟头挤开自己的阴唇，"..npc2.Name.."绝望地喊道。\n伴随着"..npc2.Name.."那紧致的肉腔的挤压无与伦比的美妙感觉让"..npc1.Name.."飘飘欲仙，占有了"..Spouse.Name.."的女人带给"..npc1.Name.."的心理快感更是妙不可言，从他龟头接触到"..npc2.Name.."那肥美娇嫩的花心。"..npc2.Name.."无比紧致的小穴死死的咬住"..npc1.Name.."的肉棒，粗大肉棒在嫩穴中狂猛抽插，胯部啪啪撞击着雪白玉臀，扶着腰部的手缓缓向上，攀上了那挺翘的玉女峰，大力的揉搓着。\n「！！……」\n 突然"..npc2.Name.."感觉到小穴的肉棒像活物一样，在自己的小穴里扭动着，龟头不断挑弄着自己的花心，可是明明这个淫贼的身子一动也没有动过。\n好奇的"..npc2.Name.."努力的看向自己的胯下。\n感觉到"..npc2.Name.."动作的"..npc1.Name.."调笑道：「怎么样"..npc2.Name.."，我兼修合欢宗的六欲心经，能控制肉棒拐弯，"..npc2.Name.."你还是从了我吧！」\n「不…不要……停……啊！……」"..npc2.Name.."想要开口喝止，可是身体下部传来的快感使她无法组织语言。\n「不要停是吧！你看好了……」说着"..npc1.Name.."大力抽插起来同时合欢功法运转，灵力通过肉棒传入"..npc2.Name.."的肉穴再到气海之中，再从紧致的阴道传过来之后，都会变得更加强大。"..npc1.Name.."精神大振体内灵力越来越充沛，当下抱紧"..npc2.Name.."，狂猛大干，灵力更是在她体内来回流转，以双修增强自己灵力，随着灵力在"..npc2.Name.."的气海与肉穴之间游走，夹着肉棒的小穴变得越发湿润，肉壁夹的越来越紧。\n「不……啊……不………啊……啊……好…好深……轻点……」看着在自己胯下扭动娇吟的"..npc2.Name.."，"..npc1.Name.."心中一阵自豪，下身更加用力的抽插着那娇嫩的小穴，同时也运使合欢功法加速灵力运转且让肉棒不断扭动忽上忽下、忽左忽右灵力流过肉壁的快感让"..npc2.Name.."兴奋得发狂，抱紧"..npc1.Name.."挺臀迎合，颤声浪叫道：「啊…啊……好…好爽……好棒……啊……好舒服……哦……哦……好深……哦……好舒服……啊……嗯呀……快……不要停……好舒服……呜呜……」\n 看着被自己胯下征服的"..npc2.Name.."，"..npc1.Name.."一阵自豪，不自觉的松开双手，把两只手撑在床上「埋头苦干」。\n\n "..npc2.Name.."喘息着，脸色羞红，双手扶着"..npc1.Name.."的肩膀，跨坐在他腰间，两人面对面交合的姿势使胸部产生强烈接触让"..npc2.Name.."更加兴奋难耐，低喘着把香吻献上，和"..npc1.Name.."亲的昏天地暗。\n同时癫狂地主动套动起来，一对丰满无比的奶子在"..npc1.Name.."面前上下抛摔着，不断接触男人的脸颊。\n"..npc1.Name.."突然抬起身子吸住了她的右乳头接着双手滑向美女臀下，抓住她的屁股向上一托，同时自己把大腿向里一收，一股向上的力量将"..npc2.Name.."的身子弹了起来，"..npc2.Name.."如吃惊的叫了一声，身体却又落下，重新坐回了他那根粗壮的阴茎上，而就这样子已完成了两人性具的一次磨擦。\n如此这般，跟着是第二次、第三次……"..npc2.Name.."的身体主动抱住"..npc1.Name.."的后背起起落落，继续承受着他的玩弄。他两只有力的手臂托着人妻的双臀不住地抬起、放下，加上强烈的视觉刺激，"..npc2.Name.."无比舒适地踦在他的跨上，「嗯……嗯……的哼叫着「好棒……啊……好舒服……哦……哦……好深……哦……好舒服……从没这么……快活……啊……呃……」她已经忘了一切，不知所云的胡乱呼喊着，每一次的肉体交欢都让她婉转娇吟，披到腰际的乌黑长发随着身体的上下套动在空中飞扬飘舞，嫣红的香腮上颗颗香汗滑下，胴体上浮起动人的绯红，那紧密的蚌肉紧夹着男人的大鸡巴，交合处玉露飞溅，点点滴滴顺着"..npc1.Name.."粗壮的大鸡巴洒落在胯间"..npc2.Name.."长吟一声，好似浑身上下都酥了，满满涨感直填到了心房里，心头猛跳，双眸水光盈盈的望着身下之人，双手撑着他胸膛，雪股急摆，嫩穴夹着巨棒大耸大落起来。\n\n "..npc1.Name.."见"..npc2.Name.."含情脉脉的看着自己，心中一片满足。只觉"..npc2.Name.."穴内嫩嫩滑滑，紧凑无比，且她淫水丰润，时不时便热辣辣的打在马眼上，十分舒爽。\n "..npc2.Name.."双眼迷离，乌发散落，浓浓鼻息荡着屋内空气亦随之沸燃"..npc2.Name.."那含苞待放的花心不断被大龟头连续地撞击，销魂蚀骨、阵阵酥麻的美感，平生第一次尝试到如此销魂蚀骨的性爱……");
						npc1.PropertyMgr.RelationData:AddRelationShip(npc2,"Luding2");
						npc1:AddModifier("Story_Caibuzhidao1");
						npc2:AddModifier("XianzheCD");
						npc1:AddModifier("XianzheCD");
						return false;
						end
						if npc2.PropertyMgr:CheckFeature("Mugou") == true and npc2.PropertyMgr:CheckFeature("Pogua") == true then
						me:AddMsg(""..npc2.Name.."虽是有夫之妇，但是经过无数次调教开发的肉体，对于任何人来说，都是不设防的……\n"..npc1.Name.."刚提出给"..Spouse.Name.."头让抹点绿的时候，便见到"..npc2.Name.."已经三下五除二的将衣服褪尽……\n一场酣战之后，双方均获得了肉体上的满足……\n事后，"..npc2.Name.."好像认定了"..npc1.Name.."这个主人……");
						npc1.PropertyMgr.RelationData:AddRelationShip(npc2,"Luding2");
						npc2:AddModifier("XianzheCD");
						npc1:AddModifier("XianzheCD");
						return false;
						end
						if npc2.PropertyMgr:CheckFeature("Pogua") == true and npc1.LuaHelper:GetModifierStack("YYHHGFL") ~= 0 then--主角有淫药，女非处
						me:AddMsg(" "..npc1.Name.."从怀里轻轻的掏出了一枚红丸，碾碎以后掐起一道法决化作一阵轻风悄无声息的吹入房中……\n少顷，屋内灯灭，显然里面的人已经睡下，深知此药厉害的"..npc1.Name.."就这样有恃无恐的潜进屋内\n"..npc1.Name.."轻轻关上房门转身看着趴在桌上熟睡的"..npc2.Name.."身体微微颤栗闻着闺房中沁人心脾的香味心中的欲火越来越旺盛。\n\n 他舔了舔嘴唇坐到了"..npc2.Name.."身边伸出右手轻轻抚摸着她白皙妩媚的脸庞手掌上传来的惊人触感令他激动不已。\n 安静燃烧的烛火散发着澹黄色的光映照在"..npc2.Name.."柔美的身段上。\n 那晶莹可爱的琼鼻轻启的唇珠露出了两颗洁白的银牙吹弹可破的肌肤无一不让"..npc1.Name.."沉醉。\n"..npc2.Name.."的闺房内"..npc1.Name.."已经将"..npc2.Name.."抱到了床上一双手正隔着轻薄的纱裙揉捏着她胸前那对硕大的美乳这极致触感和沸腾的欲火让他喘息不已。\n 他伸出舌头轻轻的舔舐着"..npc2.Name.."红润的脸颊而中了迷药的"..npc2.Name.."却依然睡得香甜。\n 「呼…」\n 心情稍微平息的"..npc1.Name.."站起身脱光自己的衣服之后开始脱"..npc2.Name.."的衣服。\n 不一会便剥去了她的纱裙露出了只剩亵衣和亵裤的美妙胴体。\n"..npc1.Name.."此刻的双眼几乎要放出光来贪婪的扫视着那光滑的香肩和平坦的小腹, 一只手已经急不可耐的摸上了"..npc2.Name.."那纤细修长的美腿无论是那柔软的大腿还，是光滑的小腿都让他赞叹不已而那对秀美白皙的玉足更是让他按捺不住直接捧到眼前，细细欣赏起来一边还猥琐的嗅着它的气味然后急不可耐的将其中一只玉足的足趾含入嘴里又舔又咬。\n同时另一只手也没闲着，随即呼吸一紧之间那"..npc2.Name.."浑身上下只剩一件亵衣，还露出了一只肥硕的美乳正被压在她身上的"..npc1.Name.."用力揉捏着四德一边享受着。\n"..npc2.Name.."胸前的丰润一边握着自己那被无数女子元阴强化过的威勐长枪用鹅蛋大小的龟头在她已经略微湿润的粉嫩美鲍上上下滑动接着轻轻向洞里插去。\n「我上了"..Spouse.Name.."的女人！」\n\n伴随着"..npc2.Name.."那紧致的肉腔的挤压无与伦比的美妙感觉让"..npc1.Name.."飘飘欲仙占有了"..Spouse.Name.."的女人带给"..npc1.Name.."的心理快感更是妙不可言从他龟头接触到"..npc2.Name.."那肥美娇嫩的花心。\n"..npc2.Name.."无比紧致的小穴死死的咬住"..npc1.Name.."的肉棒，粗大肉棒在嫩穴中狂猛抽插，胯部啪啪撞击着雪白玉臀，插得美人无意识的娇吟虽然在睡梦中却依然轻轻蹙起了眉头似乎感受到了下身那粗壮的肉茎。\n "..npc1.Name.."松开手中的美乳将"..npc2.Name.."修长的美腿架在肩上耸动着熊腰开始操弄眼前的尤物伴随着"..npc1.Name.."的操干"..npc2.Name.."的上半身也轻轻摇晃着那只暴露在空气中的美乳也不停晃动着。\n同时合欢功法下意识的运转着，灵力不停地在两人之间流转，"..npc1.Name.."内观气海，感觉到每次灵力通过肉棒传入"..npc2.Name.."的气海之中，再从紧致的阴道传过来之后，都会变得更加强大。"..npc1.Name.."精神大振体内灵力越来越充沛，自从修仙以来，他已经很有做爱升级的心得，当下抱紧"..npc2.Name.."，狂猛大干，灵力更是在她体内来回流转，以双修增强自己灵力，随着灵力在"..npc2.Name.."的气海与肉穴之间游走，夹着肉棒的小穴变得越发湿润，肉壁夹的越来越紧。\n 「嘶…太爽了…」\n"..npc1.Name.."一边干着一边感叹双手在"..npc2.Name.."的娇躯上四处摸索被架在他肩上的玉足不停晃动着"..npc1.Name.."舔了舔嘴唇随即将那大拇指含入嘴里用力吮吸着。\n 就这般操干了小半个时辰"..npc1.Name.."终于忍耐住不下体即将喷薄的欲望于是将"..npc2.Name.."的双腿压到她的胸前下身奋力冲刺起来。\n「哦…」\n 不一会儿"..npc1.Name.."便趴在"..npc2.Name.."身上痉挛起来在子宫上面狂猛跳动将一股股滚烫浓精送入她的子宫内。精液之中，灌注强大灵力，在人妻子宫中闪闪生辉，留下另一个男人的印记被这夹带灵力的滚烫浓精一烫，"..npc2.Name.."也在无意识的睡梦中达到了高潮，一大股珍贵的阴精喷薄而出，在双修功法的作用下很快便被"..npc1.Name.."的肉棒吸收炼化，化为灵力融入"..npc1.Name.."的气海之中。\n休息一阵之后，"..npc1.Name.."将"..npc2.Name.."的衣服重新穿好，收拾一下现场，施了个隐身咒从房门探出头观察了一番之后无声的融入了漆黑夜中。");
						local WDY = npc1.PropertyMgr:FindModifier("YYHHGFL")
						WDY:UpdateStack(-1);
						npc2:AddModifier("XianzheCD");
						npc1:AddModifier("XianzheCD");
						return false;
						end
						if Dfxg == CS.XiaWorld.g_emJHNpc_Feature.Greedy and npc1.LuaHelper:GetModifierStack("Qian") >= 1000000 and npc2.PropertyMgr:CheckFeature("Pogua") == true then--主角100W贪婪非处
						me:AddMsg(""..npc1.Name.."拿出一把银票，向"..npc2.Name.."表达了双修的愿望，"..npc2.Name.."看着银票，眼睛都直了，心道，这么多钱，别说是和你双修，就是当你的狗也甘之若饴。\n怕错失这次机会，"..npc2.Name.."连忙趴在地上舔"..npc1.Name.."的鞋底，同时沉腰将自己的后臀抬高，风骚的扭动着屁股，口中淫叫着，“啊……主人快来插我。”\n\n"..npc1.Name.."一脚踩在她的脸上，用随身带着的法器抽打着她摇个不停的骚屁股，一脸淫邪的笑道，“我插你，那你老公怎么办呢？你可是"..Spouse.Name.."的妻子啊，可不能不守妇道。”\n"..npc2.Name.."的脸都被踩得变形，还是乖巧的挤出讨好的笑容，“那是因为母狗之前没遇到主人，现在做了主人的贱母狗，我浑身上下都是属于主人的，任由主人随便玩弄。主人要是不让，我老公也不能操我。”\n"..npc1.Name.."把脚趾伸进她的狗嘴里，“这么乖啊，喏，这是主人赏你的。”\n"..npc1.Name.."又掏出一把银票扔在地上，"..npc2.Name.."口中含着脚趾，含糊不清的不住言道，“谢主人赏，谢主人赏……”磕了几个头，将银票捡了起来，攥成一卷，插进自己的后庭，摇着屁股讨好的说道，“主人，母狗有尾巴了，谢谢主人赏赐。”\n"..npc1.Name.."见这骚婊子这般淫贱，再也按捺不住心头欲火，提枪直刺。待云雨将歇之时——“啊，主人射进来吧，我要给主人生孩子，求求主人了。”"..npc2.Name.."淫叫着恳求"..npc1.Name.."。\n“给我生孩子，那你丈夫呢？”"..npc1.Name.."停了下来，坏笑着问。\n“他，他不配，主人放心，他的精液再也不会射进我的骚屄，母狗不会再让他碰了，母狗只属于主人一个人……啊……哦，谢谢主人……啊……”"..npc2.Name.."最终感受到一股滚烫射进了自己的淫穴，强烈的刺激之下，骚水也喷涌而出，“好……好爽，主人。”\n\n"..npc1.Name.."又递上了些许银两，拍了拍她的屁股，“你，不错，是条好狗。”\n\n事毕，"..npc2.Name.."成为了"..npc1.Name.."的女奴隶，"..npc2.Name.."获得银两10万两。");
						npc1:AddModifier("Qian");
						npc2:AddModifier("Qian");
						npc2:AddModifier("XianzheCD");
						npc1:AddModifier("XianzheCD");
						local WDQ = npc1.PropertyMgr:FindModifier("Qian")
						local DDQ = npc2.PropertyMgr:FindModifier("Qian")
						WDQ:UpdateStack(-100001);
						DDQ:UpdateStack(99999);
						npc1.PropertyMgr.RelationData:AddRelationShip(npc2,"Luding2");
						return false;
						end
						if Dfxg == CS.XiaWorld.g_emJHNpc_Feature.Greedy and npc1.LuaHelper:GetModifierStack("Qian") >= 1000000 and npc2.PropertyMgr:CheckFeature("Pogua") ~= true then--主角100W贪婪处女
						me:AddMsg(""..npc1.Name.."拿出一把银票，向"..npc2.Name.."表达了双修的愿望。"..npc2.Name.."看着银票，眼睛都直了，心想，还从来没见过这么多钱，真是后悔和他结婚了。\n可如今自己已经是"..Spouse.Name.."的妻子了，我和他还未曾欢好过，心下犹豫，这样做是否太对不起他了，可抬头看着那厚厚的一沓银票，又实在是怕错失这次机会。\n\n就在这犹豫之时，"..npc1.Name.."又拿出了一大把银票，全是汇通银号的千两票子，"..npc2.Name.."的眼睛就跟着那银票转动，失神之际，"..npc1.Name.."将银票插进了她双乳之间，她连忙按住，攥在手里。\n“我知道你还是个雏，我"..npc1.Name.."玩的就是雏。\n除了这些，你若应下，我手头还有几个零散的铺子和庄园，一并送你了。\n趁早踹了你那废物老公吧。”"..npc2.Name.."看着手里和眼前的票子，身下一热，淫水潺潺的就流了下来，口中娇喘着，伏在"..npc1.Name.."身下，用香舌侍弄着他的阳物，“爷的鸡巴真大，真不愧是财大器粗呢。”阴茎、阳袋都小心的舔弄着。\n"..npc1.Name.."听得高兴，被她伺候的也舒服，又拿出一沓子银票随手扔在了地上，“像狗一样捡起来，捡起来就是你的了。”\n"..npc2.Name.."听话的趴在地上，用舌头卷、用嘴叼，将银票都收拢到了一起，跪着磕了几个头，“母狗谢主人赏赐。”\n“真聪明，可我还是觉得你这个贱母狗没长尾巴，真是难看呢。”"..npc2.Name.."看了看四周，除了银票再无他物，心下一横，将面前的银票攥成一卷，插进自己的后庭，摇着屁股讨好的说道，“主人，母狗有尾巴了，谢谢主人赐给母狗尾巴。”\n"..npc1.Name.."用脚拍打着"..npc2.Name.."的脸，“你说，你这母狗怎么这么贱啊？要不把你这贱样用留影法器录下来，让你老公看看？”"..npc2.Name.."讨好的舔舐着"..npc1.Name.."的脚趾，“母狗才不管那个废物老公呢，母狗只想主人操我。”\n\n“去，躺到那，自己把腿掰开，让主人看看你的膜还在吗。”"..npc2.Name.."用双手分开双腿，手指掰开阴唇，正面展示给"..npc1.Name.."看，“在的主人，母狗的贱狗老公也没碰过，母狗的膜是专门留给主人的。”\n"..npc1.Name.."一脚踢在她的屄上，“你这烂屄的膜也配留给我，去，自己拿银子捅烂了再像狗一样跪到那儿给老子操。”\n“是。”"..npc2.Name.."用地上的碎银子插破的自己的处女膜，而后跪着，等待着"..npc1.Name.."的临幸。"..npc1.Name.."见这骚婊子这般淫贱，再也按捺不住心头欲火，拍了拍她的屁股，便将鸡巴插了进去。待云雨将歇之时——“啊，主人射进来吧，我要给主人生孩子，求求主人了。”\n"..npc2.Name.."淫叫着恳求"..npc1.Name.."。“给我生孩子，那你丈夫呢？”"..npc1.Name.."停了下来，坏笑着问。“他，他不配，主人放心，他的精液以后不会射进我的骚屄，母狗不会让他碰的，母狗只属于主人一个人……啊……哦，谢谢主人……啊……”"..npc2.Name.."最终感受到一股滚烫射进了自己的淫穴，强烈的刺激之下，骚水也喷涌而出，“好……好爽，主人。”\n\n"..npc1.Name.."又递上了些许银两，将鸡巴在她脸上蹭了蹭，从储物戒中拿出一条贞操带，“你，不错，是条好狗。喏，把这个戴上，以后每月都有赏赐。”\n\n"..npc2.Name.."得了赏，欢喜的戴上带子，扭着屁股磕头，“谢主人赏，贱奴的骚屄永远只属于主人。”\n\n突然之间，"..npc2.Name.."觉得身下凉凉的，方才戴上的贞操带竟已消失不见，细看之下，小腹下方竟多了一处淫纹图案——“这是我独门的贞操咒印，无人能解，日后你的穴口只有接触到我的阳具，才会张开，否则只有针孔大小，他人精液也无法流入。”\n\n"..npc2.Name.."听闻自己的贞操带竟是永久的，心中激动，自己果真永远属于主人了，看着小腹的淫纹与紧贴着的屄缝，好想主人干我。\n身下的淫水已然泛滥，在地上纵横流淌。\n\n事毕，"..npc2.Name.."成为了"..npc1.Name.."的女奴隶，"..npc2.Name.."获得银两20万两，"..npc2.Name.."获得贞操咒印，"..npc1.Name.."获得元阴落红。")
						npc1:AddModifier("Qian");
						npc2:AddModifier("Qian");
						npc2.PropertyMgr:AddFeature("Pogua");
						npc2:AddModifier("Zhenchaosuo");
						npc1:AddModifier("Diyidixue");
						npc2:AddModifier("XianzheCD");
						npc1:AddModifier("XianzheCD");
						local WDQ = npc1.PropertyMgr:FindModifier("Qian")
						local DDQ = npc2.PropertyMgr:FindModifier("Qian")
						WDQ:UpdateStack(-200001);
						DDQ:UpdateStack(199999);
						npc1.PropertyMgr.RelationData:AddRelationShip(npc2,"Luding2");
						npc1.PropertyMgr.RelationData:AddRelationShip(npc2,"Chunv");
						npc1.LuaHelper:DropAwardItem("Item_Nvxiuluohong",1);
						return false;
						end
						if Dfxg == CS.XiaWorld.g_emJHNpc_Feature.Greedy and npc1.LuaHelper:GetModifierStack("Qian") >= 100000 and npc2.PropertyMgr:CheckFeature("Pogua") == true then--主角10W贪婪非处
						me:AddMsg(""..npc1.Name.."拿出两张银票递给"..npc2.Name.."，向她表达了双修的愿望。\n"..npc2.Name.."看着银票，足有千两之多，心道这也不少了，自从我跟了那个死鬼，就没过过一天好日子，银钱哪里够使的，心中刚一盘算，便将银票一把攥在了手中，谨慎的看了看四周，暗道，“跟我来。”\n二人来到"..npc2.Name.."的卧房，"..npc2.Name.."含饴弄箫之际，双手也未闲着，拢、捻、捏、划，挑动着"..npc1.Name.."的春袋、双乳、后背。\n"..npc1.Name.."舒爽万分，心中却仍有些担忧，“好仙子，"..Spouse.Name.."今日去哪里了，不会回来吧。”“蹦，”"..npc2.Name.."吐出巨大的阳物，“好好地提他干嘛，你就放点心吧，今天没人打扰我们的好事的。”\n而后一路向上舔弄着，精湛的口技弄得"..npc1.Name.."意乱神迷。\n“还有更爽更刺激的，要玩吗？”"..npc2.Name.."笑得妩媚，"..npc1.Name.."只顾不住点头。\n“愣着干嘛，加钱啊。”"..npc2.Name.."握着他的阳物，白了他一眼。\n“哦……哦哦。”"..npc1.Name.."似是被下了降头，又乖乖的从储物戒中拿出两张银票。\n"..npc2.Name.."银钱到手，笑得开心，“我告诉你啊，你今儿这钱花的不亏，我那死鬼老公我还没这样伺候过呢。”\n"..npc2.Name.."蹲在他的身后，舌尖轻挑后庭，除去秽物后，将后庭湿润，香舌团作一股，向更深处探去。\n“啊……呼……”"..npc1.Name.."忍不住叫出声来，“仙子，仙子好厉害……真是美极了……”“安啦，还有更舒服的呢。\n”波推、骑乘……一整套做下来，"..npc1.Name.."身心愉悦。临走之时，"..npc1.Name.."又给了"..npc2.Name.."一些银子，“仙子以后莫要忘了我。”\n"..npc2.Name.."获得银两3000两。");
						npc1:AddModifier("Qian");
						npc2:AddModifier("Qian");
						npc2:AddModifier("XianzheCD");
						npc1:AddModifier("XianzheCD");
						local WDQ = npc1.PropertyMgr:FindModifier("Qian")
						local DDQ = npc2.PropertyMgr:FindModifier("Qian")
						WDQ:UpdateStack(-3001);
						DDQ:UpdateStack(2999);
						return false;
						end
						if Dfxg == CS.XiaWorld.g_emJHNpc_Feature.Greedy and npc1.LuaHelper:GetModifierStack("Qian") >= 100000 and npc2.PropertyMgr:CheckFeature("Pogua") ~= true then--主角10W贪婪处女
						me:AddMsg(""..npc1.Name.."拿出两张银票递给"..npc2.Name.."，向她表达了双修的愿望。\n"..npc2.Name.."看着这两张银票，心道这人也算出手阔绰了，只是，我和"..Spouse.Name.."虽已成婚却还未曾欢好过，这般做法，也太不要脸面了。\n未理那人，转身便要离去，"..npc1.Name.."忙道，“别走啊，价钱好商量的。”又拿出了几张银票挥手向"..npc2.Name.."示意。\n"..npc2.Name.."心中略作挣扎，却仍是不愿舍了自己的元阴之身，表面上走得坚决，头也不回。看着"..npc2.Name.."的身影渐远，"..npc1.Name.."嘴上恨恨骂着，“臭婊子，装什么纯，不就嫌老子钱少吗……”。");
						return false;
						end
						if Dfxg == CS.XiaWorld.g_emJHNpc_Feature.Greedy and npc1.LuaHelper:GetModifierStack("Qian") < 100000 then--主角小于10W贪婪女
						me:AddMsg(""..npc1.Name.."捧着一株灵草，向"..npc2.Name.."表达了想要双修的愿望。\n"..npc2.Name.."轻蔑的扫了一眼他的穿着打扮，“就你？也不掂量掂量自己，我老公可是九华村首富，就是用钱砸也把你砸死了。再说了，我就是给富豪舔脚、当肉便器，也不愿让你这穷逼碰一根手指头，快滚吧。”\n"..npc2.Name.."说完嗤笑一声便离去了，"..npc1.Name.."呆立在原地，低着头两眼通红，手中的灵草也打了蔫似的弯了下来。");
						return false;
						end
						if Dfxg == CS.XiaWorld.g_emJHNpc_Feature.Weak and npc1.LuaHelper:GetGLevel() - 5 > npc2.LuaHelper:GetGLevel() and npc2.PropertyMgr:CheckFeature("Pogua") == true then--软弱非处1
						me:AddMsg(""..npc1.Name.."当面直截了当的向"..npc2.Name.."提出了双修的要求。\n"..npc2.Name.."心中惊惧，自己已为人妇，怎能答应，可"..npc1.Name.."修为高绝，若是惹恼了他，全家也要跟着遭殃。\n她低头咬着嘴唇，羞红了脸，“那，你可不要声张出去，而且，而且说好了，就这一次。”\n\n"..npc1.Name.."当街揉捏着她的屁股，“别废话了，走吧，你也不想被别人看到不是吗？”\n\n床榻之上，"..npc2.Name.."顺从的给"..npc1.Name.."呵着卵子——“好了，给爷舔舔屁眼。”\n怎么这样……那里那么脏……我给老公就连口交都没做过呢。“\n爷，要不，我伺候您洗洗，然后再给您舔？”"..npc2.Name.."陪着笑小心的试探。\n"..npc1.Name.."大怒，“你个贱婊子还嫌爷脏？”抓起"..npc2.Name.."的头发，将她的脑袋直埋进了尿桶之中，任她挣扎求饶也不松手。\n待声息渐弱，"..npc1.Name.."将她拽出尿桶，"..npc2.Name.."大口的喘息着，咳嗽着，全然不顾满身的尿液。\n“爽吗，贱屄？”"..npc1.Name.."用脚踩着她的奶子。\n“爽，爽……求爷饶了贱屄吧，贱屄刚才犯贱，贱屄知道错了。”"..npc2.Name.."不住的求饶。\n"..npc1.Name.."递给"..npc2.Name.."一件像笔一样的法器，“这是以龙血为墨制成的灵纹法器，纹在身上就洗不掉了，也是为了让你记住自己的身份，去，自己给你屄两边纹上‘贱屄’两个字。”\n“是，是，谢主人赐名。”"..npc2.Name.."乖乖的给自己刺字。\n“贱屄，你老公以后看见这两个字怎么办啊？”"..npc1.Name.."笑着问。\n“贱屄就说，这是主人赏赐的，贱屄以后就是主人的玩具，让贱老公以后再也不能碰了。”\n"..npc2.Name.."答得利索，"..npc1.Name.."想收拾竟都找不到由头，无奈之下递出一块木板，“你那烂屄太松了，爷看着就倒胃口，拿着，狠狠的扇自己那烂屄，边扇边报数，每次报数后面都要接一声‘谢主人赏’，记住了吗？”\n“是，贱屄记得了。”"..npc2.Name.."接过木板，用力向自己下体打去，“一，谢主人赏……”\n\n二人在"..npc1.Name.."的洞府玩了足足三天三夜，"..npc2.Name.."一身湿哒黏腻，红肿的小穴处不断往外淌着白浊的液体。除私处的刺青外，"..npc2.Name.."的阴部、乳头也被穿了星髓制成的奴环。\n“回去吧，让你老公看看你现在的贱样。”\n“是。”"..npc2.Name.."四肢着地，像狗一样一步一步往家中爬去。\n"..npc1.Name.."情绪+20,"..npc2.Name.."身体多处受伤（可治愈），"..npc2.Name.."成为了"..npc1.Name.."的女奴隶。");
						npc1.PropertyMgr.RelationData:AddRelationShip(npc2,"Luding2");
						npc2.LuaHelper:AddDamageRandomPart(3,"Cut1",0.5, "来自性虐鞭挞割裂伤");
						npc2.LuaHelper:AddDamage("Scar","Hips",0.01, "真气纹身，上书“贱屄”字样。");
						npc2:AddModifier("XianzheCD");
						npc1:AddModifier("XianzheCD");
						return false;
						end
						if Dfxg == CS.XiaWorld.g_emJHNpc_Feature.Weak and npc1.LuaHelper:GetGLevel() - 5 > npc2.LuaHelper:GetGLevel() and npc2.PropertyMgr:CheckFeature("Pogua") ~= true then--软弱处1
						me:AddMsg(""..npc1.Name.."当面直截了当的向"..npc2.Name.."提出了双修的要求。\n"..npc2.Name.."心中惊惧，自己已为人妇了，且结婚这些日子了老公还没碰过自己的身子，怎能让外人就这般污了清白。\n可"..npc1.Name.."修为高绝，若是惹恼了他，自己全家也要跟着遭殃。\n"..npc2.Name.."深陷惶恐之中，不知该如何是好，"..npc1.Name.."可不管那么许多，手已经按在了她的屁股上，不住地揉捏着，“别想了，你逃不了的。”\n\n"..npc1.Name.."带着她来到自己的洞府，"..npc2.Name.."平日里也看过些图册，心想不论做出何种牺牲，也要保住自己的处女元阴，不能让老公知晓自己失身之事，于是跪着面向"..npc1.Name.."的巨龙，生涩的舔吸着。\n侍弄了有一刻钟，"..npc1.Name.."却一点射精的意思也没有，"..npc2.Name.."的小口已酸涩的不行了，喘了口气，想要歇息片刻。\n"..npc1.Name.."笑着，“我知你还是处子，若你将我伺候舒服了，想要保住身子也不是不行。”\n而后手扶着鸡巴拍打她的脸，“记住了，别光顾着这根东西，蛋蛋、屁眼，都给老子仔细舔着。”\n在此之前，"..npc2.Name.."甚至还从未看到过男人的下体，与老公寻常的肢体接触也几乎没有，此刻却像是久历皮肉生意的老姐儿，客提的什么要求都不皱一下眉，顺从的给"..npc1.Name.."舔着菊穴，秽物也都吃了下去。\n\n二人在"..npc1.Name.."的洞府玩了足足三天三夜，"..npc2.Name.."全力的陪侍令"..npc1.Name.."心神愉悦，无论什么要求只要以破处作为要挟，"..npc2.Name.."都会乖乖答应。\n虽未取她的元阴落红，"..npc1.Name.."自觉也算玩得尽兴了。\n"..npc2.Name.."原本的衣衫已全然毁坏了，如今只紧裹着"..npc1.Name.."的长袍往家中走去，"..Spouse.Name.."迎面，却不知"..npc2.Name.."的菊穴、口中均含着"..npc1.Name.."的浓精，乳头、臀部也被刻上了有"..npc1.Name.."的母狗……");
						npc1.PropertyMgr.RelationData:AddRelationShip(npc2,"Luding2");
						npc2.LuaHelper:AddDamage("Scar","Hips",0.01, "真气纹身，上书“"..npc1.Name.."的母狗”字样。");
						npc2:AddModifier("XianzheCD");
						npc1:AddModifier("XianzheCD");
						return false;
						end
						if Dfxg == CS.XiaWorld.g_emJHNpc_Feature.Weak and npc1.LuaHelper:GetGLevel() > npc2.LuaHelper:GetGLevel() and npc2.PropertyMgr:CheckFeature("Pogua") == true then--软弱非处2
						me:AddMsg(""..npc1.Name.."当面直截了当的向"..npc2.Name.."提出了双修的要求。\n"..npc2.Name.."心中不悦，明知我是有丈夫的人，做了这事，日后脸面岂不都要丢尽了。可他修为高我许多，若不应下，又怕他发难。\n"..npc2.Name.."佯作羞色，表面上答应了下来，一路随着"..npc1.Name.."向他的洞府而行。\n路上，趁"..npc1.Name.."驾驭飞行法器灵力不济之际，暗施法术，猛然偷袭。不料"..npc1.Name.."早有防备，灵宝护体，竟毫发无伤，反将"..npc2.Name.."用法宝缚住，带回了洞府。\n\n“臭婊子，他妈还敢害老子？”"..npc1.Name.."扇了她两巴掌，看着她战栗发抖的样子既觉爽快，又觉得有些不够过瘾，“你他妈的，爷给你洗洗脸。”\n"..npc1.Name.."抓起"..npc2.Name.."的头发，将她的脑袋直埋进了尿桶之中，任她挣扎求饶也不松手。\n待声息渐弱，"..npc1.Name.."将她拽出尿桶，"..npc2.Name.."大口的喘息着，咳嗽着，全然不顾满身的尿液。\n“爽吗，贱屄？”"..npc1.Name.."用脚踩着她的奶子。\n“爽，爽……求爷饶了贱屄吧，贱屄刚才犯贱，贱屄知道错了。”"..npc2.Name.."不住的求饶。\n"..npc1.Name.."递给"..npc2.Name.."一件像笔一样的法器，“这是以龙血为墨制成的灵纹法器，纹在身上就洗不掉了，也是为了让你记住自己的身份，去，自己给你屄两边纹上‘贱屄’两个字。”\n“是，是，谢主人赐名。”"..npc2.Name.."乖乖的张开双腿给自己刺字。\n"..npc1.Name.."看得有趣，“贱屄，你老公以后看见这两个字怎么办啊？”\n“贱屄就说，这是主人赏赐的，贱屄以后就是主人的玩具，让贱老公以后再也不能碰了。”\n"..npc1.Name.."答得利索，"..npc2.Name.."想收拾竟都找不到由头，无奈之下递出一块木板，“你那烂屄太松了，爷看着就倒胃口，拿着，狠狠的扇自己那烂屄，边扇边报数，每次报数后面都要接一声‘谢主人赏’，记住了吗？”\n“是，贱屄记得了。”"..npc2.Name.."接过木板，用力向自己下体打去，“一，谢主人赏……”……\n\n“主人打你是为了你好，知道吗，省的整天没事动坏心眼子。”"..npc1.Name.."把脚伸了出去，让跪趴着的"..npc2.Name.."用香舌伺候着。\n“知道了，谢谢主人打奴奴，奴奴喜欢主人打我。”"..npc2.Name.."顺从的舔着"..npc1.Name.."的脚底，扭动着高高撅起的翘臀。\n"..npc1.Name.."手里拿着长鞭，抽打着"..npc2.Name.."的屁股，忽觉翘挺的屁股上一片白，打起来也没什么意思。\n拿起灵纹法器在"..npc2.Name.."的屁股上又刺了“贱畜母狗"..npc2.Name.."”几个大字。\n粉涨的屁股将龙血刺青映得殷红，其上鞭痕交错，"..npc1.Name.."看着自己的成果不禁色欲大盛，怒龙高抬，扶着丰润的臀部挺身而入。\n二人在"..npc1.Name.."的洞府玩了足足三天三夜，"..npc2.Name.."一身湿哒黏腻，红肿的小穴、后庭都不断往外淌着白浊的液体。\n除私处和臀部的刺青外，"..npc2.Name.."的阴部、乳头也被穿了星髓制成的奴环。“回去吧，让你老公看看你现在的贱样。”\n“是。”"..npc2.Name.."四肢着地，像狗一样一步一步往家中爬去。\n"..npc2.Name.."身体多处受伤（可治愈），"..npc2.Name.."成为了"..npc1.Name.."的女奴隶。");
						npc1.PropertyMgr.RelationData:AddRelationShip(npc2,"Luding2");
						npc2.LuaHelper:AddDamageRandomPart(3,"Cut1",0.5, "来自性虐鞭挞割裂伤");
						npc2.LuaHelper:AddDamage("Scar","Hips",0.01, "真气纹身，上书“贱屄”字样。");
						npc2:AddModifier("XianzheCD");
						npc1:AddModifier("XianzheCD");
						return false;
						end
						if Dfxg == CS.XiaWorld.g_emJHNpc_Feature.Weak and npc1.LuaHelper:GetGLevel() > npc2.LuaHelper:GetGLevel() and npc2.PropertyMgr:CheckFeature("Pogua") ~= true then--软弱处2
						me:AddMsg(""..npc1.Name.."当面直截了当的向"..npc2.Name.."提出了双修的要求。\n"..npc2.Name.."念及自己还是处子之身，结婚这些日子以来，丈夫还未曾与自己欢好过，若与他人有染，这往后的日子可怎么过啊。\n她暗施法力，探查"..npc1.Name.."的修为境界，发现"..npc1.Name.."修为高出自己不少，此刻若不应下，又怕他直行那不轨之事，自己可就难以应对了。\n"..npc2.Name.."佯作羞色，表面上答应了下来，一路随着"..npc1.Name.."向他的洞府而行。\n路上，趁"..npc1.Name.."驾驭飞行法器灵力不济之际，祭出法宝，猛然偷袭。\n不料"..npc1.Name.."早有防备，灵宝护体，竟毫发无伤，反将"..npc2.Name.."用法宝缚住，带回了洞府。\n\n“臭婊子，他妈还敢害老子？”"..npc1.Name.."扇了她两巴掌，看着她战栗发抖的样子既觉爽快，又觉得有些不够过瘾，“你他妈的，爷给你洗洗脸。”\n"..npc1.Name.."抓起"..npc2.Name.."的头发，将她的脑袋直埋进了尿桶之中，任她挣扎求饶也不松手。\n待声息渐弱，"..npc1.Name.."将她拽出尿桶，"..npc2.Name.."大口的喘息着，咳嗽着，全然不顾满身的尿液。\n“爽吗，贱屄？”"..npc1.Name.."用脚踩着她的奶子。\n“爽，爽……求爷饶了贱屄吧，贱屄刚才犯贱，贱屄知道错了。”"..npc2.Name.."不住的求饶。\n"..npc1.Name.."递给"..npc2.Name.."一件像笔一样的法器，“这是以龙血为墨制成的灵纹法器，纹在身上就洗不掉了，也是为了让你记住自己的身份，去，自己给你屄两边纹上‘贱屄’两个字。”\n“是，是，谢主人赐名。”"..npc2.Name.."乖乖的给自己刺字。\n"..npc1.Name.."欣赏着"..npc2.Name.."粉嫩的蜜穴，觉得这两个字真是美妙极了，“把腿分开，用手掰开你那贱屄，让也好好看看。”\n“是。”"..npc2.Name.."将腿张到最大，手指在左右两侧按住小阴唇，将美穴毫无保留的展示出来。\n“这是什么，”"..npc1.Name.."看着她小穴口半透明的薄膜，“没想到你还是个雏？”\n“是，是，”"..npc2.Name.."被弄得怕了，忙想着该怎么回话，“贱屄的身子就是主人的，之前老公一直想操我我都不答应，贱屄知道，贱屄的膜要留给主人，求主人给贱屄破处。”\n“这么想让我操啊，那你自己来吧。”"..npc1.Name.."躺在床上，摇动着鸡巴。\n“是，谢谢主人操贱屄，贱屄太高兴了。”"..npc2.Name.."骑在"..npc1.Name.."的腰间，手扶着那粗长的阳物，对准小穴，缓缓地坐了下去。\n\n之后，二人在"..npc1.Name.."的洞府玩了足足三天三夜，"..npc2.Name.."一身湿哒黏腻，纹着刺青红肿的小穴处不断往外淌着白浊的液体。\n"..npc1.Name.."看着躺在那里浑身赤裸的"..npc2.Name.."，心念一动，捏起咒诀，施了一道法术，"..npc2.Name.."的小腹下方忽的显现了一幅淫纹图案，“你不是说你的贱屄属于我吗？这是我独门的贞操秘术，你看看你的屄，现在是不是小的像针眼一样。你老公要想操，以后还得先问问我。”\n"..npc2.Name.."成为了"..npc1.Name.."的女奴隶，"..npc2.Name.."获得贞操咒印。");
						npc1.PropertyMgr.RelationData:AddRelationShip(npc2,"Luding2");
						npc1.PropertyMgr.RelationData:AddRelationShip(npc2,"Chunv");
						npc2.PropertyMgr:AddFeature("Pogua");
						npc2:AddModifier("XianzheCD");
						npc1:AddModifier("XianzheCD");
						return false;
						end
						if Dfxg == CS.XiaWorld.g_emJHNpc_Feature.Weak and npc1.LuaHelper:GetGLevel() <= npc2.LuaHelper:GetGLevel() then--软弱但是比我强或者相同
						me:AddMsg(""..npc1.Name.."当面直截了当的向"..npc2.Name.."提出了双修的要求。\n"..npc2.Name.."心中不悦，明知我是有丈夫的人还屡次前来纠缠于我，暗施法力查探了一番"..npc1.Name.."的修为境界，发现不过尔尔，便施法宝护体，果断回绝道，“你再这般纠缠，休怪我不客气了。”\n"..npc1.Name.."看她祭出这等绝品法宝，心生胆怯，连忙退去了。");
						return false;
						end
						if Dfxg == CS.XiaWorld.g_emJHNpc_Feature.Naive and npc1.LuaHelper:GetCharisma() > 9 and npc2.PropertyMgr:CheckFeature("Pogua") == true then--天真非处，我魅力大于9
						me:AddMsg(""..npc1.Name.."朝着"..npc2.Name.."露出微笑，委婉的向"..npc2.Name.."表露出想与之双修的愿望。\n"..npc2.Name.."看着眼前的男子，高冠清扬，气格超逸不群，风清骨峻而令人心向往之，她甚至都没听清"..npc1.Name.."说了什么。\n"..npc1.Name.."笑得温暖和煦，大方的又向她再次倾吐心声，"..npc2.Name.."感觉自己的心都要跳了出来，这般俊美的男子竟然会对我心生爱慕，羞怯之下，竟不知如何言语，面色涨得通红，连忙双手捂脸，以饰娇羞。\n她这般举措落在"..npc1.Name.."眼中，倒也觉得纯真可爱，偏又生了几分怜爱。\n\n"..npc1.Name.."与她相拥，欲低头深吻，"..npc2.Name.."看着那绝美的面庞逐渐沉沦，就在双唇将触之际，"..npc2.Name.."一个激灵，“我，我结婚了的，我不能对不起他。”伸手欲将他推开。\n"..npc1.Name.."却抱得更紧，“我们就这一次，他不会知道的。我知道，你也想要的。”\n"..npc1.Name.."在她耳畔轻语，温热的气息湿润了她的心房，她感觉耳朵、心里都痒痒的，她从未有过这般感受。\n"..npc1.Name.."用手探向她的裙底，抚弄着，“瞧，你都湿了不是吗？闭上眼睛，放松自己，都交给我就好了。”\n"..npc2.Name.."闭眼，默默的喘息着，"..Spouse.Name.."在她的心中已然消散，脑海中全是"..npc1.Name.."的天人一般的容颜，他的声音、他的气息、他身体的温度都已铭刻在了她的心里。\n她感觉自己是在天上，暖暖的，也有云雾的湿气，赏着世间绝景，或许此刻的自己是这个世界上最幸福的人了吧。\n云消雨歇，"..npc1.Name.."吻在她的额头，“宝贝，我走了。”\n"..npc2.Name.."拽着他的袖子，“可，可不可以不要走……”\n“就当这是一场梦，好吗。”");
						npc1.PropertyMgr.RelationData:AddRelationShip(npc2,"Lover");
						npc2:AddModifier("XianzheCD");
						npc1:AddModifier("XianzheCD");
						return false;
						end
						if Dfxg == CS.XiaWorld.g_emJHNpc_Feature.Naive and npc1.LuaHelper:GetCharisma() > 9 and npc2.PropertyMgr:CheckFeature("Pogua") ~= true then--天真处，我魅力大于9
						me:AddMsg(""..npc1.Name.."朝着"..npc2.Name.."露出微笑，委婉的向"..npc2.Name.."表露出想与之双修的愿望。\n"..npc2.Name.."看着眼前的男子，高冠清扬，气格超逸不群，风清骨峻而令人心向往之，她甚至都没听清"..npc1.Name.."说了什么。\n"..npc1.Name.."笑得温暖和煦，大方的又向她再次倾吐心声，"..npc2.Name.."感觉自己的心都要跳了出来，这般俊美的男子竟然会对我心生爱慕，羞怯之下，竟不知如何言语，面色涨得通红，连忙双手捂脸，以饰娇羞。\n她这般举措落在"..npc1.Name.."眼中，倒也觉得纯真可爱，偏又生了几分怜爱。\n\n"..npc1.Name.."与她相拥，欲低头深吻，"..npc2.Name.."看着那绝美的面庞逐渐沉沦，就在双唇将触之际，"..npc2.Name.."一个激灵，突然想起自己的丈夫，猛地将"..npc1.Name.."推开。\n婚礼当日，"..Spouse.Name.."被灌得大醉，难行周公之礼，后来二人竟也没顾得上，以致今日她还是处子之身。\n“我，我是有丈夫的，我们不能这样。”"..npc2.Name.."忙说。\n"..npc1.Name.."不管不顾，上前将她紧紧的抱在怀里，“亲爱的，你那丈夫，"..Spouse.Name.."整日在外花天酒地，他可曾将你视作妻子。我爱煞了你，我的心中只有你一人，我不想你受委屈，跟我走吧。”\n"..npc1.Name.."的语气坚决，像一块大石撞开了她的心防，她默默地流泪，闭眼，不再想其他。\n“是了，相信我，我会给你幸福的，慢慢放松，都交给我就好了。”\n"..npc1.Name.."轻抚着她的后背，低头吻上她的樱唇。\n"..npc2.Name.."心里甜丝丝的，还有些痒痒的，似是在期待着什么，此刻，他的声音、他的气息、他身体的温度都已铭刻在了她的心里。\n她静静的感受着，她感觉自己仿若是在天上，暖暖的，也有云雾的湿气，赏着世间的绝景，或许此时此刻自己是这个世界上最幸福的人了吧。\n\n一夜欢愉，梦醒时分却不见情郎身影。\n“骗子，”她流着泪，咬着手帕，心下却难生恨意。\n“玲珑骰子安红豆，入骨相思知不知。”");
						npc2.PropertyMgr:AddFeature("Pogua");
						npc1.PropertyMgr.RelationData:AddRelationShip(npc2,"Lover");
						npc2:AddModifier("XianzheCD");
						npc1:AddModifier("XianzheCD");
						return false;
						end
						if Dfxg == CS.XiaWorld.g_emJHNpc_Feature.Naive and npc1.PropertyMgr.RelationData:IsRelationShipWith("Lover",npc2) == true and npc2.PropertyMgr:CheckFeature("Pogua") == true then--天真非处，是恋人
						me:AddMsg(""..npc2.Name.."不喜拘着自己在那漫漫仙途之上求索，自然畅达或是她的本心所求，故而无事时常逛逛坊市，看看那些娇艳的灵植，寻些古物和一些有趣的小玩意儿，打发打发时间。\n只是，这几个月来，"..npc1.Name.."也总是在坊市中出现，送她一些她打心眼儿里喜欢的东西。\n开始她觉得许是碰巧遇到了，但这么些日子一直如此，再呆的人也明白了，她本不欲与"..npc1.Name.."再有往来，但"..npc1.Name.."话说得诚恳，她也不忍伤了"..npc1.Name.."的面子。\n赶巧，今日便又碰到了——“"..npc2.Name.."仙子，我知你喜爱那些素雅的花草，前些日子我在古书之中查到南荒之地生一种名为‘荀草’的仙草，看到时我就想，仙子一定喜欢的，这不，我赶紧给你请了来。”\n南荒距此何止万里，"..npc2.Name.."看着"..npc1.Name.."手中捧着的仙草，形质如兰，散发着浓郁的仙灵之气，枝叶青翠欲滴，“传闻荀草有姿容焕颜之效，你是想让我吃了它吗？”"..npc2.Name.."笑着问。\n“仙子容颜，合三界众生之美亦难及半分，何须吃它，用它来衬仙子的倾世之貌才是最好不过的了。”\n“确实不错，你有心了。”"..npc2.Name.."收下仙草，转身欲离去——“仙子，我……”\n"..npc2.Name.."听到他吞吞吐吐的劝拦，回眸，“你可知道，我是有丈夫的。”\n“我知道，可，可我……我还是喜欢你……我想和你在一起！”"..npc1.Name.."最终撕扯着喊出自己的心声。\n“我知道了，你小声些，跟我来吧。”\n\n"..npc2.Name.."家中，"..npc2.Name.."双手搭在"..npc1.Name.."赤裸的肩上，“你知道吗，在遇到你之前，我不知道什么是爱情。如今，这个世界，我感受得最深的，是你的温暖，是你炽热的心。\n“那我们再来一次？”\n“可我老公要回来了。”\n“来我家吧。”");
						npc2:AddModifier("XianzheCD");
						npc1:AddModifier("XianzheCD");
						return false;
						end
						if Dfxg == CS.XiaWorld.g_emJHNpc_Feature.Naive and npc1.PropertyMgr.RelationData:IsRelationShipWith("Lover",npc2) == true and npc2.PropertyMgr:CheckFeature("Pogua") ~= true then--天真处，是恋人
						me:AddMsg(""..npc2.Name.."不喜拘着自己在那漫漫仙途之上求索，自然畅达或是她的本心所求，故而无事时常逛逛坊市，看看那些娇艳的灵植，寻些古物和一些有趣的小玩意儿，打发打发时间。\n只是，这几个月来，"..npc1.Name.."也总是在坊市中出现，送她一些她打心眼儿里喜欢的东西。\n开始她觉得许是碰巧遇到了，但这么些日子一直如此，再呆的人也明白了，她本不欲与"..npc1.Name.."再有往来，但"..npc1.Name.."话说得诚恳，她也不忍伤了"..npc1.Name.."的面子。\n赶巧，今日便又碰到了——“仙子，我知你喜爱那些素雅的花草，前些日子我在古书之中查到南荒之地生一种名为‘荀草’的仙草，看到时我就想，仙子一定喜欢的，这不，我赶紧给你请了来。”\n南荒距此何止万里，"..npc2.Name.."看着"..npc1.Name.."手中捧着的仙草，形质如兰，散发着浓郁的仙灵之气，枝叶青翠欲滴，“传闻荀草有姿容焕颜之效，你是想让我吃了它吗？”"..npc2.Name.."笑着问。\n“仙子容颜，合三界众生之美亦难及半分，何须吃它，用它来衬仙子的倾世之貌才是最好不过的了。”\n“确实不错，你有心了。”"..npc2.Name.."收下仙草，转身欲离去——“仙子，我……”\n"..npc2.Name.."听到他吞吞吐吐的劝拦，回眸，“你可知道，我是有丈夫的。”\n“我知道，可，可我……我还是喜欢你……我想和你在一起！”"..npc1.Name.."最终撕扯着喊出自己的心声。\n“我知道了，你小声些，跟我来。”\n\n"..npc2.Name.."家中，"..npc2.Name.."拉着"..npc1.Name.."的手，“我之前从未爱过任何人，是你给了我温暖，你答应我，要真心待我，不能负我，不然……”\n"..npc1.Name.."吻上她的唇，轻啄，“我的心中永远只有你一人，天涯海角，碧落黄泉，至死相随。”\n二人拥吻，"..npc1.Name.."急不可耐的除着衣物。\n“"..npc1.Name.."，你一会儿慢一些，我……我还是处子。”\n"..npc1.Name.."一愣，心下万份惊喜，埋头舔弄着"..npc2.Name.."的私处，看到了那层小小的膜。\n“他没和你……”\n“嗯，我不喜欢他，讨厌他碰我，每次都借故推脱掉了。”\n二人怀着惊喜、激动又带有几分期待的心情共赴巫山，几度重楼，事后相约他日再诉绵缠。");
						npc2:AddModifier("XianzheCD");
						npc1:AddModifier("XianzheCD");
						return false;
						end
						if Dfxg == CS.XiaWorld.g_emJHNpc_Feature.Naive then--天真拒绝
						me:AddMsg(""..npc2.Name.."平素喜逛坊市，可最近出门总有一个傻小子凑近来，要么没话找话硬找她聊些什么，要么非要送她些什么东西。\n这不，出门又碰到了——“仙子，我……”\n“这位公子，你我非亲非故，我又早已嫁作他人之妇，你再这般纠缠不清，我可就要告诉我家官人了。”"..npc2.Name.."不再顾忌"..npc1.Name.."的面子，话讲的坚决，离去的也坚决。\n"..npc1.Name.."看着她的背影，攥着手中的花，悻悻然埋头蹲在了地上。");
						return false;
						end
						if Dfxg == CS.XiaWorld.g_emJHNpc_Feature.Apathy and Wfxg == CS.XiaWorld.g_emJHNpc_Feature.Tenacity and npc1.LuaHelper:GetGLevel() > npc2.LuaHelper:GetGLevel() and npc2.PropertyMgr:CheckFeature("Pogua") == true then--非处冷，男坚
						me:AddMsg(""..npc1.Name.."看"..npc2.Name.."身形窈窕、姿态妍丽，心动不已，要干得她欲仙欲死的念头一下就生了起来，胯下顿时怒龙高抬。\n"..npc1.Name.."毫不掩饰，“这位仙子，可愿与某共度春宵？”\n"..npc2.Name.."性子冷清，男女情爱之事，既不懂，也从未关心过。\n当初家中长辈只当她还未开窍，怕她嫁与人家多要吃亏，故而特以数万灵石聘了百名仙媒，着意为她寻了一家世清白、忠厚老实的修士嫁了。\n"..Spouse.Name.."婚后待她极好，她感受的到，但不知该如何表达，唯有在与"..Spouse.Name.."的夫妻生活中尽量配合了。\n可她不喜掩饰，"..Spouse.Name.."操弄时候，她是不舒服的，"..Spouse.Name.."也看得出来，可"..Spouse.Name.."不仅不怪她，还更多的照顾她的情绪。\n"..npc2.Name.."觉得自己亏欠丈夫许多，着实称不上一个好妻子，但那是因自己天性如此，可若是失贞，那也太对不起他了。\n\n"..npc2.Name.."面若冰霜，对"..npc1.Name.."连一个眼神都没有，错身便走了过去。\n这臭婊子，老子让你装，"..npc1.Name.."当着众人，只觉脸面无光，心下恼怒极了，暗施法力，在她身上留下了一道寻踪印记。\n待"..npc2.Name.."出城后，"..npc1.Name.."祭出诸般法器，不消片刻便将"..npc2.Name.."击败。\n“贱货，让你给老子装！”"..npc1.Name.."用鞋底踩着"..npc2.Name.."的脸颊，手握马鞭，"..npc2.Name.."的衣物已做褴褛状，再也包裹不住那诱人的胴体。\n"..npc2.Name.."不知他为何这般恼火，故而在凌辱之下，也未曾言语。\n“真当自己是仙女了？啊？”"..npc1.Name.."以为"..npc2.Name.."仍在故作高傲，心中原本泄出的怒火又蹭蹭的窜了起来。\n“就算你是仙女，在老子这儿，也得变成吃屎喝尿的狗。”"..npc1.Name.."掏出阳物对准"..npc2.Name.."的俏脸——“呲……”一边尿一边左右摇摆着阳物，觉得有趣极了。\n"..npc2.Name.."不懂他为什么笑，只是觉得这样很脏，无奈之下闭上了眼睛。\n"..npc1.Name.."并未理会，看着眼前的尿人，自在畅怀，用阳物在她脸上拍打着，“来，给爷舔干净。”\n他可能只是想出气吧，虽然不知道哪里惹到他了，但"..npc2.Name.."觉得这并不有损自己的清白，便问，“舔干净了就放我走吗？”\n“啊……嗯。”"..npc1.Name.."眼睛看向别处，应得模糊。\n"..npc2.Name.."以为他答应了，舔得仔细。\n“想不到你这妞还挺浪啊。”\n"..npc2.Name.."听不懂，只顾埋首舔着。\n“好了，爷的鸡巴也硬了，躺那儿，自己把腿掰开。”\n"..npc2.Name.."呆愣，"..npc1.Name.."看她不动，上前将她抱起，长枪直刺，尽入其中。\n……\n\n次日清晨，她披着已化作一缕缕碎布的衣衫向家中走去，身下，"..npc1.Name.."的阳精与自身的淫液还在流淌着。\n她远远就看到了"..Spouse.Name.."站立在大院门口，眼泪一下就流了出来，“"..Spouse.Name.."，对不起……”\n“不哭，不哭……没事了，啊。”");
						npc2:AddModifier("XianzheCD");
						npc1:AddModifier("XianzheCD");
						return false;
						end
						if Dfxg == CS.XiaWorld.g_emJHNpc_Feature.Apathy and Wfxg == CS.XiaWorld.g_emJHNpc_Feature.Greedy and npc1.LuaHelper:GetGLevel() > npc2.LuaHelper:GetGLevel() and npc2.PropertyMgr:CheckFeature("Pogua") == true then--非处冷，男坚
						me:AddMsg(""..npc1.Name.."看"..npc2.Name.."身形窈窕、姿态妍丽，心动不已，要干得她欲仙欲死的念头一下就生了起来，胯下顿时怒龙高抬。\n"..npc1.Name.."毫不掩饰，“这位仙子，可愿与某共度春宵？”\n"..npc2.Name.."性子冷清，男女情爱之事，既不懂，也从未关心过。\n当初家中长辈只当她还未开窍，怕她嫁与人家多要吃亏，故而特以数万灵石聘了百名仙媒，着意为她寻了一家世清白、忠厚老实的修士嫁了。\n"..Spouse.Name.."婚后待她极好，她感受的到，但不知该如何表达，唯有在与"..Spouse.Name.."的夫妻生活中尽量配合了。\n可她不喜掩饰，"..Spouse.Name.."操弄时候，她是不舒服的，"..Spouse.Name.."也看得出来，可"..Spouse.Name.."不仅不怪她，还更多的照顾她的情绪。\n"..npc2.Name.."觉得自己亏欠丈夫许多，着实称不上一个好妻子，但那是因自己天性如此，可若是失贞，那也太对不起他了。\n\n"..npc2.Name.."面若冰霜，对"..npc1.Name.."连一个眼神都没有，错身便走了过去。\n这臭婊子，老子让你装，"..npc1.Name.."当着众人，只觉脸面无光，心下恼怒极了，暗施法力，在她身上留下了一道寻踪印记。\n待"..npc2.Name.."出城后，"..npc1.Name.."祭出诸般法器，不消片刻便将"..npc2.Name.."击败。\n“贱货，让你给老子装！”"..npc1.Name.."用鞋底踩着"..npc2.Name.."的脸颊，手握马鞭，"..npc2.Name.."的衣物已做褴褛状，再也包裹不住那诱人的胴体。\n"..npc2.Name.."不知他为何这般恼火，故而在凌辱之下，也未曾言语。\n“真当自己是仙女了？啊？”"..npc1.Name.."以为"..npc2.Name.."仍在故作高傲，心中原本泄出的怒火又蹭蹭的窜了起来。\n“就算你是仙女，在老子这儿，也得变成吃屎喝尿的狗。”"..npc1.Name.."掏出阳物对准"..npc2.Name.."的俏脸——“呲……”一边尿一边左右摇摆着阳物，觉得有趣极了。\n"..npc2.Name.."不懂他为什么笑，只是觉得这样很脏，无奈之下闭上了眼睛。\n"..npc1.Name.."并未理会，看着眼前的尿人，自在畅怀，用阳物在她脸上拍打着，“来，给爷舔干净。”\n他可能只是想出气吧，虽然不知道哪里惹到他了，但"..npc2.Name.."觉得这并不有损自己的清白，便问，“舔干净了就放我走吗？”\n“啊……嗯。”"..npc1.Name.."眼睛看向别处，应得模糊。\n"..npc2.Name.."以为他答应了，舔得仔细。\n“想不到你这妞还挺浪啊。”\n"..npc2.Name.."听不懂，只顾埋首舔着。\n“好了，爷的鸡巴也硬了，躺那儿，自己把腿掰开。”\n"..npc2.Name.."呆愣，"..npc1.Name.."看她不动，上前将她抱起，长枪直刺，尽入其中。\n……\n\n次日清晨，她披着已化作一缕缕碎布的衣衫向家中走去，身下，"..npc1.Name.."的阳精与自身的淫液还在流淌着。\n她远远就看到了"..Spouse.Name.."站立在大院门口，眼泪一下就流了出来，“"..Spouse.Name.."，对不起……”\n“不哭，不哭……没事了，啊。”");
						npc2:AddModifier("XianzheCD");
						npc1:AddModifier("XianzheCD");
						return false;
						end
						if Dfxg == CS.XiaWorld.g_emJHNpc_Feature.Apathy and Wfxg == CS.XiaWorld.g_emJHNpc_Feature.Tenacity and npc1.LuaHelper:GetGLevel() > npc2.LuaHelper:GetGLevel() and npc2.PropertyMgr:CheckFeature("Pogua") ~= true then--处冷，男坚
						me:AddMsg(""..npc1.Name.."见前方走来的"..npc2.Name.."身形窈窕、姿态妍丽，心动不已，要干得她欲仙欲死的念头一下就生了起来，胯下顿时怒龙高抬。\n"..npc1.Name.."毫不掩饰，“这位仙子，可愿与某共度春宵？”\n"..npc2.Name.."性子冷清，男女情爱之事，既不懂，也从未关心过。\n当初家中长辈怕她吃亏，特意为她寻了一家世清白、忠厚老实的修士作为双修道侣。\n可她不喜床笫欢爱，"..Spouse.Name.."只道她还未生情愫，便对她百般怜爱，未曾强行索取过，故而"..npc2.Name.."至今仍是处子。\n"..npc2.Name.."对"..Spouse.Name.."的歉意与感激多过男女之情，她曾想过，"..Spouse.Name.."是个好人，终有一日还要把身子给他的。\n\n只是她心中对男女欢爱仍难掩厌恶，遇到此事，心下更为不悦，面若冰霜，对"..npc1.Name.."连一个眼神都没有，径直自他身侧走了过去。\n这臭婊子，老子让你装，"..npc1.Name.."当着众人，只觉脸面无光，愤恨之下，暗施法力，在她身上留下了一道寻踪印记。\n待"..npc2.Name.."出城后，"..npc1.Name.."祭出诸般法器，不消片刻便将"..npc2.Name.."击败。\n“贱货，让你给老子装！”"..npc1.Name.."用鞋底踩着"..npc2.Name.."的脸颊，手握马鞭，"..npc2.Name.."的衣物已作褴褛状，再也包裹不住那诱人的胴体。\n"..npc2.Name.."不知他为何这般恼火，故而在凌辱之下，也未曾言语。\n“真当自己是仙女了？啊？”"..npc1.Name.."以为"..npc2.Name.."仍在故作高傲，心中原本泄出的怒火又蹭蹭的窜了起来。\n“就算你是仙女，在老子这儿，也得变成吃屎喝尿的狗。”"..npc1.Name.."掏出阳物对准"..npc2.Name.."的俏脸——“呲……”一边尿一边左右摇摆着阳物，觉得有趣极了。\n"..npc2.Name.."不懂他为什么笑，只是觉得这样很脏，无奈之下闭上了眼睛。\n"..npc1.Name.."看着眼前的尿人，自在畅怀，用阳物在她脸上拍打着，“来，给爷舔干净。”\n他可能只是想出气吧，虽然不知道哪里惹到他了，但"..npc2.Name.."觉得这并不有损自己的清白，若是还能留得性命，她回去定要将身子给了"..Spouse.Name.."，最好能给他生个儿子。\n心中思定，便问，“舔干净了就放我走吗？”\n“啊……嗯。”"..npc1.Name.."眼睛看向别处，应得模糊。\n"..npc2.Name.."以为他答应了，舔得仔细。\n“想不到你这妞还挺浪啊。”\n"..npc2.Name.."听不懂，只顾埋首舔着。\n“好了，爷的鸡巴也硬了，躺那儿，自己把腿掰开。”\n"..npc2.Name.."呆愣，"..npc1.Name.."看她不动，上前将她抱起，长枪直刺，路途之上却感到了些许阻隔——“你……你还是个雏？”\n"..npc2.Name.."吃痛之下也明白发生了什么，泪水默默流下，心如死灰，直觉得还不如死了算了。\n"..npc1.Name.."全然不理那些，只觉得今天真是捡到宝了，心中兴奋不已，怒龙又雄壮了几分。\n"..npc1.Name.."的粗壮阳物在"..npc2.Name.."的少女嫩屄中进出操弄着，伴随淫液带出的丝丝殷红不断刺激着"..npc1.Name.."的神经。\n"..npc1.Name.."不顾"..npc2.Name.."初经人事，不耐伐挞，直干到了次日天明。\n"..npc1.Name.."高呼痛快之时，发觉"..npc2.Name.."竟已昏死了过去。\n……\n\n"..npc2.Name.."睁眼时，看到"..Spouse.Name.."守在她的榻前，眼泪一下就流了出来，情绪再难抑制，“我对不起你……对不起你，你杀了我吧……”\n"..Spouse.Name.."只是抱着她，轻轻的拍着后背，“不哭，不哭……没事了，哎，好了，没事的。”");
						npc1.PropertyMgr.RelationData:AddRelationShip(npc2,"Chunv");
						npc2.PropertyMgr:AddFeature("Pogua");
						npc2:AddModifier("XianzheCD");
						npc1:AddModifier("XianzheCD");
						return false;
						end
						if Dfxg == CS.XiaWorld.g_emJHNpc_Feature.Apathy and Wfxg == CS.XiaWorld.g_emJHNpc_Feature.Greedy and npc1.LuaHelper:GetGLevel() > npc2.LuaHelper:GetGLevel() and npc2.PropertyMgr:CheckFeature("Pogua") ~= true then--处冷，男坚
						me:AddMsg(""..npc1.Name.."见前方走来的"..npc2.Name.."身形窈窕、姿态妍丽，心动不已，要干得她欲仙欲死的念头一下就生了起来，胯下顿时怒龙高抬。\n"..npc1.Name.."毫不掩饰，“这位仙子，可愿与某共度春宵？”\n"..npc2.Name.."性子冷清，男女情爱之事，既不懂，也从未关心过。\n当初家中长辈怕她吃亏，特意为她寻了一家世清白、忠厚老实的修士作为双修道侣。\n可她不喜床笫欢爱，"..Spouse.Name.."只道她还未生情愫，便对她百般怜爱，未曾强行索取过，故而"..npc2.Name.."至今仍是处子。\n"..npc2.Name.."对"..Spouse.Name.."的歉意与感激多过男女之情，她曾想过，"..Spouse.Name.."是个好人，终有一日还要把身子给他的。\n\n只是她心中对男女欢爱仍难掩厌恶，遇到此事，心下更为不悦，面若冰霜，对"..npc1.Name.."连一个眼神都没有，径直自他身侧走了过去。\n这臭婊子，老子让你装，"..npc1.Name.."当着众人，只觉脸面无光，愤恨之下，暗施法力，在她身上留下了一道寻踪印记。\n待"..npc2.Name.."出城后，"..npc1.Name.."祭出诸般法器，不消片刻便将"..npc2.Name.."击败。\n“贱货，让你给老子装！”"..npc1.Name.."用鞋底踩着"..npc2.Name.."的脸颊，手握马鞭，"..npc2.Name.."的衣物已作褴褛状，再也包裹不住那诱人的胴体。\n"..npc2.Name.."不知他为何这般恼火，故而在凌辱之下，也未曾言语。\n“真当自己是仙女了？啊？”"..npc1.Name.."以为"..npc2.Name.."仍在故作高傲，心中原本泄出的怒火又蹭蹭的窜了起来。\n“就算你是仙女，在老子这儿，也得变成吃屎喝尿的狗。”"..npc1.Name.."掏出阳物对准"..npc2.Name.."的俏脸——“呲……”一边尿一边左右摇摆着阳物，觉得有趣极了。\n"..npc2.Name.."不懂他为什么笑，只是觉得这样很脏，无奈之下闭上了眼睛。\n"..npc1.Name.."看着眼前的尿人，自在畅怀，用阳物在她脸上拍打着，“来，给爷舔干净。”\n他可能只是想出气吧，虽然不知道哪里惹到他了，但"..npc2.Name.."觉得这并不有损自己的清白，若是还能留得性命，她回去定要将身子给了"..Spouse.Name.."，最好能给他生个儿子。\n心中思定，便问，“舔干净了就放我走吗？”\n“啊……嗯。”"..npc1.Name.."眼睛看向别处，应得模糊。\n"..npc2.Name.."以为他答应了，舔得仔细。\n“想不到你这妞还挺浪啊。”\n"..npc2.Name.."听不懂，只顾埋首舔着。\n“好了，爷的鸡巴也硬了，躺那儿，自己把腿掰开。”\n"..npc2.Name.."呆愣，"..npc1.Name.."看她不动，上前将她抱起，长枪直刺，路途之上却感到了些许阻隔——“你……你还是个雏？”\n"..npc2.Name.."吃痛之下也明白发生了什么，泪水默默流下，心如死灰，直觉得还不如死了算了。\n"..npc1.Name.."全然不理那些，只觉得今天真是捡到宝了，心中兴奋不已，怒龙又雄壮了几分。\n"..npc1.Name.."的粗壮阳物在"..npc2.Name.."的少女嫩屄中进出操弄着，伴随淫液带出的丝丝殷红不断刺激着"..npc1.Name.."的神经。\n"..npc1.Name.."不顾"..npc2.Name.."初经人事，不耐伐挞，直干到了次日天明。\n"..npc1.Name.."高呼痛快之时，发觉"..npc2.Name.."竟已昏死了过去。\n……\n\n"..npc2.Name.."睁眼时，看到"..Spouse.Name.."守在她的榻前，眼泪一下就流了出来，情绪再难抑制，“我对不起你……对不起你，你杀了我吧……”\n"..Spouse.Name.."只是抱着她，轻轻的拍着后背，“不哭，不哭……没事了，哎，好了，没事的。”");
						npc1.PropertyMgr.RelationData:AddRelationShip(npc2,"Chunv");
						npc2.PropertyMgr:AddFeature("Pogua");
						npc2:AddModifier("XianzheCD");
						npc1:AddModifier("XianzheCD");
						return false;
						end
						if Dfxg == CS.XiaWorld.g_emJHNpc_Feature.Apathy and npc1.PropertyMgr.RelationData:IsRelationShipWith("Lover",npc2) == true and npc2.PropertyMgr:CheckFeature("Pogua") == true then--冷漠非处恋人
						me:AddMsg(""..npc1.Name.."手捧一簇鲜花，鼓起勇气向"..npc2.Name.."表明心迹。\n"..npc2.Name.."有些惊讶，"..npc1.Name.."在修行上曾帮她许多，"..npc2.Name.."始终视他为良师益友，曾有结为金兰之念，不料今日听到这番言语。\n"..npc2.Name.."是清冷之人，向来不喜男女之事，当初家中长辈怕她吃亏，特意为她寻了一家世清白、忠厚老实的修士作为双修道侣。\n"..Spouse.Name.."婚后待她极好，可她在床笫之间着实难掩厌恶之色，二人相交多次，难得欢愉，故而自觉亏欠丈夫许多。\n"..npc1.Name.."也是一个好人，这些年来，他的行止她也看在眼里，至纯至善，如今能鼓起勇气向她表白，她又怎么忍心伤害他。\n可若答应了，也实在对不起丈夫。\n\n“夫人，我这一生，别无所求，你若能与我一夕之欢，我真是死也无憾了。”"..npc1.Name.."握着她的手，诚恳至极。\n我真是个坏女人，千错万错都是我的错，若是九天之上当真有神明看着，所有罪责都让我一人承担吧。"..npc2.Name.."下定决心，“说好了，就这一次，万不能让"..Spouse.Name.."知道。”\n“我晓得了。”\n……\n\n"..npc2.Name.."平静的躺着，暗中思索，实在不知这事儿有何欢愉，竟使得世间千万男子耽溺其中。\n"..npc1.Name.."在她身下卖力耕耘，速度逐渐加快——"..npc2.Name.."似乎想到了什么，忙道，“你可不能射进……”\n“啊……”伴随着"..npc1.Name.."畅快的声音，"..npc2.Name.."感受到了身下喷涌而入的那一股股火热。\n"..npc2.Name.."生气了，但在她发火之前——“对不起，我错了，夫人实在太美了，我……我没能忍住。”"..npc1.Name.."面露愧色，"..npc2.Name.."气得憋闷。\n“这样好了，夫人，我帮你舔干净，放心，一定不会有孕的。”\n“算了，那里脏……”\n……\n\n天色将暗，二人就已返回了"..npc2.Name.."府上，待"..Spouse.Name.."归来，三人宴乐欢笑，一切如常。");
						npc2:AddModifier("XianzheCD");
						npc1:AddModifier("XianzheCD");
						return false;
						end
						if Dfxg == CS.XiaWorld.g_emJHNpc_Feature.Apathy and npc1.PropertyMgr.RelationData:IsRelationShipWith("Lover",npc2) == true and npc2.PropertyMgr:CheckFeature("Pogua") ~= true then--冷漠处恋人
						me:AddMsg(""..npc1.Name.."手捧一簇鲜花，鼓起勇气向"..npc2.Name.."表明心迹。"..npc2.Name.."听完，心中平生了几分愧意。\n"..npc1.Name.."在修行上曾帮她许多，"..npc2.Name.."始终视他为良师益友，曾也有结为金兰之念，但今日这事，是万万不能应下的。\n"..npc2.Name.."是清冷之人，向来不喜男女之事，当初家中长辈怕她吃亏，特意为她寻了一家世清白、忠厚老实的修士作为双修道侣。\n婚后，"..npc2.Name.."不愿承欢，"..Spouse.Name.."只道她还未生情愫，便对她百般怜爱，未曾强行索取过。\n"..npc2.Name.."对"..Spouse.Name.."有太多的感激与歉意，故而无论怎样，也不能负他。\n"..npc1.Name.."看"..npc2.Name.."拒绝的坚决，也不再纠缠，“罢了，希望此事莫伤了我们之间的情谊。”");
						npc2:AddModifier("XianzheCD");
						npc1:AddModifier("XianzheCD");
						return false;
						end
						if Dfxg == CS.XiaWorld.g_emJHNpc_Feature.Apathy then
						me:AddMsg(""..npc1.Name.."看"..npc2.Name.."身形窈窕、姿态妍丽，心动不已，径直言道，“仙子可愿与某双修？”\n"..npc2.Name.."只当此人是街市寻常的浪荡子，未作理会，转身便离去了。");
						return false;
						end
						if Dfxg == CS.XiaWorld.g_emJHNpc_Feature.Tenacity and npc1.LuaHelper:GetGLevel() - 5 > npc2.LuaHelper:GetGLevel() and npc2.PropertyMgr:CheckFeature("Pogua") == true then--坚毅非处1
						me:AddMsg(""..npc1.Name.."御剑而来，飒沓似流星。\n“"..npc2.Name.."，你可愿与本尊双修？”\n"..npc2.Name.."一心向道，从未理睬过那些俗世尘埃，向来也无半分痴怨情思。\n自己与"..Spouse.Name.."结成道侣也是门派与宗族的利益需要，二人平素就连相见也是难得，与他人双修，更是从未想过。\n只是，此人是一方大能，若能与之双修，于修行也大有裨益，"..npc2.Name.."心下犹豫，难以抉择。\n\n“本尊精于阴阳和合之道，与本尊双修过的女子日后修行皆一日千里，本尊这里还有一粒九转金丹，亦可绵延益寿、增进修为。”\n"..npc2.Name.."看着真人手中的丹药，感受着他身上散发着如高山洪海一般浩然而澎湃的法力，身下渐渐湿润。\n她以极不自然的步伐走上前去，伸手去接。\n"..npc1.Name.."也爽快，直把丹药给了她，“脱衣服吧。”\n这里虽是城外，却也离官道不远啊，"..npc2.Name.."惊愕，以手臂护住衣襟。\n“慌什么，你们一起。”\n"..npc1.Name.."祭出一个形似床榻的法器，床榻渐渐变大，"..npc2.Name.."惊觉塌上竟横卧着8名裸衣女子，这八人招摇妩媚，姿态万千，修为皆在自己之上，这般修士，也甘作他的性奴吗？\n“来来来，都给本尊跪好了，把骚屄露出来，本尊今日要花开九朵。”\n"..npc2.Name.."略作挣扎，还是解开了衣物的扣带，将外衣缓缓褪去。\n“妹妹，你可要快些，再这样，主人可就要生气了。”\n众女奴一边言语，一边七手八脚的把"..npc2.Name.."的衣服除了个一干二净。\n"..npc2.Name.."学着她们的样子跪着，众女跪作一排，屁股高高撅起，蜜缝与菊穴全都对着"..npc1.Name.."彻底坦露。\n"..npc2.Name.."从未做过这样的姿势，与丈夫的性爱也只是躺在那里，等他一番活动后草草收场。\n这般行径，还是在野外，真是羞也羞死了。\n"..npc1.Name.."轻轻挥舞手掌，法力带动着空气形成微风，“跟着风向，把你们的贱屁股给本尊扭起来。”\n"..npc2.Name.."没想到羞耻的还在后面，众女想来不是第一次玩这种游戏了，配合纯熟，"..npc2.Name.."却万分僵硬，多次打乱节奏。\n"..npc1.Name.."将她一脚踢翻，“你这贱狗，是想挨鞭子吗？”\n"..npc2.Name.."看着他手中的鞭形法器，充斥着恐怖的雷霆威能，心下畏惧不已，忙爬上前去，含住"..npc1.Name.."的脚趾，“主人，贱狗错了，贱狗是第一次，但贱狗会用心学的，求主人饶了贱狗吧。”\n"..npc1.Name.."指了指自己的阳物，“不想吃鞭子也行，就罚你喝本尊的圣水吧。”\n"..npc2.Name.."愣神，一时不知"..npc1.Name.."所说圣水是何物。\n一女奴在她耳畔轻声提醒，其他女奴你一言我一语——“这哪是惩罚啊，分明是赏赐，还不谢谢主人。”“就是，主人的圣水这么宝贵，我们平时争着抢着也喝不到啊。”\n"..npc2.Name.."磕头道谢，含住"..npc1.Name.."的鸡巴，忍着心里的恶心吞下那一股股液体，饮毕，惊觉这液体清香，自身的修为竟也增进了许多，忙上前为"..npc1.Name.."清理，还轻轻吸了一吸。\n"..npc1.Name.."与九女的欢愉持续了七天七夜，结束之时"..npc2.Name.."发觉自身修为大涨，十年苦修也难及这七日欢好之功，她求"..npc1.Name.."将她也收作女奴。\n“做本尊的女奴，日后就是本尊的人了，不能再与你丈夫有情爱绵缠，你可想好了？”\n我与他本就无甚情爱，这算的什么，"..npc2.Name.."跪地，头埋在"..npc1.Name.."脚下，“想好了，愿为主人女奴，求主人恩准。”\n"..npc1.Name.."点头，一道咒印打在"..npc2.Name.."身上，小腹下方竟多了一幅直透着淫靡气息的暗红淫纹。\n“这是本尊的贞操咒印，看你那小穴口，如今只有针眼大小，唯遇本尊阳具，才会张开。”\n听到这话，"..npc2.Name.."心想自己日后身心都属于这般强大的主人了，不住的激动、喜悦，身下淫水潺潺，好想主人操我。\n"..npc1.Name.."修为增加，"..npc2.Name.."修为增加,"..npc2.Name.."成为了"..npc1.Name.."的女奴隶，"..npc2.Name.."获得贞操咒印。");
						npc1.PropertyMgr.RelationData:AddRelationShip(npc2,"Luding2");
						npc2:AddModifier("Zhenchaosuo");
						npc1.LuaHelper:AddPracticeResource("Stage",npc1.LuaHelper:GetGLevel() * 1000);
						npc2.LuaHelper:AddPracticeResource("Stage",npc2.LuaHelper:GetGLevel() * 2000);
						npc2:AddModifier("XianzheCD");
						npc1:AddModifier("XianzheCD");
						return false;
						end
						if Dfxg == CS.XiaWorld.g_emJHNpc_Feature.Tenacity and npc1.LuaHelper:GetGLevel() - 5 > npc2.LuaHelper:GetGLevel() and npc2.PropertyMgr:CheckFeature("Pogua") ~= true then--坚毅处1
						me:AddMsg(""..npc1.Name.."御剑而来，飒沓似流星。\n“"..npc2.Name.."，你可愿与本尊双修？”\n"..npc2.Name.."一心向道，从未理睬过那些俗世尘埃，向来也无半分痴怨情思。\n自己与"..Spouse.Name.."结成道侣也是门派与宗族的利益需要，除了婚礼当日见过一次外，再无半面之缘，就是成婚之夜，也是分席睡下的，毕竟保留处子元阴于修行大有裨益，她可不愿为了"..Spouse.Name.."这个素不相识的男人绝了自己的通天之路。\n只是，眼下这人是修行界有名的一方大能，素闻其精通坎离既济之法，与他双修过得女子如今皆修行有成，不知是真是假，"..npc2.Name.."一时难以取舍。\n\n“本尊知你还是处子之身，除了你的容貌，本尊看中的恰是你这般修为的元阴之精。你放心，本尊破了你的身子，也会让你从本尊这里得到更大的好处，你看——”"..npc1.Name.."祭出一形似床榻的法器，床榻渐渐变大，"..npc2.Name.."惊觉塌上竟横卧着8名裸衣女子，这八人招摇妩媚，姿态万千，修为皆在自己之上，这般修士，也甘作他的性奴吗？\n“这八人一年之前不过凡体肉胎，正是跟了本尊，才有如此修为。”\n不过做了他一年性奴便抵我数十年的苦修吗？"..npc2.Name.."心动。\n“被那些不懂这阴阳妙法的男子破了身子，自是阻碍修行的，但你可知，孤阴不生，独阳不长，坎离相济、阴阳和合才是天地大道，如此修行方可通天。”"..npc1.Name.."面容严肃，一众女奴也都跟着劝道，“这等好事，你还不赶快答应？”“是啊，主人看上你是你的福分，我们平日里摇着屁股求主人操都求不来呢。”“我和主人双修一次就突破了一个小境界呢，这样的机缘，你还想什么呢？”\n"..npc2.Name.."沉默片刻，点头道，“好。”\n“那就脱衣服吧，和她们跪在一起。”\n这里虽是城外，却也离官道不远啊，"..npc2.Name.."一下慌了神。\n“怕什么，你看她们不也一样。”"..npc1.Name.."指了指前方未着寸缕跪作一排的女奴们。\n“是。”"..npc2.Name.."横下心，学着她们的样子跪着，屁股高高撅起，蜜缝与菊穴全都对着"..npc1.Name.."彻底坦露。\n"..npc2.Name.."从未有过男女情爱，这样的姿势，还是在野外，真是羞也羞死了。\n"..npc1.Name.."绕着女奴们转了一圈，手掌一一拍过她们的屁股，“真不错，本尊今日便要花开九朵。”\n“母狗恳请主人临幸。”众女音调整齐,言语同时一同扭着屁股，想来不是第一次玩这种游戏了，相互之间，配合纯熟。\n“嗯，那就从你这只贱狗开始好了。”"..npc1.Name.."佯作思索，用脚趾捅了捅"..npc2.Name.."的嫩穴。\n"..npc2.Name.."怕元阴有失，惹得"..npc1.Name.."不快，身子缩了缩，一边磕头一边道，“多谢主人，求……求主人操我。”她哪里说过这种话，不过是有样学样，心中羞臊万分。\n"..npc1.Name.."扶着阳物，在她娇嫩、湿润的洞口不断磨蹭着，就是不肯插入，“想让我操？说点好听的。”\n"..npc2.Name.."身下火热，瘙痒难耐，淫水已流了一地，感受着那不断磨蹭着阴唇的雄伟阳物，求之不得最是让人骚动、疯狂，“求……求主人了，我是主人的贱狗，屄是主人的，膜是主人的，我浑身上下都是主人的玩具，主人……主人快来玩我吧。”\n"..npc1.Name.."觉得火候差不多了，运功缓缓插入，调和阴阳……\n"..npc1.Name.."与九女的欢愉持续了七天七夜，"..npc2.Name.."自觉十年苦修也难及这七日欢好之功，她求"..npc1.Name.."将她也收作女奴。\n“做本尊的女奴，往后便不能与你丈夫有情爱绵缠，你可想好了？”\n我与他本就无甚情爱，这算的什么，"..npc2.Name.."跪地，头埋在"..npc1.Name.."脚下，“想好了，愿为主人女奴，求主人恩准。”\n"..npc1.Name.."点头，一道咒印打在"..npc2.Name.."身上，小腹下方竟多了一幅直透着淫靡气息的暗红淫纹。\n“这是本尊的贞操咒印，看你那小穴口，如今只有针眼大小，唯遇本尊阳具，才会张开。”\n听到这话，"..npc2.Name.."心想自己日后身心都属于这般强大的主人了，不住的激动、喜悦，身下淫水潺潺，好想主人操我。\n"..npc1.Name.."修为大幅上涨，"..npc2.Name.."修为大幅上涨,"..npc2.Name.."成为了"..npc1.Name.."的女奴隶，"..npc2.Name.."获得贞操咒印。");
						npc1.PropertyMgr.RelationData:AddRelationShip(npc2,"Luding2");
						npc2:AddModifier("Zhenchaosuo");
						npc1.LuaHelper:AddPracticeResource("Stage",npc1.LuaHelper:GetGLevel() * 2000);
						npc2.LuaHelper:AddPracticeResource("Stage",npc2.LuaHelper:GetGLevel() * 4000);
						npc2:AddModifier("XianzheCD");
						npc1:AddModifier("XianzheCD");
						return false;
						end
						if Dfxg == CS.XiaWorld.g_emJHNpc_Feature.Tenacity and npc1.LuaHelper:GetGLevel() > npc2.LuaHelper:GetGLevel() and npc2.PropertyMgr:CheckFeature("Pogua") == true then--坚毅非处2
						me:AddMsg(""..npc1.Name.."看中了那名女修，虽修为一般，但容貌非常，眸若秋水，眉如远山，兼具仙家气度，似天生得玄心道骨。\n"..npc1.Name.."献上礼物，向"..npc2.Name.."表达了双修的愿望。\n"..npc2.Name.."一心向道，从未理睬过那些俗世尘埃，向来也无半分痴怨情思。\n自己与"..Spouse.Name.."结成道侣也是门派与宗族的利益需要，二人平素就连相见也是难得，与他人双修，更是从未想过。\n本欲直接拒绝，忽然之间却想起自己识得此人，传闻"..npc1.Name.."精通坎离既济之法，与他双修过得女子如今皆修行有成，只是不知是真是假。\n"..npc1.Name.."看"..npc2.Name.."犹豫，欺身上前，递上了一物，耳畔暗语，“阴阳之法，合乎天道，双修于你我修行大有裨益，我还愿献上丹霞洞天千金难求的仙丹——三清灵纹丹，此丹有固本培元之效，以助仙子成就大道之基。”\n"..npc2.Name.."收下丹药，道了声好，便跟着"..npc1.Name.."，往他的洞府而去。\n\n"..npc1.Name.."的洞府之中，"..npc2.Name.."稍有几分尴尬，她素来无心男女情爱，与丈夫之间难得的性交，不过是躺在那里应付差事，任他施为而已。\n可，可如今这般情形，又当如何？\n"..npc1.Name.."看出她的窘状，微笑着安抚着，“别担心，交给我就好。”\n"..npc1.Name.."轻咬她的耳垂，爱抚之下，缓缓褪去她身上的衣物。\n"..npc2.Name.."觉得耳朵痒痒的，身上也很舒服，便也不再紧张的抗拒。\n待得二人坦诚相待，"..npc1.Name.."伏在"..npc2.Name.."身下，先以舌尖轻轻挑弄着。\n"..npc2.Name.."从未有过这样的体验，刺激之下，身子都酥了，可又觉得害羞，“那里，那里是尿尿的地方，脏……”\n“仙子的身子，就像是昆仑山巅的雪莲，纯净无暇。”\n"..npc1.Name.."见她渐渐接受，便一边用手指侍弄着阴蒂，一边将舌头往更深处顶去。\n"..npc2.Name.."以往与"..Spouse.Name.."的性交经历，只留下疼痛与肮脏的回忆，她不知女子在情爱之中，竟能这般愉快。\n"..npc2.Name.."闭上双目，只觉自身在御剑飞行，直上云霄，待极乐之时，不禁叫出声来——“啊！……”潮水喷涌，射了"..npc1.Name.."一身，也浸湿了床榻。\n"..npc2.Name.."大脑空白，只觉身在天上，两腿紧闭，身子痉挛不已。待睁眼觉察到发生了何事时，血色上涌，羞臊万分，“我，我不是故意的。”\n"..npc1.Name.."轻轻地抱了抱她，“刚才的你，是最美的。”\n"..npc2.Name.."不敢看他。\n"..npc1.Name.."取了一件尺寸合适的玉势，缓缓插入"..npc2.Name.."美屄的同时，在身后舔弄着"..npc2.Name.."的菊穴。\n有了前面的经历，"..npc2.Name.."也不再压抑自己，专心感受着自己的前后两穴被"..npc1.Name.."以高超的技法侍弄着。\n"..npc1.Name.."见她欢愉的表现愈渐强烈，加快了手中抽插的速度，且伴随着玉势的抽插，"..npc1.Name.."的舌尖也有节奏的一次一次向她后庭的深处顶去——“啊！……啊……”潮水泛滥而不绝，一股又一股的接连喷射，"..npc2.Name.."此时方知，男女之事，竟是人间至乐。\n……\n二人交欢，直至天明，结束之时，"..npc2.Name.."后庭、小穴甚至是双乳之上，都淌着"..npc1.Name.."白浊的阳精。\n"..npc2.Name.."运起功法，发现自己的修为竟也增进了许多，欢喜之下，二人相约他日再续绵缠。\n事毕，双方修为均大量上升，"..npc1.Name.."看着四下散落的阴精，心满意足的眯着眼笑了笑。");
						npc1.LuaHelper:AddPracticeResource("Stage",npc1.LuaHelper:GetGLevel() * 2000);
						npc2.LuaHelper:AddPracticeResource("Stage",npc2.LuaHelper:GetGLevel() * 4000);
						npc2:AddModifier("XianzheCD");
						npc1:AddModifier("XianzheCD");
							if npc2.LuaHelper:GetGLevel() >9 then
							npc1.LuaHelper:DropAwardItem("Item_yinjin5",4);
							elseif npc2.LuaHelper:GetGLevel() >6 then
							npc1.LuaHelper:DropAwardItem("Item_yinjin4",4);
							elseif npc2.LuaHelper:GetGLevel() >3 then
							npc1.LuaHelper:DropAwardItem("Item_yinjin3",4);
							elseif npc2.LuaHelper:GetGLevel() >0 then
							npc1.LuaHelper:DropAwardItem("Item_yinjin2",4);
							else
							npc1.LuaHelper:DropAwardItem("Item_yinjin1",4);
							end
						return false;
						end
						if Dfxg == CS.XiaWorld.g_emJHNpc_Feature.Tenacity and npc1.LuaHelper:GetGLevel() > npc2.LuaHelper:GetGLevel() and npc2.PropertyMgr:CheckFeature("Pogua") ~= true then--坚毅处2
						me:AddMsg(""..npc1.Name.."看中了那名女修，虽修为一般，但容貌非常，眸若秋水，眉如远山，兼具仙家气度，似天生得玄心道骨。\n"..npc1.Name.."献上礼物，向"..npc2.Name.."表达了双修的愿望。\n"..npc2.Name.."一心向道，何曾理会过这男女痴缠，就是与丈夫的新婚之夜，也是分席而卧的，除了维持道心通明、空静玄览外，也是为了守住自身的处子元阴，此女子先天之气也，消散则于道基大有损害。\n且这人与我素未谋面，开口便是双修话语，这等轻浮浪子，真是令人生厌。\n"..npc2.Name.."将礼物掷回，转身便御剑远去。");
						return false;
						end
						if Dfxg == CS.XiaWorld.g_emJHNpc_Feature.Tenacity and npc2.PropertyMgr:CheckFeature("Pogua") == true then
						me:AddMsg(""..npc1.Name.."远处便见那女修气骨非凡，若能与之双修，定可修为大进。\n"..npc1.Name.."上前献上礼物，向"..npc2.Name.."表达了双修的愿望。\n"..npc2.Name.."一心向道，何曾理会过这男女痴缠，自己就是与"..Spouse.Name.."结成道侣，那也是门派与宗族的利益需要。\n况你这资质，又如何配得上我？\n"..npc2.Name.."将礼物掷回，转身便御剑远去。");
						return false;
						end
						if Dfxg == CS.XiaWorld.g_emJHNpc_Feature.Tenacity and npc2.PropertyMgr:CheckFeature("Pogua") ~= true then
						me:AddMsg(""..npc1.Name.."远处便见那女修气骨非凡，若能与之双修，定可修为大进。\n"..npc1.Name.."上前献上礼物，向"..npc2.Name.."表达了双修的愿望。\n"..npc2.Name.."一心向道，何曾理会过这男女痴缠，就是与丈夫的新婚之夜，也是分席而卧的，除了维持道心通明、空静玄览外，也是为了守住自身的处子元阴，此女子先天之气也，消散则于道基大有损害。\n且这人与我素未谋面，开口便是双修话语，这等轻浮浪子，真是令人生厌。\n"..npc2.Name.."将礼物掷回，转身便御剑远去。");
						return false;
						end
						me:AddMsg("所有判定均未成功，理论上不太可能，如果出现了当前文字，请加群上报bug，另外作者不保证修23333");
					end
					return false;
				else
					if npc2.Sex == CS.XiaWorld.g_emNpcSex.Male then--女男ntr
					me:AddMsg(""..npc2.Name.."和妻子"..Spouse.Name.."，非常美满，想来ntr的机会不算太多其实就是还没写完");
					else--女女ntr
					me:AddMsg(""..npc2.Name.."和丈夫"..Spouse.Name.."的婚姻非常美满，而且老娘是女的，操你妈别乱点！");
					end
					return false;
				end
			end
		end
	end--ntr判定失败开始色诱剧本
		if npc1.Sex == CS.XiaWorld.g_emNpcSex.Male then
			if npc2.Sex == CS.XiaWorld.g_emNpcSex.Male then
				if meili < 5 and npc2.PropertyMgr:CheckFeature("Feminization") and npc1.LuaHelper:GetGLevel() > npc2.LuaHelper:GetGLevel() then
				me:AddMsg(""..npc1.Name.."修行间歇越发感觉下体有股欲火熊熊，但却因相貌丑陋苦无同门师姐妹们的垂青，竟然无人愿与"..npc1.Name.."媾和，便想到师姐妹们的居所去顺些裘衣、裘裤、足袋、或是偷窥洗浴、练功以自行解决。没想行至半路却见那外门弟子"..npc2.Name.."正在弯腰处理杂务，那纤瘦的腰肢、滚圆上翘的臀线、隐隐的透出女子之态，"..npc1.Name.."看的竟然有些发痴。\n“"..npc2.Name.."、你过来。”"..npc2.Name.."闻声便停下手中杂务站起身来，见是内门师兄"..npc1.Name.."唤他便恭步迎向前来，俯身作揖。\n"..npc2.Name.."的修行服本就是外门的男弟子统一款式、略显宽大，"..npc1.Name.."目光如电，早已顺着那宽松的领口向内望去。只见"..npc2.Name.."那玉白的肌肤，清秀的锁骨、阳光的照射下散发出粉里透白的霞光。\n"..npc1.Name.."眼中淫邪之光大盛，但也只是一闪而过、随即便消失的一干二净，变得古井不波、真诚而又平和。“你在外门也有些时日了，师兄我虽然不能教你一些本门的功法，但是念在你勤劳本分、这里有一些小小的神通还是可以教于你，你可想学之一二？”\n“诺！”"..npc2.Name.."抬起头来，见"..npc1.Name.."那真诚的目光，惊喜万分，“无量天尊、承蒙师兄恩泽、师弟永世不忘。”\n“你随我来。”"..npc1.Name.."转身便走向附近的树林中，只是那眼中的淫邪之光如同着了火一般，火光大盛、咄咄逼人。\n"..npc1.Name.."与"..npc2.Name.."一前一后往森林深处走去，四下无人，只见"..npc1.Name.."猛然转身，手掐法印、口中念念有词，那眼中的淫邪之光更是毫无遮敛。\n“师兄！你……”"..npc2.Name.."刚想开口询问，便被"..npc1.Name.."用法术束缚、"..npc2.Name.."见"..npc1.Name.."眼中之火，惊慌失措、胡乱挣扎，“师兄……你……求求你饶了我吧……求求你了！”\n"..npc1.Name.."也不答话，任由"..npc2.Name.."惊恐挣扎、高声求饶。啧啧有声道“没想到呀，本门的师弟竟然还有这番姿色，妙！实在是妙！”言罢又掐起法印，"..npc2.Name.."进缓缓的飘了起来。\n“去！”"..npc1.Name.."抬起右手轻轻一点，"..npc2.Name.."的衣裳竟开始逐渐滑落，裸露出大片的玉白色肌肤，纤瘦的小小身躯逐渐显露出来，胸前微微有些隆起的胸肌和两点粉红看的"..npc1.Name.."血脉喷张，下身的肉棒高高抬起，把修行服的下摆撑起一个小小的帐篷。\n"..npc1.Name.."欺身压近，充满欲望的目光如烈火一般灼烧着"..npc2.Name.."裸露出的每一片肌肤，修长的手指划过"..npc2.Name.."的脸颊、锁骨、胸膛、滑进那未被目光侵蚀的地方。\n“别……”\n“嘘。”"..npc1.Name.."轻声打断了"..npc2.Name.."，同时默运功法，一股奇特的香气在两人之间弥散开来。\n这是什么香气？好像在内门师姐的居所附近闻到过，好舒服。"..npc2.Name.."心中疑惑，但是转眼之间"..npc2.Name.."便迷失在这沁人心脾的香氛中。\n"..npc1.Name.."嘿嘿轻笑，褪去了"..npc2.Name.."的衣服，雪白的胴体完全暴露在眼前，没想到不但身形像女子，就连下身也很是相似，"..npc2.Name.."的下身并不硕大，甚至要比普通人小很多，翘立的小肉棒竟如小指一般大小，散发出一股微骚的奶甜气息。\n"..npc1.Name.."不由食指大动，喉结滚动。一口含住"..npc2.Name.."的肉棒，吮动起来。\n"..npc2.Name.."的身体一阵颤抖，檀口大张，一波又一波强烈的快感冲击着全身，宛如狂海之中的一叶扁舟。\n"..npc1.Name.."立刻把自己剥了个精光，挺立的肉棒刺入"..npc2.Name.."口中，前后耸动起来，两人飘立在半空之中，抵死缠绵。\n纠缠半晌，"..npc2.Name.."突然浑身颤抖，双手紧紧的抱着"..npc1.Name.."双腿盘上"..npc1.Name.."的臂膀，发疯了一般套弄着"..npc1.Name.."的肉棒，舌头纠缠着肉棒前段的沟壑。“嗯……”"..npc1.Name.."舒爽的闷哼一声，下身更是猛力一挺，硕大的龟头死死的顶着"..npc2.Name.."的喉咙。精关大开，一股股粘稠的阳精伴着下身的挺动喷薄而出。同时，"..npc1.Name.."也觉得一股滚烫的液体喷入自己口中，微苦而又甘甜。喉结滚动，同时吞下彼此的精华，"..npc2.Name.."也因为"..npc1.Name.."抽出肉棒而清醒了过来。\n两人整理衣衫，"..npc2.Name.."眼神迷离的偎依在"..npc1.Name.."身旁，望着"..npc1.Name.."的脸庞，“师哥……我……”"..npc2.Name.."还未说完，"..npc1.Name.."便用嘴巴堵住了"..npc2.Name.."话语，吻毕，“我会再来找你的。”"..npc1.Name.."说道。！");
				npc1:AddModifier("XianzheCD");
				npc2:AddModifier("XianzheCD");
				npc1.PropertyMgr.RelationData:AddRelationShip(npc2,"Lover");
				else
				me:AddMsg(""..npc2.Name.."：滚！");
				end
			elseif npc2.Camp ~= npc1.Camp and npc1.PropertyMgr.Practice.Gong.Name == ("Gong_1701_Tu") and npc1.LuaHelper:GetCharisma() > 9 and npc1.Name == "卓十七"then
			me:AddMsg(""..npc2.Name.."虽与"..npc1.Name.."处于敌对阵营，可"..npc1.Name.."帅气的脸庞，挺拔的身姿还是深深吸引住了"..npc2.Name.."，只闻得邪魅的"..npc1.Name.."说了一句“这位仙子清丽不凡，何要学那些厮杀莽汉，不如我俩去寻个小树林，痛痛快快的来个一炮泯恩仇如何？”，\n照理说此等放浪言辞按"..npc2.Name.."平日早就祭出法宝将其打杀，可今日不知为何却怎么也下不了手，口中还答曰“郎君如此俊美，所言必是正理……”\n两人寻的一僻静之地褪下衣衫干了个痛快，代"..npc2.Name.."泄身沉沦于满足的肉欲之时，却见"..npc1.Name.."默运六欲心经的采补法诀将对方精元掠夺一空。\n待"..npc2.Name.."发现之时已经无力回天……");
			npc1:AddModifier("Story_Caibuzhidao1");
			npc2.PropertyMgr:AddMaxAge(- 9999);
			elseif Dfxg == CS.XiaWorld.g_emJHNpc_Feature.Greedy and npc1.LuaHelper:GetModifierStack("Qian") >= 100 and npc2.PropertyMgr:CheckFeature("Pogua") == true then
			me:AddMsg(""..npc1.Name.."邪魅的瞥了"..npc2.Name.."一眼，舔了舔嘴唇，手沿着强健优美的胸膛向下划入怀中。\n“女人，正面上我，伺候得我舒服，这些都是你的。”说罢从怀中抓出一把银钱，顺势解开了衣服，雪白的银钱撒在了"..npc1.Name.."古铜色的肌肤上，交相辉映的光彩晃得"..npc2.Name.."喘不过气，“母狗，还不滚过来？”此刻"..npc1.Name.."侧躺在地上银钱散落的到处都是，"..npc2.Name.."望着"..npc1.Name.."胯下硕大的鸡巴狠狠咽了咽口水，情不自禁的爬了过去，张开小嘴用力将"..npc1.Name.."的鸡巴含了进去，吃力的舔弄了起来，"..npc1.Name.."翻身踢开了她，面对"..npc2.Name.."不解的目光，"..npc1.Name.."抬起了脚送到"..npc2.Name.."的嘴边，"..npc2.Name.."迟疑了一下，还是伸出香舌，舔舐了起来。\n从鸡巴到脚再到屁眼，"..npc2.Name.."舔吸的力量逐渐迟缓了下来，已是春情荡漾浑身无力，于是"..npc1.Name.."翻身上马撕开了"..npc2.Name.."的衣裙，定睛一看，"..npc2.Name.."粉嫩的阴唇早已淫水泛滥、饥渴难耐，于是"..npc1.Name.."毫不犹豫、持枪而入。“啊！轻点，好大，我受不了了。”\n"..npc1.Name.."的大鸡巴插得"..npc2.Name.."欲仙欲死，原本寂静的四周充斥着"..npc2.Name.."淫叫。\n"..npc1.Name.."不管不顾大力抽插，又是几百回合下来，插得"..npc2.Name.."阴精狂泄、高潮迭起，见"..npc2.Name.."已无力再战，"..npc1.Name.."闷哼一声，用力一插，龟头一紧，大量滚烫的阳精灌入"..npc2.Name.."的子宫之中，此时的"..npc2.Name.."虽已是被干的头晕目眩、意乱情迷，却也没有忘记银钱，事毕之后取走了那百两纹银只留下了一句，“老板下次再找我啊！”便离开了。");
			npc2:AddModifier("XianzheCD");
			npc2:AddModifier("Qian");
			npc1:AddModifier("XianzheCD");
			npc1.PropertyMgr:FindModifier("Qian"):UpdateStack(-100);
			npc2.PropertyMgr:FindModifier("Qian"):UpdateStack(99);
			elseif npc2.PropertyMgr:CheckFeature("Pogua") == true and npc2.PropertyMgr:CheckFeature("WHLjinv") == true and npc1.LuaHelper:GetGLevel() > npc2.LuaHelper:GetGLevel() then
			me:AddMsg(""..npc1.Name.."垂涎"..npc2.Name.."已久，却不料"..npc2.Name.."居然对自己不假辞色，这着实激怒了"..npc1.Name.."。\n这一人"..npc1.Name.."拦住了"..npc2.Name.."再次示好却又被拒绝，怒火中烧的"..npc1.Name.."一个耳光将"..npc2.Name.."抽倒在地怒呵道：“贱人你都不是原装的了，在万花楼都接过客了，搁我这装什么清纯呢？”随后便撕扯掉对方的裤头将她按住强行奸污了。");
			npc2:AddModifier("NalitongCD");
			npc1:AddModifier("XianzheCD");
			npc2.PropertyMgr.RelationData:AddRelationShip(npc1,"PersonalEnemy");
			elseif npc2.PropertyMgr:CheckFeature("Pogua") == true and npc1.LuaHelper:GetModifierStack("YYHHGFL") ~= 0 and npc1.LuaHelper:GetGLevel() < npc2.LuaHelper:GetGLevel() then
			me:AddMsg(""..npc1.Name.."垂涎"..npc2.Name.."良久日日夜夜想的都是"..npc2.Name.."，奈何"..npc1.Name.."实力不济，最多只能每天晚上在梦里霸王硬上个机会弓。\n这日"..npc1.Name.."废了大代价搞来了阴阳合欢蛊的屎丸，此乃一等一的催情迷药，乘着"..npc2.Name.."不注意的时候，"..npc1.Name.."将红丸置入"..npc2.Name.."杯中，待其饮下药效发作欲火焚身之际，"..npc1.Name.."顺势将其奸污了。\n事毕，"..npc2.Name.."居然说什么要"..npc1.Name.."负责之类的胡话……");
			npc2:AddModifier("NalitongCD");
			npc1:AddModifier("XianzheCD");
			npc1.PropertyMgr.RelationData:AddRelationShip(npc2,"Lover");
			elseif npc2.PropertyMgr:CheckFeature("Mugou") == true and npc2.PropertyMgr:CheckFeature("Pogua") == true then
			me:AddMsg(""..npc2.Name.."被充分调教的肉体，显然低档不住任何诱惑，"..npc1.Name.."只是掏出肉棒"..npc2.Name.."变向一条恶犬扑食一般上前舔舐……！\n"..npc2.Name.."舔到"..npc1.Name.."性起，只见"..npc1.Name.."翻转过她的身子，便在"..npc2.Name.."蜜穴里狠狠抽插了起来……\n事毕，"..npc2.Name.."一边舔着"..npc1.Name.."的肉棒，一边表达着自己想给"..npc1.Name.."当狗的愿望。");
			npc1:AddModifier("XianzheCD");
			npc2:AddModifier("XianzheCD");
			npc1.PropertyMgr.RelationData:AddRelationShip(npc2,"Luding2");
			elseif npc1.PropertyMgr.RelationData:IsRelationShipWith("Lover",npc2) == true and npc2.PropertyMgr:CheckFeature("Pogua") == true then
			me:AddMsg(""..npc2.Name.."的房内，"..npc2.Name.."上身只穿一件肚兜，下身赤裸的靠在"..npc1.Name.."的怀中，任凭"..npc1.Name.."抚摸自己白皙娇嫩的肌肤。\n"..npc1.Name.."抚弄着"..npc2.Name.."的迷人躯体，说道：「仙子奶子真敏感，摸几下上面的奶头就翘起来了」微汗的"..npc2.Name.."被"..npc1.Name.."的手摸得娇喘连连，听到身后的情郎所说的话，想起被"..npc1.Name.."奸淫时的快感，早已被"..npc1.Name.."大鸡巴征服的"..npc2.Name.."心中一片火热，，下身蜜穴淫水潺潺流出。\n这几日"..npc2.Name.."的身体早被"..npc1.Name.."摸透，"..npc1.Name.."手指伸进蜜穴一勾，就精准的触碰到她最敏感的点上，还记得那点被"..npc1.Name.."找到后手指狂抽猛插，让她高潮迭起，淫水狂喷，丢了个大丑。\n "..npc2.Name.."身子一颤，原来"..npc1.Name.."一手进攻蜜穴的同时，大嘴不断亲吻仙子的脖颈、脸颊和小巧的耳垂。\n「嗯…啊…"..npc1.Name.."……干我……」\n「仙子……看棍………」说着"..npc1.Name.."微微下蹲，肉屌一跳一跳的摩擦着仙子的玉腿，肥大的肉屌寻找着那波光闪闪的「水帘洞」。\n"..npc2.Name.."一只手抓住"..npc1.Name.."的手揉搓的自己的娇乳，另一只手伸向胯下，抓住"..npc1.Name.."的大肉棒，把龟头对准从小内裤中间缝隙处露出的蜜穴，同时"..npc1.Name.."默契的一挺 屁股，大肉棒「滋」的一下插入"..npc2.Name.."小穴的深处。\n「啊……」\n 「仙子，你看我的棍法练得可好？」\n「好……好棒……你这棍法……变化多端……又力若千钧……」\n「啊…啊……好…好爽……好棒……啊……好舒服……哦……哦……好深……哦……好舒服……啊……嗯呀……快……不要停……好舒服……呜呜……」\n「来，我们换个地方继续弄。\n」说着"..npc1.Name.."双手扶住"..npc2.Name.."的芊腰，肉棒也不抽出，不停的大力抽插着。\n "..npc2.Name.."则双手向后扶住"..npc1.Name.."的臀部，生怕抽插过程中"..npc1.Name.."的大肉棒离开自己的身体。\n两人一边抽插一边来到旁边床榻处。\n只见"..npc1.Name.."把"..npc2.Name.."按住背靠着床榻，高高抬起"..npc2.Name.."的一条玉腿，略微挪动腰部，将大鸡巴对准"..npc2.Name.."的小穴，一口气将肉棒重新插到仙子蜜穴的深处。\n「啊……」\n「仙子，这个姿势舒服吧？」"..npc1.Name.."就这么一边高高抬着"..npc2.Name.."的玉腿，一只手大力地贴着肚兜揉搓着仙子的胸部，下身卖力地抽插着，龟头每次都深的顶到花心上，同时龟头马眼微张，不断亲吻着"..npc2.Name.."的花心。\n「啊…啊……好…好爽……好棒……啊……好舒服……哦……哦……好深……哦……好舒服……啊……嗯呀……快……不要停……好舒服……呜呜……」\n「啊……啊……啊……哥哥，好棒，要，要被你插穿了，我，我要飞上天了……好棒啊……啊……啊……」"..npc2.Name.."疯狂地摆着脑袋，沾着的姿势限制了自己下半身的动作。\n如果是躺在床上，此刻定是已经将双腿盘在"..npc1.Name.."的腰上，自己主动地开始随求了。\n而面前的"..npc1.Name.."更是不敢怠慢猛烈地抽插着身前的仙子，誓要把仙子打落凡尘。\n「啊……啊……好哥哥…你…你太棒了……昔儿是你的……下面都是你的…啊……以后…只给哥哥插…啊……哥哥…哥哥插得我好棒……要……要来了……啊……啊……」"..npc2.Name.."双手紧紧地抓着"..npc1.Name.."的肩膀，指甲甚至已经刮破了"..npc1.Name.."的肩膀。\n但"..npc1.Name.."还是专心抽插，下身的速度有增无减，仅仅一个姿势，一个单调的作，"..npc2.Name.."便快招架不住了。\n「好哥…哥哥……啊……啊……要……不……那……什……呀……唔……嗯……」"..npc2.Name.."被插得语无伦次，下身一塌糊涂的淫穴已经开始喷出水来，"..npc2.Name.."的身体也开始有节奏的颤动。\n "..npc1.Name.."知道，"..npc2.Name.."高潮了，而且这一波高潮来得那么亢奋，来得那么激烈，泄得"..npc2.Name.."身上一点力气都没有了。\n "..npc1.Name.."还在卖力地抽插着，丝毫不顾"..npc2.Name.."的身体已经软趴趴地熊抱在自己的身上。\n "..npc1.Name.."抽插的频率越来越快，"..npc2.Name.."只能放松身体，任由自己的情郎蹂躏，终于，"..npc1.Name.."一声长叹，停止了抽插。\n一大股一大股的精液从巨大的肉棒中冲了出来，"..npc2.Name.."可以明显地感觉到那股热流一下一下刺激着自己身体的最深处，犹如炸药在身体中爆炸了一样，原本刚刚高潮过的身体，在热浪的刺激下，再次被推上了高潮。\n「啊！……」"..npc2.Name.."喊着，下身犹如潮水倒灌一样，淫水喷了出来，水花溅的到处都是，"..npc1.Name.."的大腿很快就被淫水淋湿，接着是脚上、地上，一整片的淫水肆无忌惮地喷了出来。\n从未试过如此刺激的高潮，"..npc2.Name.."再也支撑不住，瘫软地倒下。");
			npc1:AddModifier("XianzheCD");
			npc2:AddModifier("XianzheCD");
			elseif npc1.LuaHelper:GetGLevel() > npc2.LuaHelper:GetGLevel() and npc2.PropertyMgr:CheckFeature("Pogua") ~= true then
			me:AddMsg(""..npc2.Name.."不愿意与"..npc1.Name.."欢好，奈何实力不济，被"..npc1.Name.."按倒在地，强行奸污了……");
			npc2:AddModifier("NalitongCD");
			npc1:AddModifier("XianzheCD");
			npc2.PropertyMgr:AddFeature("Pogua");
			npc2.PropertyMgr.RelationData:AddRelationShip(npc1,"PersonalEnemy");
			elseif npc1.LuaHelper:GetGLevel() > npc2.LuaHelper:GetGLevel() and npc2.PropertyMgr:CheckFeature("Pogua") == true then
			me:AddMsg(""..npc2.Name.."不愿意与"..npc1.Name.."欢好，奈何实力不济，被"..npc1.Name.."按倒在地，强行奸污了……");
			npc2:AddModifier("NalitongCD");
			npc1:AddModifier("XianzheCD");
			npc2.PropertyMgr.RelationData:AddRelationShip(npc1,"PersonalEnemy");
			else
			me:AddMsg(""..npc2.Name.."：滚！");
			end
		elseif npc2.Sex ~= CS.XiaWorld.g_emNpcSex.Male then--百合
			local sj1 = world:RandomInt(1,3)
			if npc1.PropertyMgr.Practice.Gong.Name == ("Gong_1701_Tu") and npc2.PropertyMgr:CheckFeature("Pogua") ~= true and npc1.LuaHelper:CheckItemEquptCount("Item_Shuangtoulong") > 0 then
			me:AddMsg(""..npc1.Name.."向"..npc2.Name.."提出双修，女女之间怎么可以！"..npc2.Name.." 俏脸一红，不知所措。"..npc1.Name.." 暗催合欢秘法，一股甜腻气息笼罩二人，"..npc2.Name.."只觉得身体燥热难耐， 涓涓细流从大腿处流下。\n"..npc1.Name.."眼见时机成熟便将双头龙插入，"..npc2.Name.."只觉一股电流直冲脑门，下面的汁水也被挤压的四溅开来，娇躯一时便没了力气倒在"..npc1.Name.."身上。\n随着"..npc1.Name.."以合欢秘法催动的香汗不断被"..npc2.Name.."吸入，"..npc2.Name.."渐渐忘了过去，忘了作为修士的骄傲，变成一个只会渴求快感的奴隶，现在她离不开"..npc1.Name.."了，愿意作为女奴，一辈子侍奉她。");
			npc1:AddModifier("XianzheCD");
			npc2:AddModifier("XianzheCD");
			npc1.PropertyMgr:AddFeature("Baihehuakai");
			npc2.PropertyMgr:AddFeature("Baihehuakai");
			npc1.PropertyMgr.RelationData:AddRelationShip(npc2,"Luding2");
			elseif sj1 == 1 or npc2.PropertyMgr:CheckFeature("Baihehuakai") or npc2.PropertyMgr:CheckFeature("Mugou") then
			me:AddMsg(""..npc1.Name.."向"..npc2.Name.."提出双修，"..npc2.Name.." 俏脸一红，不知所措。"..npc1.Name.."不等"..npc2.Name.."回过神来玉指已然深入后者的蜜穴之中，一番挑逗"..npc2.Name.."感觉飘飘欲仙，云雨之后"..npc2.Name.."对百合有了新的理解。");
			npc1:AddModifier("XianzheCD");
			npc2:AddModifier("XianzheCD");
			npc1.PropertyMgr:AddFeature("Baihehuakai");
			npc2.PropertyMgr:AddFeature("Baihehuakai");
			else
			me:AddMsg(""..npc1.Name.."向"..npc2.Name.."提出双修，女女之间怎么可以！"..npc2.Name.."断然拒绝"..npc1.Name.."的请求。");
			end
		else
			if npc1.PropertyMgr:CheckFeature("BeautifulFace3") then
			npc1.PropertyMgr.RelationData:AddRelationShip(npc2,"Luding2");
			npc2:AddModifier("XianzheCD");
			npc1:AddModifier("XianzheCD");
			if npc1.PropertyMgr:CheckFeature("Pogua") ~= true then
			npc1.PropertyMgr:AddFeature("Pogua");
			npc1.PropertyMgr.RelationData:AddRelationShip(npc2,"Chunv");
			end
			me:AddMsg("没有任何男人可能拒绝的了"..npc1.Name.."，"..npc1.Name.."对"..npc2.Name.."提出了性爱的要求，"..npc2.Name.."大喜之余化身为最卑微的公狗，四肢着地的舔舐起了"..npc1.Name.."玉足。\n在"..npc1.Name.."的面前，"..npc2.Name.."没有丝毫尊严的倾服于"..npc1.Name.."，经过"..npc2.Name.."努力且卑微的服侍之后，"..npc1.Name.."同意了"..npc2.Name.."成为自己的狗。");
			elseif Dfxg ~= CS.XiaWorld.g_emJHNpc_Feature.Apathy then--对方性格不是冷漠
				if meili >= random or npc1.PropertyMgr:CheckFeature("BeautifulFace2") or npc1.PropertyMgr:CheckFeature("BeautifulFace1") then--魅力检定，我方女角色魅力大于1~14的随机数既判定成功
					if juqing == 1 then--啪啪啪判定，双方都很愉快
					npc2:AddModifier("XianzheCD");
					npc1:AddModifier("XianzheCD");
					me:AddMsg(""..npc1.Name.."尝试用自己的身体诱惑对方，只见"..npc1.Name.."解开罗裙之际，"..npc2.Name.."便迎上前来小心翼翼的捧起了"..npc1.Name.."玉足。\n"..npc2.Name.."的舌尖在"..npc1.Name.."足间的每一道缝隙中来回穿梭，并不时的将其含入口中细细吮吸，并顺势解开"..npc1.Name.."的亵裤。\n"..npc1.Name..":快，快放进来……人家……\n这是一场令双方均很愉快的双修。");
					elseif juqing == 2 then--啪啪啪判定，我很很愉快，对方不愉快
					npc2:AddModifier("NalitongCD");
					npc1:AddModifier("XianzheCD");
					me:AddMsg(""..npc1.Name.."尝试用自己的身体诱惑对方，见对方目色迷离，"..npc1.Name.."乘势而起一招观音坐莲将对方骑在身下，对方硕大的阳物让"..npc1.Name.."甚至忘记了自己的原本目的，只是沉迷于肉欲的快感之中，而后在激烈的肉搏战中，对方因为没有跟上"..npc1.Name.."扭动的速度，折伤了小兄弟，虽然自己活得的快感，但是对方显然不是很开心。");
					elseif juqing == 3 then--啪啪啪判定，我不愉快，对方愉快
					npc2:AddModifier("XianzheCD");
					npc1:AddModifier("NalitongCD");
					me:AddMsg(""..npc1.Name.."尝试用自己的身体诱惑对方，没想到"..npc2.Name.."色心一起就管不得其他许多了，一顿猛烈到如同狂风骤雨般的冲刺，让"..npc1.Name.."觉得下体仿佛都快被戳烂了，随着对方一泡热力十足的阳精灌注于自己体内后，对方终于缓下的动作，就这么直挺挺的插着自己睡了过去。");
					else
					npc1.PropertyMgr.RelationData:AddRelationShip(npc2,"Luding2");
					npc2:AddModifier("XianzheCD");
					npc1:AddModifier("XianzheCD");
					if CS.GameMain.Instance.FightMap == false then
					npc2.LuaHelper:SetCamp(g_emFightCamp.Player, false)
					end
					me:AddMsg(""..npc1.Name.."假装不经意间的走光引得"..npc2.Name.."色欲大起，那白玉般的足尖尚未完全从履中脱出，"..npc2.Name.."便迫不及待的连带着鞋履捧起了这天赐之物，跪倒在地如同舔舐牛奶的猫咪一般舔舐了起来，只听轻笑见"..npc1.Name.."解下罗裙，蜜穴完完全全展露与"..npc2.Name.."眼前，"..npc2.Name.."仿佛获得了万般激励，顿时化为发情的公狗，于"..npc1.Name.."身上驰骋了数个时辰，知道阳关大泄，此时此刻"..npc2.Name.."才仿佛领悟到了活着的真正意义，成为"..npc1.Name.."石榴裙下的俘虏之一。");
					end
						if npc1.PropertyMgr:CheckFeature("Pogua") ~= true then
						npc1.PropertyMgr:AddFeature("Pogua");
						npc1.PropertyMgr.RelationData:AddRelationShip(npc2,"Chunv");
						end
				else--丑B要有自知之明
				me:AddMsg(""..npc2.Name.."：丑b，滚，别靠近我！");
				npc2:AddModifier("XianzheCD");
				end
			else--对方性格冷漠
				if npc2.Camp ~= npc1.Camp and npc1.Name == "李九妹" then
				me:AddMsg(""..npc2.Name.."是江湖上有名的冷面郎君，斩敌破阵好不容情，可他的冷只在见到"..npc1.Name.."之前能够维持，当他见到"..npc1.Name.."之后，瞬间成为了她裙下之臣，甘愿为她舔脚当狗。");
				npc1.PropertyMgr.RelationData:AddRelationShip(npc2,"Luding2");
				if CS.GameMain.Instance.FightMap == false then
				npc2.LuaHelper:SetCamp(g_emFightCamp.Player, false)
				end
				else
					if npc1.LuaHelper:GetGLevel() > npc2.LuaHelper:GetGLevel() then
						if Wfxg == CS.XiaWorld.g_emJHNpc_Feature.Greedy then--女主比对方实力强，且是贪婪性格
						npc1:AddModifier("XianzheCD");
						npc2:AddModifier("NalitongCD");
						npc1.PropertyMgr:AddMaxAge(5);
						npc2.PropertyMgr:AddMaxAge(- 10);
						npc1.PropertyMgr.RelationData:AddRelationShip(npc2,"Luding2");
						if CS.GameMain.Instance.FightMap == false then
						npc2.LuaHelper:SetCamp(g_emFightCamp.Player, false)
						end
							if npc1.PropertyMgr:CheckFeature("Pogua") ~= true then
							npc1.PropertyMgr:AddFeature("Pogua");
							npc1.PropertyMgr.RelationData:AddRelationShip(npc2,"Chunv");
							end
						me:AddMsg(""..npc2.Name.."冷着脸对"..npc1.Name.."说了一个“滚”字，然而这是修真界，是要凭借实力说话的地方，恼羞成怒的"..npc1.Name.."施展秘术定住了"..npc2.Name.."提裙跨坐于"..npc2.Name.."身上自顾自的摇摆了起来……\n"..npc1.Name.."榨取了整整四个时辰，直到"..npc2.Name.."的下体再也射不出任何精元，"..npc1.Name.."还是依旧没有放过"..npc2.Name.."。\n最终，欲火融化了坚冰，"..npc1.Name.."驯服了"..npc2.Name.."。");
						elseif Wfxg == CS.XiaWorld.g_emJHNpc_Feature.Tenacity then--女主比对方实力强，且是坚毅性格
						npc1:AddModifier("XianzheCD");
						npc2:AddModifier("NalitongCD");
							if npc1.PropertyMgr:CheckFeature("Pogua") ~= true then
							npc1.PropertyMgr:AddFeature("Pogua");
							npc1.PropertyMgr.RelationData:AddRelationShip(npc2,"Chunv");
							end
						me:AddMsg(""..npc2.Name.."冷着脸对"..npc1.Name.."说了一个“滚”字,只听一阵狂放的笑声从"..npc1.Name.."口中传出，只见"..npc1.Name.."制住"..npc2.Name.."后便开始把玩着对方的下体，口中还呢喃着什么“老娘想要的东西，还没有得不到的，人！也一样！”边跨身坐在了"..npc2.Name.."肚下三寸处开始摇摆了起来……\n事毕，"..npc1.Name.."提上罗裙后，还给了"..npc2.Name.."下体一脚嘴里嘟囔着些什么“中看不中用，银样镴枪头”之类的怪话。");
						else
						me:AddMsg(""..npc2.Name.."冷着脸对"..npc1.Name.."说了一句“滚”,显然冷漠性格的人并不吃色诱这一套。");
						end
					else
					me:AddMsg(""..npc2.Name.."冷着脸对"..npc1.Name.."说了一句“滚”,显然冷漠性格的人并不吃色诱这一套。");
					end
				end
			end
		end
	else
	me:AddMsg("对方刚刚被干过对方休息一会把……");
	end
end

function Hudong:Maiyin()--卖淫
npc1 = ThingMgr:FindThingByID(me.npcObj.ID)
npc2 = ThingMgr:FindThingByID(story:GetBindThing().ID)
local XianzheCD = npc2.LuaHelper:GetModifierStack("XianzheCD");
local NalitongCD = npc2.LuaHelper:GetModifierStack("NalitongCD");
local seyouCD = NalitongCD + XianzheCD
local shili = npc1.LuaHelper:GetGLevel()
if npc1.PropertyMgr:CheckFeature("Tiancilonggen") == true then--卖淫有大屌加成
	MYJC1 = 10
	else
	MYJC1 = 0
end
if npc1.PropertyMgr:CheckFeature("BeautifulFace2") == true then--卖淫有惊世美貌加成
	MYJC2 = 10
	else
	MYJC2 = 0
end
if npc1.PropertyMgr:CheckFeature("BeautifulFace1") == true then--卖淫有美貌加成
	MYJC3 = 5
	else
	MYJC3 = 0
end
Jieguo = MYJC3 + MYJC2 + MYJC1 + shili + 1
Piaozi = 50 * npc2.LuaHelper:GetGLevel() + 50
Shouyi = Jieguo * Piaozi
print(Shouyi)
	if seyouCD > 0 then--对方不想嫖娼
	me:AddMsg(""..npc1.Name.."向"..npc2.Name.."提出卖身的想法，但是被"..npc2.Name.."以“刚刚已经爽过了，现在不想干”的理由拒绝了。");
	else
		if npc2.IsVistor == true then--是访客
			if npc1.Sex == CS.XiaWorld.g_emNpcSex.Male and npc1.PropertyMgr.BodyData:PartIsBroken("Genitals")== true then--卖淫者是太监
			me:AddMsg(""..npc1.Name.."向"..npc2.Name.."提出卖身的想法，但是被"..npc2.Name.."以“不想和连吊都没有的男人说话”的理由给拒绝了。");
			elseif npc1.Sex == CS.XiaWorld.g_emNpcSex.Male and npc2.PropertyMgr:CheckFeature("Pogua") == false then --卖淫者是男人，对象是处女
			me:AddMsg(""..npc1.Name.."向"..npc2.Name.."提出卖身的想法，但是被"..npc2.Name.."以“我还是处子，怎么可能……”的理由给拒绝了。");
			elseif npc1.Sex == CS.XiaWorld.g_emNpcSex.Male then --卖淫者是男人
			me:AddMsg(""..npc1.Name.."向"..npc2.Name.."提出卖身的想法，"..npc2.Name.."很愉快的接受了，一阵激情过后，"..npc2.Name.."留下了"..Shouyi.."两银子……。");
			npc2:AddModifier("XianzheCD");npc1:AddModifier("Qian");npc1.PropertyMgr:FindModifier("Qian"):UpdateStack(Shouyi - 1);
			elseif npc1.Sex == CS.XiaWorld.g_emNpcSex.Female and npc1.PropertyMgr:CheckFeature("Pogua") == true then--卖淫者是非处女
			me:AddMsg(""..npc1.Name.."向"..npc2.Name.."提出卖身的想法，"..npc2.Name.."很愉快的接受了，一阵激情过后，"..npc2.Name.."留下了"..Shouyi.."两银子……。");
			npc2:AddModifier("XianzheCD");npc1:AddModifier("Qian");npc1.PropertyMgr:FindModifier("Qian"):UpdateStack(Shouyi - 1);
			elseif npc1.Sex == CS.XiaWorld.g_emNpcSex.Female then--卖淫者是处女
			me:AddMsg(""..npc1.Name.."向"..npc2.Name.."提出卖身的想法，但是被"..npc2.Name.."以“作者懒得写处女卖春文本”的理由拒绝了。");
			else--其他
			me:AddMsg(""..npc1.Name.."向"..npc2.Name.."提出卖身的想法，但是被"..npc2.Name.."拒绝了。");
			end
		else
			if npc2.LuaHelper:GetModifierStack("Qian") < Shouyi then
			me:AddMsg(""..npc1.Name.."向"..npc2.Name.."提出卖身的想法，但是被"..npc2.Name.."以“自己身上没有足够嫖资”的理由给拒绝了。");
			elseif npc1.Sex == CS.XiaWorld.g_emNpcSex.Male and npc1.PropertyMgr.BodyData:PartIsBroken("Genitals")== true then--卖淫者是太监
			me:AddMsg(""..npc1.Name.."向"..npc2.Name.."提出卖身的想法，但是被"..npc2.Name.."以“不想和连吊都没有的男人说话”的理由给拒绝了。");
			elseif npc1.Sex == CS.XiaWorld.g_emNpcSex.Male and npc2.PropertyMgr:CheckFeature("Pogua") == false then --卖淫者是男人，对象是处女
			me:AddMsg(""..npc1.Name.."向"..npc2.Name.."提出卖身的想法，但是被"..npc2.Name.."以“我还是处子，怎么可能……”的理由给拒绝了。");
			elseif npc1.Sex == CS.XiaWorld.g_emNpcSex.Male then --卖淫者是男人
			me:AddMsg(""..npc1.Name.."向"..npc2.Name.."提出卖身的想法，"..npc2.Name.."很愉快的接受了，一阵激情过后，"..npc2.Name.."留下了"..Shouyi.."两银子……。");
			npc2:AddModifier("XianzheCD");npc1:AddModifier("Qian");npc1.PropertyMgr:FindModifier("Qian"):UpdateStack(Shouyi - 1);npc2.PropertyMgr:FindModifier("Qian"):UpdateStack(-Shouyi);
			elseif npc1.Sex == CS.XiaWorld.g_emNpcSex.Female and npc1.PropertyMgr:CheckFeature("Pogua") == true then--卖淫者是非处女
			me:AddMsg(""..npc1.Name.."向"..npc2.Name.."提出卖身的想法，"..npc2.Name.."很愉快的接受了，一阵激情过后，"..npc2.Name.."留下了"..Shouyi.."两银子……。");
			npc2:AddModifier("XianzheCD");npc1:AddModifier("Qian");npc1.PropertyMgr:FindModifier("Qian"):UpdateStack(Shouyi - 1);npc2.PropertyMgr:FindModifier("Qian"):UpdateStack(-Shouyi);
			elseif npc1.Sex == CS.XiaWorld.g_emNpcSex.Female then--卖淫者是处女
			me:AddMsg(""..npc1.Name.."向"..npc2.Name.."提出卖身的想法，但是被"..npc2.Name.."以“作者懒得写处女卖春文本”的理由拒绝了。");
			else--其他
			me:AddMsg(""..npc1.Name.."向"..npc2.Name.."提出卖身的想法，但是被"..npc2.Name.."拒绝了。");
			end
		end
	end
end

function Hudong:Zagan()--榨干
npc1 = ThingMgr:FindThingByID(me.npcObj.ID)
npc2 = ThingMgr:FindThingByID(story:GetBindThing().ID)
local dfm = npc2.LuaHelper:GetProperty("MaxAge")
me:AddMsg(""..npc1.Name.."脱下了衣服勾了勾手指，"..npc2.Name.."急不可耐的冲了上来。"..npc1.Name.."暗自窃喜，不中用的废物，爽完这发还是拿来补我寿元吧！"..npc2.Name.."沉浸在色欲中，丝毫没有任何察觉。一翻云雨之后，"..npc1.Name.."发动功法，吸取"..npc2.Name.."精元寿元，沉浸在事后状态的"..npc2.Name.."发觉时，已经为时已晚，但是因为奴性舍不得对主人狠下心来自爆。只能任由"..npc1.Name.."榨干。魂归大地，再起不能。");
npc1.PropertyMgr:AddMaxAge(dfm);
npc2.PropertyMgr:AddMaxAge(-dfm);
end

function Hudong:Shitu()--师徒潜规则
npc1 = ThingMgr:FindThingByID(me.npcObj.ID)--徒弟
npc2 = ThingMgr:FindThingByID(story:GetBindThing().ID)--师父
local XianzheCD = npc2.LuaHelper:GetModifierStack("XianzheCD");
local NalitongCD = npc2.LuaHelper:GetModifierStack("NalitongCD");
local seyouCD = NalitongCD + XianzheCD
	if npc1.Sex == npc2.Sex or npc1.PropertyMgr.RelationData:IsRelationShipWith("Spouse",npc2) == true or npc1.PropertyMgr.BodyData:PartIsBroken("Genitals") or npc2.PropertyMgr.BodyData:PartIsBroken("Genitals") or seyouCD > 0 then
	me:AddMsg(""..npc1.Name.."有修行上的问题想要向"..npc2.Name.."请教，但是被"..npc2.Name.."以“现在没空的理由”给拒绝了。");
	elseif npc1.Sex == CS.XiaWorld.g_emNpcSex.Male and npc2.PropertyMgr:CheckFeature("Pogua") == true then
	me:AddMsg(""..npc1.Name.."有修行上的问题想要向"..npc2.Name.."请教，"..npc2.Name.."将弟子带入寝殿室后张开双腿以眼神示意，"..npc1.Name.."自是知道师父的意思，连忙上前在师父的身上耕耘了起来……\n事毕，"..npc2.Name.."的性欲得到满足后，便顺口解答了"..npc1.Name.."修行上的疑惑。");
	npc2:AddModifier("XianzheCD");npc1.LuaHelper:AddTreeExp(1000 * npc2.PropertyMgr.Practice:GetDaoHang());npc1.LuaHelper:AddPracticeResource("Stage",1000 * npc2.PropertyMgr.Practice:GetDaoHang());
	elseif npc2.Sex == CS.XiaWorld.g_emNpcSex.Male and npc1.PropertyMgr:CheckFeature("Pogua") == true then
	me:AddMsg(""..npc1.Name.."有修行上的问题想要向"..npc2.Name.."请教，"..npc2.Name.."将弟子带入寝殿室后张开双腿以颜色示意，"..npc1.Name.."自是知道师父的意思，连忙上前捧起了师傅的龙根……\n事毕，"..npc2.Name.."的性欲得到满足后，便顺口解答了"..npc1.Name.."修行上的疑惑。");
	npc2:AddModifier("XianzheCD");npc1.LuaHelper:AddTreeExp(1000 * npc2.PropertyMgr.Practice:GetDaoHang());npc1.LuaHelper:AddPracticeResource("Stage",1000 * npc2.PropertyMgr.Practice:GetDaoHang());
	elseif npc2.Sex == CS.XiaWorld.g_emNpcSex.Male and npc1.PropertyMgr:CheckFeature("Pogua") == false then
	me:AddMsg(""..npc1.Name.."有修行上的问题想要向"..npc2.Name.."请教，"..npc2.Name.."对弟子"..npc1.Name.."的处子之身早已垂涎良久，便将其骗入房间顺势骗奸了……\n事毕，为了补偿"..npc1.Name.."，"..npc2.Name.."传授了其不少自己修行的秘法。");
	npc2:AddModifier("XianzheCD");npc1.PropertyMgr:AddFeature("Pogua");npc1.LuaHelper:AddTreeExp(5000 * npc2.PropertyMgr.Practice:GetDaoHang());npc1.LuaHelper:AddPracticeResource("Stage",1000 * npc2.PropertyMgr.Practice:GetDaoHang());npc1.PropertyMgr.RelationData:AddRelationShip(npc2,"Chunv");
	else
	me:AddMsg(""..npc1.Name.."有修行上的问题想要向"..npc2.Name.."请教，但是被"..npc2.Name.."以“现在没空的理由”给拒绝了。");
	end
end

function Hudong:Yexi()--夜袭，组装文本
local XianzheCD = npc2.LuaHelper:GetModifierStack("XianzheCD");
	if XianzheCD > 0 then
	me:AddMsg(""..npc1.Name.."最近SEX过了。");
	else
		if npc1.Sex == CS.XiaWorld.g_emNpcSex.Male and npc1.PropertyMgr.BodyData:PartIsBroken("Genitals") == false then--男对女非太监
			me:AddMsg(""..npc1.Name.."悄悄的来到了"..npc2.Name.."卧室，看着沉睡中的"..npc2.Name.."，"..npc1.Name.."只觉心中邪念大起。");
			if npc1.PropertyMgr.RelationData:IsRelationShipWith("Child",npc2) then--父女
				if npc1.LuaHelper:GetGLevel() > npc2.LuaHelper:GetGLevel() and npc1.PropertyMgr.Practice:GetDaoHang() > npc2.PropertyMgr.Practice:GetDaoHang() then--是否被发现（实力与道行大于对方）
					me:AddMsg(""..npc1.Name.."以高深的道术使"..npc2.Name.."睡的更沉了……");
					if npc2.PropertyMgr:CheckFeature("Pogua") then
						me:AddMsg("看着女儿"..npc1.Name.."不禁想到，自己女儿"..npc2.Name.."的元阴反正也早就已被别人取走了，既早已不是处子，想来这下身美屄给父亲用上一用也是没有关系的吧？\n于是"..npc1.Name.."掏出了自己的阳物，便在女儿的美屄抽插了起来，这禁忌不伦的行为让"..npc1.Name.."很快就达到了高潮，在女儿"..npc2.Name.."的下身播撒下了自己的种子……\n事毕，"..npc1.Name.."心满意足的离开了。");
						npc1:AddModifier("ShuangxiuCD");
					else
						me:AddMsg("看着女儿"..npc1.Name.."不禁想到，自己女儿"..npc2.Name.."还保留着处子元阴，自身为生父，若是不取，岂不是便宜了其他的杂种？\n于是"..npc1.Name.."掏出了自己的阳物，狠狠的插入了女儿的小穴，处子那尚未开发的肉穴紧紧的箍着"..npc1.Name.."的阳具，"..npc1.Name.."在女儿的处女屄中抽插了百余下便达到了高潮，在女儿"..npc2.Name.."的下身播撒下了自己的种子后"..npc1.Name.."心满意足的离开了。");
						npc2.PropertyMgr:AddFeature("Pogua");npc1:AddModifier("ShuangxiuCD");npc1.PropertyMgr.RelationData:AddRelationShip(npc2,"Chunv");
					end
				else
				me:AddMsg(""..npc1.Name.."想要对"..npc2.Name.."做些什么，却不小心惊醒了"..npc2.Name.."，见"..npc2.Name.."转醒"..npc1.Name.."只能偷偷溜走了……");
				end
			elseif npc1.PropertyMgr.RelationData:IsRelationShipWith("GodChild",npc2) then--义父女
				if npc2.PropertyMgr:CheckFeature("Pogua") then
					me:AddMsg("在"..npc1.Name.."的推搡之下"..npc2.Name.."醒了过来，看着干爹已经亮出的阳物，"..npc2.Name.."张口将其含入口中一阵吮吸。\n待"..npc1.Name.."阳物矗立之时，"..npc1.Name.."便在将其从"..npc2.Name.."的口中抽出，插入"..npc2.Name.."的美屄抽插了起来，听着"..npc2.Name.."声声“爹爹，女儿要被你插死了！”等禁忌不伦的言语，让"..npc1.Name.."很快就达到了高潮，在义女"..npc2.Name.."的下身播撒下了自己的种子……\n事毕，"..npc1.Name.."心满意足的离开了。");
					npc1:AddModifier("ShuangxiuCD");
				else
					me:AddMsg(""..npc2.Name.."在"..npc1.Name.."的推搡之下缓缓醒来，看着干爹已经亮出的阳物，"..npc2.Name.."自是知道等待着自己的是什么，随着破瓜之痛，"..npc2.Name.."失去了她的处子之身……");
					npc2.PropertyMgr:AddFeature("Pogua");npc1:AddModifier("ShuangxiuCD");npc1.PropertyMgr.RelationData:AddRelationShip(npc2,"Chunv");
				end
			elseif npc1.PropertyMgr.RelationData:IsRelationShipWith("Spouse",npc2) then--夫妻
				me:AddMsg("在"..npc1.Name.."的推搡之下"..npc2.Name.."醒了过来，看着丈夫已经亮出的阳物，"..npc2.Name.."张口将其含入口中一阵吮吸。\n事毕，"..npc1.Name.."将精元射入了妻子口中后，便心满意足的离开了。");
				npc1:AddModifier("ShuangxiuCD");
			elseif npc1.PropertyMgr.RelationData:IsRelationShipWith("Luding2",npc2) then--男主女仆
				me:AddMsg("身为女奴母狗的"..npc2.Name.."自然没有什么权利，即使是睡眠时间，作为主人的"..npc1.Name.."只要想要了，就是可以对"..npc2.Name.."为所欲为。\n事毕，"..npc1.Name.."满足的离开了……");
				npc1:AddModifier("ShuangxiuCD");
			elseif npc1.PropertyMgr.RelationData:IsRelationShipWith("Lover",npc2) then--恋人
				if npc2.PropertyMgr:CheckFeature("Pogua") then
					me:AddMsg(""..npc1.Name.."抱起"..npc2.Name.."那白嫩的奶子轻柔的把玩着，"..npc2.Name.."因"..npc1.Name.."的戏弄醒了过来，看到相好那已经立起的小兄弟，不禁舔了舔舌头便将其含入口中。\n待"..npc1.Name.."阳物矗立之时，"..npc1.Name.."便在将其从"..npc2.Name.."的口中抽出，插入"..npc2.Name.."的美屄开始抽插，很快"..npc1.Name.."就达到了高潮，在"..npc2.Name.."的下身射出了自己的精华……\n事毕，"..npc1.Name.."心满意足的离开了。");
					npc1:AddModifier("ShuangxiuCD");
				else
					me:AddMsg(""..npc2.Name.."在"..npc1.Name.."的推搡之下缓缓醒来，看着相好已经亮出的阳物，"..npc2.Name.."自是知道等待着自己的是什么，随着破瓜之痛，"..npc2.Name.."失去了她的处子之身……");
					npc2.PropertyMgr:AddFeature("Pogua");npc1:AddModifier("ShuangxiuCD");npc1.PropertyMgr.RelationData:AddRelationShip(npc2,"Chunv");
				end
			elseif npc1.PropertyMgr.RelationData:IsRelationShipWith("FancyFlag",npc2) then--男是女的男神
			me:AddMsg(""..npc1.Name.."想要对"..npc2.Name.."做些什么，却不小心惊醒了"..npc2.Name.."，见"..npc2.Name.."转醒"..npc1.Name.."只能偷偷溜走了……");
			elseif npc1.PropertyMgr.RelationData:IsRelationShipWith("Fancy",npc2) then--男是女的舔狗
			me:AddMsg(""..npc1.Name.."想要对"..npc2.Name.."做些什么，却不小心惊醒了"..npc2.Name.."，见"..npc2.Name.."转醒"..npc1.Name.."只能偷偷溜走了……");
			elseif npc1.PropertyMgr.RelationData:IsRelationShipWith("PracticeOtherChildChild",npc2) then--男是女的师祖
			me:AddMsg(""..npc1.Name.."想要对"..npc2.Name.."做些什么，却不小心惊醒了"..npc2.Name.."，见"..npc2.Name.."转醒"..npc1.Name.."只能偷偷溜走了……");
			elseif npc1.PropertyMgr.RelationData:IsRelationShipWith("PracticeChildChild",npc2) then--男是女的太师傅
			me:AddMsg(""..npc1.Name.."想要对"..npc2.Name.."做些什么，却不小心惊醒了"..npc2.Name.."，见"..npc2.Name.."转醒"..npc1.Name.."只能偷偷溜走了……");
			elseif npc1.PropertyMgr.RelationData:IsRelationShipWith("PracticeChild",npc2) then--男是女的师傅
			me:AddMsg(""..npc1.Name.."想要对"..npc2.Name.."做些什么，却不小心惊醒了"..npc2.Name.."，见"..npc2.Name.."转醒"..npc1.Name.."只能偷偷溜走了……");
			elseif npc1.PropertyMgr.RelationData:IsRelationShipWith("PracticeMaster",npc2) then--男是女的徒弟
			me:AddMsg(""..npc1.Name.."想要对"..npc2.Name.."做些什么，却不小心惊醒了"..npc2.Name.."，见"..npc2.Name.."转醒"..npc1.Name.."只能偷偷溜走了……");
			elseif npc1.PropertyMgr.RelationData:IsRelationShipWith("PracticeMasterMaster",npc2) then--男是女的徒孙
			me:AddMsg(""..npc1.Name.."想要对"..npc2.Name.."做些什么，却不小心惊醒了"..npc2.Name.."，见"..npc2.Name.."转醒"..npc1.Name.."只能偷偷溜走了……");
			else
			me:AddMsg(""..npc1.Name.."想要对"..npc2.Name.."做些什么，却不小心惊醒了"..npc2.Name.."，见"..npc2.Name.."转醒"..npc1.Name.."只能偷偷溜走了……");
			end
		elseif npc1.Sex == CS.XiaWorld.g_emNpcSex.Female and npc2.PropertyMgr.BodyData:PartIsBroken("Genitals") == false then--女对男非太监
		me:AddMsg(""..npc1.Name.."悄悄的来到了"..npc2.Name.."卧室，看着沉睡中的"..npc2.Name.."，"..npc1.Name.."只觉心中邪念大起。");
		me:AddMsg(""..npc1.Name.."想要对"..npc2.Name.."做些什么，却不小心惊醒了"..npc2.Name.."，见"..npc2.Name.."转醒"..npc1.Name.."只能偷偷溜走了……");
		else
		me:AddMsg(""..npc1.Name.."悄悄的来到了"..npc2.Name.."卧室，看着沉睡中的"..npc2.Name.."，"..npc1.Name.."只觉心中邪念大起。");
		me:AddMsg(""..npc1.Name.."想要对"..npc2.Name.."做些什么，却不小心惊醒了"..npc2.Name.."，见"..npc2.Name.."转醒"..npc1.Name.."只能偷偷溜走了……");
		end
	end
end

function Hudong:Jingyu()--精浴
npc1 = ThingMgr:FindThingByID(me.npcObj.ID)
	if npc1.Sex == CS.XiaWorld.g_emNpcSex.Male then
	me:AddMsg(""..npc1.Name.."右手一挥袖口散出百道水柱，汇入并化作满桶阴精，左手打了个指诀，将衣裳褪去露出健硕身材。\n"..npc1.Name.."清楚的感应到浴桶中元阴之力的澎湃，迫不及待的踏入浴桶并且盘腿坐在木盆之中。\n"..npc1.Name.."双手结印，阴精的精华随着每一个毛孔被吸入，"..npc1.Name.."能感觉到其中的精气正在化入身体，为其补充精元。");
	npc1.PropertyMgr.Practice.BodyPracticeData:AddQuenchingItem("Item_yinjin",-100)
	npc1.Needs:AddNeedValue(CS.XiaWorld.g_emNeedType.Practice,2000)
	else
	me:AddMsg(""..npc1.Name.."右手一挥袖口散出百道白光，汇入并化作满桶阳精，左手打了个指诀，将衣裳褪去露出曼妙身材。\n一想到要入桶沐浴，自己一个女孩子家要入这污秽之中，简直犹如受刑！这白灼液体散发出的阵阵腥臭，更是令"..npc1.Name.."心生退却，但"..npc1.Name.."清楚的感应到浴桶中元阳之力的澎湃，无奈只能咬着牙心中不断默念，这是木楠花的味道！这是木楠花的味道！\n踏入浴桶且盘腿坐在木盆之中，满桶阳精正好没过胸口，"..npc1.Name.."双手结印，阳精的精华随着每一个毛孔被吸入，"..npc1.Name.."能感觉到其中的精气正在化入身体，为其补充精元。");
	npc1.PropertyMgr.Practice.BodyPracticeData:AddQuenchingItem("Item_yangjin",-100)
	npc1.Needs:AddNeedValue(CS.XiaWorld.g_emNeedType.Practice,2000)
	end
end

function Hudong:Tuzai()--屠宰
npc1 = ThingMgr:FindThingByID(me.npcObj.ID)
sirenshu = 0
local npc2s = Map.Things:GetNpcsLua(
	function(n)
		return n.IsDeath ;
	end);
	for i = 0, npc2s.Count-1, 1 do
	local npc2 = npc2s[i];
		if npc2 ~= nil then
			if npc2.IsPlayerThing then
			else
			ThingMgr:RemoveThing(npc2,false,true)
			sirenshu = sirenshu + 1
			end
		end
	end
	me:AddMsg("共"..sirenshu.."具尸体被"..npc1.Name.."屠宰成了肉块保存起来……");
	npc1.LuaHelper:DropAwardItem("Item_HumanMeat",50*sirenshu);
end

function Hudong:Xieeliancheng()
npc1 = ThingMgr:FindThingByID(me.npcObj.ID)
sirenshu = 0
xuelingzhi = 0
xuequan = 0
local npc2s = Map.Things:GetNpcsLua(
	function(n)
		return (n.IsDeath or n:CheckHealthState(g_emNpcHealthState.Dying) or n:CheckHealthState(g_emNpcHealthState.Coma)) and n.Camp == CS.XiaWorld.Fight.g_emFightCamp.Enemy;
	end);
	for i = 0, npc2s.Count-1, 1 do
	local npc2 = npc2s[i];
		if npc2 ~= nil then
			if npc2.IsPlayerThing then
			else
			ThingMgr:RemoveThing(npc2,false,true)
			sirenshu = sirenshu + 1
			end
			if npc2.LuaHelper:GetGLevel() > 6 then
			xuelingzhi = xuelingzhi +1
			elseif npc2.LuaHelper:GetGLevel() > 3 then
			xuequan = xuequan + 1
			else
			end
		end
	end
	me:AddMsg("共"..sirenshu.."人被"..npc1.Name.."使用铁处女炼化成了精血以及邪丹……");
	npc1.LuaHelper:DropAwardItem("Item_HumanMeat",50*sirenshu);
	npc1.LuaHelper:DropAwardItem("Item_Jingxue",sirenshu);
	npc1.LuaHelper:DropAwardItem("Item_EarthEssence1",xuequan);
	npc1.LuaHelper:DropAwardItem("Item_EarthEssence1_1",xuelingzhi);
end
-------------------历练单人综合事件判定系统

function Hudong:HehuanNanxingPD()--判定变量主角是男性
npc1 = ThingMgr:FindThingByID(me.npcObj.ID)
if npc1.Sex ~= CS.XiaWorld.g_emNpcSex.Male then
return false;
else
return true;
end
return false;
end

function Hudong:HehuanNvnxingPD()--判定变量主角是女性
npc1 = ThingMgr:FindThingByID(me.npcObj.ID)
if npc1.Sex == CS.XiaWorld.g_emNpcSex.Male then
return false;
else
return true;
end
return false;
end

function Hudong:Renwu1PD()--判定变量“RWPanding”1~100的随机数，大于70为判定成功显示该任务
npc1 = ThingMgr:FindThingByID(me.npcObj.ID)
if RWPanding <= 70 then
return false;
else
return true;
end
return false;
end


function Hudong:Suiji1PD()--判定变量“NPCPanding”1~100的随机数，大于90为判定成功显示该NPC
npc1 = ThingMgr:FindThingByID(me.npcObj.ID)
if NPCPanding <= 90 then
return false;
else
return true;
end
return false;
end

function Hudong:Suiji2PD()--判定变量“NPCPanding”1~100的随机数，小于10为判定成功显示该NPC
npc1 = ThingMgr:FindThingByID(me.npcObj.ID)
if NPCPanding >= 10 then
return false;
else
return true;
end
return false;
end

function Hudong:HehuanNanYouDiaoPD()--判定变量主角是否是会采补功法的有吊男性
npc1 = ThingMgr:FindThingByID(me.npcObj.ID)
if npc1.PropertyMgr.Practice:CheckIsLearnedEsoteric("Gong1701_Esoterica_1") == false or npc1.Sex ~= CS.XiaWorld.g_emNpcSex.Male or npc1.PropertyMgr.BodyData:PartIsBroken("Genitals") then
return false;
else
return true;
end
return false;
end

function Hudong:PutongchunvPD()--判定变量主角是处女
npc1 = ThingMgr:FindThingByID(me.npcObj.ID)
if npc1.Sex == CS.XiaWorld.g_emNpcSex.Male or npc1.PropertyMgr:CheckFeature("Pogua") == true then
return false;
else
return true;
end
return false;
end

function Hudong:PutongfeichunvPD()--判定变量主角是漂亮的非处女
npc1 = ThingMgr:FindThingByID(me.npcObj.ID)
if npc1.Sex == CS.XiaWorld.g_emNpcSex.Male or npc1.PropertyMgr:CheckFeature("Pogua") ~= true or npc1.LuaHelper:GetCharisma() < 7 then
return false;
else
return true;
end
return false;
end

function Hudong:haitongnvPD()--幼女体态
npc1 = ThingMgr:FindThingByID(me.npcObj.ID)
if npc1.Sex == CS.XiaWorld.g_emNpcSex.Male or npc1.LuaHelper:GetModifierStack("Haitong") == 0 then
return false;
else
return true;
end
return false;
end

function Hudong:TuzaiPD()--屠宰
if npc1.RaceDefName == "Human" then
return false;
else
return true;
end
end

function Hudong:JingyuPD()--精浴
npc1 = ThingMgr:FindThingByID(me.npcObj.ID)
if npc1.GongKind ~= g_emGongKind.Body then
return false;
elseif (npc1.Sex == CS.XiaWorld.g_emNpcSex.Male and npc1.PropertyMgr.Practice.BodyPracticeData:GetQuenchingItemCount("Item_yinjin") > 99) or (npc1.Sex == CS.XiaWorld.g_emNpcSex.Female and npc1.PropertyMgr.Practice.BodyPracticeData:GetQuenchingItemCount("Item_yangjin") > 99) then
return true;
else
return false;
end
end

function Hudong:Ymeinv1renPD()--判定变量主角是否拥有一个以上的美女俘虏
npc1 = ThingMgr:FindThingByID(me.npcObj.ID)
if npc1.LuaHelper:GetModifierStack("Luding4") == 0 then
return false;
else
return true;
end
return false;
end

function Hudong:TuhaojianyuPD()--判定变量主角是否拥100W，且未开启监狱
npc1 = ThingMgr:FindThingByID(me.npcObj.ID)
if npc1.LuaHelper:GetModifierStack("Qian") < 1000000 or world:GetWorldFlag(1707) == 1 then
return false;
else
return true;
end
return false;
end

function Hudong:ShuijiaoPD()--判定对方是否在睡觉
npc1 = ThingMgr:FindThingByID(me.npcObj.ID)
npc2 = ThingMgr:FindThingByID(story:GetBindThing().ID)
if npc2.IsSleeping and npc1.Sex ~= npc2.Sex and npc1.Race.RaceType == npc2.Race.RaceType then
return true;
end
return false;
end

function Hudong:ShuijiaonoPD()--判定对方是否在不睡觉
npc2 = ThingMgr:FindThingByID(story:GetBindThing().ID)
if npc2.IsSleeping == false then
return true;
end
return false;
end

function Hudong:MaiyinPD()--卖淫判定
npc1 = ThingMgr:FindThingByID(me.npcObj.ID)
npc2 = ThingMgr:FindThingByID(story:GetBindThing().ID)
if npc1.Sex == npc2.Sex or npc1.PropertyMgr.RelationData:IsRelationShipWith("Spouse",npc2) == true or npc1.PropertyMgr.RelationData:IsRelationShipWith("Luding2",npc2) == true or npc1.PropertyMgr.RelationData:IsRelationShipWith("Luding1",npc2) == true or npc2.Camp ~= npc1.Camp or npc2.IsSmartRace == false or npc2.IsSleeping then
return false;
else
return true;
end
return false;
end

function Hudong:ShituPD()--师徒潜规则判定
npc1 = ThingMgr:FindThingByID(me.npcObj.ID)
npc2 = ThingMgr:FindThingByID(story:GetBindThing().ID)
if npc1.PropertyMgr.RelationData:IsRelationShipWith("PracticeMaster",npc2) == false or npc2.IsSleeping then
return false;
else
return true;
end
return false;
end

function Hudong:ZaganPD()--榨干判定
npc1 = ThingMgr:FindThingByID(me.npcObj.ID)
npc2 = ThingMgr:FindThingByID(story:GetBindThing().ID)
if npc1.Sex == CS.XiaWorld.g_emNpcSex.Male or npc1.Sex == npc2.Sex or npc1.PropertyMgr.RelationData:IsRelationShipWith("Luding2",npc2) == false then
return false;
else
return true;
end
return false;
end

function Hudong:LingshouSex()
	if npc2.RaceDefName == "LsFox" then
		if npc1.PropertyMgr:CheckFeature("Tongling_long") or npc1.PropertyMgr:CheckFeature("Tongling_feng") or npc1.PropertyMgr:CheckFeature("Tongling_gou") then
		me:AddMsg(""..npc1.Name.."听说与守护灵狐人兽和一，可以增强术法威力，于是乎便找灵狐诉说原由，希望助己修行。\n灵狐看了一眼"..npc1.Name.."回答道：“你已经是其他灵兽的魂侍了……”");
		elseif npc1.Sex == CS.XiaWorld.g_emNpcSex.Female and npc1.GongKind ~= g_emGongKind.Body then
			if npc1.PropertyMgr:CheckFeature("Tongling_linghu") and npc1.PropertyMgr.SkillData:GetSkillLevel(CS.XiaWorld.g_emNpcSkillType.FightSkill) < 100 then
			me:AddMsg(""..npc1.Name.."找灵狐诉说原由，希望助己修行，灵狐前踏一步，天灵之中射出一道青光直通"..npc1.Name.."灵台穴，"..npc1.Name.."的术法能力有了质的飞跃。");
			npc1.PropertyMgr.SkillData:AddSkillLevelOverAddion(CS.XiaWorld.g_emNpcSkillType.FightSkill,1)
			elseif npc1.PropertyMgr.SkillData:GetSkillLevel(CS.XiaWorld.g_emNpcSkillType.FightSkill) < 100 then
			me:AddMsg(""..npc1.Name.."听说与守护灵狐人兽和一，可以增强术法威力，于是乎便找灵狐诉说原由，希望助己修行。\n听罢灵狐哈哈大笑：小姑娘你可知道本狐仙的那话儿有多大吗？足足有你手臂那么粗，哈哈哈你这小姑娘你可真是个妙人！罢了，今个本狐仙心情好便告诉你真正的增强方法吧。\n可"..npc1.Name.."满脸通红还沉浸在，灵狐手臂粗的那话儿，究竟能不能放进去？的想象之中丝毫没有注意灵狐说的话，直到一声轻咳将"..npc1.Name.."带回现实。\n小姑娘你有没有听本狐仙说话啊，本狐仙授道可是很难得的！\n抱歉，灵狐大人，我走神了。\n守护灵狐想了想，说到看来口说不行，要让你亲身体会一下了，灵狐前踏一步，天灵之中射出一道青光直通"..npc1.Name.."灵台穴，"..npc1.Name.."的术法能力有了质的飞跃。");
			npc1.PropertyMgr.SkillData:AddSkillLevelOverAddion(CS.XiaWorld.g_emNpcSkillType.FightSkill,1)
			else
			me:AddMsg(""..npc1.Name.."找灵狐诉说原由，希望助己修行，灵狐前踏一步，天灵之中射出一道青光直通"..npc1.Name.."灵台穴，"..npc1.Name.."的术法能力已至化境，无法继续提升了。");
			end
			npc1:AddModifier("XianzheCD");
			if npc1.PropertyMgr:CheckFeature("Tongling_linghu") == false then
			npc1.PropertyMgr:AddFeature("Tongling_linghu");
			end
		else
		me:AddMsg(""..npc1.Name.."听说与守护灵狐人兽和一，可以增强术法威力，于是乎便找灵狐诉说原由，希望助己修行。\n灵狐拒绝了"..npc1.Name.."");
		end
	elseif npc2.RaceDefName == "LsDragon" then
		if npc1.PropertyMgr:CheckFeature("Tongling_linghu") or npc1.PropertyMgr:CheckFeature("Tongling_feng") or npc1.PropertyMgr:CheckFeature("Tongling_gou") then
		me:AddMsg(""..npc1.Name.."听说与守护神龙人兽和一，可以增护体之术，于是乎便找护派灵龙诉说原由，希望助己修行。\n灵龙看了一眼"..npc1.Name.."回答道：“你已经是其他灵兽的魂侍了……”");
		elseif npc1.Sex == CS.XiaWorld.g_emNpcSex.Female and npc1.GongKind ~= g_emGongKind.Body then
			if npc1.PropertyMgr:CheckFeature("Tongling_long") and npc1.PropertyMgr.SkillData:GetSkillLevel(CS.XiaWorld.g_emNpcSkillType.Barrier) < 100 then
			me:AddMsg(""..npc1.Name.."希望能提升护体能力，便去寻求门内灵龙的帮助。\n灵龙思考片刻便欣然答应，只道：嘿嘿，你可别后悔。说罢，大喝一声龙王喷水！一股碗口大的水柱直冲"..npc1.Name.."。\n"..npc1.Name.."哪里反应的过来，已然被冲的满地翻滚。\n就在"..npc1.Name.."一次又一次的水压对抗中，护体能力得到了显著提高，真是可喜可贺。");
			npc1.PropertyMgr.SkillData:AddSkillLevelOverAddion(CS.XiaWorld.g_emNpcSkillType.Barrier,1)
			elseif npc1.PropertyMgr.SkillData:GetSkillLevel(CS.XiaWorld.g_emNpcSkillType.Barrier) < 100 then
			me:AddMsg(""..npc1.Name.."听说与守护神龙人兽和一，可以增护体之术，于是乎便找护派灵龙诉说原由，希望助己修行。\n听罢灵龙哈哈大笑：小姑娘你可知道本尊是雌的么？哈哈哈你这小姑娘你可真是个妙人！罢了，今个本尊心情好便告诉你真正的增强方法吧。\n说罢，大喝一声龙王喷水！一股碗口大的水柱直冲"..npc1.Name.."。\n"..npc1.Name.."哪里反应的过来，已然被冲的满地翻滚。\n就在"..npc1.Name.."一次又一次的水压对抗中，护体能力得到了显著提高，真是可喜可贺。");
			npc1.PropertyMgr.SkillData:AddSkillLevelOverAddion(CS.XiaWorld.g_emNpcSkillType.Barrier,1)
			else
			me:AddMsg(""..npc1.Name.."找灵龙诉说原由，希望助己修行，灵龙前踏一步，大喝一声龙王喷水！一股碗口大的水柱直冲"..npc1.Name.."。\n"..npc1.Name.."哪里反应的过来，已然被冲的满地翻滚，然而"..npc1.Name.."的护体能力已至化境，无法继续提升了。");
			end
			npc1:AddModifier("XianzheCD");
			if npc1.PropertyMgr:CheckFeature("Tongling_long") == false then
			npc1.PropertyMgr:AddFeature("Tongling_long");
			end
		else
		me:AddMsg(""..npc1.Name.."听说与守护灵龙人兽和一，可以增强护体之术，于是乎便找灵龙诉说原由，希望助己修行。\n灵龙拒绝了"..npc1.Name.."");
		end
	elseif npc2.RaceDefName == "LsPhoenix" then
		if npc1.PropertyMgr:CheckFeature("Tongling_linghu") or npc1.PropertyMgr:CheckFeature("Tongling_long") or npc1.PropertyMgr:CheckFeature("Tongling_gou") then
		me:AddMsg(""..npc1.Name.."希望能提升御器能力，便去寻求门内灵凰的帮助。\n灵凰看了一眼"..npc1.Name.."回答道：“你已经是其他灵兽的魂侍了……”");
		elseif npc1.Sex == CS.XiaWorld.g_emNpcSex.Female and npc1.GongKind ~= g_emGongKind.Body then
			if npc1.PropertyMgr:CheckFeature("Tongling_feng") and npc1.PropertyMgr.SkillData:GetSkillLevel(CS.XiaWorld.g_emNpcSkillType.Fabao) < 100 then
			me:AddMsg(""..npc1.Name.."希望能提升御器能力，便去寻求门内灵凰的帮助。\n灵凰对求道若渴的修士，甚是喜爱，便欣然答应，一声凤鸣，唤来一本天书。\n吾名为《三千年御器五千年模拟》就让吾教导你御器之道。\n天书通灵，能口吐人言，并不稀奇。于是乎"..npc1.Name.."在天书“耐心”的教导下口嗨，嘲讽，爆粗，御器的能力得到了显著提高。至于心理阴影面积增加多少，这就不重要了。");
			npc1.PropertyMgr.SkillData:AddSkillLevelOverAddion(CS.XiaWorld.g_emNpcSkillType.Fabao,1)
			elseif npc1.PropertyMgr.SkillData:GetSkillLevel(CS.XiaWorld.g_emNpcSkillType.Fabao) < 100 then
			me:AddMsg(""..npc1.Name.."听说与守护神凰人兽和一，可以增护体之术，于是乎便找护派灵凰诉说原由，希望助己修行。\n听罢灵凰哈哈大笑：小姑娘你可知道本尊是雌的么？哈哈哈你这小姑娘你可真是个妙人！罢了，今个本尊心情好便告诉你真正的增强方法吧。\n言毕，一声凤鸣，唤来一本天书。\n吾名为《三千年御器五千年模拟》就让吾教导你御器之道。\n天书通灵，能口吐人言，并不稀奇。于是乎"..npc1.Name.."在天书“耐心”的教导下口嗨，嘲讽，爆粗，御器的能力得到了显著提高。至于心理阴影面积增加多少，这就不重要了。");
			npc1.PropertyMgr.SkillData:AddSkillLevelOverAddion(CS.XiaWorld.g_emNpcSkillType.Fabao,1)
			else
			me:AddMsg(""..npc1.Name.."找灵凰诉说原由，希望助己修行，凤凰对求道若渴的修士，甚是喜爱，便欣然答应，一声凤鸣，唤来一本天书，然而"..npc1.Name.."的驭器能力已至化境，无法继续提升了。");
			end
			npc1:AddModifier("XianzheCD");
			if npc1.PropertyMgr:CheckFeature("Tongling_feng") == false then
			npc1.PropertyMgr:AddFeature("Tongling_feng");
			end
		else
		me:AddMsg(""..npc1.Name.."听说与守护灵凰人兽和一，可以增强驭器之术，于是乎便找灵凰诉说原由，希望助己修行。\n灵凰拒绝了"..npc1.Name.."");
		end
	else
		if npc1.PropertyMgr:CheckFeature("Tongling_linghu") or npc1.PropertyMgr:CheckFeature("Tongling_long") or npc1.PropertyMgr:CheckFeature("Tongling_feng") or npc1.Sex ~= CS.XiaWorld.g_emNpcSex.Female or npc1.GongKind ~= g_emGongKind.Body then
		me:AddMsg(""..npc2.Name.."自己跑开了……");
		else
			if npc1.PropertyMgr:CheckFeature("Tongling_gou") and npc1.PropertyMgr.SkillData:GetSkillLevel(CS.XiaWorld.g_emNpcSkillType.Fight) < 100 then
			me:AddMsg(""..npc1.Name.."与"..npc2.Name.."交合，被灵犬精元灌入体内，滋养了自身肉体……\n"..npc1.Name.."自身战斗能力有了飞跃级的进步…………");
			npc1.Needs:AddNeedValue(CS.XiaWorld.g_emNeedType.Practice,500);
			npc1.PropertyMgr.SkillData:AddSkillLevelOverAddion(CS.XiaWorld.g_emNpcSkillType.Fight,1);
			elseif npc1.PropertyMgr.SkillData:GetSkillLevel(CS.XiaWorld.g_emNpcSkillType.Fight) < 100 then
			me:AddMsg(""..npc1.Name.."伸出手指蘸取了些许蜂蜜涂在下身，蜂蜜又浆又腻，肉穴前的黑森林也因为蜂蜜被黏绕在了一起，有些许蜂蜜还顺着缝隙流到肉穴里。\n"..npc2.Name.."对于甜食完全没没有任何抵抗力，伸出长舌拼命舔，津津有味，最后还用舌尖撩进阴户内，去舔那些藏在深处和缝间的残余糖浆。\n狗的舌头比人长许多，一舔下去，触到的面积更大，几个敏感部 位一齐能受到刺激，加上舌头上有很多小肉粒，好像有一张柔软的砂纸在轻轻磨。\n蜂蜜还没舔清，"..npc1.Name.."倒给它舔得心如鹿撞，麻痒难熬"..npc1.Name.."伸腿盘住了"..npc2.Name.."的脑袋，使其与自己肉穴的接触变得更加紧密无间，不多久"..npc1.Name.."便感到全身发热，不知不觉间竟然有些阴精流了出来。\n许是大自然雌性动物的分泌对雄性都有催情作用，加上"..npc2.Name.."鼻子的嗅觉特别灵敏，舔着舔着，"..npc2.Name.."公本来藏在体内看不见的阳具竟然伸了出外，又红又尖的龟头从厚厚的包皮中冒出，阴茎渐渐变得越来越长，越来越硬。\n见事，"..npc1.Name.."换了个姿势躺倒在"..npc2.Name.."的旁边，把阳具从它胯下拉过来，放进自己的口中，谁知"..npc2.Name.."的阳根实在太长了，口里放不下，迫得一边用手替它套捋，一边只用舌尖在龟头上舔着，"..npc2.Name.."的阳具和人祖的又不大相同，包皮厚很多，而且皮外近龟头处长了好些尖尖的小肉刺，龟头的肉嫩一点，但却是尖尖长长的，不似人族那么混圆，"..npc2.Name.."被"..npc1.Name.."舔了不一会，也来劲了，鼻子发出呜呜的低鸣，两条后腿不停在地上扒。\n见其急不可耐的样子，作势翻了一个伏于地面，屁股高高的抬起姿势就像一只春情焕发的母狗。"..npc2.Name.."一看见她趴下就立即夹着尾巴爬上她背，阴茎在"..npc2.Name.."桃花源部附近乱撩，"..npc1.Name.."怕它错乱中误插进谷道里，连忙用手替它扶正，引领它的龟头对准湿濡的桃源口。\n又大又长的阳具找着了目标，开始插进"..npc1.Name.."的阴户，起初只能插进一大半，连插了七八下才能全部进入。当"..npc2.Name.."在阴道里抽送时，大概是塞得太满了，里面的蜜汁都给挤出来，每捅进一下，混合着蜜汁的淫水就往外喷出一股。"..npc2.Name.."将肚子紧贴她的背部 ，前脚搁在她纤腰两旁，弓着背一收一放，每一下都把龟头顶到她"..npc1.Name.."子宫口，酥麻的感觉一阵一阵地涌上脑袋。\n只见"..npc1.Name.."全身在打颤，毛孔都起了疙瘩，香汗直流，她尝到一种从来都没试过的特殊滋味，真想不到和犬类灵兽性交如此刺激，比起那些只懂摧残女性毫不怜香惜玉的人，真是连禽兽也不如……\n"..npc1.Name.."因为与犬灵交合，被灵犬精元灌入体内，滋养了自身肉体……\n"..npc1.Name.."成为犬灵灵侍自身战斗能力有了飞跃级的进步……");
			npc1.PropertyMgr:AddFeature("Tongling_gou");
			npc1.Needs:AddNeedValue(CS.XiaWorld.g_emNeedType.Practice,500);
			npc1.PropertyMgr.SkillData:AddSkillLevelOverAddion(CS.XiaWorld.g_emNpcSkillType.Fight,1);
			else
			me:AddMsg(""..npc1.Name.."与"..npc2.Name.."交合，，被灵犬精元灌入体内，滋养了自身肉体，但因自身战斗实力早已超凡脱俗，故没有太大的提升……");
			npc1.Needs:AddNeedValue(CS.XiaWorld.g_emNeedType.Practice,500);
			end
			npc1:AddModifier("XianzheCD");
		end
	end
end

function Hudong:xuexi()
	if (npc1.GongKind == g_emGongKind.Body or npc2.GongKind == g_emGongKind.Body) and npc1.GongKind ~= npc2.GongKind then--一方是体修
		npc1.Needs:AddNeedValue(CS.XiaWorld.g_emNeedType.Practice,npc2.LuaHelper:GetGLevel() * 10)
		npc2.Needs:AddNeedValue(CS.XiaWorld.g_emNeedType.Practice,npc1.LuaHelper:GetGLevel() * 10)
		if npc1.GongKind == g_emGongKind.Body then
			if npc1.Sex == CS.XiaWorld.g_emNpcSex.Male then
				if ThingMgr:FindThingByID(npc2.ID).PropertyMgr.Practice.GodCount > 0 then
				npc1.PropertyMgr.Practice.BodyPracticeData:AddQuenchingItem("Item_yinjin",32);
				elseif npc2.LuaHelper:GetGLevel() > 9 then
				npc1.PropertyMgr.Practice.BodyPracticeData:AddQuenchingItem("Item_yinjin",16);
				elseif npc2.LuaHelper:GetGLevel() > 6 then
				npc1.PropertyMgr.Practice.BodyPracticeData:AddQuenchingItem("Item_yinjin",8);
				elseif npc2.LuaHelper:GetGLevel() > 3 then
				npc1.PropertyMgr.Practice.BodyPracticeData:AddQuenchingItem("Item_yinjin",4);
				elseif npc2.LuaHelper:GetGLevel() > 0 then
				npc1.PropertyMgr.Practice.BodyPracticeData:AddQuenchingItem("Item_yinjin",2);
				else
				npc1.PropertyMgr.Practice.BodyPracticeData:AddQuenchingItem("Item_yinjin",1);
				end
			else
				if ThingMgr:FindThingByID(npc2.ID).PropertyMgr.Practice.GodCount > 0 then
				npc1.PropertyMgr.Practice.BodyPracticeData:AddQuenchingItem("Item_yangjin",32);
				elseif npc2.LuaHelper:GetGLevel() > 9 then
				npc1.PropertyMgr.Practice.BodyPracticeData:AddQuenchingItem("Item_yangjin",16);
				elseif npc2.LuaHelper:GetGLevel() > 6 then
				npc1.PropertyMgr.Practice.BodyPracticeData:AddQuenchingItem("Item_yangjin",8);
				elseif npc2.LuaHelper:GetGLevel() > 3 then
				npc1.PropertyMgr.Practice.BodyPracticeData:AddQuenchingItem("Item_yangjin",4);
				elseif npc2.LuaHelper:GetGLevel() > 0 then
				npc1.PropertyMgr.Practice.BodyPracticeData:AddQuenchingItem("Item_yangjin",2);
				else
				npc1.PropertyMgr.Practice.BodyPracticeData:AddQuenchingItem("Item_yangjin",1);
				end
			end
			if npc2.RaceDefName == "Human_JGZT" then--判定对象为通灵精怪
			Jg = ThingMgr:FindThingByID(npc2.ThingToHuman.thingid)
			Jingguai = ThingMgr:FindThingByID(npc2.ID)
			Tixiu = ThingMgr:FindThingByID(npc1.ID)
			Hudong:xuexi2()
			end
		else
			if npc1.Sex == CS.XiaWorld.g_emNpcSex.Male then
				if ThingMgr:FindThingByID(npc1.ID).PropertyMgr.Practice.GodCount > 0 then
				npc2.PropertyMgr.Practice.BodyPracticeData:AddQuenchingItem("Item_yangjin",32);
				elseif npc1.LuaHelper:GetGLevel() > 9 then
				npc2.PropertyMgr.Practice.BodyPracticeData:AddQuenchingItem("Item_yangjin",16);
				elseif npc1.LuaHelper:GetGLevel() > 6 then
				npc2.PropertyMgr.Practice.BodyPracticeData:AddQuenchingItem("Item_yangjin",8);
				elseif npc1.LuaHelper:GetGLevel() > 3 then
				npc2.PropertyMgr.Practice.BodyPracticeData:AddQuenchingItem("Item_yangjin",4);
				elseif npc1.LuaHelper:GetGLevel() > 0 then
				npc2.PropertyMgr.Practice.BodyPracticeData:AddQuenchingItem("Item_yangjin",2);
				else
				npc2.PropertyMgr.Practice.BodyPracticeData:AddQuenchingItem("Item_yangjin",1);
				end
			else
				if ThingMgr:FindThingByID(npc1.ID).PropertyMgr.Practice.GodCount > 0 then
				npc2.PropertyMgr.Practice.BodyPracticeData:AddQuenchingItem("Item_yinjin",32);
				elseif npc1.LuaHelper:GetGLevel() > 9 then
				npc2.PropertyMgr.Practice.BodyPracticeData:AddQuenchingItem("Item_yinjin",16);
				elseif npc1.LuaHelper:GetGLevel() > 6 then
				npc2.PropertyMgr.Practice.BodyPracticeData:AddQuenchingItem("Item_yinjin",8);
				elseif npc1.LuaHelper:GetGLevel() > 3 then
				npc2.PropertyMgr.Practice.BodyPracticeData:AddQuenchingItem("Item_yinjin",4);
				elseif npc1.LuaHelper:GetGLevel() > 0 then
				npc2.PropertyMgr.Practice.BodyPracticeData:AddQuenchingItem("Item_yinjin",2);
				else
				npc2.PropertyMgr.Practice.BodyPracticeData:AddQuenchingItem("Item_yinjin",1);
				end
			end
			if npc1.RaceDefName == "Human_JGZT" then--判定对象为通灵精怪
			Jg = ThingMgr:FindThingByID(npc1.ThingToHuman.thingid)
			Jingguai = ThingMgr:FindThingByID(npc1.ID)
			Tixiu = ThingMgr:FindThingByID(npc2.ID)
			Hudong:xuexi2()
			end
		end
		npc1:AddModifier("ShuangxiuCD");
		npc2:AddModifier("ShuangxiuCD");
	elseif (npc1.GongKind == g_emGongKind.Body or npc2.GongKind == g_emGongKind.Body) and npc1.GongKind == npc2.GongKind then--双方是体修
	npc1.Needs:AddNeedValue(CS.XiaWorld.g_emNeedType.Practice,npc2.LuaHelper:GetGLevel() * 50)
	npc2.Needs:AddNeedValue(CS.XiaWorld.g_emNeedType.Practice,npc1.LuaHelper:GetGLevel() * 50)
	npc1:AddModifier("ShuangxiuCD");
	npc2:AddModifier("ShuangxiuCD");
	else
		local miji = npc2.LuaHelper:GetRandomEsotericName();
		local miji2 = npc1.LuaHelper:GetRandomEsotericName();
		npc1:AddModifier("ShuangxiuCD");
		npc2:AddModifier("ShuangxiuCD");
		npc1.Needs:AddNeedValue(CS.XiaWorld.g_emNeedType.Practice,npc2.LuaHelper:GetGLevel() * 10)
		npc2.Needs:AddNeedValue(CS.XiaWorld.g_emNeedType.Practice,npc1.LuaHelper:GetGLevel() * 10)
		npc1.LuaHelper:AddTreeExp(1000 * npc2.LuaHelper:GetGLevel());
		npc2.LuaHelper:AddTreeExp(1000 * npc1.LuaHelper:GetGLevel());
		npc2:AddLing(npc1.LuaHelper:GetProperty("NpcLingMaxValue"));
		npc1:AddLing(npc2.LuaHelper:GetProperty("NpcLingMaxValue"));
		npc1.LuaHelper:AddPracticeResource("Stage",5 * npc2.PropertyMgr.Practice:GetDaoHang() * npc2.LuaHelper:GetGLevel());
		npc2.LuaHelper:AddPracticeResource("Stage",5 * npc1.PropertyMgr.Practice:GetDaoHang() * npc1.LuaHelper:GetGLevel());
		if npc1.LuaHelper:GetProperty("NpcLingMaxValue") > npc2.LuaHelper:GetProperty("NpcLingMaxValue") then
		local shuzi1 = npc2.LuaHelper:GetProperty("NpcLingMaxValue") / npc1.LuaHelper:GetProperty("NpcLingMaxValue")
		local shuzi2 = 1 - shuzi1
		shanghai = world:RandomInt(1,10) / 10
		cishu = math.floor(shuzi2*10)
		while cishu > 0 do
		npc2.LuaHelper:AddDamageRandomPart(4,"LingSpillsInjury",shanghai, "因为双修对象灵力暴走导致的真气溢伤");
		cishu = cishu - 1
		end
		elseif npc2.LuaHelper:GetProperty("NpcLingMaxValue") > npc1.LuaHelper:GetProperty("NpcLingMaxValue") then
		local shuzi1 = npc1.LuaHelper:GetProperty("NpcLingMaxValue") / npc2.LuaHelper:GetProperty("NpcLingMaxValue")
		local shuzi2 = 1 - shuzi1
		shanghai = world:RandomInt(1,10) / 10
		cishu = math.floor(shuzi2*10)
		while cishu > 0 do
		npc1.LuaHelper:AddDamageRandomPart(4,"LingSpillsInjury",shanghai, "因为双修对象灵力暴走导致的真气溢伤");
		cishu = cishu - 1
		end
		else
		end
		print("双修完成，判定采补")
		if miji ~= nil then
		print(npc2.Name.."被选取的功法"..miji)
			if npc1.PropertyMgr.Practice.Gong.Name == ("Gong_1701_Tu") and npc1.PropertyMgr.Practice:CheckIsLearnedEsoteric(miji) == false then
			me:AddMsg(""..npc1.Name.."在双修过程中，施展了合欢宗六欲残卷上的秘法，从"..npc2.Name.."身上学会了一门秘法……");
			npc1.LuaHelper:LearnEsoteric(miji)
			end
		end
		if miji2 ~= nil then
		print(npc1.Name.."被选取的功法"..miji2)
			if npc2.PropertyMgr.Practice.Gong.Name == ("Gong_1701_Tu") and npc2.PropertyMgr.Practice:CheckIsLearnedEsoteric(miji2) == false then
			me:AddMsg(""..npc2.Name.."在双修过程中，施展了合欢宗六欲残卷上的秘法，从"..npc1.Name.."身上学会了一门秘法……");
			npc2.LuaHelper:LearnEsoteric(miji2)
			end
		end
	end
end

function Hudong:xuexi2()
JgName = Jg.def.ThingName
print("精怪名字："..Jingguai.Name)
print("体修名字："..Tixiu.Name)
print("精怪名字："..JgName)
Panding = world:RandomInt(1,101);
	if JgName == "天道本源-水" then
	Hudong:xuexiYYZS()
	elseif JgName == "造化玉露" and Panding > 50 then
	Hudong:xuexiYYZS()
	elseif (JgName == "地母灵液" or JgName == "元魂露" ) and Panding > 75 then
	Hudong:xuexiYYZS()
	elseif (JgName == "灵初露" or JgName == "纯阴落红" or JgName == "邪脉血泉") and Panding > 88 then
	Hudong:xuexiYYZS()
	elseif (JgName == "邪魂露" or JgName == "阳精" or JgName == "阴精") and Panding > 94 then
	Hudong:xuexiYYZS()
	elseif JgName == "妖灵血" and Panding > 97 then
	Hudong:xuexiYYZS()
	elseif (JgName == "水" or JgName == "野外的水") and Panding > 99 then
	Hudong:xuexiYYZS()
	else
	print(""..Tixiu.Name.."在和"..JgName.."精"..Jingguai.Name.."双修的过程中，什么都没学会。")
	end
end

function Hudong:xuexiYYZS()
	if Tixiu.PropertyMgr.Practice.BodyPracticeData.SuperParts:ContainsKey("SuperPart_Base_shiqi_1") then
	me:AddMsg(""..Tixiu.Name.."在双修过程中，从"..JgName.."精"..Jingguai.Name.."身上学会了一门他本身就会的秘体……");
	else
	me:AddMsg(""..Tixiu.Name.."在双修过程中，从"..JgName.."精"..Jingguai.Name.."身上学会了一门秘体……");
	Tixiu.PropertyMgr.Practice.BodyPracticeData:UnLockSuperPart("SuperPart_Base_shiqi_2");
	end
end