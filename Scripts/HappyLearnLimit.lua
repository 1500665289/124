local HappyLearnLimit = GameMain:GetMod("HappyLearnLimit");
local tbEvent = GameMain:GetMod("_Event");
local npc = nil;

function HappyLearnLimit:OnEnter()
	tbEvent:RegisterEvent(g_emEvent.WindowEvent,HappyLearnLimit.OnWindowEvent, "HappyLearnLimit")
end

function HappyLearnLimit.OnWindowEvent(e,thing,obj)
	local Window = obj[0];
	local Show = (obj[1] == 1) and true or false;
	if Window:ToString() == "Wnd_SelectGongs2" and Show then
		xlua.private_accessible(CS.Wnd_SelectGongs2)
		xlua.private_accessible(CS.Wnd_Message)
		HappyLearnLimit:AddNpc(Window.npc)
	end
	if Window:ToString() == "Wnd_Message" and Show and (Window.title =="《纯阳玄鼎经》" or Window.title =="《六欲心经》") then
		local Npc = HappyLearnLimit:GetNpc()
		if Npc.Sex ~= CS.XiaWorld.g_emNpcSex.Male and Window.title =="《纯阳玄鼎经》" then
		Window:Hide()
		elseif Npc.Sex ~= CS.XiaWorld.g_emNpcSex.Female and Window.title =="《六欲心经》" then
		Window:Hide()
		end
	end
end

function HappyLearnLimit:AddNpc(Npc)
npc = Npc
end

function HappyLearnLimit:GetNpc()
return npc;
end



