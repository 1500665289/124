local tbModifier = GameMain:GetMod("_ModifierScript"):GetModifier("AddSchoolMax");
local flag = 0;

--进入modifier
function tbModifier:Enter(modifier, npc)

end

--modifier step
function tbModifier:Step(modifier, npc, dt)
if flag == 0 then
CS.XiaWorld.GameDefine.SchoolMaxNpc[0] = 24
CS.XiaWorld.GameDefine.SchoolMaxNpc[1] = 24
CS.XiaWorld.GameDefine.SchoolMaxNpc[2] = 36
CS.XiaWorld.GameDefine.SchoolMaxNpc[3] = 48
flag = 1;
end
end

--离开modifier
function tbModifier:Leave(modifier, npc)
CS.XiaWorld.GameDefine.SchoolMaxNpc[0] = 12
CS.XiaWorld.GameDefine.SchoolMaxNpc[1] = 12
CS.XiaWorld.GameDefine.SchoolMaxNpc[2] = 24
CS.XiaWorld.GameDefine.SchoolMaxNpc[3] = 36
end


