local tbModifier = GameMain:GetMod("_ModifierScript"):GetModifier("RecoveryLingAuto2");
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
npc:AddLing(20000)
time[id] = 0
end
time[id] = time[id] + dt
end

--离开modifier
function tbModifier:Leave(modifier, npc)

end


