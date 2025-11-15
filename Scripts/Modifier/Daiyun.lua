local tbTable = GameMain:GetMod("_ModifierScript");
local tbModifier = tbTable:GetModifier("Daiyun");

function tbModifier:Leave(modifier, npc)
world:ShowStoryBox("代孕七个月后，爽仙子居然和她的仙侣闹崩派下天将要求"..npc.Name.."打掉孩子，虽然腹中的孩子不是"..npc.Name.."的儿女，但这七个月的血脉交融让"..npc.Name.."觉得不该如此，毕竟七个月大的孩子，已经有了感知世界的能力。\n\n"..npc.Name.."的拒绝让爽仙子极其恼怒的留下了：“他妈的烦死了，七个月的孩子代孕女修就不愿意打掉，伤阴德个屁啊。老娘都是神仙了！”、“在不带打掉我就派我天娱殿的保安，呸，天兵天将来杀你全家……”等等言论？\n\n在爽仙子的百般威胁下，"..npc.Name.."终于决定了不拖累所有人，把这个孩子打了，却不想爽仙子的前道侣恒仙尊找上了门来表示：“我最近跟爽仙子闹离婚，这个孩子是个不错的把柄，可以重拳出击爽仙子，来来来你跟我走，我保你平安……”","代孕",{"打掉孩子","跟恒仙尊离开"},
	function(key)
		if key == 0 then
		return ""..npc.Name.."打掉了孩子！"
		end
		if key == 1 then
			renshu = world:RandomInt(10,40);
			while renshu > 0 do
				local npc1 = CS.XiaWorld.NpcRandomMechine.RandomNpc(npc.RaceDefName);
				CS.XiaWorld.NpcMgr.Instance:AddNpc(npc1,npc1.LuaHelper:RandomInt(240,280),Map,CS.XiaWorld.Fight.g_emFightCamp.Enemy);
				CS.XiaWorld.ThingMgr.Instance:EquptNpc(npc1,npc1.LuaHelper:RandomInt(7,13),CS.XiaWorld.g_emNpcRichLable.Richest);
				npc1:AddTitle("天娱殿神将");
				npc1.FightBody.AttackWait = 1;
				npc1.FightBody.AttackTime = 10000;
				npc1.FightBody.AutoNext = true;
				npc1.FightBody.IsAttacker = true;
				renshu = renshu - 1
			end
			ThingMgr:RemoveThing(npc,false,true)
		return ""..npc.Name.."拒绝了打掉孩子，并和张仙尊一起离开了本门……"
		end
	end
	);
end