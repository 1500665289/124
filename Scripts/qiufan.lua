-- 囚犯互动
local Hudong = GameMain:GetMod("Lua_qiufan");

function Hudong:qiufanhudong()
world:SetWorldFlag(1707,world:GetSelectThing().ID)
local ActionF=WorldLua:GetSelectNpcCallback(function(rs) if (rs == nil or rs.Count == 0) then return end
npc1 = ThingMgr:FindThingByID(world:GetWorldFlag(1707))
npc2 = CS.XiaWorld.ThingMgr.Instance:FindThingByID(rs[0])
world:ShowStoryBox(""..npc1.Name.."被囚禁于"..SchoolMgr.Name.."。\n"..npc2.Name.."来到了"..npc1.Name.."的囚笼，打算……","囚犯",{"泄欲","奴役","榨乳","五脏获取","脑部切除","离开"},
	function(key)
		if key == 0 then
		local miji = npc1.LuaHelper:GetRandomEsotericName();
			if npc1.PropertyMgr:CheckFeature("Pogua") ~= true and npc1.Sex == CS.XiaWorld.g_emNpcSex.Female and npc2.Sex == CS.XiaWorld.g_emNpcSex.Male then--男主女囚（处）
			qiufanwenben = "身为囚犯的"..npc1.Name.."自然是没有任何人权的，"..npc2.Name.."欲火一起便来到监狱，将其按在地上强奸了……\n事毕，"..npc2.Name.."将混着"..npc1.Name.."破瓜之血的肉棒塞进对方嘴里让其舔干净后，心满意足的离开了。"
			npc1.PropertyMgr:AddFeature("Pogua");npc2:AddModifier("XianzheCD");npc1:AddModifier("Qufudu");
			elseif npc1.PropertyMgr:CheckFeature("Pogua") == true and npc1.Sex == CS.XiaWorld.g_emNpcSex.Female and npc2.Sex == CS.XiaWorld.g_emNpcSex.Male then--男主女囚（非处）
			qiufanwenben = "身为囚犯的"..npc1.Name.."自然是没有任何人权的，"..npc2.Name.."欲火一起便来到监狱，将其按在地上强奸了……\n事毕，"..npc2.Name.."将肉棒塞进对方嘴里让其舔干净后，心满意足的离开了。"
			npc2:AddModifier("XianzheCD");npc1:AddModifier("Qufudu");
			elseif npc2.PropertyMgr:CheckFeature("Pogua") ~= true and npc2.Sex == CS.XiaWorld.g_emNpcSex.Female and npc1.Sex == CS.XiaWorld.g_emNpcSex.Male then--女主（女）男囚
			qiufanwenben = "身为囚犯的"..npc1.Name.."自然是没有任何人权的，"..npc2.Name.."欲火一起便来到监狱，然后仔细一想妈的老娘还是处女，把处子之身送囚犯，是不是有点脑瘫的？\n"..npc2.Name.."摇了摇头转身离开了。"
			npc2:AddModifier("XianzheCD");npc1:AddModifier("Qufudu");
			elseif npc2.PropertyMgr:CheckFeature("Pogua") == true and npc2.Sex == CS.XiaWorld.g_emNpcSex.Female and npc1.Sex == CS.XiaWorld.g_emNpcSex.Male then--女主（非处）男囚
			qiufanwenben = "身为囚犯的"..npc1.Name.."自然是没有任何人权的，"..npc2.Name.."欲火一起便来到监狱，将其按倒在地后便跨坐上去摇摆了起来……\n事毕，"..npc2.Name.."将满是精液的屄递到"..npc1.Name.."嘴前让其舔干净后，心满意足的离开了。"
			npc2:AddModifier("XianzheCD");npc1:AddModifier("Qufudu");
			elseif npc1.Sex == CS.XiaWorld.g_emNpcSex.Male and npc2.Sex == CS.XiaWorld.g_emNpcSex.Male then--男男
			qiufanwenben = "身为囚犯的"..npc1.Name.."自然是没有任何人权的，"..npc2.Name.."欲火一起便来到监狱，性癖奇特的他挑选了身为同性的"..npc1.Name.."……\n翻云覆雨之后……，"..npc2.Name.."将肉棒塞进对方嘴里让其舔干净后，心满意足的离开了。"
			npc2:AddModifier("XianzheCD");npc1:AddModifier("Qufudu");
			elseif npc1.Sex == CS.XiaWorld.g_emNpcSex.Male and npc2.Sex == CS.XiaWorld.g_emNpcSex.Male then--女女
			qiufanwenben = "身为囚犯的"..npc1.Name.."自然是没有任何人权的，"..npc2.Name.."欲火一起便来到监狱，性癖奇特的他挑选了身为同性的"..npc1.Name.."……\n翻云覆雨之后……，"..npc2.Name.."心满意足的离开了。"
			npc2:AddModifier("XianzheCD");npc1:AddModifier("Qufudu");
			else--bug排除
			qiufanwenben = "跳这个就是bug，不过无所谓……"
			end
			if miji ~= nil and npc1.PropertyMgr.Practice:CheckIsLearnedEsoteric(miji) == false then
			npc2.LuaHelper:LearnEsoteric(miji)
			print(qiufanwenben)
				return ""..qiufanwenben.."\n"..npc1.Name.."被"..npc2.Name.."按倒在地用于泄欲，未曾想一时快意上涌心神失守，向对方吐露了一门绝学……！"
			else
			print(qiufanwenben)
				return ""..qiufanwenben.."\n"..npc1.Name.."被"..npc2.Name.."按倒在地用于泄欲……！"
			end
			npc1.PropertyMgr:AddMaxAge(-1);
		end
		if key == 1 then
		npc1.PropertyMgr:AddModifier("Prison_Modifier2");
		npc1.PropertyMgr:RemoveModifier("Prison_Modifier");
		npc1.LuaHelper:SetCamp(g_emFightCamp.Friend, false)
		npc1:ChangeRank(g_emNpcRank.Worker);
		return ""..npc2.Name.."为"..npc1.Name.."套上了奴隶专用的枷锁，"..npc1.Name.."现在是本宗的苦役了……"
		end
		if key == 2 then
			if npc1.Sex == CS.XiaWorld.g_emNpcSex.Female then
			npc2.Needs:AddNeedValue(CS.XiaWorld.g_emNeedType.Practice,200)
			npc2.Needs:AddNeedValue(CS.XiaWorld.g_emNeedType.Food,100)
			npc2.Needs:AddNeedValue(CS.XiaWorld.g_emNeedType.Water,100)
			npc1.PropertyMgr:AddMaxAge(-5);
			item = CS.XiaWorld.ItemRandomMachine.RandomItem("Item_Human_Milk");
			item.Rate = npc1.LuaHelper:GetGLevel() + 1
			item:SetName("" .. npc1:GetName() .. "的乳汁");
			npc1.map:DropItem(item,npc1.Key,true,true,false,true,5);
			return ""..npc2.Name.."来到"..npc1.Name.."的囚室，将催乳秘药涂抹至"..npc1.Name.."的乳房上，经过秘药的催发，"..npc1.Name.."的乳房以肉眼可见的速度鼓涨了起来，甘美的乳汁也随即由乳头溢出，"..npc2.Name.."上前猛的吸了一口，满口甜腻的乳汁让"..npc2.Name.."仿佛嗑了一顿最极品的极乐丹……\n"..npc2.Name.."美美的饱饮了一顿后，开始挤压"..npc1.Name.."乳房，将乳汁挤至器皿之内……\n"..npc2.Name.."获得了："..npc1.Name.."的乳汁*1。\n"..npc2.Name.."因为痛饮"..npc1.Name.."的乳汁，获得了满足了口腹之欲，并获取了少量精元。\n"..npc1.Name.."因为催乳秘药，损失了些许寿命……"
			else
			return ""..npc1.Name.."是一个男人，他无乳可榨！\n"..npc2.Name.."离开了"..npc1.Name.."的囚笼！"
			end
		end
		if key == 3 then
			if npc1.PropertyMgr.BodyData:PartIsBroken("Heart") and npc1.PropertyMgr.BodyData:PartIsBroken("Liver") and npc1.PropertyMgr.BodyData:PartIsBroken("Spleen") and npc1.PropertyMgr.BodyData:PartIsBroken("Lung") and npc1.PropertyMgr.BodyData:PartIsBroken("Kidney") and npc1.PropertyMgr.BodyData:PartIsBroken("Stomach") and npc1.PropertyMgr.BodyData:PartIsBroken("Intestines") then
			return ""..npc1.Name.."的五脏无一完好！"
			else
				if npc1.PropertyMgr.BodyData:PartIsBroken("Heart") == false then
				item = CS.XiaWorld.ItemRandomMachine.RandomItem("Item_xin");
				item.Rate = npc1.LuaHelper:GetGLevel() + 1
				item:SetName("" .. npc1:GetName() .. "的心脏");
				npc1.map:DropItem(item,npc1.Key,true,true,false,true,5);
				npc1.LuaHelper:AddDamage("Fabao_CutOff","Heart", 1, XT(""..npc2.Name.."摘取"));
				end
				if npc1.PropertyMgr.BodyData:PartIsBroken("Liver") == false then
				item = CS.XiaWorld.ItemRandomMachine.RandomItem("Item_gan");
				item.Rate = npc1.LuaHelper:GetGLevel() + 1
				item:SetName("" .. npc1:GetName() .. "的肝");
				npc1.map:DropItem(item,npc1.Key,true,true,false,true,5);
				npc1.LuaHelper:AddDamage("Fabao_CutOff","Liver", 1, XT(""..npc2.Name.."摘取"));
				end
				if npc1.PropertyMgr.BodyData:PartIsBroken("Spleen") == false then
				item = CS.XiaWorld.ItemRandomMachine.RandomItem("Item_pi");
				item.Rate = npc1.LuaHelper:GetGLevel() + 1
				item:SetName("" .. npc1:GetName() .. "的脾脏");
				npc1.map:DropItem(item,npc1.Key,true,true,false,true,5);
				npc1.LuaHelper:AddDamage("Fabao_CutOff","Spleen", 1, XT(""..npc2.Name.."摘取"));
				end
				end
				if npc1.PropertyMgr.BodyData:PartIsBroken("Lung") == false then
				item = CS.XiaWorld.ItemRandomMachine.RandomItem("Item_fei");
				item.Rate = npc1.LuaHelper:GetGLevel() + 1
				item:SetName("" .. npc1:GetName() .. "的肺");
				npc1.map:DropItem(item,npc1.Key,true,true,false,true,5);
				npc1.LuaHelper:AddDamage("Fabao_CutOff","Lung", 1, XT(""..npc2.Name.."摘取"));
				end
				if npc1.PropertyMgr.BodyData:PartIsBroken("Kidney") == false then
				item = CS.XiaWorld.ItemRandomMachine.RandomItem("Item_shen");
				item.Rate = npc1.LuaHelper:GetGLevel() + 1
				item:SetName("" .. npc1:GetName() .. "的肾脏");
				npc1.map:DropItem(item,npc1.Key,true,true,false,true,5);
				npc1.LuaHelper:AddDamage("Fabao_CutOff","Kidney", 1, XT(""..npc2.Name.."摘取"));
				end
				if npc1.PropertyMgr.BodyData:PartIsBroken("Stomach") == false then
				item = CS.XiaWorld.ItemRandomMachine.RandomItem("Item_wei");
				item.Rate = npc1.LuaHelper:GetGLevel() + 1
				item:SetName("" .. npc1:GetName() .. "的胃");
				npc1.map:DropItem(item,npc1.Key,true,true,false,true,5);
				npc1.LuaHelper:AddDamage("Fabao_CutOff","Stomach", 1, XT(""..npc2.Name.."摘取"));
				end
				if npc1.PropertyMgr.BodyData:PartIsBroken("Intestines") == false then
				item = CS.XiaWorld.ItemRandomMachine.RandomItem("Item_chang");
				item.Rate = npc1.LuaHelper:GetGLevel() + 1
				item:SetName("" .. npc1:GetName() .. "的肠");
				npc1.map:DropItem(item,npc1.Key,true,true,false,true,5);
				npc1.LuaHelper:AddDamage("Fabao_CutOff","Intestines", 1, XT(""..npc2.Name.."摘取"));
				end
		return ""..npc2.Name.."对"..npc1.Name.."展开了残忍的手术，切除了其现有的五脏！"
		end
		if key == 4 then
			if npc1.PropertyMgr.BodyData:PartIsBroken("Brain") == false then
			item = CS.XiaWorld.ItemRandomMachine.RandomItem("Item_nao");
			item.Rate = npc1.LuaHelper:GetGLevel() + 1
			item:SetName("" .. npc1:GetName() .. "的大脑");
			npc1.map:DropItem(item,npc1.Key,true,true,false,true,5);
			npc1.LuaHelper:AddDamage("Fabao_CutOff","Brain", 1, XT(""..npc2.Name.."摘取"));
			return ""..npc2.Name.."开颅切走了"..npc1.Name.."的大脑！"
			else
			return ""..npc1.Name.."没有脑子！"
			end
		end
		if key == 5 then
		return ""..npc2.Name.."离开了"..npc1.Name.."的囚笼！"
		end
	end
	); end)
