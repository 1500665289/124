-- 囚犯互动
local tbTable = GameMain:GetMod("MagicHelper");
local tbMagic = tbTable:GetMagic("Magic_Zhazhiji");


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
if npc1.Sex == CS.XiaWorld.g_emNpcSex.Male then
CS.Wnd_StorySelect.Select("榨汁姬",""..npc1.Name.."是男性，无法化身榨汁姬！",nil,nil)
return false;
end
	if npc1.LuaHelper:GetModifierStack("Tiaodan") ~= 0 then
		if success == true then
			local targets = Map.Things:GetNpcsLua(
			function(n)
				return n.Sex == CS.XiaWorld.g_emNpcSex.Male and n.Camp == CS.XiaWorld.Fight.g_emFightCamp.Enemy and n.LuaHelper:GetModifierStack("Prison_Modifier") ~= 1 and n:HasSpecialFlag(g_emNpcSpecailFlag.FLAG_DROPSOULCRYSTAL) == false and (n:CheckHealthState(g_emNpcHealthState.Dying) or n:CheckHealthState(g_emNpcHealthState.Coma));
			end);
			zhaqurenshu = 0
			for i = 0, targets.Count-1, 1 do
				local target = targets[i];
				if target ~= nil then
				npc1:AddModifier("Story_Caibuzhidao1");
				local tlqz = math.floor(target.LuaHelper:GetProperty("NpcLingMaxValue") * target.LuaHelper:GetGLevel())
				zhaqurenshu = zhaqurenshu + 1
				lingqigongxiangwangluo = lingqigongxiangwangluo + tlqz
				print("榨汁姬"..npc1.Name.."从"..target.Name.."身上榨取得到"..tlqz.."点灵气，跳蛋中已存灵气："..lingqigongxiangwangluo.."")
				if target.PropertyMgr.Practice.GodCount > 0 then
				target.LuaHelper:DropAwardItem("Item_yangjin6",1);
				elseif target.LuaHelper:GetGLevel() > 9 then
				target.LuaHelper:DropAwardItem("Item_yangjin5",1);
				elseif target.LuaHelper:GetGLevel() > 6 then
				target.LuaHelper:DropAwardItem("Item_yangjin4",1);
				elseif target.LuaHelper:GetGLevel() > 3 then
				target.LuaHelper:DropAwardItem("Item_yangjin3",1);
				elseif target.LuaHelper:GetGLevel() > 0 then
				target.LuaHelper:DropAwardItem("Item_yangjin2",1);
				else
				target.LuaHelper:DropAwardItem("Item_yangjin1",1);
				end
				target:DropSoulCrystal()
				target.PropertyMgr:AddMaxAge(-99999999);
				end
			end		
			CS.Wnd_StorySelect.Select("榨汁姬",""..npc1.Name.."盘膝坐下运起功法分化榨精魔女前去活活榨干了倒地的"..zhaqurenshu.."人！",nil,nil)
		end	
	else
	CS.Wnd_StorySelect.Select("榨汁姬",""..npc1.Name.."的小穴里没有运行中的跳蛋！",nil,nil)
	end
end

function tbMagic:OnGetSaveData()
	return nil;	
end

function tbMagic:OnLoadData(tbData,IDs, IsThing)	
	
end
