local tbTable = GameMain:GetMod("JianghuMgr");
local tbTalkAction = tbTable:GetTalkAction("Mod_shiqi");


--类会复用，如果有局部变量，记得在init里初始化
function tbTalkAction:Init()	
end

function tbTalkAction:GetName(player,target)
	return "采补";
end

function tbTalkAction:GetDesc(player,target)
	return "采补，需要学会采补功法。";
end

--按钮什么时候可见
function tbTalkAction:CheckActive(player,target)
	if player.PropertyMgr.Practice:CheckIsLearnedEsoteric("Gong1701_Esoterica_1") == false or player.LuaHelper:GetGLevel()== 0 or player.PropertyMgr.RelationData:IsRelationShipWith("Spouse",target) == true or shiqidejiance == 1 or (target.IsPlayerThing == false and target.LuaHelper:GetModifierStack("Prison_Modifier2") == 0) then--需要内门并且不是道侣
		return false;
	end
	return true;
end

--按钮什么时候可用
function tbTalkAction:CheckEnable(player,target)
	if player.PropertyMgr.Practice:CheckIsLearnedEsoteric("Gong1701_Esoterica_1") == false or player.LuaHelper:GetGLevel()== 0 or player.PropertyMgr.RelationData:IsRelationShipWith("Spouse",target) == true or shiqidejiance == 1 or (target.IsPlayerThing == false and target.LuaHelper:GetModifierStack("Prison_Modifier2") == 0) then--需要内门并且不是道侣
		return false;
	end
	return true;
end

