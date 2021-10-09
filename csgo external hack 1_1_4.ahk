#Include classMemory.ahk
#Include csgo offsets.ahk
#Include imgui.ahk

#NoEnv
#Persistent
#InstallKeybdHook
#SingleInstance, Force
DetectHiddenWindows, On
SetKeyDelay,-1, -1
SetControlDelay, -1
SetMouseDelay, -1
SendMode Input
SetBatchLines,-1
ListLines, Off
Process, Priority, , H

if !Read_csgo_offsets_from_hazedumper() {
	MsgBox, 48, Error!, Failed to get csgo offsets
    ExitApp
}
if (_ClassMemory.__Class != "_ClassMemory") {
    msgbox class memory not correctly installed. Or the (global class) variable "_ClassMemory" has been overwritten
    ExitApp
}


Global cl_grenadepreview := 0xDC4D78 ;client 0=off 1=on Int
Global sv_showimpacts := 0xDBD3E0 ;client 0=off 1=on Int
Global weapon_debug_spread_show := 0xDC6E10 ;client 0=off 3=on Int
Global weapon_recoil_view_punch_extra := 0xDBD8AC ;client 0=off 0.055=on Float
Global view_recoil_tracking := 0xD9B14C ;client 0=off 0.45=on Float
Global r_drawothermodels := 0xD9BE08 ;client 1=off 2=on Int
Global mp_weapons_glow_on_ground := 0xDBA1D0 ;client 0=off 1=on Int
Global mat_postprocess_enable := 0xDB00C0 ;client 0=off 1=on Int
Global r_aspectratio := 0x58A994 ;engine
Global r_drawparticles := 0xDAA780 ;client 0=off 1=on Int
Global mat_fullbright := 0xBBC68 ;materialsystem 0=off 1=on Int



Process, Wait, csgo.exe
Global csgo := new _ClassMemory("ahk_exe csgo.exe", "", hProcessCopy)
Global client := csgo.getModuleBaseAddress("client.dll")
Global engine := csgo.getModuleBaseAddress("engine.dll")
Global materialsystem := csgo.getModuleBaseAddress("materialsystem.dll")

pattern := csgo.hexStringToPattern("A0 ?? ?? 0B 08")
Global smokecount := csgo.modulePatternScan("client.dll", pattern*) + 0xC






DllCall("QueryPerformanceFrequency", "Int64*", freq)
ShootBefore := ShootAfter := 0


Global enable_glow := 0
Global enable_glow_enemy := 0
Global glow_enemy_color := 0xFFC22CCF
Global glow_enemy_color_a := 0
Global glow_enemy_color_r := 0
Global glow_enemy_color_g := 0
Global glow_enemy_color_b := 0
Global enable_glow_team := 0
Global glow_team_color := 0xFF00C800 ;ARGB
Global glow_team_color_a := 0
Global glow_team_color_r := 0
Global glow_team_color_g := 0
Global glow_team_color_b := 0

Global enable_chams := 0
Global enable_chams_enemy := 0
Global chams_enemy_color := 0x00FFFFFF
Global chams_enemy_color_r := 0
Global chams_enemy_color_b := 0
Global chams_enemy_color_b := 0
Global enable_chams_team := 0
Global chams_team_color := 0x00FFFFFF
Global chams_team_color_r := 0
Global chams_team_color_g := 0
Global chams_team_color_b := 0
Global enable_chams_local := 0
Global chams_local_color := 0x00FFFFFF
Global chams_local_color_r := 0
Global chams_local_color_g := 0
Global chams_local_color_b := 0

Global fov_changer_value := 90

Global aspect_ratio_value := 1.777777

Global enable_dont_render := 1

Global Glow_Struct_Enemy
VarSetCapacity(Glow_Struct_Enemy, 16)

Global Glow_Struct_Team
VarSetCapacity(Glow_Struct_Team, 16)

Global NewViewAngles := [0, 0]
Global OldPunchAngles := [0, 0]


