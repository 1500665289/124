local CBS = GameMain:GetMod("CaiBuStory");
local tbEvent = GameMain:GetMod("_Event");
local win = nil;

function CBS:OnEnter()
	xlua.private_accessible(CS.Wnd_StorySelect)
	tbEvent:RegisterEvent(g_emEvent.WindowEvent,CBS.OnWindowEvent, "CaiBuStory")
end

function CBS.OnWindowEvent(e,thing,obj)
	local Window = obj[0];
	local Show = (obj[1] == 1) and true or false;
	if Window:ToString() == "Wnd_StorySelect" and Show and Window.UIInfo.m_frame.title == "采补选择" then
		win = Window;
	end
end

function CBS:GetWindow()
	return win;
end

function CBS:CaiBu(n1,n2)
local npc1 = n1;
local npc2 = n2;
world:SetRandomSeed();
local Desc = "<font color=#D06508>"
local random = npc1.LuaHelper:RandomInt(0,100);
	if npc2.IsDeath then
	Desc = Desc..""..npc2.Name.."虽然已经死亡，但"..npc1.Name.."任然从对方的尸体上夺取了最后的精元……"
	elseif npc2.LuaHelper:GetModifierStack("Prison_Modifier2")~= 0 then
	Desc = Desc.."作为"..SchoolMgr.Name.."的囚犯"..npc2.Name.."自然是无法以任何理由拒绝"..SchoolMgr.Name.."弟子的，于是"..npc2.Name.."作为炉鼎被"..npc1.Name.."采补了一番。"
	elseif true then
		if npc2.RaceDefName ~= "Human" then
			if npc2.Name == "卓十七" then
			Desc = Desc..""..npc1.Name.."：别的咱们不多哔哔，兄弟你妈没了！"
			elseif npc1.Sex == CS.XiaWorld.g_emNpcSex.Male and npc1.PropertyMgr.BodyData:PartIsBroken("Genitals") and npc2.Sex == CS.XiaWorld.g_emNpcSex.Male then--主角太监，动物公
			Desc = Desc..""..npc1.Name.."一把抓住了"..npc2.Name.."，面露淫光的"..npc1.Name.."一把握在"..npc2.Name.."生殖器上，上下撸动着……\n见"..npc2.Name.."并没有太大反应，身为太监的"..npc1.Name.."居然伏下身子，对着"..npc2.Name.."生殖器便是一阵吹拉弹唱……\n事毕，"..npc1.Name.."用嘴吸干了"..npc2.Name.."的精元、"
			elseif npc1.Sex == CS.XiaWorld.g_emNpcSex.Male and npc1.PropertyMgr.BodyData:PartIsBroken("Genitals") and npc2.Sex ~= CS.XiaWorld.g_emNpcSex.Male then--主角太监，动物母
			Desc = Desc..""..npc1.Name.."一把抓住了"..npc2.Name.."，面露淫光的"..npc1.Name.."将对方按在地上，伸出舌头舔弄着"..npc2.Name.."肉穴……\n事毕，"..npc1.Name.."用嘴吸干了"..npc2.Name.."的精元。"
			elseif npc1.Sex == CS.XiaWorld.g_emNpcSex.Male and npc2.Sex == CS.XiaWorld.g_emNpcSex.Male then--主角男，动物公
			Desc = Desc..""..npc1.Name.."一把抓住了"..npc2.Name.."，面露淫光的"..npc1.Name.."一把握在"..npc2.Name.."生殖器上，上下撸动着……\n见"..npc2.Name.."并没有太大反应，身为男性的"..npc1.Name.."居然伏下身子，对着"..npc2.Name.."生殖器便是一阵吹拉弹唱……\n事毕，"..npc1.Name.."用嘴吸干了"..npc2.Name.."的精元、"
			elseif npc1.Sex == CS.XiaWorld.g_emNpcSex.Male and npc2.Sex ~= CS.XiaWorld.g_emNpcSex.Male then--主角男，动物母
			Desc = Desc..""..npc1.Name.."一把抓住了"..npc2.Name.."，面露淫光的"..npc1.Name.."将对方按在地上，伸出舌头舔弄着"..npc2.Name.."肉穴，见"..npc2.Name.."放下戒备后，便褪下裤子露出胯下巨龙，狠狠的插入了"..npc2.Name.."的肉穴，全然不顾"..npc2.Name.."的惨叫，抽送百余下后，"..npc1.Name.."突然提速……\n事毕，"..npc1.Name.."吸干了"..npc2.Name.."的精元、"
			elseif npc1.Sex ~= CS.XiaWorld.g_emNpcSex.Male and npc2.Sex == CS.XiaWorld.g_emNpcSex.Male then--主角女，动物公
			Desc = Desc..""..npc1.Name.."露出肉穴，肉穴中散发出极度催情的气味，"..npc2.Name.."狂性大发，跨上"..npc1.Name.."的身体将肉棒插了进去……一阵狂风暴雨般的抽插后，"..npc2.Name.."将精元灌满了"..npc1.Name.."的子宫……"
			elseif npc1.Sex ~= CS.XiaWorld.g_emNpcSex.Male and npc2.Sex ~= CS.XiaWorld.g_emNpcSex.Male then--主角女，动物母
			Desc = Desc..""..npc1.Name.."一把抓住了"..npc2.Name.."，将对方按在地上，伸出舌头舔弄着"..npc2.Name.."肉穴……\n事毕，"..npc1.Name.."用嘴吸干了"..npc2.Name.."的精元。"
			else
			Desc = Desc.."如果出现这文本，请上报bug至810116969。"
			end
		return false;
		end
		if npc1.LuaHelper:GetModifierStack("Zhenchaosuo")~= 0 or npc1.LuaHelper:GetModifierStack("Zhenchaozhou") ~= 0 then--1带着贞操锁/咒
			if npc1.Sex == CS.XiaWorld.g_emNpcSex.Male and npc1.PropertyMgr.RelationData:IsRelationShipWith("Luding2",npc2) == true then--1是男，且是2的奴隶
				Desc = Desc..""..npc1.Name.."被"..npc2.Name.."的贞操锁/咒封着"..npc1.Name.."不能采补自己的主人"
			else
				if npc1.Sex ~= CS.XiaWorld.g_emNpcSex.Male and npc1.PropertyMgr.RelationData:IsRelationShipWith("Luding2",npc2) == true then--1是女，且是2的奴隶
					Desc = Desc..""..npc1.Name.."被"..npc2.Name.."的贞操锁/咒封着"..npc1.Name.."不能采补自己的主人"
				else
					Desc = Desc..""..npc1.Name.."的下体被阳锁/贞操咒封住了，并不能对对方做什么，于是转身离开了。"
				end
			end
		return false;
		end
		if npc2.LuaHelper:GetModifierStack("Zhenchaosuo")~= 0 or npc2.LuaHelper:GetModifierStack("Zhenchaozhou") ~= 0 then--2带着贞操锁/咒
			if npc1.Sex == CS.XiaWorld.g_emNpcSex.Male and npc1.PropertyMgr.RelationData:IsRelationShipWith("Luding2",npc2) == true then--1是男，且是2的主人
				Desc = Desc..""..npc1.Name.."一时性起，想要干自己的女奴"..npc2.Name.."一炮，他解开了贞操锁/咒，把"..npc2.Name.."干到不省人事后，采补了一番后心满意足的离开了。"
			else
				if npc1.Sex ~= CS.XiaWorld.g_emNpcSex.Male and npc1.PropertyMgr.RelationData:IsRelationShipWith("Luding2",npc2) == true then--1是女，且是2的主人
					Desc = Desc..""..npc1.Name.."一时性起，感觉下身湿润了，想要自己的公狗"..npc2.Name.."来干上自己一炮，他解开了贞操锁/咒，让"..npc2.Name.."在自己身上努力耕耘着，地自然耕不坏，但牛是会累到的。\n事毕，"..npc1.Name.."采补了一番后心满意足的离开了。"
				else
					Desc = Desc..""..npc1.Name.."想要采补"..npc2.Name.."却见对方指了指下身，"..npc1.Name.."定睛一看，吐了个“靠”字，便转身离去了。"
				end
			end
		return false;
		end
		if npc1.PropertyMgr.BodyData:PartIsBroken("Genitals") or npc2.PropertyMgr.BodyData:PartIsBroken("Genitals") then
			Desc = Desc.."双方中有人是阴阳人的话，是不可以采补的嗷"
		else
			if npc1.Sex == npc2.Sex then
				if npc1.Sex == CS.XiaWorld.g_emNpcSex.Male then
					if random >= 90 then
					Desc = Desc..""..npc1.Name.."后背贴着"..npc2.Name.."的前胸，菊花深深的坐在"..npc2.Name.."的巨根上 两个人就好像被贴在一起一样，"..npc1.Name.."运转合欢功法，"..npc2.Name.."就射了三十多次，原本结实的"..npc2.Name.."被"..npc1.Name.."吸的仿佛一个年过古稀的老人一般，头发随风脱落，下体顺着马眼不停的流出鲜红的液体。\n事毕，"..npc1.Name.."发现一不小心吸过头了。"
					elseif random >= 80 then
					Desc = Desc..""..npc1.Name.."将用力搓弄着"..npc2.Name.."的肉棒和囊袋，"..npc2.Name.."吃痛的浪叫，"..npc1.Name.."将脚往"..npc2.Name.."嘴里一戳，"..npc2.Name.."舌头不停的舔着入侵异物开始淫叫，"..npc2.Name.."一时精关不守，一泻千里。\n事毕，"..npc1.Name.."运转心法将精元吸入体内。"
					elseif random >= 60 then
					Desc = Desc..""..npc1.Name.."拔下"..npc2.Name.."的袜子，一阵痴迷，用自己的鼻尖在"..npc2.Name.."的脚心轻轻蹭弄，两只手从衣下伸进去，"..npc2.Name.."抱着"..npc1.Name.."的头使劲的在"..npc1.Name.."嘴里抽插起来，不一会便从"..npc1.Name.."的嘴里流出了乳白的液体。\n事毕，"..npc1.Name.."将口中的精元吞入腹中开始炼化……"
					elseif random >= 40 then
					Desc = Desc..""..npc1.Name.."把下巴支在"..npc2.Name.."肩膀上，对着"..npc2.Name.."耳边说我想吃奶，说罢便俯下身含住"..npc2.Name.."的阳具，又是舔又是吮吸，巨大的刺激让"..npc2.Name.."很快高潮来临，小哥哥出奶了，"..npc1.Name.."细细品尝着口中的精元……。\n事毕，"..npc1.Name.."将品尝完毕的精元吞入腹中开始炼化……"
					elseif random >= 5 then
					Desc = Desc..""..npc1.Name.."掐了一个御水诀，让水流变成细流从"..npc2.Name.."马眼注射进去，"..npc2.Name.."被刺激的痛苦的呻吟，慢慢的小腹隆起，脚趾都被刺激的屈了起来，在巨大的刺激下"..npc2.Name.."，痛苦的射出了带血的阳精。\n事毕，"..npc1.Name.."将"..npc2.Name.."射出带有丝丝精血的阳精吞入腹中炼化……"
					else
					npc2.LuaHelper:AddDamage("Destroy","Genitals",1, "被割断……");
					Desc = Desc..""..npc1.Name.."看到"..npc2.Name.."高大威猛，阳气旺盛，顿时心生邪念，念出一段夺魄诀让"..npc2.Name.."陷入色念迷境幻想当中，渐渐的"..npc1.Name.."下身阳具慢慢挺起，马眼流出泪珠，不一会"..npc2.Name.."阳具越来越粗，一抖一抖，"..npc1.Name.."顺势赶紧用嘴接上"..npc2.Name.."泄出的元阳，吞入腹后，只见银光一闪，"..npc1.Name.."割下了"..npc2.Name.."的阳具放入盒中，阴阴的一笑道：这下补充阳元的丹药又有着落了，遍飘然而去。\n事毕，"..npc1.Name.."用"..npc2.Name.."的阳根混合着他的精元催使秘法炼制了一颗秘药吞服入腹……"
					end
				else
					if random >= 66 then
					Desc = Desc..""..npc1.Name.."掰开"..npc2.Name.."的玉腿就舔了上去，用舌尖翻开花瓣的外层，直入花心，半盏茶之后，一口接一口香甜的蜜露被吸入腹中……"
					elseif random >= 33 then
					Desc = Desc..""..npc1.Name.."一之手掐着绵软的双峰，一只手探入"..npc2.Name.."蜜穴之中轻轻扣弄，只感觉那蜜穴越吸越紧，"..npc1.Name.."猛地将手指往中心一挑，只见"..npc2.Name.."就这么瘫软在怀中，蜜水喷湿了整个下摆……"
					else
					Desc = Desc..""..npc1.Name.."用脚撑开对方双腿，两手用力揉搓着"..npc2.Name.."那丰满的双峰，只见"..npc2.Name.."越来越骚，"..npc1.Name.."把脚探入那秘洞之中，那"..npc2.Name.."不停扭动屁股，"..npc1.Name.."按着对方肩膀张开嘴运转心法对着那双峰使劲的吸，一股暖流渐入腹中。"
					end
				end
			else
				if npc1.LuaHelper:GetGLevel() > npc2.LuaHelper:GetGLevel() then
					if random >= 100 then
						Desc = Desc.."虽然"..npc1.Name.."施展迷魂术失败了，但双方境界上的差距让对方完全无法察觉"
					else
						if npc1.Sex == CS.XiaWorld.g_emNpcSex.Male then
							if npc2.PropertyMgr:CheckFeature("Pogua") ~= true then--对方是处女
								npc1.PropertyMgr.RelationData:AddRelationShip(npc2,"Chunv");
								Desc = Desc..""..npc1.Name.."使用幻术迷住了"..npc2.Name.."后，将她按倒在地，一把撕去了"..npc2.Name.."的裤子，"..npc2.Name.."的惊呼也没让他产生半点怜悯，请出自己胯下的小兄弟，刺入了对方的蜜穴。\n"..npc1.Name.."的肉棒前端阻碍，不禁暗道一声“没想到"..npc2.Name.."竟是个处子之身，赚到了！”后，便在对方对方蜜穴中来来回回抽插了百余下，虽过程中"..npc2.Name.."大声哭喊呼救，但最终还是在"..npc1.Name.."高超的技巧下达到了高潮，"..npc2.Name.."那处子的精元混合着精血喷洒在了"..npc1.Name.."的肉棒之上。\n"..npc1.Name.."感觉自己的灵气和潜力均有所提升。"
							else
								Desc = Desc..""..npc1.Name.."使用幻术迷住了"..npc2.Name.."后，将她按倒在地，一把撕去了"..npc2.Name.."的裤子，"..npc2.Name.."的惊呼也没让他产生半点怜悯，请出自己胯下的小兄弟，便在对方对方蜜穴中来来回回抽插了百余下，于"..npc2.Name.."高潮之际，掠走了对方不少精元后。\n"..npc1.Name.."感觉自己的灵气有所提升。"
							end
						else
							if npc1.PropertyMgr:CheckFeature("Pogua") ~= true then--我是处女
								Desc = Desc..""..npc1.Name.."刚掀起自己的裙角，"..npc2.Name.."便急不可待的像条公狗一样冲了上来，将自己的小兄弟插入了"..npc1.Name.."蜜壶中，破瓜的巨痛让"..npc1.Name.."心神失守，随着"..npc2.Name.."一阵猪突蒙进，"..npc2.Name.."直觉到大量的快感充斥脑海，随着一个冷战，大量的阴元喷射在对方肉棒上，这是一次失败的采补。\n"..npc1.Name.."感觉自己损失了不少精血。"
							else
								Desc = Desc..""..npc1.Name.."刚掀起自己的裙角，"..npc2.Name.."便急不可待的像条公狗一样冲了上来，将自己的小兄弟插入了"..npc1.Name.."蜜壶中，随后便是一阵猪突蒙进，直到元阳不守一泄如注，大量的元阳灌注与"..npc1.Name.."蜜穴之中以供"..npc1.Name.."炼化。\n"..npc1.Name.."感觉自己的灵气有所提升。"
							end
						end
					end
				else
					if npc1.LuaHelper:GetGLevel() == npc2.LuaHelper:GetGLevel() then
						if random >= 100 then
							Desc = Desc.."施展迷魂术失败后，反被对方精神力反伤。"
						else
							if npc1.Sex == CS.XiaWorld.g_emNpcSex.Male then
								if npc2.PropertyMgr:CheckFeature("Pogua") ~= true then--对方是处女
									npc1.PropertyMgr.RelationData:AddRelationShip(npc2,"Chunv")
									Desc = Desc..""..npc1.Name.."使用幻术迷住了"..npc2.Name.."后，将她按倒在地，一把撕去了"..npc2.Name.."的裤子，"..npc2.Name.."的惊呼也没让他产生半点怜悯，请出自己胯下的小兄弟，刺入了对方的蜜穴。\n"..npc1.Name.."的肉棒前端阻碍，不禁暗道一声“没想到"..npc2.Name.."竟是个处子之身，赚到了！”后，便在对方对方蜜穴中来来回回抽插了百余下，虽过程中"..npc2.Name.."大声哭喊呼救，但最终还是在"..npc1.Name.."高超的技巧下达到了高潮，"..npc2.Name.."那处子的精元混合着精血喷洒在了"..npc1.Name.."的肉棒之上。\n"..npc1.Name.."感觉自己的灵气和潜力均有所提升。"
								else
									Desc = Desc..""..npc1.Name.."使用幻术迷住了"..npc2.Name.."后，将她按倒在地，一把撕去了"..npc2.Name.."的裤子，"..npc2.Name.."的惊呼也没让他产生半点怜悯，请出自己胯下的小兄弟，便在对方对方蜜穴中来来回回抽插了百余下，于"..npc2.Name.."高潮之际，掠走了对方不少精元后。\n"..npc1.Name.."感觉自己的灵气有所提升。"
								end
							else
								if npc1.PropertyMgr:CheckFeature("Pogua") ~= true then--我是处女
									npc1.PropertyMgr.RelationData:AddRelationShip(npc2,"Chunv")
									Desc = Desc..""..npc1.Name.."刚掀起自己的裙角，"..npc2.Name.."便急不可待的像条公狗一样冲了上来，将自己的小兄弟插入了"..npc1.Name.."蜜壶中，破瓜的巨痛让"..npc1.Name.."心神失守，随着"..npc2.Name.."一阵猪突蒙进，"..npc2.Name.."直觉到大量的快感充斥脑海，随着一个冷战，大量的阴元喷射在对方肉棒上，这是一次失败的采补。\n"..npc1.Name.."感觉自己损失了不少精血。"
								else
									Desc = Desc..""..npc1.Name.."刚掀起自己的裙角，"..npc2.Name.."便急不可待的像条公狗一样冲了上来，将自己的小兄弟插入了"..npc1.Name.."蜜壶中，随后便是一阵猪突蒙进，直到元阳不守一泄如注，大量的元阳灌注与"..npc1.Name.."蜜穴之中以供"..npc1.Name.."炼化。\n"..npc1.Name.."感觉自己的灵气有所提升。"
								end
							end
						end
					else
						Desc = Desc..""..npc1.Name.."看了对方一眼，被对方身上强大的气势所摄，仔细想想还是不要搞事情了。"
					end
				end
			end
		end
	else
		Desc = Desc..""..npc2.Name.."已经被你采补过了。"
	end
	Desc = Desc.."</font>"
	return Desc;
end




