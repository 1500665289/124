local tbTable = GameMain:GetMod("_ModifierScript");
local tbModifier = tbTable:GetModifier("Tiaodan");

function tbModifier:Enter(modifier, npc)
end

function tbModifier:Step(modifier, npc, dt)
	local time = self.time or 0
	time = time + dt
	if time > 10 then
		tbModifier:tiaodan(modifier, npc)
		self.time = 0;
		return
	end
	self.time = time;
end

function tbModifier:tiaodan(modifier, npc)
	lingqigongxiangwangluo = lingqigongxiangwangluo or 0
	if npc.GongKind == g_emGongKind.Body then
		if lingqigongxiangwangluo > 10000 then
		lingqigongxiangwangluo = lingqigongxiangwangluo - 10000
		npc.PropertyMgr:ModifierProperty("BodyPratice_MaxZhenQi",1,0,0,0)
		print(npc.Name.."通过跳蛋灵气网络，吸收跳蛋中的海量灵气，用于淬炼自身气海，使自身气海得到了扩充……跳蛋中已存灵气："..lingqigongxiangwangluo.."")
		end
	else
		if npc.IsPlayerThing and npc.IsDisciple and npc.Sex == CS.XiaWorld.g_emNpcSex.Female and npc.LingV == npc.LuaHelper:GetProperty("NpcLingMaxValue") and lingqigongxiangwangluo < 100000000 then
		local chongling = math.floor(npc.LuaHelper:GetProperty("NpcLingMaxValue")/10)
		lingqigongxiangwangluo = lingqigongxiangwangluo + chongling
		npc:AddLing(-chongling);
		lingqigongxiangwangluo = lingqigongxiangwangluo;
		print(npc.Name.."将灵气通过下体灌注于跳蛋中，本次灌注"..chongling.."点灵气，跳蛋中已存灵气："..lingqigongxiangwangluo.."")
		lingqigongxiangwangluo = lingqigongxiangwangluo or 0
		elseif npc.IsPlayerThing and npc.IsDisciple and npc.Sex == CS.XiaWorld.g_emNpcSex.Female and npc.LingV < npc.LuaHelper:GetProperty("NpcLingMaxValue")/10 and lingqigongxiangwangluo ~= 0 then
		local bclq = math.floor(npc.LuaHelper:GetProperty("NpcLingMaxValue") - npc.LingV)
			if lingqigongxiangwangluo > bclq then
			npc:AddLing(bclq);
			lingqigongxiangwangluo = lingqigongxiangwangluo - bclq
			print(npc.Name.."从跳蛋中抽取"..bclq.."点灵气，跳蛋中已存灵气："..lingqigongxiangwangluo.."")
			else
			npc:AddLing(lingqigongxiangwangluo);
			print(npc.Name.."从跳蛋中抽取"..lingqigongxiangwangluo.."点灵气，跳蛋中已存灵气：0")
			lingqigongxiangwangluo = 0
			end
		lingqigongxiangwangluo = lingqigongxiangwangluo or 0
		else
		end
	end
end


function tbModifier:Leave(modifier, npc)
end