local tbTable = GameMain:GetMod("_ModifierScript");
local tbModifier = tbTable:GetModifier("Renmulingye");

function tbModifier:Leave(modifier, npc)
	if npc.PropertyMgr:CheckFeature("Pogua") == true then
	npc.PropertyMgr:RemoveFeature("Pogua");
	npc.PropertyMgr:FindModifier("Renmulingye"):UpdateStack(-1);
	end
end