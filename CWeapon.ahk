;ItemDefinitionIndex
Global WEAPON_NONE := 0
Global WEAPON_DEAGLE := 1
Global WEAPON_ELITE := 2
Global WEAPON_FIVESEVEN := 3
Global WEAPON_GLOCK := 4
Global WEAPON_AK47 := 7
Global WEAPON_AUG := 8
Global WEAPON_AWP := 9
Global WEAPON_FAMAS := 10
Global WEAPON_G3SG1 := 11
Global WEAPON_GALILAR := 13
Global WEAPON_M249 := 14
Global WEAPON_M4A1 := 16
Global WEAPON_MAC10 := 17
Global WEAPON_P90 := 19
Global WEAPON_MP5SD := 23
Global WEAPON_UMP45 := 24
Global WEAPON_XM1014 := 25
Global WEAPON_BIZON := 26
Global WEAPON_MAG7 := 27
Global WEAPON_NEGEV := 28
Global WEAPON_SAWEDOFF := 29
Global WEAPON_TEC9 := 30
Global WEAPON_TASER := 31
Global WEAPON_HKP2000 := 32
Global WEAPON_MP7 := 33
Global WEAPON_MP9 := 34
Global WEAPON_NOVA := 35
Global WEAPON_P250 := 36
Global WEAPON_SCAR20 := 38
Global WEAPON_SG556 := 39
Global WEAPON_SSG08 := 40
Global WEAPON_KNIFE_GG := 41
Global WEAPON_KNIFE_CT := 42
Global WEAPON_FLASHBANG := 43
Global WEAPON_HEGRENADE := 44
Global WEAPON_SMOKEGRENADE := 45
Global WEAPON_MOLOTOV := 46
Global WEAPON_DECOY := 47
Global WEAPON_INCGRENADE := 48
Global WEAPON_C4 := 49
Global WEAPON_HEALTHSHOT := 57
Global WEAPON_KNIFE_T := 59
Global WEAPON_M4A1_SILENCER := 60
Global WEAPON_USP_SILENCER := 61
Global WEAPON_CZ75A := 63
Global WEAPON_REVOLVER := 64
Global WEAPON_TAGRENADE := 68
Global WEAPON_FISTS := 69
Global WEAPON_BREACHCHARGE := 70
Global WEAPON_TABLET := 72
;Global WEAPON_MELEE := 74	;prefab
Global WEAPON_AXE := 75
Global WEAPON_HAMMER := 76
Global WEAPON_SPANNER := 78
Global WEAPON_KNIFE_GHOST := 80
Global WEAPON_FIREBOMB := 81
Global WEAPON_DIVERSION := 82
Global WEAPON_FRAG_GRENADE := 83
Global WEAPON_KNIFE_BAYONET := 500
Global WEAPON_KNIFE_FLIP := 505
Global WEAPON_KNIFE_GUT := 506
Global WEAPON_KNIFE_KARAMBIT := 507
Global WEAPON_KNIFE_M9_BAYONET := 508
Global WEAPON_KNIFE_TACTICAL := 509
Global WEAPON_KNIFE_FALCHION := 512
Global WEAPON_KNIFE_SURVIVAL_BOWIE := 514
Global WEAPON_KNIFE_BUTTERFLY := 515
Global WEAPON_KNIFE_PUSH := 516
Global WEAPON_KNIFE_URSUS := 519
Global WEAPON_KNIFE_GYPSY_JACKKNIFE := 520
Global WEAPON_KNIFE_STILETTO := 522
Global WEAPON_KNIFE_WIDOWMAKER := 523

;CSWeaponType
Global WEAPONTYPE_KNIFE         := 0
Global WEAPONTYPE_PISTOL        := 1
Global WEAPONTYPE_SUBMACHINEGUN := 2
Global WEAPONTYPE_RIFLE         := 3
Global WEAPONTYPE_SHOTGUN       := 4
Global WEAPONTYPE_SNIPER_RIFLE  := 5
Global WEAPONTYPE_MACHINEGUN    := 6
Global WEAPONTYPE_C4            := 7
Global WEAPONTYPE_GRENADE       := 9
Global WEAPONTYPE_STACKABLE     := 11
Global WEAPONTYPE_FISTS         := 12
Global WEAPONTYPE_BREACHCHARGE  := 13
Global WEAPONTYPE_TABLET        := 14
Global WEAPONTYPE_MELEE         := 15
Global WEAPONTYPE_UNKNOWN       := 16

