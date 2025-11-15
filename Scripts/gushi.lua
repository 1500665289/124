-- 随机事件系统
local Suiji = GameMain:GetMod("Lua_gushi");
Suijishijiantime = Suijishijiantime or 600
print("下次触发事件需要："..Suijishijiantime.."秒")

function Suiji:OnStep(dt)	--请谨慎处理step的逻辑，可能会影响游戏效率
	local time = self.time or 0
	time = time + dt
	if time > Suijishijiantime then
	Suijishijiantime = world:RandomInt(100,1000)
	print("下次触发事件需要："..Suijishijiantime.."秒")
		Suiji:panding()
		self.time = 0;
		return
	end
	self.time = time;
end

function Suiji:panding()
	Wmtrnpc = World.map.Things:RandomNpc()
	print("随机事件筛选npc："..Wmtrnpc.Name)
	if CS.GameMain.Instance.FightMap then
	print(Wmtrnpc.Name.."非门派地图，本次事件轮空")
	elseif world:GetWorldFlag(1716) > 0 then
	world:SetWorldFlag(1716,world:GetWorldFlag(1716)-1);
	local diduimenpai = WorldLua:RandomInt(1,#menpailiebiao+1);
		if world:IsSchoolSubmissionToPlayer(diduimenpai) then
		CS.Wnd_StorySelect.Select(menpailiebiao[diduimenpai].."的上供","一大群"..menpailiebiao[diduimenpai].."的强者来到了"..SchoolMgr.Name.."，前来感谢宗主门派-"..SchoolMgr.Name.."。\n原来"..SchoolMgr.Name.."弟子在游历途中得遇"..menpailiebiao[diduimenpai].."长老的义子非礼良家妇女，就顺手击杀了这个混蛋帮"..menpailiebiao[diduimenpai].."除得一害，故"..menpailiebiao[diduimenpai].."送上一万灵石表示感谢……",nil,nil)
		Wmtrnpc.LuaHelper:DropAwardItem("Item_LingStone",10000);
		else
			CS.Wnd_StorySelect.Select(menpailiebiao[diduimenpai].."的报复","一大群"..menpailiebiao[diduimenpai].."的强者杀上了"..SchoolMgr.Name.."，理由是："..SchoolMgr.Name.."弟子居然仅仅是看到了"..menpailiebiao[diduimenpai].."长老的义子非礼良家妇女，就残忍的把其杀害了……",nil,nil)
			renshu = WorldLua:RandomInt(15,30);
			while renshu > 0 do
				local zhongzu = WorldLua:RandomInt(1,#zhongzubiaoge+1);
				local npc = CS.XiaWorld.NpcRandomMechine.RandomNpc(zhongzubiaoge[zhongzu],g_emNpcSex.Male);
				npc:AddTitle(menpailiebiao[diduimenpai].."强者");
				CS.XiaWorld.NpcMgr.Instance:AddNpc(npc,npc.LuaHelper:RandomInt(240,280),Map,CS.XiaWorld.Fight.g_emFightCamp.Enemy);
				CS.XiaWorld.ThingMgr.Instance:EquptNpc(npc,npc.LuaHelper:RandomInt(7,12),CS.XiaWorld.g_emNpcRichLable.Richest);
				npc.FightBody.AttackWait = 1;
				npc.FightBody.AttackTime = 10000;
				npc.FightBody.AutoNext = true;
				npc.FightBody.IsAttacker = true;
				renshu = renshu - 1
			end
		end
	elseif Wmtrnpc.IsPlayerThing and Wmtrnpc.IsAlive then
		if Wmtrnpc:HasSpecialFlag(g_emNpcSpecailFlag.MapExploring) then
			if Wmtrnpc.GongKind == g_emGongKind.Dao or Wmtrnpc.GongKind == g_emGongKind.Body then
				if Wmtrnpc.LuaHelper:GetGLevel() < 4 and (Wmtrnpc.PropertyMgr:CheckFeature("UglyFace2") or Wmtrnpc.PropertyMgr:CheckFeature("UglyFace1")) then
				Wmtrnpc.LuaHelper:TriggerStory("Chounvwudi_1")
				elseif Wmtrnpc.LuaHelper:GetGLevel() < 7 and SchoolMgr:IsGongUnLocked("God_Gong_1701") == false then
				Wmtrnpc.LuaHelper:TriggerStory("Fomenchongsheng")
				else
				local sjs = world:RandomInt(1,19);
				Wmtrnpc.LuaHelper:TriggerStory("Storyshiqi_"..sjs.."")
				end
			elseif Wmtrnpc.GongKind == g_emGongKind.God then
			Wmtrnpc.LuaHelper:AddSecret(world:RandomInt(17003,17006))
			else
			print(Wmtrnpc.Name.."是魂修正在历练，由于魂修未完成，故本次事件轮空")
			end
		elseif Wmtrnpc:HasSpecialFlag(g_emNpcSpecailFlag.AuctionPunish) then
		print(Wmtrnpc.Name.."正被囚禁在拍卖所")
		else
			if Wmtrnpc.IsSleeping and Wmtrnpc.InBuilding ~= nil and Wmtrnpc.InBuilding.def.Building.IsBed then--本角色在睡觉
				TCRen = 0
				TCnpc = nil
				local targets = Map.Things:GetNpcsLua(
				function(n)
					return n.InBuilding ~= nil and n.InBuilding == Wmtrnpc.InBuilding and n ~= Wmtrnpc ;
				end);
				for i = 0, targets.Count-1, 1 do
				local target = targets[i];
					if target ~= nil then
					TCRen = TCRen + 1
						if TCRen > 0 then
						TCnpc = target
						end
					end
				end
				if TCRen > 0 and TCnpc ~= nil then
				print(Wmtrnpc.Name.."获取成功，且在睡眠，"..TCnpc.Name.."也在这张床上")
				else
				print(Wmtrnpc.Name.."获取成功，且在睡眠，床上没有其他人")
				end
			elseif world:GetWorldFlag(1705) == 5 and Wmtrnpc.PropertyMgr:CheckFeature("BeautifulFace2") and Wmtrnpc.GongKind == g_emGongKind.Body then
			Wmtrnpc.LuaHelper:TriggerStory("NPC_Jingjigongsi");
			elseif Wmtrnpc.IsSmartRace and GameDefine.GetSchoolMaxNpc(SchoolMgr.Level) > SchoolMgr:GetSchoolData(CS.XiaWorld.g_emSchoolData.NumDisciple) + SchoolMgr:GetSchoolData(CS.XiaWorld.g_emSchoolData.NumWorker) and SchoolMgr:GetSchoolData(CS.XiaWorld.g_emSchoolData.NumWorker) > 3 and SchoolMgr:GetSchoolData(CS.XiaWorld.g_emSchoolData.NumDisciple) == 0 and Wmtrnpc.Sex == CS.XiaWorld.g_emNpcSex.Female and Wmtrnpc.PropertyMgr:CheckFeature("BeautifulFace2") then
			Wmtrnpc.LuaHelper:TriggerStory("Suiji07");
			elseif Wmtrnpc.IsSmartRace then
			print(Wmtrnpc.Name.."获取成功，是智慧种族，触发随机事件")
			Wmtrnpc.LuaHelper:TriggerStory("Suiji_yule")
			else
			print(Wmtrnpc.Name.."获取成功，非智慧种族，因为未完成非智慧种族随机事件，返还随机筛选npc")
			Suiji:panding()
			end
		end
	else
		if Wmtrnpc.IsDeath then
		Suiji:STshijian()
		else
		zhangmen = ThingMgr:FindThingByID(CS.XiaWorld.SchoolMgr.Instance.MasterID)
			if world:GetWorldFlag(1715) == 0 and Wmtrnpc.LuaHelper:GetSchoolRelation(170) < -1000 and zhangmen ~= nil then
			zhangmen.LuaHelper:TriggerStory("Suiji10")
			else
			print(Wmtrnpc.Name.."因为未完成非我方阵营或者且没有死亡，返还随机筛选npc")
			Suiji:panding()
			end
		end
	end
end

function Suiji:zoulu()
local Command = Wmtrnpc2:AddCommandIfNotExist("MoveTo",Wmtrnpc.Key);
Wmtrnpc2.JobEngine:InterruptJob("MoveTo", true, false);
Wmtrnpc2.JobEngine:BeginJob(CS.XiaWorld.JobMgr.Instance:CreateJob("JobMoveTo",Command))
end

function Suiji:STshijian()
	if Wmtrnpc.IsSmartRace then
	Wmtrnpc2 = World.map.Things:RandomNpc()
	local Panding = world:RandomInt(1,101);
	print(Wmtrnpc2)
		if Wmtrnpc2.IsSmartRace and (Wmtrnpc2.PropertyMgr:CheckFeature("Yishipi") or Wmtrnpc2.RaceDefName ~= "Human") then
		Wmtrnpc2:SetPostion(Wmtrnpc.Key + 1)
		local wenben = Wmtrnpc2.LuaHelper:ParseNpcStory("[rand_lable=desc_time,desc_place,desc_weather]，"..Wmtrnpc2.Name.."看着"..Wmtrnpc.Name.."的尸体，腹中鼓鸣连连，唾液也不禁的在嘴中大肆分泌，"..Wmtrnpc2.Name.."将"..Wmtrnpc.Name.."的尸体大卸八块后吃掉了一部分")
		Wmtrnpc2.LuaHelper:AddMemery(wenben)
		Wmtrnpc2.LuaHelper:DropAwardItem("Item_HumanMeat",25);
		Wmtrnpc2:AddMood("Chirenrou")
		ThingMgr:RemoveThing(Wmtrnpc,false,true)
		elseif World.DayCount > 50 and Panding > 80 then
		Wmtrnpc:ChangeToCorpse()
		Wmtrnpc:Change2Zombie()
		Wmtrnpc.PropertyMgr.Practice:ChangeGong("Body_Gong_5");
		Wmtrnpc:ChangeRank(g_emNpcRank.Disciple);
			if World.DayCount > 150 and Panding > 97 then
			local Qiangdu = math.floor(World.DayCount/10) + 1
			local sj = WorldLua:RandomInt(100,1000) * Qiangdu
			Wmtrnpc.PropertyMgr:ModifierProperty("BodyPratice_MaxZhenQi",5*sj,0,0,0)--真气+5
			Wmtrnpc.PropertyMgr:ModifierProperty("BodyPratice_RecoverZhenQi",1*sj,0,0,0)--回气+1
			Wmtrnpc.PropertyMgr:ModifierProperty("BodyPractice_SuperPartAddp_CatchFabao",0.0001*sj,0,0,0)--镇压概率
			Wmtrnpc.PropertyMgr:ModifierProperty("BodyPractice_SuperPartAddp_ArmorPenetration",0.0001*sj,0,0,0)--穿透加成率
			Wmtrnpc.PropertyMgr:ModifierProperty("BodyPractice_SuperPartAddp_DefRate",0.0001*sj,0,0,0)--防御成功率
			Wmtrnpc.PropertyMgr:ModifierProperty("BodyPractice_SuperPartAddp_AtkRate",0.0001*sj,0,0,0)--命中率
			Wmtrnpc.PropertyMgr:ModifierProperty("MaxAge",1*sj,0,0,0)--寿命
			Wmtrnpc.PropertyMgr:ModifierProperty("BodyPractice_SuperPartAddv_AtkPower",10*sj,0,0,0)--攻击力
			Wmtrnpc.PropertyMgr:ModifierProperty("BodyPractice_SuperPartAddv_DefPower",10*sj,0,0,0)--防御力
			Wmtrnpc.PropertyMgr:ModifierProperty("PainTolerance",0.0001*sj,0,0,0)--疼痛忍耐
			Wmtrnpc.PropertyMgr:ModifierProperty("BodyPratice_BodyStrong",0.1*sj,0,0,0)--身体强悍程度
			Wmtrnpc.PropertyMgr:ModifierProperty("BodyPratice_CatchFaboValue",-0.0001*sj,0,0,0)--镇压法宝消耗
			Wmtrnpc.PropertyMgr:ModifierProperty("NpcFight_BaseDodgeChance",0.0001*sj,0,0,0)--闪避
			CS.XiaWorld.ThingMgr.Instance:EquptNpcBodyPracticeSuperPart(Wmtrnpc)
			Wmtrnpc.PropertyMgr.Practice:Up2Disciple("Body_Gong_5", 12)
			print(Wmtrnpc.Name.."化身僵尸王")
			CS.Wnd_StorySelect.Select("僵尸王苏醒","躺在本门中未被埋葬的"..Wmtrnpc.Name.."因为吸收了大量怨气和灵气突然苏醒了过来！",nil,nil)
			else
			CS.XiaWorld.ThingMgr.Instance:EquptNpcBodyPracticeSuperPart(Wmtrnpc)
			CS.Wnd_StorySelect.Select("僵尸苏醒","躺在本门中未被埋葬的"..Wmtrnpc.Name.."因为吸收了大量怨气和灵气突然苏醒了过来！",nil,nil)
			print(Wmtrnpc.Name.."化身僵尸")
			end
		Wmtrnpc.PropertyMgr.Practice.BodyPracticeData:AddZhenQi(999999)
		Wmtrnpc.FightBody.AttackWait = 1;
		Wmtrnpc.FightBody.AttackTime = 10000;
		Wmtrnpc.FightBody.AutoNext = true;
		Wmtrnpc.FightBody.IsAttacker = true;
		else
		end
	else
		if SchoolMgr:GetSchoolData(CS.XiaWorld.g_emSchoolData.NumDisciple) < 3 then--内门弟子小于3
		CS.Wnd_StorySelect.Select("路过的爱"..Wmtrnpc.Name.."人士","一群路过本地的爱"..Wmtrnpc.Name.."人士：天啊，"..Wmtrnpc.Name.."那么可爱，那么好玩，那么好用！\n你们为什么要杀"..Wmtrnpc.Name.."，难道你们是想吃"..Wmtrnpc.Name.."！！！\n后便拔出了刀剑向我方冲了过来！",nil,nil)
		renshu = world:RandomInt(5,20);
			if Wmtrnpc.Sex == CS.XiaWorld.g_emNpcSex.Male then
			xingbie = g_emNpcSex.Female
			else
			xingbie = g_emNpcSex.Male
			end
			while renshu > 0 do
				local npc = CS.XiaWorld.NpcRandomMechine.RandomNpc("Human",xingbie);
				npc:AddTitle("爱"..Wmtrnpc.Name.."人士");
				CS.XiaWorld.NpcMgr.Instance:AddNpc(npc,npc.LuaHelper:RandomInt(240,280),Map,CS.XiaWorld.Fight.g_emFightCamp.Enemy);
				CS.XiaWorld.ThingMgr.Instance:EquptNpc(npc,0,CS.XiaWorld.g_emNpcRichLable.Richest);
				npc.FightBody.AttackWait = 1;
				npc.FightBody.AttackTime = 10000;
				npc.FightBody.AutoNext = true;
				npc.FightBody.IsAttacker = true;
				renshu = renshu - 1
			end
		else
		print(Wmtrnpc.Name.."有内门弟子的情况下，动保人士入侵未完成，本次事件轮空")
		end
	end
end