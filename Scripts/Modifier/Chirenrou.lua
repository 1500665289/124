local tbTable = GameMain:GetMod("_ModifierScript");
local tbModifier = tbTable:GetModifier("Chirenrou");

function tbModifier:Leave(modifier, npc)
	if npc.RaceDefName ~= "Human" then
	npc:AddMood("Chirenrou")
	npc.Needs:AddNeedValue(CS.XiaWorld.g_emNeedType.Practice,100)
	local wenben = npc.LuaHelper:ParseNpcStory("[rand_lable=desc_time,desc_place,desc_weather]，"..npc.Name.."美美的品尝了一顿新鲜的人肉，真是太美味鲜嫩了！如此富含精元的食物真是百吃不腻呢！")
	elseif npc.PropertyMgr:CheckFeature("Yishipi") then
	npc:AddMood("Chirenrou")
	npc.Needs:AddNeedValue(CS.XiaWorld.g_emNeedType.Practice,100)
	local wenben = npc.LuaHelper:ParseNpcStory("[rand_lable=desc_time,desc_place,desc_weather]，"..npc.Name.."美美的品尝了一顿新鲜的人肉，真是太美味鲜嫩了！如此富含精元的食物真是百吃不腻呢！")
	npc.LuaHelper:AddPenalty(1)
	else
	npc:AddMood("Chirenrou2")
	local wenben = npc.LuaHelper:ParseNpcStory("[rand_lable=desc_time,desc_place,desc_weather]，不知道为什么，"..npc.Name.."居然吃了一口人肉，呕……")
	npc.LuaHelper:AddPenalty(1)
	end
	if CS.XiaWorld.OutspreadMgr.Instance:CanCostItem("Item_HumanMeat", 1) then
	CS.XiaWorld.OutspreadMgr.Instance:CostItem(CS.XiaWorld.OutspreadMgr.Region(),"Item_HumanMeat", 1, nil);
	end
	npc.LuaHelper:AddMemery(wenben)
	npc.PropertyMgr:FindModifier("Chirenrou"):UpdateStack(-1);
end
