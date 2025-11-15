local tbTable = GameMain:GetMod("_ModifierScript");
local tbModifier = tbTable:GetModifier("Shouyun");

function tbModifier:Leave(modifier, npc)
	if npc.PropertyMgr:CheckFeature("Huaitai_zhu") then--猪
	npc.PropertyMgr:RemoveFeature("Huaitai_zhu");
	fuqing = CS.XiaWorld.NpcRandomMechine.RandomNpc("YGBoar",g_emNpcSex.Male);
	end
world:ShowStoryBox("孩子出生了，它的母亲是"..npc.Name.."！\n是否要遗弃这个孩子？","繁育",{"留下","抛弃"},
	function(key)
		if key == 0 then
		npc1 = CS.XiaWorld.NpcRandomMechine.RandomNpc(fuqing.RaceDefName);
		npc1.PropertyMgr.Age = 1;
		npc1:ChangeRank(CS.XiaWorld.g_emNpcRank.Worker);
		npc1.PropertyMgr.RelationData:AddRelationShip(npc, "Parent");
		npc1.PropertyMgr.RelationData:AddRelationShip(fuqing, "Parent");
		CS.XiaWorld.NpcMgr.Instance:AddNpc(npc1,npc.Key+1,Map,CS.XiaWorld.Fight.g_emFightCamp.Player);
		return ""..npc1.Name.."被"..npc.Name.."生了下来！"
		end
		if key == 1 then
		return ""..npc1.Name.."被"..npc.Name.."抛弃了！"
		end
	end
	);
end