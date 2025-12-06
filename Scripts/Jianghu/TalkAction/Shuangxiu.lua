local tbTable = GameMain:GetMod("JianghuMgr");
local tbTalkAction = tbTable:GetTalkAction("Mod_shuangxiu");


--类会复用，如果有局部变量，记得在init里初始化
function tbTalkAction:Init()	
end

function tbTalkAction:GetName(player,target)
	return "双修";
end

function tbTalkAction:GetDesc(player,target)
	return "通过双修来调和阴阳提升修为与参悟。";
end

--按钮什么时候可见
function tbTalkAction:CheckActive(player,target)
	if player.Sex == target.Sex or player.LuaHelper:GetGLevel() < 1 or target.LuaHelper:GetGLevel() < 1 or player.PropertyMgr.BodyData:PartIsBroken("Genitals") or target.PropertyMgr.BodyData:PartIsBroken("Genitals") then--异性且有修为且没有太监
		return false;
	end
	return true;
end

--按钮什么时候可用
function tbTalkAction:CheckEnable(player,target)
	if player.Sex == target.Sex or player.LuaHelper:GetGLevel() < 1 or target.LuaHelper:GetGLevel() < 1 or player.PropertyMgr.BodyData:PartIsBroken("Genitals") or target.PropertyMgr.BodyData:PartIsBroken("Genitals") then--异性且有修为且没有太监
		return false;
	end
	return true;
end

