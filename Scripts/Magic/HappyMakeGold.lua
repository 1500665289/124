local tbTable = GameMain:GetMod("MagicHelper");
local tbMagic = tbTable:GetMagic("HappyMakeGold");

function tbMagic:EnableCheck(npc)
	if npc.LuaHelper:GetGongName() == "Gong_HappyMan" and npc.Sex == CS.XiaWorld.g_emNpcSex.Male then
	return true;
	else
	return false;
	end
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
	local count = Map.Things:GetActiveNpcs(g_emNpcRaceType.Wisdom).Count
	local list = Map.Things:GetActiveNpcs(g_emNpcRaceType.Wisdom)
		for i=0,count - 1,1 do
		local npc = list[i]
		if npc.IsDeath and npc.IsDisciple then
			local item = CS.XiaWorld.ItemRandomMachine.RandomItem("HappyGold");
			local num = npc.Needs:GetNeedValue(CS.XiaWorld.g_emNeedType.Practice) - npc.Needs:GetNeedValue(CS.XiaWorld.g_emNeedType.Practice)%1
			npc.map:DropItem(item,npc.Key,true,true,false,true,5);
			item:AddLing(npc.LingV * 0.2)
			item.Author = self.bind.Name
			item:SetName(npc.Name.."的精元丹")
			item:ChangeBeauty(num)
			item.Rate = npc.LuaHelper:GetGLevel()
			ThingMgr:RemoveThing(npc)
		end
		end
	end
end