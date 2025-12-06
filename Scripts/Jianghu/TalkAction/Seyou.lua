local tbTable = GameMain:GetMod("JianghuMgr");
local tbTalkAction = tbTable:GetTalkAction("Mod_seyou");


--类会复用，如果有局部变量，记得在init里初始化
function tbTalkAction:Init()	
end

function tbTalkAction:GetName(player,target)
	return "色诱";
end

function tbTalkAction:GetDesc(player,target)
	return "出卖色相诱惑对方，使对方对你产生好感。";
end

--按钮什么时候可见
function tbTalkAction:CheckActive(player,target)
	if target.PropertyMgr.BodyData:PartIsBroken("Genitals") or player.PropertyMgr.BodyData:PartIsBroken("Genitals") or player.PropertyMgr.RelationData:IsRelationShipWith("Spouse",target) == true then--太监和夫妻除外
		return false;
	end
	return true;
end

--按钮什么时候可用
function tbTalkAction:CheckEnable(player,target)
	if target.PropertyMgr.BodyData:PartIsBroken("Genitals") or player.PropertyMgr.BodyData:PartIsBroken("Genitals") or player.PropertyMgr.RelationData:IsRelationShipWith("Spouse",target) == true then--太监和夫妻除外
		return false;
	end
	return true;
end

