local tbModifier = GameMain:GetMod("_ModifierScript"):GetModifier("HappyZhuYan2");
local time = {}

--进入modifier
function tbModifier:Enter(modifier, npc)

end

--modifier step
function tbModifier:Step(modifier, npc, dt)
local id = npc.ID;
if time[id] == nil then
	time[id] = 0;
end
if time[id] > 5 then
	local value = npc.Needs:GetNeedValue(CS.XiaWorld.g_emNeedType.Practice)
	if value > 100 then
		npc.Needs:AddNeedValue(CS.XiaWorld.g_emNeedType.Practice,-100)
		npc.PropertyMgr:RemoveModifier(modifier.Name)
	end
time[id] = 0
end
time[id] = time[id] + dt;
end

--离开modifier
function tbModifier:Leave(modifier, npc)

end