function tbTalkAction:Action(player,target)
	local random = player.LuaHelper:RandomInt(0,100);
	local CaibuCD = target.LuaHelper:GetModifierStack("CaibuCD");
	if target.IsDeath then
	self:SetTxt(""..target.Name.."已经死了……");
	elseif target.LuaHelper:GetModifierStack("Prison_Modifier2")~= 0 then
	self:SetTxt("作为"..SchoolMgr.Name.."的囚犯"..target.Name.."自然是无法以任何理由拒绝"..SchoolMgr.Name.."弟子的，于是"..target.Name.."作为炉鼎被"..player.Name.."采补了一番。");
	target:AddModifier("CaibuCD");
	player:AddModifier("Story_Caibuzhidao1");
	player.PropertyMgr:AddMaxAge(1);
	target.PropertyMgr:AddMaxAge(- 10);
		if player.Sex == CS.XiaWorld.g_emNpcSex.Female and player.PropertyMgr:CheckFeature("Pogua")then
		player.PropertyMgr:AddFeature("Pogua");
		end
		if target.Sex == CS.XiaWorld.g_emNpcSex.Female and target.PropertyMgr:CheckFeature("Pogua")then
		target.PropertyMgr:AddFeature("Pogua");
		end
	elseif CaibuCD == 0 then
		if player.LuaHelper:GetModifierStack("Zhenchaosuo")~= 0 or player.LuaHelper:GetModifierStack("Zhenchaozhou") ~= 0 then--1带着贞操锁/咒
			if player.Sex == CS.XiaWorld.g_emNpcSex.Male and player.PropertyMgr.RelationData:IsRelationShipWith("Luding2",target) == true then--1是男，且是2的奴隶
			self:SetTxt(""..player.Name.."被"..target.Name.."的贞操锁/咒封着"..player.Name.."不能采补自己的主人");
			else
				if player.Sex ~= CS.XiaWorld.g_emNpcSex.Male and player.PropertyMgr.RelationData:IsRelationShipWith("Luding2",target) == true then--1是女，且是2的奴隶
				self:SetTxt(""..player.Name.."被"..target.Name.."的贞操锁/咒封着"..player.Name.."不能采补自己的主人");
				else
					self:SetTxt(""..player.Name.."的下体被阳锁/贞操咒封住了，并不能对对方做什么，于是转身离开了。");
				end
			end
		return false;
		end
		if target.LuaHelper:GetModifierStack("Zhenchaosuo")~= 0 or target.LuaHelper:GetModifierStack("Zhenchaozhou") ~= 0 then--2带着贞操锁/咒
			if player.Sex == CS.XiaWorld.g_emNpcSex.Male and player.PropertyMgr.RelationData:IsRelationShipWith("Luding2",target) == true then--1是男，且是2的主人
			self:SetTxt(""..player.Name.."一时性起，想要干自己的女奴"..target.Name.."一炮，他解开了贞操锁/咒，把"..target.Name.."干到不省人事后，采补了一番后心满意足的离开了。");
			target:AddModifier("CaibuCD");
			player:AddModifier("Story_Caibuzhidao1");
			player.PropertyMgr:AddMaxAge(1);
			target.PropertyMgr:AddMaxAge(- 10);
			else
				if player.Sex ~= CS.XiaWorld.g_emNpcSex.Male and player.PropertyMgr.RelationData:IsRelationShipWith("Luding2",target) == true then--1是女，且是2的主人
				self:SetTxt(""..player.Name.."一时性起，感觉下身湿润了，想要自己的公狗"..target.Name.."来干上自己一炮，他解开了贞操锁/咒，让"..target.Name.."在自己身上努力耕耘着，地自然耕不坏，但牛是会累到的。\n事毕，"..player.Name.."采补了一番后心满意足的离开了。");
				target:AddModifier("CaibuCD");
				player:AddModifier("Story_Caibuzhidao1");
				player.PropertyMgr:AddMaxAge(1);
				target.PropertyMgr:AddMaxAge(- 10);
				else
					self:SetTxt(""..player.Name.."想要采补"..target.Name.."却见对方指了指下身，"..player.Name.."定睛一看，吐了个“靠”字，便转身离去了。");
				end
			end
		return false;
		end
		if player.PropertyMgr.BodyData:PartIsBroken("Genitals") or target.PropertyMgr.BodyData:PartIsBroken("Genitals") then
			self:SetTxt("双方中有人是阴阳人的话，是不可以采补的嗷");
		else
			if player.Sex == target.Sex then
				if player.Sex == CS.XiaWorld.g_emNpcSex.Male then
					if random >= 90 then
					player.PropertyMgr:AddMaxAge(10);
					target.PropertyMgr:AddMaxAge(- 100);
					target:AddModifier("CaibuCD");
					player:AddModifier("Story_Caibuzhidao1");
					player.PropertyMgr:FindModifier("Story_Caibuzhidao1"):UpdateStack(9);
					self:SetTxt(""..player.Name.."后背贴着"..target.Name.."的前胸，菊花深深的坐在"..target.Name.."的巨根上 两个人就好像被贴在一起一样，"..player.Name.."运转合欢功法，"..target.Name.."就射了三十多次，原本结实的"..target.Name.."被"..player.Name.."吸的仿佛一个年过古稀的老人一般，头发随风脱落，下体顺着马眼不停的流出鲜红的液体。\n事毕，"..player.Name.."发现一不小心吸过头了。");
					elseif random >= 80 then
					target:AddModifier("CaibuCD");
					player:AddModifier("Story_Caibuzhidao1");
					player.PropertyMgr:AddMaxAge(1);
					target.PropertyMgr:AddMaxAge(- 10);
					self:SetTxt(""..player.Name.."将用力搓弄着"..target.Name.."的肉棒和囊袋，"..target.Name.."吃痛的浪叫，"..player.Name.."将脚往"..target.Name.."嘴里一戳，"..target.Name.."舌头不停的舔着入侵异物开始淫叫，"..target.Name.."一时精关不守，一泻千里。\n事毕，"..player.Name.."运转心法将精元吸入体内。");
					elseif random >= 60 then
					target:AddModifier("CaibuCD");
					player:AddModifier("Story_Caibuzhidao1");
					player.PropertyMgr:AddMaxAge(1);
					target.PropertyMgr:AddMaxAge(- 10);
					self:SetTxt(""..player.Name.."拔下"..target.Name.."的袜子，一阵痴迷，用自己的鼻尖在"..target.Name.."的脚心轻轻蹭弄，两只手从衣下伸进去，"..target.Name.."抱着"..player.Name.."的头使劲的在"..player.Name.."嘴里抽插起来，不一会便从"..player.Name.."的嘴里流出了乳白的液体。\n事毕，"..player.Name.."将口中的精元吞入腹中开始炼化……");
					elseif random >= 40 then
					target:AddModifier("CaibuCD");
					player:AddModifier("Story_Caibuzhidao1");
					player.PropertyMgr:AddMaxAge(1);
					target.PropertyMgr:AddMaxAge(- 10);
					self:SetTxt(""..player.Name.."把下巴支在"..target.Name.."肩膀上，对着"..target.Name.."耳边说我想吃奶，说罢便俯下身含住"..target.Name.."的阳具，又是舔又是吮吸，巨大的刺激让"..target.Name.."很快高潮来临，小哥哥出奶了，"..player.Name.."细细品尝着口中的精元……。\n事毕，"..player.Name.."将品尝完毕的精元吞入腹中开始炼化……");
					elseif random >= 5 then
					target:AddModifier("CaibuCD");
					player:AddModifier("Story_Caibuzhidao1");
					player.PropertyMgr:AddMaxAge(1);
					target.PropertyMgr:AddMaxAge(- 10);
					self:SetTxt(""..player.Name.."掐了一个御水诀，让水流变成细流从"..target.Name.."马眼注射进去，"..target.Name.."被刺激的痛苦的呻吟，慢慢的小腹隆起，脚趾都被刺激的屈了起来，在巨大的刺激下"..target.Name.."，痛苦的射出了带血的阳精。\n事毕，"..player.Name.."将"..target.Name.."射出带有丝丝精血的阳精吞入腹中炼化……");
					else
					player.PropertyMgr:AddMaxAge(10);
					target.PropertyMgr:AddMaxAge(- 100);
					target:AddModifier("CaibuCD");
					player:AddModifier("Story_Caibuzhidao1");
					player.PropertyMgr:FindModifier("Story_Caibuzhidao1"):UpdateStack(19);
					target.LuaHelper:AddDamage("Destroy","Genitals",1, "被割断……");
					self:SetTxt(""..player.Name.."看到"..target.Name.."高大威猛，阳气旺盛，顿时心生邪念，念出一段夺魄诀让"..target.Name.."陷入色念迷境幻想当中，渐渐的"..player.Name.."下身阳具慢慢挺起，马眼流出泪珠，不一会"..target.Name.."阳具越来越粗，一抖一抖，"..player.Name.."顺势赶紧用嘴接上"..target.Name.."泄出的元阳，吞入腹后，只见银光一闪，"..player.Name.."割下了"..target.Name.."的阳具放入盒中，阴阴的一笑道：这下补充阳元的丹药又有着落了，遍飘然而去。\n事毕，"..player.Name.."用"..target.Name.."的阳根混合着他的精元催使秘法炼制了一颗秘药吞服入腹……");
					end
				else
					if random >= 66 then
					target:AddModifier("CaibuCD");
					player:AddModifier("Story_Caibuzhidao1");
					player.PropertyMgr:AddMaxAge(1);
					target.PropertyMgr:AddMaxAge(- 10);
					self:SetTxt(""..player.Name.."掰开"..target.Name.."的玉腿就舔了上去，用舌尖翻开花瓣的外层，直入花心，半盏茶之后，一口接一口香甜的蜜露被吸入腹中……");
					elseif random >= 33 then
					target:AddModifier("CaibuCD");
					player:AddModifier("Story_Caibuzhidao1");
					player.PropertyMgr:AddMaxAge(1);
					target.PropertyMgr:AddMaxAge(- 10);
					self:SetTxt(""..player.Name.."一之手掐着绵软的双峰，一只手探入"..target.Name.."蜜穴之中轻轻扣弄，只感觉那蜜穴越吸越紧，"..player.Name.."猛地将手指往中心一挑，只见"..target.Name.."就这么瘫软在怀中，蜜水喷湿了整个下摆……");
					else
					target:AddModifier("CaibuCD");
					player:AddModifier("Story_Caibuzhidao1");
					player.PropertyMgr:AddMaxAge(1);
					target.PropertyMgr:AddMaxAge(- 10);
					self:SetTxt(""..player.Name.."用脚撑开对方双腿，两手用力揉搓着"..target.Name.."那丰满的双峰，只见"..target.Name.."越来越骚，"..player.Name.."把脚探入那秘洞之中，那"..target.Name.."不停扭动屁股，"..player.Name.."按着对方肩膀张开嘴运转心法对着那双峰使劲的吸，一股暖流渐入腹中。");
					end
				end
			else
				if player.LuaHelper:GetGLevel() > target.LuaHelper:GetGLevel() then
					if random >= 80 then
						self:SetTxt("虽然"..player.Name.."施展迷魂术失败了，但双方境界上的差距让对方完全无法察觉");
					else
						if player.Sex == CS.XiaWorld.g_emNpcSex.Male then
							if target.PropertyMgr:CheckFeature("Pogua") ~= true then--对方是处女
							target.PropertyMgr:AddFeature("Pogua");
							player:AddModifier("Diyidixue");
							player:AddModifier("Story_Caibuzhidao1");
							target:AddModifier("CaibuCD");
							player.PropertyMgr.RelationData:AddRelationShip(target,"Chunv");
							self:SetTxt(""..player.Name.."使用幻术迷住了"..target.Name.."后，将她按倒在地，一把撕去了"..target.Name.."的裤子，"..target.Name.."的惊呼也没让他产生半点怜悯，请出自己胯下的小兄弟，刺入了对方的蜜穴。\n"..player.Name.."的肉棒前端阻碍，不禁暗道一声“没想到"..target.Name.."竟是个处子之身，赚到了！”后，便在对方对方蜜穴中来来回回抽插了百余下，虽过程中"..target.Name.."大声哭喊呼救，但最终还是在"..player.Name.."高超的技巧下达到了高潮，"..target.Name.."那处子的精元混合着精血喷洒在了"..player.Name.."的肉棒之上。\n"..player.Name.."感觉自己的灵气和潜力均有所提升。");
							else
							target:AddModifier("CaibuCD");
							player:AddModifier("Story_Caibuzhidao1");
							player.PropertyMgr:AddMaxAge(1);
							target.PropertyMgr:AddMaxAge(- 10);
							JianghuMgr:AddKnowNpcData(target.JiangHuSeed,CS.XiaWorld.g_emJHNpcDataType.None,50);
							self:SetTxt(""..player.Name.."使用幻术迷住了"..target.Name.."后，将她按倒在地，一把撕去了"..target.Name.."的裤子，"..target.Name.."的惊呼也没让他产生半点怜悯，请出自己胯下的小兄弟，便在对方对方蜜穴中来来回回抽插了百余下，于"..target.Name.."高潮之际，掠走了对方不少精元后。\n"..player.Name.."感觉自己的灵气有所提升。");
							end
						else
							if player.PropertyMgr:CheckFeature("Pogua") ~= true then--我是处女
							player.PropertyMgr:AddFeature("Pogua");
							target:AddModifier("Diyidixue");
							target:AddModifier("CaibuCD");
							player.PropertyMgr:AddMaxAge(- 5);
							target.PropertyMgr:AddMaxAge(5);
							player.PropertyMgr.RelationData:AddRelationShip(target,"Chunv");
							self:SetTxt(""..player.Name.."刚掀起自己的裙角，"..target.Name.."便急不可待的像条公狗一样冲了上来，将自己的小兄弟插入了"..player.Name.."蜜壶中，破瓜的巨痛让"..player.Name.."心神失守，随着"..target.Name.."一阵猪突蒙进，"..target.Name.."直觉到大量的快感充斥脑海，随着一个冷战，大量的阴元喷射在对方肉棒上，这是一次失败的采补。\n"..player.Name.."感觉自己损失了不少精血。");
							else
								target:AddModifier("CaibuCD");
								player:AddModifier("Story_Caibuzhidao1");
								player.PropertyMgr:AddMaxAge(1);
								target.PropertyMgr:AddMaxAge(- 10);
								JianghuMgr:AddKnowNpcData(target.JiangHuSeed,CS.XiaWorld.g_emJHNpcDataType.None,50);
								self:SetTxt(""..player.Name.."刚掀起自己的裙角，"..target.Name.."便急不可待的像条公狗一样冲了上来，将自己的小兄弟插入了"..player.Name.."蜜壶中，随后便是一阵猪突蒙进，直到元阳不守一泄如注，大量的元阳灌注与"..player.Name.."蜜穴之中以供"..player.Name.."炼化。\n"..player.Name.."感觉自己的灵气有所提升。");
							end
						end
					end
				else
					if player.PropertyMgr:CheckFeature("BeautifulFace3") then
						target:AddModifier("CaibuCD");
						player:AddModifier("Story_Caibuzhidao1");
						player.PropertyMgr:AddMaxAge(1);
						target.PropertyMgr:AddMaxAge(- 10);
						JianghuMgr:AddKnowNpcData(target.JiangHuSeed,CS.XiaWorld.g_emJHNpcDataType.None,50);
						self:SetTxt("没有任何男人可能拒绝的了"..player.Name.."的要求，"..player.Name.."正大光明的告诉了"..target.Name.."她想要他的精元用于修炼，"..target.Name.."便跪倒在了"..player.Name.."的面前，看着"..player.Name.."那全世界为其倾倒的绝美容颜，想着其竟向自己索取阳精"..target.Name.."的针线活还没开始便已经结束，子弹便如连珠炮射而出，"..player.Name.."将"..target.Name.."的精元炼化，感觉自身的灵气有所提升。");
					elseif player.LuaHelper:GetGLevel() == target.LuaHelper:GetGLevel() then
						if random >= 50 then
							JianghuMgr:AddKnowNpcData(target.JiangHuSeed,CS.XiaWorld.g_emJHNpcDataType.None,-100);
							self:SetTxt("施展迷魂术失败后，反被对方精神力反伤，心神大损导致折寿十年。");
							player.PropertyMgr:AddMaxAge(-10);
						else
							if player.Sex == CS.XiaWorld.g_emNpcSex.Male then
								if target.PropertyMgr:CheckFeature("Pogua") ~= true then--对方是处女
								target.PropertyMgr:AddFeature("Pogua");
								player:AddModifier("Story_Caibuzhidao1");
								player:AddModifier("Diyidixue");
								target:AddModifier("CaibuCD");
								player.PropertyMgr.RelationData:AddRelationShip(target,"Chunv");
								JianghuMgr:AddKnowNpcData(target.JiangHuSeed,CS.XiaWorld.g_emJHNpcDataType.None,50);
								self:SetTxt(""..player.Name.."使用幻术迷住了"..target.Name.."后，将她按倒在地，一把撕去了"..target.Name.."的裤子，"..target.Name.."的惊呼也没让他产生半点怜悯，请出自己胯下的小兄弟，刺入了对方的蜜穴。\n"..player.Name.."的肉棒前端阻碍，不禁暗道一声“没想到"..target.Name.."竟是个处子之身，赚到了！”后，便在对方对方蜜穴中来来回回抽插了百余下，虽过程中"..target.Name.."大声哭喊呼救，但最终还是在"..player.Name.."高超的技巧下达到了高潮，"..target.Name.."那处子的精元混合着精血喷洒在了"..player.Name.."的肉棒之上。\n"..player.Name.."感觉自己的灵气和潜力均有所提升。");
								else
								target:AddModifier("CaibuCD");
								player:AddModifier("Story_Caibuzhidao1");
								player.PropertyMgr:AddMaxAge(1);
								target.PropertyMgr:AddMaxAge(- 10);
								JianghuMgr:AddKnowNpcData(target.JiangHuSeed,CS.XiaWorld.g_emJHNpcDataType.None,50);
								self:SetTxt(""..player.Name.."使用幻术迷住了"..target.Name.."后，将她按倒在地，一把撕去了"..target.Name.."的裤子，"..target.Name.."的惊呼也没让他产生半点怜悯，请出自己胯下的小兄弟，便在对方对方蜜穴中来来回回抽插了百余下，于"..target.Name.."高潮之际，掠走了对方不少精元后。\n"..player.Name.."感觉自己的灵气有所提升。");
								end
							else
								if player.PropertyMgr:CheckFeature("Pogua") ~= true then--我是处女
								player.PropertyMgr:AddFeature("Pogua");
								target:AddModifier("CaibuCD");
								target:AddModifier("Diyidixue");
								player.PropertyMgr:AddMaxAge(- 5);
								target.PropertyMgr:AddMaxAge(5);
								player.PropertyMgr.RelationData:AddRelationShip(target,"Chunv");
								JianghuMgr:AddKnowNpcData(target.JiangHuSeed,CS.XiaWorld.g_emJHNpcDataType.None,50);
								self:SetTxt(""..player.Name.."刚掀起自己的裙角，"..target.Name.."便急不可待的像条公狗一样冲了上来，将自己的小兄弟插入了"..player.Name.."蜜壶中，破瓜的巨痛让"..player.Name.."心神失守，随着"..target.Name.."一阵猪突蒙进，"..target.Name.."直觉到大量的快感充斥脑海，随着一个冷战，大量的阴元喷射在对方肉棒上，这是一次失败的采补。\n"..player.Name.."感觉自己损失了不少精血。");
								else
									target:AddModifier("CaibuCD");
									player:AddModifier("Story_Caibuzhidao1");
									player.PropertyMgr:AddMaxAge(1);
									target.PropertyMgr:AddMaxAge(- 10);
									JianghuMgr:AddKnowNpcData(target.JiangHuSeed,CS.XiaWorld.g_emJHNpcDataType.None,50);
									self:SetTxt(""..player.Name.."刚掀起自己的裙角，"..target.Name.."便急不可待的像条公狗一样冲了上来，将自己的小兄弟插入了"..player.Name.."蜜壶中，随后便是一阵猪突蒙进，直到元阳不守一泄如注，大量的元阳灌注与"..player.Name.."蜜穴之中以供"..player.Name.."炼化。\n"..player.Name.."感觉自己的灵气有所提升。");
								end
							end
						end
					else
						self:SetTxt(""..player.Name.."看了对方一眼，被对方身上强大的气势所摄，仔细想想还是不要搞事情了。");
					end
				end
			end
		end
	else
		self:SetTxt(""..target.Name.."已经被你采补过了。");
	end
end