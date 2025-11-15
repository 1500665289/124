local tbTable = GameMain:GetMod("MapStoryHelper");--先注册一个新的MOD模块

function tbTable:LingYaoNote(sZ,sName,nT,nFlagTime)  --- 灵根记录
	local sTY = math.floor(world:GetWorldFlag(nFlagTime)/112) + 246
	local sTL = world:GetWorldFlag(nFlagTime)%112 + 8
	local sTS = nil
	if sTL <= 28 then
		sTS = XT("春")
	elseif  sTL <= 56 then
		sTS = XT("夏")
	elseif  sTL <= 84 then
		sTS = XT("秋")
	else
		sTS = XT("冬")
	end
	local sTD = sTL % 28
	if sTD == 0 then
		sTD = 28
	end
	if nT == 1 then
		MessageMgr:AddChainEventMessage(5, -1,string.format(XT("%s采摘完后，算了算时间，大概推算出%s会在天苍历%s年 %s %s日左右再次成熟。"), tostring(sName), tostring(sZ), tostring(sTY), tostring(sTS), tostring(sTD)), 0, 0, null, XT("灵根备忘录"), -1, nil, "res/Sprs/ui/msg_lingzhi");
	elseif nT == 2 then
		MessageMgr:AddChainEventMessage(5, -1,string.format(XT("%s十分懊恼，只得仔细查看了灵植的长势，算了算时间，大概推算出%s会在天苍历%s年 %s %s日左右再次成熟。"), tostring(sName), tostring(sZ), tostring(sTY), tostring(sTS), tostring(sTD)), 0, 0, null, XT("灵根备忘录"), -1, nil, "res/Sprs/ui/msg_lingzhi");
	elseif nT == 3 then
		MessageMgr:AddChainEventMessage(5, -1,string.format(XT("%s十分懊恼，采摘完剩下的灵植后，仔细查看了灵植的长势，算了算时间，大概推算出%s会在天苍历%s年 %s %s日左右再次成熟。"), tostring(sName), tostring(sZ), tostring(sTY), tostring(sTS), tostring(sTD)), 0, 0, null, XT("灵根备忘录"), -1, nil, "res/Sprs/ui/msg_lingzhi");
	end
end

function tbTable:VisitAward(player)  --- 通用奖励
	local nR = player:RandomInt(1, 21);
	if nR <= 4 then
		player:DropRandomItem("FightFabao", 1, 9);
	elseif nR <= 10 then
		local nW = player:RandomInt(1, 4);
		for i = 1, nW do
			player:DropAwardItemFromCache(story.ItemCache3, 1);
		end;
	elseif nR <= 16 then
		local nW = player:RandomInt(1, 4);
		for i = 1, nW do
			player:DropAwardItemFromCache(story.ItemCache4, 1);
		end;
	elseif nR <= 18 then
		player:DropEsotericFromCache(story.ItemCache, 1);
	elseif nR <= 20 then
		player:DropEsotericFromCache(story.ItemCache2, 1);
	end;
end

function tbTable:WuXingLingWu(player,lingzhi,k) --参数：角色，灵植，放大系数
	local nFlagID = 0
	local sHouZhui = nil
	local nWX = nil
	local nLS = lingzhi:GetLingSha()
	if lingzhi:GetName() == "LingZhi_Jin" then
		nFlagID = 50
		sHouZhui = XT("金")
		nWX = 1
	elseif lingzhi:GetName() == "LingZhi_Mu" or lingzhi:GetName() == "LingZhi_Ren" then
		nFlagID = 51
		sHouZhui = XT("木")
		nWX = 2
	elseif lingzhi:GetName() == "LingZhi_Shui" then
		nFlagID = 52
		sHouZhui = XT("水")
		nWX = 3
	elseif lingzhi:GetName() == "LingZhi_Huo" then
		nFlagID = 53
		sHouZhui = XT("火")
		nWX = 4
	elseif lingzhi:GetName() == "LingZhi_Tu" then
		nFlagID = 54
		sHouZhui = XT("土")
		nWX = 5
	end
	local nQ = math.floor(nLS * k * player:GetIntelligence() / 6);
	player:SetFlag(nFlagID,player:GetFlag(nFlagID) + nQ);
	local lingzhiName = lingzhi.plant:GetName()
	if nQ > 0 and player:GetFlag(nFlagID) >= 0 then
		player:AddMsg(string.format(XT("[NAME]感觉与%s的灵性更融洽了。"), tostring(lingzhiName)));
	elseif nQ < 0 and player:GetFlag(nFlagID) >= 0 then
		player:AddMsg(string.format(XT("[NAME]感觉与%s的灵性多了一些滞涩的感觉。"), tostring(lingzhiName)));
	elseif nQ > 0 and player:GetFlag(nFlagID) <= 0 then
		player:AddMsg(string.format(XT("[NAME]感觉与%s的煞性多了一些滞涩的感觉。"), tostring(lingzhiName)));
	elseif nQ < 0 and player:GetFlag(nFlagID) <= 0 then
		player:AddMsg(string.format(XT("[NAME]感觉与%s的煞性更融洽了。"), tostring(lingzhiName)));
	end
	if player:GetFlag(nFlagID) >= 2000 then
		player:SetFlag(nFlagID,0);
		player:AddMsg(string.format(XT("[NAME]与%s交感多年，借其灵性衍变，竟然领悟出一门秘法。"), tostring(lingzhiName)));
		local nTP = world:RandomInt(1,5)
		player:LearnEsotericCustomize(string.format(XT("%s灵秘法-"), tostring(sHouZhui)), nWX, nTP + 3,true)
	elseif player:GetFlag(nFlagID) <= -2000 then
		player:SetFlag(nFlagID,0);
		player:AddMsg(string.format(XT("[NAME]与%s交感多年，借其煞性衍变，竟然领悟出一门秘法。"), tostring(lingzhiName)));
		local nTP = world:RandomInt(1,4)
		player:LearnEsotericCustomize(string.format(XT("%s煞秘法-"), tostring(sHouZhui)), nWX, nTP, true)
	end
end

function tbTable:MiFaLingWu(player,lingzhi) --参数：角色，灵植
	local nPE = player:GetGElementKind()
	local nLE = nil
	local sHouZhui = nil
	if lingzhi:GetName() == "LingZhi_Jin" then
		nLE = 1
		sHouZhui = "Jin"
	elseif lingzhi:GetName() == "LingZhi_Mu" or lingzhi:GetName() == "LingZhi_Ren" then
		nLE = 2
		sHouZhui = "Mu"
	elseif lingzhi:GetName() == "LingZhi_Shui" then
		nLE = 3
		sHouZhui = "Shui"
	elseif lingzhi:GetName() == "LingZhi_Huo" then
		nLE = 4
		sHouZhui = "Huo"
	elseif lingzhi:GetName() == "LingZhi_Tu" then
		nLE = 5
		sHouZhui = "Tu"
	end
	if nPE == nLE and player:GetIntelligence() >= 8 and player:GetLuck() >= player:RandomInt(1,16) then
		local lingzhiName = lingzhi.plant:GetName()
		player:AddMsg(string.format(XT("%s灵煞之性已达极致，一股晦涩难明的气息浮现在四周，灵性交感之下,[NAME]福至心灵，竟然从中悟出一门绝世秘法。"), tostring(lingzhiName)));
		player:AddMsg(XT("随着[NAME]的领悟，这股玄奥的气息也消散殆尽。"));
		lingzhi:SetFlag(55, 1);
		if lingzhi:GetLingSha() >= 0 then
			player:LearnEsoteric("Esoterica_LingZhi_MiFa_Ling_" .. sHouZhui, true);
			WorldLua:UnLockAchievement(2048)
		elseif lingzhi:GetLingSha() < 0 then
			player:LearnEsoteric("Esoterica_LingZhi_MiFa_Sha_" .. sHouZhui, true);
			WorldLua:UnLockAchievement(2049)
		end
	end
