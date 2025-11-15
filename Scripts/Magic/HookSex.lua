local tbTable = GameMain:GetMod("MagicHelper");
local tbMagic = tbTable:GetMagic("HookSex");


function tbMagic:EnableCheck(npc)
	if npc.LuaHelper:GetGongName() == "Gong_HappyWoman" and npc.Sex == CS.XiaWorld.g_emNpcSex.Female then
	return true;
	else
	return false;
	end
end

function tbMagic:TargetCheck(key, t)	
	if t.PropertyMgr:FindModifier("HappyGetDebuff") or t.PropertyMgr:FindModifier("HappyGetDepthDebuff") then
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
			if target.IsDisciple then
			target.PropertyMgr:RemoveModifier("HappyGetDebuff")
			target:Reborn()
			target.PropertyMgr:AddModifier("HappyGetDepthDebuff")
			self.bind.PropertyMgr.BaseData:AddAddion(CS.XiaWorld.g_emNpcBasePropertyType.Charisma,0.2);
			self.bind.PropertyMgr.BaseData:AddAddion(CS.XiaWorld.g_emNpcBasePropertyType.Luck,0.2);
			self.bind.PropertyMgr.BaseData:AddAddion(CS.XiaWorld.g_emNpcBasePropertyType.Intelligence,0.2);
			self.bind.PropertyMgr.BaseData:AddAddion(CS.XiaWorld.g_emNpcBasePropertyType.Perception,0.2);
			self.bind.PropertyMgr.BaseData:AddAddion(CS.XiaWorld.g_emNpcBasePropertyType.Physique,0.2);
			else
			target.LuaHelper:DropAwardItem("Item_SoulCrystalNing",5);
			target.LuaHelper:DropAwardItem("Item_LingStone",40);
			ThingMgr:RemoveThing(target);
			end
		end
	end
end