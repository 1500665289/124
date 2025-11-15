local Prison = GameMain:GetMod("Prison");--先注册一个新的MOD模块
xlua.private_accessible(CS.XiaWorld.AreaMgr);
xlua.private_accessible(CS.XiaWorld.Thing);
xlua.private_accessible(CS.XiaWorld.ThingsData);
xlua.private_accessible(CS.XiaWorld.Npc);
xlua.private_accessible(CS.XiaWorld.MainManager); 
xlua.private_accessible(CS.XiaWorld.AreaBase); 
xlua.private_accessible(CS.Panel_ThingInfo); 
--[[
local mapAreaTypes = CS.XiaWorld.AreaMgr.m_mapAreaTypes
if mapAreaTypes:ContainsKey("Prison") ~= true then
	local a = CS.XiaWorld.AreaTypeDef();
	a.Name = "Prison";
	a.Class = "AreaRoom";
	a.AreaType = "Prison";	m_mapAreaTypes:Add(a.Name,a)
end
]]--
Prison.flag = false;

-- 模块初始化
function Prison:OnInit()
	print("Prison init");
	Prison.IsLoaded = false;
end

-- 模块进入事件
function Prison:OnEnter()
	print("Prison Enter");
end

-- 显示监狱相关按钮
function Prison.ShowBtn(e,n,obj)
	local area = obj[0];
	-- 获取当前操作面板
	local Panel = CS.Wnd_GameMain.Instance.PanelThingInfo.Panel;
	-- 获取操作面板按钮组
	local BtnList = Panel.m_cmdbnts;
	-- 获取按钮组
	local PrisonList = Panel:GetChild("PrisonList");
	if BtnList.numChildren > 0 then
		PrisonList.y = BtnList.y + BtnList.height + 4;
	else
		PrisonList.y = BtnList.y;
	end
	-- 获取按钮组下设为监狱按钮
	local btn1 = PrisonList:GetChild("PrisonBtn");
	-- 获取按钮组下设为鸡鸭按钮
	local btn2 = PrisonList:GetChild("PrisonBtn_JiYa");
	-- 如果区域定义为 监狱
		if area.def.AreaType == "Prison" then
			-- 显示按钮组
			PrisonList.visible = true;
			btn1.visible = true;
			btn1.title = "取消监狱"
			btn1.data = 1;
			-- 显示鸡鸭
			btn2.visible = true;
		elseif area.def.AreaType == "Room" then
			PrisonList.visible = true;
			btn1.visible = true;
			btn1.title = "设为监狱"
			btn1.data = 0;
			-- 隐藏鸡鸭
			btn2.visible = false;
		else
			-- 全部隐藏
			btn1.visible = false;
			btn2.visible = false;
		end
end

-- 隐藏监狱按钮
function Prison.HideBtn()
	-- 隐藏按钮组
	local PrisonList = CS.Wnd_GameMain.Instance.PanelThingInfo.Panel:GetChild("PrisonList");
	PrisonList.visible = false;
end

-- 点击事件
function Prison.onClickItem(Context)
	Prison:OnClickbtn(Context);
end

-- 按钮点击事件
function Prison:OnClickbtn(Context)
	-- 点击的按钮
	local btn = Context.data;
	-- 如果是监狱按钮，就设置房间定义
	if btn.name == "PrisonBtn" then
		local area = CS.Wnd_GameMain.Instance.PanelThingInfo.area
		if not area then
			print("没有找到区域")
			return;
		end
		if btn.data == 0 then
			area:ChangeName("监狱")
			area.def = AreaMgr:GetDef("Prison");
		elseif btn.data == 1 then
			area:ChangeName("房间")
			area.def = AreaMgr:GetDef("Room");
		end
	-- 鸡鸭按钮则执行鸡鸭脚本
	elseif btn.name == "PrisonBtn_JiYa" then
		Map.Things:GetNpcsLua(Prison.JiYa)
	end
end

-- NPC离开区域事件
function Prison.onNpcLeaveArea(Event,Npc,Params)
	local oldKey = Params[0];
	-- 获取区域ID
	local Area = AreaMgr:FindAreaByID(Params[1]);
	-- 如果是监狱且NPC处于监狱状态，则触发越狱事件
	if Area.def.AreaType == "Prison" then
		if Npc.PropertyMgr:FindModifier("Prison_Modifier") then
			if Npc.IsDeath then		
				Npc:RemoveModifier("Prison_Modifier");
			else
				print("有人尝试越狱！" .. Npc.Key .. "\n CurKey:".. oldKey);
				-- 删除NPC当前任务
				if Npc.JobEngine.CurJob ~= nil then
					Npc.JobEngine:ClearJob();
				end
				-- 设置NPC坐标
				local newKey = World:Position2GridKey(Area.Center);
				Npc.Pos = Area.Center;
				Npc.Key = newKey;
				Npc.LastWalkable = newKey;
				-- 传送NPC
				Npc:OnMoved();
				Map.Things:RemoveNpc2Key(Npc,oldKey);
				Map.Things:AddNpc2Key(Npc);
				Npc:Draw();
			end
		end
	end
end