CS.Wnd_SelectNpc.Instance:Select(ActionF,g_emNpcRank.Normal,1,1,nil,nil,"选择与囚犯的互动者")
end

function Hudong:zhangmentequan()
local ActionF=WorldLua:GetSelectNpcCallback(function(rs) if (rs == nil or rs.Count == 0) then return end
npc1 = ThingMgr:FindThingByID(CS.XiaWorld.SchoolMgr.Instance.MasterID)
npc2 = CS.XiaWorld.ThingMgr.Instance:FindThingByID(rs[0])
npc3 = CS.XiaWorld.ThingMgr.Instance:FindThingByID(rs[1])
npc4 = CS.XiaWorld.ThingMgr.Instance:FindThingByID(rs[2])
npc5 = CS.XiaWorld.ThingMgr.Instance:FindThingByID(rs[3])
npc6 = CS.XiaWorld.ThingMgr.Instance:FindThingByID(rs[4])
npc7 = CS.XiaWorld.ThingMgr.Instance:FindThingByID(rs[5])
npc8 = CS.XiaWorld.ThingMgr.Instance:FindThingByID(rs[6])
npc9 = CS.XiaWorld.ThingMgr.Instance:FindThingByID(rs[7])
npc10 = CS.XiaWorld.ThingMgr.Instance:FindThingByID(rs[8])
npc11 = CS.XiaWorld.ThingMgr.Instance:FindThingByID(rs[9])
world:ShowStoryBox(""..npc1.Name.."召唤了"..npc2.Name.."等弟子","掌门特权",{"与众人合修","离开"},
	function(key)
		if key == 0 then
		return ""..npc1.Name.."与"..npc2.Name.."等人通过多人运动同参大道！"
		end
		if key == 1 then
		return ""..npc1.Name.."让"..npc2.Name.."和弟子们离开了！"
		end
	end
	); end)
