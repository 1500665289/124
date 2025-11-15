local tbModifier = GameMain:GetMod("_ModifierScript"):GetModifier("HappyZhuYan");

--进入modifier
function tbModifier:Enter(modifier, npc)
npc.ZhuYan = 1;
end

--modifier step
function tbModifier:Step(modifier, npc, dt)


end

--离开modifier
function tbModifier:Leave(modifier, npc)
npc.ZhuYan = 2
end


