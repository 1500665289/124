local tbModifier = GameMain:GetMod("_ModifierScript"):GetModifier("HappyZhuYan2");

--进入modifier
function tbModifier:Enter(modifier, npc)
npc.PropertyMgr:AddFeature("BeautifulFace2");
end

--modifier step
function tbModifier:Step(modifier, npc, dt)


end

--离开modifier
function tbModifier:Leave(modifier, npc)
npc.PropertyMgr:RemoveFeature("BeautifulFace2");
end


