-- 囚犯互动
local tbTable = GameMain:GetMod("MagicHelper");
local tbMagic = tbTable:GetMagic("Magic_Shenyou");


function tbMagic:Init()
end

function tbMagic:TargetCheck(k, t)	
	return true;
end

function tbMagic:MagicEnter(IDs, IsThing)
	
end

function tbMagic:MagicStep(dt, duration)--返回值  0继续 1成功并结束 -1失败并结束
	self:SetProgress(duration/self.magic.Param1);
	if duration >= self.magic.Param1 then	
		return 1;	
	end
	return 0;
end

function tbMagic:MagicLeave(success)	
local npc1 = self.bind
if npc1.GongKind ~= g_emGongKind.God or npc1.LuaHelper:GetGLevel() < 7 or npc1.PropertyMgr.Practice.GodPracticeData.GodCityArea < 1 then
CS.Wnd_StorySelect.Select("神游",""..npc1.Name.."没有属于自己的神国。",nil,nil)
return false;
end
	npc1.LuaHelper:TriggerStory("Shenyou")
end

function tbMagic:OnGetSaveData()
	return nil;	
end

function tbMagic:OnLoadData(tbData,IDs, IsThing)	
	
end
