local WomanX = GameMain:GetMod("WomanX");
local tbEvent = GameMain:GetMod("_Event");


function WomanX:OnEnter()
	tbEvent:RegisterEvent(g_emEvent.FightBodyBeHit, WomanX.OnFightBodyBeHit, "DuoLing")

end


function WomanX:OnLeave()
	tbEvent:UnRegisterEvent(g_emEvent.FightBodyBeHit, "DuoLing")
end

function WomanX.OnFightBodyBeHit(t,npc,obj)
	if obj[2] ~= nil then
	local from = obj[2];
		if npc.PropertyMgr:FindModifier("Gong_HappyWoman_10") ~= nil and npc.LuaHelper:GetGongName() == "Gong_HappyWoman" then
			local num = (npc.MaxLing - npc.LingV) * 0.1
			npc:AddLing(num)
			from:AddLing(-num)
		end
	end
end