-- NPC进入区域事件
function Prison.onNpcEnterArea(Event,Npc,Params)
	local Key = Params[0];
	local Area = AreaMgr:FindAreaByID(Params[1]);
	if Area.def.AreaType == "Prison" and Npc.IsAlive then
	--if Area.def.Name == "Prison" and Npc.Camp == CS.XiaWorld.Fight.g_emFightCamp.Enemy then
		--print("有人进入监狱！");
		if Npc.Camp == CS.XiaWorld.Fight.g_emFightCamp.Enemy and Npc.HealthState ~= CS.XiaWorld.g_emNpcHealthState.Normal then
		--if Npc.Camp == CS.XiaWorld.Fight.g_emFightCamp.Player then
			print("收纳到一个犯人");
			Npc:AddModifier("Prison_Modifier");
			Npc.LuaHelper:SetCamp(g_emFightCamp.Friend, false)
		end
	end
end

function Prison:OnStep(dt)--请谨慎处理step的逻辑，可能会影响游戏效率
	--print("MoreNPC Step"..dt);
	
	--if Prison.IsLoaded == false and CS.Wnd_GameMain.Instance ~= nil then
	if Prison.IsLoaded == false and CS.Wnd_GameMain.Instance.PanelThingInfo.Panel then
		print("监狱图标加载中")		
		local Prison = GameMain:GetMod("Prison");
		xlua.private_accessible(CS.Panel_ThingInfo);
		local SysList = CS.Wnd_GameMain.Instance.PanelThingInfo.Panel.m_cmdbnts; 
		local BtnList = CS.XiaWorld.UI.InGame.UI_Panel_ThingInfo:CreateInstance().m_cmdbnts;
		BtnList.name = "PrisonList"
		BtnList.height = SysList.height;
		BtnList.y = SysList.y;
		BtnList.x = SysList.x
		
		local a = BtnList:AddItemFromPool()
		a.name = "PrisonBtn_JiYa";
		a.title = "羁押"
		a.selected = false;
		a.m_inputkey.text = "";
		a.m_shift.visible = false;
		a.tooltips = "弟子将会搜索地图上所有可羁押的敌人，并搬运到监狱里来。";
		a.icon = "res/Sprs/ui/icon_shengchan01";
		
		--a.onClick:Add(function(aa) aa.sender.selected = false;
		--local a = CS.Wnd_GameMain.Instance.PanelThingInfo.area; 
		--a:ChangeName("监狱");
		--a.def = AreaMgr:GetDef("Prison"); end);
		
		local b = BtnList:AddItemFromPool()
		b.name = "PrisonBtn";
		b.title = "设为监狱"
		b.selected = false;
		b.m_inputkey.text = "";
		b.m_shift.visible = false;
		b.tooltips = "将这个房间设为监狱";
		b.icon = "res/Sprs/ui/icon_shengchan01";
		b.onClick:Add(Prison.OnClick);
		--b.onClick:Add(function(aa) aa.sender.selected = false; Map.Things:GetNpcsLua(Prison.JiYa) end);
		local result = CS.Wnd_GameMain.Instance.PanelThingInfo.Panel:AddChild(BtnList)
		if result == nil then
			CS.Wnd_Message.Show(nil, 1, nil, true, "出错啦！", 0, 0, "右侧快捷按钮生成失败，请将BUG反馈给作者。反馈QQ群：780475084");
			return;
		end
		BtnList.onClickItem:Add(Prison.onClickItem);
		
		GameMain:GetMod("_Event"):RegisterEvent(g_emEvent.SelectArea, Prison.ShowBtn, "Prison");
		GameMain:GetMod("_Event"):RegisterEvent(g_emEvent.SelectPlant, Prison.HideBtn, "Prison");
		GameMain:GetMod("_Event"):RegisterEvent(g_emEvent.SelectBuilding, Prison.HideBtn, "Prison");
		GameMain:GetMod("_Event"):RegisterEvent(g_emEvent.SelectItem, Prison.HideBtn, "Prison");
		GameMain:GetMod("_Event"):RegisterEvent(g_emEvent.SelectNpc, Prison.HideBtn, "Prison");
		GameMain:GetMod("_Event"):RegisterEvent(g_emEvent.NpcLeaveArea, Prison.onNpcLeaveArea, "Prison");
		GameMain:GetMod("_Event"):RegisterEvent(g_emEvent.NpcEnterArea, Prison.onNpcEnterArea, "Prison");
		Prison.IsLoaded = true;
		
	end
	
end

function Prison.JiYa(Npc)
	local area = CS.Wnd_GameMain.Instance.PanelThingInfo.area
	if Npc.Camp == CS.XiaWorld.Fight.g_emFightCamp.Enemy and Npc.HealthState ~= g_emNpcHealthState.Normal and Npc.IsSmartRace then
		Npc:SetPostion(area.Center)
		Npc:AddModifier("Prison_Modifier");
		return true;
	else
		return false;
	end
end

function Prison:OnBeforeInit()
	print("Prison OnBeforeInit");
	local def = CS.XiaWorld.AreaMgr.Instance:GetDef("Prison");
		if def then
		print("找到监狱:"..tostring(def));
		local mapAreaTypes = CS.XiaWorld.AreaMgr.m_mapAreaTypes
		for k,v in pairs(mapAreaTypes) do
			if v.AreaType == "Prison" then
				v.Name = "Room";
			end
		end
	end
	
end

function Prison:OnLeave()
	print("Prison Leave");
end

function Prison:OnSave()--系统会将返回的table存档 table应该是纯粹的KV
	print("Prison OnSave");
	local mapAreaTypes = CS.XiaWorld.AreaMgr.m_mapAreaTypes
	for k,v in pairs(mapAreaTypes) do
		if v.AreaType == "Prison" then
			v.Name = "Prison";
		end
	end
end

function Prison:OnLoad(tbLoad)--读档时会将存档的table回调到这里
	print("Prison OnLoad");
end