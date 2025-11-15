local tbModifier = GameMain:GetMod("_ModifierScript"):GetModifier("RecoveryNeedPractice");
local time = {}


--进入modifier
function tbModifier:Enter(modifier, npc)

end

--modifier step
function tbModifier:Step(modifier, npc, dt)
local id = npc.ID
if time[id] == nil then
time[id] = 0
end
if time[id] >= 10 then
local num1 = npc.Needs:GetNeedValue(CS.XiaWorld.g_emNeedType.Practice)
local num2 = 0.1 * npc.MaxLing
if num1 < 200 and npc.LingV > num2 then
npc.Needs:AddNeedValue(CS.XiaWorld.g_emNeedType.Practice,1000)
npc:AddLing(-num2)
end
time[id] = 0
end
time[id] = time[id] + dt
end

--离开modifier
function tbModifier:Leave(modifier, npc)

end