end

function tbTable:ChanceEventStage1(lingzhi) 
	local tJG = {};
	lingzhi:GetJiaoGanNpcList(tJG);

	local nR = world:RandomInt(1,5);
	if nR == 1 then
		lingzhi:AddMsg(XT("[NAME]生长过程中，似乎与环境达成某种契合，灵性活泼了许多！"));
		lingzhi:AddLingSha(world:RandomFloat(1,3));
	elseif nR == 2 then
		lingzhi:AddMsg(XT("[NAME]生长过程中，似乎沾染了一些杀伐之气，煞性增强了许多！"));
		lingzhi:AddLingSha(-world:RandomFloat(1,3));
	elseif nR == 3 then
		if next(tJG) ~= nil then
			lingzhi:AddMsg(XT("[NAME]突然摇了摇枝叶，似乎在释放善意。灵性交感中的众人似乎都觉得心境一亮，似乎通明了许多。"));
			for _, v in pairs(tJG) do
				self:WuXingLingWu(v, lingzhi, 0.5);
				local nk = world:RandomFloat(1,3)
				local vnpcObjName = v.npcObj:GetName()
				local tv = math.floor(10 * nk)
				v.npcObj:AddModifier("Story_LingZhi_XinJing1", nk, true);
				lingzhi:AddMsg(string.format(XT("%s心境短期内提高了%s点。"), tostring(vnpcObjName), tostring(tv)));
			end 
		else
			lingzhi:AddMsg(XT("[NAME]突然摇了摇枝叶，似乎在释放善意。可惜附近并没有人修炼，无人察觉此事。"));
		end	
	elseif nR == 4 then
		if next(tJG) ~= nil then
			lingzhi:AddMsg(XT("[NAME]突然散发出凌冽的气息。灵性交感中的众人猝不及防，心境皆受波及。"));
			for _, v in pairs(tJG) do
				self:WuXingLingWu(v, lingzhi, 0.5);
				local nk = world:RandomFloat(1,3)
				local vnpcObjName = v.npcObj:GetName()
				local tv = math.floor(10 * nk)
				v.npcObj:AddModifier("Story_LingZhi_XinJing2", nk, true);
				lingzhi:AddMsg(string.format(XT("%s心境短期内降低了%s点。"), tostring(vnpcObjName), tostring(tv)));
			end 
		else
			lingzhi:AddMsg(XT("[NAME]突然散发出凌冽的气息。幸好周围无人修炼，并未受其影响。"));
		end	
	end
end

function tbTable:ChanceEventStage2(lingzhi) 
	local tJG = {};
	lingzhi:GetJiaoGanNpcList(tJG);

	local nR = world:RandomInt(1,4);
	if nR == 1 then
		lingzhi:AddMsg(XT("[NAME]生长过程中，积累的灵气突然散化入枝干，灵性大增！"));
		local nP = world:RandomFloat(2,5);
		if lingzhi:GetLing() >= nP * 1000 then
			lingzhi:AddLing(-nP * 1000);
			lingzhi:AddLingSha(nP);
		else
			lingzhi:AddLing(-lingzhi:GetLing());
			lingzhi:AddLingSha(-lingzhi:GetLing()/1000);
		end 
	elseif nR == 2 then
		lingzhi:AddMsg(XT("[NAME]生长过程中，突然像受了某些刺激，猛烈吸收起周围的灵气，煞性大增！"));
		local nP = world:RandomFloat(2,5);
		lingzhi:AddLing(nP * 1500);
		lingzhi:AddLingSha(-nP);
	elseif nR == 3 then
		if lingzhi:GetLingSha() >= 0 then
			if next(tJG) ~= nil then
				lingzhi:AddMsg(XT("[NAME]突然将积累的灵气化作灵氛弥漫开来。灵性交感之下，众人皆从中参悟良多。"));
				local nP = world:RandomFloat(0.2,0.5);
				lingzhi:AddLing(-nP * lingzhi:GetLing());
				for _, v in pairs(tJG) do
					self:WuXingLingWu(v, lingzhi, 0.8);
					v:AddTreeExp(nP * lingzhi:GetLing() * 3);
				end 
			else
				lingzhi:AddMsg(XT("[NAME]突然将积累的灵气化作灵氛弥漫开来。可惜附近并没有人修炼，无人抓住这一机缘。"));
			end	
		else
			if next(tJG) ~= nil then
				lingzhi:AddMsg(XT("[NAME]突然煞性勃发，散发出一股强烈的吸力，灵性交感下，众人根本灵气竟被夺走些许。不过虽然略微有损修行，但也借机窥视到灵根气脉运行的奥妙，获得许多参悟。"));
				for _, v in pairs(tJG) do
					self:WuXingLingWu(v, lingzhi, 0.8);
					v.npcObj:AddModifier("Story_LingZhi_MaxLing1", world:RandomFloat(0.5,1.5), true);
					v:AddTreeExp(10000 * world:RandomFloat(0.5,1.5));
				end 
			else
				lingzhi:AddMsg(XT("[NAME]突然煞性大盛，散发出一股强烈的吸力。不过周围无人修炼，并未有人受其影响。"));
			end	
		end
	end
end
		