GetWeaponType(itemDefIndex) {
	switch (itemDefIndex) {
		case WEAPON_TASER
		, WEAPON_KNIFE_GG
		, WEAPON_KNIFE_CT
		, WEAPON_KNIFE_T
		, WEAPON_KNIFE_GHOST
		, WEAPON_KNIFE_BAYONET
		, WEAPON_KNIFE_FLIP
		, WEAPON_KNIFE_GUT
		, WEAPON_KNIFE_KARAMBIT
		, WEAPON_KNIFE_M9_BAYONET
		, WEAPON_KNIFE_TACTICAL
		, WEAPON_KNIFE_FALCHION
		, WEAPON_KNIFE_SURVIVAL_BOWIE
		, WEAPON_KNIFE_BUTTERFLY
		, WEAPON_KNIFE_PUSH
		, WEAPON_KNIFE_URSUS
		, WEAPON_KNIFE_GYPSY_JACKKNIFE
		, WEAPON_KNIFE_STILETTO
		, WEAPON_KNIFE_WIDOWMAKER:
			return WEAPONTYPE_KNIFE
		case WEAPON_DEAGLE
		, WEAPON_ELITE
		, WEAPON_FIVESEVEN
		, WEAPON_GLOCK
		, WEAPON_TEC9
		, WEAPON_HKP2000
		, WEAPON_P250
		, WEAPON_USP_SILENCER
		, WEAPON_CZ75A
		, WEAPON_REVOLVER:
			return WEAPONTYPE_PISTOL
		case WEAPON_MAC10
		, WEAPON_P90
		, WEAPON_MP5SD
		, WEAPON_UMP45
		, WEAPON_BIZON
		, WEAPON_MP7
		, WEAPON_MP9:
			return WEAPONTYPE_SUBMACHINEGUN
		case WEAPON_AK47
		, WEAPON_AUG
		, WEAPON_FAMAS
		, WEAPON_GALILAR
		, WEAPON_M4A1
		, WEAPON_SG556
		, WEAPON_M4A1_SILENCER:
			return WEAPONTYPE_RIFLE
		case WEAPON_XM1014
		, WEAPON_MAG7
		, WEAPON_SAWEDOFF
		, WEAPON_NOVA:
			return WEAPONTYPE_SHOTGUN
		case WEAPON_AWP
		, WEAPON_G3SG1
		, WEAPON_SCAR20
		, WEAPON_SSG08:
			return WEAPONTYPE_SNIPER_RIFLE
		case WEAPON_M249
		, WEAPON_NEGEV:
			return WEAPONTYPE_MACHINEGUN
		case WEAPON_C4:
			return WEAPONTYPE_C4
		case WEAPON_FLASHBANG
		, WEAPON_HEGRENADE
		, WEAPON_SMOKEGRENADE
		, WEAPON_MOLOTOV
		, WEAPON_DECOY
		, WEAPON_INCGRENADE
		, WEAPON_TAGRENADE
		, WEAPON_FIREBOMB
		, WEAPON_DIVERSION
		, WEAPON_FRAG_GRENADE:
			return WEAPONTYPE_GRENADE
		case WEAPON_FISTS:
			return WEAPONTYPE_FISTS
		case WEAPON_BREACHCHARGE:
			return WEAPONTYPE_BREACHCHARGE
		case WEAPON_TABLET:
			return WEAPONTYPE_TABLET
		case WEAPON_AXE
		, WEAPON_HAMMER
		, WEAPON_SPANNER:
			return WEAPONTYPE_MELEE
		default:
			return WEAPONTYPE_UNKNOWN
	}
}

Class CWeapon {
	__New(entity) {
		csgo.readRaw(entity, ent_struct, m_zoomLevel+0x4)
		this.m_OriginalOwnerXuidHigh := NumGet(ent_struct, m_OriginalOwnerXuidHigh, "int")
		,this.m_OriginalOwnerXuidLow := NumGet(ent_struct, m_OriginalOwnerXuidLow, "int")
		,this.m_iItemDefinitionIndex := NumGet(ent_struct, m_iItemDefinitionIndex, "Short")
		,this.m_flNextPrimaryAttack  := NumGet(ent_struct, m_flNextPrimaryAttack, "Float")
		,this.m_iClip1               := NumGet(ent_struct, m_iClip1, "int")
		,this.m_bInReload            := NumGet(ent_struct, m_bInReload, "char")
		,this.m_fAccuracyPenalty     := NumGet(ent_struct, m_fAccuracyPenalty, "Float")
		,this.m_nFallbackPaintKit    := NumGet(ent_struct, m_nFallbackPaintKit, "int")
		;,this.m_szCustomName         := 
		,this.m_zoomLevel            := NumGet(ent_struct, m_zoomLevel, "int")
	}
}