function tbTalkAction:Action(player,target)
	local random = player.LuaHelper:RandomInt(1,100);
	local tmeili = target.LuaHelper:GetGLevel()
	local pmeili = player.LuaHelper:GetGLevel()
	local tsCD = target.LuaHelper:GetModifierStack("ShuangxiuCD");
	local psCD = player.LuaHelper:GetModifierStack("ShuangxiuCD");
	local zCD = tsCD + psCD
	local Dfxg = CS.XiaWorld.JianghuMgr.Instance:GetJHNpcDataBySeed(target.JiangHuSeed).Feature
	if zCD == 0 then --双方双修CD判定
		if player.LuaHelper:GetModifierStack("Zhenchaosuo")~= 0 or player.LuaHelper:GetModifierStack("Zhenchaozhou") ~= 0 then--1带着贞操锁/咒
			if player.Sex == CS.XiaWorld.g_emNpcSex.Male and player.PropertyMgr.RelationData:IsRelationShipWith("Luding2",target) == true then--1是男，且是2的奴隶
			self:SetTxt(""..target.Name.."想要侍奉自己的主人，许是"..player.Name.."心情很好，她解开了贞操锁/咒，让"..player.Name.."用胯下肉棒侍奉了自己");
			target:AddModifier("XianzheCD");
			player:AddModifier("XianzheCD");
			else
				if player.Sex ~= CS.XiaWorld.g_emNpcSex.Male and player.PropertyMgr.RelationData:IsRelationShipWith("Luding1",target) == true then--1是女，且是2的奴隶
				self:SetTxt(""..target.Name.."想要侍奉自己的主人，许是"..player.Name.."心情很好，他解开了贞操锁/咒，让"..player.Name.."使用小穴侍奉了自己");
				target:AddModifier("XianzheCD");
				player:AddModifier("XianzheCD");
				else
					self:SetTxt(""..player.Name.."的下体被阳锁/贞操咒封住了，并不能对对方做什么，于是转身离开了。");
				end
			end
		return false;
		end
		if target.LuaHelper:GetModifierStack("Zhenchaosuo")~= 0 or target.LuaHelper:GetModifierStack("Zhenchaozhou") ~= 0 then--2带着贞操锁/咒
			if player.Sex == CS.XiaWorld.g_emNpcSex.Male and player.PropertyMgr.RelationData:IsRelationShipWith("Luding1",target) == true then--1是男，且是2的主人
			self:SetTxt(""..player.Name.."一时性起，想要干自己的女奴"..target.Name.."一炮，他解开了贞操锁/咒，在"..target.Name.."身上耕耘许久直到心满意足后转身离去了。");
			target:AddModifier("XianzheCD");
			player:AddModifier("XianzheCD");
			else
				if player.Sex ~= CS.XiaWorld.g_emNpcSex.Male and player.PropertyMgr.RelationData:IsRelationShipWith("Luding2",target) == true then--1是女，且是2的主人
				self:SetTxt(""..player.Name.."一时性起，感觉下身湿润了，想要自己的公狗"..target.Name.."来干上自己一炮，他解开了贞操锁/咒，"..target.Name.."用胯下肉棒侍奉了"..player.Name.."。");
				target:AddModifier("XianzheCD");
				player:AddModifier("XianzheCD");
				else
					if player.PropertyMgr.RelationData:IsRelationShipWith("Spouse",target) == true then--是夫妻，离婚
					self:SetTxt(""..player.Name.."开口向"..target.Name.."要求双修，"..target.Name.."百般推脱不成，反倒激怒了"..player.Name.."一把揽住"..target.Name.."便伸手往下探去。直到触及一硬物……\n只闻"..player.Name.."留下了一句“贱人”……\n"..player.Name.."与"..target.Name.."解除了婚姻关系。");
					player.PropertyMgr.RelationData:RemoveRelationShip(target,"Spouse");
					else--带锁拒绝
					self:SetTxt(""..target.Name.."因为下身被锁，故拒绝了双修。");
					end
				end
			end
		return false;
		end
		if player.Sex == CS.XiaWorld.g_emNpcSex.Male then--性别判定
			if player.PropertyMgr.RelationData:IsRelationShipWith("Spouse",target) == true then--是否夫妻
			target:AddModifier("Pochu");
			player:AddModifier("ShuangxiuCD");
			target:AddModifier("ShuangxiuCD");
			self:SetTxt(""..player.Name.."向"..target.Name.."提出双修的邀请，"..target.Name.."作为妻子，自然不会拒绝"..player.Name.."的要求，于是双方进行了一次和谐的双修。");
			else
				if player.PropertyMgr.RelationData:IsRelationShipWith("Luding1",target) == true then--是否主人
				player:AddModifier("ShuangxiuCD");
				target:AddModifier("ShuangxiuCD");
				self:SetTxt("对于主人的需求，身为母狗的"..target.Name.."自然是万万不敢拒绝的，于是"..target.Name.."跪伏下身子开始为她的主人服务……\n这是一次双方都很满意的双修。");
				else
					if target.LuaHelper:GetModifierStack("Pochu") == 0 then--对方是处女
						if Dfxg == CS.XiaWorld.g_emJHNpc_Feature.Tenacity then--坚毅性格，只愿意被比自己强且是金丹以上的大佬破处
							if player.LuaHelper:GetGLevel() > target.LuaHelper:GetGLevel() and player.LuaHelper:GetGLevel() > 6 then
							target:AddModifier("Pochu");
							player:AddModifier("Diyidixue");
							target:AddModifier("ShuangxiuCD");
							player:AddModifier("ShuangxiuCD");
							player.PropertyMgr.RelationData:AddRelationShip(target,"Chunv");
							self:SetTxt(""..player.Name.."向"..target.Name.."提出双修的邀请，"..target.Name.."本想拒绝，可对方那强悍的修为着实让"..target.Name.."心动不已，只听"..target.Name.."呢喃一句：“为了成就大道，这处女之身，弃了便弃了罢”。\n"..player.Name.."闻言大喜，褪下裤子露出胯下巨物，便与对方缠绵了起来……\n一番云雨过后，看着身旁滴滴落红，"..player.Name.."兴致又起再次拖着"..target.Name.."酣战了数番。");
							else
							self:SetTxt(""..target.Name.."表示自己一心修行，无心想着那些旁门左道的双修之法，所以并不愿意和"..player.Name.."双修。");
							end
						else
							if Dfxg == CS.XiaWorld.g_emJHNpc_Feature.Greedy then--贪婪性格，会被身价百万的男性草服，成为对方母狗，也原意被拥有10W以上的男修破处
								if player.LuaHelper:GetModifierStack("Qian") > 1000000 then
								target:AddModifier("Pochu");
								player:AddModifier("Diyidixue");
								target:AddModifier("ShuangxiuCD");
								player:AddModifier("ShuangxiuCD");
								player.PropertyMgr.RelationData:AddRelationShip(target,"Chunv");
								player.PropertyMgr.RelationData:AddRelationShip(target,"Luding1");
								self:SetTxt(""..player.Name.."向"..target.Name.."提出双修的邀请，没想到这种身家百万的巨富会愿意给自己开苞，不禁下身湿透意乱情迷……\n许是那财富的光环迷人眼眸，"..target.Name.."不但没有感受到破瓜之痛，反而一边挨炮一边360度无死角的跪舔着"..player.Name.."\n事毕，"..target.Name.."自甘化身母狗用舌头清理着"..player.Name.."肉棒上的污渍，并试图继续求欢，奈何"..player.Name.."却已没了兴致，一脚踹在了"..target.Name.."脸上并呵斥道：“母狗，快舔干净，我还有别的事呢。”……");
								else
									if player.LuaHelper:GetModifierStack("Qian") > 100000 then
									target:AddModifier("Pochu");
									player:AddModifier("Diyidixue");
									target:AddModifier("ShuangxiuCD");
									player:AddModifier("ShuangxiuCD");
									player.PropertyMgr.RelationData:AddRelationShip(target,"Chunv");
									self:SetTxt(""..player.Name.."向"..target.Name.."提出双修的邀请，没想到这种富甲一方的男人会愿意给自己开苞，不禁下身湿透意乱情迷……\n许是那财富的光环迷人眼眸，"..target.Name.."不但没有感受到破瓜之痛，反而越挨炮越来劲，口中淫言浪语不断……\n事毕，"..target.Name.."的蜜穴里还插着"..player.Name.."的肉棒，两人均非常满足的拥在了一起……");
									else
									self:SetTxt(""..target.Name.."嫖了一眼"..player.Name.."后，清冷的吐出了一个“滚”字。");
									end
								end
							else
								if Dfxg == CS.XiaWorld.g_emJHNpc_Feature.Naive then--天真人格，天真脑瘫无破处条件
								target:AddModifier("Pochu");
								player:AddModifier("Diyidixue");
								target:AddModifier("ShuangxiuCD");
								player:AddModifier("ShuangxiuCD");
								player.PropertyMgr.RelationData:AddRelationShip(target,"Lover");
								player.PropertyMgr.RelationData:AddRelationShip(target,"Chunv");
								self:SetTxt(""..player.Name.."向"..target.Name.."提出双修的邀请，却听"..target.Name.."拒绝道：“可人家还是处子之身”……\n"..player.Name.."闻言大喜，于花言巧语之后成功将自己的肉棒插入了对方的蜜穴，一鼓作气突破了那道关卡，"..target.Name.."惊叫了一声“好疼”却未换来"..player.Name.."任何的怜悯，"..player.Name.."自顾自的一顿猪突于蜜穴猛烈的抽插了起来……\n事毕"..target.Name.."的蜜穴里还插着"..player.Name.."的肉棒，两人均非常满足的拥在了一起……");
								else
									if Dfxg == CS.XiaWorld.g_emJHNpc_Feature.Weak then--软弱人格，只被比自己强的人强推
										if player.LuaHelper:GetGLevel() > target.LuaHelper:GetGLevel() then
										target:AddModifier("Pochu");
										player:AddModifier("Diyidixue");
										target:AddModifier("ShuangxiuCD");
										player:AddModifier("ShuangxiuCD");
										player.PropertyMgr.RelationData:AddRelationShip(target,"Chunv");
										self:SetTxt(""..player.Name.."向"..target.Name.."提出双修的邀请，却听"..target.Name.."拒绝道：“对，对，对不起，我，我还是……&还是处子之身”。\n"..player.Name.."闻言大喜凭着强悍的实力将对方压倒在地，肉棒插入了对方的蜜穴，一鼓作气突破了那道关卡，"..target.Name.."惊叫了一声“好疼”却未换来"..player.Name.."任何的怜悯，"..player.Name.."自顾自的一顿猪突于蜜穴猛烈的抽插了起来……\n事毕"..target.Name.."的蜜穴里还插着"..player.Name.."的肉棒，一个人悄悄的抹着眼泪时，只闻"..player.Name.."道“你的处是我破的，从今以后你就是我的人了，听到没！”\n"..target.Name.."含泪点头称诺……");
										else
										self:SetTxt(""..target.Name.."：“对，对，对不起，我，我还是……&还是处子之身”。\n"..target.Name.."拒绝了双修。");
										end
									else--冷漠人格，不给破处，请通过事件破处后在使用双修功能
									self:SetTxt(""..target.Name.."冷冷的看了"..player.Name.."一眼后，清冷的吐出了一个“滚字”。");
									end
								end
							end
						end
					else
						if player.LuaHelper:GetGLevel() > target.LuaHelper:GetGLevel() then--男性主角，且比对象强
							if random > 40 then--60%概率发生以下事件
							player:AddModifier("ShuangxiuCD");
							target:AddModifier("ShuangxiuCD");
							self:SetTxt(""..player.Name.."向"..target.Name.."提出双修的邀请，"..target.Name.."显然不太擅长拒绝强者的要求，毕竟在修真界与强者双修本身就是一件挺划得来的事情，对觊觎仙途的修真者们来说，所谓贞洁大不抵只是个笑话罢了\n"..target.Name.."褪下衣衫后便与"..player.Name.."搂作一团翻云覆雨了起来。\n这是一次不错的双修，双方都获得了满足。");
							else
								if random > 20 and tmeili > 8 then--对方魅力大于8有20%概率发生以下事件
								player:AddModifier("ShuangxiuCD");
								target:AddModifier("ShuangxiuCD");
								player.PropertyMgr:AddMaxAge(- 60);
								target.PropertyMgr:AddMaxAge(30);
								self:SetTxt(""..player.Name.."向"..target.Name.."提出双修的邀请，"..target.Name.."却显得不太情愿，可"..target.Name.."这等绝世容颜显然让"..player.Name.."欲火焚身难以自持了\n只见"..player.Name.."三下五除二的褪下对方衣衫，信手掏出胯下之物便如急色鬼附身一样在"..target.Name.."身上奋战了起来，"..player.Name.."的肉棒于于"..target.Name.."的蜜穴中来回冲杀，战至酣时"..player.Name.."甚至忘记了双修的本意，也管不得什么交而不泄止泄固元了。\n随着一声怒吼声，"..player.Name.."将自己滚热的阳精全部灌注于"..target.Name.."的蜜穴里。\n虽然这次双修最后还是成功了，但是这次精关失守"..player.Name.."损失了近一甲子的寿元。");
								else
									if random > 10 then--如果没有发生上面的事件，那有30%触发此事件
									player:AddModifier("ShuangxiuCD");
									target:AddModifier("NalitongCD");
									self:SetTxt(""..player.Name.."向"..target.Name.."提出双修的邀请，"..target.Name.."却显得不太情愿，然而实力的差距容不得"..target.Name.."摇头说不，只见"..player.Name.."施术摄住"..target.Name.."后便掏出肉棒不管不顾的捅进"..target.Name.."小穴之中，一阵阵猛烈的活塞运动让尚未做好准备的"..target.Name.."被干的两眼翻白几度昏死过去后又被操醒过来……\n酣畅之后，心满意足的"..player.Name.."放过了"..target.Name.."。");
									else--10%概率发生以下事件
									player:AddModifier("ShuangxiuCD");
									target:AddModifier("ShuangxiuCD");
									player.PropertyMgr.RelationData:AddRelationShip(target,"Luding1");
									self:SetTxt(""..player.Name.."刚向"..target.Name.."提出双修的邀请，"..target.Name.."就好像显得特别高兴并露出迫不及待的样子，还没等"..player.Name.."准备做些什么，"..target.Name.."便已经伸手掏出了"..player.Name.."的肉棒，一口猛的吞了进去，"..player.Name.."只觉下体被那温暖的小口含住……\n事毕，"..target.Name.."用着香舌帮着"..player.Name.."清理肉棒上的污渍，还满脸淫贱相的说着什么“主人在干我一次吧”之类的话语。");
									end
								end
							end
						else
							if player.LuaHelper:GetGLevel() < target.LuaHelper:GetGLevel() then--男主，没女目标实力强
								if pmeili > 9 then--男主魅力大于9
								player:AddModifier("ShuangxiuCD");
								target:AddModifier("ShuangxiuCD");
								player.PropertyMgr.RelationData:AddRelationShip(target,"Luding2");
								self:SetTxt(""..player.Name.."向"..target.Name.."提出双修，虽然这是一个看实力的修真世界，但是偶尔英俊的脸庞还是能起一些作用的，比如眼前的女修"..target.Name.."便是轻点足尖仿佛等待着些什么，"..player.Name.."仿佛领悟到了，伏下身子捧起对方的玉足，伸出舌头在"..target.Name.."玉足的每一寸肌肤上均舔舐了数个来回……\n精心的侍奉让"..target.Name.."感到愉悦，心情大好的"..target.Name.."甚至主动跨坐于"..player.Name.."腿上摇摆不止。\n对"..player.Name.."来说这是一次成功的双修，而对"..target.Name.."来说，则是获得了一条公狗，但至少这是各取所需不是么。");
								else
								self:SetTxt(""..player.Name.."刚向"..target.Name.."提出双修的邀请，之听"..target.Name.."口中冷清冷的吐出了一个“滚”字，便灰溜溜的离开了。");
								end
							else--男主，和女目标境界相同
							player:AddModifier("ShuangxiuCD");
							target:AddModifier("ShuangxiuCD");
							self:SetTxt(""..player.Name.."的境界与"..target.Name.."相差无几，开口提出双修对方也没有拒绝。\n这是一次成功的双修。");
							end
						end
					end
				end
			end
		else--主角为女性
			if player.PropertyMgr.RelationData:IsRelationShipWith("Spouse",target) == true then--女主，夫妻
			player:AddModifier("ShuangxiuCD");
			target:AddModifier("ShuangxiuCD");
			self:SetTxt(""..player.Name.."向"..target.Name.."提出双修的邀请，"..target.Name.."作为丈夫，自然不会拒绝"..player.Name.."的要求，于是双方进行了一次和谐的双修。");
			else
				if player.PropertyMgr.RelationData:IsRelationShipWith("Luding2",target) == true then--女主，主仆
				player:AddModifier("ShuangxiuCD");
				target:AddModifier("ShuangxiuCD");
				self:SetTxt(""..target.Name.."一听到自己的主人邀请自己双修，激动地跪倒在地匍匐在"..player.Name.."脚边做摇尾乞怜状，"..player.Name.."大喜，恩赐似的跨坐于"..target.Name.."脸上道：“乖狗狗，来舔”……\n随即双方进行了一次和谐的双修。");
				else
					if player.LuaHelper:GetModifierStack("Pochu") == 0 then--我是处女
					player:AddModifier("Pochu");
					target:AddModifier("Diyidixue");
					player:AddModifier("ShuangxiuCD");
					target:AddModifier("ShuangxiuCD");
					player.PropertyMgr.RelationData:AddRelationShip(target,"Chunv");
					self:SetTxt(""..player.Name.."向"..target.Name.."提出双修，"..target.Name.."整个人都因为狂喜而呆滞住了几秒，毕竟修真界的处子女修，就是有着这样那样的特权，"..target.Name.."完全没有想到居然有给女修士破处这样的好处会轮到自己，狂喜之余"..target.Name.."褪下裤子露出胯下巨物，伸手拖住那肉棒便向"..player.Name.."蜜穴攻去，只听"..player.Name.."惊叫连连，引得"..target.Name.."欲火更盛，只见"..target.Name.."掰过"..player.Name.."脸庞一口吻在"..player.Name.."嘴上，舌头在"..player.Name.."口中纠缠着对方的香舌……\n酣战之后，"..player.Name.."心满意足的躺在"..target.Name.."怀里……");
					else
						if Dfxg == CS.XiaWorld.g_emJHNpc_Feature.Tenacity then--女主，对方坚毅人格
							if player.LuaHelper:GetGLevel() > 6 then--女主实力大于金丹
							player:AddModifier("ShuangxiuCD");
							target:AddModifier("ShuangxiuCD");
							self:SetTxt(""..target.Name.."大打量了一眼"..player.Name.."，觉得"..player.Name.."修为还是不错的，于是"..target.Name.."接受了"..player.Name.."的双修邀请。\n随即双方进行了一次和谐的双修。");
							else
							self:SetTxt(""..target.Name.."侧目瞟了"..player.Name.."一眼道：“很抱歉，你的修为太低了，和你双修对我的修炼毫提升”\n对方拒绝与"..player.Name.."双修。");
							end
						else
							if Dfxg == CS.XiaWorld.g_emJHNpc_Feature.Greedy or Dfxg == CS.XiaWorld.g_emJHNpc_Feature.Naive or Dfxg == CS.XiaWorld.g_emJHNpc_Feature.Weak then--女主，对方贪婪天真或者软弱人格
								if player.LuaHelper:GetGLevel() > target.LuaHelper:GetGLevel() then--女主，比男目标实力强
								player.PropertyMgr.RelationData:AddRelationShip(target,"Luding2");
								target:AddModifier("ShuangxiuCD");
								player:AddModifier("ShuangxiuCD");
								self:SetTxt(""..player.Name.."向"..target.Name.."提出双修，"..target.Name.."甚至完全没想到会有此等好事发生在自己身上，居然有实力高强的女修士愿意给自己送干还外带修炼的，只要脑子没坏自是不会错过这等好事。\n这是一次成功的双修，双修结束后"..target.Name.."还久久不愿离去，腆着脸要给"..player.Name.."当狗。");
								else
									if player.LuaHelper:GetGLevel() < target.LuaHelper:GetGLevel() then--女主，没男目标实力强
									player:AddModifier("ShuangxiuCD");
									target:AddModifier("ShuangxiuCD");
									player.PropertyMgr:AddMaxAge(10);
									self:SetTxt(""..player.Name.."的境界与"..target.Name.."相差甚远，但谁让"..player.Name.."女修呢，女性在大部分时候都要更占便宜一点，"..player.Name.."刚提出双修，对方便同意了，随后便是数个时辰的疯狂，"..player.Name.."甚至感觉自己被操的快断片了，数次的昏死过去在被活活操醒，让"..player.Name.."了解到高位修士的持久力是多么“恐怖如斯”，不过这一切都是值得的，随着对方虎躯颤了那么几颤，"..player.Name.."只觉一股滚烫且极具生命活力的精元灌注进自己的身体……");
									else--女主，和男目标一样强
									player:AddModifier("ShuangxiuCD");
									target:AddModifier("ShuangxiuCD");
									self:SetTxt(""..player.Name.."的境界与"..target.Name.."相差无几，开口提出双修对方也没有拒绝。\n这是一次成功的双修。");
									end
								end
							else
								if player.LuaHelper:GetGLevel() > target.LuaHelper:GetGLevel() then--女主，比男目标实力强
									if random > 5 then
									player:AddModifier("ShuangxiuCD");
									target:AddModifier("ShuangxiuCD");
									self:SetTxt(""..player.Name.."向"..target.Name.."提出双修，"..target.Name.."只冷冷的吐出了一个：“滚！”字。\n然而修真界是讲实力的地方女神仙比你实力强，你就算在冷在傲娇，也是无用，只见"..player.Name.."轻而易举的制住了"..target.Name.."，随即便扒下裤子托着"..target.Name.."的肉棒进入自己的蜜穴……\n事毕，只听"..player.Name.."冷笑一句：“你活不错，下次本座还来找你双修。”");
									else
									player:AddModifier("ShuangxiuCD");
									target:AddModifier("ShuangxiuCD");
									player.PropertyMgr.RelationData:AddRelationShip(target,"Luding2");
									self:SetTxt(""..player.Name.."向"..target.Name.."提出双修，"..target.Name.."只冷冷的吐出了一个：“滚！”字。\n然而修真界是讲实力的地方女神仙比你实力强，你就算在冷在傲娇，也是无用，只见"..player.Name.."轻而易举的制住了"..target.Name.."，随即便扒下裤子托着"..target.Name.."的肉棒进入自己的蜜穴……\n事毕，只见"..target.Name.."乖巧的用着舌头帮"..player.Name.."清理下身，"..player.Name.."抚掌大笑道：“瞧你刚刚冷若冰霜，怎么现在却形同本座裙下公狗来着了？”。\n"..target.Name.."被"..player.Name.."收服为犬奴");
									end
								else
								self:SetTxt(""..target.Name.."：“滚！”");
								end
							end
						end
					end
				end
			end
		end
	else
		if tsCD == 0 then
		self:SetTxt(""..player.Name.."刚双修完毕，体内阴阳二气无比和谐，暂时无法双修。");
		else
		self:SetTxt(""..target.Name.."刚双修完毕，体内阴阳二气无比和谐，暂时无法双修。");
		end
	end
end