function tbTable:ChanceEventStage3(lingzhi) 
	local tJG = {};
	lingzhi:GetJiaoGanNpcList(tJG);

	local nR = world:RandomInt(1,5);
	if nR == 1 then
		lingzhi:AddMsg(XT("[NAME]生长过程中，积累的灵气突然散化入枝干，灵性大增！"));
		local nP = world:RandomFloat(2,5);
		if lingzhi:GetLing() >= nP * 2000 then
			lingzhi:AddLing(-nP * 2000);
			lingzhi:AddLingSha(nP);
		else
			lingzhi:AddLing(-lingzhi:GetLing());
			lingzhi:AddLingSha(-lingzhi:GetLing()/2000);
		end
	elseif nR == 2 then
		lingzhi:AddMsg(XT("[NAME]生长过程中，突然像受了某些刺激，猛烈吸收起周围的灵气，煞性大增！"));
		local nP = world:RandomFloat(2,5);
		lingzhi:AddLing(nP * 3000);
		lingzhi:AddLingSha(-nP);
	elseif nR == 3 then
		if lingzhi:GetLingSha() >= 0 then
			if next(tJG) ~= nil then
				lingzhi:AddMsg(XT("[NAME]突然将积累的灵气化作灵氛弥漫开来。灵性交感之下，众人皆从中参悟良多。"));
				local nP = world:RandomFloat(0.4,0.6);
				lingzhi:AddLing(-nP * lingzhi:GetLing());
				for _, v in pairs(tJG) do
					self:WuXingLingWu(v, lingzhi, 1.2);
					v:AddTreeExp(nP * lingzhi:GetLing() * 4);
				end 
			else
				lingzhi:AddMsg(XT("[NAME]突然将积累的灵气化作灵氛弥漫开来。可惜附近并没有人修炼，无人抓住这一机缘。"));
			end	
		else
			if next(tJG) ~= nil then
				lingzhi:AddMsg(XT("[NAME]突然煞性勃发，散发出一股强烈的吸力，灵性交感下，众人灵气竟被夺走些许。不过虽然略微有损修行，但也借机窥视到灵根气脉运行的奥妙，获得许多参悟。"));
				for _, v in pairs(tJG) do
					self:WuXingLingWu(v, lingzhi, 1.2);
					v.npcObj:AddModifier("Story_LingZhi_MaxLing1", world:RandomFloat(1,2), true);
					v:AddTreeExp(12000 * world:RandomFloat(0.5,1.5));
				end 
			else
				lingzhi:AddMsg(XT("[NAME]突然煞性大盛，散发出一股强烈的吸力。不过周围无人修炼，并未有人受其影响。"));
			end	
		end
	elseif nR == 4 then
		if lingzhi:GetLing() > 40000 then
			lingzhi:AddLing(-40000) 
			if lingzhi:GetName() == "LingZhi_Ren" then
				lingzhi:AddMsg(XT("[NAME]生长过程中，树干处的肉穴流出了大量散发着甜腻气息的汁液。"));
				lingzhi:DropAwardItem("Item_EarthEssence_Ren",world:RandomInt(5,15));
			else
				lingzhi:AddMsg(XT("[NAME]生长过程中，根部突然有些隆起。竟然不知何时孕育出一些事物。"));
				lingzhi:DropAwardItem("Item_LingCrystal", 1);
			end
		elseif lingzhi:GetLing() > 10000 then
			lingzhi:AddLing(-10000) 
			if lingzhi:GetName() == "LingZhi_Jin" then
				lingzhi:AddMsg(XT("[NAME]生长过程中，根部突然有些隆起。竟然不知何时孕育出一些事物。"));
				lingzhi:DropAwardItem("Item_DarksteelRock",world:RandomInt(6,16));
			elseif lingzhi:GetName() == "LingZhi_Mu" then
				lingzhi:AddMsg(XT("[NAME]生长过程中，根部突然有些隆起。竟然不知何时孕育出一些事物。"));
				lingzhi:DropAwardItem("Item_LingWood",world:RandomInt(6,16));
			elseif lingzhi:GetName() == "LingZhi_Ren" then
				lingzhi:AddMsg(XT("[NAME]生长过程中，树干处的肉穴流出了若干散发着甜腻气息的汁液。"));
				lingzhi:DropAwardItem("Item_EarthEssence_Ren",world:RandomInt(2,6));
			elseif lingzhi:GetName() == "LingZhi_Shui" then
				lingzhi:AddMsg(XT("[NAME]生长过程中，根部突然有些隆起。竟然不知何时孕育出一些事物。"));
				lingzhi:DropAwardItem("Item_SilverRock",world:RandomInt(30,46));
			elseif lingzhi:GetName() == "LingZhi_Huo" then
				lingzhi:AddMsg(XT("[NAME]生长过程中，根部突然有些隆起。竟然不知何时孕育出一些事物。"));
				lingzhi:DropAwardItem("Item_CopperRock",world:RandomInt(30,46));
			elseif lingzhi:GetName() == "LingZhi_Tu" then
				lingzhi:AddMsg(XT("[NAME]生长过程中，根部突然有些隆起。竟然不知何时孕育出一些事物。"));
				lingzhi:DropAwardItem("Item_Jade",world:RandomInt(6,16));
			end
		elseif lingzhi:GetLing() > 5000 then
		lingzhi:AddLing(-5000) 
			if lingzhi:GetName() == "LingZhi_Ren" then
				lingzhi:AddMsg(XT("[NAME]生长过程中，树干处的肉穴流出了些许散发着甜腻气息的汁液。"));
				lingzhi:DropAwardItem("Item_EarthEssence_Ren",world:RandomInt(1,3));
			else
				lingzhi:AddMsg(XT("[NAME]生长过程中，根部突然有些隆起。竟然不知何时孕育出一些事物。"));
				lingzhi:DropAwardItem("Item_LingStone",world:RandomInt(3,9));
			end
		else
			lingzhi:AddMsg(XT("[NAME]生长过程中，根部突然有些隆起，似乎在孕育什么。不过由于灵气不足，最终并没有孕育成功。"));
			lingzhi:DropAwardItem("Item_Garbage", 1);
		end	
	end
