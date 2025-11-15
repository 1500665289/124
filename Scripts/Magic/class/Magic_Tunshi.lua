-- 囚犯互动
local tbTable = GameMain:GetMod("MagicHelper");
local tbMagic = tbTable:GetMagic("Magic_Tunshi");


function tbMagic:Init()
end

function tbMagic:MagicEnter(IDs, IsThing)
	self.TargetID = IDs[0]
	npc2 = ThingMgr:FindThingByID(self.TargetID)
	npc1 = self.bind
	if npc1.Camp ~= npc2.Camp and npc2.LuaHelper:GetModifierStack("Prison_Modifier2")~= 0 and npc1.Sex ~= npc2.Sex then
	npc2.PropertyMgr:RemoveModifier("Prison_Modifier2");
	npc1.PropertyMgr.RelationData:AddRelationShip(npc2,"Luding2");
	npc2.LuaHelper:SetCamp(g_emFightCamp.Player, false)
		if npc2.LuaHelper:GetGLevel() > 0 then
		npc2:ChangeRank(g_emNpcRank.Disciple);
		else
		npc2:ChangeRank(g_emNpcRank.Worker);
		end
	CS.Wnd_StorySelect.Select("转化",""..npc2.Name.."转化成功！",nil,nil)
	else
	CS.Wnd_StorySelect.Select("转化",""..npc2.Name.."转化失败！",nil,nil)
	end
end
