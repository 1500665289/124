local tbTable = GameMain:GetMod("_ModifierScript");
local tbModifier = tbTable:GetModifier("Ouxianglianxishen1");

function tbModifier:Leave(modifier, npc)
	if npc.GongKind == g_emGongKind.Body then
		if npc.PropertyMgr.Practice.BodyPracticeData:GetQuenchingItemCount("Item_Naocanfen") > 1000 then
		world:ShowMsgBox("虚空之中显现出道主荆棘宫丝的身形，对方看了一眼"..npc.Name.."道：“你身上虾的愿力太强，已经影响到我了”\n言毕便一口将"..npc.Name.."吞入腹中吃掉了。","荆棘宫丝")
		end
	local sj = WorldLua:RandomInt(1,10)
	npc.PropertyMgr:ModifierProperty("BodyPratice_MaxZhenQi",5*sj,0,0,0)--真气+5
	npc.PropertyMgr:ModifierProperty("BodyPratice_RecoverZhenQi",1*sj,0,0,0)--回气+1
	npc.PropertyMgr:ModifierProperty("BodyPractice_SuperPartAddp_CatchFabao",0.0001*sj,0,0,0)--镇压概率
	npc.PropertyMgr:ModifierProperty("BodyPractice_SuperPartAddp_ArmorPenetration",0.0001*sj,0,0,0)--穿透加成率
	npc.PropertyMgr:ModifierProperty("BodyPractice_SuperPartAddp_DefRate",0.0001*sj,0,0,0)--防御成功率
	npc.PropertyMgr:ModifierProperty("BodyPractice_SuperPartAddp_AtkRate",0.0001*sj,0,0,0)--命中率
	npc.PropertyMgr:ModifierProperty("MaxAge",1*sj,0,0,0)--寿命
	npc.PropertyMgr:ModifierProperty("BodyPractice_SuperPartAddv_AtkPower",10*sj,0,0,0)--攻击力
	npc.PropertyMgr:ModifierProperty("BodyPractice_SuperPartAddv_DefPower",10*sj,0,0,0)--防御力
	npc.PropertyMgr:ModifierProperty("PainTolerance",0.0001*sj,0,0,0)--疼痛忍耐
	npc.PropertyMgr:ModifierProperty("BodyPratice_BodyStrong",0.1*sj,0,0,0)--身体强悍程度
	npc.PropertyMgr:ModifierProperty("BodyPratice_CatchFaboValue",-0.0001*sj,0,0,0)--镇压法宝消耗
	npc.PropertyMgr:ModifierProperty("NpcFight_BaseDodgeChance",0.0001*sj,0,0,0)--闪避
	npc.PropertyMgr.Practice.BodyPracticeData:AddQuenchingItem("Item_Naocanfen",sj)
	local wenben = npc.LuaHelper:ParseNpcStory("[rand_lable=desc_time,desc_place,desc_weather]，"..npc.Name.."因为丁柳炼汐身，自身变得更强大了，但也因为因丁柳炼汐身所吸引的脑瘫信徒们，导致凝结了"..sj.."虾形愿力结晶")
	npc.LuaHelper:AddMemery(wenben)
	npc:AddModifier("Ouxianglianxishen1")
	end
end