end

		
function tbTable:ChanceEventStage4(lingzhi) 
	local tJG = {};
	lingzhi:GetJiaoGanNpcList(tJG);

	local nR = world:RandomInt(1,6);
	if nR == 1 then
		lingzhi:AddMsg(XT("[NAME]生长过程中，积累的灵气突然散化入枝干，灵性大增！"));
		local nP = world:RandomFloat(2,5);
		if lingzhi:GetLing() >= nP * 5000 then
			lingzhi:AddLing(-nP * 5000);
			lingzhi:AddLingSha(nP);
		else
			lingzhi:AddLing(-lingzhi:GetLing());
			lingzhi:AddLingSha(-lingzhi:GetLing()/5000);
		end 
	elseif nR == 2 then
		lingzhi:AddMsg(XT("[NAME]生长过程中，突然像受了某些刺激，猛烈吸收起周围的灵气，煞性大增！"));
		local nP = world:RandomFloat(2,5);
		lingzhi:AddLing(nP * 7500);
		lingzhi:AddLingSha(-nP);
	elseif nR == 3 then
		if lingzhi:GetLingSha() >= 0 then
			if next(tJG) ~= nil then
				lingzhi:AddMsg(XT("[NAME]突然将积累的灵气化作灵氛弥漫开来。灵性交感之下，众人皆从中参悟良多。"));
				local nP = world:RandomFloat(0.5,0.8);
				lingzhi:AddLing(-nP * lingzhi:GetLing());
				for _, v in pairs(tJG) do
					self:WuXingLingWu(v, lingzhi, 1.5);
					v:AddTreeExp(nP * lingzhi:GetLing() * 5);
				end 
			else
				lingzhi:AddMsg(XT("[NAME]突然将积累的灵气化作灵氛弥漫开来。可惜附近并没有人修炼，无人抓住这一机缘。"));
			end	
		else
			if next(tJG) ~= nil then
				lingzhi:AddMsg(XT("[NAME]突然煞性勃发，散发出一股强烈的吸力，灵性交感下，众人灵气竟被夺走些许。不过虽然略微有损修行，但也借机窥视到灵根气脉运行的奥妙，获得许多参悟。"));
				for _, v in pairs(tJG) do
					self:WuXingLingWu(v, lingzhi, 1.5);
					v.npcObj:AddModifier("Story_LingZhi_MaxLing1", world:RandomFloat(2,4), true);
					v:AddTreeExp(18000 * world:RandomFloat(0.5,1.5));
				end 
			else
				lingzhi:AddMsg(XT("[NAME]突然煞性大盛，散发出一股强烈的吸力。不过周围无人修炼，并未有人受其影响。"));
			end	
		end
	elseif nR == 4 then
		if lingzhi:GetLing() > 40000 then
			lingzhi:AddLing(-40000) 
			if lingzhi:GetName() == "LingZhi_Ren" then
				lingzhi:AddMsg(XT("[NAME]生长过程中，树干处的肉穴流出了大量散发着甜腻气息的汁液。"));
				lingzhi:DropAwardItem("Item_EarthEssence_Ren",world:RandomInt(5,15));
			else
				lingzhi:AddMsg(XT("[NAME]生长过程中，根部突然有些隆起。竟然不知何时孕育出一些事物。"));
				lingzhi:DropAwardItem("Item_LingCrystal",world:RandomInt(1,4));
			end
		elseif lingzhi:GetLing() > 10000 then
			lingzhi:AddLing(-10000) 
			if lingzhi:GetName() == "LingZhi_Jin" then
				lingzhi:AddMsg(XT("[NAME]生长过程中，根部突然有些隆起。竟然不知何时孕育出一些事物。"));
				lingzhi:DropAwardItem("Item_DarksteelRock",world:RandomInt(6,16));
			elseif lingzhi:GetName() == "LingZhi_Mu" then
				lingzhi:AddMsg(XT("[NAME]生长过程中，根部突然有些隆起。竟然不知何时孕育出一些事物。"));
				lingzhi:DropAwardItem("Item_LingWood",world:RandomInt(6,16));
			elseif lingzhi:GetName() == "LingZhi_Ren" then
				lingzhi:AddMsg(XT("[NAME]生长过程中，树干处的肉穴流出了若干散发着甜腻气息的汁液。"));
				lingzhi:DropAwardItem("Item_EarthEssence_Ren",world:RandomInt(2,6));
			elseif lingzhi:GetName() == "LingZhi_Shui" then
				lingzhi:AddMsg(XT("[NAME]生长过程中，根部突然有些隆起。竟然不知何时孕育出一些事物。"));
				lingzhi:DropAwardItem("Item_SilverRock",world:RandomInt(30,46));
			elseif lingzhi:GetName() == "LingZhi_Huo" then
				lingzhi:AddMsg(XT("[NAME]生长过程中，根部突然有些隆起。竟然不知何时孕育出一些事物。"));
				lingzhi:DropAwardItem("Item_CopperRock",world:RandomInt(30,46));
			elseif lingzhi:GetName() == "LingZhi_Tu" then
				lingzhi:AddMsg(XT("[NAME]生长过程中，根部突然有些隆起。竟然不知何时孕育出一些事物。"));
				lingzhi:DropAwardItem("Item_Jade",world:RandomInt(6,16));
			end
		elseif lingzhi:GetLing() > 5000 then
			lingzhi:AddLing(-5000) 
			if lingzhi:GetName() == "LingZhi_Ren" then
				lingzhi:AddMsg(XT("[NAME]生长过程中，树干处的肉穴流出了些许散发着甜腻气息的汁液。"));
				lingzhi:DropAwardItem("Item_EarthEssence_Ren",world:RandomInt(1,3));
			else
				lingzhi:AddMsg(XT("[NAME]生长过程中，根部突然有些隆起。竟然不知何时孕育出一些事物。"));
				lingzhi:DropAwardItem("Item_LingStone",world:RandomInt(3,9));
			end
		else
			lingzhi:AddMsg(XT("[NAME]生长过程中，根部突然有些隆起，似乎在孕育什么。不过由于灵气不足，最终并没有孕育成功。"));
			lingzhi:DropAwardItem("Item_Garbage", 1);
		end	
	elseif nR == 5 then
		if lingzhi:GetLing() > 80000 then
			lingzhi:AddMsg(XT("[NAME]生长过程中，树干之上忽有异状。竟然不知何时分泌出一些事物。"));
			lingzhi:AddLing(-80000) 
			if lingzhi:GetLingSha() >= 0 then
				lingzhi:DropAwardItem("Item_EarthEssence",world:RandomInt(1,4));
			else
				lingzhi:DropAwardItem("Item_EarthEssence1",world:RandomInt(1,4));
			end
		elseif lingzhi:GetLing() > 10000 then
			lingzhi:AddMsg(XT("[NAME]生长过程中，树干之上忽有异状。竟然不知何时分泌出一些事物。"));
			lingzhi:AddLing(-10000) 
			lingzhi:DropAwardItem("Item_LingMuXueJie",world:RandomInt(1,3));
		else
			lingzhi:AddMsg(XT("[NAME]生长过程中，树干之上忽有异状，似乎要分泌出一些事物。不过由于灵气不足，最终只出现了一些无用之物。"));
			lingzhi:DropAwardItem("Item_Garbage", 1);
		end
	end
end

function tbTable:ChanceEventStage5(lingzhi) 
	local tJG = {};
	lingzhi:GetJiaoGanNpcList(tJG);

	local nR = world:RandomInt(1,4);
	if nR == 1 then
		if lingzhi:GetLingSha() >= 0 then
			if next(tJG) ~= nil then
				lingzhi:AddMsg(XT("[NAME]突然将积累的灵气化作灵氛弥漫开来。灵性交感之下，众人皆从中参悟良多。"));
				local nP = world:RandomFloat(0.6,0.9);
				lingzhi:AddLing(-nP * lingzhi:GetLing());
				for _, v in pairs(tJG) do
					self:WuXingLingWu(v, lingzhi, 1.5);
					v:AddTreeExp(nP * lingzhi:GetLing() * 6);
				end 
			else
				lingzhi:AddMsg(XT("[NAME]突然将积累的灵气化作灵氛弥漫开来。可惜附近并没有人修炼，无人抓住这一机缘。"));
			end	
		else
			if next(tJG) ~= nil then
				lingzhi:AddMsg(XT("[NAME]突然煞性勃发，散发出一股强烈的吸力，灵性交感下，众人根本灵气竟被夺走些许。不过虽然略微有损修行，但也借机窥视到灵根气脉运行的奥妙，获得许多参悟。"));
				for _, v in pairs(tJG) do
					self:WuXingLingWu(v, lingzhi, 1.5);
					v.npcObj:AddModifier("Story_LingZhi_MaxLing1", world:RandomFloat(4,8), true);
					v:AddTreeExp(30000 * world:RandomFloat(0.5,2.5));
				end 
			else
				lingzhi:AddMsg(XT("[NAME]突然煞性大盛，散发出一股强烈的吸力。不过周围无人修炼，并未有人受其影响。"));
			end
		end
	elseif nR == 2 then
		if lingzhi:GetLing() > 150000 then
			lingzhi:AddMsg(XT("[NAME]树干之上忽有异状。竟然不知何时分泌出一些事物。"));
			lingzhi:AddLing(-150000) 
			lingzhi:DropAwardItem("Item_ZaoHuaYuLu",1);
		elseif lingzhi:GetLing() > 80000 then
			lingzhi:AddMsg(XT("[NAME]树干之上忽有异状。竟然不知何时分泌出一些事物。"));
			lingzhi:AddLing(-80000) 
			if lingzhi:GetLingSha() >= 0 then
				lingzhi:DropAwardItem("Item_EarthEssence",world:RandomInt(1,4));
			else
				lingzhi:DropAwardItem("Item_EarthEssence1",world:RandomInt(1,4));
			end
		elseif lingzhi:GetLing() > 10000 then
			lingzhi:AddMsg(XT("[NAME]树干之上忽有异状。竟然不知何时分泌出一些事物。"));
			lingzhi:AddLing(-10000) 
			lingzhi:DropAwardItem("Item_LingMuXueJie",world:RandomInt(1,3));
		else
			lingzhi:AddMsg(XT("[NAME]树干之上忽有异状，似乎要分泌出一些事物。不过由于灵气不足，最终只出现了一些无用之物。"));
			lingzhi:DropAwardItem("Item_Garbage", 1);
		end
	end
