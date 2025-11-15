local tbTable = GameMain:GetMod("MagicHelper");
local tbMagic = tbTable:GetMagic("Update3Item");


function tbMagic:EnableCheck(npc)
	if npc.LuaHelper:GetGongName() == "Gong_HappyWoman" and npc.Sex == CS.XiaWorld.g_emNpcSex.Female and npc.Needs:GetNeedValue(CS.XiaWorld.g_emNeedType.Practice) > 100 then
	return true;
	else
	return false;
	end
end

function tbMagic:TargetCheck(key, t)	
	if t.def.Parent == "DanBase" or t.IsFaBao or t.def.Parent == "Item_Spell" or t.def.Name == "Item_Spell" then
		return true;
	else
		return false;
	end
end

function tbMagic:MagicEnter(IDs, IsThing)
	self.targetId = IDs[0];
end

function tbMagic:MagicStep(dt, duration)
	local target = ThingMgr:FindThingByID(self.targetId);
	self:SetProgress(duration/self.magic.Param1);
	if duration >=self.magic.Param1  then
		return 1;
	end
	return 0;
end

function tbMagic:MagicLeave(success)
	if success == true then
		local target = ThingMgr:FindThingByID(self.targetId);
		if target ~= nil then
			local rate = target.Rate
			if rate < 25 then
			target.Rate = rate + 1
			self.bind.Needs:AddNeedValue(CS.XiaWorld.g_emNeedType.Practice,-100)
			end
		end
	end
end