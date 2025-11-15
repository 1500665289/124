local tbModifier = GameMain:GetMod("_ModifierScript"):GetModifier("VesselOfHuman");
local BE = GameMain:GetMod("SonVesselOfHuman");
local time = {}

function BE:SwtichModifier(bind)
local npc = bind
if npc.PropertyMgr:FindModifier("VesselOfHumanOpen") == nil then
npc.PropertyMgr:AddModifier("VesselOfHumanOpen")
else
npc.PropertyMgr:RemoveModifier("VesselOfHumanOpen")
end
end

--进入modifier
function tbModifier:Enter(modifier, npc)
if npc.IsDisciple then
local curling = npc.LingV
npc:AddLing(-curling)
npc.PropertyMgr:AddMaxAge(curling ^ 0.1)
end
npc:AddBtnData("开关","res/Sprs/ui/icon_hand","GameMain:GetMod('SonVesselOfHuman'):SwtichModifier(bind)","开启或关闭子吸天梭的效果。")
end

--modifier step
function tbModifier:Step(modifier, npc, dt)
local id = npc.ID
if time[id] == nil then
time[id] = 0
end
if time[id] >= 10 and npc.IsDisciple then
if npc.LingV >= 500 then
npc:AddLing(-500)
npc.PropertyMgr:AddMaxAge(0.25)
end
time[id] = 0
end
time[id] = time[id] + dt
end

--离开modifier
function tbModifier:Leave(modifier, npc)
if npc.PropertyMgr:FindModifier("VesselOfHumanOpen") then
npc.PropertyMgr:RemoveModifier("VesselOfHumanOpen")
end
npc:RemoveBtnData("开关")
end