end

function tbTable:M3D6(a, b)
	local k = world:RandomInt(1,6) + world:RandomInt(1,6) + world:RandomInt(1,6);
	return math.ceil((b - a) * k / 18 + a);
end

function tbTable:Rand(m)
	return math.ceil(self:M3D6(m*0.75, m*1.25));
end

function tbTable:NoEvent(me, region)
	self:DisSubmiss(me, region);
	me:AddMsg(XT("无事发生"));
end

function tbTable:PrintSolution(region, WorldLua, solution)
	tWord = {
		["None"] = XT("决定不处理这个事件。"),
		["Social"] = XT("决定使用处世来解决事件。"),
		["Charm"] = XT("决定依靠魅力来解决事件。"),
		["Fight"] = XT("决定使用武力来解决事件。"),
		["Intelligence"] = XT("决定依靠悟性来解决事件。"),
		["Food"] = XT("决定使用食物来解决事件。"),
		["LingStone"] = XT("决定使用灵石来解决事件。"),
		["Wood"] = XT("决定使用原木来解决事件。"),
		["Rock"] = XT("决定使用石头来解决事件。"),
		["Member"] = XT("决定选择某个弟子来解决事件。")
	}
	if tWord[solution] then
		WorldLua:AddMsg(XT("代理人{1}想了想，{0}"), tWord[solution], region.UnionData:GetPMName());
	end
end

function tbTable:AddInfluence(WorldLua, region)
	local unionData = region.UnionData;
	local d = 100 * math.max(1, self:SPP(unionData.Social));
	local k = self:Rand(d);
	region:Influencial(k);
	WorldLua:AddMsg(XT("获得了{0}点影响值。"), k);
end

function tbTable:MPL(k) --MainPropertyLevel
	t = 
	{
		[1] = 7,
		[2] = 11,
		[3] = 15
	}
	if t[k] then
		return t[k];
	end
	return 0.5;
end
function tbTable:SPL(k) --SidePropertyLevel
	t = 
	{
		[1] = 14,
		[2] = 21,
		[3] = 28
	}
	if t[k] then
		return t[k];
	end
	return 0.5;
end
function tbTable:SML(k) --SideMemberLevel
	t = 
	{
		[1] = 18,
		[2] = 24,
		[3] = 30
	}
	if t[k] then
		return t[k];
	end
	return 0;
end
function tbTable:MPP(k) --MainPropertyProduction
	return k / 7;
end
function tbTable:SPP(k) --SidePropertyProduction
	return k / 14;
end
function tbTable:SMP(k) --SideMemberProduction
	return k / 16;
end

function tbTable:AddProduction(tProduct, region, WorldLua)
	local unionData = region.UnionData;
	local tMembers = unionData.members;
	local countOfMember = 10;
	if tMembers then
		countOfMember = countOfMember + tMembers.Count;
	end
	t = {
		["Item_Wheat"] = {self:Rand(400), tbTable:SPP(unionData.Farming), 0, 20},
		["Item_Wood"] = {self:Rand(300), tbTable:SMP(countOfMember), 0, 15},
		["Item_BrownRock"] = {self:Rand(300), tbTable:SPP(unionData.Mining), 0, 15},
		["Item_LingStone"] = {self:Rand(400), tbTable:SPP(unionData.Mining), 0, 20}
	}
	for k, v in pairs(tProduct) do
		if v.def.Products ~= nil and v.def.Products.Count > 0 then
			local item = v.def.Products[0];
			if t[item] then
				local k = math.ceil(t[item][1] * math.max(1, t[item][2])* v.Count / t[item][4]);
				region:AddIntoStorage(item, k);
				t[item][3] = t[item][3] + k;
			end
		end
	end
	for k, v in pairs(t) do
		if v[3] > 0 then
			local displayname = WorldLua:GetItemName(item);
			WorldLua:AddMsg(XT("代理人{3}在{2}收获了{0}个{1}"), v[3], WorldLua:GetItemName(k), region.def.DisplayName, unionData:GetPMName());
		end
	end
end
function tbTable:AddTreasure(tProduct, region, WorldLua, solve)
	local unionData = region.UnionData;
	local tMembers = unionData.members;
	local countOfMember = 10;
	local enumSolve = CS.XiaWorld.OutspreadMgr.Region.SolveWay;
	if tMembers then
		countOfMember = countOfMember + tMembers.Count;
	end
	t = {
		["Item_IronRock"] = {self:Rand(50), tbTable:SPP(unionData.Mining), 0, tbTable:MPL(0), enumSolve.Member, XT("啥都没有拿到。"), XT("代理人让弟子一起努力")},
		["Item_StoneEssence"] = {self:Rand(50), tbTable:SPP(unionData.Mining), 0, tbTable:MPL(1), enumSolve.Fight, XT("代理人和弟子并没有那么高的体力，啥都没找到。"), XT("代理人凭借力量挖掘，并仔细辨认")},
		["Item_RedGinseng"] = {self:Rand(20), tbTable:SPP(unionData.Mining), 0, tbTable:MPL(1), enumSolve.LingStone, XT("代理人虽用灵石作引，但无法辨认宝物在何方。啥都没找到。"), XT("代理人使用灵石作引")},
		["Item_Cinnabar"] = {self:Rand(50), tbTable:SPP(unionData.Mining), 0, tbTable:MPL(1), enumSolve.Wood, XT("代理人使用木头开凿，但无法辨认出宝物"), XT("代理人使用木头轻轻开凿")},
		["Item_SkyStone"] = {self:Rand(1), tbTable:SPP(unionData.Mining), 0, tbTable:MPL(2), enumSolve.LingStone, XT("代理人虽用灵石作引，但无法辨认宝物在何方。啥都没找到。"), XT("代理人使用灵石作引，并仔细辨认")},
		["Item_PurpleGanodermaLucidum"] = {self:Rand(10), tbTable:SPP(unionData.Farming), 0, tbTable:MPL(1), enumSolve.LingStone, XT("代理人虽用灵石作引，但无法辨认宝物在何方。啥都没找到。"), XT("代理人使用灵石作引")},
		["Item_SilverRock"] = {self:Rand(50), tbTable:SPP(unionData.Mining), 0, tbTable:MPL(0), enumSolve.Member, XT("啥都没有拿到。"), XT("代理人让弟子一起努力")},
		["Item_JadeEssence"] = {self:Rand(50), tbTable:SPP(unionData.Mining), tbTable:MPL(1), enumSolve.Rock, XT("代理人虽用石头开凿，但无法辨认宝物。"), XT("代理人使用石头开凿，仔细辨认")},
		["Item_EarthEssence1"] = {self:Rand(1), tbTable:SPP(unionData.Mining), tbTable:MPL(2), enumSolve.LingStone, XT("代理人虽用灵石作引，但无法辨认宝物在何方。啥都没找到。"), XT("代理人使用灵石作引，并仔细辨认")},
		["Item_MonsterBlood"] = {self:Rand(10), tbTable:SMP(countOfMember), tbTable:MPL(0), enumSolve.Fight, XT("代理人想要击杀一些小妖兽，但力量不足，无法抗衡"), XT("代理人杀了一些小妖兽")}, 
		["Item_LingWood"] = {self:Rand(50), tbTable:SMP(countOfMember), 0, tbTable:MPL(0), enumSolve.Member, XT("啥都没有拿到。"), XT("代理人让弟子一起努力")},
		["Item_CopperRock"] = {self:Rand(50), tbTable:SPP(unionData.Mining), 0, tbTable:MPL(0), enumSolve.Member, XT("啥都没有拿到。"), XT("代理人让弟子一起努力")}
	}
	--必须保证所有点每级寻宝只有一种
	for k, v in pairs(tProduct) do
		if v.def.Products ~= nil and v.def.Products.Count > 0 then
			local item = v.def.Products[0];
			if t[item] then
				if solve == t[item][5] then
					if unionData.Intelligence >= t[item][4] then
						local count = math.ceil(t[item][1] * math.max(t[item][2], 1));
						region:AddIntoStorage(item, count);
						WorldLua:AddMsg(XT("{0}，找到了{1}个{2}。"), t[item][7], count, WorldLua:GetItemName(item));
						return;
					else
						WorldLua:AddMsg(XT(t[item][6]));
						return;
					end
				end
			end
		end
	end
	WorldLua:AddMsg(XT("代理人在{0}忙活半天，啥都没找到。"), region.def.DisplayName);
	return;
