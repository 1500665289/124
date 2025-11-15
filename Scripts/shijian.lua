local Hudong = GameMain:GetMod("Lua_shijian");
local npc1 = nil;
local npc2 = nil;
local flag = nil;
---------------------------------------------------------------------------------------------存档
function Hudong:OnEnter()--非法用户检测
zhongzubiaoge = {"Human","YGRabbit","YGChicken","YGWolf","YGSnake","YGBoar","YGBear","YGTurtle","YGFrog","YGCat","YGCattle","YGTiger"}
nvsishu = {"《女戒》","《女则》","《烈女传》","《闺范》"}
Zhuyaoflag = {"虾神","剑神","灵狐","青行灯","香姬"}
zhChar = {'一','二','三','四','五','六','七','八','九'}
places = {'','十','百','千','万','十','百','千','亿','十','百','千','万'}
menpailiebiao = {"丹霞洞天","昆仑宫","极天宫","紫霄宗","玄一道","青莲剑宗","栖霞洞天","百蛮山","七仟坞","七杀魔宫","合欢派","万妖殿"}
lingqigongxiangwangluo = world:GetWorldFlag(1711) or 0
print("进入游戏，读取灵气共享网络中的灵气值，现有灵气："..lingqigongxiangwangluo.."。")
end

function Hudong:OnInit()
GameMain:GetMod('_Event'):RegisterEvent(g_emEvent.FightBodyBeHit,Hudong.FightBodyBeHit, "Hudong_Reinforce");
GameMain:GetMod('_Event'):RegisterEvent(g_emEvent.NpcHealthStateChanged,Hudong.NpcHealthStateChanged, "Hudong_Fight");
GameMain:GetMod('_Event'):RegisterEvent(g_emEvent.NpcDeath,Hudong.NpcDeath, "Hudong_Death");
local targets = Map.Things:GetNpcsLua(
	function(n)
		return n.LuaHelper:GetModifierStack("Prison_Modifier") > 0;
	end);
	for i = 0, targets.Count-1, 1 do
	local target = targets[i];
		if target ~= nil then
		target:RemoveBtnData("囚犯互动");
		target:AddBtnData("囚犯互动","","GameMain:GetMod('Lua_qiufan'):qiufanhudong()","安排一个人，与囚犯互动");
		end
	end
end

function Hudong:OnSave()
world:SetWorldFlag(1711,lingqigongxiangwangluo);
print("保存游戏，保存灵气共享网络中的灵气值，现有灵气："..lingqigongxiangwangluo.."。")
end

function Hudong.NpcDeath(e,npc,obj)
	if npc.Name == "神秘修行者" then
	nvxingrenshu = 0
	nanxingrenshu = 0
	world:ShowStoryBox("神秘修行者的尸身之上慢慢幻出一个鹤发童颜的老叟：“东皇宫后人果然各个孤儿，连一个前来庇佑你们的仙人，你们都要谋杀。”","神秘修仙者",{"忏悔","嘴硬"},
	function(key)
		if key == 0 then
		local targets = Map.Things:GetNpcsLua(
		function(n)
			return n.IsPlayerThing and n.IsAlive and n:HasSpecialFlag(g_emNpcSpecailFlag.MapExploring) == false and n:HasSpecialFlag(g_emNpcSpecailFlag.AuctionPunish) == false and n.IsSmartRace ;
		end);
		for i = 0, targets.Count-1, 1 do
		local target = targets[i];
			if target ~= nil then
				if target.Sex == CS.XiaWorld.g_emNpcSex.Female then
				target.PropertyMgr:AddFeature("Pogua");
				target.PropertyMgr:AddFeature("Huaitai_zhu");
				target:AddModifier("Shouyun")
				nvxingrenshu = nvxingrenshu + 1
				else
				target.LuaHelper:AddDamage("Fabao_CutOff","Genitals", 1, XT("神秘修行者的剑诀斩断"));
				nanxingrenshu = nanxingrenshu + 1
				end
			end
		end
			if nvxingrenshu > 0 and nanxingrenshu > 0 then --多人，有男有女
			return "众人跪倒在地连连忏悔，老叟却一脸不屑！法诀连展，数头猪妖凭空而现将"..nvxingrenshu.."女奸淫了一番，腾云离去之时，老叟顺手施展剑诀，将所有男子的阳物斩断，冷笑连连……"
			elseif nvxingrenshu > 1 and nanxingrenshu == 0 then	--多人全女
			return "众人跪倒在地连连忏悔，老叟却一脸不屑！法诀连展，数头猪妖凭空而现将"..nvxingrenshu.."女奸淫了一番，后腾云离去了……"
			elseif nvxingrenshu == 0 and nanxingrenshu > 1 then --多人全男
			return "众人跪倒在地连连忏悔，老叟却一脸不屑！法诀连展，将所有男子阳物斩断后腾云离去了……"
			elseif nvxingrenshu == 0 and nanxingrenshu == 1 then -- 一男
			return "那男子跪倒在地连连忏悔，老叟却一脸不屑！法诀连展，将所有男子阳物斩断后腾云离去了……"
			else--一女
			return "那女子跪倒在地连连忏悔，老叟却一脸不屑！法诀连展，数头猪妖凭空而现将"..nvxingrenshu.."女奸淫了一番，后腾云离去了……"
			end
		end
		if key == 1 then
		npc.LuaHelper:DropAwardItem("Item_LingCrystal",10);
		return "众人没有丝毫会意反而舔着脸说着什么：“修行之道本就逆天而行巴拉巴拉的”。\n却不曾想老叟却哈哈大笑，高声赞到：“说的对，我辈修行之人，本就是在逆天而行，你们果然有慧根，我百蛮山卓十七看好你们”，言毕便留下了十枚灵晶腾云而去了。"
		end
	end
	);
	end
end
function Hudong.NpcHealthStateChanged(e,npc,obj)
	if (npc.IsDeath or npc.IsLingering or npc:CheckHealthState(g_emNpcHealthState.Dying) or npc:CheckHealthState(g_emNpcHealthState.Coma)) and npc.PropertyMgr:CheckFeature("Kushenjiang") then
		if WorldLua:CheckWeatherExist("Rainstorm") then
		npcc = CS.XiaWorld.NpcRandomMechine.RandomNpc("Human",g_emNpcSex.Female);
		npcc:SetName("郭紫黎")
		npcc.LuaHelper:AddTitle("哭神将的念人")
		npcc.PropertyMgr:AddFeature("Kushenjiang");
		npcc.PropertyMgr.Practice:ChangeGong("Body_Gong_nvquan");
		Hudong:zuzhuangnvquanmiti()
		npcc.PropertyMgr.Practice.BodyPracticeData:AddZhenQi(999999)
		CS.XiaWorld.NpcMgr.Instance:AddNpc(npcc,npc.Key,Map,CS.XiaWorld.Fight.g_emFightCamp.Enemy);
		npcc.PropertyMgr.Practice:Up2Disciple("Body_Gong_nvquan", 12)
		npcc.LuaHelper:AddMemery(""..npcc.Name.."：“你看，天都在为这男尊的世界悲伤，没有人可以在上天为我哭泣的时候打败我！”")
		npcc.FightBody.AttackWait = 1;
		npcc.FightBody.AttackTime = 10000;
		npcc.FightBody.AutoNext = true;
		npcc.FightBody.IsAttacker = true;
		ThingMgr:RemoveThing(npc,false,true)
		print("分身完成。")
		return;
		else
		ThingMgr:RemoveThing(npc,false,true)
		return;
		end
	end
end

function Hudong.FightBodyBeHit(e,npc,obj)
	duishou = obj[2]
	Ksjfenshen = Ksjfenshen or 0
	if npc.PropertyMgr:CheckFeature("Kushenjiang") and WorldLua:CheckWeatherExist("Rainstorm") and Ksjfenshen < 7 then
	Ksjfenshen = Ksjfenshen + 1
	npcc = CS.XiaWorld.NpcRandomMechine.RandomNpc("Human",g_emNpcSex.Female);
	npcc:SetName("郭紫黎")
	npcc.LuaHelper:AddTitle("哭神将的念人")
	npcc.PropertyMgr:AddFeature("Kushenjiang");
	npcc.PropertyMgr.Practice:ChangeGong("Body_Gong_nvquan");
	Hudong:zuzhuangnvquanmiti()
	npcc.PropertyMgr.Practice.BodyPracticeData:AddZhenQi(999999)
	CS.XiaWorld.NpcMgr.Instance:AddNpc(npcc,npc.Key,Map,CS.XiaWorld.Fight.g_emFightCamp.Enemy);
	npcc.PropertyMgr.Practice:Up2Disciple("Body_Gong_nvquan", 12)
	npcc.LuaHelper:AddMemery(""..npcc.Name.."：“你看，天都在为这男尊的世界悲伤，没有人可以在上天为我哭泣的时候打败我！”。\n言毕又一个"..npcc.Name.."的念人在雨水中具现……")
	npcc.FightBody.AttackWait = 1;
	npcc.FightBody.AttackTime = 10000;
	npcc.FightBody.AutoNext = true;
	npcc.FightBody.IsAttacker = true;
	print("分身完成。")
	return;
	elseif duishou.LuaHelper:GetGongName() == "Gong_1701_Tu" and duishou.GongKind == npc.GongKind and npc.LuaHelper:GetGongName() ~= "Gong_1701_Tu" and duishou.Sex ~= npc.Sex then
	xiling = math.floor(duishou.LuaHelper:GetProperty("NpcLingMaxValue")/10)
		if npc.LingV > 0 then
		duishou:AddLing(-xiling);
		npc:AddLing(xiling);
		print(""..npc.Name.."被"..duishou.Name.."攻击了，"..duishou.Name.."施展了合欢秘法，"..duishou.Name.."吸收了"..npc.Name.."的灵气"..xiling.."点")
		WorldLua:PlayEffect("Effect/gsq/Prefab/long/fx_long002_fanshi_01", duishou.ViewPos, 5);
		return;
		end
	end
end
-------------------事件
function Hudong:formatNumber( num ) --数字中文化

if  type(num) ~=  'number' then
return num .. 'is not a num'
end
local numStr = tostring(num)
local len = string.len(numStr)
local str = ''
local has0 = false
for i = 1, len do
local n = tonumber(string.sub(numStr,i,i))
local p = len - i + 1
if n > 0 and has0 == true then --连续多个零只显示一个
str = str .. '零'
has0 = false
end
if p % 4 == 2 and n == 1 then --十位数如果是首位则不显示一十这样的
if len > p then
str = str .. zhChar[n]
end
str = str .. places[p]
elseif n > 0 then 
str = str .. zhChar[n]
str = str .. places[p]
elseif n == 0 then
if p % 4 == 1 then --各位是零则补单位
str = str .. places[p]
else
has0 = true
end
end
end
return str
end

function Hudong:shiqi1()
	if me:GetSex() == 1 and me:GetCharisma() > 7 then
		if me:GetGongName() == "Gong_1701_Tu" then
		me:AddMsg(XT("[NAME]仅仅只靠俊俏的脸庞便俘获了对方芳心，一番调教之后，该女子成为了[NAME]的专属炉鼎以供采补，[NAME]修为大涨。"));me:AddModifier("Luding4");me:AddPracticeResource("Stage",me:GetGLevel() * 500);me:AddModifier("Story_Caibuzhidao1");me:AddMemery("在历练途中睡了一个绝色女子！");
		else
		me:AddMsg(XT("[NAME]仅仅只靠俊俏的脸庞便俘获了对方芳心，由于并未习得采补之法，故只是和该女子结了一段露水姻缘后便离开了。"));
		end
	else
	me:AddMsg(XT("[NAME]欲追明火执仗的追求这位女子，而只得到了一个“滚”字。"));
	end
end

function Hudong:shiqi2()
	if me:GetGLevel() > 6 then
		if me:GetGongName() == "Gong_1701_Tu" then
		me:AddMsg(XT("[NAME]二话不说，打退了女子身边的随从，便将女子掳回门派，一番调教之后，该女子成为了[NAME]的专属炉鼎以供采补，[NAME]修为大涨。"));me:AddModifier("Luding4");me:AddPracticeResource("Stage",me:GetGLevel() * 500);me:AddSchoolScore(3,100);me:AddModifier("Story_Caibuzhidao1");me:AddMemery("在历练途中强奸了一个绝色女子！");
		else
		me:AddMsg(XT("[NAME]二话不说，打退了女子身边的随从，将女子一番调教后干了个爽，由于并未习得采补之法，故满足肉欲后[NAME]便离开了。"));
		end
	else
	me:AddMsg(XT("[NAME]被女子的舔狗们一顿暴打，看准一个机会勉强趁机溜走。"));me:AddSchoolScore(1,-100);
	end
end

function Hudong:shiqi3()
	if me:GetSex() > 1 then
		if me:GetGongName() == "Gong_1701_Tu" then
		me:AddMsg(XT("身为女修的[NAME]，扮作凡女故意被合欢叛徒掳走，合欢叛徒们于[NAME]身上驰骋之时，只见[NAME]气随意转转瞬间将对方精元吸尽，余者只当是此子纵欲过度未做防范，[NAME]以一当百活生生的将所有合欢叛徒睡服。"));me.npcObj.PropertyMgr:AddFeature("Pogua");me:AddModifier("Story_Caibuzhidao1");me:AddMemery("在历练途中舍身睡服数十合欢叛徒，并将对方残余不多的精元采补一空！");
		else
		me:AddMsg(XT("身为女修的[NAME]，扮作凡女故意被合欢叛徒掳走，合欢叛徒们于[NAME]身上驰骋之时，[NAME]想要运转法诀反夺对方精元，奈何自己并未学习任何采补之法，只能活生生的被这一众合欢叛徒所轮奸。"));me.npcObj.PropertyMgr:AddFeature("Pogua");me:AddModifier("Story_Caibuzhidao2");me:AddMemery("于历练途中被一众合欢叛徒轮奸采补！");
		end
	else
		if me.npcObj.PropertyMgr.BodyData:PartIsBroken("Genitals") then
		me:AddMsg(XT("早已自宫的[NAME]男生女相，扮作凡女故意被合欢叛徒掳走，合欢叛徒欲采补[NAME]之时却发现[NAME]竟是个太监，故将[NAME]打了一顿后扔出了驻地"));
		else
		me:AddMsg(XT("[NAME]是个铁铮铮的硬汉子，合欢叛徒也不是智障，此事只得作罢。"));
		end
	end
end

function Hudong:shiqi4()
if me:GetGLevel() > 6 then
	me:AddMsg(XT("[NAME]直接杀向合欢弟子据点，国士无双勇不可当，只有少量合欢叛徒趁乱逃走了。"));me:AddSchoolScore(2,100);me:AddSchoolRelation(11,150);
	else
		if me:GetSex() > 1 then
		me:AddMsg(XT("[NAME]道法不精，被合欢弟子所击败，合欢弟子见色起意，将[NAME]削断四肢当成肉枕玩弄了一番后丢弃了，此事于合欢女修们知晓后，觉得本门全特么废物，便对本门的好感降低了。"));me.npcObj.PropertyMgr:AddFeature("Pogua");me:AddModifier("Story_Caibuzhidao2");me:AddSchoolRelation(11,-150);me:AddSchoolScore(1,-200);me:AddDamage("Fabao_CutOff","LeftScapula", 1, XT("斩断"));me:AddDamage("Fabao_CutOff","RightScapula", 1, XT("斩断"));me:AddDamage("Fabao_CutOff","LeftThighbone", 1, XT("斩断"));me:AddDamage("Fabao_CutOff","RightThighbone", 1, XT("斩断"));me:AddMemery("在历练途中不慎被合欢叛徒所擒获，后被斩断四肢作为肉枕玩弄！");me:AddTitle(XT("肉枕"),string.format(XT("于%s年历练途中，被人斩断四肢作为肉枕饲养玩弄！"),4));
		else
			me:AddMsg(XT("[NAME]道法不精，被合欢弟子所击败后砍成了人棍，此事于合欢女修们知晓后，觉得本门全特么废物，便对本门的好感降低了。"));me:AddSchoolRelation(11,-150);me:AddSchoolScore(1,-200);me:AddDamage("Fabao_CutOff","LeftScapula", 1, XT("斩断"));me:AddDamage("Fabao_CutOff","RightScapula", 1, XT("斩断"));me:AddDamage("Fabao_CutOff","LeftThighbone", 1, XT("斩断"));me:AddDamage("Fabao_CutOff","RightThighbone", 1, XT("斩断"));
		end
	end
end

function Hudong:shiqi5()
	if me:GetSex() == 2 or me.npcObj.PropertyMgr.BodyData:PartIsBroken("Genitals") then
	me:AddMsg("女性太监线未完成，而且女人没屌，你哪里来的龙根标签。\n如果是太监来参加合欢支线……作者只能说你好棒棒，特地拿个有龙根还没屌的人来找bug，优秀！");
	else
	me:AddMsg("[NAME]决定参与入门试炼混入合欢宗。");
	me:TriggerStory("Ludingxiuxianji1");
	end
end

function Hudong:shiqi6()
	if me:GetSex() > 1 then
	me:AddMsg(XT("[NAME]是个女人，合欢宗的女修又不是脑瘫，无遮大会自然与[NAME]毫无关系。"));
	else
		if me:GetCharisma() > 7 then
		me:AddMsg(XT("[NAME]凭借着不俗的外表赢了的一位合欢女修的关注，那位女修向[NAME]走来。"));me:TriggerStory("Secrets_wuzhendahui1");
		else
		me:AddMsg(XT("舔狗或许有资格成为炉鼎，但是丑比绝对没有，这次无遮大会没有任何合欢女修看上了[NAME]，毕竟就算是挑采补的炉鼎，也要选那些长得还不错的炉鼎。"));
		end
	end
end

function Hudong:shiqi7()
	if me.npcObj.PropertyMgr.BodyData:PartIsBroken("Genitals") then
	me:AddMsg(XT("[NAME]连忙点头称诺，最后便于那女修进入山门，一入合欢山门，那真是若梦似幻，着眼之下便是那一众青衣婢子也堪得上秀色可餐。"));
	me:AddMsg(XT("在一路欣赏燕瘦环肥的美景之后，[NAME]跟随合欢女修来到了一间宽大的卧室，女修将[NAME]推入房门，便开始上下其手对[NAME]撩拨了起来，直到那纤纤玉手游走到了原本应该矗立着一支擎天白玉柱的方位。"));
	me:AddMsg(XT("“你这是在找死！”那五条应该缠绕着白玉擎天柱的绕指柔蛇瞬间化催魂夺命的百炼钢刀，直接斩断[NAME]一臂，并将其赶出宗门。"));me:AddSchoolRelation(11,-150);me:AddSchoolScore(1,-200);me:AddDamage("Fabao_CutOff","AllHead", 1, XT("打穿"));
	else
		if me:GetPhysique() > 7 then
		me:AddMsg(XT("[NAME]连忙点头称诺，最后便于那女修进入山门，一入合欢山门，那真是若梦似幻，着眼之下便是那一众青衣婢子也堪得上秀色可餐。"));
		me:AddMsg(XT("在一路欣赏燕瘦环肥的美景之后，[NAME]跟随合欢女修来到了一间宽大的卧室，女修将[NAME]推入房门，便开始上下其手对[NAME]撩拨了起来，[NAME]胯下的擎天玉柱也支立了起来，适时[NAME]只感胯下玉柱被数条灵蛇所绕，灵蛇上下翻飞所经之地处皆留下蛇腹的清凉与些许蛇身环勒所带来的烧灼感。"));me:TriggerStory("Secrets_wuzhendahui3");
		else
		me:AddMsg(XT("[NAME]连忙点头称诺，最后便于那女修进入山门，一入合欢山门，那真是若梦似幻，着眼之下便是那一众青衣婢子也堪得上秀色可餐。"));
		me:AddMsg(XT("在一路欣赏燕瘦环肥的美景之后，[NAME]跟随合欢女修来到了一间宽大的卧室，女修将[NAME]推入房门，便开始上下其手对[NAME]撩拨了起来，[NAME]胯下的擎天玉柱也支立了起来，适时[NAME]只感胯下玉柱被数条灵蛇所绕，灵蛇上下翻飞所经之地处皆留下蛇腹的清凉与些许蛇身环勒所带来的烧灼感。"));
		me:AddMsg(XT("女修超绝的手法是[NAME]从未经历过的，一时快意上涌直冲百汇。"));me:TriggerStory("Secrets_wuzhendahui2");
		end
	end
end

function Hudong:shiqi8()
me:AddMsg(XT("女修怒叱一声“废物”后，伏下身子张口含住那微微软倒的玉柱，香舌或提或挑，又不时化身泥鳅一般抵着[NAME]的马眼便是一通钻弄，[NAME]的玉柱再次立起，却仅仅只坚持了数个呼吸，便溃不成军一泻千里。\n数轮快意过后，[NAME]的玉柱早已应该喷吐不出任何精元了，然而[NAME]惊恐的发现，随着一轮又一轮的快意，自己的玉柱依旧随着快意在向外倾泻着体液，直到一次较大的喷泄后，女修的嘴角渗出了些许猩红，[NAME]才知道自己或许应该命不久矣。"));
me:AddMsg(XT("被采补一空后的[NAME]，面无血色形同枯槁，与一些同样被采废的炉鼎一起被赶出了合欢宗"));me:AddDamage("Mu_Failure","Heart", 1, XT("心脉精血皆被合欢宗女修采补一空干涸"));me:AddDamage("Mu_Failure","TheWholeBody", 1, XT("全身精血皆被合欢宗女修采补一空干涸"));
end

function Hudong:shiqi9()
me:AddMsg(XT("正所谓他强任他强清风拂山冈，他横由他横明月照大江，任凭合欢女修千般挑弄，[NAME]就是闭锁精关巍然不动，合欢女修见只靠手口无法使得[NAME]的小兄弟俯首称臣，只得褪尽罗衫。\n见眼前女修褪下衣衫，[NAME]高笑一声便欺身上前，将女修按倒在榻机之上。直接提枪跨马冲杀入那桃源大阵，[NAME]胯下巨兽凶蛮的直冲幽径深处直捣黄龙，而后便是毫无所谓技术的一顿猪突猛进，可谓是枪枪见底。"));
me:AddMsg(XT("出生于合欢宗的女修，虽也算的上身经百战，但如此强悍的攻势还是第一次遇上，对方那竿长枪真能算说是枪枪到肉，每次插入都仿佛一根烧红的铁棍由下而上贯入子宫，而那毫不留情抽出则仿佛要将自己整个灵魂都从身体里抽出。"));me:TriggerStory("Secrets_wuzhendahui4");
end

function Hudong:shiqi10()
me:AddMsg(XT("月上柳梢头，人，对人，嗯那个人，人已经被[NAME]胯下的凶兽所完全征服，这自称银灵儿的合欢女修跪倒在机塌之前，用这口中三寸软香清洁着[NAME]的下身。\n“银灵儿，你这舔的老子又有感觉了！”言毕，[NAME]便又提起胯下这温香软玉往塌上一按，对着那看似好像完全未经人事的谷道便是奋力一刺。"));
me:AddMsg(XT("只听身下人儿惨呼一声，[NAME]那又管的许多，这未经开发的谷道便如同拥有无数守护者一般，对侵入自己地盘[NAME]胯下的凶器便是一顿压挤，企图将这入侵者赶出自己的领地，而这一份压迫力对于[NAME]来说更是无比欢畅的激励，直到再次抽插了近千下，[NAME]终于阳关大开，一身精元注入银灵儿的谷道后，就这么沉沉的睡去。"));me:TriggerStory("Secrets_wuzhendahui5");
end

function Hudong:shiqi11()
me:AddMsg(XT("[NAME]伸手翻开了左边的匣子，一本秘籍出现在匣子底部，[NAME]取出了这本秘籍，打算去开另一个匣子时，发现怎么都打不开另外一个匣子，[NAME]带着秘籍离开了合欢岛。"));
me:LearnEsotericCustomize(XT("六欲密典之"), me:GetGElementKind(), 0, true, world:RandomFloat(1,1.5), 1, 1, XT("巨量的"));
end

function Hudong:shiqi12()
me:AddMsg(XT("[NAME]伸手翻开了右边的匣子，发现匣底是一个白玉制成的小碗，碗中陈放着淡金色的药液，药液有着淡淡死鲨鱼的味道，取出玉碗。"));
me:TriggerStory("Secrets_wuzhendahui6");
end

function Hudong:shiqi13()
me:AddMsg(XT("“俗话说的好，良药苦口利于病”[NAME]暗自呢喃道，这液体虽然闻起来不怎么样，但说不定高级灵药就是这气味的呢，言毕[NAME]便将金色的液体吞服入腹。"));
me:AddMsg(XT("药液入腹，一股无比庞大的灵气在[NAME]腹中炸裂开来，[NAME]自叹“吾命休矣”，确没想到炸裂开的灵气，一边狂暴的扩充着自身的经脉，一边滋养着因扩张经脉所带来的损伤"));
me:AddModifier("Story_Zhenxianlingye1");
me:AddTitle(XT("圣泉使"),string.format(XT("第%s年，成功在合欢宗无遮大会喝到女真仙下体的蜜液的男人！"),4));
end

function Hudong:shiqi14()
me:AddMsg("[NAME]挑选了了一个男性俘虏，张开双腿指着自己下身的蜜穴，对方四肢着地顺从的爬到了[NAME]身前轻吻着[NAME]芳足等待着下一个指示\n[NAME]:“上来！”。\n得到指示的男性俘虏便在[NAME]身上奋力耕耘了起来。\n事毕，[NAME]带着满穴精元心满意足的离开了。");
me.npcObj.PropertyMgr:AddFeature("Pogua");
me:AddPracticeResource("Stage",me:GetGLevel() * 250);
end

function Hudong:shiqi15()
me:AddMsg("细细的娇喘声如水溪流过，声音柔合而又娇媚，让人想入非非，[NAME]轻揉着年幼女奴娇嫩的乳房，山峰顶端的蓓蕾呈粉红色挺立着，蓓蕾随着[NAME]猛烈的抽插动作颤抖，身下的人儿婉转娇啼，如初春的燕子：“快点......... 快！.......... 再快点！......... 啊~！公子你好....... 好厉害”……\n事毕，[NAME]将阳精灌入了对方娇嫩的下体后，心满意足的睡去了。");
end

function Hudong:shiqi16()
me:AddModifier("Luding");
local Fulu = me:GetModifierStack("Luding");
local buff = me.npcObj.PropertyMgr:FindModifier("Luding");
me:AddModifier("Story_Caibuzhidao1");
local buff2 = me.npcObj.PropertyMgr:FindModifier("Story_Caibuzhidao1");
local Panding = me:RandomInt(1,5);
	if Fulu >= 11 and Panding == 4 then
	me:AddMsg("[NAME]决定在据点来一次个人的采补盛宴，她从俘虏中挑出了十名普通男性，与他们逐一欢好，将他们浑身精元采补一空。\n事毕，诸男均化为干尸被遗弃在据点中的苗圃一角，用于肥田，见到时候已经不早，[NAME]御剑向山门归去。。");
	me.npcObj.PropertyMgr:AddFeature("Pogua");
	buff:UpdateStack(-Panding);
	buff2:UpdateStack(9);
	elseif Fulu >= 4 and Panding == 3 then
	me:AddMsg("[NAME]从俘虏中挑出了三名普通男性，与他们逐一欢好，将他们浑身精元采补一空。\n事毕，诸男均化为干尸被遗弃在据点中的苗圃一角，用于肥田，见到时候已经不早，[NAME]御剑向山门归去。。");
	me.npcObj.PropertyMgr:AddFeature("Pogua");
	buff:UpdateStack(-Panding);
	buff2:UpdateStack(2);
	elseif Fulu >= 3 and Panding == 2 then
	me:AddMsg("[NAME]从俘虏中挑出了两名普通男性，与他们逐一欢好，将他们浑身精元采补一空。\n事毕，诸男均化为干尸被遗弃在据点中的苗圃一角，用于肥田，见到时候已经不早，[NAME]御剑向山门归去。。");
	me.npcObj.PropertyMgr:AddFeature("Pogua");
	buff:UpdateStack(-Panding);
	buff2:UpdateStack(1);
	elseif Fulu >= 2 and Panding == 1 then
	me:AddMsg("[NAME]从俘虏中挑出了一名普通男性，与他欢好，将他浑身精元采补一空。\n事毕，此男化为干尸被遗弃在据点中的苗圃一角，用于肥田，见到时候已经不早，[NAME]御剑向山门归去。。");
	me.npcObj.PropertyMgr:AddFeature("Pogua");
	buff:UpdateStack(-Panding);
	elseif Fulu >= 2 then
	me:AddMsg("[NAME]从俘虏中挑出了一名普通男性，与他欢好，将他浑身精元采补一空。\n事毕，此男化为干尸被遗弃在据点中的苗圃一角，用于肥田，见到时候已经不早，[NAME]御剑向山门归去。。");
	me.npcObj.PropertyMgr:AddFeature("Pogua");
	buff:UpdateStack(-1);
	else
	me:AddMsg("[NAME]没有普通男性俘虏");
	me:TriggerStory("Secrets_xiangyong_1");
	buff2:UpdateStack(-1);
	end
	buff:UpdateStack(-1);
end

function Hudong:shiqi17()
me:AddModifier("Luding3");
local Fulu = me:GetModifierStack("Luding3");
local buff = me.npcObj.PropertyMgr:FindModifier("Luding3");
me:AddModifier("Story_Caibuzhidao1");
local buff2 = me.npcObj.PropertyMgr:FindModifier("Story_Caibuzhidao1");
local Panding = me:RandomInt(1,5);
	if Fulu >= 11 and Panding == 4 then
	me:AddMsg("[NAME]决定在据点来一次个人的采补盛宴，她从俘虏中挑出了十名俊美男性，与他们逐一欢好，将他们浑身精元采补一空。\n事毕，诸男均化为干尸被遗弃在据点中的苗圃一角，用于肥田，见到时候已经不早，[NAME]御剑向山门归去。。");
	me.npcObj.PropertyMgr:AddFeature("Pogua");
	buff:UpdateStack(-Panding);
	buff2:UpdateStack(9);
	elseif Fulu >= 4 and Panding == 3 then
	me:AddMsg("[NAME]从俘虏中挑出了三名俊美男性，与他们逐一欢好，将他们浑身精元采补一空。\n事毕，诸男均化为干尸被遗弃在据点中的苗圃一角，用于肥田，见到时候已经不早，[NAME]御剑向山门归去。。");
	me.npcObj.PropertyMgr:AddFeature("Pogua");
	buff:UpdateStack(-Panding);
	buff2:UpdateStack(2);
	elseif Fulu >= 3 and Panding == 2 then
	me:AddMsg("[NAME]从俘虏中挑出了两名俊美男性，与他们逐一欢好，将他们浑身精元采补一空。\n事毕，诸男均化为干尸被遗弃在据点中的苗圃一角，用于肥田，见到时候已经不早，[NAME]御剑向山门归去。。");
	me.npcObj.PropertyMgr:AddFeature("Pogua");
	buff:UpdateStack(-Panding);
	buff2:UpdateStack(1);
	elseif Fulu >= 2 and Panding == 1 then
	me:AddMsg("[NAME]从俘虏中挑出了一名俊美男性，与他欢好，将他浑身精元采补一空。\n事毕，此男化为干尸被遗弃在据点中的苗圃一角，用于肥田，见到时候已经不早，[NAME]御剑向山门归去。。");
	me.npcObj.PropertyMgr:AddFeature("Pogua");
	buff:UpdateStack(-Panding);
	elseif Fulu >= 2 then
	me:AddMsg("[NAME]从俘虏中挑出了一名俊美男性，与他欢好，将他浑身精元采补一空。\n事毕，此男化为干尸被遗弃在据点中的苗圃一角，用于肥田，见到时候已经不早，[NAME]御剑向山门归去。。");
	me.npcObj.PropertyMgr:AddFeature("Pogua");
	buff:UpdateStack(-1);
	else
	me:AddMsg("[NAME]没有俊美的男性俘虏");
	me:TriggerStory("Secrets_xiangyong_1");
	buff2:UpdateStack(-1);
	end
	buff:UpdateStack(-1);
end

function Hudong:shiqi18()
me:AddModifier("Luding5");
local Fulu = me:GetModifierStack("Luding5");
local buff = me.npcObj.PropertyMgr:FindModifier("Luding5");
me:AddModifier("Story_Caibuzhidao1");
local buff2 = me.npcObj.PropertyMgr:FindModifier("Story_Caibuzhidao1");
local Panding = me:RandomInt(1,5);
	if Fulu >= 11 and Panding == 4 then
	me:AddMsg("[NAME]决定在据点来一次个人的采补盛宴，她从俘虏中挑出了十名男性修士，与他们逐一欢好，将他们浑身精元采补一空。\n事毕，诸男均化为干尸被遗弃在据点中的苗圃一角，用于肥田，见到时候已经不早，[NAME]御剑向山门归去。。");
	me.npcObj.PropertyMgr:AddFeature("Pogua");
	buff:UpdateStack(-Panding);
	buff2:UpdateStack(19);
	elseif Fulu >= 4 and Panding == 3 then
	me:AddMsg("[NAME]从俘虏中挑出了三名男性修士，与他们逐一欢好，将他们浑身精元采补一空。\n事毕，诸男均化为干尸被遗弃在据点中的苗圃一角，用于肥田，见到时候已经不早，[NAME]御剑向山门归去。。");
	me.npcObj.PropertyMgr:AddFeature("Pogua");
	buff:UpdateStack(-Panding);
	buff2:UpdateStack(5);
	elseif Fulu >= 3 and Panding == 2 then
	me:AddMsg("[NAME]从俘虏中挑出了两名男性修士，与他们逐一欢好，将他们浑身精元采补一空。\n事毕，诸男均化为干尸被遗弃在据点中的苗圃一角，用于肥田，见到时候已经不早，[NAME]御剑向山门归去。。");
	me.npcObj.PropertyMgr:AddFeature("Pogua");
	buff:UpdateStack(-Panding);
	buff2:UpdateStack(3);
	elseif Fulu >= 2 and Panding == 1 then
	me:AddMsg("[NAME]从俘虏中挑出了一名男性修士，与他欢好，将他浑身精元采补一空。\n事毕，此男化为干尸被遗弃在据点中的苗圃一角，用于肥田，见到时候已经不早，[NAME]御剑向山门归去。。");
	me.npcObj.PropertyMgr:AddFeature("Pogua");
	buff:UpdateStack(-Panding);
	buff2:UpdateStack(1);
	elseif Fulu >= 2 then
	me:AddMsg("[NAME]从俘虏中挑出了一名男性修士，与他欢好，将他浑身精元采补一空。\n事毕，此男化为干尸被遗弃在据点中的苗圃一角，用于肥田，见到时候已经不早，[NAME]御剑向山门归去。。");
	me.npcObj.PropertyMgr:AddFeature("Pogua");
	buff:UpdateStack(-1);
	buff2:UpdateStack(1);
	else
	me:AddMsg("[NAME]没有男性修士俘虏");
	me:TriggerStory("Secrets_xiangyong_1");
	buff2:UpdateStack(-1);
	end
	buff:UpdateStack(-1);
end

function Hudong:shiqi19()
me:AddModifier("Luding2");
local Fulu = me:GetModifierStack("Luding2");
local buff = me.npcObj.PropertyMgr:FindModifier("Luding2");
me:AddModifier("Story_Caibuzhidao1");
local buff2 = me.npcObj.PropertyMgr:FindModifier("Story_Caibuzhidao1");
local Panding = me:RandomInt(1,5);
	if Fulu >= 11 and Panding == 4 then
	me:AddMsg("[NAME]决定在据点来一次个人的采补盛宴，她从俘虏中挑出了十名普通女性，与他们逐一欢好，将他们浑身精元采补一空。\n事毕，诸女均化为干尸被遗弃在据点中的苗圃一角，用于肥田，见到时候已经不早，[NAME]御剑向山门归去。。");
	buff:UpdateStack(-Panding);
	buff2:UpdateStack(9);
	elseif Fulu >= 4 and Panding == 3 then
	me:AddMsg("[NAME]从俘虏中挑出了三名普通女性，与他们逐一欢好，将他们浑身精元采补一空。\n事毕，诸女均化为干尸被遗弃在据点中的苗圃一角，用于肥田，见到时候已经不早，[NAME]御剑向山门归去。。");
	buff:UpdateStack(-Panding);
	buff2:UpdateStack(2);
	elseif Fulu >= 3 and Panding == 2 then
	me:AddMsg("[NAME]从俘虏中挑出了两名普通女性，与他们逐一欢好，将他们浑身精元采补一空。\n事毕，诸女均化为干尸被遗弃在据点中的苗圃一角，用于肥田，见到时候已经不早，[NAME]御剑向山门归去。。");
	buff:UpdateStack(-Panding);
	buff2:UpdateStack(1);
	elseif Fulu >= 2 and Panding == 1 then
	me:AddMsg("[NAME]从俘虏中挑出了一名普通女性，与他欢好，将他浑身精元采补一空。\n事毕，此女化为干尸被遗弃在据点中的苗圃一角，用于肥田，见到时候已经不早，[NAME]御剑向山门归去。。");
	buff:UpdateStack(-Panding);
	elseif Fulu >= 2 then
	me:AddMsg("[NAME]从俘虏中挑出了一名普通女性，与他欢好，将他浑身精元采补一空。\n事毕，此女化为干尸被遗弃在据点中的苗圃一角，用于肥田，见到时候已经不早，[NAME]御剑向山门归去。。");
	buff:UpdateStack(-1);
	else
	me:AddMsg("[NAME]没有普通男女俘虏");
	me:TriggerStory("Secrets_xiangyong_1");
	buff2:UpdateStack(-1);
	end
	buff:UpdateStack(-1);
end

function Hudong:shiqi20()
me:AddModifier("Luding4");
local Fulu = me:GetModifierStack("Luding4");
local buff = me.npcObj.PropertyMgr:FindModifier("Luding4");
me:AddModifier("Story_Caibuzhidao1");
local buff2 = me.npcObj.PropertyMgr:FindModifier("Story_Caibuzhidao1");
local Panding = me:RandomInt(1,5);
	if Fulu >= 11 and Panding == 4 then
	me:AddMsg("[NAME]决定在据点来一次个人的采补盛宴，她从俘虏中挑出了十名美貌女子，与他们逐一欢好，将他们浑身精元采补一空。\n事毕，诸女均化为干尸被遗弃在据点中的苗圃一角，用于肥田，见到时候已经不早，[NAME]御剑向山门归去。。");
	buff:UpdateStack(-Panding);
	buff2:UpdateStack(9);
	elseif Fulu >= 4 and Panding == 3 then
	me:AddMsg("[NAME]从俘虏中挑出了三名美貌女子，与他们逐一欢好，将他们浑身精元采补一空。\n事毕，诸女均化为干尸被遗弃在据点中的苗圃一角，用于肥田，见到时候已经不早，[NAME]御剑向山门归去。。");
	buff:UpdateStack(-Panding);
	buff2:UpdateStack(2);
	elseif Fulu >= 3 and Panding == 2 then
	me:AddMsg("[NAME]从俘虏中挑出了两名美貌女子，与他们逐一欢好，将他们浑身精元采补一空。\n事毕，诸女均化为干尸被遗弃在据点中的苗圃一角，用于肥田，见到时候已经不早，[NAME]御剑向山门归去。。");
	buff:UpdateStack(-Panding);
	buff2:UpdateStack(1);
	elseif Fulu >= 2 and Panding == 1 then
	me:AddMsg("[NAME]从俘虏中挑出了一名美貌女子，与他欢好，将他浑身精元采补一空。\n事毕，此女化为干尸被遗弃在据点中的苗圃一角，用于肥田，见到时候已经不早，[NAME]御剑向山门归去。。");
	buff:UpdateStack(-Panding);
	elseif Fulu >= 2 then
	me:AddMsg("[NAME]从俘虏中挑出了一名美貌女子，与他欢好，将他浑身精元采补一空。\n事毕，此女化为干尸被遗弃在据点中的苗圃一角，用于肥田，见到时候已经不早，[NAME]御剑向山门归去。。");
	buff:UpdateStack(-1);
	else
	me:AddMsg("[NAME]没有美貌女子俘虏");
	me:TriggerStory("Secrets_xiangyong_1");
	buff2:UpdateStack(-1);
	end
	buff:UpdateStack(-1);
end

function Hudong:shiqi21()
me:AddModifier("Luding6");
local Fulu = me:GetModifierStack("Luding6");
local buff = me.npcObj.PropertyMgr:FindModifier("Luding6");
me:AddModifier("Story_Caibuzhidao1");
local buff2 = me.npcObj.PropertyMgr:FindModifier("Story_Caibuzhidao1");
local Panding = me:RandomInt(1,5);
	if Fulu >= 11 and Panding == 4 then
	me:AddMsg("[NAME]决定在据点来一次个人的采补盛宴，她从俘虏中挑出了十名女修士，与他们逐一欢好，将他们浑身精元采补一空。\n事毕，诸女均化为干尸被遗弃在据点中的苗圃一角，用于肥田，见到时候已经不早，[NAME]御剑向山门归去。。");
	buff:UpdateStack(-Panding);
	buff2:UpdateStack(19);
	elseif Fulu >= 4 and Panding == 3 then
	me:AddMsg("[NAME]从俘虏中挑出了三名女修士，与他们逐一欢好，将他们浑身精元采补一空。\n事毕，诸女均化为干尸被遗弃在据点中的苗圃一角，用于肥田，见到时候已经不早，[NAME]御剑向山门归去。。");
	buff:UpdateStack(-Panding);
	buff2:UpdateStack(5);
	elseif Fulu >= 3 and Panding == 2 then
	me:AddMsg("[NAME]从俘虏中挑出了两名女修士，与他们逐一欢好，将他们浑身精元采补一空。\n事毕，诸女均化为干尸被遗弃在据点中的苗圃一角，用于肥田，见到时候已经不早，[NAME]御剑向山门归去。。");
	buff:UpdateStack(-Panding);
	buff2:UpdateStack(3);
	elseif Fulu >= 2 and Panding == 1 then
	me:AddMsg("[NAME]从俘虏中挑出了一名女修士，与他欢好，将他浑身精元采补一空。\n事毕，此女化为干尸被遗弃在据点中的苗圃一角，用于肥田，见到时候已经不早，[NAME]御剑向山门归去。。");
	buff:UpdateStack(-Panding);
	buff2:UpdateStack(1);
	elseif Fulu >= 2 then
	me:AddMsg("[NAME]从俘虏中挑出了一名女修士，与他欢好，将他浑身精元采补一空。\n事毕，此女化为干尸被遗弃在据点中的苗圃一角，用于肥田，见到时候已经不早，[NAME]御剑向山门归去。。");
	buff:UpdateStack(-1);
	buff2:UpdateStack(1);
	else
	me:AddMsg("[NAME]没有女修士俘虏");
	me:TriggerStory("Secrets_xiangyong_1");
	buff2:UpdateStack(-1);
	end
	buff:UpdateStack(-1);
end

function Hudong:shiqi22()
me:AddModifier("Qian");
local Fulu = me:GetModifierStack("Qian");
local buff = me.npcObj.PropertyMgr:FindModifier("Qian");
	if Fulu >= 5 then
		if me:GetSex() == 1 then
			if me.npcObj.PropertyMgr.BodyData:PartIsBroken("Genitals") then
			me:AddMsg("龟公将[NAME]引入了一间厢房，妓子随后便到，可惜[NAME]是个太监，只能把妓子搂入怀中上下把玩一番。\n事毕，[NAME]便离开了妓馆。");
			me.npcObj.PropertyMgr:AddFeature("Pogua");
			elseif me:GetGongName() == "Gong_1701_Tu" then
			me:AddMsg("龟公将[NAME]引入了一间厢房，妓子随后便到，可惜[NAME]把妓子搂入怀中，掏出胯下肉棒，插入妓子肉穴上下翻飞巫山几度，待妓子泄身神色迷离之际，[NAME]运起功法将妓子采补一番。\n事毕，[NAME]便离开了妓馆，[NAME]感觉自身的修为提升了。");
			me:AddPracticeResource("Stage",me:GetGLevel() * 500);
			else
			me:AddMsg("龟公将[NAME]引入了一间厢房，妓子随后便到，可惜[NAME]把妓子搂入怀中，掏出胯下肉棒，插入妓子肉穴上下翻飞巫山几度。\n事毕，[NAME]便离开了妓馆。");
			end
		else
		me:TriggerStory("Guigong_jujuenv");
		end
	else
		if me.npcObj.PropertyMgr.BodyData:PartIsBroken("Genitals") then
		me:AddMsg("[NAME]摸了摸口袋，又摸了摸下身心道一句：“既没屌也没钱……这个地方与我无缘”便转身离去了。");
		me:TriggerStory("Huajieliuxiang");
		else
		me:TriggerStory("Guigong_jujuenan");
		end
	end
	buff:UpdateStack(-1);
end

function Hudong:shiqi23()
local JLEHG = me:GetModifierStack("Jinlinger");
	if JLEHG >= 80 then
		if me:GetSex() == 1 then
		me:AddMsg("尚未等[NAME]开口，阁楼中则已传出那个清甜好听的声音：“奴家待公子多时了！”。鸨母闻言退至一边让[NAME]上楼与金铃儿欢好，一夕风流。");
		else
		me:AddMsg("尚未等[NAME]开口，阁楼中则已传出那个清甜好听的声音：“奴家待小姐多时了！”。鸨母闻言退至一边让[NAME]上楼与金铃儿欢好，一夕风流。");
		end
		world:SetWorldFlag(1702,1)
		me:TriggerStory("NPC_Jinlinger");
	else
	me:AddModifier("Jinlinger");
	local buff = me.npcObj.PropertyMgr:FindModifier("Jinlinger");
		if me:GetSex() == 2 then
			if me:GetModifierStack("Story_Caibuzhidao1") >= 100 then
			me:AddMsg("[NAME]高呼：“自古佳人配英雄，本姑娘觉得自己算是个女中豪杰，金铃儿小姐可愿一见？”\n只闻阁楼中传来一阵银铃般的轻笑后房门自动弹开，[NAME]信步进入阁楼，突觉灵气被封无法调用，暗道一声“不好！”便打算退出房间，却被房中的长发女子伸手拦住，女子笑道：“姐姐莫慌，奴家只是试试姐姐。”言毕便轻鼓两掌唤来数名手持双头龙或是角先生的女子，/n一夕狂欢之后，诸女均败于[NAME]身下。");
			buff:UpdateStack(99);
			else
			me:AddMsg("[NAME]高呼：“自古佳人配英雄，本姑娘觉得自己算是个女中豪杰，金铃儿小姐可愿一见？”\n只闻阁楼中传来一阵银铃般的轻笑后房门自动弹开，[NAME]信步进入阁楼，突觉灵气被封无法调用，暗道一声“不好！”便打算退出房间，却被房中的长发女子伸手拦住，女子笑道：“姐姐莫慌，奴家只是试试姐姐。”言毕便轻鼓两掌唤来数名手持双头龙或是角先生的女子。/n一夕狂欢之后，[NAME]被诸女弄的欲生欲死意乱神迷后，金铃儿只是不满的说了一句：“抬下去罢”，[NAME]便被抬出了阁楼。");
			end
		else
			if me.npcObj.PropertyMgr.BodyData:PartIsBroken("Genitals") then
			me:AddMsg("[NAME]暗道一句：“我特么是个太监，我展现什么实力啊……”便转身离开了。");
			me:TriggerStory("Wanhualou");
			elseif me:GetPhysique() > 9 then
			me:AddMsg("[NAME]高呼：“自古佳人配英雄，本公子觉得自己算得当世豪杰，金铃儿小姐可愿一见？”\n只闻阁楼中传来一阵银铃般的轻笑：“这个你得问妈妈”，[NAME]只觉手臂上一紧，便听那鸨母一句：“公子请吧！”\n欲见花魁没想到要先日这肥婆鸨母，不知什么坚定了[NAME]的决心，[NAME]与那肥婆鸨母大战百余回合后终于获得了胜利，然而眼下也着实没有什么兴趣了，只到金铃儿阁楼下高呼一句：“今日公子打道回府了，希望下次得小姐垂帘”，便转身离去了。");
			buff:UpdateStack(5);
			else
			me:AddMsg("[NAME]高呼：“自古佳人配英雄，本公子觉得自己算得当世豪杰，金铃儿小姐可愿一见？”\n只闻阁楼中传来一阵银铃般的轻笑：“这个你得问妈妈”，[NAME]只觉手臂上一紧，便听那鸨母一句：“公子请吧！”\n欲见花魁没想到要先日这肥婆鸨母，不知什么坚定了[NAME]的决心，[NAME]与那肥婆鸨母大战百余回合后败下阵来，迷离之间只听门外传来一句：“这般废物还自称豪杰，抬下去罢”，[NAME]便被扔到了花街之上。");
			end
		end
		buff:UpdateStack(-1);
	end
end

function Hudong:shiqi24()
	if me:GetGLevel() > 6 then
	me:AddMsg("[NAME]定睛一看对方竟然将自己指向管理妓女的鸨母，不由得怒从心起，喝骂道:“你这狗一样的腌赞泼才，睁大你的狗眼看好了，姑奶奶乃是金丹（元婴）真人，还不速速去把姑娘找来！”。\n那龟公却面不改色道:“就算是金丹（元婴）真人，也不能坏了行规！”。\n[NAME]大怒，身上五彩霞光一现已经祭出法宝，赫然是一八宝七彩六欲五行四相混元琉璃双头龙，只见她单手戟指龟公:“你莫不是来消遣姑奶奶的”，言毕便操使法宝一番打砸后恐合欢宗强者的支援，便逃离了现场。\n万花楼乃合欢宗产业，由于[NAME]实力强横，所以驻守于此的合欢弟子没有跳出来找死，却还是将此事件回禀宗门。");
	me:AddSchoolRelation(11,-500);
	else
	me:AddMsg("[NAME]定睛一看对方竟然将自己指向管理妓女的鸨母，不由得怒从心起，喝骂道:“你这狗一样的腌赞泼才，睁大你的狗眼看好了，姑奶奶乃是练气（结丹）修士，还不速速去把姑娘找来！”。\n那龟公却面不改色道:“就算是练气（结丹）修士，也不能坏了行规！”。\n[NAME]大怒，便欲祭出法宝打砸一番，却未曾想到转瞬间自己的护体灵气被人击碎，击碎自己护体灵气的赫然是一八宝七彩六欲五行四相混元琉璃双头龙，在昏死过去的一瞬之前，[NAME]只闻驭使此法宝的长发女修道:“什么玩意也赶来我合欢宗的场子寻死，瞧你略有几分姿色，便在我这接客百次抵罪吧”，言毕长发女修便封住[NAME]周身大穴将其交于鸨母。\n[NAME]于万花楼中，被迫接待了上百个嫖客后，重获了自由之身。");
	me:AddSchoolRelation(11,-50);
	me:AddTitle(XT("妓女"),string.format(XT("第%s年，因为在万花楼捣乱，被驻扎于此的合欢弟子击败后，强制接客百余人。"),4));
	me:AddMemery("在历练途中被迫当妓女接客百余人！");
	me.npcObj.PropertyMgr:AddFeature("Pogua");
	end
end

function Hudong:shiqi25()
me:AddModifier("Qian");
local Fulu = me:GetModifierStack("Qian");
local buff = me.npcObj.PropertyMgr:FindModifier("Qian");
	if Fulu >= 501 then
	me:AddMsg("[NAME]从袋中掏出了百两纹银：“这能不能让你万花楼规矩改改？”\n龟公依旧口中说着什么“咱这是合欢宗的正规场子，不接女客。”一面赔笑着拒绝了。\n恼怒之下[NAME]又掏出了四百两往柜台上一撂，话头未起龟公便躬下身子喊到“楼上的姑娘下来接豪客啦！”\n事实证明，有钱就是可以使鬼推磨，[NAME]与万花楼妓子们胡混了一夜，也因[NAME]的豪爽，合欢派对本门的好感提升了。");
	buff:UpdateStack(-500);
	me:AddSchoolRelation(11,50);
	elseif Fulu >= 101 then
	me:AddMsg("[NAME]从袋中掏出了百两纹银：“这能不能让你万花楼规矩改改？”\n龟公依旧口中说着什么“咱这是合欢宗的正规场子，不接女客。”一面赔笑着拒绝了。\n无奈之下[NAME]悻悻的离开了万花楼。");
	me:TriggerStory("Huajieliuxiang");
	else
	me:AddMsg("[NAME]摸了摸口袋，暗道一句：“没钱还是别装X了吧”便离开了万花楼”。");
	me:TriggerStory("Huajieliuxiang");
	end
	buff:UpdateStack(-1);
end

function Hudong:shiqi26()
if me:GetGLevel() > 6 then
	me:AddMsg("[NAME]闻言不由得怒从心起，喝骂道:“呔，你这狗一样的腌赞泼才，睁大你的狗眼看好了，本君乃是金丹（元婴）真人，还不速速去把姑娘找来！”。\n那龟公却面不改色道:“就算是金丹（元婴）真人，也不能白嫖是不！”。\n[NAME]怒极，拍案而起，只见二楼一道华光闪烁向自己袭来，[NAME]定睛一看那法宝赫然是一八宝七彩六欲五行四相混元琉璃双头龙，只见那长发女修伸手遥指[NAME]怒喝道:“你莫不是来我合欢宗的地头寻死的？”，言毕便操使法宝与[NAME]战作一团。\n乱战之下，合欢女修略逊一筹，被[NAME]寻得一个机会所败，[NAME]眼看四下混乱无比，心道一句：“还是走为上策吧”便携着自己的战利品，也就是那位战败的合欢女弟子，趁乱离开了万花楼。");
	me:AddSchoolRelation(11,-500);
	me:AddModifier("Luding6");
	else
	me:AddMsg("[NAME]闻言不由得怒从心起，喝骂道:“呔，你这狗一样的腌赞泼才，睁大你的狗眼看好了，本君乃是练气（结丹）修士，还不速速去把姑娘找来！”。\n那龟公却面不改色道:“就算是练气（结丹）真人，也不能白嫖是不！”。\n[NAME]怒极，拍案而起，只见二楼一道华光闪烁向自己袭来，[NAME]定睛一看那法宝赫然是一八宝七彩六欲五行四相混元琉璃双头龙，只见那长发女修伸手遥指[NAME]怒喝道:“你莫不是来我合欢宗的地头寻死的？”，言毕便操使法宝与[NAME]战作一团。\n数招过后，[NAME]略逊一筹，被合欢女修寻得一个机会催使法宝砸断了[NAME]四肢后带回房间享用了一番，直到[NAME]精元全被对方摄去后，被削成人棍的[NAME]才被丢出了万花楼。");
	me:AddSchoolRelation(11,-100);me:AddSchoolScore(1,-200);me:AddDamage("Fabao_CutOff","LeftScapula", 1, XT("砸断"));me:AddDamage("Fabao_CutOff","RightScapula", 1, XT("砸断"));me:AddDamage("Fabao_CutOff","LeftThighbone", 1, XT("砸断"));me:AddDamage("Fabao_CutOff","RightThighbone", 1, XT("砸断"));me:AddModifier("Story_Caibuzhidao2");
	end
end

function Hudong:shiqi27()
me:AddModifier("Qian");
local buff = me.npcObj.PropertyMgr:FindModifier("Qian");
	if me:GetSex() > 1 then
		if me:CheckFeature("Pogua") ~= true then
			if me:GetCharisma() > 9 then
			buff:UpdateStack(49999);
			local Fulu = me:GetModifierStack("Qian");
			me:AddMsg(string.format(XT("[NAME]打算卖身赚钱。\n[NAME]既有着惊世绝代的容貌，又是个修练有成的女修，还是个未经人事的处子。\n此等奇货自是引得万花楼内众嫖客哄抢竞价，最终一巨富以十万两白银夺得头筹一亲[NAME]香泽。\n事毕，刨去楼中抽成，[NAME]独得五万两白银，当前白银：%s两"), tostring(Fulu)));
			elseif me:GetCharisma() > 6 then
			buff:UpdateStack(14999);
			local Fulu = me:GetModifierStack("Qian");
			me:AddMsg(string.format(XT("[NAME]打算卖身赚钱。\n[NAME]长得清丽脱俗，又是个修练有成的女修，还是个未经人事的处子。\n此等特级货色自是引得万花楼内众嫖客哄抢竞价，最终一豪客以三万两白银夺得头筹一亲[NAME]香泽。\n事毕，刨去楼中抽成，[NAME]独得一万五千两白银，当前白银：%s两"), tostring(Fulu)));
			elseif me:GetCharisma() > 3 then
			buff:UpdateStack(4999);
			local Fulu = me:GetModifierStack("Qian");
			me:AddMsg(string.format(XT("[NAME]打算卖身赚钱。\n[NAME]长得平平无奇，可毕竟是个修练有成的女修，还是个未经人事的处子。\n此等高级货色自是引得万花楼内众嫖客哄抢竞价，最终一大户以一万两白银夺得头筹一亲[NAME]香泽。\n事毕，刨去楼中抽成，[NAME]独得五千两白银，当前白银：%s两"), tostring(Fulu)));
			else
			buff:UpdateStack(999);
			local Fulu = me:GetModifierStack("Qian");
			me:AddMsg(string.format(XT("[NAME]打算卖身赚钱。\n[NAME]长得着实丑陋，可毕竟是个修练有成的女修，还是个未经人事的处子。\n虽然这种长相在万花楼里刷马桶都不配，可毕竟取女修的处子之身据说能壮阳延命，最终一地主以两千两白银夺得头筹一亲[NAME]香泽。\n事毕，刨去楼中抽成，[NAME]独得一千两白银，当前白银：%s两"), tostring(Fulu)));
			end
			me.npcObj.PropertyMgr:AddFeature("Pogua");
			me.npcObj.PropertyMgr:AddFeature("WHLjinv")
		else
			if me:GetCharisma() > 9 then
			buff:UpdateStack(99);
			local Fulu = me:GetModifierStack("Qian");
			me.npcObj.PropertyMgr:AddFeature("WHLjinv")
			me:AddMsg(string.format(XT("[NAME]打算卖身赚钱。\n[NAME]既有着惊世绝代的容貌，又是个修练有成的女修，虽然处子之身不在但是谁又不想日此等绝美的女神仙呢，哄抢之下一嫖客以两百两白银夺得头筹一亲[NAME]香泽。\n事毕，刨去楼中抽成，[NAME]独得一百两白银，当前白银：%s两"), tostring(Fulu)));
			elseif me:GetCharisma() > 6 then
			buff:UpdateStack(49);
			local Fulu = me:GetModifierStack("Qian");
			me.npcObj.PropertyMgr:AddFeature("WHLjinv")
			me:AddMsg(string.format(XT("[NAME]打算卖身赚钱。\n[NAME]长得清丽脱俗，又是个修练有成的女修，虽然处子之身不在但是谁又不想日好看的女神仙呢，哄抢之下一嫖客以一百两白银夺得头筹一亲[NAME]香泽。\n事毕，刨去楼中抽成，[NAME]独得一百两白银，当前白银：%s两"), tostring(Fulu)));
			elseif me:GetCharisma() > 3 then
			buff:UpdateStack(24);
			local Fulu = me:GetModifierStack("Qian");
			me.npcObj.PropertyMgr:AddFeature("WHLjinv")
			me:AddMsg(string.format(XT("[NAME]打算卖身赚钱。\n[NAME]长得平平无奇，可毕竟是个修练有成的女修，虽然处子之身不在但是至少是日那高高在上的女神仙啊，不花太多钱总不是太亏的，哄抢之下一嫖客以五十两白银夺得头筹一亲[NAME]香泽。\n事毕，刨去楼中抽成，[NAME]独得二十五两白银，当前白银：%s两"), tostring(Fulu)));
			else
			me:AddMsg(string.format(XT("[NAME]打算卖身赚钱。\n[NAME]长得着实丑陋，可毕竟是个修练有成的女修，虽然处子之身不在但自己毕竟是个凡人眼中的女神仙啊[NAME]觉得自己还是能卖的。\n奈何这个看脸的修真界，那该死的老鸨居然拒绝了[NAME]的兼职……\n当前白银：%s两"), tostring(Fulu)));
			end
		end
	else
	me:AddMsg("上下打量了一番[NAME]冷笑道：“这位公子，我们这可是合欢宗的正规场子，只做正当的皮肉生意，这边不接受搞基比剑的嗷！”。\n万花楼只收女性兼职人员，[NAME]只能无奈的离开了。");
	me:TriggerStory("Huajieliuxiang");
	end
end

function Hudong:shiqi28()
	if me:GetProperty("NpcLingMaxValue") > 8000 then
	me:AddMsg(XT("到了夜晚，终于到了[NAME],[NAME]早已被蒙住了双眼，带到了一张，长宽各一丈的大床上躺下。\n[NAME]的第一个任务是要接受十名女子的玩弄，并且不能射出自己的精液。\n[NAME]的身上并没有任何束缚，他双手枕在自己的脑后，神经却非常的紧张，不知道等待自己的是什么。\n突然，一阵轻轻的摸索，从自己两条粗大壮伟的双腿之间。\n向自己的胯下游移。\n[NAME]感觉到一双温热的灵巧的小手，慢慢的托起自己的两颗雄卵。\n一张灵巧的小嘴，对着雄卵上的汗毛轻轻吹气。\n[NAME]的身体猛地一颤，浑身的肌肉慢慢放松下来。\n面对女性的抚摸，[NAME]更希望自己的身体可以让她感到舒服。\n而不全是坚硬如铁的肌肉。\n小手的主人、似乎非常懂得欲擒故纵，也非常懂得如何玩弄男人。\n她知道，先前[NAME]的神经是非常紧绷的。\n这样轻微的抚摸，可以让[NAME]对他放下戒心。\n小手在[NAME]大腿的肌肉块上，灵巧地滑动着去探索[NAME]下体每一处敏感点，让[NAME]的大腿传来酥酥软软的电流。\n女人时不时的发出轻轻的赞叹，去满足[NAME]雄性的欲望。\n不过这些赞叹也是由衷的，[NAME]的身体太让人着迷了。\n让躺在[NAME]两侧的一对姐妹大开眼界。\n这对姐妹可不是一般的侍女。\n而是专门为了试炼新人培养的合欢女修。\n她们用手沿着[NAME]胸肌的边缘的线条缓缓的蹭着摸着，最后来到下胸肌的位置用手掂着，恰如其分衬托出[NAME]那硕大胸肌的分量。\n时不时的在[NAME]的耳根上，腋下，缓缓地吹出让人迷乱的气息。\n趁着[NAME]看不见，两名合欢女修。\n先是趁着帮[NAME]按摩肌肉的时候在[NAME]的全身，涂了一层烈性的春药。\n这种春药药性强烈，不一会儿便让[NAME]全身发热。\n本来[NAME]便是极阳之体。\n身体的温度很高，涂了春药之后[NAME]的身体简直就是发烫。\n[NAME]的呼吸逐渐紊乱。\n两名合欢女修先后脱光了自己身上的衣服。\n趴在[NAME]滚烫的身体上，灵巧的游动着。\n并且发出一阵一阵小声的低吟，娇喘。\n[NAME]本来对男女之事只是略知一二。\n从来没有女性在自己的身体上如此放肆。\n[NAME]本以为自己是一介粗人。\n并没有女生会喜欢自己一身肌肉疙瘩。\n但是这两名女性的大胆举动让[NAME]兴奋异常。\n龙根不一会儿便笔直地指向天花板，像一根铁柱。\n两名合欢女修并没有去触碰[NAME]的阳具，她俩要让[NAME]的情欲发挥到极致，骚动不安的[NAME]忍不住摆动自己充满力量的臀部将自己的龙根向天空推送。\n合欢女修们相视一笑，伸出自己灵巧的舌头占有[NAME]干净温暖的口腔，舔着[NAME]好看的整齐的白牙。\n与[NAME]的舌头相互纠缠着。\n呼吸着[NAME]呼出的温暖的空气，并且引导着[NAME]厚实粗糙的双手向合欢女修的双乳摸去。\n让[NAME]感受从来没有体验过的柔软。\n[NAME]越是浴火焚身，春药的药性散发的越强烈。\n[NAME]:“两位姑娘…我…”[NAME]话还没说完“啊啊啊啊…”的一声叫了出来，原来其中的一名合欢女修一口将[NAME]的巨大龟头勉强吞下，用舌头在冠状沟的位置来回扫动，沿着冠状沟的纹路，仔细的摩擦着[NAME]龟头脆弱敏感的鲜肉。\n[NAME]哪里受得了这种刺激，屁股不自觉的想上抬，又重重的的坠落了下来。\n在春药中合欢女修还加了大量的泄力药材，让[NAME]感觉自己的身子软绵绵的，手都抬不起来，只好躺在床上任凭两位合欢女修摆弄，一身的肌肉都变成了累赘，两位合欢女修轮流轰炸这[NAME]的龟头，[NAME]张着嘴时不时发出春吼，让在场的每一个人看的心跳加速。\n其中一名合欢女修用手抱着自己的乳房递到[NAME]的嘴边，挤出奶水给[NAME]喂了下去。\n[NAME]:“啊，好甜！”\n合欢女修:“呵呵，猛男，好甜你就多喝一点，专门为你准备的，奶水有的是”\n[NAME]吮吸着甘甜的乳汁，殊不知这乳汁乃是致命的毒物！奶水进入到男人身体以后，迅速的吸收体内的灵气与能量，将之转化为一股股阳精供合欢女修吸榨！合欢女修有令在身，并不会吸榨[NAME]的精液，而是大量消耗[NAME]的灵气，让他在后面被榨的更彻底！[NAME]越喝越渴，越喝浑身越燥，却又因为淫药的作用感受不到自己的力量正渐渐消失，不经人事的[NAME]彻底被淹没在官能欲海之中！"));
	me:TriggerStory("Ludingxiuxianji2");
	else
	me:AddMsg(XT("到了夜晚，终于到了[NAME],[NAME]早已被蒙住了双眼，带到了一张，长宽各一丈的大床上躺下。\n[NAME]的第一个任务是要接受十名女子的玩弄，并且不能射出自己的精液。\n[NAME]的身上并没有任何束缚，他双手枕在自己的脑后，神经却非常的紧张，不知道等待自己的是什么。\n突然，一阵轻轻的摸索，从自己两条粗大壮伟的双腿之间。\n向自己的胯下游移。\n[NAME]感觉到一双温热的灵巧的小手，慢慢的托起自己的两颗雄卵。\n一张灵巧的小嘴，对着雄卵上的汗毛轻轻吹气。\n[NAME]的身体猛地一颤，浑身的肌肉慢慢放松下来。\n面对女性的抚摸，[NAME]更希望自己的身体可以让她感到舒服。\n而不全是坚硬如铁的肌肉。\n小手的主人、似乎非常懂得欲擒故纵，也非常懂得如何玩弄男人。\n她知道，先前[NAME]的神经是非常紧绷的。\n这样轻微的抚摸，可以让[NAME]对他放下戒心。\n小手在[NAME]大腿的肌肉块上，灵巧地滑动着去探索[NAME]下体每一处敏感点，让[NAME]的大腿传来酥酥软软的电流。\n女人时不时的发出轻轻的赞叹，去满足[NAME]雄性的欲望。\n不过这些赞叹也是由衷的，[NAME]的身体太让人着迷了。\n让躺在[NAME]两侧的一对姐妹大开眼界。\n这对姐妹可不是一般的侍女。\n而是专门为了试炼新人培养的合欢女修。\n她们用手沿着[NAME]胸肌的边缘的线条缓缓的蹭着摸着，最后来到下胸肌的位置用手掂着，恰如其分衬托出[NAME]那硕大胸肌的分量。\n时不时的在[NAME]的耳根上，腋下，缓缓地吹出让人迷乱的气息。\n趁着[NAME]看不见，两名合欢女修。\n先是趁着帮[NAME]按摩肌肉的时候在[NAME]的全身，涂了一层烈性的春药。\n这种春药药性强烈，不一会儿便让[NAME]全身发热。\n本来[NAME]便是极阳之体。\n身体的温度很高，涂了春药之后[NAME]的身体简直就是发烫。\n[NAME]的呼吸逐渐紊乱。\n两名合欢女修先后脱光了自己身上的衣服。\n趴在[NAME]滚烫的身体上，灵巧的游动着。\n并且发出一阵一阵小声的低吟，娇喘。\n[NAME]本来对男女之事只是略知一二。\n从来没有女性在自己的身体上如此放肆。\n[NAME]本以为自己是一介粗人。\n并没有女生会喜欢自己一身肌肉疙瘩。\n但是这两名女性的大胆举动让[NAME]兴奋异常。\n龙根不一会儿便笔直地指向天花板，像一根铁柱。\n两名合欢女修并没有去触碰[NAME]的阳具，她俩要让[NAME]的情欲发挥到极致，骚动不安的[NAME]忍不住摆动自己充满力量的臀部将自己的龙根向天空推送。\n合欢女修们相视一笑，伸出自己灵巧的舌头占有[NAME]干净温暖的口腔，舔着[NAME]好看的整齐的白牙。\n与[NAME]的舌头相互纠缠着。\n呼吸着[NAME]呼出的温暖的空气，并且引导着[NAME]厚实粗糙的双手向合欢女修的双乳摸去。\n让[NAME]感受从来没有体验过的柔软。\n[NAME]越是浴火焚身，春药的药性散发的越强烈。\n[NAME]:“两位姑娘…我…”[NAME]话还没说完“啊啊啊啊…”的一声叫了出来，原来其中的一名合欢女修一口将[NAME]的巨大龟头勉强吞下，用舌头在冠状沟的位置来回扫动，沿着冠状沟的纹路，仔细的摩擦着[NAME]龟头脆弱敏感的鲜肉。\n[NAME]哪里受得了这种刺激，屁股不自觉的想上抬，又重重的的坠落了下来。\n在春药中合欢女修还加了大量的泄力药材，让[NAME]感觉自己的身子软绵绵的，手都抬不起来，只好躺在床上任凭两位合欢女修摆弄，一身的肌肉都变成了累赘，两位合欢女修轮流轰炸这[NAME]的龟头，[NAME]张着嘴时不时发出春吼，让在场的每一个人看的心跳加速。\n其中一名合欢女修用手抱着自己的乳房递到[NAME]的嘴边，挤出奶水给[NAME]喂了下去。\n[NAME]:“啊，好甜！”\n合欢女修:“呵呵，猛男，好甜你就多喝一点，专门为你准备的，奶水有的是”\n[NAME]吮吸着甘甜的乳汁，殊不知这乳汁乃是致命的毒物！奶水进入到男人身体以后，迅速的吸收体内的灵气与能量，将之转化为一股股阳精供合欢女修吸榨！合欢女修有令在身，并不会吸榨[NAME]的精液，而是大量消耗[NAME]的灵气，让他在后面被榨的更彻底！[NAME]越喝越渴，越喝浑身越燥，却又因为淫药的作用感受不到自己的力量正渐渐消失，不经人事的[NAME]彻底被淹没在官能欲海之中！最后，合欢女修为了爽死[NAME]，用沾满精油的小手飞速撸动着[NAME]的大鸡吧，从阳根底部到龟头嫩肉，甚至还扣了扣马眼，就这样撸了半个小时，[NAME]身上的淫药发挥到了极致，突然双目爆睁，身子猛地坐了起来！一股高潮的快感让他浑身的肌肉如触电般痉挛颤抖！[NAME]的鸡巴犹如一把巨锤愤怒的挺立在合欢女修面前。\n这根鸡巴竟比一般女性的小臂还要长，十分粗壯，有合欢女修的胳膊般粗，25厘米的茎身上，顶上一个形如大鹅蛋般的龟头，直径四寸，此时受了不断的刺激，整根鸡巴高高翘起，血管将鸡巴充得粗大异常，鸡巴上青筋暴露，有如一条条蟠龙蜿蜒在大鸡巴上，龟棱突出，像是一只大大的蕈菇，马眼闪着晶晶的凶光，真是性感极了！一对鹅蛋大小的阳卵紧裹在皱皱的卵袋里，悬在巨棒的下方。\n一阵阵浓烈的猛男的体味源源不断的传出，更让合欢女修心花怒放，她们都等不及吃到这传说中的猛男阳精了！而[NAME]不是不愿意么，没有关系，这不是泄闸了么,她们疯狂的吮吸着[NAME]射出的每道精元.合欢女修玩弄[NAME]张开嘴跪在[NAME]的双腿间，用嘴包住[NAME]的龟头疯狂的摩擦着，[NAME]一遍遍疯狂的喷射出一股股浓精,终于在合欢女修的折磨下[NAME]射了十几次开始,[NAME]哀嚎着混合着血丝又射了四次,再也射不出任何东西,开始失禁射出白色尿液,嘴角流着涎水双眼翻白渐渐失去意识"));
	me:AddModifier("Story_Caibuzhidao2");
	me:AddSchoolScore(1,-200);me:AddDamage("Fabao_CutOff","LeftScapula", 1, XT("斩断"));
	me:AddDamage("Fabao_CutOff","RightScapula", 1, XT("斩断"));
	me:AddDamage("Fabao_CutOff","LeftThighbone", 1, XT("斩断"));
	me:AddDamage("Fabao_CutOff","RightThighbone", 1, XT("斩断"));
	me:AddDamage("Destroy","Genitals", 1, XT("被某位合欢女修咬断吃了下去"));
	me:AddDamage("MeridianRupture","Meridian", 1, XT("被一众合欢女修采补"));
	me.npcObj.PropertyMgr:RemoveFeature("Tiancilonggen");
	me:AddMemery("在合欢岛无遮大会被合欢众女修打断四肢连续采阳七天七夜！");
	me:AddTitle(XT("废人"),string.format(XT("被合欢众女修打断四肢连续采阳七天七夜！"),4));
	end
end

function Hudong:shiqi29()
	if me:GetProperty("NpcLingMaxValue") > 18000 then
	me:AddMsg("[NAME]紧紧盯着自己通红的铁棍！马眼愤怒的张到最大，高潮的快感一波接一波！却没有一滴阳精喷射！原来阴险歹毒的妖女竟然用两根细到看不见的毒针横竖交叉刺进[NAME]的阳具，[NAME]甚至一点感觉都没有，皮肤都不会被伤害到，就像被蚊子叮了一样，莫要小看这两根毒针，它们上下交叉封锁了[NAME]控精的肌肉，让[NAME]的尿道口锁死，一股股滚烫的精液，活生生的被堵死在龙根底部，[NAME]绝望的看着自己的大鸡吧，有发出一声低沉的吼叫，重重跌回床上。\n不知怎的，仅仅是撸了一次就比的上平常自己玩弄好几次！可[NAME]知道自己绝对不能放弃！好在自己体内的灵气源源不绝，并不是可以轻易被消耗干净的！\n[NAME]被重新戴上眼罩，第三和第四名女子带着自己的法物登场，女子掏出一根长长的柔软的羽毛，又拿出一瓶黑色的小陶罐，将羽毛放进陶罐里充分的沾满了陶罐中精油与春药的混合物。\n妖女再用另外一只手把[NAME]在上一场没有射精愤愤不平的龙根扶稳。\n将红色的羽毛对准[NAME]的马眼插了进去快速的转动。\n[NAME]:“哦…不要…啊啊啊！”[NAME]发出一声长长的呻吟，却无法阻止羽毛继续深入，浑身的肌肉开始颤抖起来。\n[NAME]以为有成千上百只的蚂蚁钻进了自己的尿道，啃噬着自己敏感的肌肤。\n羽毛上的淫药滴到了[NAME]的阳心深处，让[NAME]的前列腺奇痒无比。\n[NAME]开始左右挣扎，试图让自己的身体深处好受一些，不过任何挣扎都是徒劳的。\n另外一名女子为了安抚[NAME]，不断的扶摸着[NAME]粗壮的脖颈，她伸出舌头慢慢的舔着[NAME]豆粒般大小的乳头。\n黑色的乳晕和正在变得挺立的乳柱，此女子的功力了得，妖女的舌头并不是红色的而是黑红两色两种颜色，她的舌头上有两种不同的温度相互交替。\n既有冷到冰点的温度又有如岩浆一般滚烫的火气，两种温度同时刺激[NAME]的乳头，[NAME]从来没有想到自己的乳头可以这么的敏感。\n[NAME]粗壮的双手艰难支撑着地面，不断的把胸肌向上方挺着，接受这妖女的折磨，[NAME]的胸部上方跟胸肌中缝早就拉丝暴筋，由此可见[NAME]乳头上受到了刺激之强烈并不比马眼中收到了刺激差，[NAME]的乳头和马眼同时受到强烈的攻击，爽得白眼直翻。\n与此同时，那滴落在阳心的春药仿佛不是普通的春药，他在[NAME]的前列腺处发出高频的震动，既痒又烫。\n可怜的[NAME]，只能绷紧肌肉去享受这种非人的快感。\n并不能作出任何反抗！[NAME]，感觉自己的精关要被再次抖松，抖的[NAME]尿都快要喷出来了，[NAME]的前列腺液早就如下暴雨一般洒满了床单，正当[NAME]忍受不住的时候妖女快速的抽出在马眼中高频转动的羽毛，女子那冰火两重天的舌头也离开了[NAME]的大胸肌。\n一切快感在刹那间夹然而止，只有那阳心深处残留的春药还在发挥效用。\n[NAME]不爽到极致，以前在山门的时候，[NAME]自己打飞机，都是怎么爽怎么来。\n而此时此刻[NAME]这头猛龙仿佛真的被禁锢住了一般，虽然浑身爽到爆炸却没有疯狂喷射实打实精液的快感，[NAME]呼吸愈加沉重，却也无奈也只能恨恨作罢这第五和第六名妖女，乃是合欢宗圣女李九妹的贴身侍女，从小便被李九妹放进内门培养，榨干过无数精壮的男人，但是像[NAME]这样普天之下少有的猛男，两名妖女也是头一次见到。，妖女的身体已经经过改造，其中一名妖女将[NAME]愤怒勃起的阳具引导着插进自己的小穴内。\n[NAME]一声重重地喘息。\n他感觉自己的肉棒进入小穴的道路异常艰难。\n第一毕竟是自己的阳具过于硕大正常人的难以容纳，第二[NAME]感觉正妖女的阴穴里有着无数湿答答软黏黏的肉刺，[NAME]的阳具每进一寸，无数的肉刺便会刮擦着[NAME]龟头上柔嫩的肌肤，让[NAME]射精的欲望更加强烈！\n妖女也发现如果自己的阴穴想要容纳[NAME]的肉棒，自己必须使出十二分的努力，[NAME]大鸡吧上缠绕的灵气就像神龙喷出的火焰，烤的妖女身体好酥好暖！直到[NAME]的肉棒笔直的插到了妖女阴穴的底端，肉棒的根部仍然露在了外面。\n妖女采取观音坐莲的方式在[NAME]的肉棒上下挪动，[NAME]的肉棒真的宛如一头猛龙牢牢的咬住狠狠的撕咬妖女的阴心。\n体质冰冷异常的妖女，也被[NAME]捣的浑身发烫，不一会儿便潮吹了。\n妖女:“阿!!!!!!!!”妖女达到了高潮，喷射出几道淫水在床单上，妖女顿时有些无力的摊在床上但是[NAME]的大肉棒依旧没有离开妖女的小穴里。\n而事实上是[NAME]无法离开妖女那蚀精无数的阴穴！\n[NAME]: “操，什么东西!”[NAME]感受到他的马眼被插入一条丝线，而且这条丝线像是有生命一样不停地从尿道蠕动进入他的生殖器深处，直到前列腺，丝线就是找到猎物一般紧咬住[NAME]的前列腺然后开始不停微微颤动。\n[NAME]“啊啊啊啊啊啊 …不要啊好爽…她妈的停下来”一波一波的快感袭击[NAME]，有别于射精高潮，这样直接刺激前列腺的快感更甚于射精，而且高潮时间是更加持续的。\n妖女:“怎么样猛男，任你什么精钢不坏之躯，还是可以被我玩坏的～”\n“啊啊啊…”[NAME]爽快的怒吼着，持续颤动着[NAME]的前列腺让他不停断的“高潮”持续了半个时辰左右，这样的持续高潮再精壮的男人也承受不住，[NAME]全身的过于紧绷，让他现在已经瘫倒在两名妖女的边上，钢铁之躯软弱无力但是阳根依然坚挺。\n妖女解开她的丝线慢慢地从[NAME]的生殖器深处收回，[NAME]有股异样的快感随着丝线而移动，酸麻的感觉随着丝线的消失逐渐高涨，然后在丝线退出[NAME]马眼的那一瞬间，[NAME]下体颤了几下。\n[NAME]:“阿~!我要射了”可是很遗憾，妖女并不会让[NAME]如愿以偿，[NAME]大张的马眼依旧没有喷出一滴阳精，只是徒劳的奋力的一张一合，身体过于酸软的[NAME]加上无限高潮的摧残，感觉自己消耗了很多的体力，好在[NAME]常年累月练就的肌肉支撑，让他没有那么容易倒下！\n长老有命令，必须将[NAME]体内的能量与灵气耗尽，再去让[NAME]被榨精，这样[NAME]的精关必将大开，榨精的过程也会畅通无阻，否则怎么可以驯服这只猛龙呢。\n两名妖女紧接着准备完成自己的第二步计划，她们一口气拿出六条缚仙绳，首先用三条缚仙绳将[NAME]呈倒Y字型绑在床上，两条粗壮的手臂叠在一起被狠狠的向上拉扯，粗壮大腿的脚踝也被绑上一条缚仙绳向床的两边拉扯，三条缚仙绳一起用力，让[NAME]的身体极度的紧绷，每一寸肌肉都苦苦支撑着，身体丝毫没有挪动的空间，[NAME]的呼吸都变的有些困难！\n因为流了过多的汗水，[NAME]的腋下散发出阵阵雄性的麝香味，浓密的腋毛也湿答答的。\n妖女被[NAME]身上的体味所吸引不禁伸出舌头去刺激着[NAME]的腋下。\n[NAME]没有想到，原来自己的腋下也是一个敏感的部位，再加上身体极度的紧绷，这种酥酥麻麻的快感，让[NAME]爽的无所适从，可是这两名妖女是负责来对[NAME]试炼的，能否顺利的榨精关键就在内门长老派来的这两名妖女身上，两名妖女念动咒语，居然催动着三条缚仙绳一起袭击[NAME]的阳具，三条缚仙绳争先恐后的钻进[NAME]的马眼，让他本来就很大的马眼被撑得更大了。\n本来一条缚仙绳就逼迫[NAME]运转灵力，没想到一下子来了三条，三条缚仙绳钻进[NAME]的体内后不由分说的吸食着[NAME]的能量，巨大的能量居然让其中一条不怎么结实的缚仙绳吸爆了，妖女只好又在[NAME]的马眼中放进一条缚仙绳。\n[NAME]惊恐的发现缚仙绳所带来的吸力是伴随着阵阵的爽快的，自己身体里的能量仿佛再也不受到自己的控制，而是真先恐后欢呼雀跃的奔向自己的马眼和阳具，渴望被缚仙绳吸食。\n[NAME]也不得不承认这种身体被掏空的快感远远的大于缚仙绳所带来的痛楚，那种身体的能量被抽掉电流一般酸麻的快感，让[NAME]忍不住发出充满雄性味道的呻吟，可是残存的理智告诉[NAME]，不能就这样被缚仙绳所吸干……[NAME]深呼吸运转灵气用自己的内力把缚仙绳逼出马眼，这样一来[NAME]消耗的能量是极其的巨大的，但是相比于被缚仙绳吸干[NAME]，只能放手一搏，捆绑[NAME]手脚的三条缚仙绳，将[NAME]的身体拉扯的几乎离开了床面。\n[NAME]的身体相当于处在半悬空的状态。\n[NAME]:“啊啊啊啊！操你妈的，给老子出去”[NAME]愤怒的大吼道，每将三条缚仙绳逼出一点点，[NAME]都要付出巨大的代价，燃烧着自己的灵气与这小小的邪器搏斗，终于三条缚仙绳被[NAME]逼出了自己的身体，[NAME]再奋力一扯绑在在[NAME]肌肉上的，绳子也被[NAME]扯断，刚刚几乎窒息的[NAME]宛如重获新生大口的呼吸新鲜的空气。\n合欢女修啪啪啪“鼓掌，笑着说道:恭喜这位小公子通过了合欢门新人终极试炼，顺利进入内门，已经好几百年没有新人能通过这样的折磨试炼而不泄出阳精，合欢功法讲求今欲不接交，神气不宣布，公子能持久而不泄真乃天生适合练合欢宗功法之人，今赐尔我合欢宗秘法一门晋升尔为内门弟子。”");
	me:UnLockGong("Gong_HappyMan");
	me.npcObj.PropertyMgr:AddFeature("HHZneimendizi")
	else
	me:AddMsg("[NAME]紧紧盯着自己通红的铁棍！马眼愤怒的张到最大，高潮的快感一波接一波！却没有一滴阳精喷射！原来阴险歹毒的妖女竟然用两根细到看不见的毒针横竖交叉刺进[NAME]的阳具，[NAME]甚至一点感觉都没有，皮肤都不会被伤害到，就像被蚊子叮了一样，莫要小看这两根毒针，它们上下交叉封锁了[NAME]控精的肌肉，让[NAME]的尿道口锁死，一股股滚烫的精液，活生生的被堵死在龙根底部，[NAME]绝望的看着自己的大鸡吧，有发出一声低沉的吼叫，重重跌回床上。\n不知怎的，仅仅是撸了一次就比的上平常自己玩弄好几次！可[NAME]知道自己绝对不能放弃！好在自己体内的灵气源源不绝，并不是可以轻易被消耗干净的！\n[NAME]被重新戴上眼罩，第三和第四名女子带着自己的法物登场，女子掏出一根长长的柔软的羽毛，又拿出一瓶黑色的小陶罐，将羽毛放进陶罐里充分的沾满了陶罐中精油与春药的混合物。\n妖女再用另外一只手把[NAME]在上一场没有射精愤愤不平的龙根扶稳。\n将红色的羽毛对准[NAME]的马眼插了进去快速的转动。\n[NAME]:“哦…不要…啊啊啊！”[NAME]发出一声长长的呻吟，却无法阻止羽毛继续深入，浑身的肌肉开始颤抖起来。\n[NAME]以为有成千上百只的蚂蚁钻进了自己的尿道，啃噬着自己敏感的肌肤。\n羽毛上的淫药滴到了[NAME]的阳心深处，让[NAME]的前列腺奇痒无比。\n[NAME]开始左右挣扎，试图让自己的身体深处好受一些，不过任何挣扎都是徒劳的。\n另外一名女子为了安抚[NAME]，不断的扶摸着[NAME]粗壮的脖颈，她伸出舌头慢慢的舔着[NAME]豆粒般大小的乳头。\n黑色的乳晕和正在变得挺立的乳柱，此女子的功力了得，妖女的舌头并不是红色的而是黑红两色两种颜色，她的舌头上有两种不同的温度相互交替。\n既有冷到冰点的温度又有如岩浆一般滚烫的火气，两种温度同时刺激[NAME]的乳头，[NAME]从来没有想到自己的乳头可以这么的敏感。\n[NAME]粗壮的双手艰难支撑着地面，不断的把胸肌向上方挺着，接受这妖女的折磨，[NAME]的胸部上方跟胸肌中缝早就拉丝暴筋，由此可见[NAME]乳头上受到了刺激之强烈并不比马眼中收到了刺激差，[NAME]的乳头和马眼同时受到强烈的攻击，爽得白眼直翻。\n与此同时，那滴落在阳心的春药仿佛不是普通的春药，他在[NAME]的前列腺处发出高频的震动，既痒又烫。\n可怜的[NAME]，只能绷紧肌肉去享受这种非人的快感。\n并不能作出任何反抗！[NAME]，感觉自己的精关要被再次抖松，抖的[NAME]尿都快要喷出来了，[NAME]的前列腺液早就如下暴雨一般洒满了床单，正当[NAME]忍受不住的时候妖女快速的抽出在马眼中高频转动的羽毛，女子那冰火两重天的舌头也离开了[NAME]的大胸肌。\n一切快感在刹那间夹然而止，只有那阳心深处残留的春药还在发挥效用。\n[NAME]不爽到极致，以前在山门的时候，[NAME]自己打飞机，都是怎么爽怎么来。\n而此时此刻[NAME]这头猛龙仿佛真的被禁锢住了一般，虽然浑身爽到爆炸却没有疯狂喷射实打实精液的快感，[NAME]呼吸愈加沉重，却也无奈也只能恨恨作罢这第五和第六名妖女，乃是合欢宗圣女李九妹的贴身侍女，从小便被李九妹放进内门培养，榨干过无数精壮的男人，但是像[NAME]这样普天之下少有的猛男，两名妖女也是头一次见到。，妖女的身体已经经过改造，其中一名妖女将[NAME]愤怒勃起的阳具引导着插进自己的小穴内。\n[NAME]一声重重地喘息。\n他感觉自己的肉棒进入小穴的道路异常艰难。\n第一毕竟是自己的阳具过于硕大正常人的难以容纳，第二[NAME]感觉正妖女的阴穴里有着无数湿答答软黏黏的肉刺，[NAME]的阳具每进一寸，无数的肉刺便会刮擦着[NAME]龟头上柔嫩的肌肤，让[NAME]射精的欲望更加强烈！\n妖女也发现如果自己的阴穴想要容纳[NAME]的肉棒，自己必须使出十二分的努力，[NAME]大鸡吧上缠绕的灵气就像神龙喷出的火焰，烤的妖女身体好酥好暖！直到[NAME]的肉棒笔直的插到了妖女阴穴的底端，肉棒的根部仍然露在了外面。\n妖女采取观音坐莲的方式在[NAME]的肉棒上下挪动，[NAME]的肉棒真的宛如一头猛龙牢牢的咬住狠狠的撕咬妖女的阴心。\n体质冰冷异常的妖女，也被[NAME]捣的浑身发烫，不一会儿便潮吹了。\n妖女:“阿!!!!!!!!”妖女达到了高潮，喷射出几道淫水在床单上，妖女顿时有些无力的摊在床上但是[NAME]的大肉棒依旧没有离开妖女的小穴里。\n而事实上是[NAME]无法离开妖女那蚀精无数的阴穴！\n[NAME]: “操，什么东西!”[NAME]感受到他的马眼被插入一条丝线，而且这条丝线像是有生命一样不停地从尿道蠕动进入他的生殖器深处，直到前列腺，丝线就是找到猎物一般紧咬住[NAME]的前列腺然后开始不停微微颤动。\n[NAME]“啊啊啊啊啊啊 …不要啊好爽…她妈的停下来”一波一波的快感袭击[NAME]，有别于射精高潮，这样直接刺激前列腺的快感更甚于射精，而且高潮时间是更加持续的。\n妖女:“怎么样猛男，任你什么精钢不坏之躯，还是可以被我玩坏的～”\n“啊啊啊…”[NAME]爽快的怒吼着，持续颤动着[NAME]的前列腺让他不停断的“高潮”持续了半个时辰左右，这样的持续高潮再精壮的男人也承受不住，[NAME]全身的过于紧绷，让他现在已经瘫倒在两名妖女的边上，钢铁之躯软弱无力但是阳根依然坚挺。\n妖女解开她的丝线慢慢地从[NAME]的生殖器深处收回，[NAME]有股异样的快感随着丝线而移动，酸麻的感觉随着丝线的消失逐渐高涨，然后在丝线退出[NAME]马眼的那一瞬间，[NAME]下体颤了几下。\n[NAME]:“阿~!我要射了”可是很遗憾，妖女并不会让[NAME]如愿以偿，[NAME]大张的马眼依旧没有喷出一滴阳精，只是徒劳的奋力的一张一合，身体过于酸软的[NAME]加上无限高潮的摧残，感觉自己消耗了很多的体力，好在[NAME]常年累月练就的肌肉支撑，让他没有那么容易倒下！\n长老有命令，必须将[NAME]体内的能量与灵气耗尽，再去让[NAME]被榨精，这样[NAME]的精关必将大开，榨精的过程也会畅通无阻，否则怎么可以驯服这只猛龙呢。\n两名妖女紧接着准备完成自己的第二步计划，她们一口气拿出六条缚仙绳，首先用三条缚仙绳将[NAME]呈倒Y字型绑在床上，两条粗壮的手臂叠在一起被狠狠的向上拉扯，粗壮大腿的脚踝也被绑上一条缚仙绳向床的两边拉扯，三条缚仙绳一起用力，让[NAME]的身体极度的紧绷，每一寸肌肉都苦苦支撑着，身体丝毫没有挪动的空间，[NAME]的呼吸都变的有些困难！\n因为流了过多的汗水，[NAME]的腋下散发出阵阵雄性的麝香味，浓密的腋毛也湿答答的。\n妖女被[NAME]身上的体味所吸引不禁伸出舌头去刺激着[NAME]的腋下。\n[NAME]没有想到，原来自己的腋下也是一个敏感的部位，再加上身体极度的紧绷，这种酥酥麻麻的快感，让[NAME]爽的无所适从，可是这两名妖女是负责来对[NAME]试炼的，能否顺利的榨精关键就在内门长老派来的这两名妖女身上，两名妖女念动咒语，居然催动着三条缚仙绳一起袭击[NAME]的阳具，三条缚仙绳争先恐后的钻进[NAME]的马眼，让他本来就很大的马眼被撑得更大了。\n本来一条缚仙绳就逼迫[NAME]运转灵力，没想到一下子来了三条，三条缚仙绳钻进[NAME]的体内后不由分说的吸食着[NAME]的能量，巨大的能量居然让其中一条不怎么结实的缚仙绳吸爆了，妖女只好又在[NAME]的马眼中放进一条缚仙绳。\n[NAME]惊恐的发现缚仙绳所带来的吸力是伴随着阵阵的爽快的，自己身体里的能量仿佛再也不受到自己的控制，而是真先恐后欢呼雀跃的奔向自己的马眼和阳具，渴望被缚仙绳吸食。\n[NAME]也不得不承认这种身体被掏空的快感远远的大于缚仙绳所带来的痛楚，那种身体的能量被抽掉电流一般酸麻的快感，让[NAME]忍不住发出充满雄性味道的呻吟，可是残存的理智告诉[NAME]，不能就这样被缚仙绳所吸干……趁着[NAME]的体力及其的虚弱，合欢女修拿出了一根及其诡异的管道，扒开[NAME]的屁股插了进去，[NAME]努力啊的痛叫一声，两块丰腴健硕的臀肉想努力合拢，合欢女修在[NAME]腰间点了几个穴位，顿时失了力气，这跟管道居然被插进了[NAME]的前列腺，无论男人如何的强大勇猛，前列腺依然非常脆弱，人的构造就是如此的美妙，管道引导着前列腺液被合欢女修们开采出来，原来合欢女修们居然连[NAME]的爱液都不放过，看了是发了狠心要把[NAME]吃干抹尽，长时间前列腺的刺激，要不是[NAME]被铁链绑住，[NAME]早已爽的不省人事，[NAME]的胸肌，腹肌，大腿被榨的甚至出现了抽筋的现象，突然，[NAME]雄卵一提，马眼一开，还不到一刻钟居然射了！！\n没有想到的是，长时间的刺激竟然让[NAME]失禁了，对于[NAME]来说简直就是奇耻大辱！但前后夹攻的快感再一次让[NAME]失去了任何羞耻心，腥臊的尿液和精液的混合，像瀑布一般流了下来，尿液之强劲，将近喷射在一丈开外，[NAME]这次射精爽的居然都不知道高潮什么时候可以结束，自己浑身上下的每个细胞都处于高潮的阶段，精液尿液的秽物沾在[NAME]的肌肉之躯，没有难闻的问道，只有男子特有的腥臊！终于合欢女修拿着采阳瓶装满了[NAME]精元。");
	me:AddModifier("Story_Caibuzhidao2");
	me.npcObj.PropertyMgr:RemoveFeature("Tiancilonggen");
	me:AddDamage("MeridianRupture","Meridian", 1, XT("被一众合欢女修采补"));
	me:AddMemery("在合欢岛无遮大会被合欢众女修吸干了精元！");
	me:AddTitle(XT("废人"),string.format(XT("被合欢众女修吸干了精元！"),4));
	end
end

function Hudong:shiqi30()
Panding = me:RandomInt(1,500);
	if me:GetSex() == 2 then
		if ThingMgr:FindThingByID(me.npcObj.ID).PropertyMgr.Practice.GodCount > 0 and me:CheckFeature("Pogua") ~= true then
		me:AddMsg("[NAME]突发奇想，试着将蛊种置入下体，蛊种仿佛很喜欢这个拥有强大灵气又好闻的巢穴，在突破[NAME]初膜向理想的苗床进发之时，被[NAME]那真仙的精血落红刺激，竟然直接成长为成蛊！。");
		me:DropAwardItem("Item_MiBao_YYHHG",1);
		me.npcObj.PropertyMgr:AddFeature("Pogua");
		story:RemoveBindItem();
		elseif me:GetGLevel() > 9 and me:CheckFeature("Pogua") ~= true and Panding > 400 then
		me:AddMsg("[NAME]突发奇想，试着将蛊种置入下体，蛊种仿佛很喜欢这个拥有强大灵气又好闻的巢穴，在突破[NAME]初膜向理想的苗床进发之时，被[NAME]那元婴强者的精血落红刺激，竟然直接成长为成蛊！。");
		me:DropAwardItem("Item_MiBao_YYHHG",1);
		me.npcObj.PropertyMgr:AddFeature("Pogua");
		story:RemoveBindItem();
		elseif me:GetGLevel() > 6 and me:CheckFeature("Pogua") ~= true and Panding > 450 then
		me:AddMsg("[NAME]突发奇想，试着将蛊种置入下体，蛊种仿佛很喜欢这个拥有强大灵气又好闻的巢穴，在突破[NAME]初膜向理想的苗床进发之时，被[NAME]那金丹女修的精血落红刺激，竟然直接成长为成蛊！。");
		me:DropAwardItem("Item_MiBao_YYHHG",1);
		me.npcObj.PropertyMgr:AddFeature("Pogua");
		story:RemoveBindItem();
		elseif me:GetGLevel() > 3 and me:CheckFeature("Pogua") ~= true and Panding > 475 then
		me:AddMsg("[NAME]突发奇想，试着将蛊种置入下体，蛊种仿佛很喜欢这个拥有强大灵气又好闻的巢穴，在突破[NAME]初膜向理想的苗床进发之时，被[NAME]的精血落红刺激，竟然直接成长为成蛊！。");
		me:DropAwardItem("Item_MiBao_YYHHG",1);
		me.npcObj.PropertyMgr:AddFeature("Pogua");
		story:RemoveBindItem();
		elseif me:GetGLevel() > 0 and me:CheckFeature("Pogua") ~= true and Panding > 490 then
		me:AddMsg("[NAME]突发奇想，试着将蛊种置入下体，蛊种仿佛很喜欢这个拥有强大灵气又好闻的巢穴，在突破[NAME]初膜向理想的苗床进发之时，被[NAME]的精血落红刺激，竟然直接成长为成蛊！。");
		me:DropAwardItem("Item_MiBao_YYHHG",1);
		me.npcObj.PropertyMgr:AddFeature("Pogua");
		story:RemoveBindItem();
		elseif me:CheckFeature("Pogua") ~= true and Panding > 498 then
		me:AddMsg("[NAME]突发奇想，试着将蛊种置入下体，蛊种仿佛很喜欢这个拥有强大灵气又好闻的巢穴，在突破[NAME]初膜向理想的苗床进发之时，被[NAME]的精血落红刺激，竟然直接成长为成蛊！。");
		me:DropAwardItem("Item_MiBao_YYHHG",1);
		me.npcObj.PropertyMgr:AddFeature("Pogua");
		story:RemoveBindItem();
		elseif me:CheckFeature("Pogua") ~= true then
		me:AddMsg("[NAME]突发奇想，试着将蛊种置入下体，蛊种仿佛很喜欢这个拥有强大灵气又好闻的巢穴，于是蛊种以[NAME]的身体作为苗床，再也不愿意回到原本的容器之中了，[NAME]也因次性情大变，仿佛变的人尽可夫的痴女了一般。");
		me.npcObj.PropertyMgr:AddFeature("Pogua");
		me.npcObj.PropertyMgr:AddFeature("Chinvguchong")
		story:RemoveBindItem();
		else
		me:AddMsg("[NAME]突发奇想，试着将蛊种置入下体，蛊种变得异常暴躁，在[NAME]的肉穴中大肆破坏撕咬，[NAME]耗尽心力才将蛊种安抚下来，可蛊种也再也不愿意回到原本的容器中了。\n[NAME]也因次性情大变，仿佛变的人尽可夫的痴女了一般，另因蛊虫造成的伤害折寿了一甲子。");
		me.npcObj.PropertyMgr:AddFeature("Chinvguchong")
		story:RemoveBindItem();
		end
	else
		if me.npcObj.PropertyMgr.BodyData:PartIsBroken("Genitals") or me:GetSex() == 2 then
		me:AddMsg("许是[NAME]身上散发这蛊虫特别讨厌的阴阳人气味，蛊虫一动不动的在装死。");
		else
		me:AddMsg("[NAME]不知道是不是脑袋被驴踢了，也许是看了什么中东式尿道飞机法，居然没事想去让蛊种来刺激自己尿道……然后就没有然后了，蛊虫也乘机逃跑了。");
		Hudong:SCdaoju001()
		me:AddDamage("Fabao_CutOff","Genitals", 1, XT("被阴阳合欢蛊幼虫咬烂断裂"));
		story:RemoveBindItem();
		end
	end
end

function Hudong:shiqi31()
if me:CheckItemEquptCount("Item_Lazhu") == 1 then
	local Fulu = me:GetModifierStack("Qian");
	local L1 = me:GetModifierStack("Luding");
	local L2 = me:GetModifierStack("Luding2");
	local L3 = me:GetModifierStack("Luding3");
	local L4 = me:GetModifierStack("Luding4");
	local L5 = me:GetModifierStack("Luding5");
	local L6 = me:GetModifierStack("Luding6");
	me:AddMsg("作为宗门弟子的[NAME]当然知道眼前这是女偶箱的防盗系统，所谓张开的嘴只是用来骗那些蠢货的假锁孔。\n[NAME]从自己股间抽出那还带着直肠余温的灵动能肛珠，塞入了女偶身后的孔穴搅动了百于下后，女偶返身打开了箱子，并调取了属于[NAME]个人的空间。\n空间内存放白银："..Fulu.."两\n男俘虏"..L1.."人，女俘虏"..L2.."人，美男俘虏"..L3.."人，美女俘虏"..L4.."人，男修俘虏"..L5.."人，女修俘虏"..L6.."人。");
	elseif me.npcObj.PropertyMgr.BodyData:PartIsBroken("Genitals") or me:GetSex() == 2 then
	me:AddMsg("[NAME]身为宗门弟子，自然知道女偶那张开的小嘴是防盗的伪锁孔，[NAME]身上并没有携带用于开启女偶锁孔的秘匙，只能转身离开了。");
	else
	me:AddMsg("[NAME]身为宗门弟子，自然知道女偶那张开的小嘴是防盗的伪锁孔，[NAME]身上并没有携带用于开启女偶锁孔的秘匙，但是闲着也是闲着，不知怎么想的[NAME]就掏出肉棒往女偶嘴中插了进去，而后自顾自的开始了活塞移动……快意正浓时……只觉下体一疼……\n该死！这女偶的设定被改了，明明以前不会……");
	Hudong:SCdaoju001()
	me:AddDamage("Fabao_CutOff","Genitals", 1, XT("被合欢女偶咬断"));
	end
end

function Hudong:shiqi32()
npc1 = ThingMgr:FindThingByID(me.npcObj.ID)
npc2 = ThingMgr:FindThingByID(story:GetBindThing().ID)
	if CS.XiaWorld.TongLingMgr.Instance:IsJingGuai(npc2.ID) and npc2.LingV > 100000 then
	me:AddMsg("[NAME]与女偶戏耍完，躺倒在地歇息之时，却见本应安静的躺在一侧的女偶，竟如那牵丝戏中的人偶一般，直挺挺的起身……\n女偶因吸纳了足够多的精华和灵气而化形……");
	TongLingMgr:ZaoHuaSuTi(npc2.ID)
	else
		if me:GetModifierStack("Nvrenou") == 0 then
			if npc1.GongKind == g_emGongKind.Body then 
				if me:GetSex() == 2 then
				me:AddMsg("[NAME]虽是女子，可也能与这女偶覆雨翻云……");
				npc1.PropertyMgr.Practice.BodyPracticeData:AddQuenchingItem("Item_yinjin",me:GetGLevel() + 1)
				elseif me:GetSex() == 1 and me.npcObj.PropertyMgr.BodyData:PartIsBroken("Genitals") == false then
				me:AddMsg("[NAME]抱起女偶便是一番猪突猛进……");
				npc1.PropertyMgr.Practice.BodyPracticeData:AddQuenchingItem("Item_yangjin",me:GetGLevel() + 1)
				else
				me:AddMsg("[NAME]闲着无聊把玩了一会女偶");
				end
			elseif me:GetGongName() == "Gong_1701_Tu" then
				if me:GetSex() > 1 then
				me:AddMsg("[NAME]虽然是个女子，但却将女偶倒转过来，将女偶头部放入自己亵衣之中。那女偶口中舌头灵活的在[NAME]双腿间拨弄挑逗，很快[NAME]就娇喘呻呤起来，忍不住也将嘴凑到女偶下体，却不想女偶下体满是之前不知名同门师兄弟留下来的精液痕迹。[NAME]被女偶舔的兴奋不已，也不停用舌头舔舐清理起女偶下体精液……待到[NAME]衣衫不整跄踉离去时，女偶下体光洁如新，没有一丝异味……此举也使得[NAME]修为提升了不少");
				me:AddPracticeResource("Stage",me:GetGLevel() * 1000);
					if ThingMgr:FindThingByID(me.npcObj.ID).PropertyMgr.Practice.GodCount > 0 then
					me:DropAwardItem("Item_yinjin6",1);
					elseif me:GetGLevel() > 9 then
					me:DropAwardItem("Item_yinjin5",1);
					elseif me:GetGLevel() > 6 then
					me:DropAwardItem("Item_yinjin4",1);
					elseif me:GetGLevel() > 3 then
					me:DropAwardItem("Item_yinjin3",1);
					elseif me:GetGLevel() > 0 then
					me:DropAwardItem("Item_yinjin2",1);
					else
					me:DropAwardItem("Item_yinjin1",1);
					end
				else
					if me.npcObj.PropertyMgr.BodyData:PartIsBroken("Genitals") then
					me:AddMsg("[NAME]虽然修炼了合欢残篇，但[NAME]是个太监，于是只能抱着女偶把玩了一会后便离开了。");
					else
					me:AddMsg("[NAME]修炼了合欢残篇，按照功法所述的方式插入女偶下体，并且运功调息抽插百余下后元阳依旧紧锁不泻，虽女偶为死物，[NAME]确依旧从中练功中获得了不少修为。");
					me:AddPracticeResource("Stage",me:GetGLevel() * 1000);
					end
				end
			else
				if me:GetSex() > 1 then
					me:AddMsg("[NAME]虽然是个女子，但却将女偶倒转过来，将女偶头部放入自己亵衣之中。那女偶口中舌头灵活的在[NAME]双腿间拨弄挑逗，很快[NAME]就娇喘呻呤起来，忍不住也将嘴凑到女偶下体，却不想女偶下体满是之前不知名同门师兄弟留下来的精液痕迹。[NAME]被女偶舔的兴奋不已，也不停用舌头舔舐清理起女偶下体精液……待到[NAME]衣衫不整跄踉离去时，女偶下体光洁如新，没有一丝异味……");
					if ThingMgr:FindThingByID(me.npcObj.ID).PropertyMgr.Practice.GodCount > 0 then
					me:DropAwardItem("Item_yinjin6",1);
					elseif me:GetGLevel() > 9 then
					me:DropAwardItem("Item_yinjin5",1);
					elseif me:GetGLevel() > 6 then
					me:DropAwardItem("Item_yinjin4",1);
					elseif me:GetGLevel() > 3 then
					me:DropAwardItem("Item_yinjin3",1);
					elseif me:GetGLevel() > 0 then
					me:DropAwardItem("Item_yinjin2",1);
					else
					me:DropAwardItem("Item_yinjin1",1);
					end
				else
					if me.npcObj.PropertyMgr.BodyData:PartIsBroken("Genitals") then
					me:AddMsg("[NAME]并没有主修合欢残篇，又是个太监，抱着女偶把玩了一会后便离开了。");
					else
					me:AddMsg("[NAME]虽然没有学过采补功法，但是看这人偶着实漂亮，忍不住掏出胯下肉棒便往玩偶的孔穴里抽插了起来，百余次冲刺之后射了一滩精元与玩偶穴中。");
						if ThingMgr:FindThingByID(me.npcObj.ID).PropertyMgr.Practice.GodCount > 0 then
						me:DropAwardItem("Item_yangjin6",1);
						elseif me:GetGLevel() > 9 then
						me:DropAwardItem("Item_yangjin5",1);
						elseif me:GetGLevel() > 6 then
						me:DropAwardItem("Item_yangjin4",1);
						elseif me:GetGLevel() > 3 then
						me:DropAwardItem("Item_yangjin3",1);
						elseif me:GetGLevel() > 0 then
						me:DropAwardItem("Item_yangjin2",1);
						else
						me:DropAwardItem("Item_yangjin1",1);
						end
					end
				end
			end
			me:AddModifier("Nvrenou");
			npc2:AddLing(10 * npc1.LuaHelper:GetGLevel() * npc1.PropertyMgr.Practice:GetDaoHang());
		else
		me:AddMsg("[NAME]最近玩过女偶了。");
		end
	end
end

function Hudong:shiqi33()
	if me:GetModifierStack("Shuangtoulong") == 0 then
		if me:GetGongName() == "Gong_1701_Tu" then
			if me:CheckFeature("Pogua") ~= true and me:GetSex() == 2 then
			me:AddMsg("[NAME]手把着双头龙探入下身肉穴，[NAME]那处子的肉穴无比紧致，双头龙堪堪插入便被一层薄膜挡住，那自然就是[NAME]的处女膜。\n[NAME]狠下心来把双头龙猛的向小穴一送，“啊……！”处女膜被双头龙撕裂的痛苦让[NAME]惨叫出声音来。\n歇息片刻，[NAME]感觉不是那么疼了，于是手握双头龙在小穴中来回抽送，百余来回之后突一冷颤，蜜穴尽头泄出了一股搀着处子精血的阴元。");
			me:AddModifier("Shuangtoulong");me.npcObj.PropertyMgr:AddFeature("Pogua");me:DropAwardItem("Item_Nvxiuluohong",1);
			else
				if me:GetSex() > 1 then
				me:AddMsg("[NAME]修炼了合欢残篇，按照功法所述的方式将双头龙插入下体运功调息。手把着双头龙在小穴中来回抽送，百余来回之后[NAME]感觉神志清明仿佛已完成了一个运功的大循环。");
				me:AddPracticeResource("Stage",me:GetGLevel() * 1000);
				me:AddModifier("Shuangtoulong");
				else
				me:AddMsg("[NAME]虽然学了合欢残篇，但是男人也不用这玩意是吧？。");
				end
			end
		else
			if me:GetSex() > 1 then
				if me:CheckFeature("Pogua") ~= true then
				me:AddMsg("[NAME]手把着双头龙探入下身肉穴，[NAME]那处子的肉穴无比紧致，双头龙堪堪插入便被一层薄膜挡住，那自然就是[NAME]的处女膜。\n[NAME]狠下心来把双头龙猛的向小穴一送，“啊……！”处女膜被双头龙撕裂的痛苦让[NAME]惨叫出声音来。\n歇息片刻，[NAME]感觉不是那么疼了，于是手握双头龙在小穴中来回抽送，百余来回之后突一冷颤，蜜穴尽头泄出了一股搀着处子精血的阴元。");
				me:AddModifier("Shuangtoulong");me.npcObj.PropertyMgr:AddFeature("Pogua");me:DropAwardItem("Item_Nvxiuluohong",1);
				else
				me:AddMsg("[NAME]手把着双头龙在小穴中来回抽送，百余来回之后突一冷颤，蜜穴尽头泄出了一股的阴元。");
				me:AddModifier("Shuangtoulong");
				end
				if ThingMgr:FindThingByID(me.npcObj.ID).PropertyMgr.Practice.GodCount > 0 then
				me:DropAwardItem("Item_yinjin6",1);
				elseif me:GetGLevel() > 9 then
				me:DropAwardItem("Item_yinjin5",1);
				elseif me:GetGLevel() > 6 then
				me:DropAwardItem("Item_yinjin4",1);
				elseif me:GetGLevel() > 3 then
				me:DropAwardItem("Item_yinjin3",1);
				elseif me:GetGLevel() > 0 then
				me:DropAwardItem("Item_yinjin2",1);
				else
				me:DropAwardItem("Item_yinjin1",1);
				end
			else
			me:AddMsg("[NAME]是个男人，也不用这玩意是吧？。");
			end
		end
	else
	me:AddMsg("[NAME]最近玩过双头龙了。");
	end
end

function Hudong:shiqi34()
	if me:GetGLevel() > 6 then
	me:AddMsg(XT("[NAME]击退了合欢宗女修，但是那些差点成为炉鼎的死老百姓根本没有觉得[NAME]的是善举，甚至还对[NAME]破口大骂，但此举顺应天道，[NAME]获得了一些功德。"));me:ModifierProperty("GodPenaltyAddV",-me:RandomInt(3,8));story:FinishSecret();
	elseif me:GetSex () > 1 then
	me:AddMsg(XT("[NAME]修为不继，被合欢女修封住周身大穴，扒光衣服扔在路边任人玩弄，[NAME]被一众凡人轮奸了上百次，浑身上下没有一处不沾染那令人恶心的白浊粘液，若非[NAME]是个修炼者，怕是这次就要交代于此了，多管闲事的确是要付出代价的。"));me.npcObj.PropertyMgr:AddFeature("Pogua");me:AddMemery("在一次历练的途中被凡人轮奸了！");me:AddTitle(XT("被凡人轮奸过的女修士"),string.format(XT("在%s年，于一次历练途中，因某些原因失去战力，惨遭凡人轮奸"),1));story:FinishSecret();
	elseif me.npcObj.PropertyMgr.BodyData:PartIsBroken("Genitals") then
	me:AddMsg(XT("[NAME]修为不继，被合欢女修封住周身大穴，合欢女修正待享受一番神道修士的元阳精华，却发现身为神修的[NAME]竟然是个太监，合欢女修勃然大怒，鼓动那些愚民们将[NAME]鸡奸了。"));me:AddMemery("在一次历练的途中被凡人鸡奸了！");me:AddTitle(XT("菊花残"),string.format(XT("在%s年，于一次历练途中，因某些原因失去战力，惨遭凡人鸡奸！"),1));story:FinishSecret();
	else
	me:AddMsg(XT("[NAME]修为不继，中了合欢女修的七情咒。\n只见合欢女修褪下衣衫向[NAME]勾了勾手指，[NAME]便如同发情的公狗一般穿着粗气想要上前做上一番活塞运动，奈何身中魔咒未得对方应允周身皆无法行动，只见妖女伸出手指掰开蜜穴花瓣后吩咐的一句“来舔”，[NAME]终感周身禁制被解，方能匍匐向前伸出舌头开始舔着那早已开始淌水的蜜穴……十个时辰之后，妖女将完全榨干的[NAME]随手丢弃在路边，独自离开了。"));me:AddModifier("Story_Caibuzhidao2");me:AddMemery("在一次历练的途中被合欢女修采补了！");me:AddTitle(XT("废弃炉鼎"),string.format(XT("在%s年，于一次历练途中，被合欢女修吸了个一干二净后弃置！"),1));story:FinishSecret();
	end
end

function Hudong:shiqi35()
local nN = me:RandomInt(math.floor(me:GetGLevel()^4 * 1),math.floor(me:GetGLevel()^4* 1.5))
me:AddMsg(XT("猪妖见眼入侵之人为自己所击败，且刚好体型与自己也大致相同，顿时淫念生，身下那宝贝分泌着大量透明粘液如同电钻般的螺旋而出（猪的生殖器的确是螺旋且会旋转的熬），[NAME]只感身下炙热的异物入体，自己的蜜穴被异物撑的无比饱满，正待适应却不想这异物顺时针的旋转了起来，那一层层接连不断的螺旋刮弄着蜜穴的肉壁，这粗暴的侵略之物让[NAME]整个人都快疯了，一波一波持续不断的冲击让渐渐沉沦其中。\n接连不断的高潮本早应当让[NAME]失去神志化为这欲海沉船，可神道传承中的那缕信仰之光一直守护着[NAME]神志的最后一道防线，直到猪妖体力不支瘫到在地，[NAME]还是获得了最终的成功为一方百姓驱退了妖群。"));me:AddFaith(me:RandomInt(100,200)*nN);me:AddGodPopulation(nN);me:ModifierProperty("GodPenaltyAddV",-me:RandomInt(3,8));me.npcObj.PropertyMgr:AddFeature("Pogua");me:AddMemery("在一次历练途中，为了保护百姓舍身于猪妖贴身肉搏三百回合，睡服了猪妖！");me:AddTitle(XT("被猪妖日过的女修士"),string.format(XT("在%s年，于一次历练途中，为了保护百姓舍身于猪妖贴身肉搏三百回合，睡服了猪妖"),1));me.npcObj.PropertyMgr:AddFeature("Huaitai_zhu");me.npcObj:AddModifier("Shouyun");story:FinishSecret();
end

function Hudong:shiqi36()
	me:AddModifier("Qian");
	local buff = me.npcObj.PropertyMgr:FindModifier("Qian");
	if me:GetSex () > 1 then
	local nN = me:RandomInt(math.floor(me:GetGLevel()^4 * 0.5),math.floor(me:GetGLevel()^4* 1))
	me:AddMsg(XT("[NAME]听到这幼子曾经扬言“三十年河东，三十年河西，莫欺少年穷！”之时，不经拍腿叫绝，这可是天命之子的专属台词啊，身为神修若能窃得一丝天命气运，修为必能精进不少，！\n故[NAME]化为凡女倒贴上门助其夺得长兄家业，并以美色诱之与[NAME]日夜欢好，终将炼其之天命之气化为自身修为，并得了遗产百两纹银。"));me.npcObj.PropertyMgr:AddFeature("Pogua");me:AddPracticeResource("Stage",10000);
	else
	me:AddMsg(XT("[NAME]听到这幼子曾经扬言“三十年河东，三十年河西，莫欺少年穷！”之时，不经拍腿叫绝，这可是天命之子的专属台词啊，若取而代之，岂不是能得其大因果纳百万信众！\n遂[NAME]于荒庙夺其皮囊承其因果，以其之身杀上长兄家中，大喊“那日长兄对我爱答不理，今日愚弟便是来告诉兄长什么是莫欺少年穷的！”，言毕便将其身之兄长毙与掌下，并占之妻女家业，诸般淫辱甚至于牧下之民共享之，此举为我教获得了不少信徒，[NAME]也获得了纹银百两。"));
	me:AddFaith(me:RandomInt(50,200)*nN);me:AddGodPopulation(nN);me:ModifierProperty("GodPenaltyAddV",-me:RandomInt(3,8));
	end
	buff:UpdateStack(99);
end

function Hudong:shiqi37()
	if me:GetSex() > 1 then
		if me:GetCharisma() > 7 then
			if me:GetGongName() == "Gong_1701_Tu" then
			me:AddMsg(XT("[NAME]见对方也算的上唇红齿白的小郎君，试图诱惑对方来上那么一炮，之见[NAME]轻佻香肩，对方变色授魂与，迫不及待的扑了上来，一手褪去[NAME]的亵裤，小兄弟便随后而至，许是刚刚射过一发，这次坚持了一刻有余才将阳精灌入[NAME]下体，可这短短一刻钟又如何能使得[NAME]心满意足，之见[NAME]双腿箍住对方腰间，也不管的对方是否已经软了下来，就是不让对方拔出来，许是泡了一会后因为蜜穴的压力，对方的小兄弟次站了起来，如此循环数次之后，对方发现这从舒畅的双修变成了单方面的采补，奈何此时已经被摄走了大量的精元，无法反抗了。\n[NAME]吸干了青莲剑宗弟子，对方甚至没有机会捏碎求救玉玦。"));
			me:AddMemery("在一次历练的途中倚靠腿间小口活活将一个青莲宗弟子抽成了人干！");me:AddModifier("Story_Caibuzhidao1");
			else
			me:AddMsg(XT("[NAME]见对方也算的上唇红齿白的小郎君，试图诱惑对方来上那么一炮，之见[NAME]轻佻香肩，对方变色授魂与，迫不及待的扑了上来，一手褪去[NAME]的亵裤，小兄弟便随后而至，许是刚刚射过一发，这次坚持了一刻有余才缴械投降，对方在[NAME]身上驰骋了个爽后便睡去，由于[NAME]也不会什么采补秘法，这一炮也就算是白挨了。"));
			end
		else
		me:AddMsg(XT("[NAME]见对方也算的上唇红齿白的小郎君，试图诱惑对方来上那么一炮，可显然对方显然看不上[NAME]腆着脸说什么“我们青莲剑宗是名门正派，不是那些邪道宵小，不能乱搞男女关系的”，完全不顾他刚才还当着[NAME]面强奸了他口中的前未婚妻。"));me:AddSchoolRelation(6,-30);
		end
	else
	me:AddMsg(XT("[NAME]见对方也算的上唇红齿白的小郎君，试图诱惑对方来上那么一炮，可显然对方不是玻璃，恼怒的拒绝了[NAME]。"));me:AddSchoolRelation(6,-10);
	end
end

function Hudong:shiqi38()
	if me:GetGongName() == "Gong_1701_Tu" then
		if me:GetSex() > 1 then
		me:AddMsg(XT("[NAME]虽是女子，却也不碍得自己对女子的喜欢，凡间所谓武学自然无法对身为修士的[NAME]造成阻扰，[NAME]轻而易举的制住了少女后，贝齿轻咬着对方的耳垂，双手也游走在少女下身，不时的触碰着少女的敏感地带，随着[NAME]指尖的入侵，少女面带飞霞轻声娇喘了起来……\n事毕，[NAME]正待离去，少女却扯着[NAME]的衣角好似上瘾般的不愿[NAME]离去，于是[NAME]将少女带在身边收为炉鼎。"));
		me:AddModifier("Story_Caibuzhidao1");
		me:AddModifier("Luding4");
		me:AddMemery("在一次历练的途中，与诱惑了一位少女与自己百合，并将对方调教成炉鼎带在身边！");
		else
			if me.npcObj.PropertyMgr.BodyData:PartIsBroken("Genitals") then
			me:AddMsg(XT("[NAME]也想要试图对少女做些什么，可奈何自己是个太监，心有余而力不足，只能将少女淫辱一番转身离去，被个太监一番折辱，使得少女心性大变，投身合欢一脉以图报复。"));me:AddSchoolRelation(11,-50);
			else
			me:AddMsg(XT("[NAME]蛮横的扯烂少女衣衫，将少女按到在地，胯下神器贯体而入，少女惊叫连连呼喊不止，奈何凡人武者之力反抗修士自是绝无可能，无力的反抗只能让[NAME]淫欲更盛，在一次又一次的脱力之后，少女的神志甚至都有些涣散了，却依旧不见[NAME]泄出阳元……\n数日调教之后，少女成为了[NAME]采补的炉鼎，被[NAME]带在了身边。"));
			me:AddModifier("Story_Caibuzhidao1");
			me:AddModifier("Luding4");
			me:AddMemery("在一次历练的途中，奸污了一名美貌少女，并将对方调教成母狗当做炉鼎带在身边！");
			end
		end
	else
	me:AddMsg(XT("[NAME]将少女淫辱把玩了一段时间，玩腻后便将少女贱卖于的青楼楚馆之中售得白银20两。"));
	me:AddModifier("Qian");
	local buff = me.npcObj.PropertyMgr:FindModifier("Qian");
	buff:UpdateStack(19);
	end
end

function Hudong:shiqi39()
	if SchoolMgr:IsGongUnLocked("Gong_1701_Tu") then
		if me:GetSex() > 1 then
		local Panding = me:RandomInt(1,10);
		me:AddModifier("Luding")
		local buff = me.npcObj.PropertyMgr:FindModifier("Luding");
		buff:UpdateStack(Panding-1);
		me:AddMsg(XT("[NAME]来到少女府邸，褪尽衫裙魅术挥洒，府中男子均化为[NAME]裙下之臣，[NAME]淫乐一番后便卷走了几个她相中的男子作为炉鼎回山采补。"));
		me:AddPracticeResource("Stage",me:GetGLevel() * 1000);me.npcObj.PropertyMgr:AddFeature("Pogua");
		elseif me.npcObj.PropertyMgr.BodyData:PartIsBroken("Genitals") then
		me:AddMsg(XT("[NAME]决定助那淫贼一臂之力，举手之间便将少女府上的家丁放翻，淫贼大喜之余将少女操弄了三四个时辰有余，作为一个凡人的淫贼有等持久度着实不太合理，但是[NAME]是个太监也不知道正常人能一次干多久，所以并未生疑，饱览了一番美景后便转身离去了。"));
		else
		me:AddMsg(XT("[NAME]如同谪仙一般从天而降，举手间便制住了淫贼，少女正待道谢却见[NAME]挥手击飞了一众府上家丁，将少女虏至卧房后一番折辱，经过数个时辰的奸淫调教，少女被驯为[NAME]胯下母犬，甘愿俯首跪于[NAME]脚下作一肉炉鼎玉蒲团。\n[NAME]将少女带回了门派，作为炉鼎饲养"));
		me:AddPracticeResource("Stage",me:GetGLevel() * 1000);me:AddModifier("Luding4");
		end
	else
		if me:GetSex() > 1 then
		me:AddMsg(XT("[NAME]决定助那淫贼一臂之力，举手之间便将少女府上的家丁放翻，淫贼大喜之余将少女操弄了三四个时辰，少女几近崩溃其胯下巨物却坚挺依旧，作为一个凡人的淫贼此等持久度着实不太合理，故[NAME]亲自上前与之大战三百回合，战至酣时[NAME]惊异的发现此人居然身怀异术，随即[NAME]一把掐住对方喉咙逼问对方！\n原来对方少年时期有所奇遇，居然有幸习得过合欢宗无上秘法，而此法也在[NAME]逼问之下被[NAME]取得。"));
		me:UnLockGong("Gong_1701_Tu");
		me.npcObj.PropertyMgr:AddFeature("Pogua");
		else
			if me.npcObj.PropertyMgr.BodyData:PartIsBroken("Genitals") then
			me:AddMsg(XT("[NAME]决定助那淫贼一臂之力，举手之间便将少女府上的家丁放翻，淫贼大喜之余将少女操弄了三四个时辰有余，作为一个凡人的淫贼有等持久度着实不太合理，但是[NAME]是个太监也不知道正常人能一次干多久，所以并未生疑，饱览了一番美景后便转身离去了。"));
			else
			me:AddMsg(XT("[NAME]得见官家小姐绰约风姿心下邪念大起，暗自下手将少女府上家丁放翻后，与淫贼一前一后干了四五个时辰，怀中少女都被干到两眼翻白不省人事，下体也烂糊一片惨不忍睹，而[NAME]却未和淫贼分出胜负，这着实有些不合常理，[NAME]作为修士能做到锁阳元不泻也就算了，这个作为凡人的采花淫贼凭什么有此等本事，随即[NAME]一把掐住对方喉咙逼问对方！\n原来对方少年时期有所奇遇，居然有幸习得过合欢宗无上秘法，而此法也在[NAME]逼问之下被[NAME]取得。"));
			me:UnLockGong("Gong_1701_Tu");
			end
		end
	end
end

function Hudong:shiqi40()
local Suiji = me:RandomInt(1,100);
local nR = world:RandomSchool(2,4);
local sR = world:GetSchoolName(nR);
local bR = world:RandomSchool(-4,-2);
local vR = world:GetSchoolName(bR);
	if Suiji > 80 then
		if me:GetSex() > 1 then
		me:AddMsg(XT("[NAME]取出了自己的干粮施于了灾民，可[NAME]却并不知晓{0}弟子早已混入这批灾民之中，伺机想要害人性命修炼邪功，[NAME]的插手让{0}弟子心底滋生了一条邪念。\n只见{0}弟子乘着[NAME]不备暗自祭出法宝，一击命中后[NAME]昏死了过去，{0}弟子一脸邪笑的掏出了胯下之器便是在[NAME]身上杀了个七进七出好不痛快。\n事毕，{0}弟子将[NAME]弃置与荒野后便转身离开了。"), vR);
		me:AddSchoolScore(1,-100);
		me.npcObj.PropertyMgr:AddFeature("Pogua");
		else
		me:AddMsg(XT("[NAME]取出了自己的干粮施于了灾民，可[NAME]却并不知晓{0}弟子早已混入这批灾民之中，伺机想要害人性命修炼邪功，[NAME]的插手让{0}弟子大为恼怒。\n只见{0}弟子乘着[NAME]不备暗自祭出法宝，一击命中后[NAME]昏死了过去后便转身离开了。"), vR);
		me:AddSchoolScore(1,-100);
		end
	else
		if Suiji > 45 then
		me:AddMsg(XT("[NAME]决定帮助灾民。\n[NAME]取出了自己的干粮施于了灾民，此举被刚好经过的{0}弟子看到，{0}弟子与[NAME]一起携手援助灾民之时，结下了一段情谊，此举使得{0}对本门的感观上升，亦提升了本门在凡间的声望。"), sR);
		me:AddSchoolRelation(nR,10);me:AddSchoolScore(2,50);
		else
		me:AddMsg(XT("[NAME]决定帮助灾民。\n[NAME]取出了自己的干粮施于了灾民\n灾民获得食物后连连感谢[NAME]慷慨仗义，本门在凡间的声望有所提高。"));
		me:AddSchoolScore(2,50);
		end
	end
end

function Hudong:shiqi41()
	if me:GetGongName() == "Gong_1701_Tu" then
		if me:GetSex() > 1 then
		me:AddMsg(XT("[NAME]对一众男性灾民施展迷情之术，一众男性灾民均丧失了理智，近靠上前的或擒或抱于[NAME]身上的三大孔穴抽插个不停，没挤进第一次梯队的也尝试着努力向前推进，仿佛即使挤上前去舔上一口[NAME]的肌肤也是极美的事情，而那些连第二梯队都排不上号的灾民，则将目光瞄准了周遭同为灾民的女子们，虽然她们没有[NAME]那冰肌玉骨，亦不如[NAME]那样有着惊世之貌，可至少还是个女人不是……\n一阵狂欢之后，只留下了一地被抽成人干的男子，以及一群瘫软在地衣衫尽碎身上伤的妇孺。"));
		me:AddSchoolScore(3,100);me:AddPracticeResource("Stage",5000);me:AddModifier("Story_Caibuzhidao1");me.npcObj.PropertyMgr:AddFeature("Pogua");
		elseif me.npcObj.PropertyMgr.BodyData:PartIsBroken("Genitals") then
		me:AddMsg(XT("[NAME]施展迷情之术，一众灾民均丧失了理智欲火焚身，直接原地乱交了起来。\n然而[NAME]虽然学了采补功法，但自己却是个太监，没有这个功能无法加入战局，无奈之下只好转换术法将对方抽魂炼珀以壮自身修为，\n因灾民均中了迷情之法，所以没人知道这事情是[NAME]干的。"));
		me:AddPracticeResource("Stage",2500);
		else
		me:AddMsg(XT("[NAME]看了一眼一众灾民，深感眼前一堆臭鱼烂虾，毕竟日晒雨淋的劳苦大众，怎么可能生的出绝色佳人呢，这着实是闭着眼睛都下不去吊，[NAME]随手便打出几个法印将一众灾民摧魂练珀，用以提升自己修为。\n因灾民均中了迷情之法，所以没人知道这事情是[NAME]干的。"));
		me:AddPracticeResource("Stage",2500);
		end
	else
	me:AddMsg(XT("[NAME]心道一声“天地不仁以万物为刍狗。”思前想后觉得如此灾荒年景想来这些灾民也是无法好好生活的，与其苟延残喘痛苦的活着，不如把他们抽魂炼珀助自己修为更近一步来着呢。\n说干就干[NAME]连忙操起秘法将一众灾民囚魂锁珀祭炼成凶魂历煞以助自身修炼。\n此事虽办得隐秘，可还是有若干幸存者逃出生天，本派的恶名更加远播了。"));
	me:AddSchoolScore(3,100);me:AddPracticeResource("Stage",2500);
	end
end

function Hudong:shiqi42()
	if me:GetSex() == 1 then
		if me.npcObj.PropertyMgr.BodyData:PartIsBroken("Genitals") then
		me:AddMsg(XT("[NAME]见少女姿色尚可便将少女敲晕后绑走了。"));
		me:AddModifier("Luding4");
		elseif me:GetGongName() == "Gong_1701_Tu" then
		me:AddMsg(XT("[NAME]见少女姿色颇为诱人，击倒了少女将其拖至无人处，驾起少女双腿便是一顿冲刺，待少女泄身脱力之时，运起六欲心经中的采补之术将少女阴元采补一空。\n事毕，[NAME]便将少女打包带走了。"));
		me:AddModifier("Story_Caibuzhidao1");me:AddModifier("Luding4");
		else
		me:AddMsg(XT("[NAME]见少女姿色颇为诱人，击倒了少女将其拖至无人处，驾起少女双腿便是一顿冲刺。\n事毕，[NAME]便将少女打包带走了。"));
		me:AddModifier("Luding4");
		end
	else
	me:AddMsg(XT("[NAME]见少女姿色颇为诱人，击倒了少女将其拖至无人处，拿出了自己的双头龙与之酣战了起来。\n事毕，[NAME]便将少女打包带走了。"));
	me:AddModifier("Luding4");me.npcObj.PropertyMgr:AddFeature("Pogua");
	end
end

function Hudong:shiqi43()
me:AddModifier("Qian");
me.npcObj.PropertyMgr:FindModifier("Qian"):UpdateStack(999);
	if me:GetSex() == 2 then
	me:AddMsg("城尉府女眷的房间里城尉新纳的如夫人坐在床边，又一白面书生钻进她的衣裙下大舌头在那泥泞的嫩穴上不断舔舐的啧啧有声让其发出阵阵呻吟。\n夫人一手隔着纱裙抚摸着白面书生的头一手抓揉着自己胸前的丰满乳房心里却想着此刻自己夫君就在离自己不远的房间里自己却在与其他男人欢好这种刺激的感觉让夫人不住的颤抖还轻轻挺动着小腰把嫩穴往白面书生嘴里凑。\n 不一会伴随着夫人的一阵颤抖她将阴精泄在了白面书生嘴里白面书生将这甜美的淫液大口的吞进肚里嘴里还剩了一口他钻出裙子轻轻拥住夫人柔美的娇躯将嘴里的淫液全部度进了夫人的嘴里接着两人的舌头不断的纠缠这一口混杂着两人津液的液体也不断在两人的嘴里来回最后全被白面书生一口吞进了肚中。\n夫人推开了白面书生在自己胸前肆虐的手喘息着说道：「行了你快回去吧。」\n「夫人给我吧我想要你。」白面书生不依不饶的纠缠着她伸手往她胯下探去。\n「不行不行…….」夫人不停的摇晃着头双手抵抗者白面书生的袭扰不过法力高强的她此刻却只能在白面书生面前勉力抵抗不一会就被白面书生扒光了衣服按在身下。\n 白面书生的裤子之解下了一半露出又粗又长的肉茎紫红色的大龟头在夫人汁液茂盛的淫穴上磨蹭着。\n 夫人双手抓着白面书生滚烫的大肉棒依然在拒绝：「不行要是相公突然过来了怎么办？」\n 白面书生见夫人虽然嘴里抗拒着可那双手却依然紧紧握着自己的肉棒不松手不由得心中暗喜嘴里轻声安慰着：「不会的已经这么晚了龙大人不会过来的。」一边说着一边将肉棒往小嫩穴里缓缓推进着。\n「哦…」 夫人被白面书生着滚烫的巨物侵入体内身体浑身颤栗着脑海中一边想着龙大人一边期待着即将到来的欢爱。\n 白面书生抓着夫人的双乳挺动熊腰有节奏的在夫人紧致的小穴内抽插着心中无限满足自己终于征服了这个龙大人新纳的小妾，从此以后她的娇躯也可以任由自己享用了。\n这样操干了她一会儿白面书生又让夫人跪在床上双手把住她纤细的腰肢从背后刺入了她的嫩穴待龟头撞击子宫那一刻龙夫人美的高高的扬起了头嘴里发出靡靡之音。「嗯……好粗……好长……噢……顶到底了……」\n白面书生不断冲击着眼前的美臀，这种身份和偷情的快感让白面书生迷醉，他一手抓住夫人四下飞舞的秀发如同骑士挽着马缰一般骑着夫人这匹母马，同时轻轻拍打着她的翘臀。\n「我们去找龙大人好不好？」白面书生从背后拥住夫人一手握着一个美乳。\n白面书生的提议让夫人浑身一紧那种刺激只是想想就让她激动不已。\n虽然夫人只是轻声喘息着没有回话可白面书生已经得到了答桉于是他欣喜的将夫人苗条轻盈的身子面对面抱在怀里打开了房门。\n夫人莲藕般的双手缠在白面书生的颈后一双修长健美的长腿仅仅缠绕在白面书生的腰上胯下的小嫩穴紧紧咬着白面书生的肉茎随着白面书生每走一步都会不断摩擦着她的肉穴让她轻轻的呻吟着。\n「唔……啊……你好色啊……大肉棒越来越硬了……喔……」屋外的冷风吹拂在紧紧相拥的两人赤裸的身上可这不仅没有熄灭他们的欲 火反而更添了一些刺激让夫人忍不住轻轻扭动着小腰缓解小穴的饥渴。\n深夜的龙府寂静无声，灯笼里的火也已经熄灭了，白面书生抱着赤裸的夫人缓缓走到了龙大人的房间外，此刻龙大人正沉睡着完全不知道自己心爱的娇妻正被别的男人在离自己几步的方侵犯着。\n月光下白面书生和夫人对视了一眼皆是看到了对方眼里的情欲于是没有 废话白面书生轻轻放下夫人儿让她手撑在龙大人房外的假山上踮起脚尖将雪臀高高翘起。\n 白面书生看着月光下这惊艳绝伦的娇躯忍不住反复把玩摩挲才将自己的肉茎刺入夫人温暖的小嫩穴中不断的抽插着。\n「唔…」\n夫人的身躯随着白面书生的冲刺不断的摇晃着由于夫君就在不远处因此夫人不敢呻吟只得把头发咬在嘴里勉强忍耐着目光迷离。\n这种刺激对于白面书生来说同样令他痴迷令他疯狂只有不断的操弄着眼前的娇躯才能缓解。\n「呜……」白面书生再也忍不住那一阵阵销魂蚀骨的刺激，屁股用力一压，大阴茎尽根而入，花心失守，凶勐的肉棒狠狠地撞入子宫颈，深深地挺进了幽深的子宫深处。\n剧烈的撞击使得两人的下体紧紧地合在了一起，到了无以复加的地步。\n蜜穴内部的层层嫩肉的阵阵紧裹夹吸使得肉棒酥麻无比，子宫紧紧地吸住了肉棒，巨大的快感让他几乎到达了爆发的临界点。\n白面书生不禁地大声叫喊道：「宝贝……我忍不住了……我要射了……」\n「我也要到了……再用力点……我要嘛……」两人就在这月光下龙大人的房外拼命交合着。\n「啊……美人……全都射给你了」……\n「坏人……都给你了……嗯……我要怀上你的种了……啊……」最后伴随着白面书生的冲刺和夫人的低声淫语白面书生将滚烫的精液射进了她的子宫里。\n\n而这一切，都被夜探城尉府的[NAME]所窥探到了。\n在这对奸夫淫妇泄身脱力之后，[NAME]缓缓步出，举着留影石于对方一通威胁，榨取了千两纹银后，便转身遁入黑夜之中……");
	elseif me.npcObj.PropertyMgr.BodyData:PartIsBroken("Genitals") then
	me:AddMsg("城尉府女眷的房间里城尉新纳的如夫人坐在床边，又一白面书生钻进她的衣裙下大舌头在那泥泞的嫩穴上不断舔舐的啧啧有声让其发出阵阵呻吟。\n夫人一手隔着纱裙抚摸着白面书生的头一手抓揉着自己胸前的丰满乳房心里却想着此刻自己夫君就在离自己不远的房间里自己却在与其他男人欢好这种刺激的感觉让夫人不住的颤抖还轻轻挺动着小腰把嫩穴往白面书生嘴里凑。\n 不一会伴随着夫人的一阵颤抖她将阴精泄在了白面书生嘴里白面书生将这甜美的淫液大口的吞进肚里嘴里还剩了一口他钻出裙子轻轻拥住夫人柔美的娇躯将嘴里的淫液全部度进了夫人的嘴里接着两人的舌头不断的纠缠这一口混杂着两人津液的液体也不断在两人的嘴里来回最后全被白面书生一口吞进了肚中。\n夫人推开了白面书生在自己胸前肆虐的手喘息着说道：「行了你快回去吧。」\n「夫人给我吧我想要你。」白面书生不依不饶的纠缠着她伸手往她胯下探去。\n「不行不行…….」夫人不停的摇晃着头双手抵抗者白面书生的袭扰不过法力高强的她此刻却只能在白面书生面前勉力抵抗不一会就被白面书生扒光了衣服按在身下。\n 白面书生的裤子之解下了一半露出又粗又长的肉茎紫红色的大龟头在夫人汁液茂盛的淫穴上磨蹭着。\n 夫人双手抓着白面书生滚烫的大肉棒依然在拒绝：「不行要是相公突然过来了怎么办？」\n 白面书生见夫人虽然嘴里抗拒着可那双手却依然紧紧握着自己的肉棒不松手不由得心中暗喜嘴里轻声安慰着：「不会的已经这么晚了龙大人不会过来的。」一边说着一边将肉棒往小嫩穴里缓缓推进着。\n「哦…」 夫人被白面书生着滚烫的巨物侵入体内身体浑身颤栗着脑海中一边想着龙大人一边期待着即将到来的欢爱。\n 白面书生抓着夫人的双乳挺动熊腰有节奏的在夫人紧致的小穴内抽插着心中无限满足自己终于征服了这个龙大人新纳的小妾，从此以后她的娇躯也可以任由自己享用了。\n这样操干了她一会儿白面书生又让夫人跪在床上双手把住她纤细的腰肢从背后刺入了她的嫩穴待龟头撞击子宫那一刻龙夫人美的高高的扬起了头嘴里发出靡靡之音。「嗯……好粗……好长……噢……顶到底了……」\n白面书生不断冲击着眼前的美臀，这种身份和偷情的快感让白面书生迷醉，他一手抓住夫人四下飞舞的秀发如同骑士挽着马缰一般骑着夫人这匹母马，同时轻轻拍打着她的翘臀。\n「我们去找龙大人好不好？」白面书生从背后拥住夫人一手握着一个美乳。\n白面书生的提议让夫人浑身一紧那种刺激只是想想就让她激动不已。\n虽然夫人只是轻声喘息着没有回话可白面书生已经得到了答桉于是他欣喜的将夫人苗条轻盈的身子面对面抱在怀里打开了房门。\n夫人莲藕般的双手缠在白面书生的颈后一双修长健美的长腿仅仅缠绕在白面书生的腰上胯下的小嫩穴紧紧咬着白面书生的肉茎随着白面书生每走一步都会不断摩擦着她的肉穴让她轻轻的呻吟着。\n「唔……啊……你好色啊……大肉棒越来越硬了……喔……」屋外的冷风吹拂在紧紧相拥的两人赤裸的身上可这不仅没有熄灭他们的欲 火反而更添了一些刺激让夫人忍不住轻轻扭动着小腰缓解小穴的饥渴。\n深夜的龙府寂静无声，灯笼里的火也已经熄灭了，白面书生抱着赤裸的夫人缓缓走到了龙大人的房间外，此刻龙大人正沉睡着完全不知道自己心爱的娇妻正被别的男人在离自己几步的方侵犯着。\n月光下白面书生和夫人对视了一眼皆是看到了对方眼里的情欲于是没有 废话白面书生轻轻放下夫人儿让她手撑在龙大人房外的假山上踮起脚尖将雪臀高高翘起。\n 白面书生看着月光下这惊艳绝伦的娇躯忍不住反复把玩摩挲才将自己的肉茎刺入夫人温暖的小嫩穴中不断的抽插着。\n「唔…」\n夫人的身躯随着白面书生的冲刺不断的摇晃着由于夫君就在不远处因此夫人不敢呻吟只得把头发咬在嘴里勉强忍耐着目光迷离。\n这种刺激对于白面书生来说同样令他痴迷令他疯狂只有不断的操弄着眼前的娇躯才能缓解。\n「呜……」白面书生再也忍不住那一阵阵销魂蚀骨的刺激，屁股用力一压，大阴茎尽根而入，花心失守，凶勐的肉棒狠狠地撞入子宫颈，深深地挺进了幽深的子宫深处。\n剧烈的撞击使得两人的下体紧紧地合在了一起，到了无以复加的地步。\n蜜穴内部的层层嫩肉的阵阵紧裹夹吸使得肉棒酥麻无比，子宫紧紧地吸住了肉棒，巨大的快感让他几乎到达了爆发的临界点。\n白面书生不禁地大声叫喊道：「宝贝……我忍不住了……我要射了……」\n「我也要到了……再用力点……我要嘛……」两人就在这月光下龙大人的房外拼命交合着。\n「啊……美人……全都射给你了」……\n「坏人……都给你了……嗯……我要怀上你的种了……啊……」最后伴随着白面书生的冲刺和夫人的低声淫语白面书生将滚烫的精液射进了她的子宫里。\n\n而这一切，都被夜探城尉府的[NAME]所窥探到了。\n在这对奸夫淫妇泄身脱力之后，[NAME]缓缓步出，举着留影石于对方一通威胁，榨取了千两纹银后，便转身遁入黑夜之中……");
	else
	me:AddMsg("城尉府女眷的房间里城尉新纳的如夫人坐在床边，又一白面书生钻进她的衣裙下大舌头在那泥泞的嫩穴上不断舔舐的啧啧有声让其发出阵阵呻吟。\n夫人一手隔着纱裙抚摸着白面书生的头一手抓揉着自己胸前的丰满乳房心里却想着此刻自己夫君就在离自己不远的房间里自己却在与其他男人欢好这种刺激的感觉让夫人不住的颤抖还轻轻挺动着小腰把嫩穴往白面书生嘴里凑。\n 不一会伴随着夫人的一阵颤抖她将阴精泄在了白面书生嘴里白面书生将这甜美的淫液大口的吞进肚里嘴里还剩了一口他钻出裙子轻轻拥住夫人柔美的娇躯将嘴里的淫液全部度进了夫人的嘴里接着两人的舌头不断的纠缠这一口混杂着两人津液的液体也不断在两人的嘴里来回最后全被白面书生一口吞进了肚中。\n夫人推开了白面书生在自己胸前肆虐的手喘息着说道：「行了你快回去吧。」\n「夫人给我吧我想要你。」白面书生不依不饶的纠缠着她伸手往她胯下探去。\n「不行不行…….」夫人不停的摇晃着头双手抵抗者白面书生的袭扰不过法力高强的她此刻却只能在白面书生面前勉力抵抗不一会就被白面书生扒光了衣服按在身下。\n 白面书生的裤子之解下了一半露出又粗又长的肉茎紫红色的大龟头在夫人汁液茂盛的淫穴上磨蹭着。\n 夫人双手抓着白面书生滚烫的大肉棒依然在拒绝：「不行要是相公突然过来了怎么办？」\n 白面书生见夫人虽然嘴里抗拒着可那双手却依然紧紧握着自己的肉棒不松手不由得心中暗喜嘴里轻声安慰着：「不会的已经这么晚了龙大人不会过来的。」一边说着一边将肉棒往小嫩穴里缓缓推进着。\n「哦…」 夫人被白面书生着滚烫的巨物侵入体内身体浑身颤栗着脑海中一边想着龙大人一边期待着即将到来的欢爱。\n 白面书生抓着夫人的双乳挺动熊腰有节奏的在夫人紧致的小穴内抽插着心中无限满足自己终于征服了这个龙大人新纳的小妾，从此以后她的娇躯也可以任由自己享用了。\n这样操干了她一会儿白面书生又让夫人跪在床上双手把住她纤细的腰肢从背后刺入了她的嫩穴待龟头撞击子宫那一刻龙夫人美的高高的扬起了头嘴里发出靡靡之音。「嗯……好粗……好长……噢……顶到底了……」\n白面书生不断冲击着眼前的美臀，这种身份和偷情的快感让白面书生迷醉，他一手抓住夫人四下飞舞的秀发如同骑士挽着马缰一般骑着夫人这匹母马，同时轻轻拍打着她的翘臀。\n「我们去找龙大人好不好？」白面书生从背后拥住夫人一手握着一个美乳。\n白面书生的提议让夫人浑身一紧那种刺激只是想想就让她激动不已。\n虽然夫人只是轻声喘息着没有回话可白面书生已经得到了答桉于是他欣喜的将夫人苗条轻盈的身子面对面抱在怀里打开了房门。\n夫人莲藕般的双手缠在白面书生的颈后一双修长健美的长腿仅仅缠绕在白面书生的腰上胯下的小嫩穴紧紧咬着白面书生的肉茎随着白面书生每走一步都会不断摩擦着她的肉穴让她轻轻的呻吟着。\n「唔……啊……你好色啊……大肉棒越来越硬了……喔……」屋外的冷风吹拂在紧紧相拥的两人赤裸的身上可这不仅没有熄灭他们的欲 火反而更添了一些刺激让夫人忍不住轻轻扭动着小腰缓解小穴的饥渴。\n深夜的龙府寂静无声，灯笼里的火也已经熄灭了，白面书生抱着赤裸的夫人缓缓走到了龙大人的房间外，此刻龙大人正沉睡着完全不知道自己心爱的娇妻正被别的男人在离自己几步的方侵犯着。\n月光下白面书生和夫人对视了一眼皆是看到了对方眼里的情欲于是没有 废话白面书生轻轻放下夫人儿让她手撑在龙大人房外的假山上踮起脚尖将雪臀高高翘起。\n 白面书生看着月光下这惊艳绝伦的娇躯忍不住反复把玩摩挲才将自己的肉茎刺入夫人温暖的小嫩穴中不断的抽插着。\n「唔…」\n夫人的身躯随着白面书生的冲刺不断的摇晃着由于夫君就在不远处因此夫人不敢呻吟只得把头发咬在嘴里勉强忍耐着目光迷离。\n这种刺激对于白面书生来说同样令他痴迷令他疯狂只有不断的操弄着眼前的娇躯才能缓解。\n「呜……」白面书生再也忍不住那一阵阵销魂蚀骨的刺激，屁股用力一压，大阴茎尽根而入，花心失守，凶勐的肉棒狠狠地撞入子宫颈，深深地挺进了幽深的子宫深处。\n剧烈的撞击使得两人的下体紧紧地合在了一起，到了无以复加的地步。\n蜜穴内部的层层嫩肉的阵阵紧裹夹吸使得肉棒酥麻无比，子宫紧紧地吸住了肉棒，巨大的快感让他几乎到达了爆发的临界点。\n白面书生不禁地大声叫喊道：「宝贝……我忍不住了……我要射了……」\n「我也要到了……再用力点……我要嘛……」两人就在这月光下龙大人的房外拼命交合着。\n「啊……美人……全都射给你了」……\n「坏人……都给你了……嗯……我要怀上你的种了……啊……」最后伴随着白面书生的冲刺和夫人的低声淫语白面书生将滚烫的精液射进了她的子宫里。\n\n而这一切，都被夜探城尉府的[NAME]所窥探到了。\n[NAME]看的小腹中欲火丛生，击晕了那个白面书生后，又将泄身脱力的城尉夫人按在身下干弄了半个时辰，带满足了自身肉欲之后，最将此女掳为性奴，并伺机窃取了千余两纹银……");
	me:AddModifier("Luding2");
	end
end

function Hudong:shiqi44()
me:AddMsg("[NAME]相貌还算不错的青莲女弟子，不禁淫心大动，几下将对方扒成一只小白羊后掏出自己的肉棒往对方小穴中抽插了起来。\n百余下活塞之后，青莲女弟子元阴大泄，[NAME]趁机运起功法将对方采补殆尽，化成了一具干尸。");
me:AddModifier("Story_Caibuzhidao1");
end

function Hudong:shiqi45()
me:AddMsg("对方面带淫笑的说到：“姑娘身上那香香的处子气息让小生意乱神迷，可愿与小生共赴那巫山，双修一番与否？”\n保留着处子之身的女修可是修真界的稀有资源，[NAME]自然不会让对方白嫖自己一番，商讨之后对方愿出纹银五千两，外加份地母灵液来换取[NAME]的处子之身。\n谈妥之后合欢男修便褪去裤子露出下身那如同巨蟒一般的大棒，看的[NAME]脸红心道：“居然那么……”，未等[NAME]在多想其他，这条巨蟒般的肉棒便突入了[NAME]的小穴一路势如破竹直取花心。\n破瓜之痛使得[NAME]不禁喊出声来，可随后便沉醉于对方超绝的性技中，直到被干到双眼翻白神志不清后被对方采补了一番……最后甚至连嫖资都没收到。");
me:AddModifier("Story_Caibuzhidao2");me.npcObj.PropertyMgr:AddFeature("Pogua");
end

function Hudong:shiqi46()
me:AddMsg("合欢男修面带淫笑的说到：“姑娘这绝色之姿容让小生意乱神迷，可愿与小生共赴那巫山，双修一番与否？”\n[NAME]并非一个处子，所以并不介意和别人随缘来上那么一炮，可是怎么说[NAME]也算的上是美人，给人白玩着实没道理\n于是在一番商讨之后对方愿出纹银千两与自己共度一宵，[NAME]觉得这个价格挺合理的便和对方寻了个地方干了起来……");
	if me:GetGongName() == "Gong_1701_Tu" then
		if me:GetModifierStack("Story_Caibuzhidao1") > 80 then
		me:AddMsg("与合欢男修酣战之余，[NAME]默颂合欢残篇心法口诀暗运功法，对方不查居然着了[NAME]的道，被[NAME]脐下三寸的小口活活吸成了人干……\n事毕，[NAME]从对方身上翻出了纹银万两。");
		me:AddModifier("Story_Caibuzhidao1");
		me:AddModifier("Qian");
		local buff = me.npcObj.PropertyMgr:FindModifier("Qian");
		buff:UpdateStack(9999);
		else
		me:AddMsg("与合欢男修酣战之余，[NAME]默颂合欢残篇心法口诀暗运功法，奈何道行太浅（采补总次数低于80），被对方察觉反被干到死去活来神失色迷……");
		me:ModifierProperty("MaxAge",-100);
		me:AddModifier("Story_Caibuzhidao2");
		end
	else
	me:AddMsg("与合欢男修酣战了数个时辰后于一阵水乳交融之后，结束了这次双修，双方对此都挺满意，觉得这是一次不错的双修。\n对方爽气的支付了一千两嫖资。");
	me:AddPracticeResource("Stage",me:GetGLevel() * 800);
	me:AddModifier("Qian");
	local buff = me.npcObj.PropertyMgr:FindModifier("Qian");
	buff:UpdateStack(999);
	end
end

function Hudong:shiqi47()
me:AddMsg("合欢男修面带淫笑的指着[NAME]的一个女俘虏说到：“道友好艳福啊，道友身边的这个女奴我实在喜欢的紧，可否割爱？”\n[NAME]对这个女奴也欢喜不已，自是不愿，割爱于合欢男修，见[NAME]坚持不愿割爱，合欢男修又道：“那这样，我出百两纹银，这女子与我玩上一番可否？”\n[NAME]心想这好像还不错，反正也那么大个活人也不可能玩两下就坏了不是，便答应了对方的要求。");
	if me:GetSex() == 2 then
		if me:CheckItemEquptCount("Item_Shuangtoulong") == 1 then
		me:AddMsg("合欢男修一把揽住[NAME]的女俘虏，一脸淫笑，手向身下探去。湿润之中却摸到了一粗长硬物，男修不惊反喜，抓住双头龙的一端便捣弄起来。\n“啊……嗯嗯额……”女子愈渐兴奋，忽然之间，反守为攻，趁着那男修玩得入神，将他牢牢压在身下，将沾满淫水的双头龙直向后庭刺去——“啊！”男修痛的叫出声来，不料女子技艺高妙，几番云雨之下令他之上云霄，体会了至今从未体会过的快乐。\n“啊……”他在极乐之中竟泄出了元阳，事后回味，却仍意犹未尽。\n事毕，合欢男修竟然成了[NAME]俘虏的裙下公狗……。[NAME]惊喜的从对方身上获得了万两纹银。");
		me:AddModifier("Luding5");
		me:AddModifier("Qian");
		local buff = me.npcObj.PropertyMgr:FindModifier("Qian");
		buff:UpdateStack(9999);
		else
		me:AddMsg("男修给了银子，一把抓过[NAME]的女俘虏，将她按在地上，单喝道，“舔。”那女子跪着仰视男修那雄壮的阳物，嗅着上面雄性特有的腥臊气息，心中荡漾，淫水早已流了一地，心下暗道，“这男人不仅财力雄厚，下面的本钱也这般了得。”不由得就已心神意属于他了，顺从而小心的侍奉着男修的阳物，马眼中流出的液体也喜悦的吞下。一边舔舐着，自己的右手在身下也开始抚弄着泥泞的花穴，男修看着女人这般骚浪，再也忍受不住，提起长枪直刺而入，开始纵横驰骋，二人一番欢愉。可那合欢男修却仍觉不尽兴，待女子用那樱桃小口侍弄完他沾满淫液的阳具后，他用那粗长之物抽打女子脸颊，命令道，“报数。”“1、2、3……”每抽打一下女子便乖乖的报出下一个数字。男修玩得爽快，大笑之下将女子翻过身去，女子跪趴着，他一手扶着她的细腰，另一手伴随着抽插的节奏拍打着她的翘臀。“啊！……哦……不要停……”打得愈渐用力，女子叫的却也愈显贱浪。“贱狗，你说你怎么这么骚啊？”男修停下动作问道。女子急得自己向后耸动了起来，“不，不要停，我是主人的贱母狗，求主人操死我。”一番云雨，待男修射出阳精后，竟发现那女人晕死了过去。事毕，[NAME]的俘虏成为了合欢男修的女奴隶。");
		me:AddModifier("Qian");
		local buff = me.npcObj.PropertyMgr:FindModifier("Qian");
		local buff2 = me.npcObj.PropertyMgr:FindModifier("Luding4");
		buff:UpdateStack(99);
		buff:UpdateStack(-1);
		end
	else
		if me.npcObj.PropertyMgr.BodyData:PartIsBroken("Genitals") then
		me:AddMsg("男修定睛凝视[NAME]的俘虏，目光一刻也难移开，只觉天上仙子也不如她半分美貌，挽过她窈窕的身姿，伸手轻抚她的长发，不经意间嗅到了那沁人心脾的芬芳而愈渐沉醉。\n二人相拥而吻，男修按奈不住，用手抚过她的后腰，直至臀部，一捏一放，他的阳物此刻已万分坚挺，“宝贝，我们把衣服脱了吧。\n”合欢男修欣赏着那衣物一件一件的从她身上褪下，眼神中充满了欲火，怎奈她褪下亵裤后却让他慌了神——“这，这是没怎么回事？”他指着她的下体，那里不似女子的蜜缝，只有一道疤痕。\n她怯生生的道，“奴奴自幼便被阉割为奴，因生的好看，学了这以色侍人的本事。那些女子会的，奴奴也会，还望真人不要嫌弃人家。”语毕，便跪下用香舌侍弄起男修的阳物，舔、拢、吸、拨，花样层出，男修只站在那里，舒服极了，看着她精致的容颜，竟也心生了一丝怜惜，心想，“任他男女，如此尤物，便是九天玄女也是不及的。\n”二人几度巫山，以致极乐。事毕，合欢男修赠与了[NAME]万两纹银，将这个美“女”俘虏从[NAME]手中赎买出来。");
		me:AddModifier("Qian");
		local buff = me.npcObj.PropertyMgr:FindModifier("Qian");
		local buff2 = me.npcObj.PropertyMgr:FindModifier("Luding4");
		buff:UpdateStack(9999);
		buff:UpdateStack(-1);
		else
		me:AddMsg("[NAME]对方将[NAME]的女奴玩弄一番后，支付了嫖资一百两。");
		me:AddModifier("Qian");
		local buff = me.npcObj.PropertyMgr:FindModifier("Qian");
		buff:UpdateStack(99);
		end
	end
end

function Hudong:shiqi48()
me:AddMsg("[NAME]祭起了法宝偷袭了这个老乞丐，却未曾想到这个自己的法宝甚至无法在对方身上造成丝毫伤害……");
	if me:GetSex() == 2 then
	me:AddMsg("老乞丐：“丫头，你本事不大脾气不小呀？”，言罢便将[NAME]制住，将其带至万花楼交予老鸨……\n其后的一段日子里，[NAME]则在万花楼中接客数十日，才被同门赎出……");
	me.npcObj.PropertyMgr:AddFeature("Pogua");
	else
	me:AddMsg("老乞丐：“孙贼，你本事不大脾气不小呀？”，言罢便将[NAME]制住，在其口中塞入了一颗奇怪的丹药，丹药入腹[NAME]觉得浑身如同着火了一般，当即昏迷过去，而后老乞丐将其带至万花楼交予老鸨……\n[NAME]醒来之后，才发现自己被卖入万花楼，还特么变成了个女人！\n其后的一段日子里，[NAME]则在万花楼中接客数十日，才被同门赎出……");
	me.npcObj.PropertyMgr:SetSex(CS.XiaWorld.g_emNpcSex.Female)
	me.npcObj.PropertyMgr:AddFeature("Pogua");
	end
	me.npcObj.PropertyMgr:AddFeature("WHLjinv")
	world:SetWorldFlag(1701,1)
end

function Hudong:shiqi49()
	if me:GetSex() == 2 then
		if me:GetAge() < 30 and me:CheckFeature("Pogua") == true then--三十以下的非处
		me:AddMsg("那名合欢男修打量了[NAME]一番，眼露迷离之色，似还要在说些什么，只见那女修在他腰间狠狠的掐了一把，男修讪讪，弯腰递上了一道木牌，“这是会场的通行证，你收好了。”\n[NAME]接过通行证，点头便上山去了。");
		me:TriggerStory("Hehuanzongshiliannv1");
		elseif me:GetAge() < 30 and me:CheckFeature("Pogua") ~= true then--三十以下的处女
		me:AddMsg("合欢男修从上到下对[NAME]打量了一番，一声邪笑便蒙骗[NAME]至后院，制住了[NAME]后叫来了门内同伴将[NAME]轮奸采补了一番，毕竟大好的元阴处女，理论上在合欢宗算得上稀缺资源……\n[NAME]被合欢弟子采补至油尽灯枯后才被丢弃……");
		me.npcObj.PropertyMgr:AddFeature("Pogua");me:ModifierProperty("MaxAge",-200);me:AddSchoolRelation(11,-50);
		else--三十以上
		me:AddMsg("合欢男修从头到脚，对着[NAME]仔仔细细的一番打量。[NAME]被看得不舒服，眼神向撇一旁。\n女修不耐，“别看了，就是超年龄了，让她走吧。”\n“可这身材，这模样……”男修看得有些痴了。\n女修蹙眉，“要死啊你！”\n那名合欢男修无奈之下，只得步送[NAME]离开。待行至稍远，男修递上一道灵牌，“这是我的通讯符咒，他日若是遇到什么难处，随时可以找我。”临了男修还送上一袋银两，趁机在[NAME]手中摸了一把。\n[NAME]因年龄超出要求，未能参加无遮大会，[NAME]获得银两200，合欢派好感+50。");
		me:AddModifier("Qian");
		me.npcObj.PropertyMgr:FindModifier("Qian"):UpdateStack(199);
		me:AddSchoolRelation(11,50);
		end
	else
	me:AddMsg("合欢男修完全没有搭理[NAME]的意思……");
	me:TriggerStory("Secrets_shiqi_3");
	end
end

function Hudong:shiqi50()
	if ( me:CheckFeature("BeautifulFace2") == true and me:CheckItemEquptCount("Item_Tiaodan") == 1 ) or ( me:GetCharisma() > 9 and me:CheckItemEquptCount("Item_Tiaodan") == 1 ) then
	me:AddMsg("作为大会的管理者之一，明德长老在看台上扫视着这些女修，心道，这届的女修质量似不及往届了，或许是该把奖励往上提提了？\n——忽然，他看到了一个绝美的身影。\n从头到脚，甚至是每一根发丝，都堪称完美，这是上天最为精心的造物。她只是站在那里，似是放不开，不敢有所动作，但会场之上所有的女子与她相比都相形见绌。她是这场上最耀眼的一颗明珠。\n只是，要怎样做，才能把这颗明珠据为己有呢？\n明德长老皱起了眉，细细回顾那女子入场时的步履姿态。不对，她的骚屄里绝对夹着东西，“还真是个小骚货，装的这么纯。”\n明德长老略作思量，心中便有了计较。\n这进场后的第一步只是为了检验这些女子的样貌身材，选优汰劣，避免玩起来的时候遇到开坦克的恶心情况。大会真正的开场还在明日，不过，依以往的惯例，今晚那些小猴子们就要活动起来了。老夫主持了这么多届无遮大会，也是该喝一口汤了……\n……\n[NAME]获知自己入选，心神稍安，穿上衣物，准备去往自己的房间。\n“今晚收拾好了来明德殿伺候。”明德长老暗中传音，给了她一个眼神，便转身离去了。");
	me:TriggerStory("Hehuanzongshiliannv2");
	elseif me:CheckFeature("BeautifulFace2") == true or me:GetCharisma() > 6 or me:CheckFeature("BeautifulFace1") == true then
	me:AddMsg("[NAME]与那些女修一样，褪尽了衣物，任由合欢派的一众修士们观赏。她从未有过这般难堪的经历，面色羞红，亦不知该作何动作，只是呆立在那里。\n不过，[NAME]的姿容样貌还是顶尖，任那些女修搔首弄姿，多也是难及的。\n[NAME]过了首轮的筛选，回到了房间之中，想着一同来此的女修们议论的，明日就要与那些个合欢派的修士们交媾。传闻那是一场上万人的狂欢，是每年最为激动人心的时刻，可[NAME]却有些提不起兴致。\n合欢派安排了专门的侍者为每一名参会的女修沐浴、除毛、熏香。虽明无遮大会，合欢派也还准备了一些特殊的饰物。\n[NAME]心道既然来此，也就听之任之了。\n夜幕将至，[NAME]在榻上辗转，却是难眠。\n周围的人都在传，明日评分的那位崇礼长老甚为不公，历年爬上他床的女子在第二日的大会之上皆受到了照顾。如此也就罢了，奈何那崇礼长老性癖变态至极，也唯有趁此机会，才能让他尝个鲜。\n愿意让他潜的女修极少，但每年也总有那么几个。");
	me:TriggerStory("Hehuanzongshiliannv3");
	else
	me:AddMsg("[NAME]与那些女修一样，褪尽了衣物，任由合欢派的一众修士们观赏。\n一位合欢男修在她身前驻足，审视了一番。[NAME]知晓自己样貌不过等闲，但仍满怀期待的看着眼前的修士。\n“年纪倒是不大，只是……算了，你把屄掰开让我看看。”合欢男修有些纠结，难以决定。\n“是。”[NAME]觉得有了机会，心中激动。忙用手指掰开骚屄，即使如此，她亦怕难以入得此人之眼，甚至用手指开始抽插，情动的呻吟着，骚水淌了一地。\n合欢男修无奈的摇了摇头，“姿色不佳也就罢了，你这骚屄都被操的跟碳一般黑了，就是做母狗也是不够格的，你回去吧。”\n[NAME]眼中垂泪，默默地穿上了衣服，离开会场。");
	end
end

function Hudong:shiqi51()
	me:AddMsg("你决定今晚陪侍明德长老，无论如何也要争取到他的支持。\n待夜幕降临，[NAME]出现在明德殿外，看着殿外的侍者，[NAME]心生了几分怯意，不知该如何开口。\n“这位就是[NAME]小姐吧，长老吩咐过了，你且随我来。”侍者开口，[NAME]口中不语，只是点头跟着。\n进了寝殿，侍者传长老之命让她除去衣物，随后侍者退步而出，再将门合了上。\n[NAME]张望，四周却不见人。突然，[NAME]一惊，她感觉到有什么凉凉的粗糙的东西碰到了自己的小穴。\n“安心……你今日走进了这扇门，就已经拿到了大会的优胜。你现在需要做的只有两个字——听话。”明德长老站在她的身后，用枯槁的手指在她的穴口处摩擦着。\n她有些痛了，但却不敢动，也不敢叫，只点头称是。\n“瞧瞧，这是什么……”长老牵着绳带，从她的玉户之中牵出了一枚跳蛋，用手摩挲了一番，“好湿……原来仙子也是食这凡俗烟火的。”\n“我……”[NAME]羞红了脸，声音细微，几不可闻“这是……这是各位师兄弟和掌门的意思。他们……他们说，把这个放，放进去，可以增加我的评分。”\n“很显然，他们说的没错，”长老笑着，把跳蛋塞进[NAME]的口中，“怎么样，好吃吗吗？”\n[NAME]乖乖张嘴，含着，将其上附着的淫液含裹着吞下，“好……好吃。”\n长老拍拍她的脸蛋，“真乖，来，舔舔这里。”他把跳蛋从[NAME]的嘴里拽了出来，指了指自己的阳物。\n“好大……”[NAME]看向长老身下，那物什虽低垂着，粗长却也远超常人，同门师兄弟们鸡巴的尺寸还不及它的三分之一。被这么大的鸡巴插会是什么感觉呢，[NAME]心中火热，气息也躁动了起来，芳草丛中，流水潺潺。\n……\n层层褶皱紧紧的包裹住他的阳物，迎接他每一次的冲击。长老的每次进出都带出她的一腔绵滑， [NAME]不知迎来了多少次高潮，殿内各处都浸着她的淫水，真是从未有过这等的快活……只是，再这样下去，这身子都要散架了……\n“长……长老，啊！……”又是一袭春水，[NAME]缓了一阵，“这次……这次做完就歇歇吧，这天都亮了，今天可要长老主持大会啊。”\n“知道了，你记得今晚再来便是。”\n……\n大会之上，[NAME]果真得了照顾，竟无合欢弟子敢来染指。\n夜间，[NAME]拖着疲惫的身躯再次来到明德殿。待褪下衣物后，只见灯火大盛。\n前方，就在[NAME]面前站立着的，竟是合欢派的明礼、明道等十一位长老。\n“小骚货，这无遮大会与会人员的分数，由我们十二名长老共同评定。其中关节，你可要想清楚了。”明德长老在她身后，一手逗弄着她身体里的跳蛋，一手捏玩着她的乳头。\n……\n[NAME]一夜小心侍奉，待其余十一位长老皆面色微红，心满意足的离去后——\n\n——“大会这几日你不消再去，只最后一天到场，再被我们几个玩一次，然后领了奖了便是。”明德长老把沾着淫液的阳物放到她的口中，交代着之后的事宜。\n[NAME]抬头，眨眼示意。\n“还有，这跳蛋我重新炼制过了，你日后日夜带着，若有震动，便知是该来此挨操了，知道了吗？”明德长老把鸡巴抽了出来，在她脸上拍打着。\n[NAME]接过跳蛋，默默将它放回肉穴之中，“知道了。”\n“别想着把跳蛋取出来，你以后就是我们几个玩具。喏，这个，你带上，你这骚屄，以后只能给我们玩。”明德长老从储物戒中拿出一条贞操带，戴上这个，屄里的跳蛋可就拿不出来了。\n[NAME]戴好贞操带，将带子用钥匙锁好，再把钥匙交还给了长老。忍了许久，还是问道，“可，可日后我丈夫若要与我过夜，我……”\n明德长老笑了，“你以后还想让你那小鸡巴老公操吗？”\n……\n这几日，众长老每夜皆来此玩乐，玩得花样也越来越变态，毒龙、灌肠、剃毛、滴蜡、穿刺……\n不过，待到最后一日，长老们也果真守信，当真评选[NAME]为本届无遮大会女子的优胜。\n返程途中，[NAME]小穴里的，还是那颗跳蛋，只是身下却多锁上了一条贞操带。她取得了优胜，拿到了功法秘籍，心中滋味，却是难言。");
	me:UnLockGong("Gong_HappyWoman");me.npcObj.PropertyMgr:AddFeature("Qianguize");me:DropAwardItem("Item_Zhencaonv",1);
end

function Hudong:shiqi52()
	me:AddMsg("无遮大会风评极好，从无什么黑幕、潜规则的负面消息，明德长老也是德艺双馨的老前辈，主持了这么多届的无遮大会，向来公正。想来，今晚这明德殿是去不得的。\n[NAME]最终没有赴那明德殿之约，不料却将那明德长老得罪狠了。\n他安排一众弟子在第二日的交媾之中暗中采补[NAME]，使之在会上昏厥而因此落选。\n[NAME]被明德长老囚于暗室，经过三天三夜的调教——\n\n——“贱母狗，香吗？”\n[NAME]跪在地上，浑身赤裸，用心的给长老舔着脚趾，听到问话，忙答道，“香，香，母狗喜欢给主人舔脚，谢谢主人恩赏。”\n“喏，把这再塞回去你那狗屄里，没我的允许，不准拿出来。这跳蛋可是经我重新炼制的，日后若有震动，便该知道，是有人要玩你了。”\n“是。”[NAME]接过跳蛋，忙把它塞入肉穴之中。\n“嗯，你这么贱，难保不会跟别的男人发骚……把这个也戴上，你回去以后，就是你任何人都不能操你了，知道吗？”明德长老从储物戒中取出一条贞操带，扔了过去。\n“贱狗知道了。”[NAME]用嘴将贞操带衔起，再仔细戴在身上，锁好后，把钥匙交还给了长老。\n“走吧，大会结束了，你也该回去了。”");
	me:AddDamage("MeridianRupture","Meridian", 1, XT("被采补过度"));me:DropAwardItem("Item_Zhencaonv",1);me.npcObj.PropertyMgr:AddFeature("Mugou");me:AddModifier("Story_Caibuzhidao2");
	end

function Hudong:shiqi53()
	if me:CheckItemEquptCount("Item_Hongzhu") == 1 then
	me:AddMsg("[NAME]决定去求那崇礼长老。无论付出怎样的代价，也要拿到那部《六欲心经残篇》。\n她穿戴打扮了一番，便出门向崇礼长老的寝殿走去，步履如风。\n[NAME]万难料想，这位长老的性癖如此古怪，她甚至开始怀疑自己先前的选择是否正确。\n[NAME]表明来意后便被那长老除去衣物，用麻绳紧紧捆绑了起来，以一种奇怪的姿势被吊在了房梁之上。\n她的前身与臀部被绳子抬得很高，腰部弯曲下沉，双足自然垂落却只有脚尖略及桌面，真是难受极了。双乳被绳子勒的紧了，且上半身前挺，一对奶子显得无比丰润翘挺。\n崇礼长老从她身上发现了宗门特制的红烛，当时便笑了，“想不到你也喜欢玩这个。”\n此刻桌上立着一小凳，小凳上便点着这蜡，火光忽长忽短，直向[NAME]蜜穴而去。\n[NAME]被灼的狠了，泪水涟涟，“长老饶了我吧，我实在受不了了。”\n“饶了你？”长老脸色一变，狠狠的在[NAME]的屁股上扇了一巴掌，“这等妙事，你说的似在遭罪一般，你不舒服吗？啊？”\n“舒，舒服。”[NAME]强忍着被灵火炙烤的伤痛，“只是，我想，要不我们多玩一些别的花样……”\n“好啊。”[NAME]看不到他似鬼魅般的笑容，发现烛台被取了下来，只感轻松了许多。\n长老将蜡烛拔下，径直插进了[NAME]的小穴之中，火光在穴口处忽明忽暗，折磨着[NAME]的心神。\n“给我夹紧了，若是掉出来，可有你好受的。”\n[NAME]放声哭了出来，“长老……”他听得烦了，取了个口球给[NAME]戴上堵住了她的嘴，“你太聒噪了，什么时候老实了，什么时候跟你解开。”\n长老又拿出一根红烛，点燃，将蜡油倾灼在[NAME]翘起的粉白臀部。\n随着每一滴蜡油的落下，[NAME]的身子便跟着发出一阵抽搐的抖动，崇礼长老心中性起，怒龙渐抬，只是却也不急。\n……许久之后，[NAME]自口球中垂下的涎水已淌了一地，她浑圆的翘臀亦被火红的蜡油完全覆盖、包裹住了。\n长老轻轻的抚过那层红蜡，甚至将脸贴了上去，静静地欣赏着自己的杰作。\n“啪！”——\n\n——崇礼长老忽的一鞭抽下，那层干蜡瞬间破碎，化作一片片娇艳的花瓣在空中飞舞。[NAME]也随着这记鞭子，浑身抽搐、扭动着，下体猛地喷出一股股水儿来，难以断绝，先前插入的红烛也被骚水带了出来，落在桌上，只是依旧燃着……\n……\n这一夜，这崇礼长老的种种手段折腾的她满身伤痛、疲惫不堪。\n好在他也守诺，在大会的第二轮上安排了了几个自己的弟子与[NAME]交合，只是做了做样子，便评得了极高的分数。\n但第三轮的评选这位崇礼长老却是不参与的，只告诉她了一些细节，让她细心准备……");
	me.npcObj.PropertyMgr:AddFeature("Qianguize");
	me:TriggerStory("Hehuanzongshiliannv5");
	else
	me:AddMsg("[NAME]羞红着脸，吞吞吐吐的向长老表明来意。\n崇礼长老原应了下来，但诸般手段使下，[NAME]却始终放不开。\n长老看着眼前妙人仿若木偶一般，心中好生无趣，令她回去了。");
	me:TriggerStory("Hehuanzongshiliannv4");
	end
end

function Hudong:shiqi54()
	me:AddMsg("依照惯例，可是要持续三天三夜的。\n所有参与这场群啪的人都不能着丝布片缕，不过，合欢派也提供了一些可以增加情趣的小饰品。\n在侍者的推荐下，[NAME]戴了一副金链乳夹，菊穴处还插了一白绒兔尾……\n海边，在合欢派的要求下，六千多名绝色女子跪着排作三个整齐的同心圆，脸面向外，后臀指向圆心。她们的菊穴均插着各式尾饰，在合欢派修士的指挥下，同步的摇摆着，真是天宫也难见此等绝景。\n地上、空中，各个角度都有合欢派的留影法器进行拍摄，不过女修们丝毫也不担心，这么多年，这些影像从未流出过。或者说，这些法器的拍摄，反倒令她们觉得异常兴奋。\n……\n在此起彼伏的呻吟声中，合欢派的修士及与会的男修也都走入了场中，情欲迷乱，芳菲漫天……\n这场上的男子，无一不是天赋异禀之辈。[NAME]满目含春的为身前的男子含着阳物，那龙头直顶入喉管之中，身后却是有如打桩机一般被进出操弄着。\n[NAME]都不知泄了几次身子了，终感身后男子射出了股股滚烫阳精，心道这可以歇歇了，奈何又有一人插了进来，似还要大上几分。几重霄汉云雨，瑶池菡萏直把泪垂……");
	if me:GetPhysique() > 7 then
	me:AddMsg("[NAME]整整与一众男修大战了三天三夜，虽有些疲惫，但也是酣畅淋漓，兴尽而归。\n这三天尝试了数不尽的玩法，什么双龙戏珠、芙蓉出水、小蜜蜂采蜜……不知道玩了多少花样。一些合欢男修精通双修之术，于她的修为也有颇多增进。因此，[NAME]也暗自感慨，这第二轮玩得时间也太短了……");
	me:AddPracticeResource("Stage",50000);me:TriggerStory("Hehuanzongshiliannv5");
	else
	me:AddMsg("这场露天群啪，[NAME]开始还觉得兴奋，多次高潮之下也让她体味到了极致的快乐。\n然而这些男修似不知疲倦，一个个又精谙此道，只一天下来，[NAME]便已疲惫不堪，周身灵力也运转不济。\n想要歇上一歇，可这些男人却不管你哪个，就是尸体也能给你折腾的死去活来。\n[NAME]当晚便被操昏了过去，而后是被人抬回了房间。\n[NAME]第二轮评分不合格，她被合欢宗扫地出门了。");
	end
end

function Hudong:shiqi55()
	if me:GetSkillLevel("SocialContact") > 18 then
	me:AddMsg("[NAME]轻笑一声道：“我未来可是要成为合欢女尊的女人，天下所有男人都是我脚下的公狗。”[NAME]不过一个眼神，勾了勾鞋尖，眼前的男修便如狗一般跪在了她的脚下，一脸陶醉的为她舔舐着鞋底。\n“喜欢给我舔鞋还是喜欢操别的女人啊？”[NAME]笑得魅极了。\n“喜欢给主人舔鞋。”男修还在认真舔着，答得诚恳。\n“嗯，真乖。”[NAME]拍了拍他的脸，“主人赏赐你舔主人的脚，但作为交换，你那根贱鸡巴以后就再也不能插到女人温热的屄里了。愿意吗？”\n“谢主人赏。贱狗愿意，能舔到主人高贵的脚，就是用贱狗的命去换也是值了。”男修磕头谢恩，面色兴奋。\n“喏，既然愿意，就把这个戴上吧。”[NAME]轻蔑的把贞操锁掷了过去。\n男修用嘴衔起贞操锁，迫不及待的将自己的大鸡巴锁在了冰冷狭小的囚笼自重。\n他如愿以偿的舔到了[NAME]的美脚，玉足的香气令他迷乱、沉醉……\n“忘了告诉你了，我的贞操锁，都是没有钥匙的。”\n……\n[NAME]顺利成为通过无遮大会测试。");
	me:UnLockGong("Gong_HappyWoman");
	else
	me:AddMsg("[NAME]见过其他女子调教男奴，她当时只觉轻松惬意，并不费什么力气。然今日做来，却发现远非想象的那般简单。\n那男修不时提出一些要求，她是听也不是，不听也不是。又要有女王十足的威严，又要有女性妩媚的诱惑，她做到后面，紧张的汗都出来了。\n最终被合欢派的评审叫停。\n[NAME]未能通过测试。");
	end
end

function Hudong:shiqi56()
	if me:GetSkillLevel("SocialContact") > 10 then
	me:AddMsg("[NAME]带着狗尾肛塞，跪在合欢男修面前，一边舔脚一边道，“我是主人的贱母狗……求主人，求主人操死我吧……”\n[NAME]说着这些淫词浪语，骚水儿竟自私处潺潺流下，是欲生情动了。\n男修看着她的翘臀，及那上摇摆着的狗尾，心下难耐，便用手掌拍起她的屁股。\n“啊……1，谢谢主人。”每扇一下，[NAME]都报一次数，并虔诚的磕头道谢。那男修也算是久历花丛了，可从未见过这般骚浪的女子，此般刺激之下，阳根万分坚挺。\n男修心中火热，难思其他，挺枪直入——\n\n——“啊……主人愿意插进来，骚母狗好高兴。嗯，嗯……啊，主人，主人的鸡巴好大，操的我好爽，爽死了……我是贱母狗，是肉便器，是主人的玩具，主人操死我吧……啊……”\n[NAME]的花穴时而夹紧，时而微含，阴精也由秘法控制着，在合适的时机喷射，不一会儿，[NAME]便觉察到那男修快要到了。\n“呜……主人好厉害，人家受不了了……主人射进来吧，人家要给主人生孩子……啊！对，不给老公生孩子，人家只给主人生孩子……啊……”\n一股股浓精射进了[NAME]的腔道之中，最终，[NAME]如愿通过无遮大会测试。");
	me:UnLockGong("Gong_HappyWoman");
	else
	me:AddMsg("[NAME]在情爱中向来是柔弱的一方，此次本想豁出面子，以m的身份展现自己女性柔美的一面，奈何那些淫词浪语，就是编也不是当场就能编好的。\n[NAME]紧张之下，行止更加无措，以致面前的男修对她实难生半分情欲。\n最终被合欢派的评审叫停。\n[NAME]未能如愿过关");
	end
end

function Hudong:shiqi57()
	if me:CheckFeature("Rouruandeshetyou") == true then
	me:AddMsg("[NAME]始终认为，女子的香舌是征服男性最好的武器。\n它柔软，它娇艳，它灵活，它可以侍奉男子身体的每一部位，并令其产生征服欲，更好的勾动男子心中的欲火。\n因而[NAME]对此练习不辍，一只塞口假阳具是她最喜欢的玩具。她自觉自己的深喉功力定是天下第一的。\n[NAME]檀口微张，那一抹殷红勾动着眼前男修的魂魄。男修呆愣在那里喘着粗气，[NAME]笑得妩媚，她认为，要俘获男人的心，那第一步就要勾得他意乱神迷，将他的魂儿牢牢抓在自己的手里。\n[NAME]的香舌自耳后舔起，舔舐、吸弄、拨挑，至脖颈，再到胸前，一缕发丝拂过他的面颊，更带去无边情意。\n[NAME]用指甲在男修左胸划着圈，“人家……帮你含含，让你舒服，好不好？”声音甜腻极了，却是令男修心痒无比，“好，好……”\n[NAME]跪着，含着男修粗长的阳具，试了几番花样，便觉察到了他的敏感点。\n舌头轻挑他的冠状沟，一手用指甲不断拨动他的阴囊，不消片刻，男修的精液便在她的口中喷射而出。[NAME]含笑吞下，并为男修清理。\n众评审对她的表现评价极高。最终，[NAME]如愿通过无遮大会测试。");
	me:UnLockGong("Gong_HappyWoman");
	else
	me:AddMsg("[NAME]曾也为丈夫口交过，觉得此事不难，俯身便将眼前男修的阳具含在了嘴里。\n她吸舔的认真，奈何这男修也并非等闲，精关紧锁，久久不射。\n一炷香后，[NAME]被合欢派的评审叫停了。\n[NAME]未能如愿过关");
	end
end

function Hudong:shiqi58()
	if me:CheckFeature("WHLjinv") == true then
	me:AddMsg("[NAME]曾经在万花楼做过兼职，同时控制小穴与后庭的动作是[NAME]最引以为傲的技艺。\n她精于此道多年，甚至可以控制究竟是让哪名男子先射出阳精。\n[NAME]对此苦练不辍，因而最喜欢的小玩具便是三叉戟，这是采用秘法融诸般灵物炼制而成的，使用起来，竟与真人别无二致。她往日无暇幽会男子时，便以此物保持状态。\n她唤来了两名男修，爱抚挑逗之下，便引得巨龙插入两处洞中。\n“啊……哥哥们好厉害，真是插死我了……要死了，呜，要死了……”[NAME]口中浪叫着，两处骚洞却并未闲歇。\n菊穴微张，轻柔而不敢用力，温柔的包裹着男修的粗长阳物。蜜肉微合，令身前男修在这滑腻的腔道中插入更显兴奋。\n不一会儿，她觉察到身前的男子快要射了，抚了抚他的后背，让他躺下，[NAME]跨坐在他的腰上，掌控着进出的节奏，翘臀微抬，菊穴一松一紧，给身后之人更强烈的刺激。\n“啊……美死我了……哥哥们射进来吧，啊，啊……射进来，我要给哥哥们生孩子……”\n两名男修再也忍耐不住，同时将阳精泄在了她的体内。\n[NAME]将手指探入下身，带出一些白浊的液体，她舔着、裹含着手指上的浊液，送上了无尽的春情与魅意。\n[NAME]如愿通过无遮大会测试。");
	me:UnLockGong("Gong_HappyWoman");
	else
	me:AddMsg("[NAME]曾与两名男子共同性交过，觉得如此做法，或能得评审青睐。\n只是她于此道并不熟稔，当初也只是被动地接受，此次被两名男子一同操弄的天昏地暗，全然失了自己的节奏。\n[NAME]未能如愿过关");
	end
end

function Hudong:shiqi59()
	if me:CheckItemEquptCount("Item_Hongzhu") == 1 then
	me:AddMsg("相较于与那些臭男人欢好，[NAME]更喜欢香香美美的女孩子。\n让她们体会到女人之间的快乐，把她们操爽、操舒服、操到哭，是[NAME]最有成就感的事情。\n[NAME]看着眼前的女子，温婉明丽，清新淡雅，正是自己最喜爱的那一款。\n[NAME]将手勾在她的颈后，“你知道，这事不是非要男女才能做的。”\n女子默默地点头，看着[NAME]的绝美面容，眉眼含春。\n[NAME]俯身，含着她的耳垂，手在她身下逗弄着。\n待她面色潮红，小穴渐渐淌出水儿来，[NAME]再吻向她的脖颈、双乳，“你是我见过最美的女子，有缘在这里遇到你，当真是神明无上的恩赐。”\n那女子羞得说不出话来，只随着[NAME]舌尖的动作，咿咿呀呀的叫着。\n[NAME]蹲下，用香舌侍弄着她的私处。\n“那里，那里脏……”女子将头扭向别处，不敢看她。\n“怎么会，你的身子纯洁无瑕，哪里都是香的。”[NAME]舌技亦是不凡，几下便引得潮水翻涌、意乱情痴——“给，给我……我要……”那女子咬着下唇，面颊红得似要滴出血来，硬是挤出了这几个字。[NAME]笑了，指着自己的粉嫩小穴，“那，你帮我也舔舔？”\n“好。”\n[NAME]享受着美人的口舌服务，手中却未停下，不断拨弄着那含苞待放的嫩芽……\n[NAME]觉得时候到了，便取出了双头龙，两头分别插入二人的小穴之中。\n她精于此道，用嫩肉控制着双通龙的进出，时紧，时松，双手也不断爱抚着那女子的身体。\n二人共体味了十余种姿势，那女子喷涌的潮水早已浸透了被单，一众评审也是大开眼界。\n最终，[NAME]如愿成为无遮大会魁首。");
	me:UnLockGong("Gong_HappyWoman");me:AddTitle(XT("无遮大会魁首"),string.format(XT("于%s年历练途中，夺得无遮大会魁首！"),4));me:AddSchoolRelation(11,1500);
	else
	me:AddMsg("[NAME]曾有一位闺中密友，二人情感笃厚，曾也尝过禁果，奈何此行难容于世俗礼法，后来也就分开了，多年也未曾联系过……\n[NAME]尝试用曾经与她欢好的技巧博得评审的青睐，怎奈当年青涩，只是情动而发，技艺上实在缺少琢磨。再者[NAME]与眼前女子欢爱时，脑海中浮现的也尽是她的身影，[NAME]更是难以放得开。\n[NAME]未能如愿过关");
	end
end

function Hudong:shiqi60()
local npc1 = ThingMgr:FindThingByID(me.npcObj.ID)
local XianzheCD = npc1.LuaHelper:GetModifierStack("XianzheCD");
	if world:GetWorldFlag(1705) == 2 and XianzheCD == 0 and me:CheckFeature("JLEdexianghao") == true then
	wenben = me:ParseNpcStory("[rand_lable=desc_time,desc_place,desc_weather]，[name]来到的厢房与金铃儿共度春宵一夜……\n激情之后，两人抵足闲话，聊到苏神教左使唐不甜派手下大将屠赞婢平灭傲山宗一事，却意外得知事情可能并没有自己想的那么简单……\n据金铃儿所述她在万花楼之时，楼中曾有一兔爷，名曰：苏小赞，由于颜靓活好，被中原的一个土豪买去做脔童了，而此人样貌恰巧和苏神教教主箫战长得及其相似……")
	me:AddMsg(wenben);npc1:AddModifier("XianzheCD");world:SetWorldFlag(1705,3)world:UnLockJianghuClue(1707)
	elseif XianzheCD > 10 then
	wenben = me:ParseNpcStory("[name]刚刚干完一炮，现在体力还没回复呢……")
	me:AddMsg(wenben);
	elseif me:CheckFeature("JLEdexianghao") == true then
	wenben = me:ParseNpcStory("[rand_lable=desc_time,desc_place,desc_weather]，[name]来到的厢房与金铃儿共度春宵一夜……。")
	npc1:AddModifier("XianzheCD");me:AddMsg(wenben);me:AddMemery(wenben);
		if npc1.GongKind == g_emGongKind.Body and npc1.PropertyMgr.Practice.BodyPracticeData:CheckQuenchingMethod("BPQuenchingMethods_shiqi_17") == false then
		me:AddMsg("[NAME]在于金铃儿欢好之时，被其传授了一种神秘的淬体之法……")
		npc1.PropertyMgr.Practice.BodyPracticeData:AddQuenchingMethod("BPQuenchingMethods_shiqi_17")
		end
	elseif npc1.GongKind == g_emGongKind.Body and npc1.Sex == CS.XiaWorld.g_emNpcSex.Male then
	me:AddMsg("[NAME]来到的厢房，想与金铃儿共度春宵一夜，金铃儿与[NAME]不熟，婉拒了[NAME]，可是身为体修的[NAME]向来是直来直去的，二话不说直接掏出阳物将金铃儿按倒在地上……。")
	me:AddMsg("金铃儿的厢房里，不断的传出[NAME]挑逗性的言语和金铃儿的喘息声，金铃儿一丝不挂的趴在一张床垫上，双手被绳索牢牢的反绑在身后，强烈的灯光突显出女人正在受虐的身体，她的身体被摆成淫荡的造型，肥大而丰满的屁股高高翘起连同屄完全暴露在身后同样一丝不挂的[NAME]那淫亵的目光下。")
	me:AddMsg("[NAME]可说是瘦瘪的身上却有一条极其粗长的阴茎此时正凶狠的刺进金铃儿那已红肿充血的肉洞里大幅度的做着活塞运动，两只手紧紧扶住了金铃儿的柳腰控制着抽插的速度时而游荡在金铃儿那对下垂的乳房和其他敏感地带上，显然金铃儿已被干了相当久了脸上浮现出痛苦却有陶醉的表情，身体在[NAME]有节奏的动作下不断的起伏，两只肉足绷的紧紧的，[NAME]的精液和金铃儿的骚水早已顺着屁股沟流下在身下印了好大一滩。")
		if me:GetPhysique() > 9 then
		me:AddMsg("心满意足的[NAME]正待离开，却见金铃儿的那两条如白藕一般的小腿，紧紧的箍住了[NAME]的腰间，而那小穴膣壁宛若要让肉棒更深入到底部般，不断地加大吸吮收缩的力道，在一阵彷佛夜晚远吠的声音下，[NAME]的肢体开始产生反射性的哆嗦，肉棒亦膨胀到极限，一口气爆发出所有剩余的精液。灼热奔流射入了金铃儿的蜜穴之中，[NAME]的肉棒再次软到在金铃儿的蜜穴之中，注入了最后一滴热液后，金铃儿子宫内原本应该盛满了浓稠的白浊精液，却不知为何她的下体如同无底洞般的继续渴求着精液，[NAME]见其情形不禁猎奇心起默运玄功重整旗鼓……")
		me:AddMsg("从开始到现在为止已经三个小时了，但[NAME]仍乐此不疲的在金铃儿的肉穴中疯狂的冲刺，身下的金铃儿早已瘫软在床上，此时她感到全身火烧般的热，随着[NAME]阴茎每一次深深的顶进自己的子宫屈辱和快感同时冲击着她的理智防线，“啊……啊……我、我……、已经……”先前还妄图施展合欢功法反制[NAME]的金铃儿已经意乱神迷……\n[NAME]再次把金铃儿的身体拉了起来让她盘腿坐在自己的怀中，两只手粗鲁的罩住了金铃儿那一对尖挺的乳房大幅度的揉捏起来不时去提一提两颗粉色的乳头。\n“哦——你的奶子不大，但很有弹性乳头也很棒，今后也要好好调教。”[NAME]如是说道……")
		npc1.PropertyMgr:AddFeature("JLEdexianghao");
		else
		me:AddMsg("心满意足的[NAME]正待离开，却见金铃儿的那两条如白藕一般的小腿，紧紧的箍住了[NAME]的腰间，而那小穴膣壁宛若要让肉棒更深入到底部般，不断地加大吸吮收缩的力道，在一阵彷佛夜晚远吠的声音下，[NAME]的肢体开始产生反射性的哆嗦，肉棒亦膨胀到极限，一口气爆发出所有剩余的精液。灼热奔流射入了金铃儿的蜜穴之中，[NAME]的肉棒再次软到在金铃儿的蜜穴之中，注入了最后一滴热液后，金铃儿子宫内原本应该盛满了浓稠的白浊精液，却不知为何她的下体如同无底洞般的继续渴求着精液，麻痹的意识让[NAME]全身全虚脱……")
		me:AddMsg("然而金铃儿仿佛依旧不打算放过这个原本是来强奸自己的蠢货，在金铃儿的卧室里[NAME]为自己的色欲熏心付出了生命的代价……")
		me:ModifierProperty("MaxAge",-99999999);
		end
	else
	wenben = me:ParseNpcStory("[rand_lable=desc_time,desc_place,desc_weather]，[name]来到的厢房，想与金铃儿共度春宵一夜，金铃儿与[name]不熟，婉拒了[name]……。")
	me:AddMsg(wenben);me:AddMemery(wenben);
	end
end

function Hudong:shiqi61()
	if me:GetGongName() == "Gong_1701_Tu" then
	me:AddMsg("[NAME]通过尹志平的描述，找到了终南山下的古墓……\n[NAME]实战了合欢功法中的迷魂大法，将居住于古墓内的女子和她的丈夫掳回了门派。");
	world:UnLockJianghuSecret(1701)
	world:SetWorldFlag(1704,3)
	else
	me:AddMsg("[NAME]通过尹志平的描述，找到了终南山下的古墓……\n只身闯入古墓，受阻于一独臂男子，虽然此人武艺惊人，可是凡人毕竟是个凡人，[NAME]举手间便将对方击杀于当场，正待抓捕尹志平口中的那个白衣女子时……却见对方高喊一声“过儿”后，便咬舌自尽了。");
	world:SetWorldFlag(1704,10)
	end
end

function Hudong:shiqi62()
	if me:GetSex() == 2 and me:GetDaoHang() > 150 and me:GetGLevel() > 6 and me:GetGongName() == "Gong_1701_Tu" then--性别女 实力强 合欢功法
	me:AddMsg("进入洞窟，[NAME]看到了一个邪魔在肆无忌惮的采补着周围的女修，周围还有很多的触手在摆动着，由于[NAME]修为高绝，所以进入之时未被邪魔发现。\n[NAME]计由心生，封住自己修为后暴露于邪魔面前，邪魔果然上当，舞动着触手将[NAME]卷起……\n经过一轮昏天黑地的较量，[NAME]成功的把邪魔吸了个干净。");
	me:AddPracticeResource("Stage",me:GetGLevel() * 1000);me:AddModifier("Story_Caibuzhidao1");me:ModifierProperty("MaxAge",300);
	elseif me:GetSex() == 2 and me:GetDaoHang() > 150 and me:GetGLevel() > 6 then--性别女 实力强 不会合欢功法
	me:AddMsg("进入洞窟，[NAME]看到了一个邪魔在肆无忌惮的采补着周围的女修，周围还有很多的触手在摆动着，由于[NAME]修为高绝，所以进入之时未被邪魔发现。\n[NAME]计由心生，封住自己修为后暴露于邪魔面前，邪魔果然上当，舞动着触手将[NAME]卷起……\n显然[NAME]高估了自己，当刺痛感从乳头和阴蒂处传来时，[NAME]本能地痛呼出声，而这些部位被强行注入催情液的那几秒，更是让[NAME]浑身颤抖，意识都有些模糊起来了，更别说凝聚魔力了。\n当针状触手从[NAME]的三点处抽出时，又激起了[NAME]的痛呼声,疼痛过后，[NAME]感觉乳头和阴蒂处产生了仿佛正在被灼烧般的热辣感。\n烫，好烫~[NAME]扭动着身体，口中吐出灼热的呼吸，三点处的灼热感散发着一圈圈的快感涟漪，逐渐遍布全身。\n[NAME]的身体也开始逐渐火热了起来。[NAME]身上缠绕的触手开始剧烈的活动，乳根被触手紧紧环住，乳房呈球状肿胀起来，逐渐开始充血，血液的不流通让两对乳球变得更为敏感，细小的触手不断地拉扯着乳头，让乳头渐渐挺立起来。\n嗯哈，不要拉啊~好痒~好热~[NAME]的意识再次开始混乱起来。\n【我，我得集中精神……可是身体好烫~好想要……】似乎听到了[NAME]内心的呼喊，一根肉柱状的触手向[NAME]的小穴靠近，触手表面布满了肉瘤一般的颗粒物。\n这条触手抵在[NAME]的蜜穴口，并没有如[NAME]料想般的插入，而是在不断的扭动着，下身的扭动感让[NAME]焦躁不安，凝聚的精神又一次被空虚和灼热感淹没。\n下面好热~受不了了~好想……唔哈~[NAME]残存的意识阻止了她说出更加羞耻的话，上齿紧紧咬着下唇，似乎想用痛感唤回自己的意识。 蜜穴处的触手依然在不停的扭动着，[NAME]的嘴唇已经渗出了些许鲜红，混乱的意识勉强凝聚起来。\n[NAME]被按住采补的时候突然发现自身修为不能动用分毫，原来那些触手能够吸收所有与灵气有关的东西，[NAME]被邪魔的触手操弄的死去活来最后找到一个机会斩断了邪魔的触手溜走了。");
	me:ModifierProperty("MaxAge",-60);
	elseif me:GetSex() == 2 and me:CheckFeature("Pogua") ~= true then--性别女 实力弱 处女
	me:AddMsg("进入瞬间，感觉天旋地转，被送入了一片全是触手的地方，[NAME]在半空中扭动着，本能的想要躲开触手的侵犯，可触手依然坚持着对乳头的猛攻。\n感觉……好奇怪，刚才被触手灌入的催淫液开始发生作用，欲望的火焰从身体里面燃烧起来，身体的敏感度也比平时高出了好几十倍。\n[NAME]的乳首开始挺立充血，触手一边在乳房上涂抹着催淫的粘液，一边继续玩弄乳首，有几跟极为纤细的开始探索乳首上那条极细的肉缝，用力的尝试钻进去。\n“啊……！”[NAME]变的极为敏感的身体引来了第一次高潮。\n[NAME]的身体猛的绷直，微微的筋挛着，大量的爱液从下身流了出来，就连小巧的菊花也高潮中被带出了肠液。\n淫秽的气氛刺激了触手，开使全面的进攻，一条巨大扁平的触手从魔法阵中升起，奇特的触手中的一面带有无数不停蠕动的颗粒和纤毛，它熟练的穿过[NAME]被分开的双腿，一直伸展到[NAME]的双乳之间，然后触手们调整着[NAME]的体位，让[NAME]整个人“骑”在了这条触手之上。\n“啊……”还没从高潮余韵中清醒的[NAME]再一次达到了小小的高潮。\n乳沟、小腹、阴户、菊穴都和这条触手紧密的结合在一起，颗粒和纤毛翻弄、吸吮、爱抚着[NAME]敏感灼热的肌肤，翻开[NAME]的阴唇，舐弄着[NAME]的淫核，骚动着阴道的内壁，刺激着菊花。\n“啊……不行……不行……不行……”很快[NAME]说不出完整的语句了。\n触手开始不停的磨动，速度不停的加剧，大量浅绿色的淫液从触手上那些颗粒中分泌出来，润滑着触手。\n“啊……”难以想像的快感一波一波的冲击着大脑，[NAME]感觉整个身体都麻痹了。\n被触手磨擦的地方传来的致命的快感。\n“小穴……我的小穴……我的小穴！哈哈哈……啊！”[NAME]的双腿不停的被绞紧，每一次磨动，扁平的触手就会变窄一点，好像就要锔进[NAME]的阴户里一样，不停的潜入。\n“啊！啊！啊！”已经不知道多少次高潮了，只感到头脑里完全一片空白。\n在极度的快乐下，不停的筋挛。触手最后一次猛烈的抽动勒紧，终于完完全全的卡进[NAME]的阴户和股沟中去了。伴随着潮喷而出的爱液，金色的尿液也一起从[NAME]的下体激射了出来。");
	me:ModifierProperty("MaxAge",-60);me:AddModifier("SysPracticeDie");
	elseif me:GetSex() == 2 then--性别女 实力弱 非处
	me:AddMsg("进入瞬间，便被突然伸出来的触手牢牢捆住，然后被拉向深处，随之而出的是一朵巨大的花孢，妖异的的颜色在上面流动。\n花朵猛的张开，一下子就把失神的[NAME]完全的吞了进去。\n下一瞬间，[NAME]发出了撕心裂肺的惨叫声，面对[NAME]已经被不是处女的身体，花朵内一根最大的雌蕾猛的深深插入阴户之中，更多的雄芯缠绕并深深的扎入[NAME]的身体之内，有二根纤细的雄芯插入了乳首的乳缝之中，开始向[NAME]的双乳注射出奇怪的液体，[NAME]的乳房随之变大了起来。\n“啊！”还有一跟雄芯则插入了[NAME]的尿道，敏感的女体立即就像被电激一样的抽动起来，“呜！”雄芯小心的穿过纤细敏感的尿道，开始不停的吸出[NAME]的尿液，更有四五根雄芯钻入了[NAME]的菊穴，开始在[NAME]的肠道内探索。\n“啊……啊……啊……”[NAME]的身体就像失去了四肢一样，只留下性器官带来的可怕的快感，花朵开始不停的摇动，花芯们则伴随着这种妖异的动作开始疯狂的抽插。\n[NAME]整个人就这么跪倒在巨大的花骨朵当中，完全失去了对自己的控制，无数触手爱抚着全身，挤压着双乳，二根触手深深的插进乳头，伴随着肿涨的快感，大量的乳汁在触手的每一次抽动中都被带出来。\n阴道传来了难以想像的快感，一支，二支，三支，更多的雄芯入侵了蜜穴，伴随着巨大的雌蕾盘旋而上，用力的磨擦着肉壁和g点。\n“啊啊……啊啊啊……坏掉了！坏掉了！坏掉了！啊！”尿道中的纤毛也不停的在抽动，[NAME]已经完全失禁，黄金水不停的被导出，四处飞散。菊花被五六跟触手扩大，最深的一根已经进入了[NAME]的肠道深处，在肠子里不停的盘旋。\n“啊……啊……啊……我要坏掉了……坏掉了……用力干我……干死我吧！干！……哈……哈……干我……啊！”[NAME]大大的张开嘴，可爱的舌头笔直的升出口外。\n有根触手爬进[NAME]的嘴角，缠绕在舌头之上，继续着蛇吻。“啊……啊……不行了……啊！”“啊……呜呜……啊啊啊啊啊啊！……！……啊！”已经不知道多少次高潮了。\n在[NAME]第n次爬上纯白的顶峰时，世界破碎了。化为无数光的碎片向无尽的虚无散去。");
	me:ModifierProperty("MaxAge",-99999);
	elseif me:GetSex() ~= 2 and me:GetDaoHang() > 150 and me:GetGLevel() > 6 and me:GetGongName() == "Gong_1701_Tu" then --性别男实力强合欢功法
	me:AddMsg("[NAME]发现此处并无宝物，乃是邪魔陷阱，其中已经有很多女性修士被采补的意识消散，击杀了邪魔后[NAME]开始征伐身下的女修士，每每女修高潮之后便将对方阴元掠夺一空后再换一个，直到性欲得到满足后，[NAME]才离开此地。");
	me:AddPracticeResource("Stage",me:GetGLevel() * 1000);me:AddModifier("Story_Caibuzhidao1");
	elseif me:GetSex() ~= 2 and me:GetDaoHang() > 150 and me:GetGLevel() > 6 then--性别男实力强
	me:AddMsg("[NAME]发现此处并无宝物，乃是邪魔陷阱，其中已经有很多女性修士被采补的意识消散，击杀了邪魔后[NAME]开始征伐身下的女修士，每每女修高潮之后就再换一个，直到性欲得到满足后，[NAME]才离开此地。");
	me:AddPracticeResource("Stage",me:GetGLevel() * 250);me:AddModifier("Luding6");
	else--性别男实力弱
	me:AddMsg("可惜[NAME]无论如何找不到入口，查探片刻后便离开了。");
	end
end

function Hudong:shiqi63()
	if me:GetModifierStack("Qian") >= 100 then
	me:AddMsg("[NAME]向这名官差打探关于傲山门的情报，在银钱的攻势下，官差告诉了[NAME]数月前他们的确接到通知，将那个傲山门驱离本地……");
	world:UnLockJianghuClue(1704)
	world:SetWorldFlag(1705,2)
	me.npcObj.PropertyMgr:FindModifier("Qian"):UpdateStack(-100);
	else
	me:AddMsg("[NAME]向这名官差打探关于傲山门的情报，被拒绝了。");
	world:SetWorldFlag(1704,10)
	end
end

function Hudong:shiqi64()--帮助苏神教徒
	if me:GetGLevel() > 6 then
	me:AddMsg("[NAME]通过地头的介绍，加入了苏神教派，此时的苏神教岌岌可危，众善信见有强援入场助力纷纷自荐枕席，愿以一身皮囊换的强援的倾力相救……\n通过几日“磨合”心满意足的[NAME]祭出飞剑之身杀向那群“乌合之众”，一时大杀四方好不痛快，修为高深的[NAME]轻而易举的斩杀了来犯之人，即使后来官府也亲自下场，也被[NAME]一人一剑所斩尽杀绝，逼得官府不得不认下了苏神教为国教一事。\n此事一毕，于庆功宴上[NAME]也得见了苏神教派的尊主箫战，此人长得无比“可爱”“让人想啵”“好漂亮”“帅死了”（此处不是故意恶搞，也不是不会背四字成语，而是百度贴吧里摘抄来的，至于什么贴吧品就完事了。），此等容貌倾世，姿容卓绝之人，果然当得一句：“苏神降临，神泽世人”。\n酒毕，喝了个烂醉的[NAME]被苏神教的弟子们簇拥着进入卧室日夜狂欢……直到[NAME]感觉到了有些什么不对的地方……\n可此时却早已悔之晚矣……");
	me:ModifierProperty("MaxAge",-99999999);world:SetWorldFlag(1705,5);
	else
	me:AddMsg("[NAME]通过地头的介绍，加入了苏神教派，此时的苏神教岌岌可危，众善信见有强援入场助力纷纷自荐枕席，愿以一身皮囊换的强援的倾力相救……\n通过几日“磨合”心满意足的[NAME]祭出飞剑之身杀向那群“乌合之众”，一时大杀四方好不痛快，奈何未结金丹的[NAME]还是无法挽救这将倾之厦，失神之时被一发流矢射中左眼，遂落荒而逃……\n最终，苏神教众还是被这泱泱大势尽数覆灭了……");
	me:AddSchoolScore(1,-1000);world:SetWorldFlag(1705,5);me:AddDamage("Fabao_CutOff","LeftEye", 1, XT("被流矢射瞎"));
	end
	story:FinishSecret();
end

function Hudong:shiqi65()--帮助凡间各大门派
	me:AddMsg("[NAME]的加入仿佛是压死苏神教徒的最后一根稻草，苏神教在诸方的打击之下，终于完全溃散……\n本门也因为此举名声大振。");
	me:AddSchoolScore(1,1000);world:SetWorldFlag(1705,5);story:FinishSecret();
end

function Hudong:shiqi66()--吃瓜潜入
	me:AddMsg("凡间各大门派围剿苏神教这一件事本身，对于身为修真者的[NAME]来说，只是属于茶余饭后的笑谈，[NAME]孤身来到中原也不过只是想将这个瓜吃个完整，以待以后闲谈之时充作谈资。\n既是如此，[NAME]自然不会投身与任何一方，隐身于高处俯瞰全场的[NAME]突觉下方战场有着一丝丝的奇怪，这搏杀双方凡人的心绪神念却很神奇的均高度统一，而每每有人力歇倒地，他们的灵魂均被一股神秘的力量引向城北的一栋府邸……");
	me:TriggerStory("Xiaozhandemimi");
end

function Hudong:shiqi67()--苏小赞被荆棘宫丝玩弄事件
me:AddMsg("好奇心驱使着[NAME]紧跟这些被引导的灵魂潜入了眼前这诡异大宅，伏身于大宅正堂上方的[NAME]，小心翼翼的移开了一枚瓦片，长眼望去一个“巨大”的女人映入眼帘。\n的确，就是“巨大”，即使她是倚靠在那张足被称为通铺的贵妃床上，依[NAME]目测此女也至少有这三四米高的样子，不光仅只是高而已，宽度在[NAME]的目测中，差不多也是那样，对方倚在通铺级的贵妃床上，浑身肥肉如同流体一般层层叠叠的铺满了整个床榻。\n床榻之下，一名后庭中插着一条黄白相间狗尾的男子匍匐于地，探出舌尖舔舐着这女“巨人”的大脚，仿佛眼前是那无比珍馐的美味，而踏上的女“巨人”贪婪的吸食着这由站场上漂进来的灵魂，不时还发出一声满足的哼哼声。\n随着飘来的灵魂越来越少，女“巨人”仿佛也知道了大战即将结束，只见她一脚往那低伏于她床榻之前，正在用舌尖给她脚趾做保养的俊俏男子头上踩去，一边狠踩还一边对其喷吐着“废物，垃圾”等等恶言。\n发泄了一通不愉快之后，女“巨人”摄起了被踩到头破血流的男子，将其当做一枚巨型的角先生肉苁蓉之类的道具，向自己的下体塞去。\n苏神教的女信徒们绝对不可能会想到，自己那个神泽世人的教主哥哥，居然被一个三四米高的女巨人，当做道具在自己下体抽插着，这根本不是仅仅用残忍就能描述的事情，这堪比绝世的酷刑，每一次短暂的脱离女巨人的下体，这俊俏男子均贪婪的大口呼吸这空气，即使他的眼眶鼻腔和口中都布满了对方下体的所分泌的粘液，而短暂的自由呼吸之后，便是那一插到底……\n[NAME]仅仅只是看，便是止不住的干呕了起来，也正是这干呕，使得[NAME]被那足以称之为魔鬼的女人发现。\n只听对方一声冷哼，[NAME]便感觉整个人被巨锤轰击气血翻腾，脸上的七窍渗出了丝丝鲜血……");
	if me:CheckFeature("Tiancilonggen") == true and me:CheckFeature("BeautifulFace2") == true and me:CheckFeature("Feminization") == true then--娘炮+惊世美貌+天赐龙根
	me:TriggerStory("Jinjigongsi");
	else
	npc1 = ThingMgr:FindThingByID(me.npcObj.ID)
	Wqcsnpc = ThingMgr:FindThingByID(me.npcObj.ID)
	Hudong:Wqcs()
	npc1.LuaHelper:AddDamage("FightSkill_Disintegrate","LeftEye", 1, XT("被荆棘宫丝灵压所毁"));
	npc1.LuaHelper:AddDamage("FightSkill_Disintegrate","RightEye", 1, XT("被荆棘宫丝灵压所毁"));
	npc1.LuaHelper:AddDamage("FightSkill_Disintegrate","LeftEar", 1, XT("被荆棘宫丝灵压所毁"));
	npc1.LuaHelper:AddDamage("FightSkill_Disintegrate","RightEar", 1, XT("被荆棘宫丝灵压所毁"));
	npc1.LuaHelper:AddDamage("FightSkill_Disintegrate","Nose", 1, XT("被荆棘宫丝灵压所毁"));
	npc1.LuaHelper:AddDamage("FightSkill_Disintegrate","Spine", 1, XT("被荆棘宫丝灵压所毁"));
	world:SetWorldFlag(1705,5);
	story:FinishSecret();
	end
end

function Hudong:shiqi68()--成为荆棘宫丝的新宠儿
me:AddMsg("有一嗦一，但凡有点逻辑，脑子没坏掉的人，都知道此时的唯一选择就是纳头便拜，毕竟被小命捏在别人手里的时候，喊上一句三十年河东什么着实不太合理。\n想到此处，[NAME]自是纳头便拜，荆棘宫丝闻之大喜，浑身脂肪也随着她的放声大笑而如投石入塘般层层叠叠向外扩散。\n蓦然，荆棘宫丝笑声停止，仿佛突然想到了些什么，身手从下体中抽出已经被当角先生塞在屄里良久的前苏神教主苏小赞，然而但凡有又有点逻辑的人就能知道，屄里是没有空气的，眼耳口鼻中被灌满荆棘宫丝下体分泌物的苏小赞早已憋死在了荆棘宫丝的屄里……\n也不见荆棘宫丝的表情，好吧，那完全被脂肪堆满的脸上，五官都不怎么看得清，自然也不会有什么表情变化……只见荆棘宫丝随意的将浑身发紫已经没了气息的苏小赞随手扔进嘴里嚼了两口吞下肚去后道：“呀，这玩意被憋死了，所以说凡人还是不太行，小子，今天起你就是我教教主了，凭你的长相来成为我饭圈道的一门护法，想来那些脑残粉……呸，信徒们肯定可以为你舍身忘死……”\n言毕，荆棘宫丝凭空凝出了一本名为《饭圈道秘法-守护最好的XX》秘籍，便放任[NAME]离去了。");
world:SetWorldFlag(1705,5);world:UnLockJianghuClue(1708);me:LearnEsoteric("Gong1701_Esoterica_999");
story:FinishSecret();
end

function Hudong:shiqi69()--拒绝荆棘宫丝，直接死亡……
me:AddMsg("[NAME]毅然决然的拒绝了荆棘宫丝……而后[NAME]在听到了一声冷哼，就在也听不到别的了……");
npc1 = ThingMgr:FindThingByID(me.npcObj.ID)
Wqcsnpc = ThingMgr:FindThingByID(me.npcObj.ID)
	Hudong:Wqcs()
	npc1.LuaHelper:AddDamage("FightSkill_Disintegrate","LeftEye", 1, XT("被荆棘宫丝灵压所毁"));
	npc1.LuaHelper:AddDamage("FightSkill_Disintegrate","RightEye", 1, XT("被荆棘宫丝灵压所毁"));
	npc1.LuaHelper:AddDamage("FightSkill_Disintegrate","LeftEar", 1, XT("被荆棘宫丝灵压所毁"));
	npc1.LuaHelper:AddDamage("FightSkill_Disintegrate","RightEar", 1, XT("被荆棘宫丝灵压所毁"));
	npc1.LuaHelper:AddDamage("FightSkill_Disintegrate","Nose", 1, XT("被荆棘宫丝灵压所毁"));
	npc1.LuaHelper:AddDamage("FightSkill_Disintegrate","Spine", 1, XT("被荆棘宫丝灵压所毁"));
world:SetWorldFlag(1705,5);
story:FinishSecret();
end

function Hudong:shiqi70()--蛞蝓妖王作恶被唐舞桐阻止
	if world:GetWorldFlag(1708) < 1 and me:GetSex() == 1 then
	me:AddMsg("[NAME]上前探查，发现整个村庄四处散布着腥臭的粘液与村民们的尸骸，被腐蚀到残破不堪的尸骸无一不在述说着他们死前受到残害。\n而随着妖气前行，一头巨大无比的团体生物正包裹着四个赤裸的男子，这自然不是史莱姆娘与……毕竟修真界没史莱姆娘。\n[NAME]凝神定睛，眼前妖物的原型赫然显现于[NAME]眼前，这竟是一头修炼有成的蛞蝓妖王，而被它裹入体内正接受摧残的四个男子则正是丹霞山近年来的主打男团，呸，丹霞四秀，对，是丹霞四秀……葛弥逆，阿洛，邱生旺与弭醉四人。\n在[NAME]神通加持之下，可以清楚的看到蛞蝓妖王将自己的身体化为触手，入侵这这四人身上所有的孔穴，不只是谷道和面上五孔，就连阳根上那最娇弱柔软的小孔，也被蛞蝓妖王的触手所侵入，那阳具的每一次抖动仿佛都在告诉着[NAME]……\n忽，[NAME]只闻身后传来一声娇呵，一女御剑而来，其女银剑青衫仙霞环身，仿若神女临世，[NAME]甚至看的有些呆了就如同仿佛有魔咒勾走了他的魂儿一般。\n天仙般的人儿驾驭着灵剑斩向蛞蝓妖王，此情此景按着[NAME]时常在师兄师姐口中的故事里，蛞蝓妖王这种反派角色早被一剑斩死毫无二话了！\n可惜这是现实，妖王功力深厚，凭借身无定型的优势，困住了灵剑，并对仙女般的人儿射出了腥臭的体液……\n眼看佳人落难，[NAME]自觉即便实力不够，但也想为佳人赴上这一死时，之间女子祭出一盒状法宝后，便是那千万到银光散射而出，将妖王与他体内被吸成人干的丹霞四秀打成了筛子……\n天！这竟是西地唐门的绝世秘宝暴雨梨花，而这眼前的女子，自便是那拜师蜀山的唐家嫡女-唐舞桐！\n[NAME]还未从惊诧中反应过来，只见唐舞桐对[NAME]躲藏的角落回眸浅笑一瞬后，便御剑飞向了青莲剑宗的方向……");
	world:SetWorldFlag(1708,1);world:UnLockJianghuNpc("Npc_shiqi_4");
	else
	local bl1 = me:RandomInt(50,100);
	me:AddMsg("[NAME]到来时，发现遍地残骸为祸的妖邪也已经逃之夭夭了。\n一番搜刮后，[NAME]便上路了。\n[NAME]获得白银"..bl1.."两");
	me:AddModifier("Qian");me.npcObj.PropertyMgr:FindModifier("Qian"):UpdateStack(bl1 - 1);
	end
end

function Hudong:shiqi71()
	if me:GetSkillLevel("SocialContact") < 18 then
	local npc1 = ThingMgr:FindThingByID(me.npcObj.ID)
	me:AddMsg("[NAME]觉得这群天元女拳宗弟子确实说的不太像人话，故出场声援柯三吉，与女拳宗弟子讲起了道理，却不曾想天元女拳宗弟子又岂是正常的讲理之人，在对方的的胡搅蛮缠之下，[NAME]因自身不擅处事之道，竟然被对方颠倒黑白渐渐被其洗脑，成为了天元女拳宗的信徒。");
	ThingMgr:RemoveThing(npc1,false,true);me:AddSchoolRelation(170,-50);
	elseif me:GetSex() == 2 then
	me:AddMsg("[NAME]觉得这群天元女拳宗弟子确实说的不太像人话，故出场声援柯三吉，与女拳宗弟子讲起了道理，身为女子而又口才极佳的[NAME]三下五除二便将那群天元女拳宗弟子讲的自惭形秽，其中那领头看着一百五十斤有余的女子，当场跪地痛哭，说着如果自己能成功减肥到一百四十斤，如果自己长得可以像人，如果自己能有人要，是万万不可能加入女拳宗四处打拳的，奈何这个看脸的世道……\n一时间哭声四起，[NAME]身为女子也渐渐泛起了怜悯之心，是啊，丑女也是人，肥婆也应该有归宿！\n故[NAME]决定将这些浪子回头脱离的丑女们，都嫁给柯三吉为妻妾，以补偿他被昆仑奴绿还被天元女拳宗打拳所受到的伤害……\n柯家只是凡间一普通的大户人家，三吉也只是一个普通的棋士，自然不敢违抗女仙的命令，在族老的命令下，柯三吉只能吹吹打打的将一众悔改的丑女肥婆娶回家中。\n传言，柯三吉因为娶了一众肥婆丑女无心房事，故苦修棋艺成为一代国手。");
	me:AddSchoolScore(2,100);me:AddPenalty(-1);
	else
	me:AddMsg("[NAME]觉得这群天元女拳宗弟子确实说的不太像人话，故出场声援柯三吉，与女拳宗弟子讲起了道理，虽[NAME]口若悬河却因自身是个男子使得最后对方总能用：“除非你证明你肥婆丑女也算女人，你也愿意透，不然你就是在找接口”所破，毕竟[NAME]审美确实正常，要以身度肥婆有一说一确实不怎么合理，最后[NAME]只能灰溜溜的离开了。");
	me:AddSchoolScore(1,-200);me:AddSchoolRelation(170,-50);
	end
end

function Hudong:shiqi72()
	me:AddMsg("[NAME]觉得天元女拳宗真是太和自己胃口了，便加入了对方一同追寻拳法的大道。\n[NAME]脱离了本宗派。");
	ThingMgr:RemoveThing(npc1,false,true);me:AddSchoolRelation(170,50);
end

function Hudong:shiqi73()--战斗收服
Yaoguainame = Zhuyaoflag[yaoguai]
YaoguaiLv = math.floor(World.DayCount/10) + Yaozanli
npc = ThingMgr:FindThingByID(me.npcObj.ID)
SHNAME = nil
Godming = nil
zhenming = nil
GodLv = 0
buzhuoGod = 0
shuzi = 1
	while(npc.PropertyMgr.Practice.GodPracticeData:GetGuardData(shuzi)~= nil)do
	zhenming = npc.PropertyMgr.Practice.GodPracticeData:GetGuardData(shuzi)
	Godming = CS.XiaWorld.PracticeMgr.Instance:GetGodGuardDef(zhenming.cname)
	me:AddMsg("[NAME]从神国中召出了Lv."..Godming.Rate.."的守护神："..Godming.DisplayName.."-"..zhenming.name.."。");
	GodLv = GodLv + Godming.Rate
	shuzi = shuzi+1
		if Godming.DisplayName == Yaoguainame then
		buzhuoGod = 1
		end
		if SHNAME == nil then
		SHNAME = Godming.DisplayName.."-"..zhenming.name
		else
		SHNAME = SHNAME.."、"..Godming.DisplayName.."-"..zhenming.name
		end
	end
	if SHNAME ~= nil then
	me:AddMsg("[NAME]召唤出"..SHNAME.."与大妖"..Yaoguainame.."战做一团。\n[NAME]方守护神战力总计："..GodLv.."，"..Yaoguainame.."战力总计："..YaoguaiLv.."。");
		if GodLv > YaoguaiLv then
		me:AddMsg("[NAME]与他的守护神们击败了"..Yaoguainame.."。");
			if buzhuoGod ~= 1 then
			me:AddMsg("[NAME]收服了"..Yaoguainame.."。");
			npc.PropertyMgr.Practice.GodPracticeData:UnLockGodGuard("Guard_shenming_"..yaoguai)
			end
		me:AddSchoolScore(2,100);me:AddPenalty(-1);story:FinishSecret();
		else
		me:AddMsg("[NAME]与自己的守护神们悉数被大妖"..Yaoguainame.."灭杀。");
		ThingMgr:RemoveThing(me.npcObj,false,true)
		end
	end
end

function Hudong:shiqi74()--免战收服
Yaoguainame = Zhuyaoflag[yaoguai]
npc = ThingMgr:FindThingByID(me.npcObj.ID)
Godming = nil
zhenming = nil
buzhuoGod = 0
shuzi = 1
	while(npc.PropertyMgr.Practice.GodPracticeData:GetGuardData(shuzi)~= nil)do
	zhenming = npc.PropertyMgr.Practice.GodPracticeData:GetGuardData(shuzi)
	Godming = CS.XiaWorld.PracticeMgr.Instance:GetGodGuardDef(zhenming.cname)
	shuzi = shuzi+1
		if Godming.DisplayName == Yaoguainame then
		buzhuoGod = 1
		end
	end
end

function Hudong:shiqi75()--神游
local npc1 = ThingMgr:FindThingByID(me.npcObj.ID)
local npcshouming = math.floor(npc1.MaxAge - npc1.Age)
local npcshenmin = npc1.LuaHelper:GetGodPopulation()
local npcxinyang = npc1.LuaHelper:GetFaith()
	if string.find(StoryEx.input,"历") ~= nil or string.find(StoryEx.input,"游") ~= nil then
	local youlinianshu = world:RandomInt(1,5)
	local youlinianzhong = Hudong:formatNumber(youlinianshu)
		if npcshenmin > 10000 then
		me:AddMsg("[NAME]在神国中游历了"..youlinianzhong.."年，游历过程中以神使的身份帮助了不少神民……\n");
		npc1.LuaHelper:AddFaith(world:RandomInt(100,math.floor((npcshenmin/world:RandomInt(5,50)))));
		elseif npcshenmin < 1 then
		me:AddMsg("[NAME]在神国中游历了"..youlinianzhong.."年，发现自己的神国中已经没有任何神民了");
		elseif npcxinyang > 1000 then
		me:AddMsg("[NAME]在神国中游历了"..youlinianzhong.."年，但是因为神国的神民们太少了，[NAME]以众生之愿力改变了部分神国之内的法则，神民们对生儿育女更有兴趣了……\n");
		npc1.LuaHelper:AddFaith(-1000);
		npc1.LuaHelper:AddGodPopulation(math.floor(npcshenmin/10));
		else
		me:AddMsg("[NAME]在神国中游历了"..youlinianzhong.."年，但是因为神国的神民们太少了，[NAME]想以众生之愿力改变了神国之内的法则，然而他的信仰之力不足以承担改变法则的消耗……\n");
		end
	npc1.PropertyMgr:AddAge(youlinianshu);
	me:AddMsg("[NAME]当前年龄："..Hudong:formatNumber(math.floor(npc1.Age)).."岁，预计总寿元"..Hudong:formatNumber(math.floor(npc1.MaxAge)).."年\n神民："..Hudong:formatNumber(math.floor(npcshenmin)).."人\n信力值："..npcxinyang.."点");
	me:TriggerStory("Shenyou");
	elseif string.find(StoryEx.input,"离") ~= nil or string.find(StoryEx.input,"去") ~= nil then
	me:AddMsg("[NAME]离开了神国……");
	me:AddMsg("[NAME]当前年龄："..Hudong:formatNumber(math.floor(npc1.Age)).."岁，预计总寿元"..Hudong:formatNumber(math.floor(npc1.MaxAge)).."年\n神民："..Hudong:formatNumber(math.floor(npcshenmin)).."人\n信力值："..npcxinyang.."点");
	else
	Godming = nil
	zhenming = nil
	panduanshifouyougaijuese = 0
	shuzi = 1
		while(npc1.PropertyMgr.Practice.GodPracticeData:GetGuardData(shuzi)~= nil)do
		zhenming = npc1.PropertyMgr.Practice.GodPracticeData:GetGuardData(shuzi)
		Godming = CS.XiaWorld.PracticeMgr.Instance:GetGodGuardDef(zhenming.cname)
		shuzi = shuzi+1
			if Godming.DisplayName == StoryEx.input then
			panduanshifouyougaijuese = shuzi - 1
			end
		end
		if panduanshifouyougaijuese > 0 then
		zhenming = npc1.PropertyMgr.Practice.GodPracticeData:GetGuardData(panduanshifouyougaijuese)
		local shendeingzi = StoryEx.input
			world:ShowStoryBox(""..npc1.Name.."唤来了神国的守护神："..StoryEx.input.."！",StoryEx.input,{"交谈","离开"},
			function(key)
				if key == 0 then
					if npc1.Sex == CS.XiaWorld.g_emNpcSex.Male and (shendeingzi == "佛母" or shendeingzi == "珈蓝" or shendeingzi == "龙女" or shendeingzi == "金刚" or shendeingzi == "剑神" or shendeingzi == "灵狐" or shendeingzi == "青行灯" or shendeingzi == "香姬" or shendeingzi == "女帝" or shendeingzi == "玉姬") then
						local panding = world:RandomInt(1,1000)
						if string.find(zhenming.name,"（") == nil then
						zhenming.name = zhenming.name.."（陌生）"
						wenben = ""..npc1.Name.."和"..shendeingzi.."聊了一会，"..shendeingzi.."有一搭没一嗒的回复着"..npc1.Name.."。\n"..shendeingzi.."对"..npc1.Name.."没啥兴趣！"
						elseif string.find(zhenming.name,"陌生") ~= nil then
							if panding > 800 then
							zhenming.name = string.gsub (zhenming.name, "陌生", "相熟")
							wenben = ""..npc1.Name.."和"..shendeingzi.."聊了一会，"..shendeingzi.."忽的邀请"..npc1.Name.."一同去她的神庙中聆听信徒的祈求。\n"..npc1.Name.."帮助"..shendeingzi.."的信徒实现了不少愿望后，"..shendeingzi.."对"..npc1.Name.."的好感度提升了！"
							else
							wenben = ""..npc1.Name.."和"..shendeingzi.."聊了一会，"..shendeingzi.."既冷漠又敷衍，有一搭没一搭的回复着"..npc1.Name.."。\n"..shendeingzi.."对"..npc1.Name.."没啥兴趣！"
							end
						else
						wenben = ""..npc1.Name.."和"..shendeingzi.."聊了一会，"..shendeingzi.."邀请"..npc1.Name.."一同去她的神庙中聆听信徒的祈求。\n"..npc1.Name.."和"..shendeingzi.."在神庙中度过了一段时光。"
						end
					else
					wenben = ""..npc1.Name.."和"..shendeingzi.."聊了一会，然而"..shendeingzi.."对"..npc1.Name.."没啥兴趣！"
					end
				return wenben
				end
				if key == 1 then
				wenben = ""..npc1.Name.."让"..shendeingzi.."离开了。"
				return wenben
				end
			end
			);
		else
		me:AddMsg("[NAME]的神国中没有"..StoryEx.input.."");
		me:TriggerStory("Shenyou");
		end
	end
end

function Hudong:shiqi1701()--小龙女（杨梓）未完成
npc1 = ThingMgr:FindThingByID(me.npcObj.ID)
local liaotian = world:GetWorldFlag(1709) + 1
local mijian = world:GetWorldFlag(1710) + 1
	if StoryEx.input == "交谈" or StoryEx.input == "闲聊" or StoryEx.input == "聊天" then
		if LNHDCD == World.DayCount then
		me:AddMsg("杨梓今天已经很累了……");
		elseif world:GetWorldFlag(1709) > 80 then
		me:AddMsg("好感度的纯爱线我还没写，没想到把，有一说一能坚持80天闲聊的你，作为作者我还是很感动嗒……");
		else
		me:AddMsg("[NAME]和被囚禁于宗门内的杨梓闲聊了一些无关紧要的事情，杨梓对被本门的抵触也略有下降……");
		world:SetWorldFlag(1709,liaotian);
		LNHDCD = World.DayCount
		end
	elseif StoryEx.input == "迷奸" or StoryEx.input == "催眠" or StoryEx.input == "神通" then
		if world:GetWorldFlag(1704) == 5 then
		me:AddMsg("[NAME]和已被调教成母狗的杨梓干了个爽……");
			if npc1.GongKind == g_emGongKind.Body then 
			local Panding = world:RandomInt(1,101);
				if Panding < 6 and npc1.PropertyMgr.Practice.BodyPracticeData.SuperParts:ContainsKey("SuperPart_Nvquan_3") == false then
				me:AddMsg("干至忘我之时，杨梓说出了一门她们古墓派的武学秘要……");
				npc1.PropertyMgr.Practice.BodyPracticeData:UnLockSuperPart("SuperPart_Nvquan_3")
				elseif Panding > 95 and npc1.PropertyMgr.Practice.BodyPracticeData.SuperParts:ContainsKey("SuperPart_Nvquan_1") == false then
				me:AddMsg("干至忘我之时，杨梓说出了一门她们古墓派的武学秘要……");
				npc1.PropertyMgr.Practice.BodyPracticeData:UnLockSuperPart("SuperPart_Nvquan_1")
				elseif Panding > 90 and npc1.PropertyMgr.Practice.BodyPracticeData.SuperParts:ContainsKey("SuperPart_Nvquan_2") == false then
				me:AddMsg("干至忘我之时，杨梓说出了一门她们古墓派的武学秘要……");
				npc1.PropertyMgr.Practice.BodyPracticeData:UnLockSuperPart("SuperPart_Nvquan_2")
				end
			end
		elseif world:GetWorldFlag(1710) > 10 then
		me:AddMsg("长期被囚困于"..SchoolMgr.Name.."的杨梓自是被那些仙门弟子们通过术法当初泄欲工具肆意玩弄，虽每次事毕均被使用道法洗去记忆，可身体的记忆却还被保留着，此番[NAME]尚未对其使用催情迷魂之法，却见其已经媚态尽显，见此情形[NAME]也停止了将施的术法，与之一番云雨。\n云雨之时，[NAME]从其口中得知了她并不是那青莲大能尹志平口中的小龙女，那古墓神女早在百年前便因情花之毒死于绝情谷底，死前诞一女正是青莲剑宗大能尹志平的遗腹子，而十六年后神雕大侠纵身跃下绝情谷所见到的女子，则是小龙女与尹志平的……");
		world:SetWorldFlag(1704,5);
		else
		me:AddMsg("[NAME]垂涎于此等绝色佳人已久，虽说这是青莲剑宗大能尹志平所看上的猎物，不过她既早已身为人妇，想来玩上一通也无大碍，想到此处[NAME]便施展了迷魂神通，将此女奸污了一番。\n事毕，[NAME]心满意足之余，又施展神通将现场复原，自当无事……");
		end
	world:SetWorldFlag(1710,mijian);
	return false;
	elseif StoryEx.input == "胁迫" and me:GetSex() == 1 then
	me:AddMsg("[NAME]将与此女一同被擒来的男子缚于其身前，以性命胁之……\n只见两行清泪从女子眼眶滑落，自知身陷"..SchoolMgr.Name.."这等仙门之中，仅凭凡世武学自是万万无法反抗的，自己与郎君的性命均在对方的一念之间，无奈之下只好在[NAME]的面前褪尽衣衫任其采摘……\n事毕，心满意足的[NAME]正待离去，却被心魔所惑，此等绝色之女若能独占……\n[NAME]背叛的宗门，将此女裹挟而去了……");
	local npc1 = ThingMgr:FindThingByID(me.npcObj.ID)
	ThingMgr:RemoveThing(npc1,false,true)
	world:SetWorldFlag(1704,4);
	return false;
	elseif StoryEx.input == "观察" then
	me:AddMsg("杨梓当前：\n好感度："..world:GetWorldFlag(1709).."");
	elseif StoryEx.input == "离开" then
	me:AddMsg("[NAME]离开了杨梓的房间");
	return false;
	else
	me:AddMsg("[NAME]不能"..StoryEx.input.."杨梓");
	end
	me:TriggerStory("NPC_Xiaolongnv");
end

function Hudong:shiqi1702()--周芷若
npc1 = ThingMgr:FindThingByID(me.npcObj.ID)
local npc = CS.XiaWorld.NpcRandomMechine.RandomNpc("Human",g_emNpcSex.Female);
	if StoryEx.input == "交谈" or StoryEx.input == "闲聊" or StoryEx.input == "聊天" or StoryEx.input == "调教" or StoryEx.input == "玩" or StoryEx.input == "驯养" then
		if npc1.PropertyMgr:CheckFeature("ZZRdezhuren") then
		me:AddMsg("[NAME]来到周芷若的房间，抱起了她，对她上下其手亵玩了一番，还不时的用鼻尖在她身上用力着吸气，说了会奇奇怪怪的话，便揉了揉周芷若的脑袋离开了……");
		else
		me:AddMsg("[NAME]来到周芷若的房前，突然想起这是门中著名疯狗精神病体修的家眷，实在招惹不得，便作罢离开了……");
		end
	elseif StoryEx.input == "强奸" or StoryEx.input == "强暴" or StoryEx.input == "施暴" or StoryEx.input == "奸污" or StoryEx.input == "侮辱" then
		if npc1.PropertyMgr:CheckFeature("ZZRdezhuren") then
		me:AddMsg("[NAME]作为周芷若的饲主，并不想"..StoryEx.input.."对方");
		else
		me:AddMsg("[NAME]来到周芷若的房前，突然想起这是门中著名疯狗精神病体修的家眷，实在招惹不得，便作罢离开了……");
		end
	elseif StoryEx.input == "学习" or StoryEx.input == "求教" or StoryEx.input == "请教" then
		if npc1.PropertyMgr.Practice.BodyPracticeData.SuperParts:ContainsKey("SuperPart_Nvquan_4") == false and npc1.GongKind == g_emGongKind.Body and world:GetWorldFlag(1714) == 3 then
		me:AddMsg("[NAME]从周芷若的传授中，学会了九阴白骨爪秘体……");
		npc1.PropertyMgr.Practice.BodyPracticeData:UnLockSuperPart("SuperPart_Nvquan_4")
		else
		me:AddMsg("[NAME]不觉得可以从周芷若身上学到什么……");
		end
	elseif StoryEx.input == "离开" then
	me:AddMsg("[NAME]离开了周芷若的房间");
	else
	me:AddMsg("[NAME]不能"..StoryEx.input.."对方");
	me:TriggerStory("NPC_Zhouzhiruo");
	end
end

function Hudong:shiqi998()
npc1 = ThingMgr:FindThingByID(me.npcObj.ID)
zhangmen = ThingMgr:FindThingByID(CS.XiaWorld.SchoolMgr.Instance.MasterID)
menpai = world:RandomInt(1,13)
mpName = world:GetSchoolName(menpai)
NanName = NpcMgr:GetRandomFullName("Human",CS.XiaWorld.g_emNpcSex.Male)
Panding = me:RandomInt(1,9);
Sjxs = NpcMgr:GetRandomPrefixName("Human",CS.XiaWorld.g_emNpcSex.Male)
sjnpc = World.map.Things:RandomNpc()
print(sjnpc)
	if shiqidejiance == 1 then
	local wenben = me:ParseNpcStory("[rand_lable=desc_time,desc_place,desc_weather]，"..npc1.Name.."突然很想死，"..npc1.Name.."人没了。")
	me:AddMsg(wenben);me:AddMemery(wenben);
	me:ModifierProperty("MaxAge",-99999999);
	elseif zhangmen ~= nil and zhangmen ~= npc1 and world:GetWorldFlag(1714) == 4 then
	me:AddMsg(""..zhangmen.Name.."于门中修行，得弟子"..npc1.Name.."禀山下有一群江湖人士前来讨要说法。\n据对方所说近来天下出了一个大魔头四处抓捕江湖侠女以采补邪术祸害之，而其自称是我"..SchoolMgr.Name.."记名弟子，故众人前来讨要一个说法。")
	zhangmen.LuaHelper:TriggerStory("Suiji09");
	world:SetWorldFlag(1714,5)
	elseif SchoolMgr:GetSchoolData(CS.XiaWorld.g_emSchoolData.NumWorker) == 1 and SchoolMgr:GetSchoolData(CS.XiaWorld.g_emSchoolData.NumDisciple) == 0 then
	local wenben = me:ParseNpcStory("[rand_lable=desc_time,desc_place,desc_weather]，"..npc1.Name.."正在山中闲来无事，见到一对夫妇逃难至此，想要讨口水喝。\n女子向"..npc1.Name.."求助道：“这位先生，我们夫妻被恶人图谋，一路逃难至此，可否向先生讨口水喝，我们好继续上路……”")
	me:AddMsg(wenben);me:AddMemery(wenben);npc1.LuaHelper:TriggerStory("Suiji08");
	elseif Panding == 4 and npc1.RaceDefName ~= "Human" and npc1.Sex ~= sjnpc.Sex and sjnpc.RaceDefName == "Human" and zhangmen ~= nil and zhangmen ~= npc1 and zhangmen ~= sjnpc and sjnpc.PropertyMgr.RelationData.m_mapRelationShips:ContainsKey("Spouse") == false then
	me:AddMsg("妖族弟子"..npc1.Name.."意图迷奸门派中的人族女弟子"..sjnpc.Name.."，事情败露后被擒至祖师殿由掌门"..zhangmen.Name.."惩处……")
	me:TriggerStory("Suiji12");
	elseif Panding == 2 and zhangmen ~= nil and zhangmen == npc1 and GameDefine.GetSchoolMaxNpc(SchoolMgr.Level) > SchoolMgr:GetSchoolData(CS.XiaWorld.g_emSchoolData.NumDisciple) + SchoolMgr:GetSchoolData(CS.XiaWorld.g_emSchoolData.NumWorker) + 1 then
	local wenben = me:ParseNpcStory("[rand_lable=desc_time,desc_place,desc_weather]，"..SchoolMgr.Name.."掌门"..npc1.Name.."于山门得弟子禀，"..SchoolMgr.Name.."山下"..Sjxs.."家集有邪修作乱奸淫掳掠无恶不作，正待"..npc1.Name.."打算听弟子细说之时，又得一弟子禀山门前一对绝色佳人正被一名面相猥琐的老道追索……")
	me:AddMsg(wenben);me:AddMemery(wenben);me:TriggerStory("Suiji06");
	elseif Panding == 7 and zhangmen ~= nil and zhangmen == npc1 and npc1.RaceDefName ~= "Human" then
	me:AddMsg(""..npc1.Name.."于门中修行，得弟子禀山下有一伙来自天元女拳宗的修士正向山门赶来，"..npc1.Name.."大惊失色，天元女拳宗可是修真界响当当的一个疯狗门派，被她们以“压迫女性，物化女性”为借口灭掉的门派数不胜数，难道今日便是我"..SchoolMgr.Name.."的末日？\n"..npc1.Name.."赶忙召唤弟子严阵以待，适时，天元女拳宗来客被引入大厅，"..npc1.Name.."一眼看去，众女皆是青面獠牙虎背熊腰又或是脂肪层层堆叠一眼就能看出很好吃的样子。\n“天，世间竟有如此出尘绝艳之女子！”（妖怪审美）"..npc1.Name.."整个妖看的都呆住拉，说话也不怎么利索，但依旧顺利的询得了来意。\n天！众位美人竟然全是因为听闻"..SchoolMgr.Name.."是洋大人……呸，是妖修当家做主的门派，是赶着趟来千里送肥鲍的，见此情形"..npc1.Name.."二话不说便碎了衣裤与那一众符合妖族审美的奇女子们酣战一宿……\n事毕，天元宗女拳宗众女，心满意足的离开了"..SchoolMgr.Name.."。")
	me:AddSchoolRelation(170,200);npc1.Needs:AddNeedValue(CS.XiaWorld.g_emNeedType.Practice,500);
	elseif Panding == 7 and zhangmen ~= nil and zhangmen == npc1 and zhangmen.LuaHelper:GetGongName() ~= "Body_Gong_nvquan" then
	local wenben = me:ParseNpcStory("一支自称天元女拳宗女修组织，以听闻"..SchoolMgr.Name.."的掌门"..zhangmen.Name.."竟然是男人，身为拳法先锋的她们大热天全身冷汗、手脚冰凉，气得浑身发抖，就连眼泪都不争气的流了下来！\n她们高呼道：“这个修真界到底怎么了，为什么到处充斥着对女修的压迫，女修们什么时候才能站起来……”\n但是身为女修的她们，心底还是有着最柔软的一块，并没有直接向"..SchoolMgr.Name.."吹起了战争的号角，而是给于"..SchoolMgr.Name.."修士们选择的权利……")
	me:AddMsg(wenben);me:TriggerStory("Suiji02");world:SetWorldFlag(1712,world:GetWorldFlag(1712)+1);
	elseif Panding == 6 and world:GetWorldFlag(1704) == 5 then
	local zhongzu = WorldLua:RandomInt(1,#zhongzubiaoge+1);
	local npc = CS.XiaWorld.NpcRandomMechine.RandomNpc(zhongzubiaoge[zhongzu],g_emNpcSex.Male);
	npc:AddTitle("尹志平的弟子");
	CS.XiaWorld.NpcMgr.Instance:AddNpc(npc,250,Map,CS.XiaWorld.Fight.g_emFightCamp.Enemy);
	CS.XiaWorld.ThingMgr.Instance:EquptNpc(npc,npc.LuaHelper:RandomInt(3,10),CS.XiaWorld.g_emNpcRichLable.Richest);
	npc.FightBody.AttackWait = 1;
	npc.FightBody.AttackTime = 10000;
	npc.FightBody.AutoNext = true;
	npc.FightBody.IsAttacker = true;
	local wenben = me:ParseNpcStory("青莲剑宗大能尹志平听说我们已经捕获了小龙女，却久久不愿意将其送去感到非常不满，派遣了座下弟子"..npc.Name.."前来找茬")
	me:AddMsg(wenben);me:AddMemery(wenben);
	elseif me.npcObj.PropertyMgr.BodyData:PartIsBroken("Genitals") then
	me:AddMsg("可惜[NAME]身上无管可撸。");
	elseif me:GetModifierStack("Zhenchaosuo") > 0 or me:GetModifierStack("Zhenchaozhou") > 0 then
	local wenben = me:ParseNpcStory("[rand_lable=desc_time,desc_place,desc_weather]，"..npc1.Name.."在[obj_action]时，因为勃发的性欲，"..npc1.Name.."想要撸一发，可惜小兄弟被贞操锁禁锢着。")
	me:AddMsg(wenben);me:AddMemery(wenben);
	elseif npc1.GongKind == g_emGongKind.Body then--主角是体修，开启体修随机事件
	local Panding = world:RandomInt(1,4)
		if world:GetWorldFlag(1714) == 1 then
		me:AddMsg("周芷若被[NAME]抓到"..SchoolMgr.Name.."已经有些时日了，对于日日不缀来亵玩自己的[NAME]，起初周芷若对此无比厌恶，然而身陷"..SchoolMgr.Name.."的周芷若，既打不过又跑不走，就连自绝心脉也会被对方轻易的用一颗丹药救回来，寻死都不能的周芷若仿佛被突破了那一条由恐惧所守护的心房，甚至对于每日来搂抱投食自己的[NAME]产生了些许依赖感，毕竟即使自己全是上下皆被其把玩了过了，可对方始终没有坏自己的清白，也不限制自己在门派内活动，仿佛对方一直将自己当做一只被圈养的宠物一般对待。\n忽地，环臂搂着周芷若的[NAME]把脸贴了上来，惊愕之下周芷若又习惯性的屈指成爪，直接向[NAME]的脖子袭去，也不见[NAME]闪避，反而在被袭后，笑吟吟的贴上周芷若的脸颊上蹭了两下，呢喃道：“小白，怎么又调皮，在山上是不是呆的不开心，我带你下山去中原玩好不好？”。\n说罢，也不管周芷若愿不愿意，便准备带着周芷若下山去了……");
		world:SetWorldFlag(1714,2)
		elseif Panding == 1 and GameDefine.GetSchoolMaxNpc(SchoolMgr.Level) > SchoolMgr:GetSchoolData(CS.XiaWorld.g_emSchoolData.NumDisciple) + SchoolMgr:GetSchoolData(CS.XiaWorld.g_emSchoolData.NumWorker) then
		local wenben = me:ParseNpcStory("[rand_lable=desc_time,desc_place,desc_weather]，"..npc1.Name.."于山门修行时，见一过路女子美貌非凡，故起了一些小心思……")
		me:AddMsg(wenben);me:AddMemery(wenben);me:TriggerStory("Suiji03");
		elseif Panding == 2 then
		local wenben = me:ParseNpcStory("[rand_lable=desc_time,desc_place,desc_weather]，一群逃难的灾民途经"..SchoolMgr.Name.."。")
		me:AddMsg(wenben);me:TriggerStory("Suiji05");
		elseif npc1.Needs:GetNeedValue(CS.XiaWorld.g_emNeedType.Practice) < 100 and npc1.PropertyMgr.Practice.BodyPracticeData:GetQuenchingItemCount("Item_yinjin") > 0 then
		me:AddMsg(""..npc1.Name.."于门中修行，因精元匮乏导致几近走火入魔")
			if npc1.PropertyMgr:CheckFeature("Yingjingzhe") then
			me:AddMsg(""..npc1.Name.."二话不说从袖中掏出一份阴精便灌入口中……")
			npc1:AddMood("Yingjingzhe1")
			else
			me:AddMsg(""..npc1.Name.."纠结了半天后，掏出了一份阴精，捏着鼻子吞服了下去……")
			npc1:AddMood("Yingjingzhe2")
			end
			npc1.PropertyMgr.Practice.BodyPracticeData:AddQuenchingItem("Item_yinjin",-1)
			npc1.Needs:AddNeedValue(CS.XiaWorld.g_emNeedType.Practice,200)
		else--体修保底事件
		wenben = me:ParseNpcStory("[rand_lable=desc_time,desc_place,desc_weather]，"..npc1.Name.."在[obj_action]时，因为勃发的性欲，"..npc1.Name.."对着自己的小兄弟上下搓弄了百余下，射出了一泡浓厚的精液。\n事毕，"..npc1.Name.."将精液集中到一起，存放了起来以用于日后的修炼。")
		me:AddMsg(wenben);me:AddMemery(wenben);
			if ThingMgr:FindThingByID(npc1.ID).PropertyMgr.Practice.GodCount > 0 then
			npc1.PropertyMgr.Practice.BodyPracticeData:AddQuenchingItem("Item_yangjin",32);
			elseif npc1.LuaHelper:GetGLevel() > 9 then
			npc1.PropertyMgr.Practice.BodyPracticeData:AddQuenchingItem("Item_yangjin",16);
			elseif npc1.LuaHelper:GetGLevel() > 6 then
			npc1.PropertyMgr.Practice.BodyPracticeData:AddQuenchingItem("Item_yangjin",8);
			elseif npc1.LuaHelper:GetGLevel() > 3 then
			npc1.PropertyMgr.Practice.BodyPracticeData:AddQuenchingItem("Item_yangjin",4);
			elseif npc1.LuaHelper:GetGLevel() > 0 then
			npc1.PropertyMgr.Practice.BodyPracticeData:AddQuenchingItem("Item_yangjin",2);
			else
			npc1.PropertyMgr.Practice.BodyPracticeData:AddQuenchingItem("Item_yangjin",1);
			end
		end
	elseif Panding == 1 and npc1.Sex ~= sjnpc.Sex and sjnpc.IsAlive and sjnpc:HasSpecialFlag(g_emNpcSpecailFlag.MapExploring) == false and sjnpc:HasSpecialFlag(g_emNpcSpecailFlag.AuctionPunish) == false and npc1.PropertyMgr.RelationData:IsRelationShipWith("Spouse",sjnpc) then
	me:AddMsg(""..npc1.Name.."于山下闲逛，见一秃顶驾着金钵向"..npc1.Name.."飞来。\n只见他收起脚下金钵，落在"..npc1.Name.."身边，呼了声佛号说到：\n贫僧乃上古神修大派佛们的传承者，今日云游至此，见此地妖气冲天，又见施主印堂发黑，妖气盘踞玄关，你家中必有千年的妖精，施主性命已经危在旦夕！不如贫僧收了她们，我要她们助我修行，亦望施主莫要沉迷情欲！");
		if npc1.LuaHelper:GetGLevel() < 1 and sjnpc.LuaHelper:GetGLevel() < 7 then
		me:AddMsg("[NAME]连声道谢后，将法师迎如家中捉妖！只见那秃驴一声大喝袈裟便如通灵了一般将"..sjnpc.Name.."困住。\n法师将"..sjnpc.Name.."降服之后在[NAME]的连声道谢中离去了……\n“艳阳天里风光好，是红的花儿，绿的草，我乐乐呵呵向前跑，踏遍青山人未老。”只听法师哼着歌谣慢慢消失夕阳下，只留下不停磕头的[NAME]。这大概就是正道的光吧。");
		ThingMgr:RemoveThing(sjnpc,false,true)
		elseif npc1.LuaHelper:GetGLevel() < 1 and sjnpc.LuaHelper:GetGLevel() > 6 then
		me:AddMsg("[NAME]连声道谢后，将法师迎如家中捉妖！只见那秃驴一声大喝袈裟便如通灵了一般将"..sjnpc.Name.."罩住，却不曾想"..sjnpc.Name.."的修为也是不凡直接破除这封体袈裟……\n见短时间内拿不下"..sjnpc.Name.."，又怕被宗门围攻，和尚逃离了此地……\n"..sjnpc.Name.."因此事与"..npc1.Name.."离婚了……");
		sjnpc.PropertyMgr.RelationData:RemoveRelationShip(npc1,"Spouse");
		elseif npc1.LuaHelper:GetGLevel() < 7 and npc1.RaceDefName == "Human" then
		me:AddMsg("[NAME]望了一眼那个秃驴，挠了挠头嘲讽到“我觉得你的脑子出了一些问题，你他娘是佛教余孽，你特娘歧视女性物化女性，你还搁着阴阳怪气的要收了我老婆？”\n那和尚闻言大怒：“大胆，妖跟人不该有凡俗之情！执迷不悟，应得惩罚！”\n“大威天龙，大罗法咒，金钵！袈裟！淦！”\n“雷电风火，杀！夜叉恶鬼，杀！魔尊妖孽，杀！地狱鬼使，杀！”\n双方拼杀在一起，打了许久不曾想竟然惊动了天元村人……\n数百名天元村女修瞬间从天元村中奔杀而出将[NAME]和那秃驴团团围住：“好啊，这不是巧了么，佛教余孽和该死的男修咬狗了这是，你们都得死！”\n[NAME]闻言大骇，却又转念一想，这天元村人向来于佛门之人不共戴天，连忙抢先说到：“秃驴该死，歧视女性的佛教该死，什么女人是五漏体，女人不可成佛成魔成梵王之类的，就是纯粹的歧视女性，还什么狗屁女人成佛要变成男人，这赤裸裸的歧视女性我一个男修都看不下去了！”\n众所周知天元女拳宗的弟子因为修炼拳法，把脑子练的差不多快没了，一听[NAME]如此说到，便开始围攻起了那个和尚，毕竟佛门和天元宗那是真的不共戴天……\n乘机溜走了……")
		me:AddSchoolRelation(170,50);
		elseif npc1.LuaHelper:GetGLevel() < 7 then
		me:AddMsg("[NAME]望了一眼那个秃驴，挠了挠头嘲讽到“我觉得你的脑子出了一些问题，你他娘是佛教余孽，你特娘歧视女性物化女性，你还搁着阴阳怪气的要收了我老婆？”\n那和尚闻言大怒：“大胆，妖跟人不该有凡俗之情！执迷不悟，应得惩罚！”\n“大威天龙，大罗法咒，金钵！袈裟！淦！”\n“雷电风火，杀！夜叉恶鬼，杀！魔尊妖孽，杀！地狱鬼使，杀！”\n双方拼杀在一起，打了许久不曾想竟然惊动了天元村人……\n数百名天元村女修瞬间从天元村中奔杀而出将那秃驴团团围住：“秃驴该死，居然敢伤害妖大人！”\n[NAME]见到天元村人到来，暗自心中大定道：“天元村的姐姐们，这个秃驴非要拉我去入他们那个什么鬼佛教，我说了我不去那种歧视女性的宗教，他就打我嘤嘤嘤……”\n众所周知天元女拳宗的弟子看到妖大人即将为那秃驴所害，本就气血上涌愤怒无比，又听[NAME]如此说到，便开始围攻起了那个和尚，毕竟佛门和天元宗那是真的不共戴天……\n事毕，天元村众人打死了那个秃驴后[NAME]表示无以为报以身相许使得众女大喜，与之酣畅淋漓的大战了一宿……")
		me:AddSchoolRelation(170,200);npc1.Needs:AddNeedValue(CS.XiaWorld.g_emNeedType.Practice,500);
		else
		me:AddMsg("[NAME]直接把这个哔哔赖赖的脑瘫和尚打死了");
		end
	elseif Panding == 1 then
	local wenben = me:ParseNpcStory("[rand_lable=desc_time,desc_place,desc_weather]，"..npc1.Name.."在[obj_action]时，因为勃发的性欲，"..npc1.Name.."对着自己的小兄弟上下搓弄了百余下，射出了一泡浓厚的精液。")
	me:AddMsg(wenben);me:AddMemery(wenben);
		if ThingMgr:FindThingByID(me.npcObj.ID).PropertyMgr.Practice.GodCount > 0 then
		me:DropAwardItem("Item_yangjin6",1);
		elseif me:GetGLevel() > 9 then
		me:DropAwardItem("Item_yangjin5",1);
		elseif me:GetGLevel() > 6 then
		me:DropAwardItem("Item_yangjin4",1);
		elseif me:GetGLevel() > 3 then
		me:DropAwardItem("Item_yangjin3",1);
		elseif me:GetGLevel() > 0 then
		me:DropAwardItem("Item_yangjin2",1);
		else
		me:DropAwardItem("Item_yangjin1",1);
		end
	elseif Panding == 2 then
	local wenben = me:ParseNpcStory("[rand_lable=desc_time,desc_place,desc_weather]，"..npc1.Name.."在[obj_action]时，突然想要去[obj_unlockmapplace]吃[obj_food]。")
	me:AddMsg(wenben);me:AddMemery(wenben);
	elseif Panding == 3 and GameDefine.GetSchoolMaxNpc(SchoolMgr.Level) > SchoolMgr:GetSchoolData(CS.XiaWorld.g_emSchoolData.NumDisciple) + SchoolMgr:GetSchoolData(CS.XiaWorld.g_emSchoolData.NumWorker) then
	local wenben = me:ParseNpcStory("[rand_lable=desc_time,desc_place,desc_weather]，"..npc1.Name.."于山门修行时，见一过路女子美貌非凡，故起了一些小心思……")
	me:AddMsg(wenben);me:AddMemery(wenben);me:TriggerStory("Suiji03");
	elseif Panding == 4 and npc1.LuaHelper:GetGLevel() > 0then
	local wenben = me:ParseNpcStory("[rand_lable=desc_time,desc_place,desc_weather]，"..npc1.Name.."在[obj_action]时，因专注于[obj_action]，"..npc1.Name.."对[obj_esoterica]的领悟又深了一层。")
	me:AddMsg(wenben);me:AddMemery(wenben);npc1.LuaHelper:AddTreeExp(100 * npc1.LuaHelper:GetGLevel());
	elseif Panding == 5 then
	local wenben = me:ParseNpcStory("[rand_lable=desc_time,desc_place,desc_weather]，"..npc1.Name.."在后山闲逛时，很幸运的捡到了一百两纹银。")
	me:AddMsg(wenben);me:AddMemery(wenben);me:AddModifier("Qian");me.npcObj.PropertyMgr:FindModifier("Qian"):UpdateStack(99);
	elseif Panding == 6 and world:GetWorldFlag(1705) < 1 then
	local wenben = me:ParseNpcStory("[rand_lable=desc_time,desc_place,desc_weather]，"..npc1.Name.."在门中修行，一[obj_goodschool]的弟子前来拜山，与"..npc1.Name.."聊起自家境内的凡人武修门派“傲山门”被一伙自称“苏神教”的邪门歪道灭门之事，当然这毕竟属于凡俗之事，于修真者口中也不过饭后笑谈而已。")
	me:AddMsg(wenben);me:AddMemery(wenben);world:SetWorldFlag(1705,1);world:UnLockJianghuSecret(1702);world:UnLockJianghuNpc("Npc_shiqi_2")
	elseif Panding == 6 and world:GetWorldFlag(1705) == 3 then
	local wenben = me:ParseNpcStory("[rand_lable=desc_time,desc_place,desc_weather]，"..npc1.Name.."在门中修行，一[obj_goodschool]的弟子前来拜山，与"..npc1.Name.."相谈甚欢，饭后双人一通闲聊，对傲山门覆灭一事略有兴趣的"..npc1.Name.."从其口中得知苏神教的最新近况，据其所述苏神教打着反双修的大旗，将傲山门举报于官府之后，又尾随灭杀傲山门人之举，被合欢宗或极天宫的凡间势力所不忿，这段时日他们已经将苏神教徒打的溃不成军，就连中原这最后一块阵地也正岌岌可危……")
	me:AddMsg(wenben);me:AddMemery(wenben);world:SetWorldFlag(1705,4)me:AddSecret(1704);
	elseif Panding == 6 then
	local wenben = me:ParseNpcStory("[rand_lable=desc_time,desc_place,desc_weather]，"..npc1.Name.."在门中修行，一"..mpName.."的弟子"..NanName.."前来拜山，"..NanName.."与"..npc1.Name.."相谈甚欢，饭后双人一通闲聊之余互相印证修炼之法，"..npc1.Name.."发现自己的修为略有精进。")
	me:AddMsg(wenben);me:AddMemery(wenben);me:AddPracticeResource("Stage",me:GetGLevel() * 500);me:AddSchoolRelation(menpai,10);
	elseif Panding == 7 then
	local wenben = me:ParseNpcStory("[rand_lable=desc_time,desc_place,desc_weather]，一群逃难的灾民途经"..SchoolMgr.Name.."。")
	me:AddMsg(wenben);me:TriggerStory("Suiji05");
	elseif me:GetGLevel() < 7 and npc1.PropertyMgr:CheckFeature("BeautifulFace2") then
	me:AddMsg("一阵香风吹过，无数金粉铺面而来，于山门之中闲逛的[NAME]听见充满魅惑的声音向他说道：小美男，姐姐我修行千年从未见过你这般俊俏的男子。\n姐姐想与你双休一番，外加这五十万两也是你的，呵呵呵，如何呀小美男。\n[NAME]循声望去，只见那女子有着即使雍容华贵的绝美服饰也无法掩盖的臃肿身材，以及面纱都不能遮盖其扭曲的容貌，几乎令[NAME]从魅术中惊醒，但一股强大的威压似乎在催促[NAME]快点做出判断。");
	me:TriggerStory("Suiji13");
	else
	local wenben = me:ParseNpcStory("[rand_lable=desc_time,desc_place,desc_weather]，"..npc1.Name.."招待了"..mpName.."的弟子"..NanName.."，"..NanName.."与"..npc1.Name.."相谈甚欢，饭后双人一通闲聊后，"..NanName.."便告辞离去了。")
	me:AddMsg(wenben);me:AddMemery(wenben);me:AddSchoolRelation(menpai,5);
	end
end

function Hudong:shiqi999()
Panding = me:RandomInt(1,10);
npc1 = ThingMgr:FindThingByID(me.npcObj.ID)
npc3 = npc1.PropertyMgr.Practice.Master
zhangmen = ThingMgr:FindThingByID(CS.XiaWorld.SchoolMgr.Instance.MasterID)
NanName = NpcMgr:GetRandomFullName("Human",CS.XiaWorld.g_emNpcSex.Male)
menpai = world:RandomInt(1,13)
mpName = world:GetSchoolName(menpai)
sjnpc = World.map.Things:RandomNpc()
sjnpc2 = World.map.Things:RandomNpc()
print(sjnpc)
print(sjnpc2)
if npc3 ~= nil then
npc4 = npc3.PropertyMgr.Practice.Master
end
	if shiqidejiance == 1 then
	local wenben = me:ParseNpcStory("[rand_lable=desc_time,desc_place,desc_weather]，"..npc1.Name.."突然很想死，"..npc1.Name.."人没了。")
	me:AddMsg(wenben);me:AddMemery(wenben);
	me:ModifierProperty("MaxAge",-99999999);
	elseif zhangmen ~= nil and zhangmen ~= npc1 and world:GetWorldFlag(1714) == 4 then
	me:AddMsg(""..zhangmen.Name.."于门中修行，得弟子"..npc1.Name.."禀山下有一群江湖人士前来讨要说法。\n据对方所说近来天下出了一个大魔头四处抓捕江湖侠女以采补邪术祸害之，而其自称是我"..SchoolMgr.Name.."记名弟子，故众人前来讨要一个说法。")
	zhangmen.LuaHelper:TriggerStory("Suiji09");
	world:SetWorldFlag(1714,5)
	elseif Panding == 7 and zhangmen ~= nil and zhangmen == npc1 and zhangmen.PropertyMgr:CheckFeature("BeautifulFace2") and zhangmen.LuaHelper:GetGongName() ~= "Body_Gong_nvquan" then
	local wenben = me:ParseNpcStory("一支自称天元女拳宗女修组织，以听闻"..SchoolMgr.Name.."是由女掌门所掌管的宗门，故前来拜访，掌门"..zhangmen.Name.."自是扫榻相迎，却万万不曾想到，对方……竟然大热天全身冷汗、手脚冰凉，气得浑身发抖，就连眼泪都不争气的流了下来！\n并愤怒的咆哮道：“为什么"..SchoolMgr.Name.."掌门"..zhangmen.Name.."是个绝色女子？难道女子的价值就只在于外貌么，这是个该死的修真界到底怎么了，为什么到处都是对女修的压迫和物化！”后，向"..SchoolMgr.Name.."发起了冲锋……")
	me:AddMsg(wenben);world:SetWorldFlag(1712,world:GetWorldFlag(1712)+1);Hudong:diren002()
	elseif Panding == 7 and zhangmen ~= nil and zhangmen == npc1 and zhangmen.LuaHelper:GetGongName() == "Body_Gong_nvquan" then
	renshu = me:RandomInt(1,4);
	local wenben = me:ParseNpcStory("一支自称天元女拳宗女修组织，以听闻"..SchoolMgr.Name.."是由女掌门所掌管的宗门，掌门"..zhangmen.Name.."毅是个拳法家，故特来拜山共同商讨拳法……")
	me:AddMsg(wenben);;me:AddSchoolRelation(170,50);
	while renshu > 0 do
	local zhongzu = WorldLua:RandomInt(1,#zhongzubiaoge+1);
	local npc = CS.XiaWorld.NpcRandomMechine.RandomNpc("Human",g_emNpcSex.Female);
	npc:AddTitle("天元女拳宗弟子");
	npc.PropertyMgr:AddFeature("Tianyuannvquan");
	CS.XiaWorld.NpcMgr.Instance:AddNpc(npc,npc.LuaHelper:RandomInt(240,280),Map,CS.XiaWorld.Fight.g_emFightCamp.Friend);
	CS.XiaWorld.ThingMgr.Instance:EquptNpc(npc,npc.LuaHelper:RandomInt(1,10),CS.XiaWorld.g_emNpcRichLable.Richest);
	renshu = renshu - 1
	end
	elseif me:GetModifierStack("Zhenchaosuo") > 0 or me:GetModifierStack("Zhenchaozhou") > 0 then
	local wenben = me:ParseNpcStory("[rand_lable=desc_time,desc_place,desc_weather]，"..npc1.Name.."在[obj_action]时，因为勃发的性欲，"..npc1.Name.."想要揉一揉，可惜下身被贞操锁禁锢着。")
	me:AddMsg(wenben);me:AddMemery(wenben);
	elseif npc1.PropertyMgr:CheckFeature("Chastity") then
	local shuming = nvsishu[WorldLua:RandomInt(1,#nvsishu+1)]
	local wenben = me:ParseNpcStory("[rand_lable=desc_time,desc_place,desc_weather]，"..npc1.Name.."闲来无事，看了一会"..shuming.."并将自己的心得体会摘抄了下来……")
	me:AddMsg(wenben);me:AddMemery(wenben);
	item = CS.XiaWorld.ItemRandomMachine.RandomItem("Item_FunPoem");
	item.Rate = WorldLua:RandomInt(1,npc1.LuaHelper:GetGLevel() + 2)
	item:SetName("" .. npc1:GetName() .. "抄写的"..shuming.."");
	item:SetDesc("此书由" .. npc1:GetName() .. "读"..shuming.."有感后抄写并注解成文。");
	npc1.map:DropItem(item,npc1.Key,true,true,false,true,5);
	elseif npc1.GongKind == g_emGongKind.Body then--主角是体修，开启体修随机事件
	local Panding = world:RandomInt(1,4)
		if npc1.PropertyMgr:CheckFeature("Pogua") ~= true then
		local wenben = me:ParseNpcStory("[rand_lable=desc_time,desc_place,desc_weather]，"..npc1.Name.."于山门练武之时，一不小心动作太大，使自己的处女膜破裂了……")
		npc1.PropertyMgr:AddFeature("Pogua");me:AddMsg(wenben);me:AddMemery(wenben);npc1.PropertyMgr.Practice.BodyPracticeData:AddQuenchingItem("Item_Nvxiuluohong",1);
		elseif Panding == 1 and npc1.LuaHelper:GetModifierStack("Daiyun") ~= 1 then
		local wenben = me:ParseNpcStory("[rand_lable=desc_time,desc_place,desc_weather]，上届大能爽仙子寻上"..npc1.Name.."，要求"..npc1.Name.."替其代孕，原是爽仙子自己因为嗑仙界神药五千石散导致不孕不育，看中了"..npc1.Name.."的体质\n\n"..npc1.Name.."虽是不愿，可还是恐于爽仙子在天界那强大的势力和后台，只得献身成为了其代孕后代的苗床……")
		me:AddMsg(wenben);me:AddMemery(wenben);npc1.LuaHelper:AddModifier("Daiyun")
		elseif Panding == 1 then
		local wenben = me:ParseNpcStory("[rand_lable=desc_time,desc_place,desc_weather]，凡界武修潜入宗门欲窃取本宗修行秘法被"..npc1.Name.."擒获，"..npc1.Name.."本欲将其打杀当场，却见得对方体格健硕样貌也算的上俊朗，心中欲火渐起，便将对方擒回房内……\n对方被"..npc1.Name.."用下身肉穴活活榨死了……")
		me:AddMsg(wenben);me:AddMemery(wenben);npc1.LuaHelper:AddModifier("Luding");npc1.PropertyMgr.Practice.BodyPracticeData:AddQuenchingItem("Item_yangjin",1);npc1.Needs:AddNeedValue(CS.XiaWorld.g_emNeedType.Practice,200)
		elseif Panding == 2 then
		local wenben = me:ParseNpcStory("[rand_lable=desc_time,desc_place,desc_weather]，一群逃难的灾民途经"..SchoolMgr.Name.."。")
		me:AddMsg(wenben);me:TriggerStory("Suiji05");
		elseif npc1.Needs:GetNeedValue(CS.XiaWorld.g_emNeedType.Practice) < 100 and npc1.PropertyMgr.Practice.BodyPracticeData:GetQuenchingItemCount("Item_yangjin") > 0 then
		me:AddMsg(""..npc1.Name.."于门中修行，因精元匮乏导致几近走火入魔")
			if npc1.PropertyMgr:CheckFeature("Yingjingzhe") then
			me:AddMsg(""..npc1.Name.."二话不说从袖中掏出一份阳精便灌入口中……")
			npc1:AddMood("Yingjingzhe1")
			else
			me:AddMsg(""..npc1.Name.."纠结了半天后，掏出了一份阳精，捏着鼻子吞服了下去……")
			npc1:AddMood("Yingjingzhe2")
			end
			npc1.PropertyMgr.Practice.BodyPracticeData:AddQuenchingItem("Item_yangjin",-1)
			npc1.Needs:AddNeedValue(CS.XiaWorld.g_emNeedType.Practice,200)
		else--体修保底事件
		wenben = me:ParseNpcStory("[rand_lable=desc_time,desc_place,desc_weather]，"..npc1.Name.."在[obj_action]时，因为勃发的性欲，"..npc1.Name.."对着自己的小穴上下搓弄了百余下。\n事毕，"..npc1.Name.."将潮吹射出的阴精集中到一起，存放了起来以用于日后的修炼。")
		me:AddMsg(wenben);me:AddMemery(wenben);
			if ThingMgr:FindThingByID(npc1.ID).PropertyMgr.Practice.GodCount > 0 then
			npc1.PropertyMgr.Practice.BodyPracticeData:AddQuenchingItem("Item_yinjin",32);
			elseif npc1.LuaHelper:GetGLevel() > 9 then
			npc1.PropertyMgr.Practice.BodyPracticeData:AddQuenchingItem("Item_yinjin",16);
			elseif npc1.LuaHelper:GetGLevel() > 6 then
			npc1.PropertyMgr.Practice.BodyPracticeData:AddQuenchingItem("Item_yinjin",8);
			elseif npc1.LuaHelper:GetGLevel() > 3 then
			npc1.PropertyMgr.Practice.BodyPracticeData:AddQuenchingItem("Item_yinjin",4);
			elseif npc1.LuaHelper:GetGLevel() > 0 then
			npc1.PropertyMgr.Practice.BodyPracticeData:AddQuenchingItem("Item_yinjin",2);
			else
			npc1.PropertyMgr.Practice.BodyPracticeData:AddQuenchingItem("Item_yinjin",1);
			end
		end
	elseif zhangmen ~= nil and npc1 ~= sjnpc and sjnpc ~= zhangmen and zhangmen ~= npc1 and npc1.PropertyMgr:CheckFeature("Pogua") ~= true and sjnpc.PropertyMgr:CheckFeature("Pogua") ~= true and npc1.IsDisciple ~= true and sjnpc.IsDisciple ~= true and sjnpc.Race.RaceType == npc1.Race.RaceType and sjnpc.IsAlive and sjnpc.Camp == npc1.Camp and sjnpc.Sex == npc1.Sex and sjnpc.Sex == zhangmen.Sex then
		if zhangmen.LuaHelper:GetGLevel() > 9 then
		me:AddMsg("“为了宗门的收入，我可爱的女弟子们，对不住了…”"..zhangmen.Name.."看着手中的账簿，神色凝重，由于想要让门派弟子们住的舒服一些，这些日子来总是大修大建，不论是凡间银钱还是灵石灵晶，都已呈现出了赤字，一系列的天材地宝又不能卖，毕竟门派尚且孱弱，钱财外露可能会招来杀身之祸…");
		else
		me:AddMsg("“为了宗门的收入，我可爱的女弟子们，对不住了…”"..zhangmen.Name.."看着手中的账簿，神色凝重，由于想要让门派弟子们住的舒服一些，这些日子来总是大修大建，不论是凡间银钱还是灵石灵晶，都已呈现出了赤字，天材地宝又要留着用以渡劫，难啊…");
		end
		if zhangmen.PropertyMgr:CheckFeature("Pogua") and zhangmen.PropertyMgr:CheckFeature("Chinvguchong") then
		me:AddMsg("“最近修真界掀起了一股百合花的花香，这个系列应该会很受欢迎，再加上我自己再去卖一下，不就解决问题了吗？我真聪明！”"..zhangmen.Name.."思索了一下，觉得可行，脸上露出了计划通的笑容。");
		elseif zhangmen.PropertyMgr:CheckFeature("Pogua") ~= true then
		me:AddMsg("“最近修真界掀起了一股百合花的花香，这个系列应该会很受欢迎，可不要让我失望啊…”"..zhangmen.Name.."思索了一下，觉得可行，但脸上却露出了几许纠结的表情。");
		else
		me:AddMsg("“最近修真界掀起了一股百合花的花香，这个系列应该会很受欢迎，再加上我帮他们完成一些过分的要求之类的，比方足交口交什么的…”"..zhangmen.Name.."思索了一下，觉得可行。");
		end
		me:AddMsg("“就你们两个吧…”"..zhangmen.Name.."通过法宝看了一眼门派内的外门弟子，随机挑选了两个样貌不错的女弟子，随后施法吹出了一股暧昧的风，只见手背上荧光一闪，而后用如玉般的双手的拇指与中指在虚空之中一拈，牵出了属于"..npc1.Name.."和"..sjnpc.Name.."的红线，将其交织到了一起…\n……\n“今天的天气真不错，就是为什么总觉得哪里怪怪的…脸上有点热，还有就是心…为什么会觉得…有点痒…”"..npc1.Name.."在太阳下晒了个懒腰，但她也不知为何，今日在她的心头总是有着一种莫名的悸动，好似冥冥之中有着一调线，在牵引着她…\n与此同时，另一边，桃花树下，还有一位女子也是如此，面带羞红，好似有了心上人一般，这种感觉是她从出生以来从未拥有过得，心中似有脱兔在无序的蹦蹦跳跳…\n“我这是…怎么了，为什么…我的心…”"..sjnpc.Name.."看了一眼天空，眼神有点迷茫，她也不知为何，她将手掌放在自己的胸前，感受着那渐快的心跳，感受着那种自己的心中从未有过的莫名的悸动…\n这种感觉，虽似令人难受，但却又是如此美好，甜甜的，如同蜜糖，两人都在此刻，期盼着得到自己想要的答案，或许结果并不美好，但唯美的过程，便是她们此行的不虚…\n随着心中的悸动与两人命运交织之红线的迁移，才不到一个时辰，两人居然无比默契的在同一时间，来到了一颗桃花树下，她们的眼睛看着彼此的不可思议的眼神，都将双手默默叠到胸前，轻轻吸了一口凉气，左脚共同后退了一步…\n时间，空间，行为，在红线这根凡人不可触及的线的牵扯下，居然使得她们尽然做到完美的同步，微微睁大的眼睛，都透露着惊讶，在未见之前，以为自己或许是被月老与自己的如意郎君签上了红线，此生甜蜜，但见面后…\n“为什么，让我心动之人，为何竟是女子…”两人心中的想法再次同步，女子与女子，好比男子之龙阳断袖，为世俗所不容，明明自己的小拇指还在，为何…竟会牵上此等孽缘…\n传说之中，月老很少为人牵线，而被牵线之人或许此生没有所谓的大富大贵，但却拥一生之喜乐安康，此生注定幸福美满，甚至为仙神所羡，为鬼魅所妒，但，即便如此，却也有因错指牵线而导致错过姻缘甚至化作孽缘的故事…\n古有一城，义城，内有一子，因判官笔误而生，在早年被马车碾断了小指，后修鬼道，灭其满门，因而臭名昭著人人得以诛之，但奈何其修为高强，天下少有人可奈何，终有一日，招来一名正道青年大修，似星辰，不染尘，其旁跟着还跟着一位青年，虽也是颇有修为，却只如同绿叶…\n不知为何，判官笔误所生之他，在其青年大修到来之际，居然又引得月老错线，没有小拇指的他被牵上了红线，象征着孽缘的无名之指，由此，判官笔误，月老错线，终揭孽缘序幕…\n青年大修与其少年，在其数年间，纷纷魂飞魄散，不得善终…\n这个故事她们从小便有所闻言，因此她们都将自己小指保护的非常之好，如今小指依旧，可为何月老…错线了…");
		if zhangmen.PropertyMgr:CheckFeature("Pogua") and zhangmen.PropertyMgr:CheckFeature("Chinvguchong") then
		me:AddMsg("“这样下去可不行吧…”在一旁观测着的"..zhangmen.Name.."，笑了一笑，然后将红线再次打了个结…");
		elseif zhangmen.PropertyMgr:CheckFeature("Pogua") ~= true then
		me:AddMsg("“这样下去…哎，为了宗门吧，以后多给点补偿吧”在一旁观测着的"..zhangmen.Name.."，叹了一口气，然后将红线再次打了个结…");
		else
		me:AddMsg("“这样下去…我这样到底对不对…”看着相互对视且觉得不可思议的两人，掌门的内心感到了无比的纠结，但是为了宗门，还最终还是选择了再一次将"..npc1.Name.."和"..sjnpc.Name.."的红线打了一个结…");
		end
		me:AddMsg("随后，只见"..zhangmen.Name.."将两根红线朝着中间的结轻轻一拉…\n“嗯…！”\n只见"..sjnpc.Name.."因为突如其来的重心不稳，朝着"..npc1.Name.."的方向跌去，而这一刻"..npc1.Name.."出于本能想要扶住"..sjnpc.Name.."倾倒的身子，但结果却是"..sjnpc.Name.."虽然被扶住，但两人的双唇却也因此碰撞在了一起，或许是因为红线的牵引，两人竟然同时将自己的舌头吐了出来，想要舔一下对方的嘴唇…\n“嗯—”两人的舌头在此时缠绕在了一起，最终抱在了一起接吻了起来，她们相互吸吮着对方口中的唾液，都觉得甜甜的，也不知是真的甜如淡蜜，还是说心有所感，禁忌的花朵在此刻慢慢绽放，红线的交织让她们最终以世俗不容之姿慢慢的堕入名为爱情的大河…\n这种感觉很奇妙，难以言喻，羞愧？心动？但此刻也都不重要了，她们此刻只想亲吻着彼此，享受这她们一生中最美好的时刻，或许结局并不会完美，甚至如同故事里一般落得个魂飞魄散，但那又如何呢？\n她们，此刻只想拥抱着当下的片刻温存，可以的话她们真的很想此生就住在对方的心中，从此不再过问红尘的繁喧，穿着素衣，有说有笑，直到青丝白发…\n“这里，不好吧…”虽然两人还想更进一步，但这里毕竟是野外，被人瞧见了可真就成了彻彻底底的的悲剧，到时骂名也就随之而来…\n“嗯…”\n随后，在心绪飘飞之际，两人来到了"..npc1.Name.."的房间里，外面的天气阴了下来，下去了绵绵细雨，"..npc1.Name.."找来了火石，点燃了放在角落的油灯，油灯微黄的光芒落在两人嫣红的脸颊上，两人的动作有些扭捏，谁都不好意思先提那为世人不容的请求…\n“伊…！”突然，"..sjnpc.Name.."呻吟了出来，不是因为其他，真是因为她蜜穴中的跳蛋的震动程度突然从原本的关闭被开到了最大程度，这猝不及防的刺激，让"..sjnpc.Name.."直接高潮了并呻吟了出来…\n“你怎么了？哪里不舒服嘛…”"..npc1.Name.."看着突然呻吟了一声的"..sjnpc.Name.."，关切的问道，她从未对一个人如此的上心…\n“那个…”"..sjnpc.Name.."羞红了脸，这种事情，怎么好意思说吗！？\n“哦…我懂了…”"..npc1.Name.."虽然自己没用过，但她自己还是知道的，现在"..sjnpc.Name.."这个情况就是典型的高潮了，绝对是下面塞了什么东西，"..npc1.Name.."慢慢的移动着身子，最终"..npc1.Name.."的脸在"..sjnpc.Name.."紧闭的双腿前停了下来…\n“放松一点吗…乖乖的把腿打开…”"..npc1.Name.."看着"..sjnpc.Name.."死死闭着的双腿，柔声细语道…");
		if zhangmen.PropertyMgr:CheckFeature("Pogua") and zhangmen.PropertyMgr:CheckFeature("Chinvguchong") then
		me:AddMsg("“这才对嘛。”将这一切看在眼里的"..zhangmen.Name.."喃喃自语道…");
		elseif zhangmen.PropertyMgr:CheckFeature("Pogua") ~= true then
		me:AddMsg("“对不起…真的对不起了…”将这一切看在眼里的"..zhangmen.Name.."心中满怀愧疚，毕竟这一切都是她搞得鬼，若无她，她们两个本该陌路，此生相疏，各自两不误…");
		else
		me:AddMsg("“虽然很对不起，但为了宗门…”"..zhangmen.Name.."虽然很是愧疚");
		end
		me:AddMsg("“嗯…”"..sjnpc.Name.."应了一声，声音真的很小，说是小过蚊虫都不为错，但她还是满满的放松着自己，将自己的双腿满满的打了开来，她知道，自己这一打开，将来就再也不可能在"..npc1.Name.."面前合上了，但…她不后悔…\n"..npc1.Name.."看着"..sjnpc.Name.."渐渐分开的双腿，笑了笑，然后轻轻的把"..sjnpc.Name.."穿着的裤子脱了下来，脱下来的时候她还当着"..sjnpc.Name.."的面将因为"..sjnpc.Name.."高潮而湿掉的地方舔了一下，顺带还评论了一句：“味道不错呢，你也来尝一下吧，尝尝自己的味道吧…”\n"..sjnpc.Name.."本就嫣红的脸此时更是如同火烧一般，因为实在是太羞耻了，这种事情，但"..npc1.Name.."将裤子拿到"..sjnpc.Name.."面前的时候，"..sjnpc.Name.."还是舔了一下，腥腥的，咸咸的，这就是她自己的味道吗？\n“味道还可以吧…”"..npc1.Name.."看着"..sjnpc.Name.."，戏谑的调戏道，她已经开始开始渐渐喜欢上这种话感觉了，这种调教的感觉，也许，不是月老错线，而是自己生错了男女吧…\n“嗯…”"..sjnpc.Name.."只能弱弱的应一声，事到如今，她已无话可说，不晓何语可对…\n"..npc1.Name.."当然也没有浪费要多时间，直接将自己的头部放到了"..sjnpc.Name.."的蜜穴处，内裤扒开，露出的是粉嫩未被开发的蜜穴，不论形状颜色还是其他，都可谓是上上之选，极品之姿，若是让合欢门人看到，不知会疯狂到何等地步…\n"..npc1.Name.."的舌头在"..sjnpc.Name.."的蜜穴里不断地舔舐着，鼻子呼出的气息化作清风拂过"..sjnpc.Name.."敏感的阴蒂，原本就因为一次高潮而被彻底湿润的蜜穴，此刻更是再度流出了不少的淫水，弄得"..npc1.Name.."满脸都是…\n“小妖精，都那么湿了啊…”"..npc1.Name.."向上抬头一笑，调戏了一波"..sjnpc.Name.."，然后便接着闷头苦干了起来…\n此情此景，"..sjnpc.Name.."早已羞得无法言语，因此只能默默地接受者来自"..npc1.Name.."的“恩泽与滋润”，约莫过了小半个时辰，"..sjnpc.Name.."迎来了第二次的高潮，直接下面喷出了大量的淫水，"..npc1.Name.."错不急防间尽然下肚了好几大口，最终她还将一口含在了嘴里，含的有多少，反正她的嘴巴已经彻底鼓起来了…\n她直接站了起来，然后一口强吻住了"..sjnpc.Name.."，香舌撬开唇瓣，直接将一大口混着唾液的淫水送到了她的嘴里，好好的让她尝了一下自己的味道…\n“可不要吐出来哦，细细的品尝一番后，在慢慢的咽下去…”"..npc1.Name.."笑着指挥道，语气温柔但对"..sjnpc.Name.."来说却显的是如此的不可抗拒，最终也只能照其说的做…\n不过百息，"..sjnpc.Name.."口中的淫水已经尽数下了肚，"..npc1.Name.."对此很是满意，随后便将"..sjnpc.Name.."的衣服和内裤全都脱了下来，就这样，她的无暇的玉体就这样呈现在了"..npc1.Name.."面前，霎时之间，"..npc1.Name.."只觉得自己的鼻腔有些刺痒，这种感觉，便是火气上涌的最好表现，这火气…自然是欲火咯…\n“如花似玉，秀色可餐…古人诚不欺我也…”"..npc1.Name.."看着"..sjnpc.Name.."的玉体一时之间看痴了，而后她又将自己的衣服脱了下来，笑道：“只有我让你舒服那也太不公平了，接下来，你就照着我的模样来做，做的不好可是会被惩罚的哦…”\n“嗯…”\n"..npc1.Name.."来到床上，坐在"..sjnpc.Name.."的对面，随后拿起了"..sjnpc.Name.."的一只玉足，并且将自己的玉足抬到了"..sjnpc.Name.."的面前，随后，她温柔的抚摸了"..sjnpc.Name.."几下玉足，便舔舐了起来，弄得"..sjnpc.Name.."脚痒痒的，这痒，也在同一时间，传递到了心理…"..sjnpc.Name.."自然记得"..npc1.Name.."说过的话，有样学样，也开始舔舐了起来…\n两人相互舔舐吸吮着对方的玉足，玉足上并没有过重的气味，反而有一些淡淡的清香，这就是所谓的女子体香，在舔舐了一段时间后，两人的下面痒的实在受不了了，无法之下，都选择了抽出一只手，进行自慰…\n一炷香后…\n“我要去了…”\n“我也是…”\n“那么…一起去吧…”\n“好的…”\n“咿呀…！”\n“嗯…嗯…嗯…咿…！”\n两人高潮过后，在床上瘫了一小会儿，恢复了一些体力后，又开始了前面还未做完的事情，这一次，居然不是先前主动地"..npc1.Name.."提出的，反而是那个害羞腼腆的"..sjnpc.Name.."提出了那个大胆的玩法…\n“我们…我们…我们把各自的脚放进对方的小穴来采掘吧，谁先高潮…就算谁输了，输的人…输的人…输的人必须成为赢的人的女奴RBQ怎么样？”"..sjnpc.Name.."羞红着脸，她真的不知道自己为何会提出如此变态的请求，但她又真的很想那么来一次…\n“好…”"..npc1.Name.."虽然诧异，但却欣然接受了，她可不觉得自己会输给这个一直被她牵着鼻子走的"..sjnpc.Name.."会在这一局里面反攻她，所以在她的自我感觉里，自己已经赢了…\n“小女奴，让你看看主人的厉害吧，论这方面，你绝对不可能胜得过主人的！哈哈哈哈！”"..npc1.Name.."得意地笑着，率先将自己的玉足放到了"..sjnpc.Name.."的蜜穴中，率先发难…\n“结果都还没出来呢！怎么就那么确定！我不会输得！哼！”"..sjnpc.Name.."虽然知道自己赢得希望渺茫，但也不是没有机会，所以很有必要全力以赴！\n一刻钟后…\n“快…快认输…高…高潮吧，你…你…你是…是不可能…赢…赢的了我的，就在…在你提出…提出这…这个比…比赛的时候，你…你就…注定会输…输给我…成…成为我…我的女奴…RBQ的！”"..npc1.Name.."笑着，断断续续的说着，但事实上她已经快到自己的极限了，她没有想过，自己的身体居然会如此的敏感…\n“我不！”"..sjnpc.Name.."很坚决，她要奋战到最后一刻，不到最后绝不倒下！这是她的倔强，她也不想以后的每一次，都被她压在下面！能争取，就绝不退缩！\n两个人的玉足都在彼此的蜜穴中疯狂的抽插着，蜜穴中的软肉让她们的玉足感受到了柔软和温暖，这里是无数男子都曾向往的温柔乡，但在此刻却被她们自产自销了，为了获得最后的胜利，蜜穴旁边早已因为破处流出的处子之血而被染红，床单早已湿成了一片，好似被水淋了个通透…\n小半刻终后…\n“你……厉害…我，输了…咿~呀！！！！”"..npc1.Name.."看着大口喘气但是还是强忍着的"..sjnpc.Name.."，知道自己已经输了，估计这辈子都要成为"..sjnpc.Name.."的女奴RBQ了，但她不介意，大不了从上面变成下面的…好吧，也只能这样安慰一下自己了…\n呻吟期间"..npc1.Name.."的淫水混合着阴精不要钱似的疯狂向外涌，喷的"..sjnpc.Name.."满身都是，而"..sjnpc.Name.."也终于得以解放，不用再继续忍耐下去，随后一声呻吟，"..sjnpc.Name.."也直接泄了洪，同样，把"..npc1.Name.."喷的满身都是…\n最终，原本一直被"..npc1.Name.."牵着鼻子走的"..sjnpc.Name.."居然忍到了最后，成功夺得了胜利，两人做起来相视一笑，最后在亲吻了一次，便相拥着睡去了…\n在她们睡去的同时，一道光芒分别在"..npc1.Name.."和"..sjnpc.Name.."的小腹和左手背上闪过，最终刻画出了两个印，"..sjnpc.Name.."的主印和"..npc1.Name.."的奴印…");
		if zhangmen.PropertyMgr:CheckFeature("Pogua") and zhangmen.PropertyMgr:CheckFeature("Chinvguchong") then
		me:AddMsg("“好样的，超清无漏全都录下来了…去卖掉然后自己在出卖一下身子，估计会有不少的钱…嘿嘿。”"..zhangmen.Name.."看着手中的录像，感到心满意足，十分的开心，宗门的支出终于有了…");
		me:DropAwardItem("Item_LingStone",world:RandomInt(6000,8000));
		elseif zhangmen.PropertyMgr:CheckFeature("Pogua") ~= true then
		me:AddMsg("“算了，果然我还是狠不下心…算了，这处子…也只能…哎。”"..zhangmen.Name.."直接毁掉了手中的录像，她已经做好了打算，一个掌门的处子，应该还算值钱吧…");
		me:DropAwardItem("Item_LingStone",world:RandomInt(2000,4000));zhangmen.PropertyMgr:AddFeature("Pogua");me:DropAwardItem("Item_Nvxiuluohong",1);
		else
		me:AddMsg("“很抱歉，但为了宗门，至少脸上打个码吧…”"..zhangmen.Name.."虽然很愧疚，但是为了宗门，只能这样做了…");
		me:DropAwardItem("Item_LingStone",world:RandomInt(4000,6000));
		end
		sjnpc.PropertyMgr.Practice: AddZhuJi(25000);npc1.PropertyMgr.Practice: AddZhuJi(25000);npc1.PropertyMgr:AddFeature("Baihehuakai");sjnpc.PropertyMgr:AddFeature("Baihehuakai");npc1.PropertyMgr:AddFeature("Pogua");sjnpc.PropertyMgr:AddFeature("Pogua");
	elseif me:CheckFeature("Pogua") ~= true and npc1.LuaHelper:GetGLevel() < 1 and sjnpc.LuaHelper:GetGLevel() < 1 and zhangmen ~= nil and zhangmen.Sex ~= npc1.Sex and sjnpc.Camp == npc1.Camp and sjnpc.Sex == npc1.Sex and sjnpc.Race.RaceType == npc1.Race.RaceType and sjnpc.IsAlive then
	local wenben = me:ParseNpcStory("今天，门派中吹拂过了一阵暧昧的风，不知是不是因为这股风的影响还是因为其他，"..sjnpc.Name.."看着[NAME]，心中顿时升起了一股异样的感觉，明明同为女人，明明这是被世俗所唾弃的一种恶念，但…\n“尔等既然来了我派，那么自然也不再是凡夫俗子，切记，修真之路需求念头通达，最好勿要有半点执念伴生，修出法力虽是至关重要，但在此期间，转变自己的心态，却也是十分重要的一件事…”"..sjnpc.Name.."回想起前些日子前辈所讲的心得，顿时心中打定了主意…\n“念头通达，勿要有半点执念伴身…”"..sjnpc.Name.."喃喃自语了一遍，然后望着[NAME]的眼神变得坚定，今日，不管是用什么法子，都必须得到她，哪怕被世人万世唾骂也在所不惜！只为自身前路道心通明，念头通达…\n“怎么？你有什么心事吗？”突然，一道声音在"..sjnpc.Name.."耳边想起，那不正是门派的掌门吗？这些时日掌门修为达到了一个瓶颈期，所以便四处走走调理着自己的心绪…\n“掌…掌…掌门，那…那个…我……”"..sjnpc.Name.."看着掌门，说起话来结结巴巴吧的，好像一个做错了事情的小孩子一般，生怕被掌门发现责罚……\n“好了，不用说了，你那点小心思我还能不知道，拿着…”只见掌门微微一笑，抛给了"..sjnpc.Name.."一个方盒和一个透明的瓶子，又道：“方盒可以制造一个法阵，可以做到遮掩和隔音的做用，至于瓶子则是用于收集纯阴落红的，只要她见红了，就立刻把瓶子放到她的蜜穴里面，它会自动收集处子的纯阴落红…”\n“谢谢…掌…”"..sjnpc.Name.."刚刚欲要感谢掌门，但却被掌门用一根手指点住了嘴，示意她不必再说下去了，然后又见掌门将头朝着[NAME]所在的方向晃了晃，到此为止，"..sjnpc.Name.."已经明白了掌门的意思，就点了点头，露出了感激的眼神，朝着[NAME]所在的方向不紧不慢的走了过去…\n（表情动作一定要自然，不要让对方发现端倪）\n"..sjnpc.Name.."心想，毕竟这种事情只能一步到位，不然一旦失败，那么将来必定被警觉，到时候再想成功，可就困难重重了…\n"..sjnpc.Name.."看着[NAME]，虽然心中早已波涛汹涌，但她的表面必须装作若无其事一般，深吸了一口气，来到[NAME]的身边…\n“[NAME]，我发现有在门派的后山处，有一个峭壁哪里长了三颗紫芝，但是我一个人下不去，所以想请你帮个忙，到时候你就用绳子拉着我，我下去采…事成后，紫芝我门二一分配怎么样？”"..sjnpc.Name.."对着[NAME]用尽可能真挚的语气蛊惑到…\n（记得内门的师兄说过一颗紫芝下肚可以直接促进我们三成还要多点的筑基进度，这一趟值得一去，不过得做点防备…）\n[NAME]思索了一阵子后，回家拿了一柄小刀，如果"..sjnpc.Name.."只是如此便就此作罢，如果她另有企图就直接割喉，这个世界，害人之心不可有，但防人之心…亦不可无！\n走了小半个时辰，"..sjnpc.Name.."带着[NAME]来到了一处极为偏僻的峭壁，峭壁下面真的有三颗紫芝，这是曾今"..sjnpc.Name.."到处乱逛找到的，目前都还未被发现，为的就是将来筑基成功，服用以进一步提升自身的法力容量，但为了她，下这个血本，值了！\n“看吧，还真有，是不是…”"..sjnpc.Name.."对着趴在地上向下看着的[NAME]如是说道，殊不知刚才[NAME]已经握紧了藏着的匕首，只要她敢有意思异动，就暴起将其击杀！\n“嗯，你说的是真的，分配我没意见，那就开始行动吧…”[NAME]站起了拍着自己身上的泥土，言道…\n说时迟那时快，趁着[NAME]拍泥土的空隙，"..sjnpc.Name.."立刻用绳子将[NAME]的手和身子绑在了一起，"..sjnpc.Name.."用的绳子可不是一般的绳子，这绳子可是有着削减气力的作用的，真是如此，任凭[NAME]如何挣扎，都不过是徒劳无功的反抗罢了，事到如今，"..sjnpc.Name.."拿出了掌门给他的方盒，只见方盒在拿出的一瞬间便飘向了半空，而后光芒一闪，形成了一个半径十米左右的太极图影像，照在大地上，这个，便是阵法的作用范围，只要不出去，便不会被发现…\n“诸位，好戏开始了哦…”另一边，掌门开启了修真直播，而这个直播间里全是各大门派的高层，这是他们私下的交流与“交流”之地…\n“哈哈！还是你有一手，合欢宗那些门路我们早就看腻了，要不是合欢宗早就被别人占去了，我都以为你们才是合欢宗了。”一旁的尹志平淫荡的笑着。\n“等下跟请这位掌门我们走一趟，我们合欢宗有意好好‘请教’一下…”和合欢宗的二长老黑着一张脸，这几个季度因为他们在H行业靠着“新意有趣的玩法”住久了崛起，合欢宗的收入直线下降，所以嘛，他们真的很想请教一下，两方面的请教……\n“贱人！放开我！你到底想怎样！我不曾害你为何如今却这样对待于我！”[NAME]的身子使劲挣扎着，当然，嘴巴也没有停下来，为了以防万一，"..sjnpc.Name.."特地进行了一次搜身，为的就是以防万一！\n“呦，居然还有刀子！看来你是打算谋财害命啊！幸好我足够机警，不然到时候可真就阴沟里翻船了！”"..sjnpc.Name.."看着手中的刀子，眼中露出了戏谑的表情，她当然知道这把刀子是[NAME]用来防身的，但…既然有了这样的证据，为什么不好好利用呢！？\n“这…！这是我用来防身的！”[NAME]顿时急了，这刀子被搜出来，就好比黄泥掉裤裆，不是屎，也只屎。\n“你觉得我会信吗！要不是总觉得哪里不对！可能我就死在你手上了！我那么信任你！而你却这样对待我！你觉得你对得起我的信任吗！”"..sjnpc.Name.."红着脸，眼中满布血丝怒吼着，红着脸，眼中的血丝是因为浴火上涌，至于怒吼，自然是装出来的，好为自己找一个道貌岸然的理由…\n“你…”[NAME]刚要说什么，就被"..sjnpc.Name.."打断了…\n“不用说了，不过既然你有害我之心，那么…就准备好接受来自我的报复吧！”"..sjnpc.Name.."邪笑着，然后用刀子一点一点，慢慢的割破了[NAME]的衣物，将其胸前的衣物和肚兜，下面的内裤和裤子都割出了一个大洞，无法遮掩的大洞！\n不得不说[NAME]的身材是真的好，不愧是她看上的人，洁白的玉体上最私密的两个部位都毫无遮掩的暴露在了"..sjnpc.Name.."的眼前，"..sjnpc.Name.."眼睛都看直了，如凝脂般的酥胸上有着两颗樱粉的乳头点缀着，看的"..sjnpc.Name.."想要再一次回归到婴儿的姿态，下面的蜜穴没有一根毛发，这是"..sjnpc.Name.."所未能想到的，天生的白虎体质，一种非常稀有的体质，虽然对修炼没啥用就是了…\n“下面很粉嫩啊，我还以为你的下面和你的乳头会和黑的和你的心一样呢…真是一副好皮囊啊！”"..sjnpc.Name.."笑着说道，嘴中吐出的言语如同鞭子一般抽打在[NAME]的心上，她是一个很重名节的人，这种污蔑让她的心感到刺痛，她突然后悔自己为什么要带一把刀子在身上，没有这把刀子，或许就没有这种事…\n“我没有！别胡说…我真的没哟！”[NAME]不断地嘶吼着，辩驳着，她怕自己的名声就败在了这里，所以辩解，嘶吼，即便没有任何作用…\n“真的没有吗！？”"..sjnpc.Name.."冷笑着，心道（真是个可爱的傻白甜呢，根本没有注意到阵法和绳子的异样，不过嘛…这样也好！）\n“不管有没有！反正我只相信我自己看到的！今天就让我来好好调教一下以这个贱人吧！”\n“不…不…不要啊！”[NAME]不断地叫着，挣扎着，甚至此时语气中都多了一些可怜和祈求，但"..sjnpc.Name.."并未理会，好不容易都到了这一步了，怎么能轻言放弃呢！？\n虽然身体不能回到婴儿，但是行为还是可以的，"..sjnpc.Name.."轻轻咬着[NAME]的樱粉乳头，用牙齿轻轻的摩擦，用舌头温柔的舔舐着，而这种行为也对[NAME]产生了一种莫名的刺激，是她从未体验过得感觉，这种感觉通常被称之为…快感。\n上面都照顾了，下面自然也不能放过啊，为了显得自己苦大仇深，"..sjnpc.Name.."原本将只放两只手指的方法换成了直接放进去三只，对了，现在宗主给的瓶子已经在[NAME]的蜜穴旁边就绪了，虽然绳子把[NAME]的力气给吸走了大部分，但[NAME]挣扎的力气还与有一些，一想到自己可能要被"..sjnpc.Name.."可能要将自己的处子破掉，就疯狂的扭起了腰…\n“啊！”"..sjnpc.Name.."看着疯狂挣扎的[NAME]，有些不耐烦，狠狠地在[NAME]的乳头上咬了一下，甚至皮都被咬破了一些，流出了一点点的血液，血液的腥味在"..sjnpc.Name.."的口中化开，尝着那股子血腥味，"..sjnpc.Name.."更加的疯狂，而[NAME]在疼痛中发出了似叫似呻吟的声音，且这一次过后也宛如泄了气的皮球一般，再无力气挣扎，只能任其"..sjnpc.Name.."摆布…\n“这就对了嘛…”看着宛如然如尸体一般的[NAME],"..sjnpc.Name.."站了起来说了一句，然后直接用三只玉指粗暴的捅进了[NAME]的蜜穴…\n“咿！！！”[NAME]痛苦的呻吟着，呻吟过后，[NAME]的眼神涣散了一些，嘴角喃喃的念叨着放过我，放过我，求求你了，诸如此类求饶的话，但是吧…"..sjnpc.Name.."根本不管！\n由于前戏的不足，导致[NAME]并未分泌出爱液来润滑蜜穴，所以显得有些干燥难以进入，因此一次未果，但没关系，一次不够，那就两次不是吗！？\n最终，在[NAME]经过了四次呻吟后，"..sjnpc.Name.."将手指抽出来时，见到了红，"..sjnpc.Name.."眼疾手快，立刻将早已准备好的透明琉璃瓶放进了[NAME]的蜜穴中！\n和"..sjnpc.Name.."的手指不同，瓶子的瓶口和瓶颈异常的冰冷，就好似将一块寒冰放进了蜜穴，那种冰冷的感觉，很难受，但不知为何，此刻却让[NAME]产生了一种别样的快感，下面的蜜穴居然开始分泌出了爱液润滑，而且量还很大…\n还好瓶子自带过滤，不然这一份纯阴落红的质量就要因为被爱液稀释下降一个等级了…\n“够骚啊，本以为你是一个十分保守的人，没想到下面居然流出了如此之多的爱液！简直绝了，果然知人知面不知心，果然是天生的荡妇啊！”"..sjnpc.Name.."看着[NAME]从蜜穴里流出的爱液的量，一时之间也震惊了，比她自己自慰的时候多了不知道多少！\n不一会儿，纯阴落红便被收集完了，"..sjnpc.Name.."将瓶子从[NAME]的蜜穴里拿了出来，盖上盖子，继续那还没有结束的工作…\n[NAME]此时再也没有力气反抗了，真真正正的彻底没力气了，因此"..sjnpc.Name.."给[NAME]松了绑，当然，这不是说突然地发了善心，而是为给[NAME]重新绑一下，弄出一个无比羞耻的姿势，这种绑法在异界好像被称之为…称之为啥来着…哦，对，龟甲缚！\n“求求你，放过我吧…”[NAME]哀求着，但"..sjnpc.Name.."没有理会，逼近现在还不是时候，她已经改变主意了，她要把[NAME]彻底变成自己的奴隶！让她彻彻底底沦为自己的RBQ！\n"..sjnpc.Name.."的嘴巴和左手就对着[NAME]的胸部不断地挑弄着，左手或柔或捏或拧或拉或压，嘴巴或牙咬或磨或舔或吸，而右手的两根手指则在[NAME]的蜜穴里不断地抽插着，本来是想三根的，但是[NAME]的蜜穴实在是太紧了，三根抽插起来太慢，渐渐地，[NAME]的呻吟中少了些许痛苦，多了几分意乱情迷…\n“啊…啊！咿呀…！不要啊！快停下…”\n“哦？阴蒂已经勃起了吗？”感受着手掌上突然多出的凸起感，同为女人的她自然知道这是[NAME]的阴蒂勃起了，当即，"..sjnpc.Name.."的左手和嘴巴撤出了胸部重地，全员集结来到了[NAME]的蜜穴前面…\n“真是漂亮呢…”看着因为爱液而变得晶莹粉嫩的蜜穴，"..sjnpc.Name.."忍不住夸赞道，但是这夸赞却让[NAME]感觉到格外的羞耻！\n“变…变态！”[NAME]哭腔着骂道\n“哼哼…”"..sjnpc.Name.."并不在意[NAME]的唾骂，她直接用行动让[NAME]再也骂不出来，和当时玩弄乳头一样，她现在正在用嘴巴玩弄着[NAME]的阴蒂，阴蒂是女人全身上下最敏感的地方之一，这里一旦被玩弄，给予的快感将是乳头的数倍，吸、咬、磨、压、舔，凡是可以展示的口技全被"..sjnpc.Name.."在[NAME]的阴蒂上展现的淋漓尽致，这种感觉让[NAME]好似在至上仙界，又好似堕入森罗地狱，欲罢不能…\n从原本的激烈反抗，到后来的无能为力，再到现在的慢慢接受，这都是一个过程…\n"..sjnpc.Name.."手指在[NAME]的蜜穴中高速抽插，口舌不断地挑逗着她的阴蒂，慢慢的，[NAME]已经无比的接近高潮了，但是"..sjnpc.Name.."却因为视线问题浑然不知…\n“宠幸了那么久的小豆子，花瓣的里面居然还没被滋润过，有些失算了，不过现在来也不算迟就是了，嘿嘿…”"..sjnpc.Name.."淫笑着，将自己的嘴巴直接对准了[NAME]的蜜穴…\n“咿呀啊~！”就在"..sjnpc.Name.."刚舔了没几下的时候，[NAME]就突然高潮了，尿液混合着阴精，直接喷了"..sjnpc.Name.."满嘴，"..sjnpc.Name.."也措不及放的喝下去了三四口，味道很冲，但是"..sjnpc.Name.."并不介意，反而舔了舔嘴唇微笑的说道：“真是不乖啊，没有得到允许，居然就擅自高潮了，看来需要惩罚啊！”\n"..sjnpc.Name.."拿起刀子，直接将[NAME]的裤子割成了只能遮住三分之一个屁股的“小裙子”，还把内裤给卸掉了，就这样，[NAME]的小穴以一个极度淫荡的姿态露了出来！而她的上衣自然也没有被"..sjnpc.Name.."放过，直接变成了只能勉强盖住过胸部的超短露脐装，当然，乳头的部分可是被剪了割大洞的，所以嘛，懂的都懂…\n“现在调教继续…”"..sjnpc.Name.."的声音不大，但对[NAME]来说却好比是地狱的颤音，森冷无比…\n“求求你饶了我吧…我再也不敢了…我愿意为你做任何事情…”[NAME]眼神溃散，有气无力的求饶着…\n“真的吗？”"..sjnpc.Name.."反问道，她知道，时机到了…\n“真的真的！我愿意做一切事情！”[NAME]好似抓住了救命稻草一般，疯狂的点着头…\n“做我奴隶也可以咯？”"..sjnpc.Name.."顺势说出了自己的目的。\n“我愿意，我…！”[NAME]突然意识到不对，但这时候却已经晚了…\n“这可是你说的！”"..sjnpc.Name.."笑了，笑得很开心，唯一可惜的是这只是一个口头承认，要是出去了她不认账那就麻烦了，所以还必须好好调教一番…\n就在"..sjnpc.Name.."准备继续的时候，原先掌门给她的方盒突然射出了两道细光，一道在"..sjnpc.Name.."的手背上刻下了一个天蓝色的印记，一个在[NAME]的蜜穴上方的小腹处刻下了一个紫红的印记，印记的样式有点像淫纹，天蓝色的是主印，紫红的是奴印！没错，此时，[NAME]正式成为了"..sjnpc.Name.."的女奴，成为了她的RBQ！\n“谢谢宗主…”"..sjnpc.Name.."行了一个跪拜之力，发自内心的感谢道…\n“呵呵…”[NAME]知道，这个印记下达的时候，她就再无回天之力，只能无奈的接受宿命，只希望将来的"..sjnpc.Name.."还能多点良知吧…\n“我们继续吧…”"..sjnpc.Name.."邪笑着…\n过了整整一天一夜，完全放弃了[NAME]成功的被彻底调教了…\n“好了，该回去了…”"..sjnpc.Name.."松开了绑着[NAME]的绳子，温柔的抚摸了一下她的脸庞，又言：“记得，衣服不准换，走路时候大腿内侧至少分开三十度，胸部不准遮掩，要将自己的私密全部展现出来哦…”\n“是…主人…”[NAME]无奈的接受了命令，她已经看到了，自己的前途有多么黑暗…\n—直播间内—\n尹志平：“精彩，真的精彩!身为掌门的你还真是个人才！”\n合欢宗大长老：“还请贵派掌门赐教，我等愿献上邪脉血泉三枚换取…”\n极天宫三长老：“得了吧，三个邪脉血泉换这种长久生意，哪有那么好的事情…”\n掌门：“各位，我也不知该如何指教，但小女子下面，却很希望各位指教一下，不如三日后我们在…”\n正一道：“好！很好……哈哈哈，那么你个小娘们到时候就看我等的厉害吧！”\n……")
	me:AddMsg(wenben);npc1.PropertyMgr:AddFeature("Pogua");me:DropAwardItem("Item_Nvxiuluohong",1);sjnpc.PropertyMgr.Practice: AddZhuJi(25000);me:DropAwardItem("Item_LingStone",world:RandomInt(1000,3000));npc1.PropertyMgr:AddFeature("Baihehuakai");sjnpc.PropertyMgr:AddFeature("Baihehuakai");
	elseif Panding < 3 and npc1.PropertyMgr:CheckFeature("Pogua") ~= true and npc3 ~= nil and npc3.PropertyMgr:CheckFeature("Pogua") ~= true and npc3.Sex == npc1.Sex and npc1.PropertyMgr.RelationData:IsRelationShipWith("Spouse",npc3) ~= true then
	me:AddMsg("“嘶—！这次红线竟然错线了如此之多！为何会这样！女子与女子的孽缘…男子与男子的孽缘…还有牵在无名指上的孽缘…”\n“老师，这是怎么了？”一旁的小童看着穿着红衣喜服的老人，不解的问道…\n“孽缘啊…孽缘…，能够挽回一些…就是一些吧，哎…”老人叹着气，说出来的话也不知是在给谁听…\n……\n岁月就好比是握在掌中的冰，不论你摊开还是紧握，都会从你手中慢慢的溜走…\n“徒儿，这地方该如何可明白了？”身为师傅的"..npc3.Name.."看着认真学习着自己所传授的功法的[NAME]，眼中充满了溺爱，她很喜欢这个徒弟，冰雪聪明且十分用功，或许偶尔有些小调皮，但总体而言十个十分不错的孩子，天资出众，容貌一等，又肯努力，这么好的弟子去哪里找？\n在这时光的变迁中，"..npc3.Name.."发现自己真的越来越喜欢自己的这个弟子了，如今可以说是到了溺爱的程度，但她总觉得再这样下去，事情会发展到一个无可挽回的地步，但…她真的没有办法停下…\n“师傅，为什么这里要这样画啊，我觉得这里不用勾而用一撇，可以让符咒中的法力流通更加的畅通与快速…”[NAME]看着"..npc3.Name.."的眼睛，提出了疑问。\n"..npc3.Name.."笑而不语只是根据[NAME]的想法，进行了一次画符，画出来后，将其递到了[NAME]的手上，悠悠的说了一句：“你试试…”\n“嗯！”[NAME]点了一下头，然后将自己的法力输入进了符咒当中，结果符咒却突然产生了轻微的爆炸，不过两人都是修真者，这点爆炸还伤不了他们就是了。\n“懂了吧…”"..npc3.Name.."摸了摸[NAME]的头，柔声细语的说道。\n“我懂了，虽然这一笔用了勾使得法力在符咒内的流动受到了一定阻碍，但却很好的促进了符咒整体的稳定性，用一撇来代替虽然提升了法力的流动性，但却大幅破坏了整体的稳定性，因此不可取…”[NAME]恍然大悟道。\n“我的徒儿真聪明！”"..npc3.Name.."揉了揉[NAME]的头，笑道，心想：“这种平静，与世无争，教书育人的感觉，真的，很不错…”\n"..npc3.Name.."是过来人，她在修真界中闯荡了不知道多少年，看尽世间人心险恶，所谓十年饮冰，难凉热血，那么两个十年呢？三个呢？再多几个呢？多少年过去了，她早已不再天真，幸好这一路虽磕磕绊绊，但也总算是走过来了，如今，收个另自己满意的徒弟，教书育人，偶尔在徒弟面前充当一下贤妻良母中的良母，日子虽然平淡，但却也让"..npc3.Name.."感到心满意足…\n“嗯！？”就下"..npc3.Name.."思绪万千之际，她突然感觉到自己胸前传来了一股异样的感觉，当她回神，发现自己可爱的徒弟居然抓着自己的胸部，还嘟着嘴嚷嚷道：“为什么师傅的比我大那么多！”\n“你…！”看着自己的徒弟这一副可爱的样子，原本升起来的怒火尽然就这样被压了下去，而胸部传来的异样的感觉又让她的脸变得羞红，这是她第一次在自己的徒弟面前露出这一副表情，一脸娇羞惹人怜的表情…\n“我这是怎么了…为什么感觉心跳那么快…这感觉是…”突然，"..npc3.Name.."瞪大了眼睛，嘴唇微分，一脸不可思议的模样，她身为一个得道修士，自然知道这是什么情况，那便是…\n“情劫！”"..npc3.Name.."吐出这两个字的时候完全不敢相信，自己的情劫居然会是自己收的徒儿!\n“为什么…为什么会这样……！怎么会…”她在得知这个结果后直接瘫软的坐在了地上，眼神都涣散了些许，晶莹的泪珠从她的眼眶中缓缓地滴落，她不知道自己此时该是什么情绪，哭吗？哭为什么自己的情劫会是自己的徒儿…笑吗？笑这一切都来得太过荒诞和滑稽？她真的不知道，真的，真的真的不知道…\n走过了如此之多的辛酸挫折，这一刻她的心乱了，乱的很厉害，从未有过的乱，她不介意自己的道侣会是个女人甚至还是自己的徒儿，但她在意情劫是自己的徒儿啊！情劫这种东西可不是说度就能度过的！渡不过便是双双魂飞魄散！\n情劫有两种解法，一是直接抹杀自己的情劫之人，但这是她心爱的徒弟啊！她怎么可能忍心下手！？她早已把自己的徒弟看得比自己还重！别说杀，就算是伤了一根汗毛她都要心疼半天，曾今就有过一个凡人世家就因为随口说了两句[NAME]，她便灭了人家满门，她的手上早已沾满了鲜血，但唯独不愿染上[NAME]的泪水…\n“师傅，你怎么了？为什么突然哭起来了…你以前不是和我说过吗，女孩子哭多了可就变成小花猫了，就不好看了…”[NAME]看着突然无故落泪的师傅，有些不知所措，只能拍拍她的肩膀，尽可能的安慰她的师傅，她从未见过自己的师傅会哭的如此的伤心，师傅落泪，她也就伤心了…弄得她也好想哭…\n情劫从来不是只影响一人的情感，而是对被施加情劫的双方相互影响着的，因此，即便目前修为尚且浅薄的[NAME]，也开始慢慢有了感应，有的情劫来得快，有的来的慢…\n何为之情劫，及月老牵线却为牵紧，但却以不可分割，与解此况，只有二法，一是直接斩断情劫，而是以真心之所爱将其牢牢牵紧，前者胜在快，成功之后修为大进，后者虽慢但一但功成二人如一心同体，默契无边，双人施展法术威力更甚往昔不知几何，可，情劫有着时间限制，若是时限以至，情劫未解，上苍将降天罚于身，使之魂飞魄散…\n“师傅，为什么，[NAME]觉得鼻子好酸，好想哭，总觉得师傅可能会离开咱，咱不想离开师傅，咱想和师傅永远在一起，呜呜呜…”[NAME]哭诉着，她真的不想离开"..npc3.Name.."，在"..npc3.Name.."这里，她得到了此生以来最好的照顾…\n依稀记得师傅教他识字绘画，为她洗衣做菜，为她将自己身为得道大修的身份放下，甘愿做那一个农桑女，这份情感，不是三言两语可以说清楚的，这些日子来，两人之间的因果丝线将其慢慢的捆绑在了一起，如同蛛丝，一根两根细不可闻，但若是多了，便再也挣不开了…\n“徒儿…你，喜欢…为师吗？”"..npc3.Name.."现在只希望[NAME]对她有着一丝爱情的火花，这样，她就可以通过这一丝火花来进行破局，即便没有，她也会想尽一切办法弄出来，她真的不想自己的徒儿魂飞魄散…\n“喜欢…徒儿最喜欢的就是师傅了…师傅别哭了……”[NAME]脱口而出，她对"..npc3.Name.."是发自内心的喜欢，可惜的是这种喜欢却还没有转化为爱情，但没事，只要有了这一点引子，接下来的事情也就好办了许多！\n“嗯，我就知道我的好徒儿不会让师傅失望的…你不是羡慕为师的胸部吗？来为师房间，为师告诉你，如何让你的胸变得更大…记住，这种事，只能我们两个做…”"..npc3.Name.."破涕为笑，拉着[NAME]的手，朝着自己的寝宫走去…\n"..npc3.Name.."的寝宫很大，但却没有任何其他人，显得异常的清冷，若是凡人住在里面三五年，恐怕要被活活逼疯，而这一直未有人烟的宫殿，今天却迎来了两位佳人，一大一小，都是人间少有的伊人…\n“师傅，这里就是你真正的住所吗？好大…好漂亮啊~。”[NAME]的眼睛四处飘荡着，这华美的寝宫看的她是眼花缭乱，之前都和师傅住在一处普通的屋子里，虽然比之曾今自己的住所好了不知几何，但与此地一笔，还是云泥之别…\n“[NAME]，来了这里，以后我就不是你的师傅了…”"..npc3.Name.."摸了摸[NAME]的脑袋，笑眯眯的说道，但听到这话的[NAME]却吓了一跳…\n“师傅！是我哪里做错了吗！？徒儿一定改！求求师傅…千万不要抛弃徒儿啊！”[NAME]以为是自己哪里惹怒了师傅，师傅要将自己逐出师门了，顿时泪流满面的哭诉祈求了起来。\n“傻孩子，以后啊，你就是我的夫人了，师傅这辈子，真的就被你缠上了，我是怎么都没有想到，你居然会成为我的情劫…”"..npc3.Name.."擦了擦[NAME]脸颊上的泪痕，不论是动作神情，都是如此的温柔…\n“师傅…你真的不生我的气？”[NAME]试探的问道。\n“当然，你可是为夫最心疼的心头之宝啊，为夫怎么可能舍弃你呢？还有，你是不是该改一下称呼了？要叫夫…君…”\n“可是，可是，可是那不是夫妻之间的称呼吗，我和师傅…可都是女人啊…”[NAME]弱弱地说道，虽然踏入仙途，但世俗对[NAME]的影响依旧非常之大，这种影响需要时间来抹平…\n“傻孩子，我们是修真者，不需要为凡俗所累，不过想你一时之间也就受不了，以后呢，我叫你夫人，你呢，叫我师傅好了…”"..npc3.Name.."刮了一下[NAME]的鼻子，笑了笑，也没强求，但终归是得到了一个好的开始…\n“嗯…”[NAME]声若蚊虫一般的应了一声，微微低下了头，小脸早已布满了嫣红…\n“夫人，今日同房，春宵一刻可值千金…”"..npc3.Name.."直接用公主抱的形式抱起了[NAME]，朝着自己曾经的闺房走去，不得不多修仙者的寝宫就是不一样，即便过了如此之多的时日无人打扫，依旧是纤尘不染…\n闺房里，灯火暗淡却刚好足够两人看清对方的一切，两人早已褪去了衣物，坦诚相见，两人相互对视，一人对其一笑一时之间风情万种，一人目光闪躲娇羞异常惹人怜爱，一高一矮，一大一小，“（胸）一大一小”就这样碰撞在了一起，一种一样的感觉都传递给了彼此…\n“夫人，之前不是还在问师傅，为什么你的比我大吗？今天开始，师傅会每日为夫人进行按摩，直至夫人与为师大小同为止…”\n“师傅别说了，羞死人了…”\n“好好好，师傅不说了，只要夫人高兴，接下来我们来第一个步骤，高阶修真者的母乳对其低阶修真者的身体发肤都有着非常好的保养作用，所以，第一步…”"..npc3.Name.."催动法力向着胸部前进，过了一会儿，慢慢的有乳汁从"..npc3.Name.."的乳头上冒了出来，又过了几息，乳头上的乳汁便如同细小的水流一般，流了下来，轻轻的拍打在[NAME]的身体上…\n乳汁纯白，温度刚好，散发着一股芬芳与清香，即便只是闻着，[NAME]都能感受到其味道的甜美，若是一口下去，不知该是何等的舒畅，想到这里，[NAME]居然忍不住的咽了一口口水，但旋即立刻摇了摇自己的脑袋，暗骂自己不为人子，为何能出现这种想法…\n“啵…”就在[NAME]想要把杂念一扫而空的时候看，"..npc3.Name.."直接就把自己的一颗乳头塞到了[NAME]的嘴里，眼神中透露着柔情蜜意，这个眼神很复杂，里面蕴含了太多东西，师徒情，爱情，背德感，甚至还有这一丝母爱…只是这个眼神真的太过复杂，别说是"..npc3.Name.."这种还未经历太多世事的孩子，就算是一个得道大修，估计也只能看透三分而已吧……\n“多喝点，对你的身体有好处，师傅这里还有很多，多喝点，把自己养的亭亭玉立的，那样我就心满意足了…”[NAME]盘坐了起来，将"..npc3.Name.."的头托在胸前，像极了母亲哺乳的样子，像是有一阵阵母性的光辉洒在[NAME]的面前，而这种感觉也好似让她回到襁褓中的婴儿姿态…\n温暖，安心，这是[NAME]如今最直观的感受…\n一刻钟后，[NAME]已经有点喝不下了，而这一点也被"..npc3.Name.."所察觉，于是乎就轻轻的把[NAME]的头部放了下去，此刻[NAME]的下巴下面已经被"..npc3.Name.."纯白的乳汁所渲染了一遍，显得格外的诱人，至少[NAME]是那么觉得的，身为师傅，最终却和自己的徒弟发生了不伦之恋，这事何等的罪过，好在这里是拳头说话的修真界，不然真不知道要面对如何的口诛笔伐…\n“接下来，师傅会把乳汁涂满你的全身，并开始按摩，不出三月，师傅的胸部应该就会有我的七分大小了…”"..npc3.Name.."一边在[NAME]身上涂抹着乳汁，一边调戏道…\n“嘤…”躺在已经彻底被自己师傅的乳汁浸湿了的床上，[NAME]发出了十分可爱的呻吟声，好似美妙的音乐听得"..npc3.Name.."是享受…\n“咿…嘤…，师傅，哪里不可以的，很脏的…”"..npc3.Name.."感受着[NAME]到处乱摸的双手，最终碰到了自己的蜜穴与娇嫩的菊花，感觉到十分的瘙痒，不由得提醒道…\n“是吗？为师闻闻…”"..npc3.Name.."直接将自己的鼻子放到了[NAME]的菊花与蜜穴前面，故意大口呼吸，通过鼻息不断地刺激着[NAME]的感官，过儿好一会儿，"..npc3.Name.."才将脑袋再次探出来巧笑道，“既然说脏，为何为师没有闻到任何的异味呢？”\n修真者，早已完成辟谷，自然不会像凡人一般因为排泄而导致下面出现臭味和残留，相反因为可辟谷不食的原因，下面反而和口舌并未有多大的区别，当然特殊情况另算…\n“师傅相信师傅的夫人是不可能撒谎的，师傅在试试看…”"..npc3.Name.."找了一个借口，伸出舌头在[NAME]的蜜穴与菊花部位舔舐了起来，相比于之前的鼻息，这一次的刺激来的更加的猛烈，未经人事的[NAME]怎可能忍得住此等刺激！\n“师傅…师傅别！别舔了！我！我！我要尿出来了…咿！！！”一瞬之间，"..npc3.Name.."便达到了高潮，可是她太过纯洁，并不知道何为高潮，因此说是要尿出来了，事实上这一批高潮里面还真混入了尿液，之前"..npc3.Name.."喝了太多来自[NAME]的母乳，由于品级过高，虽然温和，但无法吸收，最终的选择也只能是排出体外，所以，这次的吹潮，是乳白色的…\n“看来夫人很是兴奋啊，居然都高潮了…”"..npc3.Name.."抹了一把脸，舔了舔嘴唇，淡淡的甜味冲击着她的味蕾，这让她想到了一个好主意，于是乎，他就想出了原本并不存在的第三步…\n“师…师傅…对不起，真的对不起…呜呜呜…”看着被自己的白色“尿液”喷成落汤鸡的师傅，[NAME]连忙道歉了起来，她真的很愧疚，自己居然把“尿尿”尿在了对待自己如此温柔的师傅身上…\n“没事，那叫高潮…以后你还会经历的…不止这一次哦…”"..npc3.Name.."完全不在乎这满身的乳白色液体…\n“好了，第二部看来是已经完成了，接下来我们开始第三步吧…”"..npc3.Name.."边说，边将自己的乳头塞进了[NAME]的蜜穴中，然后通过法力将其乳汁注入到了[NAME]的膀胱之中，没过一会儿，[NAME]的膀胱便被注入了满满的乳汁，然后"..npc3.Name.."再通过法力封住了尿道，使之无法流出…\n“师…师傅，你在干什么！为什么把胸部塞进了我尿尿的地方！为什么…我越来越想尿尿了！但为什么，想尿却尿不出来！”[NAME]看着师傅奇怪的举动，虽然她很难受，但她不想去阻止，她不想要让自己的师傅失望！\n“没事的，等下就会很舒服了…”"..npc3.Name.."看着在床单上不断忍者刺激的[NAME]，选择了“邪魅一笑”，然后将自己的两根玉指放入了[NAME]的蜜穴中抽送了起来，而在此期间，[NAME]也因为刺激不断地呻吟着，叫声之销魂曼妙，另"..npc3.Name.."陶醉不已…\n不过一会儿，"..npc3.Name.."的手指上便出现了红色的血迹，这是处子之血，"..npc3.Name.."动用法力将其处子之血凝聚于半空，而后再分神一道牵来一个琉璃瓶将其放入其中，完工后还在上面刻上了[NAME]的处子之血，"..npc3.Name.."取之…当然，过程中"..npc3.Name.."手指的差送并未停下…\n“师傅……我，我真的，快…快…不行…不行了，感…感觉…自己…快要…昏过去了…师傅，求你放过我吧，让我尿出来吧！求你了”过了两刻钟后，[NAME]求饶着，她真的已经到达极限了，再这样下去她感觉自己要坏掉了…\n“说，夫君，让人家高潮吧……”"..npc3.Name.."抓住时机，在[NAME]的耳边轻声细语着，好似恶魔的低语…\n“是…是…，夫…夫君…大人…求…求求…求求你…，快让我…让我…高…高潮吧！”[NAME]艰难的说出了这段话，"..npc3.Name.."也直接解开了位于尿道的法力封锁，一时之间，[NAME]的泄洪场景甚是壮观，这个过程整整持续了几十息，而在这一次高潮结束后，[NAME]也直接昏睡了过去…\n“睡得真是可爱呢…”"..npc3.Name.."看着[NAME]的睡颜，轻轻地在其脸颊旁亲了一口，又道：“下次，可就轮到你收走为师的处子了哦…”\n……\n“师傅…这一次，轮到我了……”[NAME]虽然说起来扭扭捏捏的，但她的眼神中，已经透露出了决绝……\n“嗯…夫人，这次，你抱着我去吧…”"..npc3.Name.."露出了信服的笑容……\n——\n“原本的这一桩女子与女子只见禁忌的孽缘，居然被硬生生掰成了善缘！果然是天要变了吗？不过，这样也好…红事一桩胜过十座仙佛庙…”\n……");
	npc1.PropertyMgr:AddFeature("Pogua");npc3.PropertyMgr:AddFeature("Pogua");me:DropAwardItem("Item_Nvxiuluohong",2);npc1.LuaHelper:AddTreeExp(100000);npc3.LuaHelper:AddTreeExp(100000);npc1.PropertyMgr.RelationData:AddRelationShip(npc3,"Spouse");npc1.PropertyMgr:AddFeature("Baihehuakai");npc3.PropertyMgr:AddFeature("Baihehuakai");
	elseif me:CheckFeature("Pogua") ~= true then
	local wenben = me:ParseNpcStory("[rand_lable=desc_time,desc_place,desc_weather]，"..npc1.Name.."想了一会心事。")
	me:AddMsg(wenben);me:AddMemery(wenben);
	elseif npc1 ~= sjnpc and npc1 ~= sjnpc2 and sjnpc ~= sjnpc2 and npc1.PropertyMgr:CheckFeature("Pogua") and sjnpc.PropertyMgr:CheckFeature("Pogua") and sjnpc2.PropertyMgr:CheckFeature("Pogua") ~= true and npc1.Sex == sjnpc2.Sex and npc1.PropertyMgr:CheckFeature("Baihehuakai") and sjnpc.PropertyMgr:CheckFeature("Baihehuakai") and sjnpc.Race.RaceType == npc1.Race.RaceType and sjnpc2.Race.RaceType == npc1.Race.RaceType and sjnpc2.IsAlive and sjnpc.IsAlive then
	me:AddMsg("“三线交织，却无恶果亦无善果，天际朦胧，本姻缘错线已多，如今更是三线一体，天变，看来真的来了…”\n……\n一阵季风带着暧昧的气息吹过了宗门的上空，而下面，也同时上映着一副异于寻常的活春宫…\n“咿呀！[NAME]，我快受不了了，快要去了…"..sjnpc.Name.."面色潮红，呼吸急促，身上香汗淋漓，配上那精致的脸蛋与挺巧的身材，无时不刻不在透露着摄人心魂的媚意，令人遐想万千，此等景象，若是让一血气方刚的年轻男子见着，也许就忍不住兽心大发，臣服于最原始的欲望了…\n“呼…喝…呼…我…也是，咱们，一起去吧……”[NAME]与她的情况相似，也已经来到了登仙之乐的最后一步，只要一个契机，她们就会尝到只属于女人的至高快感！没错，两人都是女子，她们正以一种世俗不容的姿态交合着……\n两人原本原本就黏在一起摩擦的蜜穴，此刻更是进入了最后的冲刺，再过了几十息的最后疯狂之后，两人终于突破了那最后的界限，达到了巅峰，完成了高潮，得到了独属于女人的至高快感！\n“咿呀…啊…！”\n两人同时传出了高潮的呻吟，声音自是十分妩媚，勾人心魂，她们的下面淫荡的泄洪比之那上面的嘴传出来的的声音也不妨多让，直接都将对方喷的满身都是，整个房间都充斥着一股淫糜的气息…\n“呼…可真畅快啊……”[NAME]躺在床上，看着气喘吁吁的"..sjnpc.Name.."，狠狠地捏了一把她饱满的胸部，笑着说道。\n“呵…”她不甘示弱，冷笑一声，直接将三根手指朝着[NAME]那因为疯狂和高潮还未闭合的蜜穴差去，这样强烈的刺激再一次将[NAME]的意识送上了极乐之境，吐出的舌头上翻的眼睛加上因为刺激而突然以臀部为中心而紧绷弹起的身子，完美的展现了肢体语言与颜艺…\n“咿…啊！”[NAME]再次泄洪，直接在原本就湿透了的床单上再多添了一处水水汪…\n她们这样已经好些时日了，她们知道这为世俗所不容，会被天下人所鄙夷，但她们都已近不在乎了，只要彼此有对方，就心满意足可，而且女子与女子一起做，感觉似乎也不差啊，那种同为女子对于敏感部位的了解和对给予女子最高快感的手法掌握，可不是男人可以比的，而且这种违背世俗之恋带来的背德感，也让她们变得更加的兴奋…\n“好了，不闹了…”过了一忽会儿，[NAME]恢复了点力气，有气无力的朝着"..sjnpc.Name.."说道。\n她揉了揉自己被[NAME]捏的生疼的胸部，没好气的说道：“是你先闹得，我只是反击而已！哼！”\n“好好好，都是我的错…”[NAME]安慰道，而后话锋一转：“哎，你觉得我们这样的日子会一直持续下去吗？”\n[NAME]的心中怀揣着不安的问道，最近她的心中总有着一种不祥的预感，她从小直觉就很准，这种感觉应该不会是空穴来风，只希望这一次，真的只是自己想多了…\n“也许吧…我倒是挺希望一直这样下去的，毕竟…我的身子，可已经完完全全的给了你了…此生心中，再无他人……”她笑了笑，突然变得有些伤感，她们之间的行径为世人所不齿的，倘若有一天被发现了…她们真的不知道该如何面对那如同天崩一样的一切……\n“算了，不要多想…啊，对了，今天要不要在这里住一晚，都那么晚了……”[NAME]看着昏暗的天空，朝着"..sjnpc.Name.."挽留道…\n“算了，我还是先回去好了，留久了会遭人怀疑的…”"..sjnpc.Name.."迅速的将跳蛋和肛塞分别塞进自己的蜜穴和屁眼里，然后快速自己的衣物穿好，由于刚才的疯狂，身上依旧是湿嗒嗒黏糊糊的，所以穿着衣服很是难受，但总不能不穿衣服吧……\n“我们两个都是女人，怀疑个什么啊，你以为都是我们啊…”[NAME]虽然嘴上是那么说，但实际上她自己也是如此，自从选择了这禁忌的情感与行为后，她也对周围的一切变得非常敏感，生怕被别人知道了一般…\n——\n“呵呵，我当最近你怎么见我见得少了…，可恶，明明是我先看上的…为什么！为什么！”在窗外看到了全过程的"..sjnpc2.Name.."，她的心绪是崩溃的，泪水止不住的落了下来，她在很早之前就已经喜欢上了"..sjnpc.Name.."，但是由于胆小和世俗的束缚，让她不敢迈出那最后的一步…最终，值得见证伊人名花有主…\n“我记得我还有一枚筑基丹…既然这样…那么…呵呵…”"..sjnpc2.Name.."擦了擦眼泪，然后露出了阴森的笑容…\n…三日后…\n这一日，"..sjnpc.Name.."再次来到了[NAME]的屋子里，她们两再一次进行了水乳交融，将自己完完全全的交于对方，享受那至高的快感，但是，她们不知道的是，这一次，她们淫糜的所作所为，全都被人记录了下来…\n“我先走了…”\n“一路上注意安全…”[NAME]笑着挥手告别，笑的很幸福，这种生活，才是她想要的，这些日子以来与"..sjnpc.Name.."的密切交流，让她道心畅通无阻，距离筑基又是更进一步。\n她迈着虚浮的步伐走在回到自己屋子的路上，没办法，疯狂过后自然是体力的不支，因此步伐虚浮也是难免之事，但之前可能没有什么事情，不过这一次…\n“嗯！呜…呜…呜！”突然，一只抓着涂了药粉的白布的手死死地捂住了她的嘴巴，挣扎之际，"..sjnpc.Name.."吞下了许多的药粉，这药粉具有催眠和催情作用，催眠效果很短，只有两刻钟，但催情效果，却有整整一天！\n而当"..sjnpc.Name.."再次睁开眼睛的时候，发现自己的四肢已经被用铁环呈现X形死死地固定在了冰冷的铁床上，而一抬头，便看到了站在一张桌子旁边已经穿上了性爱服装的"..sjnpc2.Name.."，但这都不是关键，她此刻只觉得自己淫欲高涨，浴火冲天！\n“为什么…不…好热，真的好热…好难受，好痒……怎么会这样…”"..sjnpc.Name.."口齿不清的说着，她想问"..sjnpc2.Name.."为什么要这么做，但她的身体却因为高涨的欲望而不允许她说出一句完整的话来……\n“为什么…呵…”她冷冷的看了一眼"..sjnpc.Name.."，然后拿起了桌子上的小鞭子，狠狠地抽打在了"..sjnpc.Name.."的乳房上，回到道：“为什么！我还想问为什么！明明只要有我就够了！为什么！”\n"..sjnpc2.Name.."像是疯了一样，又是好几鞭子，直接将她的乳房抽出了淤青，可见她是真的非常愤怒，不过抽了几下之后，她又停了下来，她笑了，笑的病态，笑的令她发寒：“不过现在也还不迟…这一次，我不会再错过了，我要彻底将你调教为我的奴隶！”\n“不要…！”"..sjnpc.Name.."还没说完以及完整的话就又被狠狠地抽了一鞭子…\n“没有主人的允许，奴隶没有资格说话！”"..sjnpc2.Name.."捏住了她的嘴巴，然后将一个口球塞进了她的嘴里，现在"..sjnpc.Name.."也只能发出嗯嗯嗯的声音，再也没有办法去质问"..sjnpc2.Name.."了…\n"..sjnpc2.Name.."不断的鞭打着，"..sjnpc.Name.."也不断的尖叫着，但是因为药粉的效果，很快她的尖叫就变成了呻吟，好似在勾引着她一样，让她再打重一点，快一点一样…\n看着满是淤青甚至被打破了皮还流出了血的胸部，"..sjnpc2.Name.."得意的笑了笑，然后从桌子上拿来了两根针管，那是异界之物，可以快速的治疗伤口并且让乳房肥大化一段时间，并且具有不错的催淫效果，同时还会开发乳腺，使其永久性质的产乳，不停地产乳…\n"..sjnpc2.Name.."粗暴的将两只针管的尖针刺进了"..sjnpc.Name.."的乳头，狠狠地将其中的药液注射了进去，剧烈的刺激冲击着"..sjnpc.Name.."的整个人和大脑，不由得发出了剧烈的呻吟，可惜戴着口球，呻吟并不能尽兴，但下面却直接泄了洪，哦，不止泄洪，甚至连尿液和粪便都在这次泄洪中被喷了出来…\n“真是淫乱的身体啊，居然高潮到失禁了…”看着高潮到失禁的"..sjnpc.Name..","..sjnpc2.Name.."的舌尖舔了舔洁白的牙齿，戏谑的嘲讽道，这幅样子，不正是她想要看到的吗？玩弄她，得到她，拥有她，在她身上彻底刻下只属于自己的烙印…！\n“但，我并不介意…”她丝毫不在乎"..sjnpc.Name.."排泄物的刺鼻气味，居然直接把自己的面部放到了"..sjnpc.Name.."的蜜穴前，动了动鼻子，闻了闻那刺鼻的气味，说：“真难闻啊，不过呢，我并不介意哦…，毕竟…”她细细的，慢慢的舔了一口蜜穴后接上上一句话道：“我不在乎呀…”\n“呜…呜…呜……嗯……！呜呜！”即便她不断地抗拒着，但却又因为药剂和药粉的催淫效果，口球又让"..sjnpc.Name.."言语不能，此刻的"..sjnpc.Name.."虽然保持着一丝清明，但大体以尽快沦为欲望的奴隶了……\n"..sjnpc2.Name.."对"..sjnpc.Name.."的喜爱已经到了近乎病态的地步，因此即便是沾了"..sjnpc.Name.."的下面已经沾染了排泄物的情况下，她也以就愿意舔舐"..sjnpc.Name.."的蜜穴与菊花，这份喜爱，病态的喜爱，可不是外物可以侵扰的…\n过了上百息后，药剂的效果已经发挥了出来，"..sjnpc.Name.."的乳房开始越来越大，同时也开始分泌起了纯白的乳汁，而且越来越多，看到这一幕的"..sjnpc2.Name.."，来到了"..sjnpc.Name.."的乳房旁边，开始揉搓了起来，嘴里念叨着：“来，让我来给你揉揉，我可爱的小奴隶，胸部一定要变得大大的哦，这样才能做主人最喜欢的小母牛，为主人产出足够多的乳汁，到时候我们一起用小母牛的香甜的乳汁洗澡，她是多么甜蜜的事情啊…”\n此时的"..sjnpc.Name.."已经不再管她到底再说些什么了，强烈的刺激让她无暇顾及其他事情，体内熊熊燃烧的浴火也让她什么都不想管，只想要将这份淫欲释放出去，口水，鼻涕，眼泪，无间断的落下来，像是一个要被玩坏的人偶一样…\n也许是"..sjnpc2.Name.."的揉搓真的起作用了，又或者是药效真的强，短短一刻钟，"..sjnpc.Name.."的一个乳房居然已经变得要"..sjnpc2.Name.."双手环抱才抱的下了，由于乳房过分的巨大，导致胸部像水流一样由高向低向着两边滑落，有一部分甚至滑出了床边，巨大的乳房自然也有着非比寻常的重量，这让"..sjnpc.Name.."感受到好似有人在将她的胸部生生撕下来一般，火辣辣的疼！\n但…药剂与药粉的双重作用，又让一部分的痛苦转化为了快感时时刻刻的冲击着"..sjnpc.Name.."的大脑，这种剧烈的刺激，她真的觉得自己快要坏掉了，在这种时刻他居然想到了也许，就这样永恒沉沦或许也没事，屈服于快感，好像也没有那么糟糕…\n又过了一刻钟，乳房已经膨胀到了最大程度，大到"..sjnpc2.Name.."即便是用抱的，也只是指尖能够轻轻相触而已，乳头上的乳汁就好像是水流一样不断地喷出来，不一会地面上就已经形成了“积水”…\n“真是的，居然会变得那么大，有点出乎预料，不过这样也好，看看这乳头…大成什么样子了？都能当蜜穴用了吧……”"..sjnpc2.Name.."舔了舔嘴唇，转身从后面的桌子上拿出了两个双头龙换个十个跳蛋！哦，对了，她还额外移过来了两张床将其与绑着"..sjnpc.Name.."的床并列合并在一起，将其乳房超过床边的部分轻轻地放在对接的两张床上……\n“本以为不需要那么多，但现在吗，应该装得下了吧……”"..sjnpc2.Name.."舔了一口跳蛋，侧眼看着已经快被玩坏的"..sjnpc.Name.."，邪笑着说道…\n"..sjnpc2.Name.."一步步的走近，拿着跳蛋，她准备将这些跳蛋都塞进"..sjnpc.Name.."的胸里面，让她体验一次不一样的高潮，说做就做，"..sjnpc2.Name.."一边说，一遍将跳蛋插进"..sjnpc.Name.."的乳头里面：“左边来一个，右边来一个……左边再来一个，右边再来一个……嘻嘻嘻，真可爱啊，我可爱的小乳牛…”\n跳蛋一个个的塞进了"..sjnpc.Name.."的两个乳头，一时之间，"..sjnpc.Name.."的胸部接受到了大量的刺激，"..sjnpc.Name.."主观上很想将它们拿出来，但是肉体的浴火又让她无比享受着这一切，不过，现在即便她想拿也拿不下来，毕竟整个人都被牢牢的束缚在哪里…\n十个个跳蛋没过一会儿就全部被塞进了"..sjnpc.Name.."的乳头里，她笑了笑：“真乖，接下来让我给你盖上盖子…然后再搅拌一下，嘻嘻…”\n"..sjnpc2.Name.."拿出双头龙，直接在堵住了"..sjnpc.Name.."的乳孔，而后直接将跳蛋的的马力开到最大，突如其来的巨大刺激直接让"..sjnpc.Name.."瞪大了眼睛，整个身子都紧绷了起来，她疯狂的挣扎着，可惜的是凡人的肉身终究没能拼过冰冷的铁链，这一切的挣扎都显得毫无意义…\n“点点羊羊左右左…嗯…就左边吧…”"..sjnpc2.Name.."来到"..sjnpc.Name.."的左胸旁边：“接下来，就把我的一切交给你吧，我为你保留的处子之身……现在，就彻底想给你了，我可爱的小奴隶啊……！”"..sjnpc2.Name.."笑了，这笑容，显得悲伤但却又好像带着幸福，显得温柔却是如此疯狂，也许她真的疯了…\n她捏住了被用双头龙堵住的乳头，虽然还是有一些乳汁从乳头的缝隙和乳晕上的一些小粒中冒出来，但相对于目前"..sjnpc.Name.."巨大的产乳量来讲并不多，甚至可以说是很少，因此现在的"..sjnpc.Name.."只觉得自己的乳房涨的厉害，但其内的乳汁却应为双头龙的堵塞而不得喷涌而出，只能被这奇怪，难受却又令人欲罢不能的感觉折磨的死去活来！\n“去了哦…”"..sjnpc2.Name.."浅笑一声，用双头龙的顶端在自己的小穴上摩擦了几下后，然后直接坐了下去，双头龙也因此直捣黄龙，"..sjnpc.Name.."的乳房也因此而变形，感受到了不小的疼痛，疼痛又有一部分转化为快感…\n“伊…！”破处的疼痛冲击着"..sjnpc2.Name.."的神经，但她也仅仅只是那么呻吟了一声，随后便露出了扭曲病态的笑容……\n“撒，内，你看，你的胸部可正在抽插着我的蜜穴呢，真的好痛的说，但是有真的好说服啊，我们早就该这样融合在一起了……不是吗？呵呵呵哈…”"..sjnpc2.Name.."的语气十分温柔，但配合上这种表情却让人有种不寒而栗的感觉，不过此时的"..sjnpc.Name.."已经彻底沦为了肉欲的奴隶，再也不能多想什么，只是无条件的迎合着"..sjnpc2.Name.."的一切所作所为……\n破处的血液从"..sjnpc2.Name.."的蜜穴滴落，直接染红了"..sjnpc.Name.."的大半个左胸部，为原本就诡异的画面更添了几分血腥与恐怖…\n“你的胸部，你的肌肤，可都沾上了我的处女之血哦，看看吧，我们融合在一起的样子是多么的美妙！这才是你我真正的归宿啊！”"..sjnpc2.Name.."显得越来越疯狂，她的柔软雪白的屁股不断地在"..sjnpc.Name.."的乳房上起落扭动，那种两块软肉相结合和感觉，让其忘乎所以，爽到成仙！\n“啊…哈…嗯…哈—……咿！”"..sjnpc2.Name.."不断地呻吟着，她觉得，这真的是她这一生中最幸福的一刻：“呵……呼…呜…真…真舒服…咿……我！好像！快…块要高…高潮了！那么…让我们一起去吧！”\n"..sjnpc2.Name.."直接拔松了"..sjnpc.Name.."右胸布上的双头龙，而她在此时也彻底达到了高潮！淫水混着尿液直接完成了一次超大水量的泄洪，瞬间就冲淡了"..sjnpc.Name.."胸部上的处子之血，而"..sjnpc.Name.."的右胸部也因为双头龙的被拔松了一点，乳房内巨大的“水压”也直接将其踢了出去，跳蛋和双头龙至少飞出了三米远，喷出的乳汁像是喷泉一样，直接喷到了有一丈高屋顶！\n“碰！”突然，房门被暴力的踢开了，来了一个人，此人不是别人，真是[NAME]！当她看见眼前的一幕的时候，整个人都傻了！\n“怎么样…我的小母牛，可爱吗？”"..sjnpc2.Name.."鬼魅般的笑着，然后将"..sjnpc.Name.."依旧塞着双头龙的乳头对准了[NAME]，稍稍一松，然后在其乳房上用力一拳！原本堆积的乳汁直接暴动化作喷泉带着双头龙和跳蛋喷向了[NAME]！[NAME]下意识的挡了一下，结果…\n“可恶！！！！”[NAME]看着周围只剩下她和被玩坏的"..sjnpc.Name.."时！整个人都暴怒了！泪水也似暴雨一般落了下来！没错，"..sjnpc2.Name.."就这样凭空消失在了[NAME]的眼前！\n自己的最爱之人居然被如此玩弄，受尽了万般折磨，在这种条件下，却让身为仇人的"..sjnpc2.Name.."跑了！这让她何以甘心！但目前追人不是当务之急，目前的当务之急是救人……！\n“下次…还会再见的！”");
		if zhangmen ~= nil and zhangmen.Sex == npc1.Sex and zhangmen.PropertyMgr:CheckFeature("Chinvguchong") then
		me:AddMsg("“嘿嘿，真的劲爆，看来这次又可以赚点钱了……”用法宝看完了全程的掌门"..zhangmen.Name.."露出了笑容…");
		me:DropAwardItem("Item_LingStone",world:RandomInt(8000,13000));
		end
	sjnpc2.PropertyMgr:AddFeature("Baihehuakai");sjnpc2.PropertyMgr.Practice: AddZhuJi(25000);sjnpc.PropertyMgr.Practice: AddZhuJi(25000);npc1.PropertyMgr.Practice: AddZhuJi(25000);sjnpc2.PropertyMgr:AddFeature("Pogua");sjnpc2.PropertyMgr:AddFeature("Runiu");
	elseif Panding == 1 then
	local wenben = me:ParseNpcStory("[rand_lable=desc_time,desc_place,desc_weather]，凡界武修潜入宗门欲窃取本宗修行秘法被"..npc1.Name.."擒获，"..npc1.Name.."本欲将其打杀当场，却见得对方体格健硕样貌也算的上俊朗，心中欲火渐起，便将对方擒回房内当做炉鼎采补圈养……")
	me:AddMsg(wenben);me:AddMemery(wenben);npc1.LuaHelper:AddModifier("Luding");
	elseif Panding == 2 and npc1.PropertyMgr:CheckFeature("SonOfDestiny") and npc1.Age < 25 then
	local wenben = me:ParseNpcStory("一名少年踏上"..SchoolMgr.Name.."山门，高喊道：“"..npc1.Name.."，当年你仗着"..SchoolMgr.Name.."实力强横来退亲之时，我就说过三十年河东，三十年河西莫欺少年穷了！今我《万剑归宗》与《凤凰神血经》大成之日，便是要你"..npc1.Name.."和"..SchoolMgr.Name.."付出代价之时！”，\n对方言毕，便只身杀上了"..SchoolMgr.Name.."。")
	me:AddMsg(wenben);Hudong:diren003()
	elseif Panding == 2 and npc1.PropertyMgr:CheckFeature("BeautifulFace2") then
	local wenben = me:ParseNpcStory("一伙路过的散修因为垂涎于"..npc1.Name.."的惊世美貌，故向"..SchoolMgr.Name.."提出了要求，如果"..SchoolMgr.Name.."愿意将"..npc1.Name.."双手奉上，那么他们就不会攻打"..SchoolMgr.Name.."。")
	me:AddMsg(wenben);me:TriggerStory("Suiji01");
	elseif Panding == 3 and zhangmen ~= nil and zhangmen.Sex ~= npc1.Sex and npc1 ~= zhangmen then
	local wenben = me:ParseNpcStory("[rand_lable=desc_time,desc_place,desc_weather]，"..npc1.Name.."发现山下有一群散修正在围攻一个女子，"..npc1.Name.."上前驱走了那些修真界的败类，拯救了这名女子，正待将这女子送走，"..npc1.Name.."突然想起这个月掌门交代的任务还未完成，便施术将其迷昏送至掌门"..zhangmen.Name.."寝室，"..zhangmen.Name.."大喜之余将女子一番采补作为炉鼎养在后院。\n"..zhangmen.Name.."：")
	me:AddMsg(wenben);me:AddMemery(wenben);zhangmen.LuaHelper:AddModifier("Story_Caibuzhidao1");zhangmen.LuaHelper:AddModifier("Luding2");
	elseif Panding == 3 then
	local wenben = me:ParseNpcStory("[rand_lable=desc_time,desc_place,desc_weather]，"..npc1.Name.."发现山下有一群散修正在围攻一个女子，"..npc1.Name.."上前驱走了那些修真界的败类，拯救了这名女子……")
	me:AddMsg(wenben);me:AddMemery(wenben);
	elseif Panding == 4 and npc1.PropertyMgr:CheckFeature("SonOfDestiny") then
	local wenben = me:ParseNpcStory("[rand_lable=desc_time,desc_place,desc_weather]，"..npc1.Name.."在山门修炼，一条修为通天的蛇妖向"..SchoolMgr.Name.."飞来，"..SchoolMgr.Name.."弟子如临大敌，纷纷驭起法器准备御敌，却未曾想蛇妖并没有攻山的意思，反而从其口中说出了一个故事：\n万年之前，它还是一条凡蛇，一日被一女修所获，当做……嗯……黄鳝……对，黄鳝使用……那女修修为通天，精元自然也是无价之宝，小蛇在女修洞中来回之时，有幸饮得些许精元开了智灵，日日伴得女修左右，却不见天有不测风云，一场仙魔大战，女修身死道消，小蛇却因实力地位逃得一劫，万载苦修只求寻得女修转世报偿恩情。\n而"..npc1.Name.."正是那千年之前的女修转世……")
	me:AddMsg(wenben);me:TriggerStory("Suiji04");
	elseif Panding == 4 and npc1.LuaHelper:GetModifierStack("Luding") > 0 then
	local wenben = me:ParseNpcStory("[rand_lable=desc_time,desc_place,desc_weather]，"..npc1.Name.."正在房中享受自己俘虏中的一名凡夫"..NanName.."的耕耘，一时忘情竟泄了身子，沉迷欲海的"..npc1.Name.."自是万万都没想到，"..NanName.."居然在机缘巧合之下习得了采补的秘法，每每在自己脱力泄身之时，偷偷吸收炼化自己的阴精用于修行，或是"..NanName.."觉得时机已到，在这次施展了诸多手段让"..npc1.Name.."完全泄身后，乘机逃离了"..SchoolMgr.Name.."……")
	me:AddMsg(wenben);me:AddMemery(wenben);npc1.PropertyMgr:FindModifier("Luding"):UpdateStack(-1);
	elseif Panding == 5 and world:GetWorldFlag(1704) < 1 then
	local wenben = me:ParseNpcStory("[rand_lable=desc_time,desc_place,desc_weather]，"..npc1.Name.."在山门招待其他门派弟子之时因为"..npc1.Name.."活好，青莲剑宗弟子"..NanName.."将一则同门长老隐秘告诉了"..npc1.Name.."：\n青莲剑宗新有一名为尹志平的长老，此人天赋卓绝贱种天成，修炼青莲贱道简直有如神助，只因一夙念未了导致一直强压修为不愿飞升，若有人可以完成尹长老的夙愿……")
	me:AddMsg(wenben);me:AddMemery(wenben);world:UnLockJianghuNpc("Npc_shiqi_1");me:AddSchoolRelation(6,20);world:SetWorldFlag(1704,1)
	elseif Panding == 5 then
	local wenben = me:ParseNpcStory("[rand_lable=desc_time,desc_place,desc_weather]，"..npc1.Name.."在山门招待其他门派弟子之时，因为"..npc1.Name.."活好得到了来自青莲剑宗弟子"..NanName.."的认同……")
	me:AddMsg(wenben);me:AddMemery(wenben);me:AddSchoolRelation(6,20);
	elseif Panding == 6 and npc3 ~= nil and npc4 ~= nil and npc3.Sex ~= npc1.Sex and npc4.Sex ~= npc1.Sex and npc3.PropertyMgr.BodyData:PartIsBroken("Genitals")and npc4.PropertyMgr.BodyData:PartIsBroken("Genitals") then--有男性师傅和男性师祖，但对方都是太监
	local wenben = me:ParseNpcStory("[rand_lable=desc_time,desc_place,desc_weather]，"..npc1.Name.."在山门[obj_action]时，被师傅"..npc3.Name.."唤去寝殿，给师傅"..npc3.Name.."和师祖"..npc4.Name.."舔谷道\n事毕，"..npc1.Name.."从两个太监师傅师祖身上获得了若干参悟……")
	me:AddMsg(wenben);me:AddMemery(wenben);npc1.LuaHelper:AddTreeExp(500 * npc3.LuaHelper:GetGLevel());npc1.LuaHelper:AddTreeExp(1000 * npc4.LuaHelper:GetGLevel());
	elseif Panding == 6 and npc3 ~= nil and npc4 ~= nil and npc3.Sex ~= npc1.Sex and npc4.Sex ~= npc1.Sex and npc4.PropertyMgr.BodyData:PartIsBroken("Genitals") then--有男性师傅和男性师祖，但师傅不是太监，师祖是
	local wenben = me:ParseNpcStory("[rand_lable=desc_time,desc_place,desc_weather]，"..npc1.Name.."在山门[obj_action]时，被师傅"..npc3.Name.."唤去寝殿，给师祖"..npc4.Name.."表演活春宫，只见师傅"..npc3.Name.."将"..npc1.Name.."按倒在床榻之上疯狂冲刺，而"..npc1.Name.."的香唇也被师祖的谷道抵住……\n事毕，"..npc1.Name.."的肉穴中被灌满了"..npc3.Name.."的精元，唇边也沾染了不少师祖"..npc4.Name.."谷道中流出的金汁……")
	me:AddMsg(wenben);me:AddMemery(wenben);npc1.LuaHelper:AddTreeExp(1000 * npc3.LuaHelper:GetGLevel());npc1.LuaHelper:AddTreeExp(1000 * npc4.LuaHelper:GetGLevel());
	elseif Panding == 6 and npc3 ~= nil and npc4 ~= nil and npc3.Sex ~= npc1.Sex and npc4.Sex ~= npc1.Sex and npc3.PropertyMgr.BodyData:PartIsBroken("Genitals")then--有男性师傅和男性师祖，但师傅是太监，师祖不是
	local wenben = me:ParseNpcStory("[rand_lable=desc_time,desc_place,desc_weather]，"..npc1.Name.."在山门[obj_action]时，被师傅"..npc3.Name.."唤去寝殿，侍奉师祖"..npc4.Name.."，只见师祖"..npc4.Name.."一会捅捅"..npc1.Name.."的肉穴，一会插插"..npc3.Name.."的谷道显得无比痛快。\n事毕，"..npc1.Name.."的肉穴中被灌满了"..npc4.Name.."的精元，"..npc1.Name.."也因此获得了若干参悟……")
	me:AddMsg(wenben);me:AddMemery(wenben);npc1.LuaHelper:AddTreeExp(500 * npc3.LuaHelper:GetGLevel());npc1.LuaHelper:AddTreeExp(2000 * npc4.LuaHelper:GetGLevel());
	elseif Panding == 6 and npc3 ~= nil and npc4 ~= nil and npc3.Sex ~= npc1.Sex and npc4.Sex ~= npc1.Sex then--有男性师傅和男性师祖，对方两人都不是太监
	local wenben = me:ParseNpcStory("[rand_lable=desc_time,desc_place,desc_weather]，"..npc1.Name.."在山门[obj_action]时，被师傅"..npc3.Name.."唤去寝殿后，"..npc3.Name.."和"..npc4.Name.."一前一后将肉棒塞入了"..npc1.Name.."的小嘴与肉穴，疯狂的抽插了起来……\n事毕，"..npc1.Name.."的肉穴中被灌满了"..npc3.Name.."和"..npc4.Name.."的精元，"..npc1.Name.."也因此获得了若干参悟……")
	me:AddMsg(wenben);me:AddMemery(wenben);npc1.LuaHelper:AddTreeExp(1000 * npc3.LuaHelper:GetGLevel());npc1.LuaHelper:AddTreeExp(2000 * npc4.LuaHelper:GetGLevel());
	elseif Panding == 6 and npc3 ~= nil and npc4 ~= nil and npc3.Sex ~= npc1.Sex and npc4.Sex == npc1.Sex and npc3.PropertyMgr.BodyData:PartIsBroken("Genitals") then--有男性太监师傅和女性师祖
	local wenben = me:ParseNpcStory("[rand_lable=desc_time,desc_place,desc_weather]，"..npc1.Name.."在山门[obj_action]时，被师傅"..npc3.Name.."唤去寝殿一同侍奉"..npc4.Name.."，师徒两人一同给师祖"..npc4.Name.."舔屄使得师祖大为欢喜，将泄出的阴精分与两人食用……")
	me:AddMsg(wenben);me:AddMemery(wenben);npc1.LuaHelper:AddPracticeResource("Stage",npc4.LuaHelper:GetGLevel() * 500);npc3.LuaHelper:AddPracticeResource("Stage",npc4.LuaHelper:GetGLevel() * 500);
	elseif Panding == 6 and npc3 ~= nil and npc4 ~= nil and npc3.Sex ~= npc1.Sex and npc4.Sex == npc1.Sex then--有男性师傅和女性师祖
	local wenben = me:ParseNpcStory("[rand_lable=desc_time,desc_place,desc_weather]，"..npc1.Name.."去给师傅请安时，发现师傅"..npc3.Name.."与师祖"..npc4.Name.."正在双修，正待回避却被师傅唤住要求加入，"..npc1.Name.."拒绝不能，与师祖"..npc4.Name.."一起被师傅"..npc3.Name.."给艹了个爽。……")
	me:AddMsg(wenben);me:AddMemery(wenben);npc1.LuaHelper:AddTreeExp(1000 * npc3.LuaHelper:GetGLevel());npc1.LuaHelper:AddPracticeResource("Stage",npc4.LuaHelper:GetGLevel() * 500);
	elseif Panding == 6 and npc3 ~= nil and npc3.Sex ~= npc1.Sex and npc3.PropertyMgr.BodyData:PartIsBroken("Genitals") then--有男性师傅，但对方是太监
	local wenben = me:ParseNpcStory("[rand_lable=desc_time,desc_place,desc_weather]，"..npc1.Name.."在给师傅请安时，被师傅"..npc3.Name.."抱住猥亵了一通……")
	me:AddMsg(wenben);me:AddMemery(wenben);
	elseif Panding == 6 and npc3 ~= nil and npc3.Sex ~= npc1.Sex then--有男性师傅，对方不是太监
	local wenben = me:ParseNpcStory("[rand_lable=desc_time,desc_place,desc_weather]，"..npc1.Name.."在给师傅请安时，被欲念大起的师傅"..npc3.Name.."按在地上，干了一通……")
	me:AddMsg(wenben);me:AddMemery(wenben);npc1.LuaHelper:AddTreeExp(1000 * npc3.LuaHelper:GetGLevel());
	elseif Panding == 6 and npc3 ~= nil then--有女性师傅
	local wenben = me:ParseNpcStory("[rand_lable=desc_time,desc_place,desc_weather]，"..npc1.Name.."与师傅"..npc3.Name.."一同修炼了[obj_gong]，"..npc1.Name.."自觉修为上升了一些……")
	me:AddMsg(wenben);me:AddMemery(wenben);npc1.LuaHelper:AddPracticeResource("Stage",npc1.LuaHelper:GetGLevel() * 500);
	elseif Panding == 6 then--没有师傅
	local wenben = me:ParseNpcStory("[rand_lable=desc_time,desc_place,desc_weather]，"..npc1.Name.."看着别人因为有师傅教授导致修为突飞猛进，总希望自己也能有个师傅……")
	me:AddMsg(wenben);me:AddMemery(wenben);
	elseif Panding == 7 and zhangmen ~= nil and zhangmen.Sex ~= npc1.Sex and npc1 ~= zhangmen then
	local wenben = me:ParseNpcStory("[rand_lable=desc_time,desc_place,desc_weather]，"..npc1.Name.."在[obj_action]忽被掌门"..zhangmen.Name.."唤至房内，"..npc1.Name.."自知掌门垂涎于自己美貌已久，但身为"..SchoolMgr.Name.."弟子自是无法违背一门之主的意思……\n事毕，心满意足躺在大床上的"..zhangmen.Name.."搂着"..npc1.Name.."的肩膀，传授了"..npc1.Name.."一些修炼诀窍。")
	me:AddMsg(wenben);me:AddMemery(wenben);npc1.LuaHelper:AddTreeExp(2000 * zhangmen.LuaHelper:GetGLevel());
	elseif Panding == 8 then
	local wenben = me:ParseNpcStory("[rand_lable=desc_time,desc_place,desc_weather]，一群逃难的灾民途经"..SchoolMgr.Name.."。")
	me:AddMsg(wenben);me:TriggerStory("Suiji05");
	elseif npc1.LuaHelper:GetGLevel() > 9 and npc1.PropertyMgr.Practice.GodSoulCount < 65 then
	me:AddMsg("“这一线居然自成一情缘结，不过此结脆弱，稍稍一拉，也就散了…但这也许诉说了，天变真的不可阻止了……”\n……\n“天材地宝都准备好了，开始分神吧…”[NAME]开始了这一次的分神，分神，几乎是每个元神期的修士都必须要做的一件事，分神共计最多可达六十四次，但能够达到的却寥寥无几，原因无他，只应分神的代价越到后面越大…\n“这一次分神，应该是我分神以来最危险的一次了…”[NAME]将一颗红色的丹药含在了嘴里，一旦情况不对，立刻服下…\n一般来讲，分神一旦开始，就再也无法停下，但还有一种方式可以强行停下，那就是在其过程中吞服玄牝重生丹，强行完成重生以此来度过分神，但结果就是修为全失，不过总比死亡的结局让人更加容易接受…\n分神，就是将自己的魂魄分离一部分化作一个神念漩涡，而后往其内灌注自己的神念使其完整，最后再将其收回识海，随着分神次数的增多而导致的神念漩涡的增加，会使得识海变得也来越稳固，魂魄越来越凝实，因而后面分魂和神念的调出也会变得更加艰难…\n为什么不让神念漩涡在识海中直接成形呢？如果你想被庞大的神念漩涡直接把你的识海搅碎的话，你可以试一试…\n分神慢慢进行着，前面的步骤还很安稳，但越到后面分神的不可控因素也就越来越多，危险系数越来越大，[NAME]的面色也因为分神导致的魂魄上的痛苦而面色苍白，但她必须忍着，一旦失败，苦修作废，这种代价，不是他愿意承受的…\n时间过去了，对于旁观者来说很快，但对[NAME]来说可谓是度日如年，她紧咬着牙关，甚至牙齿都因为她那巨大的咬合力而出现了裂缝，原本摊开的手掌早已紧握，掌心已是血肉模糊，整个身子高度紧绷着，但她必须忍着…为了分神的成功……\n很快，过了三天三夜，她终于挺过了这差点让她崩溃的剧烈痛苦，识海中又多出了一枚神念漩涡，但是，相对于其他的漩涡，这一枚漩涡少了一件东西，那便是旋转，漩涡漩涡，自然会旋转，而这一枚，就孤零零的在哪里一动不动，就好像是少了最关键的动力源一样，只不过是个空壳子罢了…\n神念漩涡通过旋转可以牢牢的锁住识海与魂魄，天劫之中有的劫就是专门针对识海的，如果渡劫之际，识海强度与稳定性不够，很容易导致渡劫失败，魂飞魄散…\n“成功了…”[NAME]欣慰的笑了笑，自己的努力没有白费，然后便直接晕了过去，她是在太累了，她已经彻底到极限了，再也支撑不下去了，她此刻只想像凡人一样，好好的睡上一觉，而就在她闭上眼睛的时候，异变发生了…\n……\n“怎么软软的？我不是昏过去倒在地上了吧…而且我记得我下过命令任何人不得靠近才对…”[NAME]有些迷迷糊糊的，但是感受的头部下面的温暖与柔滑，绝对不是地板应该有的触感才对…\n“你好啊，本体，醒过来了吗…”一个和[NAME]长得神似的女子深情的看着她，而此时她也反应过来了，她自己感受到的温暖与柔滑，是人家这是大腿，换句话来讲，人家给自己膝枕了…\n“你…”[NAME]坐了起来，看着这个和自己长得极度相似的女子，有些吃惊的说不出话来，她身上的气息，和自己完全一模一样，而且刚刚她还叫自己本体，该不会…\n“不错，本体，和你想的一样，我就是你新分的分神…”她笑了笑，毫不忌讳的说出了自己的真实身份，没错，她就是[NAME]的分神，只要把她收回去，[NAME]的分神就会彻底完美，不过这样一来，她也会彻底消失…\n“本体，你可能没有察觉到，你之前在为分魂注入神念的时候，还注入了一部分自己得一部分七情六欲，正是如此，我才得以诞生，但只要你一个愿意…”分神没有把话说完，但不用说完，身为本体的[NAME]也知道结局是怎么样的……\n“本体，你也曾经是否有过自己可能喜欢女子的想法，即便只是一瞬之间……”分神问道。\n“……，记不得了，我也不晓得……”[NAME]回答道，她并没有特别清晰的记忆，因为她这一辈子都在修炼之路执着的走下去，完全没有去多想情感之事…\n“你有，但你不记得了，这一路走来岁月的冲刷让你忘记了许多，但是那一份情感却传递给了我…所以本体…我希望在彻底化作你的分神之前……来一次属于‘我’与‘我’的输入交融…可以吗？”分神依旧笑着，但话语中却多出了几分祈求，她知道最终自己还是会化作本体的分神漩涡，但在此之前，她想将自己的身影永远的留在[NAME]的记忆里，即便只是微不足道的，那么小小的一席之地…\n“……”[NAME]犹豫了，她在思考，到底要不要答应，即便不答应，她也可以收回分神，但她总觉得自己若是不答应，可能会错过一些东西，一些无比珍贵的东西…，最终他咬了咬牙：“跟我来吧……”\n“嗯…”分神很开心，真的很开心，也许是因为本身就知道自己不会长久存在，因此她更加的单纯与愿意释放自己的情绪，但又有谁知道，这背后的泪呢？\n“哎…”[NAME]挺羡慕自己的分神可以如此的释放自己的天性，但又得必有一失，作为代价就是最终会还归于本体，因此羡慕归羡慕，但是她不会想着成为她，若只是为了如此，为了暂时的释放自我，她不知年岁的苦修又是为了什么？\n她求的是大无敌，走到所有修士前面的大无敌，唯有大无敌可以开辟出属于自己的大自在之路，大超脱之路，打那个时候，她就可以彻底脱下那无情冷面，永恒的逍遥自在…\n短暂的生命有着短暂的生命可以创造的奇迹与花火，长久的岁月也有长久的岁月所独属的韵味和沉香，每个个体，都有着自己的追逐与梦想，只是一路上走过，太多的人早已没了当初的锐利与锋芒…\n走了一刻钟，两人从[NAME]的修炼室走到了自己的卧室，卧室不大吗，装饰也算不上好，甚至比不上金丹修士的卧室配置，也许是她清冷惯了，对住所的要求也没有多少，记得这间屋子，她从结丹，住到了现在…\n“脱了衣服吧…”[NAME]坐到床上，准备开始宽衣解带，而当她准备脱的时候，一双玉手制止了她，她有些诧异，随后耳边传来一阵热气：“让我来…帮你脱吧…，还有，我想在上面，可以吗？”\n说完，[NAME]的耳朵就被含住了，传来了一阵很奇怪的感觉…满脸通红，扭过头，闭上眼睛，意味着她算是默认了，分神自然知晓其意，慢慢的为她宽衣解带，在此期间当然也少不了占便宜，摸摸这里，捏捏哪里，舔舔上面，尝尝下面，反正能占的便宜全占了，随后分魂也为自己完成了宽衣解带…\n“本体，你的味道可真好啊…”分神与她对视着，笑着调戏道，闻言她稍微扭了扭头，不敢与之对视，害羞了…\n“哼哼……”分神轻笑了两声，然后将她的左手臂抬了起来，然后又将自己的蜜穴掰开，露出了里面粉嫩的软肉，看着十分诱人，也许是因为前面做了些前戏的原因，现在分神的蜜穴里，已经变得晶莹剔透，像极了花瓣沾染了朝露，诱人，还散发着一股奇异的清香…\n“嗯…嗯……！”她拿着[NAME]的手臂，坐了上去，开始前后摩擦了起来，分开的蜜穴在左手手臂上来来回回，感受着手臂上恰到好处的温度与如玉般的质感，身为分神的她不由得呻吟了起来，这呻吟声也影响到了她的本体，[NAME]的下面，也开始分泌出了爱液…来润滑蜜穴…\n这样过了小半刻钟，[NAME]的左臂上已经满是爱液，淫糜的气息渐渐出现在了房间里慢慢的四散开来…\n又过了一刻钟，分神迎来了第一波的小高潮，让[NAME]的身上还有她自己的大腿内侧都沾染上了不少的爱液和阴精\n“来，本体，将你的手指放进来吧…”分神坐在[NAME]的大腿上，将本体的左手的中指与无名指插进了自己的菊花之中，右手则将其导进了蜜穴中，下面的两个嘴巴被自己本体塞住的感觉，这种感觉很奇妙，她很喜欢：“本体，不要像木头人偶一样一动不动啊，手指抽插起来，不然完全没有感觉吗…”\n“嗯…”她弱弱的回应了一声，相对于与分神的天性开放，身为本体的[NAME]却因为清规戒律显得比较的保守，不过既然她的分神都这样说了，她还是开始慢慢的动了起来…\n“本体再快点…嗯啊！再快点…再快点就更舒服了…”随着[NAME]的抽动，分神渐渐地感受到了快感，这让她很是享受，随后她便不再说话，因为她直接与身为本体的[NAME]深情热吻了起来，她紧紧的抱着[NAME]，享受着这甜蜜的时光，口中不断交换着唾液，两人唇瓣分开片刻拉出的银丝，显得是如此的唯美诱人…\n过了好一会儿，分神迎来了她的第二次高潮，这一次高潮不同于前面的一次小高潮，这一次的吹潮不但打湿了床单，甚至还让其积攒起了一个小小的水汪，显得十分的淫荡。\n“呵…呵…，本体，有尝过…尝过自己的味道…吗？”分神喘了两口气，笑问道。\n“没有”\n“那么现在来尝尝吧…”分神站了起来，将自己沾满了阴精淫水的湿漉漉的下面贴到了[NAME]的嘴前，显得十分淫荡，由于清规戒律，[NAME]的思绪开始挣扎，分神看到如此的本体，催促了一下：“来尝尝吗，反正都是自己的味道，况且又没有别人知道…”\n“嗯…”最终[NAME]还是妥协了，这一妥协不但代表着现在，也代表着她开始慢慢放下了心中的清规戒律，这些清规戒律或许将来仍是[NAME]心中举足轻重的部分，但绝对不会再是绝对的意志了…\n[NAME]像是一只偷腥的小猫一般，舌尖轻轻地点了一下，然后又快速收了回来，好似生怕被发现一样，那个味道，有点腥，又有点咸咸的，尝试禁果的滋味让她感到很害羞，她本以为自己已经准备好了一切，但现在看来，还是有些不够…\n“哼哼…本体，你真可爱…”分神掩嘴笑了笑，看到自己的本体这一副像是犯了错的孩子一样的表情，她就忍不住笑了，同时，她直接弯了一下腰，用一只手把自己的蜜穴尽可能的掰开贴在了[NAME]的嘴上，并且用另一只手将本体的头部按在自己的股间……\n“嗯……！”[NAME]有些始料未及，她本想推开她的分神，但不知为何，她却选择了妥协，舌头悄悄地伸出去点一下…然后再点一下，像是打地鼠游戏里面的地鼠一样，不过这个频率在慢慢的加快，这种一点一点的刺激，让分神觉得下面好痒，但却又不能去挠，很折磨，但也很诱人……\n就好似罂栗……\n时间慢慢的过去，也许是因为气氛的渲染，慢慢的[NAME]的嘴巴从原本的轻点慢慢变成了舔舐，再到后来甚至吮吸了起来，而她的手也不甘寂寞，一只手抽插着分神的菊花，一只手玩弄着自己的蜜穴，下面更是水流成群，多年的禁欲使得这一次欲望的释放变得无比的强烈，阀门一旦打开便再也停不下来了…\n“本…本体……，我…我……我快……快去了！啊啊啊啊——！”一瞬之间，分神达到了第三次高潮，这次吹潮比前面两次更猛烈，由于她是站着的，而[NAME]则是跪坐在哪里舔舐着她的蜜雪，所以，理所当然的，[NAME]直接被这一次的高潮淋了个透，粘粘的阴精淫水让她看起来显得格外的淫荡。\n“接下来…我们两个一起爽吧…”这一次的[NAME]，变得主动了，甚至主动向着分神提出了曾今自己连想都不敢想的提议，她甚至感觉自己是不是疯了，不过也好，就让自己疯一回吧，把前面所有岁月里积攒的执念与压力，在这一次的疯狂中，彻底的释放出去吧！\n“嗯，不过，我要在上面……”分神自然同意，当然，她要在上面的心，依旧没有变化…\n[NAME]躺在床上，分神则趴在[NAME]身上，呈现69姿态，两人的胸部都紧贴着对方的腰部，那柔软的触觉以及两点硬硬的感觉，让她们进一步感受了两人的链接…\n她们相互舔舐吮吸着对方的蜜穴，玩弄着对方的后庭，挑逗着对方的阴蒂，他们下面的爱液不间断的流出来，她们从原来一人压着一人的姿势变成了侧躺，在变成人压人，就这样不断地反复，期间的呻吟更是毫不间断，一刻钟，两刻钟…，两人都快忘记时间的流动了，她们真的希望这一刻可以永痕，但万事总有终结的时刻……\n“嗯……咿呀！”也不知道是谁的一声呻吟，致使两人同时达到了巅峰，一段时间的疯狂过后，自然是倦意席卷了她们的意识，对于本体的[NAME]来说这不过是一次昏睡…但对于分神来说，这却相当于是是生命的终结，对两人而言，这很可能是永恒的离别……\n“本体…我真的，很不想走……”分神笑了笑，但眼泪却落了下来，笑的哭了，她觉得自己很幸福，至少在那一刻，但她也觉得自己很悲哀，没有办法和自己所爱的人天长地久…\n[NAME]没有说一句话，只是泪水…最终还是没有忍住，有些时候无言，更胜言语所能表达的，分神看到这副模样的本体的，也没再说什么，只是温柔的抚摸着本体的脸颊，而在[NAME]在昏睡过去的最后一刻，她看见了…她的分神已经开始化作点点星光，飞向她的身体……\n[NAME]闭上了眼睛，什么都看不见了，嘴角上挑露出了苦涩的笑容，即便进入了睡梦，泪水依旧止不住的流下来…\n…一觉过后…\n“这是…”[NAME]看着她的分神再次出现在了她的面前，她很惊讶，但自己的神念漩涡的确没有出现异常，而再看看周围，又多出了一群女子，样貌都与现在或者过去的她异常的神似…\n“呜呜…啊…！我还以为再也见不到你了…！呜呜…”[NAME]直接冲上去保住了为首的，也就是那个和他有过一夜狂欢的分神，放肆的大哭了出来…\n“乖……”分神温柔的抚摸着她的头，就像是母亲一样……\n“什么都别说了！姐姐们！一起上！脱光她！让她半年下不了床！”一直小萝莉看着这一幕，嘟起了嘴，感觉到自己好像被冷落了，立刻就不爽的指着[NAME]，向着后面的女子们号令道……\n萝莉一声令下，一群女子立刻群起而“攻”之，自此，[NAME]的后“攻”团正式成立，你问谁是受？自然是她咯…至于她们是谁，谁知道呢？不，应该说，谁不知道呢？\n——\n“怎么可能！松散的结紧了也就罢了！为何如今这根红线却自己给自己打上了如此之多的情缘结！”\n“即便是天变！也绝不至于此！莫不成是哪位大能出手，截了天之道！”\n……")
	me:DropAwardItem("Item_yinjin5",(me:RandomInt(5,10)));npc1.LuaHelper:AddTreeExp(me:RandomInt(1000000,5000000));npc1.PropertyMgr.Practice.GodSoulCount = npc1.PropertyMgr.Practice.GodSoulCount + 1;
	elseif npc1.PropertyMgr:CheckFeature("Tianyuannvquan") and npc1.LuaHelper:GetModifierStack("Shouyun") == 0 then
	me:TriggerStory("Suiji11");
	else
	Zhuanqian = me:RandomInt(50,200);
	local wenben = me:ParseNpcStory(string.format(XT("[rand_lable=desc_time,desc_place,desc_weather]，"..mpName.."弟子"..NanName.."见得"..npc1.Name.."便仿佛丢了魂儿一般，"..npc1.Name.."也算不得什么贞洁烈女，见状即上前谈好价格一次白银%s两，"..NanName.."大喜之余，立刻付了银钱钱与"..npc1.Name.."欢好了一番。"), tostring(Zhuanqian)));
	me:AddMsg(wenben);me:AddMemery(wenben);
	me:AddModifier("Qian");
	me.npcObj.PropertyMgr:FindModifier("Qian"):UpdateStack(Zhuanqian - 1);
	end
end

function Hudong:shiqi1000()
npc1 = ThingMgr:FindThingByID(me.npcObj.ID)
me:AddMsg("[NAME]被宗门放弃了，这对方心满意足的离开了")
ThingMgr:RemoveThing(npc1,false,true)
end

function Hudong:shiqi1001()
me:AddMsg(""..SchoolMgr.Name.."岂会因为区区散修的威胁便放弃宗门弟子，于是这群散修在恼怒之余，向"..SchoolMgr.Name.."发起了进攻。")
	renshu = me:RandomInt(10,15);
	while renshu > 0 do
		local zhongzu = WorldLua:RandomInt(1,#zhongzubiaoge+1);
		local npc = CS.XiaWorld.NpcRandomMechine.RandomNpc(zhongzubiaoge[zhongzu],g_emNpcSex.Male);
		npc:AddTitle("色欲熏心的男修");
		CS.XiaWorld.NpcMgr.Instance:AddNpc(npc,npc.LuaHelper:RandomInt(240,280),Map,CS.XiaWorld.Fight.g_emFightCamp.Enemy);
		CS.XiaWorld.ThingMgr.Instance:EquptNpc(npc,npc.LuaHelper:RandomInt(1,10),CS.XiaWorld.g_emNpcRichLable.Richest);
		npc.FightBody.AttackWait = 1;
		npc.FightBody.AttackTime = 10000;
		npc.FightBody.AutoNext = true;
		npc.FightBody.IsAttacker = true;
		renshu = renshu - 1
	end
end

function Hudong:shiqi1002()
	if world:GetWorldFlag(1712) > 10 then
	me:AddMsg("天元女拳宗修士们在她们长老的带领下，愤怒的向这个压迫女修而不自省的人渣门派发起了冲锋")
	Hudong:diren001()
	else
	me:AddMsg("天元女拳宗修士们愤怒的向这个压迫女修而不自省的人渣门派发起了冲锋")
	end
	me:AddSchoolRelation(170,-100);
Hudong:diren002()
end

function Hudong:shiqi1003()
npc1 = ThingMgr:FindThingByID(me.npcObj.ID)
local npc = CS.XiaWorld.NpcRandomMechine.RandomNpc("Human",g_emNpcSex.Female);
	if string.find(StoryEx.input,"谈") ~= nil or string.find(StoryEx.input,"话") ~= nil or string.find(StoryEx.input,"聊") ~= nil or string.find(StoryEx.input,"说") ~= nil or string.find(StoryEx.input,"讲") ~= nil then
	me:AddMsg("[NAME]与其闲聊了几句，便转身离开了……");
	elseif string.find(StoryEx.input,"奸") ~= nil or string.find(StoryEx.input,"强") or string.find(StoryEx.input,"辱") or string.find(StoryEx.input,"抓") or string.find(StoryEx.input,"捕") or string.find(StoryEx.input,"俘") or string.find(StoryEx.input,"奴") or string.find(StoryEx.input,"掳") then
		if npc1.GongKind == g_emGongKind.Body then
		me:AddMsg("[NAME]垂涎于对方的美貌，直接将对方擒入宗门百般奸淫，凡人女子自是万万不可能招架得住炼体者的折腾，这名女子被[NAME]活活操弄致死……");
		npc1.PropertyMgr.Practice.BodyPracticeData:AddQuenchingItem("Item_yinjin",1);
		npc1.PropertyMgr.Practice.BodyPracticeData:AddQuenchingItem("Item_Nvxiuluohong",1);
		npc1.Needs:AddNeedValue(CS.XiaWorld.g_emNeedType.Practice,100)
		else
		me:AddMsg("[NAME]垂涎于对方的美貌，对方被[NAME]打晕后拖入僻静之地，一番奸淫侮辱后，[NAME]将其掳回山门作为泄欲的女奴……");
		CS.XiaWorld.NpcMgr.Instance:AddNpc(npc,npc.LuaHelper:RandomInt(240,280),Map,CS.XiaWorld.Fight.g_emFightCamp.Player);
		CS.XiaWorld.ThingMgr.Instance:EquptNpc(npc,0,CS.XiaWorld.g_emNpcRichLable.Richest);
		npc:ChangeRank(g_emNpcRank.Worker);
		npc1.PropertyMgr.RelationData:AddRelationShip(npc,"Luding2");
		npc.PropertyMgr:AddFeature("Pogua");npc.PropertyMgr:AddFeature("BeautifulFace2");
		end
	elseif string.find(StoryEx.input,"爱") or string.find(StoryEx.input,"婚") or string.find(StoryEx.input,"娶") then
		if npc1.IsDisciple then
		me:AddMsg("被身为仙门弟子的"..npc1.Name.."求娶，此等仙缘"..npc.Name.."自然不会拒绝，徘徊于"..SchoolMgr.Name.."周边的"..npc.Name.."本就打算靠着自己一身美貌的皮囊求得仙缘，能被仙家弟子娶回山门自然是无上的妙事\n"..npc.Name.."嫁给了"..npc1.Name.."，并拜入了"..SchoolMgr.Name.."……");
		CS.XiaWorld.NpcMgr.Instance:AddNpc(npc,npc.LuaHelper:RandomInt(240,280),Map,CS.XiaWorld.Fight.g_emFightCamp.Player);
		CS.XiaWorld.ThingMgr.Instance:EquptNpc(npc,0,CS.XiaWorld.g_emNpcRichLable.Richest);
		SchoolMgr:UpNpc2Disciple(npc)
		npc1.PropertyMgr.RelationData:AddRelationShip(npc,"Spouse");npc.PropertyMgr:AddFeature("BeautifulFace2");
		else
		me:AddMsg(""..npc.Name.."拒绝了[NAME]的示爱，表示[NAME]是个好人，但是双方并不合适……");
		end
	elseif string.find(StoryEx.input,"离") or string.find(StoryEx.input,"去") then
	me:AddMsg("[NAME]与其闲聊了几句，便转身离开了……");
	else
	me:AddMsg("[NAME]不能"..StoryEx.input.."对方");
	me:TriggerStory("Suiji03");
	end
end

function Hudong:shiqi1004()
NvName = NpcMgr:GetRandomFullName("Human",CS.XiaWorld.g_emNpcSex.Female)
me:AddMsg("[NAME]的拒绝让蛇妖完全崩溃了，自己苦修这万年唯一的目标便是与当年女修"..NvName.."的转世双宿双栖。\n而今，[NAME]身为"..NvName.."转世，却以：“人和蛇搞一起也太尼玛恶心拉，鉄子。”的理由拒绝了它，那这万年的修行还有什么意义？\n蛇妖恼怒之下自行碎丹求死，却未曾想那无尽的怒意和碎妖单时的决绝，让其竟然突破了最后一层阻碍，化身为龙……\n然而这一切又有什么意义呢，哀大莫过于心死，蛇妖心已死，得这龙躯又能如何，一时间……心魔入体，化龙的蛇妖被心魔所惑，决定不能同生，至少可以共死……")
GameUlt.CallBoss("Boss_Long", nil,0);
end

function Hudong:shiqi1005()
npc1 = ThingMgr:FindThingByID(me.npcObj.ID)
me:AddMsg("[NAME]答应了蛇妖，让它在钻一次黄鳝洞，只见蛇妖幻化成一条纯白色的小蛇……\n事毕，蛇妖浑身金光大作，褪下那一身凡胎化身为龙，再次与[NAME]于云端欢好\n事又毕，神龙携[NAME]御风而去……")
World.Weather:BeginWeather("LightningStorm", true, 0, true);
me:DropAwardItem("Item_MiBao_SLND",1);
ThingMgr:RemoveThing(npc1,false,true)
end

function Hudong:shiqi1006()
npc1 = ThingMgr:FindThingByID(me.npcObj.ID)
	if StoryEx.input == "交谈" or StoryEx.input == "闲聊" or StoryEx.input == "聊天" then
	me:AddMsg("[NAME]与灾民闲聊了几句，便将其驱离了"..SchoolMgr.Name.."……");
	elseif StoryEx.input == "布施" or StoryEx.input == "帮助" or StoryEx.input == "施舍" then
		if CS.XiaWorld.OutspreadMgr.Instance:CanCostItem("Item_Flour", 100) then
		me:AddMsg("[NAME]对灾民们的苦难动了恻隐之心，赠与了灾民一百单位的面粉后，灾民们千恩万谢的一路叩拜着离开了"..SchoolMgr.Name.."。\n[NAME]的仁慈得到了上苍的赞赏，"..SchoolMgr.Name.."乐善好施的名声也传播开了。");
		CS.XiaWorld.OutspreadMgr.Instance:CostItem(CS.XiaWorld.OutspreadMgr.Region(),"Item_Flour", 100, nil);me:AddSchoolScore(2,100);me:AddPenalty(-1);
		elseif CS.XiaWorld.OutspreadMgr.Instance:CanCostItem("Item_Wheat", 100) then
		me:AddMsg("[NAME]对灾民们的苦难动了恻隐之心，赠与了灾民一百单位的小麦后，灾民们千恩万谢的一路叩拜着离开了"..SchoolMgr.Name.."。\n[NAME]的仁慈得到了上苍的赞赏，"..SchoolMgr.Name.."乐善好施的名声也传播开了。");
		CS.XiaWorld.OutspreadMgr.Instance:CostItem(CS.XiaWorld.OutspreadMgr.Region(),"Item_Wheat", 100, nil);me:AddSchoolScore(2,100);me:AddPenalty(-1);
		else
		me:AddMsg("[NAME]对灾民们的苦难动了恻隐之心，然而门中也没有多余的小麦面粉……只能将灾民们驱离了"..SchoolMgr.Name.."。");
		end
	elseif StoryEx.input == "肉身布施" or StoryEx.input == "SEX" or StoryEx.input == "送屄" then
		if npc1.Sex == CS.XiaWorld.g_emNpcSex.Female then
		me:AddMsg("[NAME]对灾民们的苦难动了恻隐之心，虽然没有赠与对方物资食物，但是用身体给与了他们关怀让其感受到"..SchoolMgr.Name.."女菩萨的“温度”。\n灾民的欲望得到满足后，一部分男性灾民们觉得这真特么是个好地方，纷纷决定加入"..SchoolMgr.Name.."成为[NAME]的奴役公狗，[NAME]的仁慈得到了上苍的赞赏，但是"..SchoolMgr.Name.."的名声因为灾民中的部分未加入我宗的女性四处败坏而降低了。");
		me:AddSchoolScore(2,-100);me:AddPenalty(-1);npc1.LuaHelper:AddModifier("Luding");me.npcObj.PropertyMgr:FindModifier("Luding"):UpdateStack(me:RandomInt(3,10));
		else
		me:AddMsg("[NAME]对灾民们的苦难动了恻隐之心，虽然没有赠与对方物资食物，但是用身体给与了他们关怀让其感受到"..SchoolMgr.Name.."男神仙的“长度”。\n灾民的欲望得到满足后，一部分女性灾民们觉得这真特么是个好地方，纷纷决定加入"..SchoolMgr.Name.."成为[NAME]的奴役母狗，[NAME]的仁慈得到了上苍的赞赏，但是"..SchoolMgr.Name.."的名声因为灾民中的部分未加入我宗的男性四处败坏而降低了。");
		me:AddSchoolScore(2,-100);me:AddPenalty(-1);npc1.LuaHelper:AddModifier("Luding2");me.npcObj.PropertyMgr:FindModifier("Luding2"):UpdateStack(me:RandomInt(3,10));
		end
	elseif StoryEx.input == "杀害" or StoryEx.input == "宰杀" or StoryEx.input == "捕猎" or StoryEx.input == "狩猎" or StoryEx.input == "屠杀" or StoryEx.input == "屠宰" or StoryEx.input == "吃" then
		me:AddMsg("[NAME]将灾民全部屠宰杀害运回山中作为储备粮食……");
		me:AddPenalty(10);me:DropAwardItem("Item_HumanMeat",300);
	elseif StoryEx.input == "掳掠" or StoryEx.input == "抓捕" or StoryEx.input == "奴役" or StoryEx.input == "囚禁" or StoryEx.input == "俘虏" then
		if npc1.GongKind == g_emGongKind.Body then
		me:AddMsg("[NAME]将灾民统统掳回了宗门榨取至死，榨出的精元及落后则被[NAME]收集起来用于修炼……");
		npc1.PropertyMgr.Practice.BodyPracticeData:AddQuenchingItem("Item_yinjin",5);
		npc1.PropertyMgr.Practice.BodyPracticeData:AddQuenchingItem("Item_yangjin",5);
		npc1.PropertyMgr.Practice.BodyPracticeData:AddQuenchingItem("Item_Nvxiuluohong",5);
		npc1.Needs:AddNeedValue(CS.XiaWorld.g_emNeedType.Practice,500)
		else
		me:AddMsg("[NAME]把灾民们抓入"..SchoolMgr.Name.."囚禁起来以做炉鼎享用……");
		npc1.LuaHelper:AddModifier("Luding");me.npcObj.PropertyMgr:FindModifier("Luding"):UpdateStack(me:RandomInt(3,10));
		npc1.LuaHelper:AddModifier("Luding2");me.npcObj.PropertyMgr:FindModifier("Luding2"):UpdateStack(me:RandomInt(3,10));
		end
	elseif StoryEx.input == "离开" then
	me:AddMsg("[NAME]与灾民闲聊了几句，便将其驱离了"..SchoolMgr.Name.."……");
	else
	me:AddMsg("[NAME]不能"..StoryEx.input.."对方");
	me:TriggerStory("Suiji05");
	end
end

function Hudong:shiqi1007()
local zhongzu = WorldLua:RandomInt(1,#zhongzubiaoge+1);
npc = CS.XiaWorld.NpcRandomMechine.RandomNpc(zhongzubiaoge[zhongzu],g_emNpcSex.Male);
npc.LuaHelper:AddRandomTitle(-1, XT("肆虐天下所得"), 4);
local ch = npc:GetCurTitle().title
me:AddMsg("老道一身修为着实不凡，但观其行便能知晓其不是什么好人，明明有着不俗的修为，却如此耍弄摧残凡人。\n[NAME]盛怒之下阻住了老道去路……\n却见老道冷笑道：“好好好，小小"..SchoolMgr.Name.."，也敢管我"..ch..npc.Name.."的闲事，小辈，今日便是你"..SchoolMgr.Name.."灭门之日！”")
CS.XiaWorld.NpcMgr.Instance:AddNpc(npc,npc.LuaHelper:RandomInt(240,280),Map,CS.XiaWorld.Fight.g_emFightCamp.Enemy);
CS.XiaWorld.ThingMgr.Instance:EquptNpc(npc,12,CS.XiaWorld.g_emNpcRichLable.Richest);
Hudong:shanchuzhuangbei()
local LQZD = WorldLua:RandomInt(3000000,9000000)
npc.PropertyMgr:SetPropertyOverwrite("NpcLingMaxValue",LQZD)
local fabao = CS.XiaWorld.ItemRandomMachine.RandomFabao(CS.XiaWorld.g_emItemLable.FightFabao, 12, 12,100,"Item_WeaponSword",nil,0,true)
local BS1 = WorldLua:RandomInt(1, 3);
local GS = WorldLua:RandomInt(1000, 9999);
local FBMZ = "饮血邪剑"
fabao:SetName(FBMZ)
fabao:SetDesc("由"..npc.Name.."以万灵血所炼制的邪恶秘剑，作为邪宝，自是人人可用……")
npc:EquipItem(fabao)
fabao:AddLing(fabao.MaxLing)
fabao.Fabao:AddAbilityData({Kind = CS.XiaWorld.Fight.g_emFabaoSpecialAbility.MultiKillAddPowerUp,Desc = "邪宝："..FBMZ..": 每击杀一个生灵提高"..BS1.."倍伤害，最高"..GS.."层",nParam1= GS,fParam1 = BS1})
npc:AddLing(npc.MaxLing)
npc.PropertyMgr.Age = 25
npc.FightBody.AttackWait = 1;
npc.FightBody.AttackTime = 10000;
npc.FightBody.AutoNext = true;
npc.FightBody.IsAttacker = true;
npc:AddModifier("Wanxue");
npc.PropertyMgr:AddModifier("Modifier_SpNpc_BasePropertie")
npc.PropertyMgr:AddModifier("Modifier_SpNpc_BaseFightPropertie");
npc.PropertyMgr:AddModifier("Modifier_SpNpc_Ling");
npc.PropertyMgr:AddModifier("Modifier_SpNpc_Shield");
npc.PropertyMgr:AddModifier("Modifier_SpNpc_FabaoAtk");
npc.PropertyMgr:AddModifier("Modifier_SpNpc_FabaoSpeed");
npc.PropertyMgr:AddModifier("Modifier_SpNpc_FabaoDisp");
end

function Hudong:shiqi1008()
me:AddMsg("老道虽相貌猥琐，但一身修为着实不凡，而另一方的只是普普通通的凡人母女，修真界弱肉强食但凡智力没问题的人，都知道应该如何选择……\n[NAME]转身回了门派，任由那对母女被这老道追索戏耍……")
end

function Hudong:shiqi1009()
npc1 = ThingMgr:FindThingByID(me.npcObj.ID)
local zhongzu = WorldLua:RandomInt(2,#zhongzubiaoge+1);
local npc = CS.XiaWorld.NpcRandomMechine.RandomNpc(zhongzubiaoge[zhongzu],g_emNpcSex.Male);
nanxingrenshu = 0
nvxingrenshu = 0
local targets = Map.Things:GetNpcsLua(
	function(n)
		return n.IsPlayerThing ;
	end);
	for i = 0, targets.Count-1, 1 do
	local target = targets[i];
		if target ~= nil then
			if target.Sex == CS.XiaWorld.g_emNpcSex.Female then
			target.PropertyMgr.RelationData:AddRelationShip(npc1,"Luding2");
			nvxingrenshu = nvxingrenshu + 1
			else
			ThingMgr:RemoveThing(target,false,true)
			nanxingrenshu = nanxingrenshu + 1
			end
		end
	end
me:AddMsg("众人将[NAME]献给了"..npc.Name.."并跪地表示臣服于"..npc.Name.."……");
npc.PropertyMgr.RelationData:RemoveRelationShip(npc1,"Luding2");
npc.PropertyMgr.RelationData:AddRelationShip(npc1,"Spouse");
nvxingrenshu = nvxingrenshu - 1
	if nvxingrenshu > 0 then
	me:AddMsg(""..npc.Name.."看了一眼那剩余的"..nvxingrenshu.."个女子，大嘴一咧道：“至于你……，虽不如[NAME]那样天姿国色，但是充作性奴炉鼎还是可以的！”");
	end
	if nanxingrenshu > 0 then
	me:AddMsg(""..npc.Name.."又瞥了一眼那"..nanxingrenshu.."个跪在地上战战兢兢磕头求饶的男子，残酷的冷笑了一声：“男人，就没什么用了，哦，还是可以吃的……”\n言毕便将那"..nanxingrenshu.."个人全部屠宰切块了……");
	npc1.LuaHelper:DropAwardItem("Item_HumanMeat",50*nanxingrenshu);
	end
CS.XiaWorld.ThingMgr.Instance:EquptNpc(npc,1,CS.XiaWorld.g_emNpcRichLable.Richest);
CS.XiaWorld.NpcMgr.Instance:AddNpc(npc,npc1.Key+1,Map,CS.XiaWorld.Fight.g_emFightCamp.Player);
end

function Hudong:shiqi1010()
npc1 = ThingMgr:FindThingByID(me.npcObj.ID)
local zhongzu = WorldLua:RandomInt(1,#zhongzubiaoge+1);
local npc = CS.XiaWorld.NpcRandomMechine.RandomNpc(zhongzubiaoge[zhongzu],g_emNpcSex.Male);
CS.XiaWorld.ThingMgr.Instance:EquptNpc(npc,1,CS.XiaWorld.g_emNpcRichLable.Richest);
CS.XiaWorld.NpcMgr.Instance:AddNpc(npc,npc.LuaHelper:RandomInt(240,280),Map,CS.XiaWorld.Fight.g_emFightCamp.Enemy);
me:AddMsg("众人拒绝了"..npc.Name.."的要求，恼怒的"..npc.Name.."向众人发起了攻击。");
npc.FightBody.AttackWait = 1;
npc.FightBody.AttackTime = 10000;
npc.FightBody.AutoNext = true;
npc.FightBody.IsAttacker = true;
end

function Hudong:shiqi1011()
	me:AddMsg("只见[NAME]大笑三声道：吾辈是要修仙得道之人，这小小南坪安家算个什么东西！\n[NAME]将这一对夫妇收留了下来");
	local npc1 = CS.XiaWorld.NpcRandomMechine.RandomNpc("Human",g_emNpcSex.Male);
	CS.XiaWorld.NpcMgr.Instance:AddNpc(npc1,npc1.LuaHelper:RandomInt(240,280),Map,CS.XiaWorld.Fight.g_emFightCamp.Player);
	CS.XiaWorld.ThingMgr.Instance:EquptNpc(npc1,0,CS.XiaWorld.g_emNpcRichLable.Richest);
	local npc2 = CS.XiaWorld.NpcRandomMechine.RandomNpc("Human",g_emNpcSex.Female);
	CS.XiaWorld.NpcMgr.Instance:AddNpc(npc2,npc2.LuaHelper:RandomInt(240,280),Map,CS.XiaWorld.Fight.g_emFightCamp.Player);
	CS.XiaWorld.ThingMgr.Instance:EquptNpc(npc2,0,CS.XiaWorld.g_emNpcRichLable.Richest);
	npc1.PropertyMgr:AddAge(-npc1.Age + 22);
	npc2.PropertyMgr:AddAge(-npc2.Age + 18);
	npc2.PropertyMgr:AddFeature("Pogua");
	npc2.PropertyMgr:AddFeature("BeautifulFace2");
	npc1:ChangeRank(g_emNpcRank.Worker);
	npc2:ChangeRank(g_emNpcRank.Worker);
	npc1.PropertyMgr.RelationData:AddRelationShip(npc2,"Spouse");
end

function Hudong:shiqi1012()
	me:AddMsg("[NAME]暗道一句：南坪村安家我一个山中凡夫可惹不起，给了这对夫妇一碗水，便要求他们离开了");
end

function Hudong:shiqi1013()
npc1 = ThingMgr:FindThingByID(me.npcObj.ID)
me:AddMsg("[NAME]答应了荆棘宫丝，成为了荆棘宫丝的追随者，跟随随着荆棘宫丝离开了……")
world:SetWorldFlag(1705,6)
ThingMgr:RemoveThing(npc1,false,true)
end

function Hudong:shiqi1014()
npc1 = ThingMgr:FindThingByID(me.npcObj.ID)
me:AddMsg("[NAME]拒绝了荆棘宫丝，对方却仿佛更加高兴了，声若雷鸣的笑道：“资本家，呸，爱国人民企业家，呸……我荆棘宫丝看上的人，不管你从不从，你都是本尊的人了！\n言毕便将一个印记打入了[NAME]眉心后转身离去了。”")
world:SetWorldFlag(1705,6)
npc1:AddModifier("Ouxianglianxishen1")
end

function Hudong:shiqi1015()
npc1 = ThingMgr:FindThingByID(me.npcObj.ID)
	if me:GetSex() > 1 and npc1.PropertyMgr:CheckFeature("BeautifulFace2") then
	me:AddMsg("[NAME]路过天元村，便被一群女拳宗弟子围住，他们对着[NAME]指指点点的说着什么“婚驴”，“扭曲男权下的恶臭审美”，“一眼就能看出没什么涵养”等等攻击性词汇，仿佛[NAME]罪大恶极十恶不赦一般，然而[NAME]并没有做任何不好的事情，只不过是长得漂亮些，便要被她们这般诋毁，[NAME]懒得和她们一般见识，头也不回的直接离开了这个疯狗的聚集地。")
	me:AddSchoolRelation(170,-100);
	elseif me:GetSex() > 1 then
	me:DropAwardItemFromCache(story.PlaceProduce, 1, me:RandomInt(1, 3));
	elseif npc1.RaceDefName ~= "Human" then
	me:AddMsg("[NAME]来到天元村，发现家家户户的养狗杀狗，正打算上前买些香肉回门派，还未等其开口，便是见到大姑娘小媳妇面带笑意的的围了过来，听为首的女子惊喜道：“天哪，洋大人，呸，妖大人，妖大人我们要给你生小妖怪……”，众人和声，言毕，便脱光了衣服与[NAME]滚作一团\n事毕，[NAME]带着此地的特产美滋滋的回了门派。")
	me:DropAwardItemFromCache(story.PlaceProduce, 1, me:RandomInt(1, 3));me:AddSchoolRelation(170,200);
		if SchoolMgr:IsGongUnLocked("Body_Gong_nvquan") == false then
		me:AddMsg("[NAME]刚离开村口，发现昨日那耐力最持久的天元村女子追了上来，塞给了[NAME]一本功法秘籍……")
		me:UnLockGong("Body_Gong_nvquan");
		end
	else
	me:AddMsg("[NAME]来到天元村，发现家家户户的养狗杀狗，正打算上前买些香肉回门派，还未等其开口，便是见到大姑娘小媳妇面色不善的围了过来，听为首的女子大声呵斥道：“滚出我们天元村……”，众人和声，[NAME]见事不妙，转身便离开了天元村。")
	me:AddSchoolRelation(170,-50);
	end
end

function Hudong:diren001()
	local zhongzu = WorldLua:RandomInt(1,#zhongzubiaoge+1);
	npc = CS.XiaWorld.NpcRandomMechine.RandomNpc("Human",g_emNpcSex.Female);
	npc:AddTitle("天元女拳宗长老");
	CS.XiaWorld.NpcMgr.Instance:AddNpc(npc,npc.LuaHelper:RandomInt(240,280),Map,CS.XiaWorld.Fight.g_emFightCamp.Enemy);
	CS.XiaWorld.ThingMgr.Instance:EquptNpc(npc,12,CS.XiaWorld.g_emNpcRichLable.Richest);
	npc.PropertyMgr:AddFeature("Tianyuannvquan");
	Hudong:shanchuzhuangbei()
	local FBSL = WorldLua:RandomInt(1,6)
	local LQZD = WorldLua:RandomInt(3000000,9000000)
	npc.PropertyMgr:SetPropertyOverwrite("NpcFight_FabaoNum",FBSL)
	npc.PropertyMgr:SetPropertyOverwrite("NpcLingMaxValue",LQZD)
	for i=1,FBSL,1 do
	local fabao = CS.XiaWorld.ItemRandomMachine.RandomFabao(CS.XiaWorld.g_emItemLable.FightFabao, 12, 12,100,"Item_Shuangtoulong",nil,0,true)
	fabao:SetName(npc.Name.."的女拳双头龙")
	npc:EquipItem(fabao)
	fabao:AddLing(fabao.MaxLing)
	end
	npc:AddLing(npc.MaxLing)
	npc.FightBody.AttackWait = 1;
	npc.FightBody.AttackTime = 10000;
	npc.FightBody.AutoNext = true;
	npc.FightBody.IsAttacker = true;
end

function Hudong:diren002()
	renshu = me:RandomInt(10,20);
	while renshu > 0 do
	local zhongzu = WorldLua:RandomInt(1,#zhongzubiaoge+1);
	local npc = CS.XiaWorld.NpcRandomMechine.RandomNpc("Human",g_emNpcSex.Female);
	npc:AddTitle("天元女拳宗弟子");
	npc.PropertyMgr:AddFeature("Tianyuannvquan");
	CS.XiaWorld.NpcMgr.Instance:AddNpc(npc,npc.LuaHelper:RandomInt(240,280),Map,CS.XiaWorld.Fight.g_emFightCamp.Enemy);
	CS.XiaWorld.ThingMgr.Instance:EquptNpc(npc,npc.LuaHelper:RandomInt(0,12),CS.XiaWorld.g_emNpcRichLable.Richest);
	npc.FightBody.AttackWait = 1;
	npc.FightBody.AttackTime = 10000;
	npc.FightBody.AutoNext = true;
	npc.FightBody.IsAttacker = true;
	renshu = renshu - 1
	end
	print("当前被天元女拳宗攻打过的次数："..world:GetWorldFlag(1712))
end

function Hudong:diren003()
	npc = CS.XiaWorld.NpcRandomMechine.RandomNpc("Human",g_emNpcSex.Male);
	npc:AddTitle(npc1.Name.."的退婚对象");
	CS.XiaWorld.NpcMgr.Instance:AddNpc(npc,npc.LuaHelper:RandomInt(240,280),Map,CS.XiaWorld.Fight.g_emFightCamp.Enemy);
	CS.XiaWorld.ThingMgr.Instance:EquptNpc(npc,12,CS.XiaWorld.g_emNpcRichLable.Richest);
	Hudong:shanchuzhuangbei()
	local FBSL = WorldLua:RandomInt(1,7)
	local LQZD = WorldLua:RandomInt(3000000,9000000)
	npc.PropertyMgr:SetPropertyOverwrite("NpcFight_FabaoNum",FBSL)
	npc.PropertyMgr:SetPropertyOverwrite("NpcLingMaxValue",LQZD)
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
	npc.PropertyMgr.Age = 25
	npc.FightBody.AttackWait = 1;
	npc.FightBody.AttackTime = 10000;
	npc.FightBody.AutoNext = true;
	npc.FightBody.IsAttacker = true;
	npc:AddModifier("Fenghuangzhixue");
end

function Hudong:shanchuzhuangbei()
	local npcitems = npc.Bag.m_lisItems -- 获取NPC身上物品列表
	for i= 0,npcitems.Count-1 do -- 删除NPC 身上物品
	 ThingMgr:RemoveThing(npcitems[0])
	end
	local item1 =CS.XiaWorld.ItemRandomMachine.RandomItem(CS.XiaWorld.g_emItemLable.Weapon,0,12,100); -- 获取随机武器
	local item2 =CS.XiaWorld.ItemRandomMachine.RandomItem(CS.XiaWorld.g_emItemLable.Clothes,0,12,100); -- 获取随机衣服
	local item3 =CS.XiaWorld.ItemRandomMachine.RandomItem(CS.XiaWorld.g_emItemLable.Trousers,0,12,100); -- 获取随机裤子
	npc:EquipItem(item1);
	npc:EquipItem(item2);
	npc:EquipItem(item3);
end

function Hudong:Wqcs()--删除所有装备，并且重生
	local npcitems = Wqcsnpc.Bag.m_lisItems
	for i= 0,npcitems.Count-1 do -- 删除NPC 身上物品
	 ThingMgr:RemoveThing(npcitems[0])
	end
	CS.XiaWorld.NpcMgr.Instance:RebornNpc(Wqcsnpc)
	Wqcsnpc = nil
end

function Hudong:zuzhuangnvquanmiti()--组装哭神将秘体
npcc.PropertyMgr.Practice.BodyPracticeData:UnLockSuperPart("SuperPart_Nvquan_4",false)
npcc.PropertyMgr.Practice.BodyPracticeData:UpgradSuperPart2RandomLevel("SuperPart_Nvquan_4")
npcc.PropertyMgr.Practice.BodyPracticeData:EquptSuperPart(CS.XiaWorld.g_emSuperPartEquptKind.Attack, "SuperPart_Nvquan_4");
npcc.PropertyMgr.Practice.BodyPracticeData:UnLockSuperPart("SuperPart_Nvquan_2",false)
npcc.PropertyMgr.Practice.BodyPracticeData:UpgradSuperPart2RandomLevel("SuperPart_Nvquan_2")
npcc.PropertyMgr.Practice.BodyPracticeData:EquptSuperPart(CS.XiaWorld.g_emSuperPartEquptKind.Defense, "SuperPart_Nvquan_2");
npcc.PropertyMgr.Practice.BodyPracticeData:UnLockSuperPart("SuperPart_Nvquan_3",false)
npcc.PropertyMgr.Practice.BodyPracticeData:UpgradSuperPart2RandomLevel("SuperPart_Nvquan_3")
npcc.PropertyMgr.Practice.BodyPracticeData:EquptSuperPart(CS.XiaWorld.g_emSuperPartEquptKind.Effect, "SuperPart_Nvquan_3");
local item2 =CS.XiaWorld.ItemRandomMachine.RandomItem(CS.XiaWorld.g_emItemLable.Clothes,0,12,100);
local item3 =CS.XiaWorld.ItemRandomMachine.RandomItem(CS.XiaWorld.g_emItemLable.Trousers,0,12,100);
npcc:EquipItem(item2);
npcc:EquipItem(item3);
local sj = WorldLua:RandomInt(1000,10000)
npcc.PropertyMgr:ModifierProperty("BodyPratice_MaxZhenQi",5*sj,0,0,0)--真气+5
npcc.PropertyMgr:ModifierProperty("BodyPratice_RecoverZhenQi",1*sj,0,0,0)--回气+1
npcc.PropertyMgr:ModifierProperty("BodyPractice_SuperPartAddp_CatchFabao",0.0001*sj,0,0,0)--镇压概率
npcc.PropertyMgr:ModifierProperty("BodyPractice_SuperPartAddp_ArmorPenetration",0.0001*sj,0,0,0)--穿透加成率
npcc.PropertyMgr:ModifierProperty("BodyPractice_SuperPartAddp_DefRate",0.0001*sj,0,0,0)--防御成功率
npcc.PropertyMgr:ModifierProperty("BodyPractice_SuperPartAddp_AtkRate",0.0001*sj,0,0,0)--命中率
npcc.PropertyMgr:ModifierProperty("MaxAge",1*sj,0,0,0)--寿命
npcc.PropertyMgr:ModifierProperty("BodyPractice_SuperPartAddv_AtkPower",10*sj,0,0,0)--攻击力
npcc.PropertyMgr:ModifierProperty("BodyPractice_SuperPartAddv_DefPower",10*sj,0,0,0)--防御力
npcc.PropertyMgr:ModifierProperty("PainTolerance",0.0001*sj,0,0,0)--疼痛忍耐
npcc.PropertyMgr:ModifierProperty("BodyPratice_BodyStrong",0.1*sj,0,0,0)--身体强悍程度
npcc.PropertyMgr:ModifierProperty("BodyPratice_CatchFaboValue",-0.0001*sj,0,0,0)--镇压法宝消耗
npcc.PropertyMgr:ModifierProperty("NpcFight_BaseDodgeChance",0.0001*sj,0,0,0)--闪避
end

function Hudong:SCdaoju001()
local npc = ThingMgr:FindThingByID(me.npcObj.ID)
item = CS.XiaWorld.ItemRandomMachine.RandomItem("Item_Baobeier");
item.Rate = npc.LuaHelper:GetGLevel() + 1
item:SetName("" .. npc:GetName() .. "的宝贝");
npc.map:DropItem(item,npc.Key,true,true,false,true,5);
end

function Hudong:citiao1()--倾国倾城
local CTnpc = ThingMgr:FindThingByID(CitiaonpcID)
	if CTnpc.PropertyMgr:CheckFeature("UglyFace2") then
	CTnpc.PropertyMgr:RemoveFeature("UglyFace2");
	elseif CTnpc.PropertyMgr:CheckFeature("UglyFace1") then
	CTnpc.PropertyMgr:RemoveFeature("UglyFace1");
	elseif CTnpc.PropertyMgr:CheckFeature("BeautifulFace2") then
	CTnpc.PropertyMgr:RemoveFeature("BeautifulFace2");
	elseif CTnpc.PropertyMgr:CheckFeature("BeautifulFace1") then
	CTnpc.PropertyMgr:RemoveFeature("BeautifulFace1");
	end
	CTnpc.PropertyMgr:AddFeature("BeautifulFace3");
end