;_ImGui_EnableViewports()
hwnd := _ImGui_GUICreate("CS:GO Ahk External Hack Settings", 720, 540, (A_ScreenWidth-720)//2, (A_ScreenHeight-540)//2)
winshow, ahk_id %hwnd%
Global rc
VarSetCapacity(rc, 16)
DllCall("GetClientRect", "Uint", hwnd, "Uint", &rc)

SetFormat, integer, H
Loop {
	settings_gui()
	IsInGame := IsInGame()
	,LocalPlayer := GetLocalPlayer()
	while (IsInGame && LocalPlayer) {
		DllCall("QueryPerformanceCounter", "Int64*", LoopBefore)
		if !(enable_dont_render & !WinActive("CS:GO Ahk External Hack Settings"))
			settings_gui()
		MaxPlayer := GetMaxPlayer()
		,IsInGame := IsInGame()
		,glowobj := GetGlowObj()
		,LocalPlayer := GetLocalPlayer()
		,LocalPlayerID := GetLocalPlayerID()
		,WeaponHandle := GetActiveWeapon(LocalPlayer)
		,WeaponEntity := GetWeaponEntity(WeaponHandle)
		,WeaponAmmo := GetWeaponAmmo(WeaponEntity)
		,WeaponIndex := GetWeaponIndex(WeaponEntity)
		,LocalPlayer_ViewModelHandler := GetViewModelHandler(LocalPlayer)
		,LocalPlayer_CurrentViewModelEntity := GetEntity((LocalPlayer_ViewModelHandler & 0xFFF) - 1)
		,LocalPlayer_CrosshairID := GetCrosshairID(LocalPlayer)
		,LocalPlayer_Team := GetTeam(LocalPlayer)
		,LocalPlayer_Dormant := GetDormant(LocalPlayer)
		,LocalPlayer_Flags := GetFlags(LocalPlayer)
		,LocalPlayer_IsScoped := IsScoped(LocalPlayer)

		if (enable_glow && enable_glow_enemy) {
			SplitARGBColor(glow_enemy_color, glow_enemy_color_a, glow_enemy_color_r, glow_enemy_color_g, glow_enemy_color_b)
			NumPut(glow_enemy_color_r/255, Glow_Struct_Enemy, 0x0, "Float")
			NumPut(glow_enemy_color_g/255, Glow_Struct_Enemy, 0x4, "Float")
			NumPut(glow_enemy_color_b/255, Glow_Struct_Enemy, 0x8, "Float")
			NumPut(glow_enemy_color_a/255, Glow_Struct_Enemy, 0xC, "Float")
			NumPut(1, Glow_Struct_Enemy, 0x10, "UChar")
		} else {
			NumPut(0, Glow_Struct_Enemy, 0x0, "Float")
			NumPut(0, Glow_Struct_Enemy, 0x4, "Float")
			NumPut(0, Glow_Struct_Enemy, 0x8, "Float")
			NumPut(0, Glow_Struct_Enemy, 0xC, "Float")
			NumPut(0, Glow_Struct_Enemy, 0x10, "UChar")
		}
		if (enable_glow && enable_glow_team) {
			SplitARGBColor(glow_team_color, glow_team_color_a, glow_team_color_r, glow_team_color_g, glow_team_color_b)
			NumPut(glow_team_color_r/255, Glow_Struct_Team, 0x0, "Float")
			NumPut(glow_team_color_g/255, Glow_Struct_Team, 0x4, "Float")
			NumPut(glow_team_color_b/255, Glow_Struct_Team, 0x8, "Float")
			NumPut(glow_team_color_a/255, Glow_Struct_Team, 0xC, "Float")
			NumPut(1, Glow_Struct_Team, 0x10, "UChar")
		} else {
			NumPut(0, Glow_Struct_Team, 0x0, "Float")
			NumPut(0, Glow_Struct_Team, 0x4, "Float")
			NumPut(0, Glow_Struct_Team, 0x8, "Float")
			NumPut(0, Glow_Struct_Team, 0xC, "Float")
			NumPut(0, Glow_Struct_Team, 0x10, "UChar")
		}
		if enable_glow {
			csgo.writeBytes(client + force_update_spectator_glow, "EB")
		} else {
			csgo.writeBytes(client + force_update_spectator_glow, "74")
		}

		csgo.readRaw(client + dwEntityList, EntityList, (MaxPlayer+1)*0x10)
		Loop % MaxPlayer {
			dwEntity := NumGet(EntityList, A_index*0x10, "Uint") ;GetEntity(A_index)
			,dwEntity_Team := GetTeam(dwEntity)
			,dwEntity_IsAlive := IsAlive(dwEntity)
			,dwEntity_Dormant := GetDormant(dwEntity)
			,dwEntity_GlowIndex := GetGlowIndex(dwEntity)
			,dwEntity_ClassId := GetClassId(dwEntity)
			;,dwEntity_SpottedByMask := GetSpottedByMask(dwEntity)
			;,dwEntity_WeaponIndex := GetWeaponIndex(dwEntity)

			;if (dwEntity_WeaponIndex=7) {
			;	msgbox % dwEntity
			;}

			if (dwEntity=0 || dwEntity=LocalPlayer || !dwEntity_IsAlive || dwEntity_Dormant)
				Continue

			if (LocalPlayer_Team != dwEntity_Team)  {
				Glow(glowobj, dwEntity_GlowIndex, Glow_Struct_Enemy)

				if (enable_chams && enable_chams_enemy) {
					SplitRGBColor(chams_enemy_color, chams_enemy_color_r, chams_enemy_color_g, chams_enemy_color_b)
					chams(dwEntity, chams_enemy_color_r, chams_enemy_color_g, chams_enemy_color_b)
				} else {
					chams(dwEntity, 255, 255, 255)
				}
				if (enable_radar_reveal && GetSpotted(dwEntity)!=2) {
					csgo.write(dwEntity + m_bSpotted, 2, "UChar")
				}
			} else {
				Glow(glowobj, dwEntity_GlowIndex, Glow_Struct_Team)

				if (enable_chams && enable_chams_team) {
					SplitRGBColor(chams_team_color, chams_team_color_r, chams_team_color_g, chams_team_color_b)
					chams(dwEntity, chams_team_color_r, chams_team_color_g, chams_team_color_b)
				} else {
					chams(dwEntity, 255, 255, 255)
				}
				if (enable_team_check && A_index=LocalPlayer_CrosshairID-1) || (enable_auto_reload && !WeaponAmmo)
					csgo.write(client + dwForceAttack, 4, "Uint")
			}
		}

		if (enable_chams && enable_chams_local) {
			SplitRGBColor(chams_local_color, chams_local_color_r, chams_local_color_g, chams_local_color_b)
			chams(LocalPlayer_CurrentViewModelEntity, chams_local_color_r, chams_local_color_g, chams_local_color_b)
		} else {
			chams(LocalPlayer_CurrentViewModelEntity, 255, 255, 255)
		}

		SetConVar(client, mp_weapons_glow_on_ground, enable_weapon_glow ? 1:0, "Int")

		SetConVar(engine, model_ambient_min, enable_model_brightness ? model_brightness_value:0, "Float")

		if enable_aspect_ratio_changer {
			SetConVar(engine, r_aspectratio, aspect_ratio_value, "Float")
		} else {
			SetConVar(engine, r_aspectratio, 0, "Float")
		}

		csgo.write(LocalPlayer + m_iDefaultFOV, enable_fov_changer ? fov_changer_value:90, "Uint") ;fov changer

		csgo.write(LocalPlayer + m_flFlashMaxAlpha, enable_anti_flash ? 0:255, "Float") ;anti flash

		csgo.write(smokecount, enable_no_smoke ? 0:, "Uint") ;no smoke
		SetConVar(client, r_drawparticles, enable_no_smoke ? 0:1, "Int") ;no smoke

		csgo.write(LocalPlayer + 0x258, enable_remove_hands ? 0:340, "Uint") ;remove hands

		SetConvar(client, weapon_recoil_view_punch_extra, enable_remove_view_punch ? 0:0.055, "Float") ;remove view punch
		SetConVar(client, view_recoil_tracking, enable_remove_view_punch ? 0:0.45, "Float") ;remove recoil tracking

		SetConVar(client, weapon_debug_spread_show, (enable_force_crosshair && !LocalPlayer_IsScoped) ? 3:0, "Int") ;force crosshair

		SetConVar(client, cl_grenadepreview, enable_grenade_prediction ? 1:0, "Int") ;grenade prediction

		SetConVar(client, mat_postprocess_enable, enable_disable_Post_Processing ? 0:1, "Int") ;disable Post-Processing

		SetConVar(client, sv_showimpacts, enable_bullet_impacts ? 1:0, "Int") ;bullet impacts

		SetConVar(materialsystem, mat_fullbright, enable_full_bright ? 1:0, "Int") ;fullbright


		if (enable_auto_bhop && GetKeyState("Space") && WinActive("ahk_exe csgo.exe") && !IsMouseEnable()) { ;auto bhop
			csgo.write(client + dwForceJump, (LocalPlayer_Flags=257 || LocalPlayer_Flags=263) ? 5:4, "Uint")
		}

		DllCall("QueryPerformanceCounter", "Int64*", ShootAfter)
		if (enable_auto_pistol && GetKeyState("LButton") && WinActive("ahk_exe csgo.exe") && !IsMouseEnable() && (WeaponIndex=30 || WeaponIndex=36 || WeaponIndex=32 || WeaponIndex=4 || WeaponIndex=3 || WeaponIndex=2 || WeaponIndex=1 || WeaponIndex=61) && ((ShootAfter-ShootBefore)/freq*1000)>=30) {
			csgo.write(client + dwForceAttack, 6, "Uint")
			DllCall("QueryPerformanceCounter", "Int64*", ShootBefore)
		}

		if rcs_value
			RCS(LocalPlayer, rcs_value)




		DllCall("QueryPerformanceCounter", "Int64*", LoopAfter)
		LoopTimer := (LoopAfter - LoopBefore) / freq * 1000
	}
	Sleep 10
}



GetMaxPlayer() {
	Return csgo.read(engine + dwClientState, "Uint", dwClientState_MaxPlayer)
}

GetLocalPlayer() {
	Return csgo.read(client + dwLocalPlayer, "Uint")
}

GetLocalPlayerID() {
	Return csgo.read(engine + dwClientState, "Uint", dwClientState_GetLocalPlayer)
}

GetCrosshairID(dwEntity) {
	Return csgo.read(dwEntity + m_iCrosshairId, "Uint")
}

GetActiveWeapon(dwEntity) {
	Return csgo.read(dwEntity + m_hActiveWeapon, "Uint")
}

GetWeaponEntity(dwWeaponHandle) {
	Return GetEntity((dwWeaponHandle & 0xFFF) - 1)
}

GetWeaponIndex(dwEntity) {
	Return csgo.read(dwEntity + m_iItemDefinitionIndex, "Uint")
}

GetWeaponAmmo(dwEntity) {
	Return csgo.read(dwEntity + m_iClip1, "Uint")
}

GetViewModelHandler(dwEntity) {
	Return csgo.read(dwEntity + m_hViewModel, "Uint")
}

GetViewAngles() {
	csgo.readRaw(engine + dwClientState, ViewAngles, 0x8, dwClientState_ViewAngles)
	Return [NumGet(ViewAngles, 0x0, "Float"), NumGet(ViewAngles, 0x4, "Float")]
}

GetPunchAngles(dwEntity) {
	csgo.readRaw(dwEntity + m_aimPunchAngle, PunchAngles, 0x8)
	Return [NumGet(PunchAngles, 0x0, "Float"), NumGet(PunchAngles, 0x4, "Float")]
}

GetShotsFired(dwEntity) {
	Return csgo.read(dwEntity + m_iShotsFired, "Uint")
}

GetFlags(dwEntity) {
	Return csgo.read(dwEntity + m_fFlags, "Uint")
}

GetEntity(index) {
	Return csgo.read(client + dwEntityList + index * 0x10, "Uint")
}

GetTeam(dwEntity) {
	Return csgo.read(dwEntity + m_iTeamNum, "Uint")
}

GetHealth(dwEntity) {
	Return csgo.read(dwEntity + m_iHealth, "Uint")
}

GetGlowIndex(dwEntity) {
	Return csgo.read(dwEntity + m_iGlowIndex, "Uint")
}

GetDormant(dwEntity) {
	Return csgo.read(dwEntity + m_bDormant, "Uint")
}

GetSpotted(dwEntity) {
	Return csgo.read(dwEntity + m_bSpotted, "UChar")
}

GetSpottedByMask(dwEntity) {
	Return csgo.read(dwEntity + m_bSpottedByMask, "UChar")
}

GetClassId(dwEntity) {
	Return csgo.read(dwEntity + 0x8, "Uint", 0x8, 0x1, 0x14)
}

IsAlive(dwEntity) {
	H := GetHealth(dwEntity)
	Return (H>0 && H<=100)
}

IsInGame() {
	Return csgo.read(engine + dwClientState, "Uint", dwClientState_State)=6
}

IsMouseEnable() {
	Return !((csgo.read(client + dwMouseEnablePtr + 0x30, "Uint") ^ dwMouseEnablePtr) & 0xF)
}

IsScoped(dwEntity) {
	Return csgo.read(dwEntity + m_bIsScoped, "Uint")
}

SetConVar(ByRef base, ByRef offset, value, type:="Float") {
	VarSetCapacity(v, 4)
	NumPut(value, v, 0, type="Float" ? "Float":"Int")
	thisPtr := base + offset - (type="Float" ? 0x2C:0x30)
	,xored := NumGet(v, 0, "Int") ^ thisPtr
	csgo.write(base + offset, xored, "Uint")
}

GetGlowObj() {
	Return csgo.read(client + dwGlowObjectManager, "Uint")
}

Glow(ByRef glowObj,ByRef glowInd, ByRef struct) {
	csgo.writeRaw(glowObj+(glowInd*0x38)+0x8, &struct, 16)
	csgo.write(glowObj+(glowInd*0x38)+0x28,  NumGet(struct, 0x10, "Char"), "UChar")
	csgo.write(glowObj+(glowInd*0x38)+0x29, 0, "UChar")
	;,csgo.write(glowObj+(glowInd*0x38)+0x30, 2, "Uint")
}

chams(dwEntity, r, g, b) {
	csgo.write(dwEntity + m_clrRender, (b<<16)+(g<<8)+r, "Uint")
}

RCS(ByRef dwEntity, value:=0) {
	PunchAngles := GetPunchAngles(dwEntity)
	,ShotsFired := GetShotsFired(dwEntity)
	if (ShotsFired>1) {
		CurrentViewAngles := GetViewAngles()
		,NewViewAngles[1] := (CurrentViewAngles[1] + OldPunchAngles[1] * 2 * (value/100)) - (PunchAngles[1] * 2 * (value/100))
	    ,NewViewAngles[2] := (CurrentViewAngles[2] + OldPunchAngles[2] * 2 * (value/100)) - (PunchAngles[2] * 2 * (value/100))

	    ,NewViewAngles[1] := (NewViewAngles[1]>89) ? 89:NewViewAngles[1]
	    ,NewViewAngles[1] := (NewViewAngles[1]<-89) ? -89:NewViewAngles[1]

	    while (NewViewAngles[2]>180)
	    	NewViewAngles[2] -= 360

	    while (NewViewAngles[2]<-180)
	    	NewViewAngles[2] += 360

	    OldPunchAngles[1] := PunchAngles[1]
	    ,OldPunchAngles[2] := PunchAngles[2]

	    VarSetCapacity(ViewAngles, 0x8)
	    NumPut(NewViewAngles[1], ViewAngles, 0x0, "Float")
	    NumPut(NewViewAngles[2], ViewAngles, 0x4, "Float")
	    csgo.writeRaw(engine + dwClientState, &ViewAngles, 0x8, dwClientState_ViewAngles)
	} else {
		OldPunchAngles[1] := PunchAngles[1]
		,OldPunchAngles[2] := PunchAngles[2]
	}
}

SendPacket(value) {
	csgo.write(engine + dwbSendPackets, value, "UChar")
}

SplitRGBColor(RGBColor, ByRef Red, ByRef Green, ByRef Blue) {
    Red    := RGBColor >> 16 & 0xFF
    ,Green := RGBColor >> 8 & 0xFF
    ,Blue  := RGBColor & 0xFF
}

SplitARGBColor(ARGBColor, ByRef Alpha, ByRef Red, ByRef Green, ByRef Blue) {
	Alpha := ARGBColor >> 24 & 0xFF
    ,Red    := ARGBColor >> 16 & 0xFF
    ,Green := ARGBColor >> 8 & 0xFF
    ,Blue  := ARGBColor & 0xFF
}

settings_gui() {
	Global
	if !_ImGui_PeekMsg()
		ExitApp
	_ImGui_BeginFrame()
	_ImGui_Begin("Setting")
	_ImGui_SetWindowPos(0, 0)
	_ImGui_SetWindowSize(NumGet(rc, 8, "int"), NumGet(rc, 12, "int"))

	_ImGui_BeginTabBar("setting tab")
	if _ImGui_BeginTabItem("visuals") {
		_ImGui_NewLine()
		_ImGui_Columns(2)

		_ImGui_Checkbox("Glow", enable_glow)
		_ImGui_SameLine(0, 30)
		_ImGui_Checkbox("Weapon Glow", enable_weapon_glow)
		_ImGui_BeginChild("glow_child", 320, 112, 1)
			_ImGui_Checkbox("Enemy", enable_glow_enemy)
			_ImGui_ColorEdit("enemy color", glow_enemy_color)

			_ImGui_Checkbox("Team", enable_glow_team)
			_ImGui_ColorEdit("team color", glow_team_color)
		_ImGui_EndChild()

		_ImGui_Checkbox("Chams", enable_chams)
		_ImGui_BeginChild("chams_child", 320, 162, 1)
			_ImGui_Checkbox("Enemy", enable_chams_enemy)
			_ImGui_ColorEdit("enemy color", chams_enemy_color)

			_ImGui_Checkbox("Team", enable_chams_team)
			_ImGui_ColorEdit("team color", chams_team_color)

			_ImGui_Checkbox("Local", enable_chams_local)
			_ImGui_ColorEdit("local color", chams_local_color)
		_ImGui_EndChild()

		_ImGui_Checkbox("Model Brightness", enable_model_brightness)
		_ImGui_BeginChild("model_brightness_child", 320, 37, 1)
			_ImGui_SliderFloat("brightness", model_brightness_value, 0, 100)
		_ImGui_EndChild()

		_ImGui_NextColumn()
		_ImGui_Checkbox("FOV Changer", enable_fov_changer)
		_ImGui_BeginChild("FOV_Changer_child", 320, 37, 1)
			_ImGui_SliderInt("FOV", fov_changer_value, 30, 150)
		_ImGui_EndChild()

		_ImGui_Checkbox("AspectRatio Changer", enable_aspect_ratio_changer)
		_ImGui_BeginChild("AspectRatio_Charger_child", 320, 62, 1)
			if _ImGui_Button("1:1")
				aspect_ratio_value := 1
			_ImGui_SameLine()
			if _ImGui_Button("5:4")
				aspect_ratio_value := 5/4
			_ImGui_SameLine()
			if _ImGui_Button("4:3")
				aspect_ratio_value := 4/3
			_ImGui_SameLine()
			if _ImGui_Button("16:9")
				aspect_ratio_value := 16/9
			_ImGui_SliderFloat("AspectRatio", aspect_ratio_value, 1, 2)
		_ImGui_EndChild()
		
		_ImGui_Checkbox("Anti Flash", enable_anti_flash)

		_ImGui_Checkbox("No Smoke", enable_no_smoke)

		_ImGui_Checkbox("Remove Hands", enable_remove_hands)

		_ImGui_Checkbox("Remove View Punch", enable_remove_view_punch)

		_ImGui_Checkbox("Radar reveal", enable_radar_reveal)

		_ImGui_Checkbox("Force Crosshair", enable_force_crosshair)

		_ImGui_Checkbox("Grenade Prediction", enable_grenade_prediction)

		_ImGui_Checkbox("Disable Post-Processing", enable_disable_Post_Processing)

		_ImGui_Checkbox("Bullet Impacts", enable_bullet_impacts)

		_ImGui_Checkbox("Fullbright", enable_full_bright)

	_ImGui_EndTabItem()
	}
	_ImGui_Columns(1)
	if _ImGui_BeginTabItem("misc") {
		_ImGui_NewLine()
		_ImGui_Columns(2)
		
		_ImGui_Checkbox("Auto Bhop", enable_auto_bhop)

		_ImGui_Checkbox("Auto Pistol", enable_auto_pistol)

		_ImGui_Checkbox("Auto Reload", enable_auto_reload)

		_ImGui_Checkbox("CrosshairID Team Check", enable_team_check)

		_ImGui_SliderInt("RCS", rcs_value, 0, 100)


	_ImGui_EndTabItem()
	}
	_ImGui_Columns(1)
	if _ImGui_BeginTabItem("debug") {
		_ImGui_NewLine()
		_ImGui_Checkbox("Don't render the settings window when in the background", enable_dont_render)

		_ImGui_Text("LocalPlayer : " . LocalPlayer)
		_ImGui_Text("current weapon entity : " . WeaponEntity)
		_ImGui_Text("current weapon index : " . WeaponIndex)

		_ImGui_Text("Loop timer : " . LoopTimer . " ms")

		

		

	}
	_ImGui_EndTabBar()

	



	_ImGui_End()
	_ImGui_EndFrame(0xFF000000)
}