end

function tbTable:ReturnPop(k)
	t = {
		[2] = 20000;
		[1] = 6000;
		[0] = 0;
		[-1] = -6000;
		[-2] = -20000;
	}
	return t[k];
end

function tbTable:SlightlyAidDisaster(me,region)
	local dis = region.Disaster;
	local unionData = region.UnionData;
	local countOfMember = 10;
	local tMembers = unionData.members;
	if tMembers then
		countOfMember = countOfMember + tMembers.Count;
	end
	local k = math.ceil(self:SMP(countOfMember) * 40);
	local Out = CS.XiaWorld.OutspreadMgr.Instance
	Out:AddDisasterAid(region, k, -1);
	me:AddMsg(XT("我方在{1}的赈灾贡献提高了{0}点。"), k, region.def.DisplayName);
end

function tbTable:AidDisaster(me,region)
	local dis = region.Disaster;
	local unionData = region.UnionData;
	local countOfMember = 10;
	local tMembers = unionData.members;
	if tMembers then
		countOfMember = countOfMember + tMembers.Count;
	end
	local k = math.ceil(self:SMP(countOfMember) * 75);
	local Out = CS.XiaWorld.OutspreadMgr.Instance
	Out:AddDisasterAid(region, k, -1);
	me:AddMsg(XT("我方在{1}的赈灾贡献提高了{0}点。"), k, region.def.DisplayName);
end

function tbTable:AidHugeDisaster(me,region)
	local dis = region.Disaster;
	local unionData = region.UnionData;
	local countOfMember = 10;
	local tMembers = unionData.members;
	if tMembers then
		countOfMember = countOfMember + tMembers.Count;
	end
	local k = math.ceil(self:SMP(countOfMember) * 150);
	local Out = CS.XiaWorld.OutspreadMgr.Instance
	Out:AddDisasterAid(region, k, -1);
	me:AddMsg(XT("我方在{1}的赈灾贡献提高了{0}点。") , k, region.def.DisplayName);
end
function tbTable:DisasterResult(me,region, disaster)
	local dis = disaster;
	local unionData = region.UnionData;
	local countOfMember = 10;
	local tMembers = unionData.members;
	local t = dis.SchoolAidReceive;
	local e = t:GetEnumerator();
	local SchoolID, Aid = 0, 0;
	
    while(e:MoveNext())
	do
		local c = e.Current;
		if (c.Value > Aid) then
			SchoolID = c.Key;
			Aid = c.Value;
		end
    end
	if Aid == 0 or SchoolID == 0 then
		me:AddMsg(XT("没有任何人帮助灾难。"));
	else
		local SchoolName = world:GetSchoolName(SchoolID) or XT("我们");
		local Pop = math.ceil(region.Population*0.15);
		if Pop < region.UnbelieverCount then
			region:AddSchoolRPopulation(SchoolID, Pop);
		else
			Pop = TransferPopulation(SchoolID, region, Pop, true);
		end
		if SchoolID ~= -1 then
			me:AddMsg(XT("{0}的代理在{2}的灾难中贡献巨大，群众十分感谢，有约{1}人成为了信众。"), SchoolName, Pop, region.def.DisplayName);
		else
			me:AddMsg(XT("我们的代理在{2}的灾难中贡献巨大，群众十分感谢，有约{1}人成为了信众。"), SchoolName, Pop, region.def.DisplayName);
		end
	end
end 
function tbTable:InnerDisaster(me)
	t = {
		[1] = 100;
		[2] = 100;
		[3] = 100;
		[4] = 250;
		[5] = 250;
		[6] = 250;
		[7] = 400;
		[8] = 400;
		[9] = 400;
		[10] = 600;
		[11] = 600;
		[12] = 600;
	}
	return t[me:GetGLevel()] or 100;
end 

function tbTable:IncreaseAllPop(me,region)
	local k = math.min(self:Rand(self:ReturnPop(2)), 400000 - region.Population);
	me:AddMsg(XT("有约{0}位流民加入了{1}。"), k, region.def.DisplayName);
	region:AddPopulation(k);
end
function tbTable:SlightlyIncreaseAllPop(me,region)
	local k = math.min(self:Rand(self:ReturnPop(1)), 400000 - region.Population);
	me:AddMsg(XT("有约{0}位流民加入了{1}。"), k, region.def.DisplayName);
	region:AddPopulation(k);
end
function tbTable:DisasterDecreaseAllPop(me,region)
	local k = math.max(math.ceil(math.min(self:Rand(region.Population * 1/3), region.Population - 50000)), 15)
	local a = world:RandomInt(1, math.ceil(k/5))
	local b = world:RandomInt(1, math.ceil(k/5))
	me:AddMsg(XT("期间，约{0}人死亡，{1}人失踪，{2}人逃离了{3}。"), a, b, k-a-b, region.def.DisplayName);
	region:AddPopulation(-k);
end
function tbTable:DisasterAffectAllPop(me,region)
	local k = math.max(math.ceil(math.min(self:Rand(region.Population * 1/20), region.Population - 50000)), 15)
	local a = world:RandomInt(1, math.ceil(k/5))
	local b = world:RandomInt(1, math.ceil(k/5))
	me:AddMsg(XT("即便如此，还是有约{0}人死亡，{1}人失踪，{2}人逃离了{3}。"), a, b, k-a-b, region.def.DisplayName);
	region:AddPopulation(-k);
end
function tbTable:DecreaseAllPop(me,region)
	local k = math.max(self:Rand(self:ReturnPop(-2)), region.Population - 50000)
	me:AddMsg(XT("有约{0}名群众逃离了{1}。"), k, region.def.DisplayName);
	region:AddPopulation(k);