CS.Wnd_SelectNpc.Instance:Select(ActionF,g_emNpcRank.Normal,1,10,nil,nil,"选择传唤的门中弟子")
end

function Hudong:lunjian()--轮奸囚犯
npc2 = ThingMgr:FindThingByID(me.npcObj.ID)
	if npc2 == beihaizhe then--目标是被害者
		if LJrenshu == nil then--没有同伙，去摇人把
		me:AddMsg("没有同伴怎么轮……去摇人把……");
		return false;
		elseif LJrenshu == 1 and npc1.Sex == CS.XiaWorld.g_emNpcSex.Male then--2男
		me:AddMsg(""..npc1.Name.."和"..tongfan1.Name.."一起轮奸了"..npc2.Name.."！！！");
		elseif LJrenshu == 2 and npc1.Sex == CS.XiaWorld.g_emNpcSex.Male then--3男
		me:AddMsg(""..npc1.Name.."、"..tongfan2.Name.."和"..tongfan1.Name.."一起轮奸了"..npc2.Name.."！！！");
		elseif LJrenshu == 3 and npc1.Sex == CS.XiaWorld.g_emNpcSex.Male then--4男
		me:AddMsg(""..npc1.Name.."、"..tongfan3.Name.."、"..tongfan2.Name.."和"..tongfan1.Name.."一起轮奸了"..npc2.Name.."！！！");
		elseif LJrenshu == 1 and npc1.Sex == CS.XiaWorld.g_emNpcSex.Female then--2女
		me:AddMsg(""..npc1.Name.."和"..tongfan1.Name.."一起轮奸了"..npc2.Name.."！！！");
		elseif LJrenshu == 2 and npc1.Sex == CS.XiaWorld.g_emNpcSex.Female then--3女
		me:AddMsg(""..npc1.Name.."、"..tongfan2.Name.."和"..tongfan1.Name.."一起轮奸了"..npc2.Name.."！！！");
		else--4女
		me:AddMsg(""..npc1.Name.."、"..tongfan3.Name.."、"..tongfan2.Name.."和"..tongfan1.Name.."一起轮奸了"..npc2.Name.."！！！");
		end
		npc2:AddModifier("Qufudu");
		npc2.PropertyMgr:FindModifier("Qufudu"):UpdateStack(LJrenshu);
		if npc1.Sex == CS.XiaWorld.g_emNpcSex.Female and npc1.PropertyMgr:CheckFeature("Pogua") ~= true then
		npc1.PropertyMgr:AddFeature("Pogua")
		end
		if npc2.Sex == CS.XiaWorld.g_emNpcSex.Female and npc2.PropertyMgr:CheckFeature("Pogua") ~= true then
		npc2.PropertyMgr:AddFeature("Pogua")
		end
		LJrenshu = nil
		tongfan3 = nil
		tongfan2 = nil
		tongfan1 = nil
		beihaizhe = nil
		shibaozhe = nil
	elseif npc1.Sex == npc2.Sex then----目标没被定义成被害者，且是同性
	me:AddMsg("因为没人写同性文本，所以不能轮同性……");
	else--目标没被定义成被害者，且不是同性，设定目标为被害者
	me:AddMsg(""..npc1.Name.."决定找人一起轮奸"..npc2.Name.."……");
	beihaizhe = ThingMgr:FindThingByID(me.npcObj.ID)
	shibaozhe = npc1
	end
