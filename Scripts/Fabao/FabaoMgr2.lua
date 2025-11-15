 local tbTable = GameMain:GetMod("_FabaoHelper2");--先注册一个新的MOD模块
function tbTable:OnEnter()

end

function tbTable:OnLeave()

end

function tbTable:Chidiao()
local npc1 = ThingMgr:FindThingByID(me.npcObj.ID)
	if npc1.Sex ~= CS.XiaWorld.g_emNpcSex.Male then
	WorldLua:ShowMsgBox(XT(""..npc1.Name.."是个女人，无法喂养合欢蛊……"), XT("喂食合欢蛊"));
	elseif npc1.PropertyMgr.BodyData:PartIsBroken("Genitals") then
	WorldLua:ShowMsgBox(XT(""..npc1.Name.."是个太监，无法喂养合欢蛊……"), XT("喂食合欢蛊"));
	else
	WorldLua:ShowMsgBox(XT(""..npc1.Name.."将吊割了下来，喂给了合欢蛊……"), XT("喂食合欢蛊"));
	me:AddDamage("Fabao_CutOff","Genitals", 1, XT("被合欢蛊吃掉了"));
	CS.XiaWorld.FabaoEventMgr.SetFabaoActive(it, CS.XiaWorld.FabaoEvenType.Other, 1);
	end
	return false;
end

function tbTable:Longdan()
local npc1 = ThingMgr:FindThingByID(me.npcObj.ID)
	if npc1.LingV > 10000000 then
	npc1:AddLing(-10000000);
	WorldLua:ShowMsgBox(XT(""..npc1.Name.."给龙丹注入了千万灵气……"), XT("注入灵气"));
	CS.XiaWorld.FabaoEventMgr.SetFabaoActive(it, CS.XiaWorld.FabaoEvenType.Other, 1000);
	elseif npc1.LingV > 1000000 then
	npc1:AddLing(-1000000);
	WorldLua:ShowMsgBox(XT(""..npc1.Name.."给龙丹注入了百万灵气……"), XT("注入灵气"));
	CS.XiaWorld.FabaoEventMgr.SetFabaoActive(it, CS.XiaWorld.FabaoEvenType.Other, 100);
	elseif npc1.LingV > 100000 then
	npc1:AddLing(-100000);
	WorldLua:ShowMsgBox(XT(""..npc1.Name.."给龙丹注入了十万灵气……"), XT("注入灵气"));
	CS.XiaWorld.FabaoEventMgr.SetFabaoActive(it, CS.XiaWorld.FabaoEvenType.Other, 10);
	elseif npc1.LingV > 10000 then
	npc1:AddLing(-10000);
	WorldLua:ShowMsgBox(XT(""..npc1.Name.."给龙丹注入了一万灵气……"), XT("注入灵气"));
	CS.XiaWorld.FabaoEventMgr.SetFabaoActive(it, CS.XiaWorld.FabaoEvenType.Other, 1);
	else
	WorldLua:ShowMsgBox(XT(""..npc1.Name.."的灵气太低，虽然注入了龙丹，但是没有什么效果……"), XT("注入灵气"));
	end
	return false;
end

function tbTable:Tiaodan()
local npc1 = ThingMgr:FindThingByID(me.npcObj.ID)
lingqigongxiangwangluo = lingqigongxiangwangluo or 0
	if npc1.Sex == CS.XiaWorld.g_emNpcSex.Female and npc1.LuaHelper:GetModifierStack("Tiaodan") ~= 0 then
	WorldLua:ShowMsgBox(XT(""..npc1.Name.."将跳蛋从下体取了出来……"), XT("跳蛋"));
	npc1.PropertyMgr:FindModifier("Tiaodan"):UpdateStack(-1);
	print(npc1.Name.."关闭了跳蛋，离开了跳蛋灵气共享网络。")
	elseif npc1.Sex == CS.XiaWorld.g_emNpcSex.Female then
	WorldLua:ShowMsgBox(XT(""..npc1.Name.."将跳蛋开启后塞入下体……\n"..npc1.Name.."连接上了灵气共享网络。\n当前跳蛋共享灵气："..lingqigongxiangwangluo..""), XT("跳蛋"));
	npc1:AddModifier("Tiaodan");
	print(npc1.Name.."开启了跳蛋。\n当前跳蛋共享灵气为"..lingqigongxiangwangluo.."")
	else
	WorldLua:ShowMsgBox(XT(""..npc1.Name.."不是女修，无法使用跳蛋……"), XT("跳蛋"));
	end
	return false;
end