end
function tbTable:SlightlyDecreaseAllPop(me,region)
	local k = math.max(self:Rand(self:ReturnPop(-1)), region.Population - 50000)
	me:AddMsg(XT("有约{0}名群众逃离了{1}。"), k, region.def.DisplayName);
	region:AddPopulation(k);
end

function TransferPopulation(religion1, region, number, isDisaster)
	local k = region:TrulyAddRPopulation(math.floor(number), religion1, isDisaster);
	return k;
end

function tbTable:IncreasePop(me,region)
	me:AddMsg(XT("在{0}，有大量群众选择信奉我们。"), region.def.DisplayName);
	local unionData = region.UnionData;
	local k = unionData:GetProperty(g_emNpcBasePropertyType.Charisma)
	local number = self:Rand(self:ReturnPop(2)) * self:MPP(k)
	if region.Stability > 0 and region.Stability < 50 then
		number = number * 1.5
		me:AddMsg(XT("由于{0}蒸蒸日上，更多信众选择加入我们。"), region.def.DisplayName);
	elseif region.Stability < -50 then
		number = number * 0.5
		me:AddMsg(XT("由于{0}人心叵测，不少信众并未如约前来。"), region.def.DisplayName);
	end
	local Pop = region.UnbelieverCount;
	if Pop >= number then
		local t = math.ceil(math.min(Pop, number));
		region:AddSchoolRPopulation(-1, t);
		me:AddMsg(XT("我方信众增加了{0}人。"), t);
	else
		local clearLeft = TransferPopulation(-1, region, number, false);
		me:AddMsg(XT("受到其他代理势力影响，我方信众只增加了{0}人。"), clearLeft);
	end
	self:AddSubmiss(me, region, 2);
end
function tbTable:SlightlyIncreasePop(me,region)
	local unionData = region.UnionData;
	me:AddMsg(XT("在{0}，有少量群众选择信奉我们。"), region.def.DisplayName);
	local k = unionData:GetProperty(g_emNpcBasePropertyType.Charisma)
	local number = self:Rand(self:ReturnPop(1)) * self:MPP(k)
	if region.Stability > 0 and region.Stability < 50 then
		number = number * 1.5
		me:AddMsg(XT("由于{0}蒸蒸日上，更多信众选择加入我们。"), region.def.DisplayName);
	elseif region.Stability < -50 then
		number = number * 0.5
		me:AddMsg(XT("由于{0}人心叵测，不少信众并未如约前来。"), region.def.DisplayName);
	end
	local Pop = region.UnbelieverCount;
	if Pop >= number then
		local t = math.ceil(math.min(Pop, number));
		region:AddSchoolRPopulation(-1, t);
		me:AddMsg(XT("我方信众增加了{0}人。"), t);
	else
		local clearLeft = TransferPopulation(-1, region, number, false);
		me:AddMsg(XT("受到其他代理势力影响，我方信众只增加了{0}人。"), clearLeft);
	end    
	self:AddSubmiss(me, region, 1);
end
function tbTable:DecreasePop(me,region)
	me:AddMsg(XT("在{0}，有不少信徒背离了我们。"), region.def.DisplayName);
	local us = region:GetReligion(-1);
	local number = math.max(-us.Population, self:Rand(self:ReturnPop(-2)));
	region:AddSchoolRPopulation(-1, t);
	me:AddMsg(XT("我方信众减少了{0}人。"), -number);
	self:DisSubmiss(me, region);
end
function tbTable:SlightlyDecreasePop(me,region)
	me:AddMsg(XT("在{0}，有少量信徒背离了我们。"), region.def.DisplayName);
	local us = region:GetReligion(-1);
	local number = math.max(-us.Population, self:Rand(self:ReturnPop(-1)));
	region:AddSchoolRPopulation(-1, t);
	me:AddMsg(XT("我方信众稍微减少了{0}人。"), -number);
	self:DisSubmiss(me, region);
end

function tbTable:IncreaseStab(me,region)
	local lv1 = region:GetStabilityLevel();
	local k = 0;
	region:AddStability(25);
	local lv2 = region:GetStabilityLevel();
	me:AddMsg(XT("{0}稳定度提高了。"), region.def.DisplayName);
	self:PrintStabChange(me, lv1, lv2, region);
	self:AddSubmiss(me, region, 2);
end
function tbTable:SlightlyIncreaseStab(me,region)
	local lv1 = region:GetStabilityLevel();
	region:AddStability(10);
	local lv2 = region:GetStabilityLevel();
	me:AddMsg(XT("{0}的稳定度稍微提高了。"), region.def.DisplayName);
	self:PrintStabChange(me, lv1, lv2, region);
	self:AddSubmiss(me, region, 1);
end
function tbTable:DecreaseStab(me,region)
	local lv1 = region:GetStabilityLevel();
	region:AddStability(-25);
	local lv2 = region:GetStabilityLevel();
	me:AddMsg(XT("{0}的稳定度降低了。"), region.def.DisplayName);
	self:PrintStabChange(me, lv1, lv2, region);
	self:DisSubmiss(me, region);
end
function tbTable:SlightlyDecreaseStab(me,region)
	local lv1 = region:GetStabilityLevel();
	region:AddStability(-10);
	local lv2 = region:GetStabilityLevel();
	me:AddMsg(XT("{0}的稳定度稍微降低了。"), region.def.DisplayName);
	self:PrintStabChange(me, lv1, lv2, region);
	self:DisSubmiss(me, region);
end
function tbTable:HugeDecreaseStab(me,region)
	local lv1 = region:GetStabilityLevel();
	region:AddStability(-40);
	local lv2 = region:GetStabilityLevel();
	me:AddMsg(XT("{0}的稳定度大幅降低了。"), region.def.DisplayName);
	self:PrintStabChange(me, lv1, lv2, region);
end
function tbTable:HugeIncreaseStab(me,region)
	local lv1 = region:GetStabilityLevel();
	region:AddStability(75);
	local lv2 = region:GetStabilityLevel()
	me:AddMsg(XT("{0}的稳定度大幅提高了。"), region.def.DisplayName);
	self:PrintStabChange(me, lv1, lv2, region);
end
function tbTable:PrintStabChange(me, lv1, lv2, region)
	if lv1 ~= lv2 then 
		local desc = CS.XiaWorld.GameDefine.OutsStabiltyTitle[CS.System.Convert.ToInt32(lv2)];
		me:AddMsg(XT("{1}的稳定度变为{0}。"), desc, region.def.DisplayName);
	end
end

function tbTable:GreatlyIncreaseAttra(me,region)
	region:AddSchoolRAttractive(-1, 75);
	me:AddMsg(XT("我方在{0}吸引力大幅提高了。"), region.def.DisplayName);
end
function tbTable:IncreaseAttra(me,region)
	region:AddSchoolRAttractive(-1, 25);
	if region.Stability > -50 and region.Stability < 0 then
		me:AddMsg(XT("由于{0}人心惶惶，吸引力获得更多提升。"), region.def.DisplayName);
		region:AddSchoolRAttractive(-1, 25);
	end
	me:AddMsg(XT("我方在{0}吸引力提高了。"), region.def.DisplayName);
	self:AddSubmiss(me, region, 2);
