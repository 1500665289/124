local tbTable = GameMain:GetMod("JianghuMgr");
local tbTalkAction = tbTable:GetTalkAction("Mod_daolv");


--类会复用，如果有局部变量，记得在init里初始化
function tbTalkAction:Init()	
end

function tbTalkAction:GetName(player,target)
	return "道侣";
end

function tbTalkAction:GetDesc(player,target)
	return "与对方结成道侣。";
end

--按钮什么时候可见
function tbTalkAction:CheckActive(player,target)
	if target.Camp ~= player.Camp or player.Sex == target.Sex or player.Sex ~= CS.XiaWorld.g_emNpcSex.Male or player.PropertyMgr.RelationData:IsRelationShipWith("Spouse",target) == true then--需要在一个地图的非已婚异性
		return false;
	end
	return true;
end

--按钮什么时候可用
function tbTalkAction:CheckEnable(player,target)
	if target.Camp ~= player.Camp or player.Sex == target.Sex or player.Sex ~= CS.XiaWorld.g_emNpcSex.Male or player.PropertyMgr.RelationData:IsRelationShipWith("Spouse",target) == true then--需要在一个地图的非已婚异性
		return false;
	end
	return true;
end

function tbTalkAction:Action(player,target)
	local Dfxg = CS.XiaWorld.JianghuMgr.Instance:GetJHNpcDataBySeed(target.JiangHuSeed).Feature
	if target.LuaHelper:GetModifierStack("Yihun") == 0 then
		if Dfxg == CS.XiaWorld.g_emJHNpc_Feature.Tenacity then
			if player.LuaHelper:GetGLevel() > 9 then--坚毅人格，只愿意和元婴以上强者结婚
			self:SetTxt("看到来自元婴强者的求婚"..target.Name.."感动的下半身都软了，毕竟"..target.Name.."从小的梦想就是和修真界中顶天立地的大人物结婚，于是"..target.Name.."毫不犹豫的答应了。\n"..player.Name.."与"..target.Name.."结合成了夫妻！");
			player.PropertyMgr.RelationData:AddRelationShip(target,"Spouse");
			player.PropertyMgr.RelationData:RemoveRelationShip(target,"Lover");
			target:AddModifier("Yihun");
			else
				if target.Sex == CS.XiaWorld.g_emNpcSex.Male then
				self:SetTxt(""..target.Name.."：对不起，我们不合适，我是那种宁可每天给元婴肥婆舔脚，也不愿意和练气美女相爱的男人。");
				else
				self:SetTxt(""..target.Name.."：对不起，我们不合适，我是那种宁可坐在元婴老头身边哭，也不愿意坐在练气帅哥身边笑的女人。");
				end
			end
		else
			if Dfxg == CS.XiaWorld.g_emJHNpc_Feature.Greedy then
				if player.LuaHelper:GetModifierStack("Qian") > 300000 then--贪婪人格，需要30W彩礼就可以结婚
				player:AddModifier("Qian");
				target:AddModifier("Qian");
				target:AddModifier("Yihun");
				local WDQ = player.PropertyMgr:FindModifier("Qian")
				local DDQ = target.PropertyMgr:FindModifier("Qian")
				WDQ:UpdateStack(-300001);
				DDQ:UpdateStack(299999);
				self:SetTxt("整整三十万两白银砸在了"..target.Name.."面前，只听"..player.Name.."一句：“这是聘礼！”，"..target.Name.."感觉自己激动的快要喷射了，凡间的金钱虽说对修真者没有太大的价值，可是从小喜欢亮闪闪的"..target.Name.."可管不了这些许多。\n"..player.Name.."与"..target.Name.."结合成了夫妻！");
				player.PropertyMgr.RelationData:AddRelationShip(target,"Spouse");
				player.PropertyMgr.RelationData:RemoveRelationShip(target,"Lover");
				else
					if target.Sex == CS.XiaWorld.g_emNpcSex.Male then
					self:SetTxt(""..target.Name.."：对不起，我们不合适，我是那种每天宁愿被富婆刷刷乐刷吊，也不想和美少女一起奋斗的男人。");
					else
					self:SetTxt(""..target.Name.."：对不起，我们不合适，在我眼里，没有钱的男人，连狗都不如。");
					end
				end
			else
				if Dfxg == CS.XiaWorld.g_emJHNpc_Feature.Naive then--天真人格，是情侣就可以结婚
					if player.PropertyMgr.RelationData:IsRelationShipWith("Lover",target) then
					self:SetTxt(""..player.Name.."与"..target.Name.."顺其自然的结合成了夫妻！");
					player.PropertyMgr.RelationData:AddRelationShip(target,"Spouse");
					player.PropertyMgr.RelationData:RemoveRelationShip(target,"Lover");
					target:AddModifier("Yihun");
					else
					self:SetTxt(""..target.Name.."：我们还没确定情侣关系，直接求婚是不是发展的太快了一些。");
					end
				else
					if Dfxg == CS.XiaWorld.g_emJHNpc_Feature.Weak then--软弱人格，主角比对方强就可以结婚
						if player.LuaHelper:GetGLevel() > target.LuaHelper:GetGLevel() then
						self:SetTxt(""..player.Name.."将"..target.Name.."拦住，板着脸认真的说：“和我结婚，听到了没有？”\n"..target.Name.."被吓住就不小心答应并与"..player.Name.."结婚了。");
						player.PropertyMgr.RelationData:AddRelationShip(target,"Spouse");
						player.PropertyMgr.RelationData:RemoveRelationShip(target,"Lover");
						target:AddModifier("Yihun");
						else
						self:SetTxt(""..target.Name.."：对不起，我不喜欢你。");
						end
					else
						if player.PropertyMgr.RelationData:IsRelationShipWith("Luding1",target) and player.Sex == CS.XiaWorld.g_emNpcSex.Male then--主角男，对方是你的狗
						self:SetTxt(""..player.Name.."一脚踹在了"..target.Name.."脸上，并吩咐道：“母狗，老子想娶你了。”\n"..target.Name.."“汪，是的，我的主人，嫁给你是我的荣幸。”\n"..player.Name.."与"..target.Name.."结合成了夫妻！");
						player.PropertyMgr.RelationData:AddRelationShip(target,"Spouse");
						player.PropertyMgr.RelationData:RemoveRelationShip(target,"Lover");
						player.PropertyMgr.RelationData:RemoveRelationShip(target,"Luding1");
						target:AddModifier("Yihun");
						else
							if player.PropertyMgr.RelationData:IsRelationShipWith("Luding2",target) and player.Sex ~= CS.XiaWorld.g_emNpcSex.Male then--主角女，对方是你的狗
							self:SetTxt(""..player.Name.."坐在"..target.Name.."脸上不时还用脚踩着"..player.Name.."的肉棒，并吩咐道：“狗狗，女王想嫁给你了。”\n"..target.Name.."“汪，是的，我的主人，娶你是我的毕生的梦想。”\n"..player.Name.."与"..target.Name.."结合成了夫妻！");
							player.PropertyMgr.RelationData:AddRelationShip(target,"Spouse");
							player.PropertyMgr.RelationData:RemoveRelationShip(target,"Lover");
							player.PropertyMgr.RelationData:RemoveRelationShip(target,"Luding2");
							target:AddModifier("Yihun");
							else
							self:SetTxt(""..target.Name.."：滚！");
							end
						end
					end
				end
			end
		end
	else
	self:SetTxt(""..target.Name.."看到"..player.Name.."向自己求婚的行为，气的浑身发抖，大热天的全身发冷手脚冰凉，这个修仙界还能不能好了，我们女孩子难道在你们男人眼里就是人尽可夫的婊子么，想到此时眼泪不禁夺眶而出嘶吼着什么：“到底要怎么样你们才能满意，这个世界充斥着对女性的压迫，女性到底何时才能真正的站起了！”反正不管别怎么想，至少"..target.Name.."绝对不会接受，成为多个男性的妻子，古老的一妻多夫制度，是对女性的侮辱和不尊重，女孩子明明就应该是香香的，纯洁的，晶莹剔透如水晶一般的！\n\n身为微博派女拳大师，精通古武的作者十七：“自20200205起，落后邪恶而又不女拳的一妻多夫制度，就要从本mod消失了！至于为什么男性可以一夫多妻……因为牛累不累死本女拳拳法家完全不在乎，反正地不能耕坏！爱护地球环境从你我做起。”");
	end
end