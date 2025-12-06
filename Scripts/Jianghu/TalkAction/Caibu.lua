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
	local Gongfa = player.PropertyMgr.Practice.Gong.Name
	if Gongfa ~= ("Gong_1701_Tu") or player.PropertyMgr.RelationData:IsRelationShipWith("Spouse",target) == true then--需要学会六欲心经并且不是道侣
		return false;
	end
	return true;
end

--按钮什么时候可用
function tbTalkAction:CheckEnable(player,target)
	local Gongfa = player.PropertyMgr.Practice.Gong.Name
	if Gongfa ~= ("Gong_1701_Tu") or player.PropertyMgr.RelationData:IsRelationShipWith("Spouse",target) == true then--需要学会六欲心经并且不是道侣
		return false;
	end
	return true;
end

function tbTalkAction:Action(player,target)
	local random = player.LuaHelper:RandomInt(0,100);
	local CaibuCD = target.LuaHelper:GetModifierStack("CaibuCD");
	if CaibuCD == 0 then
		if player.LuaHelper:GetModifierStack("Zhenchaosuo")~= 0 or player.LuaHelper:GetModifierStack("Zhenchaozhou") ~= 0 then--1带着贞操锁/咒
			if player.Sex == CS.XiaWorld.g_emNpcSex.Male and player.PropertyMgr.RelationData:IsRelationShipWith("Luding2",target) == true then--1是男，且是2的奴隶
			self:SetTxt(""..player.Name.."被"..target.Name.."的贞操锁/咒封着"..player.Name.."不能采补自己的主人");
			else
				if player.Sex ~= CS.XiaWorld.g_emNpcSex.Male and player.PropertyMgr.RelationData:IsRelationShipWith("Luding1",target) == true then--1是女，且是2的奴隶
				self:SetTxt(""..player.Name.."被"..target.Name.."的贞操锁/咒封着"..player.Name.."不能采补自己的主人");
				else
					self:SetTxt(""..player.Name.."的下体被阳锁/贞操咒封住了，并不能对对方做什么，于是转身离开了。");
				end
			end
		return false;
		end
		if target.LuaHelper:GetModifierStack("Zhenchaosuo")~= 0 or target.LuaHelper:GetModifierStack("Zhenchaozhou") ~= 0 then--2带着贞操锁/咒
			if player.Sex == CS.XiaWorld.g_emNpcSex.Male and player.PropertyMgr.RelationData:IsRelationShipWith("Luding1",target) == true then--1是男，且是2的主人
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
		if player.Sex == target.Sex then
			self:SetTxt(""..player.Name.."来到"..target.Name.."身前，看了一眼"..target.Name.."，思前想后我们俩是同性应该也没法采吧？");
		else
			if player.PropertyMgr.BodyData:PartIsBroken("Genitals") or target.PropertyMgr.BodyData:PartIsBroken("Genitals") then
				self:SetTxt("双方中有人是阴阳人的话，是不可以采补的嗷");
			else
				if player.LuaHelper:GetGLevel() > target.LuaHelper:GetGLevel() then
					if random >= 80 then
						self:SetTxt("虽然"..player.Name.."施展迷魂术失败了，但双方境界上的差距让对方完全无法察觉");
					else
						if player.Sex == CS.XiaWorld.g_emNpcSex.Male then
							if target.LuaHelper:GetModifierStack("Pochu") == 0 then--对方是处女
							target:AddModifier("Pochu");
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
							if player.LuaHelper:GetModifierStack("Pochu") == 0 then--我是处女
							player:AddModifier("Pochu");
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
					if player.LuaHelper:GetGLevel() == target.LuaHelper:GetGLevel() then
						if random >= 50 then
							self:SetTxt("施展迷魂术失败后，反被对方精神力反伤，心神大损导致折寿十年。");
							player.PropertyMgr:AddMaxAge(-10);
							JianghuMgr:AddKnowNpcData(target.JiangHuSeed,CS.XiaWorld.g_emJHNpcDataType.None,-100);
						else
							if player.Sex == CS.XiaWorld.g_emNpcSex.Male then
								if target.LuaHelper:GetModifierStack("Pochu") == 0 then--对方是处女
								target:AddModifier("Pochu");
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
								if player.LuaHelper:GetModifierStack("Pochu") == 0 then--我是处女
								player:AddModifier("Pochu");
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