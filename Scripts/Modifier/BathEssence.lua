local tbModifier = GameMain:GetMod("_ModifierScript"):GetModifier("BathEssence");
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
if time[id] >= 10 and npc.Sex == CS.XiaWorld.g_emNpcSex.Female then
local item = npc.Equip:FindTool("Item_MiBao_BathEssenceBead")
local num1 = npc.Needs:GetNeedValue(CS.XiaWorld.g_emNeedType.Practice) - npc.Needs:GetNeedValue(CS.XiaWorld.g_emNeedType.Practice)%1
local num2 = item.Beauty
local num = 0;
if num1 > 1000 then
num = num1 - 1000;
npc.Needs:AddNeedValue(CS.XiaWorld.g_emNeedType.Practice,-num)
item:ChangeBeauty(num2 + num)
else
num = 1000 - num1;
if num > num2 then
npc.Needs:AddNeedValue(CS.XiaWorld.g_emNeedType.Practice,num2)
item:ChangeBeauty(0)
else
npc.Needs:AddNeedValue(CS.XiaWorld.g_emNeedType.Practice,num)
item:ChangeBeauty(num2 - num)
end
end
time[id] = 0
end
time[id] = time[id] + dt
end

--离开modifier
function tbModifier:Leave(modifier, npc)

end


