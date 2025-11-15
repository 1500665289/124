local tbTable = GameMain:GetMod("_ModifierScript");
local tbModifier = tbTable:GetModifier("Fuhuo");

function tbModifier:Enter(modifier, npc)
end

function tbModifier:Step(modifier, npc, dt)
	local time = self.time or 0
	time = time + dt
	if time > 1 then
		tbModifier:fuhuo(modifier, npc)
		self.time = 0;
		return
	end
	self.time = time;
end

function tbModifier:fuhuo(modifier, npc)
	if npc.IsDeath or npc.IsLingering or npc:CheckHealthState(g_emNpcHealthState.Dying) or npc:CheckHealthState(g_emNpcHealthState.Coma) then
	print(npc.Name.."等待复活")
		if npc.MaxAge > npc.Age then
		npc.PropertyMgr:FindModifier("Fenghuangzhixue"):UpdateStack(-1);
		else
		print(npc.Name.."寿命不足")
		world:ShowMsgBox(npc.Name.."的凤凰之血已经完全干涸了，"..npc.Name.."的身躯被心火焚烧殆尽。","凤凰之血")
		ThingMgr:RemoveThing(npc,false,true)
		end 
	end
end


function tbModifier:Leave(modifier, npc)
	npc:Resurrection()
	npc:AddLing(npc.MaxLing)
	print(npc.Name.."耗费了60寿命，点燃了凤凰血脉，成功复活")
	local wenben = npc.Name.."施展了秘术激活了体内的凤凰血脉，通过燃烧一甲子寿元，成功的复活了"
	npc.LuaHelper:AddMemery(wenben);
	npc.PropertyMgr:AddMaxAge(-60);
	WorldLua:PlayEffect("Effect/A/Prefabs/Projectiles/Light/LightImpactNormal", npc.Pos, 5);
	npc:AddModifier("FuhuoCD");
end