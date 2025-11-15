local tbModifier = GameMain:GetMod("_ModifierScript"):GetModifier("MumSuckShip");
local time = 0;

--进入modifier
function tbModifier:Enter(modifier, npc)

end

--modifier step
function tbModifier:Step(modifier, npc, dt)
if time > 600 then
if npc.LuaHelper:CheckFeature("Pogua") == false and npc.Sex == CS.XiaWorld.g_emNpcSex.Female and npc.Age < 18 then
local it = npc.Equip:FindTool("Item_MiBao_MumSuckShip");
CS.XiaWorld.FabaoEventMgr.SetFabaoActive(it, CS.XiaWorld.FabaoEvenType.Other, 1);
end
time = 0;
end
time = time + dt
end

--离开modifier
function tbModifier:Leave(modifier, npc)

end


