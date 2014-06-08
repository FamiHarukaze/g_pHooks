-- https://www.youtube.com/user/INTELINSIDECHANNEL

local _R = debug.getregistry();
local _G = _G;
local cheat_notify = function(x) _G.chat.AddText(_G.Color(240,240,0,255),"g_pHooks| ",_G.Color(240,240,240),x); end;
local g_pGT = _R.Player.Team;
local g_pIV = _R.Player.InVehicle;
local g_pIA = _R.Player.Alive;
local g_pLTW = _R.Entity.LocalToWorld;
local g_pGOBBC = _R.Entity.OBBCenter;
local g_pGC = function(x) if !x then return; end return g_pLTW(x,g_pGOBBC(x)); end;
local g_pEP = _R.Entity.EyePos;
local g_pTANG = _R.Vector.Angle;
local g_pIDRMNT = function(x) return false; end; --_R.Entity.IsDormant; -- This is going to be in the next Garry's Mod Update
local g_pWEP = _R.Player.GetActiveWeapon;

--[[ // Todo: Unload Hooks
local cheat_hooks = {};
local function cheat_unload()
	for k = 0, #cheat_hooks do local v = cheat_hooks[k];
	_G.hook.Remove();
	end
end
]]

local g_pLocalPlayer = _G.LocalPlayer();
local g_pAimbotTarget = nil;
local g_CalcViewAngle = _G.Angle();

local function g_IsValidTarget(pEnt)
	if (!pEnt) then return false; end
	
	if (g_pIDRMNT(pEnt)) then return false; end
	
	if pEnt:IsPlayer() then
		if (pEnt == g_pLocalPlayer) then return false; end
	
		if (!g_pIA(pEnt)) then return false; end 
		
		if (g_pIV(pEnt)) then return false; end

		if (g_pGT(pEnt) == TEAM_SPECTATOR) then return false; end
	end
	
	return true;
end

local function g_AimbotThread()
	g_pAimbotTarget = nil;
	local pPlayers = player.GetAll(); -- local pEntities = ents.GetAll(); // Incaze you want to aim at npcs
	for i = 1, #pPlayers do local pEnt = pPlayers[i]; -- Now let's iterate though players... 'i' is the integrer and 'pEnt' is the player entity
		if (!g_IsValidTarget(pEnt)) then continue; end
		g_pAimbotTarget = pEnt;
	end
end

local function g_GetAimPosition(pEnt)
	local vPrediction = _G.Vector(0,0,0); -- Make your own prediction, faggot.

	return (g_pGC(pEnt) + vPrediction);
end

local function g_Aim(CUserCmd)
	if (g_pAimbotTarget ~= nil) then
		local vPosition = g_GetAimPosition(g_pAimbotTarget);
		local aAngles = g_ToAngles(vPosition - g_pEP(g_pLocalPlayer))
		aAngles.p = _G.math.NormalizeAngle(aAngles.p);
		aAngles.y = _G.math.NormalizeAngle(aAngles.y);
				
		CUserCmd:SetViewAngles(aAngles);
	end
end

local function hooked_CreateMove(CUserCmd)

	g_AimbotThread(); -- Search for a target

	g_Aim(CUserCmd); -- Aim at the target if any.
	
	g_CalcViewAngle = CUserCmd:GetViewAngles();

end

local function hooked_CalcView( ply, origin, angles, fov )
	local pWeapon = g_pWEP(g_pLocalPlayer);
	if ( pWeapon.Primary ) then pWeapon.Primary.Recoil = 0.0; end
	if ( pWeapon.Secondary ) then pWeapon.Secondary.Recoil = 0.0; end
	
	local view = {}
	view.angles = g_CalcViewAngle;
	view.angles.r = 0;
	view.vm_angles = view.angles;
	
	return view;
end

local function hookAdd(hooked_vfuncname,hooked_nfunc)
	_G.hook.Add(hooked_vfuncname,_G.tostring(_G.math.random(666,133769420)),hooked_nfunc);
	cheat_notify("Hook Added: "..hooked_vfuncname);
end

hookAdd("CreateMove",hooked_CreateMove);
hookAdd("CalcView",hooked_CalcView);

cheat_notify("Hungarian Notation Simulator Loaded");
