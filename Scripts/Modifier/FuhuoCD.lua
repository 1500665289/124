local tbTable = GameMain:GetMod("_ModifierScript");
local tbModifier = tbTable:GetModifier("FuhuoCD");

function tbModifier:Enter(modifier, npc)
npc.FightBody.AttackWait = 1;
npc.FightBody.AttackTime = 10000;
npc.FightBody.AutoNext = true;
npc.FightBody.IsAttacker = true;
end

function tbModifier:Leave(modifier, npc)
local FBSL = npc.LuaHelper:GetProperty("NpcFight_FabaoNum")
	for i=1,FBSL,1 do
	local fabao = CS.XiaWorld.ItemRandomMachine.RandomFabao(CS.XiaWorld.g_emItemLable.FightFabao, 12, 12,100,"Item_WeaponSword",nil,0,true)
	local GJCS = WorldLua:RandomInt(1, 10);
	local GS = WorldLua:RandomInt(5, 10);
	local CXSJ = WorldLua:RandomInt(3, 6);
	local FBMZ = npc.Name.."的剑"
	fabao:SetName(npc.Name.."的剑")
	fabao:SetDesc(npc.Name.."所使用的剑")
	fabao:BindItem2Npc(npc)
	npc:EquipItem(fabao)
	fabao:AddLing(fabao.MaxLing)
	fabao.Fabao:AddAbilityData({Kind = CS.XiaWorld.Fight.g_emFabaoSpecialAbility.HitCountAddMirror,Desc = "秘宝"..FBMZ..": 每攻击"..GJCS.."出现"..GS.."道分型，持续"..CXSJ.."秒",nParam1= GJCS,nParam2 = GS,fParam1 = CXSJ})
	print(npc.Name.."制造了秘宝-"..npc.Name.."的剑")
	end
npc:AddLing(npc.MaxLing)
print(npc.Name.."复活cd结束，重新获得复活")
npc:AddModifier("Fenghuangzhixue");
end