local tbTable = GameMain:GetMod("JianghuMgr");
local tbTalkAction = tbTable:GetTalkAction("Mod_seyou");


--类会复用，如果有局部变量，记得在init里初始化
function tbTalkAction:Init()	
end

function tbTalkAction:GetName(player,target)
	return "SEX";
end

function tbTalkAction:GetDesc(player,target)
	return "SEX相关系列事件（原色诱）。";
end

--按钮什么时候可见
function tbTalkAction:CheckActive(player,target)
	if target.PropertyMgr.BodyData:PartIsBroken("Genitals") or player.PropertyMgr.BodyData:PartIsBroken("Genitals") or shiqidejiance == 1 then--太监除外
		return false;
	end
	return true;
end

--按钮什么时候可用
function tbTalkAction:CheckEnable(player,target)
	if target.PropertyMgr.BodyData:PartIsBroken("Genitals") or player.PropertyMgr.BodyData:PartIsBroken("Genitals") or shiqidejiance == 1 then--太监除外
		return false;
	end
	return true;
end

function tbTalkAction:Action(player,target)--未完成
local random = player.LuaHelper:RandomInt(0,15);
local meili = player.LuaHelper:GetCharisma()
local juqing = player.LuaHelper:RandomInt(1,5)
local Wfxg = CS.XiaWorld.JianghuMgr.Instance:GetJHNpcDataBySeed(player.JiangHuSeed).Feature
local Dfxg = CS.XiaWorld.JianghuMgr.Instance:GetJHNpcDataBySeed(target.JiangHuSeed).Feature
local XianzheCD = target.LuaHelper:GetModifierStack("XianzheCD");
local NalitongCD = target.LuaHelper:GetModifierStack("NalitongCD");
local seyouCD = NalitongCD + XianzheCD
local jueseming = CS.XiaWorld.JianghuMgr.Instance:GetJHNpcName(target.JiangHuSeed)
local yuanfen = CS.XiaWorld.JianghuMgr.Instance:GetFateBetween(player,target)
print(player.Name.."互动对象的真实姓名为："..jueseming.."当前"..target.Age.."岁，两人缘分："..yuanfen)
	if jueseming == "何足道" and world:IsGongUnLocked("Gong_12_None") == false then--新的学习方式
		if (player.PropertyMgr:CheckFeature("Tiancilonggen") == true and player.PropertyMgr:CheckFeature("YangBody") == true) or player.Name == "卓十七" then
		self:SetTxt(""..player.Name.."来到何足道的面前，想要向她求请欢好双修，毕竟"..player.Name.."垂涎对方所修炼的符修秘法《太元五符云箓》已久，据传此功乃上古大能云中子于双修之时，因自己的持久力不强，故借破关之时引得天地之力关注于符箓。而起到一夜战万人而不怠的绝强道统。\n何足道本欲拒绝"..player.Name.."双修的请求，但一时迷醉于"..player.Name.."浑身散发出的那阳刚之气与其故意暴露出的那根足有25CM长的庞然大物之下，便半推半就的答应了"..player.Name.."。\n一夕欢愉之后，"..player.Name.."得偿所愿的习得了《太元五符云箓》。");
		player.LuaHelper:UnLockGong("Gong_12_None");
		else
		self:SetTxt(""..player.Name.."来到何足道的面前，想要向她求请欢好双修，毕竟"..player.Name.."垂涎对方所修炼的符修秘法《太元五符云箓》已久，据传此功乃上古大能云中子于双修之时，因自己的持久力不强，故借破关之时引得天地之力关注于符箓。而起到一夜战万人而不怠的绝强道统。\n因此绝学于双修忘情之时，便极易被人窥窃，何足道自是不愿神功外传，故拒绝了"..player.Name.."。");
		end
	return false;
	end
	if jueseming == "小龙女" then--年龄修复
	local nianlingxiufu = target.Age - 28
	target.PropertyMgr:AddAge(-nianlingxiufu);
	print("修复成功！"..jueseming.."当前"..target.Age.."岁")
	end
	if jueseming == "屠赞婢" and target.Sex == CS.XiaWorld.g_emNpcSex.Female then
		if player.LuaHelper:GetModifierStack("Luding") >= 10 and world:GetWorldFlag(1706) == 0 then
		world:SetWorldFlag(1706,1)
		target:AddModifier("XianzheCD");
		self:SetTxt(""..player.Name.."觉得屠赞婢肯定有什么情报没有告诉自己，傲山门的灭门之谜也一定没有那么简单，可诸多手段施展下来也不见对方的证言有所改变，于是"..player.Name.."决定改变策略……\n"..player.Name.."亲率十数健仆将屠赞婢绑了，出言要挟道：“屠赞婢，你若是在执迷不悟，不肯说出傲山门覆灭真相，就莫要怪本尊言之不预了！”\n屠赞婢脸上却毫无惧色，只闻其口中默念着什么“小赞小赞，苏神泽世……”之类的话语……\n见屠赞婢完全执迷不悟，"..player.Name.."恼羞成怒之余命令健仆将其轮了一番……");
		elseif player.LuaHelper:GetModifierStack("Luding") >= 10 and seyouCD > 0 and world:GetWorldFlag(1706) > 0 and world:GetWorldFlag(1706) < 11 then
		local X1 = world:GetWorldFlag(1706) + 1
		world:SetWorldFlag(1706,X1)
		print("屠赞婢被艹晕了"..world:GetWorldFlag(1706).."次");
		target:AddModifier("XianzheCD");
		self:SetTxt("被"..player.Name.."的健仆们轮了"..world:GetWorldFlag(1706).."番的屠赞婢浑身酸软的躺倒在地，却依旧咬紧牙关的不愿说出实情。\n见屠赞婢完全执迷不悟，"..player.Name.."恼羞成怒之余又命令健仆将其轮了一番……");
		elseif world:GetWorldFlag(1706) == 11 and world:GetWorldFlag(1705) == 1 and seyouCD > 0 then
		world:UnLockJianghuClue(1705);world:UnLockJianghuClue(1706);world:UnLockJianghuNpc("Npc_shiqi_3");world:SetWorldFlag(1705,2);
		self:SetTxt("被"..player.Name.."的健仆们轮了十余次的屠赞婢终于心神崩溃，木讷的眼神中泛着死灰，而"..player.Name.."也成功的从其口中得到了自己想要的情报……\n原来苏神教早就有安排要覆灭傲山门，在傲山门被官府驱逐出境后，她就亲自带队追击……\n而这一切的起因，则是苏神教护教左使-唐不甜与傲山门门主曾经因为一张中原王朝太医院的入学推荐有过争执……");
		elseif player.LuaHelper:GetModifierStack("Luding") >= 10 and seyouCD == 0 and world:GetWorldFlag(1706) > 0 and world:GetWorldFlag(1706) < 11 then
		world:SetWorldFlag(1706,1);
		target:AddModifier("XianzheCD");
		self:SetTxt(""..player.Name.."觉得屠赞婢肯定有什么情报没有告诉自己，傲山门的灭门之谜也一定没有那么简单，可诸多手段施展下来也不见对方的证言有所改变，于是"..player.Name.."决定改变策略……\n"..player.Name.."亲率十数健仆将屠赞婢绑了，出言要挟道：“屠赞婢，你若是在执迷不悟，不肯说出傲山门覆灭真相，就莫要怪本尊言之不预了！”\n屠赞婢脸上却毫无惧色，只闻其口中默念着什么“小赞小赞，苏神泽世……”之类的话语……\n见屠赞婢完全执迷不悟，"..player.Name.."恼羞成怒之余命令健仆将其轮了一番……");
		else
		self:SetTxt(""..target.Name.."一脸正色的拒绝了"..player.Name.."，并表示自己的屄是只属于苏神小赞大人的……");
		end
	return false;
	end
	if jueseming == "尹志平" and target.Sex == CS.XiaWorld.g_emNpcSex.Male then
		if world:GetWorldFlag(1704) == 1 and player.Sex == CS.XiaWorld.g_emNpcSex.Female and player.PropertyMgr:CheckFeature("BeautifulFace2") == true and player.PropertyMgr.Practice.Gong.Name == ("Gong_1701_Tu") then
		self:SetTxt(""..player.Name.."来到……尹志平面前，与小龙女及其相似的面容使得尹志平方寸大乱，"..player.Name.."乘机实战六欲心经中的迷情法术，激发了尹志平心中的兽性后，尹志平撕开了"..player.Name.."的衣衫，抚摸着那光滑、雪白的青春玉体，那修长的双腿、那还没有完全育成熟的柔软双峰，以及那令人失去理智的桃源洞口，让他仿佛回到了终南山下……\n他迫不及待地坐倒在松软的草地上，双腿分开，盘住"..player.Name.."的腰臀处，微一用力，身躯逼近"..player.Name.."张开的玉股间，顿时，早已昂扬勃的粗大肉棒直直地顶在两瓣已经微微充血显得娇艳异常的花唇间隙中，蓄势待发……\n一阵抽搐之后，尹志平倒在了"..player.Name.."的两股之间，而愉悦的过程中"..player.Name.."也得到了她想要知道的情报……\n曾经，这个青莲剑宗长老还没拜入青莲剑宗之前，曾是一个凡间武修门派的门人，年轻时曾奸污过一个绝美的凡人女子，直到现在剑道大成，即将超脱了还难以忘怀……\n并表示"..player.Name.."若能让他得偿所愿在干这女子一炮，必将自己毕生绝学传与"..player.Name.."……");
		world:SetWorldFlag(1704,2)
		elseif world:GetWorldFlag(1704) == 3 or world:GetWorldFlag(1704) == 5 then
		self:SetTxt(""..player.Name.."将小龙女（杨梓）送与了青莲剑宗大能尹志平，尹志平大喜至于将自己的毕生所学的精华，灌注于"..player.Name.."的识海之中……");
		while(player.LuaHelper:GetGLevel() ~= 12)do
		player.PropertyMgr.Practice:AddPractice(9999999)
		player.PropertyMgr.Practice:BrokenNeck();
			if player.LuaHelper:GetGLevel() == 12 then
				while(player.PropertyMgr.Practice.StageValue ~= player.PropertyMgr.Practice.CurStage.Value)do
				player.PropertyMgr.Practice:AddPractice(20000000)
				player.PropertyMgr.Practice:BrokenNeck();
				end
			end
		end
		player:AddModifier("Modifier_SpNpc_BasePropertie")
		player:AddModifier("Modifier_SpNpc_BaseFightPropertie");
		player:AddModifier("Modifier_SpNpc_Ling");
		player:AddModifier("Modifier_SpNpc_Shield");
		player:AddModifier("Modifier_SpNpc_FabaoAtk");
		player:AddModifier("Modifier_SpNpc_FabaoSpeed");
		player:AddModifier("Modifier_SpNpc_FabaoDisp");
		world:SetWorldFlag(1704,6)
		else
		self:SetTxt(""..target.Name.."一脸正色，完全不打算理会"..player.Name.."……");
		end
	return false;
	end
	if target.IsDeath then
	self:SetTxt(""..target.Name.."已经死了……");
	elseif target.LuaHelper:GetModifierStack("Prison_Modifier2")~= 0 then
	self:SetTxt("作为"..SchoolMgr.Name.."的囚犯"..target.Name.."自然是无法以任何理由拒绝"..SchoolMgr.Name.."弟子的，于是"..target.Name.."被"..player.Name.."操弄了一番。");
		if player.Sex == CS.XiaWorld.g_emNpcSex.Female and player.PropertyMgr:CheckFeature("Pogua")then
		player.PropertyMgr:AddFeature("Pogua");
		end
		if target.Sex == CS.XiaWorld.g_emNpcSex.Female and target.PropertyMgr:CheckFeature("Pogua")then
		target.PropertyMgr:AddFeature("Pogua");
		end
	target:AddModifier("XianzheCD");
	player:AddModifier("XianzheCD");
	elseif seyouCD == 0 then--cd判定，成功开始剧本
		if target.PropertyMgr:CheckFeature("Chastity") and player.PropertyMgr.RelationData:IsRelationShipWith("Spouse",target) == false then
		self:SetTxt(""..player.Name.."对"..target.Name.."提出了性需求，然而"..target.Name.."是一个贞洁的女子，她拒绝了"..player.Name.."。");
		return false;
		end
		if player.LuaHelper:GetModifierStack("Zhenchaosuo")~= 0 or player.LuaHelper:GetModifierStack("Zhenchaozhou") ~= 0 then--1带着贞操锁/咒
			if player.Sex == CS.XiaWorld.g_emNpcSex.Male and player.PropertyMgr.RelationData:IsRelationShipWith("Luding2",target) == true then--1是男，且是2的奴隶
			self:SetTxt(""..player.Name.."想要侍奉自己的主人，许是"..target.Name.."心情很好，她解开了贞操锁/咒，让"..player.Name.."用胯下肉棒侍奉了自己");
			target:AddModifier("XianzheCD");
			player:AddModifier("XianzheCD");
			else
				if player.Sex ~= CS.XiaWorld.g_emNpcSex.Male and player.PropertyMgr.RelationData:IsRelationShipWith("Luding2",target) == true then--1是女，且是2的奴隶
				self:SetTxt(""..player.Name.."想要侍奉自己的主人，许是"..target.Name.."心情很好，他解开了贞操锁/咒，让"..player.Name.."使用小穴侍奉了自己");
				target:AddModifier("XianzheCD");
				player:AddModifier("XianzheCD");
				else
					self:SetTxt(""..player.Name.."的下体被阳锁/贞操咒封住了，并不能对对方做什么，于是转身离开了。");
				end
			end
		return false;
		end
		if target.LuaHelper:GetModifierStack("Zhenchaosuo")~= 0 or target.LuaHelper:GetModifierStack("Zhenchaozhou") ~= 0 then--2带着贞操锁/咒
			if player.Sex == CS.XiaWorld.g_emNpcSex.Male and player.PropertyMgr.RelationData:IsRelationShipWith("Luding2",target) == true then--1是男，且是2的主人
			self:SetTxt(""..player.Name.."一时性起，想要干自己的女奴"..target.Name.."一炮，他解开了贞操锁/咒，在"..target.Name.."身上耕耘许久直到心满意足后转身离去了。");
			target:AddModifier("XianzheCD");
			player:AddModifier("XianzheCD");
			else
				if player.Sex ~= CS.XiaWorld.g_emNpcSex.Male and player.PropertyMgr.RelationData:IsRelationShipWith("Luding2",target) == true then--1是女，且是2的主人
				self:SetTxt(""..player.Name.."一时性起，感觉下身湿润了，想要自己的公狗"..target.Name.."来干上自己一炮，他解开了贞操锁/咒，"..target.Name.."用胯下肉棒侍奉了"..player.Name.."。");
				target:AddModifier("XianzheCD");
				player:AddModifier("XianzheCD");
				else
					self:SetTxt("还未等"..player.Name.."开口，只见"..target.Name.."摸了摸下身，也不理会"..player.Name.."便转身离去了。");
				end
			end
		return false;
		end
		if player.PropertyMgr.RelationData:IsRelationShipWith("Spouse",target) then
			if target.Sex ~= CS.XiaWorld.g_emNpcSex.Male and target.PropertyMgr:CheckFeature("Pogua") ~= true then
			self:SetTxt(""..target.Name.."的初夜一直为"..player.Name.."守护到了现在，从来没有任何污秽进入过她的身体，她是一个圣洁的处子，而这一份圣洁也是天道所喜的，"..player.Name.."与"..target.Name.."度过了美好的一夜……");
			target.PropertyMgr:AddFeature("Pogua");
			target.PropertyMgr:AddFeature("Chastity");
			elseif player.Sex ~= CS.XiaWorld.g_emNpcSex.Male and player.PropertyMgr:CheckFeature("Pogua") ~= true then
			self:SetTxt(""..player.Name.."的初夜一直为"..target.Name.."守护到了现在，从来没有任何污秽进入过她的身体，她是一个圣洁的处子，而这一份圣洁也是天道所喜的，"..player.Name.."与"..target.Name.."度过了美好的一夜……");
			player.PropertyMgr:AddFeature("Pogua");
			player.PropertyMgr:AddFeature("Chastity");
			else
			self:SetTxt(""..player.Name.."和"..target.Name.."是夫妻关系，想要干一炮显然是合理合法的需求，于是两个人开心的干了一炮。");
			end
		target:AddModifier("XianzheCD");
		player:AddModifier("XianzheCD");
		return false;
		end
		if player.PropertyMgr.RelationData:IsRelationShipWith("FancyFlag",target) then
		self:SetTxt(""..player.Name.."忽一时欲起，找到了自己的舔狗"..target.Name.."提出帮自己泻火，"..target.Name.."被这突来的幸运砸蒙了，兴奋的跪倒在地，用自己嘴侍奉了"..player.Name.."，"..player.Name.."心满意足后便离去了。");
		player:AddModifier("XianzheCD");
		return false;
		end
	for key,npcs in pairs(target.PropertyMgr.RelationData.m_mapRelationShips) do
		if (key == "Spouse") and npcs.Count > 0 then 
			print("找到夫妻或恋人关系")
			local isSpouse = false
			local Spouse = ""
			for _,npc in pairs(npcs) do
				Spouse = npc
				if player.ID == npc.ID then 
					isSpouse = true
					break
				end
			end
			if isSpouse == false then--判定NTR成功
				if player.Sex == CS.XiaWorld.g_emNpcSex.Male then
					if target.Sex == CS.XiaWorld.g_emNpcSex.Male then--男男ntr
					local npc3 = player.PropertyMgr.Practice.Master
						if player.LuaHelper:GetGLevel() > target.LuaHelper:GetGLevel() and  player.LuaHelper:GetGLevel() > Spouse.LuaHelper:GetGLevel() then
						self:SetTxt("一日，"..player.Name.."拦住了"..target.Name.."吩咐道："..target.Name.."啊，我觉得你的老婆"..Spouse.Name.."姿色不错，哪来给兄弟日以下可好？\n这绿油油的帽子"..target.Name.."自然不愿意带在头上，可实力不济的"..target.Name.."又无法反抗……只能将自己的妻子"..Spouse.Name.."迷晕之后送与"..player.Name.."对方玩弄……\n"..Spouse.Name.."成了"..player.Name.."的母狗……");
						player.PropertyMgr.RelationData:AddRelationShip(target,"Kuzhu");
						player.PropertyMgr.RelationData:AddRelationShip(Spouse,"Luding2");
							if Spouse.PropertyMgr:CheckFeature("Pogua") ~= true then
							Spouse.PropertyMgr:AddFeature("Pogua");
							end
						elseif player.LuaHelper:GetGLevel() > target.LuaHelper:GetGLevel() and npc3 ~= nil and npc3.LuaHelper:GetGLevel() > Spouse.LuaHelper:GetGLevel() and npc3.Sex == CS.XiaWorld.g_emNpcSex.Male then
						self:SetTxt("一日，"..player.Name.."拦住了"..target.Name.."吩咐道："..target.Name.."啊，我觉得你的老婆"..Spouse.Name.."姿色不错，哪来给兄弟日以下可好？\n这绿油油的帽子"..target.Name.."自然不愿意带在头上，可实力不济的"..target.Name.."又无法反抗，只能将"..player.Name.."带入家中……\n"..player.Name.."欲行不轨之事时，只见"..Spouse.Name.."三两下间便击倒"..player.Name.."……\n奈何"..player.Name.."早就料到自己的实力不及"..Spouse.Name.."，于是其早早就请了自己师傅一起享用此女……\n只见"..npc3.Name.."轻而易举的制住了"..Spouse.Name.."与弟子"..player.Name.."一同将"..target.Name.."的妻子"..Spouse.Name.."按在地上干了个爽……");
						player.PropertyMgr.RelationData:AddRelationShip(target,"Kuzhu");
						npc3.PropertyMgr.RelationData:AddRelationShip(target,"Kuzhu");
						player.PropertyMgr.RelationData:AddRelationShip(Spouse,"Luding2");
						npc3.PropertyMgr.RelationData:AddRelationShip(Spouse,"Luding2");
							if Spouse.PropertyMgr:CheckFeature("Pogua") ~= true then
							Spouse.PropertyMgr:AddFeature("Pogua");
							end
						elseif player.LuaHelper:GetGLevel() > target.LuaHelper:GetGLevel() then
						self:SetTxt("一日，"..player.Name.."拦住了"..target.Name.."吩咐道："..target.Name.."啊，我觉得你的老婆"..Spouse.Name.."姿色不错，哪来给兄弟日以下可好？\n这绿油油的帽子"..target.Name.."自然不愿意带在头上，可实力不济的"..target.Name.."又无法反抗，只能将"..player.Name.."带入家中……\n"..player.Name.."欲行不轨之事时，只见"..Spouse.Name.."三两下间便击倒"..player.Name.."，还没等"..target.Name.."来得及舔上两句，"..target.Name.."便被"..Spouse.Name.."踹倒在地上……\n"..Spouse.Name.."觉得"..target.Name.."不是良配，便与其终结了这段夫妻关系……");
						Spouse.PropertyMgr.RelationData:RemoveRelationShip(target,"Spouse");
						else
						self:SetTxt(""..target.Name.."实力远胜于"..player.Name.."，"..player.Name.."这样正大光明的夫目前犯，怕不是要被打出屎来……。");
						end
					else--男女ntr
						if target.PropertyMgr:CheckFeature("Pogua") == true and player.PropertyMgr.Practice.Gong.Name == ("Gong_1701_Tu") and target.PropertyMgr:CheckFeature("Chinvguchong") == true then--主角会采补，女非处，被蛊寄生
						self:SetTxt(""..target.Name.."感觉最近自己的欲念越来越强烈，经常不自觉想起和"..Spouse.Name.."缠绵的情景，想着想着脑海了的"..Spouse.Name.."竟然变成了这几天时有来往的"..player.Name.."。其实"..target.Name.."不知道，这都是阴阳和合蛊寄生后起的作用。"..target.Name.."失常欲火难耐，独自一人白天在小屋里自己抚慰自己，释放心中的欲望。\n这一日垂涎"..target.Name.."已久的"..player.Name.."待其不备封住了正在自摸的"..target.Name.."，"..player.Name.."一边脱下衣裤一边淫笑道：「"..target.Name.."，你已被我封住了灵力，放弃抵抗好好享受吧，我的鸡巴会让你欲仙欲死的。」\n说着"..player.Name.."立即向"..target.Name.."扑了过去。\n "..player.Name.."一只手扣住"..target.Name.."的双手，另一只手扶着"..target.Name.."的芊腰，用两个膝盖分开对方的双腿一边悄声道：「是不是觉得你的小骚穴痒痒的，特别想要？你被阴阳合欢蛊寄生了，此蛊会催发自身淫欲化为淫毒，如不与男子交合，只是自行抚弄，怕是要不了多久，就会被毒蛊变成一只欲求不满，只知淫欲的母狗……」\n"..target.Name.."的脸色一下子变得苍白，身子无助的发抖着。\n "..player.Name.."晃动屁股，使龟头对准"..target.Name.."的小穴后，缓缓用力，一根粗长的肉棒缓缓的插入到"..target.Name.."的深处。\n「不要！…………」感觉到火热的龟头挤开自己的阴唇，"..target.Name.."绝望地喊道。\n伴随着"..target.Name.."那紧致的肉腔的挤压无与伦比的美妙感觉让"..player.Name.."飘飘欲仙，占有了"..Spouse.Name.."的女人带给"..player.Name.."的心理快感更是妙不可言，从他龟头接触到"..target.Name.."那肥美娇嫩的花心。"..target.Name.."无比紧致的小穴死死的咬住"..player.Name.."的肉棒，粗大肉棒在嫩穴中狂猛抽插，胯部啪啪撞击着雪白玉臀，扶着腰部的手缓缓向上，攀上了那挺翘的玉女峰，大力的揉搓着。\n「！！……」\n 突然"..target.Name.."感觉到小穴的肉棒像活物一样，在自己的小穴里扭动着，龟头不断挑弄着自己的花心，可是明明这个淫贼的身子一动也没有动过。\n好奇的"..target.Name.."努力的看向自己的胯下。\n感觉到"..target.Name.."动作的"..player.Name.."调笑道：「怎么样"..target.Name.."，我兼修合欢宗的六欲心经，能控制肉棒拐弯，"..target.Name.."你还是从了我吧！」\n「不…不要……停……啊！……」"..target.Name.."想要开口喝止，可是身体下部传来的快感使她无法组织语言。\n「不要停是吧！你看好了……」说着"..player.Name.."大力抽插起来同时合欢功法运转，灵力通过肉棒传入"..target.Name.."的肉穴再到气海之中，再从紧致的阴道传过来之后，都会变得更加强大。"..player.Name.."精神大振体内灵力越来越充沛，当下抱紧"..target.Name.."，狂猛大干，灵力更是在她体内来回流转，以双修增强自己灵力，随着灵力在"..target.Name.."的气海与肉穴之间游走，夹着肉棒的小穴变得越发湿润，肉壁夹的越来越紧。\n「不……啊……不………啊……啊……好…好深……轻点……」看着在自己胯下扭动娇吟的"..target.Name.."，"..player.Name.."心中一阵自豪，下身更加用力的抽插着那娇嫩的小穴，同时也运使合欢功法加速灵力运转且让肉棒不断扭动忽上忽下、忽左忽右灵力流过肉壁的快感让"..target.Name.."兴奋得发狂，抱紧"..player.Name.."挺臀迎合，颤声浪叫道：「啊…啊……好…好爽……好棒……啊……好舒服……哦……哦……好深……哦……好舒服……啊……嗯呀……快……不要停……好舒服……呜呜……」\n 看着被自己胯下征服的"..target.Name.."，"..player.Name.."一阵自豪，不自觉的松开双手，把两只手撑在床上「埋头苦干」。\n\n "..target.Name.."喘息着，脸色羞红，双手扶着"..player.Name.."的肩膀，跨坐在他腰间，两人面对面交合的姿势使胸部产生强烈接触让"..target.Name.."更加兴奋难耐，低喘着把香吻献上，和"..player.Name.."亲的昏天地暗。\n同时癫狂地主动套动起来，一对丰满无比的奶子在"..player.Name.."面前上下抛摔着，不断接触男人的脸颊。\n"..player.Name.."突然抬起身子吸住了她的右乳头接着双手滑向美女臀下，抓住她的屁股向上一托，同时自己把大腿向里一收，一股向上的力量将"..target.Name.."的身子弹了起来，"..target.Name.."如吃惊的叫了一声，身体却又落下，重新坐回了他那根粗壮的阴茎上，而就这样子已完成了两人性具的一次磨擦。\n如此这般，跟着是第二次、第三次……"..target.Name.."的身体主动抱住"..player.Name.."的后背起起落落，继续承受着他的玩弄。他两只有力的手臂托着人妻的双臀不住地抬起、放下，加上强烈的视觉刺激，"..target.Name.."无比舒适地踦在他的跨上，「嗯……嗯……的哼叫着「好棒……啊……好舒服……哦……哦……好深……哦……好舒服……从没这么……快活……啊……呃……」她已经忘了一切，不知所云的胡乱呼喊着，每一次的肉体交欢都让她婉转娇吟，披到腰际的乌黑长发随着身体的上下套动在空中飞扬飘舞，嫣红的香腮上颗颗香汗滑下，胴体上浮起动人的绯红，那紧密的蚌肉紧夹着男人的大鸡巴，交合处玉露飞溅，点点滴滴顺着"..player.Name.."粗壮的大鸡巴洒落在胯间"..target.Name.."长吟一声，好似浑身上下都酥了，满满涨感直填到了心房里，心头猛跳，双眸水光盈盈的望着身下之人，双手撑着他胸膛，雪股急摆，嫩穴夹着巨棒大耸大落起来。\n\n "..player.Name.."见"..target.Name.."含情脉脉的看着自己，心中一片满足。只觉"..target.Name.."穴内嫩嫩滑滑，紧凑无比，且她淫水丰润，时不时便热辣辣的打在马眼上，十分舒爽。\n "..target.Name.."双眼迷离，乌发散落，浓浓鼻息荡着屋内空气亦随之沸燃"..target.Name.."那含苞待放的花心不断被大龟头连续地撞击，销魂蚀骨、阵阵酥麻的美感，平生第一次尝试到如此销魂蚀骨的性爱……");
						player.PropertyMgr.RelationData:AddRelationShip(target,"Luding2");
						player:AddModifier("Story_Caibuzhidao1");
						target:AddModifier("XianzheCD");
						player:AddModifier("XianzheCD");
						return false;
						end
						if target.PropertyMgr:CheckFeature("Pogua") == true and target.PropertyMgr:CheckFeature("Mugou") == true then
						self:SetTxt(""..target.Name.."虽是有夫之妇，但是经过无数次调教开发的肉体，对于任何人来说，都是不设防的……\n"..player.Name.."刚提出给"..Spouse.Name.."头让抹点绿的时候，便见到"..target.Name.."已经三下五除二的将衣服褪尽……\n一场酣战之后，双方均获得了肉体上的满足……\n事后，"..target.Name.."好像认定了"..player.Name.."这个主人……");
						player.PropertyMgr.RelationData:AddRelationShip(target,"Luding2");
						target:AddModifier("XianzheCD");
						player:AddModifier("XianzheCD");
						return false;
						end
						if target.PropertyMgr:CheckFeature("Pogua") == true and player.LuaHelper:GetModifierStack("YYHHGFL") ~= 0 then--主角有淫药，女非处
						self:SetTxt(" "..player.Name.."从怀里轻轻的掏出了一枚红丸，碾碎以后掐起一道法决化作一阵轻风悄无声息的吹入房中……\n少顷，屋内灯灭，显然里面的人已经睡下，深知此药厉害的"..player.Name.."就这样有恃无恐的潜进屋内\n"..player.Name.."轻轻关上房门转身看着趴在桌上熟睡的"..target.Name.."身体微微颤栗闻着闺房中沁人心脾的香味心中的欲火越来越旺盛。\n\n 他舔了舔嘴唇坐到了"..target.Name.."身边伸出右手轻轻抚摸着她白皙妩媚的脸庞手掌上传来的惊人触感令他激动不已。\n 安静燃烧的烛火散发着澹黄色的光映照在"..target.Name.."柔美的身段上。\n 那晶莹可爱的琼鼻轻启的唇珠露出了两颗洁白的银牙吹弹可破的肌肤无一不让"..player.Name.."沉醉。\n"..target.Name.."的闺房内"..player.Name.."已经将"..target.Name.."抱到了床上一双手正隔着轻薄的纱裙揉捏着她胸前那对硕大的美乳这极致触感和沸腾的欲火让他喘息不已。\n 他伸出舌头轻轻的舔舐着"..target.Name.."红润的脸颊而中了迷药的"..target.Name.."却依然睡得香甜。\n 「呼…」\n 心情稍微平息的"..player.Name.."站起身脱光自己的衣服之后开始脱"..target.Name.."的衣服。\n 不一会便剥去了她的纱裙露出了只剩亵衣和亵裤的美妙胴体。\n"..player.Name.."此刻的双眼几乎要放出光来贪婪的扫视着那光滑的香肩和平坦的小腹, 一只手已经急不可耐的摸上了"..target.Name.."那纤细修长的美腿无论是那柔软的大腿还，是光滑的小腿都让他赞叹不已而那对秀美白皙的玉足更是让他按捺不住直接捧到眼前，细细欣赏起来一边还猥琐的嗅着它的气味然后急不可耐的将其中一只玉足的足趾含入嘴里又舔又咬。\n同时另一只手也没闲着，随即呼吸一紧之间那"..target.Name.."浑身上下只剩一件亵衣，还露出了一只肥硕的美乳正被压在她身上的"..player.Name.."用力揉捏着四德一边享受着。\n"..target.Name.."胸前的丰润一边握着自己那被无数女子元阴强化过的威勐长枪用鹅蛋大小的龟头在她已经略微湿润的粉嫩美鲍上上下滑动接着轻轻向洞里插去。\n「我上了"..Spouse.Name.."的女人！」\n\n伴随着"..target.Name.."那紧致的肉腔的挤压无与伦比的美妙感觉让"..player.Name.."飘飘欲仙占有了"..Spouse.Name.."的女人带给"..player.Name.."的心理快感更是妙不可言从他龟头接触到"..target.Name.."那肥美娇嫩的花心。\n"..target.Name.."无比紧致的小穴死死的咬住"..player.Name.."的肉棒，粗大肉棒在嫩穴中狂猛抽插，胯部啪啪撞击着雪白玉臀，插得美人无意识的娇吟虽然在睡梦中却依然轻轻蹙起了眉头似乎感受到了下身那粗壮的肉茎。\n "..player.Name.."松开手中的美乳将"..target.Name.."修长的美腿架在肩上耸动着熊腰开始操弄眼前的尤物伴随着"..player.Name.."的操干"..target.Name.."的上半身也轻轻摇晃着那只暴露在空气中的美乳也不停晃动着。\n同时合欢功法下意识的运转着，灵力不停地在两人之间流转，"..player.Name.."内观气海，感觉到每次灵力通过肉棒传入"..target.Name.."的气海之中，再从紧致的阴道传过来之后，都会变得更加强大。"..player.Name.."精神大振体内灵力越来越充沛，自从修仙以来，他已经很有做爱升级的心得，当下抱紧"..target.Name.."，狂猛大干，灵力更是在她体内来回流转，以双修增强自己灵力，随着灵力在"..target.Name.."的气海与肉穴之间游走，夹着肉棒的小穴变得越发湿润，肉壁夹的越来越紧。\n 「嘶…太爽了…」\n"..player.Name.."一边干着一边感叹双手在"..target.Name.."的娇躯上四处摸索被架在他肩上的玉足不停晃动着"..player.Name.."舔了舔嘴唇随即将那大拇指含入嘴里用力吮吸着。\n 就这般操干了小半个时辰"..player.Name.."终于忍耐住不下体即将喷薄的欲望于是将"..target.Name.."的双腿压到她的胸前下身奋力冲刺起来。\n「哦…」\n 不一会儿"..player.Name.."便趴在"..target.Name.."身上痉挛起来在子宫上面狂猛跳动将一股股滚烫浓精送入她的子宫内。精液之中，灌注强大灵力，在人妻子宫中闪闪生辉，留下另一个男人的印记被这夹带灵力的滚烫浓精一烫，"..target.Name.."也在无意识的睡梦中达到了高潮，一大股珍贵的阴精喷薄而出，在双修功法的作用下很快便被"..player.Name.."的肉棒吸收炼化，化为灵力融入"..player.Name.."的气海之中。\n休息一阵之后，"..player.Name.."将"..target.Name.."的衣服重新穿好，收拾一下现场，施了个隐身咒从房门探出头观察了一番之后无声的融入了漆黑夜中。");
						local WDY = player.PropertyMgr:FindModifier("YYHHGFL")
						WDY:UpdateStack(-1);
						target:AddModifier("XianzheCD");
						player:AddModifier("XianzheCD");
						return false;
						end
						if Dfxg == CS.XiaWorld.g_emJHNpc_Feature.Greedy and player.LuaHelper:GetModifierStack("Qian") >= 1000000 and target.PropertyMgr:CheckFeature("Pogua") == true then--主角100W贪婪非处
						self:SetTxt(""..player.Name.."拿出一把银票，向"..target.Name.."表达了双修的愿望，"..target.Name.."看着银票，眼睛都直了，心道，这么多钱，别说是和你双修，就是当你的狗也甘之若饴。\n怕错失这次机会，"..target.Name.."连忙趴在地上舔"..player.Name.."的鞋底，同时沉腰将自己的后臀抬高，风骚的扭动着屁股，口中淫叫着，“啊……主人快来插我。”\n\n"..player.Name.."一脚踩在她的脸上，用随身带着的法器抽打着她摇个不停的骚屁股，一脸淫邪的笑道，“我插你，那你老公怎么办呢？你可是"..Spouse.Name.."的妻子啊，可不能不守妇道。”\n"..target.Name.."的脸都被踩得变形，还是乖巧的挤出讨好的笑容，“那是因为母狗之前没遇到主人，现在做了主人的贱母狗，我浑身上下都是属于主人的，任由主人随便玩弄。主人要是不让，我老公也不能操我。”\n"..player.Name.."把脚趾伸进她的狗嘴里，“这么乖啊，喏，这是主人赏你的。”\n"..player.Name.."又掏出一把银票扔在地上，"..target.Name.."口中含着脚趾，含糊不清的不住言道，“谢主人赏，谢主人赏……”磕了几个头，将银票捡了起来，攥成一卷，插进自己的后庭，摇着屁股讨好的说道，“主人，母狗有尾巴了，谢谢主人赏赐。”\n"..player.Name.."见这骚婊子这般淫贱，再也按捺不住心头欲火，提枪直刺。待云雨将歇之时——“啊，主人射进来吧，我要给主人生孩子，求求主人了。”"..target.Name.."淫叫着恳求"..player.Name.."。\n“给我生孩子，那你丈夫呢？”"..player.Name.."停了下来，坏笑着问。\n“他，他不配，主人放心，他的精液再也不会射进我的骚屄，母狗不会再让他碰了，母狗只属于主人一个人……啊……哦，谢谢主人……啊……”"..target.Name.."最终感受到一股滚烫射进了自己的淫穴，强烈的刺激之下，骚水也喷涌而出，“好……好爽，主人。”\n\n"..player.Name.."又递上了些许银两，拍了拍她的屁股，“你，不错，是条好狗。”\n\n事毕，"..target.Name.."成为了"..player.Name.."的女奴隶，"..target.Name.."获得银两10万两。");
						player:AddModifier("Qian");
						target:AddModifier("Qian");
						target:AddModifier("XianzheCD");
						player:AddModifier("XianzheCD");
						local WDQ = player.PropertyMgr:FindModifier("Qian")
						local DDQ = target.PropertyMgr:FindModifier("Qian")
						WDQ:UpdateStack(-100001);
						DDQ:UpdateStack(99999);
						player.PropertyMgr.RelationData:AddRelationShip(target,"Luding2");
						return false;
						end
						if Dfxg == CS.XiaWorld.g_emJHNpc_Feature.Greedy and player.LuaHelper:GetModifierStack("Qian") >= 1000000 and target.PropertyMgr:CheckFeature("Pogua") ~= true then--主角100W贪婪处女
						self:SetTxt(""..player.Name.."拿出一把银票，向"..target.Name.."表达了双修的愿望。"..target.Name.."看着银票，眼睛都直了，心想，还从来没见过这么多钱，真是后悔和他结婚了。\n可如今自己已经是"..Spouse.Name.."的妻子了，我和他还未曾欢好过，心下犹豫，这样做是否太对不起他了，可抬头看着那厚厚的一沓银票，又实在是怕错失这次机会。\n\n就在这犹豫之时，"..player.Name.."又拿出了一大把银票，全是汇通银号的千两票子，"..target.Name.."的眼睛就跟着那银票转动，失神之际，"..player.Name.."将银票插进了她双乳之间，她连忙按住，攥在手里。\n“我知道你还是个雏，我"..player.Name.."玩的就是雏。\n除了这些，你若应下，我手头还有几个零散的铺子和庄园，一并送你了。\n趁早踹了你那废物老公吧。”"..target.Name.."看着手里和眼前的票子，身下一热，淫水潺潺的就流了下来，口中娇喘着，伏在"..player.Name.."身下，用香舌侍弄着他的阳物，“爷的鸡巴真大，真不愧是财大器粗呢。”阴茎、阳袋都小心的舔弄着。\n"..player.Name.."听得高兴，被她伺候的也舒服，又拿出一沓子银票随手扔在了地上，“像狗一样捡起来，捡起来就是你的了。”\n"..target.Name.."听话的趴在地上，用舌头卷、用嘴叼，将银票都收拢到了一起，跪着磕了几个头，“母狗谢主人赏赐。”\n“真聪明，可我还是觉得你这个贱母狗没长尾巴，真是难看呢。”"..target.Name.."看了看四周，除了银票再无他物，心下一横，将面前的银票攥成一卷，插进自己的后庭，摇着屁股讨好的说道，“主人，母狗有尾巴了，谢谢主人赐给母狗尾巴。”\n"..player.Name.."用脚拍打着"..target.Name.."的脸，“你说，你这母狗怎么这么贱啊？要不把你这贱样用留影法器录下来，让你老公看看？”"..target.Name.."讨好的舔舐着"..player.Name.."的脚趾，“母狗才不管那个废物老公呢，母狗只想主人操我。”\n\n“去，躺到那，自己把腿掰开，让主人看看你的膜还在吗。”"..target.Name.."用双手分开双腿，手指掰开阴唇，正面展示给"..player.Name.."看，“在的主人，母狗的贱狗老公也没碰过，母狗的膜是专门留给主人的。”\n"..player.Name.."一脚踢在她的屄上，“你这烂屄的膜也配留给我，去，自己拿银子捅烂了再像狗一样跪到那儿给老子操。”\n“是。”"..target.Name.."用地上的碎银子插破的自己的处女膜，而后跪着，等待着"..player.Name.."的临幸。"..player.Name.."见这骚婊子这般淫贱，再也按捺不住心头欲火，拍了拍她的屁股，便将鸡巴插了进去。待云雨将歇之时——“啊，主人射进来吧，我要给主人生孩子，求求主人了。”\n"..target.Name.."淫叫着恳求"..player.Name.."。“给我生孩子，那你丈夫呢？”"..player.Name.."停了下来，坏笑着问。“他，他不配，主人放心，他的精液以后不会射进我的骚屄，母狗不会让他碰的，母狗只属于主人一个人……啊……哦，谢谢主人……啊……”"..target.Name.."最终感受到一股滚烫射进了自己的淫穴，强烈的刺激之下，骚水也喷涌而出，“好……好爽，主人。”\n\n"..player.Name.."又递上了些许银两，将鸡巴在她脸上蹭了蹭，从储物戒中拿出一条贞操带，“你，不错，是条好狗。喏，把这个戴上，以后每月都有赏赐。”\n\n"..target.Name.."得了赏，欢喜的戴上带子，扭着屁股磕头，“谢主人赏，贱奴的骚屄永远只属于主人。”\n\n突然之间，"..target.Name.."觉得身下凉凉的，方才戴上的贞操带竟已消失不见，细看之下，小腹下方竟多了一处淫纹图案——“这是我独门的贞操咒印，无人能解，日后你的穴口只有接触到我的阳具，才会张开，否则只有针孔大小，他人精液也无法流入。”\n\n"..target.Name.."听闻自己的贞操带竟是永久的，心中激动，自己果真永远属于主人了，看着小腹的淫纹与紧贴着的屄缝，好想主人干我。\n身下的淫水已然泛滥，在地上纵横流淌。\n\n事毕，"..target.Name.."成为了"..player.Name.."的女奴隶，"..target.Name.."获得银两20万两，"..target.Name.."获得贞操咒印，"..player.Name.."获得元阴落红。")
						player:AddModifier("Qian");
						target:AddModifier("Qian");
						target.PropertyMgr:AddFeature("Pogua");
						target:AddModifier("Zhenchaosuo");
						player:AddModifier("Diyidixue");
						target:AddModifier("XianzheCD");
						player:AddModifier("XianzheCD");
						local WDQ = player.PropertyMgr:FindModifier("Qian")
						local DDQ = target.PropertyMgr:FindModifier("Qian")
						WDQ:UpdateStack(-200001);
						DDQ:UpdateStack(199999);
						player.PropertyMgr.RelationData:AddRelationShip(target,"Luding2");
						player.PropertyMgr.RelationData:AddRelationShip(target,"Chunv");
						player.LuaHelper:DropAwardItem("Item_Nvxiuluohong",1);
						return false;
						end
						if Dfxg == CS.XiaWorld.g_emJHNpc_Feature.Greedy and player.LuaHelper:GetModifierStack("Qian") >= 100000 and target.PropertyMgr:CheckFeature("Pogua") == true then--主角10W贪婪非处
						self:SetTxt(""..player.Name.."拿出两张银票递给"..target.Name.."，向她表达了双修的愿望。\n"..target.Name.."看着银票，足有千两之多，心道这也不少了，自从我跟了那个死鬼，就没过过一天好日子，银钱哪里够使的，心中刚一盘算，便将银票一把攥在了手中，谨慎的看了看四周，暗道，“跟我来。”\n二人来到"..target.Name.."的卧房，"..target.Name.."含饴弄箫之际，双手也未闲着，拢、捻、捏、划，挑动着"..player.Name.."的春袋、双乳、后背。\n"..player.Name.."舒爽万分，心中却仍有些担忧，“好仙子，"..Spouse.Name.."今日去哪里了，不会回来吧。”“蹦，”"..target.Name.."吐出巨大的阳物，“好好地提他干嘛，你就放点心吧，今天没人打扰我们的好事的。”\n而后一路向上舔弄着，精湛的口技弄得"..player.Name.."意乱神迷。\n“还有更爽更刺激的，要玩吗？”"..target.Name.."笑得妩媚，"..player.Name.."只顾不住点头。\n“愣着干嘛，加钱啊。”"..target.Name.."握着他的阳物，白了他一眼。\n“哦……哦哦。”"..player.Name.."似是被下了降头，又乖乖的从储物戒中拿出两张银票。\n"..target.Name.."银钱到手，笑得开心，“我告诉你啊，你今儿这钱花的不亏，我那死鬼老公我还没这样伺候过呢。”\n"..target.Name.."蹲在他的身后，舌尖轻挑后庭，除去秽物后，将后庭湿润，香舌团作一股，向更深处探去。\n“啊……呼……”"..player.Name.."忍不住叫出声来，“仙子，仙子好厉害……真是美极了……”“安啦，还有更舒服的呢。\n”波推、骑乘……一整套做下来，"..player.Name.."身心愉悦。临走之时，"..player.Name.."又给了"..target.Name.."一些银子，“仙子以后莫要忘了我。”\n"..target.Name.."获得银两3000两。");
						player:AddModifier("Qian");
						target:AddModifier("Qian");
						target:AddModifier("XianzheCD");
						player:AddModifier("XianzheCD");
						local WDQ = player.PropertyMgr:FindModifier("Qian")
						local DDQ = target.PropertyMgr:FindModifier("Qian")
						WDQ:UpdateStack(-3001);
						DDQ:UpdateStack(2999);
						return false;
						end
						if Dfxg == CS.XiaWorld.g_emJHNpc_Feature.Greedy and player.LuaHelper:GetModifierStack("Qian") >= 100000 and target.PropertyMgr:CheckFeature("Pogua") ~= true then--主角10W贪婪处女
						self:SetTxt(""..player.Name.."拿出两张银票递给"..target.Name.."，向她表达了双修的愿望。\n"..target.Name.."看着这两张银票，心道这人也算出手阔绰了，只是，我和"..Spouse.Name.."虽已成婚却还未曾欢好过，这般做法，也太不要脸面了。\n未理那人，转身便要离去，"..player.Name.."忙道，“别走啊，价钱好商量的。”又拿出了几张银票挥手向"..target.Name.."示意。\n"..target.Name.."心中略作挣扎，却仍是不愿舍了自己的元阴之身，表面上走得坚决，头也不回。看着"..target.Name.."的身影渐远，"..player.Name.."嘴上恨恨骂着，“臭婊子，装什么纯，不就嫌老子钱少吗……”。");
						return false;
						end
						if Dfxg == CS.XiaWorld.g_emJHNpc_Feature.Greedy and player.LuaHelper:GetModifierStack("Qian") < 100000 then--主角小于10W贪婪女
						self:SetTxt(""..player.Name.."捧着一株灵草，向"..target.Name.."表达了想要双修的愿望。\n"..target.Name.."轻蔑的扫了一眼他的穿着打扮，“就你？也不掂量掂量自己，我老公可是九华村首富，就是用钱砸也把你砸死了。再说了，我就是给富豪舔脚、当肉便器，也不愿让你这穷逼碰一根手指头，快滚吧。”\n"..target.Name.."说完嗤笑一声便离去了，"..player.Name.."呆立在原地，低着头两眼通红，手中的灵草也打了蔫似的弯了下来。");
						return false;
						end
						if Dfxg == CS.XiaWorld.g_emJHNpc_Feature.Weak and player.LuaHelper:GetGLevel() - 5 > target.LuaHelper:GetGLevel() and target.PropertyMgr:CheckFeature("Pogua") == true then--软弱非处1
						self:SetTxt(""..player.Name.."当面直截了当的向"..target.Name.."提出了双修的要求。\n"..target.Name.."心中惊惧，自己已为人妇，怎能答应，可"..player.Name.."修为高绝，若是惹恼了他，全家也要跟着遭殃。\n她低头咬着嘴唇，羞红了脸，“那，你可不要声张出去，而且，而且说好了，就这一次。”\n\n"..player.Name.."当街揉捏着她的屁股，“别废话了，走吧，你也不想被别人看到不是吗？”\n\n床榻之上，"..target.Name.."顺从的给"..player.Name.."呵着卵子——“好了，给爷舔舔屁眼。”\n怎么这样……那里那么脏……我给老公就连口交都没做过呢。“\n爷，要不，我伺候您洗洗，然后再给您舔？”"..target.Name.."陪着笑小心的试探。\n"..player.Name.."大怒，“你个贱婊子还嫌爷脏？”抓起"..target.Name.."的头发，将她的脑袋直埋进了尿桶之中，任她挣扎求饶也不松手。\n待声息渐弱，"..player.Name.."将她拽出尿桶，"..target.Name.."大口的喘息着，咳嗽着，全然不顾满身的尿液。\n“爽吗，贱屄？”"..player.Name.."用脚踩着她的奶子。\n“爽，爽……求爷饶了贱屄吧，贱屄刚才犯贱，贱屄知道错了。”"..target.Name.."不住的求饶。\n"..player.Name.."递给"..target.Name.."一件像笔一样的法器，“这是以龙血为墨制成的灵纹法器，纹在身上就洗不掉了，也是为了让你记住自己的身份，去，自己给你屄两边纹上‘贱屄’两个字。”\n“是，是，谢主人赐名。”"..target.Name.."乖乖的给自己刺字。\n“贱屄，你老公以后看见这两个字怎么办啊？”"..player.Name.."笑着问。\n“贱屄就说，这是主人赏赐的，贱屄以后就是主人的玩具，让贱老公以后再也不能碰了。”\n"..target.Name.."答得利索，"..player.Name.."想收拾竟都找不到由头，无奈之下递出一块木板，“你那烂屄太松了，爷看着就倒胃口，拿着，狠狠的扇自己那烂屄，边扇边报数，每次报数后面都要接一声‘谢主人赏’，记住了吗？”\n“是，贱屄记得了。”"..target.Name.."接过木板，用力向自己下体打去，“一，谢主人赏……”\n\n二人在"..player.Name.."的洞府玩了足足三天三夜，"..target.Name.."一身湿哒黏腻，红肿的小穴处不断往外淌着白浊的液体。除私处的刺青外，"..target.Name.."的阴部、乳头也被穿了星髓制成的奴环。\n“回去吧，让你老公看看你现在的贱样。”\n“是。”"..target.Name.."四肢着地，像狗一样一步一步往家中爬去。\n"..player.Name.."情绪+20,"..target.Name.."身体多处受伤（可治愈），"..target.Name.."成为了"..player.Name.."的女奴隶。");
						player.PropertyMgr.RelationData:AddRelationShip(target,"Luding2");
						target.LuaHelper:AddDamageRandomPart(3,"Cut1",0.5, "来自性虐鞭挞割裂伤");
						target.LuaHelper:AddDamage("Scar","Hips",0.01, "真气纹身，上书“贱屄”字样。");
						target:AddModifier("XianzheCD");
						player:AddModifier("XianzheCD");
						return false;
						end
						if Dfxg == CS.XiaWorld.g_emJHNpc_Feature.Weak and player.LuaHelper:GetGLevel() - 5 > target.LuaHelper:GetGLevel() and target.PropertyMgr:CheckFeature("Pogua") ~= true then--软弱处1
						self:SetTxt(""..player.Name.."当面直截了当的向"..target.Name.."提出了双修的要求。\n"..target.Name.."心中惊惧，自己已为人妇了，且结婚这些日子了老公还没碰过自己的身子，怎能让外人就这般污了清白。\n可"..player.Name.."修为高绝，若是惹恼了他，自己全家也要跟着遭殃。\n"..target.Name.."深陷惶恐之中，不知该如何是好，"..player.Name.."可不管那么许多，手已经按在了她的屁股上，不住地揉捏着，“别想了，你逃不了的。”\n\n"..player.Name.."带着她来到自己的洞府，"..target.Name.."平日里也看过些图册，心想不论做出何种牺牲，也要保住自己的处女元阴，不能让老公知晓自己失身之事，于是跪着面向"..player.Name.."的巨龙，生涩的舔吸着。\n侍弄了有一刻钟，"..player.Name.."却一点射精的意思也没有，"..target.Name.."的小口已酸涩的不行了，喘了口气，想要歇息片刻。\n"..player.Name.."笑着，“我知你还是处子，若你将我伺候舒服了，想要保住身子也不是不行。”\n而后手扶着鸡巴拍打她的脸，“记住了，别光顾着这根东西，蛋蛋、屁眼，都给老子仔细舔着。”\n在此之前，"..target.Name.."甚至还从未看到过男人的下体，与老公寻常的肢体接触也几乎没有，此刻却像是久历皮肉生意的老姐儿，客提的什么要求都不皱一下眉，顺从的给"..player.Name.."舔着菊穴，秽物也都吃了下去。\n\n二人在"..player.Name.."的洞府玩了足足三天三夜，"..target.Name.."全力的陪侍令"..player.Name.."心神愉悦，无论什么要求只要以破处作为要挟，"..target.Name.."都会乖乖答应。\n虽未取她的元阴落红，"..player.Name.."自觉也算玩得尽兴了。\n"..target.Name.."原本的衣衫已全然毁坏了，如今只紧裹着"..player.Name.."的长袍往家中走去，"..Spouse.Name.."迎面，却不知"..target.Name.."的菊穴、口中均含着"..player.Name.."的浓精，乳头、臀部也被刻上了有"..player.Name.."的母狗……");
						player.PropertyMgr.RelationData:AddRelationShip(target,"Luding2");
						target.LuaHelper:AddDamage("Scar","Hips",0.01, "真气纹身，上书“"..player.Name.."的母狗”字样。");
						target:AddModifier("XianzheCD");
						player:AddModifier("XianzheCD");
						return false;
						end
						if Dfxg == CS.XiaWorld.g_emJHNpc_Feature.Weak and player.LuaHelper:GetGLevel() > target.LuaHelper:GetGLevel() and target.PropertyMgr:CheckFeature("Pogua") == true then--软弱非处2
						self:SetTxt(""..player.Name.."当面直截了当的向"..target.Name.."提出了双修的要求。\n"..target.Name.."心中不悦，明知我是有丈夫的人，做了这事，日后脸面岂不都要丢尽了。可他修为高我许多，若不应下，又怕他发难。\n"..target.Name.."佯作羞色，表面上答应了下来，一路随着"..player.Name.."向他的洞府而行。\n路上，趁"..player.Name.."驾驭飞行法器灵力不济之际，暗施法术，猛然偷袭。不料"..player.Name.."早有防备，灵宝护体，竟毫发无伤，反将"..target.Name.."用法宝缚住，带回了洞府。\n\n“臭婊子，他妈还敢害老子？”"..player.Name.."扇了她两巴掌，看着她战栗发抖的样子既觉爽快，又觉得有些不够过瘾，“你他妈的，爷给你洗洗脸。”\n"..player.Name.."抓起"..target.Name.."的头发，将她的脑袋直埋进了尿桶之中，任她挣扎求饶也不松手。\n待声息渐弱，"..player.Name.."将她拽出尿桶，"..target.Name.."大口的喘息着，咳嗽着，全然不顾满身的尿液。\n“爽吗，贱屄？”"..player.Name.."用脚踩着她的奶子。\n“爽，爽……求爷饶了贱屄吧，贱屄刚才犯贱，贱屄知道错了。”"..target.Name.."不住的求饶。\n"..player.Name.."递给"..target.Name.."一件像笔一样的法器，“这是以龙血为墨制成的灵纹法器，纹在身上就洗不掉了，也是为了让你记住自己的身份，去，自己给你屄两边纹上‘贱屄’两个字。”\n“是，是，谢主人赐名。”"..target.Name.."乖乖的张开双腿给自己刺字。\n"..player.Name.."看得有趣，“贱屄，你老公以后看见这两个字怎么办啊？”\n“贱屄就说，这是主人赏赐的，贱屄以后就是主人的玩具，让贱老公以后再也不能碰了。”\n"..player.Name.."答得利索，"..target.Name.."想收拾竟都找不到由头，无奈之下递出一块木板，“你那烂屄太松了，爷看着就倒胃口，拿着，狠狠的扇自己那烂屄，边扇边报数，每次报数后面都要接一声‘谢主人赏’，记住了吗？”\n“是，贱屄记得了。”"..target.Name.."接过木板，用力向自己下体打去，“一，谢主人赏……”……\n\n“主人打你是为了你好，知道吗，省的整天没事动坏心眼子。”"..player.Name.."把脚伸了出去，让跪趴着的"..target.Name.."用香舌伺候着。\n“知道了，谢谢主人打奴奴，奴奴喜欢主人打我。”"..target.Name.."顺从的舔着"..player.Name.."的脚底，扭动着高高撅起的翘臀。\n"..player.Name.."手里拿着长鞭，抽打着"..target.Name.."的屁股，忽觉翘挺的屁股上一片白，打起来也没什么意思。\n拿起灵纹法器在"..target.Name.."的屁股上又刺了“贱畜母狗"..target.Name.."”几个大字。\n粉涨的屁股将龙血刺青映得殷红，其上鞭痕交错，"..player.Name.."看着自己的成果不禁色欲大盛，怒龙高抬，扶着丰润的臀部挺身而入。\n二人在"..player.Name.."的洞府玩了足足三天三夜，"..target.Name.."一身湿哒黏腻，红肿的小穴、后庭都不断往外淌着白浊的液体。\n除私处和臀部的刺青外，"..target.Name.."的阴部、乳头也被穿了星髓制成的奴环。“回去吧，让你老公看看你现在的贱样。”\n“是。”"..target.Name.."四肢着地，像狗一样一步一步往家中爬去。\n"..target.Name.."身体多处受伤（可治愈），"..target.Name.."成为了"..player.Name.."的女奴隶。");
						player.PropertyMgr.RelationData:AddRelationShip(target,"Luding2");
						target.LuaHelper:AddDamageRandomPart(3,"Cut1",0.5, "来自性虐鞭挞割裂伤");
						target.LuaHelper:AddDamage("Scar","Hips",0.01, "真气纹身，上书“贱屄”字样。");
						target:AddModifier("XianzheCD");
						player:AddModifier("XianzheCD");
						return false;
						end
						if Dfxg == CS.XiaWorld.g_emJHNpc_Feature.Weak and player.LuaHelper:GetGLevel() > target.LuaHelper:GetGLevel() and target.PropertyMgr:CheckFeature("Pogua") ~= true then--软弱处2
						self:SetTxt(""..player.Name.."当面直截了当的向"..target.Name.."提出了双修的要求。\n"..target.Name.."念及自己还是处子之身，结婚这些日子以来，丈夫还未曾与自己欢好过，若与他人有染，这往后的日子可怎么过啊。\n她暗施法力，探查"..player.Name.."的修为境界，发现"..player.Name.."修为高出自己不少，此刻若不应下，又怕他直行那不轨之事，自己可就难以应对了。\n"..target.Name.."佯作羞色，表面上答应了下来，一路随着"..player.Name.."向他的洞府而行。\n路上，趁"..player.Name.."驾驭飞行法器灵力不济之际，祭出法宝，猛然偷袭。\n不料"..player.Name.."早有防备，灵宝护体，竟毫发无伤，反将"..target.Name.."用法宝缚住，带回了洞府。\n\n“臭婊子，他妈还敢害老子？”"..player.Name.."扇了她两巴掌，看着她战栗发抖的样子既觉爽快，又觉得有些不够过瘾，“你他妈的，爷给你洗洗脸。”\n"..player.Name.."抓起"..target.Name.."的头发，将她的脑袋直埋进了尿桶之中，任她挣扎求饶也不松手。\n待声息渐弱，"..player.Name.."将她拽出尿桶，"..target.Name.."大口的喘息着，咳嗽着，全然不顾满身的尿液。\n“爽吗，贱屄？”"..player.Name.."用脚踩着她的奶子。\n“爽，爽……求爷饶了贱屄吧，贱屄刚才犯贱，贱屄知道错了。”"..target.Name.."不住的求饶。\n"..player.Name.."递给"..target.Name.."一件像笔一样的法器，“这是以龙血为墨制成的灵纹法器，纹在身上就洗不掉了，也是为了让你记住自己的身份，去，自己给你屄两边纹上‘贱屄’两个字。”\n“是，是，谢主人赐名。”"..target.Name.."乖乖的给自己刺字。\n"..player.Name.."欣赏着"..target.Name.."粉嫩的蜜穴，觉得这两个字真是美妙极了，“把腿分开，用手掰开你那贱屄，让也好好看看。”\n“是。”"..target.Name.."将腿张到最大，手指在左右两侧按住小阴唇，将美穴毫无保留的展示出来。\n“这是什么，”"..player.Name.."看着她小穴口半透明的薄膜，“没想到你还是个雏？”\n“是，是，”"..target.Name.."被弄得怕了，忙想着该怎么回话，“贱屄的身子就是主人的，之前老公一直想操我我都不答应，贱屄知道，贱屄的膜要留给主人，求主人给贱屄破处。”\n“这么想让我操啊，那你自己来吧。”"..player.Name.."躺在床上，摇动着鸡巴。\n“是，谢谢主人操贱屄，贱屄太高兴了。”"..target.Name.."骑在"..player.Name.."的腰间，手扶着那粗长的阳物，对准小穴，缓缓地坐了下去。\n\n之后，二人在"..player.Name.."的洞府玩了足足三天三夜，"..target.Name.."一身湿哒黏腻，纹着刺青红肿的小穴处不断往外淌着白浊的液体。\n"..player.Name.."看着躺在那里浑身赤裸的"..target.Name.."，心念一动，捏起咒诀，施了一道法术，"..target.Name.."的小腹下方忽的显现了一幅淫纹图案，“你不是说你的贱屄属于我吗？这是我独门的贞操秘术，你看看你的屄，现在是不是小的像针眼一样。你老公要想操，以后还得先问问我。”\n"..target.Name.."成为了"..player.Name.."的女奴隶，"..target.Name.."获得贞操咒印。");
						player.PropertyMgr.RelationData:AddRelationShip(target,"Luding2");
						player.PropertyMgr.RelationData:AddRelationShip(target,"Chunv");
						target.LuaHelper:AddDamageRandomPart(3,"Cut1",0.5, "来自性虐鞭挞割裂伤");
						target.LuaHelper:AddDamage("Scar","Hips",0.01, "真气纹身，上书“贱屄”字样。");
						target.PropertyMgr:AddFeature("Pogua");
						target:AddModifier("XianzheCD");
						player:AddModifier("XianzheCD");
						return false;
						end
						if Dfxg == CS.XiaWorld.g_emJHNpc_Feature.Weak and player.LuaHelper:GetGLevel() <= target.LuaHelper:GetGLevel() then--软弱但是比我强或者相同
						self:SetTxt(""..player.Name.."当面直截了当的向"..target.Name.."提出了双修的要求。\n"..target.Name.."心中不悦，明知我是有丈夫的人还屡次前来纠缠于我，暗施法力查探了一番"..player.Name.."的修为境界，发现不过尔尔，便施法宝护体，果断回绝道，“你再这般纠缠，休怪我不客气了。”\n"..player.Name.."看她祭出这等绝品法宝，心生胆怯，连忙退去了。");
						return false;
						end
						if Dfxg == CS.XiaWorld.g_emJHNpc_Feature.Naive and player.LuaHelper:GetCharisma() > 9 and target.PropertyMgr:CheckFeature("Pogua") == true then--天真非处，我魅力大于9
						self:SetTxt(""..player.Name.."朝着"..target.Name.."露出微笑，委婉的向"..target.Name.."表露出想与之双修的愿望。\n"..target.Name.."看着眼前的男子，高冠清扬，气格超逸不群，风清骨峻而令人心向往之，她甚至都没听清"..player.Name.."说了什么。\n"..player.Name.."笑得温暖和煦，大方的又向她再次倾吐心声，"..target.Name.."感觉自己的心都要跳了出来，这般俊美的男子竟然会对我心生爱慕，羞怯之下，竟不知如何言语，面色涨得通红，连忙双手捂脸，以饰娇羞。\n她这般举措落在"..player.Name.."眼中，倒也觉得纯真可爱，偏又生了几分怜爱。\n\n"..player.Name.."与她相拥，欲低头深吻，"..target.Name.."看着那绝美的面庞逐渐沉沦，就在双唇将触之际，"..target.Name.."一个激灵，“我，我结婚了的，我不能对不起他。”伸手欲将他推开。\n"..player.Name.."却抱得更紧，“我们就这一次，他不会知道的。我知道，你也想要的。”\n"..player.Name.."在她耳畔轻语，温热的气息湿润了她的心房，她感觉耳朵、心里都痒痒的，她从未有过这般感受。\n"..player.Name.."用手探向她的裙底，抚弄着，“瞧，你都湿了不是吗？闭上眼睛，放松自己，都交给我就好了。”\n"..target.Name.."闭眼，默默的喘息着，"..Spouse.Name.."在她的心中已然消散，脑海中全是"..player.Name.."的天人一般的容颜，他的声音、他的气息、他身体的温度都已铭刻在了她的心里。\n她感觉自己是在天上，暖暖的，也有云雾的湿气，赏着世间绝景，或许此刻的自己是这个世界上最幸福的人了吧。\n云消雨歇，"..player.Name.."吻在她的额头，“宝贝，我走了。”\n"..target.Name.."拽着他的袖子，“可，可不可以不要走……”\n“就当这是一场梦，好吗。”");
						player.PropertyMgr.RelationData:AddRelationShip(target,"Lover");
						target:AddModifier("XianzheCD");
						player:AddModifier("XianzheCD");
						return false;
						end
						if Dfxg == CS.XiaWorld.g_emJHNpc_Feature.Naive and player.LuaHelper:GetCharisma() > 9 and target.PropertyMgr:CheckFeature("Pogua") ~= true then--天真处，我魅力大于9
						self:SetTxt(""..player.Name.."朝着"..target.Name.."露出微笑，委婉的向"..target.Name.."表露出想与之双修的愿望。\n"..target.Name.."看着眼前的男子，高冠清扬，气格超逸不群，风清骨峻而令人心向往之，她甚至都没听清"..player.Name.."说了什么。\n"..player.Name.."笑得温暖和煦，大方的又向她再次倾吐心声，"..target.Name.."感觉自己的心都要跳了出来，这般俊美的男子竟然会对我心生爱慕，羞怯之下，竟不知如何言语，面色涨得通红，连忙双手捂脸，以饰娇羞。\n她这般举措落在"..player.Name.."眼中，倒也觉得纯真可爱，偏又生了几分怜爱。\n\n"..player.Name.."与她相拥，欲低头深吻，"..target.Name.."看着那绝美的面庞逐渐沉沦，就在双唇将触之际，"..target.Name.."一个激灵，突然想起自己的丈夫，猛地将"..player.Name.."推开。\n婚礼当日，"..Spouse.Name.."被灌得大醉，难行周公之礼，后来二人竟也没顾得上，以致今日她还是处子之身。\n“我，我是有丈夫的，我们不能这样。”"..target.Name.."忙说。\n"..player.Name.."不管不顾，上前将她紧紧的抱在怀里，“亲爱的，你那丈夫，"..Spouse.Name.."整日在外花天酒地，他可曾将你视作妻子。我爱煞了你，我的心中只有你一人，我不想你受委屈，跟我走吧。”\n"..player.Name.."的语气坚决，像一块大石撞开了她的心防，她默默地流泪，闭眼，不再想其他。\n“是了，相信我，我会给你幸福的，慢慢放松，都交给我就好了。”\n"..player.Name.."轻抚着她的后背，低头吻上她的樱唇。\n"..target.Name.."心里甜丝丝的，还有些痒痒的，似是在期待着什么，此刻，他的声音、他的气息、他身体的温度都已铭刻在了她的心里。\n她静静的感受着，她感觉自己仿若是在天上，暖暖的，也有云雾的湿气，赏着世间的绝景，或许此时此刻自己是这个世界上最幸福的人了吧。\n\n一夜欢愉，梦醒时分却不见情郎身影。\n“骗子，”她流着泪，咬着手帕，心下却难生恨意。\n“玲珑骰子安红豆，入骨相思知不知。”");
						target.PropertyMgr:AddFeature("Pogua");
						player.PropertyMgr.RelationData:AddRelationShip(target,"Lover");
						target:AddModifier("XianzheCD");
						player:AddModifier("XianzheCD");
						return false;
						end
						if Dfxg == CS.XiaWorld.g_emJHNpc_Feature.Naive and player.PropertyMgr.RelationData:IsRelationShipWith("Lover",target) == true and target.PropertyMgr:CheckFeature("Pogua") == true then--天真非处，是恋人
						self:SetTxt(""..target.Name.."不喜拘着自己在那漫漫仙途之上求索，自然畅达或是她的本心所求，故而无事时常逛逛坊市，看看那些娇艳的灵植，寻些古物和一些有趣的小玩意儿，打发打发时间。\n只是，这几个月来，"..player.Name.."也总是在坊市中出现，送她一些她打心眼儿里喜欢的东西。\n开始她觉得许是碰巧遇到了，但这么些日子一直如此，再呆的人也明白了，她本不欲与"..player.Name.."再有往来，但"..player.Name.."话说得诚恳，她也不忍伤了"..player.Name.."的面子。\n赶巧，今日便又碰到了——“"..target.Name.."仙子，我知你喜爱那些素雅的花草，前些日子我在古书之中查到南荒之地生一种名为‘荀草’的仙草，看到时我就想，仙子一定喜欢的，这不，我赶紧给你请了来。”\n南荒距此何止万里，"..target.Name.."看着"..player.Name.."手中捧着的仙草，形质如兰，散发着浓郁的仙灵之气，枝叶青翠欲滴，“传闻荀草有姿容焕颜之效，你是想让我吃了它吗？”"..target.Name.."笑着问。\n“仙子容颜，合三界众生之美亦难及半分，何须吃它，用它来衬仙子的倾世之貌才是最好不过的了。”\n“确实不错，你有心了。”"..target.Name.."收下仙草，转身欲离去——“仙子，我……”\n"..target.Name.."听到他吞吞吐吐的劝拦，回眸，“你可知道，我是有丈夫的。”\n“我知道，可，可我……我还是喜欢你……我想和你在一起！”"..player.Name.."最终撕扯着喊出自己的心声。\n“我知道了，你小声些，跟我来吧。”\n\n"..target.Name.."家中，"..target.Name.."双手搭在"..player.Name.."赤裸的肩上，“你知道吗，在遇到你之前，我不知道什么是爱情。如今，这个世界，我感受得最深的，是你的温暖，是你炽热的心。\n“那我们再来一次？”\n“可我老公要回来了。”\n“来我家吧。”");
						target:AddModifier("XianzheCD");
						player:AddModifier("XianzheCD");
						return false;
						end
						if Dfxg == CS.XiaWorld.g_emJHNpc_Feature.Naive and player.PropertyMgr.RelationData:IsRelationShipWith("Lover",target) == true and target.PropertyMgr:CheckFeature("Pogua") ~= true then--天真处，是恋人
						self:SetTxt(""..target.Name.."不喜拘着自己在那漫漫仙途之上求索，自然畅达或是她的本心所求，故而无事时常逛逛坊市，看看那些娇艳的灵植，寻些古物和一些有趣的小玩意儿，打发打发时间。\n只是，这几个月来，"..player.Name.."也总是在坊市中出现，送她一些她打心眼儿里喜欢的东西。\n开始她觉得许是碰巧遇到了，但这么些日子一直如此，再呆的人也明白了，她本不欲与"..player.Name.."再有往来，但"..player.Name.."话说得诚恳，她也不忍伤了"..player.Name.."的面子。\n赶巧，今日便又碰到了——“仙子，我知你喜爱那些素雅的花草，前些日子我在古书之中查到南荒之地生一种名为‘荀草’的仙草，看到时我就想，仙子一定喜欢的，这不，我赶紧给你请了来。”\n南荒距此何止万里，"..target.Name.."看着"..player.Name.."手中捧着的仙草，形质如兰，散发着浓郁的仙灵之气，枝叶青翠欲滴，“传闻荀草有姿容焕颜之效，你是想让我吃了它吗？”"..target.Name.."笑着问。\n“仙子容颜，合三界众生之美亦难及半分，何须吃它，用它来衬仙子的倾世之貌才是最好不过的了。”\n“确实不错，你有心了。”"..target.Name.."收下仙草，转身欲离去——“仙子，我……”\n"..target.Name.."听到他吞吞吐吐的劝拦，回眸，“你可知道，我是有丈夫的。”\n“我知道，可，可我……我还是喜欢你……我想和你在一起！”"..player.Name.."最终撕扯着喊出自己的心声。\n“我知道了，你小声些，跟我来。”\n\n"..target.Name.."家中，"..target.Name.."拉着"..player.Name.."的手，“我之前从未爱过任何人，是你给了我温暖，你答应我，要真心待我，不能负我，不然……”\n"..player.Name.."吻上她的唇，轻啄，“我的心中永远只有你一人，天涯海角，碧落黄泉，至死相随。”\n二人拥吻，"..player.Name.."急不可耐的除着衣物。\n“"..player.Name.."，你一会儿慢一些，我……我还是处子。”\n"..player.Name.."一愣，心下万份惊喜，埋头舔弄着"..target.Name.."的私处，看到了那层小小的膜。\n“他没和你……”\n“嗯，我不喜欢他，讨厌他碰我，每次都借故推脱掉了。”\n二人怀着惊喜、激动又带有几分期待的心情共赴巫山，几度重楼，事后相约他日再诉绵缠。");
						target:AddModifier("XianzheCD");
						player:AddModifier("XianzheCD");
						return false;
						end
						if Dfxg == CS.XiaWorld.g_emJHNpc_Feature.Naive then--天真拒绝
						self:SetTxt(""..target.Name.."平素喜逛坊市，可最近出门总有一个傻小子凑近来，要么没话找话硬找她聊些什么，要么非要送她些什么东西。\n这不，出门又碰到了——“仙子，我……”\n“这位公子，你我非亲非故，我又早已嫁作他人之妇，你再这般纠缠不清，我可就要告诉我家官人了。”"..target.Name.."不再顾忌"..player.Name.."的面子，话讲的坚决，离去的也坚决。\n"..player.Name.."看着她的背影，攥着手中的花，悻悻然埋头蹲在了地上。");
						return false;
						end
						if Dfxg == CS.XiaWorld.g_emJHNpc_Feature.Apathy and Wfxg == CS.XiaWorld.g_emJHNpc_Feature.Tenacity and player.LuaHelper:GetGLevel() > target.LuaHelper:GetGLevel() and target.PropertyMgr:CheckFeature("Pogua") == true then--非处冷，男坚
						self:SetTxt(""..player.Name.."看"..target.Name.."身形窈窕、姿态妍丽，心动不已，要干得她欲仙欲死的念头一下就生了起来，胯下顿时怒龙高抬。\n"..player.Name.."毫不掩饰，“这位仙子，可愿与某共度春宵？”\n"..target.Name.."性子冷清，男女情爱之事，既不懂，也从未关心过。\n当初家中长辈只当她还未开窍，怕她嫁与人家多要吃亏，故而特以数万灵石聘了百名仙媒，着意为她寻了一家世清白、忠厚老实的修士嫁了。\n"..Spouse.Name.."婚后待她极好，她感受的到，但不知该如何表达，唯有在与"..Spouse.Name.."的夫妻生活中尽量配合了。\n可她不喜掩饰，"..Spouse.Name.."操弄时候，她是不舒服的，"..Spouse.Name.."也看得出来，可"..Spouse.Name.."不仅不怪她，还更多的照顾她的情绪。\n"..target.Name.."觉得自己亏欠丈夫许多，着实称不上一个好妻子，但那是因自己天性如此，可若是失贞，那也太对不起他了。\n\n"..target.Name.."面若冰霜，对"..player.Name.."连一个眼神都没有，错身便走了过去。\n这臭婊子，老子让你装，"..player.Name.."当着众人，只觉脸面无光，心下恼怒极了，暗施法力，在她身上留下了一道寻踪印记。\n待"..target.Name.."出城后，"..player.Name.."祭出诸般法器，不消片刻便将"..target.Name.."击败。\n“贱货，让你给老子装！”"..player.Name.."用鞋底踩着"..target.Name.."的脸颊，手握马鞭，"..target.Name.."的衣物已做褴褛状，再也包裹不住那诱人的胴体。\n"..target.Name.."不知他为何这般恼火，故而在凌辱之下，也未曾言语。\n“真当自己是仙女了？啊？”"..player.Name.."以为"..target.Name.."仍在故作高傲，心中原本泄出的怒火又蹭蹭的窜了起来。\n“就算你是仙女，在老子这儿，也得变成吃屎喝尿的狗。”"..player.Name.."掏出阳物对准"..target.Name.."的俏脸——“呲……”一边尿一边左右摇摆着阳物，觉得有趣极了。\n"..target.Name.."不懂他为什么笑，只是觉得这样很脏，无奈之下闭上了眼睛。\n"..player.Name.."并未理会，看着眼前的尿人，自在畅怀，用阳物在她脸上拍打着，“来，给爷舔干净。”\n他可能只是想出气吧，虽然不知道哪里惹到他了，但"..target.Name.."觉得这并不有损自己的清白，便问，“舔干净了就放我走吗？”\n“啊……嗯。”"..player.Name.."眼睛看向别处，应得模糊。\n"..target.Name.."以为他答应了，舔得仔细。\n“想不到你这妞还挺浪啊。”\n"..target.Name.."听不懂，只顾埋首舔着。\n“好了，爷的鸡巴也硬了，躺那儿，自己把腿掰开。”\n"..target.Name.."呆愣，"..player.Name.."看她不动，上前将她抱起，长枪直刺，尽入其中。\n……\n\n次日清晨，她披着已化作一缕缕碎布的衣衫向家中走去，身下，"..player.Name.."的阳精与自身的淫液还在流淌着。\n她远远就看到了"..Spouse.Name.."站立在大院门口，眼泪一下就流了出来，“"..Spouse.Name.."，对不起……”\n“不哭，不哭……没事了，啊。”");
						target:AddModifier("XianzheCD");
						player:AddModifier("XianzheCD");
						return false;
						end
						if Dfxg == CS.XiaWorld.g_emJHNpc_Feature.Apathy and Wfxg == CS.XiaWorld.g_emJHNpc_Feature.Greedy and player.LuaHelper:GetGLevel() > target.LuaHelper:GetGLevel() and target.PropertyMgr:CheckFeature("Pogua") == true then--非处冷，男坚
						self:SetTxt(""..player.Name.."看"..target.Name.."身形窈窕、姿态妍丽，心动不已，要干得她欲仙欲死的念头一下就生了起来，胯下顿时怒龙高抬。\n"..player.Name.."毫不掩饰，“这位仙子，可愿与某共度春宵？”\n"..target.Name.."性子冷清，男女情爱之事，既不懂，也从未关心过。\n当初家中长辈只当她还未开窍，怕她嫁与人家多要吃亏，故而特以数万灵石聘了百名仙媒，着意为她寻了一家世清白、忠厚老实的修士嫁了。\n"..Spouse.Name.."婚后待她极好，她感受的到，但不知该如何表达，唯有在与"..Spouse.Name.."的夫妻生活中尽量配合了。\n可她不喜掩饰，"..Spouse.Name.."操弄时候，她是不舒服的，"..Spouse.Name.."也看得出来，可"..Spouse.Name.."不仅不怪她，还更多的照顾她的情绪。\n"..target.Name.."觉得自己亏欠丈夫许多，着实称不上一个好妻子，但那是因自己天性如此，可若是失贞，那也太对不起他了。\n\n"..target.Name.."面若冰霜，对"..player.Name.."连一个眼神都没有，错身便走了过去。\n这臭婊子，老子让你装，"..player.Name.."当着众人，只觉脸面无光，心下恼怒极了，暗施法力，在她身上留下了一道寻踪印记。\n待"..target.Name.."出城后，"..player.Name.."祭出诸般法器，不消片刻便将"..target.Name.."击败。\n“贱货，让你给老子装！”"..player.Name.."用鞋底踩着"..target.Name.."的脸颊，手握马鞭，"..target.Name.."的衣物已做褴褛状，再也包裹不住那诱人的胴体。\n"..target.Name.."不知他为何这般恼火，故而在凌辱之下，也未曾言语。\n“真当自己是仙女了？啊？”"..player.Name.."以为"..target.Name.."仍在故作高傲，心中原本泄出的怒火又蹭蹭的窜了起来。\n“就算你是仙女，在老子这儿，也得变成吃屎喝尿的狗。”"..player.Name.."掏出阳物对准"..target.Name.."的俏脸——“呲……”一边尿一边左右摇摆着阳物，觉得有趣极了。\n"..target.Name.."不懂他为什么笑，只是觉得这样很脏，无奈之下闭上了眼睛。\n"..player.Name.."并未理会，看着眼前的尿人，自在畅怀，用阳物在她脸上拍打着，“来，给爷舔干净。”\n他可能只是想出气吧，虽然不知道哪里惹到他了，但"..target.Name.."觉得这并不有损自己的清白，便问，“舔干净了就放我走吗？”\n“啊……嗯。”"..player.Name.."眼睛看向别处，应得模糊。\n"..target.Name.."以为他答应了，舔得仔细。\n“想不到你这妞还挺浪啊。”\n"..target.Name.."听不懂，只顾埋首舔着。\n“好了，爷的鸡巴也硬了，躺那儿，自己把腿掰开。”\n"..target.Name.."呆愣，"..player.Name.."看她不动，上前将她抱起，长枪直刺，尽入其中。\n……\n\n次日清晨，她披着已化作一缕缕碎布的衣衫向家中走去，身下，"..player.Name.."的阳精与自身的淫液还在流淌着。\n她远远就看到了"..Spouse.Name.."站立在大院门口，眼泪一下就流了出来，“"..Spouse.Name.."，对不起……”\n“不哭，不哭……没事了，啊。”");
						target:AddModifier("XianzheCD");
						player:AddModifier("XianzheCD");
						return false;
						end
						if Dfxg == CS.XiaWorld.g_emJHNpc_Feature.Apathy and Wfxg == CS.XiaWorld.g_emJHNpc_Feature.Tenacity and player.LuaHelper:GetGLevel() > target.LuaHelper:GetGLevel() and target.PropertyMgr:CheckFeature("Pogua") ~= true then--处冷，男坚
						self:SetTxt(""..player.Name.."见前方走来的"..target.Name.."身形窈窕、姿态妍丽，心动不已，要干得她欲仙欲死的念头一下就生了起来，胯下顿时怒龙高抬。\n"..player.Name.."毫不掩饰，“这位仙子，可愿与某共度春宵？”\n"..target.Name.."性子冷清，男女情爱之事，既不懂，也从未关心过。\n当初家中长辈怕她吃亏，特意为她寻了一家世清白、忠厚老实的修士作为双修道侣。\n可她不喜床笫欢爱，"..Spouse.Name.."只道她还未生情愫，便对她百般怜爱，未曾强行索取过，故而"..target.Name.."至今仍是处子。\n"..target.Name.."对"..Spouse.Name.."的歉意与感激多过男女之情，她曾想过，"..Spouse.Name.."是个好人，终有一日还要把身子给他的。\n\n只是她心中对男女欢爱仍难掩厌恶，遇到此事，心下更为不悦，面若冰霜，对"..player.Name.."连一个眼神都没有，径直自他身侧走了过去。\n这臭婊子，老子让你装，"..player.Name.."当着众人，只觉脸面无光，愤恨之下，暗施法力，在她身上留下了一道寻踪印记。\n待"..target.Name.."出城后，"..player.Name.."祭出诸般法器，不消片刻便将"..target.Name.."击败。\n“贱货，让你给老子装！”"..player.Name.."用鞋底踩着"..target.Name.."的脸颊，手握马鞭，"..target.Name.."的衣物已作褴褛状，再也包裹不住那诱人的胴体。\n"..target.Name.."不知他为何这般恼火，故而在凌辱之下，也未曾言语。\n“真当自己是仙女了？啊？”"..player.Name.."以为"..target.Name.."仍在故作高傲，心中原本泄出的怒火又蹭蹭的窜了起来。\n“就算你是仙女，在老子这儿，也得变成吃屎喝尿的狗。”"..player.Name.."掏出阳物对准"..target.Name.."的俏脸——“呲……”一边尿一边左右摇摆着阳物，觉得有趣极了。\n"..target.Name.."不懂他为什么笑，只是觉得这样很脏，无奈之下闭上了眼睛。\n"..player.Name.."看着眼前的尿人，自在畅怀，用阳物在她脸上拍打着，“来，给爷舔干净。”\n他可能只是想出气吧，虽然不知道哪里惹到他了，但"..target.Name.."觉得这并不有损自己的清白，若是还能留得性命，她回去定要将身子给了"..Spouse.Name.."，最好能给他生个儿子。\n心中思定，便问，“舔干净了就放我走吗？”\n“啊……嗯。”"..player.Name.."眼睛看向别处，应得模糊。\n"..target.Name.."以为他答应了，舔得仔细。\n“想不到你这妞还挺浪啊。”\n"..target.Name.."听不懂，只顾埋首舔着。\n“好了，爷的鸡巴也硬了，躺那儿，自己把腿掰开。”\n"..target.Name.."呆愣，"..player.Name.."看她不动，上前将她抱起，长枪直刺，路途之上却感到了些许阻隔——“你……你还是个雏？”\n"..target.Name.."吃痛之下也明白发生了什么，泪水默默流下，心如死灰，直觉得还不如死了算了。\n"..player.Name.."全然不理那些，只觉得今天真是捡到宝了，心中兴奋不已，怒龙又雄壮了几分。\n"..player.Name.."的粗壮阳物在"..target.Name.."的少女嫩屄中进出操弄着，伴随淫液带出的丝丝殷红不断刺激着"..player.Name.."的神经。\n"..player.Name.."不顾"..target.Name.."初经人事，不耐伐挞，直干到了次日天明。\n"..player.Name.."高呼痛快之时，发觉"..target.Name.."竟已昏死了过去。\n……\n\n"..target.Name.."睁眼时，看到"..Spouse.Name.."守在她的榻前，眼泪一下就流了出来，情绪再难抑制，“我对不起你……对不起你，你杀了我吧……”\n"..Spouse.Name.."只是抱着她，轻轻的拍着后背，“不哭，不哭……没事了，哎，好了，没事的。”");
						player.PropertyMgr.RelationData:AddRelationShip(target,"Chunv");
						target.PropertyMgr:AddFeature("Pogua");
						target:AddModifier("XianzheCD");
						player:AddModifier("XianzheCD");
						return false;
						end
						if Dfxg == CS.XiaWorld.g_emJHNpc_Feature.Apathy and Wfxg == CS.XiaWorld.g_emJHNpc_Feature.Greedy and player.LuaHelper:GetGLevel() > target.LuaHelper:GetGLevel() and target.PropertyMgr:CheckFeature("Pogua") ~= true then--处冷，男坚
						self:SetTxt(""..player.Name.."见前方走来的"..target.Name.."身形窈窕、姿态妍丽，心动不已，要干得她欲仙欲死的念头一下就生了起来，胯下顿时怒龙高抬。\n"..player.Name.."毫不掩饰，“这位仙子，可愿与某共度春宵？”\n"..target.Name.."性子冷清，男女情爱之事，既不懂，也从未关心过。\n当初家中长辈怕她吃亏，特意为她寻了一家世清白、忠厚老实的修士作为双修道侣。\n可她不喜床笫欢爱，"..Spouse.Name.."只道她还未生情愫，便对她百般怜爱，未曾强行索取过，故而"..target.Name.."至今仍是处子。\n"..target.Name.."对"..Spouse.Name.."的歉意与感激多过男女之情，她曾想过，"..Spouse.Name.."是个好人，终有一日还要把身子给他的。\n\n只是她心中对男女欢爱仍难掩厌恶，遇到此事，心下更为不悦，面若冰霜，对"..player.Name.."连一个眼神都没有，径直自他身侧走了过去。\n这臭婊子，老子让你装，"..player.Name.."当着众人，只觉脸面无光，愤恨之下，暗施法力，在她身上留下了一道寻踪印记。\n待"..target.Name.."出城后，"..player.Name.."祭出诸般法器，不消片刻便将"..target.Name.."击败。\n“贱货，让你给老子装！”"..player.Name.."用鞋底踩着"..target.Name.."的脸颊，手握马鞭，"..target.Name.."的衣物已作褴褛状，再也包裹不住那诱人的胴体。\n"..target.Name.."不知他为何这般恼火，故而在凌辱之下，也未曾言语。\n“真当自己是仙女了？啊？”"..player.Name.."以为"..target.Name.."仍在故作高傲，心中原本泄出的怒火又蹭蹭的窜了起来。\n“就算你是仙女，在老子这儿，也得变成吃屎喝尿的狗。”"..player.Name.."掏出阳物对准"..target.Name.."的俏脸——“呲……”一边尿一边左右摇摆着阳物，觉得有趣极了。\n"..target.Name.."不懂他为什么笑，只是觉得这样很脏，无奈之下闭上了眼睛。\n"..player.Name.."看着眼前的尿人，自在畅怀，用阳物在她脸上拍打着，“来，给爷舔干净。”\n他可能只是想出气吧，虽然不知道哪里惹到他了，但"..target.Name.."觉得这并不有损自己的清白，若是还能留得性命，她回去定要将身子给了"..Spouse.Name.."，最好能给他生个儿子。\n心中思定，便问，“舔干净了就放我走吗？”\n“啊……嗯。”"..player.Name.."眼睛看向别处，应得模糊。\n"..target.Name.."以为他答应了，舔得仔细。\n“想不到你这妞还挺浪啊。”\n"..target.Name.."听不懂，只顾埋首舔着。\n“好了，爷的鸡巴也硬了，躺那儿，自己把腿掰开。”\n"..target.Name.."呆愣，"..player.Name.."看她不动，上前将她抱起，长枪直刺，路途之上却感到了些许阻隔——“你……你还是个雏？”\n"..target.Name.."吃痛之下也明白发生了什么，泪水默默流下，心如死灰，直觉得还不如死了算了。\n"..player.Name.."全然不理那些，只觉得今天真是捡到宝了，心中兴奋不已，怒龙又雄壮了几分。\n"..player.Name.."的粗壮阳物在"..target.Name.."的少女嫩屄中进出操弄着，伴随淫液带出的丝丝殷红不断刺激着"..player.Name.."的神经。\n"..player.Name.."不顾"..target.Name.."初经人事，不耐伐挞，直干到了次日天明。\n"..player.Name.."高呼痛快之时，发觉"..target.Name.."竟已昏死了过去。\n……\n\n"..target.Name.."睁眼时，看到"..Spouse.Name.."守在她的榻前，眼泪一下就流了出来，情绪再难抑制，“我对不起你……对不起你，你杀了我吧……”\n"..Spouse.Name.."只是抱着她，轻轻的拍着后背，“不哭，不哭……没事了，哎，好了，没事的。”");
						player.PropertyMgr.RelationData:AddRelationShip(target,"Chunv");
						target.PropertyMgr:AddFeature("Pogua");
						target:AddModifier("XianzheCD");
						player:AddModifier("XianzheCD");
						return false;
						end
						if Dfxg == CS.XiaWorld.g_emJHNpc_Feature.Apathy and player.PropertyMgr.RelationData:IsRelationShipWith("Lover",target) == true and target.PropertyMgr:CheckFeature("Pogua") == true then--冷漠非处恋人
						self:SetTxt(""..player.Name.."手捧一簇鲜花，鼓起勇气向"..target.Name.."表明心迹。\n"..target.Name.."有些惊讶，"..player.Name.."在修行上曾帮她许多，"..target.Name.."始终视他为良师益友，曾有结为金兰之念，不料今日听到这番言语。\n"..target.Name.."是清冷之人，向来不喜男女之事，当初家中长辈怕她吃亏，特意为她寻了一家世清白、忠厚老实的修士作为双修道侣。\n"..Spouse.Name.."婚后待她极好，可她在床笫之间着实难掩厌恶之色，二人相交多次，难得欢愉，故而自觉亏欠丈夫许多。\n"..player.Name.."也是一个好人，这些年来，他的行止她也看在眼里，至纯至善，如今能鼓起勇气向她表白，她又怎么忍心伤害他。\n可若答应了，也实在对不起丈夫。\n\n“夫人，我这一生，别无所求，你若能与我一夕之欢，我真是死也无憾了。”"..player.Name.."握着她的手，诚恳至极。\n我真是个坏女人，千错万错都是我的错，若是九天之上当真有神明看着，所有罪责都让我一人承担吧。"..target.Name.."下定决心，“说好了，就这一次，万不能让"..Spouse.Name.."知道。”\n“我晓得了。”\n……\n\n"..target.Name.."平静的躺着，暗中思索，实在不知这事儿有何欢愉，竟使得世间千万男子耽溺其中。\n"..player.Name.."在她身下卖力耕耘，速度逐渐加快——"..target.Name.."似乎想到了什么，忙道，“你可不能射进……”\n“啊……”伴随着"..player.Name.."畅快的声音，"..target.Name.."感受到了身下喷涌而入的那一股股火热。\n"..target.Name.."生气了，但在她发火之前——“对不起，我错了，夫人实在太美了，我……我没能忍住。”"..player.Name.."面露愧色，"..target.Name.."气得憋闷。\n“这样好了，夫人，我帮你舔干净，放心，一定不会有孕的。”\n“算了，那里脏……”\n……\n\n天色将暗，二人就已返回了"..target.Name.."府上，待"..Spouse.Name.."归来，三人宴乐欢笑，一切如常。");
						target:AddModifier("XianzheCD");
						player:AddModifier("XianzheCD");
						return false;
						end
						if Dfxg == CS.XiaWorld.g_emJHNpc_Feature.Apathy and player.PropertyMgr.RelationData:IsRelationShipWith("Lover",target) == true and target.PropertyMgr:CheckFeature("Pogua") ~= true then--冷漠处恋人
						self:SetTxt(""..player.Name.."手捧一簇鲜花，鼓起勇气向"..target.Name.."表明心迹。"..target.Name.."听完，心中平生了几分愧意。\n"..player.Name.."在修行上曾帮她许多，"..target.Name.."始终视他为良师益友，曾也有结为金兰之念，但今日这事，是万万不能应下的。\n"..target.Name.."是清冷之人，向来不喜男女之事，当初家中长辈怕她吃亏，特意为她寻了一家世清白、忠厚老实的修士作为双修道侣。\n婚后，"..target.Name.."不愿承欢，"..Spouse.Name.."只道她还未生情愫，便对她百般怜爱，未曾强行索取过。\n"..target.Name.."对"..Spouse.Name.."有太多的感激与歉意，故而无论怎样，也不能负他。\n"..player.Name.."看"..target.Name.."拒绝的坚决，也不再纠缠，“罢了，希望此事莫伤了我们之间的情谊。”");
						target:AddModifier("XianzheCD");
						player:AddModifier("XianzheCD");
						return false;
						end
						if Dfxg == CS.XiaWorld.g_emJHNpc_Feature.Apathy then
						self:SetTxt(""..player.Name.."看"..target.Name.."身形窈窕、姿态妍丽，心动不已，径直言道，“仙子可愿与某双修？”\n"..target.Name.."只当此人是街市寻常的浪荡子，未作理会，转身便离去了。");
						return false;
						end
						if Dfxg == CS.XiaWorld.g_emJHNpc_Feature.Tenacity and player.LuaHelper:GetGLevel() - 5 > target.LuaHelper:GetGLevel() and target.PropertyMgr:CheckFeature("Pogua") == true then--坚毅非处1
						self:SetTxt(""..player.Name.."御剑而来，飒沓似流星。\n“"..target.Name.."，你可愿与本尊双修？”\n"..target.Name.."一心向道，从未理睬过那些俗世尘埃，向来也无半分痴怨情思。\n自己与"..Spouse.Name.."结成道侣也是门派与宗族的利益需要，二人平素就连相见也是难得，与他人双修，更是从未想过。\n只是，此人是一方大能，若能与之双修，于修行也大有裨益，"..target.Name.."心下犹豫，难以抉择。\n\n“本尊精于阴阳和合之道，与本尊双修过的女子日后修行皆一日千里，本尊这里还有一粒九转金丹，亦可绵延益寿、增进修为。”\n"..target.Name.."看着真人手中的丹药，感受着他身上散发着如高山洪海一般浩然而澎湃的法力，身下渐渐湿润。\n她以极不自然的步伐走上前去，伸手去接。\n"..player.Name.."也爽快，直把丹药给了她，“脱衣服吧。”\n这里虽是城外，却也离官道不远啊，"..target.Name.."惊愕，以手臂护住衣襟。\n“慌什么，你们一起。”\n"..player.Name.."祭出一个形似床榻的法器，床榻渐渐变大，"..target.Name.."惊觉塌上竟横卧着8名裸衣女子，这八人招摇妩媚，姿态万千，修为皆在自己之上，这般修士，也甘作他的性奴吗？\n“来来来，都给本尊跪好了，把骚屄露出来，本尊今日要花开九朵。”\n"..target.Name.."略作挣扎，还是解开了衣物的扣带，将外衣缓缓褪去。\n“妹妹，你可要快些，再这样，主人可就要生气了。”\n众女奴一边言语，一边七手八脚的把"..target.Name.."的衣服除了个一干二净。\n"..target.Name.."学着她们的样子跪着，众女跪作一排，屁股高高撅起，蜜缝与菊穴全都对着"..player.Name.."彻底坦露。\n"..target.Name.."从未做过这样的姿势，与丈夫的性爱也只是躺在那里，等他一番活动后草草收场。\n这般行径，还是在野外，真是羞也羞死了。\n"..player.Name.."轻轻挥舞手掌，法力带动着空气形成微风，“跟着风向，把你们的贱屁股给本尊扭起来。”\n"..target.Name.."没想到羞耻的还在后面，众女想来不是第一次玩这种游戏了，配合纯熟，"..target.Name.."却万分僵硬，多次打乱节奏。\n"..player.Name.."将她一脚踢翻，“你这贱狗，是想挨鞭子吗？”\n"..target.Name.."看着他手中的鞭形法器，充斥着恐怖的雷霆威能，心下畏惧不已，忙爬上前去，含住"..player.Name.."的脚趾，“主人，贱狗错了，贱狗是第一次，但贱狗会用心学的，求主人饶了贱狗吧。”\n"..player.Name.."指了指自己的阳物，“不想吃鞭子也行，就罚你喝本尊的圣水吧。”\n"..target.Name.."愣神，一时不知"..player.Name.."所说圣水是何物。\n一女奴在她耳畔轻声提醒，其他女奴你一言我一语——“这哪是惩罚啊，分明是赏赐，还不谢谢主人。”“就是，主人的圣水这么宝贵，我们平时争着抢着也喝不到啊。”\n"..target.Name.."磕头道谢，含住"..player.Name.."的鸡巴，忍着心里的恶心吞下那一股股液体，饮毕，惊觉这液体清香，自身的修为竟也增进了许多，忙上前为"..player.Name.."清理，还轻轻吸了一吸。\n"..player.Name.."与九女的欢愉持续了七天七夜，结束之时"..target.Name.."发觉自身修为大涨，十年苦修也难及这七日欢好之功，她求"..player.Name.."将她也收作女奴。\n“做本尊的女奴，日后就是本尊的人了，不能再与你丈夫有情爱绵缠，你可想好了？”\n我与他本就无甚情爱，这算的什么，"..target.Name.."跪地，头埋在"..player.Name.."脚下，“想好了，愿为主人女奴，求主人恩准。”\n"..player.Name.."点头，一道咒印打在"..target.Name.."身上，小腹下方竟多了一幅直透着淫靡气息的暗红淫纹。\n“这是本尊的贞操咒印，看你那小穴口，如今只有针眼大小，唯遇本尊阳具，才会张开。”\n听到这话，"..target.Name.."心想自己日后身心都属于这般强大的主人了，不住的激动、喜悦，身下淫水潺潺，好想主人操我。\n"..player.Name.."修为增加，"..target.Name.."修为增加,"..target.Name.."成为了"..player.Name.."的女奴隶，"..target.Name.."获得贞操咒印。");
						player.PropertyMgr.RelationData:AddRelationShip(target,"Luding2");
						target:AddModifier("Zhenchaosuo");
						player.LuaHelper:AddPracticeResource("Stage",player.LuaHelper:GetGLevel() * 1000);
						target.LuaHelper:AddPracticeResource("Stage",target.LuaHelper:GetGLevel() * 2000);
						target:AddModifier("XianzheCD");
						player:AddModifier("XianzheCD");
						return false;
						end
						if Dfxg == CS.XiaWorld.g_emJHNpc_Feature.Tenacity and player.LuaHelper:GetGLevel() - 5 > target.LuaHelper:GetGLevel() and target.PropertyMgr:CheckFeature("Pogua") ~= true then--坚毅处1
						self:SetTxt(""..player.Name.."御剑而来，飒沓似流星。\n“"..target.Name.."，你可愿与本尊双修？”\n"..target.Name.."一心向道，从未理睬过那些俗世尘埃，向来也无半分痴怨情思。\n自己与"..Spouse.Name.."结成道侣也是门派与宗族的利益需要，除了婚礼当日见过一次外，再无半面之缘，就是成婚之夜，也是分席睡下的，毕竟保留处子元阴于修行大有裨益，她可不愿为了"..Spouse.Name.."这个素不相识的男人绝了自己的通天之路。\n只是，眼下这人是修行界有名的一方大能，素闻其精通坎离既济之法，与他双修过得女子如今皆修行有成，不知是真是假，"..target.Name.."一时难以取舍。\n\n“本尊知你还是处子之身，除了你的容貌，本尊看中的恰是你这般修为的元阴之精。你放心，本尊破了你的身子，也会让你从本尊这里得到更大的好处，你看——”"..player.Name.."祭出一形似床榻的法器，床榻渐渐变大，"..target.Name.."惊觉塌上竟横卧着8名裸衣女子，这八人招摇妩媚，姿态万千，修为皆在自己之上，这般修士，也甘作他的性奴吗？\n“这八人一年之前不过凡体肉胎，正是跟了本尊，才有如此修为。”\n不过做了他一年性奴便抵我数十年的苦修吗？"..target.Name.."心动。\n“被那些不懂这阴阳妙法的男子破了身子，自是阻碍修行的，但你可知，孤阴不生，独阳不长，坎离相济、阴阳和合才是天地大道，如此修行方可通天。”"..player.Name.."面容严肃，一众女奴也都跟着劝道，“这等好事，你还不赶快答应？”“是啊，主人看上你是你的福分，我们平日里摇着屁股求主人操都求不来呢。”“我和主人双修一次就突破了一个小境界呢，这样的机缘，你还想什么呢？”\n"..target.Name.."沉默片刻，点头道，“好。”\n“那就脱衣服吧，和她们跪在一起。”\n这里虽是城外，却也离官道不远啊，"..target.Name.."一下慌了神。\n“怕什么，你看她们不也一样。”"..player.Name.."指了指前方未着寸缕跪作一排的女奴们。\n“是。”"..target.Name.."横下心，学着她们的样子跪着，屁股高高撅起，蜜缝与菊穴全都对着"..player.Name.."彻底坦露。\n"..target.Name.."从未有过男女情爱，这样的姿势，还是在野外，真是羞也羞死了。\n"..player.Name.."绕着女奴们转了一圈，手掌一一拍过她们的屁股，“真不错，本尊今日便要花开九朵。”\n“母狗恳请主人临幸。”众女音调整齐,言语同时一同扭着屁股，想来不是第一次玩这种游戏了，相互之间，配合纯熟。\n“嗯，那就从你这只贱狗开始好了。”"..player.Name.."佯作思索，用脚趾捅了捅"..target.Name.."的嫩穴。\n"..target.Name.."怕元阴有失，惹得"..player.Name.."不快，身子缩了缩，一边磕头一边道，“多谢主人，求……求主人操我。”她哪里说过这种话，不过是有样学样，心中羞臊万分。\n"..player.Name.."扶着阳物，在她娇嫩、湿润的洞口不断磨蹭着，就是不肯插入，“想让我操？说点好听的。”\n"..target.Name.."身下火热，瘙痒难耐，淫水已流了一地，感受着那不断磨蹭着阴唇的雄伟阳物，求之不得最是让人骚动、疯狂，“求……求主人了，我是主人的贱狗，屄是主人的，膜是主人的，我浑身上下都是主人的玩具，主人……主人快来玩我吧。”\n"..player.Name.."觉得火候差不多了，运功缓缓插入，调和阴阳……\n"..player.Name.."与九女的欢愉持续了七天七夜，"..target.Name.."自觉十年苦修也难及这七日欢好之功，她求"..player.Name.."将她也收作女奴。\n“做本尊的女奴，往后便不能与你丈夫有情爱绵缠，你可想好了？”\n我与他本就无甚情爱，这算的什么，"..target.Name.."跪地，头埋在"..player.Name.."脚下，“想好了，愿为主人女奴，求主人恩准。”\n"..player.Name.."点头，一道咒印打在"..target.Name.."身上，小腹下方竟多了一幅直透着淫靡气息的暗红淫纹。\n“这是本尊的贞操咒印，看你那小穴口，如今只有针眼大小，唯遇本尊阳具，才会张开。”\n听到这话，"..target.Name.."心想自己日后身心都属于这般强大的主人了，不住的激动、喜悦，身下淫水潺潺，好想主人操我。\n"..player.Name.."修为大幅上涨，"..target.Name.."修为大幅上涨,"..target.Name.."成为了"..player.Name.."的女奴隶，"..target.Name.."获得贞操咒印。");
						player.PropertyMgr.RelationData:AddRelationShip(target,"Luding2");
						target:AddModifier("Zhenchaosuo");
						player.LuaHelper:AddPracticeResource("Stage",player.LuaHelper:GetGLevel() * 2000);
						target.LuaHelper:AddPracticeResource("Stage",target.LuaHelper:GetGLevel() * 4000);
						target:AddModifier("XianzheCD");
						player:AddModifier("XianzheCD");
						return false;
						end
						if Dfxg == CS.XiaWorld.g_emJHNpc_Feature.Tenacity and player.LuaHelper:GetGLevel() > target.LuaHelper:GetGLevel() and target.PropertyMgr:CheckFeature("Pogua") == true then--坚毅非处2
						self:SetTxt(""..player.Name.."看中了那名女修，虽修为一般，但容貌非常，眸若秋水，眉如远山，兼具仙家气度，似天生得玄心道骨。\n"..player.Name.."献上礼物，向"..target.Name.."表达了双修的愿望。\n"..target.Name.."一心向道，从未理睬过那些俗世尘埃，向来也无半分痴怨情思。\n自己与"..Spouse.Name.."结成道侣也是门派与宗族的利益需要，二人平素就连相见也是难得，与他人双修，更是从未想过。\n本欲直接拒绝，忽然之间却想起自己识得此人，传闻"..player.Name.."精通坎离既济之法，与他双修过得女子如今皆修行有成，只是不知是真是假。\n"..player.Name.."看"..target.Name.."犹豫，欺身上前，递上了一物，耳畔暗语，“阴阳之法，合乎天道，双修于你我修行大有裨益，我还愿献上丹霞洞天千金难求的仙丹——三清灵纹丹，此丹有固本培元之效，以助仙子成就大道之基。”\n"..target.Name.."收下丹药，道了声好，便跟着"..player.Name.."，往他的洞府而去。\n\n"..player.Name.."的洞府之中，"..target.Name.."稍有几分尴尬，她素来无心男女情爱，与丈夫之间难得的性交，不过是躺在那里应付差事，任他施为而已。\n可，可如今这般情形，又当如何？\n"..player.Name.."看出她的窘状，微笑着安抚着，“别担心，交给我就好。”\n"..player.Name.."轻咬她的耳垂，爱抚之下，缓缓褪去她身上的衣物。\n"..target.Name.."觉得耳朵痒痒的，身上也很舒服，便也不再紧张的抗拒。\n待得二人坦诚相待，"..player.Name.."伏在"..target.Name.."身下，先以舌尖轻轻挑弄着。\n"..target.Name.."从未有过这样的体验，刺激之下，身子都酥了，可又觉得害羞，“那里，那里是尿尿的地方，脏……”\n“仙子的身子，就像是昆仑山巅的雪莲，纯净无暇。”\n"..player.Name.."见她渐渐接受，便一边用手指侍弄着阴蒂，一边将舌头往更深处顶去。\n"..target.Name.."以往与"..Spouse.Name.."的性交经历，只留下疼痛与肮脏的回忆，她不知女子在情爱之中，竟能这般愉快。\n"..target.Name.."闭上双目，只觉自身在御剑飞行，直上云霄，待极乐之时，不禁叫出声来——“啊！……”潮水喷涌，射了"..player.Name.."一身，也浸湿了床榻。\n"..target.Name.."大脑空白，只觉身在天上，两腿紧闭，身子痉挛不已。待睁眼觉察到发生了何事时，血色上涌，羞臊万分，“我，我不是故意的。”\n"..player.Name.."轻轻地抱了抱她，“刚才的你，是最美的。”\n"..target.Name.."不敢看他。\n"..player.Name.."取了一件尺寸合适的玉势，缓缓插入"..target.Name.."美屄的同时，在身后舔弄着"..target.Name.."的菊穴。\n有了前面的经历，"..target.Name.."也不再压抑自己，专心感受着自己的前后两穴被"..player.Name.."以高超的技法侍弄着。\n"..player.Name.."见她欢愉的表现愈渐强烈，加快了手中抽插的速度，且伴随着玉势的抽插，"..player.Name.."的舌尖也有节奏的一次一次向她后庭的深处顶去——“啊！……啊……”潮水泛滥而不绝，一股又一股的接连喷射，"..target.Name.."此时方知，男女之事，竟是人间至乐。\n……\n二人交欢，直至天明，结束之时，"..target.Name.."后庭、小穴甚至是双乳之上，都淌着"..player.Name.."白浊的阳精。\n"..target.Name.."运起功法，发现自己的修为竟也增进了许多，欢喜之下，二人相约他日再续绵缠。\n事毕，双方修为均大量上升，"..player.Name.."看着四下散落的阴精，心满意足的眯着眼笑了笑。");
						player.LuaHelper:AddPracticeResource("Stage",player.LuaHelper:GetGLevel() * 2000);
						target.LuaHelper:AddPracticeResource("Stage",target.LuaHelper:GetGLevel() * 4000);
						target:AddModifier("XianzheCD");
						player:AddModifier("XianzheCD");
							if target.LuaHelper:GetGLevel() >9 then
							player.LuaHelper:DropAwardItem("Item_yinjin5",4);
							elseif target.LuaHelper:GetGLevel() >6 then
							player.LuaHelper:DropAwardItem("Item_yinjin4",4);
							elseif target.LuaHelper:GetGLevel() >3 then
							player.LuaHelper:DropAwardItem("Item_yinjin3",4);
							elseif target.LuaHelper:GetGLevel() >0 then
							player.LuaHelper:DropAwardItem("Item_yinjin2",4);
							else
							player.LuaHelper:DropAwardItem("Item_yinjin1",4);
							end
						return false;
						end
						if Dfxg == CS.XiaWorld.g_emJHNpc_Feature.Tenacity and player.LuaHelper:GetGLevel() > target.LuaHelper:GetGLevel() and target.PropertyMgr:CheckFeature("Pogua") ~= true then--坚毅处2
						self:SetTxt(""..player.Name.."看中了那名女修，虽修为一般，但容貌非常，眸若秋水，眉如远山，兼具仙家气度，似天生得玄心道骨。\n"..player.Name.."献上礼物，向"..target.Name.."表达了双修的愿望。\n"..target.Name.."一心向道，何曾理会过这男女痴缠，就是与丈夫的新婚之夜，也是分席而卧的，除了维持道心通明、空静玄览外，也是为了守住自身的处子元阴，此女子先天之气也，消散则于道基大有损害。\n且这人与我素未谋面，开口便是双修话语，这等轻浮浪子，真是令人生厌。\n"..target.Name.."将礼物掷回，转身便御剑远去。");
						return false;
						end
						if Dfxg == CS.XiaWorld.g_emJHNpc_Feature.Tenacity and target.PropertyMgr:CheckFeature("Pogua") == true then
						self:SetTxt(""..player.Name.."远处便见那女修气骨非凡，若能与之双修，定可修为大进。\n"..player.Name.."上前献上礼物，向"..target.Name.."表达了双修的愿望。\n"..target.Name.."一心向道，何曾理会过这男女痴缠，自己就是与"..Spouse.Name.."结成道侣，那也是门派与宗族的利益需要。\n况你这资质，又如何配得上我？\n"..target.Name.."将礼物掷回，转身便御剑远去。");
						return false;
						end
						if Dfxg == CS.XiaWorld.g_emJHNpc_Feature.Tenacity and target.PropertyMgr:CheckFeature("Pogua") ~= true then
						self:SetTxt(""..player.Name.."远处便见那女修气骨非凡，若能与之双修，定可修为大进。\n"..player.Name.."上前献上礼物，向"..target.Name.."表达了双修的愿望。\n"..target.Name.."一心向道，何曾理会过这男女痴缠，就是与丈夫的新婚之夜，也是分席而卧的，除了维持道心通明、空静玄览外，也是为了守住自身的处子元阴，此女子先天之气也，消散则于道基大有损害。\n且这人与我素未谋面，开口便是双修话语，这等轻浮浪子，真是令人生厌。\n"..target.Name.."将礼物掷回，转身便御剑远去。");
						return false;
						end
						self:SetTxt("所有判定均未成功，理论上不太可能，如果出现了当前文字，请加群上报bug，另外作者不保证修23333");
					end
					return false;
				else
					if target.Sex == CS.XiaWorld.g_emNpcSex.Male then--女男ntr
					self:SetTxt(""..target.Name.."和妻子"..Spouse.Name.."，非常美满，想来ntr的机会不算太多其实就是还没写完");
					else--女女ntr
					self:SetTxt(""..target.Name.."和丈夫"..Spouse.Name.."的婚姻非常美满，而且老娘是女的，操你妈别乱点！");
					end
					return false;
				end
			end
		end
	end--ntr判定失败开始色诱剧本
		if player.Sex == CS.XiaWorld.g_emNpcSex.Male then
			if target.Sex == CS.XiaWorld.g_emNpcSex.Male then
				if meili < 5 and target.PropertyMgr:CheckFeature("Feminization") and player.LuaHelper:GetGLevel() > target.LuaHelper:GetGLevel() then
				self:SetTxt(""..player.Name.."修行间歇越发感觉下体有股欲火熊熊，但却因相貌丑陋苦无同门师姐妹们的垂青，竟然无人愿与"..player.Name.."媾和，便想到师姐妹们的居所去顺些裘衣、裘裤、足袋、或是偷窥洗浴、练功以自行解决。没想行至半路却见那外门弟子"..target.Name.."正在弯腰处理杂务，那纤瘦的腰肢、滚圆上翘的臀线、隐隐的透出女子之态，"..player.Name.."看的竟然有些发痴。\n“"..target.Name.."、你过来。”"..target.Name.."闻声便停下手中杂务站起身来，见是内门师兄"..player.Name.."唤他便恭步迎向前来，俯身作揖。\n"..target.Name.."的修行服本就是外门的男弟子统一款式、略显宽大，"..player.Name.."目光如电，早已顺着那宽松的领口向内望去。只见"..target.Name.."那玉白的肌肤，清秀的锁骨、阳光的照射下散发出粉里透白的霞光。\n"..player.Name.."眼中淫邪之光大盛，但也只是一闪而过、随即便消失的一干二净，变得古井不波、真诚而又平和。“你在外门也有些时日了，师兄我虽然不能教你一些本门的功法，但是念在你勤劳本分、这里有一些小小的神通还是可以教于你，你可想学之一二？”\n“诺！”"..target.Name.."抬起头来，见"..player.Name.."那真诚的目光，惊喜万分，“无量天尊、承蒙师兄恩泽、师弟永世不忘。”\n“你随我来。”"..player.Name.."转身便走向附近的树林中，只是那眼中的淫邪之光如同着了火一般，火光大盛、咄咄逼人。\n"..player.Name.."与"..target.Name.."一前一后往森林深处走去，四下无人，只见"..player.Name.."猛然转身，手掐法印、口中念念有词，那眼中的淫邪之光更是毫无遮敛。\n“师兄！你……”"..target.Name.."刚想开口询问，便被"..player.Name.."用法术束缚、"..target.Name.."见"..player.Name.."眼中之火，惊慌失措、胡乱挣扎，“师兄……你……求求你饶了我吧……求求你了！”\n"..player.Name.."也不答话，任由"..target.Name.."惊恐挣扎、高声求饶。啧啧有声道“没想到呀，本门的师弟竟然还有这番姿色，妙！实在是妙！”言罢又掐起法印，"..target.Name.."进缓缓的飘了起来。\n“去！”"..player.Name.."抬起右手轻轻一点，"..target.Name.."的衣裳竟开始逐渐滑落，裸露出大片的玉白色肌肤，纤瘦的小小身躯逐渐显露出来，胸前微微有些隆起的胸肌和两点粉红看的"..player.Name.."血脉喷张，下身的肉棒高高抬起，把修行服的下摆撑起一个小小的帐篷。\n"..player.Name.."欺身压近，充满欲望的目光如烈火一般灼烧着"..target.Name.."裸露出的每一片肌肤，修长的手指划过"..target.Name.."的脸颊、锁骨、胸膛、滑进那未被目光侵蚀的地方。\n“别……”\n“嘘。”"..player.Name.."轻声打断了"..target.Name.."，同时默运功法，一股奇特的香气在两人之间弥散开来。\n这是什么香气？好像在内门师姐的居所附近闻到过，好舒服。"..target.Name.."心中疑惑，但是转眼之间"..target.Name.."便迷失在这沁人心脾的香氛中。\n"..player.Name.."嘿嘿轻笑，褪去了"..target.Name.."的衣服，雪白的胴体完全暴露在眼前，没想到不但身形像女子，就连下身也很是相似，"..target.Name.."的下身并不硕大，甚至要比普通人小很多，翘立的小肉棒竟如小指一般大小，散发出一股微骚的奶甜气息。\n"..player.Name.."不由食指大动，喉结滚动。一口含住"..target.Name.."的肉棒，吮动起来。\n"..target.Name.."的身体一阵颤抖，檀口大张，一波又一波强烈的快感冲击着全身，宛如狂海之中的一叶扁舟。\n"..player.Name.."立刻把自己剥了个精光，挺立的肉棒刺入"..target.Name.."口中，前后耸动起来，两人飘立在半空之中，抵死缠绵。\n纠缠半晌，"..target.Name.."突然浑身颤抖，双手紧紧的抱着"..player.Name.."双腿盘上"..player.Name.."的臂膀，发疯了一般套弄着"..player.Name.."的肉棒，舌头纠缠着肉棒前段的沟壑。“嗯……”"..player.Name.."舒爽的闷哼一声，下身更是猛力一挺，硕大的龟头死死的顶着"..target.Name.."的喉咙。精关大开，一股股粘稠的阳精伴着下身的挺动喷薄而出。同时，"..player.Name.."也觉得一股滚烫的液体喷入自己口中，微苦而又甘甜。喉结滚动，同时吞下彼此的精华，"..target.Name.."也因为"..player.Name.."抽出肉棒而清醒了过来。\n两人整理衣衫，"..target.Name.."眼神迷离的偎依在"..player.Name.."身旁，望着"..player.Name.."的脸庞，“师哥……我……”"..target.Name.."还未说完，"..player.Name.."便用嘴巴堵住了"..target.Name.."话语，吻毕，“我会再来找你的。”"..player.Name.."说道。！");
				player:AddModifier("XianzheCD");
				target:AddModifier("XianzheCD");
				player.PropertyMgr.RelationData:AddRelationShip(target,"Lover");
				else
				self:SetTxt(""..target.Name.."：滚！");
				end
			elseif Dfxg == CS.XiaWorld.g_emJHNpc_Feature.Greedy and player.LuaHelper:GetModifierStack("Qian") >= 100 and target.PropertyMgr:CheckFeature("Pogua") == true then
			self:SetTxt(""..player.Name.."邪魅的瞥了"..target.Name.."一眼，舔了舔嘴唇，手沿着强健优美的胸膛向下划入怀中。\n“女人，正面上我，伺候得我舒服，这些都是你的。”说罢从怀中抓出一把银钱，顺势解开了衣服，雪白的银钱撒在了"..player.Name.."古铜色的肌肤上，交相辉映的光彩晃得"..target.Name.."喘不过气，“母狗，还不滚过来？”此刻"..player.Name.."侧躺在地上银钱散落的到处都是，"..target.Name.."望着"..player.Name.."胯下硕大的鸡巴狠狠咽了咽口水，情不自禁的爬了过去，张开小嘴用力将"..player.Name.."的鸡巴含了进去，吃力的舔弄了起来，"..player.Name.."翻身踢开了她，面对"..target.Name.."不解的目光，"..player.Name.."抬起了脚送到"..target.Name.."的嘴边，"..target.Name.."迟疑了一下，还是伸出香舌，舔舐了起来。\n从鸡巴到脚再到屁眼，"..target.Name.."舔吸的力量逐渐迟缓了下来，已是春情荡漾浑身无力，于是"..player.Name.."翻身上马撕开了"..target.Name.."的衣裙，定睛一看，"..target.Name.."粉嫩的阴唇早已淫水泛滥、饥渴难耐，于是"..player.Name.."毫不犹豫、持枪而入。“啊！轻点，好大，我受不了了。”\n"..player.Name.."的大鸡巴插得"..target.Name.."欲仙欲死，原本寂静的四周充斥着"..target.Name.."淫叫。\n"..player.Name.."不管不顾大力抽插，又是几百回合下来，插得"..target.Name.."阴精狂泄、高潮迭起，见"..target.Name.."已无力再战，"..player.Name.."闷哼一声，用力一插，龟头一紧，大量滚烫的阳精灌入"..target.Name.."的子宫之中，此时的"..target.Name.."虽已是被干的头晕目眩、意乱情迷，却也没有忘记银钱，事毕之后取走了那百两纹银只留下了一句，“老板下次再找我啊！”便离开了。");
			target:AddModifier("XianzheCD");
			target:AddModifier("Qian");
			player:AddModifier("XianzheCD");
			player.PropertyMgr:FindModifier("Qian"):UpdateStack(-100);
			target.PropertyMgr:FindModifier("Qian"):UpdateStack(99);
			elseif target.PropertyMgr:CheckFeature("Pogua") == true and target.PropertyMgr:CheckFeature("WHLjinv") == true and player.LuaHelper:GetGLevel() > target.LuaHelper:GetGLevel() then
			self:SetTxt(""..player.Name.."垂涎"..target.Name.."已久，却不料"..target.Name.."居然对自己不假辞色，这着实激怒了"..player.Name.."。\n这一人"..player.Name.."拦住了"..target.Name.."再次示好却又被拒绝，怒火中烧的"..player.Name.."一个耳光将"..target.Name.."抽倒在地怒呵道：“贱人你都不是原装的了，在万花楼都接过客了，搁我这装什么清纯呢？”随后便撕扯掉对方的裤头将她按住强行奸污了。");
			target:AddModifier("NalitongCD");
			player:AddModifier("XianzheCD");
			target.PropertyMgr.RelationData:AddRelationShip(player,"PersonalEnemy");
			elseif target.PropertyMgr:CheckFeature("Pogua") == true and player.LuaHelper:GetModifierStack("YYHHGFL") ~= 0 and player.LuaHelper:GetGLevel() < target.LuaHelper:GetGLevel() then
			self:SetTxt(""..player.Name.."垂涎"..target.Name.."良久日日夜夜想的都是"..target.Name.."，奈何"..player.Name.."实力不济，最多只能每天晚上在梦里霸王硬上个机会弓。\n这日"..player.Name.."废了大代价搞来了阴阳合欢蛊的屎丸，此乃一等一的催情迷药，乘着"..target.Name.."不注意的时候，"..player.Name.."将红丸置入"..target.Name.."杯中，待其饮下药效发作欲火焚身之际，"..player.Name.."顺势将其奸污了。\n事毕，"..target.Name.."居然说什么要"..player.Name.."负责之类的胡话……");
			target:AddModifier("NalitongCD");
			player:AddModifier("XianzheCD");
			player.PropertyMgr.RelationData:AddRelationShip(target,"Lover");
			elseif target.PropertyMgr:CheckFeature("Pogua") == true and target.PropertyMgr:CheckFeature("Mugou") == true then
			self:SetTxt(""..target.Name.."被充分调教的肉体，显然低档不住任何诱惑，"..player.Name.."只是掏出肉棒"..target.Name.."变向一条恶犬扑食一般上前舔舐……！\n"..target.Name.."舔到"..player.Name.."性起，只见"..player.Name.."翻转过她的身子，便在"..target.Name.."蜜穴里狠狠抽插了起来……\n事毕，"..target.Name.."一边舔着"..player.Name.."的肉棒，一边表达着自己想给"..player.Name.."当狗的愿望。");
			player:AddModifier("XianzheCD");
			target:AddModifier("XianzheCD");
			player.PropertyMgr.RelationData:AddRelationShip(target,"Luding2");
			elseif target.PropertyMgr:CheckFeature("Pogua") == true and player.PropertyMgr.RelationData:IsRelationShipWith("Lover",target) == true then
			self:SetTxt(""..target.Name.."的房内，"..target.Name.."上身只穿一件肚兜，下身赤裸的靠在"..player.Name.."的怀中，任凭"..player.Name.."抚摸自己白皙娇嫩的肌肤。\n"..player.Name.."抚弄着"..target.Name.."的迷人躯体，说道：「仙子奶子真敏感，摸几下上面的奶头就翘起来了」微汗的"..target.Name.."被"..player.Name.."的手摸得娇喘连连，听到身后的情郎所说的话，想起被"..player.Name.."奸淫时的快感，早已被"..player.Name.."大鸡巴征服的"..target.Name.."心中一片火热，，下身蜜穴淫水潺潺流出。\n这几日"..target.Name.."的身体早被"..player.Name.."摸透，"..player.Name.."手指伸进蜜穴一勾，就精准的触碰到她最敏感的点上，还记得那点被"..player.Name.."找到后手指狂抽猛插，让她高潮迭起，淫水狂喷，丢了个大丑。\n "..target.Name.."身子一颤，原来"..player.Name.."一手进攻蜜穴的同时，大嘴不断亲吻仙子的脖颈、脸颊和小巧的耳垂。\n「嗯…啊…"..player.Name.."……干我……」\n「仙子……看棍………」说着"..player.Name.."微微下蹲，肉屌一跳一跳的摩擦着仙子的玉腿，肥大的肉屌寻找着那波光闪闪的「水帘洞」。\n"..target.Name.."一只手抓住"..player.Name.."的手揉搓的自己的娇乳，另一只手伸向胯下，抓住"..player.Name.."的大肉棒，把龟头对准从小内裤中间缝隙处露出的蜜穴，同时"..player.Name.."默契的一挺 屁股，大肉棒「滋」的一下插入"..target.Name.."小穴的深处。\n「啊……」\n 「仙子，你看我的棍法练得可好？」\n「好……好棒……你这棍法……变化多端……又力若千钧……」\n「啊…啊……好…好爽……好棒……啊……好舒服……哦……哦……好深……哦……好舒服……啊……嗯呀……快……不要停……好舒服……呜呜……」\n「来，我们换个地方继续弄。\n」说着"..player.Name.."双手扶住"..target.Name.."的芊腰，肉棒也不抽出，不停的大力抽插着。\n "..target.Name.."则双手向后扶住"..player.Name.."的臀部，生怕抽插过程中"..player.Name.."的大肉棒离开自己的身体。\n两人一边抽插一边来到旁边床榻处。\n只见"..player.Name.."把"..target.Name.."按住背靠着床榻，高高抬起"..target.Name.."的一条玉腿，略微挪动腰部，将大鸡巴对准"..target.Name.."的小穴，一口气将肉棒重新插到仙子蜜穴的深处。\n「啊……」\n「仙子，这个姿势舒服吧？」"..player.Name.."就这么一边高高抬着"..target.Name.."的玉腿，一只手大力地贴着肚兜揉搓着仙子的胸部，下身卖力地抽插着，龟头每次都深的顶到花心上，同时龟头马眼微张，不断亲吻着"..target.Name.."的花心。\n「啊…啊……好…好爽……好棒……啊……好舒服……哦……哦……好深……哦……好舒服……啊……嗯呀……快……不要停……好舒服……呜呜……」\n「啊……啊……啊……哥哥，好棒，要，要被你插穿了，我，我要飞上天了……好棒啊……啊……啊……」"..target.Name.."疯狂地摆着脑袋，沾着的姿势限制了自己下半身的动作。\n如果是躺在床上，此刻定是已经将双腿盘在"..player.Name.."的腰上，自己主动地开始随求了。\n而面前的"..player.Name.."更是不敢怠慢猛烈地抽插着身前的仙子，誓要把仙子打落凡尘。\n「啊……啊……好哥哥…你…你太棒了……昔儿是你的……下面都是你的…啊……以后…只给哥哥插…啊……哥哥…哥哥插得我好棒……要……要来了……啊……啊……」"..target.Name.."双手紧紧地抓着"..player.Name.."的肩膀，指甲甚至已经刮破了"..player.Name.."的肩膀。\n但"..player.Name.."还是专心抽插，下身的速度有增无减，仅仅一个姿势，一个单调的作，"..target.Name.."便快招架不住了。\n「好哥…哥哥……啊……啊……要……不……那……什……呀……唔……嗯……」"..target.Name.."被插得语无伦次，下身一塌糊涂的淫穴已经开始喷出水来，"..target.Name.."的身体也开始有节奏的颤动。\n "..player.Name.."知道，"..target.Name.."高潮了，而且这一波高潮来得那么亢奋，来得那么激烈，泄得"..target.Name.."身上一点力气都没有了。\n "..player.Name.."还在卖力地抽插着，丝毫不顾"..target.Name.."的身体已经软趴趴地熊抱在自己的身上。\n "..player.Name.."抽插的频率越来越快，"..target.Name.."只能放松身体，任由自己的情郎蹂躏，终于，"..player.Name.."一声长叹，停止了抽插。\n一大股一大股的精液从巨大的肉棒中冲了出来，"..target.Name.."可以明显地感觉到那股热流一下一下刺激着自己身体的最深处，犹如炸药在身体中爆炸了一样，原本刚刚高潮过的身体，在热浪的刺激下，再次被推上了高潮。\n「啊！……」"..target.Name.."喊着，下身犹如潮水倒灌一样，淫水喷了出来，水花溅的到处都是，"..player.Name.."的大腿很快就被淫水淋湿，接着是脚上、地上，一整片的淫水肆无忌惮地喷了出来。\n从未试过如此刺激的高潮，"..target.Name.."再也支撑不住，瘫软地倒下。");
			player:AddModifier("XianzheCD");
			target:AddModifier("XianzheCD");
			elseif player.LuaHelper:GetGLevel() > target.LuaHelper:GetGLevel() and target.PropertyMgr:CheckFeature("Pogua") ~= true then
			self:SetTxt(""..target.Name.."不愿意与"..player.Name.."欢好，奈何实力不济，被"..player.Name.."按倒在地，强行奸污了……");
			target:AddModifier("NalitongCD");
			player:AddModifier("XianzheCD");
			target.PropertyMgr:AddFeature("Pogua");
			target.PropertyMgr.RelationData:AddRelationShip(player,"PersonalEnemy");
			elseif player.LuaHelper:GetGLevel() > target.LuaHelper:GetGLevel() and target.PropertyMgr:CheckFeature("Pogua") == true then
			self:SetTxt(""..target.Name.."不愿意与"..player.Name.."欢好，奈何实力不济，被"..player.Name.."按倒在地，强行奸污了……");
			target:AddModifier("NalitongCD");
			player:AddModifier("XianzheCD");
			target.PropertyMgr.RelationData:AddRelationShip(player,"PersonalEnemy");
			else
			self:SetTxt(""..target.Name.."：滚！");
			end
		elseif target.Sex ~= CS.XiaWorld.g_emNpcSex.Male then
			local sj1 = world:RandomInt(1,3)
			if player.PropertyMgr.Practice.Gong.Name == ("Gong_1701_Tu") and target.PropertyMgr:CheckFeature("Pogua") ~= true and player.LuaHelper:CheckItemEquptCount("Item_Shuangtoulong") > 0 then
			self:SetTxt(""..player.Name.."向"..target.Name.."提出双修，女女之间怎么可以！"..target.Name.." 俏脸一红，不知所措。"..player.Name.." 暗催合欢秘法，一股甜腻气息笼罩二人，"..target.Name.."只觉得身体燥热难耐， 涓涓细流从大腿处流下。\n"..player.Name.."眼见时机成熟便将双头龙插入，"..target.Name.."只觉一股电流直冲脑门，下面的汁水也被挤压的四溅开来，娇躯一时便没了力气倒在"..player.Name.."身上。\n随着"..player.Name.."以合欢秘法催动的香汗不断被"..target.Name.."吸入，"..target.Name.."渐渐忘了过去，忘了作为修士的骄傲，变成一个只会渴求快感的奴隶，现在她离不开"..player.Name.."了，愿意作为女奴，一辈子侍奉她。");
			player:AddModifier("XianzheCD");
			target:AddModifier("XianzheCD");
			player.PropertyMgr:AddFeature("Baihehuakai");
			target.PropertyMgr:AddFeature("Baihehuakai");
			player.PropertyMgr.RelationData:AddRelationShip(target,"Luding2");
			elseif sj1 == 1 or target.PropertyMgr:CheckFeature("Baihehuakai") or target.PropertyMgr:CheckFeature("Mugou") then
			self:SetTxt(""..player.Name.."向"..target.Name.."提出双修，"..target.Name.." 俏脸一红，不知所措。"..player.Name.."不等"..target.Name.."回过神来玉指已然深入后者的蜜穴之中，一番挑逗"..target.Name.."感觉飘飘欲仙，云雨之后"..target.Name.."对百合有了新的理解。");
			player:AddModifier("XianzheCD");
			target:AddModifier("XianzheCD");
			player.PropertyMgr:AddFeature("Baihehuakai");
			target.PropertyMgr:AddFeature("Baihehuakai");
			else
			self:SetTxt(""..player.Name.."向"..target.Name.."提出双修，女女之间怎么可以！"..target.Name.."断然拒绝"..player.Name.."的请求。");
			end
		else
			if player.PropertyMgr:CheckFeature("BeautifulFace3") then
			JianghuMgr:AddKnowNpcData(target.JiangHuSeed,CS.XiaWorld.g_emJHNpcDataType.None,100);
			player.PropertyMgr.RelationData:AddRelationShip(target,"Luding2");
			target:AddModifier("XianzheCD");
			player:AddModifier("XianzheCD");
			if player.PropertyMgr:CheckFeature("Pogua") ~= true then
			player.PropertyMgr:AddFeature("Pogua");
			player.PropertyMgr.RelationData:AddRelationShip(target,"Chunv");
			end
			self:SetTxt("没有任何男人可能拒绝的了"..player.Name.."，"..player.Name.."对"..target.Name.."提出了性爱的要求，"..target.Name.."大喜之余化身为最卑微的公狗，四肢着地的舔舐起了"..player.Name.."玉足。\n在"..player.Name.."的面前，"..target.Name.."没有丝毫尊严的倾服于"..player.Name.."，经过"..target.Name.."努力且卑微的服侍之后，"..player.Name.."同意了"..target.Name.."成为自己的狗。");
			elseif Dfxg ~= CS.XiaWorld.g_emJHNpc_Feature.Apathy then--对方性格不是冷漠
				if meili >= random then--魅力检定，我方女角色魅力大于1~14的随机数既判定成功
					if juqing == 1 then--啪啪啪判定，双方都很愉快
					JianghuMgr:AddKnowNpcData(target.JiangHuSeed,CS.XiaWorld.g_emJHNpcDataType.None,50);
					target:AddModifier("XianzheCD");
					player:AddModifier("XianzheCD");
					self:SetTxt(""..player.Name.."尝试用自己的身体诱惑对方，只见"..player.Name.."解开罗裙之际，"..target.Name.."便迎上前来小心翼翼的捧起了"..player.Name.."玉足。\n"..target.Name.."的舌尖在"..player.Name.."足间的每一道缝隙中来回穿梭，并不时的将其含入口中细细吮吸，并顺势解开"..player.Name.."的亵裤。\n"..player.Name..":快，快放进来……人家……\n这是一场令双方均很愉快的双修。");
					elseif juqing == 2 then--啪啪啪判定，我很很愉快，对方不愉快
					JianghuMgr:AddKnowNpcData(target.JiangHuSeed,CS.XiaWorld.g_emJHNpcDataType.None,-30);
					target:AddModifier("NalitongCD");
					player:AddModifier("XianzheCD");
					self:SetTxt(""..player.Name.."尝试用自己的身体诱惑对方，见对方目色迷离，"..player.Name.."乘势而起一招观音坐莲将对方骑在身下，对方硕大的阳物让"..player.Name.."甚至忘记了自己的原本目的，只是沉迷于肉欲的快感之中，而后在激烈的肉搏战中，对方因为没有跟上"..player.Name.."扭动的速度，折伤了小兄弟，虽然自己活得的快感，但是对方显然不是很开心。");
					elseif juqing == 3 then--啪啪啪判定，我不愉快，对方愉快
					JianghuMgr:AddKnowNpcData(target.JiangHuSeed,CS.XiaWorld.g_emJHNpcDataType.None,100);
					target:AddModifier("XianzheCD");
					player:AddModifier("NalitongCD");
					self:SetTxt(""..player.Name.."尝试用自己的身体诱惑对方，没想到"..target.Name.."色心一起就管不得其他许多了，一顿猛烈到如同狂风骤雨般的冲刺，让"..player.Name.."觉得下体仿佛都快被戳烂了，随着对方一泡热力十足的阳精灌注于自己体内后，对方终于缓下的动作，就这么直挺挺的插着自己睡了过去。");
					else
					JianghuMgr:AddKnowNpcData(target.JiangHuSeed,CS.XiaWorld.g_emJHNpcDataType.None,100);
					player.PropertyMgr.RelationData:AddRelationShip(target,"Luding2");
					target:AddModifier("XianzheCD");
					player:AddModifier("XianzheCD");
					if CS.GameMain.Instance.FightMap == false then
					target.LuaHelper:SetCamp(g_emFightCamp.Player, false)
					end
					self:SetTxt(""..player.Name.."假装不经意间的走光引得"..target.Name.."色欲大起，那白玉般的足尖尚未完全从履中脱出，"..target.Name.."便迫不及待的连带着鞋履捧起了这天赐之物，跪倒在地如同舔舐牛奶的猫咪一般舔舐了起来，只听轻笑见"..player.Name.."解下罗裙，蜜穴完完全全展露与"..target.Name.."眼前，"..target.Name.."仿佛获得了万般激励，顿时化为发情的公狗，于"..player.Name.."身上驰骋了数个时辰，知道阳关大泄，此时此刻"..target.Name.."才仿佛领悟到了活着的真正意义，成为"..player.Name.."石榴裙下的俘虏之一。");
					end
					if player.PropertyMgr:CheckFeature("Pogua") ~= true then
					player.PropertyMgr:AddFeature("Pogua");
					player.PropertyMgr.RelationData:AddRelationShip(target,"Chunv");
					end
				else--丑B要有自知之明
				self:SetTxt(""..target.Name.."：丑b，滚，别靠近我！");
				target:AddModifier("XianzheCD");
				end
			else--对方性格冷漠
				if player.LuaHelper:GetGLevel() > target.LuaHelper:GetGLevel() then
					if Wfxg == CS.XiaWorld.g_emJHNpc_Feature.Greedy then--女主比对方实力强，且是贪婪性格
					player:AddModifier("XianzheCD");
					target:AddModifier("NalitongCD");
					player.PropertyMgr:AddMaxAge(5);
					target.PropertyMgr:AddMaxAge(- 10);
					player.PropertyMgr.RelationData:AddRelationShip(target,"Luding2");
					if CS.GameMain.Instance.FightMap == false then
					target.LuaHelper:SetCamp(g_emFightCamp.Player, false)
					end
						if player.PropertyMgr:CheckFeature("Pogua") ~= true then
						player.PropertyMgr:AddFeature("Pogua");
						player.PropertyMgr.RelationData:AddRelationShip(target,"Chunv");
						end
					self:SetTxt(""..target.Name.."冷着脸对"..player.Name.."说了一个“滚”字，然而这是修真界，是要凭借实力说话的地方，恼羞成怒的"..player.Name.."施展秘术定住了"..target.Name.."提裙跨坐于"..target.Name.."身上自顾自的摇摆了起来……\n"..player.Name.."榨取了整整四个时辰，直到"..target.Name.."的下体再也射不出任何精元，"..player.Name.."还是依旧没有放过"..target.Name.."。\n最终，欲火融化了坚冰，"..player.Name.."驯服了"..target.Name.."。");
					elseif Wfxg == CS.XiaWorld.g_emJHNpc_Feature.Tenacity then--女主比对方实力强，且是坚毅性格
					player:AddModifier("XianzheCD");
					target:AddModifier("NalitongCD");
						if player.PropertyMgr:CheckFeature("Pogua") ~= true then
						player.PropertyMgr:AddFeature("Pogua");
						player.PropertyMgr.RelationData:AddRelationShip(target,"Chunv");
						end
					self:SetTxt(""..target.Name.."冷着脸对"..player.Name.."说了一个“滚”字,只听一阵狂放的笑声从"..player.Name.."口中传出，只见"..player.Name.."制住"..target.Name.."后便开始把玩着对方的下体，口中还呢喃着什么“老娘想要的东西，还没有得不到的，人！也一样！”边跨身坐在了"..target.Name.."肚下三寸处开始摇摆了起来……\n事毕，"..player.Name.."提上罗裙后，还给了"..target.Name.."下体一脚嘴里嘟囔着些什么“中看不中用，银样镴枪头”之类的怪话。");
					else
					self:SetTxt(""..target.Name.."冷着脸对"..player.Name.."说了一句“滚”,显然冷漠性格的人并不吃色诱这一套。");
					end
				else
				self:SetTxt(""..target.Name.."冷着脸对"..player.Name.."说了一句“滚”,显然冷漠性格的人并不吃色诱这一套。");
				end
			end
		end
	else
	self:SetTxt("对方刚刚被干过对方休息一会把……");
	end
end