end


function Hudong:fanmai()--贩卖囚犯
npc2 = ThingMgr:FindThingByID(me.npcObj.ID)
NanName = NpcMgr:GetRandomFullName("Human",CS.XiaWorld.g_emNpcSex.Male)
local shili = npc2.LuaHelper:GetGLevel()
if npc2.PropertyMgr:CheckFeature("Tiancilonggen") == true then--卖淫有大屌加成
	MYJC1 = 10
	else
	MYJC1 = 0
end
if npc2.PropertyMgr:CheckFeature("BeautifulFace2") == true then--卖淫有惊世美貌加成
	MYJC2 = 10
	else
	MYJC2 = 0
end
if npc2.PropertyMgr:CheckFeature("BeautifulFace1") == true then--卖淫有美貌加成
	MYJC3 = 5
	else
	MYJC3 = 0
end
Jieguo = MYJC3 + MYJC2 + MYJC1 + shili + 1
Shouyi = Jieguo * 50
print(Shouyi)
me:AddMsg(""..npc2.Name.."被"..npc1.Name.."贩卖给了"..NanName.."，"..npc1.Name.."获得了"..Shouyi.."两白银……");
ThingMgr:RemoveThing(npc2,false,true);npc1:AddModifier("Qian");npc1.PropertyMgr:FindModifier("Qian"):UpdateStack(Shouyi - 1);
end