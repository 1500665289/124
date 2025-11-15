local tbTable = GameMain:GetMod("_ModifierScript");
local tbModifier = tbTable:GetModifier("Qiufan");

function tbModifier:Enter(modifier, npc)
npc:AddBtnData("囚犯互动","","GameMain:GetMod('Lua_qiufan'):qiufanhudong()","安排一个人，与囚犯互动");
end

function tbModifier:Leave(modifier, npc)
npc:RemoveBtnData("囚犯互动");
end