function tbTalkAction:Action(player,target)--未完成
	local random = player.LuaHelper:RandomInt(0,15);
	local meili = player.LuaHelper:GetCharisma()
	local juqing = player.LuaHelper:RandomInt(1,5)
	local Wfxg = CS.XiaWorld.JianghuMgr.Instance:GetJHNpcDataBySeed(player.JiangHuSeed).Feature
	local Dfxg = CS.XiaWorld.JianghuMgr.Instance:GetJHNpcDataBySeed(target.JiangHuSeed).Feature
	local XianzheCD = target.LuaHelper:GetModifierStack("XianzheCD");
	local NalitongCD = target.LuaHelper:GetModifierStack("NalitongCD");
	local seyouCD = NalitongCD + XianzheCD
	if seyouCD == 0 then--cd判定，成功开始剧本
		if player.LuaHelper:GetModifierStack("Zhenchaosuo")~= 0 or player.LuaHelper:GetModifierStack("Zhenchaozhou") ~= 0 then--1带着贞操锁/咒
			if player.Sex == CS.XiaWorld.g_emNpcSex.Male and player.PropertyMgr.RelationData:IsRelationShipWith("Luding2",target) == true then--1是男，且是2的奴隶
			self:SetTxt(""..target.Name.."想要侍奉自己的主人，许是"..player.Name.."心情很好，她解开了贞操锁/咒，让"..player.Name.."用胯下肉棒侍奉了自己");
			target:AddModifier("XianzheCD");
			player:AddModifier("XianzheCD");
			else
				if player.Sex ~= CS.XiaWorld.g_emNpcSex.Male and player.PropertyMgr.RelationData:IsRelationShipWith("Luding1",target) == true then--1是女，且是2的奴隶
				self:SetTxt(""..target.Name.."想要侍奉自己的主人，许是"..player.Name.."心情很好，他解开了贞操锁/咒，让"..player.Name.."使用小穴侍奉了自己");
				target:AddModifier("XianzheCD");
				player:AddModifier("XianzheCD");
				else
					self:SetTxt(""..player.Name.."的下体被阳锁/贞操咒封住了，并不能对对方做什么，于是转身离开了。");
				end
			end
		return false;
		end
		if target.LuaHelper:GetModifierStack("Zhenchaosuo")~= 0 or target.LuaHelper:GetModifierStack("Zhenchaozhou") ~= 0 then--2带着贞操锁/咒
			if player.Sex == CS.XiaWorld.g_emNpcSex.Male and player.PropertyMgr.RelationData:IsRelationShipWith("Luding1",target) == true then--1是男，且是2的主人
			self:SetTxt(""..player.Name.."一时性起，想要干自己的女奴"..target.Name.."一炮，他解开了贞操锁/咒，在"..target.Name.."身上耕耘许久直到心满意足后转身离去了。");
			target:AddModifier("XianzheCD");
			player:AddModifier("XianzheCD");
			else
				if player.Sex ~= CS.XiaWorld.g_emNpcSex.Male and player.PropertyMgr.RelationData:IsRelationShipWith("Luding2",target) == true then--1是女，且是2的主人
				self:SetTxt(""..player.Name.."一时性起，感觉下身湿润了，想要自己的公狗"..target.Name.."来干上自己一炮，他解开了贞操锁/咒，"..target.Name.."用胯下肉棒侍奉了"..player.Name.."。");
				target:AddModifier("XianzheCD");
				player:AddModifier("XianzheCD");
				else
					self:SetTxt("还未等"..player.Name.."开口，只见"..target.Name.."摸了摸下身，也不理会"..player.Name.."便转身离去了。");
				end
			end
		return false;
		end
	for key,npcs in pairs(target.PropertyMgr.RelationData.m_mapRelationShips) do
		if (key == "Spouse") and npcs.Count > 0 then 
			print("找到夫妻或恋人关系")
			local isSpouse = false
			local SpouseName = ""
			for _,npc in pairs(npcs) do
				SpouseName = npc.Name
				if player.ID == npc.ID then 
					isSpouse = true
					break
				end
			end
			if isSpouse == false then--判定NTR成功
				if player.Sex == CS.XiaWorld.g_emNpcSex.Male then
					if target.Sex == CS.XiaWorld.g_emNpcSex.Male then--男男ntr
					self:SetTxt(""..target.Name.."有老婆了，何况"..player.Name.."还是个男的，别干这脑瘫事情了可好？");
					else--男女ntr
						if Dfxg == CS.XiaWorld.g_emJHNpc_Feature.Greedy and player.LuaHelper:GetModifierStack("Qian") >= 1000000 and target.LuaHelper:GetModifierStack("Pochu") ~= 0 then--主角100W贪婪非处
						self:SetTxt(""..player.Name.."拿出一把银票，向"..target.Name.."表达了双修的愿望，"..target.Name.."看着银票，眼睛都直了，心道，这么多钱，别说是和你双修，就是当你的狗也甘之若饴。\n怕错失这次机会，"..target.Name.."连忙趴在地上舔"..player.Name.."的鞋底，同时沉腰将自己的后臀抬高，风骚的扭动着屁股，口中淫叫着，“啊……主人快来插我。”\n\n"..player.Name.."一脚踩在她的脸上，用随身带着的法器抽打着她摇个不停的骚屁股，一脸淫邪的笑道，“我插你，那你老公怎么办呢？你可是"..SpouseName.."的妻子啊，可不能不守妇道。”\n"..target.Name.."的脸都被踩得变形，还是乖巧的挤出讨好的笑容，“那是因为母狗之前没遇到主人，现在做了主人的贱母狗，我浑身上下都是属于主人的，任由主人随便玩弄。主人要是不让，我老公也不能操我。”\n"..player.Name.."把脚趾伸进她的狗嘴里，“这么乖啊，喏，这是主人赏你的。”\n"..player.Name.."又掏出一把银票扔在地上，"..target.Name.."口中含着脚趾，含糊不清的不住言道，“谢主人赏，谢主人赏……”磕了几个头，将银票捡了起来，攥成一卷，插进自己的后庭，摇着屁股讨好的说道，“主人，母狗有尾巴了，谢谢主人赏赐。”\n"..player.Name.."见这骚婊子这般淫贱，再也按捺不住心头欲火，提枪直刺。待云雨将歇之时——“啊，主人射进来吧，我要给主人生孩子，求求主人了。”"..target.Name.."淫叫着恳求"..player.Name.."。\n“给我生孩子，那你丈夫呢？”"..player.Name.."停了下来，坏笑着问。\n“他，他不配，主人放心，他的精液再也不会射进我的骚屄，母狗不会再让他碰了，母狗只属于主人一个人……啊……哦，谢谢主人……啊……”"..target.Name.."最终感受到一股滚烫射进了自己的淫穴，强烈的刺激之下，骚水也喷涌而出，“好……好爽，主人。”\n\n"..player.Name.."又递上了些许银两，拍了拍她的屁股，“你，不错，是条好狗。”\n\n事毕，"..target.Name.."成为了"..player.Name.."的女奴隶，"..target.Name.."获得银两10万两。");
						player:AddModifier("Qian");
						target:AddModifier("Qian");
						target:AddModifier("XianzheCD");
						player:AddModifier("XianzheCD");
						local WDQ = player.PropertyMgr:FindModifier("Qian")
						local DDQ = target.PropertyMgr:FindModifier("Qian")
						WDQ:UpdateStack(-100001);
						DDQ:UpdateStack(99999);
						player.PropertyMgr.RelationData:AddRelationShip(target,"Luding1");
						return false;
						end
						if Dfxg == CS.XiaWorld.g_emJHNpc_Feature.Greedy and player.LuaHelper:GetModifierStack("Qian") >= 1000000 and target.LuaHelper:GetModifierStack("Pochu") == 0 then--主角100W贪婪处女
						self:SetTxt(""..player.Name.."拿出一把银票，向"..target.Name.."表达了双修的愿望。"..target.Name.."看着银票，眼睛都直了，心想，还从来没见过这么多钱，真是后悔和他结婚了。\n可如今自己已经是"..SpouseName.."的妻子了，我和他还未曾欢好过，心下犹豫，这样做是否太对不起他了，可抬头看着那厚厚的一沓银票，又实在是怕错失这次机会。\n\n就在这犹豫之时，"..player.Name.."又拿出了一大把银票，全是汇通银号的千两票子，"..target.Name.."的眼睛就跟着那银票转动，失神之际，"..player.Name.."将银票插进了她双乳之间，她连忙按住，攥在手里。\n“我知道你还是个雏，我"..player.Name.."玩的就是雏。\n除了这些，你若应下，我手头还有几个零散的铺子和庄园，一并送你了。\n趁早踹了你那废物老公吧。”"..target.Name.."看着手里和眼前的票子，身下一热，淫水潺潺的就流了下来，口中娇喘着，伏在"..player.Name.."身下，用香舌侍弄着他的阳物，“爷的鸡巴真大，真不愧是财大器粗呢。”阴茎、阳袋都小心的舔弄着。\n"..player.Name.."听得高兴，被她伺候的也舒服，又拿出一沓子银票随手扔在了地上，“像狗一样捡起来，捡起来就是你的了。”\n"..target.Name.."听话的趴在地上，用舌头卷、用嘴叼，将银票都收拢到了一起，跪着磕了几个头，“母狗谢主人赏赐。”\n“真聪明，可我还是觉得你这个贱母狗没长尾巴，真是难看呢。”"..target.Name.."看了看四周，除了银票再无他物，心下一横，将面前的银票攥成一卷，插进自己的后庭，摇着屁股讨好的说道，“主人，母狗有尾巴了，谢谢主人赐给母狗尾巴。”\n"..player.Name.."用脚拍打着"..target.Name.."的脸，“你说，你这母狗怎么这么贱啊？要不把你这贱样用留影法器录下来，让你老公看看？”"..target.Name.."讨好的舔舐着"..player.Name.."的脚趾，“母狗才不管那个废物老公呢，母狗只想主人操我。”\n\n“去，躺到那，自己把腿掰开，让主人看看你的膜还在吗。”"..target.Name.."用双手分开双腿，手指掰开阴唇，正面展示给"..player.Name.."看，“在的主人，母狗的贱狗老公也没碰过，母狗的膜是专门留给主人的。”\n"..player.Name.."一脚踢在她的屄上，“你这烂屄的膜也配留给我，去，自己拿银子捅烂了再像狗一样跪到那儿给老子操。”\n“是。”"..target.Name.."用地上的碎银子插破的自己的处女膜，而后跪着，等待着"..player.Name.."的临幸。"..player.Name.."见这骚婊子这般淫贱，再也按捺不住心头欲火，拍了拍她的屁股，便将鸡巴插了进去。待云雨将歇之时——“啊，主人射进来吧，我要给主人生孩子，求求主人了。”\n"..target.Name.."淫叫着恳求"..player.Name.."。“给我生孩子，那你丈夫呢？”"..player.Name.."停了下来，坏笑着问。“他，他不配，主人放心，他的精液以后不会射进我的骚屄，母狗不会让他碰的，母狗只属于主人一个人……啊……哦，谢谢主人……啊……”"..target.Name.."最终感受到一股滚烫射进了自己的淫穴，强烈的刺激之下，骚水也喷涌而出，“好……好爽，主人。”\n\n"..player.Name.."又递上了些许银两，将鸡巴在她脸上蹭了蹭，从储物戒中拿出一条贞操带，“你，不错，是条好狗。喏，把这个戴上，以后每月都有赏赐。”\n\n"..target.Name.."得了赏，欢喜的戴上带子，扭着屁股磕头，“谢主人赏，贱奴的骚屄永远只属于主人。”\n\n突然之间，"..target.Name.."觉得身下凉凉的，方才戴上的贞操带竟已消失不见，细看之下，小腹下方竟多了一处淫纹图案——“这是我独门的贞操咒印，无人能解，日后你的穴口只有接触到我的阳具，才会张开，否则只有针孔大小，他人精液也无法流入。”\n\n"..target.Name.."听闻自己的贞操带竟是永久的，心中激动，自己果真永远属于主人了，看着小腹的淫纹与紧贴着的屄缝，好想主人干我。\n身下的淫水已然泛滥，在地上纵横流淌。\n\n事毕，"..target.Name.."成为了"..player.Name.."的女奴隶，"..target.Name.."获得银两20万两，"..target.Name.."获得贞操咒印，"..player.Name.."获得元阴落红。")
						player:AddModifier("Qian");
						target:AddModifier("Qian");
						target:AddModifier("Pochu");
						target:AddModifier("Zhenchaosuo");
						player:AddModifier("Diyidixue");
						target:AddModifier("XianzheCD");
						player:AddModifier("XianzheCD");
						local WDQ = player.PropertyMgr:FindModifier("Qian")
						local DDQ = target.PropertyMgr:FindModifier("Qian")
						WDQ:UpdateStack(-200001);
						DDQ:UpdateStack(199999);
						player.PropertyMgr.RelationData:AddRelationShip(target,"Luding1");
						player.PropertyMgr.RelationData:AddRelationShip(target,"Chunv");
						player.LuaHelper:DropAwardItem("Item_Nvxiuluohong",1);
						return false;
						end
						if Dfxg == CS.XiaWorld.g_emJHNpc_Feature.Greedy and player.LuaHelper:GetModifierStack("Qian") >= 100000 and target.LuaHelper:GetModifierStack("Pochu") ~= 0 then--主角10W贪婪非处
						self:SetTxt(""..player.Name.."拿出两张银票递给"..target.Name.."，向她表达了双修的愿望。\n"..target.Name.."看着银票，足有千两之多，心道这也不少了，自从我跟了那个死鬼，就没过过一天好日子，银钱哪里够使的，心中刚一盘算，便将银票一把攥在了手中，谨慎的看了看四周，暗道，“跟我来。”\n二人来到"..target.Name.."的卧房，"..target.Name.."含饴弄箫之际，双手也未闲着，拢、捻、捏、划，挑动着"..player.Name.."的春袋、双乳、后背。\n"..player.Name.."舒爽万分，心中却仍有些担忧，“好仙子，"..SpouseName.."今日去哪里了，不会回来吧。”“蹦，”"..target.Name.."吐出巨大的阳物，“好好地提他干嘛，你就放点心吧，今天没人打扰我们的好事的。”\n而后一路向上舔弄着，精湛的口技弄得"..player.Name.."意乱神迷。\n“还有更爽更刺激的，要玩吗？”"..target.Name.."笑得妩媚，"..player.Name.."只顾不住点头。\n“愣着干嘛，加钱啊。”"..target.Name.."握着他的阳物，白了他一眼。\n“哦……哦哦。”"..player.Name.."似是被下了降头，又乖乖的从储物戒中拿出两张银票。\n"..target.Name.."银钱到手，笑得开心，“我告诉你啊，你今儿这钱花的不亏，我那死鬼老公我还没这样伺候过呢。”\n"..target.Name.."蹲在他的身后，舌尖轻挑后庭，除去秽物后，将后庭湿润，香舌团作一股，向更深处探去。\n“啊……呼……”"..player.Name.."忍不住叫出声来，“仙子，仙子好厉害……真是美极了……”“安啦，还有更舒服的呢。\n”波推、骑乘……一整套做下来，"..player.Name.."身心愉悦。临走之时，"..player.Name.."又给了"..target.Name.."一些银子，“仙子以后莫要忘了我。”\n"..target.Name.."获得银两3000两。");
						player:AddModifier("Qian");
						target:AddModifier("Qian");
						target:AddModifier("XianzheCD");
						player:AddModifier("XianzheCD");
						local WDQ = player.PropertyMgr:FindModifier("Qian")
						local DDQ = target.PropertyMgr:FindModifier("Qian")
						WDQ:UpdateStack(-3001);
						DDQ:UpdateStack(2999);
						return false;
						end
						if Dfxg == CS.XiaWorld.g_emJHNpc_Feature.Greedy and player.LuaHelper:GetModifierStack("Qian") >= 100000 and target.LuaHelper:GetModifierStack("Pochu") == 0 then--主角10W贪婪处女
						self:SetTxt(""..player.Name.."拿出两张银票递给"..target.Name.."，向她表达了双修的愿望。\n"..target.Name.."看着这两张银票，心道这人也算出手阔绰了，只是，我和"..SpouseName.."虽已成婚却还未曾欢好过，这般做法，也太不要脸面了。\n未理那人，转身便要离去，"..player.Name.."忙道，“别走啊，价钱好商量的。”又拿出了几张银票挥手向"..target.Name.."示意。\n"..target.Name.."心中略作挣扎，却仍是不愿舍了自己的元阴之身，表面上走得坚决，头也不回。看着"..target.Name.."的身影渐远，"..player.Name.."嘴上恨恨骂着，“臭婊子，装什么纯，不就嫌老子钱少吗……”。");
						return false;
						end
						if Dfxg == CS.XiaWorld.g_emJHNpc_Feature.Greedy and player.LuaHelper:GetModifierStack("Qian") < 100000 then--主角小于10W贪婪女
						self:SetTxt(""..player.Name.."捧着一株灵草，向"..target.Name.."表达了想要双修的愿望。\n"..target.Name.."轻蔑的扫了一眼他的穿着打扮，“就你？也不掂量掂量自己，我老公可是九华村首富，就是用钱砸也把你砸死了。再说了，我就是给富豪舔脚、当肉便器，也不愿让你这穷逼碰一根手指头，快滚吧。”\n"..target.Name.."说完嗤笑一声便离去了，"..player.Name.."呆立在原地，低着头两眼通红，手中的灵草也打了蔫似的弯了下来。");
						return false;
						end
						if Dfxg == CS.XiaWorld.g_emJHNpc_Feature.Weak and player.LuaHelper:GetGLevel() - 5 > target.LuaHelper:GetGLevel() and target.LuaHelper:GetModifierStack("Pochu") ~= 0 then--软弱非处1
						self:SetTxt(""..player.Name.."当面直截了当的向"..target.Name.."提出了双修的要求。\n"..target.Name.."心中惊惧，自己已为人妇，怎能答应，可"..player.Name.."修为高绝，若是惹恼了他，全家也要跟着遭殃。\n她低头咬着嘴唇，羞红了脸，“那，你可不要声张出去，而且，而且说好了，就这一次。”\n\n"..player.Name.."当街揉捏着她的屁股，“别废话了，走吧，你也不想被别人看到不是吗？”\n\n床榻之上，"..target.Name.."顺从的给"..player.Name.."呵着卵子——“好了，给爷舔舔屁眼。”\n怎么这样……那里那么脏……我给老公就连口交都没做过呢。“\n爷，要不，我伺候您洗洗，然后再给您舔？”"..target.Name.."陪着笑小心的试探。\n"..player.Name.."大怒，“你个贱婊子还嫌爷脏？”抓起"..target.Name.."的头发，将她的脑袋直埋进了尿桶之中，任她挣扎求饶也不松手。\n待声息渐弱，"..player.Name.."将她拽出尿桶，"..target.Name.."大口的喘息着，咳嗽着，全然不顾满身的尿液。\n“爽吗，贱屄？”"..player.Name.."用脚踩着她的奶子。\n“爽，爽……求爷饶了贱屄吧，贱屄刚才犯贱，贱屄知道错了。”"..target.Name.."不住的求饶。\n"..player.Name.."递给"..target.Name.."一件像笔一样的法器，“这是以龙血为墨制成的灵纹法器，纹在身上就洗不掉了，也是为了让你记住自己的身份，去，自己给你屄两边纹上‘贱屄’两个字。”\n“是，是，谢主人赐名。”"..target.Name.."乖乖的给自己刺字。\n“贱屄，你老公以后看见这两个字怎么办啊？”"..player.Name.."笑着问。\n“贱屄就说，这是主人赏赐的，贱屄以后就是主人的玩具，让贱老公以后再也不能碰了。”\n"..player.Name.."答得利索，"..target.Name.."想收拾竟都找不到由头，无奈之下递出一块木板，“你那烂屄太松了，爷看着就倒胃口，拿着，狠狠的扇自己那烂屄，边扇边报数，每次报数后面都要接一声‘谢主人赏’，记住了吗？”\n“是，贱屄记得了。”"..target.Name.."接过木板，用力向自己下体打去，“一，谢主人赏……”\n\n二人在"..player.Name.."的洞府玩了足足三天三夜，"..target.Name.."一身湿哒黏腻，红肿的小穴处不断往外淌着白浊的液体。除私处的刺青外，"..target.Name.."的阴部、乳头也被穿了星髓制成的奴环。\n“回去吧，让你老公看看你现在的贱样。”\n“是。”"..target.Name.."四肢着地，像狗一样一步一步往家中爬去。\n"..player.Name.."情绪+20,"..target.Name.."身体多处受伤（可治愈），"..target.Name.."成为了"..player.Name.."的女奴隶。");
						player.PropertyMgr.RelationData:AddRelationShip(target,"Luding1");
						target.LuaHelper:AddDamageRandomPart(3,"Cut1",0.5, "来自性虐鞭挞割裂伤");
						target.LuaHelper:AddDamage("Scar","Hips",0.01, "真气纹身，上书“贱屄”字样。");
						target:AddModifier("XianzheCD");
						player:AddModifier("XianzheCD");
						return false;
						end
						if Dfxg == CS.XiaWorld.g_emJHNpc_Feature.Weak and player.LuaHelper:GetGLevel() - 5 > target.LuaHelper:GetGLevel() and target.LuaHelper:GetModifierStack("Pochu") == 0 then--软弱处1
						self:SetTxt(""..player.Name.."当面直截了当的向"..target.Name.."提出了双修的要求。\n"..target.Name.."心中惊惧，自己已为人妇了，且结婚这些日子了老公还没碰过自己的身子，怎能让外人就这般污了清白。\n可"..player.Name.."修为高绝，若是惹恼了他，自己全家也要跟着遭殃。\n"..target.Name.."深陷惶恐之中，不知该如何是好，"..player.Name.."可不管那么许多，手已经按在了她的屁股上，不住地揉捏着，“别想了，你逃不了的。”\n\n"..player.Name.."带着她来到自己的洞府，"..target.Name.."平日里也看过些图册，心想不论做出何种牺牲，也要保住自己的处女元阴，不能让老公知晓自己失身之事，于是跪着面向"..player.Name.."的巨龙，生涩的舔吸着。\n侍弄了有一刻钟，"..player.Name.."却一点射精的意思也没有，"..target.Name.."的小口已酸涩的不行了，喘了口气，想要歇息片刻。\n"..player.Name.."笑着，“我知你还是处子，若你将我伺候舒服了，想要保住身子也不是不行。”\n而后手扶着鸡巴拍打她的脸，“记住了，别光顾着这根东西，蛋蛋、屁眼，都给老子仔细舔着。”\n在此之前，"..target.Name.."甚至还从未看到过男人的下体，与老公寻常的肢体接触也几乎没有，此刻却像是久历皮肉生意的老姐儿，客提的什么要求都不皱一下眉，顺从的给"..player.Name.."舔着菊穴，秽物也都吃了下去。\n\n二人在"..player.Name.."的洞府玩了足足三天三夜，"..target.Name.."全力的陪侍令"..player.Name.."心神愉悦，无论什么要求只要以破处作为要挟，"..target.Name.."都会乖乖答应。\n虽未取她的元阴落红，"..player.Name.."自觉也算玩得尽兴了。\n"..target.Name.."原本的衣衫已全然毁坏了，如今只紧裹着"..player.Name.."的长袍往家中走去，"..SpouseName.."迎面，却不知"..target.Name.."的菊穴、口中均含着"..player.Name.."的浓精，乳头、臀部也被刻上了有"..player.Name.."的母狗……");
						player.PropertyMgr.RelationData:AddRelationShip(target,"Luding1");
						target.LuaHelper:AddDamage("Scar","Hips",0.01, "真气纹身，上书“"..player.Name.."的母狗”字样。");
						target:AddModifier("XianzheCD");
						player:AddModifier("XianzheCD");
						return false;
						end
						if Dfxg == CS.XiaWorld.g_emJHNpc_Feature.Weak and player.LuaHelper:GetGLevel() > target.LuaHelper:GetGLevel() and target.LuaHelper:GetModifierStack("Pochu") ~= 0 then--软弱非处2
						self:SetTxt(""..player.Name.."当面直截了当的向"..target.Name.."提出了双修的要求。\n"..target.Name.."心中不悦，明知我是有丈夫的人，做了这事，日后脸面岂不都要丢尽了。可他修为高我许多，若不应下，又怕他发难。\n"..target.Name.."佯作羞色，表面上答应了下来，一路随着"..player.Name.."向他的洞府而行。\n路上，趁"..player.Name.."驾驭飞行法器灵力不济之际，暗施法术，猛然偷袭。不料"..player.Name.."早有防备，灵宝护体，竟毫发无伤，反将"..target.Name.."用法宝缚住，带回了洞府。\n\n“臭婊子，他妈还敢害老子？”"..player.Name.."扇了她两巴掌，看着她战栗发抖的样子既觉爽快，又觉得有些不够过瘾，“你他妈的，爷给你洗洗脸。”\n"..player.Name.."抓起"..target.Name.."的头发，将她的脑袋直埋进了尿桶之中，任她挣扎求饶也不松手。\n待声息渐弱，"..player.Name.."将她拽出尿桶，"..target.Name.."大口的喘息着，咳嗽着，全然不顾满身的尿液。\n“爽吗，贱屄？”"..player.Name.."用脚踩着她的奶子。\n“爽，爽……求爷饶了贱屄吧，贱屄刚才犯贱，贱屄知道错了。”"..target.Name.."不住的求饶。\n"..player.Name.."递给"..target.Name.."一件像笔一样的法器，“这是以龙血为墨制成的灵纹法器，纹在身上就洗不掉了，也是为了让你记住自己的身份，去，自己给你屄两边纹上‘贱屄’两个字。”\n“是，是，谢主人赐名。”"..target.Name.."乖乖的张开双腿给自己刺字。\n"..player.Name.."看得有趣，“贱屄，你老公以后看见这两个字怎么办啊？”\n“贱屄就说，这是主人赏赐的，贱屄以后就是主人的玩具，让贱老公以后再也不能碰了。”\n"..player.Name.."答得利索，"..target.Name.."想收拾竟都找不到由头，无奈之下递出一块木板，“你那烂屄太松了，爷看着就倒胃口，拿着，狠狠的扇自己那烂屄，边扇边报数，每次报数后面都要接一声‘谢主人赏’，记住了吗？”\n“是，贱屄记得了。”"..target.Name.."接过木板，用力向自己下体打去，“一，谢主人赏……”……\n\n“主人打你是为了你好，知道吗，省的整天没事动坏心眼子。”"..player.Name.."把脚伸了出去，让跪趴着的"..target.Name.."用香舌伺候着。\n“知道了，谢谢主人打奴奴，奴奴喜欢主人打我。”"..target.Name.."顺从的舔着"..player.Name.."的脚底，扭动着高高撅起的翘臀。\n"..player.Name.."手里拿着长鞭，抽打着"..target.Name.."的屁股，忽觉翘挺的屁股上一片白，打起来也没什么意思。\n拿起灵纹法器在"..target.Name.."的屁股上又刺了“贱畜母狗"..target.Name.."”几个大字。\n粉涨的屁股将龙血刺青映得殷红，其上鞭痕交错，"..player.Name.."看着自己的成果不禁色欲大盛，怒龙高抬，扶着丰润的臀部挺身而入。\n二人在"..player.Name.."的洞府玩了足足三天三夜，"..target.Name.."一身湿哒黏腻，红肿的小穴、后庭都不断往外淌着白浊的液体。\n除私处和臀部的刺青外，"..target.Name.."的阴部、乳头也被穿了星髓制成的奴环。“回去吧，让你老公看看你现在的贱样。”\n“是。”"..target.Name.."四肢着地，像狗一样一步一步往家中爬去。\n"..target.Name.."身体多处受伤（可治愈），"..target.Name.."成为了"..player.Name.."的女奴隶。");
						player.PropertyMgr.RelationData:AddRelationShip(target,"Luding1");
						target.LuaHelper:AddDamageRandomPart(3,"Cut1",0.5, "来自性虐鞭挞割裂伤");
						target.LuaHelper:AddDamage("Scar","Hips",0.01, "真气纹身，上书“贱屄”字样。");
						target:AddModifier("XianzheCD");
						player:AddModifier("XianzheCD");
						return false;
						end
						if Dfxg == CS.XiaWorld.g_emJHNpc_Feature.Weak and player.LuaHelper:GetGLevel() > target.LuaHelper:GetGLevel() and target.LuaHelper:GetModifierStack("Pochu") == 0 then--软弱处2
						self:SetTxt(""..player.Name.."当面直截了当的向"..target.Name.."提出了双修的要求。\n"..target.Name.."念及自己还是处子之身，结婚这些日子以来，丈夫还未曾与自己欢好过，若与他人有染，这往后的日子可怎么过啊。\n她暗施法力，探查"..player.Name.."的修为境界，发现"..player.Name.."修为高出自己不少，此刻若不应下，又怕他直行那不轨之事，自己可就难以应对了。\n"..target.Name.."佯作羞色，表面上答应了下来，一路随着"..player.Name.."向他的洞府而行。\n路上，趁"..player.Name.."驾驭飞行法器灵力不济之际，祭出法宝，猛然偷袭。\n不料"..player.Name.."早有防备，灵宝护体，竟毫发无伤，反将"..target.Name.."用法宝缚住，带回了洞府。\n\n“臭婊子，他妈还敢害老子？”"..player.Name.."扇了她两巴掌，看着她战栗发抖的样子既觉爽快，又觉得有些不够过瘾，“你他妈的，爷给你洗洗脸。”\n"..player.Name.."抓起"..target.Name.."的头发，将她的脑袋直埋进了尿桶之中，任她挣扎求饶也不松手。\n待声息渐弱，"..player.Name.."将她拽出尿桶，"..target.Name.."大口的喘息着，咳嗽着，全然不顾满身的尿液。\n“爽吗，贱屄？”"..player.Name.."用脚踩着她的奶子。\n“爽，爽……求爷饶了贱屄吧，贱屄刚才犯贱，贱屄知道错了。”"..target.Name.."不住的求饶。\n"..player.Name.."递给"..target.Name.."一件像笔一样的法器，“这是以龙血为墨制成的灵纹法器，纹在身上就洗不掉了，也是为了让你记住自己的身份，去，自己给你屄两边纹上‘贱屄’两个字。”\n“是，是，谢主人赐名。”"..target.Name.."乖乖的给自己刺字。\n"..player.Name.."欣赏着"..target.Name.."粉嫩的蜜穴，觉得这两个字真是美妙极了，“把腿分开，用手掰开你那贱屄，让也好好看看。”\n“是。”"..target.Name.."将腿张到最大，手指在左右两侧按住小阴唇，将美穴毫无保留的展示出来。\n“这是什么，”"..player.Name.."看着她小穴口半透明的薄膜，“没想到你还是个雏？”\n“是，是，”"..target.Name.."被弄得怕了，忙想着该怎么回话，“贱屄的身子就是主人的，之前老公一直想操我我都不答应，贱屄知道，贱屄的膜要留给主人，求主人给贱屄破处。”\n“这么想让我操啊，那你自己来吧。”"..player.Name.."躺在床上，摇动着鸡巴。\n“是，谢谢主人操贱屄，贱屄太高兴了。”"..target.Name.."骑在"..player.Name.."的腰间，手扶着那粗长的阳物，对准小穴，缓缓地坐了下去。\n\n之后，二人在"..player.Name.."的洞府玩了足足三天三夜，"..target.Name.."一身湿哒黏腻，纹着刺青红肿的小穴处不断往外淌着白浊的液体。\n"..player.Name.."看着躺在那里浑身赤裸的"..target.Name.."，心念一动，捏起咒诀，施了一道法术，"..target.Name.."的小腹下方忽的显现了一幅淫纹图案，“你不是说你的贱屄属于我吗？这是我独门的贞操秘术，你看看你的屄，现在是不是小的像针眼一样。你老公要想操，以后还得先问问我。”\n"..target.Name.."成为了"..player.Name.."的女奴隶，"..target.Name.."获得贞操咒印。");
						player.PropertyMgr.RelationData:AddRelationShip(target,"Luding1");
						player.PropertyMgr.RelationData:AddRelationShip(target,"Chunv");
						target:AddModifier("Pochu");
						target:AddModifier("XianzheCD");
						player:AddModifier("XianzheCD");
						return false;
						end
						if Dfxg == CS.XiaWorld.g_emJHNpc_Feature.Weak and player.LuaHelper:GetGLevel() <= target.LuaHelper:GetGLevel() then--软弱但是比我强或者相同
						self:SetTxt(""..player.Name.."当面直截了当的向"..target.Name.."提出了双修的要求。\n"..target.Name.."心中不悦，明知我是有丈夫的人还屡次前来纠缠于我，暗施法力查探了一番"..player.Name.."的修为境界，发现不过尔尔，便施法宝护体，果断回绝道，“你再这般纠缠，休怪我不客气了。”\n"..player.Name.."看她祭出这等绝品法宝，心生胆怯，连忙退去了。");
						return false;
						end
						if Dfxg == CS.XiaWorld.g_emJHNpc_Feature.Naive and player.LuaHelper:GetCharisma() > 9 and target.LuaHelper:GetModifierStack("Pochu") ~= 0 then--天真非处，我魅力大于9
						self:SetTxt(""..player.Name.."朝着"..target.Name.."露出微笑，委婉的向"..target.Name.."表露出想与之双修的愿望。\n"..target.Name.."看着眼前的男子，高冠清扬，气格超逸不群，风清骨峻而令人心向往之，她甚至都没听清"..player.Name.."说了什么。\n"..player.Name.."笑得温暖和煦，大方的又向她再次倾吐心声，"..target.Name.."感觉自己的心都要跳了出来，这般俊美的男子竟然会对我心生爱慕，羞怯之下，竟不知如何言语，面色涨得通红，连忙双手捂脸，以饰娇羞。\n她这般举措落在"..player.Name.."眼中，倒也觉得纯真可爱，偏又生了几分怜爱。\n\n"..player.Name.."与她相拥，欲低头深吻，"..target.Name.."看着那绝美的面庞逐渐沉沦，就在双唇将触之际，"..target.Name.."一个激灵，“我，我结婚了的，我不能对不起他。”伸手欲将他推开。\n"..player.Name.."却抱得更紧，“我们就这一次，他不会知道的。我知道，你也想要的。”\n"..player.Name.."在她耳畔轻语，温热的气息湿润了她的心房，她感觉耳朵、心里都痒痒的，她从未有过这般感受。\n"..player.Name.."用手探向她的裙底，抚弄着，“瞧，你都湿了不是吗？闭上眼睛，放松自己，都交给我就好了。”\n"..target.Name.."闭眼，默默的喘息着，"..SpouseName.."在她的心中已然消散，脑海中全是"..player.Name.."的天人一般的容颜，他的声音、他的气息、他身体的温度都已铭刻在了她的心里。\n她感觉自己是在天上，暖暖的，也有云雾的湿气，赏着世间绝景，或许此刻的自己是这个世界上最幸福的人了吧。\n云消雨歇，"..player.Name.."吻在她的额头，“宝贝，我走了。”\n"..target.Name.."拽着他的袖子，“可，可不可以不要走……”\n“就当这是一场梦，好吗。”");
						player.PropertyMgr.RelationData:AddRelationShip(target,"Lover");
						target:AddModifier("XianzheCD");
						player:AddModifier("XianzheCD");
						return false;
						end
						if Dfxg == CS.XiaWorld.g_emJHNpc_Feature.Naive and player.LuaHelper:GetCharisma() > 9 and target.LuaHelper:GetModifierStack("Pochu") == 0 then--天真处，我魅力大于9
						self:SetTxt(""..player.Name.."朝着"..target.Name.."露出微笑，委婉的向"..target.Name.."表露出想与之双修的愿望。\n"..target.Name.."看着眼前的男子，高冠清扬，气格超逸不群，风清骨峻而令人心向往之，她甚至都没听清"..player.Name.."说了什么。\n"..player.Name.."笑得温暖和煦，大方的又向她再次倾吐心声，"..target.Name.."感觉自己的心都要跳了出来，这般俊美的男子竟然会对我心生爱慕，羞怯之下，竟不知如何言语，面色涨得通红，连忙双手捂脸，以饰娇羞。\n她这般举措落在"..player.Name.."眼中，倒也觉得纯真可爱，偏又生了几分怜爱。\n\n"..player.Name.."与她相拥，欲低头深吻，"..target.Name.."看着那绝美的面庞逐渐沉沦，就在双唇将触之际，"..target.Name.."一个激灵，突然想起自己的丈夫，猛地将"..player.Name.."推开。\n婚礼当日，"..SpouseName.."被灌得大醉，难行周公之礼，后来二人竟也没顾得上，以致今日她还是处子之身。\n“我，我是有丈夫的，我们不能这样。”"..target.Name.."忙说。\n"..player.Name.."不管不顾，上前将她紧紧的抱在怀里，“亲爱的，你那丈夫，"..SpouseName.."整日在外花天酒地，他可曾将你视作妻子。我爱煞了你，我的心中只有你一人，我不想你受委屈，跟我走吧。”\n"..player.Name.."的语气坚决，像一块大石撞开了她的心防，她默默地流泪，闭眼，不再想其他。\n“是了，相信我，我会给你幸福的，慢慢放松，都交给我就好了。”\n"..player.Name.."轻抚着她的后背，低头吻上她的樱唇。\n"..target.Name.."心里甜丝丝的，还有些痒痒的，似是在期待着什么，此刻，他的声音、他的气息、他身体的温度都已铭刻在了她的心里。\n她静静的感受着，她感觉自己仿若是在天上，暖暖的，也有云雾的湿气，赏着世间的绝景，或许此时此刻自己是这个世界上最幸福的人了吧。\n\n一夜欢愉，梦醒时分却不见情郎身影。\n“骗子，”她流着泪，咬着手帕，心下却难生恨意。\n“玲珑骰子安红豆，入骨相思知不知。”");
						target:AddModifier("Pochu");
						player.PropertyMgr.RelationData:AddRelationShip(target,"Lover");
						target:AddModifier("XianzheCD");
						player:AddModifier("XianzheCD");
						return false;
						end
						if Dfxg == CS.XiaWorld.g_emJHNpc_Feature.Naive and player.PropertyMgr.RelationData:IsRelationShipWith("Lover",target) == true and target.LuaHelper:GetModifierStack("Pochu") ~= 0 then--天真非处，是恋人
						self:SetTxt(""..target.Name.."不喜拘着自己在那漫漫仙途之上求索，自然畅达或是她的本心所求，故而无事时常逛逛坊市，看看那些娇艳的灵植，寻些古物和一些有趣的小玩意儿，打发打发时间。\n只是，这几个月来，"..player.Name.."也总是在坊市中出现，送她一些她打心眼儿里喜欢的东西。\n开始她觉得许是碰巧遇到了，但这么些日子一直如此，再呆的人也明白了，她本不欲与"..player.Name.."再有往来，但"..player.Name.."话说得诚恳，她也不忍伤了"..player.Name.."的面子。\n赶巧，今日便又碰到了——“"..target.Name.."仙子，我知你喜爱那些素雅的花草，前些日子我在古书之中查到南荒之地生一种名为‘荀草’的仙草，看到时我就想，仙子一定喜欢的，这不，我赶紧给你请了来。”\n南荒距此何止万里，"..target.Name.."看着"..player.Name.."手中捧着的仙草，形质如兰，散发着浓郁的仙灵之气，枝叶青翠欲滴，“传闻荀草有姿容焕颜之效，你是想让我吃了它吗？”"..target.Name.."笑着问。\n“仙子容颜，合三界众生之美亦难及半分，何须吃它，用它来衬仙子的倾世之貌才是最好不过的了。”\n“确实不错，你有心了。”"..target.Name.."收下仙草，转身欲离去——“仙子，我……”\n"..target.Name.."听到他吞吞吐吐的劝拦，回眸，“你可知道，我是有丈夫的。”\n“我知道，可，可我……我还是喜欢你……我想和你在一起！”"..player.Name.."最终撕扯着喊出自己的心声。\n“我知道了，你小声些，跟我来吧。”\n\n"..target.Name.."家中，"..target.Name.."双手搭在"..player.Name.."赤裸的肩上，“你知道吗，在遇到你之前，我不知道什么是爱情。如今，这个世界，我感受得最深的，是你的温暖，是你炽热的心。\n“那我们再来一次？”\n“可我老公要回来了。”\n“来我家吧。”");
						target:AddModifier("XianzheCD");
						player:AddModifier("XianzheCD");
						return false;
						end
						if Dfxg == CS.XiaWorld.g_emJHNpc_Feature.Naive and player.PropertyMgr.RelationData:IsRelationShipWith("Lover",target) == true and target.LuaHelper:GetModifierStack("Pochu") == 0 then--天真处，是恋人
						self:SetTxt(""..target.Name.."不喜拘着自己在那漫漫仙途之上求索，自然畅达或是她的本心所求，故而无事时常逛逛坊市，看看那些娇艳的灵植，寻些古物和一些有趣的小玩意儿，打发打发时间。\n只是，这几个月来，"..player.Name.."也总是在坊市中出现，送她一些她打心眼儿里喜欢的东西。\n开始她觉得许是碰巧遇到了，但这么些日子一直如此，再呆的人也明白了，她本不欲与"..player.Name.."再有往来，但"..player.Name.."话说得诚恳，她也不忍伤了"..player.Name.."的面子。\n赶巧，今日便又碰到了——“仙子，我知你喜爱那些素雅的花草，前些日子我在古书之中查到南荒之地生一种名为‘荀草’的仙草，看到时我就想，仙子一定喜欢的，这不，我赶紧给你请了来。”\n南荒距此何止万里，"..target.Name.."看着"..player.Name.."手中捧着的仙草，形质如兰，散发着浓郁的仙灵之气，枝叶青翠欲滴，“传闻荀草有姿容焕颜之效，你是想让我吃了它吗？”"..target.Name.."笑着问。\n“仙子容颜，合三界众生之美亦难及半分，何须吃它，用它来衬仙子的倾世之貌才是最好不过的了。”\n“确实不错，你有心了。”"..target.Name.."收下仙草，转身欲离去——“仙子，我……”\n"..target.Name.."听到他吞吞吐吐的劝拦，回眸，“你可知道，我是有丈夫的。”\n“我知道，可，可我……我还是喜欢你……我想和你在一起！”"..player.Name.."最终撕扯着喊出自己的心声。\n“我知道了，你小声些，跟我来。”\n\n"..target.Name.."家中，"..target.Name.."拉着"..player.Name.."的手，“我之前从未爱过任何人，是你给了我温暖，你答应我，要真心待我，不能负我，不然……”\n"..player.Name.."吻上她的唇，轻啄，“我的心中永远只有你一人，天涯海角，碧落黄泉，至死相随。”\n二人拥吻，"..player.Name.."急不可耐的除着衣物。\n“"..player.Name.."，你一会儿慢一些，我……我还是处子。”\n"..player.Name.."一愣，心下万份惊喜，埋头舔弄着"..target.Name.."的私处，看到了那层小小的膜。\n“他没和你……”\n“嗯，我不喜欢他，讨厌他碰我，每次都借故推脱掉了。”\n二人怀着惊喜、激动又带有几分期待的心情共赴巫山，几度重楼，事后相约他日再诉绵缠。");
						target:AddModifier("XianzheCD");
						player:AddModifier("XianzheCD");
						return false;
						end
						if Dfxg == CS.XiaWorld.g_emJHNpc_Feature.Naive then--天真拒绝
						self:SetTxt(""..target.Name.."平素喜逛坊市，可最近出门总有一个傻小子凑近来，要么没话找话硬找她聊些什么，要么非要送她些什么东西。\n这不，出门又碰到了——“仙子，我……”\n“这位公子，你我非亲非故，我又早已嫁作他人之妇，你再这般纠缠不清，我可就要告诉我家官人了。”"..target.Name.."不再顾忌"..player.Name.."的面子，话讲的坚决，离去的也坚决。\n"..player.Name.."看着她的背影，攥着手中的花，悻悻然埋头蹲在了地上。");
						return false;
						end
						if Dfxg == CS.XiaWorld.g_emJHNpc_Feature.Apathy and Wfxg == CS.XiaWorld.g_emJHNpc_Feature.Tenacity and player.LuaHelper:GetGLevel() > target.LuaHelper:GetGLevel() and target.LuaHelper:GetModifierStack("Pochu") ~= 0 then--非处冷，男坚
						self:SetTxt(""..player.Name.."看"..target.Name.."身形窈窕、姿态妍丽，心动不已，要干得她欲仙欲死的念头一下就生了起来，胯下顿时怒龙高抬。\n"..player.Name.."毫不掩饰，“这位仙子，可愿与某共度春宵？”\n"..target.Name.."性子冷清，男女情爱之事，既不懂，也从未关心过。\n当初家中长辈只当她还未开窍，怕她嫁与人家多要吃亏，故而特以数万灵石聘了百名仙媒，着意为她寻了一家世清白、忠厚老实的修士嫁了。\n"..SpouseName.."婚后待她极好，她感受的到，但不知该如何表达，唯有在与"..SpouseName.."的夫妻生活中尽量配合了。\n可她不喜掩饰，"..SpouseName.."操弄时候，她是不舒服的，"..SpouseName.."也看得出来，可"..SpouseName.."不仅不怪她，还更多的照顾她的情绪。\n"..target.Name.."觉得自己亏欠丈夫许多，着实称不上一个好妻子，但那是因自己天性如此，可若是失贞，那也太对不起他了。\n\n"..target.Name.."面若冰霜，对"..player.Name.."连一个眼神都没有，错身便走了过去。\n这臭婊子，老子让你装，"..player.Name.."当着众人，只觉脸面无光，心下恼怒极了，暗施法力，在她身上留下了一道寻踪印记。\n待"..target.Name.."出城后，"..player.Name.."祭出诸般法器，不消片刻便将"..target.Name.."击败。\n“贱货，让你给老子装！”"..player.Name.."用鞋底踩着"..target.Name.."的脸颊，手握马鞭，"..target.Name.."的衣物已做褴褛状，再也包裹不住那诱人的胴体。\n"..target.Name.."不知他为何这般恼火，故而在凌辱之下，也未曾言语。\n“真当自己是仙女了？啊？”"..player.Name.."以为"..target.Name.."仍在故作高傲，心中原本泄出的怒火又蹭蹭的窜了起来。\n“就算你是仙女，在老子这儿，也得变成吃屎喝尿的狗。”"..player.Name.."掏出阳物对准"..target.Name.."的俏脸——“呲……”一边尿一边左右摇摆着阳物，觉得有趣极了。\n"..target.Name.."不懂他为什么笑，只是觉得这样很脏，无奈之下闭上了眼睛。\n"..player.Name.."并未理会，看着眼前的尿人，自在畅怀，用阳物在她脸上拍打着，“来，给爷舔干净。”\n他可能只是想出气吧，虽然不知道哪里惹到他了，但"..target.Name.."觉得这并不有损自己的清白，便问，“舔干净了就放我走吗？”\n“啊……嗯。”"..player.Name.."眼睛看向别处，应得模糊。\n"..target.Name.."以为他答应了，舔得仔细。\n“想不到你这妞还挺浪啊。”\n"..target.Name.."听不懂，只顾埋首舔着。\n“好了，爷的鸡巴也硬了，躺那儿，自己把腿掰开。”\n"..target.Name.."呆愣，"..player.Name.."看她不动，上前将她抱起，长枪直刺，尽入其中。\n……\n\n次日清晨，她披着已化作一缕缕碎布的衣衫向家中走去，身下，"..player.Name.."的阳精与自身的淫液还在流淌着。\n她远远就看到了"..SpouseName.."站立在大院门口，眼泪一下就流了出来，“"..SpouseName.."，对不起……”\n“不哭，不哭……没事了，啊。”");
						target:AddModifier("XianzheCD");
						player:AddModifier("XianzheCD");
						return false;
						end
						if Dfxg == CS.XiaWorld.g_emJHNpc_Feature.Apathy and Wfxg == CS.XiaWorld.g_emJHNpc_Feature.Greedy and player.LuaHelper:GetGLevel() > target.LuaHelper:GetGLevel() and target.LuaHelper:GetModifierStack("Pochu") ~= 0 then--非处冷，男坚
						self:SetTxt(""..player.Name.."看"..target.Name.."身形窈窕、姿态妍丽，心动不已，要干得她欲仙欲死的念头一下就生了起来，胯下顿时怒龙高抬。\n"..player.Name.."毫不掩饰，“这位仙子，可愿与某共度春宵？”\n"..target.Name.."性子冷清，男女情爱之事，既不懂，也从未关心过。\n当初家中长辈只当她还未开窍，怕她嫁与人家多要吃亏，故而特以数万灵石聘了百名仙媒，着意为她寻了一家世清白、忠厚老实的修士嫁了。\n"..SpouseName.."婚后待她极好，她感受的到，但不知该如何表达，唯有在与"..SpouseName.."的夫妻生活中尽量配合了。\n可她不喜掩饰，"..SpouseName.."操弄时候，她是不舒服的，"..SpouseName.."也看得出来，可"..SpouseName.."不仅不怪她，还更多的照顾她的情绪。\n"..target.Name.."觉得自己亏欠丈夫许多，着实称不上一个好妻子，但那是因自己天性如此，可若是失贞，那也太对不起他了。\n\n"..target.Name.."面若冰霜，对"..player.Name.."连一个眼神都没有，错身便走了过去。\n这臭婊子，老子让你装，"..player.Name.."当着众人，只觉脸面无光，心下恼怒极了，暗施法力，在她身上留下了一道寻踪印记。\n待"..target.Name.."出城后，"..player.Name.."祭出诸般法器，不消片刻便将"..target.Name.."击败。\n“贱货，让你给老子装！”"..player.Name.."用鞋底踩着"..target.Name.."的脸颊，手握马鞭，"..target.Name.."的衣物已做褴褛状，再也包裹不住那诱人的胴体。\n"..target.Name.."不知他为何这般恼火，故而在凌辱之下，也未曾言语。\n“真当自己是仙女了？啊？”"..player.Name.."以为"..target.Name.."仍在故作高傲，心中原本泄出的怒火又蹭蹭的窜了起来。\n“就算你是仙女，在老子这儿，也得变成吃屎喝尿的狗。”"..player.Name.."掏出阳物对准"..target.Name.."的俏脸——“呲……”一边尿一边左右摇摆着阳物，觉得有趣极了。\n"..target.Name.."不懂他为什么笑，只是觉得这样很脏，无奈之下闭上了眼睛。\n"..player.Name.."并未理会，看着眼前的尿人，自在畅怀，用阳物在她脸上拍打着，“来，给爷舔干净。”\n他可能只是想出气吧，虽然不知道哪里惹到他了，但"..target.Name.."觉得这并不有损自己的清白，便问，“舔干净了就放我走吗？”\n“啊……嗯。”"..player.Name.."眼睛看向别处，应得模糊。\n"..target.Name.."以为他答应了，舔得仔细。\n“想不到你这妞还挺浪啊。”\n"..target.Name.."听不懂，只顾埋首舔着。\n“好了，爷的鸡巴也硬了，躺那儿，自己把腿掰开。”\n"..target.Name.."呆愣，"..player.Name.."看她不动，上前将她抱起，长枪直刺，尽入其中。\n……\n\n次日清晨，她披着已化作一缕缕碎布的衣衫向家中走去，身下，"..player.Name.."的阳精与自身的淫液还在流淌着。\n她远远就看到了"..SpouseName.."站立在大院门口，眼泪一下就流了出来，“"..SpouseName.."，对不起……”\n“不哭，不哭……没事了，啊。”");
						target:AddModifier("XianzheCD");
						player:AddModifier("XianzheCD");
						return false;
						end
						if Dfxg == CS.XiaWorld.g_emJHNpc_Feature.Apathy and Wfxg == CS.XiaWorld.g_emJHNpc_Feature.Tenacity and player.LuaHelper:GetGLevel() > target.LuaHelper:GetGLevel() and target.LuaHelper:GetModifierStack("Pochu") == 0 then--处冷，男坚
						self:SetTxt(""..player.Name.."见前方走来的"..target.Name.."身形窈窕、姿态妍丽，心动不已，要干得她欲仙欲死的念头一下就生了起来，胯下顿时怒龙高抬。\n"..player.Name.."毫不掩饰，“这位仙子，可愿与某共度春宵？”\n"..target.Name.."性子冷清，男女情爱之事，既不懂，也从未关心过。\n当初家中长辈怕她吃亏，特意为她寻了一家世清白、忠厚老实的修士作为双修道侣。\n可她不喜床笫欢爱，"..SpouseName.."只道她还未生情愫，便对她百般怜爱，未曾强行索取过，故而"..target.Name.."至今仍是处子。\n"..target.Name.."对"..SpouseName.."的歉意与感激多过男女之情，她曾想过，"..SpouseName.."是个好人，终有一日还要把身子给他的。\n\n只是她心中对男女欢爱仍难掩厌恶，遇到此事，心下更为不悦，面若冰霜，对"..player.Name.."连一个眼神都没有，径直自他身侧走了过去。\n这臭婊子，老子让你装，"..player.Name.."当着众人，只觉脸面无光，愤恨之下，暗施法力，在她身上留下了一道寻踪印记。\n待"..target.Name.."出城后，"..player.Name.."祭出诸般法器，不消片刻便将"..target.Name.."击败。\n“贱货，让你给老子装！”"..player.Name.."用鞋底踩着"..target.Name.."的脸颊，手握马鞭，"..target.Name.."的衣物已作褴褛状，再也包裹不住那诱人的胴体。\n"..target.Name.."不知他为何这般恼火，故而在凌辱之下，也未曾言语。\n“真当自己是仙女了？啊？”"..player.Name.."以为"..target.Name.."仍在故作高傲，心中原本泄出的怒火又蹭蹭的窜了起来。\n“就算你是仙女，在老子这儿，也得变成吃屎喝尿的狗。”"..player.Name.."掏出阳物对准"..target.Name.."的俏脸——“呲……”一边尿一边左右摇摆着阳物，觉得有趣极了。\n"..target.Name.."不懂他为什么笑，只是觉得这样很脏，无奈之下闭上了眼睛。\n"..player.Name.."看着眼前的尿人，自在畅怀，用阳物在她脸上拍打着，“来，给爷舔干净。”\n他可能只是想出气吧，虽然不知道哪里惹到他了，但"..target.Name.."觉得这并不有损自己的清白，若是还能留得性命，她回去定要将身子给了"..SpouseName.."，最好能给他生个儿子。\n心中思定，便问，“舔干净了就放我走吗？”\n“啊……嗯。”"..player.Name.."眼睛看向别处，应得模糊。\n"..target.Name.."以为他答应了，舔得仔细。\n“想不到你这妞还挺浪啊。”\n"..target.Name.."听不懂，只顾埋首舔着。\n“好了，爷的鸡巴也硬了，躺那儿，自己把腿掰开。”\n"..target.Name.."呆愣，"..player.Name.."看她不动，上前将她抱起，长枪直刺，路途之上却感到了些许阻隔——“你……你还是个雏？”\n"..target.Name.."吃痛之下也明白发生了什么，泪水默默流下，心如死灰，直觉得还不如死了算了。\n"..player.Name.."全然不理那些，只觉得今天真是捡到宝了，心中兴奋不已，怒龙又雄壮了几分。\n"..player.Name.."的粗壮阳物在"..target.Name.."的少女嫩屄中进出操弄着，伴随淫液带出的丝丝殷红不断刺激着"..player.Name.."的神经。\n"..player.Name.."不顾"..target.Name.."初经人事，不耐伐挞，直干到了次日天明。\n"..player.Name.."高呼痛快之时，发觉"..target.Name.."竟已昏死了过去。\n……\n\n"..target.Name.."睁眼时，看到"..SpouseName.."守在她的榻前，眼泪一下就流了出来，情绪再难抑制，“我对不起你……对不起你，你杀了我吧……”\n"..SpouseName.."只是抱着她，轻轻的拍着后背，“不哭，不哭……没事了，哎，好了，没事的。”");
						player.PropertyMgr.RelationData:AddRelationShip(target,"Chunv");
						target:AddModifier("Pochu");
						target:AddModifier("XianzheCD");
						player:AddModifier("XianzheCD");
						return false;
						end
						if Dfxg == CS.XiaWorld.g_emJHNpc_Feature.Apathy and Wfxg == CS.XiaWorld.g_emJHNpc_Feature.Greedy and player.LuaHelper:GetGLevel() > target.LuaHelper:GetGLevel() and target.LuaHelper:GetModifierStack("Pochu") == 0 then--处冷，男坚
						self:SetTxt(""..player.Name.."见前方走来的"..target.Name.."身形窈窕、姿态妍丽，心动不已，要干得她欲仙欲死的念头一下就生了起来，胯下顿时怒龙高抬。\n"..player.Name.."毫不掩饰，“这位仙子，可愿与某共度春宵？”\n"..target.Name.."性子冷清，男女情爱之事，既不懂，也从未关心过。\n当初家中长辈怕她吃亏，特意为她寻了一家世清白、忠厚老实的修士作为双修道侣。\n可她不喜床笫欢爱，"..SpouseName.."只道她还未生情愫，便对她百般怜爱，未曾强行索取过，故而"..target.Name.."至今仍是处子。\n"..target.Name.."对"..SpouseName.."的歉意与感激多过男女之情，她曾想过，"..SpouseName.."是个好人，终有一日还要把身子给他的。\n\n只是她心中对男女欢爱仍难掩厌恶，遇到此事，心下更为不悦，面若冰霜，对"..player.Name.."连一个眼神都没有，径直自他身侧走了过去。\n这臭婊子，老子让你装，"..player.Name.."当着众人，只觉脸面无光，愤恨之下，暗施法力，在她身上留下了一道寻踪印记。\n待"..target.Name.."出城后，"..player.Name.."祭出诸般法器，不消片刻便将"..target.Name.."击败。\n“贱货，让你给老子装！”"..player.Name.."用鞋底踩着"..target.Name.."的脸颊，手握马鞭，"..target.Name.."的衣物已作褴褛状，再也包裹不住那诱人的胴体。\n"..target.Name.."不知他为何这般恼火，故而在凌辱之下，也未曾言语。\n“真当自己是仙女了？啊？”"..player.Name.."以为"..target.Name.."仍在故作高傲，心中原本泄出的怒火又蹭蹭的窜了起来。\n“就算你是仙女，在老子这儿，也得变成吃屎喝尿的狗。”"..player.Name.."掏出阳物对准"..target.Name.."的俏脸——“呲……”一边尿一边左右摇摆着阳物，觉得有趣极了。\n"..target.Name.."不懂他为什么笑，只是觉得这样很脏，无奈之下闭上了眼睛。\n"..player.Name.."看着眼前的尿人，自在畅怀，用阳物在她脸上拍打着，“来，给爷舔干净。”\n他可能只是想出气吧，虽然不知道哪里惹到他了，但"..target.Name.."觉得这并不有损自己的清白，若是还能留得性命，她回去定要将身子给了"..SpouseName.."，最好能给他生个儿子。\n心中思定，便问，“舔干净了就放我走吗？”\n“啊……嗯。”"..player.Name.."眼睛看向别处，应得模糊。\n"..target.Name.."以为他答应了，舔得仔细。\n“想不到你这妞还挺浪啊。”\n"..target.Name.."听不懂，只顾埋首舔着。\n“好了，爷的鸡巴也硬了，躺那儿，自己把腿掰开。”\n"..target.Name.."呆愣，"..player.Name.."看她不动，上前将她抱起，长枪直刺，路途之上却感到了些许阻隔——“你……你还是个雏？”\n"..target.Name.."吃痛之下也明白发生了什么，泪水默默流下，心如死灰，直觉得还不如死了算了。\n"..player.Name.."全然不理那些，只觉得今天真是捡到宝了，心中兴奋不已，怒龙又雄壮了几分。\n"..player.Name.."的粗壮阳物在"..target.Name.."的少女嫩屄中进出操弄着，伴随淫液带出的丝丝殷红不断刺激着"..player.Name.."的神经。\n"..player.Name.."不顾"..target.Name.."初经人事，不耐伐挞，直干到了次日天明。\n"..player.Name.."高呼痛快之时，发觉"..target.Name.."竟已昏死了过去。\n……\n\n"..target.Name.."睁眼时，看到"..SpouseName.."守在她的榻前，眼泪一下就流了出来，情绪再难抑制，“我对不起你……对不起你，你杀了我吧……”\n"..SpouseName.."只是抱着她，轻轻的拍着后背，“不哭，不哭……没事了，哎，好了，没事的。”");
						player.PropertyMgr.RelationData:AddRelationShip(target,"Chunv");
						target:AddModifier("Pochu");
						target:AddModifier("XianzheCD");
						player:AddModifier("XianzheCD");
						return false;
						end
						if Dfxg == CS.XiaWorld.g_emJHNpc_Feature.Apathy and player.PropertyMgr.RelationData:IsRelationShipWith("Lover",target) == true and target.LuaHelper:GetModifierStack("Pochu") ~= 0 then--冷漠非处恋人
						self:SetTxt(""..player.Name.."手捧一簇鲜花，鼓起勇气向"..target.Name.."表明心迹。\n"..target.Name.."有些惊讶，"..player.Name.."在修行上曾帮她许多，"..target.Name.."始终视他为良师益友，曾有结为金兰之念，不料今日听到这番言语。\n"..target.Name.."是清冷之人，向来不喜男女之事，当初家中长辈怕她吃亏，特意为她寻了一家世清白、忠厚老实的修士作为双修道侣。\n"..SpouseName.."婚后待她极好，可她在床笫之间着实难掩厌恶之色，二人相交多次，难得欢愉，故而自觉亏欠丈夫许多。\n"..player.Name.."也是一个好人，这些年来，他的行止她也看在眼里，至纯至善，如今能鼓起勇气向她表白，她又怎么忍心伤害他。\n可若答应了，也实在对不起丈夫。\n\n“夫人，我这一生，别无所求，你若能与我一夕之欢，我真是死也无憾了。”"..player.Name.."握着她的手，诚恳至极。\n我真是个坏女人，千错万错都是我的错，若是九天之上当真有神明看着，所有罪责都让我一人承担吧。"..target.Name.."下定决心，“说好了，就这一次，万不能让"..SpouseName.."知道。”\n“我晓得了。”\n……\n\n"..target.Name.."平静的躺着，暗中思索，实在不知这事儿有何欢愉，竟使得世间千万男子耽溺其中。\n"..player.Name.."在她身下卖力耕耘，速度逐渐加快——"..target.Name.."似乎想到了什么，忙道，“你可不能射进……”\n“啊……”伴随着"..player.Name.."畅快的声音，"..target.Name.."感受到了身下喷涌而入的那一股股火热。\n"..target.Name.."生气了，但在她发火之前——“对不起，我错了，夫人实在太美了，我……我没能忍住。”"..player.Name.."面露愧色，"..target.Name.."气得憋闷。\n“这样好了，夫人，我帮你舔干净，放心，一定不会有孕的。”\n“算了，那里脏……”\n……\n\n天色将暗，二人就已返回了"..target.Name.."府上，待"..SpouseName.."归来，三人宴乐欢笑，一切如常。");
						target:AddModifier("XianzheCD");
						player:AddModifier("XianzheCD");
						return false;
						end
						if Dfxg == CS.XiaWorld.g_emJHNpc_Feature.Apathy and player.PropertyMgr.RelationData:IsRelationShipWith("Lover",target) == true and target.LuaHelper:GetModifierStack("Pochu") == 0 then--冷漠处恋人
						self:SetTxt(""..player.Name.."手捧一簇鲜花，鼓起勇气向"..target.Name.."表明心迹。"..target.Name.."听完，心中平生了几分愧意。\n"..player.Name.."在修行上曾帮她许多，"..target.Name.."始终视他为良师益友，曾也有结为金兰之念，但今日这事，是万万不能应下的。\n"..target.Name.."是清冷之人，向来不喜男女之事，当初家中长辈怕她吃亏，特意为她寻了一家世清白、忠厚老实的修士作为双修道侣。\n婚后，"..target.Name.."不愿承欢，"..SpouseName.."只道她还未生情愫，便对她百般怜爱，未曾强行索取过。\n"..target.Name.."对"..SpouseName.."有太多的感激与歉意，故而无论怎样，也不能负他。\n"..player.Name.."看"..target.Name.."拒绝的坚决，也不再纠缠，“罢了，希望此事莫伤了我们之间的情谊。”");
						target:AddModifier("XianzheCD");
						player:AddModifier("XianzheCD");
						return false;
						end
						if Dfxg == CS.XiaWorld.g_emJHNpc_Feature.Apathy then
						self:SetTxt(""..player.Name.."看"..target.Name.."身形窈窕、姿态妍丽，心动不已，径直言道，“仙子可愿与某双修？”\n"..target.Name.."只当此人是街市寻常的浪荡子，未作理会，转身便离去了。");
						return false;
						end
						if Dfxg == CS.XiaWorld.g_emJHNpc_Feature.Tenacity and player.LuaHelper:GetGLevel() - 5 > target.LuaHelper:GetGLevel() and target.LuaHelper:GetModifierStack("Pochu") ~= 0 then--坚毅非处1
						self:SetTxt(""..player.Name.."御剑而来，飒沓似流星。\n“"..target.Name.."，你可愿与本尊双修？”\n"..target.Name.."一心向道，从未理睬过那些俗世尘埃，向来也无半分痴怨情思。\n自己与"..SpouseName.."结成道侣也是门派与宗族的利益需要，二人平素就连相见也是难得，与他人双修，更是从未想过。\n只是，此人是一方大能，若能与之双修，于修行也大有裨益，"..target.Name.."心下犹豫，难以抉择。\n\n“本尊精于阴阳和合之道，与本尊双修过的女子日后修行皆一日千里，本尊这里还有一粒九转金丹，亦可绵延益寿、增进修为。”\n"..target.Name.."看着真人手中的丹药，感受着他身上散发着如高山洪海一般浩然而澎湃的法力，身下渐渐湿润。\n她以极不自然的步伐走上前去，伸手去接。\n"..player.Name.."也爽快，直把丹药给了她，“脱衣服吧。”\n这里虽是城外，却也离官道不远啊，"..target.Name.."惊愕，以手臂护住衣襟。\n“慌什么，你们一起。”\n"..player.Name.."祭出一个形似床榻的法器，床榻渐渐变大，"..target.Name.."惊觉塌上竟横卧着8名裸衣女子，这八人招摇妩媚，姿态万千，修为皆在自己之上，这般修士，也甘作他的性奴吗？\n“来来来，都给本尊跪好了，把骚屄露出来，本尊今日要花开九朵。”\n"..target.Name.."略作挣扎，还是解开了衣物的扣带，将外衣缓缓褪去。\n“妹妹，你可要快些，再这样，主人可就要生气了。”\n众女奴一边言语，一边七手八脚的把"..target.Name.."的衣服除了个一干二净。\n"..target.Name.."学着她们的样子跪着，众女跪作一排，屁股高高撅起，蜜缝与菊穴全都对着"..player.Name.."彻底坦露。\n"..target.Name.."从未做过这样的姿势，与丈夫的性爱也只是躺在那里，等他一番活动后草草收场。\n这般行径，还是在野外，真是羞也羞死了。\n"..player.Name.."轻轻挥舞手掌，法力带动着空气形成微风，“跟着风向，把你们的贱屁股给本尊扭起来。”\n"..target.Name.."没想到羞耻的还在后面，众女想来不是第一次玩这种游戏了，配合纯熟，"..target.Name.."却万分僵硬，多次打乱节奏。\n"..player.Name.."将她一脚踢翻，“你这贱狗，是想挨鞭子吗？”\n"..target.Name.."看着他手中的鞭形法器，充斥着恐怖的雷霆威能，心下畏惧不已，忙爬上前去，含住"..player.Name.."的脚趾，“主人，贱狗错了，贱狗是第一次，但贱狗会用心学的，求主人饶了贱狗吧。”\n"..player.Name.."指了指自己的阳物，“不想吃鞭子也行，就罚你喝本尊的圣水吧。”\n"..target.Name.."愣神，一时不知"..player.Name.."所说圣水是何物。\n一女奴在她耳畔轻声提醒，其他女奴你一言我一语——“这哪是惩罚啊，分明是赏赐，还不谢谢主人。”“就是，主人的圣水这么宝贵，我们平时争着抢着也喝不到啊。”\n"..target.Name.."磕头道谢，含住"..player.Name.."的鸡巴，忍着心里的恶心吞下那一股股液体，饮毕，惊觉这液体清香，自身的修为竟也增进了许多，忙上前为"..player.Name.."清理，还轻轻吸了一吸。\n"..player.Name.."与九女的欢愉持续了七天七夜，结束之时"..target.Name.."发觉自身修为大涨，十年苦修也难及这七日欢好之功，她求"..player.Name.."将她也收作女奴。\n“做本尊的女奴，日后就是本尊的人了，不能再与你丈夫有情爱绵缠，你可想好了？”\n我与他本就无甚情爱，这算的什么，"..target.Name.."跪地，头埋在"..player.Name.."脚下，“想好了，愿为主人女奴，求主人恩准。”\n"..player.Name.."点头，一道咒印打在"..target.Name.."身上，小腹下方竟多了一幅直透着淫靡气息的暗红淫纹。\n“这是本尊的贞操咒印，看你那小穴口，如今只有针眼大小，唯遇本尊阳具，才会张开。”\n听到这话，"..target.Name.."心想自己日后身心都属于这般强大的主人了，不住的激动、喜悦，身下淫水潺潺，好想主人操我。\n"..player.Name.."修为增加，"..target.Name.."修为增加,"..target.Name.."成为了"..player.Name.."的女奴隶，"..target.Name.."获得贞操咒印。");
						player.PropertyMgr.RelationData:AddRelationShip(target,"Luding1");
						target:AddModifier("Zhenchaosuo");
						player.LuaHelper:AddPracticeResource("Stage",player.LuaHelper:GetGLevel() * 1000);
						target.LuaHelper:AddPracticeResource("Stage",target.LuaHelper:GetGLevel() * 2000);
						target:AddModifier("XianzheCD");
						player:AddModifier("XianzheCD");
						return false;
						end
						if Dfxg == CS.XiaWorld.g_emJHNpc_Feature.Tenacity and player.LuaHelper:GetGLevel() - 5 > target.LuaHelper:GetGLevel() and target.LuaHelper:GetModifierStack("Pochu") == 0 then--坚毅处1
						self:SetTxt(""..player.Name.."御剑而来，飒沓似流星。\n“"..target.Name.."，你可愿与本尊双修？”\n"..target.Name.."一心向道，从未理睬过那些俗世尘埃，向来也无半分痴怨情思。\n自己与"..SpouseName.."结成道侣也是门派与宗族的利益需要，除了婚礼当日见过一次外，再无半面之缘，就是成婚之夜，也是分席睡下的，毕竟保留处子元阴于修行大有裨益，她可不愿为了"..SpouseName.."这个素不相识的男人绝了自己的通天之路。\n只是，眼下这人是修行界有名的一方大能，素闻其精通坎离既济之法，与他双修过得女子如今皆修行有成，不知是真是假，"..target.Name.."一时难以取舍。\n\n“本尊知你还是处子之身，除了你的容貌，本尊看中的恰是你这般修为的元阴之精。你放心，本尊破了你的身子，也会让你从本尊这里得到更大的好处，你看——”"..player.Name.."祭出一形似床榻的法器，床榻渐渐变大，"..target.Name.."惊觉塌上竟横卧着8名裸衣女子，这八人招摇妩媚，姿态万千，修为皆在自己之上，这般修士，也甘作他的性奴吗？\n“这八人一年之前不过凡体肉胎，正是跟了本尊，才有如此修为。”\n不过做了他一年性奴便抵我数十年的苦修吗？"..target.Name.."心动。\n“被那些不懂这阴阳妙法的男子破了身子，自是阻碍修行的，但你可知，孤阴不生，独阳不长，坎离相济、阴阳和合才是天地大道，如此修行方可通天。”"..player.Name.."面容严肃，一众女奴也都跟着劝道，“这等好事，你还不赶快答应？”“是啊，主人看上你是你的福分，我们平日里摇着屁股求主人操都求不来呢。”“我和主人双修一次就突破了一个小境界呢，这样的机缘，你还想什么呢？”\n"..target.Name.."沉默片刻，点头道，“好。”\n“那就脱衣服吧，和她们跪在一起。”\n这里虽是城外，却也离官道不远啊，"..target.Name.."一下慌了神。\n“怕什么，你看她们不也一样。”"..player.Name.."指了指前方未着寸缕跪作一排的女奴们。\n“是。”"..target.Name.."横下心，学着她们的样子跪着，屁股高高撅起，蜜缝与菊穴全都对着"..player.Name.."彻底坦露。\n"..target.Name.."从未有过男女情爱，这样的姿势，还是在野外，真是羞也羞死了。\n"..player.Name.."绕着女奴们转了一圈，手掌一一拍过她们的屁股，“真不错，本尊今日便要花开九朵。”\n“母狗恳请主人临幸。”众女音调整齐,言语同时一同扭着屁股，想来不是第一次玩这种游戏了，相互之间，配合纯熟。\n“嗯，那就从你这只贱狗开始好了。”"..player.Name.."佯作思索，用脚趾捅了捅"..target.Name.."的嫩穴。\n"..target.Name.."怕元阴有失，惹得"..player.Name.."不快，身子缩了缩，一边磕头一边道，“多谢主人，求……求主人操我。”她哪里说过这种话，不过是有样学样，心中羞臊万分。\n"..player.Name.."扶着阳物，在她娇嫩、湿润的洞口不断磨蹭着，就是不肯插入，“想让我操？说点好听的。”\n"..target.Name.."身下火热，瘙痒难耐，淫水已流了一地，感受着那不断磨蹭着阴唇的雄伟阳物，求之不得最是让人骚动、疯狂，“求……求主人了，我是主人的贱狗，屄是主人的，膜是主人的，我浑身上下都是主人的玩具，主人……主人快来玩我吧。”\n"..player.Name.."觉得火候差不多了，运功缓缓插入，调和阴阳……\n"..player.Name.."与九女的欢愉持续了七天七夜，"..target.Name.."自觉十年苦修也难及这七日欢好之功，她求"..player.Name.."将她也收作女奴。\n“做本尊的女奴，往后便不能与你丈夫有情爱绵缠，你可想好了？”\n我与他本就无甚情爱，这算的什么，"..target.Name.."跪地，头埋在"..player.Name.."脚下，“想好了，愿为主人女奴，求主人恩准。”\n"..player.Name.."点头，一道咒印打在"..target.Name.."身上，小腹下方竟多了一幅直透着淫靡气息的暗红淫纹。\n“这是本尊的贞操咒印，看你那小穴口，如今只有针眼大小，唯遇本尊阳具，才会张开。”\n听到这话，"..target.Name.."心想自己日后身心都属于这般强大的主人了，不住的激动、喜悦，身下淫水潺潺，好想主人操我。\n"..player.Name.."修为大幅上涨，"..target.Name.."修为大幅上涨,"..target.Name.."成为了"..player.Name.."的女奴隶，"..target.Name.."获得贞操咒印。");
						player.PropertyMgr.RelationData:AddRelationShip(target,"Luding1");
						target:AddModifier("Zhenchaosuo");
						player.LuaHelper:AddPracticeResource("Stage",player.LuaHelper:GetGLevel() * 2000);
						target.LuaHelper:AddPracticeResource("Stage",target.LuaHelper:GetGLevel() * 4000);
						target:AddModifier("XianzheCD");
						player:AddModifier("XianzheCD");
						return false;
						end
						if Dfxg == CS.XiaWorld.g_emJHNpc_Feature.Tenacity and player.LuaHelper:GetGLevel() > target.LuaHelper:GetGLevel() and target.LuaHelper:GetModifierStack("Pochu") ~= 0 then--坚毅非处2
						self:SetTxt(""..player.Name.."看中了那名女修，虽修为一般，但容貌非常，眸若秋水，眉如远山，兼具仙家气度，似天生得玄心道骨。\n"..player.Name.."献上礼物，向"..target.Name.."表达了双修的愿望。\n"..target.Name.."一心向道，从未理睬过那些俗世尘埃，向来也无半分痴怨情思。\n自己与"..SpouseName.."结成道侣也是门派与宗族的利益需要，二人平素就连相见也是难得，与他人双修，更是从未想过。\n本欲直接拒绝，忽然之间却想起自己识得此人，传闻"..player.Name.."精通坎离既济之法，与他双修过得女子如今皆修行有成，只是不知是真是假。\n"..player.Name.."看"..target.Name.."犹豫，欺身上前，递上了一物，耳畔暗语，“阴阳之法，合乎天道，双修于你我修行大有裨益，我还愿献上丹霞洞天千金难求的仙丹——三清灵纹丹，此丹有固本培元之效，以助仙子成就大道之基。”\n"..target.Name.."收下丹药，道了声好，便跟着"..player.Name.."，往他的洞府而去。\n\n"..player.Name.."的洞府之中，"..target.Name.."稍有几分尴尬，她素来无心男女情爱，与丈夫之间难得的性交，不过是躺在那里应付差事，任他施为而已。\n可，可如今这般情形，又当如何？\n"..player.Name.."看出她的窘状，微笑着安抚着，“别担心，交给我就好。”\n"..player.Name.."轻咬她的耳垂，爱抚之下，缓缓褪去她身上的衣物。\n"..target.Name.."觉得耳朵痒痒的，身上也很舒服，便也不再紧张的抗拒。\n待得二人坦诚相待，"..player.Name.."伏在"..target.Name.."身下，先以舌尖轻轻挑弄着。\n"..target.Name.."从未有过这样的体验，刺激之下，身子都酥了，可又觉得害羞，“那里，那里是尿尿的地方，脏……”\n“仙子的身子，就像是昆仑山巅的雪莲，纯净无暇。”\n"..player.Name.."见她渐渐接受，便一边用手指侍弄着阴蒂，一边将舌头往更深处顶去。\n"..target.Name.."以往与"..SpouseName.."的性交经历，只留下疼痛与肮脏的回忆，她不知女子在情爱之中，竟能这般愉快。\n"..target.Name.."闭上双目，只觉自身在御剑飞行，直上云霄，待极乐之时，不禁叫出声来——“啊！……”潮水喷涌，射了"..player.Name.."一身，也浸湿了床榻。\n"..target.Name.."大脑空白，只觉身在天上，两腿紧闭，身子痉挛不已。待睁眼觉察到发生了何事时，血色上涌，羞臊万分，“我，我不是故意的。”\n"..player.Name.."轻轻地抱了抱她，“刚才的你，是最美的。”\n"..target.Name.."不敢看他。\n"..player.Name.."取了一件尺寸合适的玉势，缓缓插入"..target.Name.."美屄的同时，在身后舔弄着"..target.Name.."的菊穴。\n有了前面的经历，"..target.Name.."也不再压抑自己，专心感受着自己的前后两穴被"..player.Name.."以高超的技法侍弄着。\n"..player.Name.."见她欢愉的表现愈渐强烈，加快了手中抽插的速度，且伴随着玉势的抽插，"..player.Name.."的舌尖也有节奏的一次一次向她后庭的深处顶去——“啊！……啊……”潮水泛滥而不绝，一股又一股的接连喷射，"..target.Name.."此时方知，男女之事，竟是人间至乐。\n……\n二人交欢，直至天明，结束之时，"..target.Name.."后庭、小穴甚至是双乳之上，都淌着"..player.Name.."白浊的阳精。\n"..target.Name.."运起功法，发现自己的修为竟也增进了许多，欢喜之下，二人相约他日再续绵缠。\n事毕，双方修为均大量上升，"..player.Name.."看着四下散落的阴精，心满意足的眯着眼笑了笑。");
						player.LuaHelper:AddPracticeResource("Stage",player.LuaHelper:GetGLevel() * 2000);
						target.LuaHelper:AddPracticeResource("Stage",target.LuaHelper:GetGLevel() * 4000);
						target:AddModifier("XianzheCD");
						player:AddModifier("XianzheCD");
							if target.LuaHelper:GetGLevel() >9 then
							player.LuaHelper:DropAwardItem("Item_yinjin5",4);
							elseif target.LuaHelper:GetGLevel() >6 then
							player.LuaHelper:DropAwardItem("Item_yinjin4",4);
							elseif target.LuaHelper:GetGLevel() >3 then
							player.LuaHelper:DropAwardItem("Item_yinjin3",4);
							elseif target.LuaHelper:GetGLevel() >0 then
							player.LuaHelper:DropAwardItem("Item_yinjin2",4);
							else
							player.LuaHelper:DropAwardItem("Item_yinjin1",4);
							end
						return false;
						end
						if Dfxg == CS.XiaWorld.g_emJHNpc_Feature.Tenacity and player.LuaHelper:GetGLevel() > target.LuaHelper:GetGLevel() and target.LuaHelper:GetModifierStack("Pochu") == 0 then--坚毅处2
						self:SetTxt(""..player.Name.."看中了那名女修，虽修为一般，但容貌非常，眸若秋水，眉如远山，兼具仙家气度，似天生得玄心道骨。\n"..player.Name.."献上礼物，向"..target.Name.."表达了双修的愿望。\n"..target.Name.."一心向道，何曾理会过这男女痴缠，就是与丈夫的新婚之夜，也是分席而卧的，除了维持道心通明、空静玄览外，也是为了守住自身的处子元阴，此女子先天之气也，消散则于道基大有损害。\n且这人与我素未谋面，开口便是双修话语，这等轻浮浪子，真是令人生厌。\n"..target.Name.."将礼物掷回，转身便御剑远去。");
						return false;
						end
						if Dfxg == CS.XiaWorld.g_emJHNpc_Feature.Tenacity and target.LuaHelper:GetModifierStack("Pochu") ~= 0 then
						self:SetTxt(""..player.Name.."远处便见那女修气骨非凡，若能与之双修，定可修为大进。\n"..player.Name.."上前献上礼物，向"..target.Name.."表达了双修的愿望。\n"..target.Name.."一心向道，何曾理会过这男女痴缠，自己就是与"..SpouseName.."结成道侣，那也是门派与宗族的利益需要。\n况你这资质，又如何配得上我？\n"..target.Name.."将礼物掷回，转身便御剑远去。");
						return false;
						end
						if Dfxg == CS.XiaWorld.g_emJHNpc_Feature.Tenacity and target.LuaHelper:GetModifierStack("Pochu") == 0 then
						self:SetTxt(""..player.Name.."远处便见那女修气骨非凡，若能与之双修，定可修为大进。\n"..player.Name.."上前献上礼物，向"..target.Name.."表达了双修的愿望。\n"..target.Name.."一心向道，何曾理会过这男女痴缠，就是与丈夫的新婚之夜，也是分席而卧的，除了维持道心通明、空静玄览外，也是为了守住自身的处子元阴，此女子先天之气也，消散则于道基大有损害。\n且这人与我素未谋面，开口便是双修话语，这等轻浮浪子，真是令人生厌。\n"..target.Name.."将礼物掷回，转身便御剑远去。");
						return false;
						end
						self:SetTxt("所有判定均未成功，理论上不太可能，如果出现了当前文字，请加群上报bug，另外作者不保证修23333");
					end
					return false;
				else
					if target.Sex == CS.XiaWorld.g_emNpcSex.Male then--女男ntr
					self:SetTxt(""..target.Name.."和妻子"..SpouseName.."，非常美满，想来ntr的机会不算太多其实就是还没写完");
					else--女女ntr
					self:SetTxt(""..target.Name.."和丈夫"..SpouseName.."的婚姻非常美满，而且老娘是女的，操你妈别乱点！");
					end
					return false;
				end
			end
		end
	end--ntr判定失败开始色诱剧本
	if player.Sex == CS.XiaWorld.g_emNpcSex.Male then
	self:SetTxt("男色诱女还没写完！");
	else
			if Dfxg ~= CS.XiaWorld.g_emJHNpc_Feature.Apathy then--对方性格不是冷漠
				if meili >= random then--魅力检定，我方女角色魅力大于1~14的随机数既判定成功
					if juqing == 1 then--啪啪啪判定，双方都很愉快
						JianghuMgr:AddKnowNpcData(target.JiangHuSeed,CS.XiaWorld.g_emJHNpcDataType.None,50);
						target:AddModifier("XianzheCD");
						player:AddModifier("XianzheCD");
						self:SetTxt(""..player.Name.."尝试用自己的身体诱惑对方，只见"..player.Name.."解开罗裙之际，"..target.Name.."便迎上前来小心翼翼的捧起了"..player.Name.."玉足。\n"..target.Name.."的舌尖在"..player.Name.."足间的每一道缝隙中来回穿梭，并不时的将其含入口中细细吮吸，并顺势解开"..player.Name.."的亵裤。\n"..player.Name..":快，快放进来……人家……\n这是一场令双方均很愉快的双修。");
					else
						if juqing == 2 then--啪啪啪判定，我很很愉快，对方不愉快
							JianghuMgr:AddKnowNpcData(target.JiangHuSeed,CS.XiaWorld.g_emJHNpcDataType.None,-30);
							target:AddModifier("NalitongCD");
							player:AddModifier("XianzheCD");
							self:SetTxt(""..player.Name.."尝试用自己的身体诱惑对方，见对方目色迷离，"..player.Name.."乘势而起一招观音坐莲将对方骑在身下，对方硕大的阳物让"..player.Name.."甚至忘记了自己的原本目的，只是沉迷于肉欲的快感之中，而后在激烈的肉搏战中，对方因为没有跟上"..player.Name.."扭动的速度，折伤了小兄弟，虽然自己活得的快感，但是对方显然不是很开心。");
						else
							if juqing == 3 then--啪啪啪判定，我不愉快，对方愉快
								JianghuMgr:AddKnowNpcData(target.JiangHuSeed,CS.XiaWorld.g_emJHNpcDataType.None,100);
								target:AddModifier("XianzheCD");
								player:AddModifier("NalitongCD");
								self:SetTxt(""..player.Name.."尝试用自己的身体诱惑对方，没想到"..target.Name.."色心一起就管不得其他许多了，一顿猛烈到如同狂风骤雨般的冲刺，让"..player.Name.."觉得下体仿佛都快被戳烂了，随着对方一泡热力十足的阳精灌注于自己体内后，对方终于缓下的动作，就这么直挺挺的插着自己睡了过去。");
							else
								JianghuMgr:AddKnowNpcData(target.JiangHuSeed,CS.XiaWorld.g_emJHNpcDataType.None,100);
								player.PropertyMgr.RelationData:AddRelationShip(target,"Luding2");
								target:AddModifier("XianzheCD");
								player:AddModifier("XianzheCD");
								target.LuaHelper:SetCamp(g_emFightCamp.Player, false)
								self:SetTxt(""..player.Name.."假装不经意间的走光引得"..target.Name.."色欲大起，那白玉般的足尖尚未完全从履中脱出，"..target.Name.."便迫不及待的连带着鞋履捧起了这天赐之物，跪倒在地如同舔舐牛奶的猫咪一般舔舐了起来，只听轻笑见"..player.Name.."解下罗裙，蜜穴完完全全展露与"..target.Name.."眼前，"..target.Name.."仿佛获得了万般激励，顿时化为发情的公狗，于"..player.Name.."身上驰骋了数个时辰，知道阳关大泄，此时此刻"..target.Name.."才仿佛领悟到了活着的真正意义，成为"..player.Name.."石榴裙下的俘虏之一。");
							end
						end
					end
				else--丑B要有自知之明
				self:SetTxt(""..target.Name.."：丑b，滚，别靠近我！");
				target:AddModifier("XianzheCD");
				end
			else--对方性格冷漠
				if player.LuaHelper:GetGLevel() > target.LuaHelper:GetGLevel() then
					if Wfxg == CS.XiaWorld.g_emJHNpc_Feature.Greedy then--女主比对方实力强，且是贪婪性格
					player:AddModifier("XianzheCD");
					target:AddModifier("NalitongCD");
					player.PropertyMgr:AddMaxAge(5);
					target.PropertyMgr:AddMaxAge(- 10);
					player.PropertyMgr.RelationData:AddRelationShip(target,"Luding2");
					target.LuaHelper:SetCamp(g_emFightCamp.Player, false)
					self:SetTxt(""..target.Name.."冷着脸对"..player.Name.."说了一个“滚”字，然而这是修真界，是要凭借实力说话的地方，恼羞成怒的"..player.Name.."施展秘术定住了"..target.Name.."提裙跨坐于"..target.Name.."身上自顾自的摇摆了起来……\n"..player.Name.."榨取了整整四个时辰，直到"..target.Name.."的下体再也射不出任何精元，"..player.Name.."还是依旧没有放过"..target.Name.."。\n最终，欲火融化了坚冰，"..player.Name.."驯服了"..target.Name.."。");
					else
						if Wfxg == CS.XiaWorld.g_emJHNpc_Feature.Tenacity then--女主比对方实力强，且是坚毅性格
						player:AddModifier("XianzheCD");
						target:AddModifier("NalitongCD");
						self:SetTxt(""..target.Name.."冷着脸对"..player.Name.."说了一个“滚”字,只听一阵狂放的笑声从"..player.Name.."口中传出，只见"..player.Name.."制住"..target.Name.."后便开始把玩着对方的下体，口中还呢喃着什么“老娘想要的东西，还没有得不到的，人！也一样！”边跨身坐在了"..target.Name.."肚下三寸处开始摇摆了起来……\n事毕，"..player.Name.."提上罗裙后，还给了"..target.Name.."下体一脚嘴里嘟囔着些什么“中看不中用，银样镴枪头”之类的怪话。");
						else
						self:SetTxt(""..target.Name.."冷着脸对"..player.Name.."说了一句“滚”,显然冷漠性格的人并不吃色诱这一套。");
						end
					end
				else
				self:SetTxt(""..target.Name.."冷着脸对"..player.Name.."说了一句“滚”,显然冷漠性格的人并不吃色诱这一套。");
				end
			end
		end
	else
	self:SetTxt("对方刚刚被干过对方休息一会把……");
	end
end