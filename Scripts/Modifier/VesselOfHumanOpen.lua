local tbModifier = GameMain:GetMod("_ModifierScript"):GetModifier("VesselOfHumanOpen");
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
if time[id] >= 600 and npc.Equip:HasEquip("Item_MiBao_BathEssenceBead") then
local itemThing = ThingMgr:AddItemThing(0, "Item_Shit", Map, 1, false);
itemThing.Author = npc:GetName();
Map:DropItem(itemThing, npc.Key, false, false, false, false, 0, false);
time[id] = 0
end
time[id] = time[id] + dt
end

--离开modifier
function tbModifier:Leave(modifier, npc)

end


