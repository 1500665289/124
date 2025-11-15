local tbTable = GameMain:GetMod("_ModifierScript");
local tbModifier = tbTable:GetModifier("Wanxue");

function tbModifier:Enter(modifier, npc)
end

function tbModifier:Step(modifier, npc, dt)
	local time = self.time or 0
	time = time + dt
	if time > 1 then
		tbModifier:fuhuo(modifier, npc)
		self.time = 0;
		return
	end
	self.time = time;
end

function tbModifier:fuhuo(modifier, npc)
	if npc.LingV < npc.LuaHelper:GetProperty("NpcLingMaxValue")/5 then
	npc:AddLing(npc.LuaHelper:GetProperty("NpcLingMaxValue"));
	local wenben = npc.Name.."：“万血！归灵！”"..npc.Name.."施展了秘术，回复了自己的全部灵气。"
	npc.LuaHelper:AddMemery(wenben);
	end
	if npc.HealthValue == 0 or npc.IsDeath or npc.IsLingering or npc:CheckHealthState(g_emNpcHealthState.Dying) or npc:CheckHealthState(g_emNpcHealthState.Coma) then
	npc.PropertyMgr:FindModifier("Wanxue"):UpdateStack(-1);
	end
end


function tbModifier:Leave(modifier, npc)
	local npc1 = CS.XiaWorld.NpcRandomMechine.RandomNpc("Human",g_emNpcSex.Female);
	CS.XiaWorld.NpcMgr.Instance:AddNpc(npc1,npc1.LuaHelper:RandomInt(240,280),Map,CS.XiaWorld.Fight.g_emFightCamp.Player);
	CS.XiaWorld.ThingMgr.Instance:EquptNpc(npc1,0,CS.XiaWorld.g_emNpcRichLable.Richest);
	local npc2 = CS.XiaWorld.NpcRandomMechine.RandomNpc("Human",g_emNpcSex.Female);
	CS.XiaWorld.NpcMgr.Instance:AddNpc(npc2,npc2.LuaHelper:RandomInt(240,280),Map,CS.XiaWorld.Fight.g_emFightCamp.Player);
	CS.XiaWorld.ThingMgr.Instance:EquptNpc(npc2,0,CS.XiaWorld.g_emNpcRichLable.Richest);
	npc1.PropertyMgr:AddAge(-npc1.Age + 28);
	npc2.PropertyMgr:AddAge(-npc2.Age + 13);
	npc1.PropertyMgr:AddFeature("Pogua");
	npc1.PropertyMgr:AddFeature("BeautifulFace2");
	npc2.PropertyMgr:AddFeature("BeautifulFace2");
	npc1:ChangeRank(g_emNpcRank.Worker);
	npc2:ChangeRank(g_emNpcRank.Worker);
	npc1.PropertyMgr.RelationData:AddRelationShip(npc2,"Child");
	if npc.HealthValue == 0 then
	local Msg =""..npc.Name.."被"..SchoolMgr.Name.."击溃，这对老道追索戏耍的母女花，也为了报答救命之恩，加入了"..SchoolMgr.Name.."。"
	CS.Wnd_StorySelect.Select("一对绝色母女",Msg,nil,nil)
	else
	local Msg =""..npc.Name.."见势不妙，逃离了"..SchoolMgr.Name.."，这对老道追索戏耍的母女花，也为了报答救命之恩，加入了"..SchoolMgr.Name.."。"
	CS.Wnd_StorySelect.Select("一对绝色母女",Msg,nil,nil)
	ThingMgr:RemoveThing(npc,false,true)
	end
end