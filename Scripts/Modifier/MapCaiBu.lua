local tbModifier = GameMain:GetMod("_ModifierScript"):GetModifier("MapCaiBu");


function tbModifier:Enter(modifier, npc)
npc.JobEngine:BeginJob(CS.XiaWorld.JobMgr.Instance:CreateJob("JobIdle",nil,CS.XLua.Cast.Int32(20),"ksXL","采补"));
self.flag = 0
self.time = 0
self.jump = 0
self.target = GameMain:GetMod("MapCaiBu"):GetNpc()[2]
end


function tbModifier:Step(modifier, npc, dt)
self.time = self.time + dt
self.jump = self.jump + dt
if self.time > 19.5 then
self.flag = 1
npc.PropertyMgr:RemoveModifier(modifier.def.Name)
end
xlua.private_accessible(CS.XiaWorld.FightMapMgr)
local school = CS.XiaWorld.FightMapMgr.Instance
if school.MapSchool > 0 and school.IsSchoolCore and school.IsSubmission == false and self.jump > 0.1 then
local target = self.target
local eye = 0
local Key = npc.Key
local R1,R2,R3,R4 = 15,10,6,3
self.jump = 0;

local EnemyList1 = GridMgr:GetEllipse(GridMgr:Key2P(Key)[0] - R1 , GridMgr:Key2P(Key)[1] - R1, GridMgr:Key2P(Key)[0] + R1 ,GridMgr:Key2P(Key)[1] + R1)
for k,v in pairs(EnemyList1) do
local npc1 = Map.Things:GetThingAtGrid(v, g_emThingType.Npc)
	if npc1 ~= nil and npc1 ~= npc and npc1 ~= target then
		npc1:Face2Pos(npc.Pos, false);
		if CS.XiaWorld.GameDefine.CanSee(npc1, npc) then
			school:SetNpcEyeLevel(npc, 1)
			CS.Wnd_DialogboxWindow.Get("(￣m￣）？", npc1, 5, 0, 0.5, 0)
			eye = 0
		end
	end
end

local EnemyList2 = GridMgr:GetEllipse(GridMgr:Key2P(Key)[0] - R2 , GridMgr:Key2P(Key)[1] - R2, GridMgr:Key2P(Key)[0] + R2 ,GridMgr:Key2P(Key)[1] + R2)
for k,v in pairs(EnemyList2) do
local npc2 = Map.Things:GetThingAtGrid(v, g_emThingType.Npc)
	if npc2 ~= nil and npc2 ~= npc and npc2 ~= target then
		npc2:Face2Pos(npc.Pos, false);
		if CS.XiaWorld.GameDefine.CanSee(npc2, npc) then
			school:SetNpcEyeLevel(npc, 2)
			CS.Wnd_DialogboxWindow.Get("(。_。)？？", npc2, 5, 0, 0.5, 0)
			eye = 1
		end
	end
end

local EnemyList3 = GridMgr:GetEllipse(GridMgr:Key2P(Key)[0] - R3 , GridMgr:Key2P(Key)[1] - R3, GridMgr:Key2P(Key)[0] + R3 ,GridMgr:Key2P(Key)[1] + R3)
for k,v in pairs(EnemyList3) do
local npc3 = Map.Things:GetThingAtGrid(v, g_emThingType.Npc)
	if npc3 ~= nil and npc3 ~= npc and npc3 ~= target then
		npc3:Face2Pos(npc.Pos, false);
		if CS.XiaWorld.GameDefine.CanSee(npc3, npc) then
			school:SetNpcEyeLevel(npc, 3)
			CS.Wnd_DialogboxWindow.Get("⊙o⊙？？？", npc3, 5, 0, 0.5, 0)
			eye = 2
		end
	end
end

local EnemyList4 = GridMgr:GetEllipse(GridMgr:Key2P(Key)[0] - R4 , GridMgr:Key2P(Key)[1] - R4, GridMgr:Key2P(Key)[0] + R4 ,GridMgr:Key2P(Key)[1] + R4)
for k,v in pairs(EnemyList4) do
local npc4 = Map.Things:GetThingAtGrid(v, g_emThingType.Npc)
	if npc4 ~= nil and npc4 ~= npc and npc4 ~= target then
		npc4:Face2Pos(npc.Pos, false);
		CS.Wnd_DialogboxWindow.Get("(⊙ˍ⊙)！", npc4, 5, 0, 0.5, 0)
		eye = 3
	end
end

if eye == 3 then
self.flag = 2
CS.Wnd_DialogboxWindow.Get("被发现了！", npc, 5, 0, 0.5, 0)
npc.PropertyMgr:RemoveModifier(modifier.def.Name)
elseif eye == 2 then
CS.Wnd_DialogboxWindow.Get("好像要被发现了！", npc, 5, 0, 0.5, 0)
elseif eye == 1 then
CS.Wnd_DialogboxWindow.Get("好像有什么动静？", npc, 5, 0, 0.5, 0)
else
CS.Wnd_DialogboxWindow.Get("一切都挺安静.....", npc, 5, 0, 0.5, 0)
end

end
end

--离开modifier
function tbModifier:Leave(modifier, npc)
npc.JobEngine:ClearJob()
if self.flag == 1 then
MapStoryMgr:TriggerStorySelection("Story_MapCaiBu",npc)
elseif self.flag == 2 then
world:ShowMsgBox("[color=#D06508]合欢派余孽"..npc.Name.."竟敢在门派中采补弟子，接招！[/color]","发现采补")
CS.XiaWorld.FightMapMgr.Instance:BeginSchoolAttack(npc,true)
else
end
self.time = 0
self.flag = 0
self.jump = 0
self.target = nil;
end