end
function tbTable:SlightlyIncreaseAttra(me,region)
	region:AddSchoolRAttractive(-1, 15);
	if region.Stability > -50 and region.Stability < 0 then
		me:AddMsg(XT("由于{0}人心惶惶，吸引力获得更多提升。"), region.def.DisplayName);
		region:AddSchoolRAttractive(-1, 15);
	end
	me:AddMsg(XT("我方在{0}吸引力稍微提高了。"), region.def.DisplayName);
	self:AddSubmiss(me, region, 1);
end
function tbTable:DecreaseAttra(me,region)
	region:AddSchoolRAttractive(-1, -30);
	me:AddMsg(XT("我方在{0}吸引力降低了。"), region.def.DisplayName);
end
function tbTable:SlightlyDecreaseAttra(me,region)
	region:AddSchoolRAttractive(-1, -10);
	me:AddMsg(XT("我方在{0}吸引力稍微降低了。"), region.def.DisplayName);
end

function tbTable:IncreaseOtherAttra(me, region, religion)
	region:AddSchoolRAttractive(religion, 30);
	local sName = world:GetSchoolName(religion);
	me:AddMsg(XT("{0}在{1}的吸引力提高了。"), sName, region.def.DisplayName);
end
function tbTable:SlightlyIncreaseOtherAttra(me, region, religion)
	region:AddSchoolRAttractive(religion, 15);
	local sName = world:GetSchoolName(religion);
	me:AddMsg(XT("{0}在{1}的吸引力稍微提高了。"), sName, region.def.DisplayName);
end
function tbTable:DecreaseOtherAttra(me, region, religion)
	region:AddSchoolRAttractive(religion, -25);
	local sName = world:GetSchoolName(religion);
	me:AddMsg(XT("{0}在{1}的吸引力降低了。"), sName, region.def.DisplayName);
	self:AddSubmiss(me, region, 2);
end
function tbTable:SlightlyDecreaseOtherAttra(me, region, religion)
	region:AddSchoolRAttractive(religion, -10);
	local sName = world:GetSchoolName(religion);
	me:AddMsg(XT("{0}在{1}的吸引力稍微降低了。"), sName, region.def.DisplayName);
	self:AddSubmiss(me, region, 1);
end

function tbTable:IncreaseOtherPop(me, region, religion)
	local sName = world:GetSchoolName(religion);
	me:AddMsg(XT("在{1}，有不少群众选择信奉{0}。"), sName, region.def.DisplayName);

	local number = self:Rand(self:ReturnPop(2));
	
	local Pop = region.UnbelieverCount;
	if Pop >= number then
		local t = math.min(Pop, number);
		region:AddSchoolRPopulation(religion, t);
		me:AddMsg(XT("信奉{0}的人数增加了{1}人。"), sName, t);
	else
		local clearLeft = TransferPopulation(religion, region, number, false);
		me:AddMsg(XT("受到其他代理势力影响，信奉{0}的人数只增加了{1}人。"), sName, clearLeft);
	end 
	self:DisSubmiss(me, region);
end
function tbTable:SlightlyIncreaseOtherPop(me, region, religion)
	local sName = world:GetSchoolName(religion);
	me:AddMsg(XT("在{1}，有少量群众选择信奉{0}。"), sName, region.def.DisplayName);

	local number = self:Rand(self:ReturnPop(1));
	
	local Pop = region.UnbelieverCount;
	if Pop >= number then
		local t = math.min(Pop, number);
		region:AddSchoolRPopulation(religion, t);
		me:AddMsg(XT("据说信奉{0}的人数增加了{1}人。"), sName, t);
	else
		local clearLeft = TransferPopulation(religion, region, number, false);
		me:AddMsg(XT("受到其他代理势力影响，信奉{0}的人数只增加了{1}人。"), sName, clearLeft);
	end
	self:DisSubmiss(me, region);
end
function tbTable:DecreaseOtherPop(me, region, religion)
	local sName = world:GetSchoolName(religion);
	me:AddMsg(XT("在{1}，有不少信徒背离了{0}。"), sName, region.def.DisplayName);
	local us = region:GetReligion(-1);
	local their = region:GetReligion(religion);
	local number = math.max(-their.Population, self:Rand(self:ReturnPop(-2)));
	region:AddSchoolRPopulation(religion, number);
	me:AddMsg(XT("信奉{0}的人数减少了约{1}。"),sName, -number);
	self:AddSubmiss(me, region, 1);
end
function tbTable:SlightlyDecreaseOtherPop(me, region, religion)
	local sName = world:GetSchoolName(religion);
	me:AddMsg(XT("在{1}，有少量信徒背离了{0}。"), sName, region.def.DisplayName);
	local us = region:GetReligion(-1);
	local their = region:GetReligion(religion);
	local number = math.max(-their.Population, self:Rand(self:ReturnPop(-1)));
	region:AddSchoolRPopulation(religion, number);
	me:AddMsg(XT("信奉{0}的人数稍微减少了{1}人。"),sName, -number);
	self:AddSubmiss(me, region, 1);
end

function tbTable:DirectlyGrabOtherPopSlightly(me, region, religion)
	local sName = world:GetSchoolName(religion);
	me:AddMsg(XT("在{1}，有少量信徒背离了{0}，并成为了我们的信众。"), sName, region.def.DisplayName);
	local their = region:GetReligion(religion);
	local number = math.ceil(math.min(their.Population, self:Rand(self:ReturnPop(1))));
	region:AddSchoolRPopulation(-1, number);
	region:AddSchoolRPopulation(religion, -number);
	me:AddMsg(XT("我方信众稍微增加了{0}人。"), number);
	self:AddSubmiss(me, region, 1);
end
function tbTable:DirectlyGrabOtherPop(me, region, religion)
	local sName = world:GetSchoolName(religion);
	me:AddMsg(XT("在{1}，部分信徒背离了{0}，并成为了我们的信众。"), sName, region.def.DisplayName);
	local their = region:GetReligion(religion);
	local number = math.ceil(math.min(their.Population, self:Rand(self:ReturnPop(2))));
	region:AddSchoolRPopulation(-1, number);
	region:AddSchoolRPopulation(religion, -number);
	me:AddMsg(XT("我方信众增加了{0}人。"), number);
	self:AddSubmiss(me, region, 2);
end

function tbTable:DisSubmiss(me, region)
	if region.Policy == "Policy_Submiss" then
		local k = region:GetLuaData("Submiss");
		if k < 10 then
			me:AddMsg(XT("{0}的收编中断了。"), region.def.DisplayName);
		end
	end
end

function tbTable:AddSubmiss(me, region, m)
	if region.Policy == "Policy_Submiss" then
		local k = region:GetLuaData("Submiss");
		k = k + m;
		if k == 30 then
			me:AddMsg(XT("{0}早已被我们收编。"), region.def.DisplayName);
		elseif k >= 20 then
			CS.XiaWorld.OutspreadMgr.Instance:Supervise(region);
			me:AddMsg(XT("{0}已被我们收编！"), region.def.DisplayName);
			region:SetLuaData("Submiss", 30);
		else
			me:AddMsg(XT("{0}收编进度达到{1}。"), region.def.DisplayName, k);
			region:SetLuaData("Submiss", k);
		end
	end
end

function tbTable:DefuseSubmiss(me, region)
	if region.Policy ~= "Policy_Submiss" then
		local k = region:GetLuaData("Submiss");
		if k > 0 then
			region:SetLuaData("Submiss", 0);
			me:AddMsg(XT("{0}收编中断了。"), region.def.DisplayName);
		end
	end
end
