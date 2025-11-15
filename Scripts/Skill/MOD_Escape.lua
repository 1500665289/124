local tbTable = GameMain:GetMod("_SkillScript");
local tbSkill = tbTable:GetSkill("MOD_Escape");



--技能释放的时候
function tbSkill:Cast(skilldef, from)

end

--技能在key点生效
function tbSkill:Apply(skilldef, key, from)

end

--技能在fightbody身上生效
function tbSkill:FightBodyApply(skilldef, fightbody, from)
	local npc = from;
	if npc.LuaHelper:GetGongName() == "Gong_HappyWoman" then
		if CS.GameMain.Instance.FightMap then
			xlua.private_accessible(CS.XiaWorld.FightMapMgr)
			local count = CS.XiaWorld.FightMapMgr.Instance.PlayerAttackNpcs.Count - 1
			for i=0,count,1 do
				ThingMgr:FindThingByID(CS.XiaWorld.FightMapMgr.Instance.PlayerAttackNpcs[i]).PropertyMgr:AddModifier("MOD_EscapeModifier")
			end
		end
	end
end

--技能产生的子弹在pos点爆炸
function tbSkill:MissileBomb(skilldef, pos, from)
end

--数值加值
function tbSkill:GetValueAddv(skilldef, fightbody, from)

end

function tbSkill:FlyCheck(skilldef, keys, from)
end