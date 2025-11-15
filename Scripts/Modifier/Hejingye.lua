local tbTable = GameMain:GetMod("_ModifierScript");
local tbModifier = tbTable:GetModifier("Hejingye");

function tbModifier:Leave(modifier, npc)
	if npc.PropertyMgr:CheckFeature("Yishipi") or npc.PropertyMgr:CheckFeature("Chinvguchong") or npc.PropertyMgr:CheckFeature("Yingjingzhe") or npc.PropertyMgr:CheckFeature("Mugou") then
	npc:AddMood("Yingjingzhe1")
	local wenben = npc.LuaHelper:ParseNpcStory(""..npc.Name.."小口小口品味着这口中甘甜精元的味道……")
	else
	npc:AddMood("Yingjingzhe2")
	local wenben = npc.LuaHelper:ParseNpcStory("呕……"..npc.Name.."喝了一口精液，整个人都被这股腥臭所恶。")
	end
	npc.LuaHelper:AddMemery(wenben)
end