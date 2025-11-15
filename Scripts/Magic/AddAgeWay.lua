local tbTable = GameMain:GetMod("MagicHelper");
local tbMagic = tbTable:GetMagic("AddAgeWay");

function tbMagic:EnableCheck(npc)
	if npc.LuaHelper:GetGongName() == "Gong_HappyMan" and npc.Sex == CS.XiaWorld.g_emNpcSex.Male then
	return true;
	else
	return false;
	end
end

function tbMagic:TargetCheck(key, t)	
	return true;
end

function tbMagic:MagicEnter(IDs, IsThing)
end

function tbMagic:MagicStep(dt, duration)
	self:SetProgress(duration/self.magic.Param1);
	if duration >=self.magic.Param1  then
		return 1;
	end
	return 0;
end

function tbMagic:MagicLeave(success)
	if success == true then
		local value = self.bind.LingV
		local level = self.bind.PropertyMgr.SkillData:GetSkillLevel(CS.XiaWorld.g_emNpcSkillType.Qi)
		local num = self.bind.PropertyMgr:GetProperty("LingAbsorbSpeed",false,true)
		self.bind:AddLing(-self.bind.LingV)
		self.bind.PropertyMgr:AddMaxAge(value ^ 0.3)
		self.bind.PropertyMgr.SkillData:AddSkillLevelAddion(CS.XiaWorld.g_emNpcSkillType.Qi,-level)
		self.bind.PropertyMgr:ModifierProperty("LingAbsorbSpeed",-num,0,0,0)
	end
end