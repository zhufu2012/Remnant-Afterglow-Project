%%% This File Is AUTO GENERATED, Don't Modify it MANUALLY!!!
%%% If you have any questions, please contact to ZHONGYUANWEI.

-ifndef(netmsgRecords).
-define(netmsgRecords,netmsgRecords).

-define(ProtoVersion,824).

-define(CMD_LS2GS_LoginResult,31727).
-record(pk_LS2GS_LoginResult,{
	reserve = 0
	}).

-define(CMD_LS2GS_UserReadyToLogin,56338).
-record(pk_LS2GS_UserReadyToLogin,{
	account = "",
	identity = 0,
	platId = 0,
	selectServerID = 0,
	platId2 = 0,
	openid = "",
	isTestAccount = false
	}).

-define(CMD_LS2GS_NewAccount,51375).
-record(pk_LS2GS_NewAccount,{
	account = "",
	platformId = 0,
	platformName = "",
	platformAccount = "",
	deviceId = "",
	createTime = 0
	}).

-define(CMD_LS2GS_KickOutUser,44591).
-record(pk_LS2GS_KickOutUser,{
	account = "",
	identity = 0,
	platId = 0,
	reason = 0
	}).

-define(CMD_LS2GS_ActiveCode,43015).
-record(pk_LS2GS_ActiveCode,{
	pidStr = "",
	activeCode = "",
	playerName = "",
	type = 0
	}).

-define(CMD_GS2LS_Request_Login,52820).
-record(pk_GS2LS_Request_Login,{
	serverId = 0,
	name = "",
	ip = "",
	port = 0,
	remmond = 0,
	hot = 0
	}).

-define(CMD_GS2LS_ReadyToAcceptUser,25780).
-record(pk_GS2LS_ReadyToAcceptUser,{
	reserve = 0
	}).

-define(CMD_GS2LS_OnlinePlayers,12007).
-record(pk_GS2LS_OnlinePlayers,{
	playerCount = 0
	}).

-define(CMD_GS2LS_UserLoginGameServer,1719).
-record(pk_GS2LS_UserLoginGameServer,{
	account = ""
	}).

-define(CMD_GS2LS_UserLogoutGameServer,19330).
-record(pk_GS2LS_UserLogoutGameServer,{
	account = ""
	}).

-define(CMD_LS2GS_DenyPlayer,34488).
-record(pk_LS2GS_DenyPlayer,{
	account = "",
	playerID = 0,
	state = 0
	}).

-define(CMD_LS2GS_DenySpeak,61008).
-record(pk_LS2GS_DenySpeak,{
	playerID = 0,
	denyChatTime = 0
	}).

-define(CMD_LS2GS_SetGmLevel,3009).
-record(pk_LS2GS_SetGmLevel,{
	account = "",
	gmLevel = 0
	}).

-define(CMD_GS2LS_ActiveCode,43632).
-record(pk_GS2LS_ActiveCode,{
	pidStr = "",
	activeCode = "",
	retcode = 0
	}).

-define(CMD_LS2GS_Announce,14820).
-record(pk_LS2GS_Announce,{
	announceInfo = "",
	startTime = 0,
	endTime = 0
	}).

-define(CMD_LS2GS_MarqueeAnnouce,58525).
-record(pk_LS2GS_MarqueeAnnouce,{
	announceID = 0,
	announceInfo = "",
	startTime = 0,
	endTime = 0,
	playTimes = 0,
	interval = 0
	}).

-define(CMD_LS2GS_deleteMarqueeAnnouce,5424).
-record(pk_LS2GS_deleteMarqueeAnnouce,{
	announceID = 0
	}).

-define(CMD_platformItemInfo,42333).
-record(pk_platformItemInfo,{
	itemID = 0,
	amount = 0
	}).

-define(CMD_platformCoinInfo,8051).
-record(pk_platformCoinInfo,{
	money_type = 0,
	money_num = 0
	}).

-define(CMD_LS2GS_sendItemToPlayer,1846).
-record(pk_LS2GS_sendItemToPlayer,{
	title = "",
	content = "",
	coin_list = [],
	player_list = [],
	item_List = []
	}).

-define(CMD_LS2GS_SendItemToPlayerEx,11455).
-record(pk_LS2GS_SendItemToPlayerEx,{
	levelMin = 0,
	levelMax = 0,
	exp = 0,
	timeBegin = 0,
	timeEnd = 0,
	title = "",
	content = "",
	coin_list = [],
	item_List = []
	}).

-define(CMD_LS2GS_changeRoleToAccount,42633).
-record(pk_LS2GS_changeRoleToAccount,{
	sourceAccount = "",
	sourcePlayerID = 0,
	destAccount = ""
	}).

-define(CMD_LS2GS_reloadShop,9573).
-record(pk_LS2GS_reloadShop,{
	}).

-define(CMD_LS2GS_setServerStartTime,11686).
-record(pk_LS2GS_setServerStartTime,{
	startTime = 0
	}).

-define(CMD_LS2GS_answerQuestion,25761).
-record(pk_LS2GS_answerQuestion,{
	opuser = "",
	askID = 0,
	answer = "",
	state = 0
	}).

-define(CMD_LS2GS_setFuncSwitch,46630).
-record(pk_LS2GS_setFuncSwitch,{
	funcID = 0,
	flag = 0
	}).

-define(CMD_LS2GS_dropPlayerGold,43468).
-record(pk_LS2GS_dropPlayerGold,{
	account = "",
	playerID = 0,
	ammount = 0
	}).

-define(CMD_LS2GS_Command,29743).
-record(pk_LS2GS_Command,{
	pidStr = "",
	num = 0,
	cmd = 0,
	params = ""
	}).

-define(CMD_GS2LS_Command,12751).
-record(pk_GS2LS_Command,{
	pidStr = "",
	num = 0,
	cmd = 0,
	retcode = 0
	}).

-define(CMD_GS2LS_ForbiddenUser,63339).
-record(pk_GS2LS_ForbiddenUser,{
	account = "",
	reason = 0
	}).

-define(CMD_GS2LS_KeepAlive,23366).
-record(pk_GS2LS_KeepAlive,{
	reserve = 0
	}).

-define(CMD_GS2LS_OnLineAccount,41936).
-record(pk_GS2LS_OnLineAccount,{
	account = "",
	platformId = 0
	}).

-define(CMD_GS2LS_UserLoginGameServerLogging,50124).
-record(pk_GS2LS_UserLoginGameServerLogging,{
	account = "",
	platform = 0,
	playerId = 0,
	name = "",
	sex = 0,
	career = 0,
	level = 0,
	vipLevel = 0,
	headid = 0,
	createtime = 0
	}).

-define(CMD_LS2GS_deleteActivity,632).
-record(pk_LS2GS_deleteActivity,{
	activityID = 0
	}).

-define(CMD_LS2GS_RefreshKaIdInfo,44200).
-record(pk_LS2GS_RefreshKaIdInfo,{
	account = "",
	playerID = 0,
	kaId = 0
	}).

-define(CMD_LS2GS_RefreshWebInfo,65353).
-record(pk_LS2GS_RefreshWebInfo,{
	openid = 0,
	serverid = 0,
	roleid = 0,
	type = 0,
	msg = ""
	}).

-define(CMD_LS2GS_recharge_order,13402).
-record(pk_LS2GS_recharge_order,{
	orderid = ""
	}).

-define(CMD_LS2GS_free_account_changed,7016).
-record(pk_LS2GS_free_account_changed,{
	}).

-define(CMD_GS2LS_server_state,24317).
-record(pk_GS2LS_server_state,{
	server_state = 0
	}).

-define(CMD_GS2LS_data,9197).
-record(pk_GS2LS_data,{
	type = 0,
	value = <<>>
	}).

-define(CMD_LS2GS_PlatformPurchaseGoodsAdd,27907).
-record(pk_LS2GS_PlatformPurchaseGoodsAdd,{
	data = <<>>
	}).

-define(CMD_LS2GS_PlatformPurchaseGoodsDel,44665).
-record(pk_LS2GS_PlatformPurchaseGoodsDel,{
	list = []
	}).

-define(CMD_LS2GS_PlatformPurchasePushAdd,56682).
-record(pk_LS2GS_PlatformPurchasePushAdd,{
	data = <<>>
	}).

-define(CMD_LS2GS_PlatformPurchasePushDel,7904).
-record(pk_LS2GS_PlatformPurchasePushDel,{
	list = []
	}).

-define(CMD_ServerInfo,47004).
-record(pk_ServerInfo,{
	server_id = 0,
	start_time = 0,
	account_count = 0
	}).

-define(CMD_GS2LS_ServerInfo,1716).
-record(pk_GS2LS_ServerInfo,{
	server_info = #pk_ServerInfo{}
	}).

-define(CMD_LS2GS_ServerList,60937).
-record(pk_LS2GS_ServerList,{
	server_list = []
	}).

-define(CMD_GS2LS_server_msg,8225).
-record(pk_GS2LS_server_msg,{
	from_server_id = 0,
	to_server_id = 0,
	key = 0,
	value = <<>>
	}).

-define(CMD_U2LS_Login,53484).
-record(pk_U2LS_Login,{
	platformAccount = "",
	platformType = "",
	clientID = "",
	accessToken = "",
	time = 0,
	deviceId = "",
	imei = "",
	idfa = "",
	mac = "",
	versionRes = 0,
	versionExe = 0,
	versionGame = 0,
	versionPro = 0,
	extra = "",
	loginHistory = 0
	}).

-define(CMD_LS2U_LoginResult,2696).
-record(pk_LS2U_LoginResult,{
	result = 0,
	account = "",
	identity = 0,
	msg = "",
	willCloseSocket = 0,
	return_server_id = 0
	}).

-define(CMD_U2LS_Request_GameServerList,46477).
-record(pk_U2LS_Request_GameServerList,{
	}).

-define(CMD_GameServerInfo,59275).
-record(pk_GameServerInfo,{
	realserverID = 0,
	name = "",
	state = 0,
	remmond = 0,
	isnew = 0,
	begintime = "",
	serverID = 0
	}).

-define(CMD_LS2U_GameServerList,61957).
-record(pk_LS2U_GameServerList,{
	gameServers = []
	}).

-define(CMD_U2LS_Request_SelGameServer,56964).
-record(pk_U2LS_Request_SelGameServer,{
	serverID = 0
	}).

-define(CMD_LS2U_Request_SelGameServer,44159).
-record(pk_LS2U_Request_SelGameServer,{
	serverID = 0,
	name = "",
	ip = "",
	port = 0,
	state = 0
	}).

-define(CMD_U2LS_Logout,38375).
-record(pk_U2LS_Logout,{
	account = "",
	identity = 0
	}).

-define(CMD_U2LS_Logout_Result,43736).
-record(pk_U2LS_Logout_Result,{
	result = 0
	}).

-define(CMD_U2LS_Return_ReLogin,52930).
-record(pk_U2LS_Return_ReLogin,{
	account = ""
	}).

-define(CMD_LS2U_Return_ReLogin_Result,39672).
-record(pk_LS2U_Return_ReLogin_Result,{
	errorCode = 0
	}).

-define(CMD_U2LS_LoginQueue,28043).
-record(pk_U2LS_LoginQueue,{
	serverid = 0
	}).

-define(CMD_LS2U_LoginQueueResult,26700).
-record(pk_LS2U_LoginQueueResult,{
	noid = 0,
	waitTime = 0
	}).

-define(CMD_U2LS_LoginHistory,24976).
-record(pk_U2LS_LoginHistory,{
	account = ""
	}).

-define(CMD_LoginInfo,15543).
-record(pk_LoginInfo,{
	serverid = 0,
	name = "",
	level = 0,
	headid = 0,
	career = 0
	}).

-define(CMD_LS2U_LoginHistory,1568).
-record(pk_LS2U_LoginHistory,{
	infoList = []
	}).

-define(CMD_U2LS_NewServerTime,44226).
-record(pk_U2LS_NewServerTime,{
	}).

-define(CMD_LS2U_NewServerTime,1086).
-record(pk_LS2U_NewServerTime,{
	server_id = 0,
	server_name = "",
	open_time = 0
	}).

-define(CMD_any_value,37769).
-record(pk_any_value,{
	type = 0,
	value = <<>>
	}).

-define(CMD_index_value,28135).
-record(pk_index_value,{
	index = 0,
	value = #pk_any_value{}
	}).

-define(CMD_ModelInfo,28245).
-record(pk_ModelInfo,{
	career = 0,
	model_id = 0,
	zoom = 0,
	shift_x = 0,
	shift_y = 0,
	shift_z = 0,
	rotate_x = 0,
	rotate_y = 0,
	rotate_z = 0
	}).

-define(CMD_NewModelInfo,11510).
-record(pk_NewModelInfo,{
	type = 0,
	model_id = 0,
	zoom = 0,
	shift_x = 0,
	shift_y = 0,
	shift_z = 0,
	rotate_x = 0,
	rotate_y = 0,
	rotate_z = 0,
	item_id = 0
	}).

-define(CMD_TypeModelInfo,9530).
-record(pk_TypeModelInfo,{
	career = 0,
	model_id = 0,
	zoom = 0,
	show_type = 0,
	shift_x = 0,
	shift_y = 0,
	shift_z = 0,
	rotate_x = 0,
	rotate_y = 0,
	rotate_z = 0
	}).

-define(CMD_key_value,45614).
-record(pk_key_value,{
	key = 0,
	value = 0
	}).

-define(CMD_key_2value,7833).
-record(pk_key_2value,{
	key = 0,
	value1 = 0,
	value2 = 0
	}).

-define(CMD_key_3value,50385).
-record(pk_key_3value,{
	key = 0,
	value1 = 0,
	value2 = 0,
	value3 = 0
	}).

-define(CMD_key_big_value,4076).
-record(pk_key_big_value,{
	key = 0,
	value = 0
	}).

-define(CMD_big_key_value,52226).
-record(pk_big_key_value,{
	key = 0,
	value = 0
	}).

-define(CMD_CommonRedPoint,38827).
-record(pk_CommonRedPoint,{
	type = 0,
	is_red = false
	}).

-define(CMD_BindSkillBase,13297).
-record(pk_BindSkillBase,{
	bind_index = 0,
	skill_index = 0
	}).

-define(CMD_U2GS_RequestLogin,20143).
-record(pk_U2GS_RequestLogin,{
	account = "",
	identity = 0,
	protocolVer = 0,
	loginType = 0,
	roleID = 0,
	language = ""
	}).

-define(CMD_GS2U_LoginResult,34889).
-record(pk_GS2U_LoginResult,{
	result = 0,
	willCloseSocket = 0,
	timezone_seconds = 0
	}).

-define(CMD_U2GS_LoginQueue,21722).
-record(pk_U2GS_LoginQueue,{
	isSkip = false
	}).

-define(CMD_GS2U_LoginQueueResult,12934).
-record(pk_GS2U_LoginQueueResult,{
	errorCode = 0,
	count = 0,
	microsecond = 0
	}).

-define(CMD_U2GS_SelPlayerEnterGame,30803).
-record(pk_U2GS_SelPlayerEnterGame,{
	roleID = 0
	}).

-define(CMD_GS2U_SelPlayerResult,42856).
-record(pk_GS2U_SelPlayerResult,{
	result = 0
	}).

-define(CMD_U2GS_requestCreateName,12491).
-record(pk_U2GS_requestCreateName,{
	career = 0
	}).

-define(CMD_GS2U_createNameResult,14154).
-record(pk_GS2U_createNameResult,{
	name = "",
	result = 0
	}).

-define(CMD_U2GS_RequestCreatePlayer,9657).
-record(pk_U2GS_RequestCreatePlayer,{
	name = "",
	sex = 0,
	camp = 0,
	career = 0,
	custom_list = []
	}).

-define(CMD_GS2U_CreatePlayerResult,36330).
-record(pk_GS2U_CreatePlayerResult,{
	errorCode = 0,
	roleID = 0
	}).

-define(CMD_U2GS_ClientHardInfo,1432).
-record(pk_U2GS_ClientHardInfo,{
	gameSvrId = "",
	vGameAppid = "",
	platID = 0,
	vopenid = "",
	clientVersion = "",
	systemSoftware = "",
	systemHardware = "",
	telecomOper = "",
	network = "",
	screenWidth = 0,
	screenHight = 0,
	density = 0,
	regChannel = 0,
	cpuHardware = "",
	memory = 0,
	gLRender = "",
	gLVersion = "",
	deviceId = "",
	loginChannel = 0,
	loginConsumeTime = 0
	}).

-define(CMD_U2GS_ClientHardInfoSummary,28345).
-record(pk_U2GS_ClientHardInfoSummary,{
	systemHardware = "",
	systemSoftware = ""
	}).

-define(CMD_U2GS_KeepAlive,20868).
-record(pk_U2GS_KeepAlive,{
	timestamp = 0
	}).

-define(CMD_GS2U_KeepAlive,25643).
-record(pk_GS2U_KeepAlive,{
	timesTamp = 0,
	resVersion = 0
	}).

-define(CMD_SkillFix,27744).
-record(pk_SkillFix,{
	skillID = 0,
	skill_index = 0,
	level = 0,
	fixIDList = []
	}).

-define(CMD_ObjectSkillFix,4895).
-record(pk_ObjectSkillFix,{
	objectID = 0,
	roleID = 0,
	fixList = []
	}).

-define(CMD_GS2U_ObjectSkillFix,12598).
-record(pk_GS2U_ObjectSkillFix,{
	objectFixList = []
	}).

-define(CMD_SkillFixSt,26579).
-record(pk_SkillFixSt,{
	role_id = 0,
	fixList = []
	}).

-define(CMD_GS2U_MySkillFix,55050).
-record(pk_GS2U_MySkillFix,{
	fix_skill_list = []
	}).

-define(CMD_BuffFix,60866).
-record(pk_BuffFix,{
	fix_type = 0,
	fix_param = 0,
	fix_id = 0
	}).

-define(CMD_GS2U_MyBuffFix,18987).
-record(pk_GS2U_MyBuffFix,{
	fix_list = []
	}).

-define(CMD_EqLookInfo,17213).
-record(pk_EqLookInfo,{
	itemid = 0,
	level = 0
	}).

-define(CMD_WeaponLookInfo,60668).
-record(pk_WeaponLookInfo,{
	weapon_id = 0,
	weapon_vfx = 0,
	weapon_level = 0,
	weapon_star = 0,
	weapon_reopen = 0,
	weapon_stars = [],
	grow_reaches = []
	}).

-define(CMD_roleModel,25989).
-record(pk_roleModel,{
	role_id = 0,
	career = 0,
	create_time = 0,
	is_leader = 0,
	eq_list = [],
	honor_lv = 0,
	title_id = 0,
	wing_id = 0,
	mount_id = 0,
	dragon_id = 0,
	fashionCfgIDList = [],
	hair_color_id = 0,
	skin_color_id = 0,
	height = 0,
	fashion_color = 0,
	tattoo = 0,
	tattoo_color = 0,
	inherit_lv = 0,
	weapon_list = [],
	career_lv = 0
	}).

-define(CMD_petModel,40183).
-record(pk_petModel,{
	pet_cfg_id = 0,
	pet_star = 0,
	pet_pos = 0,
	pet_lv = 0,
	pet_sp_lv = 0,
	illusion_id = 0
	}).

-define(CMD_playerModelUI,48908).
-record(pk_playerModelUI,{
	playerId = 0,
	name = "",
	vip = 0,
	sex = 0,
	level = 0,
	head_id = 0,
	frame = 0,
	serverName = "",
	guildName = "",
	battleValue = 0,
	guild_id = 0,
	guildRank = 0,
	nationality_id = 0,
	role_list = [],
	pet_list = [],
	server_id = 0
	}).

-define(CMD_U2GS_player_ui_req,2541).
-record(pk_U2GS_player_ui_req,{
	player_id = 0
	}).

-define(CMD_GS2U_player_ui_ret,6254).
-record(pk_GS2U_player_ui_ret,{
	player_ui = #pk_playerModelUI{}
	}).

-define(CMD_LookInfoPlayer4UI,24618).
-record(pk_LookInfoPlayer4UI,{
	player_id = 0,
	name = "",
	level = 0,
	headid = 0,
	frame = 0,
	battle_value = 0,
	vip = 0,
	career = 0,
	fateLevel = 0,
	fashionCfgIDList = [],
	eq_list = [],
	suitChara = 0,
	suitLevel = 0,
	suitQuality = 0,
	wingCfgID = 0,
	sex = 0,
	sutraDataID = [],
	pet_id = 0,
	weapon_id = 0,
	weapon_vfx = 0,
	weapon_level = 0,
	weapon_star = 0,
	ancient_holy_eq_id = 0,
	ancient_holy_eq_enhance_level = 0,
	hair_color_id = 0,
	skin_color_id = 0,
	height = 0,
	fashion_color = 0,
	tattoo = 0,
	tattoo_color = 0
	}).

-define(CMD_U2GS_LookInfoPlayer4UIReq,55707).
-record(pk_U2GS_LookInfoPlayer4UIReq,{
	player_id = 0
	}).

-define(CMD_GS2U_LookInfoPlayer4UISync,17221).
-record(pk_GS2U_LookInfoPlayer4UISync,{
	look_info = #pk_LookInfoPlayer4UI{}
	}).

-define(CMD_topBattleHero,12323).
-record(pk_topBattleHero,{
	heroDataID = 0,
	star = 0,
	chara = 0,
	awaken = 0
	}).

-define(CMD_topPlayer,11352).
-record(pk_topPlayer,{
	playerId = 0,
	name = "",
	vip = 0,
	sex = 0,
	career = 0,
	level = 0,
	fateLevel = 0,
	headID = 0,
	frame = 0,
	serverName = "",
	guildName = "",
	battleValue = 0,
	titleID = 0,
	mountDataID = 0,
	mountStar = 0,
	fashionCfgIDList = [],
	eq_list = [],
	battleHeroID_list = [],
	rank = 0,
	value = 0,
	customInt = [],
	worship_times = 0,
	is_worship = 0,
	time = 0,
	guild_id = 0,
	guildRank = 0,
	wingCfgID = 0,
	intensity_lv = 0,
	weapon_id = 0,
	weapon_vfx = 0,
	weapon_level = 0,
	weapon_star = 0,
	nationality_id = 0,
	ancient_holy_eq_id = 0,
	ancient_holy_eq_enhance_level = 0,
	contribution = 0,
	nobility_id = 0
	}).

-define(CMD_U2GS_GetTopRankInfo,49702).
-record(pk_U2GS_GetTopRankInfo,{
	type = 0
	}).

-define(CMD_GS2U_TopRank,13923).
-record(pk_GS2U_TopRank,{
	type = 0,
	topPlayers = []
	}).

-define(CMD_U2GS_WorshipPlayer,51446).
-record(pk_U2GS_WorshipPlayer,{
	targetID = 0
	}).

-define(CMD_U2GS_getBattleTopModel,47673).
-record(pk_U2GS_getBattleTopModel,{
	}).

-define(CMD_GS2U_BattleTopModelInfo,11446).
-record(pk_GS2U_BattleTopModelInfo,{
	type = 0,
	topPlayers = []
	}).

-define(CMD_ArenaHistory,57964).
-record(pk_ArenaHistory,{
	time = 0,
	playerName = "",
	type = 0,
	newRank = 0,
	playerID = 0
	}).

-define(CMD_ArenaPlayer,57296).
-record(pk_ArenaPlayer,{
	player = #pk_LookInfoPlayer4UI{},
	rankNumber = 0
	}).

-define(CMD_ArenaPlayerScoreRank,58474).
-record(pk_ArenaPlayerScoreRank,{
	player_id = 0,
	player_name = "",
	player_sex = 0,
	guild_name = "",
	head_id = 0,
	frame_id = 0,
	score = 0,
	rank = 0
	}).

-define(CMD_GS2U_ArenaPlayerInfo,59478).
-record(pk_GS2U_ArenaPlayerInfo,{
	rankType = 0,
	rankNumber = 0,
	lastRank = 0,
	arenaMaxRankType = 0,
	arenaMaxRankNum = 0,
	historyList = [],
	playerList = []
	}).

-define(CMD_GS2U_ArenaRankInfo,23176).
-record(pk_GS2U_ArenaRankInfo,{
	playerList = []
	}).

-define(CMD_U2GS_GetArenaScoreRank,47719).
-record(pk_U2GS_GetArenaScoreRank,{
	}).

-define(CMD_GS2U_GetArenaScoreRankRet,58817).
-record(pk_GS2U_GetArenaScoreRankRet,{
	rank_list = [],
	my_rank = 0,
	my_score = 0
	}).

-define(CMD_U2GS_RequestWolrdBossInfo,54159).
-record(pk_U2GS_RequestWolrdBossInfo,{
	dungeonID = 0
	}).

-define(CMD_GS2U_WolrdBossInfo,16219).
-record(pk_GS2U_WolrdBossInfo,{
	worldBossID = 0,
	bossIndex = 0,
	worldBossLevel = 0,
	maxFightCount = 0,
	curFightCount = 0,
	startNow = 0,
	startTime = 0,
	endTime = 0,
	curHp = 0,
	lastKillerName = ""
	}).

-define(CMD_U2GS_RequestBuyWorldBossBuff,52749).
-record(pk_U2GS_RequestBuyWorldBossBuff,{
	buffIndex = 0
	}).

-define(CMD_GS2U_RequestBuyWorldBossBuffResult,11765).
-record(pk_GS2U_RequestBuyWorldBossBuffResult,{
	result = 0,
	buffIndex = 0
	}).

-define(CMD_rewardStc,58036).
-record(pk_rewardStc,{
	type = 0,
	id = 0,
	num = 0,
	bindState = 0
	}).

-define(CMD_U2GS_CreateGuild,60598).
-record(pk_U2GS_CreateGuild,{
	headIcon = 0,
	strGuildName = ""
	}).

-define(CMD_GS2U_CreateGuildResult,22380).
-record(pk_GS2U_CreateGuildResult,{
	result = 0,
	guildID = 0
	}).

-define(CMD_U2GS_QueryGuildList,49608).
-record(pk_U2GS_QueryGuildList,{
	}).

-define(CMD_guildCondition,36390).
-record(pk_guildCondition,{
	type = 0,
	value = 0
	}).

-define(CMD_GuildInfoSmall,61983).
-record(pk_GuildInfoSmall,{
	nGuildID = 0,
	headIcon = 0,
	strGuildName = "",
	nChairmanPlayerID = 0,
	strChairmanPlayerName = "",
	nLevel = 0,
	nMemberCount = 0,
	strAnnouncement = "",
	isApp = 0,
	rank = 0,
	guildBattleValue = 0,
	autoJoin = 0,
	rating = 0,
	condition_list = [],
	is_knight = 0,
	strLink = ""
	}).

-define(CMD_GS2U_GuildInfoSmallList,37552).
-record(pk_GS2U_GuildInfoSmallList,{
	info_list = []
	}).

-define(CMD_U2GS_GetMyGuildInfo,22153).
-record(pk_U2GS_GetMyGuildInfo,{
	}).

-define(CMD_guild_event,55329).
-record(pk_guild_event,{
	name = "",
	rank = 0,
	sex = 0,
	type = 0,
	time = 0,
	params = []
	}).

-define(CMD_givePieceInfo,1510).
-record(pk_givePieceInfo,{
	playerID = 0,
	strPlayerName = "",
	nPlayerLevel = 0,
	sex = 0,
	nRank = 0,
	vip = 0,
	headID = 0,
	frame = 0,
	fateLevel = 0,
	card_id = 0,
	num = 0,
	giveTime = 0
	}).

-define(CMD_guildWishData,6029).
-record(pk_guildWishData,{
	playerID = 0,
	strPlayerName = "",
	nPlayerLevel = 0,
	sex = 0,
	nRank = 0,
	vip = 0,
	headID = 0,
	frame = 0,
	card_id = 0,
	wishNum = 0,
	reciveCount = 0,
	msgTime = 0,
	wishTime = 0,
	subscribe_time = 0,
	give_List = []
	}).

-define(CMD_guildBuilding,33508).
-record(pk_guildBuilding,{
	buildingID = 0,
	level = 0
	}).

-define(CMD_GuildBaseData,29538).
-record(pk_GuildBaseData,{
	nGuildID = 0,
	headIcon = 0,
	strGuildName = "",
	nChairmanPlayerID = 0,
	strChairmanPlayerName = "",
	nRank = 0,
	nLevel = 0,
	dayExp = 0,
	weekExp = 0,
	nExp = 0,
	nContribute = 0,
	memberCount = 0,
	strAnnouncement = "",
	feteValue = 0,
	feteCount = 0,
	feteTotalTimes = 0,
	createTime = 0,
	changeNameTime = 0,
	guildMoney = 0,
	autoJoin = 0,
	building_materials = 0,
	treasure_chest = 0,
	treasure_chest_consume = 0,
	assign_treasure_rule = 0,
	wish_limit_num = 0,
	chariot_use_rule = 0,
	bonfire_boss_order = 0,
	condition_list = [],
	building_list = [],
	chariot_science_list = [],
	active_value = 0,
	active_less_day = 0,
	guild_ins_zones_assign_rule = 0,
	is_knight = 0,
	strLink = ""
	}).

-define(CMD_FeteAwardsList,27355).
-record(pk_FeteAwardsList,{
	feteID = 0
	}).

-define(CMD_GuildMemberData,62025).
-record(pk_GuildMemberData,{
	nPlayerID = 0,
	strPlayerName = "",
	sex = 0,
	nPlayerLevel = 0,
	nRank = 0,
	vip = 0,
	frame = 0,
	headID = 0,
	fateLevel = 0,
	nAddExp = 0,
	nDailyContr = 0,
	nweeklyContr = 0,
	nContribute = 0,
	nDonateIntegral = 0,
	bOnline = 0,
	join_time = 0,
	battleValue = 0,
	offlineTime = 0,
	salary = 0,
	nationality_id = 0,
	state_mark = 0,
	active_value = 0
	}).

-define(CMD_GS2U_GuildFullInfo,51501).
-record(pk_GS2U_GuildFullInfo,{
	stBase = #pk_GuildBaseData{},
	total_bv = 0,
	my_rank = 0,
	feteList = [],
	last_give_time = 0,
	active_value_access = [],
	active_less_day = 0
	}).

-define(CMD_U2GS_GetMyGuildMemberInfo,53164).
-record(pk_U2GS_GetMyGuildMemberInfo,{
	}).

-define(CMD_GS2U_GuildAllMemberInfo,59041).
-record(pk_GS2U_GuildAllMemberInfo,{
	member_list = []
	}).

-define(CMD_U2GS_GetMyGuildEvent,16221).
-record(pk_U2GS_GetMyGuildEvent,{
	}).

-define(CMD_GS2U_GetMyGuildEventRet,24488).
-record(pk_GS2U_GetMyGuildEventRet,{
	event_list = []
	}).

-define(CMD_U2GS_GetMyGuildWishData,58948).
-record(pk_U2GS_GetMyGuildWishData,{
	}).

-define(CMD_GS2U_GetMyGuildWishDataRet,17307).
-record(pk_GS2U_GetMyGuildWishDataRet,{
	wish_list = []
	}).

-define(CMD_U2GS_GetMyGuildApplicantInfo,65101).
-record(pk_U2GS_GetMyGuildApplicantInfo,{
	}).

-define(CMD_GuildApplicantData,2318).
-record(pk_GuildApplicantData,{
	nPlayerID = 0,
	strPlayerName = "",
	nPlayerLevel = 0,
	player_sex = 0,
	vip = 0,
	headID = 0,
	frame = 0,
	battleValue = 0,
	fateLevel = 0
	}).

-define(CMD_GS2U_GuildApplicantInfoList,25467).
-record(pk_GS2U_GuildApplicantInfoList,{
	info_list = []
	}).

-define(CMD_U2GS_RequestChangeGuildAnnouncement,7484).
-record(pk_U2GS_RequestChangeGuildAnnouncement,{
	strAnnouncement = ""
	}).

-define(CMD_GS2U_RequestChangeGuildAnnouncementResult,56426).
-record(pk_GS2U_RequestChangeGuildAnnouncementResult,{
	result = 0
	}).

-define(CMD_GS2U_GuildAnnouncementChanged,12991).
-record(pk_GS2U_GuildAnnouncementChanged,{
	strAnnouncement = ""
	}).

-define(CMD_U2GS_RequestChangeGuildLinkUrl,52208).
-record(pk_U2GS_RequestChangeGuildLinkUrl,{
	strLink = ""
	}).

-define(CMD_GS2U_RequestChangeGuildLinkUrlResult,61648).
-record(pk_GS2U_RequestChangeGuildLinkUrlResult,{
	result = 0
	}).

-define(CMD_GS2U_GuildLinkUrlChanged,48927).
-record(pk_GS2U_GuildLinkUrlChanged,{
	strLink = ""
	}).

-define(CMD_U2GS_RequestGuildContribute,24236).
-record(pk_U2GS_RequestGuildContribute,{
	nMoney = 0,
	nGold = 0,
	nItemCount = 0
	}).

-define(CMD_GS2U_RequestGuildContributeResult,40141).
-record(pk_GS2U_RequestGuildContributeResult,{
	result = 0
	}).

-define(CMD_GS2U_GuildLevelEXPChanged,24512).
-record(pk_GS2U_GuildLevelEXPChanged,{
	nLevel = 0,
	nEXP = 0
	}).

-define(CMD_GS2U_GuildMemberOnlineChanged,38854).
-record(pk_GS2U_GuildMemberOnlineChanged,{
	nPlayerID = 0,
	nOnline = 0
	}).

-define(CMD_U2GS_RequestGuildMemberRankChange,3560).
-record(pk_U2GS_RequestGuildMemberRankChange,{
	nPlayerID = 0,
	nRank = 0
	}).

-define(CMD_GS2U_GuildMemberRankChangedResult,14002).
-record(pk_GS2U_GuildMemberRankChangedResult,{
	result = 0,
	nPlayerID = 0,
	nNewRank = 0
	}).

-define(CMD_U2GS_RequestGuildKickOutMember,31338).
-record(pk_U2GS_RequestGuildKickOutMember,{
	nPlayerID = 0
	}).

-define(CMD_GS2U_RequestGuildKickOutMemberResult,27205).
-record(pk_GS2U_RequestGuildKickOutMemberResult,{
	result = 0
	}).

-define(CMD_U2GS_RequestGuildQuit,59208).
-record(pk_U2GS_RequestGuildQuit,{
	}).

-define(CMD_GS2U_RequestGuildQuitResult,45593).
-record(pk_GS2U_RequestGuildQuitResult,{
	result = 0
	}).

-define(CMD_GS2U_GuildMemberQuit,26302).
-record(pk_GS2U_GuildMemberQuit,{
	nPlayerID = 0,
	bKickOut = 0
	}).

-define(CMD_U2GS_RequestJoinGuild,12184).
-record(pk_U2GS_RequestJoinGuild,{
	nGuildID = 0
	}).

-define(CMD_GS2U_RequestJoinGuildResult,2510).
-record(pk_GS2U_RequestJoinGuildResult,{
	result = 0
	}).

-define(CMD_U2GS_RequestGuildApplicant,29830).
-record(pk_U2GS_RequestGuildApplicant,{
	nPlayerID = 0,
	nAllowOrRefuse = 0
	}).

-define(CMD_GS2U_RequestGuildApplicantResult,14830).
-record(pk_GS2U_RequestGuildApplicantResult,{
	result = 0
	}).

-define(CMD_U2GS_RequestGuildApplicantOPAll,45855).
-record(pk_U2GS_RequestGuildApplicantOPAll,{
	nAllowOrRefuse = 0
	}).

-define(CMD_GS2U_GuildMemberAdd,13629).
-record(pk_GS2U_GuildMemberAdd,{
	stData = #pk_GuildMemberData{}
	}).

-define(CMD_GS2U_JoinGuildSuccess,64073).
-record(pk_GS2U_JoinGuildSuccess,{
	guildID = 0,
	guildName = "",
	isSuc = 0
	}).

-define(CMD_U2GS_RequestChangeGuildName,63902).
-record(pk_U2GS_RequestChangeGuildName,{
	strGuildName = ""
	}).

-define(CMD_GS2U_ChangeGuildNameResult,12205).
-record(pk_GS2U_ChangeGuildNameResult,{
	result = 0
	}).

-define(CMD_U2GS_RequestDissolveGuild,20985).
-record(pk_U2GS_RequestDissolveGuild,{
	}).

-define(CMD_GS2U_DissolveGuildResult,4203).
-record(pk_GS2U_DissolveGuildResult,{
	result = 0
	}).

-define(CMD_U2GS_GuildInvite,12435).
-record(pk_U2GS_GuildInvite,{
	playerID = 0
	}).

-define(CMD_GS2U_GuildInviteResult,63074).
-record(pk_GS2U_GuildInviteResult,{
	result = 0,
	limit_timestamp = 0,
	money_type = 0,
	money = 0
	}).

-define(CMD_U2GS_GuildInviteByMoney,40726).
-record(pk_U2GS_GuildInviteByMoney,{
	player_id = 0,
	is_use_money = false,
	money_type = 0,
	money = 0
	}).

-define(CMD_GS2U_GuildInviteByMoneyRet,8139).
-record(pk_GS2U_GuildInviteByMoneyRet,{
	result = 0
	}).

-define(CMD_GS2U_GuildInviteTip,17048).
-record(pk_GS2U_GuildInviteTip,{
	guildID = 0,
	playerID = 0,
	playerName = "",
	guildName = "",
	level = 0,
	battleValue = 0,
	vip = 0
	}).

-define(CMD_U2GS_GuildApplyInvite,55740).
-record(pk_U2GS_GuildApplyInvite,{
	isAllow = 0,
	inviterID = 0,
	guildID = 0
	}).

-define(CMD_GS2U_GuildApplyInviteResult,38409).
-record(pk_GS2U_GuildApplyInviteResult,{
	result = 0
	}).

-define(CMD_GS2U_GuildApplyInviteIsAllow,61209).
-record(pk_GS2U_GuildApplyInviteIsAllow,{
	name = "",
	result = 0
	}).

-define(CMD_U2GS_FeteGod,3068).
-record(pk_U2GS_FeteGod,{
	feteID = 0,
	feteTimes = 0
	}).

-define(CMD_GS2U_FeteGodResult,51832).
-record(pk_GS2U_FeteGodResult,{
	feteID = 0,
	sucTimes = 0,
	reward_list = [],
	result = 0
	}).

-define(CMD_U2GS_getFeteGodAward,58018).
-record(pk_U2GS_getFeteGodAward,{
	feteIdList = []
	}).

-define(CMD_GS2U_getFeteGodAwardResult,409).
-record(pk_GS2U_getFeteGodAwardResult,{
	feteIdList = [],
	result = 0
	}).

-define(CMD_U2GS_donateIntegral,61697).
-record(pk_U2GS_donateIntegral,{
	}).

-define(CMD_GS2U_donateIntegralRet,7453).
-record(pk_GS2U_donateIntegralRet,{
	value = 0
	}).

-define(CMD_U2GS_donateItem,9460).
-record(pk_U2GS_donateItem,{
	id_list = []
	}).

-define(CMD_GS2U_donateItemResult,55163).
-record(pk_GS2U_donateItemResult,{
	itemID = 0,
	result = 0
	}).

-define(CMD_U2GS_changeItem,31849).
-record(pk_U2GS_changeItem,{
	id = 0,
	num = 0
	}).

-define(CMD_GS2U_changeItemResult,53512).
-record(pk_GS2U_changeItemResult,{
	id = 0,
	result = 0
	}).

-define(CMD_U2GS_deleteFromGuildBag,32872).
-record(pk_U2GS_deleteFromGuildBag,{
	id_list = []
	}).

-define(CMD_GS2U_deleteFromGuildBagResult,12344).
-record(pk_GS2U_deleteFromGuildBagResult,{
	saleID = 0,
	result = 0
	}).

-define(CMD_U2GS_getGuildSalary,6017).
-record(pk_U2GS_getGuildSalary,{
	}).

-define(CMD_GS2U_getGuildSalaryResult,37033).
-record(pk_GS2U_getGuildSalaryResult,{
	result = 0
	}).

-define(CMD_U2GS_CancelJoinGuild,26422).
-record(pk_U2GS_CancelJoinGuild,{
	guildID = 0
	}).

-define(CMD_GS2U_CancelJoinGuildResult,39516).
-record(pk_GS2U_CancelJoinGuildResult,{
	guildID = 0,
	result = 0
	}).

-define(CMD_U2GS_assign_treasure_chest,3510).
-record(pk_U2GS_assign_treasure_chest,{
	id_list = []
	}).

-define(CMD_GS2U_assign_treasure_chest_ret,22851).
-record(pk_GS2U_assign_treasure_chest_ret,{
	id_list = [],
	err_code = 0
	}).

-define(CMD_U2GS_assign_treasure_rule_set,53314).
-record(pk_U2GS_assign_treasure_rule_set,{
	rule = 0
	}).

-define(CMD_GS2U_assign_treasure_rule_set_ret,28927).
-record(pk_GS2U_assign_treasure_rule_set_ret,{
	rule = 0,
	err_code = 0
	}).

-define(CMD_U2GS_get_prestige_salary,15197).
-record(pk_U2GS_get_prestige_salary,{
	}).

-define(CMD_GS2U_get_prestige_salary_ret,62405).
-record(pk_GS2U_get_prestige_salary_ret,{
	err_code = 0
	}).

-define(CMD_U2GS_assign_treasure_event,17352).
-record(pk_U2GS_assign_treasure_event,{
	}).

-define(CMD_GS2U_assign_treasure_event_ret,29506).
-record(pk_GS2U_assign_treasure_event_ret,{
	event_list = []
	}).

-define(CMD_U2GS_guild_member_prestige,35559).
-record(pk_U2GS_guild_member_prestige,{
	type = 0
	}).

-define(CMD_GS2U_guild_member_prestige_ret,27733).
-record(pk_GS2U_guild_member_prestige_ret,{
	type = 0,
	value = 0
	}).

-define(CMD_U2GS_guild_science_info,8834).
-record(pk_U2GS_guild_science_info,{
	}).

-define(CMD_GS2U_guild_science_info_ret,56114).
-record(pk_GS2U_guild_science_info_ret,{
	list = []
	}).

-define(CMD_U2GS_guild_science_up,13065).
-record(pk_U2GS_guild_science_up,{
	id = 0
	}).

-define(CMD_GS2U_guild_science_up_ret,59473).
-record(pk_GS2U_guild_science_up_ret,{
	id = 0,
	new_lv = 0,
	error = 0
	}).

-define(CMD_chariot_stc,6990).
-record(pk_chariot_stc,{
	id = 0,
	type = 0,
	end_time = 0
	}).

-define(CMD_U2GS_guild_workshop_info,59444).
-record(pk_U2GS_guild_workshop_info,{
	}).

-define(CMD_GS2U_guild_workshop_info_ret,929).
-record(pk_GS2U_guild_workshop_info_ret,{
	list = []
	}).

-define(CMD_U2GS_guild_chariot_build,20370).
-record(pk_U2GS_guild_chariot_build,{
	build_list = []
	}).

-define(CMD_GS2U_guild_chariot_build_ret,48141).
-record(pk_GS2U_guild_chariot_build_ret,{
	error = 0
	}).

-define(CMD_U2GS_guild_chariot_build_cancel,62728).
-record(pk_U2GS_guild_chariot_build_cancel,{
	cancel_id = 0
	}).

-define(CMD_GS2U_guild_chariot_build_cancel_ret,9777).
-record(pk_GS2U_guild_chariot_build_cancel_ret,{
	cancel_id = 0,
	error = 0
	}).

-define(CMD_U2GS_chariot_use_rule,56709).
-record(pk_U2GS_chariot_use_rule,{
	value = 0
	}).

-define(CMD_GS2U_chariot_use_rule_ret,9497).
-record(pk_GS2U_chariot_use_rule_ret,{
	value = 0,
	err_code = 0
	}).

-define(CMD_GS2U_MyActiveValueAccessUpdate,33410).
-record(pk_GS2U_MyActiveValueAccessUpdate,{
	active_value_access = []
	}).

-define(CMD_GS2U_KickOutGuild,1738).
-record(pk_GS2U_KickOutGuild,{
	}).

-define(CMD_U2GS_onkeyRefuseGuildApp,59315).
-record(pk_U2GS_onkeyRefuseGuildApp,{
	}).

-define(CMD_GS2U_onkeyRefuseGuildAppResult,22696).
-record(pk_GS2U_onkeyRefuseGuildAppResult,{
	result = 0
	}).

-define(CMD_UserPlayerData,8399).
-record(pk_UserPlayerData,{
	roleID = 0,
	name = "",
	sex = 0,
	career = 0,
	level = 0,
	fashionCfgIDList = [],
	fashion_color = 0,
	equipCfgIDList = [],
	wingCfgID = 0,
	battleValue = 0,
	ancient_holy_eq_id = 0,
	ancient_holy_eq_enhance_level = 0,
	hair_color_id = 0,
	skin_color_id = 0,
	height_id = 0,
	tattoo = 0,
	tattoo_color = 0,
	is_show_helmet = 0,
	weapon_list = [],
	is_show_weapon = 0,
	career_lv = 0
	}).

-define(CMD_GS2U_UserPlayerList,8211).
-record(pk_GS2U_UserPlayerList,{
	info = []
	}).

-define(CMD_GS2U_ServerInfo,18440).
-record(pk_GS2U_ServerInfo,{
	enter_server_id = 0,
	real_server_id = 0
	}).

-define(CMD_chat_instance,7110).
-record(pk_chat_instance,{
	uid = 0,
	pk = ""
	}).

-define(CMD_U2GS_ChatInfo,22789).
-record(pk_U2GS_ChatInfo,{
	channelID = 0,
	receiverID = 0,
	content = "",
	p1_list = [],
	p2_list = [],
	ins_list = []
	}).

-define(CMD_U2GS_GetChatInstance,54243).
-record(pk_U2GS_GetChatInstance,{
	uid = 0
	}).

-define(CMD_GS2U_GetChatInstanceRet,9024).
-record(pk_GS2U_GetChatInstanceRet,{
	ins = #pk_chat_instance{}
	}).

-define(CMD_GS2U_ChatError,35966).
-record(pk_GS2U_ChatError,{
	errorCode = 0
	}).

-define(CMD_GS2U_ChatInfo,11849).
-record(pk_GS2U_ChatInfo,{
	channelID = 0,
	receiverID = 0,
	serverName = "",
	senderID = 0,
	senderName = "",
	senderSex = 0,
	senderCareer = 0,
	frame = 0,
	senderLevel = 0,
	senderVip = 0,
	senderFateLevel = 0,
	content = "",
	p1_list = [],
	p2_list = [],
	chat_bubble = 0,
	horn_bubble = 0,
	sendTime = 0,
	senderGuildID = 0,
	senderHeadID = 0,
	senderGuildRank = 0
	}).

-define(CMD_U2GS_VoiceChatInfo,59759).
-record(pk_U2GS_VoiceChatInfo,{
	channelID = 0,
	receiverID = 0,
	voiceSeconds = 0,
	voiceCacheIDList = [],
	voiceTextID = 0
	}).

-define(CMD_GS2U_VoiceChatError,745).
-record(pk_GS2U_VoiceChatError,{
	errorCode = 0
	}).

-define(CMD_GS2U_VoiceChatInfo,51922).
-record(pk_GS2U_VoiceChatInfo,{
	channelID = 0,
	receiverID = 0,
	serverName = "",
	senderID = 0,
	senderName = "",
	senderSex = 0,
	senderCareer = 0,
	frame = 0,
	senderLevel = 0,
	senderVip = 0,
	senderFateLevel = 0,
	chat_bubble = 0,
	horn_bubble = 0,
	voiceKey = 0,
	voiceSeconds = 0,
	sendTime = 0,
	senderGuildID = 0,
	voiceCount = 0,
	senderHeadID = 0,
	senderGuildRank = 0
	}).

-define(CMD_U2GS_GetVoiceContent,40894).
-record(pk_U2GS_GetVoiceContent,{
	channelID = 0,
	senderID = 0,
	voiceKey = 0
	}).

-define(CMD_GS2U_GetVoiceContent,52117).
-record(pk_GS2U_GetVoiceContent,{
	channelID = 0,
	senderID = 0,
	voiceKey = 0,
	errorCode = 0,
	voiceContent = <<>>,
	voiceIndex = 0
	}).

-define(CMD_VariantData,1214).
-record(pk_VariantData,{
	index = 0,
	value = 0
	}).

-define(CMD_VariantBigData,40680).
-record(pk_VariantBigData,{
	index = 0,
	value = 0
	}).

-define(CMD_pb_VariantData,21879).
-record(pk_pb_VariantData,{
	index = 0,
	value = 0
	}).

-define(CMD_pb_VariantBigData,45321).
-record(pk_pb_VariantBigData,{
	index = 0,
	value = 0
	}).

-define(CMD_GS2U_VariantDataSet,6809).
-record(pk_GS2U_VariantDataSet,{
	variant_type = 0,
	info_list = [],
	big_list = []
	}).

-define(CMD_VariantDataSetAll,10151).
-record(pk_VariantDataSetAll,{
	variant_type = 0,
	info_list = [],
	big_list = []
	}).

-define(CMD_GS2U_VariantDataSetAll,14990).
-record(pk_GS2U_VariantDataSetAll,{
	info_list = []
	}).

-define(CMD_GS2U_VariantRoleDataSet,21597).
-record(pk_GS2U_VariantRoleDataSet,{
	role_id = 0,
	variant_type = 0,
	info_list = [],
	big_list = []
	}).

-define(CMD_variantRoleDataSetAll,61563).
-record(pk_variantRoleDataSetAll,{
	role_id = 0,
	variant_type = 0,
	info_list = [],
	big_list = []
	}).

-define(CMD_GS2U_VariantRoleDataSetAll,22251).
-record(pk_GS2U_VariantRoleDataSetAll,{
	info_list = []
	}).

-define(CMD_PlayerBaseInfo,26065).
-record(pk_PlayerBaseInfo,{
	id = 0,
	name = "",
	sex = 0,
	career = 0,
	level = 0,
	exp = 0,
	energy = 0,
	stamina = 0,
	vip = 0,
	battleValue = 0,
	offlineTime = 0,
	recharge = 0,
	createTime = 0,
	guildID = 0,
	quitTime = 0,
	fashionCfgIDList = [],
	recharFlag = 0,
	freeVipVal = 0,
	keepLoginDays = 0,
	titleID = 0,
	weapon_id = 0,
	weapon_vfx = 0,
	weapon_level = 0,
	weapon_star = 0,
	nationality_id = 0,
	military_rank = 0,
	wingCfgID = 0,
	fwinglevel = 0,
	res_point = 0,
	guard_id = 0,
	rein_lv = 0,
	recharge_price = 0,
	headID = 0,
	guildName = "",
	isInit = 0,
	guildRank = 0
	}).

-define(CMD_PlayerBasePropertyChanged,39869).
-record(pk_PlayerBasePropertyChanged,{
	index = 0,
	value = 0
	}).

-define(CMD_role,8401).
-record(pk_role,{
	role_id = 0,
	career = 0,
	create_time = 0,
	attr_title_id = 0,
	show_title_id = 0,
	guard_id = 0,
	mount_id = 0,
	wing_id = 0,
	holy_id = 0,
	dragon_id = 0,
	battle_value = 0,
	hair_color_id = 0,
	skin_color_id = 0,
	height_id = 0,
	tattoo = 0,
	tattoo_color = 0,
	is_show_helmet = 0,
	weapon_list = [],
	is_show_weapon = 0
	}).

-define(CMD_GS2U_all_role_list,24025).
-record(pk_GS2U_all_role_list,{
	leader_role_id = 0,
	role_list = []
	}).

-define(CMD_GS2U_updated_role_list,39543).
-record(pk_GS2U_updated_role_list,{
	role_list = []
	}).

-define(CMD_role_property,53821).
-record(pk_role_property,{
	role_id = 0,
	index = 0,
	value = 0
	}).

-define(CMD_GS2U_updated_role_property,51321).
-record(pk_GS2U_updated_role_property,{
	property_list = []
	}).

-define(CMD_U2GS_create_role,59972).
-record(pk_U2GS_create_role,{
	career = 0
	}).

-define(CMD_GS2U_create_role,15248).
-record(pk_GS2U_create_role,{
	career = 0,
	error = 0,
	role_list = []
	}).

-define(CMD_U2GS_change_leader_role,18324).
-record(pk_U2GS_change_leader_role,{
	role_id = 0
	}).

-define(CMD_GS2U_change_leader_role,10514).
-record(pk_GS2U_change_leader_role,{
	error = 0,
	leader_role_id = 0
	}).

-define(CMD_RandProp,20376).
-record(pk_RandProp,{
	index = 0,
	value = 0,
	character = 0,
	p_index = 0
	}).

-define(CMD_GrowProp,47419).
-record(pk_GrowProp,{
	index = 0,
	value = 0,
	add_value = 0,
	character = 0,
	p_index = 0
	}).

-define(CMD_AddItem,56611).
-record(pk_AddItem,{
	itemDataID = 0,
	itemCount = 0
	}).

-define(CMD_AddCoin,8084).
-record(pk_AddCoin,{
	type = 0,
	amount = 0
	}).

-define(CMD_EqInfo,6415).
-record(pk_EqInfo,{
	equid = 0,
	cfg_id = 0,
	character = 0,
	star = 0,
	bind = 0,
	rand_prop = [],
	beyond_prop = [],
	gd_prop = [],
	gem_hole_num = 0,
	polarity = 0
	}).

-define(CMD_godOrnamentAttr,61531).
-record(pk_godOrnamentAttr,{
	index = 0,
	value = 0,
	is_start = 0
	}).

-define(CMD_godOrnamentLayer,40748).
-record(pk_godOrnamentLayer,{
	type = 0,
	order = 0,
	quality = 0,
	active_times = 0,
	excellence_active = [],
	advance_times = 0,
	excellence_advance = []
	}).

-define(CMD_EqAddition,51312).
-record(pk_EqAddition,{
	eq_Uid = 0,
	cfg_id = 0,
	rand_props = []
	}).

-define(CMD_AEquipmentInfo,10463).
-record(pk_AEquipmentInfo,{
	aequip_uid = 0,
	cfg_id = 0,
	intensity_level = 0,
	intensity_exp = 0,
	intensity_t_exp = 0,
	rand_props = []
	}).

-define(CMD_ornament,1064).
-record(pk_ornament,{
	uid = 0,
	cfg_id = 0,
	bind = 0,
	int_lv = 0,
	rand_prop = [],
	beyond_prop = []
	}).

-define(CMD_constellation_equipment,50425).
-record(pk_constellation_equipment,{
	equipment_id = 0,
	cfg_id = 0,
	excellent_attr = [],
	excellent_attr1 = []
	}).

-define(CMD_ancient_holy_equipment,9211).
-record(pk_ancient_holy_equipment,{
	equipment_id = 0,
	cfg_id = 0,
	high_quality_attr = [],
	superior_attr = []
	}).

-define(CMD_holy_wing,8854).
-record(pk_holy_wing,{
	holy_wing_id = 0,
	cfg_id = 0,
	attr = []
	}).

-define(CMD_dark_flame_eq,51907).
-record(pk_dark_flame_eq,{
	uid = 0,
	cfg_id = 0,
	best_attr = [],
	exc_attr = []
	}).

-define(CMD_ShengWen,52790).
-record(pk_ShengWen,{
	uid = 0,
	cfg_id = 0,
	bind = 0,
	jipin_prop = [],
	zhuoyue_prop = []
	}).

-define(CMD_ItemBaseInfo,17075).
-record(pk_ItemBaseInfo,{
	item_id = 0,
	bind = 0,
	count = 0
	}).

-define(CMD_CoinBaseInfo,42795).
-record(pk_CoinBaseInfo,{
	type = 0,
	count = 0
	}).

-define(CMD_EqBaseInfo,50304).
-record(pk_EqBaseInfo,{
	cfg_id = 0,
	character = 0,
	star = 0,
	bind = 0,
	count = 0
	}).

-define(CMD_HeroDrawItem,64455).
-record(pk_HeroDrawItem,{
	index = 0,
	cfgId = 0,
	amount = 0,
	bind = 0,
	exchange = 0,
	runescoreid = 0
	}).

-define(CMD_HeroDrawEquipment,12778).
-record(pk_HeroDrawEquipment,{
	index = 0,
	cfgId = 0,
	bind = 0,
	quality = 0,
	star = 0,
	exchange = 0
	}).

-define(CMD_HeroDrawCurrency,15991).
-record(pk_HeroDrawCurrency,{
	index = 0,
	cfgId = 0,
	amount = 0,
	exchange = 0
	}).

-define(CMD_HeroDrawAward,11466).
-record(pk_HeroDrawAward,{
	index = 0,
	needNum = 0,
	itemParaNew1 = [],
	currencyParaNew1 = [],
	itemParaNew2 = [],
	currencyParaNew2 = [],
	itemParaNew3 = [],
	currencyParaNew3 = []
	}).

-define(CMD_HeroDrawFinishAward,14531).
-record(pk_HeroDrawFinishAward,{
	index = 0,
	choice = 0
	}).

-define(CMD_HeroDrawAwardShow,49708).
-record(pk_HeroDrawAwardShow,{
	index = 0,
	type = 0,
	typeId = 0,
	order = 0,
	star = 0,
	bind = 0,
	number = 0,
	show = 0
	}).

-define(CMD_HeroDrawModelShow,46655).
-record(pk_HeroDrawModelShow,{
	itemId = 0,
	modelId = 0,
	zoom = 0,
	shift_x = 0,
	shift_y = 0,
	shift_z = 0,
	rotate_x = 0,
	rotate_y = 0,
	rotate_z = 0
	}).

-define(CMD_HeroDrawTimesShow,12154).
-record(pk_HeroDrawTimesShow,{
	drawTimes = 0,
	type = 0,
	typeId = 0,
	quality = 0,
	star = 0,
	bind = 0,
	num = 0
	}).

-define(CMD_HeroDrawEffect,17771).
-record(pk_HeroDrawEffect,{
	item_id = 0,
	min = 0,
	max = 0,
	index = 0
	}).

-define(CMD_HeroAwardShow,37160).
-record(pk_HeroAwardShow,{
	type = 0,
	equip_id = 0,
	num = 0,
	quality = 0,
	star = 0
	}).

-define(CMD_RoulettePreviewBigInfo,29309).
-record(pk_RoulettePreviewBigInfo,{
	id = 0,
	type = 0,
	itemlist = [],
	model = #pk_NewModelInfo{},
	picPath = "",
	text = ""
	}).

-define(CMD_HeroAwardNumCfg,44703).
-record(pk_HeroAwardNumCfg,{
	time_id = 0,
	timeNum = 0,
	timeEquipShow = [],
	timeItemShow = [],
	timeCurrencyShow = [],
	show = 0
	}).

-define(CMD_HeroAllAwardNumShow,28254).
-record(pk_HeroAllAwardNumShow,{
	type = 0,
	cfg_id = 0,
	num = 0,
	quality = 0,
	star = 0,
	is_band = false
	}).

-define(CMD_HeroAllAwardNumCfg,51511).
-record(pk_HeroAllAwardNumCfg,{
	id = 0,
	oder = 0,
	times = 0,
	oder_max = 0,
	item_list = [],
	show = 0
	}).

-define(CMD_HeroDrawCfg,44982).
-record(pk_HeroDrawCfg,{
	data_id = 0,
	levelLimit = 0,
	turnId = 0,
	consItem = 0,
	genericConsItem = 0,
	consNumList = [],
	item = [],
	currency = [],
	rollingEquipShow = [],
	rollingItemShow = [],
	rollingCurrencyShow = [],
	equipShow = [],
	itemShow = [],
	currencyShow = [],
	showNum = [],
	awardList = [],
	awardShowitem = [],
	awardExpireTime = 0,
	awardNum = 0,
	awardModelScale = [],
	shopID = 0,
	textID = "",
	textTitle = "",
	textDoc = "",
	personLuckyMax = 0,
	worldLuckyMax = 0,
	worldLuckyAddRate = 0,
	show = [],
	modelLeft = #pk_HeroDrawModelShow{},
	modelcentre = #pk_HeroDrawModelShow{},
	modelright = #pk_HeroDrawModelShow{},
	scoreModel = #pk_HeroDrawModelShow{},
	timeShow = [],
	isTurn = false,
	slotLeft = "",
	slotCenter = "",
	slotRight = "",
	modelLeft2 = #pk_HeroDrawModelShow{},
	modelCenter2 = #pk_HeroDrawModelShow{},
	modelRight2 = #pk_HeroDrawModelShow{},
	effect = [],
	xunbao_Show = 0,
	awardShow = [],
	timeAwardShow = [],
	timeallAwardShow = []
	}).

-define(CMD_U2GS_PreviewBigList,25445).
-record(pk_U2GS_PreviewBigList,{
	data_id = 0
	}).

-define(CMD_GS2U_PreviewBigListRet,31706).
-record(pk_GS2U_PreviewBigListRet,{
	data_id = 0,
	previewBigList = []
	}).

-define(CMD_HeroDrawInfo,18610).
-record(pk_HeroDrawInfo,{
	data_id = 0,
	free_time = 0,
	period_num = 0,
	finishAwardList = [],
	person_lucky = 0,
	time_draw_award_time = [],
	today_times = 0,
	param_list = []
	}).

-define(CMD_GS2U_HeroDrawNotify,35168).
-record(pk_GS2U_HeroDrawNotify,{
	drawInfo = #pk_HeroDrawInfo{},
	drawCfg = #pk_HeroDrawCfg{}
	}).

-define(CMD_HeroDrawResult,39470).
-record(pk_HeroDrawResult,{
	itemList = [],
	currencyList = [],
	equipmentList = []
	}).

-define(CMD_U2GS_HeroDraw,12641).
-record(pk_U2GS_HeroDraw,{
	data_id = 0,
	draw_time = 0,
	isFree = false
	}).

-define(CMD_GS2U_HeroDraw,29142).
-record(pk_GS2U_HeroDraw,{
	data_id = 0,
	draw_time = 0,
	isFree = false,
	isRefresh = false,
	errorCode = 0,
	drawInfo = #pk_HeroDrawInfo{},
	drawCfg = #pk_HeroDrawCfg{},
	giftItemList = [],
	giftCurrencyList = [],
	drawResultList = []
	}).

-define(CMD_HeroDrawRecord,48337).
-record(pk_HeroDrawRecord,{
	time = 0,
	playerId = 0,
	playerName = "",
	type = 0,
	itemList = [],
	currencyList = [],
	equipmentList = []
	}).

-define(CMD_U2GS_HeroDrawRecord,65021).
-record(pk_U2GS_HeroDrawRecord,{
	data_id = 0
	}).

-define(CMD_GS2U_HeroDrawRecord,12136).
-record(pk_GS2U_HeroDrawRecord,{
	data_id = 0,
	myList = [],
	allList = []
	}).

-define(CMD_HeroDrawRuneShow,1730).
-record(pk_HeroDrawRuneShow,{
	runeNum = 0,
	itemShow = [],
	currencyShow = []
	}).

-define(CMD_U2GS_HeroDrawRuneShow,24830).
-record(pk_U2GS_HeroDrawRuneShow,{
	}).

-define(CMD_GS2U_HeroDrawRuneShow,55428).
-record(pk_GS2U_HeroDrawRuneShow,{
	list = []
	}).

-define(CMD_GS2U_HeroDrawRecordAdd,25852).
-record(pk_GS2U_HeroDrawRecordAdd,{
	data_id = 0,
	type = 0,
	record = #pk_HeroDrawRecord{}
	}).

-define(CMD_HeroDrawEquipLevel,3039).
-record(pk_HeroDrawEquipLevel,{
	levelLimit = 0,
	preview = "",
	previewLimtLv = 0
	}).

-define(CMD_U2GS_HeroDrawEquipLevelList,3694).
-record(pk_U2GS_HeroDrawEquipLevelList,{
	}).

-define(CMD_GS2U_HeroDrawEquipLevelList,41278).
-record(pk_GS2U_HeroDrawEquipLevelList,{
	levelLimit = 0,
	auto_level = false,
	list = []
	}).

-define(CMD_U2GS_HeroDrawEquipLevel,45998).
-record(pk_U2GS_HeroDrawEquipLevel,{
	levelLimit = 0,
	auto_level = false
	}).

-define(CMD_GS2U_HeroDrawEquipLevel,38187).
-record(pk_GS2U_HeroDrawEquipLevel,{
	error = 0
	}).

-define(CMD_U2GS_HeroDrawTimeAward,48472).
-record(pk_U2GS_HeroDrawTimeAward,{
	data_id = 0,
	time_id = 0
	}).

-define(CMD_GS2U_HeroDrawTimeAward,56056).
-record(pk_GS2U_HeroDrawTimeAward,{
	data_id = 0,
	time_id = 0,
	errorCode = 0
	}).

-define(CMD_BagTransfer,23218).
-record(pk_BagTransfer,{
	bag_type = 0,
	ids = [],
	target_bag_type = 0
	}).

-define(CMD_U2GS_GetDrawStorageItemReq,18265).
-record(pk_U2GS_GetDrawStorageItemReq,{
	transfer_list = []
	}).

-define(CMD_GS2U_GetDrawStorageItemRet,37188).
-record(pk_GS2U_GetDrawStorageItemRet,{
	transfer_list = [],
	errorCode = 0
	}).

-define(CMD_U2GS_ReceiveTaiTanDraw,44201).
-record(pk_U2GS_ReceiveTaiTanDraw,{
	season_id = 0,
	oder = 0
	}).

-define(CMD_GS2U_ReceiveTaiTanDrawRet,31911).
-record(pk_GS2U_ReceiveTaiTanDrawRet,{
	data_id = 0,
	season_id = 0,
	oder = 0,
	errorCode = 0
	}).

-define(CMD_U2GS_ReceiveTaiTanSynthe,39278).
-record(pk_U2GS_ReceiveTaiTanSynthe,{
	cfg_id = 0,
	num = 0
	}).

-define(CMD_GS2U_ReceiveTaiTanSyntheRet,55124).
-record(pk_GS2U_ReceiveTaiTanSyntheRet,{
	cfg_id = 0,
	num = 0,
	errorCode = 0
	}).

-define(CMD_BagItemInfo,57138).
-record(pk_BagItemInfo,{
	id = 0,
	item_data_id = 0,
	amount = 0,
	quality = 0,
	genius = 0,
	bind = 0,
	expireTime = 0
	}).

-define(CMD_GS2U_UdateItem,11894).
-record(pk_GS2U_UdateItem,{
	bagType = 0,
	itemInfo = #pk_BagItemInfo{}
	}).

-define(CMD_U2GS_UseItem,16702).
-record(pk_U2GS_UseItem,{
	bag_id = 0,
	itemDBID = 0,
	itemCount = 0,
	param = 0
	}).

-define(CMD_GS2U_UseItem,12715).
-record(pk_GS2U_UseItem,{
	itemDBID = 0,
	bag_id = 0,
	use_count = 0,
	errorCode = 0,
	addItemList = [],
	useType = 0,
	getCount = 0,
	artiItemDBID = 0,
	itemDataID = 0,
	coinList = [],
	eqs = []
	}).

-define(CMD_GS2U_SellItem,27590).
-record(pk_GS2U_SellItem,{
	errorCode = 0
	}).

-define(CMD_TaskProgress,17580).
-record(pk_TaskProgress,{
	roleID = 0,
	taskID = 0,
	progress = 0
	}).

-define(CMD_GS2U_TaskInfo,6730).
-record(pk_GS2U_TaskInfo,{
	acceptedList = [],
	activeIDList = [],
	activeValue = 0
	}).

-define(CMD_U2GS_RequestTaskInfo,14811).
-record(pk_U2GS_RequestTaskInfo,{
	}).

-define(CMD_GS2U_TaskCompleteList,16996).
-record(pk_GS2U_TaskCompleteList,{
	task_id_list = []
	}).

-define(CMD_U2GS_TaskProgressUpdate,29073).
-record(pk_U2GS_TaskProgressUpdate,{
	roleID = 0,
	taskID = 0,
	progress = 0
	}).

-define(CMD_GS2U_TaskProgressUpdate,19420).
-record(pk_GS2U_TaskProgressUpdate,{
	roleID = 0,
	taskID = 0,
	errorCode = 0,
	progress = 0
	}).

-define(CMD_U2GS_TaskComplete,20104).
-record(pk_U2GS_TaskComplete,{
	roleID = 0,
	taskID = 0,
	isMultiple = false
	}).

-define(CMD_GS2U_TaskComplete,16143).
-record(pk_GS2U_TaskComplete,{
	roleID = 0,
	taskID = 0,
	isMultiple = false,
	errorCode = 0,
	activeValue = 0
	}).

-define(CMD_U2GS_CheckTaskProgress,17286).
-record(pk_U2GS_CheckTaskProgress,{
	taskID = 0
	}).

-define(CMD_ShopDiscount,12098).
-record(pk_ShopDiscount,{
	num = 0,
	discount = 0
	}).

-define(CMD_ShopItem,42369).
-record(pk_ShopItem,{
	itemDataID = 0,
	bind = 0,
	bind_show = 0,
	oldCount = 0,
	count = 0,
	discount = 0,
	discountList = []
	}).

-define(CMD_ShopCurrency,36647).
-record(pk_ShopCurrency,{
	currencyType = 0,
	oldPrice = 0,
	price = 0,
	discount = 0,
	discountList = []
	}).

-define(CMD_ShopEquip,58864).
-record(pk_ShopEquip,{
	cfg_id = 0,
	chara = 0,
	star = 0,
	bind = 0,
	count = 0,
	discount = 0,
	discountList = []
	}).

-define(CMD_ShopData,43282).
-record(pk_ShopData,{
	shopDataID = 0,
	refresh_ctl = 0,
	item = #pk_ShopItem{},
	currency = #pk_ShopCurrency{},
	equip = #pk_ShopEquip{},
	currency1 = #pk_ShopCurrency{},
	currency2 = #pk_ShopCurrency{},
	needItem1 = #pk_ShopItem{},
	needItem2 = #pk_ShopItem{},
	limitType = 0,
	limitParam = 0,
	buyNum = 0,
	conditionType = 0,
	conditionParam = 0,
	conditionParam2 = 0,
	conditionParam3 = 0,
	recommend = 0,
	show_type = 0,
	show_param = 0,
	show_param2 = 0,
	show_param3 = 0,
	disappearType = 0,
	disappearParam = 0,
	disappearParam2 = 0,
	newItem = 0,
	recNum = 0
	}).

-define(CMD_ShopInfo,62060).
-record(pk_ShopInfo,{
	shopID = 0,
	shopTime = 0,
	refreshFreeType = 0,
	refreshFreeNum = 0,
	refreshFreeNumMax = 0,
	refreshFreeVipFunID = 0,
	refreshPayType = 0,
	refreshPayNum = 0,
	refreshPayNumMax = 0,
	refreshPayItem = #pk_ShopItem{},
	refreshPayCurrency = #pk_ShopCurrency{},
	refreshPayVipFunID = 0,
	resetType = 0,
	resetParam = 0,
	shopDataList = []
	}).

-define(CMD_U2GS_ShopDataList,36564).
-record(pk_U2GS_ShopDataList,{
	shopID = 0
	}).

-define(CMD_GS2U_ShopDataListAck,34948).
-record(pk_GS2U_ShopDataListAck,{
	shopID = 0,
	errorCode = 0,
	shopInfo = #pk_ShopInfo{}
	}).

-define(CMD_U2GS_ShopRefresh,318).
-record(pk_U2GS_ShopRefresh,{
	shopID = 0,
	shopTime = 0
	}).

-define(CMD_GS2U_ShopRefreshAck,15106).
-record(pk_GS2U_ShopRefreshAck,{
	shopID = 0,
	errorCode = 0,
	shopInfo = #pk_ShopInfo{}
	}).

-define(CMD_shopbuy_info,9059).
-record(pk_shopbuy_info,{
	shopID = 0,
	shopTime = 0,
	shopDataID = 0,
	count = 0,
	isUseItem = false
	}).

-define(CMD_shopbuy_ackinfo,64314).
-record(pk_shopbuy_ackinfo,{
	shopID = 0,
	shopDataID = 0,
	newPrice1 = 0,
	discount1 = 0,
	newPrice2 = 0,
	discount2 = 0,
	newNeedItemCount1 = 0,
	needItemDiscount1 = 0,
	newNeedItemCount2 = 0,
	needItemDiscount2 = 0,
	newBuyNum = 0
	}).

-define(CMD_U2GS_ShopBuyNew,55449).
-record(pk_U2GS_ShopBuyNew,{
	buy_list = []
	}).

-define(CMD_GS2U_ShopBuyAckNew,29773).
-record(pk_GS2U_ShopBuyAckNew,{
	errorCode = 0,
	ack_list = []
	}).

-define(CMD_shop_data_req_info,19229).
-record(pk_shop_data_req_info,{
	shop_id = 0,
	item_id_list = []
	}).

-define(CMD_shop_data_ret_info,15814).
-record(pk_shop_data_ret_info,{
	shop_id = 0,
	shop_time = 0,
	shop_data_list = []
	}).

-define(CMD_U2GS_GetShopDataInfoReq,20912).
-record(pk_U2GS_GetShopDataInfoReq,{
	data_list = []
	}).

-define(CMD_GS2U_GetShopDataInfoRet,24651).
-record(pk_GS2U_GetShopDataInfoRet,{
	err_code = 0,
	data_list = []
	}).

-define(CMD_U2GS_GetShopBuyCondition,7780).
-record(pk_U2GS_GetShopBuyCondition,{
	}).

-define(CMD_GS2U_ShopBuyCondition,28994).
-record(pk_GS2U_ShopBuyCondition,{
	fight_1v1_grade = 0
	}).

-define(CMD_U2GS_FateAddLevel,31638).
-record(pk_U2GS_FateAddLevel,{
	}).

-define(CMD_U2GS_FateAddExp,45474).
-record(pk_U2GS_FateAddExp,{
	}).

-define(CMD_U2GS_RequestEnterMap,41112).
-record(pk_U2GS_RequestEnterMap,{
	mapDataID = 0,
	isReconnect = 0,
	index = 0,
	reasonContent = ""
	}).

-define(CMD_GS2U_RequestEnterMapResult,29714).
-record(pk_GS2U_RequestEnterMapResult,{
	result = 0,
	id = 0,
	mapDataID = 0,
	x = 0,
	y = 0,
	isServerRequest = 0
	}).

-define(CMD_U2GS_EnterMap,58901).
-record(pk_U2GS_EnterMap,{
	id = 0,
	index = 0,
	toMapDataID = 0
	}).

-define(CMD_GS2U_EnterMapResult,22303).
-record(pk_GS2U_EnterMapResult,{
	result = 0,
	mapDataID = 0,
	line = 0,
	x = 0,
	y = 0
	}).

-define(CMD_BattleProp,14694).
-record(pk_BattleProp,{
	index = 0,
	value = 0
	}).

-define(CMD_RequestBattleProp,35351).
-record(pk_RequestBattleProp,{
	id = 0,
	role_id = 0,
	objectType = 0,
	battleProp = []
	}).

-define(CMD_GS2U_RequestBattleProp,24311).
-record(pk_GS2U_RequestBattleProp,{
	battle_info_list = []
	}).

-define(CMD_GS2U_BattlePropList,53825).
-record(pk_GS2U_BattlePropList,{
	id = 0,
	role_id = 0,
	objectType = 0,
	battleProp = []
	}).

-define(CMD_LookInfoRole,28626).
-record(pk_LookInfoRole,{
	id = 0,
	player_id = 0,
	career = 0,
	charState = 0,
	hp = 0,
	maxhp = 0,
	transform_id = 0,
	eq_list = [],
	mount_id = 0,
	mount_star = 0,
	wing_id = 0,
	guard_id = 0,
	holy_id_list = [],
	enable = 0,
	title_id = 0,
	honor_lv = 0,
	pos = 0,
	fashionCfgIDList = [],
	hair_color_id = 0,
	skin_color_id = 0,
	height = 0,
	fashion_color = 0,
	tattoo = 0,
	tattoo_color = 0,
	is_show_helmet = 0,
	fwingstate = 0,
	weapon_list = []
	}).

-define(CMD_map_pet,54019).
-record(pk_map_pet,{
	pet_object_id = 0,
	pet_id = 0,
	pet_star = 0,
	pet_pos = 0,
	pet_sp_lv = 0,
	been_link_pet_cfg_id = 0,
	transform_id = 0,
	illusion_id = 0,
	is_fight = 0
	}).

-define(CMD_LookInfoPlayer,6722).
-record(pk_LookInfoPlayer,{
	id = 0,
	career = 0,
	fateLevel = 0,
	ponchoLevel = 0,
	headID = 0,
	fashionCfgIDList = [],
	equipCfgIDList = [],
	eq_list = [],
	suitChara = 0,
	suitLevel = 0,
	suitQuality = 0,
	name = "",
	x = 0,
	y = 0,
	move_speed = 0,
	level = 0,
	charState = 0,
	group = 0,
	hp = 0,
	mp = 0,
	superArmor = 0,
	titleID = 0,
	guildID = 0,
	guildName = "",
	pkGroup = 0,
	battleValue = 0,
	maxhp = 0,
	guildRank = 0,
	vip = 0,
	mountDataID = 0,
	mountStar = 0,
	mountStatus = 0,
	vehicle_state = 0,
	transform_id = 0,
	meleeQuality = 0,
	wingCfgID = 0,
	serverID = 0,
	sutraDataID = [],
	team_id = 0,
	showFateLevel = false,
	weddingState = 0,
	weddingPlayerID = 0,
	weddingPlayerName = "",
	sex = 0,
	fwingstate = 0,
	pet_id = 0,
	honor_lv = 0,
	red_value = 0,
	battle_status = 0,
	gc_color = 0,
	hang_dungeon_id = 0,
	pet_star = 0,
	weapon_id = 0,
	weapon_vfx = 0,
	weapon_level = 0,
	weapon_star = 0,
	nationality_id = 0,
	shield = 0,
	max_sheild = 0,
	shield_id = 0,
	ancient_holy_eq_id = 0,
	ancient_holy_eq_enhance_level = 0,
	serverName = "",
	leader_role_id = 0,
	control_role_id = 0,
	mapRoleList = [],
	pet_object_id = 0,
	frame_id = 0,
	pet_infos = [],
	attach_monster_list = [],
	armor = 0,
	max_armor = 0
	}).

-define(CMD_GS2U_PlayerList,24845).
-record(pk_GS2U_PlayerList,{
	info_list = [],
	is_enter_map = false
	}).

-define(CMD_GS2U_LookInfoPlayer_update,48838).
-record(pk_GS2U_LookInfoPlayer_update,{
	id = 0,
	value_list = []
	}).

-define(CMD_GS2U_LookInfoPlayer_EqLookinfo,25606).
-record(pk_GS2U_LookInfoPlayer_EqLookinfo,{
	id = 0,
	role_id = 0,
	eq_list = []
	}).

-define(CMD_GS2U_LookInfoRole_update,15423).
-record(pk_GS2U_LookInfoRole_update,{
	id = 0,
	role_id = 0,
	value_list = []
	}).

-define(CMD_GS2U_LookInfoRole_WeaponInfo,51010).
-record(pk_GS2U_LookInfoRole_WeaponInfo,{
	id = 0,
	role_id = 0,
	weapon_list = []
	}).

-define(CMD_MirrorPlayerBindSkill,40341).
-record(pk_MirrorPlayerBindSkill,{
	role_id = 0,
	bind_skill_list = []
	}).

-define(CMD_GS2U_map_pet_info_update,1065).
-record(pk_GS2U_map_pet_info_update,{
	player_id = 0,
	pet_infos = []
	}).

-define(CMD_GS2U_LookInfoMonster_update,25591).
-record(pk_GS2U_LookInfoMonster_update,{
	id = 0,
	value_list = []
	}).

-define(CMD_LookInfoMirrorPlayer,41000).
-record(pk_LookInfoMirrorPlayer,{
	id = 0,
	career = 0,
	fateLevel = 0,
	ponchoLevel = 0,
	headID = 0,
	fashionCfgIDList = [],
	eq_list = [],
	suitChara = 0,
	suitLevel = 0,
	suitQuality = 0,
	name = "",
	x = 0,
	y = 0,
	move_speed = 0,
	level = 0,
	titleID = 0,
	charState = 0,
	group = 0,
	typeFrom = 0,
	hp = 0,
	mp = 0,
	superArmor = 0,
	guildID = 0,
	guildName = "",
	battleValue = 0,
	maxhp = 0,
	guildRank = 0,
	vip = 0,
	wingCfgID = 0,
	showFateLevel = false,
	sutraDataIDList = [],
	weddingState = 0,
	weddingPlayerID = 0,
	weddingPlayerName = "",
	sex = 0,
	pet_infos = [],
	weapon_id = 0,
	weapon_vfx = 0,
	weapon_level = 0,
	weapon_star = 0,
	nationality_id = 0,
	shield = 0,
	max_sheild = 0,
	shield_id = 0,
	ancient_holy_eq_id = 0,
	ancient_holy_eq_enhance_level = 0,
	leader_role_id = 0,
	control_role_id = 0,
	mapRoleList = [],
	frame_id = 0,
	server_id = 0,
	server_name = "",
	bind_skill_list = [],
	attach_monster_list = [],
	armor = 0,
	max_armor = 0
	}).

-define(CMD_GS2U_MirroList,57810).
-record(pk_GS2U_MirroList,{
	info_list = []
	}).

-define(CMD_LookInfoStump,53555).
-record(pk_LookInfoStump,{
	stumpid = 0,
	hp = 0
	}).

-define(CMD_LookInfoMonster,8438).
-record(pk_LookInfoMonster,{
	id = 0,
	dataID = 0,
	resID = 0,
	level = 0,
	x = 0,
	y = 0,
	rotw = 0,
	status = 0,
	targetID = 0,
	owner_type = 0,
	owern_id = 0,
	move_speed = 0,
	hp = 0,
	charState = 0,
	group = 0,
	superArmor = 0,
	guildID = 0,
	maxhp = 0,
	hp_count = 0,
	guildName = "",
	transform_id = 0,
	stumpInfo = [],
	skill_use_list = [],
	attach_player_id = 0,
	attach_buff_data_id = 0,
	attach_caster_id = 0,
	attach_caster_role_id = 0
	}).

-define(CMD_GS2U_MonsterSpeedSync,62318).
-record(pk_GS2U_MonsterSpeedSync,{
	id = 0,
	move_speed = 0
	}).

-define(CMD_GS2U_MonsterList,31106).
-record(pk_GS2U_MonsterList,{
	info_list = [],
	is_enter_map = false
	}).

-define(CMD_LookInfoSummon,52742).
-record(pk_LookInfoSummon,{
	id = 0,
	dataID = 0,
	x = 0,
	y = 0,
	owner_type = 0,
	owern_id = 0,
	move_speed = 0,
	hp = 0,
	charState = 0,
	group = 0,
	superArmor = 0,
	maxhp = 0
	}).

-define(CMD_GS2U_SummonList,49500).
-record(pk_GS2U_SummonList,{
	info_list = []
	}).

-define(CMD_LookInfoNpc,33773).
-record(pk_LookInfoNpc,{
	id = 0,
	dataID = 0,
	resID = 0,
	x = 0,
	y = 0,
	rotw = 0,
	status = 0,
	superArmor = 0,
	npcType = 0
	}).

-define(CMD_GS2U_NpcList,36362).
-record(pk_GS2U_NpcList,{
	info_list = []
	}).

-define(CMD_LookInfoHero,41629).
-record(pk_LookInfoHero,{
	id = 0,
	pos = 0,
	x = 0,
	y = 0,
	move_speed = 0,
	status = 0,
	owern_id = 0,
	item_data_id = 0,
	star = 0,
	chara = 0,
	charState = 0,
	group = 0,
	hp = 0,
	superArmor = 0,
	maxhp = 0
	}).

-define(CMD_GS2U_LookHeroList,57077).
-record(pk_GS2U_LookHeroList,{
	info_list = []
	}).

-define(CMD_MapTombInfo,39841).
-record(pk_MapTombInfo,{
	bossID = 0,
	serverName = "",
	killerName = "",
	deadTime = 0
	}).

-define(CMD_LookInfoMachineTrap,54489).
-record(pk_LookInfoMachineTrap,{
	id = 0,
	dataID = 0,
	x = 0,
	y = 0,
	rotw = 0,
	hp = 0,
	att_cd = 0,
	stat = 0,
	skillID = 0,
	guildID = 0,
	map_tomb = #pk_MapTombInfo{}
	}).

-define(CMD_GS2U_MachineTrapList,36708).
-record(pk_GS2U_MachineTrapList,{
	info_list = []
	}).

-define(CMD_U2GS_control_role,51262).
-record(pk_U2GS_control_role,{
	object_id = 0,
	control_role_id = 0
	}).

-define(CMD_GS2U_control_role,14911).
-record(pk_GS2U_control_role,{
	object_id = 0,
	control_role_id = 0
	}).

-define(CMD_GS2U_MapObjectSpeak,10573).
-record(pk_GS2U_MapObjectSpeak,{
	id = 0,
	stringID = ""
	}).

-define(CMD_U2GS_MonsterBossDown,63189).
-record(pk_U2GS_MonsterBossDown,{
	id = 0
	}).

-define(CMD_GS2U_MonsterBossDown,8876).
-record(pk_GS2U_MonsterBossDown,{
	id = 0,
	isWeak = 0
	}).

-define(CMD_GS2U_MonsterBossNotify,37338).
-record(pk_GS2U_MonsterBossNotify,{
	id = 0,
	bossState = 0,
	type = 0
	}).

-define(CMD_U2GS_MonsterBornFinish,36069).
-record(pk_U2GS_MonsterBornFinish,{
	id = 0
	}).

-define(CMD_GS2U_ActorDisapearList,56002).
-record(pk_GS2U_ActorDisapearList,{
	delay = 0,
	info_list = []
	}).

-define(CMD_PosInfo,6288).
-record(pk_PosInfo,{
	x = 0,
	y = 0
	}).

-define(CMD_U2GS_MoveTo,18779).
-record(pk_U2GS_MoveTo,{
	id = 0,
	posX = 0,
	posY = 0,
	posInfos = [],
	timestamp = 0
	}).

-define(CMD_U2GS_StopMove,5064).
-record(pk_U2GS_StopMove,{
	id = 0,
	posX = 0,
	posY = 0,
	angleX = 0,
	angleY = 0
	}).

-define(CMD_GS2U_StopMove,21565).
-record(pk_GS2U_StopMove,{
	id = 0,
	posX = 0,
	posY = 0,
	angleX = 0,
	angleY = 0
	}).

-define(CMD_GS2U_MoveInfo,40549).
-record(pk_GS2U_MoveInfo,{
	id = 0,
	posX = 0,
	posY = 0,
	posInfos = []
	}).

-define(CMD_U2GS_SyncView,38326).
-record(pk_U2GS_SyncView,{
	type = 0,
	view_num = 0
	}).

-define(CMD_GS2U_ActorStateFlagSet,20977).
-record(pk_GS2U_ActorStateFlagSet,{
	actorID = 0,
	nSetStateFlag = 0
	}).

-define(CMD_U2GS_RequestTrigger,27512).
-record(pk_U2GS_RequestTrigger,{
	id = 0,
	op = 0
	}).

-define(CMD_TriggerInfo,43134).
-record(pk_TriggerInfo,{
	triggerId = 0,
	type = 0
	}).

-define(CMD_U2GS_MoveTrigger,29258).
-record(pk_U2GS_MoveTrigger,{
	objectid = 0,
	info = []
	}).

-define(CMD_GS2U_Trigger,43257).
-record(pk_GS2U_Trigger,{
	id = 0,
	op = 0,
	fromObjectid = 0
	}).

-define(CMD_U2GS_RequestMachineTrap,13893).
-record(pk_U2GS_RequestMachineTrap,{
	id = 0,
	op = 0
	}).

-define(CMD_GS2U_MachineTrap,21072).
-record(pk_GS2U_MachineTrap,{
	id = 0,
	op = 0
	}).

-define(CMD_U2GS_RequestMachineHP,46653).
-record(pk_U2GS_RequestMachineHP,{
	attackerID = 0,
	targetID = 0,
	target_role_id = 0
	}).

-define(CMD_GS2U_MachineHP,2184).
-record(pk_GS2U_MachineHP,{
	attackerID = 0,
	targetID = 0,
	target_role_id = 0,
	value = 0
	}).

-define(CMD_itemInfo,56453).
-record(pk_itemInfo,{
	itemID = 0,
	count = 0,
	multiple = 0,
	bindState = 0
	}).

-define(CMD_NewitemInfo,11635).
-record(pk_NewitemInfo,{
	itemID = 0,
	count = 0,
	multiple = 0,
	bindState = 0
	}).

-define(CMD_CoinInfo,32250).
-record(pk_CoinInfo,{
	type = 0,
	amount = 0,
	multiple = 0
	}).

-define(CMD_NewCoinInfo,52968).
-record(pk_NewCoinInfo,{
	type = 0,
	amount = 0,
	multiple = 0
	}).

-define(CMD_GS2U_CopyMapAwardList,19191).
-record(pk_GS2U_CopyMapAwardList,{
	objectID = 0,
	coinList = [],
	itemList = [],
	eqs = []
	}).

-define(CMD_PlayerShortInfo,40759).
-record(pk_PlayerShortInfo,{
	name = "",
	battleValue = 0
	}).

-define(CMD_demonItem,47999).
-record(pk_demonItem,{
	itemID = 0,
	num = 0,
	itemDBID = 0,
	bind = 0,
	level = 0,
	point = 0
	}).

-define(CMD_GS2U_CopyMapSettleAccounts,49013).
-record(pk_GS2U_CopyMapSettleAccounts,{
	dungeonType = 0,
	dungeonID = 0,
	cardID = 0,
	isWin = 0,
	exp = 0,
	coinList = [],
	itemList = [],
	artiIDList = [],
	settleType = 0,
	isConqAward = 0,
	demonItemList = [],
	eq_list = [],
	cur_star = 0,
	max_enter_count = 0,
	enter_count = 0,
	double_times = 0,
	challenge_time = 0
	}).

-define(CMD_GS2U_MopUpCopyMapResult,942).
-record(pk_GS2U_MopUpCopyMapResult,{
	result = 0,
	dungeonType = 0,
	dungeonID = 0,
	cardID = 0,
	isWin = 0,
	exp = 0,
	coinList = [],
	itemList = [],
	demonItemList = [],
	eq_list = []
	}).

-define(CMD_GS2U_OpenChapterBoxResult,61763).
-record(pk_GS2U_OpenChapterBoxResult,{
	result = 0,
	coinList = [],
	itemList = [],
	index = 0
	}).

-define(CMD_GS2U_GainConqAwardResult,3120).
-record(pk_GS2U_GainConqAwardResult,{
	result = 0,
	dungeonID = 0,
	coinList = [],
	itemList = [],
	index = 0
	}).

-define(CMD_U2GS_GiftsDataReq,25939).
-record(pk_U2GS_GiftsDataReq,{
	}).

-define(CMD_GS2U_GiftsDataRet,1139).
-record(pk_GS2U_GiftsDataRet,{
	login_days = 0,
	get_list = []
	}).

-define(CMD_U2GS_GetGiftReq,1924).
-record(pk_U2GS_GetGiftReq,{
	gift_id = 0
	}).

-define(CMD_GS2U_GetGiftRet,5170).
-record(pk_GS2U_GetGiftRet,{
	err_code = 0,
	gift_id = 0,
	type = 0
	}).

-define(CMD_U2GS_getRegisterData,59960).
-record(pk_U2GS_getRegisterData,{
	}).

-define(CMD_GS2U_sendRegisterData,51351).
-record(pk_GS2U_sendRegisterData,{
	sign_level = 0,
	sign_vip = 0,
	sign_days = 0,
	sign_pro_group = 0,
	sign_pro_level = 0,
	sign_pro_days = 0,
	sign_pro_total_days = 0
	}).

-define(CMD_U2GS_Register,49685).
-record(pk_U2GS_Register,{
	day = 0
	}).

-define(CMD_GS2U_feedbackRegister,28689).
-record(pk_GS2U_feedbackRegister,{
	day = 0,
	isSuc = 0
	}).

-define(CMD_U2GS_getRegisterProAward,5132).
-record(pk_U2GS_getRegisterProAward,{
	day = 0
	}).

-define(CMD_GS2U_getRegisterProAwardResult,25714).
-record(pk_GS2U_getRegisterProAwardResult,{
	day = 0,
	result = 0
	}).

-define(CMD_U2GS_requestOpenActivity,50436).
-record(pk_U2GS_requestOpenActivity,{
	}).

-define(CMD_activityList,63239).
-record(pk_activityList,{
	activityID = 0
	}).

-define(CMD_GS2U_ActivityOpenList,51156).
-record(pk_GS2U_ActivityOpenList,{
	activity_list = []
	}).

-define(CMD_U2GS_getLevelGift,32325).
-record(pk_U2GS_getLevelGift,{
	level = 0,
	is_vip = 0
	}).

-define(CMD_GS2U_feedbackGetLevelGfit,8426).
-record(pk_GS2U_feedbackGetLevelGfit,{
	level = 0,
	is_vip = 0,
	isSuc = 0,
	item = [],
	coin = [],
	eq = [],
	item1 = [],
	coin1 = [],
	eq1 = []
	}).

-define(CMD_lvlGiftInfo,50609).
-record(pk_lvlGiftInfo,{
	id = 0,
	lvl = 0,
	isGetGift = 0,
	isGetVipGift = 0,
	award_count = 0
	}).

-define(CMD_GS2U_sendLevelGift,62525).
-record(pk_GS2U_sendLevelGift,{
	gift_list = []
	}).

-define(CMD_arenaDamageInfo,26896).
-record(pk_arenaDamageInfo,{
	roleID = 0,
	career = 0,
	damage = 0,
	treat = 0,
	taskDamage = 0,
	isMine = false,
	isLeader = false
	}).

-define(CMD_GS2U_FightArenaResult,14303).
-record(pk_GS2U_FightArenaResult,{
	isWin = false,
	score = 0,
	add_score = 0,
	coinList = [],
	itemList = [],
	exp = 0
	}).

-define(CMD_U2GS_getMonthlyCardReward,55655).
-record(pk_U2GS_getMonthlyCardReward,{
	id = 0
	}).

-define(CMD_GS2U_feedbackMonthlyReward,57042).
-record(pk_GS2U_feedbackMonthlyReward,{
	id = 0,
	gold = 0,
	isSuc = 0,
	coinList = []
	}).

-define(CMD_GS2U_feedbackUplevelMonthlyCard,55125).
-record(pk_GS2U_feedbackUplevelMonthlyCard,{
	id = 0,
	isSuc = 0
	}).

-define(CMD_U2GS_requestMonthlyCard,31707).
-record(pk_U2GS_requestMonthlyCard,{
	}).

-define(CMD_monthlyCardInfo,7871).
-record(pk_monthlyCardInfo,{
	id = 0,
	isBuy = 0,
	lvl = 0,
	getDays = 0,
	allDays = 0,
	perDayNum = 0,
	isGet = 0
	}).

-define(CMD_GS2U_sendMonthlyCardInfo,38405).
-record(pk_GS2U_sendMonthlyCardInfo,{
	info_list = []
	}).

-define(CMD_GS2U_SendTipMsg,36192).
-record(pk_GS2U_SendTipMsg,{
	type = 0,
	msg = ""
	}).

-define(CMD_GS2U_SendTipID,15949).
-record(pk_GS2U_SendTipID,{
	type = 0,
	errorCode = 0
	}).

-define(CMD_GS2U_LoginAnnounce,60586).
-record(pk_GS2U_LoginAnnounce,{
	announce = ""
	}).

-define(CMD_GS2U_marqueeAnnounce,19251).
-record(pk_GS2U_marqueeAnnounce,{
	announce = "",
	playTimes = 0
	}).

-define(CMD_U2GS_DownloadReward,37090).
-record(pk_U2GS_DownloadReward,{
	}).

-define(CMD_GS2U_DownloadReward,14108).
-record(pk_GS2U_DownloadReward,{
	errorCode = 0
	}).

-define(CMD_U2GS_requestFuncList,52620).
-record(pk_U2GS_requestFuncList,{
	}).

-define(CMD_GS2U_sendCloseFuncIDList,27281).
-record(pk_GS2U_sendCloseFuncIDList,{
	funcID_list = []
	}).

-define(CMD_GS2U_openFunction,17857).
-record(pk_GS2U_openFunction,{
	funcID = 0
	}).

-define(CMD_U2GS_GuideReq,505).
-record(pk_U2GS_GuideReq,{
	guide_id = 0
	}).

-define(CMD_GS2U_GuideRet,1115).
-record(pk_GS2U_GuideRet,{
	guide_id = 0
	}).

-define(CMD_U2GS_FreeEnergy,20510).
-record(pk_U2GS_FreeEnergy,{
	type = []
	}).

-define(CMD_GS2U_FreeEnergy,54958).
-record(pk_GS2U_FreeEnergy,{
	type = [],
	errorCode = 0
	}).

-define(CMD_U2GS_PlatActiveCode,7587).
-record(pk_U2GS_PlatActiveCode,{
	token = "",
	code = "",
	cilentID = ""
	}).

-define(CMD_GS2U_PlatActiveCodeResult,38500).
-record(pk_GS2U_PlatActiveCodeResult,{
	result = 0,
	coinList = [],
	itemList = []
	}).

-define(CMD_U2GS_GMAsk,61269).
-record(pk_U2GS_GMAsk,{
	content = ""
	}).

-define(CMD_GS2U_GMAsk,20395).
-record(pk_GS2U_GMAsk,{
	errorCode = 0,
	content = "",
	sendTime = 0
	}).

-define(CMD_GS2U_GMAnswer,21495).
-record(pk_GS2U_GMAnswer,{
	senderName = "",
	content = "",
	sendTime = 0
	}).

-define(CMD_GS2U_KickMe,30511).
-record(pk_GS2U_KickMe,{
	reason = 0
	}).

-define(CMD_GS2U_CareerSwitch,38465).
-record(pk_GS2U_CareerSwitch,{
	career = 0,
	errorCode = 0
	}).

-define(CMD_U2GS_ServerTime,3504).
-record(pk_U2GS_ServerTime,{
	}).

-define(CMD_GS2U_ServerTime,37952).
-record(pk_GS2U_ServerTime,{
	serverTime = 0,
	serverDay = 0
	}).

-define(CMD_GS2U_InitMsg,54624).
-record(pk_GS2U_InitMsg,{
	serverTime = 0,
	cmdkey = 0,
	lenkey = 0,
	serverWaitTime = 0
	}).

-define(CMD_GS2U_ShopBuyNotify,8957).
-record(pk_GS2U_ShopBuyNotify,{
	shopID = 0,
	canBuy = 0
	}).

-define(CMD_shop_new,55511).
-record(pk_shop_new,{
	shop_id = 0,
	item_list = []
	}).

-define(CMD_GS2U_shop_new_notify,23879).
-record(pk_GS2U_shop_new_notify,{
	shop_id_list = []
	}).

-define(CMD_U2GS_getVipAward,8280).
-record(pk_U2GS_getVipAward,{
	}).

-define(CMD_GS2U_getVipAwardResult,49079).
-record(pk_GS2U_getVipAwardResult,{
	code = 0
	}).

-define(CMD_U2GS_getVipFreeExp,5020).
-record(pk_U2GS_getVipFreeExp,{
	}).

-define(CMD_GS2U_getVipFreeExpResult,1105).
-record(pk_GS2U_getVipFreeExpResult,{
	code = 0
	}).

-define(CMD_GS2U_MainCopyMapSettleAccounts,49396).
-record(pk_GS2U_MainCopyMapSettleAccounts,{
	dungeonType = 0,
	dungeonID = 0,
	cardID = 0,
	isWin = 0,
	exp = 0,
	coinList = [],
	itemList = [],
	artiIDList = [],
	conditionIDList = [],
	settleType = 0,
	isConqAward = 0,
	eq_list = []
	}).

-define(CMD_MopUpArenaResult,12640).
-record(pk_MopUpArenaResult,{
	errorCode = 0,
	cardID = 0,
	coinList = [],
	exp = 0,
	itemList = []
	}).

-define(CMD_GS2U_MopUpArenaResult,43767).
-record(pk_GS2U_MopUpArenaResult,{
	info_list = []
	}).

-define(CMD_LookBasePlayerInfo,64244).
-record(pk_LookBasePlayerInfo,{
	id = 0,
	name = "",
	career = 0,
	level = 0,
	fateLevel = 0,
	ponchoLevel = 0,
	headID = 0,
	fashionCfgIDList = [],
	equipCfgIDList = [],
	eq_list = [],
	suitChara = 0,
	suitLevel = 0,
	suitQuality = 0,
	vip = 0,
	title = 0,
	guildID = 0,
	heroID = 0,
	heroDataID = 0,
	heroStar = 0,
	guildName = "",
	guildRank = 0,
	mountDataID = 0,
	mountStar = 0,
	wingCfgID = 0,
	showFateLevel = false,
	weddingState = 0,
	weddingPlayerID = 0,
	weddingPlayerName = "",
	sex = 0,
	pet_id = 0,
	mount_id = 0,
	wing_id = 0,
	holy_ids = [],
	guard_id = 0,
	move_speed = 0,
	weapon_id = 0,
	weapon_vfx = 0,
	weapon_level = 0,
	weapon_star = 0,
	nationality_id = 0
	}).

-define(CMD_GS2U_BasePlayerList,36567).
-record(pk_GS2U_BasePlayerList,{
	info_list = []
	}).

-define(CMD_U2GS_BasePlayerList,1539).
-record(pk_U2GS_BasePlayerList,{
	maxCount = 0
	}).

-define(CMD_U2GS_RefreshRecoverValue,27894).
-record(pk_U2GS_RefreshRecoverValue,{
	recoverType = 0
	}).

-define(CMD_GS2U_GuildDungeonFightResult,1942).
-record(pk_GS2U_GuildDungeonFightResult,{
	isWin = 0,
	dungeonID = 0,
	damage = 0,
	coinList = [],
	itemList = [],
	rank = 0,
	settleType = 0,
	killerName = ""
	}).

-define(CMD_GS2U_OfficeChange,52303).
-record(pk_GS2U_OfficeChange,{
	oldOfficeType = 0,
	oldOffice = 0,
	officeType = 0,
	office = 0
	}).

-define(CMD_GS2U_TeamCopyMapSettleAccounts,32110).
-record(pk_GS2U_TeamCopyMapSettleAccounts,{
	dungeonType = 0,
	dungeonID = 0,
	cardID = 0,
	isWin = 0,
	exp = 0,
	exp_multi = 0,
	intimacy = 0,
	name_list = [],
	coinList = [],
	itemList = [],
	artiIDList = [],
	fightType = 0,
	settleType = 0,
	eq_list = [],
	double_times = 0,
	merge_times = 0
	}).

-define(CMD_U2GS_UseSelectItem,31999).
-record(pk_U2GS_UseSelectItem,{
	bag_id = 0,
	itemDBID = 0,
	selectIndex = [],
	itemCount = 0,
	params = 0
	}).

-define(CMD_GS2U_UseSelectItem,13987).
-record(pk_GS2U_UseSelectItem,{
	bag_id = 0,
	itemDBID = 0,
	selectIndex = [],
	errorCode = 0
	}).

-define(CMD_actionHintInfo,53622).
-record(pk_actionHintInfo,{
	dataID = 0,
	isActive = 0,
	buyItem_list = []
	}).

-define(CMD_GS2U_actionHintData,40531).
-record(pk_GS2U_actionHintData,{
	data_list = []
	}).

-define(CMD_U2GS_activePlayerAttr,45867).
-record(pk_U2GS_activePlayerAttr,{
	dataID = 0
	}).

-define(CMD_GS2U_activePlayerAttrResult,61219).
-record(pk_GS2U_activePlayerAttrResult,{
	dataID = 0,
	result = 0
	}).

-define(CMD_U2GS_buyActionItem,58259).
-record(pk_U2GS_buyActionItem,{
	dataID = 0,
	buyNumber = 0
	}).

-define(CMD_GS2U_buyActionItemResult,14549).
-record(pk_GS2U_buyActionItemResult,{
	dataID = 0,
	buyNumber = 0,
	result = 0
	}).

-define(CMD_U2GS_FetterEquipRemove,64043).
-record(pk_U2GS_FetterEquipRemove,{
	equipmentID = 0
	}).

-define(CMD_GS2U_FetterEquipRemove,11110).
-record(pk_GS2U_FetterEquipRemove,{
	equipmentID = 0,
	errorCode = 0,
	fetterEquipIDList = []
	}).

-define(CMD_GS2U_fightRingScore,56628).
-record(pk_GS2U_fightRingScore,{
	fightRingScore = 0
	}).

-define(CMD_U2GS_getPlayerTitleInfo,48292).
-record(pk_U2GS_getPlayerTitleInfo,{
	}).

-define(CMD_titleInfo,36928).
-record(pk_titleInfo,{
	titleID = 0,
	type = 0,
	expireTime = 0
	}).

-define(CMD_GS2U_SendPlayerTitleInfo,9495).
-record(pk_GS2U_SendPlayerTitleInfo,{
	title_list = []
	}).

-define(CMD_FetterID,46391).
-record(pk_FetterID,{
	id = 0,
	numb = 0
	}).

-define(CMD_ObjectProperty,4915).
-record(pk_ObjectProperty,{
	battlePropList = [],
	fetterIDList = []
	}).

-define(CMD_ObjectPropertyChanged,1412).
-record(pk_ObjectPropertyChanged,{
	battlePropList = [],
	fetterIDList = []
	}).

-define(CMD_BattleValueTuple,13357).
-record(pk_BattleValueTuple,{
	battleValue = 0,
	baseFactor = 0,
	scaleFactor = 0,
	trueFactor = 0,
	elementFactor = 0
	}).

-define(CMD_InspireTuple,14558).
-record(pk_InspireTuple,{
	inspireHp = 0,
	inspireAttack = 0,
	inspireDefence = 0,
	inspireTrueDamage = 0,
	inspireTrueDefence = 0,
	inspireFire = 0,
	inspireCold = 0,
	inspireThunder = 0,
	inspireDefFire = 0,
	inspireDefCold = 0,
	inspireDefThunder = 0,
	inspire = 0,
	inspireHpElement = 0
	}).

-define(CMD_GS2U_PlayerProperty,40523).
-record(pk_GS2U_PlayerProperty,{
	errorCode = 0,
	objectProperty = #pk_ObjectProperty{},
	battleValueTuple = #pk_BattleValueTuple{},
	skillHp = 0,
	skillAttack = 0,
	skillDefence = 0
	}).

-define(CMD_U2GS_HeroProperty,46016).
-record(pk_U2GS_HeroProperty,{
	heroID = 0
	}).

-define(CMD_U2GS_EquipProperty,5350).
-record(pk_U2GS_EquipProperty,{
	equipmentID = 0
	}).

-define(CMD_GS2U_EquipProperty,52874).
-record(pk_GS2U_EquipProperty,{
	equipmentID = 0,
	errorCode = 0,
	objectProperty = #pk_ObjectProperty{}
	}).

-define(CMD_GS2U_PlayerPropertyChanged,54005).
-record(pk_GS2U_PlayerPropertyChanged,{
	objectPropertyChanged = #pk_ObjectPropertyChanged{},
	battleValueTuple = #pk_BattleValueTuple{},
	skillHp = 0,
	skillAttack = 0,
	skillDefence = 0
	}).

-define(CMD_GS2U_EquipPropertyChanged,1420).
-record(pk_GS2U_EquipPropertyChanged,{
	equipmentID = 0,
	objectPropertyChanged = #pk_ObjectPropertyChanged{}
	}).

-define(CMD_GS2U_DeleteItemBatch,19311).
-record(pk_GS2U_DeleteItemBatch,{
	idList = []
	}).

-define(CMD_U2GS_equipTitle,21207).
-record(pk_U2GS_equipTitle,{
	type = 0,
	role_id = 0,
	titleID = 0
	}).

-define(CMD_GS2U_equipTitleResult,7112).
-record(pk_GS2U_equipTitleResult,{
	type = 0,
	role_id = 0,
	titleID = 0,
	result = 0
	}).

-define(CMD_conditionInfo,21509).
-record(pk_conditionInfo,{
	type = 0,
	curNum = 0
	}).

-define(CMD_GS2U_SendAchievementTarget,61963).
-record(pk_GS2U_SendAchievementTarget,{
	achieveID = 0,
	condition_list = []
	}).

-define(CMD_GS2U_getAchievementTargetResult,23057).
-record(pk_GS2U_getAchievementTargetResult,{
	achieveID = 0,
	result = 0
	}).

-define(CMD_U2GS_unEquipTitle,63919).
-record(pk_U2GS_unEquipTitle,{
	type = 0,
	role_id = 0,
	titleID = 0
	}).

-define(CMD_GS2U_unEquipTitleResult,38668).
-record(pk_GS2U_unEquipTitleResult,{
	type = 0,
	role_id = 0,
	titleID = 0,
	result = 0
	}).

-define(CMD_title_record,51847).
-record(pk_title_record,{
	titleID = 0,
	op = 0,
	oldtitleID = 0,
	title_text = "",
	time = 0
	}).

-define(CMD_U2GS_TitleRecord,5135).
-record(pk_U2GS_TitleRecord,{
	}).

-define(CMD_GS2U_TitleRecordRet,11756).
-record(pk_GS2U_TitleRecordRet,{
	title_record_list = []
	}).

-define(CMD_U2GS_getPayAward,36629).
-record(pk_U2GS_getPayAward,{
	type = 0,
	index = 0
	}).

-define(CMD_GS2U_getPayAwardResult,2327).
-record(pk_GS2U_getPayAwardResult,{
	errorCode = 0,
	type = 0,
	index = 0
	}).

-define(CMD_U2GS_getPlayerLookInfo,7213).
-record(pk_U2GS_getPlayerLookInfo,{
	playerID = 0
	}).

-define(CMD_GS2U_sendPlayerLookInfo,17410).
-record(pk_GS2U_sendPlayerLookInfo,{
	playerID = 0,
	vip = 0,
	playerName = "",
	career = 0,
	fateLevel = 0,
	level = 0,
	fightPower = 0,
	guildID = 0,
	guildName = "",
	offlineTime = 0,
	headID = 0
	}).

-define(CMD_U2GS_goldChangeName,26904).
-record(pk_U2GS_goldChangeName,{
	name = "",
	type = 0
	}).

-define(CMD_GS2U_goldChangeNameResult,47393).
-record(pk_GS2U_goldChangeNameResult,{
	result = 0
	}).

-define(CMD_GS2U_MonsterDrop,48696).
-record(pk_GS2U_MonsterDrop,{
	id = 0,
	addCurrencyList = [],
	itemList = [],
	eq_list = []
	}).

-define(CMD_conditionItem,1818).
-record(pk_conditionItem,{
	conditionID = 0,
	targetNum = 0,
	param1 = 0
	}).

-define(CMD_indexCoinInfo,41350).
-record(pk_indexCoinInfo,{
	index = 0,
	type = 0,
	amount = 0,
	effect = 0
	}).

-define(CMD_indexItemInfo,10095).
-record(pk_indexItemInfo,{
	index = 0,
	itemID = 0,
	count = 0,
	bind = 0,
	effect = 0,
	is_equip = false,
	quality = 0,
	star = 0
	}).

-define(CMD_indexTypeItem,59207).
-record(pk_indexTypeItem,{
	index = 0,
	type = 0,
	itemID = 0,
	count = 0,
	bind = 0,
	effect = 0,
	quality = 0,
	star = 0,
	is_label = 0
	}).

-define(CMD_groupInfo,60797).
-record(pk_groupInfo,{
	index = 0,
	sort_id = 0,
	show = 0
	}).

-define(CMD_activityItem,45961).
-record(pk_activityItem,{
	id = 0,
	group = #pk_groupInfo{},
	vip_limit = 0,
	condition_list = [],
	coin_List = [],
	item_list = [],
	limit = [],
	score = 0,
	model = []
	}).

-define(CMD_ac_ticket,45978).
-record(pk_ac_ticket,{
	n_id = 0,
	cost = [],
	cost_item = [],
	limit_timestamp = 0,
	a_ids = [],
	name_text = "",
	over_time = 0
	}).

-define(CMD_multiType,41640).
-record(pk_multiType,{
	type = 0,
	param1 = 0,
	param2 = 0,
	multiNum = 0
	}).

-define(CMD_multiItem,5674).
-record(pk_multiItem,{
	id = 0,
	funcId = 0,
	title = "",
	des = "",
	multiType = []
	}).

-define(CMD_limitItem,60684).
-record(pk_limitItem,{
	sellID = 0,
	itemID = 0,
	itemNum = 0,
	curType = 0,
	oldPrice = 0,
	nowPrice = 0,
	limit = []
	}).

-define(CMD_limitShop,2718).
-record(pk_limitShop,{
	shopID = 0,
	type = 0,
	vipLevel = 0,
	buyItem_list = []
	}).

-define(CMD_exchangeGetEq,31350).
-record(pk_exchangeGetEq,{
	index = 0,
	itemId = 0,
	chara = 0,
	star = 0,
	bind = 0,
	count = 0
	}).

-define(CMD_exchangeGetItem,62339).
-record(pk_exchangeGetItem,{
	index = 0,
	type = 0,
	itemId = 0,
	bind = 0,
	count = 0
	}).

-define(CMD_exchangeSpent,6965).
-record(pk_exchangeSpent,{
	type = 0,
	id = 0,
	num = 0
	}).

-define(CMD_exchangeItem,31348).
-record(pk_exchangeItem,{
	changeID = 0,
	changeEq = [],
	changeItem = [],
	discount = 0,
	spentItem = [],
	limit = []
	}).

-define(CMD_timeInterval,21035).
-record(pk_timeInterval,{
	startSec = 0,
	endSec = 0
	}).

-define(CMD_entryCond,28888).
-record(pk_entryCond,{
	index = 0,
	type = 0,
	value = 0
	}).

-define(CMD_conqItem,33293).
-record(pk_conqItem,{
	index = 0,
	times = 0,
	itemID = 0,
	num = 0
	}).

-define(CMD_monsterDrop,41167).
-record(pk_monsterDrop,{
	index = 0,
	dropID = 0,
	dropTimes = 0
	}).

-define(CMD_dungeonSales,4314).
-record(pk_dungeonSales,{
	dungeonID = 0,
	maxTimes = 0,
	entry_list = [],
	dropItem = [],
	item_list = [],
	drop_list = []
	}).

-define(CMD_bossSales,27465).
-record(pk_bossSales,{
	id = 0,
	bornMapList = [],
	bossIDList = [],
	timeList = []
	}).

-define(CMD_timeReset,6857).
-record(pk_timeReset,{
	mapDataID = 0,
	bossIndex = 0,
	resetPer = 0
	}).

-define(CMD_demonTimeReset,6358).
-record(pk_demonTimeReset,{
	id = 0,
	title = "",
	describe = "",
	reset_list = []
	}).

-define(CMD_discount,51073).
-record(pk_discount,{
	type = 0,
	param1 = 0,
	param2 = 0
	}).

-define(CMD_limit,19782).
-record(pk_limit,{
	type = 0,
	param1 = 0,
	param2 = 0
	}).

-define(CMD_discount_goods,45812).
-record(pk_discount_goods,{
	shop_id = 0,
	goods_id = 0,
	sort_id = 0,
	item = #pk_ItemBaseInfo{},
	coin = #pk_CoinBaseInfo{},
	eq = [],
	cost_curr_type = 0,
	cost_curr_num = 0,
	cost_item_id = 0,
	cost_item_num = 0,
	discount = [],
	limit = [],
	recommend = 0,
	show = 0,
	condition_type = 0,
	condition_param1 = 0,
	condition_param2 = 0,
	show_type = 0,
	show_param1 = 0,
	show_param2 = 0
	}).

-define(CMD_dcs_goods,65515).
-record(pk_dcs_goods,{
	shop_id = 0,
	goods_id = 0,
	buy_count = 0
	}).

-define(CMD_dcs_buy,38688).
-record(pk_dcs_buy,{
	goods_id = 0,
	count = 0
	}).

-define(CMD_U2GS_DiscountGoodsBuyReq,1550).
-record(pk_U2GS_DiscountGoodsBuyReq,{
	ac_id = 0,
	shop_id = 0,
	buy_list = []
	}).

-define(CMD_GS2U_DiscountGoodsBuyRet,56774).
-record(pk_GS2U_DiscountGoodsBuyRet,{
	err_code = 0,
	ac_id = 0,
	shop_id = 0,
	buy_list = []
	}).

-define(CMD_IndexAwardItem,4826).
-record(pk_IndexAwardItem,{
	index = 0,
	type = 0,
	cfg_id = 0,
	bind = 0,
	num = 0,
	param = 0
	}).

-define(CMD_IndexAwardEquip,2785).
-record(pk_IndexAwardEquip,{
	index = 0,
	cfg_id = 0,
	chara = 0,
	star = 0,
	bind = 0,
	num = 0,
	param = 0
	}).

-define(CMD_U2GS_Card777DrawReq,163).
-record(pk_U2GS_Card777DrawReq,{
	ac_id = 0,
	show_index = 0
	}).

-define(CMD_GS2U_Card777DrawRet,24363).
-record(pk_GS2U_Card777DrawRet,{
	err_code = 0,
	ac_id = 0,
	show_index = 0,
	award_index = 0
	}).

-define(CMD_U2GS_Card777ResetReq,3122).
-record(pk_U2GS_Card777ResetReq,{
	ac_id = 0
	}).

-define(CMD_GS2U_Card777ResetRet,15597).
-record(pk_GS2U_Card777ResetRet,{
	err_code = 0,
	ac_id = 0
	}).

-define(CMD_U2GS_GetCard777SpecAwardReq,6248).
-record(pk_U2GS_GetCard777SpecAwardReq,{
	ac_id = 0,
	award_index = 0
	}).

-define(CMD_GS2U_GetCard777SpecAwardRet,55382).
-record(pk_GS2U_GetCard777SpecAwardRet,{
	err_code = 0,
	ac_id = 0,
	award_index = 0
	}).

-define(CMD_U2GS_GetCard777RecordReq,32653).
-record(pk_U2GS_GetCard777RecordReq,{
	ac_id = 0
	}).

-define(CMD_Card777Record,16288).
-record(pk_Card777Record,{
	type = 0,
	name = "",
	coin = [],
	item = [],
	eq = [],
	time = 0
	}).

-define(CMD_GS2U_GetCard777RecordRet,22341).
-record(pk_GS2U_GetCard777RecordRet,{
	ac_id = 0,
	record_list = []
	}).

-define(CMD_GS2U_AddCard777Record,18541).
-record(pk_GS2U_AddCard777Record,{
	ac_id = 0,
	record = #pk_Card777Record{}
	}).

-define(CMD_U2GS_FSign_SignReq,16658).
-record(pk_U2GS_FSign_SignReq,{
	ac_id = 0,
	sign_id = 0,
	day = 0
	}).

-define(CMD_GS2U_FSign_SignRet,20371).
-record(pk_GS2U_FSign_SignRet,{
	err_code = 0,
	ac_id = 0,
	sign_id = 0,
	day = 0
	}).

-define(CMD_U2GS_FSign_RepSignReq,19059).
-record(pk_U2GS_FSign_RepSignReq,{
	ac_id = 0,
	sign_id = 0,
	day = 0
	}).

-define(CMD_GS2U_FSign_RepSignRet,61208).
-record(pk_GS2U_FSign_RepSignRet,{
	err_code = 0,
	ac_id = 0,
	sign_id = 0,
	day = 0
	}).

-define(CMD_U2GS_FSign_OneKeyRepSignReq,63244).
-record(pk_U2GS_FSign_OneKeyRepSignReq,{
	ac_id = 0
	}).

-define(CMD_GS2U_FSign_OneKeyRepSignRet,46842).
-record(pk_GS2U_FSign_OneKeyRepSignRet,{
	err_code = 0,
	ac_id = 0
	}).

-define(CMD_U2GS_FSign_AwardReq,53800).
-record(pk_U2GS_FSign_AwardReq,{
	ac_id = 0,
	sign_id = 0,
	type = 0,
	day = 0
	}).

-define(CMD_GS2U_FSign_AwardRet,12464).
-record(pk_GS2U_FSign_AwardRet,{
	err_code = 0,
	ac_id = 0,
	sign_id = 0,
	type = 0,
	day = 0
	}).

-define(CMD_U2GS_MysteryShopOpenReq,44110).
-record(pk_U2GS_MysteryShopOpenReq,{
	ac_id = 0,
	shop_id = 0
	}).

-define(CMD_GS2U_MysteryShopOpenRet,47849).
-record(pk_GS2U_MysteryShopOpenRet,{
	err_code = 0,
	ac_id = 0,
	shop_id = 0
	}).

-define(CMD_U2GS_MysteryBuyReq,43546).
-record(pk_U2GS_MysteryBuyReq,{
	ac_id = 0,
	shop_id = 0,
	goods_position = 0
	}).

-define(CMD_GS2U_MysteryBuyRet,47259).
-record(pk_GS2U_MysteryBuyRet,{
	err_code = 0,
	ac_id = 0,
	shop_id = 0,
	goods_position = 0
	}).

-define(CMD_U2GS_MysteryRefreshReq,56239).
-record(pk_U2GS_MysteryRefreshReq,{
	ac_id = 0,
	shop_id = 0
	}).

-define(CMD_GS2U_MysteryRefreshRet,9836).
-record(pk_GS2U_MysteryRefreshRet,{
	err_code = 0,
	ac_id = 0,
	shop_id = 0
	}).

-define(CMD_lucky_cat_cost,49049).
-record(pk_lucky_cat_cost,{
	programme = 0,
	type = 0,
	id = 0,
	number = 0
	}).

-define(CMD_lucky_draw,27766).
-record(pk_lucky_draw,{
	name = "",
	multiple = 0,
	reward = #pk_key_value{}
	}).

-define(CMD_big_reward,41734).
-record(pk_big_reward,{
	order = 0,
	multiple = 0,
	show = 0
	}).

-define(CMD_LuckyCat,29463).
-record(pk_LuckyCat,{
	times = 0,
	condition = #pk_key_value{},
	consume = [],
	reward_type = 0,
	award_index = []
	}).

-define(CMD_U2GS_LuckyCatDrawRecordReq,51762).
-record(pk_U2GS_LuckyCatDrawRecordReq,{
	}).

-define(CMD_GS2U_LuckyCatDrawRecordRet,5149).
-record(pk_GS2U_LuckyCatDrawRecordRet,{
	all_record = []
	}).

-define(CMD_U2GS_GetLuckyCatDrawReq,35463).
-record(pk_U2GS_GetLuckyCatDrawReq,{
	ac_id = 0,
	times = 0
	}).

-define(CMD_GS2U_LuckyCatDrawRet,22714).
-record(pk_GS2U_LuckyCatDrawRet,{
	ac_id = 0,
	order = 0,
	multiple = 0,
	reward = [],
	is_record = 0,
	err_code = 0
	}).

-define(CMD_badge_equip,50404).
-record(pk_badge_equip,{
	rank_lv = 0,
	career = 0,
	equip_id = 0,
	equip_quality = 0,
	equip_star = 0,
	is_bind = 0,
	number = 0,
	sort = 0
	}).

-define(CMD_badge_item,52798).
-record(pk_badge_item,{
	rank_lv = 0,
	career = 0,
	type = 0,
	item_id = 0,
	is_bind = 0,
	number = 0,
	sort = 0
	}).

-define(CMD_advanced_consume,31236).
-record(pk_advanced_consume,{
	type = 0,
	coin_id = 0,
	coin_num = 0,
	recharge_coin = "",
	advancedtext = ""
	}).

-define(CMD_level_reward,52143).
-record(pk_level_reward,{
	level = 0,
	exp = 0,
	equip_reward = [],
	item_reward = [],
	show = 0
	}).

-define(CMD_glory_badge_info,29692).
-record(pk_glory_badge_info,{
	dailytask = [],
	weeklytask = [],
	buyexp = [],
	dailyReward = [],
	consume_list = [],
	battle_pic = [],
	battle_text = "",
	reward_list = [],
	icon_equip = [],
	icon_item = [],
	big_item_list = []
	}).

-define(CMD_shop_item,25111).
-record(pk_shop_item,{
	id = 0,
	bind = 0,
	num = 0
	}).

-define(CMD_exchange_goods,15220).
-record(pk_exchange_goods,{
	shop_id = 0,
	goods_id = 0,
	sort = 0,
	item = #pk_shop_item{},
	coin = #pk_key_value{},
	equip = [],
	price = #pk_key_value{},
	limit = #pk_key_value{},
	buy_times = 0,
	show = 0,
	push = 0,
	buy_condition = #pk_key_value{}
	}).

-define(CMD_glory_badge_player,42568).
-record(pk_glory_badge_player,{
	battle_lv = 0,
	curr_exp = 0,
	reward_lv = 0,
	rank_lv = 0,
	shop = [],
	daily_reward = 0,
	is_advance = 0
	}).

-define(CMD_U2GS_UpGloryBadgeReq,41399).
-record(pk_U2GS_UpGloryBadgeReq,{
	ac_id = 0,
	type = 0
	}).

-define(CMD_GS2U_UpGloryBadgeRet,53875).
-record(pk_GS2U_UpGloryBadgeRet,{
	ac_id = 0,
	type = 0,
	err_code = 0
	}).

-define(CMD_U2GS_BuyGloryBadgeLvReq,31283).
-record(pk_U2GS_BuyGloryBadgeLvReq,{
	ac_id = 0,
	level_num = 0
	}).

-define(CMD_GS2U_BuyGloryBadgeLvRet,35022).
-record(pk_GS2U_BuyGloryBadgeLvRet,{
	ac_id = 0,
	new_Level = 0,
	new_exp = 0,
	err_code = 0
	}).

-define(CMD_U2GS_GloryBadgeLevelReq,44859).
-record(pk_U2GS_GloryBadgeLevelReq,{
	ac_id = 0,
	level = 0
	}).

-define(CMD_GS2U_GloryBadgeLevelReq,37048).
-record(pk_GS2U_GloryBadgeLevelReq,{
	ac_id = 0,
	err_code = 0
	}).

-define(CMD_U2GS_GloryBadgeDailyReq,34195).
-record(pk_U2GS_GloryBadgeDailyReq,{
	ac_id = 0
	}).

-define(CMD_GS2U_GloryBadgeDailyReq,26384).
-record(pk_GS2U_GloryBadgeDailyReq,{
	ac_id = 0,
	err_code = 0
	}).

-define(CMD_U2GS_BuyGloryBadgeGoodsReq,31253).
-record(pk_U2GS_BuyGloryBadgeGoodsReq,{
	ac_id = 0,
	shop_id = 0,
	goods_id = 0,
	buy_times = 0
	}).

-define(CMD_GS2U_BuyGloryBadgeGoodsReq,38626).
-record(pk_GS2U_BuyGloryBadgeGoodsReq,{
	ac_id = 0,
	shop_id = 0,
	goods_id = 0,
	buy_times = 0,
	err_code = 0
	}).

-define(CMD_pay_condition,57040).
-record(pk_pay_condition,{
	reset_order = 0,
	type = 0,
	param = 0
	}).

-define(CMD_holiday_pay_cfg,58127).
-record(pk_holiday_pay_cfg,{
	order = 0,
	reset_condition = [],
	awardsType = 0
	}).

-define(CMD_holiday_pay,42384).
-record(pk_holiday_pay,{
	order = 0,
	num = 0,
	state = 0,
	recharge_num = 0,
	consume_num = 0,
	reset_times = 0,
	is_today = false
	}).

-define(CMD_U2GS_FWage_DrawReq,65022).
-record(pk_U2GS_FWage_DrawReq,{
	ac_id = 0,
	order = 0
	}).

-define(CMD_GS2U_FWage_DrawRet,3198).
-record(pk_GS2U_FWage_DrawRet,{
	err_code = 0,
	ac_id = 0,
	order = 0,
	pay_value = 0
	}).

-define(CMD_U2GS_FWage_ResetReq,27046).
-record(pk_U2GS_FWage_ResetReq,{
	ac_id = 0,
	order = 0
	}).

-define(CMD_GS2U_FWage_ResetRet,51246).
-record(pk_GS2U_FWage_ResetRet,{
	err_code = 0,
	ac_id = 0,
	order = 0
	}).

-define(CMD_openServerGiftPacks,41649).
-record(pk_openServerGiftPacks,{
	goods_id = 0,
	adver = "",
	name = "",
	discribe = "",
	pack_image = "",
	item_list = [],
	model = [],
	discount = 0,
	limit = #pk_key_2value{},
	curr_type = #pk_key_value{},
	condition_type = #pk_key_value{},
	show_type = #pk_key_value{}
	}).

-define(CMD_U2GS_open_server_buy,61867).
-record(pk_U2GS_open_server_buy,{
	ac_id = 0,
	goods_id = 0
	}).

-define(CMD_GS2U_open_server_buy_ret,15847).
-record(pk_GS2U_open_server_buy_ret,{
	err_code = 0,
	ac_id = 0,
	goods_id = 0
	}).

-define(CMD_activeBaseInfo,4923).
-record(pk_activeBaseInfo,{
	id = 0,
	group_id = 0,
	group_index = 0,
	group_name = "",
	name = "",
	title = "",
	describe = "",
	describe_big = "",
	pic = "",
	iconPic = "",
	pic_list = [],
	push_title = 0,
	teamType = 0,
	teamName = "",
	type = 0,
	detailedType = 0,
	startTime = 0,
	endTime = 0,
	banner_upleft = "",
	banner_lowleft = "",
	banner_upright = "",
	banner_lowright = "",
	interval_list = [],
	joinCustom = [],
	activityList = [],
	ticket_list = [],
	multiItemList = [],
	shop_list = [],
	exchange_list = [],
	dungeon_list = [],
	bossList = [],
	timeResetList = [],
	dcs_shop = [],
	pay_list = [],
	glory_badge = #pk_glory_badge_info{}
	}).

-define(CMD_LS2GS_ActivityBaseInfo,1317).
-record(pk_LS2GS_ActivityBaseInfo,{
	id = 0,
	name = "",
	title = "",
	describe = "",
	pic = "",
	type = 0,
	show_start = 0,
	show_end = 0,
	startTime = 0,
	endTime = 0,
	joinCustom = [],
	activityList = [],
	multiItemList = [],
	shop_list = []
	}).

-define(CMD_GS2U_sendActivityBaseList,15788).
-record(pk_GS2U_sendActivityBaseList,{
	teamType = 0,
	activity_list = []
	}).

-define(CMD_U2GS_requestActivityBaseinfo,30228).
-record(pk_U2GS_requestActivityBaseinfo,{
	teamType = 0
	}).

-define(CMD_commitCondition,18428).
-record(pk_commitCondition,{
	conditionID = 0,
	curNum = 0,
	param = 0
	}).

-define(CMD_reachedInfo,37178).
-record(pk_reachedInfo,{
	id = 0,
	getRewardTimes = 0
	}).

-define(CMD_multiFunc,6176).
-record(pk_multiFunc,{
	funcID = 0,
	getTimes = 0
	}).

-define(CMD_playerMultiInfo,44551).
-record(pk_playerMultiInfo,{
	id = 0,
	func_list = []
	}).

-define(CMD_playerlimitItem,56582).
-record(pk_playerlimitItem,{
	sellID = 0,
	buyTimes = 0,
	serverTimes = 0
	}).

-define(CMD_playerLimitShop,21904).
-record(pk_playerLimitShop,{
	shopID = 0,
	buy_list = []
	}).

-define(CMD_playerExchangeInfo,36307).
-record(pk_playerExchangeInfo,{
	changeID = 0,
	changeTimes = 0,
	serverTimes = 0
	}).

-define(CMD_playerRecharAct,4283).
-record(pk_playerRecharAct,{
	id = 0,
	isAward = 0
	}).

-define(CMD_playerFunds,15861).
-record(pk_playerFunds,{
	index = 0,
	buy_funds = 0,
	award_num = 0,
	get_award = 0
	}).

-define(CMD_PlayerWeeklyReward,29283).
-record(pk_PlayerWeeklyReward,{
	curDay = 0,
	day_list = []
	}).

-define(CMD_player_ac_ticket,44288).
-record(pk_player_ac_ticket,{
	id = 0,
	n_id = 0,
	is_buy = false
	}).

-define(CMD_PlayerFireworks,39027).
-record(pk_PlayerFireworks,{
	total_times = 0,
	cond_award_list = []
	}).

-define(CMD_IndexMap,58854).
-record(pk_IndexMap,{
	id1 = 0,
	id2 = 0
	}).

-define(CMD_Player777,26710).
-record(pk_Player777,{
	total_times = 0,
	free_reset_times = 0,
	select_list = [],
	award_spec_list = []
	}).

-define(CMD_f_sign_key,60527).
-record(pk_f_sign_key,{
	id = 0,
	day = 0
	}).

-define(CMD_f_sign_cost,600).
-record(pk_f_sign_cost,{
	day = 0,
	coin = []
	}).

-define(CMD_player_f_sign,62504).
-record(pk_player_f_sign,{
	recharge_list = [],
	cost_list = [],
	reach_normal = [],
	award_normal = [],
	reach_total = [],
	award_total = [],
	reach_final = [],
	award_final = []
	}).

-define(CMD_mystery_item,29086).
-record(pk_mystery_item,{
	type = 0,
	id = 0,
	chara = 0,
	star = 0,
	bind = 0,
	num = 0,
	vfx = 0
	}).

-define(CMD_mystery_discount,37651).
-record(pk_mystery_discount,{
	is_active_discount = 0,
	d1 = 0,
	d2 = 0
	}).

-define(CMD_mystery_goods,61854).
-record(pk_mystery_goods,{
	pool_id = 0,
	goods_id = 0,
	quality = 0,
	limit_type = 0,
	limit_p1 = 0,
	limit_p2 = 0,
	cost_list = [],
	items = [],
	discount = #pk_mystery_discount{},
	is_min_price = 0
	}).

-define(CMD_mystery_cost,59240).
-record(pk_mystery_cost,{
	programme = 0,
	type = 0,
	id = 0,
	number = 0
	}).

-define(CMD_mystery_shop,36655).
-record(pk_mystery_shop,{
	shop_id = 0,
	auto_refresh_interval = 0,
	free_refresh_max = 0,
	refresh_warn = 0,
	refresh_cost = [],
	quality_goods = []
	}).

-define(CMD_mystery_buy_info,22314).
-record(pk_mystery_buy_info,{
	pool_id = 0,
	goods_id = 0,
	times = 0
	}).

-define(CMD_player_mystery,34493).
-record(pk_player_mystery,{
	shop_id = 0,
	auto_refresh_time = 0,
	free_refresh_times = 0,
	cost_refresh_times = 0,
	cur_turns = 0,
	goods_list = [],
	buy_list1 = [],
	buy_list2 = []
	}).

-define(CMD_player_treasure,53224).
-record(pk_player_treasure,{
	select_ids = [],
	draw_ids = [],
	times_rewards = []
	}).

-define(CMD_limit_direct_buy,22968).
-record(pk_limit_direct_buy,{
	goods_id = 0,
	name = "",
	character = 0,
	item_list = [],
	curr_type = #pk_key_value{},
	direct_purchase = "",
	limit = #pk_key_2value{},
	condition_type = #pk_key_value{}
	}).

-define(CMD_limit_direct_player,58788).
-record(pk_limit_direct_player,{
	goods_id = 0,
	daily_times = 0,
	total_times = 0
	}).

-define(CMD_U2GS_limit_direct_buy,46068).
-record(pk_U2GS_limit_direct_buy,{
	ac_id = 0,
	goods_id = 0
	}).

-define(CMD_GS2U_limit_direct_buy_ret,20323).
-record(pk_GS2U_limit_direct_buy_ret,{
	error_code = 0,
	ac_id = 0,
	goods_id = 0
	}).

-define(CMD_activePlayerInfo,18804).
-record(pk_activePlayerInfo,{
	id = 0,
	recharge = 0,
	consume = 0,
	commit_list = [],
	ticket_list = [],
	reached_list = [],
	multi_list = [],
	shop_list = [],
	change_list = [],
	recharge_list = [],
	lotteryNum = 0,
	funds_list = [],
	playerWeeklyReward = #pk_PlayerWeeklyReward{},
	dcs_shop = [],
	player777 = #pk_Player777{},
	player_sign = #pk_player_f_sign{},
	player_mystery = [],
	first_reset = 0,
	playerFireworks = #pk_PlayerFireworks{},
	holiday_pay_list = [],
	lucky_cat_times = #pk_key_value{},
	player_glory_badge = #pk_glory_badge_player{},
	change_package = [],
	player_treasure = #pk_player_treasure{},
	player_open_gift = [],
	player_wheel_luck_one = 0,
	player_wheel_luck_two = #pk_key_value{},
	limit_direct_buy = []
	}).

-define(CMD_U2GS_AcTicketBuy,24347).
-record(pk_U2GS_AcTicketBuy,{
	id = 0,
	n_id = 0
	}).

-define(CMD_GS2U_AcTicketBuyRet,42225).
-record(pk_GS2U_AcTicketBuyRet,{
	err_code = 0,
	id = 0,
	n_id = 0
	}).

-define(CMD_GS2U_sendActivityPlayerList,53212).
-record(pk_GS2U_sendActivityPlayerList,{
	activityInfo_list = []
	}).

-define(CMD_U2GS_getActivityPlayerInfo,60556).
-record(pk_U2GS_getActivityPlayerInfo,{
	}).

-define(CMD_U2GS_getConditionReward,11017).
-record(pk_U2GS_getConditionReward,{
	id = 0,
	funcID = 0,
	index = 0
	}).

-define(CMD_GS2U_getConditionRewardResult,46404).
-record(pk_GS2U_getConditionRewardResult,{
	id = 0,
	funcID = 0,
	index = 0,
	result = 0
	}).

-define(CMD_U2GS_GetAllConditionReward,47855).
-record(pk_U2GS_GetAllConditionReward,{
	ac_id = 0,
	type = 0
	}).

-define(CMD_GS2U_GetAllConditionRewardRet,34352).
-record(pk_GS2U_GetAllConditionRewardRet,{
	err_code = 0,
	ac_id = 0,
	score = 0
	}).

-define(CMD_U2GS_buyActivityItem,58833).
-record(pk_U2GS_buyActivityItem,{
	id = 0,
	shopID = 0,
	sellID = 0,
	buyTimes = 0
	}).

-define(CMD_GS2U_buyActivityItemResult,43927).
-record(pk_GS2U_buyActivityItemResult,{
	id = 0,
	shopID = 0,
	sellID = 0,
	buyTimes = 0,
	result = 0
	}).

-define(CMD_GS2U_WorshipPlayerResult,52203).
-record(pk_GS2U_WorshipPlayerResult,{
	targetID = 0,
	result = 0,
	coin_List = [],
	item_list = []
	}).

-define(CMD_U2GS_VoiceChatCache,51432).
-record(pk_U2GS_VoiceChatCache,{
	voiceCacheID = 0,
	voiceContent = <<>>
	}).

-define(CMD_U2GS_HeroAdjustLevel,17150).
-record(pk_U2GS_HeroAdjustLevel,{
	heroID = 0
	}).

-define(CMD_U2GS_getPlayerActivityData,44069).
-record(pk_U2GS_getPlayerActivityData,{
	id = 0
	}).

-define(CMD_GS2U_updatePlayerActivityData,22847).
-record(pk_GS2U_updatePlayerActivityData,{
	id = 0,
	recharge = 0,
	consume = 0,
	commit_list = [],
	ticket_list = [],
	reached_list = [],
	multi_list = [],
	shop_list = [],
	change_list = [],
	playerWeeklyReward = #pk_PlayerWeeklyReward{},
	dcs_shop = [],
	player777 = #pk_Player777{},
	player_sign = #pk_player_f_sign{},
	player_mystery = [],
	playerFireworks = #pk_PlayerFireworks{},
	first_reset = 0,
	holiday_pay_list = [],
	lucky_cat_times = #pk_key_value{},
	player_glory_badge = #pk_glory_badge_player{},
	change_package = [],
	player_treasure = #pk_player_treasure{},
	player_open_gift = [],
	player_wheel_luck_one = 0,
	player_wheel_luck_two = #pk_key_value{},
	limit_direct_buy = []
	}).

-define(CMD_U2GS_EnterWildBOSS,27251).
-record(pk_U2GS_EnterWildBOSS,{
	mapDataID = 0,
	lineNum = 0
	}).

-define(CMD_U2GS_GetDungeonLineInfo,51103).
-record(pk_U2GS_GetDungeonLineInfo,{
	mapDataID = 0
	}).

-define(CMD_U2GS_EquipInheritPreview,3884).
-record(pk_U2GS_EquipInheritPreview,{
	restoreEquipmentID = 0,
	equipmentID = 0
	}).

-define(CMD_GS2U_EquipInheritPreview,187).
-record(pk_GS2U_EquipInheritPreview,{
	restoreEquipmentID = 0,
	equipmentID = 0,
	errorCode = 0,
	decGold = 0,
	newLevel = 0,
	newNumb = 0,
	newQuality = 0,
	addMoney = 0,
	addEquipExp = 0,
	addItemList = []
	}).

-define(CMD_U2GS_EquipInherit,51196).
-record(pk_U2GS_EquipInherit,{
	restoreEquipmentID = 0,
	equipmentID = 0
	}).

-define(CMD_GS2U_EquipInherit,47235).
-record(pk_GS2U_EquipInherit,{
	restoreEquipmentID = 0,
	equipmentID = 0,
	errorCode = 0,
	addMoney = 0,
	addEquipExp = 0,
	addItemList = []
	}).

-define(CMD_U2GS_PlayerReborn,43263).
-record(pk_U2GS_PlayerReborn,{
	reviveID = 0
	}).

-define(CMD_GS2U_PlayerRebornResult,38149).
-record(pk_GS2U_PlayerRebornResult,{
	result = 0,
	playerID = 0,
	x = 0,
	y = 0,
	reviveID = 0
	}).

-define(CMD_U2GS_bindAccount,41772).
-record(pk_U2GS_bindAccount,{
	token = "",
	tell = "",
	content = "",
	verifyid = ""
	}).

-define(CMD_GS2U_BindAccountResult,17498).
-record(pk_GS2U_BindAccountResult,{
	result = 0,
	coinList = [],
	itemList = []
	}).

-define(CMD_GS2U_getNewtitle,30799).
-record(pk_GS2U_getNewtitle,{
	titleID = 0
	}).

-define(CMD_U2GS_FlyMoveTo,3402).
-record(pk_U2GS_FlyMoveTo,{
	id = 0,
	posX = 0,
	posY = 0
	}).

-define(CMD_GS2U_FlyMoveTo,8004).
-record(pk_GS2U_FlyMoveTo,{
	id = 0,
	posX = 0,
	posY = 0
	}).

-define(CMD_U2GS_getNextDayAward,32431).
-record(pk_U2GS_getNextDayAward,{
	id = 0
	}).

-define(CMD_GS2U_getNextDayAwardResult,26594).
-record(pk_GS2U_getNextDayAwardResult,{
	id = 0,
	errorCode = 0
	}).

-define(CMD_U2GS_getCurNextDayAwardPro,51069).
-record(pk_U2GS_getCurNextDayAwardPro,{
	}).

-define(CMD_GS2U_sendCurNexDayAwardPro,4829).
-record(pk_GS2U_sendCurNexDayAwardPro,{
	id = 0,
	countDownTime = 0,
	isGet = 0
	}).

-define(CMD_GS2U_kick_out_player,44236).
-record(pk_GS2U_kick_out_player,{
	mapAi = 0
	}).

-define(CMD_U2GS_ReqDungeonInfo,16260).
-record(pk_U2GS_ReqDungeonInfo,{
	dungeonID = 0
	}).

-define(CMD_GS2U_DungeonInfo,16747).
-record(pk_GS2U_DungeonInfo,{
	dungeonID = 0,
	fightCount = 0,
	bestTime = 0,
	resetCount = 0,
	groupFightID = 0,
	selfFightCount = 0,
	resetSelfFightCount = 0,
	buyFightCount = 0,
	buyFightCountDay = 0,
	starsIndexList = []
	}).

-define(CMD_PlayerRankInfo,10460).
-record(pk_PlayerRankInfo,{
	rank = 0,
	playerID = 0,
	name = "",
	recordTime = 0,
	career = 0,
	fateLevel = 0,
	headID = 0
	}).

-define(CMD_DungeonConqInfo,24323).
-record(pk_DungeonConqInfo,{
	dungeonID = 0,
	conqCount = 0,
	conqAwardList = []
	}).

-define(CMD_U2GS_GetDungeonConqInfo,58891).
-record(pk_U2GS_GetDungeonConqInfo,{
	dungeonIDList = []
	}).

-define(CMD_GS2U_DungeonConqInfo,1798).
-record(pk_GS2U_DungeonConqInfo,{
	info_list = []
	}).

-define(CMD_U2GS_GainConqAward,39090).
-record(pk_U2GS_GainConqAward,{
	dungeonID = 0,
	conqIndex = 0
	}).

-define(CMD_DungeonInfo,36293).
-record(pk_DungeonInfo,{
	dungeonID = 0,
	fightCount = 0,
	bestTime = 0,
	resetCount = 0,
	groupFightID = 0,
	selfFightCount = 0,
	resetSelfFightCount = 0,
	buyFightCount = 0,
	buyFightCountDay = 0,
	starsIndexList = [],
	freeCount = 0
	}).

-define(CMD_U2GS_ResetGroupFightCount,15513).
-record(pk_U2GS_ResetGroupFightCount,{
	dungeonID = 0
	}).

-define(CMD_GS2U_ResetGroupFightCountResult,62734).
-record(pk_GS2U_ResetGroupFightCountResult,{
	result = 0
	}).

-define(CMD_U2GS_BuyDungeonCount,33715).
-record(pk_U2GS_BuyDungeonCount,{
	dungeonID = 0,
	count = 0
	}).

-define(CMD_GS2U_BuyDungeonCountResult,9276).
-record(pk_GS2U_BuyDungeonCountResult,{
	result = 0,
	curFightCount = 0,
	maxFightCount = 0
	}).

-define(CMD_U2GS_GetMainCopyMapInfo,24590).
-record(pk_U2GS_GetMainCopyMapInfo,{
	}).

-define(CMD_ChapterInfo,18404).
-record(pk_ChapterInfo,{
	chapterID = 0,
	starNum = 0,
	boxIndexList = [],
	dungeonInfoList = [],
	dungeonConqList = []
	}).

-define(CMD_GS2U_MainDungeonInfo,36265).
-record(pk_GS2U_MainDungeonInfo,{
	dungeonID = 0,
	fightCount = 0,
	bestTime = 0
	}).

-define(CMD_GS2U_GetMainCopyMapInfo,18788).
-record(pk_GS2U_GetMainCopyMapInfo,{
	chapterInfoList = []
	}).

-define(CMD_U2GS_GetSpecMainCopyMapInfo,58044).
-record(pk_U2GS_GetSpecMainCopyMapInfo,{
	chapterIDList = []
	}).

-define(CMD_U2GS_EnterCopyMap,25343).
-record(pk_U2GS_EnterCopyMap,{
	dungeonID = 0,
	reasonContent = ""
	}).

-define(CMD_U2GS_OpenChapterBox,47165).
-record(pk_U2GS_OpenChapterBox,{
	chapterID = 0,
	index = 0
	}).

-define(CMD_U2GS_MopUpCopyMap,6038).
-record(pk_U2GS_MopUpCopyMap,{
	dungeonID = 0
	}).

-define(CMD_killerInfo,61917).
-record(pk_killerInfo,{
	killerID = 0,
	killerName = "",
	fateLevel = 0,
	bossID = 0,
	time = 0,
	itemID = 0,
	itemDBID = 0,
	character = 0,
	is_top = 0,
	serverName = ""
	}).

-define(CMD_U2GS_EnterArtiCopyMap,7104).
-record(pk_U2GS_EnterArtiCopyMap,{
	dungeonID = 0
	}).

-define(CMD_U2GS_GetTeamCopyMapFriends,46162).
-record(pk_U2GS_GetTeamCopyMapFriends,{
	}).

-define(CMD_U2GS_GetDNTGRankInfo,48828).
-record(pk_U2GS_GetDNTGRankInfo,{
	}).

-define(CMD_GS2U_GetDNTGRankInfoResult,38112).
-record(pk_GS2U_GetDNTGRankInfoResult,{
	maxStars = 0,
	rankList = []
	}).

-define(CMD_U2GS_GetArenaPlayerInfo,50741).
-record(pk_U2GS_GetArenaPlayerInfo,{
	}).

-define(CMD_U2GS_GetArenaRankInfo,19466).
-record(pk_U2GS_GetArenaRankInfo,{
	}).

-define(CMD_U2GS_EnterArena,46289).
-record(pk_U2GS_EnterArena,{
	rankNumber = 0
	}).

-define(CMD_U2GS_FightArenaBoss,35113).
-record(pk_U2GS_FightArenaBoss,{
	}).

-define(CMD_GS2U_MonsterTotalWave,59137).
-record(pk_GS2U_MonsterTotalWave,{
	wave = 0
	}).

-define(CMD_GS2U_MonsterDeadWave,17199).
-record(pk_GS2U_MonsterDeadWave,{
	wave = 0
	}).

-define(CMD_GS2U_DeathGoblinNum,61864).
-record(pk_GS2U_DeathGoblinNum,{
	num = 0
	}).

-define(CMD_ShiftSkillPos,28891).
-record(pk_ShiftSkillPos,{
	x = 0,
	y = 0
	}).

-define(CMD_C2S_PlayerUseShiftSkill,51567).
-record(pk_C2S_PlayerUseShiftSkill,{
	code = 0,
	skillId = 0,
	serial = 0,
	targetCodeList = [],
	posList = [],
	angleX = 0,
	angleY = 0
	}).

-define(CMD_C2GS_PlayerUseShiftSkillExt,34567).
-record(pk_C2GS_PlayerUseShiftSkillExt,{
	code = 0,
	skillId = 0,
	serial = 0,
	targetCodeList = [],
	x = 0,
	y = 0,
	angleX = 0,
	angleY = 0
	}).

-define(CMD_GS2C_PlayerUseShiftSkillExt,182).
-record(pk_GS2C_PlayerUseShiftSkillExt,{
	code = 0,
	skillId = 0,
	serial = 0,
	targetCodeList = [],
	x = 0,
	y = 0,
	angleX = 0,
	angleY = 0
	}).

-define(CMD_GS2U_Dead,61421).
-record(pk_GS2U_Dead,{
	deadActorCode = 0,
	deadRoleID = 0,
	killerCode = 0,
	killerRoleID = 0,
	killerName = "",
	skillID = 0,
	recover = 0
	}).

-define(CMD_GS2U_BreakSkill,5305).
-record(pk_GS2U_BreakSkill,{
	userCode = 0,
	skillId = 0,
	serial = 0,
	error = 0
	}).

-define(CMD_U2GS_ChangeBattleHeroTeam,56223).
-record(pk_U2GS_ChangeBattleHeroTeam,{
	id = 0
	}).

-define(CMD_GS2U_ChangeBattleHeroTeam,4546).
-record(pk_GS2U_ChangeBattleHeroTeam,{
	id = 0,
	errorCode = 0,
	teamID = 0
	}).

-define(CMD_ObjectHPSt,9723).
-record(pk_ObjectHPSt,{
	code = 0,
	role_id = 0,
	value = 0
	}).

-define(CMD_GS2U_ObjectHP,41317).
-record(pk_GS2U_ObjectHP,{
	info_list = []
	}).

-define(CMD_GS2U_SINGLE_ObjectHP,60282).
-record(pk_GS2U_SINGLE_ObjectHP,{
	code = 0,
	role_id = 0,
	value = 0
	}).

-define(CMD_GS2U_ObjectShield,44472).
-record(pk_GS2U_ObjectShield,{
	code = 0,
	value = 0
	}).

-define(CMD_GS2U_ObjectArmor,58425).
-record(pk_GS2U_ObjectArmor,{
	code = 0,
	value = 0
	}).

-define(CMD_GS2U_ObjectMP,43592).
-record(pk_GS2U_ObjectMP,{
	code = 0,
	value = 0
	}).

-define(CMD_GS2U_ObjectSuperArmor,16941).
-record(pk_GS2U_ObjectSuperArmor,{
	code = 0,
	value = 0,
	stat = 0
	}).

-define(CMD_GS2U_CopyMapLeftTime,24926).
-record(pk_GS2U_CopyMapLeftTime,{
	leftTime = 0
	}).

-define(CMD_U2GS_AnswerFightRingInvite,33570).
-record(pk_U2GS_AnswerFightRingInvite,{
	isAgree = 0,
	playerID = 0
	}).

-define(CMD_CopyMapProgressInfo,63228).
-record(pk_CopyMapProgressInfo,{
	dungeonType = 0,
	dungeonID = 0,
	winDungeonID = 0
	}).

-define(CMD_GS2U_CopyMapProgress,19403).
-record(pk_GS2U_CopyMapProgress,{
	infoList = []
	}).

-define(CMD_ActiveExtendFightCount,30824).
-record(pk_ActiveExtendFightCount,{
	type = 0,
	maxFightCount = 0,
	fightCount = 0,
	buyFightCountDay = 0
	}).

-define(CMD_GS2U_CopyMapFightCount,64555).
-record(pk_GS2U_CopyMapFightCount,{
	artiFightCountList = [],
	enterCount = 0,
	assistantCount = 0,
	activeCount = 0,
	coupleCount = 0,
	activeExtendFightCountList = []
	}).

-define(CMD_U2GS_GetArtiDungeonInfo,10884).
-record(pk_U2GS_GetArtiDungeonInfo,{
	}).

-define(CMD_GS2U_GetArtiDungeonInfoResult,61939).
-record(pk_GS2U_GetArtiDungeonInfoResult,{
	enterCountList = [],
	dungeonInfoList = [],
	killerInfoList = [],
	quick_award_times = 0
	}).

-define(CMD_ChapterRedPoint,26469).
-record(pk_ChapterRedPoint,{
	chapterID = 0,
	isRed = 0,
	isConqRed = 0,
	conqNum = 0
	}).

-define(CMD_GS2U_MainCopyMapTip,23371).
-record(pk_GS2U_MainCopyMapTip,{
	info_list = []
	}).

-define(CMD_GS2U_ChapterAndConqBox,56080).
-record(pk_GS2U_ChapterAndConqBox,{
	isChapterBox = 0,
	isConqBox = 0
	}).

-define(CMD_U2GS_ArenaRefreshTarget,3814).
-record(pk_U2GS_ArenaRefreshTarget,{
	}).

-define(CMD_U2GS_GetChapterConqInfo,28992).
-record(pk_U2GS_GetChapterConqInfo,{
	chapterID = 0
	}).

-define(CMD_GS2U_GetChapterConqInfoResult,62166).
-record(pk_GS2U_GetChapterConqInfoResult,{
	info_list = []
	}).

-define(CMD_U2GS_GetChapterRankInfo,10145).
-record(pk_U2GS_GetChapterRankInfo,{
	chapterID = 0
	}).

-define(CMD_ChapterRankInfo,54176).
-record(pk_ChapterRankInfo,{
	dungeonID = 0,
	playerRankInfoList = []
	}).

-define(CMD_GS2U_GetChapterRankInfoResult,54603).
-record(pk_GS2U_GetChapterRankInfoResult,{
	info_list = []
	}).

-define(CMD_U2GS_BuyMainMopUpValue,64726).
-record(pk_U2GS_BuyMainMopUpValue,{
	count = 0
	}).

-define(CMD_U2GS_ResetMainFightCount,37924).
-record(pk_U2GS_ResetMainFightCount,{
	dungeonID = 0
	}).

-define(CMD_GS2U_ResetMainFightCountResult,45562).
-record(pk_GS2U_ResetMainFightCountResult,{
	errorCode = 0
	}).

-define(CMD_U2GS_MopUpArena,18163).
-record(pk_U2GS_MopUpArena,{
	rankNumber = 0
	}).

-define(CMD_GS2U_CopyMapStarCondition,13828).
-record(pk_GS2U_CopyMapStarCondition,{
	conditionIndex = 0,
	newValue = 0
	}).

-define(CMD_GS2U_BuyMainMopUpValueResult,1190).
-record(pk_GS2U_BuyMainMopUpValueResult,{
	result = 0
	}).

-define(CMD_U2GS_TeamCopyMapMirror,35868).
-record(pk_U2GS_TeamCopyMapMirror,{
	teamDungeonID = 0
	}).

-define(CMD_U2GS_BuyFightValue,25877).
-record(pk_U2GS_BuyFightValue,{
	count = 0
	}).

-define(CMD_GS2U_BuyFightValueResult,30660).
-record(pk_GS2U_BuyFightValueResult,{
	result = 0
	}).

-define(CMD_InvitePlayerInfo,6219).
-record(pk_InvitePlayerInfo,{
	playerID = 0,
	vip = 0,
	playerName = "",
	career = 0,
	fateLevel = 0,
	headID = 0,
	level = 0,
	fightPower = 0,
	guildID = 0,
	guildName = "",
	guildRank = 0,
	state = 0
	}).

-define(CMD_GS2U_MainCopyMapForGuide,17120).
-record(pk_GS2U_MainCopyMapForGuide,{
	dungeonID = 0,
	conqState = 0
	}).

-define(CMD_U2GS_GetExcellenceDungeonInfo,15480).
-record(pk_U2GS_GetExcellenceDungeonInfo,{
	}).

-define(CMD_GS2U_GetExcellenceDungeonInfoResult,7714).
-record(pk_GS2U_GetExcellenceDungeonInfoResult,{
	dungeonInfoList = [],
	dungeonConqList = []
	}).

-define(CMD_U2GS_EnterExceCopyMap,8143).
-record(pk_U2GS_EnterExceCopyMap,{
	dungeonID = 0
	}).

-define(CMD_GS2U_ExceRedPoint,53112).
-record(pk_GS2U_ExceRedPoint,{
	isRed = 0
	}).

-define(CMD_AdditionStar,4085).
-record(pk_AdditionStar,{
	addType = 0,
	addValue = 0
	}).

-define(CMD_CheckData,2613).
-record(pk_CheckData,{
	checkType = 0,
	checkValue = 0
	}).

-define(CMD_CheckData2,62996).
-record(pk_CheckData2,{
	role_id = 0,
	maxDamage = 0,
	battlePropList = []
	}).

-define(CMD_U2GS_RequestSettleAccounts,64141).
-record(pk_U2GS_RequestSettleAccounts,{
	settleType = 0,
	info_list = [],
	bagOrRewards = 0,
	isRewardCenter = 0,
	check_list = [],
	dungeon_id = 0,
	id = 0
	}).

-define(CMD_U2GS_RequestSettleAccounts2,2840).
-record(pk_U2GS_RequestSettleAccounts2,{
	check_list = []
	}).

-define(CMD_GS2U_FightRingEnterFightMatching,12975).
-record(pk_GS2U_FightRingEnterFightMatching,{
	}).

-define(CMD_ObjectRage,43477).
-record(pk_ObjectRage,{
	code = 0,
	role_id = 0,
	value = 0
	}).

-define(CMD_GS2U_ObjectRage,1282).
-record(pk_GS2U_ObjectRage,{
	info_list = []
	}).

-define(CMD_GS2U_Single_ObjectRage,32439).
-record(pk_GS2U_Single_ObjectRage,{
	code = 0,
	role_id = 0,
	value = 0
	}).

-define(CMD_role_skill_hit,40635).
-record(pk_role_skill_hit,{
	object_id = 0,
	role_id = 0
	}).

-define(CMD_C2S_PlayerSkillBuff,46958).
-record(pk_C2S_PlayerSkillBuff,{
	fromCode = 0,
	from_role_id = 0,
	skillId = 0,
	buffId = 0,
	forceFlag = 0,
	targetCodeList = []
	}).

-define(CMD_GS2U_PlayerSkillBuffRet,9080).
-record(pk_GS2U_PlayerSkillBuffRet,{
	buffId = 0,
	err_code = 0
	}).

-define(CMD_GS2U_MirrorTotalWave,11934).
-record(pk_GS2U_MirrorTotalWave,{
	wave = 0
	}).

-define(CMD_GS2U_MirrorDeadWave,18471).
-record(pk_GS2U_MirrorDeadWave,{
	wave = 0
	}).

-define(CMD_ManorRift,46976).
-record(pk_ManorRift,{
	riftDataID = 0,
	posX = 0,
	posY = 0,
	state = 0
	}).

-define(CMD_GS2U_ManorRiftList,40014).
-record(pk_GS2U_ManorRiftList,{
	riftList = []
	}).

-define(CMD_GS2U_AddBuff,63063).
-record(pk_GS2U_AddBuff,{
	id = 0,
	actor_id = 0,
	actor_role_id = 0,
	caster_id = 0,
	caster_role_id = 0,
	buff_data_id = 0,
	allValidTime = 0,
	remainTriggerCount = 0,
	layoutNum = 0,
	is_pause = 0
	}).

-define(CMD_GS2U_UpdateBuff,1480).
-record(pk_GS2U_UpdateBuff,{
	id = 0,
	actor_id = 0,
	actor_role_id = 0,
	caster_id = 0,
	caster_role_id = 0,
	buff_data_id = 0,
	allValidTime = 0,
	remainTriggerCount = 0,
	layoutNum = 0,
	is_pause = 0
	}).

-define(CMD_ObjectBuff,7322).
-record(pk_ObjectBuff,{
	id = 0,
	caster_id = 0,
	caster_role_id = 0,
	buff_data_id = 0,
	allValidTime = 0,
	remainTriggerCount = 0,
	layoutNum = 0,
	is_pause = 0
	}).

-define(CMD_ObjectBuffInfo,9104).
-record(pk_ObjectBuffInfo,{
	objectId = 0,
	role_id = 0,
	buffs = []
	}).

-define(CMD_GS2U_BuffList,16820).
-record(pk_GS2U_BuffList,{
	buffList = []
	}).

-define(CMD_GS2U_DelBuff,48302).
-record(pk_GS2U_DelBuff,{
	id = 0,
	actor_id = 0,
	actor_role_id = 0,
	caster_id = 0,
	buff_data_id = 0
	}).

-define(CMD_friendsInfo,50769).
-record(pk_friendsInfo,{
	playerID = 0,
	vip = 0,
	playerName = "",
	career = 0,
	sex = 0,
	fateLevel = 0,
	headID = 0,
	level = 0,
	fightPower = 0,
	guildID = 0,
	guildName = "",
	offlineTime = 0,
	isOpenHome = 0,
	isCatch = 0,
	isGive = 0,
	intimacyLevel = 0,
	intimacy = 0,
	isSingle = 0,
	flowerIntimacy = 0,
	frame = 0,
	nationality_id = 0
	}).

-define(CMD_GS2U_FriendsInfo,51254).
-record(pk_GS2U_FriendsInfo,{
	info_list = []
	}).

-define(CMD_blackListInfo,24353).
-record(pk_blackListInfo,{
	playerID = 0,
	vip = 0,
	playerName = "",
	career = 0,
	sex = 0,
	fateLevel = 0,
	headID = 0,
	level = 0,
	fightPower = 0,
	guildID = 0,
	guildName = "",
	offlineTime = 0
	}).

-define(CMD_GS2U_blackListInfo,32367).
-record(pk_GS2U_blackListInfo,{
	info_list = []
	}).

-define(CMD_inviteListInfo,5574).
-record(pk_inviteListInfo,{
	playerID = 0,
	vip = 0,
	playerName = "",
	career = 0,
	sex = 0,
	fateLevel = 0,
	headID = 0,
	level = 0,
	fightPower = 0,
	guildID = 0,
	guildName = "",
	offlineTime = 0,
	inviteTime = 0,
	nationality_id = 0
	}).

-define(CMD_GS2U_InviteFriend,49301).
-record(pk_GS2U_InviteFriend,{
	info_list = []
	}).

-define(CMD_U2GS_getInviteFriend,56617).
-record(pk_U2GS_getInviteFriend,{
	}).

-define(CMD_U2GS_ReplyInvite,52071).
-record(pk_U2GS_ReplyInvite,{
	playerID = 0,
	isAgree = 0
	}).

-define(CMD_U2GS_AddFriendByID,11124).
-record(pk_U2GS_AddFriendByID,{
	playerID = 0
	}).

-define(CMD_U2GS_AddFriendByName,46631).
-record(pk_U2GS_AddFriendByName,{
	playerName = ""
	}).

-define(CMD_U2GS_AddToBlack,16071).
-record(pk_U2GS_AddToBlack,{
	playerID = 0
	}).

-define(CMD_U2GS_DeleteBlack,58199).
-record(pk_U2GS_DeleteBlack,{
	playerID = 0
	}).

-define(CMD_U2GS_DeleteFriend,50901).
-record(pk_U2GS_DeleteFriend,{
	playerID = 0
	}).

-define(CMD_U2GS_getRecomFrineds,21227).
-record(pk_U2GS_getRecomFrineds,{
	}).

-define(CMD_recomInfo,27395).
-record(pk_recomInfo,{
	playerID = 0,
	vip = 0,
	playerName = "",
	sex = 0,
	career = 0,
	fateLevel = 0,
	headID = 0,
	level = 0,
	guild_name = ""
	}).

-define(CMD_GS2U_RecomInfo,50307).
-record(pk_GS2U_RecomInfo,{
	info_list = []
	}).

-define(CMD_U2GS_onekeyRefuse,36680).
-record(pk_U2GS_onekeyRefuse,{
	}).

-define(CMD_GS2U_sendBaseInfo,48800).
-record(pk_GS2U_sendBaseInfo,{
	friendsCount = 0,
	friendsMaxCount = 0,
	staminaCount = 0,
	staminaMaxCount = 0
	}).

-define(CMD_GS2U_inviteMsg,4229).
-record(pk_GS2U_inviteMsg,{
	playerName = "",
	isSucc = 0
	}).

-define(CMD_U2GS_requestFriendInfo,47298).
-record(pk_U2GS_requestFriendInfo,{
	}).

-define(CMD_GS2U_ReplyInviteResult,37315).
-record(pk_GS2U_ReplyInviteResult,{
	playerID = 0,
	playerName = "",
	result = 0
	}).

-define(CMD_U2GS_giveStamina,7852).
-record(pk_U2GS_giveStamina,{
	targetID = 0,
	type = 0
	}).

-define(CMD_GS2U_giveStaminaResult,43020).
-record(pk_GS2U_giveStaminaResult,{
	targetID = 0,
	type = 0,
	result = 0
	}).

-define(CMD_U2GS_getStamina,14689).
-record(pk_U2GS_getStamina,{
	targetID = 0,
	type = 0
	}).

-define(CMD_GS2U_getStaminaResult,41932).
-record(pk_GS2U_getStaminaResult,{
	targetID = 0,
	stamina = 0,
	result = 0
	}).

-define(CMD_U2GS_oneKeyGetStamina,65166).
-record(pk_U2GS_oneKeyGetStamina,{
	}).

-define(CMD_GS2U_oneKeyGetStamina,41064).
-record(pk_GS2U_oneKeyGetStamina,{
	stamina = 0,
	result = 0
	}).

-define(CMD_U2GS_getGiftsReceived,57009).
-record(pk_U2GS_getGiftsReceived,{
	}).

-define(CMD_giftsReceived,52168).
-record(pk_giftsReceived,{
	playerID = 0,
	vip = 0,
	playerName = "",
	sex = 0,
	career = 0,
	fateLevel = 0,
	headID = 0,
	level = 0,
	fightPower = 0,
	guildID = 0,
	guildName = "",
	offlineTime = 0,
	energy = 0,
	goldEnergy = 0,
	intimacyLevel = 0,
	intimacy = 0,
	giveEnergyTime = 0
	}).

-define(CMD_GS2U_sendGiftsReceived,18638).
-record(pk_GS2U_sendGiftsReceived,{
	gift_list = []
	}).

-define(CMD_TaskNpc,45476).
-record(pk_TaskNpc,{
	npcID = 0,
	showState = 0
	}).

-define(CMD_GS2U_TaskNpcList,56893).
-record(pk_GS2U_TaskNpcList,{
	taskNpcList = []
	}).

-define(CMD_GS2U_TaskNpcUpdate,28045).
-record(pk_GS2U_TaskNpcUpdate,{
	taskNpc = #pk_TaskNpc{}
	}).

-define(CMD_MessageInfo,48608).
-record(pk_MessageInfo,{
	type = 0,
	message = "",
	time = 0
	}).

-define(CMD_GS2U_MessageNotify,32524).
-record(pk_GS2U_MessageNotify,{
	messageInfoList = []
	}).

-define(CMD_U2GS_VoiceTextInfo,63666).
-record(pk_U2GS_VoiceTextInfo,{
	channelID = 0,
	receiverID = 0,
	voiceTextID = 0,
	voiceText = ""
	}).

-define(CMD_GS2U_VoiceTextInfo,45480).
-record(pk_GS2U_VoiceTextInfo,{
	channelID = 0,
	senderID = 0,
	voiceKey = 0,
	voiceText = ""
	}).

-define(CMD_GS2U_channelNotice,14370).
-record(pk_GS2U_channelNotice,{
	noticeIndex = "",
	notice = "",
	guildID = 0,
	bossLevel = 0,
	textIDParam = []
	}).

-define(CMD_GS2U_channelPosNotice,61807).
-record(pk_GS2U_channelPosNotice,{
	noticeIndex = "",
	notice = "",
	guildID = 0,
	posList = []
	}).

-define(CMD_GS2U_channelNoticeSpecial,51512).
-record(pk_GS2U_channelNoticeSpecial,{
	noticeIndex = "",
	notice = "",
	guildID = 0,
	special_args = []
	}).

-define(CMD_GS2U_channelNoticeHeadFram,38168).
-record(pk_GS2U_channelNoticeHeadFram,{
	noticeIndex = "",
	text_id = "",
	guildID = 0,
	head_id = 0,
	frame_id = 0,
	textIDParam = []
	}).

-define(CMD_U2GS_releaseWish,22698).
-record(pk_U2GS_releaseWish,{
	card_id_list = []
	}).

-define(CMD_GS2U_releaseWishResult,2784).
-record(pk_GS2U_releaseWishResult,{
	card_id_list = [],
	result = 0
	}).

-define(CMD_GS2U_releaseNewWish,44728).
-record(pk_GS2U_releaseNewWish,{
	wish_list = []
	}).

-define(CMD_U2GS_givePiece,28343).
-record(pk_U2GS_givePiece,{
	targetID = 0,
	card_id = 0,
	giveNum = 0
	}).

-define(CMD_GS2U_givePieceResult,51557).
-record(pk_GS2U_givePieceResult,{
	targetID = 0,
	card_id = 0,
	giveNum = 0,
	result = 0
	}).

-define(CMD_GS2U_giveNewPiece,32236).
-record(pk_GS2U_giveNewPiece,{
	give_list = []
	}).

-define(CMD_U2GS_sendPieceMsg,42774).
-record(pk_U2GS_sendPieceMsg,{
	}).

-define(CMD_GS2U_sendPieceMsgResult,17585).
-record(pk_GS2U_sendPieceMsgResult,{
	result = 0,
	sendTime = 0
	}).

-define(CMD_U2GS_givePieceRecord,3486).
-record(pk_U2GS_givePieceRecord,{
	}).

-define(CMD_GS2U_givePieceRecordRet,47306).
-record(pk_GS2U_givePieceRecordRet,{
	give_list = []
	}).

-define(CMD_GS2U_KillWorldBossAward,17192).
-record(pk_GS2U_KillWorldBossAward,{
	dataID = 0,
	coinList = [],
	item_info = []
	}).

-define(CMD_LookInfoCollection,64777).
-record(pk_LookInfoCollection,{
	id = 0,
	dataID = 0,
	x = 0,
	y = 0,
	rotw = 0,
	state = 0,
	startTime = 0,
	playerID = 0,
	playerName = "",
	creatorID = 0,
	owner_id = 0
	}).

-define(CMD_LookInfoMultiCollection,31713).
-record(pk_LookInfoMultiCollection,{
	id = 0,
	dataID = 0,
	x = 0,
	y = 0,
	rotw = 0,
	canCollectTimes = 0,
	pidList = []
	}).

-define(CMD_GS2U_CollectionList,1287).
-record(pk_GS2U_CollectionList,{
	collectionList = []
	}).

-define(CMD_U2GS_CollectStart,16561).
-record(pk_U2GS_CollectStart,{
	collectionID = 0
	}).

-define(CMD_GS2U_CollectStart,12600).
-record(pk_GS2U_CollectStart,{
	playerID = 0,
	roleID = 0,
	collectionID = 0,
	errorCode = 0
	}).

-define(CMD_U2GS_CollectStop,42014).
-record(pk_U2GS_CollectStop,{
	collectionID = 0,
	isSucceed = false
	}).

-define(CMD_GS2U_CollectStop,53447).
-record(pk_GS2U_CollectStop,{
	playerID = 0,
	collectionID = 0,
	errorCode = 0,
	isSucceed = false
	}).

-define(CMD_U2GS_GetAllRoomList,54148).
-record(pk_U2GS_GetAllRoomList,{
	dungeonID = 0,
	roomType = 0
	}).

-define(CMD_GS2U_CreateRoomResult,54131).
-record(pk_GS2U_CreateRoomResult,{
	result = 0,
	mapAI = 0
	}).

-define(CMD_RoomPlayerInfo,29015).
-record(pk_RoomPlayerInfo,{
	playerID = 0,
	ui_info = #pk_LookInfoPlayer4UI{},
	headID = 0,
	framID = 0,
	croFightRingQuitTime = 0,
	battle_value = 0,
	name = ""
	}).

-define(CMD_GS2U_RoomShortInfo,3331).
-record(pk_GS2U_RoomShortInfo,{
	roomID = 0,
	masterID = 0,
	dungeonID = 0,
	roomType = 0,
	roomSubType = 0,
	maxNum = 0,
	playerList = [],
	mapAI = 0
	}).

-define(CMD_U2GS_ChangeReadyState,22981).
-record(pk_U2GS_ChangeReadyState,{
	state = 0
	}).

-define(CMD_RoomPlayerState,35535).
-record(pk_RoomPlayerState,{
	playerID = 0,
	state = 0
	}).

-define(CMD_GS2U_RoomPlayerStateList,18848).
-record(pk_GS2U_RoomPlayerStateList,{
	info_list = [],
	mapAI = 0
	}).

-define(CMD_U2GS_KickRoomPlayer,17720).
-record(pk_U2GS_KickRoomPlayer,{
	playerID = 0
	}).

-define(CMD_GS2U_KickRoomPlayerResult,10901).
-record(pk_GS2U_KickRoomPlayerResult,{
	result = 0,
	playerID = 0,
	mapAI = 0
	}).

-define(CMD_U2GS_QuitRoom,36864).
-record(pk_U2GS_QuitRoom,{
	}).

-define(CMD_GS2U_DisbandRoom,6796).
-record(pk_GS2U_DisbandRoom,{
	mapAI = 0
	}).

-define(CMD_U2GS_JoinRoom,42534).
-record(pk_U2GS_JoinRoom,{
	roomID = 0,
	isAward = 0
	}).

-define(CMD_GS2U_JoinRoomResult,32889).
-record(pk_GS2U_JoinRoomResult,{
	result = 0,
	mapAI = 0
	}).

-define(CMD_U2GS_BattlefieldEnter,27525).
-record(pk_U2GS_BattlefieldEnter,{
	mapDataID = 0,
	type = 0
	}).

-define(CMD_GS2U_AddRoomPlayer,60762).
-record(pk_GS2U_AddRoomPlayer,{
	info = #pk_RoomPlayerInfo{},
	mapAI = 0
	}).

-define(CMD_GS2U_PlayerQuitRoom,41696).
-record(pk_GS2U_PlayerQuitRoom,{
	playerID = 0,
	mapAI = 0
	}).

-define(CMD_BattlefieldRank,63272).
-record(pk_BattlefieldRank,{
	rank = 0,
	rankValue = 0,
	playerID = 0,
	playerSex = 0,
	playerName = "",
	serverName = "",
	guildID = 0,
	guildName = "",
	chairmanID = 0,
	chairmanSex = 0,
	chairmanName = "",
	playerBattleValue = 0,
	guildBattleValue = 0,
	nationality_id = 0
	}).

-define(CMD_U2GS_BattlefieldRankList,54024).
-record(pk_U2GS_BattlefieldRankList,{
	type = 0
	}).

-define(CMD_GS2U_BattlefieldRankList,50327).
-record(pk_GS2U_BattlefieldRankList,{
	type = 0,
	errorCode = 0,
	rankList = [],
	myRank = 0,
	myRankValue = 0
	}).

-define(CMD_sample_rank,1898).
-record(pk_sample_rank,{
	rank = 0,
	name = "",
	serverName = "",
	value = 0,
	nationality_id = 0
	}).

-define(CMD_GS2U_BFScoreRankSample,5979).
-record(pk_GS2U_BFScoreRankSample,{
	bin_fill = <<>>,
	ranks = [],
	my_rank = 0,
	my_score = 0
	}).

-define(CMD_U2GS_GetBFScoreRank,58298).
-record(pk_U2GS_GetBFScoreRank,{
	}).

-define(CMD_bf_score_rank,31757).
-record(pk_bf_score_rank,{
	rank = 0,
	name = "",
	guild_name = "",
	box_num = 0,
	kill_num = 0,
	score = 0
	}).

-define(CMD_GS2U_GetBFScoreRankRet,60757).
-record(pk_GS2U_GetBFScoreRankRet,{
	ranks = [],
	my_rank = 0,
	box_num = 0,
	kill_num = 0,
	my_score = 0
	}).

-define(CMD_GS2U_BattlefieldPlayerTaskInfo,47384).
-record(pk_GS2U_BattlefieldPlayerTaskInfo,{
	progressList = [],
	finishList = []
	}).

-define(CMD_GS2U_BattlefieldGuildTaskInfo,58835).
-record(pk_GS2U_BattlefieldGuildTaskInfo,{
	progressList = []
	}).

-define(CMD_GS2U_BattlefieldTaskUpdate,39957).
-record(pk_GS2U_BattlefieldTaskUpdate,{
	taskProgress = #pk_TaskProgress{},
	isGuildTask = false
	}).

-define(CMD_U2GS_BattlefieldTaskFinish,38532).
-record(pk_U2GS_BattlefieldTaskFinish,{
	taskID = [],
	isGuildTask = false
	}).

-define(CMD_GS2U_BattlefieldTaskFinish,44185).
-record(pk_GS2U_BattlefieldTaskFinish,{
	taskID = [],
	errorCode = 0
	}).

-define(CMD_U2GS_RequestRoomInfo,57883).
-record(pk_U2GS_RequestRoomInfo,{
	}).

-define(CMD_GS2U_RequestRoomInfoResult,3873).
-record(pk_GS2U_RequestRoomInfoResult,{
	result = 0
	}).

-define(CMD_U2GS_AllMapObjectsInfo,56101).
-record(pk_U2GS_AllMapObjectsInfo,{
	}).

-define(CMD_MapObject,14932).
-record(pk_MapObject,{
	objectID = 0,
	relation = 0,
	posInfo = #pk_PosInfo{}
	}).

-define(CMD_OtherMapObject,61726).
-record(pk_OtherMapObject,{
	objectID = 0,
	monsterDataID = 0,
	guildID = 0,
	guildName = "",
	server_name = "",
	isAlive = 0,
	posInfo = #pk_PosInfo{}
	}).

-define(CMD_GS2U_AllMapObjectsInfoResult,42438).
-record(pk_GS2U_AllMapObjectsInfoResult,{
	infoList = [],
	otherInfoList = []
	}).

-define(CMD_GS2U_BattlefieldState,34963).
-record(pk_GS2U_BattlefieldState,{
	state = 0,
	openTime = 0,
	monsterTime = 0,
	closeTime = 0,
	discount = 0,
	settle_map = []
	}).

-define(CMD_BattlefieldBossInfo,29658).
-record(pk_BattlefieldBossInfo,{
	monsterDataID = 0,
	playerID = 0,
	playerName = "",
	serverName = ""
	}).

-define(CMD_BattlefieldMapInfo,48552).
-record(pk_BattlefieldMapInfo,{
	mapDataID = 0,
	num = 0,
	numGuild = 0,
	numGuildOnline = 0,
	bossInfoList = []
	}).

-define(CMD_U2GS_BattlefieldPanelInfo,37479).
-record(pk_U2GS_BattlefieldPanelInfo,{
	}).

-define(CMD_GS2U_BattlefieldPanelInfo,51338).
-record(pk_GS2U_BattlefieldPanelInfo,{
	arenaRanking = 0,
	enterMapDataID = 0,
	mapInfoList = [],
	rebornTime = 0,
	worldLevel = 0,
	server_type = 0,
	server_num = 0
	}).

-define(CMD_GS2U_BattlefieldMapObject,37668).
-record(pk_GS2U_BattlefieldMapObject,{
	state = 0,
	openTime = 0,
	collectionTime = 0,
	monsterTime = 0,
	closeTime = 0,
	monsterNum = 0,
	collectionNum = 0
	}).

-define(CMD_U2GS_GetWorldBossRank,41225).
-record(pk_U2GS_GetWorldBossRank,{
	number = 0
	}).

-define(CMD_WorldBossRankInfo,8547).
-record(pk_WorldBossRankInfo,{
	rank = 0,
	playerID = 0,
	playerName = "",
	guildName = "",
	battleValue = 0,
	damage = 0
	}).

-define(CMD_GS2U_WorldBossRankList,34560).
-record(pk_GS2U_WorldBossRankList,{
	myRank = 0,
	myDamage = 0,
	rankList = [],
	luckyList = []
	}).

-define(CMD_U2GS_conveneGuildMember,62997).
-record(pk_U2GS_conveneGuildMember,{
	mapDataID = 0,
	type = 0,
	posX = 0,
	posY = 0
	}).

-define(CMD_GS2U_SendConveneMsg,3926).
-record(pk_GS2U_SendConveneMsg,{
	sendID = 0,
	sendName = "",
	type = 0,
	nRank = 0,
	mapDataID = 0,
	posX = 0,
	posY = 0
	}).

-define(CMD_U2GS_getPacketCount,55754).
-record(pk_U2GS_getPacketCount,{
	}).

-define(CMD_GS2U_sendPacketCount,14217).
-record(pk_GS2U_sendPacketCount,{
	killNum = 0,
	killGuildNum = 0,
	damageNum = 0,
	growthNum = 0,
	packetCount = 0,
	integral = 0
	}).

-define(CMD_U2GS_operatePacket,47137).
-record(pk_U2GS_operatePacket,{
	}).

-define(CMD_GS2U_operatePacketResult,53565).
-record(pk_GS2U_operatePacketResult,{
	coin_list = [],
	item_list = [],
	result = 0
	}).

-define(CMD_GS2U_conveneGuildMemberResult,7477).
-record(pk_GS2U_conveneGuildMemberResult,{
	mapDataID = 0,
	posX = 0,
	posY = 0,
	result = 0
	}).

-define(CMD_GS2U_BattlefieldMessage,46290).
-record(pk_GS2U_BattlefieldMessage,{
	message = ""
	}).

-define(CMD_U2GS_MapBattleValue,47428).
-record(pk_U2GS_MapBattleValue,{
	}).

-define(CMD_GS2U_MapBattleValue,24619).
-record(pk_GS2U_MapBattleValue,{
	battleValue = 0
	}).

-define(CMD_GS2U_addFriendsByIDResult,2553).
-record(pk_GS2U_addFriendsByIDResult,{
	playerID = 0,
	result = 0
	}).

-define(CMD_U2GS_getPlayerConveneTime,47050).
-record(pk_U2GS_getPlayerConveneTime,{
	type = 0
	}).

-define(CMD_GS2U_sendPlayerConveneTime,1663).
-record(pk_GS2U_sendPlayerConveneTime,{
	conveneTime = 0,
	times = 0
	}).

-define(CMD_U2GS_AppearUpdate,17302).
-record(pk_U2GS_AppearUpdate,{
	addList = [],
	delList = []
	}).

-define(CMD_GS2U_BattlefieldKeepKill,6444).
-record(pk_GS2U_BattlefieldKeepKill,{
	num = 0
	}).

-define(CMD_BattlefieldBossResult,27580).
-record(pk_BattlefieldBossResult,{
	monsterDataID = 0,
	playerID = 0,
	playerSex = 0,
	playerName = "",
	serverName = "",
	guildID = 0,
	guildName = "",
	coinList = [],
	itemList = [],
	nationality_id = 0
	}).

-define(CMD_bf_settle_rank,63291).
-record(pk_bf_settle_rank,{
	rank = 0,
	sex = 0,
	name = "",
	guild_name = "",
	serverName = "",
	value = 0,
	nationality_id = 0
	}).

-define(CMD_BattlefieldScoreResult,45356).
-record(pk_BattlefieldScoreResult,{
	ranks = [],
	coin_list = [],
	item_list = [],
	eq_list = []
	}).

-define(CMD_GS2U_BattlefieldMapResult,14047).
-record(pk_GS2U_BattlefieldMapResult,{
	score_result = #pk_BattlefieldScoreResult{},
	bossResultList = [],
	killNum = 0,
	collectionNum = 0,
	bossNum = 0,
	guildRewardNum = 0,
	guildKillNum = 0,
	guildCollectionNum = 0,
	guildBossNum = 0
	}).

-define(CMD_U2GS_ChangePlayerSex,36961).
-record(pk_U2GS_ChangePlayerSex,{
	sex = 0
	}).

-define(CMD_GS2U_ChangePlayerSex,48185).
-record(pk_GS2U_ChangePlayerSex,{
	sex = 0,
	errorCode = 0
	}).

-define(CMD_U2GS_UseHpItem,31257).
-record(pk_U2GS_UseHpItem,{
	itemDataID = 0
	}).

-define(CMD_U2GS_addGuildCondition,41633).
-record(pk_U2GS_addGuildCondition,{
	type = 0,
	value = 0
	}).

-define(CMD_GS2U_addGuildConditionResult,9121).
-record(pk_GS2U_addGuildConditionResult,{
	type = 0,
	value = 0,
	result = 0
	}).

-define(CMD_U2GS_setAutoJoinGuild,6799).
-record(pk_U2GS_setAutoJoinGuild,{
	autoJoin = 0
	}).

-define(CMD_GS2U_setAutoJoinGuildResult,35520).
-record(pk_GS2U_setAutoJoinGuildResult,{
	autoJoin = 0,
	result = 0
	}).

-define(CMD_GS2U_requestQuitWildBossResult,11502).
-record(pk_GS2U_requestQuitWildBossResult,{
	killBossName = "",
	integral = 0,
	killPlayerCount = 0,
	lifeBossLine = 0
	}).

-define(CMD_GS2U_MapPlayerCount,62208).
-record(pk_GS2U_MapPlayerCount,{
	playerCount = 0
	}).

-define(CMD_U2GS_BattlefieldResult,3210).
-record(pk_U2GS_BattlefieldResult,{
	mapDataID = 0
	}).

-define(CMD_GS2U_BattlefieldResult,15639).
-record(pk_GS2U_BattlefieldResult,{
	mapDataID = 0,
	isFinish = false
	}).

-define(CMD_GS2U_ResourseFindBackRedPoint,31439).
-record(pk_GS2U_ResourseFindBackRedPoint,{
	}).

-define(CMD_U2GS_ResourseFindBackData,11572).
-record(pk_U2GS_ResourseFindBackData,{
	}).

-define(CMD_ResourseFindBack,31369).
-record(pk_ResourseFindBack,{
	resID = 0,
	count_nor = 0,
	count_ex = 0,
	count_nor_get = 0,
	count_ex_get = 0,
	params = []
	}).

-define(CMD_GS2U_ResourseFindBackData,25605).
-record(pk_GS2U_ResourseFindBackData,{
	resList = []
	}).

-define(CMD_U2GS_ResourseFindBack,39584).
-record(pk_U2GS_ResourseFindBack,{
	resID = 0,
	findType = 0,
	count = 0,
	dlgType = 0
	}).

-define(CMD_GS2U_ResourseFindBackResult,17223).
-record(pk_GS2U_ResourseFindBackResult,{
	resID = 0,
	findType = 0,
	count = 0,
	result = 0,
	exp = 0,
	coinList = [],
	itemList = [],
	eq_list = []
	}).

-define(CMD_U2GS_RechargeInfo,16158).
-record(pk_U2GS_RechargeInfo,{
	}).

-define(CMD_GS2U_RechargeInfo,12197).
-record(pk_GS2U_RechargeInfo,{
	serverDay = 0,
	gold1 = 0,
	itemID1 = [],
	coin1 = [],
	gold2 = 0,
	itemID2 = [],
	coin2 = [],
	gold3 = 0,
	itemID3 = [],
	coin3 = [],
	itemIDReward = [],
	coinReward = [],
	finishServerDay = 0,
	dayGold = 0,
	days5 = 0,
	itemID5 = [],
	coin5 = [],
	days6 = 0,
	itemID6 = [],
	coin6 = [],
	days7 = 0,
	itemID7 = [],
	coin7 = []
	}).

-define(CMD_GS2U_recharge_total,42718).
-record(pk_GS2U_recharge_total,{
	daily_recharge = 0,
	daily_finish1 = 0,
	daily_finish2 = 0,
	daily_finish3 = 0,
	daily_finish4 = 0,
	period_time = 0,
	period_days = 0,
	period_finish1 = 0,
	period_finish2 = 0,
	period_finish3 = 0
	}).

-define(CMD_U2GS_RequestSettleAccounts_info,31827).
-record(pk_U2GS_RequestSettleAccounts_info,{
	keyindex = 0,
	info = <<>>
	}).

-define(CMD_ActiveInfo,24109).
-record(pk_ActiveInfo,{
	activeID = 0,
	usedCount = 0,
	totalCount = 0,
	remainBuyCount = 0,
	recommendVIP = 0
	}).

-define(CMD_GS2U_ActiveInfoList,1030).
-record(pk_GS2U_ActiveInfoList,{
	activeInfoList = []
	}).

-define(CMD_GS2U_ActiveInfoUpdate,18535).
-record(pk_GS2U_ActiveInfoUpdate,{
	activeInfo = #pk_ActiveInfo{}
	}).

-define(CMD_U2GS_conveneGuildMemberResult,61251).
-record(pk_U2GS_conveneGuildMemberResult,{
	conveneID = 0,
	type = 0,
	agree = 0
	}).

-define(CMD_U2GS_BattlefieldGetResult,35619).
-record(pk_U2GS_BattlefieldGetResult,{
	mapDataID = 0
	}).

-define(CMD_U2GS_Guild_enter_Camp,39641).
-record(pk_U2GS_Guild_enter_Camp,{
	mapId = 0
	}).

-define(CMD_GS2U_Guild_enter_CampRet,43727).
-record(pk_GS2U_Guild_enter_CampRet,{
	errorCode = 0
	}).

-define(CMD_GS2U_Guild_quit_CampRet,16068).
-record(pk_GS2U_Guild_quit_CampRet,{
	errorCode = 0
	}).

-define(CMD_Camp_Player,58961).
-record(pk_Camp_Player,{
	playerId = 0,
	name = "",
	sex = 0,
	headID = 0,
	fateLevel = 0,
	vip = 0
	}).

-define(CMD_GS2U_Guild_Camp_PlayerNotify,39704).
-record(pk_GS2U_Guild_Camp_PlayerNotify,{
	playerInfo = []
	}).

-define(CMD_GS2U_Guild_Camp_PlayerLeave,5799).
-record(pk_GS2U_Guild_Camp_PlayerLeave,{
	playerId = 0
	}).

-define(CMD_Camp_Buff,11643).
-record(pk_Camp_Buff,{
	index = 0,
	buff_id = 0,
	etime = 0,
	provider_name = ""
	}).

-define(CMD_GS2U_Guild_Camp_BuffNotify,9905).
-record(pk_GS2U_Guild_Camp_BuffNotify,{
	buffInfo = []
	}).

-define(CMD_GS2U_MountProperty,4983).
-record(pk_GS2U_MountProperty,{
	mountID = 0,
	errorCode = 0,
	objectProperty = #pk_ObjectProperty{}
	}).

-define(CMD_GS2U_MountPropertyChanged,36433).
-record(pk_GS2U_MountPropertyChanged,{
	mountID = 0,
	objectPropertyChanged = #pk_ObjectPropertyChanged{}
	}).

-define(CMD_GS2U_Guild_Camp_CampfireRet,33184).
-record(pk_GS2U_Guild_Camp_CampfireRet,{
	level = 0,
	base_exp = 0
	}).

-define(CMD_GS2U_CarnivalValidList,60655).
-record(pk_GS2U_CarnivalValidList,{
	id_list = []
	}).

-define(CMD_U2GS_getCarnivalInfo,21341).
-record(pk_U2GS_getCarnivalInfo,{
	id = 0
	}).

-define(CMD_carnivalInfo,23318).
-record(pk_carnivalInfo,{
	id = 0,
	name = "",
	fateLevel = 0,
	param = 0,
	value = 0,
	rank = 0,
	time = 0
	}).

-define(CMD_GS2U_sendCarnivalInfo,12906).
-record(pk_GS2U_sendCarnivalInfo,{
	id = 0,
	value = 0,
	rank = 0,
	fateLevel = 0,
	param = 0,
	time = 0,
	carnival_list = []
	}).

-define(CMD_carnivalcon,39630).
-record(pk_carnivalcon,{
	reward_order = 0,
	param1 = 0,
	param2 = 0,
	param3 = 0
	}).

-define(CMD_carnivalconbase,44258).
-record(pk_carnivalconbase,{
	order = 0,
	type = 0,
	param = 0
	}).

-define(CMD_carnival_buy_stc,24564).
-record(pk_carnival_buy_stc,{
	goods_id = 0,
	lv_range = #pk_key_value{},
	name = "",
	item_list = [],
	show = [],
	buy_type = 0,
	curr_type = #pk_key_value{},
	direct_purchase_code = "",
	discount = 0,
	limit = #pk_key_2value{},
	condition_type = #pk_key_value{},
	show_type = #pk_key_value{},
	character = 0,
	red_dot = 0,
	must_buy_label = 0
	}).

-define(CMD_carnivalcfginfo,43148).
-record(pk_carnivalcfginfo,{
	id = 0,
	name = "",
	pic = "",
	pic_text = "",
	pic_text2 = "",
	pic_text_pos = 0,
	opendate = 0,
	duration_day = 0,
	recommend = [],
	rank_record = 0,
	rank_show = 0,
	type = 0,
	reward_cond = [],
	reward_cond_base = [],
	rank_value_view = 0,
	reward_show = [],
	titlel_con = 0,
	ui_show_num = 0,
	reward_group = 0,
	recommend_text = [],
	qipao_text = "",
	recommend_Name = [],
	recommend_Icon = [],
	direct_buy_list = [],
	pay_open_date = 0
	}).

-define(CMD_GS2U_CarnivalCfgRank,48348).
-record(pk_GS2U_CarnivalCfgRank,{
	cfg_rank_info = []
	}).

-define(CMD_GS2U_CarnivalDirectBuyInfo,27720).
-record(pk_GS2U_CarnivalDirectBuyInfo,{
	buy_list = []
	}).

-define(CMD_U2GS_carnival_goods_buy,21033).
-record(pk_U2GS_carnival_goods_buy,{
	id = 0,
	goods_id = 0
	}).

-define(CMD_GS2U_carnival_goods_buy_ret,54751).
-record(pk_GS2U_carnival_goods_buy_ret,{
	id = 0,
	goods_id = 0,
	err_code = 0
	}).

-define(CMD_carnivalequip,2670).
-record(pk_carnivalequip,{
	career = 0,
	equip_id = 0,
	equip_quality = 0,
	equip_star = 0,
	is_bind = 0
	}).

-define(CMD_carnivalitem,7790).
-record(pk_carnivalitem,{
	career = 0,
	type = 0,
	item_id = 0,
	is_bind = 0,
	number = 0
	}).

-define(CMD_carnivalactiveinfo,6805).
-record(pk_carnivalactiveinfo,{
	type = 0,
	id = 0,
	gift_order = 0,
	award_item = [],
	award_equip = []
	}).

-define(CMD_GS2U_CarnivalCfgRankGift,9788).
-record(pk_GS2U_CarnivalCfgRankGift,{
	cfg_active_info = []
	}).

-define(CMD_carnivalspecial,5190).
-record(pk_carnivalspecial,{
	gift_id = 0,
	id = 0,
	position = 0,
	award_item = [],
	award_equip = [],
	item_show = 0
	}).

-define(CMD_GS2U_CarnivalCfgSpecial,60437).
-record(pk_GS2U_CarnivalCfgSpecial,{
	special_info = []
	}).

-define(CMD_U2GS_MountChangeStatus,54323).
-record(pk_U2GS_MountChangeStatus,{
	mountStatus = 0
	}).

-define(CMD_GS2U_MountChangeStatus,1390).
-record(pk_GS2U_MountChangeStatus,{
	playerID = 0,
	mountStatus = 0,
	move_speed = 0
	}).

-define(CMD_U2GS_Red_Envelope,30069).
-record(pk_U2GS_Red_Envelope,{
	type = 0,
	param = 0,
	targetID = 0,
	command = ""
	}).

-define(CMD_GS2U_Red_EnvelopeRet,40898).
-record(pk_GS2U_Red_EnvelopeRet,{
	errorCode = 0
	}).

-define(CMD_Red_EnvelopeRet,46335).
-record(pk_Red_EnvelopeRet,{
	id = 0,
	type = 0,
	title = "",
	sender_name = "",
	money = 0,
	number = 0,
	time = 0
	}).

-define(CMD_GS2U_Red_EnvelopeNotify,30916).
-record(pk_GS2U_Red_EnvelopeNotify,{
	red_Envelope = []
	}).

-define(CMD_U2GS_Red_Envelope_Take,58396).
-record(pk_U2GS_Red_Envelope_Take,{
	id = 0,
	command = ""
	}).

-define(CMD_GS2U_Red_Envelope_TakeRet,59993).
-record(pk_GS2U_Red_Envelope_TakeRet,{
	type = 0,
	errorCode = 0,
	sender_name = "",
	gold = 0,
	coin = 0
	}).

-define(CMD_GS2U_Red_EnvelopeClear,45076).
-record(pk_GS2U_Red_EnvelopeClear,{
	id = 0
	}).

-define(CMD_U2GS_donateGuildMoney,53399).
-record(pk_U2GS_donateGuildMoney,{
	times = 0
	}).

-define(CMD_GS2U_donateGuildMoneyResult,20485).
-record(pk_GS2U_donateGuildMoneyResult,{
	times = 0,
	result = 0
	}).

-define(CMD_U2GS_getGuildMoneyLogList,51410).
-record(pk_U2GS_getGuildMoneyLogList,{
	}).

-define(CMD_guildMoneyLog,6749).
-record(pk_guildMoneyLog,{
	playerID = 0,
	playerName = "",
	donateTimes = 0,
	addMoney = 0,
	donateTime = 0
	}).

-define(CMD_GS2U_sendGuildMoneyLogList,58897).
-record(pk_GS2U_sendGuildMoneyLogList,{
	log_list = []
	}).

-define(CMD_Camp_Act_State,61460).
-record(pk_Camp_Act_State,{
	playerId = 0,
	targetId = 0,
	point = 0,
	type = 0,
	sit = 0
	}).

-define(CMD_U2GS_Guild_Camp_State,55119).
-record(pk_U2GS_Guild_Camp_State,{
	act = []
	}).

-define(CMD_GS2U_Guild_Camp_StateNotify,29189).
-record(pk_GS2U_Guild_Camp_StateNotify,{
	act = []
	}).

-define(CMD_U2GS_Guild_Camp_Gains,27530).
-record(pk_U2GS_Guild_Camp_Gains,{
	}).

-define(CMD_GS2U_Guild_Camp_GainsRet,4372).
-record(pk_GS2U_Guild_Camp_GainsRet,{
	exp = 0,
	gold = 0
	}).

-define(CMD_U2GS_Red_Envelope_Record,12388).
-record(pk_U2GS_Red_Envelope_Record,{
	}).

-define(CMD_Red_Envelope_Record,50439).
-record(pk_Red_Envelope_Record,{
	playerName = "",
	onwerName = "",
	take_money = 0,
	time = 0,
	type = 0,
	best_of_luck = 0
	}).

-define(CMD_GS2U_Red_Envelope_RecordRet,14787).
-record(pk_GS2U_Red_Envelope_RecordRet,{
	todayNumber = 0,
	todayCount = 0,
	historyNumber = 0,
	historyCount = 0,
	record = []
	}).

-define(CMD_U2GS_BattleStatus,17925).
-record(pk_U2GS_BattleStatus,{
	battleStatus = 0
	}).

-define(CMD_GS2U_BattleStatus,47110).
-record(pk_GS2U_BattleStatus,{
	playerID = 0,
	battleStatus = 0
	}).

-define(CMD_U2GS_getGuildMoney,21813).
-record(pk_U2GS_getGuildMoney,{
	}).

-define(CMD_GS2U_sendGuildMoney,45879).
-record(pk_GS2U_sendGuildMoney,{
	guildMoney = 0
	}).

-define(CMD_U2GS_GetAwardShow,30895).
-record(pk_U2GS_GetAwardShow,{
	awardIDList = []
	}).

-define(CMD_AwardShow,46127).
-record(pk_AwardShow,{
	awardID = 0,
	coinList = [],
	itemList = []
	}).

-define(CMD_GS2U_GetAwardShowRet,50345).
-record(pk_GS2U_GetAwardShowRet,{
	awardShowList = []
	}).

-define(CMD_U2GS_exchangeItem,11482).
-record(pk_U2GS_exchangeItem,{
	id = 0,
	changeID = 0,
	changeTimes = 0
	}).

-define(CMD_GS2U_exchangeItemResult,33680).
-record(pk_GS2U_exchangeItemResult,{
	id = 0,
	changeID = 0,
	changeTimes = 0,
	result = 0
	}).

-define(CMD_U2GS_getRouletteInfo,60211).
-record(pk_U2GS_getRouletteInfo,{
	id = 0
	}).

-define(CMD_consWay,25414).
-record(pk_consWay,{
	program = 0,
	way = 0,
	param1 = 0,
	param2 = 0
	}).

-define(CMD_rewardItem,56305).
-record(pk_rewardItem,{
	index = 0,
	tp = 0,
	career = 0,
	bind = 0,
	p1 = 0,
	p2 = 0,
	chara = 0,
	star = 0,
	show_vfx = 0
	}).

-define(CMD_rouletteChangeInfo,33857).
-record(pk_rouletteChangeInfo,{
	index = 0,
	isServer = 0,
	item = #pk_rewardItem{},
	integral = 0,
	changeTimes = 0,
	discount = 0
	}).

-define(CMD_roulette_change,39000).
-record(pk_roulette_change,{
	index = 0,
	isServer = 0,
	times = 0
	}).

-define(CMD_roulette_top,27967).
-record(pk_roulette_top,{
	index = 0,
	startR = 0,
	endR = 0,
	list = []
	}).

-define(CMD_top_rank,12558).
-record(pk_top_rank,{
	playerID = 0,
	name = "",
	fateLevel = 0,
	value = 0,
	time = 0,
	nationality_id = 0
	}).

-define(CMD_rouletteInfo,35009).
-record(pk_rouletteInfo,{
	id = 0,
	type = 0,
	startTime = 0,
	endTime = 0,
	showEndTime = 0,
	convPoint = 0,
	luckyPointUnit = 0,
	luckyPointMax = 0,
	times = [],
	pro_list = [],
	itemSp_list = [],
	itemCom_list = [],
	sit_list = [],
	changeInfo_list = [],
	top_award_list = [],
	show_rank = []
	}).

-define(CMD_GS2U_sendRouletteInfo,51776).
-record(pk_GS2U_sendRouletteInfo,{
	roulette_list = []
	}).

-define(CMD_U2GS_rouletteDraw,36925).
-record(pk_U2GS_rouletteDraw,{
	id = 0,
	times = 0
	}).

-define(CMD_rouletteItem,15318).
-record(pk_rouletteItem,{
	index = 0,
	type = 0,
	param1 = 0,
	param2 = 0,
	bind = 0,
	chara = 0,
	star = 0,
	times = 0
	}).

-define(CMD_roulettePercent,25302).
-record(pk_roulettePercent,{
	percent = 0,
	drawSalary = 0
	}).

-define(CMD_GS2U_rouletteDrawResult,38561).
-record(pk_GS2U_rouletteDrawResult,{
	id = 0,
	times = 0,
	salIntegral = 0,
	changeIntegral = 0,
	luckyIntegral = 0,
	itemCount = 0,
	per_list = [],
	itemSp_list = [],
	itemCom_list = [],
	result = 0
	}).

-define(CMD_U2GS_getPlayerTempBag,34229).
-record(pk_U2GS_getPlayerTempBag,{
	id = 0
	}).

-define(CMD_GS2U_sendPlayerTempBag,61394).
-record(pk_GS2U_sendPlayerTempBag,{
	bag_list = []
	}).

-define(CMD_U2GS_changeRouletteItem,40064).
-record(pk_U2GS_changeRouletteItem,{
	id = 0,
	index = 0,
	times = 0
	}).

-define(CMD_GS2U_changeRouletteItemResult,48290).
-record(pk_GS2U_changeRouletteItemResult,{
	id = 0,
	index = 0,
	changeIntegral = 0,
	result = 0
	}).

-define(CMD_U2GS_getSingleTempItem,29301).
-record(pk_U2GS_getSingleTempItem,{
	id = 0,
	isAll = 0,
	type = 0,
	param1 = 0,
	param2 = 0,
	bind = 0,
	chara = 0,
	star = 0
	}).

-define(CMD_GS2U_getSingleTempItemResult,57793).
-record(pk_GS2U_getSingleTempItemResult,{
	id = 0,
	isAll = 0,
	type = 0,
	param1 = 0,
	param2 = 0,
	bind = 0,
	chara = 0,
	star = 0,
	itemCount = 0,
	result = 0
	}).

-define(CMD_roulette_record,17317).
-record(pk_roulette_record,{
	player_text = "",
	type = 0,
	param1 = 0,
	param2 = 0,
	chara = 0,
	times = 0
	}).

-define(CMD_GS2U_rouletteItemMsg,512).
-record(pk_GS2U_rouletteItemMsg,{
	id = 0,
	isServer = 0,
	sp_list = [],
	com_list = [],
	mix_list = [],
	limit_list = []
	}).

-define(CMD_U2GS_GuildCamp_ActivityTime,515).
-record(pk_U2GS_GuildCamp_ActivityTime,{
	}).

-define(CMD_GS2U_GuildCamp_ActivityTimeRet,19150).
-record(pk_GS2U_GuildCamp_ActivityTimeRet,{
	start_time = 0,
	end_time = 0
	}).

-define(CMD_lookRoulette,590).
-record(pk_lookRoulette,{
	id = 0,
	type = 0,
	teamType = 0,
	title = "",
	isRed = 0,
	startTime = 0,
	endTime = 0,
	pic_list = [],
	banner_upleft = "",
	banner_lowleft = "",
	banner_upright = "",
	banner_lowright = ""
	}).

-define(CMD_GS2U_sendLookRoulette,8544).
-record(pk_GS2U_sendLookRoulette,{
	teamType = 0,
	roulette_list = []
	}).

-define(CMD_U2GS_RedEnvelop_Rest_Number,35506).
-record(pk_U2GS_RedEnvelop_Rest_Number,{
	id = 0
	}).

-define(CMD_GS2U_RedEnvelop_Rest_NumberRet,30731).
-record(pk_GS2U_RedEnvelop_Rest_NumberRet,{
	rest_number = 0
	}).

-define(CMD_GS2U_ItemDecompose,65505).
-record(pk_GS2U_ItemDecompose,{
	itemDBID = 0,
	itemCount = 0,
	errorCode = 0,
	itemDataID = 0
	}).

-define(CMD_U2GS_getLookRoulette,59156).
-record(pk_U2GS_getLookRoulette,{
	teamType = 0
	}).

-define(CMD_GS2U_SuitAddChara,34279).
-record(pk_GS2U_SuitAddChara,{
	oldChara = 0,
	newChara = 0
	}).

-define(CMD_U2GS_SkillStat,38650).
-record(pk_U2GS_SkillStat,{
	code = 0,
	skillId = 0,
	isUse = false,
	angleX = 0,
	angleY = 0
	}).

-define(CMD_GS2U_SkillStat,43426).
-record(pk_GS2U_SkillStat,{
	code = 0,
	skillId = 0,
	isUse = false,
	angleX = 0,
	angleY = 0
	}).

-define(CMD_GS2U_MonsterTransferBegin,12036).
-record(pk_GS2U_MonsterTransferBegin,{
	id = 0,
	type = 0
	}).

-define(CMD_GS2U_MonsterTransferEnd,32833).
-record(pk_GS2U_MonsterTransferEnd,{
	id = 0,
	type = 0
	}).

-define(CMD_RebateAwardCurrency,12670).
-record(pk_RebateAwardCurrency,{
	currencyType = 0,
	currency = 0
	}).

-define(CMD_RebateAwardItem,42245).
-record(pk_RebateAwardItem,{
	cfgId = 0,
	amount = 0,
	bind = 0
	}).

-define(CMD_RebateAwardEquipment,12053).
-record(pk_RebateAwardEquipment,{
	cfgId = 0,
	amount = 0,
	bind = 0,
	quality = 0,
	star = 0
	}).

-define(CMD_RebateAward,32499).
-record(pk_RebateAward,{
	name = "",
	currencyList = [],
	itemList = [],
	equipmentList = []
	}).

-define(CMD_RebateItemCfg,65122).
-record(pk_RebateItemCfg,{
	index = 0,
	price = 0,
	gold = 0,
	rebateAward = #pk_RebateAward{}
	}).

-define(CMD_U2GS_RebateItemCfgList,33631).
-record(pk_U2GS_RebateItemCfgList,{
	}).

-define(CMD_GS2U_RebateItemCfgList,46235).
-record(pk_GS2U_RebateItemCfgList,{
	rebateAward = #pk_RebateAward{},
	cfgList = []
	}).

-define(CMD_GS2U_recharge_buy,43107).
-record(pk_GS2U_recharge_buy,{
	daily_finish1 = 0,
	daily_finish2 = 0,
	daily_finish3 = 0,
	daily_finish4 = 0
	}).

-define(CMD_GiftPackageBuy,49323).
-record(pk_GiftPackageBuy,{
	index = 0,
	id = 0,
	name = "",
	buy_times = 0,
	total_times = 0,
	icon = "",
	ammount11_Equip = [],
	ammount11_Item = []
	}).

-define(CMD_GS2U_gift_package_buy,40364).
-record(pk_GS2U_gift_package_buy,{
	infoList = []
	}).

-define(CMD_U2GS_getRouletteExchange,35978).
-record(pk_U2GS_getRouletteExchange,{
	id = 0
	}).

-define(CMD_GS2U_sendRouletteExchangeList,27047).
-record(pk_GS2U_sendRouletteExchangeList,{
	id = 0,
	change_list = []
	}).

-define(CMD_U2GS_getRouletteTopList,51173).
-record(pk_U2GS_getRouletteTopList,{
	id = 0
	}).

-define(CMD_GS2U_sendRouletteTopList,13490).
-record(pk_GS2U_sendRouletteTopList,{
	id = 0,
	rankNum = 0,
	top_list = []
	}).

-define(CMD_salary_record,19574).
-record(pk_salary_record,{
	time = 0,
	name = "",
	rate = 0,
	num = 0
	}).

-define(CMD_GS2U_sendSarlaryRecord,44038).
-record(pk_GS2U_sendSarlaryRecord,{
	id = 0,
	record_list = []
	}).

-define(CMD_rouletteSaveInfo,33586).
-record(pk_rouletteSaveInfo,{
	id = 0,
	wealthTime = 0,
	salIntegral = 0,
	drawTimes = 0,
	changeIntegral = 0,
	luckyIntegral = 0,
	itemCount = 0,
	rankBase = 0,
	rankNum = 0,
	change_list = [],
	top_list = []
	}).

-define(CMD_GS2U_sendRouletteSaveInfo,24207).
-record(pk_GS2U_sendRouletteSaveInfo,{
	info_list = []
	}).

-define(CMD_U2GS_getTop_activityInfo,18812).
-record(pk_U2GS_getTop_activityInfo,{
	}).

-define(CMD_activity_topInfo,46534).
-record(pk_activity_topInfo,{
	id = 0,
	name = "",
	fateLevel = 0,
	value = 0,
	customInt = 0,
	rank = 0,
	time = 0,
	nationality_id = 0
	}).

-define(CMD_activity_topAward,2469).
-record(pk_activity_topAward,{
	type = 0,
	param1 = 0,
	param2 = 0
	}).

-define(CMD_activity_topCfg,32029).
-record(pk_activity_topCfg,{
	index = 0,
	startR = 0,
	endR = 0,
	param = 0,
	award_list = []
	}).

-define(CMD_top_activityInfo,13467).
-record(pk_top_activityInfo,{
	id = 0,
	group_id = 0,
	group_index = 0,
	group_name = "",
	name = "",
	pic = "",
	teamType = 0,
	teamName = "",
	type = 0,
	startTime = 0,
	endTime = 0,
	value = 0,
	rank = 0,
	cfg_list = [],
	info_list = []
	}).

-define(CMD_GS2U_sendTop_activityInfo,35682).
-record(pk_GS2U_sendTop_activityInfo,{
	info_list = []
	}).

-define(CMD_U2GS_RebateFreeAward,11409).
-record(pk_U2GS_RebateFreeAward,{
	}).

-define(CMD_GS2U_RebateFreeAward,22632).
-record(pk_GS2U_RebateFreeAward,{
	errorCode = 0
	}).

-define(CMD_RechargeAward,51502).
-record(pk_RechargeAward,{
	itemList = [],
	currencyList = [],
	equipmentList = []
	}).

-define(CMD_GS2U_NewRechargeResult2,28715).
-record(pk_GS2U_NewRechargeResult2,{
	orderID = "",
	code = 0,
	amount = 0,
	itemid = "",
	createtime = "",
	firstRecharg = 0,
	addgold = 0,
	freeVipValue = 0,
	rebateAwardList = [],
	comments = "",
	price = "",
	orig_price = "",
	orig_currency = "",
	purple_num = 0
	}).

-define(CMD_U2GS_getEnemyInfo,57317).
-record(pk_U2GS_getEnemyInfo,{
	}).

-define(CMD_enemyInfo,14921).
-record(pk_enemyInfo,{
	killID = 0,
	server_id = 0,
	vip = 0,
	playerName = "",
	headID = 0,
	level = 0,
	killTimes = 0,
	time = 0,
	offlineTime = 0
	}).

-define(CMD_GS2U_sendEnemyInfo,14456).
-record(pk_GS2U_sendEnemyInfo,{
	info_list = []
	}).

-define(CMD_U2GS_DeleteEnemy,7997).
-record(pk_U2GS_DeleteEnemy,{
	playerID = 0
	}).

-define(CMD_U2GS_getRouletteSalary,53835).
-record(pk_U2GS_getRouletteSalary,{
	id = 0
	}).

-define(CMD_GS2U_sendRouletteSalary,64032).
-record(pk_GS2U_sendRouletteSalary,{
	id = 0,
	salIntegral = 0
	}).

-define(CMD_GS2U_WildAutoBoss,23213).
-record(pk_GS2U_WildAutoBoss,{
	bossID = 0,
	bossDataID = 0,
	bossTime = 0,
	mapDataID = 0,
	state = 0
	}).

-define(CMD_GS2U_AddExp,9140).
-record(pk_GS2U_AddExp,{
	exp = 0,
	add_multi = 0,
	reason = 0
	}).

-define(CMD_U2GS_SkillUseCount,50806).
-record(pk_U2GS_SkillUseCount,{
	objectID = 0,
	skillID = 0
	}).

-define(CMD_GS2U_SkillUseCount,32794).
-record(pk_GS2U_SkillUseCount,{
	objectID = 0,
	skillID = 0,
	useCount = 0,
	updateLastTime = 0
	}).

-define(CMD_U2GS_GetObjectPos,17945).
-record(pk_U2GS_GetObjectPos,{
	objectID = 0
	}).

-define(CMD_GS2U_ObjectPos,63032).
-record(pk_GS2U_ObjectPos,{
	objectID = 0,
	posInfo = #pk_PosInfo{}
	}).

-define(CMD_U2GS_MopupDungeonActive,22387).
-record(pk_U2GS_MopupDungeonActive,{
	dungeonID = 0,
	enterType = 0
	}).

-define(CMD_GS2U_MopupDungeonActive,12560).
-record(pk_GS2U_MopupDungeonActive,{
	dungeonID = 0,
	coinList = [],
	itemList = [],
	damageCoinList = [],
	damageItemList = [],
	isOpenNext = 0,
	result = 0
	}).

-define(CMD_U2GS_MeleeEnter,11265).
-record(pk_U2GS_MeleeEnter,{
	}).

-define(CMD_GS2U_GetItemDropShowRet,13386).
-record(pk_GS2U_GetItemDropShowRet,{
	itemList = []
	}).

-define(CMD_U2GS_getConvoyInfo,24868).
-record(pk_U2GS_getConvoyInfo,{
	}).

-define(CMD_GS2U_sendConvoyInfo,49108).
-record(pk_GS2U_sendConvoyInfo,{
	award_id = 0,
	insured = 0,
	refreshTimes = 0,
	start_time = 0,
	isBorder = 0
	}).

-define(CMD_U2GS_InsureConvoy,2040).
-record(pk_U2GS_InsureConvoy,{
	}).

-define(CMD_GS2U_InsureConvoyResult,20272).
-record(pk_GS2U_InsureConvoyResult,{
	result = 0
	}).

-define(CMD_U2GS_refreshQuality,54090).
-record(pk_U2GS_refreshQuality,{
	isMax = 0
	}).

-define(CMD_GS2U_refreshQualityResult,14847).
-record(pk_GS2U_refreshQualityResult,{
	result = 0
	}).

-define(CMD_LookInfoBuffObject,62359).
-record(pk_LookInfoBuffObject,{
	id = 0,
	dataID = 0,
	x = 0,
	y = 0
	}).

-define(CMD_GS2U_BuffObjectList,5624).
-record(pk_GS2U_BuffObjectList,{
	buffObjectList = []
	}).

-define(CMD_U2GS_UseBuffObject,63755).
-record(pk_U2GS_UseBuffObject,{
	id = 0
	}).

-define(CMD_GS2U_UseBuffObject,45568).
-record(pk_GS2U_UseBuffObject,{
	playerID = 0,
	id = 0,
	dataID = 0,
	errorCode = 0
	}).

-define(CMD_GS2U_sendRescueMsg,37).
-record(pk_GS2U_sendRescueMsg,{
	}).

-define(CMD_U2GS_getRescueList,25088).
-record(pk_U2GS_getRescueList,{
	}).

-define(CMD_rescueInfo,54007).
-record(pk_rescueInfo,{
	playerID = 0,
	name = "",
	quality = 0,
	mapdataID = 0,
	x = 0,
	y = 0,
	time = 0
	}).

-define(CMD_GS2U_sendRescueList,49328).
-record(pk_GS2U_sendRescueList,{
	rescue_list = []
	}).

-define(CMD_LookInfoVehicle,40692).
-record(pk_LookInfoVehicle,{
	id = 0,
	dataID = 0,
	x = 0,
	y = 0,
	owern_id = 0,
	name = "",
	hp = 0,
	maxHp = 0,
	group = 0,
	move_state = 0,
	guildID = 0,
	move_speed = 0,
	charState = 0,
	serverID = 0
	}).

-define(CMD_GS2U_VehicleList,27999).
-record(pk_GS2U_VehicleList,{
	info_list = []
	}).

-define(CMD_U2GS_StartConvoy,57700).
-record(pk_U2GS_StartConvoy,{
	npcID = 0,
	isBorder = 0
	}).

-define(CMD_GS2U_StartConvoyResult,50922).
-record(pk_GS2U_StartConvoyResult,{
	npcID = 0,
	startTime = 0,
	result = 0
	}).

-define(CMD_U2GS_CompleteConvoy,53234).
-record(pk_U2GS_CompleteConvoy,{
	npcID = 0
	}).

-define(CMD_GS2U_CompleteConvoyResult,34260).
-record(pk_GS2U_CompleteConvoyResult,{
	npcID = 0,
	exp = 0,
	coinList = [],
	itemList = [],
	result = 0
	}).

-define(CMD_U2GS_requestVehicleState,17275).
-record(pk_U2GS_requestVehicleState,{
	state = 0
	}).

-define(CMD_GS2U_PlayerVehicleChangeState,4869).
-record(pk_GS2U_PlayerVehicleChangeState,{
	playerID = 0,
	mapDataID = 0,
	state = 0,
	result = 0
	}).

-define(CMD_U2GS_requestRescueVehicle,19651).
-record(pk_U2GS_requestRescueVehicle,{
	targetID = 0
	}).

-define(CMD_GS2U_requestRescueVehicleResult,40949).
-record(pk_GS2U_requestRescueVehicleResult,{
	targetID = 0,
	result = 0
	}).

-define(CMD_U2GS_readyTransferVehicle,54788).
-record(pk_U2GS_readyTransferVehicle,{
	}).

-define(CMD_GS2U_readyTransferVehicleResult,7474).
-record(pk_GS2U_readyTransferVehicleResult,{
	result = 0
	}).

-define(CMD_U2GS_transferVehicle,34456).
-record(pk_U2GS_transferVehicle,{
	mapdataID = 0
	}).

-define(CMD_U2GS_GetAllTimeLimitGift,175).
-record(pk_U2GS_GetAllTimeLimitGift,{
	}).

-define(CMD_TimeLimitGift,33465).
-record(pk_TimeLimitGift,{
	giftID = 0,
	giftName = "",
	triTime = 0,
	endTime = 0,
	priceType = 0,
	oldPrice = 0,
	newPrice = 0,
	rebate = 0,
	totalPrice = 0,
	salePrice = 0,
	buyLimit = 0,
	vip = 0,
	itemCode = 0,
	eqList = [],
	itemList = [],
	coinList = [],
	buyTimes = 0
	}).

-define(CMD_GS2U_AllTimeLimitGiftRet,38145).
-record(pk_GS2U_AllTimeLimitGiftRet,{
	infoList = []
	}).

-define(CMD_GS2U_TimeLimitGiftUpdate,64196).
-record(pk_GS2U_TimeLimitGiftUpdate,{
	infoList = []
	}).

-define(CMD_U2GS_BuyTimeLimitGift,461).
-record(pk_U2GS_BuyTimeLimitGift,{
	giftID = 0
	}).

-define(CMD_GS2U_BuyTimeLimitGiftRet,41675).
-record(pk_GS2U_BuyTimeLimitGiftRet,{
	giftID = 0,
	result = 0
	}).

-define(CMD_MeleeRank,36688).
-record(pk_MeleeRank,{
	rank = 0,
	rankValue = 0,
	playerID = 0,
	playerName = "",
	guildID = 0,
	guildName = "",
	battleValue = 0,
	totalKillNum = 0,
	serverName = "",
	nationality_id = 0
	}).

-define(CMD_U2GS_MeleeRankList,4818).
-record(pk_U2GS_MeleeRankList,{
	}).

-define(CMD_GS2U_MeleeRankList,52342).
-record(pk_GS2U_MeleeRankList,{
	errorCode = 0,
	rankList = [],
	myRank = 0,
	myRankValue = 0
	}).

-define(CMD_GS2U_MeleeRankTopList,24815).
-record(pk_GS2U_MeleeRankTopList,{
	bin_fill = <<>>,
	rankList = [],
	myRank = 0,
	myRankValue = 0,
	myQuality = 0
	}).

-define(CMD_GS2U_convoyTransData,1794).
-record(pk_GS2U_convoyTransData,{
	playerID = 0,
	recMapDataID = 0,
	recNpcDataID = 0,
	recVehicleNpcID = 0,
	comMapDataID = 0,
	comNpcDataID = 0,
	comVehicleNpcID = 0,
	map_list = []
	}).

-define(CMD_U2GS_MeleeState,57597).
-record(pk_U2GS_MeleeState,{
	}).

-define(CMD_GS2U_MeleeState,26509).
-record(pk_GS2U_MeleeState,{
	state = 0,
	readyTime = 0,
	battleTime = 0,
	closeTime = 0,
	playerCount = 0,
	firstPlayer = #pk_playerModelUI{}
	}).

-define(CMD_GS2U_MeleeMapTime,29461).
-record(pk_GS2U_MeleeMapTime,{
	state = 0,
	battleTime = 0,
	closeTime = 0,
	buffTime = 0,
	collectionTime = 0,
	teleporterTime = 0,
	bossTime = 0,
	switchTime = 0,
	isBossDead = false
	}).

-define(CMD_LookInfoTeleporter,56965).
-record(pk_LookInfoTeleporter,{
	id = 0,
	dataID = 0,
	x = 0,
	y = 0,
	rotw = 0
	}).

-define(CMD_GS2U_TeleporterList,31704).
-record(pk_GS2U_TeleporterList,{
	teleporterList = []
	}).

-define(CMD_U2GS_UseTeleporter,43995).
-record(pk_U2GS_UseTeleporter,{
	id = 0
	}).

-define(CMD_GS2U_UseTeleporter,25983).
-record(pk_GS2U_UseTeleporter,{
	playerID = 0,
	id = 0,
	dataID = 0,
	errorCode = 0,
	type = 0
	}).

-define(CMD_U2GS_GetDungeonLoveInfo,6216).
-record(pk_U2GS_GetDungeonLoveInfo,{
	activeID = 0
	}).

-define(CMD_GS2U_DungeonLoveRet,31666).
-record(pk_GS2U_DungeonLoveRet,{
	fightCount = 0,
	enterCount = 0,
	indexList = [],
	dungeonID = 0,
	maxTimes = 0,
	entry_list = [],
	dropItem = [],
	item_list = [],
	drop_list = [],
	result = 0
	}).

-define(CMD_U2GS_GetDungeonLoveInviteList,60534).
-record(pk_U2GS_GetDungeonLoveInviteList,{
	activeID = 0
	}).

-define(CMD_GS2U_GetDungeonLoveInviteListRet,58828).
-record(pk_GS2U_GetDungeonLoveInviteListRet,{
	result = 0,
	friendList = [],
	guildList = []
	}).

-define(CMD_U2GS_EnterDungeonLoveRoom,54689).
-record(pk_U2GS_EnterDungeonLoveRoom,{
	activeID = 0,
	isAward = 0
	}).

-define(CMD_U2GS_getConvoyNpcInfo,1789).
-record(pk_U2GS_getConvoyNpcInfo,{
	}).

-define(CMD_GS2U_sendConvoyNpcInfo,28955).
-record(pk_GS2U_sendConvoyNpcInfo,{
	npcDataID = 0,
	x = 0,
	y = 0,
	npcDataID1 = 0,
	x1 = 0,
	y1 = 0
	}).

-define(CMD_GS2U_EnterDungeonLoveRoomRet,17638).
-record(pk_GS2U_EnterDungeonLoveRoomRet,{
	isAward = 0,
	result = 0
	}).

-define(CMD_U2GS_checkConvoyOutTime,57697).
-record(pk_U2GS_checkConvoyOutTime,{
	}).

-define(CMD_GS2U_MeleeBossResult,22216).
-record(pk_GS2U_MeleeBossResult,{
	dataID = 0,
	coinList = [],
	itemList = []
	}).

-define(CMD_ResultRank,62294).
-record(pk_ResultRank,{
	rank = 0,
	playerID = 0,
	playerName = "",
	power = 0,
	killNum = 0,
	score = 0,
	headID = 0,
	frame = 0,
	career = 0,
	serverName = "",
	nationality_id = 0,
	alive = 0
	}).

-define(CMD_GS2U_MeleeMapResult,41909).
-record(pk_GS2U_MeleeMapResult,{
	myRank = 0,
	myRankValue = 0,
	coinList = [],
	itemList = [],
	firstPlayerID = 0,
	firstPlayerName = "",
	firstServerName = "",
	firstTitleID = 0,
	resultRankList = [],
	myResultRank = #pk_ResultRank{}
	}).

-define(CMD_GS2U_MapKillNum,14629).
-record(pk_GS2U_MapKillNum,{
	killNum = 0
	}).

-define(CMD_GS2U_MountTotalProperty,30825).
-record(pk_GS2U_MountTotalProperty,{
	inspireTuple = #pk_InspireTuple{}
	}).

-define(CMD_GS2U_VehicleDisappear,21808).
-record(pk_GS2U_VehicleDisappear,{
	}).

-define(CMD_GS2U_syncMaxGetItem,38660).
-record(pk_GS2U_syncMaxGetItem,{
	}).

-define(CMD_U2GS_completeShare,2421).
-record(pk_U2GS_completeShare,{
	}).

-define(CMD_U2GS_AshuraEnter,53241).
-record(pk_U2GS_AshuraEnter,{
	type = 0
	}).

-define(CMD_U2GS_AshuraState,61919).
-record(pk_U2GS_AshuraState,{
	}).

-define(CMD_GS2U_AshuraState,7817).
-record(pk_GS2U_AshuraState,{
	state = 0,
	readyTime = 0,
	battleTime = 0,
	closeTime = 0,
	ashuraWinner = #pk_playerModelUI{},
	worldLevel = 0
	}).

-define(CMD_GS2U_AshuraMapTime,36867).
-record(pk_GS2U_AshuraMapTime,{
	state = 0,
	battleTime = 0,
	closeTime = 0,
	final_num = 0
	}).

-define(CMD_GS2U_AshuraMapScore,41015).
-record(pk_GS2U_AshuraMapScore,{
	myScore = 0,
	myKillNum = 0
	}).

-define(CMD_AshuraRank,24079).
-record(pk_AshuraRank,{
	rank = 0,
	rankValue = 0,
	playerID = 0,
	playerName = "",
	guildID = 0,
	guildName = "",
	battleValue = 0,
	totalKillNum = 0,
	totalLiveTime = 0,
	serverName = "",
	nationality_id = 0,
	head_id = 0,
	frame_id = 0,
	alive = 0
	}).

-define(CMD_GS2U_AshuraSampleRankList,59445).
-record(pk_GS2U_AshuraSampleRankList,{
	rank_list = []
	}).

-define(CMD_GS2U_AshuraMainAliveNum,23480).
-record(pk_GS2U_AshuraMainAliveNum,{
	num = 0
	}).

-define(CMD_GS2U_AshuraKillInfo,21524).
-record(pk_GS2U_AshuraKillInfo,{
	name1 = "",
	serverName1 = "",
	name2 = "",
	serverName2 = ""
	}).

-define(CMD_U2GS_AshuraRankList,32523).
-record(pk_U2GS_AshuraRankList,{
	}).

-define(CMD_GS2U_AshuraRankList,9715).
-record(pk_GS2U_AshuraRankList,{
	rankList = [],
	myRank = 0,
	myRankValue = 0,
	myTotalLiveTime = 0
	}).

-define(CMD_GS2U_AshuraMapResult,28035).
-record(pk_GS2U_AshuraMapResult,{
	totalScore = 0,
	coinList = [],
	itemList = [],
	winnerPlayerID = 0,
	winnerPlayerName = "",
	winnerTitleID = 0,
	resultRankList = [],
	myResultRank = #pk_ResultRank{},
	serverName = ""
	}).

-define(CMD_GS2U_AshuraGroupResult,49081).
-record(pk_GS2U_AshuraGroupResult,{
	totalScore = 0,
	coinList = [],
	itemList = [],
	winnerPlayerID = 0,
	winnerPlayerName = "",
	winnerTitleID = 0,
	resultRankList = [],
	myResultRank = #pk_ResultRank{},
	serverName = "",
	final_num = 0
	}).

-define(CMD_GS2U_AshuraFailResult,53751).
-record(pk_GS2U_AshuraFailResult,{
	totalScore = 0,
	coinList = [],
	itemList = []
	}).

-define(CMD_U2GS_AshuraView,30169).
-record(pk_U2GS_AshuraView,{
	}).

-define(CMD_GS2U_AshuraView,21866).
-record(pk_GS2U_AshuraView,{
	errorCode = 0
	}).

-define(CMD_GS2U_AshuraDeathNum,7601).
-record(pk_GS2U_AshuraDeathNum,{
	deathNum = 0
	}).

-define(CMD_AshuraAchieve,33528).
-record(pk_AshuraAchieve,{
	winNum = 0,
	totalKillNum = 0,
	totalNum1 = 0,
	totalScore1 = 0,
	totalKillNum1 = 0,
	killNum1 = 0,
	totalNum2 = 0,
	totalScore2 = 0,
	totalKillNum2 = 0,
	killNum2 = 0
	}).

-define(CMD_GS2U_AshuraAchieveInfo,33203).
-record(pk_GS2U_AshuraAchieveInfo,{
	achieve = #pk_AshuraAchieve{},
	finishList = []
	}).

-define(CMD_GS2U_AshuraAchieveUpdate,7269).
-record(pk_GS2U_AshuraAchieveUpdate,{
	achieve = #pk_AshuraAchieve{}
	}).

-define(CMD_U2GS_AshuraAchieveFinish,24598).
-record(pk_U2GS_AshuraAchieveFinish,{
	index = []
	}).

-define(CMD_GS2U_AshuraAchieveFinish,20901).
-record(pk_GS2U_AshuraAchieveFinish,{
	index = [],
	errorCode = 0
	}).

-define(CMD_U2GS_AshuraEnterNextMap,50881).
-record(pk_U2GS_AshuraEnterNextMap,{
	}).

-define(CMD_GS2U_AshuraEnterNextMapRet,26542).
-record(pk_GS2U_AshuraEnterNextMapRet,{
	errorCode = 0
	}).

-define(CMD_U2GS_GetCroFightRingInfo,60811).
-record(pk_U2GS_GetCroFightRingInfo,{
	isInvite = 0
	}).

-define(CMD_GS2U_GetCroFightRingRet,54072).
-record(pk_GS2U_GetCroFightRingRet,{
	season = 0,
	seasonStartTime = 0,
	seasonEndTime = 0,
	officeType = 0,
	office = 0,
	score = 0,
	fightCount = 0,
	retrieveCount = 0,
	retrieveHistory = 0,
	buyHistory = 0,
	rank = 0
	}).

-define(CMD_U2GS_GetCroFightRingInviteList,34823).
-record(pk_U2GS_GetCroFightRingInviteList,{
	}).

-define(CMD_GS2U_GetCroFightRingInviteListRet,51354).
-record(pk_GS2U_GetCroFightRingInviteListRet,{
	result = 0,
	friendList = [],
	guildList = []
	}).

-define(CMD_U2GS_CroFightRingInvite,58964).
-record(pk_U2GS_CroFightRingInvite,{
	opType = 0,
	playerIDList = []
	}).

-define(CMD_GS2U_CroFightRingInviteInfo,12497).
-record(pk_GS2U_CroFightRingInviteInfo,{
	roomID = 0,
	playerID = 0,
	invitePlayerName = "",
	career = 0,
	fateLevel = 0,
	enterCount = 0,
	headID = 0,
	level = 0,
	battleValue = 0,
	vip = 0
	}).

-define(CMD_U2GS_ChangeCroFightRingMatchState,48238).
-record(pk_U2GS_ChangeCroFightRingMatchState,{
	state = 0
	}).

-define(CMD_GS2U_ChangeCroFightRingMatchStateRet,19937).
-record(pk_GS2U_ChangeCroFightRingMatchStateRet,{
	result = 0,
	state = 0
	}).

-define(CMD_GS2U_CroFightRingMapState,7450).
-record(pk_GS2U_CroFightRingMapState,{
	state = 0,
	time = 0
	}).

-define(CMD_CroFightRingScore,60921).
-record(pk_CroFightRingScore,{
	groupID = 0,
	score = 0,
	killNum = 0
	}).

-define(CMD_GS2U_CroFightRingScore,1239).
-record(pk_GS2U_CroFightRingScore,{
	infoList = []
	}).

-define(CMD_CroFightRingArea,21945).
-record(pk_CroFightRingArea,{
	dataID = 0,
	groupID = 0,
	progressGroupID = 0,
	progress = 0
	}).

-define(CMD_GS2U_CroFightRingArea,47022).
-record(pk_GS2U_CroFightRingArea,{
	infoList = []
	}).

-define(CMD_U2GS_HeroDrawAddAward,3090).
-record(pk_U2GS_HeroDrawAddAward,{
	data_id = 0,
	index = 0,
	choice = 0
	}).

-define(CMD_GS2U_HeroDrawAddAward,44524).
-record(pk_GS2U_HeroDrawAddAward,{
	data_id = 0,
	draw_list = [],
	errorCode = 0
	}).

-define(CMD_U2GS_BattleTopRank,24566).
-record(pk_U2GS_BattleTopRank,{
	type = 0
	}).

-define(CMD_U2GS_GetCroFightRingReport,10476).
-record(pk_U2GS_GetCroFightRingReport,{
	time = 0
	}).

-define(CMD_CroFightRingReportPlayer,37588).
-record(pk_CroFightRingReportPlayer,{
	playerID = 0,
	name = "",
	vip = 0,
	career = 0,
	level = 0,
	headID = 0,
	serverID = 0,
	battleValue = 0,
	heroList = [],
	killNum = 0,
	deadNum = 0,
	fateLevel = 0,
	officeType = 0,
	office = 0,
	sex = 0
	}).

-define(CMD_CroFightRingGroup,50970).
-record(pk_CroFightRingGroup,{
	groupID = 0,
	score = 0,
	playerList = []
	}).

-define(CMD_GS2U_GetCroFightRingReportRet,38640).
-record(pk_GS2U_GetCroFightRingReportRet,{
	winGroupID = 0,
	mvpPlayerID = 0,
	groupList = []
	}).

-define(CMD_GS2U_CroFightRingSettle,4892).
-record(pk_GS2U_CroFightRingSettle,{
	winGroupID = 0,
	mvpPlayerID = 0,
	groupList = [],
	score = 0
	}).

-define(CMD_U2GS_GetCroFightRingAttainment,25815).
-record(pk_U2GS_GetCroFightRingAttainment,{
	}).

-define(CMD_CroFightRingAttainment,31994).
-record(pk_CroFightRingAttainment,{
	attainmentDataID = 0,
	value = 0,
	isAward = 0,
	value2 = 0
	}).

-define(CMD_GS2U_CroFightRingAttainmentRet,39998).
-record(pk_GS2U_CroFightRingAttainmentRet,{
	infoList = []
	}).

-define(CMD_GS2U_CroFightRingAttainmentRed,1137).
-record(pk_GS2U_CroFightRingAttainmentRed,{
	}).

-define(CMD_U2GS_GainCroFightRingAttainment,36987).
-record(pk_U2GS_GainCroFightRingAttainment,{
	attainmentDataID = 0
	}).

-define(CMD_GS2U_GainCroFightRingAttainmentRet,31388).
-record(pk_GS2U_GainCroFightRingAttainmentRet,{
	result = 0,
	attainmentDataID = 0
	}).

-define(CMD_GS2U_WingTotalProperty,45388).
-record(pk_GS2U_WingTotalProperty,{
	inspireTuple = #pk_InspireTuple{}
	}).

-define(CMD_GS2U_SpiritTotalProperty,64752).
-record(pk_GS2U_SpiritTotalProperty,{
	inspireTuple = #pk_InspireTuple{}
	}).

-define(CMD_GS2U_CroFightRingOfficeChange,36616).
-record(pk_GS2U_CroFightRingOfficeChange,{
	oldOfficeType = 0,
	oldOffice = 0,
	officeType = 0,
	office = 0
	}).

-define(CMD_U2GS_CroFightRingRecord,36163).
-record(pk_U2GS_CroFightRingRecord,{
	}).

-define(CMD_CroFightRingInfo,43042).
-record(pk_CroFightRingInfo,{
	time = 0,
	isWin = 0
	}).

-define(CMD_GS2U_CroFightRingRecordRet,50367).
-record(pk_GS2U_CroFightRingRecordRet,{
	recordList = []
	}).

-define(CMD_GS2U_UnfinishBattle,13458).
-record(pk_GS2U_UnfinishBattle,{
	mapAi = 0
	}).

-define(CMD_U2GS_DealUnfinishBattle,11636).
-record(pk_U2GS_DealUnfinishBattle,{
	dealType = 0,
	mapAi = 0
	}).

-define(CMD_U2GS_CroFightRingInOutArea,60871).
-record(pk_U2GS_CroFightRingInOutArea,{
	dataID = 0,
	type = 0
	}).

-define(CMD_U2GS_ArenaDirectWin,22783).
-record(pk_U2GS_ArenaDirectWin,{
	rankNumber = 0
	}).

-define(CMD_GS2U_ArenaDirectWinRet,51503).
-record(pk_GS2U_ArenaDirectWinRet,{
	result = 0,
	rankNumber = 0
	}).

-define(CMD_U2GS_peltDarts,59704).
-record(pk_U2GS_peltDarts,{
	id = 0,
	type = 0
	}).

-define(CMD_GS2U_peltDartsResult,52061).
-record(pk_GS2U_peltDartsResult,{
	id = 0,
	type = 0,
	ring = 0,
	result = 0
	}).

-define(CMD_U2GS_getDartsPoint,20656).
-record(pk_U2GS_getDartsPoint,{
	id = 0
	}).

-define(CMD_GS2U_getDartsPointResult,57911).
-record(pk_GS2U_getDartsPointResult,{
	id = 0,
	result = 0
	}).

-define(CMD_U2GS_exchangeDartsItem,61278).
-record(pk_U2GS_exchangeDartsItem,{
	id = 0,
	index = 0,
	times = 0
	}).

-define(CMD_GS2U_exchagneDartsItemResult,55968).
-record(pk_GS2U_exchagneDartsItemResult,{
	id = 0,
	index = 0,
	changeIntegral = 0,
	result = 0
	}).

-define(CMD_U2GS_getDayPoints,43851).
-record(pk_U2GS_getDayPoints,{
	id = 0
	}).

-define(CMD_GS2U_getDayPointsResult,45404).
-record(pk_GS2U_getDayPointsResult,{
	id = 0,
	point = 0,
	result = 0
	}).

-define(CMD_GS2U_SutraTotalProperty,17937).
-record(pk_GS2U_SutraTotalProperty,{
	inspireTuple = #pk_InspireTuple{}
	}).

-define(CMD_U2GS_activeDarts,41687).
-record(pk_U2GS_activeDarts,{
	id = 0,
	type = 0,
	level = 0
	}).

-define(CMD_GS2U_activeDartsResult,22229).
-record(pk_GS2U_activeDartsResult,{
	id = 0,
	type = 0,
	level = 0,
	result = 0
	}).

-define(CMD_GS2U_MonsterTalk,56968).
-record(pk_GS2U_MonsterTalk,{
	id = 0,
	talkIDList = []
	}).

-define(CMD_GS2U_MonsterProgress,14094).
-record(pk_GS2U_MonsterProgress,{
	id = 0,
	type = 0,
	param1 = 0,
	param2 = 0
	}).

-define(CMD_GS2U_MonsterProgressSuccess,36184).
-record(pk_GS2U_MonsterProgressSuccess,{
	id = 0,
	type = 0,
	param1 = 0,
	param2 = 0
	}).

-define(CMD_GS2U_MonsterProgressFailure,11418).
-record(pk_GS2U_MonsterProgressFailure,{
	id = 0,
	type = 0,
	param1 = 0,
	param2 = 0
	}).

-define(CMD_GS2U_MonsterPlayAdd,17876).
-record(pk_GS2U_MonsterPlayAdd,{
	playID = 0,
	param1 = 0,
	param2 = 0
	}).

-define(CMD_GS2U_MonsterPlayRemove,44872).
-record(pk_GS2U_MonsterPlayRemove,{
	playID = 0
	}).

-define(CMD_GS2U_MonsterPlayUpdate,57220).
-record(pk_GS2U_MonsterPlayUpdate,{
	playID = 0,
	param1 = 0,
	param2 = 0
	}).

-define(CMD_U2GS_ShowInfoMark,34126).
-record(pk_U2GS_ShowInfoMark,{
	mask = 0
	}).

-define(CMD_GS2U_ShowInfoMark,63312).
-record(pk_GS2U_ShowInfoMark,{
	}).

-define(CMD_U2GS_updateMapSutra,44768).
-record(pk_U2GS_updateMapSutra,{
	playerID = 0,
	cur_data_id = 0
	}).

-define(CMD_playerMapSutra,39137).
-record(pk_playerMapSutra,{
	playerID = 0,
	cur_data_id = 0
	}).

-define(CMD_GS2U_syncPlayerMapSutra,46247).
-record(pk_GS2U_syncPlayerMapSutra,{
	sutra_list = []
	}).

-define(CMD_GS2U_MonsterPlayTips,18209).
-record(pk_GS2U_MonsterPlayTips,{
	tipsID = 0,
	param1 = 0,
	param2 = 0
	}).

-define(CMD_U2GS_CrofightRingRetrieve,40954).
-record(pk_U2GS_CrofightRingRetrieve,{
	retrieveCount = 0
	}).

-define(CMD_GS2U_CrofightRingRetrieveRet,31355).
-record(pk_GS2U_CrofightRingRetrieveRet,{
	result = 0,
	retrieveHistory = 0
	}).

-define(CMD_GS2U_EquipTotalProperty,63786).
-record(pk_GS2U_EquipTotalProperty,{
	inspireTuple = #pk_InspireTuple{}
	}).

-define(CMD_U2GS_RoomStateChange,17441).
-record(pk_U2GS_RoomStateChange,{
	state = 0
	}).

-define(CMD_GS2U_RoomStateChangeNotify,64960).
-record(pk_GS2U_RoomStateChangeNotify,{
	state = 0,
	mapAi = 0
	}).

-define(CMD_GS2U_MonsterDisappear,25609).
-record(pk_GS2U_MonsterDisappear,{
	id = 0,
	param = 0
	}).

-define(CMD_GS2U_MapGainNotify,32196).
-record(pk_GS2U_MapGainNotify,{
	notice = []
	}).

-define(CMD_GenItem,52023).
-record(pk_GenItem,{
	key = 0,
	value = 0
	}).

-define(CMD_GS2U_GenInviteNotice,11679).
-record(pk_GS2U_GenInviteNotice,{
	fromid = 0,
	fateLevel = 0,
	career = 0,
	battleValue = 0,
	headID = 0,
	frame = 0,
	level = 0,
	vip = 0,
	type = 0,
	time_out = 0,
	fromName = "",
	info = [],
	message = ""
	}).

-define(CMD_U2GS_GenInviteNoticeReply,56894).
-record(pk_U2GS_GenInviteNoticeReply,{
	fromid = 0,
	type = 0,
	reply = 0
	}).

-define(CMD_GS2U_GenInviteNoticeReplyRet,60894).
-record(pk_GS2U_GenInviteNoticeReplyRet,{
	errorCode = 0,
	type = 0
	}).

-define(CMD_U2GS_RequestFriendsCanTrystTimes,60785).
-record(pk_U2GS_RequestFriendsCanTrystTimes,{
	}).

-define(CMD_PlayerTrystTimes,29040).
-record(pk_PlayerTrystTimes,{
	playerID = 0,
	playerName = "",
	times = 0
	}).

-define(CMD_GS2U_RequestFriendsCanTrystTimesRet,25713).
-record(pk_GS2U_RequestFriendsCanTrystTimesRet,{
	timesList = []
	}).

-define(CMD_U2GS_RequestTryst,2491).
-record(pk_U2GS_RequestTryst,{
	roleidList = [],
	trystType = 0
	}).

-define(CMD_GS2U_RequestTrystRet,60074).
-record(pk_GS2U_RequestTrystRet,{
	errorCode = 0,
	trystType = 0,
	fromid = 0,
	fromName = ""
	}).

-define(CMD_U2GS_IntimacyAddByTryst,30071).
-record(pk_U2GS_IntimacyAddByTryst,{
	addType = 0,
	param = 0
	}).

-define(CMD_GS2U_IntimacyAddByTrystRet,65276).
-record(pk_GS2U_IntimacyAddByTrystRet,{
	errorCode = 0,
	addType = 0,
	param = 0,
	sourcePlayerID = 0,
	intimacy = 0
	}).

-define(CMD_U2GS_RequestEngage,38319).
-record(pk_U2GS_RequestEngage,{
	roleid = 0,
	broadcastType = 0,
	sweet = ""
	}).

-define(CMD_GS2U_RequestEngageRet,325).
-record(pk_GS2U_RequestEngageRet,{
	errorCode = 0,
	timestamp = 0,
	sweet = ""
	}).

-define(CMD_GS2U_EngageInfo,20743).
-record(pk_GS2U_EngageInfo,{
	playerName = "",
	timestamp = 0,
	sweet = ""
	}).

-define(CMD_GS2U_CeremonyNotity,6513).
-record(pk_GS2U_CeremonyNotity,{
	playerNameA = "",
	playerNameB = ""
	}).

-define(CMD_U2GS_RequestEnterCeremonyMap,49942).
-record(pk_U2GS_RequestEnterCeremonyMap,{
	}).

-define(CMD_GS2U_RequestEnterCeremonyMapRet,60292).
-record(pk_GS2U_RequestEnterCeremonyMapRet,{
	errorCode = 0,
	type = 0,
	time = 0
	}).

-define(CMD_U2GS_TrystEnter,52567).
-record(pk_U2GS_TrystEnter,{
	trystType = 0
	}).

-define(CMD_U2GS_WeddingInviteAsk,52555).
-record(pk_U2GS_WeddingInviteAsk,{
	playerID = 0
	}).

-define(CMD_GS2U_WeddingInviteAsk,28453).
-record(pk_GS2U_WeddingInviteAsk,{
	errorCode = 0
	}).

-define(CMD_GS2U_WeddingInviteAskNotify,35574).
-record(pk_GS2U_WeddingInviteAskNotify,{
	}).

-define(CMD_WeddingInvite,24348).
-record(pk_WeddingInvite,{
	playerID = 0,
	name = "",
	career = 0,
	level = 0,
	fateLevel = 0,
	battleValue = 0,
	vip = 0,
	guildName = "",
	guildRank = 0,
	headID = 0,
	frame = 0,
	guildID = 0,
	sex = 0,
	isOnline = false,
	intimacyLevel = 0,
	intimacy = 0,
	isInvited = false
	}).

-define(CMD_U2GS_WeddingInviteList,19624).
-record(pk_U2GS_WeddingInviteList,{
	}).

-define(CMD_GS2U_WeddingInviteList,32227).
-record(pk_GS2U_WeddingInviteList,{
	errorCode = 0,
	friendsInviteList = [],
	guildInviteList = [],
	askInviteList = [],
	isRejectAsk = false
	}).

-define(CMD_U2GS_WeddingInviteSend,49462).
-record(pk_U2GS_WeddingInviteSend,{
	playerIDList = []
	}).

-define(CMD_GS2U_WeddingInviteSend,62065).
-record(pk_GS2U_WeddingInviteSend,{
	errorCode = 0,
	playerIDList = []
	}).

-define(CMD_GS2U_WeddingInviteSendNotify,8962).
-record(pk_GS2U_WeddingInviteSendNotify,{
	ceremonyTime = 0,
	playerID1 = 0,
	name1 = "",
	sex1 = 0,
	career1 = 0,
	playerID2 = 0,
	name2 = "",
	sex2 = 0,
	career2 = 0,
	isMarryNotify = false
	}).

-define(CMD_U2GS_WeddingInviteReceive,28864).
-record(pk_U2GS_WeddingInviteReceive,{
	playerID = 0
	}).

-define(CMD_playerCareer,58574).
-record(pk_playerCareer,{
	playerID = 0,
	career = 0
	}).

-define(CMD_U2GS_getWeddingLookInfo,18605).
-record(pk_U2GS_getWeddingLookInfo,{
	player_list = []
	}).

-define(CMD_weddingLookInfo,15453).
-record(pk_weddingLookInfo,{
	playerId = 0,
	career = 0,
	ponchoLevel = 0,
	fashionCfgIDList = [],
	equipCfgIDList = [],
	intensityLvList = [],
	suitChara = 0,
	suitLevel = 0,
	suitQuality = 0,
	wingCfgID = 0
	}).

-define(CMD_GS2U_sendWeddingLookInfo,46458).
-record(pk_GS2U_sendWeddingLookInfo,{
	info_list = []
	}).

-define(CMD_GS2U_WeddingInfo,11957).
-record(pk_GS2U_WeddingInfo,{
	state = 0,
	otherPlayerID = 0,
	otherPlayerName = "",
	otherPlayerSex = 0,
	ceremonyType = 0,
	ceremonyBeginTime = 0,
	ceremonyEndTime = 0
	}).

-define(CMD_formation,13548).
-record(pk_formation,{
	objectID = 0,
	dataID = 0
	}).

-define(CMD_GS2U_sendCruiseInfo,24337).
-record(pk_GS2U_sendCruiseInfo,{
	bridegroomID = 0,
	brideID = 0,
	bride_object_id = 0,
	cruise_id = 0,
	x = 0,
	y = 0,
	way_point = 0,
	mapIndex = 0,
	ox_list = [],
	npc_list = []
	}).

-define(CMD_RingCastPropInfo,12078).
-record(pk_RingCastPropInfo,{
	index = 0,
	propID = 0,
	level = 0
	}).

-define(CMD_RingInfo,39942).
-record(pk_RingInfo,{
	ringID = 0,
	level = 0,
	star = 0,
	break_lv = 0,
	rein_lv = 0,
	partnerLevel = 0,
	partnerStar = 0,
	level_prop_max = 0,
	star_prop_max = 0
	}).

-define(CMD_GS2U_RingList,12257).
-record(pk_GS2U_RingList,{
	ringList = []
	}).

-define(CMD_GS2U_RingAdd,38689).
-record(pk_GS2U_RingAdd,{
	errorCode = 0,
	active_type = 0,
	ringList = []
	}).

-define(CMD_U2GS_RingCast,53187).
-record(pk_U2GS_RingCast,{
	ringID = 0
	}).

-define(CMD_U2GS_RingCastReplace,8064).
-record(pk_U2GS_RingCastReplace,{
	ringID = 0,
	propList = []
	}).

-define(CMD_GS2U_RingRet,35986).
-record(pk_GS2U_RingRet,{
	type = 0,
	errorCode = 0,
	ringInfo = #pk_RingInfo{}
	}).

-define(CMD_U2GS_RingSoulAdd,52590).
-record(pk_U2GS_RingSoulAdd,{
	addLevel = 0
	}).

-define(CMD_GS2U_RingSoulAddRet,9977).
-record(pk_GS2U_RingSoulAddRet,{
	errorCode = 0,
	addLevel = 0
	}).

-define(CMD_GS2U_WeddingEngageNotify,63149).
-record(pk_GS2U_WeddingEngageNotify,{
	errorCode = 0,
	state = 0
	}).

-define(CMD_GS2U_TrystStart,33367).
-record(pk_GS2U_TrystStart,{
	timestamp = 0
	}).

-define(CMD_U2GS_TrystStart,6618).
-record(pk_U2GS_TrystStart,{
	}).

-define(CMD_U2GS_syncCruiseWayPoint,50751).
-record(pk_U2GS_syncCruiseWayPoint,{
	wayPoint = 0,
	length = 0
	}).

-define(CMD_U2GS_readyTransCruise,8725).
-record(pk_U2GS_readyTransCruise,{
	}).

-define(CMD_GS2U_readyTransCruiseResult,18563).
-record(pk_GS2U_readyTransCruiseResult,{
	result = 0
	}).

-define(CMD_GS2U_GenErrorNotify,12768).
-record(pk_GS2U_GenErrorNotify,{
	errorCode = 0,
	msgid = 0
	}).

-define(CMD_U2GS_DivorceAgreement,43361).
-record(pk_U2GS_DivorceAgreement,{
	type = 0
	}).

-define(CMD_GS2U_DivorceAgreementRet,12706).
-record(pk_GS2U_DivorceAgreementRet,{
	errorCode = 0,
	state = 0
	}).

-define(CMD_GS2U_WeddingMarryMapInfo,26907).
-record(pk_GS2U_WeddingMarryMapInfo,{
	state = 0,
	waitingTime = 0,
	confirmTime = 0,
	marryTime = 0,
	feastTime = 0,
	leaveTime = 0,
	playerID1 = 0,
	isConfirm1 = false,
	playerID2 = 0,
	isConfirm2 = false
	}).

-define(CMD_U2GS_WeddingMarryConfirm,58778).
-record(pk_U2GS_WeddingMarryConfirm,{
	}).

-define(CMD_GS2U_WeddingMarryConfirm,55081).
-record(pk_GS2U_WeddingMarryConfirm,{
	errorCode = 0
	}).

-define(CMD_U2GS_getMerryRecord,1356).
-record(pk_U2GS_getMerryRecord,{
	}).

-define(CMD_merryRecord,2745).
-record(pk_merryRecord,{
	index = 0,
	bridegroomID = 0,
	bridegroomName = "",
	bridegroomFateLeve = 0,
	brideID = 0,
	bridegName = "",
	brideFateLeve = 0,
	type = 0,
	time = 0
	}).

-define(CMD_GS2U_sendMerryRecord,25355).
-record(pk_GS2U_sendMerryRecord,{
	selfRecord = #pk_merryRecord{},
	rercord_list = [],
	last_list = []
	}).

-define(CMD_U2GS_getReservationRecord,39808).
-record(pk_U2GS_getReservationRecord,{
	}).

-define(CMD_reservation,48570).
-record(pk_reservation,{
	bridegroomID = 0,
	bridegroomFateLeve = 0,
	bridegroomName = "",
	brideID = 0,
	brideFateLeve = 0,
	bridegName = "",
	type = 0,
	resTime = 0,
	orTime = 0,
	isBless = 0,
	isRequest = 0
	}).

-define(CMD_GS2U_sendReservationRecord,47295).
-record(pk_GS2U_sendReservationRecord,{
	res_list = []
	}).

-define(CMD_U2GS_getWeddingRecord,32308).
-record(pk_U2GS_getWeddingRecord,{
	}).

-define(CMD_weddingGiftRank,43498).
-record(pk_weddingGiftRank,{
	targetID = 0,
	name = "",
	fateLevel = 0,
	rank = 0,
	giftNum = 0,
	totalValue = 0
	}).

-define(CMD_weddingRecord,20403).
-record(pk_weddingRecord,{
	time = 0,
	targetID = 0,
	name = "",
	fateLevel = 0,
	type = 0,
	packetNum = 0,
	goldNum = 0,
	giftNum = 0,
	totalValue = 0,
	rank_list = []
	}).

-define(CMD_GS2U_sendWeddingRecord,59474).
-record(pk_GS2U_sendWeddingRecord,{
	wedding_list = []
	}).

-define(CMD_U2GS_getMarriageInfo,25150).
-record(pk_U2GS_getMarriageInfo,{
	}).

-define(CMD_marriage,17222).
-record(pk_marriage,{
	time = 0,
	type = 0,
	targetID = 0,
	name = "",
	fateLevel = 0,
	param_list = [],
	extra_param = ""
	}).

-define(CMD_GS2U_sendMarriageInfo,16714).
-record(pk_GS2U_sendMarriageInfo,{
	marriage_list = []
	}).

-define(CMD_GS2U_DatingIntimacyMax,65309).
-record(pk_GS2U_DatingIntimacyMax,{
	}).

-define(CMD_U2GS_FinishTryst,4985).
-record(pk_U2GS_FinishTryst,{
	}).

-define(CMD_GS2U_TrystFinish,21479).
-record(pk_GS2U_TrystFinish,{
	type = 0
	}).

-define(CMD_WeddingOrder,15932).
-record(pk_WeddingOrder,{
	beginTime = 0,
	number = 0,
	playerID1 = 0,
	playerName1 = "",
	playerID2 = 0,
	playerName2 = "",
	orderTime = 0
	}).

-define(CMD_U2GS_WeddingOrderList,43005).
-record(pk_U2GS_WeddingOrderList,{
	type = 0
	}).

-define(CMD_GS2U_WeddingOrderList,18729).
-record(pk_GS2U_WeddingOrderList,{
	errorCode = 0,
	orderList = []
	}).

-define(CMD_U2GS_WeddingOrderApply,20155).
-record(pk_U2GS_WeddingOrderApply,{
	beginTime = 0,
	number = 0
	}).

-define(CMD_GS2U_WeddingOrderApply,32758).
-record(pk_GS2U_WeddingOrderApply,{
	beginTime = 0,
	number = 0,
	errorCode = 0
	}).

-define(CMD_U2GS_WeddingOrderModify,47828).
-record(pk_U2GS_WeddingOrderModify,{
	beginTime = 0,
	number = 0
	}).

-define(CMD_GS2U_WeddingOrderModify,38176).
-record(pk_GS2U_WeddingOrderModify,{
	beginTime = 0,
	number = 0,
	errorCode = 0
	}).

-define(CMD_WeddingRoomPlayer,23797).
-record(pk_WeddingRoomPlayer,{
	playerID = 0,
	name = "",
	career = 0,
	level = 0,
	headID = 0,
	fateLevel = 0,
	battleValue = 0,
	ponchoLevel = 0,
	wingCfgID = 0,
	titleID = 0,
	suitChara = 0,
	suitLevel = 0,
	suitQuality = 0,
	equipCfgIDList = [],
	fashionCfgIDList = [],
	careerList = [],
	useCareer = 0,
	dungeonID = 0,
	isDungeonPass = false,
	count = 0,
	isUseCount = false
	}).

-define(CMD_WeddingRoom,47812).
-record(pk_WeddingRoom,{
	masterPlayerID = 0,
	dungeonID = 0,
	playerList = []
	}).

-define(CMD_GS2U_WeddingRoomUpdate,63073).
-record(pk_GS2U_WeddingRoomUpdate,{
	room = #pk_WeddingRoom{}
	}).

-define(CMD_GS2U_WeddingRoomDestroy,12623).
-record(pk_GS2U_WeddingRoomDestroy,{
	}).

-define(CMD_U2GS_WeddingRoomEnter,11363).
-record(pk_U2GS_WeddingRoomEnter,{
	}).

-define(CMD_GS2U_WeddingRoomUseCount,14695).
-record(pk_GS2U_WeddingRoomUseCount,{
	errorCode = 0
	}).

-define(CMD_GS2U_WeddingRoomUseCareer,53328).
-record(pk_GS2U_WeddingRoomUseCareer,{
	errorCode = 0
	}).

-define(CMD_GS2U_WeddingRoomUseDungeon,32141).
-record(pk_GS2U_WeddingRoomUseDungeon,{
	errorCode = 0
	}).

-define(CMD_U2GS_sendDanmaku,30683).
-record(pk_U2GS_sendDanmaku,{
	channelID = 0,
	colorLevel = 0,
	content = ""
	}).

-define(CMD_danmakuInfo,3036).
-record(pk_danmakuInfo,{
	channelID = 0,
	playerID = 0,
	name = "",
	career = 0,
	headID = 0,
	frame = 0,
	type = 0,
	title_list = [],
	colorLevel = 0,
	content = ""
	}).

-define(CMD_GS2U_syncDanmaku,61141).
-record(pk_GS2U_syncDanmaku,{
	danmaku_list = []
	}).

-define(CMD_U2GS_getDanmakuChannel,37025).
-record(pk_U2GS_getDanmakuChannel,{
	}).

-define(CMD_danmakuChannel,2511).
-record(pk_danmakuChannel,{
	id = 0,
	type = 0,
	owner = []
	}).

-define(CMD_GS2U_sendDanmakuChannel,47222).
-record(pk_GS2U_sendDanmakuChannel,{
	channel_list = []
	}).

-define(CMD_U2GS_requestEnterChannel,54952).
-record(pk_U2GS_requestEnterChannel,{
	id = 0
	}).

-define(CMD_GS2U_requestEnterChannelResult,1739).
-record(pk_GS2U_requestEnterChannelResult,{
	id = 0,
	result = 0
	}).

-define(CMD_U2GS_requestExitChannel,41914).
-record(pk_U2GS_requestExitChannel,{
	id = 0
	}).

-define(CMD_GS2U_requestExitChannelResult,37034).
-record(pk_GS2U_requestExitChannelResult,{
	id = 0,
	result = 0
	}).

-define(CMD_GS2U_sendDanmakuResult,44920).
-record(pk_GS2U_sendDanmakuResult,{
	channelID = 0,
	colorLevel = 0,
	result = 0
	}).

-define(CMD_GS2U_OnPartnerRingLevelUp,31993).
-record(pk_GS2U_OnPartnerRingLevelUp,{
	partnerID = 0,
	ringID = 0,
	ringLevel = 0,
	level_prop_max = 0
	}).

-define(CMD_GS2U_OnPartnerRingStarUp,39107).
-record(pk_GS2U_OnPartnerRingStarUp,{
	partnerID = 0,
	ringID = 0,
	ringStar = 0,
	star_prop_max = 0
	}).

-define(CMD_U2GS_present,59152).
-record(pk_U2GS_present,{
	id = 0,
	giftID = 0,
	count = 0
	}).

-define(CMD_GS2U_presentResult,43364).
-record(pk_GS2U_presentResult,{
	id = 0,
	giftID = 0,
	count = 0,
	result = 0
	}).

-define(CMD_GS2U_sendPresentInfo,11733).
-record(pk_GS2U_sendPresentInfo,{
	giftID = 0,
	id = 0,
	tycoonName = "",
	career = 0,
	headID = 0,
	frame = 0,
	times = 0,
	curTimes = 0,
	content = ""
	}).

-define(CMD_GS2U_broadcastWayPoint,22595).
-record(pk_GS2U_broadcastWayPoint,{
	objectID = 0,
	wayPoint = 0,
	length = 0
	}).

-define(CMD_WeddingInviteReceive,39212).
-record(pk_WeddingInviteReceive,{
	ceremonyTime = 0,
	playerID1 = 0,
	name1 = "",
	sex1 = 0,
	career1 = 0,
	playerID2 = 0,
	name2 = "",
	sex2 = 0,
	career2 = 0
	}).

-define(CMD_U2GS_WeddingInviteReceiveList,17539).
-record(pk_U2GS_WeddingInviteReceiveList,{
	}).

-define(CMD_GS2U_WeddingInviteReceiveList,12773).
-record(pk_GS2U_WeddingInviteReceiveList,{
	inviteReceiveList = []
	}).

-define(CMD_GS2U_AshuraAliveCount,53556).
-record(pk_GS2U_AshuraAliveCount,{
	playerCount = 0
	}).

-define(CMD_GS2U_AshuraStateSync,37539).
-record(pk_GS2U_AshuraStateSync,{
	state = 0,
	start_time = 0
	}).

-define(CMD_GS2U_SyncLoveTaskStep,41030).
-record(pk_GS2U_SyncLoveTaskStep,{
	step = 0
	}).

-define(CMD_U2GS_SubmitLoveTask,21570).
-record(pk_U2GS_SubmitLoveTask,{
	step = 0
	}).

-define(CMD_GS2U_SubmitLoveTaskRet,28865).
-record(pk_GS2U_SubmitLoveTaskRet,{
	errorCode = 0,
	type = 0,
	step = 0
	}).

-define(CMD_GS2U_DivorceNotify,14941).
-record(pk_GS2U_DivorceNotify,{
	type = 0,
	playerid = 0,
	name = ""
	}).

-define(CMD_U2GS_DivorceNotifyConfirm,18924).
-record(pk_U2GS_DivorceNotifyConfirm,{
	}).

-define(CMD_U2GS_GetWeddingParnterLookInfo,37164).
-record(pk_U2GS_GetWeddingParnterLookInfo,{
	}).

-define(CMD_GS2U_GetWeddingParnterLookInfoRet,22499).
-record(pk_GS2U_GetWeddingParnterLookInfoRet,{
	playerID = 0,
	name = "",
	career = 0,
	level = 0,
	headID = 0,
	fateLevel = 0,
	battleValue = 0,
	ponchoLevel = 0,
	wingCfgID = 0,
	titleID = 0,
	suitChara = 0,
	suitLevel = 0,
	suitQuality = 0,
	equipCfgIDList = [],
	fashionCfgIDList = [],
	intensityLvList = []
	}).

-define(CMD_U2GS_blessWedding,17431).
-record(pk_U2GS_blessWedding,{
	bridegroomID = 0,
	brideID = 0
	}).

-define(CMD_GS2U_blessWeddingResult,11828).
-record(pk_GS2U_blessWeddingResult,{
	bridegroomID = 0,
	brideID = 0,
	type = 0,
	result = 0
	}).

-define(CMD_GS2U_WeddingMarryNpcNotify,58792).
-record(pk_GS2U_WeddingMarryNpcNotify,{
	loveIncidentID = 0
	}).

-define(CMD_GS2U_WeddingMarryFinishNotify,62890).
-record(pk_GS2U_WeddingMarryFinishNotify,{
	playerID1 = 0,
	name1 = "",
	sex1 = 0,
	playerID2 = 0,
	name2 = "",
	sex2 = 0
	}).

-define(CMD_GS2U_WeddingOrderApplyNotify,4794).
-record(pk_GS2U_WeddingOrderApplyNotify,{
	type = 0,
	ceremonyTime = 0,
	playerID1 = 0,
	name1 = "",
	playerID2 = 0,
	name2 = "",
	orderType = 0
	}).

-define(CMD_U2GS_ViewWeddingGifts,20885).
-record(pk_U2GS_ViewWeddingGifts,{
	id = 0
	}).

-define(CMD_WeddingGift,58413).
-record(pk_WeddingGift,{
	name = "",
	giftID = 0,
	times = 0
	}).

-define(CMD_WeddingStat,42236).
-record(pk_WeddingStat,{
	itemType = 0,
	itemID = 0,
	itemNum = 0
	}).

-define(CMD_GS2U_ViewWeddingGiftsRet,12445).
-record(pk_GS2U_ViewWeddingGiftsRet,{
	giftList = [],
	giftStat = []
	}).

-define(CMD_U2GS_getWeddingRankInfo,48052).
-record(pk_U2GS_getWeddingRankInfo,{
	type = 0
	}).

-define(CMD_topWedding,25146).
-record(pk_topWedding,{
	bridegroomID = 0,
	bridegroomName = "",
	bridegroomVip = 0,
	bridegroomLevel = 0,
	bridegroomFateLevel = 0,
	brideID = 0,
	brideName = "",
	brideVip = 0,
	brideLevel = 0,
	brideFateLevel = 0,
	rank = 0,
	value = 0,
	customInt = 0,
	time = 0
	}).

-define(CMD_GS2U_sendWeddingRankInfo,10369).
-record(pk_GS2U_sendWeddingRankInfo,{
	type = 0,
	rank = 0,
	value = 0,
	customInt = 0,
	top_list = []
	}).

-define(CMD_GS2U_WeddingPrepareInfo,59765).
-record(pk_GS2U_WeddingPrepareInfo,{
	state = 0,
	confirmEndTime = 0,
	careerEndTime = 0,
	prepareEndTime = 0,
	masterPlayerID = 0,
	playerID1 = 0,
	playerName1 = "",
	isConfirm1 = false,
	useCareer1 = 0,
	playerID2 = 0,
	playerName2 = "",
	isConfirm2 = false,
	useCareer2 = 0
	}).

-define(CMD_U2GS_GetWeddingPrepareInfo,29404).
-record(pk_U2GS_GetWeddingPrepareInfo,{
	}).

-define(CMD_U2GS_WeddingPrepareRequest,54496).
-record(pk_U2GS_WeddingPrepareRequest,{
	}).

-define(CMD_GS2U_WeddingPrepareRequest,60149).
-record(pk_GS2U_WeddingPrepareRequest,{
	errorCode = 0
	}).

-define(CMD_U2GS_WeddingPrepareResponse,16452).
-record(pk_U2GS_WeddingPrepareResponse,{
	isAgree = false
	}).

-define(CMD_GS2U_WeddingPrepareRejectNotify,47198).
-record(pk_GS2U_WeddingPrepareRejectNotify,{
	}).

-define(CMD_U2GS_WeddingPrepareCareer,22871).
-record(pk_U2GS_WeddingPrepareCareer,{
	useCareer = 0
	}).

-define(CMD_U2GS_getWeddingTaskInfo,55182).
-record(pk_U2GS_getWeddingTaskInfo,{
	}).

-define(CMD_wTaskPro,52248).
-record(pk_wTaskPro,{
	type = 0,
	num = 0
	}).

-define(CMD_GS2U_sendWeddingTaskInfo,17499).
-record(pk_GS2U_sendWeddingTaskInfo,{
	dayPro_list = [],
	pro_list = [],
	task_list = []
	}).

-define(CMD_U2GS_getWeddingTaskReward,51317).
-record(pk_U2GS_getWeddingTaskReward,{
	id = 0
	}).

-define(CMD_GS2U_getWeddingTaskRewardResult,3535).
-record(pk_GS2U_getWeddingTaskRewardResult,{
	id = 0,
	result = 0
	}).

-define(CMD_U2GS_CancelSubmitLoveTask,19252).
-record(pk_U2GS_CancelSubmitLoveTask,{
	step = 0
	}).

-define(CMD_U2GS_RequestMyRankInfo,30818).
-record(pk_U2GS_RequestMyRankInfo,{
	}).

-define(CMD_GS2U_RequestMyRankInfoRet,16573).
-record(pk_GS2U_RequestMyRankInfoRet,{
	giftValue = 0,
	giftTimes = 0,
	giftValueWeek = 0,
	giftTimesWeek = 0,
	cTimes = 0
	}).

-define(CMD_GS2U_MultiCollectionList,55376).
-record(pk_GS2U_MultiCollectionList,{
	mCollectionList = []
	}).

-define(CMD_U2GS_WeddingInviteRejectAsk,10113).
-record(pk_U2GS_WeddingInviteRejectAsk,{
	isRejectAsk = false
	}).

-define(CMD_GS2U_WeddingInviteRejectAsk,47237).
-record(pk_GS2U_WeddingInviteRejectAsk,{
	errorCode = 0
	}).

-define(CMD_U2GS_WeddingInviteRejectList,63237).
-record(pk_U2GS_WeddingInviteRejectList,{
	playerIDList = []
	}).

-define(CMD_GS2U_WeddingInviteRejectList,44086).
-record(pk_GS2U_WeddingInviteRejectList,{
	errorCode = 0
	}).

-define(CMD_GS2U_NextBuffTime,6371).
-record(pk_GS2U_NextBuffTime,{
	buffTime = 0
	}).

-define(CMD_GS2U_WeddingCeremonyInfo,17536).
-record(pk_GS2U_WeddingCeremonyInfo,{
	state = 0,
	type = 0,
	playerID1 = 0,
	playerName1 = "",
	playerID2 = 0,
	playerName2 = ""
	}).

-define(CMD_U2GS_WeddingCeremonyInfo,28933).
-record(pk_U2GS_WeddingCeremonyInfo,{
	}).

-define(CMD_U2GS_WeddingLoveTaskPanelOpen,18543).
-record(pk_U2GS_WeddingLoveTaskPanelOpen,{
	step = 0
	}).

-define(CMD_CostItemInfo,55719).
-record(pk_CostItemInfo,{
	itemID = 0,
	itemNum = 0
	}).

-define(CMD_LoveTaskPanelInfo,495).
-record(pk_LoveTaskPanelInfo,{
	sex = 0,
	career = 0,
	cList = [],
	intimacyLevel = 0,
	equipCfgIDList = [],
	fashionCfgIDList = [],
	intensityLvList = []
	}).

-define(CMD_GS2U_WeddingLoveTaskPanelOpenRet,39689).
-record(pk_GS2U_WeddingLoveTaskPanelOpenRet,{
	errCode = 0,
	state = 0,
	pInfo = #pk_LoveTaskPanelInfo{}
	}).

-define(CMD_U2GS_WeddingLoveTaskGather,57303).
-record(pk_U2GS_WeddingLoveTaskGather,{
	step = 0
	}).

-define(CMD_GS2U_WeddingLoveTaskGatherRet,32751).
-record(pk_GS2U_WeddingLoveTaskGatherRet,{
	state = 0
	}).

-define(CMD_U2GS_WeddingLoveBanquetStart,16863).
-record(pk_U2GS_WeddingLoveBanquetStart,{
	id = 0
	}).

-define(CMD_GS2U_WeddingLoveBanquetStartRet,30013).
-record(pk_GS2U_WeddingLoveBanquetStartRet,{
	errCode = 0
	}).

-define(CMD_U2GS_WeddingRingCheckActiveCondition,3459).
-record(pk_U2GS_WeddingRingCheckActiveCondition,{
	}).

-define(CMD_U2GS_WeddingRingGetActiveCondition,38788).
-record(pk_U2GS_WeddingRingGetActiveCondition,{
	}).

-define(CMD_FriendIntimacyLevelStat,49932).
-record(pk_FriendIntimacyLevelStat,{
	level = 0,
	num = 0
	}).

-define(CMD_ActiveCurrentProcess,49304).
-record(pk_ActiveCurrentProcess,{
	key = 0,
	value = 0,
	param = 0,
	paramList = [],
	friendParamList = [],
	geremony_list = []
	}).

-define(CMD_GS2U_WeddingRingGetActiveConditionRet,7221).
-record(pk_GS2U_WeddingRingGetActiveConditionRet,{
	pList = []
	}).

-define(CMD_GS2U_CollectMultiCollectionSuccess,7585).
-record(pk_GS2U_CollectMultiCollectionSuccess,{
	collectionID = 0
	}).

-define(CMD_GS2U_LoveTokenTotalProperty,1883).
-record(pk_GS2U_LoveTokenTotalProperty,{
	inspireTuple = #pk_InspireTuple{}
	}).

-define(CMD_GS2U_genRedDotPush,56352).
-record(pk_GS2U_genRedDotPush,{
	type = 0
	}).

-define(CMD_U2GS_transToWeddingCruise,22647).
-record(pk_U2GS_transToWeddingCruise,{
	brideID = 0
	}).

-define(CMD_GS2U_transToWeddingCruiseResult,18734).
-record(pk_GS2U_transToWeddingCruiseResult,{
	brideID = 0,
	result = 0
	}).

-define(CMD_GS2U_BanquetCollectFinishCountDown,22098).
-record(pk_GS2U_BanquetCollectFinishCountDown,{
	timeSec = 0
	}).

-define(CMD_U2GS_getDanmakuPresentTimes,39774).
-record(pk_U2GS_getDanmakuPresentTimes,{
	id = 0
	}).

-define(CMD_presentTimes,3397).
-record(pk_presentTimes,{
	giftID = 0,
	count = 0
	}).

-define(CMD_GS2U_sendDanmakuPresentTimes,49324).
-record(pk_GS2U_sendDanmakuPresentTimes,{
	id = 0,
	present_list = []
	}).

-define(CMD_U2GS_WeddingOrderReceive,11042).
-record(pk_U2GS_WeddingOrderReceive,{
	}).

-define(CMD_GS2U_WeddingLoveBanquetStart,43739).
-record(pk_GS2U_WeddingLoveBanquetStart,{
	id = 0
	}).

-define(CMD_U2GS_WeddingFinish,7392).
-record(pk_U2GS_WeddingFinish,{
	type = 0
	}).

-define(CMD_GS2U_RingRedSpot,5696).
-record(pk_GS2U_RingRedSpot,{
	id = 0
	}).

-define(CMD_GS2U_WeddingEscortFinishNotify,60451).
-record(pk_GS2U_WeddingEscortFinishNotify,{
	playerID1 = 0,
	playerID2 = 0
	}).

-define(CMD_U2GS_flowerGift,44617).
-record(pk_U2GS_flowerGift,{
	playerID = 0,
	id = 0,
	num = 0
	}).

-define(CMD_GS2U_flowerGift,13530).
-record(pk_GS2U_flowerGift,{
	playerID = 0,
	id = 0,
	num = 0,
	intimacyLevel = 0,
	intimacy = 0,
	flowerIntimacy = 0,
	result = 0
	}).

-define(CMD_U2GS_Red_Envelope_close,3647).
-record(pk_U2GS_Red_Envelope_close,{
	close_reason = 0,
	id = 0
	}).

-define(CMD_U2GS_GetCoupleFightInfo,45095).
-record(pk_U2GS_GetCoupleFightInfo,{
	isInvite = 0
	}).

-define(CMD_GS2U_GetCoupleFightRet,43088).
-record(pk_GS2U_GetCoupleFightRet,{
	season = 0,
	seasonStartTime = 0,
	seasonEndTime = 0,
	activityStartTime = 0,
	activityStopTime = 0,
	punishTime = 0,
	officeType = 0,
	office = 0,
	score = 0,
	fightCount = 0,
	retrieveCount = 0,
	retrieveHistory = 0,
	buyHistory = 0
	}).

-define(CMD_GS2U_InvatePartnerInfo,19029).
-record(pk_GS2U_InvatePartnerInfo,{
	roomID = 0,
	playerID = 0,
	invitePlayerName = "",
	career = 0,
	fateLevel = 0,
	headID = 0,
	level = 0,
	battleValue = 0,
	vip = 0
	}).

-define(CMD_CoupleFightLives,1647).
-record(pk_CoupleFightLives,{
	id = 0,
	lives = 0,
	group = 0,
	sex = 0
	}).

-define(CMD_GS2U_CoupleFightLivesNotify,54962).
-record(pk_GS2U_CoupleFightLivesNotify,{
	lives = []
	}).

-define(CMD_U2GS_CoupleFightRecord,53330).
-record(pk_U2GS_CoupleFightRecord,{
	}).

-define(CMD_CoupleFightBattleResultPlayer,55522).
-record(pk_CoupleFightBattleResultPlayer,{
	playerid = 0,
	name = "",
	headId = 0,
	battleValue = 0,
	restHp = 0,
	restLives = 0,
	killNum = 0,
	dieNum = 0,
	group = 0,
	sex = 0,
	state = 0,
	vip = 0,
	level = 0,
	fateLevel = 0,
	officeType = 0,
	office = 0,
	heroList = []
	}).

-define(CMD_CoupleFightBattleResult,48586).
-record(pk_CoupleFightBattleResult,{
	time = 0,
	players = [],
	winGroup = 0,
	mvpId = 0
	}).

-define(CMD_GS2U_CoupleFightRecordRet,3488).
-record(pk_GS2U_CoupleFightRecordRet,{
	records = []
	}).

-define(CMD_GS2U_CoupleFightResult,5578).
-record(pk_GS2U_CoupleFightResult,{
	result = #pk_CoupleFightBattleResult{}
	}).

-define(CMD_U2GS_CoupleFightGiveLives,41315).
-record(pk_U2GS_CoupleFightGiveLives,{
	result = 0
	}).

-define(CMD_GS2U_CoupleFightGiveLivesRet,29561).
-record(pk_GS2U_CoupleFightGiveLivesRet,{
	errorCode = 0
	}).

-define(CMD_U2GS_CoupleFightTmpResult,57134).
-record(pk_U2GS_CoupleFightTmpResult,{
	}).

-define(CMD_GS2U_CoupleFightTmpResultRet,63281).
-record(pk_GS2U_CoupleFightTmpResultRet,{
	record = #pk_CoupleFightBattleResult{}
	}).

-define(CMD_U2GS_CoupleFightGradeRank,54873).
-record(pk_U2GS_CoupleFightGradeRank,{
	type = 0
	}).

-define(CMD_GS2U_CoupleFightAchievementRed,15576).
-record(pk_GS2U_CoupleFightAchievementRed,{
	}).

-define(CMD_GS2U_CoupleFightOfficeChange,48131).
-record(pk_GS2U_CoupleFightOfficeChange,{
	oldOfficeType = 0,
	oldOffice = 0,
	officeType = 0,
	office = 0
	}).

-define(CMD_U2GS_SpecMapBuyNumberOfChallenges,26428).
-record(pk_U2GS_SpecMapBuyNumberOfChallenges,{
	type = 0,
	buyNumber = 0
	}).

-define(CMD_GS2U_SpecMapBuyNumberOfChallengesRet,45384).
-record(pk_GS2U_SpecMapBuyNumberOfChallengesRet,{
	result = 0,
	buyNumber = 0
	}).

-define(CMD_GS2U_InvatePartnerRet,27833).
-record(pk_GS2U_InvatePartnerRet,{
	result = 0
	}).

-define(CMD_U2GS_InvatePartner,791).
-record(pk_U2GS_InvatePartner,{
	}).

-define(CMD_U2GS_RequestInSell,60518).
-record(pk_U2GS_RequestInSell,{
	itemid = 0,
	num = 0,
	currency_type = 0,
	price = 0,
	star = 0,
	equipCharacter = 0
	}).

-define(CMD_GS2U_RequestInSellRet,59282).
-record(pk_GS2U_RequestInSellRet,{
	errorCode = 0
	}).

-define(CMD_U2GS_GetConsignmentInfo,23899).
-record(pk_U2GS_GetConsignmentInfo,{
	isRequest = false,
	part1 = 0,
	part2 = 0,
	star = 0,
	equipCharacter = 0,
	itemType = 0,
	detailedTypeFind = 0,
	detailedType2Find = 0,
	detailedType3Find = 0,
	useTypeFind = 0,
	useParam1Find = 0,
	useParam2Find = 0,
	useParam3Find = 0,
	useParam4Find = 0,
	character = 0,
	oder = 0,
	price = 0,
	totalPrice = 0,
	buyType = 0,
	numPerPage = 0,
	filters = []
	}).

-define(CMD_ConsignmentItem,58121).
-record(pk_ConsignmentItem,{
	index = 0,
	id = 0,
	itemid = 0,
	star = 0,
	equipCharacter = 0,
	num = 0,
	currency_type = 0,
	price = 0,
	buyType = 0,
	passward = "",
	isSelf = false,
	playerName = "",
	score = 0
	}).

-define(CMD_GS2U_ConsignmentRet,55848).
-record(pk_GS2U_ConsignmentRet,{
	len = 0,
	items = []
	}).

-define(CMD_U2GS_GetConsignmentNextInfo,52936).
-record(pk_U2GS_GetConsignmentNextInfo,{
	numPerPage = 0,
	index = 0
	}).

-define(CMD_U2GS_ConsignmentBankSell,31120).
-record(pk_U2GS_ConsignmentBankSell,{
	id = 0,
	bag_type = 0,
	num = 0,
	currency_type = 0,
	price = 0,
	isPassword = false,
	passWord = ""
	}).

-define(CMD_GS2U_ConsignmentBankSellRet,41512).
-record(pk_GS2U_ConsignmentBankSellRet,{
	errorCode = 0,
	id = 0
	}).

-define(CMD_U2GS_ConsignmentBankOffShelf,9105).
-record(pk_U2GS_ConsignmentBankOffShelf,{
	index = 0,
	type = 0
	}).

-define(CMD_GS2U_ConsignmentBankOffShelfRet,2072).
-record(pk_GS2U_ConsignmentBankOffShelfRet,{
	errorCode = 0,
	index = 0
	}).

-define(CMD_U2GS_ConsignmentBankReferencePrice,625).
-record(pk_U2GS_ConsignmentBankReferencePrice,{
	id = 0,
	star = 0,
	equipCharacter = 0
	}).

-define(CMD_ReferencePrice,4623).
-record(pk_ReferencePrice,{
	id = 0,
	num = 0,
	price = 0,
	star = 0,
	equipCharacter = 0,
	eq1 = #pk_EqInfo{},
	eq2 = #pk_EqAddition{},
	eq3 = #pk_AEquipmentInfo{},
	eq4 = #pk_ornament{},
	eq5 = #pk_constellation_equipment{},
	eq6 = #pk_ancient_holy_equipment{},
	eq7 = #pk_holy_wing{},
	eq8 = #pk_dark_flame_eq{},
	eq9 = #pk_ShengWen{}
	}).

-define(CMD_GS2U_ConsignmentBankReferencePriceRet,38758).
-record(pk_GS2U_ConsignmentBankReferencePriceRet,{
	id = 0,
	info = []
	}).

-define(CMD_U2GS_ConsignmentBankBuy,23651).
-record(pk_U2GS_ConsignmentBankBuy,{
	index = 0,
	num = 0,
	pw = ""
	}).

-define(CMD_GS2U_ConsignmentBankBuyRet,62849).
-record(pk_GS2U_ConsignmentBankBuyRet,{
	errorCode = 0,
	index = 0
	}).

-define(CMD_U2GS_ConsignmentBankSelf,4835).
-record(pk_U2GS_ConsignmentBankSelf,{
	}).

-define(CMD_ReferenceASelfItem,27158).
-record(pk_ReferenceASelfItem,{
	index = 0,
	id = 0,
	num = 0,
	star = 0,
	equipCharacter = 0,
	currency_type = 0,
	price = 0,
	time = 0,
	score = 0,
	eq1 = #pk_EqInfo{},
	eq2 = #pk_EqAddition{},
	eq3 = #pk_AEquipmentInfo{},
	eq4 = #pk_ornament{},
	eq5 = #pk_constellation_equipment{},
	eq6 = #pk_ancient_holy_equipment{},
	eq7 = #pk_holy_wing{},
	eq8 = #pk_dark_flame_eq{},
	eq9 = #pk_ShengWen{}
	}).

-define(CMD_GS2U_ConsignmentBankSelfRet,36932).
-record(pk_GS2U_ConsignmentBankSelfRet,{
	id = 0,
	info = []
	}).

-define(CMD_U2GS_ConsignmentBankRecord,1827).
-record(pk_U2GS_ConsignmentBankRecord,{
	type = 0
	}).

-define(CMD_ConsignmentBankRecord,39188).
-record(pk_ConsignmentBankRecord,{
	uid = 0,
	id = 0,
	num = 0,
	equipment_star = 0,
	equipment_character = 0,
	currency_type = 0,
	price = 0,
	state = 0,
	time = 0
	}).

-define(CMD_GS2U_ConsignmentBankRecordRet,57826).
-record(pk_GS2U_ConsignmentBankRecordRet,{
	current_num = 0,
	current_bind_num = 0,
	info = []
	}).

-define(CMD_U2GS_ConsignmentBankGain,19757).
-record(pk_U2GS_ConsignmentBankGain,{
	}).

-define(CMD_GS2U_ConsignmentBankGainRet,29548).
-record(pk_GS2U_ConsignmentBankGainRet,{
	errorCode = 0,
	currencyUsed = 0,
	currencyBindUsed = 0,
	currencyRemaining = 0,
	currencyBindRemaining = 0
	}).

-define(CMD_U2GS_SellRequest,29118).
-record(pk_U2GS_SellRequest,{
	id = 0,
	num = 0
	}).

-define(CMD_GS2U_SellRequestRet,32341).
-record(pk_GS2U_SellRequestRet,{
	errorCode = 0,
	num = 0
	}).

-define(CMD_U2GS_WeddingRedEnvelopeSate,3225).
-record(pk_U2GS_WeddingRedEnvelopeSate,{
	playerid = 0,
	id = 0
	}).

-define(CMD_GS2U_WeddingRedEnvelopeNotify,53058).
-record(pk_GS2U_WeddingRedEnvelopeNotify,{
	playerid = 0,
	state = 0,
	sender_name = "",
	cmd = "",
	money = 0
	}).

-define(CMD_WeddingRedEnvelopeNum,51275).
-record(pk_WeddingRedEnvelopeNum,{
	playerid = 0,
	num = 0
	}).

-define(CMD_GS2U_WeddingRedEnvelopeNum,33910).
-record(pk_GS2U_WeddingRedEnvelopeNum,{
	info = []
	}).

-define(CMD_GS2U_FWingChangeStatus,21408).
-record(pk_GS2U_FWingChangeStatus,{
	playerID = 0,
	fwingStatus = 0
	}).

-define(CMD_U2GS_RequestCharm,9837).
-record(pk_U2GS_RequestCharm,{
	}).

-define(CMD_GS2U_RequestCharmRet,40457).
-record(pk_GS2U_RequestCharmRet,{
	charm = 0,
	cherish = 0
	}).

-define(CMD_GS2U_CharmTopFirst,29198).
-record(pk_GS2U_CharmTopFirst,{
	charmPlayerID = 0,
	cherishPlayerID = 0
	}).

-define(CMD_ActiveExtendDungeonInfo,33730).
-record(pk_ActiveExtendDungeonInfo,{
	dungeonID = 0,
	freeTimes = 0,
	maxProgress = 0,
	star = 0
	}).

-define(CMD_ActiveExtendGroupInfo,14073).
-record(pk_ActiveExtendGroupInfo,{
	type = 0,
	maxFightCount = 0,
	fightCount = 0,
	buyFightCountDay = 0,
	dungeonList = []
	}).

-define(CMD_U2GS_ActiveExtendDungeonInfo,24081).
-record(pk_U2GS_ActiveExtendDungeonInfo,{
	}).

-define(CMD_GS2U_ActiveExtendDungeonInfo,4756).
-record(pk_GS2U_ActiveExtendDungeonInfo,{
	groupList = []
	}).

-define(CMD_U2GS_EnterActiveExtendDungeon,38322).
-record(pk_U2GS_EnterActiveExtendDungeon,{
	dungeonID = 0
	}).

-define(CMD_GS2U_ActiveExtendDungeonFightResult,33859).
-record(pk_GS2U_ActiveExtendDungeonFightResult,{
	dungeonID = 0,
	progress = 0,
	maxProgress = 0,
	cur_star = 0,
	max_star = 0,
	is_first_star = 0,
	isOpenNext = false,
	exp = 0,
	double_times = 0,
	coinList = [],
	itemList = [],
	eq_list = [],
	max_enter_count = 0,
	enter_count = 0,
	firstCoinList = [],
	firstItemList = [],
	first_eq_list = []
	}).

-define(CMD_U2GS_MopupDungeonActiveExtend,15064).
-record(pk_U2GS_MopupDungeonActiveExtend,{
	dungeonID = 0
	}).

-define(CMD_GS2U_MopupDungeonActiveExtend,10472).
-record(pk_GS2U_MopupDungeonActiveExtend,{
	dungeonID = 0,
	maxProgress = 0,
	isOpenNext = false,
	exp = 0,
	coinList = [],
	itemList = [],
	eq_list = [],
	double_times = 0,
	star = 0
	}).

-define(CMD_U2GS_BossActivityInfo,65439).
-record(pk_U2GS_BossActivityInfo,{
	activityID = 0,
	bossActivityID = 0
	}).

-define(CMD_GS2U_BossActivityInfo,41163).
-record(pk_GS2U_BossActivityInfo,{
	activityID = 0,
	bossActivityID = 0,
	errorCode = 0,
	bornMap = 0,
	bossIDList = [],
	timeList = [],
	dropItemList = [],
	messageList = [],
	awardList = [],
	awardReceiveList = [],
	finishNum = 0
	}).

-define(CMD_GS2U_BossActivityBossNotify,462).
-record(pk_GS2U_BossActivityBossNotify,{
	activityID = 0,
	bossActivityID = 0,
	bossState = 0
	}).

-define(CMD_GS2U_BossActivityAwardNotify,33541).
-record(pk_GS2U_BossActivityAwardNotify,{
	activityID = 0,
	bossActivityID = 0
	}).

-define(CMD_GS2U_BossActivityAwardReceive,61722).
-record(pk_GS2U_BossActivityAwardReceive,{
	activityID = 0,
	bossActivityID = 0,
	index = 0,
	errorCode = 0
	}).

-define(CMD_GS2U_WealthTime,56186).
-record(pk_GS2U_WealthTime,{
	wealthTime = 0
	}).

-define(CMD_U2GS_GiveStaminaOneKey,22274).
-record(pk_U2GS_GiveStaminaOneKey,{
	}).

-define(CMD_GS2U_GiveStaminaOneKeyRet,55312).
-record(pk_GS2U_GiveStaminaOneKeyRet,{
	friendIDList = []
	}).

-define(CMD_U2GS_EnterDemonMap,28284).
-record(pk_U2GS_EnterDemonMap,{
	enter_type = 0,
	mapDataID = 0
	}).

-define(CMD_U2GS_getDemonsMsg,8616).
-record(pk_U2GS_getDemonsMsg,{
	type = 0
	}).

-define(CMD_demonInfo,2154).
-record(pk_demonInfo,{
	bossID = 0,
	deadTime = 0,
	follow = 0,
	is_super = 0,
	killer_list = [],
	index = 0
	}).

-define(CMD_mapDemons,26190).
-record(pk_mapDemons,{
	mapDataID = 0,
	monsterNum = 0,
	collectionNum = 0,
	collectionTime = 0,
	demon_list = []
	}).

-define(CMD_GS2U_sendDemonsMsg,31291).
-record(pk_GS2U_sendDemonsMsg,{
	type = 0,
	fatigue = 0,
	extra_fatigue = 0,
	awardTimes = 0,
	demonsAnger = 0,
	demonsHatred = 0,
	enter_multi = 0,
	buy_times = 0,
	param = 0,
	demon_list = []
	}).

-define(CMD_U2GS_getDemonsDropMsg,45801).
-record(pk_U2GS_getDemonsDropMsg,{
	type = 0
	}).

-define(CMD_GS2U_sendDemonsDropMsg,7430).
-record(pk_GS2U_sendDemonsDropMsg,{
	drop_list = []
	}).

-define(CMD_U2GS_enterDemonArea,56609).
-record(pk_U2GS_enterDemonArea,{
	type = 0,
	mapDataID = 0,
	bossID = 0
	}).

-define(CMD_GS2U_enterDemonAreaResult,35993).
-record(pk_GS2U_enterDemonAreaResult,{
	type = 0,
	mapDataID = 0,
	bossID = 0,
	result = 0
	}).

-define(CMD_U2GS_exitDemonArea,11588).
-record(pk_U2GS_exitDemonArea,{
	type = 0,
	mapDataID = 0,
	bossID = 0
	}).

-define(CMD_GS2U_exitDemonAreaResult,2441).
-record(pk_GS2U_exitDemonAreaResult,{
	type = 0,
	mapDataID = 0,
	bossID = 0,
	result = 0
	}).

-define(CMD_demonRankInfo,6410).
-record(pk_demonRankInfo,{
	playerID = 0,
	name = "",
	isAward = 0,
	damage = 0,
	rank = 0,
	serverName = "",
	nationality_id = 0
	}).

-define(CMD_GS2U_sendDemonRank,41820).
-record(pk_GS2U_sendDemonRank,{
	damage = 0,
	rank = 0,
	bin_fill = <<>>,
	rank_list = []
	}).

-define(CMD_U2GS_followDemon,61127).
-record(pk_U2GS_followDemon,{
	type = 0,
	type2 = 0,
	mapDataID = 0,
	bossID = 0
	}).

-define(CMD_GS2U_followDemonResult,11755).
-record(pk_GS2U_followDemonResult,{
	type = 0,
	type2 = 0,
	mapDataID = 0,
	bossID = 0,
	result = 0
	}).

-define(CMD_U2GS_unFollowDemon,40393).
-record(pk_U2GS_unFollowDemon,{
	type = 0,
	type2 = 0,
	mapDataID = 0,
	bossID = 0
	}).

-define(CMD_GS2U_unFollowDemonResult,50981).
-record(pk_GS2U_unFollowDemonResult,{
	type = 0,
	type2 = 0,
	mapDataID = 0,
	bossID = 0,
	result = 0
	}).

-define(CMD_GS2U_DemonSettle,61783).
-record(pk_GS2U_DemonSettle,{
	name = "",
	isTeam = 0,
	name_list = [],
	rank = 0,
	fatigue = 0,
	awardTimes = 0,
	coin_list = [],
	item_list = []
	}).

-define(CMD_GS2U_DemonRefreshNotice,55120).
-record(pk_GS2U_DemonRefreshNotice,{
	type = 0,
	type2 = 0,
	mapDataID = 0,
	bossID = 0
	}).

-define(CMD_U2GS_getDemonsRedPoint,46388).
-record(pk_U2GS_getDemonsRedPoint,{
	type = 0
	}).

-define(CMD_demonsRedPoint,55269).
-record(pk_demonsRedPoint,{
	type = 0,
	isRed = 0
	}).

-define(CMD_GS2U_sendDemonsRedPoint,56585).
-record(pk_GS2U_sendDemonsRedPoint,{
	demonsAnger = 0,
	demonsHatred = 0,
	red_list = []
	}).

-define(CMD_U2GS_requireReborn,45000).
-record(pk_U2GS_requireReborn,{
	type = 0
	}).

-define(CMD_GS2U_sendRequireBorn,45405).
-record(pk_GS2U_sendRequireBorn,{
	type = 0,
	times = 0
	}).

-define(CMD_U2GS_requireDemonKeepTime,37446).
-record(pk_U2GS_requireDemonKeepTime,{
	mapDataID = 0
	}).

-define(CMD_GS2U_requireDemonKeepTimeResult,36445).
-record(pk_GS2U_requireDemonKeepTimeResult,{
	mapDataID = 0,
	result = 0
	}).

-define(CMD_U2GS_getMapKickExitTime,32531).
-record(pk_U2GS_getMapKickExitTime,{
	mapDataID = 0
	}).

-define(CMD_GS2U_sendMapKickExitTime,60384).
-record(pk_GS2U_sendMapKickExitTime,{
	mapDataID = 0,
	exitTime = 0
	}).

-define(CMD_demon_guild_rank_info,25943).
-record(pk_demon_guild_rank_info,{
	guild_id = 0,
	guild_name = "",
	guild_damage = 0,
	rank = 0
	}).

-define(CMD_GS2U_send_demon_guild_rank,52391).
-record(pk_GS2U_send_demon_guild_rank,{
	damage = 0,
	rank = 0,
	rank_list = []
	}).

-define(CMD_GS2U_demon_super_boss_member_award,43055).
-record(pk_GS2U_demon_super_boss_member_award,{
	mapDataID = 0,
	monsterID = 0
	}).

-define(CMD_U2GS_get_super_boss_member_award,53924).
-record(pk_U2GS_get_super_boss_member_award,{
	mapDataID = 0,
	monsterID = 0
	}).

-define(CMD_GS2U_get_super_boss_member_award_ret,55031).
-record(pk_GS2U_get_super_boss_member_award_ret,{
	mapDataID = 0,
	monsterID = 0,
	error_code = 0
	}).

-define(CMD_U2GS_super_boss_convene,30111).
-record(pk_U2GS_super_boss_convene,{
	mapDataID = 0,
	monsterID = 0
	}).

-define(CMD_GS2U_super_boss_convene_ret,1582).
-record(pk_GS2U_super_boss_convene_ret,{
	mapDataID = 0,
	monsterID = 0,
	error_code = 0
	}).

-define(CMD_GS2U_super_boss_convene_info,23254).
-record(pk_GS2U_super_boss_convene_info,{
	mapDataID = 0,
	monsterID = 0,
	x = 0,
	y = 0
	}).

-define(CMD_super_boss_state,41770).
-record(pk_super_boss_state,{
	mapDataID = 0,
	monsterID = 0,
	index = 0,
	dead_time = 0
	}).

-define(CMD_GS2U_super_boss_state_sync,48703).
-record(pk_GS2U_super_boss_state_sync,{
	list = []
	}).

-define(CMD_GS2U_demonBossDead,60723).
-record(pk_GS2U_demonBossDead,{
	map_data_id = 0,
	boss_id = 0,
	dead_time = 0
	}).

-define(CMD_U2GS_getRechargeActAward,7244).
-record(pk_U2GS_getRechargeActAward,{
	id = 0,
	act_id = 0
	}).

-define(CMD_GS2U_getRechargeActAwardResult,59446).
-record(pk_GS2U_getRechargeActAwardResult,{
	id = 0,
	act_id = 0,
	result = 0
	}).

-define(CMD_U2GS_lotteyReward,35727).
-record(pk_U2GS_lotteyReward,{
	id = 0,
	world_index = 0,
	times = 0
	}).

-define(CMD_GS2U_lotteryRewardResult,5192).
-record(pk_GS2U_lotteryRewardResult,{
	id = 0,
	world_index = 0,
	times = 0,
	coin_list = [],
	item_list = [],
	result = 0
	}).

-define(CMD_actCoin,41408).
-record(pk_actCoin,{
	index = 0,
	type = 0,
	amount = 0,
	effect = 0
	}).

-define(CMD_actItem,24399).
-record(pk_actItem,{
	index = 0,
	itemID = 0,
	count = 0,
	bind = 0,
	effect = 0
	}).

-define(CMD_rechargeAct,39826).
-record(pk_rechargeAct,{
	id = 0,
	target = 0,
	model = 0,
	coin_list = [],
	item_list = [],
	limit = []
	}).

-define(CMD_dailyTopItem,59807).
-record(pk_dailyTopItem,{
	rank = 0,
	type = 0,
	itemID = 0,
	num = 0,
	bind = 0,
	chara = 0,
	star = 0,
	effect = 0
	}).

-define(CMD_dailyTopBase,12957).
-record(pk_dailyTopBase,{
	top_id = 0,
	settleType = 0,
	day = 0,
	top_type = 0,
	rank_num = 0,
	min_value = 0,
	rewars = [],
	floor_type = 0,
	floor_value = 0,
	floor_rewars = []
	}).

-define(CMD_itemPoint,53091).
-record(pk_itemPoint,{
	itemID = 0,
	point = 0
	}).

-define(CMD_currencyPoint,11095).
-record(pk_currencyPoint,{
	type = 0,
	unit = 0,
	point = 0
	}).

-define(CMD_newPoint,34676).
-record(pk_newPoint,{
	type = 0,
	param1 = 0,
	param2 = 0,
	point = 0
	}).

-define(CMD_resPoint,59816).
-record(pk_resPoint,{
	id = 0,
	cons_list = [],
	jump = [],
	item_list = [],
	currency_list = [],
	new_list = [],
	cid_list = [],
	des = ""
	}).

-define(CMD_fundsCondition,50693).
-record(pk_fundsCondition,{
	index = 0,
	recharge = 0
	}).

-define(CMD_fundsSpend,49335).
-record(pk_fundsSpend,{
	index = 0,
	spent = 0,
	ret_num = 0
	}).

-define(CMD_fundsReward,19395).
-record(pk_fundsReward,{
	index = 0,
	start_ret = 0,
	end_ret = 0,
	gold_num = 0
	}).

-define(CMD_SalesFunds,10948).
-record(pk_SalesFunds,{
	cond_list = [],
	spent_list = [],
	reward_list = []
	}).

-define(CMD_weeklyCardItem,60595).
-record(pk_weeklyCardItem,{
	day = 0,
	type = 0,
	itemID = 0,
	num = 0,
	bind = 0,
	effect = 0
	}).

-define(CMD_WeeklyCard,53087).
-record(pk_WeeklyCard,{
	id = 0,
	conditions = 0,
	item_list = []
	}).

-define(CMD_ConsumeEx,22616).
-record(pk_ConsumeEx,{
	group = 0,
	type = 0,
	param1 = 0,
	param2 = 0
	}).

-define(CMD_ResetP,23970).
-record(pk_ResetP,{
	type = 0,
	param1 = 0,
	param2 = 0,
	param3 = 0
	}).

-define(CMD_Card777,24453).
-record(pk_Card777,{
	consume = [],
	consume_change = [],
	reset = #pk_ResetP{},
	spec_item = [],
	spec_eq = [],
	normal_item = [],
	normal_eq = []
	}).

-define(CMD_ac_play_award_show,27631).
-record(pk_ac_play_award_show,{
	career = 0,
	item_id = 0,
	chara = 0,
	star = 0,
	bind = 0
	}).

-define(CMD_ac_play_buy_cost,30350).
-record(pk_ac_play_buy_cost,{
	sn = 0,
	tp = 0,
	p1 = 0,
	p2 = 0
	}).

-define(CMD_ac_play,56339).
-record(pk_ac_play,{
	q_id = 0,
	free_num = 0,
	buy_cost = [],
	award_item_show = [],
	award_eq_show = []
	}).

-define(CMD_f_sign_condition,27541).
-record(pk_f_sign_condition,{
	day = 0,
	cond_type = 0,
	cond_param = 0,
	rep_cost_type = 0,
	rep_cost_id = 0,
	rep_cost_num = 0
	}).

-define(CMD_f_sign_award,4486).
-record(pk_f_sign_award,{
	day = 0,
	type = 0,
	id = 0,
	chara = 0,
	star = 0,
	num = 0,
	bind = 0,
	vfx = 0,
	rep = 0
	}).

-define(CMD_f_sign_total_condition,32670).
-record(pk_f_sign_total_condition,{
	group = 0,
	type = 0,
	param = 0
	}).

-define(CMD_f_sign_total_award,48985).
-record(pk_f_sign_total_award,{
	day = 0,
	type = 0,
	id = 0,
	chara = 0,
	star = 0,
	num = 0,
	bind = 0,
	vfx = 0
	}).

-define(CMD_f_sign_final_condition,40536).
-record(pk_f_sign_final_condition,{
	group = 0,
	type = 0,
	param = 0
	}).

-define(CMD_f_sign_final_award,10922).
-record(pk_f_sign_final_award,{
	type = 0,
	id = 0,
	chara = 0,
	star = 0,
	num = 0,
	bind = 0,
	vfx = 0
	}).

-define(CMD_f_sign,43604).
-record(pk_f_sign,{
	id = 0,
	type = 0,
	cond_list = [],
	award_list = [],
	total_cond_list = [],
	total_award_list = [],
	final_cond_list = [],
	final_award_list = [],
	model = []
	}).

-define(CMD_Fireworks,53310).
-record(pk_Fireworks,{
	id = 0,
	exchangeid = 0,
	item = [],
	turnplate = 0,
	awardEquip = [],
	awardItem = [],
	model = [],
	condPara = [],
	awardEquipNew1 = [],
	awardParaNew1 = [],
	upperLimit = 0,
	lowerLimit = 0
	}).

-define(CMD_U2GS_GetFireworksAward,25580).
-record(pk_U2GS_GetFireworksAward,{
	index = 0
	}).

-define(CMD_GS2U_GetFireworksAwardRet,34004).
-record(pk_GS2U_GetFireworksAwardRet,{
	index = 0,
	errCode = 0
	}).

-define(CMD_change_package,19065).
-record(pk_change_package,{
	id = 0,
	package_num = "",
	text = "",
	award_item = [],
	award_eq = [],
	app_shop = "",
	remind = "",
	type = 0
	}).

-define(CMD_U2GS_get_change_package_award,63269).
-record(pk_U2GS_get_change_package_award,{
	ac_id = 0
	}).

-define(CMD_GS2U_get_change_package_award_ret,8751).
-record(pk_GS2U_get_change_package_award_ret,{
	ac_id = 0,
	err_code = 0
	}).

-define(CMD_U2GS_GetFirstRechargeResetReq,36699).
-record(pk_U2GS_GetFirstRechargeResetReq,{
	ac_id = 0
	}).

-define(CMD_GS2U_FirstRechargeResetRet,52842).
-record(pk_GS2U_FirstRechargeResetRet,{
	ac_id = 0,
	err_code = 0
	}).

-define(CMD_firstRechargeRestInfo,24669).
-record(pk_firstRechargeRestInfo,{
	max_times = 0,
	reset_text = ""
	}).

-define(CMD_type_traw,24701).
-record(pk_type_traw,{
	draw_times = 0,
	base_expectation = 0,
	a_expectation = 0,
	s_expectation = 0,
	ss_expectation = 0,
	sss_expectation = 0
	}).

-define(CMD_times_reward_item,31929).
-record(pk_times_reward_item,{
	index = 0,
	draw_times = 0,
	career = 0,
	type = 0,
	itemID = 0,
	count = 0,
	quality = 0,
	star = 0,
	bind = 0
	}).

-define(CMD_dragon_treasure,62806).
-record(pk_dragon_treasure,{
	consWay = [],
	purchase = [],
	choose_num = [],
	type_traw = [],
	times_reward_item = [],
	base_item = [],
	type_A_item = [],
	type_S_item = [],
	type_SS_item = [],
	type_SSS_item = [],
	notice = []
	}).

-define(CMD_GS2U_dragon_treasure_ret,25751).
-record(pk_GS2U_dragon_treasure_ret,{
	id = 0,
	err = 0,
	info = #pk_dragon_treasure{},
	select_ids = [],
	draw_ids = [],
	times_rewards = []
	}).

-define(CMD_U2GS_DragonTreasureSelectReward,783).
-record(pk_U2GS_DragonTreasureSelectReward,{
	ac_id = 0,
	select_ids = []
	}).

-define(CMD_GS2U_DragonTreasureSelectRewardRet,34814).
-record(pk_GS2U_DragonTreasureSelectRewardRet,{
	err_code = 0,
	ac_id = 0,
	select_ids = []
	}).

-define(CMD_U2GS_DragonTreasureDraw,5803).
-record(pk_U2GS_DragonTreasureDraw,{
	ac_id = 0,
	pos = 0
	}).

-define(CMD_GS2U_DragonTreasureDrawRet,24406).
-record(pk_GS2U_DragonTreasureDrawRet,{
	err_code = 0,
	ac_id = 0,
	pos = 0,
	index = 0
	}).

-define(CMD_U2GS_DragonTreasureGetTimesReward,50878).
-record(pk_U2GS_DragonTreasureGetTimesReward,{
	ac_id = 0,
	index = 0
	}).

-define(CMD_GS2U_DragonTreasureGetTimesRewardRet,3512).
-record(pk_GS2U_DragonTreasureGetTimesRewardRet,{
	err_code = 0,
	ac_id = 0,
	index = 0
	}).

-define(CMD_U2GS_DragonTreasureBuyConsumeReq,29442).
-record(pk_U2GS_DragonTreasureBuyConsumeReq,{
	id = 0,
	num = 0
	}).

-define(CMD_GS2U_DragonTreasureBuyConsumeRet,42796).
-record(pk_GS2U_DragonTreasureBuyConsumeRet,{
	id = 0,
	num = 0,
	err = 0
	}).

-define(CMD_U2GS_requestActivityBaseinfoEx,39233).
-record(pk_U2GS_requestActivityBaseinfoEx,{
	teamType = 0
	}).

-define(CMD_U2GS_RequestMapCurse,9244).
-record(pk_U2GS_RequestMapCurse,{
	mapDataID = 0
	}).

-define(CMD_GS2U_RequestMapCurseRet,44413).
-record(pk_GS2U_RequestMapCurseRet,{
	errCode = 0,
	mapDataID = 0,
	boughtTimes = 0,
	isMax = false
	}).

-define(CMD_GS2U_SyncMapCurse,55708).
-record(pk_GS2U_SyncMapCurse,{
	mapDataID = 0,
	value = 0
	}).

-define(CMD_U2GS_BuyCMMapEnterTime,9181).
-record(pk_U2GS_BuyCMMapEnterTime,{
	mapDataID = 0
	}).

-define(CMD_GS2U_BuyCMMapEnterTimeRet,52277).
-record(pk_GS2U_BuyCMMapEnterTimeRet,{
	errCode = 0,
	mapDataID = 0
	}).

-define(CMD_U2GS_getDailyTopInfo,30992).
-record(pk_U2GS_getDailyTopInfo,{
	id = 0
	}).

-define(CMD_dailyTopPlayer,13192).
-record(pk_dailyTopPlayer,{
	playerID = 0,
	name = "",
	sex = 0,
	title_id = 0,
	honor = 0,
	career = 0,
	eq_list = [],
	wingCfgID = 0,
	value = 0,
	rank = 0,
	nationality_id = 0,
	weapon_id = 0,
	weapon_vfx = 0,
	weapon_level = 0,
	weapon_star = 0
	}).

-define(CMD_top_of_day,12425).
-record(pk_top_of_day,{
	day = 0,
	top_type = 0,
	rank_list = []
	}).

-define(CMD_GS2U_sendDailyTopInfo,22557).
-record(pk_GS2U_sendDailyTopInfo,{
	id = 0,
	curDay = 0,
	curValue = 0,
	top_list = []
	}).

-define(CMD_U2GS_RequestBuyCMMapTimes,49118).
-record(pk_U2GS_RequestBuyCMMapTimes,{
	buyTimes = 0
	}).

-define(CMD_GS2U_RequestBuyCMMapTimesRet,8580).
-record(pk_GS2U_RequestBuyCMMapTimesRet,{
	errCode = 0,
	remainTimes = 0
	}).

-define(CMD_U2GS_ArtiDungeonBuy,18879).
-record(pk_U2GS_ArtiDungeonBuy,{
	freeCount = 0,
	payCount = 0
	}).

-define(CMD_GS2U_ArtiDungeonBuy,61606).
-record(pk_GS2U_ArtiDungeonBuy,{
	freeCount = 0,
	payCount = 0,
	errorCode = 0
	}).

-define(CMD_U2GS_buySalesFunds,25875).
-record(pk_U2GS_buySalesFunds,{
	id = 0,
	index = 0
	}).

-define(CMD_GS2U_buySalesFundsResult,37731).
-record(pk_GS2U_buySalesFundsResult,{
	id = 0,
	index = 0,
	result = 0
	}).

-define(CMD_U2GS_getSalesFundsAward,5472).
-record(pk_U2GS_getSalesFundsAward,{
	id = 0,
	index = 0
	}).

-define(CMD_GS2U_getSalesFundsAwardResult,62793).
-record(pk_GS2U_getSalesFundsAwardResult,{
	id = 0,
	index = 0,
	result = 0
	}).

-define(CMD_U2GS_requestBrideInfo,60276).
-record(pk_U2GS_requestBrideInfo,{
	ownerID = 0
	}).

-define(CMD_U2GS_pk_mode_change,33008).
-record(pk_U2GS_pk_mode_change,{
	mode = 0
	}).

-define(CMD_GS2U_pk_mode_change,44231).
-record(pk_GS2U_pk_mode_change,{
	player_id = 0,
	mode = 0
	}).

-define(CMD_GS2U_red_value,44532).
-record(pk_GS2U_red_value,{
	player_id = 0,
	red_value = 0
	}).

-define(CMD_GS2U_fight_back_status,12779).
-record(pk_GS2U_fight_back_status,{
	target_player_id = 0,
	status = 0
	}).

-define(CMD_SoulInfo,47466).
-record(pk_SoulInfo,{
	soul_uid = 0,
	cfg_id = 0,
	level = 0,
	star = 0,
	stage = 0
	}).

-define(CMD_SoulPosInfo,49365).
-record(pk_SoulPosInfo,{
	position = 0,
	soul_uid = 0
	}).

-define(CMD_GS2U_SoulList,39709).
-record(pk_GS2U_SoulList,{
	soul_list = [],
	soul_equip_list = []
	}).

-define(CMD_GS2U_SoulUpdate,46109).
-record(pk_GS2U_SoulUpdate,{
	soul = []
	}).

-define(CMD_U2GS_SoulEquipOn,48408).
-record(pk_U2GS_SoulEquipOn,{
	position = 0,
	soul_uid = 0
	}).

-define(CMD_U2GS_SoulEquipOff,10779).
-record(pk_U2GS_SoulEquipOff,{
	position = 0,
	soul_uid = 0
	}).

-define(CMD_GS2U_SoulPosUpdate,19346).
-record(pk_GS2U_SoulPosUpdate,{
	soul_pos = #pk_SoulPosInfo{}
	}).

-define(CMD_U2GS_SoulAddLevel,34066).
-record(pk_U2GS_SoulAddLevel,{
	soul_uid = 0,
	add_lv = 0
	}).

-define(CMD_GS2U_SoulAddLevelRet,19360).
-record(pk_GS2U_SoulAddLevelRet,{
	err_code = 0,
	soul_uid = 0
	}).

-define(CMD_U2GS_SoulAddStar,4369).
-record(pk_U2GS_SoulAddStar,{
	soul_uid = 0
	}).

-define(CMD_GS2U_SoulAddStarRet,3417).
-record(pk_GS2U_SoulAddStarRet,{
	err_code = 0,
	soul_uid = 0
	}).

-define(CMD_U2GS_SoulAddStage,31587).
-record(pk_U2GS_SoulAddStage,{
	soul_uid = 0
	}).

-define(CMD_GS2U_SoulAddStageRet,48958).
-record(pk_GS2U_SoulAddStageRet,{
	err_code = 0,
	soul_uid = 0
	}).

-define(CMD_U2GS_SoulSeparate,19401).
-record(pk_U2GS_SoulSeparate,{
	soul_uid = 0
	}).

-define(CMD_GS2U_SoulSeparateRet,54980).
-record(pk_GS2U_SoulSeparateRet,{
	err_code = 0
	}).

-define(CMD_U2GS_SoulFade,9550).
-record(pk_U2GS_SoulFade,{
	soul_uids = []
	}).

-define(CMD_GS2U_SoulFadeRet,63573).
-record(pk_GS2U_SoulFadeRet,{
	err_code = 0
	}).

-define(CMD_item_info,53803).
-record(pk_item_info,{
	id = 0,
	cfg_id = 0,
	bind = 0,
	expire_time = 0,
	amount = 0
	}).

-define(CMD_item_bag_info,50019).
-record(pk_item_bag_info,{
	bag_type = 0,
	capacity = 0,
	extend = 0,
	item_list = []
	}).

-define(CMD_GS2U_item_bag_list,61071).
-record(pk_GS2U_item_bag_list,{
	bag_list = []
	}).

-define(CMD_GS2U_item_bag_change,47562).
-record(pk_GS2U_item_bag_change,{
	bag_type = 0,
	capacity = 0,
	extend = 0,
	delete_item_list = [],
	update_item_list = []
	}).

-define(CMD_U2GS_item_bag_capacity,768).
-record(pk_U2GS_item_bag_capacity,{
	bag_id = 0,
	count = 0,
	currency = 0
	}).

-define(CMD_GS2U_item_bag_capacity,8351).
-record(pk_GS2U_item_bag_capacity,{
	bag_id = 0,
	error = 0
	}).

-define(CMD_U2GS_item_bag_split,35427).
-record(pk_U2GS_item_bag_split,{
	bag_type = 0,
	id = 0,
	amount = 0
	}).

-define(CMD_GS2U_item_bag_split,48077).
-record(pk_GS2U_item_bag_split,{
	error = 0
	}).

-define(CMD_U2GS_item_bag_merge,56353).
-record(pk_U2GS_item_bag_merge,{
	bag_type = 0
	}).

-define(CMD_GS2U_item_bag_merge,3467).
-record(pk_GS2U_item_bag_merge,{
	bag_type = 0,
	error = 0
	}).

-define(CMD_U2GS_item_bag_transfer,50668).
-record(pk_U2GS_item_bag_transfer,{
	bag_type = 0,
	ids = [],
	target_bag_type = 0
	}).

-define(CMD_GS2U_item_bag_transfer,40841).
-record(pk_GS2U_item_bag_transfer,{
	bag_type = 0,
	ids = [],
	target_bag_type = 0,
	error = 0
	}).

-define(CMD_U2GS_item_bag_sell,32871).
-record(pk_U2GS_item_bag_sell,{
	bag_id = 0,
	delete_item_list = []
	}).

-define(CMD_GS2U_item_bag_sell,25034).
-record(pk_GS2U_item_bag_sell,{
	error = 0,
	money = []
	}).

-define(CMD_ItemUse,62101).
-record(pk_ItemUse,{
	item_id = 0,
	use_count = 0
	}).

-define(CMD_ItemCd,46498).
-record(pk_ItemCd,{
	type = 0,
	count = 0
	}).

-define(CMD_GS2U_ItemUseInfoSync,5492).
-record(pk_GS2U_ItemUseInfoSync,{
	use_info = []
	}).

-define(CMD_GS2U_ItemUseInfoUpdate,7869).
-record(pk_GS2U_ItemUseInfoUpdate,{
	use_info = []
	}).

-define(CMD_GS2U_ItemCdInfoSync,44660).
-record(pk_GS2U_ItemCdInfoSync,{
	cd_info = []
	}).

-define(CMD_GS2U_ItemCdInfoUpdate,50041).
-record(pk_GS2U_ItemCdInfoUpdate,{
	cd_info = []
	}).

-define(CMD_U2GS_EnterRuneTower,32081).
-record(pk_U2GS_EnterRuneTower,{
	dungeonID = 0
	}).

-define(CMD_U2GS_DragonTowerBless,12896).
-record(pk_U2GS_DragonTowerBless,{
	}).

-define(CMD_GS2U_DragonTowerBlessRet,18949).
-record(pk_GS2U_DragonTowerBlessRet,{
	blessList = [],
	randomBlessList = [],
	error = 0
	}).

-define(CMD_U2GS_DragonTowerChoiceBless,14850).
-record(pk_U2GS_DragonTowerChoiceBless,{
	blessId = 0
	}).

-define(CMD_GS2U_DragonTowerChoiceBlessRet,34148).
-record(pk_GS2U_DragonTowerChoiceBlessRet,{
	blessId = 0,
	randomBlessList = [],
	blessList = [],
	error = 0
	}).

-define(CMD_dragonTowerReward,34626).
-record(pk_dragonTowerReward,{
	dungeonID = 0,
	exp = 0,
	coinList = [],
	itemList = []
	}).

-define(CMD_U2GS_DragonTowerMopUp,6660).
-record(pk_U2GS_DragonTowerMopUp,{
	number = 0
	}).

-define(CMD_GS2U_DragonTowerMopUpRet,481).
-record(pk_GS2U_DragonTowerMopUpRet,{
	number = 0,
	reward_list = [],
	error = 0
	}).

-define(CMD_RuneInfo,56610).
-record(pk_RuneInfo,{
	rune_uid = 0,
	cfg_id = 0,
	star = 0,
	level = 0,
	stage = 0
	}).

-define(CMD_RunePosInfo,34595).
-record(pk_RunePosInfo,{
	role_id = 0,
	position = 0,
	rune_uid = 0
	}).

-define(CMD_GS2U_RuneList,7151).
-record(pk_GS2U_RuneList,{
	rune_list = [],
	rune_equip_list = []
	}).

-define(CMD_GS2U_RuneUpdate,57701).
-record(pk_GS2U_RuneUpdate,{
	rune = []
	}).

-define(CMD_U2GS_RuneEquipOn,39399).
-record(pk_U2GS_RuneEquipOn,{
	role_id = 0,
	position = 0,
	rune_uid = 0
	}).

-define(CMD_U2GS_RuneEquipOff,64748).
-record(pk_U2GS_RuneEquipOff,{
	role_id = 0,
	position = 0,
	rune_uid = 0
	}).

-define(CMD_GS2U_RunePosUpdate,16394).
-record(pk_GS2U_RunePosUpdate,{
	rune_pos = #pk_RunePosInfo{}
	}).

-define(CMD_U2GS_RuneAddLevel,36305).
-record(pk_U2GS_RuneAddLevel,{
	rune_uid = 0,
	add_lv = 0
	}).

-define(CMD_GS2U_RuneAddLevelRet,41489).
-record(pk_GS2U_RuneAddLevelRet,{
	err_code = 0,
	rune_uid = 0
	}).

-define(CMD_U2GS_RuneAddStar,55135).
-record(pk_U2GS_RuneAddStar,{
	rune_uid = 0
	}).

-define(CMD_GS2U_RuneAddStarRet,34219).
-record(pk_GS2U_RuneAddStarRet,{
	err_code = 0,
	rune_uid = 0
	}).

-define(CMD_U2GS_RuneAddStage,28627).
-record(pk_U2GS_RuneAddStage,{
	rune_uid = 0
	}).

-define(CMD_GS2U_RuneAddStageRet,19092).
-record(pk_GS2U_RuneAddStageRet,{
	err_code = 0,
	rune_uid = 0
	}).

-define(CMD_U2GS_RuneSeparate,47230).
-record(pk_U2GS_RuneSeparate,{
	rune_uid = 0
	}).

-define(CMD_GS2U_RuneSeparateRet,53762).
-record(pk_GS2U_RuneSeparateRet,{
	err_code = 0
	}).

-define(CMD_U2GS_RuneFade,18569).
-record(pk_U2GS_RuneFade,{
	rune_uids = []
	}).

-define(CMD_GS2U_RuneFadeRet,23484).
-record(pk_GS2U_RuneFadeRet,{
	err_code = 0
	}).

-define(CMD_FazhenInfo,56345).
-record(pk_FazhenInfo,{
	fazhen_uid = 0,
	star = 0,
	rune_list = []
	}).

-define(CMD_FazhenRuneInfo,49052).
-record(pk_FazhenRuneInfo,{
	rune_uid = 0,
	fazhen_uid = 0,
	level = 0,
	star = 0,
	islock = 0
	}).

-define(CMD_FaZhenRuneViewInfo,42407).
-record(pk_FaZhenRuneViewInfo,{
	fazhen_uid = 0,
	cfg_id = 0,
	star = 0,
	pos = 0,
	rune = []
	}).

-define(CMD_GS2U_SyncFazhenRune,42363).
-record(pk_GS2U_SyncFazhenRune,{
	fazhen_list = [],
	rune_list = [],
	unlock_pos_list = []
	}).

-define(CMD_GS2U_UpdateFazhen,17623).
-record(pk_GS2U_UpdateFazhen,{
	fazhen_list = []
	}).

-define(CMD_GS2U_UpdateFazhenRune,25391).
-record(pk_GS2U_UpdateFazhenRune,{
	rune_list = []
	}).

-define(CMD_U2GS_FazhenPos,44492).
-record(pk_U2GS_FazhenPos,{
	pos = 0
	}).

-define(CMD_GS2U_FazhenPosRet,56773).
-record(pk_GS2U_FazhenPosRet,{
	pos = 0,
	err_code = 0
	}).

-define(CMD_U2GS_FazhenEquip,29708).
-record(pk_U2GS_FazhenEquip,{
	role_id = 0,
	fazhen_uid = []
	}).

-define(CMD_GS2U_FazhenEquipRet,16156).
-record(pk_GS2U_FazhenEquipRet,{
	err_code = 0,
	role_id = 0,
	fazhen_uid = []
	}).

-define(CMD_U2GS_FazhenOff,16488).
-record(pk_U2GS_FazhenOff,{
	role_id = 0,
	fazhen_uid = []
	}).

-define(CMD_GS2U_FazhenOffRet,38182).
-record(pk_GS2U_FazhenOffRet,{
	role_id = 0,
	fazhen_uid = [],
	err_code = 0
	}).

-define(CMD_U2GS_FazhenRuneBreakDown,45946).
-record(pk_U2GS_FazhenRuneBreakDown,{
	fazhen_uid_list = [],
	rune_uid_list = [],
	item_uid_list = []
	}).

-define(CMD_GS2U_FazhenRuneBreakDownRet,37724).
-record(pk_GS2U_FazhenRuneBreakDownRet,{
	coinList = [],
	itemList = [],
	err_code = 0
	}).

-define(CMD_U2GS_FazhenAddStar,65251).
-record(pk_U2GS_FazhenAddStar,{
	fazhen_uid_list = []
	}).

-define(CMD_GS2U_FazhenAddStarRet,16350).
-record(pk_GS2U_FazhenAddStarRet,{
	fazhen_uid = [],
	err_code = 0
	}).

-define(CMD_FazhenRunePosInfo,47737).
-record(pk_FazhenRunePosInfo,{
	fazhen_uid = 0,
	rune_pos = 0,
	rune_uid = 0
	}).

-define(CMD_U2GS_FazhenRuneOn,7015).
-record(pk_U2GS_FazhenRuneOn,{
	role_id = 0,
	fazhen_pos_rune = []
	}).

-define(CMD_GS2U_FazhenRuneOnRet,6088).
-record(pk_GS2U_FazhenRuneOnRet,{
	role_id = 0,
	fazhen_pos_rune = [],
	err_code = 0
	}).

-define(CMD_U2GS_FazhenRuneOff,58428).
-record(pk_U2GS_FazhenRuneOff,{
	role_id = 0,
	fazhen_pos_rune = []
	}).

-define(CMD_GS2U_FazhenRuneOffRet,6582).
-record(pk_GS2U_FazhenRuneOffRet,{
	role_id = 0,
	fazhen_pos_rune = [],
	err_code = 0
	}).

-define(CMD_U2GS_FazhenRuneAddLv,33389).
-record(pk_U2GS_FazhenRuneAddLv,{
	rune_lv = []
	}).

-define(CMD_GS2U_FazhenRuneAddLvRet,7335).
-record(pk_GS2U_FazhenRuneAddLvRet,{
	rune_lv = [],
	err_code = 0
	}).

-define(CMD_U2GS_FazhenRuneAddStar,19907).
-record(pk_U2GS_FazhenRuneAddStar,{
	rune_uid = []
	}).

-define(CMD_GS2U_FazhenRuneAddStarRet,40986).
-record(pk_GS2U_FazhenRuneAddStarRet,{
	rune_uid = [],
	err_code = 0
	}).

-define(CMD_U2GS_FazhenRunelock,35778).
-record(pk_U2GS_FazhenRunelock,{
	rune_uid = 0,
	islock = 0
	}).

-define(CMD_GS2U_FazhenRunelockRet,17776).
-record(pk_GS2U_FazhenRunelockRet,{
	rune_uid = 0,
	islock = 0,
	err_code = 0
	}).

-define(CMD_RoleAstrolabe,23983).
-record(pk_RoleAstrolabe,{
	role_id = 0,
	pos_num = 0,
	astro_id_list = []
	}).

-define(CMD_GS2U_AEquipList,8504).
-record(pk_GS2U_AEquipList,{
	aequips1 = [],
	aequips2 = []
	}).

-define(CMD_AEquipPos,26210).
-record(pk_AEquipPos,{
	position = 0,
	equip_uid = 0
	}).

-define(CMD_Astrolabe,15392).
-record(pk_Astrolabe,{
	id = 0,
	equips = []
	}).

-define(CMD_GS2U_AstrolabeList,21734).
-record(pk_GS2U_AstrolabeList,{
	roleAstrolabeList = [],
	astrolabes = []
	}).

-define(CMD_GS2U_RoleAstrolabeUpdate,28861).
-record(pk_GS2U_RoleAstrolabeUpdate,{
	roleAstrolabe = #pk_RoleAstrolabe{}
	}).

-define(CMD_GS2U_AstrolabeUpdate,31546).
-record(pk_GS2U_AstrolabeUpdate,{
	astrolabe = #pk_Astrolabe{}
	}).

-define(CMD_GS2U_AEquipUpdate,57030).
-record(pk_GS2U_AEquipUpdate,{
	aequips = []
	}).

-define(CMD_U2GS_AstroEquipOn,31325).
-record(pk_U2GS_AstroEquipOn,{
	position = 0,
	astro_id = 0,
	aequip_uid = 0,
	is_lv_transfer = 0
	}).

-define(CMD_U2GS_AstroEquipOff,37860).
-record(pk_U2GS_AstroEquipOff,{
	position = 0,
	astro_id = 0,
	aequip_uid = 0
	}).

-define(CMD_U2GS_AstroAssistOp,17769).
-record(pk_U2GS_AstroAssistOp,{
	type = 0,
	role_id = 0,
	astro_id = 0,
	replace_astro_id = 0
	}).

-define(CMD_GS2U_AstroAssistOpRet,56431).
-record(pk_GS2U_AstroAssistOpRet,{
	err_code = 0,
	type = 0,
	role_id = 0,
	astro_id = 0,
	replace_astro_id = 0
	}).

-define(CMD_U2GS_AstroExtendAssistNum,45786).
-record(pk_U2GS_AstroExtendAssistNum,{
	role_id = 0
	}).

-define(CMD_GS2U_AstroExtendAssistNumRet,36849).
-record(pk_GS2U_AstroExtendAssistNumRet,{
	role_id = 0,
	err_code = 0
	}).

-define(CMD_U2GS_AstroOneKeyOp,21971).
-record(pk_U2GS_AstroOneKeyOp,{
	astro_id = 0,
	op = 0,
	aequips = [],
	is_lv_transfer = 0
	}).

-define(CMD_GS2U_AstroOneKeyOpRet,11040).
-record(pk_GS2U_AstroOneKeyOpRet,{
	astro_id = 0,
	err_code = 0,
	op = 0,
	is_lv_transfer = 0
	}).

-define(CMD_U2GS_AEquipAddLevel,16545).
-record(pk_U2GS_AEquipAddLevel,{
	aequip_id = 0,
	is_double = false,
	costlist = []
	}).

-define(CMD_GS2U_AEquipAddLevelRet,6152).
-record(pk_GS2U_AEquipAddLevelRet,{
	err_code = 0,
	aequip_id = 0
	}).

-define(CMD_U2GS_AEquipDismantle,50890).
-record(pk_U2GS_AEquipDismantle,{
	aequip_id = 0
	}).

-define(CMD_GS2U_AEquipDismantleRet,879).
-record(pk_GS2U_AEquipDismantleRet,{
	err_code = 0
	}).

-define(CMD_DropItem,32719).
-record(pk_DropItem,{
	uid = 0,
	playerid = 0,
	teamid = 0,
	time = 0,
	id = 0,
	num = 0,
	quality = 0,
	star = 0,
	x = 0,
	y = 0,
	source_id = 0
	}).

-define(CMD_GS2U_DropItemNotify,61257).
-record(pk_GS2U_DropItemNotify,{
	items = []
	}).

-define(CMD_U2GS_GetDropItem,32098).
-record(pk_U2GS_GetDropItem,{
	uid = 0
	}).

-define(CMD_GS2U_GetDropItemRet,52520).
-record(pk_GS2U_GetDropItemRet,{
	errorCode = 0
	}).

-define(CMD_GS2U_DropItemCleanNotify,64093).
-record(pk_GS2U_DropItemCleanNotify,{
	uid = [],
	playerid = 0
	}).

-define(CMD_Dialog_Item,60513).
-record(pk_Dialog_Item,{
	item_id = 0,
	count = 0,
	multiple = 0,
	bind = 0,
	time_limt = 0
	}).

-define(CMD_Dialog_Coin,11986).
-record(pk_Dialog_Coin,{
	type = 0,
	amount = 0,
	multiple = 0
	}).

-define(CMD_U2GS_startHang,26633).
-record(pk_U2GS_startHang,{
	}).

-define(CMD_GS2U_startHangResult,32329).
-record(pk_GS2U_startHangResult,{
	result = 0
	}).

-define(CMD_U2GS_stopHang,19272).
-record(pk_U2GS_stopHang,{
	}).

-define(CMD_GS2U_soptHangResult,56240).
-record(pk_GS2U_soptHangResult,{
	result = 0
	}).

-define(CMD_U2GS_getHangData,32978).
-record(pk_U2GS_getHangData,{
	}).

-define(CMD_expEffect,53401).
-record(pk_expEffect,{
	player_id = 0,
	name = "",
	sex = 0,
	exp_effect = 0,
	rank = 0
	}).

-define(CMD_GS2U_sendHangData,603).
-record(pk_GS2U_sendHangData,{
	inHang = false,
	onlineStart = 0,
	hangTime = 0,
	exp1 = 0,
	exp2 = 0,
	level = 0,
	coin1 = 0,
	coin2 = 0,
	item_list1 = [],
	eq_list1 = [],
	item_list2 = [],
	eq_list2 = [],
	cur_exp = 0,
	cur_coin = 0,
	fade_num = 0,
	fade_exp = 0,
	cur_item_list = [],
	cur_eq_list = [],
	effect_list = [],
	curr_list = []
	}).

-define(CMD_U2GS_getHangStartTime,11136).
-record(pk_U2GS_getHangStartTime,{
	}).

-define(CMD_GS2U_HangStartTime,12942).
-record(pk_GS2U_HangStartTime,{
	time = 0
	}).

-define(CMD_U2GS_getHangAward,5717).
-record(pk_U2GS_getHangAward,{
	}).

-define(CMD_GS2U_getHangAwardResult,34047).
-record(pk_GS2U_getHangAwardResult,{
	result = 0
	}).

-define(CMD_U2GS_requestQuickAwardInfo,56195).
-record(pk_U2GS_requestQuickAwardInfo,{
	}).

-define(CMD_GS2U_requestQuickAwardInfoRet,12490).
-record(pk_GS2U_requestQuickAwardInfoRet,{
	exp = 0,
	coin = 0,
	level = 0,
	item_list = [],
	eq_list = []
	}).

-define(CMD_U2GS_getQuickHangAward,23189).
-record(pk_U2GS_getQuickHangAward,{
	}).

-define(CMD_GS2U_getQuickHangAwardRet,29864).
-record(pk_GS2U_getQuickHangAwardRet,{
	result = 0
	}).

-define(CMD_U2GS_synthic,9119).
-record(pk_U2GS_synthic,{
	id = 0,
	type2 = 0,
	type3 = 0,
	type4 = 0,
	type5 = 0,
	itemBack = false,
	times = 0,
	dbIDList = [],
	dbIDList2 = [],
	flag = 0
	}).

-define(CMD_GS2U_synthicResult,23069).
-record(pk_GS2U_synthicResult,{
	id = 0,
	type2 = 0,
	type3 = 0,
	type4 = 0,
	type5 = 0,
	sucTimes = 0,
	result = 0,
	backList = [],
	itemList = []
	}).

-define(CMD_synthetic_info,5956).
-record(pk_synthetic_info,{
	id = 0,
	type2 = 0,
	type3 = 0,
	type4 = 0,
	type5 = 0,
	cf_times = 0
	}).

-define(CMD_GS2U_update_synthetic_info,62991).
-record(pk_GS2U_update_synthetic_info,{
	synthetic_info_list = []
	}).

-define(CMD_U2GS_quickSynthetic,58977).
-record(pk_U2GS_quickSynthetic,{
	itemID = 0,
	allNum = 0
	}).

-define(CMD_GS2U_quickSynthetic,6091).
-record(pk_GS2U_quickSynthetic,{
	errorCode = 0,
	itemID = 0
	}).

-define(CMD_pantheconCollection,38852).
-record(pk_pantheconCollection,{
	level = 0,
	collectTimes = 0
	}).

-define(CMD_GS2U_sendPantheonCollectInfo,36048).
-record(pk_GS2U_sendPantheonCollectInfo,{
	collect_list = []
	}).

-define(CMD_GemPosInfo,48138).
-record(pk_GemPosInfo,{
	pos = 0,
	gem_uid = 0,
	gem_cfg_id = 0
	}).

-define(CMD_CastProp,32057).
-record(pk_CastProp,{
	pos = 0,
	index = 0,
	value = 0,
	character = 0
	}).

-define(CMD_EqPosInfo,57702).
-record(pk_EqPosInfo,{
	role_id = 0,
	pos = 0,
	equid = 0,
	intensity_lv = 0,
	intensity_t_lv = 0,
	add_lv = 0,
	add_t_lv = 0,
	ele_intensity_atk_lv = 0,
	ele_intensity_def_lv = 0,
	ele_intensity_atk_break_lv = 0,
	ele_intensity_def_break_lv = 0,
	ele_add_atk_lv = 0,
	ele_add_def_lv = 0,
	gem_refine_lv = 0,
	gem_refine_exp = 0,
	gem_list = [],
	cast_prop = [],
	gd_prop = [],
	suit_lv = [],
	card = [],
	fazhen = 0
	}).

-define(CMD_CostList,25925).
-record(pk_CostList,{
	item_id = 0,
	num = 0
	}).

-define(CMD_EqMaster,37621).
-record(pk_EqMaster,{
	role_id = 0,
	type = 0,
	level = 0
	}).

-define(CMD_GS2U_EqList,35847).
-record(pk_GS2U_EqList,{
	eqs = [],
	eqps = [],
	eq_master = []
	}).

-define(CMD_GS2U_EqUpdate,15028).
-record(pk_GS2U_EqUpdate,{
	eqs = []
	}).

-define(CMD_GS2U_EqPosUpdate,60514).
-record(pk_GS2U_EqPosUpdate,{
	eqps = []
	}).

-define(CMD_GS2U_EqMasterUpdate,18372).
-record(pk_GS2U_EqMasterUpdate,{
	eq_master = []
	}).

-define(CMD_U2GS_EquipOp,20917).
-record(pk_U2GS_EquipOp,{
	type = 0,
	equid = 0,
	role_id = 0
	}).

-define(CMD_GS2U_EquipOpRet,3046).
-record(pk_GS2U_EquipOpRet,{
	err_code = 0,
	type = 0,
	equid = 0,
	role_id = 0
	}).

-define(CMD_U2GS_EqAddLevel,57297).
-record(pk_U2GS_EqAddLevel,{
	role_id = 0,
	equid = 0
	}).

-define(CMD_GS2U_EqAddLevelRet,21778).
-record(pk_GS2U_EqAddLevelRet,{
	err_code = 0,
	role_id = 0,
	equid = 0,
	is_success = 0
	}).

-define(CMD_U2GS_EqAddAdd,19011).
-record(pk_U2GS_EqAddAdd,{
	role_id = 0,
	equid = 0,
	intact_num = 0
	}).

-define(CMD_U2GS_EqEleAddLevel,3365).
-record(pk_U2GS_EqEleAddLevel,{
	role_id = 0,
	equid = 0,
	type = 0
	}).

-define(CMD_GS2U_EqEleAddLevelRet,19850).
-record(pk_GS2U_EqEleAddLevelRet,{
	err_code = 0,
	role_id = 0,
	equid = 0,
	type = 0
	}).

-define(CMD_U2GS_EqEleLevelBreak,2238).
-record(pk_U2GS_EqEleLevelBreak,{
	role_id = 0,
	equid = 0,
	type = 0
	}).

-define(CMD_GS2U_EqEleLevelBreakRet,23003).
-record(pk_GS2U_EqEleLevelBreakRet,{
	err_code = 0,
	role_id = 0,
	equid = 0,
	type = 0
	}).

-define(CMD_U2GS_EqEleAddAdd,35195).
-record(pk_U2GS_EqEleAddAdd,{
	role_id = 0,
	equid = 0,
	type = 0
	}).

-define(CMD_GS2U_EqEleAddAddRet,37592).
-record(pk_GS2U_EqEleAddAddRet,{
	err_code = 0,
	role_id = 0,
	equid = 0,
	type = 0
	}).

-define(CMD_U2GS_EqFade,17534).
-record(pk_U2GS_EqFade,{
	equids = []
	}).

-define(CMD_GS2U_EqFadeRet,42658).
-record(pk_GS2U_EqFadeRet,{
	err_code = 0
	}).

-define(CMD_U2GS_EqCast,55865).
-record(pk_U2GS_EqCast,{
	role_id = 0,
	equid = 0,
	type = 0,
	lock_indes = []
	}).

-define(CMD_GS2U_EqCastRet,11629).
-record(pk_GS2U_EqCastRet,{
	err_code = 0,
	role_id = 0,
	equid = 0
	}).

-define(CMD_U2GS_EqCastHoleExtend,62805).
-record(pk_U2GS_EqCastHoleExtend,{
	role_id = 0,
	equid = 0,
	pos = 0
	}).

-define(CMD_GS2U_EqCastHoleExtendRet,3316).
-record(pk_GS2U_EqCastHoleExtendRet,{
	err_code = 0,
	role_id = 0,
	equid = 0,
	pos = 0
	}).

-define(CMD_U2GS_EqGemEquipOn,64979).
-record(pk_U2GS_EqGemEquipOn,{
	role_id = 0,
	eq_uid = 0,
	gem_uid = 0,
	pos = 0
	}).

-define(CMD_U2GS_EqGemEquipOff,2523).
-record(pk_U2GS_EqGemEquipOff,{
	role_id = 0,
	eq_uid = 0,
	gem_uid = 0,
	pos = 0
	}).

-define(CMD_GS2U_EqGemEquipRet,23427).
-record(pk_GS2U_EqGemEquipRet,{
	op = 0,
	err_code = 0,
	role_id = 0,
	eq_uid = 0,
	gem_uid = 0,
	pos = 0
	}).

-define(CMD_U2GS_EqGem1KeyEquipOn,51350).
-record(pk_U2GS_EqGem1KeyEquipOn,{
	role_id = 0,
	eq_uid = 0,
	equip_list = []
	}).

-define(CMD_GS2U_EqGem1KeyEquipOnRet,45326).
-record(pk_GS2U_EqGem1KeyEquipOnRet,{
	err_code = 0,
	role_id = 0,
	eq_uid = 0
	}).

-define(CMD_U2GS_EqGem1KeyEquipOff,52298).
-record(pk_U2GS_EqGem1KeyEquipOff,{
	role_id = 0,
	eq_uid = 0
	}).

-define(CMD_GS2U_EqGem1KeyEquipOffRet,33005).
-record(pk_GS2U_EqGem1KeyEquipOffRet,{
	err_code = 0,
	role_id = 0,
	eq_uid = 0
	}).

-define(CMD_U2GS_EqGemAddLevel,39616).
-record(pk_U2GS_EqGemAddLevel,{
	role_id = 0,
	equid = 0,
	costs = []
	}).

-define(CMD_GS2U_EqGemAddLevelRet,7181).
-record(pk_GS2U_EqGemAddLevelRet,{
	err_code = 0
	}).

-define(CMD_U2GS_EqGemDismantle,4787).
-record(pk_U2GS_EqGemDismantle,{
	uid = 0
	}).

-define(CMD_GS2U_EqGemDismantleRet,57898).
-record(pk_GS2U_EqGemDismantleRet,{
	err_code = 0
	}).

-define(CMD_U2GS_EqSuitAdd,31047).
-record(pk_U2GS_EqSuitAdd,{
	role_id = 0,
	equid = 0,
	type = 0
	}).

-define(CMD_GS2U_EqSuitAddRet,53510).
-record(pk_GS2U_EqSuitAddRet,{
	err_code = 0,
	role_id = 0,
	equid = 0,
	type = 0,
	now_suit_lv = 0
	}).

-define(CMD_U2GS_EqSuitDismantle,57602).
-record(pk_U2GS_EqSuitDismantle,{
	role_id = 0,
	pos = 0,
	type = 0
	}).

-define(CMD_GS2U_EqSuitDismantleRet,6304).
-record(pk_GS2U_EqSuitDismantleRet,{
	err_code = 0,
	role_id = 0,
	pos = 0,
	type = 0
	}).

-define(CMD_U2GS_EqMasterAdd,29621).
-record(pk_U2GS_EqMasterAdd,{
	role_id = 0,
	type = 0
	}).

-define(CMD_GS2U_EqMasterAddRet,33041).
-record(pk_GS2U_EqMasterAddRet,{
	role_id = 0,
	type = 0,
	level = 0,
	err_code = 0
	}).

-define(CMD_GS2U_fade_privilege_info,16667).
-record(pk_GS2U_fade_privilege_info,{
	lv = 0,
	time = 0
	}).

-define(CMD_GS2U_recharge_fade_privilege_ret,55256).
-record(pk_GS2U_recharge_fade_privilege_ret,{
	lv = 0,
	time = 0,
	err_code = 0
	}).

-define(CMD_GS2U_equip_off_back,47420).
-record(pk_GS2U_equip_off_back,{
	back_list = []
	}).

-define(CMD_U2GS_EqPolaritySelectReq,4026).
-record(pk_U2GS_EqPolaritySelectReq,{
	eq_uid = 0,
	target_polarity = 0,
	is_use_special = false
	}).

-define(CMD_GS2U_EqPolaritySelectRet,59250).
-record(pk_GS2U_EqPolaritySelectRet,{
	eq_uid = 0,
	target_polarity = 0,
	err_code = 0
	}).

-define(CMD_U2GS_eq_forge_req,18868).
-record(pk_U2GS_eq_forge_req,{
	base_eq_uid = 0,
	used_list = []
	}).

-define(CMD_GS2U_eq_forge_ret,59604).
-record(pk_GS2U_eq_forge_ret,{
	base_eq_uid = 0,
	is_success = 0,
	err_code = 0
	}).

-define(CMD_LordRingPosInfo,22408).
-record(pk_LordRingPosInfo,{
	pos = 0,
	uid = 0
	}).

-define(CMD_RoleLordRingPosInfo,55157).
-record(pk_RoleLordRingPosInfo,{
	role_id = 0,
	ring_list = []
	}).

-define(CMD_U2GS_LordRingOpReq,21968).
-record(pk_U2GS_LordRingOpReq,{
	role_id = 0,
	type = 0,
	uid = 0
	}).

-define(CMD_GS2U_LordRingOpRet,25681).
-record(pk_GS2U_LordRingOpRet,{
	role_id = 0,
	err_code = 0,
	type = 0,
	uid = 0
	}).

-define(CMD_GS2U_LordRingList,10797).
-record(pk_GS2U_LordRingList,{
	lrps = []
	}).

-define(CMD_GS2U_LordRingPosUpdate,32547).
-record(pk_GS2U_LordRingPosUpdate,{
	lrps = []
	}).

-define(CMD_PetInfo,22560).
-record(pk_PetInfo,{
	pet_id = 0,
	pet_lv = 0,
	pet_exp = 0,
	break_lv = 0,
	star = 0,
	grade = 0,
	awaken_lv = 0,
	awaken_potential = 0,
	is_rein = 0,
	ultimate_skill_lv = 0
	}).

-define(CMD_GS2U_PetUpdate,19201).
-record(pk_GS2U_PetUpdate,{
	pets = []
	}).

-define(CMD_GS2U_PetEquipList,15945).
-record(pk_GS2U_PetEquipList,{
	pet_list = []
	}).

-define(CMD_U2GS_PetOut,55625).
-record(pk_U2GS_PetOut,{
	pos = 0,
	pet_id = 0
	}).

-define(CMD_GS2U_PetOutRet,15702).
-record(pk_GS2U_PetOutRet,{
	op = 0,
	err_code = 0
	}).

-define(CMD_U2GS_PetAddLv,46145).
-record(pk_U2GS_PetAddLv,{
	pet_id = 0,
	costs = []
	}).

-define(CMD_GS2U_PetAddLvRet,14038).
-record(pk_GS2U_PetAddLvRet,{
	pet_id = 0,
	err_code = 0
	}).

-define(CMD_U2GS_PetAutoAddLv,57939).
-record(pk_U2GS_PetAutoAddLv,{
	pet_id = 0
	}).

-define(CMD_GS2U_PetAutoAddLvRet,14048).
-record(pk_GS2U_PetAutoAddLvRet,{
	pet_id = 0,
	err_code = 0
	}).

-define(CMD_U2GS_PetAddBreak,30426).
-record(pk_U2GS_PetAddBreak,{
	pet_id = 0
	}).

-define(CMD_GS2U_PetAddBreakRet,35304).
-record(pk_GS2U_PetAddBreakRet,{
	pet_id = 0,
	err_code = 0
	}).

-define(CMD_U2GS_PetAddStar,20628).
-record(pk_U2GS_PetAddStar,{
	pet_id = 0,
	use_spec = false
	}).

-define(CMD_GS2U_PetAddStarRet,27433).
-record(pk_GS2U_PetAddStarRet,{
	pet_id = 0,
	err_code = 0
	}).

-define(CMD_U2GS_PetAddAwaken,23566).
-record(pk_U2GS_PetAddAwaken,{
	pet_id = 0,
	use_spec = false
	}).

-define(CMD_GS2U_PetAddAwakenRet,6810).
-record(pk_GS2U_PetAddAwakenRet,{
	pet_id = 0,
	err_code = 0
	}).

-define(CMD_U2GS_PetAddAwakenPotential,32545).
-record(pk_U2GS_PetAddAwakenPotential,{
	pet_id = 0
	}).

-define(CMD_GS2U_PetAddAwakenPotentialRet,54807).
-record(pk_GS2U_PetAddAwakenPotentialRet,{
	pet_id = 0,
	err_code = 0
	}).

-define(CMD_U2GS_PetReincarnation,7801).
-record(pk_U2GS_PetReincarnation,{
	pet_id = 0
	}).

-define(CMD_GS2U_PetReincarnationRet,48).
-record(pk_GS2U_PetReincarnationRet,{
	pet_id = 0,
	err_code = 0
	}).

-define(CMD_U2GS_PetAddGrade,63644).
-record(pk_U2GS_PetAddGrade,{
	pet_id = 0
	}).

-define(CMD_GS2U_PetAddGradeRet,280).
-record(pk_GS2U_PetAddGradeRet,{
	pet_id = 0,
	err_code = 0
	}).

-define(CMD_U2GS_PetUltimateLvUp,38866).
-record(pk_U2GS_PetUltimateLvUp,{
	pet_id = 0
	}).

-define(CMD_GS2U_PetUltimateLvUpRet,26303).
-record(pk_GS2U_PetUltimateLvUpRet,{
	pet_id = 0,
	err_code = 0
	}).

-define(CMD_MolingEqPos,63059).
-record(pk_MolingEqPos,{
	role_id = 0,
	pos = 0,
	uid = 0,
	lv = 0,
	break_lv = 0
	}).

-define(CMD_MolingSkill,2918).
-record(pk_MolingSkill,{
	role_id = 0,
	pos = 0,
	pet_id = 0,
	skill_id = 0
	}).

-define(CMD_Moling,9747).
-record(pk_Moling,{
	role_id = 0,
	lv = 0,
	exp = 0,
	pill1 = 0,
	pill2 = 0,
	pill3 = 0
	}).

-define(CMD_GS2U_MolingUpdate,60099).
-record(pk_GS2U_MolingUpdate,{
	ml = []
	}).

-define(CMD_GS2U_MolingSkillUpdate,12951).
-record(pk_GS2U_MolingSkillUpdate,{
	skills = []
	}).

-define(CMD_GS2U_MolingEqUpdate,18243).
-record(pk_GS2U_MolingEqUpdate,{
	eqs = []
	}).

-define(CMD_U2GS_MolingAddLv,29113).
-record(pk_U2GS_MolingAddLv,{
	role_id = 0,
	costs = []
	}).

-define(CMD_GS2U_MolingAddLvRet,10030).
-record(pk_GS2U_MolingAddLvRet,{
	role_id = 0,
	err_code = 0
	}).

-define(CMD_U2GS_MolingAutoAddLv,29711).
-record(pk_U2GS_MolingAutoAddLv,{
	role_id = 0
	}).

-define(CMD_GS2U_MolingAutoAddLvRet,26364).
-record(pk_GS2U_MolingAutoAddLvRet,{
	role_id = 0,
	add_exp = 0,
	err_code = 0
	}).

-define(CMD_U2GS_MolingSkillBoxOpenReq,57292).
-record(pk_U2GS_MolingSkillBoxOpenReq,{
	role_id = 0,
	pos = 0
	}).

-define(CMD_GS2U_MolingSkillBoxOpenRet,10679).
-record(pk_GS2U_MolingSkillBoxOpenRet,{
	role_id = 0,
	err_code = 0,
	pos = 0
	}).

-define(CMD_U2GS_MolingSkillOp,59296).
-record(pk_U2GS_MolingSkillOp,{
	role_id = 0,
	type = 0,
	pos = 0,
	skillid = 0,
	petid = 0
	}).

-define(CMD_GS2U_MolingSkillOpRet,57435).
-record(pk_GS2U_MolingSkillOpRet,{
	role_id = 0,
	err_code = 0,
	type = 0
	}).

-define(CMD_U2GS_MolingEqOp,166).
-record(pk_U2GS_MolingEqOp,{
	role_id = 0,
	type = 0,
	uid = 0
	}).

-define(CMD_GS2U_MolingEqOpRet,10932).
-record(pk_GS2U_MolingEqOpRet,{
	role_id = 0,
	err_code = 0,
	type = 0,
	uid = 0
	}).

-define(CMD_U2GS_MolingEqOneKeyOp,37126).
-record(pk_U2GS_MolingEqOneKeyOp,{
	role_id = 0,
	type = 0
	}).

-define(CMD_GS2U_MolingEqOneKeyOpRet,64595).
-record(pk_GS2U_MolingEqOneKeyOpRet,{
	role_id = 0,
	err_code = 0,
	type = 0
	}).

-define(CMD_U2GS_MolingEqAddLv,22160).
-record(pk_U2GS_MolingEqAddLv,{
	role_id = 0,
	pos = 0,
	eq_uid = 0
	}).

-define(CMD_GS2U_MolingEqAddLvRet,40765).
-record(pk_GS2U_MolingEqAddLvRet,{
	role_id = 0,
	err_code = 0,
	is_success = 0
	}).

-define(CMD_U2GS_MolingEqBreak,50282).
-record(pk_U2GS_MolingEqBreak,{
	role_id = 0,
	pos = 0,
	eq_uid = 0
	}).

-define(CMD_GS2U_MolingEqBreakRet,61665).
-record(pk_GS2U_MolingEqBreakRet,{
	role_id = 0,
	err_code = 0
	}).

-define(CMD_U2GS_YilingEqBreak,42662).
-record(pk_U2GS_YilingEqBreak,{
	role_id = 0,
	pos = 0,
	eq_uid = 0
	}).

-define(CMD_GS2U_YilingEqBreakRet,52702).
-record(pk_GS2U_YilingEqBreakRet,{
	role_id = 0,
	err_code = 0
	}).

-define(CMD_PetFetter,4944).
-record(pk_PetFetter,{
	f_id = 0,
	f_lv = 0
	}).

-define(CMD_GS2U_PetFetterUpdate,64957).
-record(pk_GS2U_PetFetterUpdate,{
	pfs = []
	}).

-define(CMD_U2GS_PetFetterActive,49743).
-record(pk_U2GS_PetFetterActive,{
	f_id = 0,
	f_lv = 0
	}).

-define(CMD_GS2U_PetFetterActiveRet,19273).
-record(pk_GS2U_PetFetterActiveRet,{
	err_code = 0
	}).

-define(CMD_U2GS_PetEquipOP,20463).
-record(pk_U2GS_PetEquipOP,{
	type = 0,
	pet_id = 0
	}).

-define(CMD_U2GS_MolingEatPill,5927).
-record(pk_U2GS_MolingEatPill,{
	role_id = 0,
	index = 0,
	num = 0
	}).

-define(CMD_GS2U_MolingEatPillRet,36981).
-record(pk_GS2U_MolingEatPillRet,{
	role_id = 0,
	err_code = 0
	}).

-define(CMD_GS2U_MLEqUpdate,1296).
-record(pk_GS2U_MLEqUpdate,{
	eqs = []
	}).

-define(CMD_GS2U_YLEqUpdate,6172).
-record(pk_GS2U_YLEqUpdate,{
	eqs = []
	}).

-define(CMD_GS2U_SLEqUpdate,36502).
-record(pk_GS2U_SLEqUpdate,{
	eqs = []
	}).

-define(CMD_U2GS_DownloadProgress,6139).
-record(pk_U2GS_DownloadProgress,{
	imei = "",
	progress = 0,
	is4G = 0
	}).

-define(CMD_U2GS_buyDungeonFightCount,53664).
-record(pk_U2GS_buyDungeonFightCount,{
	dungeonID = 0,
	times = 0
	}).

-define(CMD_GS2U_buyDungeonFightCountResult,53138).
-record(pk_GS2U_buyDungeonFightCountResult,{
	dungeonID = 0,
	times = 0,
	buy_player = 0,
	result = 0
	}).

-define(CMD_WingNew,6580).
-record(pk_WingNew,{
	wing_id = 0,
	wing_lv = 0,
	wing_exp = 0,
	break_lv = 0,
	star = 0,
	feather_lv = 0,
	sublimate_lv = 0,
	is_rein = 0,
	ele_awaken = 0,
	is_fly = 0,
	f_level = 0
	}).

-define(CMD_GS2U_WingNewUpdate,47545).
-record(pk_GS2U_WingNewUpdate,{
	wings = []
	}).

-define(CMD_U2GS_WingNewAddStar,15547).
-record(pk_U2GS_WingNewAddStar,{
	wing_id = 0,
	use_spec = false
	}).

-define(CMD_GS2U_WingNewAddStarRet,56841).
-record(pk_GS2U_WingNewAddStarRet,{
	wing_id = 0,
	err_code = 0
	}).

-define(CMD_U2GS_WingNewAddLevel,28096).
-record(pk_U2GS_WingNewAddLevel,{
	wing_id = 0,
	costs = []
	}).

-define(CMD_GS2U_WingNewAddLevelRet,46453).
-record(pk_GS2U_WingNewAddLevelRet,{
	wing_id = 0,
	err_code = 0
	}).

-define(CMD_U2GS_WingAutoAddLevel,53139).
-record(pk_U2GS_WingAutoAddLevel,{
	wing_id = 0
	}).

-define(CMD_GS2U_WingAutoAddLevelRet,11869).
-record(pk_GS2U_WingAutoAddLevelRet,{
	wing_id = 0,
	err_code = 0
	}).

-define(CMD_U2GS_WingNewAddBreak,50891).
-record(pk_U2GS_WingNewAddBreak,{
	wing_id = 0
	}).

-define(CMD_GS2U_WingNewAddBreakRet,51074).
-record(pk_GS2U_WingNewAddBreakRet,{
	wing_id = 0,
	err_code = 0
	}).

-define(CMD_U2GS_WingNewAddFeather,23958).
-record(pk_U2GS_WingNewAddFeather,{
	wing_id = 0,
	use_spec = false
	}).

-define(CMD_GS2U_WingNewAddFeatherRet,63583).
-record(pk_GS2U_WingNewAddFeatherRet,{
	wing_id = 0,
	err_code = 0
	}).

-define(CMD_U2GS_WingNewAddsublimate,41896).
-record(pk_U2GS_WingNewAddsublimate,{
	wing_id = 0
	}).

-define(CMD_GS2U_WingNewAddsublimateRet,45357).
-record(pk_GS2U_WingNewAddsublimateRet,{
	wing_id = 0,
	err_code = 0
	}).

-define(CMD_U2GS_WingReincarnation,8672).
-record(pk_U2GS_WingReincarnation,{
	wing_id = 0
	}).

-define(CMD_GS2U_WingReincarnationRet,31858).
-record(pk_GS2U_WingReincarnationRet,{
	wing_id = 0,
	err_code = 0
	}).

-define(CMD_U2GS_WingNewEleAwaken,23455).
-record(pk_U2GS_WingNewEleAwaken,{
	wing_id = 0,
	type = 0
	}).

-define(CMD_GS2U_WingNewEleAwakenRet,34794).
-record(pk_GS2U_WingNewEleAwakenRet,{
	wing_id = 0,
	type = 0,
	err_code = 0
	}).

-define(CMD_U2GS_WingOpenFly,48664).
-record(pk_U2GS_WingOpenFly,{
	wing_id = 0
	}).

-define(CMD_GS2U_WingOpenFlyRet,37210).
-record(pk_GS2U_WingOpenFlyRet,{
	wing_id = 0,
	err_code = 0
	}).

-define(CMD_U2GS_FWingNewAddLevel,13334).
-record(pk_U2GS_FWingNewAddLevel,{
	wing_id = 0,
	add_level = 0
	}).

-define(CMD_GS2U_FWingNewAddLevelRet,52104).
-record(pk_GS2U_FWingNewAddLevelRet,{
	wing_id = 0,
	new_level = 0,
	err_code = 0
	}).

-define(CMD_YilingEqPos,35214).
-record(pk_YilingEqPos,{
	pos = 0,
	uid = 0,
	lv = 0,
	break_lv = 0
	}).

-define(CMD_YilingSkill,40610).
-record(pk_YilingSkill,{
	pos = 0,
	wing_id = 0,
	skill_idx = 0,
	is_lock = 0
	}).

-define(CMD_Yiling,32301).
-record(pk_Yiling,{
	role_id = 0,
	lv = 0,
	exp = 0,
	break_lv = 0,
	skill_t_mask = 0,
	award_list = []
	}).

-define(CMD_GS2U_YilingUpdate,7465).
-record(pk_GS2U_YilingUpdate,{
	yl = #pk_Yiling{}
	}).

-define(CMD_GS2U_YilingSkillUpdate,42730).
-record(pk_GS2U_YilingSkillUpdate,{
	role_id = 0,
	skills = []
	}).

-define(CMD_GS2U_YilingTSkillUpdate,62984).
-record(pk_GS2U_YilingTSkillUpdate,{
	role_id = 0,
	skills = []
	}).

-define(CMD_GS2U_YilingEqUpdate,8979).
-record(pk_GS2U_YilingEqUpdate,{
	role_id = 0,
	eqs = []
	}).

-define(CMD_U2GS_YilingAddLv,1268).
-record(pk_U2GS_YilingAddLv,{
	role_id = 0,
	costs = []
	}).

-define(CMD_GS2U_YilingAddLvRet,766).
-record(pk_GS2U_YilingAddLvRet,{
	role_id = 0,
	costs = [],
	err_code = 0
	}).

-define(CMD_U2GS_YilingAutoAddLv,21609).
-record(pk_U2GS_YilingAutoAddLv,{
	role_id = 0
	}).

-define(CMD_GS2U_YilingAutoAddLvRet,57854).
-record(pk_GS2U_YilingAutoAddLvRet,{
	role_id = 0,
	add_exp = 0,
	err_code = 0
	}).

-define(CMD_U2GS_YilingSkillBoxOpenReq,24452).
-record(pk_U2GS_YilingSkillBoxOpenReq,{
	role_id = 0,
	pos = 0
	}).

-define(CMD_GS2U_YilingSkillBoxOpenRet,43375).
-record(pk_GS2U_YilingSkillBoxOpenRet,{
	role_id = 0,
	err_code = 0,
	pos = 0
	}).

-define(CMD_U2GS_YilingSkillOp,51676).
-record(pk_U2GS_YilingSkillOp,{
	role_id = 0,
	type = 0,
	pos = 0,
	skill_idx = 0,
	wing_id = 0
	}).

-define(CMD_GS2U_YilingSkillOpRet,48473).
-record(pk_GS2U_YilingSkillOpRet,{
	role_id = 0,
	err_code = 0,
	type = 0
	}).

-define(CMD_U2GS_YilingEqOp,54465).
-record(pk_U2GS_YilingEqOp,{
	role_id = 0,
	type = 0,
	uid = 0
	}).

-define(CMD_GS2U_YilingEqOpRet,3312).
-record(pk_GS2U_YilingEqOpRet,{
	role_id = 0,
	err_code = 0,
	type = 0,
	uid = 0
	}).

-define(CMD_U2GS_YilingEqOneKeyOp,28163).
-record(pk_U2GS_YilingEqOneKeyOp,{
	role_id = 0,
	type = 0
	}).

-define(CMD_GS2U_YilingEqOneKeyOpRet,8452).
-record(pk_GS2U_YilingEqOneKeyOpRet,{
	role_id = 0,
	err_code = 0,
	type = 0
	}).

-define(CMD_U2GS_YilingEqAddLv,14539).
-record(pk_U2GS_YilingEqAddLv,{
	role_id = 0,
	pos = 0,
	eq_uid = 0
	}).

-define(CMD_GS2U_YilingEqAddLvRet,31802).
-record(pk_GS2U_YilingEqAddLvRet,{
	role_id = 0,
	err_code = 0,
	is_success = 0
	}).

-define(CMD_U2GS_YilingLockIndexReq,41558).
-record(pk_U2GS_YilingLockIndexReq,{
	role_id = 0,
	index = 0,
	target_lock = 0
	}).

-define(CMD_GS2U_YilingLockIndexRet,45298).
-record(pk_GS2U_YilingLockIndexRet,{
	role_id = 0,
	index = 0,
	target_lock = 0,
	err_code = 0
	}).

-define(CMD_U2GS_YilingSkill_T_off,19862).
-record(pk_U2GS_YilingSkill_T_off,{
	role_id = 0,
	pos = 0
	}).

-define(CMD_GS2U_YilingSkill_T_off_Ret,53051).
-record(pk_GS2U_YilingSkill_T_off_Ret,{
	role_id = 0,
	pos = 0,
	err_code = 0
	}).

-define(CMD_WingNewFetter,30647).
-record(pk_WingNewFetter,{
	f_id = 0,
	f_lv = 0
	}).

-define(CMD_GS2U_WingNewFetterUpdate,181).
-record(pk_GS2U_WingNewFetterUpdate,{
	wfs = []
	}).

-define(CMD_U2GS_WingNewFetterActive,7754).
-record(pk_U2GS_WingNewFetterActive,{
	f_id = 0,
	f_lv = 0
	}).

-define(CMD_GS2U_WingNewFetterActiveRet,40963).
-record(pk_GS2U_WingNewFetterActiveRet,{
	err_code = 0
	}).

-define(CMD_U2GS_WingNewEquipOP,15383).
-record(pk_U2GS_WingNewEquipOP,{
	role_id = 0,
	type = 0,
	wing_id = 0
	}).

-define(CMD_U2GS_YilingSkill_T_Slot_Open,23080).
-record(pk_U2GS_YilingSkill_T_Slot_Open,{
	role_id = 0,
	index = 0
	}).

-define(CMD_GS2U_YilingSkill_T_Slot_OpenRet,62648).
-record(pk_GS2U_YilingSkill_T_Slot_OpenRet,{
	role_id = 0,
	err_code = 0
	}).

-define(CMD_U2GS_YilingSkill_T_Make,31097).
-record(pk_U2GS_YilingSkill_T_Make,{
	role_id = 0,
	lock_index = []
	}).

-define(CMD_GS2U_YilingSkill_T_MakeRet,9952).
-record(pk_GS2U_YilingSkill_T_MakeRet,{
	role_id = 0,
	err_code = 0,
	fail_times = 0,
	success_times = 0
	}).

-define(CMD_U2GS_YilingBreak,29390).
-record(pk_U2GS_YilingBreak,{
	role_id = 0
	}).

-define(CMD_GS2U_YilingBreakRet,21666).
-record(pk_GS2U_YilingBreakRet,{
	role_id = 0,
	err_code = 0
	}).

-define(CMD_U2GS_YilingLvAward,24864).
-record(pk_U2GS_YilingLvAward,{
	role_id = 0,
	lv = 0
	}).

-define(CMD_GS2U_YilingLvAwardRet,46417).
-record(pk_GS2U_YilingLvAwardRet,{
	role_id = 0,
	lv = 0,
	err_code = 0
	}).

-define(CMD_MountNew,62834).
-record(pk_MountNew,{
	mount_id = 0,
	mount_lv = 0,
	mount_exp = 0,
	break_lv = 0,
	star = 0,
	awaken_lv = 0,
	sublimate_lv = 0,
	is_rein = 0,
	ele_awaken = 0,
	expire_time = 0
	}).

-define(CMD_GS2U_MountNewUpdate,48647).
-record(pk_GS2U_MountNewUpdate,{
	mounts = []
	}).

-define(CMD_U2GS_MountNewAddStar,32707).
-record(pk_U2GS_MountNewAddStar,{
	mount_id = 0,
	use_spec = false
	}).

-define(CMD_GS2U_MountNewAddStarRet,33572).
-record(pk_GS2U_MountNewAddStarRet,{
	mount_id = 0,
	err_code = 0
	}).

-define(CMD_U2GS_MountNewAddLevel,29305).
-record(pk_U2GS_MountNewAddLevel,{
	mount_id = 0,
	costs = []
	}).

-define(CMD_GS2U_MountNewAddLevelRet,59570).
-record(pk_GS2U_MountNewAddLevelRet,{
	mount_id = 0,
	err_code = 0
	}).

-define(CMD_U2GS_MountAutoAddLevel,24730).
-record(pk_U2GS_MountAutoAddLevel,{
	mount_id = 0
	}).

-define(CMD_GS2U_MountAutoAddLevelRet,61733).
-record(pk_GS2U_MountAutoAddLevelRet,{
	mount_id = 0,
	err_code = 0
	}).

-define(CMD_U2GS_MountNewAddBreak,52099).
-record(pk_U2GS_MountNewAddBreak,{
	mount_id = 0
	}).

-define(CMD_GS2U_MountNewAddBreakRet,64191).
-record(pk_GS2U_MountNewAddBreakRet,{
	mount_id = 0,
	err_code = 0
	}).

-define(CMD_U2GS_MountNewAddAwaken,10107).
-record(pk_U2GS_MountNewAddAwaken,{
	mount_id = 0,
	use_spec = false
	}).

-define(CMD_GS2U_MountNewAddAwakenRet,57432).
-record(pk_GS2U_MountNewAddAwakenRet,{
	mount_id = 0,
	err_code = 0
	}).

-define(CMD_U2GS_MountNewAddsublimate,31020).
-record(pk_U2GS_MountNewAddsublimate,{
	mount_id = 0
	}).

-define(CMD_GS2U_MountNewAddsublimateRet,57940).
-record(pk_GS2U_MountNewAddsublimateRet,{
	mount_id = 0,
	err_code = 0
	}).

-define(CMD_U2GS_MountReincarnation,798).
-record(pk_U2GS_MountReincarnation,{
	mount_id = 0
	}).

-define(CMD_GS2U_MountReincarnationRet,13383).
-record(pk_GS2U_MountReincarnationRet,{
	mount_id = 0,
	err_code = 0
	}).

-define(CMD_U2GS_MountNewEleAwaken,60583).
-record(pk_U2GS_MountNewEleAwaken,{
	mount_id = 0,
	type = 0
	}).

-define(CMD_GS2U_MountNewEleAwakenRet,19121).
-record(pk_GS2U_MountNewEleAwakenRet,{
	mount_id = 0,
	type = 0,
	err_code = 0
	}).

-define(CMD_ShoulingEqPos,49033).
-record(pk_ShoulingEqPos,{
	suit_id = 0,
	pos = 0,
	uid = 0,
	lv = 0,
	break_lv = 0
	}).

-define(CMD_ShoulingSkill,54428).
-record(pk_ShoulingSkill,{
	pos = 0,
	mount_id = 0,
	skill_idx = 0,
	is_lock = 0
	}).

-define(CMD_Shouling,65016).
-record(pk_Shouling,{
	role_id = 0,
	lv = 0,
	exp = 0,
	break_lv = 0,
	skill_t_mask = 0,
	pill1 = 0,
	pill2 = 0,
	pill3 = 0,
	award_list = []
	}).

-define(CMD_GS2U_ShoulingUpdate,30915).
-record(pk_GS2U_ShoulingUpdate,{
	sl = #pk_Shouling{}
	}).

-define(CMD_GS2U_ShoulingSkillUpdate,57361).
-record(pk_GS2U_ShoulingSkillUpdate,{
	role_id = 0,
	skills = []
	}).

-define(CMD_GS2U_ShoulingTSkillUpdate,20725).
-record(pk_GS2U_ShoulingTSkillUpdate,{
	role_id = 0,
	skills = []
	}).

-define(CMD_GS2U_ShoulingEqUpdate,19007).
-record(pk_GS2U_ShoulingEqUpdate,{
	role_id = 0,
	eqs = []
	}).

-define(CMD_U2GS_ShoulingAddLv,42444).
-record(pk_U2GS_ShoulingAddLv,{
	role_id = 0,
	costs = []
	}).

-define(CMD_GS2U_ShoulingAddLvRet,10794).
-record(pk_GS2U_ShoulingAddLvRet,{
	role_id = 0,
	err_code = 0
	}).

-define(CMD_U2GS_ShoulingAutoAddLv,24952).
-record(pk_U2GS_ShoulingAutoAddLv,{
	role_id = 0
	}).

-define(CMD_GS2U_ShoulingAutoAddLvRet,15594).
-record(pk_GS2U_ShoulingAutoAddLvRet,{
	role_id = 0,
	add_exp = 0,
	err_code = 0
	}).

-define(CMD_U2GS_ShoulingSkillBoxOpenReq,44718).
-record(pk_U2GS_ShoulingSkillBoxOpenReq,{
	role_id = 0,
	pos = 0
	}).

-define(CMD_GS2U_ShoulingSkillBoxOpenRet,65023).
-record(pk_GS2U_ShoulingSkillBoxOpenRet,{
	err_code = 0,
	role_id = 0,
	pos = 0
	}).

-define(CMD_U2GS_ShoulingSkillOp,10510).
-record(pk_U2GS_ShoulingSkillOp,{
	role_id = 0,
	type = 0,
	pos = 0,
	skill_idx = 0,
	mount_id = 0
	}).

-define(CMD_GS2U_ShoulingSkillOpRet,30066).
-record(pk_GS2U_ShoulingSkillOpRet,{
	err_code = 0,
	role_id = 0,
	type = 0
	}).

-define(CMD_GS2U_ShoulingEqPosUnLockListRet,46587).
-record(pk_GS2U_ShoulingEqPosUnLockListRet,{
	unlock_pos_list = []
	}).

-define(CMD_U2GS_ShoulingEqPosUnLock,37628).
-record(pk_U2GS_ShoulingEqPosUnLock,{
	suit_id = 0,
	pos = 0
	}).

-define(CMD_GS2U_ShoulingEqPosUnLockRet,2431).
-record(pk_GS2U_ShoulingEqPosUnLockRet,{
	suit_id = 0,
	pos = 0,
	err_code = 0
	}).

-define(CMD_U2GS_ShoulingEqOp,1694).
-record(pk_U2GS_ShoulingEqOp,{
	role_id = 0,
	suit_id = 0,
	type = 0,
	uid = 0
	}).

-define(CMD_GS2U_ShoulingEqOpRet,36446).
-record(pk_GS2U_ShoulingEqOpRet,{
	err_code = 0,
	role_id = 0,
	suit_id = 0,
	type = 0,
	uid = 0
	}).

-define(CMD_U2GS_ShoulingEqOneKeyOp,48166).
-record(pk_U2GS_ShoulingEqOneKeyOp,{
	role_id = 0,
	suit_id = 0,
	type = 0
	}).

-define(CMD_GS2U_ShoulingEqOneKeyOpRet,28422).
-record(pk_GS2U_ShoulingEqOneKeyOpRet,{
	err_code = 0,
	role_id = 0,
	suit_id = 0,
	type = 0
	}).

-define(CMD_U2GS_ShoulingEqAddLv,38910).
-record(pk_U2GS_ShoulingEqAddLv,{
	role_id = 0,
	suit_id = 0,
	pos = 0,
	eq_uid = 0
	}).

-define(CMD_GS2U_ShoulingEqAddLvRet,13396).
-record(pk_GS2U_ShoulingEqAddLvRet,{
	role_id = 0,
	suit_id = 0,
	err_code = 0,
	is_success = 0
	}).

-define(CMD_U2GS_ShoulingEqBreak,1496).
-record(pk_U2GS_ShoulingEqBreak,{
	role_id = 0,
	suit_id = 0,
	pos = 0,
	eq_uid = 0
	}).

-define(CMD_GS2U_ShoulingEqBreakRet,34296).
-record(pk_GS2U_ShoulingEqBreakRet,{
	role_id = 0,
	suit_id = 0,
	err_code = 0
	}).

-define(CMD_U2GS_ShoulingEqStar,11019).
-record(pk_U2GS_ShoulingEqStar,{
	uid = 0
	}).

-define(CMD_GS2U_ShoulingEqStar,23670).
-record(pk_GS2U_ShoulingEqStar,{
	cfgid = 0,
	error = 0
	}).

-define(CMD_U2GS_ShoulingEqBreakDown,57944).
-record(pk_U2GS_ShoulingEqBreakDown,{
	eq_uid_list = []
	}).

-define(CMD_GS2U_ShoulingEqBreakDownRet,5976).
-record(pk_GS2U_ShoulingEqBreakDownRet,{
	itemlist = [],
	err_code = 0
	}).

-define(CMD_U2GS_ShoulingLockIndexReq,18147).
-record(pk_U2GS_ShoulingLockIndexReq,{
	role_id = 0,
	index = 0,
	target_lock = 0
	}).

-define(CMD_GS2U_ShoulingLockIndexRet,3038).
-record(pk_GS2U_ShoulingLockIndexRet,{
	role_id = 0,
	index = 0,
	target_lock = 0,
	err_code = 0
	}).

-define(CMD_MountNewFetter,2026).
-record(pk_MountNewFetter,{
	f_id = 0,
	f_lv = 0
	}).

-define(CMD_GS2U_MountNewFetterUpdate,50044).
-record(pk_GS2U_MountNewFetterUpdate,{
	wfs = []
	}).

-define(CMD_U2GS_MountNewFetterActive,62414).
-record(pk_U2GS_MountNewFetterActive,{
	f_id = 0,
	f_lv = 0
	}).

-define(CMD_GS2U_MountNewFetterActiveRet,53546).
-record(pk_GS2U_MountNewFetterActiveRet,{
	err_code = 0
	}).

-define(CMD_U2GS_MountNewEquipOP,32542).
-record(pk_U2GS_MountNewEquipOP,{
	role_id = 0,
	type = 0,
	mount_id = 0
	}).

-define(CMD_U2GS_ShoulingEatPill,22677).
-record(pk_U2GS_ShoulingEatPill,{
	role_id = 0,
	index = 0,
	num = 0
	}).

-define(CMD_GS2U_ShoulingEatPillRet,9612).
-record(pk_GS2U_ShoulingEatPillRet,{
	role_id = 0,
	err_code = 0
	}).

-define(CMD_U2GS_ShoulingSkill_T_Slot_Open,20837).
-record(pk_U2GS_ShoulingSkill_T_Slot_Open,{
	role_id = 0,
	index = 0
	}).

-define(CMD_GS2U_ShoulingSkill_T_Slot_OpenRet,40578).
-record(pk_GS2U_ShoulingSkill_T_Slot_OpenRet,{
	role_id = 0,
	err_code = 0
	}).

-define(CMD_U2GS_ShoulingSkill_T_Make,7686).
-record(pk_U2GS_ShoulingSkill_T_Make,{
	role_id = 0,
	lock_index = []
	}).

-define(CMD_GS2U_ShoulingSkill_T_MakeRet,31598).
-record(pk_GS2U_ShoulingSkill_T_MakeRet,{
	err_code = 0,
	role_id = 0,
	fail_times = 0,
	success_times = 0
	}).

-define(CMD_U2GS_ShoulingSkill_T_off,63938).
-record(pk_U2GS_ShoulingSkill_T_off,{
	role_id = 0,
	pos = 0
	}).

-define(CMD_GS2U_ShoulingSkill_T_off_Ret,9161).
-record(pk_GS2U_ShoulingSkill_T_off_Ret,{
	role_id = 0,
	pos = 0,
	err_code = 0
	}).

-define(CMD_U2GS_ShoulingBreak,5031).
-record(pk_U2GS_ShoulingBreak,{
	role_id = 0
	}).

-define(CMD_GS2U_ShoulingBreakRet,31694).
-record(pk_GS2U_ShoulingBreakRet,{
	role_id = 0,
	err_code = 0
	}).

-define(CMD_U2GS_ShoulingLvAward,49235).
-record(pk_U2GS_ShoulingLvAward,{
	role_id = 0,
	lv = 0
	}).

-define(CMD_GS2U_ShoulingLvAwardRet,28012).
-record(pk_GS2U_ShoulingLvAwardRet,{
	role_id = 0,
	lv = 0,
	err_code = 0
	}).

-define(CMD_U2GS_getArenaAward,38872).
-record(pk_U2GS_getArenaAward,{
	}).

-define(CMD_GS2U_getArenaAwardResult,15284).
-record(pk_GS2U_getArenaAwardResult,{
	result = 0
	}).

-define(CMD_U2GS_buyArenaFightCount,28057).
-record(pk_U2GS_buyArenaFightCount,{
	count = 0
	}).

-define(CMD_GS2U_buyArenaFightCount,20246).
-record(pk_GS2U_buyArenaFightCount,{
	count = 0,
	result = 0
	}).

-define(CMD_U2GS_getGuardList,15287).
-record(pk_U2GS_getGuardList,{
	}).

-define(CMD_guardInfo,24753).
-record(pk_guardInfo,{
	role_id = 0,
	guard_id = 0,
	time = 0,
	awaken = 0
	}).

-define(CMD_role_guard,38873).
-record(pk_role_guard,{
	role_id = 0,
	guard_list = [],
	get_guard_list = []
	}).

-define(CMD_GS2U_sendRoleGuardList,47678).
-record(pk_GS2U_sendRoleGuardList,{
	role_guard_list = []
	}).

-define(CMD_U2GS_activeGuard,35640).
-record(pk_U2GS_activeGuard,{
	role_id = 0,
	guard_id = 0,
	item_id = 0
	}).

-define(CMD_GS2U_activeGuardResult,52347).
-record(pk_GS2U_activeGuardResult,{
	role_id = 0,
	guard_id = 0,
	item_id = 0,
	err_code = 0
	}).

-define(CMD_U2GS_levelUpGuard,19726).
-record(pk_U2GS_levelUpGuard,{
	role_id = 0,
	guard_id = 0
	}).

-define(CMD_GS2U_levelUpGuardResult,11626).
-record(pk_GS2U_levelUpGuardResult,{
	role_id = 0,
	guard_id = 0,
	err_code = 0
	}).

-define(CMD_U2GS_AddGuardTime,29441).
-record(pk_U2GS_AddGuardTime,{
	role_id = 0,
	guard_id = 0
	}).

-define(CMD_GS2U_AddGuardTimeRet,49280).
-record(pk_GS2U_AddGuardTimeRet,{
	role_id = 0,
	guard_id = 0,
	err_code = 0
	}).

-define(CMD_U2GS_renewGuard,4039).
-record(pk_U2GS_renewGuard,{
	role_id = 0,
	guard_id = 0,
	cost_group_id = 0
	}).

-define(CMD_GS2U_renewGuard,61272).
-record(pk_GS2U_renewGuard,{
	role_id = 0,
	guard_id = 0,
	cost_group_id = 0,
	err_code = 0
	}).

-define(CMD_U2GS_equipGuard,36461).
-record(pk_U2GS_equipGuard,{
	role_id = 0,
	guard_id = 0
	}).

-define(CMD_GS2U_equipGuardResult,3351).
-record(pk_GS2U_equipGuardResult,{
	role_id = 0,
	guard_id = 0,
	err_code = 0
	}).

-define(CMD_U2GS_awaken_guard,6763).
-record(pk_U2GS_awaken_guard,{
	role_id = 0,
	guard_id = 0
	}).

-define(CMD_GS2U_awaken_guard_ret,33255).
-record(pk_GS2U_awaken_guard_ret,{
	role_id = 0,
	guard_id = 0,
	err_code = 0
	}).

-define(CMD_guard_fetter,21631).
-record(pk_guard_fetter,{
	role_id = 0,
	type = 0,
	lv = 0
	}).

-define(CMD_GS2U_sendGuardFetter,64684).
-record(pk_GS2U_sendGuardFetter,{
	guard_fetter_list = []
	}).

-define(CMD_U2GS_active_guard_fetter,42681).
-record(pk_U2GS_active_guard_fetter,{
	role_id = 0,
	type = 0,
	lv = 0
	}).

-define(CMD_GS2U_active_guard_fetter_ret,50029).
-record(pk_GS2U_active_guard_fetter_ret,{
	role_id = 0,
	type = 0,
	lv = 0,
	err_code = 0
	}).

-define(CMD_PillAttr,18099).
-record(pk_PillAttr,{
	key = 0,
	value = 0
	}).

-define(CMD_DragonInfo,33577).
-record(pk_DragonInfo,{
	id = 0,
	level = 0,
	exp = 0,
	star = 0,
	active_mask = 0,
	addition_attr = [],
	relate_id = 0,
	is_rein = 0,
	break_lv = 0,
	wing_lv = 0,
	wing_exp = 0
	}).

-define(CMD_DragonEqInfo,36584).
-record(pk_DragonEqInfo,{
	id = 0,
	awaken_lv = 0
	}).

-define(CMD_GS2U_DragonUpdate,56590).
-record(pk_GS2U_DragonUpdate,{
	ds = []
	}).

-define(CMD_GS2U_DragonEqUpdate,33346).
-record(pk_GS2U_DragonEqUpdate,{
	des = []
	}).

-define(CMD_U2GS_DragonActiveArti,56204).
-record(pk_U2GS_DragonActiveArti,{
	d_id = 0,
	index = 0
	}).

-define(CMD_GS2U_DragonActiveArtiRet,37751).
-record(pk_GS2U_DragonActiveArtiRet,{
	err_code = 0,
	d_id = 0,
	index = 0
	}).

-define(CMD_U2GS_DragonAwake,26667).
-record(pk_U2GS_DragonAwake,{
	id = 0
	}).

-define(CMD_GS2U_DragonAwakeRet,18072).
-record(pk_GS2U_DragonAwakeRet,{
	err_code = 0,
	d_id = 0,
	init_star = 0
	}).

-define(CMD_U2GS_DragonAddLevel,26889).
-record(pk_U2GS_DragonAddLevel,{
	id = 0,
	costs = []
	}).

-define(CMD_GS2U_DragonAddLevelRet,18855).
-record(pk_GS2U_DragonAddLevelRet,{
	err_code = 0,
	is_stage_up = false
	}).

-define(CMD_U2GS_DragonAddStar,6903).
-record(pk_U2GS_DragonAddStar,{
	id = 0
	}).

-define(CMD_GS2U_DragonAddStarRet,44376).
-record(pk_GS2U_DragonAddStarRet,{
	err_code = 0
	}).

-define(CMD_U2GS_DragonReincarnation,27305).
-record(pk_U2GS_DragonReincarnation,{
	id = 0
	}).

-define(CMD_GS2U_DragonReincarnationRet,65326).
-record(pk_GS2U_DragonReincarnationRet,{
	id = 0,
	err_code = 0
	}).

-define(CMD_U2GS_DragonSetBattle,34854).
-record(pk_U2GS_DragonSetBattle,{
	role_id = 0,
	id = 0
	}).

-define(CMD_GS2U_DragonSetBattleRet,50315).
-record(pk_GS2U_DragonSetBattleRet,{
	role_id = 0,
	id = 0,
	err_code = 0
	}).

-define(CMD_U2GS_DragonSkillOp,23090).
-record(pk_U2GS_DragonSkillOp,{
	op = 0,
	id1 = 0,
	id2 = 0
	}).

-define(CMD_GS2U_DragonSkillOpRet,16671).
-record(pk_GS2U_DragonSkillOpRet,{
	err_code = 0,
	op = 0,
	id1 = 0,
	id2 = 0
	}).

-define(CMD_U2GS_DragonEqAwaken,13744).
-record(pk_U2GS_DragonEqAwaken,{
	id = 0
	}).

-define(CMD_GS2U_DragonEqAwakenRet,55006).
-record(pk_GS2U_DragonEqAwakenRet,{
	id = 0,
	err_code = 0
	}).

-define(CMD_U2GS_DragonEqSplit,29234).
-record(pk_U2GS_DragonEqSplit,{
	costs = []
	}).

-define(CMD_GS2U_DragonEqSplitRet,63004).
-record(pk_GS2U_DragonEqSplitRet,{
	err_code = 0,
	adds = []
	}).

-define(CMD_U2GS_DragonBreak,52843).
-record(pk_U2GS_DragonBreak,{
	id = 0
	}).

-define(CMD_GS2U_DragonBreakRet,46033).
-record(pk_GS2U_DragonBreakRet,{
	id = 0,
	err_code = 0
	}).

-define(CMD_U2GS_Dragon_WingUp,64850).
-record(pk_U2GS_Dragon_WingUp,{
	id = 0,
	uid_list = []
	}).

-define(CMD_GS2U_Dragon_WingUpRet,21818).
-record(pk_GS2U_Dragon_WingUpRet,{
	id = 0,
	new_lv = 0,
	new_exp = 0,
	err_code = 0
	}).

-define(CMD_U2GS_UseSkill,60956).
-record(pk_U2GS_UseSkill,{
	attackerid = 0,
	attacker_role_id = 0,
	skillid = 0,
	pos_x = 0,
	pos_y = 0,
	targetList = [],
	timestamp = 0
	}).

-define(CMD_U2GS_UseSkillPassive,39411).
-record(pk_U2GS_UseSkillPassive,{
	attackerid = 0,
	attacker_role_id = 0,
	skillid = 0,
	pos_x = 0,
	pos_y = 0,
	targetList = []
	}).

-define(CMD_GS2U_UseSkill,50015).
-record(pk_GS2U_UseSkill,{
	attackerid = 0,
	attacker_role_id = 0,
	skillid = 0,
	type = 0,
	pos_x = 0,
	pos_y = 0,
	targetList = []
	}).

-define(CMD_GS2U_UseSkillFail,65190).
-record(pk_GS2U_UseSkillFail,{
	err_code = 0,
	attackerid = 0,
	attacker_role_id = 0,
	skillid = 0
	}).

-define(CMD_U2GS_SkillHit,28707).
-record(pk_U2GS_SkillHit,{
	skillid = 0,
	attackerid = 0,
	attacker_role_id = 0,
	targetList = []
	}).

-define(CMD_Object_Damage,29825).
-record(pk_Object_Damage,{
	objectId = 0,
	role_id = 0,
	objectHp = 0,
	type = 0,
	value = 0
	}).

-define(CMD_GS2U_SKillHitRet,55794).
-record(pk_GS2U_SKillHitRet,{
	skillid = 0,
	attackerid = 0,
	attacker_role_id = 0,
	damageList = []
	}).

-define(CMD_GS2U_BuffResult,16218).
-record(pk_GS2U_BuffResult,{
	objectID = 0,
	role_id = 0,
	srcObjectID = 0,
	srcRoleId = 0,
	buffID = 0,
	damage = #pk_Object_Damage{}
	}).

-define(CMD_U2GS_UseSkillShift,55624).
-record(pk_U2GS_UseSkillShift,{
	type = 0,
	attackerid = 0,
	targetid = 0,
	pos_x = 0,
	pos_y = 0
	}).

-define(CMD_GS2U_UseSkillShiftNotify,20716).
-record(pk_GS2U_UseSkillShiftNotify,{
	type = 0,
	attackerid = 0,
	targetid = 0,
	pos_x = 0,
	pos_y = 0
	}).

-define(CMD_GS2U_dungeons_map_state,22640).
-record(pk_GS2U_dungeons_map_state,{
	state = 0,
	start_time = 0
	}).

-define(CMD_dungeons_inspire,50547).
-record(pk_dungeons_inspire,{
	objectId = 0,
	buy_times = []
	}).

-define(CMD_GS2U_dungeons_inspire,38709).
-record(pk_GS2U_dungeons_inspire,{
	list = []
	}).

-define(CMD_U2GS_dungeons_inspire_buy,64270).
-record(pk_U2GS_dungeons_inspire_buy,{
	objectId = 0,
	index = 0,
	merged_times = 0
	}).

-define(CMD_GS2U_dungeons_inspire_buy,37612).
-record(pk_GS2U_dungeons_inspire_buy,{
	objectId = 0,
	index = 0,
	error = 0
	}).

-define(CMD_U2GS_dungeons_inspire_buy_all,62902).
-record(pk_U2GS_dungeons_inspire_buy_all,{
	index = 0,
	merged_times = 0
	}).

-define(CMD_GS2U_dungeons_inspire_buy_all,49399).
-record(pk_GS2U_dungeons_inspire_buy_all,{
	index = 0,
	error = 0
	}).

-define(CMD_GS2U_dungeons_round,65004).
-record(pk_GS2U_dungeons_round,{
	round_index = 0
	}).

-define(CMD_GS2U_dungeons_round_next,12867).
-record(pk_GS2U_dungeons_round_next,{
	round_index = 0,
	type = 0,
	time = 0
	}).

-define(CMD_GS2U_syncPantheonMapInfo,56025).
-record(pk_GS2U_syncPantheonMapInfo,{
	monsterNum = 0,
	collectionNum = 0,
	collectionTime = 0
	}).

-define(CMD_GS2U_guardExpirePush,22620).
-record(pk_GS2U_guardExpirePush,{
	role_id = 0,
	guard_id = 0,
	time = 0
	}).

-define(CMD_GS2U_PlayerVipChange,32964).
-record(pk_GS2U_PlayerVipChange,{
	playerid = 0,
	vip = 0
	}).

-define(CMD_item_sp,58653).
-record(pk_item_sp,{
	id = 0,
	cfg_id = 0,
	bind = 0
	}).

-define(CMD_GS2U_GetSthDialog,6289).
-record(pk_GS2U_GetSthDialog,{
	type = 0,
	items = [],
	coins = [],
	eqs = [],
	sps = [],
	exp = 0,
	source_from = 0
	}).

-define(CMD_GS2U_BestDropDialog,40906).
-record(pk_GS2U_BestDropDialog,{
	items = [],
	eqs = [],
	source_from = 0
	}).

-define(CMD_Card,37237).
-record(pk_Card,{
	id = 0,
	star = 0,
	quality_lv = 0
	}).

-define(CMD_GS2U_CardSync,51406).
-record(pk_GS2U_CardSync,{
	cards = []
	}).

-define(CMD_U2GS_CardAddStar,27019).
-record(pk_U2GS_CardAddStar,{
	card_id = 0
	}).

-define(CMD_GS2U_CardAddStarRet,38252).
-record(pk_GS2U_CardAddStarRet,{
	err_code = 0,
	card_id = 0,
	star = 0
	}).

-define(CMD_GS2U_CardAdd,29291).
-record(pk_GS2U_CardAdd,{
	card = #pk_Card{}
	}).

-define(CMD_U2GS_CardAddQuality,14407).
-record(pk_U2GS_CardAddQuality,{
	card_id = 0
	}).

-define(CMD_GS2U_CardAddQualityRet,43593).
-record(pk_GS2U_CardAddQualityRet,{
	err_code = 0,
	card_id = 0,
	quality_lv = 0
	}).

-define(CMD_CardFetter,3886).
-record(pk_CardFetter,{
	f_id = 0,
	f_lv = 0
	}).

-define(CMD_GS2U_CardFetterUpdate,30735).
-record(pk_GS2U_CardFetterUpdate,{
	cfs = []
	}).

-define(CMD_U2GS_CardFetterActive,51383).
-record(pk_U2GS_CardFetterActive,{
	f_id = 0,
	f_lv = 0
	}).

-define(CMD_GS2U_CardFetterActiveRet,16417).
-record(pk_GS2U_CardFetterActiveRet,{
	err_code = 0,
	f_id = 0,
	f_lv = 0
	}).

-define(CMD_U2GS_DungeonTeamExpInfo,44014).
-record(pk_U2GS_DungeonTeamExpInfo,{
	}).

-define(CMD_DungeonTeamExp,33319).
-record(pk_DungeonTeamExp,{
	dungeonID = 0,
	enterTime = 0,
	star = 0
	}).

-define(CMD_GS2U_DungeonTeamExpInfo,36203).
-record(pk_GS2U_DungeonTeamExpInfo,{
	maxFightCount = 0,
	fightCount = 0,
	buyFightCountDay = 0,
	dungeon_list = []
	}).

-define(CMD_U2GS_clearEnterMapTime,27087).
-record(pk_U2GS_clearEnterMapTime,{
	dungeonID = 0
	}).

-define(CMD_GS2U_clearEnterMapTimeResult,51675).
-record(pk_GS2U_clearEnterMapTimeResult,{
	dungeonID = 0,
	result = 0
	}).

-define(CMD_U2GS_startEnterTeamMap,26029).
-record(pk_U2GS_startEnterTeamMap,{
	}).

-define(CMD_team_enter_reason,57208).
-record(pk_team_enter_reason,{
	player_id = 0,
	name = "",
	reason = 0
	}).

-define(CMD_GS2U_startEnterTeamMapResult,60156).
-record(pk_GS2U_startEnterTeamMapResult,{
	result = 0,
	reason_list = []
	}).

-define(CMD_GS2U_syncEnterTeamMap,59933).
-record(pk_GS2U_syncEnterTeamMap,{
	}).

-define(CMD_U2GS_replyEnterTeamMap,50026).
-record(pk_U2GS_replyEnterTeamMap,{
	agree = 0
	}).

-define(CMD_GS2U_replyEnterTeamMapResult,6647).
-record(pk_GS2U_replyEnterTeamMapResult,{
	agree = 0,
	result = 0
	}).

-define(CMD_GS2U_syncReplyEnterTeamMap,18715).
-record(pk_GS2U_syncReplyEnterTeamMap,{
	playerID = 0,
	agree = 0,
	mergeTimes = 0
	}).

-define(CMD_U2GS_mergeFightCount,21877).
-record(pk_U2GS_mergeFightCount,{
	dungeonID = 0,
	mergeTimes = 0
	}).

-define(CMD_GS2U_mergeFightCountResult,19943).
-record(pk_GS2U_mergeFightCountResult,{
	dungeonID = 0,
	mergeTimes = 0,
	result = 0
	}).

-define(CMD_U2GS_mergeFightManyCount,28456).
-record(pk_U2GS_mergeFightManyCount,{
	map_ai = 0,
	mergeTimes = 0
	}).

-define(CMD_GS2U_mergeFightManyCountResult,11842).
-record(pk_GS2U_mergeFightManyCountResult,{
	map_ai = 0,
	mergeTimes = 0,
	result = 0
	}).

-define(CMD_U2GS_uplevelGuildBuilding,16467).
-record(pk_U2GS_uplevelGuildBuilding,{
	buildingID = 0
	}).

-define(CMD_GS2U_uplevelGuildBuildingResult,53421).
-record(pk_GS2U_uplevelGuildBuildingResult,{
	buildingID = 0,
	result = 0
	}).

-define(CMD_U2GS_getGuildScience,60447).
-record(pk_U2GS_getGuildScience,{
	}).

-define(CMD_science,5774).
-record(pk_science,{
	id = 0,
	level = 0
	}).

-define(CMD_GS2U_sendGuildScience,38189).
-record(pk_GS2U_sendGuildScience,{
	science_list = []
	}).

-define(CMD_U2GS_uplevelGuildScience,58087).
-record(pk_U2GS_uplevelGuildScience,{
	id = 0,
	times = 0
	}).

-define(CMD_GS2U_uplevelGuildScience,36225).
-record(pk_GS2U_uplevelGuildScience,{
	id = 0,
	times = 0,
	result = 0
	}).

-define(CMD_GS2U_VipInfoSync,12649).
-record(pk_GS2U_VipInfoSync,{
	lv = 0,
	exp = 0,
	expire_time = 0,
	lv_tmp = 0,
	expire_time_tmp = 0,
	dynamic_vip_lv = 0
	}).

-define(CMD_vip_update_data,46421).
-record(pk_vip_update_data,{
	index = 0,
	value = 0
	}).

-define(CMD_GS2U_VipInfoUpdate,13500).
-record(pk_GS2U_VipInfoUpdate,{
	datas = []
	}).

-define(CMD_U2GS_requestGuildBagData,33579).
-record(pk_U2GS_requestGuildBagData,{
	}).

-define(CMD_GS2U_SendGuildBagData,3872).
-record(pk_GS2U_SendGuildBagData,{
	eq_list = [],
	event_list = []
	}).

-define(CMD_U2GS_getDungeonMergeTimes,16942).
-record(pk_U2GS_getDungeonMergeTimes,{
	dungeonID = 0
	}).

-define(CMD_GS2U_syncDungeonMergeTimes,50423).
-record(pk_GS2U_syncDungeonMergeTimes,{
	dungeonID = 0,
	mergeTimes = 0
	}).

-define(CMD_U2GS_getManyDungeonMergeTimes,46959).
-record(pk_U2GS_getManyDungeonMergeTimes,{
	map_ai = 0
	}).

-define(CMD_GS2U_syncManyDungeonMergeTimes,16199).
-record(pk_GS2U_syncManyDungeonMergeTimes,{
	map_ai = 0,
	mergeTimes = 0
	}).

-define(CMD_GS2U_presentVip,28023).
-record(pk_GS2U_presentVip,{
	preVipLv = 0
	}).

-define(CMD_U2GS_BountyLottery,24142).
-record(pk_U2GS_BountyLottery,{
	}).

-define(CMD_GS2U_BountyLotteryRet,59460).
-record(pk_GS2U_BountyLotteryRet,{
	err_code = 0,
	lv_index = 0,
	hit_index = []
	}).

-define(CMD_U2GS_BountyExpVipGet,9728).
-record(pk_U2GS_BountyExpVipGet,{
	}).

-define(CMD_GS2U_BountyExpVipGetRet,34308).
-record(pk_GS2U_BountyExpVipGetRet,{
	err_code = 0,
	exp = 0
	}).

-define(CMD_BountyTaskAward,3501).
-record(pk_BountyTaskAward,{
	items = [],
	coins = [],
	eqs = [],
	exp = 0
	}).

-define(CMD_U2GS_BountyTaskFastFinish,2521).
-record(pk_U2GS_BountyTaskFastFinish,{
	type = 0,
	task_id = 0
	}).

-define(CMD_GS2U_BountyTaskFastFinishRet,8969).
-record(pk_GS2U_BountyTaskFastFinishRet,{
	err_code = 0,
	type = 0,
	award = #pk_BountyTaskAward{}
	}).

-define(CMD_U2GS_getGuildEnvelopeInfo,59821).
-record(pk_U2GS_getGuildEnvelopeInfo,{
	}).

-define(CMD_guildEnvelope,57178).
-record(pk_guildEnvelope,{
	en_id = 0,
	type = 0,
	money = 0,
	number = 0,
	player_id = 0,
	name = "",
	headIcon = 0,
	frame = 0,
	career = 0,
	msg = "",
	time = 0,
	is_get = 0
	}).

-define(CMD_GS2U_sendGuildEnvelopeInfo,14434).
-record(pk_GS2U_sendGuildEnvelopeInfo,{
	envelope_list = [],
	event_list = []
	}).

-define(CMD_U2GS_getGuildEnvelopeRecord,37969).
-record(pk_U2GS_getGuildEnvelopeRecord,{
	en_id = 0
	}).

-define(CMD_guilEnvelopeRecord,30363).
-record(pk_guilEnvelopeRecord,{
	name = "",
	award = [],
	is_max = 0
	}).

-define(CMD_GS2U_sendGuildEnvelopeRecord,61284).
-record(pk_GS2U_sendGuildEnvelopeRecord,{
	my_award = [],
	record_list = []
	}).

-define(CMD_U2GS_get_guild_envelope,4465).
-record(pk_U2GS_get_guild_envelope,{
	en_id = 0
	}).

-define(CMD_GS2U_get_guild_envelope_result,39550).
-record(pk_GS2U_get_guild_envelope_result,{
	en_id = 0,
	result = 0
	}).

-define(CMD_U2GS_send_guild_envelope,45152).
-record(pk_U2GS_send_guild_envelope,{
	money = 0,
	number = 0,
	msg = ""
	}).

-define(CMD_GS2U_send_guild_envelope_result,60117).
-record(pk_GS2U_send_guild_envelope_result,{
	result = 0
	}).

-define(CMD_U2GS_YanMoRequestEnterMap,33544).
-record(pk_U2GS_YanMoRequestEnterMap,{
	}).

-define(CMD_U2GS_RequesYanMoInfo,36944).
-record(pk_U2GS_RequesYanMoInfo,{
	}).

-define(CMD_GS2U_RequesYanMoInfoRet,25020).
-record(pk_GS2U_RequesYanMoInfoRet,{
	boss_level = 0,
	server_type = 0,
	server_num = 0,
	start_time = 0,
	end_time = 0,
	last_exit_time = 0,
	worldLevel = 0
	}).

-define(CMD_U2GS_RequestYanMoRank,59909).
-record(pk_U2GS_RequestYanMoRank,{
	type = 0
	}).

-define(CMD_YanMoHurtInfo,47266).
-record(pk_YanMoHurtInfo,{
	rank = 0,
	player_id = 0,
	career = 0,
	head_id = 0,
	head_frame = 0,
	player_name = "",
	guild_name = "",
	battle_value = 0,
	damage = 0,
	serverName = "",
	nationality_id = 0
	}).

-define(CMD_YanMoHurtUpdate,3665).
-record(pk_YanMoHurtUpdate,{
	rank = 0,
	player_name = "",
	damage = 0,
	serverName = "",
	nationality_id = 0
	}).

-define(CMD_YanMoGuildHurtInfo,23843).
-record(pk_YanMoGuildHurtInfo,{
	rank = 0,
	guild_id = 0,
	server_name = "",
	guild_name = "",
	battle_value = 0,
	damage = 0
	}).

-define(CMD_GS2U_YanMoHurtRankSync,64759).
-record(pk_GS2U_YanMoHurtRankSync,{
	my_rank = 0,
	my_guild_rank = 0,
	my_damage = 0,
	my_guild_damage = 0,
	bin_fill = <<>>,
	type = 0,
	rank_list_up = [],
	rank_list = [],
	guild_rank_list = []
	}).

-define(CMD_YanMoLuckInfo,19105).
-record(pk_YanMoLuckInfo,{
	time = 0,
	player_id = 0,
	player_name = "",
	serverName = ""
	}).

-define(CMD_GS2U_YanMoLuckRankSync,45483).
-record(pk_GS2U_YanMoLuckRankSync,{
	lucks = []
	}).

-define(CMD_YanMoKillInfoReward,26859).
-record(pk_YanMoKillInfoReward,{
	item_id = 0,
	num = 0
	}).

-define(CMD_YanMoKillInfo,9464).
-record(pk_YanMoKillInfo,{
	time = 0,
	player_id = 0,
	player_name = "",
	serverName = "",
	awards = [],
	coins = []
	}).

-define(CMD_GS2U_YanMoKillRankSync,15775).
-record(pk_GS2U_YanMoKillRankSync,{
	ranks = []
	}).

-define(CMD_GS2U_YanMoRefreshTime,17711).
-record(pk_GS2U_YanMoRefreshTime,{
	timestamp = 0
	}).

-define(CMD_GS2U_YanMoRewardNotice,25271).
-record(pk_GS2U_YanMoRewardNotice,{
	type = 0,
	boss_id = 0,
	boss_lv = 0,
	items = [],
	coins = [],
	eqs = []
	}).

-define(CMD_GS2U_YanMoStageAward,39813).
-record(pk_GS2U_YanMoStageAward,{
	stage = 0
	}).

-define(CMD_U2GS_GetYanMoStageAward,64112).
-record(pk_U2GS_GetYanMoStageAward,{
	stage = 0
	}).

-define(CMD_GS2U_YanMoResult,39862).
-record(pk_GS2U_YanMoResult,{
	isWin = 0,
	items = [],
	coins = [],
	eqs = []
	}).

-define(CMD_GS2U_YanMoGuildResult,6373).
-record(pk_GS2U_YanMoGuildResult,{
	isWin = 0,
	rank = 0,
	guild_items = [],
	guild_coins = [],
	guild_eqs = [],
	personal_items = [],
	personal_coins = [],
	personal_eqs = []
	}).

-define(CMD_U2GS_RequesBagItemList,23322).
-record(pk_U2GS_RequesBagItemList,{
	bag_ids = [],
	is_bind = false
	}).

-define(CMD_demonFatigue,59792).
-record(pk_demonFatigue,{
	type = 0,
	fatigue = 0,
	extra_fatigue = 0
	}).

-define(CMD_GS2U_sendDemonsFatigue,27129).
-record(pk_GS2U_sendDemonsFatigue,{
	fatigue_list = []
	}).

-define(CMD_GS2U_demonFatigueChanged,16043).
-record(pk_GS2U_demonFatigueChanged,{
	type = 0,
	fatigue = 0,
	extra_fatigue = 0
	}).

-define(CMD_GS2U_NewMailArrive,51829).
-record(pk_GS2U_NewMailArrive,{
	unread_num = 0,
	one_key_op = 0
	}).

-define(CMD_U2GS_RequestMailList,22059).
-record(pk_U2GS_RequestMailList,{
	timestamp = 0
	}).

-define(CMD_itemInstanceinfo,16448).
-record(pk_itemInstanceinfo,{
	id = 0,
	itemID = 0,
	bindState = 0,
	equipment = #pk_EqInfo{}
	}).

-define(CMD_mailNew,10798).
-record(pk_mailNew,{
	mailID = 0,
	senderID = 0,
	senderName = "",
	title = "",
	describe = "",
	state = 0,
	sendTime = 0,
	getATime = 0,
	multiple = 0,
	coinList = [],
	item_info = [],
	item_ins_info = [],
	one_key_op = 0
	}).

-define(CMD_mailHead,16539).
-record(pk_mailHead,{
	mailID = 0,
	senderID = 0,
	title = "",
	state = 0,
	sendTime = 0,
	getATime = 0,
	have_award = 0,
	one_key_op = 0
	}).

-define(CMD_mailContent,11866).
-record(pk_mailContent,{
	mailID = 0,
	senderName = "",
	describe = "",
	multiple = 0,
	coinList = [],
	item_info = [],
	item_ins_info = []
	}).

-define(CMD_U2GS_RequestMailHead,42299).
-record(pk_U2GS_RequestMailHead,{
	}).

-define(CMD_GS2U_RequestMailHeadRet,64416).
-record(pk_GS2U_RequestMailHeadRet,{
	head_list = []
	}).

-define(CMD_U2GS_RequestMailContent,15832).
-record(pk_U2GS_RequestMailContent,{
	id_list = []
	}).

-define(CMD_GS2U_RequestMailContentRet,16666).
-record(pk_GS2U_RequestMailContentRet,{
	content_list = []
	}).

-define(CMD_GS2U_RequestMailListRet,55946).
-record(pk_GS2U_RequestMailListRet,{
	mailList = []
	}).

-define(CMD_U2GS_MailOp,52346).
-record(pk_U2GS_MailOp,{
	mailID = 0,
	type = 0
	}).

-define(CMD_GS2U_MailOpRet,43701).
-record(pk_GS2U_MailOpRet,{
	errCode = 0,
	mailID = 0,
	type = 0
	}).

-define(CMD_U2GS_MailOneKeyOp,8357).
-record(pk_U2GS_MailOneKeyOp,{
	type = 0
	}).

-define(CMD_GS2U_MailOneKeyOpRet,26674).
-record(pk_GS2U_MailOneKeyOpRet,{
	errCode = 0,
	mailIDList = [],
	coinList = [],
	item_info = [],
	item_ins_info = [],
	type = 0
	}).

-define(CMD_GS2U_MailDeleteNotify,17242).
-record(pk_GS2U_MailDeleteNotify,{
	mailIDList = []
	}).

-define(CMD_U2GS_DungeonPreDepositsInfo,43832).
-record(pk_U2GS_DungeonPreDepositsInfo,{
	}).

-define(CMD_DungeonPreDeposits,48839).
-record(pk_DungeonPreDeposits,{
	dungeonID = 0,
	star = 0
	}).

-define(CMD_GS2U_DungeonPreDepositsInfo,15880).
-record(pk_GS2U_DungeonPreDepositsInfo,{
	maxFightCount = 0,
	fightCount = 0,
	dungeon_list = []
	}).

-define(CMD_GS2U_push_update_version_mail,16235).
-record(pk_GS2U_push_update_version_mail,{
	info = #pk_mailHead{}
	}).

-define(CMD_HolyInfo,37321).
-record(pk_HolyInfo,{
	holy_id = 0,
	holy_lv = 0,
	holy_exp = 0,
	holy_type = 0,
	break_lv = 0,
	star = 0,
	refine_lv = 0,
	is_rein = 0
	}).

-define(CMD_GS2U_HolyUpdate,42171).
-record(pk_GS2U_HolyUpdate,{
	holys = []
	}).

-define(CMD_U2GS_HolyAddLv,33219).
-record(pk_U2GS_HolyAddLv,{
	holy_id = 0,
	costs = []
	}).

-define(CMD_GS2U_HolyAddLvRet,53715).
-record(pk_GS2U_HolyAddLvRet,{
	holy_id = 0,
	holy_lv = 0,
	holy_exp = 0,
	err_code = 0
	}).

-define(CMD_U2GS_HolyAddBreak,61729).
-record(pk_U2GS_HolyAddBreak,{
	holy_id = 0
	}).

-define(CMD_GS2U_HolyAddBreakRet,33960).
-record(pk_GS2U_HolyAddBreakRet,{
	holy_id = 0,
	break_lv = 0,
	err_code = 0
	}).

-define(CMD_U2GS_HolyAddStar,23971).
-record(pk_U2GS_HolyAddStar,{
	holy_id = 0,
	use_spec = false
	}).

-define(CMD_GS2U_HolyAddStarRet,7138).
-record(pk_GS2U_HolyAddStarRet,{
	holy_id = 0,
	star = 0,
	err_code = 0
	}).

-define(CMD_U2GS_HolyAddAwaken,32840).
-record(pk_U2GS_HolyAddAwaken,{
	holy_id = 0,
	use_spec = false
	}).

-define(CMD_GS2U_HolyAddAwakenRet,14556).
-record(pk_GS2U_HolyAddAwakenRet,{
	holy_id = 0,
	refine_lv = 0,
	err_code = 0
	}).

-define(CMD_U2GS_HolyReincarnation,45341).
-record(pk_U2GS_HolyReincarnation,{
	holy_id = 0
	}).

-define(CMD_GS2U_HolyReincarnationRet,64942).
-record(pk_GS2U_HolyReincarnationRet,{
	holy_id = 0,
	err_code = 0
	}).

-define(CMD_ShenglingSkill,16168).
-record(pk_ShenglingSkill,{
	pos = 0,
	holy_id = 0,
	skill_type = 0,
	skill_id = 0
	}).

-define(CMD_Shengling,10813).
-record(pk_Shengling,{
	type = 0,
	lv = 0,
	exp = 0,
	pill1 = 0,
	pill2 = 0,
	pill3 = 0,
	holy_id = 0
	}).

-define(CMD_GS2U_ShenglingUpdate,24437).
-record(pk_GS2U_ShenglingUpdate,{
	shenglings = []
	}).

-define(CMD_GS2U_ShenglingSkillUpdate,46867).
-record(pk_GS2U_ShenglingSkillUpdate,{
	type = 0,
	skills = []
	}).

-define(CMD_U2GS_ShenglingSkillBoxOpenReq,7750).
-record(pk_U2GS_ShenglingSkillBoxOpenReq,{
	type = 0,
	pos = 0
	}).

-define(CMD_GS2U_ShenglingSkillBoxOpenRet,5797).
-record(pk_GS2U_ShenglingSkillBoxOpenRet,{
	err_code = 0,
	type = 0,
	pos = 0
	}).

-define(CMD_U2GS_ShenglingAddLv,13420).
-record(pk_U2GS_ShenglingAddLv,{
	type = 0,
	costs = []
	}).

-define(CMD_GS2U_ShenglingAddLvRet,60200).
-record(pk_GS2U_ShenglingAddLvRet,{
	type = 0,
	lv = 0,
	exp = 0,
	err_code = 0
	}).

-define(CMD_U2GS_ShenglingSkillOp,24721).
-record(pk_U2GS_ShenglingSkillOp,{
	switch = 0,
	pos = 0,
	type = 0,
	skillid = 0,
	skill_type = 0,
	holyid = 0
	}).

-define(CMD_GS2U_ShenglingSkillOpRet,10134).
-record(pk_GS2U_ShenglingSkillOpRet,{
	err_code = 0,
	switch = 0
	}).

-define(CMD_U2GS_ShenglingEatPill,36888).
-record(pk_U2GS_ShenglingEatPill,{
	index = 0,
	pos = 0,
	num = 0,
	type = 0
	}).

-define(CMD_GS2U_ShenglingEatPillRet,55217).
-record(pk_GS2U_ShenglingEatPillRet,{
	err_code = 0
	}).

-define(CMD_U2GS_HolyEquipOP,23805).
-record(pk_U2GS_HolyEquipOP,{
	role_id = 0,
	type = 0,
	holy_id = 0
	}).

-define(CMD_GS2U_HolyEquipOPRet,58133).
-record(pk_GS2U_HolyEquipOPRet,{
	role_id = 0,
	holy_id = 0,
	err_code = 0
	}).

-define(CMD_U2GS_GetBossWorldInfo,54976).
-record(pk_U2GS_GetBossWorldInfo,{
	}).

-define(CMD_BossWorldDeadRecord,6608).
-record(pk_BossWorldDeadRecord,{
	server_name = "",
	name = "",
	kill_time = 0
	}).

-define(CMD_BossWorldInfo,38360).
-record(pk_BossWorldInfo,{
	map_id = 0,
	boss_lv = 0,
	is_dead = 0,
	refresh_time = 0,
	is_follow = 0,
	kill_record = [],
	kill_drop_list = [],
	is_pass = 0,
	dead_times = 0
	}).

-define(CMD_GS2U_GetBossWorldInfoResult,2854).
-record(pk_GS2U_GetBossWorldInfoResult,{
	gets = [],
	last_restore_time = 0,
	restore_times = 0,
	info = [],
	enter_multi = 0
	}).

-define(CMD_GS2U_BossWorldBossDead,24892).
-record(pk_GS2U_BossWorldBossDead,{
	map_id = 0
	}).

-define(CMD_U2GS_GetBossWorldInfoUpdate,1333).
-record(pk_U2GS_GetBossWorldInfoUpdate,{
	map_id = 0
	}).

-define(CMD_GS2U_GetBossWorldInfoUpdateRet,40460).
-record(pk_GS2U_GetBossWorldInfoUpdateRet,{
	info = #pk_BossWorldInfo{}
	}).

-define(CMD_U2GS_EnterBossWorld,43898).
-record(pk_U2GS_EnterBossWorld,{
	map_id = 0
	}).

-define(CMD_BossWorldRank,1978).
-record(pk_BossWorldRank,{
	player_id = 0,
	rank = 0,
	team_flag = 0,
	name = "",
	value = 0,
	serverName = "",
	nationality_id = 0
	}).

-define(CMD_GS2U_BossWorldRankInfo,3549).
-record(pk_GS2U_BossWorldRankInfo,{
	is_dead = 0,
	my_rank = 0,
	my_damage = 0,
	bin_fill = <<>>,
	refresh_time = 0,
	rank_list = []
	}).

-define(CMD_world_boss_award,33315).
-record(pk_world_boss_award,{
	items = [],
	coins = [],
	eqs = []
	}).

-define(CMD_GS2U_BossWorldResult,61946).
-record(pk_GS2U_BossWorldResult,{
	kill_award = #pk_world_boss_award{},
	rank_award = #pk_world_boss_award{},
	gets = [],
	rank = 0
	}).

-define(CMD_U2GS_quick_award,24886).
-record(pk_U2GS_quick_award,{
	dungeonID = 0
	}).

-define(CMD_GS2U_quick_award_ret,14398).
-record(pk_GS2U_quick_award_ret,{
	err_code = 0,
	times = 0,
	enter_times = 0
	}).

-define(CMD_GS2U_BossWorldHurtNotice,3094).
-record(pk_GS2U_BossWorldHurtNotice,{
	hurt_time = 0
	}).

-define(CMD_daily_task,14323).
-record(pk_daily_task,{
	task_id = 0,
	progress = 0
	}).

-define(CMD_activity_complete,16683).
-record(pk_activity_complete,{
	task_id = 0,
	normal = false,
	recharge = false
	}).

-define(CMD_U2GS_GetDailyInfo,58748).
-record(pk_U2GS_GetDailyInfo,{
	}).

-define(CMD_U2GS_GetActivityInfo,2110).
-record(pk_U2GS_GetActivityInfo,{
	}).

-define(CMD_GS2U_DailyTaskSync,41519).
-record(pk_GS2U_DailyTaskSync,{
	daily_progress_list = [],
	daily_complete_list = [],
	daily_extra_exp = []
	}).

-define(CMD_GS2U_DailyTaskUpdate,9833).
-record(pk_GS2U_DailyTaskUpdate,{
	progress_list = [],
	complete_list = [],
	daily_extra_exp = []
	}).

-define(CMD_GS2U_ActivityTaskSync,29416).
-record(pk_GS2U_ActivityTaskSync,{
	accept_list = [],
	activity_complete_list = [],
	activity_val = 0
	}).

-define(CMD_GS2U_ActivityTaskUpdate,355).
-record(pk_GS2U_ActivityTaskUpdate,{
	complete = #pk_activity_complete{},
	activity_val = 0
	}).

-define(CMD_U2GS_DailyTaskComplete,41214).
-record(pk_U2GS_DailyTaskComplete,{
	task_id = 0
	}).

-define(CMD_GS2U_DailyTaskCompleteRet,42067).
-record(pk_GS2U_DailyTaskCompleteRet,{
	err_code = 0,
	task_id = 0,
	coins = [],
	items = [],
	exp = 0
	}).

-define(CMD_U2GS_DailyTaskOneKeyComplete,14324).
-record(pk_U2GS_DailyTaskOneKeyComplete,{
	}).

-define(CMD_GS2U_DailyTaskOneKeyCompleteRet,51957).
-record(pk_GS2U_DailyTaskOneKeyCompleteRet,{
	err_code = 0,
	taskid_list = [],
	coins = [],
	items = [],
	exp = 0
	}).

-define(CMD_U2GS_ActivityTaskComplete,27924).
-record(pk_U2GS_ActivityTaskComplete,{
	task_id = 0,
	type = 0
	}).

-define(CMD_GS2U_ActivityTaskCompleteRet,50742).
-record(pk_GS2U_ActivityTaskCompleteRet,{
	err_code = 0,
	task_id = 0,
	type = 0,
	coins = [],
	items = []
	}).

-define(CMD_ActionInfo,32368).
-record(pk_ActionInfo,{
	task_id = 0,
	left_count = 0,
	bought_count = 0,
	add_count = 0
	}).

-define(CMD_GS2U_ActionInfoAllSync,4734).
-record(pk_GS2U_ActionInfoAllSync,{
	info_list = []
	}).

-define(CMD_GS2U_ActionInfoSync,36212).
-record(pk_GS2U_ActionInfoSync,{
	info = #pk_ActionInfo{}
	}).

-define(CMD_GS2U_FuncFreeSync,46181).
-record(pk_GS2U_FuncFreeSync,{
	func_id_list = []
	}).

-define(CMD_GS2U_daily_task_sync_special_state,23816).
-record(pk_GS2U_daily_task_sync_special_state,{
	state_list = []
	}).

-define(CMD_U2GS_activity_sign_up,56026).
-record(pk_U2GS_activity_sign_up,{
	openaction_id = 0
	}).

-define(CMD_GS2U_activity_sign_up_ret,20384).
-record(pk_GS2U_activity_sign_up_ret,{
	err_code = 0,
	openaction_id = 0
	}).

-define(CMD_GS2U_activity_sign_up_list,22992).
-record(pk_GS2U_activity_sign_up_list,{
	list = []
	}).

-define(CMD_U2GS_getContactList,28551).
-record(pk_U2GS_getContactList,{
	}).

-define(CMD_contactInfo,21051).
-record(pk_contactInfo,{
	playerID = 0,
	name = "",
	headID = 0,
	vip = 0,
	level = 0,
	time = 0,
	offine_time = 0,
	online = 0,
	career = 0,
	sex = 0,
	frame = 0
	}).

-define(CMD_GS2U_sendContactList,6858).
-record(pk_GS2U_sendContactList,{
	contact_list = []
	}).

-define(CMD_GS2U_DungeonPreDepositsSettleAccounts,42169).
-record(pk_GS2U_DungeonPreDepositsSettleAccounts,{
	dungeonType = 0,
	dungeonID = 0,
	isWin = 0,
	star = 0,
	exp = 0,
	intimacy = 0,
	name_list = [],
	coinList = [],
	itemList = [],
	artiIDList = [],
	settleType = 0,
	assistant = 0,
	eq_list = []
	}).

-define(CMD_DungeonBoneYardInfo,55056).
-record(pk_DungeonBoneYardInfo,{
	dungeonID = 0,
	freeTimes = 0,
	record_list = []
	}).

-define(CMD_U2GS_DungeonBoneYardInfo,51409).
-record(pk_U2GS_DungeonBoneYardInfo,{
	}).

-define(CMD_GS2U_DungeonBoneYardInfoRet,42439).
-record(pk_GS2U_DungeonBoneYardInfoRet,{
	max_count = 0,
	fight_ount = 0,
	buy_count_day = 0,
	dungeon_list = []
	}).

-define(CMD_U2GS_BoneYardMopUp,49589).
-record(pk_U2GS_BoneYardMopUp,{
	dungeonID = 0,
	call_boss_num = 0
	}).

-define(CMD_GS2U_BoneYardMopUpRet,46413).
-record(pk_GS2U_BoneYardMopUpRet,{
	err_code = 0,
	dungeonID = 0,
	exp = 0,
	items = [],
	coins = [],
	eqs = []
	}).

-define(CMD_U2GS_EnterBondYard,64838).
-record(pk_U2GS_EnterBondYard,{
	dungeonID = 0
	}).

-define(CMD_BoneYardTower,7092).
-record(pk_BoneYardTower,{
	id = 0,
	lv = 0,
	index = 0,
	monster_uid = 0
	}).

-define(CMD_BoneYardBase,45507).
-record(pk_BoneYardBase,{
	batch = 0,
	is_call_boss = false,
	soul = 0,
	escape_num = 0,
	exp = 0,
	towers = [],
	record_list = []
	}).

-define(CMD_GS2U_BoneYardBaseInfo,31814).
-record(pk_GS2U_BoneYardBaseInfo,{
	base = #pk_BoneYardBase{}
	}).

-define(CMD_GS2U_BoneYardBaseUpdate_Batch,40977).
-record(pk_GS2U_BoneYardBaseUpdate_Batch,{
	batch = 0,
	is_call_boss = false
	}).

-define(CMD_GS2U_BoneYardBaseUpdate_Soul,10276).
-record(pk_GS2U_BoneYardBaseUpdate_Soul,{
	soul = 0
	}).

-define(CMD_GS2U_BoneYardBaseUpdate_Exp,28409).
-record(pk_GS2U_BoneYardBaseUpdate_Exp,{
	exp = 0
	}).

-define(CMD_GS2U_BoneYardBaseUpdate_Escape,22146).
-record(pk_GS2U_BoneYardBaseUpdate_Escape,{
	escape_num = 0,
	uid = 0
	}).

-define(CMD_GS2U_BoneYardBaseUpdate_Tower,37893).
-record(pk_GS2U_BoneYardBaseUpdate_Tower,{
	towers = []
	}).

-define(CMD_GS2U_BoneYardBaseUpdate_RecordList,47192).
-record(pk_GS2U_BoneYardBaseUpdate_RecordList,{
	record_list = []
	}).

-define(CMD_U2GS_CreateDefTower,56912).
-record(pk_U2GS_CreateDefTower,{
	id = 0,
	index = 0,
	x = 0,
	y = 0
	}).

-define(CMD_GS2U_CreateDefTowerRet,18703).
-record(pk_GS2U_CreateDefTowerRet,{
	err_code = 0
	}).

-define(CMD_U2GS_DefTowerAddLv,28052).
-record(pk_U2GS_DefTowerAddLv,{
	id = 0,
	index = 0
	}).

-define(CMD_GS2U_DefTowerAddLvRet,2734).
-record(pk_GS2U_DefTowerAddLvRet,{
	err_code = 0
	}).

-define(CMD_U2GS_DefTowerDel,37999).
-record(pk_U2GS_DefTowerDel,{
	index = 0
	}).

-define(CMD_GS2U_DefTowerDelRet,3095).
-record(pk_GS2U_DefTowerDelRet,{
	err_code = 0
	}).

-define(CMD_U2GS_BoneYardCallBoss,4504).
-record(pk_U2GS_BoneYardCallBoss,{
	batch = 0
	}).

-define(CMD_GS2U_BoneYardCallBossRet,915).
-record(pk_GS2U_BoneYardCallBossRet,{
	err_code = 0
	}).

-define(CMD_U2GS_BoneYardShowAwardGeted,4646).
-record(pk_U2GS_BoneYardShowAwardGeted,{
	}).

-define(CMD_GS2U_BoneYardShowAwardGetedRet,28884).
-record(pk_GS2U_BoneYardShowAwardGetedRet,{
	items = [],
	coins = [],
	eqs = []
	}).

-define(CMD_GS2U_BoneYardResult,52463).
-record(pk_GS2U_BoneYardResult,{
	dungeonID = 0,
	is_win = 0,
	exp = 0,
	items = [],
	coins = [],
	eqs = [],
	max_enter_count = 0,
	enter_count = 0
	}).

-define(CMD_U2GS_BoneYardStartImmediacy,21853).
-record(pk_U2GS_BoneYardStartImmediacy,{
	}).

-define(CMD_GS2U_BoneYardStartImmediacyRet,13160).
-record(pk_GS2U_BoneYardStartImmediacyRet,{
	err_code = 0
	}).

-define(CMD_U2GS_OverImmediacy,21640).
-record(pk_U2GS_OverImmediacy,{
	}).

-define(CMD_U2GS_SkipFinishWait,45598).
-record(pk_U2GS_SkipFinishWait,{
	}).

-define(CMD_GS2U_CurMapStage,22637).
-record(pk_GS2U_CurMapStage,{
	stage = 0
	}).

-define(CMD_GS2U_CurReachStageList,24448).
-record(pk_GS2U_CurReachStageList,{
	stageList = [],
	failedList = []
	}).

-define(CMD_PlayerProp,10989).
-record(pk_PlayerProp,{
	index = 0,
	base_value = 0,
	total_value = 0
	}).

-define(CMD_PlayerPropChanged,59914).
-record(pk_PlayerPropChanged,{
	role_id = 0,
	props = []
	}).

-define(CMD_GS2U_PlayerPropChanged,64753).
-record(pk_GS2U_PlayerPropChanged,{
	props = []
	}).

-define(CMD_U2GS_DungeonDepositsExInfo,61788).
-record(pk_U2GS_DungeonDepositsExInfo,{
	}).

-define(CMD_dungeonDepositsEx,2577).
-record(pk_dungeonDepositsEx,{
	dungeonID = 0,
	star = 0
	}).

-define(CMD_GS2U_DungeonDepositsExInfo,3625).
-record(pk_GS2U_DungeonDepositsExInfo,{
	maxFightCount = 0,
	fightCount = 0,
	buyFightCountDay = 0,
	dungeon_list = []
	}).

-define(CMD_U2GS_DungeonDragonInfo,39699).
-record(pk_U2GS_DungeonDragonInfo,{
	}).

-define(CMD_dungeonDragon,41721).
-record(pk_dungeonDragon,{
	dungeonID = 0,
	star = 0,
	free = 0
	}).

-define(CMD_GS2U_DungeonDragonInfo,47283).
-record(pk_GS2U_DungeonDragonInfo,{
	maxFightCount = 0,
	fightCount = 0,
	buyFightCountDay = 0,
	dungeon_list = []
	}).

-define(CMD_GS2U_DungeonDragonpSettleAccounts,33291).
-record(pk_GS2U_DungeonDragonpSettleAccounts,{
	dungeonType = 0,
	dungeonID = 0,
	isWin = 0,
	exp = 0,
	star = 0,
	coinList = [],
	itemList = [],
	artiIDList = [],
	settleType = 0,
	isConqAward = 0,
	eq_list = []
	}).

-define(CMD_U2GS_enterDungeonDragon,22989).
-record(pk_U2GS_enterDungeonDragon,{
	dungeonID = 0
	}).

-define(CMD_DungeonMonsterKilled,43615).
-record(pk_DungeonMonsterKilled,{
	monster_id = 0,
	num = 0
	}).

-define(CMD_GS2U_DungeonMonsterKilledInfo,7898).
-record(pk_GS2U_DungeonMonsterKilledInfo,{
	info = []
	}).

-define(CMD_GS2U_DungeonKillInfo,40043).
-record(pk_GS2U_DungeonKillInfo,{
	num_p = 0,
	num_f = 0
	}).

-define(CMD_role_title,7278).
-record(pk_role_title,{
	role_id = 0,
	career = 0,
	intensity_lv = 0,
	title_show = 0
	}).

-define(CMD_GS2U_RoleTitleSync,20691).
-record(pk_GS2U_RoleTitleSync,{
	role_title_list = []
	}).

-define(CMD_U2GS_RoleTitleAddLv,31926).
-record(pk_U2GS_RoleTitleAddLv,{
	role_id = 0
	}).

-define(CMD_GS2U_RoleTitleAddLvRet,1856).
-record(pk_GS2U_RoleTitleAddLvRet,{
	role_id = 0,
	new_intensity_lv = 0,
	err_code = 0
	}).

-define(CMD_U2GS_RoleTitleEquip,54236).
-record(pk_U2GS_RoleTitleEquip,{
	role_id = 0,
	title_switch = 0
	}).

-define(CMD_GS2U_RoleTitleEquipRet,7911).
-record(pk_GS2U_RoleTitleEquipRet,{
	role_id = 0,
	title_switch = 0,
	err_code = 0
	}).

-define(CMD_U2GS_RingAddExp,24100).
-record(pk_U2GS_RingAddExp,{
	ringID = 0,
	costs = []
	}).

-define(CMD_U2GS_RingAddStar,49629).
-record(pk_U2GS_RingAddStar,{
	ringID = 0,
	is_use_debris = false
	}).

-define(CMD_U2GS_RingAddBreak,13417).
-record(pk_U2GS_RingAddBreak,{
	ringID = 0
	}).

-define(CMD_U2GS_RingAddRein,33206).
-record(pk_U2GS_RingAddRein,{
	ringID = 0
	}).

-define(CMD_U2GS_GetMapLineInfo,52324).
-record(pk_U2GS_GetMapLineInfo,{
	map_id = 0
	}).

-define(CMD_MapLineInfo,42663).
-record(pk_MapLineInfo,{
	line = 0,
	player_num = 0
	}).

-define(CMD_GS2U_GetMapLineInfoRet,42817).
-record(pk_GS2U_GetMapLineInfoRet,{
	err_code = 0,
	line_list = []
	}).

-define(CMD_U2GS_ChangeMapLine,45557).
-record(pk_U2GS_ChangeMapLine,{
	map_id = 0,
	line = 0
	}).

-define(CMD_GS2U_ChangeMapLineRet,64146).
-record(pk_GS2U_ChangeMapLineRet,{
	err_code = 0
	}).

-define(CMD_MapPlayerNumInfo,26898).
-record(pk_MapPlayerNumInfo,{
	map_data_id = 0,
	line = 0,
	player_num = 0
	}).

-define(CMD_U2GS_GetMapAiLineInfo,56230).
-record(pk_U2GS_GetMapAiLineInfo,{
	map_ai = 0
	}).

-define(CMD_GS2U_GetMapAiLineInfoRet,46448).
-record(pk_GS2U_GetMapAiLineInfoRet,{
	err_code = 0,
	map_ai = 0,
	map_list = []
	}).

-define(CMD_U2GS_GetGuildGuardInfo,46282).
-record(pk_U2GS_GetGuildGuardInfo,{
	}).

-define(CMD_GS2U_GetGuildGuardInfo,53865).
-record(pk_GS2U_GetGuildGuardInfo,{
	next_ac_time = 0
	}).

-define(CMD_GS2U_GuildGuardOpenSync,15848).
-record(pk_GS2U_GuildGuardOpenSync,{
	}).

-define(CMD_U2GS_EnterGuildGuardMap,6991).
-record(pk_U2GS_EnterGuildGuardMap,{
	}).

-define(CMD_GuildGuardInfo,13450).
-record(pk_GuildGuardInfo,{
	is_call_boss = 0,
	kill_num = 0,
	ac_end_time = 0,
	exp = 0,
	jiagu_times1 = 0,
	jiagu_times2 = 0,
	jiagu_times3 = 0
	}).

-define(CMD_GS2U_GuildGuardInfoSync,46206).
-record(pk_GS2U_GuildGuardInfoSync,{
	info = #pk_GuildGuardInfo{}
	}).

-define(CMD_gg_update_data,28979).
-record(pk_gg_update_data,{
	index = 0,
	value = 0
	}).

-define(CMD_GS2U_GuildGuardInfo_Update,57914).
-record(pk_GS2U_GuildGuardInfo_Update,{
	update_list = []
	}).

-define(CMD_U2GS_GuildGuardCallBoss,62257).
-record(pk_U2GS_GuildGuardCallBoss,{
	}).

-define(CMD_GS2U_GuildGuardCallBossRet,61958).
-record(pk_GS2U_GuildGuardCallBossRet,{
	err_code = 0
	}).

-define(CMD_U2GS_GuildGuardJiaGu,42373).
-record(pk_U2GS_GuildGuardJiaGu,{
	type = 0
	}).

-define(CMD_GS2U_GuildGuardJiaGuRet,31469).
-record(pk_GS2U_GuildGuardJiaGuRet,{
	err_code = 0
	}).

-define(CMD_GuildGuardRank,42605).
-record(pk_GuildGuardRank,{
	rank = 0,
	name = "",
	value = 0,
	nationality_id = 0
	}).

-define(CMD_GS2U_GuildGuardRankInfo,59286).
-record(pk_GS2U_GuildGuardRankInfo,{
	my_rank = 0,
	my_damage = 0,
	rank_list = []
	}).

-define(CMD_GS2U_GuildGuardResult,35252).
-record(pk_GS2U_GuildGuardResult,{
	is_win = false,
	exp1 = 0,
	exp2 = 0,
	exp3 = 0
	}).

-define(CMD_GuildGuardRankResult,41592).
-record(pk_GuildGuardRankResult,{
	rank = 0,
	name = "",
	head_id = 0,
	head_frame = 0,
	career = 0,
	battle_value = 0,
	damage = 0,
	nationality_id = 0
	}).

-define(CMD_GS2U_GuildGuardRankReslutInfo,7880).
-record(pk_GS2U_GuildGuardRankReslutInfo,{
	rank_list = []
	}).

-define(CMD_GS2U_GuildGuardAcIsSettle,18425).
-record(pk_GS2U_GuildGuardAcIsSettle,{
	is_settle = false
	}).

-define(CMD_equipment_view,814).
-record(pk_equipment_view,{
	eqs = [],
	eqps = []
	}).

-define(CMD_team_view,7329).
-record(pk_team_view,{
	team_id = 0,
	is_leader = false
	}).

-define(CMD_guild_view,39580).
-record(pk_guild_view,{
	guild_id = 0,
	guild_name = "",
	guild_rank = 0
	}).

-define(CMD_wedding_view,32600).
-record(pk_wedding_view,{
	state = 0,
	name = ""
	}).

-define(CMD_battle_value_view,63523).
-record(pk_battle_value_view,{
	id = 0,
	other_value = 0
	}).

-define(CMD_lord_ring_view,24726).
-record(pk_lord_ring_view,{
	pos = 0,
	cfg_id = 0
	}).

-define(CMD_role_view,13950).
-record(pk_role_view,{
	role_id = 0,
	career = 0,
	career_lv = 0,
	is_leader = 0,
	equipment = #pk_equipment_view{},
	honor_lv = 0,
	title_id = 0,
	wing_id = 0,
	mount_id = 0,
	dragon_id = 0,
	property_list = [],
	battle_value_list = [],
	go_list = [],
	lord_ring_list = [],
	fashionCfgIDList = [],
	hair_color_id = 0,
	skin_color_id = 0,
	height = 0,
	fashion_color = 0,
	tattoo = 0,
	tattoo_color = 0,
	weapon_list = [],
	guard_liss = []
	}).

-define(CMD_GS2U_DressPlayer,32589).
-record(pk_GS2U_DressPlayer,{
	player_id = 0,
	head_id = 0,
	frame_id = 0,
	chat_bubble_id = 0,
	album_lv = 0,
	album_exp = 0
	}).

-define(CMD_PlayerHeadInfo,32145).
-record(pk_PlayerHeadInfo,{
	head_id = 0,
	head_star = 0
	}).

-define(CMD_GS2U_PlayerHeadUpdate,16906).
-record(pk_GS2U_PlayerHeadUpdate,{
	head_list = []
	}).

-define(CMD_U2GS_PlayerHeadAddStar,45372).
-record(pk_U2GS_PlayerHeadAddStar,{
	head_id = 0
	}).

-define(CMD_GS2U_PlayerHeadAddStarRet,30654).
-record(pk_GS2U_PlayerHeadAddStarRet,{
	head_id = 0,
	head_star = 0,
	err_code = 0
	}).

-define(CMD_U2GS_ChangePlayerHead,22869).
-record(pk_U2GS_ChangePlayerHead,{
	headID = 0
	}).

-define(CMD_GS2U_ChangePlayerHead,53467).
-record(pk_GS2U_ChangePlayerHead,{
	headID = 0,
	errorCode = 0
	}).

-define(CMD_HeadFrameInfo,16631).
-record(pk_HeadFrameInfo,{
	frame_id = 0,
	frame_star = 0
	}).

-define(CMD_GS2U_HeadFrameUpdate,59042).
-record(pk_GS2U_HeadFrameUpdate,{
	frame_list = []
	}).

-define(CMD_U2GS_HeadFrameAddStar,54566).
-record(pk_U2GS_HeadFrameAddStar,{
	frame_id = 0
	}).

-define(CMD_GS2U_HeadFrameAddStarRet,50206).
-record(pk_GS2U_HeadFrameAddStarRet,{
	frame_id = 0,
	frame_star = 0,
	err_code = 0
	}).

-define(CMD_U2GS_ChangeHeadFrame,41967).
-record(pk_U2GS_ChangeHeadFrame,{
	frame_id = 0
	}).

-define(CMD_GS2U_ChangeHeadFrame,42892).
-record(pk_GS2U_ChangeHeadFrame,{
	frame_id = 0,
	errorCode = 0
	}).

-define(CMD_ChatBubbleInfo,59078).
-record(pk_ChatBubbleInfo,{
	bubble_id = 0,
	bubble_star = 0
	}).

-define(CMD_GS2U_ChatBubbleUpdate,40293).
-record(pk_GS2U_ChatBubbleUpdate,{
	bubble_list = []
	}).

-define(CMD_U2GS_ChatBubbleAddStar,64029).
-record(pk_U2GS_ChatBubbleAddStar,{
	bubble_id = 0
	}).

-define(CMD_GS2U_ChatBubbleAddStarRet,46967).
-record(pk_GS2U_ChatBubbleAddStarRet,{
	bubble_id = 0,
	bubble_star = 0,
	err_code = 0
	}).

-define(CMD_U2GS_ChangeChatBubble,865).
-record(pk_U2GS_ChangeChatBubble,{
	bubble_id = 0
	}).

-define(CMD_GS2U_ChangeChatBubbleRet,8961).
-record(pk_GS2U_ChangeChatBubbleRet,{
	bubble_id = 0,
	err_code = 0
	}).

-define(CMD_U2GS_PhotoAlbumAddLv,18090).
-record(pk_U2GS_PhotoAlbumAddLv,{
	costs = []
	}).

-define(CMD_GS2U_PhotoAlbumAddLvRet,54828).
-record(pk_GS2U_PhotoAlbumAddLvRet,{
	photo_album_lv = 0,
	photo_album_exp = 0,
	err_code = 0
	}).

-define(CMD_GuildTaskAward,106).
-record(pk_GuildTaskAward,{
	items = [],
	coins = [],
	eqs = [],
	exp = 0
	}).

-define(CMD_U2GS_AcceptGuildTask,51313).
-record(pk_U2GS_AcceptGuildTask,{
	accept_pos = 0
	}).

-define(CMD_GS2U_AcceptGuildTaskRet,63485).
-record(pk_GS2U_AcceptGuildTaskRet,{
	err_code = 0,
	accept_pos = 0
	}).

-define(CMD_GS2U_GuildTaskSync,23851).
-record(pk_GS2U_GuildTaskSync,{
	cur_rid = 0,
	award_part_list = []
	}).

-define(CMD_U2GS_QuickCompleteGuildTask,26445).
-record(pk_U2GS_QuickCompleteGuildTask,{
	type = 0,
	cur_rid = 0
	}).

-define(CMD_GS2U_QuickCompleteGuildTaskRet,32923).
-record(pk_GS2U_QuickCompleteGuildTaskRet,{
	err_code = 0,
	award = #pk_GuildTaskAward{}
	}).

-define(CMD_U2GS_GetGuildTaskPartReward,50389).
-record(pk_U2GS_GetGuildTaskPartReward,{
	part_id = 0
	}).

-define(CMD_GS2U_GetGuildTaskPartRewardRet,30648).
-record(pk_GS2U_GetGuildTaskPartRewardRet,{
	err_code = 0
	}).

-define(CMD_guild_task_info,44256).
-record(pk_guild_task_info,{
	pos = 0,
	task_id = 0
	}).

-define(CMD_GS2U_guild_task_task_info,49358).
-record(pk_GS2U_guild_task_task_info,{
	task_list = [],
	used_refresh = 0,
	accept_times = 0,
	accept_pos = 0
	}).

-define(CMD_U2GS_guild_task_refresh_task,31907).
-record(pk_U2GS_guild_task_refresh_task,{
	}).

-define(CMD_GS2U_guild_task_refresh_task_ret,29004).
-record(pk_GS2U_guild_task_refresh_task_ret,{
	err_code = 0
	}).

-define(CMD_U2GS_PutItemForTask,26111).
-record(pk_U2GS_PutItemForTask,{
	task_id = 0,
	item_uid = 0,
	count = 0
	}).

-define(CMD_GS2U_PutItemForTaskRet,63150).
-record(pk_GS2U_PutItemForTaskRet,{
	err_code = 0,
	task_id = 0,
	progress = 0
	}).

-define(CMD_role_career_sync,50534).
-record(pk_role_career_sync,{
	role_id = 0,
	career_lv = 0
	}).

-define(CMD_GS2U_CareerSync,65288).
-record(pk_GS2U_CareerSync,{
	career_list = []
	}).

-define(CMD_role_career_condition,22839).
-record(pk_role_career_condition,{
	task_id = 0,
	can_do = false
	}).

-define(CMD_GS2U_UpCareerConditionSync,59585).
-record(pk_GS2U_UpCareerConditionSync,{
	left_pre_list = []
	}).

-define(CMD_role_career_task,16203).
-record(pk_role_career_task,{
	role_id = 0,
	part = 0,
	progress = 0,
	ele_list = [],
	left_task = []
	}).

-define(CMD_GS2U_UpCareerTaskInfoSync,11206).
-record(pk_GS2U_UpCareerTaskInfoSync,{
	career_task_list = []
	}).

-define(CMD_U2GS_AcceptCareerTask,29716).
-record(pk_U2GS_AcceptCareerTask,{
	}).

-define(CMD_U2GS_ActiveFateStar,35300).
-record(pk_U2GS_ActiveFateStar,{
	role_id = 0,
	star_id = 0,
	cond_type = 0
	}).

-define(CMD_GS2U_ActiveFateStarRet,30255).
-record(pk_GS2U_ActiveFateStarRet,{
	role_id = 0,
	star_id = 0,
	err_code = 0
	}).

-define(CMD_U2GS_ActiveDragonSpirit,20257).
-record(pk_U2GS_ActiveDragonSpirit,{
	role_id = 0,
	part_id = 0,
	spirit_id = 0,
	cond_type = 0
	}).

-define(CMD_GS2U_ActiveDragonSpiritRet,4527).
-record(pk_GS2U_ActiveDragonSpiritRet,{
	role_id = 0,
	part_id = 0,
	spirit_id = 0,
	err_code = 0
	}).

-define(CMD_U2GS_ActiveDragonCristal,18371).
-record(pk_U2GS_ActiveDragonCristal,{
	role_id = 0,
	part_id = 0,
	cristal_id = 0,
	cond_type = 0
	}).

-define(CMD_GS2U_ActiveDragonCristalRet,34211).
-record(pk_GS2U_ActiveDragonCristalRet,{
	role_id = 0,
	part_id = 0,
	cristal_id = 0,
	err_code = 0
	}).

-define(CMD_U2GS_ActiveElement,19444).
-record(pk_U2GS_ActiveElement,{
	role_id = 0,
	ele_id = 0,
	ele_lv = 0,
	cond_type = 0
	}).

-define(CMD_GS2U_ActiveElementRet,158).
-record(pk_GS2U_ActiveElementRet,{
	role_id = 0,
	ele_id = 0,
	ele_lv = 0,
	err_code = 0
	}).

-define(CMD_U2GS_ActiveDemonSource,24218).
-record(pk_U2GS_ActiveDemonSource,{
	role_id = 0,
	part_id = 0,
	source_id = 0,
	cond_type = 0
	}).

-define(CMD_GS2U_ActiveDemonSourceRet,29432).
-record(pk_GS2U_ActiveDemonSourceRet,{
	role_id = 0,
	part_id = 0,
	source_id = 0,
	err_code = 0
	}).

-define(CMD_U2GS_ActiveMagicFire,26483).
-record(pk_U2GS_ActiveMagicFire,{
	role_id = 0,
	part_id = 0,
	fire_id = 0,
	cond_type = 0
	}).

-define(CMD_GS2U_ActiveMagicFireRet,52518).
-record(pk_GS2U_ActiveMagicFireRet,{
	role_id = 0,
	part_id = 0,
	fire_id = 0,
	err_code = 0
	}).

-define(CMD_U2GS_UpCareerComplete,24686).
-record(pk_U2GS_UpCareerComplete,{
	role_id = 0
	}).

-define(CMD_GS2U_UpCareerCompleteRet,41677).
-record(pk_GS2U_UpCareerCompleteRet,{
	role_id = 0,
	err_code = 0
	}).

-define(CMD_U2GS_UpCareerAddTitle,18818).
-record(pk_U2GS_UpCareerAddTitle,{
	role_id = 0,
	task_id = 0
	}).

-define(CMD_GS2U_UpCareerAddTitleRet,17922).
-record(pk_GS2U_UpCareerAddTitleRet,{
	role_id = 0,
	task_id = 0,
	star_id = 0,
	title_id = 0,
	err_code = 0
	}).

-define(CMD_GS2U_RoleTaskRedPoint,43920).
-record(pk_GS2U_RoleTaskRedPoint,{
	type = 0,
	is_red = false
	}).

-define(CMD_ProphecyTaskInfo,5042).
-record(pk_ProphecyTaskInfo,{
	task_id = 0,
	task_progress = [],
	task_complete = 0
	}).

-define(CMD_ProphecyInfo,59414).
-record(pk_ProphecyInfo,{
	book_id = 0,
	role_id = 0,
	book_progress = 0,
	book_complete = 0,
	task_list = []
	}).

-define(CMD_GS2U_ProphecyUpdate,28629).
-record(pk_GS2U_ProphecyUpdate,{
	book_list = []
	}).

-define(CMD_U2GS_AcceptingAnAward,25574).
-record(pk_U2GS_AcceptingAnAward,{
	book_id = 0,
	role_id = 0,
	task_id = 0
	}).

-define(CMD_GS2U_AcceptingAnAwardRet,4947).
-record(pk_GS2U_AcceptingAnAwardRet,{
	book_id = 0,
	role_id = 0,
	task_id = 0,
	err_code = 0
	}).

-define(CMD_U2GS_prophecy_one_key_reward_req,54266).
-record(pk_U2GS_prophecy_one_key_reward_req,{
	book_id = 0,
	role_id = 0,
	task_list = []
	}).

-define(CMD_GS2U_prophecy_one_key_reward_ret,2083).
-record(pk_GS2U_prophecy_one_key_reward_ret,{
	book_id = 0,
	role_id = 0,
	task_list = [],
	err_code = 0
	}).

-define(CMD_U2GS_GetOneFightInfo,17156).
-record(pk_U2GS_GetOneFightInfo,{
	}).

-define(CMD_GS2U_GetOneFightRet,37944).
-record(pk_GS2U_GetOneFightRet,{
	season = 0,
	seasonStartTime = 0,
	seasonEndTime = 0,
	activityStartTime = 0,
	activityStopTime = 0,
	punishTime = 0,
	office = 0,
	score = 0,
	fightCount = 0,
	buyHistory = 0,
	changedCount = 0,
	rank = 0,
	isGetDayAward = false
	}).

-define(CMD_U2GS_ChangeOneFightMatchState,25415).
-record(pk_U2GS_ChangeOneFightMatchState,{
	state = 0
	}).

-define(CMD_GS2U_ChangeOneFightMatchStateRet,14802).
-record(pk_GS2U_ChangeOneFightMatchStateRet,{
	result = 0,
	state = 0
	}).

-define(CMD_GS2U_OneFightMatchSucceed,29934).
-record(pk_GS2U_OneFightMatchSucceed,{
	player_id = 0,
	office = 0
	}).

-define(CMD_GS2U_OneFightOfficeChange,56424).
-record(pk_GS2U_OneFightOfficeChange,{
	oldOffice = 0,
	office = 0
	}).

-define(CMD_U2GS_GetOneFightRingAttainment,42934).
-record(pk_U2GS_GetOneFightRingAttainment,{
	}).

-define(CMD_OneFightRingAttainment,11905).
-record(pk_OneFightRingAttainment,{
	attainmentDataID = 0,
	value = 0,
	isAward = 0,
	value2 = 0
	}).

-define(CMD_GS2U_OneFightRingAttainmentRet,53191).
-record(pk_GS2U_OneFightRingAttainmentRet,{
	infoList = []
	}).

-define(CMD_U2GS_GainOneFightRingAttainment,49451).
-record(pk_U2GS_GainOneFightRingAttainment,{
	attainmentDataID = 0
	}).

-define(CMD_GS2U_GainOneFightRingAttainmentRet,61870).
-record(pk_GS2U_GainOneFightRingAttainmentRet,{
	result = 0,
	attainmentDataID = 0
	}).

-define(CMD_U2GS_GainOneFightDailyAward,61662).
-record(pk_U2GS_GainOneFightDailyAward,{
	}).

-define(CMD_GS2U_GainOneFightDailyAwardRet,16950).
-record(pk_GS2U_GainOneFightDailyAwardRet,{
	result = 0
	}).

-define(CMD_U2GS_GetOneFightHistory,60827).
-record(pk_U2GS_GetOneFightHistory,{
	}).

-define(CMD_OneFightRingInfo,6657).
-record(pk_OneFightRingInfo,{
	time = 0,
	isWin = 0,
	playerName = "",
	serverName = ""
	}).

-define(CMD_GS2U_GetOneFightHistoryRet,36717).
-record(pk_GS2U_GetOneFightHistoryRet,{
	historyList = []
	}).

-define(CMD_GS2U_OneFightSettleResult,19493).
-record(pk_GS2U_OneFightSettleResult,{
	isWin = 0,
	winNum = 0,
	score = 0,
	playerID = 0,
	playerName = "",
	serverName = "",
	office = 0,
	career = 0,
	player_ui = #pk_LookInfoPlayer4UI{}
	}).

-define(CMD_U2GS_inviteBuyGroupFightCount,4204).
-record(pk_U2GS_inviteBuyGroupFightCount,{
	}).

-define(CMD_GS2U_inviteBuyGroupFightCountResult,36889).
-record(pk_GS2U_inviteBuyGroupFightCountResult,{
	result = 0
	}).

-define(CMD_GS2U_sendInviteBuyGroupFightCount,1759).
-record(pk_GS2U_sendInviteBuyGroupFightCount,{
	}).

-define(CMD_U2GS_getDungeonCoupleInfo,25801).
-record(pk_U2GS_getDungeonCoupleInfo,{
	}).

-define(CMD_GS2U_sendDungeonCoupleInfo,45950).
-record(pk_GS2U_sendDungeonCoupleInfo,{
	maxFightCount = 0,
	fightCount = 0,
	buyFightCountDay = 0,
	couple_info = #pk_playerModelUI{}
	}).

-define(CMD_GS2U_sendChallengePic,17635).
-record(pk_GS2U_sendChallengePic,{
	pic_list = [],
	pic_id = 0,
	settle_time = 0,
	challenge_time = 0
	}).

-define(CMD_U2GS_playerChoicePic,32347).
-record(pk_U2GS_playerChoicePic,{
	pic_id = 0
	}).

-define(CMD_GS2U_DungeonCoupleSettleAccounts,34058).
-record(pk_GS2U_DungeonCoupleSettleAccounts,{
	dungeonID = 0,
	isWin = 0,
	isSuc = 0,
	challenge_time = 0,
	is_best = 0,
	exp = #pk_big_key_value{},
	intimacy = #pk_key_value{},
	name_list = [],
	coinList = [],
	itemList = [],
	artiIDList = [],
	settleType = 0
	}).

-define(CMD_CpTrialRank,17236).
-record(pk_CpTrialRank,{
	player_id1 = 0,
	player_id2 = 0,
	player_name1 = "",
	player_name2 = "",
	player_sex1 = 0,
	player_sex2 = 0,
	server_id = 0,
	player_lv1 = 0,
	player_lv2 = 0,
	player_career1 = 0,
	player_career2 = 0,
	best_time = 0,
	rank = 0
	}).

-define(CMD_U2GS_GetCpTrialTop,4335).
-record(pk_U2GS_GetCpTrialTop,{
	shift = 0
	}).

-define(CMD_GS2U_GetCpTrialTopRet,33548).
-record(pk_GS2U_GetCpTrialTopRet,{
	shift = 0,
	remain = 0,
	my_rank = #pk_CpTrialRank{},
	top_list = []
	}).

-define(CMD_GS2U_DungeonCoupleBossDead,6661).
-record(pk_GS2U_DungeonCoupleBossDead,{
	boss_id = 0,
	revive_time = 0,
	revive_count = 0
	}).

-define(CMD_GS2U_DungeonCoupleBossRevive,10468).
-record(pk_GS2U_DungeonCoupleBossRevive,{
	boss_id = 0,
	revive_time = 0,
	revive_count = 0
	}).

-define(CMD_GS2U_DungeonCoupleBossReviveSync,27064).
-record(pk_GS2U_DungeonCoupleBossReviveSync,{
	revive_list = []
	}).

-define(CMD_SkillBase,7611).
-record(pk_SkillBase,{
	index = 0,
	skill_id = 0,
	skill_level = 0,
	break_lv = 0,
	awaken_lv = 0,
	exp = 0
	}).

-define(CMD_role_skill,49587).
-record(pk_role_skill,{
	role_id = 0,
	skill_list = [],
	bind_skill_list_by_hand = [],
	bind_skill_list = [],
	bind_skills_normal = []
	}).

-define(CMD_GS2U_SyncPlayerSkillList,50590).
-record(pk_GS2U_SyncPlayerSkillList,{
	role_skill_list = []
	}).

-define(CMD_U2GS_SkillLevelUp,8499).
-record(pk_U2GS_SkillLevelUp,{
	role_id = 0,
	skill_index = 0
	}).

-define(CMD_GS2U_SkillLevelUpRet,29849).
-record(pk_GS2U_SkillLevelUpRet,{
	err_code = 0,
	role_id = 0,
	skill_index = 0,
	skill_lv = 0
	}).

-define(CMD_U2GS_SkillStateUp,45210).
-record(pk_U2GS_SkillStateUp,{
	role_id = 0,
	index = 0,
	state = 0
	}).

-define(CMD_GS2U_SkillStateUpRet,38692).
-record(pk_GS2U_SkillStateUpRet,{
	err_code = 0,
	role_id = 0,
	index = 0,
	state = 0,
	level = 0
	}).

-define(CMD_U2GS_RequestBindSkill,39838).
-record(pk_U2GS_RequestBindSkill,{
	role_id = 0,
	type = 0,
	bind_list = []
	}).

-define(CMD_GS2U_RequestBindSkillRet,30804).
-record(pk_GS2U_RequestBindSkillRet,{
	err_code = 0,
	role_id = 0,
	type = 0,
	new_bind_list = []
	}).

-define(CMD_U2GS_SkillReset,49695).
-record(pk_U2GS_SkillReset,{
	}).

-define(CMD_GS2U_SkillResetRet,55187).
-record(pk_GS2U_SkillResetRet,{
	err_code = 0
	}).

-define(CMD_battle_value_part,3683).
-record(pk_battle_value_part,{
	role_id = 0,
	part_list = []
	}).

-define(CMD_GS2U_BattleValuePartSync,26001).
-record(pk_GS2U_BattleValuePartSync,{
	list = []
	}).

-define(CMD_GS2U_sendReachAttainment,14613).
-record(pk_GS2U_sendReachAttainment,{
	id = 0
	}).

-define(CMD_attainmentReachInfo,18232).
-record(pk_attainmentReachInfo,{
	id = 0,
	isGet = 0
	}).

-define(CMD_U2GS_getAttainmentReachList,11008).
-record(pk_U2GS_getAttainmentReachList,{
	}).

-define(CMD_GS2U_sendAttainmentReachList,34324).
-record(pk_GS2U_sendAttainmentReachList,{
	reachList = []
	}).

-define(CMD_U2GS_getAttainmentReward,13169).
-record(pk_U2GS_getAttainmentReward,{
	prize_list = []
	}).

-define(CMD_GS2U_getAttainmentRewardRet,34464).
-record(pk_GS2U_getAttainmentRewardRet,{
	err_code = 0
	}).

-define(CMD_attainmentProgress,30748).
-record(pk_attainmentProgress,{
	id = 0,
	progress = 0
	}).

-define(CMD_U2GS_getAttainmentProgress,65076).
-record(pk_U2GS_getAttainmentProgress,{
	}).

-define(CMD_GS2U_sendAttainmentProgress,52791).
-record(pk_GS2U_sendAttainmentProgress,{
	progressList = []
	}).

-define(CMD_genius,52145).
-record(pk_genius,{
	type = 0,
	index = 0,
	level = 0
	}).

-define(CMD_GS2U_GeniusSync,59836).
-record(pk_GS2U_GeniusSync,{
	genius_info = []
	}).

-define(CMD_U2GS_UpgradeGenius,11979).
-record(pk_U2GS_UpgradeGenius,{
	type = 0,
	index = 0
	}).

-define(CMD_GS2U_UpgradeGeniusRet,40410).
-record(pk_GS2U_UpgradeGeniusRet,{
	err_code = 0,
	type = 0,
	index = 0,
	level = 0
	}).

-define(CMD_U2GS_ResetGenius,35458).
-record(pk_U2GS_ResetGenius,{
	}).

-define(CMD_GS2U_ResetGeniusRet,17470).
-record(pk_GS2U_ResetGeniusRet,{
	err_code = 0
	}).

-define(CMD_GS2U_demonBossLife,33911).
-record(pk_GS2U_demonBossLife,{
	map_data_id = 0,
	boss_id = 0,
	dead_time = 0,
	index = 0
	}).

-define(CMD_U2GS_ShowEqInfo,33087).
-record(pk_U2GS_ShowEqInfo,{
	type = 0,
	eq_uid = 0
	}).

-define(CMD_GS2U_ShowEqInfoRet,37195).
-record(pk_GS2U_ShowEqInfoRet,{
	err_code = 0,
	eq_uid = 0,
	eq_info = #pk_EqInfo{},
	df_eq_info = #pk_dark_flame_eq{},
	shengwen_info = #pk_ShengWen{}
	}).

-define(CMD_GS2U_show_holy_wing_info_ret,45979).
-record(pk_GS2U_show_holy_wing_info_ret,{
	err_code = 0,
	eq_uid = 0,
	eq_info = #pk_holy_wing{}
	}).

-define(CMD_GS2U_DuplicateReward,55886).
-record(pk_GS2U_DuplicateReward,{
	type = 0,
	id = 0,
	coin_list = [],
	item_list = []
	}).

-define(CMD_U2GS_getFuncOpenTime,4916).
-record(pk_U2GS_getFuncOpenTime,{
	id_list = []
	}).

-define(CMD_funcOpenTime,58277).
-record(pk_funcOpenTime,{
	id = 0,
	time = 0,
	time2 = 0
	}).

-define(CMD_GS2U_sendFuncOpenTime,48193).
-record(pk_GS2U_sendFuncOpenTime,{
	open_list = []
	}).

-define(CMD_U2GS_hangAutoSetting,59680).
-record(pk_U2GS_hangAutoSetting,{
	type = 0,
	itemType = 0,
	is_open = 0
	}).

-define(CMD_GS2U_hangAutoSettingResult,57055).
-record(pk_GS2U_hangAutoSettingResult,{
	type = 0,
	itemType = 0,
	result = 0
	}).

-define(CMD_U2GS_Logout,33450).
-record(pk_U2GS_Logout,{
	}).

-define(CMD_GS2U_EmojiList,60190).
-record(pk_GS2U_EmojiList,{
	emojiIDList = []
	}).

-define(CMD_U2GS_SendEmoji,55760).
-record(pk_U2GS_SendEmoji,{
	emojiID = 0
	}).

-define(CMD_GS2U_SendEmojiRet,30899).
-record(pk_GS2U_SendEmojiRet,{
	errCode = 0,
	emojiID = 0
	}).

-define(CMD_GS2U_EmojiActiveByLevelUp,33953).
-record(pk_GS2U_EmojiActiveByLevelUp,{
	emojiIDList = []
	}).

-define(CMD_U2GS_enterDungeonTeamExp,23483).
-record(pk_U2GS_enterDungeonTeamExp,{
	dungeonID = 0,
	mergeTimes = 0
	}).

-define(CMD_U2GS_RequestGCInfo,45105).
-record(pk_U2GS_RequestGCInfo,{
	}).

-define(CMD_gc_team,64153).
-record(pk_gc_team,{
	name = "",
	server_name = "",
	group_id = 0
	}).

-define(CMD_GS2U_RequestGCInfoRet,40022).
-record(pk_GS2U_RequestGCInfoRet,{
	s = [],
	a = [],
	b = [],
	c = [],
	d = [],
	state = 0,
	day_second = 0
	}).

-define(CMD_U2GS_RequestGCNextStartTime,30017).
-record(pk_U2GS_RequestGCNextStartTime,{
	}).

-define(CMD_GS2U_RequestGCNextStartTimeRet,25736).
-record(pk_GS2U_RequestGCNextStartTimeRet,{
	timestamp = 0
	}).

-define(CMD_U2GS_RequestGCResult,41651).
-record(pk_U2GS_RequestGCResult,{
	}).

-define(CMD_gc_overlord,51526).
-record(pk_gc_overlord,{
	ui_info = #pk_LookInfoPlayer4UI{},
	rank = 0
	}).

-define(CMD_GS2U_RequestGCResultRet,8478).
-record(pk_GS2U_RequestGCResultRet,{
	overloads = [],
	guild_name = "",
	server_name = "",
	t1 = 0,
	t2 = 0,
	zone = 0,
	rank = 0
	}).

-define(CMD_U2GS_GCGetDailyAward,62740).
-record(pk_U2GS_GCGetDailyAward,{
	}).

-define(CMD_GS2U_GCGetDailyAwardRet,42445).
-record(pk_GS2U_GCGetDailyAwardRet,{
	err_code = 0
	}).

-define(CMD_U2GS_RequestEnterGC,13619).
-record(pk_U2GS_RequestEnterGC,{
	}).

-define(CMD_gc_map_team,27204).
-record(pk_gc_map_team,{
	color = 0,
	name = "",
	server_name = "",
	point = 0,
	num_person = 0,
	num_flag = 0
	}).

-define(CMD_GS2U_GCMapInfo,14585).
-record(pk_GS2U_GCMapInfo,{
	stage = 0,
	teams = [],
	boss1_state = 0,
	boss2_state = 0
	}).

-define(CMD_GS2U_GCMapBossStateUpdate,28034).
-record(pk_GS2U_GCMapBossStateUpdate,{
	boss1_state = 0,
	boss2_state = 0
	}).

-define(CMD_gc_map_team_update,37330).
-record(pk_gc_map_team_update,{
	color = 0,
	key = 0,
	value = 0
	}).

-define(CMD_GS2U_GCMapTeamUpdate,47567).
-record(pk_GS2U_GCMapTeamUpdate,{
	updates = []
	}).

-define(CMD_gc_player_rank_settle,2704).
-record(pk_gc_player_rank_settle,{
	rank = 0,
	player_name = "",
	guild_name = "",
	server_name = "",
	career_id = 0,
	head_id = 0,
	frame = 0,
	battle = 0,
	point = 0,
	nationality_id = 0
	}).

-define(CMD_GS2U_GCMapTeamRankSettle,54497).
-record(pk_GS2U_GCMapTeamRankSettle,{
	rank = [],
	my_rank = 0,
	my_point = 0
	}).

-define(CMD_gc_player_rank,8529).
-record(pk_gc_player_rank,{
	rank = 0,
	player_name = "",
	guild_name = "",
	server_name = "",
	flag_num = 0,
	kill_num = 0,
	point = 0,
	nationality_id = 0
	}).

-define(CMD_GS2U_GCMapTeamRank,39427).
-record(pk_GS2U_GCMapTeamRank,{
	ranks = [],
	my_flag_num = 0,
	my_rank = 0,
	my_kill_num = 0,
	my_point = 0
	}).

-define(CMD_GS2U_GCResult,44460).
-record(pk_GS2U_GCResult,{
	isWin = 0,
	items = [],
	coins = [],
	eqs = []
	}).

-define(CMD_GS2U_GCSatetSync,6895).
-record(pk_GS2U_GCSatetSync,{
	state = 0
	}).

-define(CMD_U2GS_getBrobabilityText,15904).
-record(pk_U2GS_getBrobabilityText,{
	id = 0
	}).

-define(CMD_GS2U_getBrobabilityTextRet,61534).
-record(pk_GS2U_getBrobabilityTextRet,{
	id = 0,
	bro_text = ""
	}).

-define(CMD_blessInfo,4112).
-record(pk_blessInfo,{
	id = 0,
	free_count = 0,
	bless_time = 0,
	day_count = 0,
	bless_count = 0
	}).

-define(CMD_U2GS_getBlessData,43816).
-record(pk_U2GS_getBlessData,{
	}).

-define(CMD_GS2U_sendBlessData,11132).
-record(pk_GS2U_sendBlessData,{
	bless_list = []
	}).

-define(CMD_U2GS_blessGift,21849).
-record(pk_U2GS_blessGift,{
	id = 0,
	is_free = 0
	}).

-define(CMD_GS2U_blessGiftResult,7373).
-record(pk_GS2U_blessGiftResult,{
	id = 0,
	is_free = 0,
	exp = 0,
	coin = 0,
	crit = 0,
	result = 0
	}).

-define(CMD_FreeBuyData,9295).
-record(pk_FreeBuyData,{
	id = 0,
	buy_time = 0
	}).

-define(CMD_U2GS_FreeBuyDataReq,41719).
-record(pk_U2GS_FreeBuyDataReq,{
	}).

-define(CMD_GS2U_FreeBuyDataSync,59766).
-record(pk_GS2U_FreeBuyDataSync,{
	func_start_time = 0,
	data_list = []
	}).

-define(CMD_U2GS_FreeShoppingReq,444).
-record(pk_U2GS_FreeShoppingReq,{
	id = 0
	}).

-define(CMD_GS2U_FreeShoppingRet,12920).
-record(pk_GS2U_FreeShoppingRet,{
	err_code = 0,
	data = #pk_FreeBuyData{}
	}).

-define(CMD_U2GS_GetFreeBuyGiftReq,48139).
-record(pk_U2GS_GetFreeBuyGiftReq,{
	id = 0
	}).

-define(CMD_GS2U_GetFreeBuyGiftRet,1735).
-record(pk_GS2U_GetFreeBuyGiftRet,{
	err_code = 0,
	id = 0
	}).

-define(CMD_U2GS_RequestXOInfo,40698).
-record(pk_U2GS_RequestXOInfo,{
	}).

-define(CMD_GS2U_RequestXOInfoRet,5439).
-record(pk_GS2U_RequestXOInfoRet,{
	server_type = 0,
	start_time = 0,
	end_time = 0
	}).

-define(CMD_xo_rank,59138).
-record(pk_xo_rank,{
	rank = 0,
	player_id = 0,
	name = "",
	guild_name = "",
	right_num = 0,
	point = 0,
	serverName = "",
	nationality_id = 0
	}).

-define(CMD_U2GS_RequestXOUIRank,23974).
-record(pk_U2GS_RequestXOUIRank,{
	}).

-define(CMD_GS2U_RequestXOUIRankRet,52568).
-record(pk_GS2U_RequestXOUIRankRet,{
	ranks = [],
	my_right_num = 0,
	my_point = 0,
	my_rank = 0,
	my_server = ""
	}).

-define(CMD_U2GS_RequestXOEnterMap,25688).
-record(pk_U2GS_RequestXOEnterMap,{
	}).

-define(CMD_GS2U_XOState,37891).
-record(pk_GS2U_XOState,{
	state = 0,
	question_index = 0,
	question = "",
	answer = 0,
	start_time = 0
	}).

-define(CMD_GS2U_XOJoinNum,1176).
-record(pk_GS2U_XOJoinNum,{
	num = 0
	}).

-define(CMD_xo_player_rank,51165).
-record(pk_xo_player_rank,{
	name = "",
	serverName = "",
	point = 0,
	nationality_id = 0
	}).

-define(CMD_GS2U_XORankInfoSync,50466).
-record(pk_GS2U_XORankInfoSync,{
	ranks = [],
	my_point = 0,
	my_exp = 0,
	actor_num = 0,
	is_right = false,
	is_viewer = false
	}).

-define(CMD_GS2U_XOIsBet,11530).
-record(pk_GS2U_XOIsBet,{
	is_bet = false,
	ranks = [],
	my_point = 0,
	my_exp = 0,
	actor_num = 0,
	is_viewer = false
	}).

-define(CMD_GS2U_XOAnswerStat,34187).
-record(pk_GS2U_XOAnswerStat,{
	x_num = 0,
	o_num = 0
	}).

-define(CMD_U2GS_XOEnterArea,42088).
-record(pk_U2GS_XOEnterArea,{
	type = 0
	}).

-define(CMD_GS2U_XOEnterAreaRet,23228).
-record(pk_GS2U_XOEnterAreaRet,{
	err_code = 0,
	type = 0
	}).

-define(CMD_U2GS_XOExitArea,3341).
-record(pk_U2GS_XOExitArea,{
	type = 0
	}).

-define(CMD_GS2U_XOExitAreaRet,38043).
-record(pk_GS2U_XOExitAreaRet,{
	err_code = 0,
	type = 0
	}).

-define(CMD_U2GS_XOReply,40214).
-record(pk_U2GS_XOReply,{
	answer = 0
	}).

-define(CMD_GS2U_XOReplyRet,53171).
-record(pk_GS2U_XOReplyRet,{
	err_code = 0,
	answer = 0
	}).

-define(CMD_xo_rank_info,12682).
-record(pk_xo_rank_info,{
	rank = 0,
	name = "",
	serverName = "",
	diamond = 0,
	nationality_id = 0
	}).

-define(CMD_BetInfo,42685).
-record(pk_BetInfo,{
	id = 0,
	is_beted = 0,
	my_bet_rank = 0,
	my_bet_diamond = 0,
	ranks = []
	}).

-define(CMD_GS2U_XOResult,21856).
-record(pk_GS2U_XOResult,{
	my_point = 0,
	my_rank = 0,
	my_right_num = 0,
	player_name = "",
	firstServerName = "",
	items = [],
	coins = [],
	eqs = [],
	bet_infos = [],
	bet_player_name = ""
	}).

-define(CMD_U2GS_XOBetUI,5551).
-record(pk_U2GS_XOBetUI,{
	}).

-define(CMD_xo_bet,52647).
-record(pk_xo_bet,{
	id = 0,
	reslut = 0,
	num = 0
	}).

-define(CMD_xo_odds,43038).
-record(pk_xo_odds,{
	index = 0,
	num = 0
	}).

-define(CMD_GS2U_XOBetUIRet,22400).
-record(pk_GS2U_XOBetUIRet,{
	bets = [],
	odds = []
	}).

-define(CMD_U2GS_XOBet,44475).
-record(pk_U2GS_XOBet,{
	id = 0,
	result = 0,
	num = 0
	}).

-define(CMD_GS2U_XOBetRet,34726).
-record(pk_GS2U_XOBetRet,{
	err_code = 0,
	id = 0,
	num = 0
	}).

-define(CMD_GS2U_XOBetOdds,45708).
-record(pk_GS2U_XOBetOdds,{
	odds = []
	}).

-define(CMD_FundsBuy,57981).
-record(pk_FundsBuy,{
	fund_type = 0,
	plan = 0,
	buy_time = 0
	}).

-define(CMD_FundsAward,50898).
-record(pk_FundsAward,{
	fund_type = 0,
	award_id = 0,
	plan = 0,
	isGet = 0
	}).

-define(CMD_FundsAwardRet,50397).
-record(pk_FundsAwardRet,{
	award_id = 0,
	isGet = 0
	}).

-define(CMD_GS2U_FundsBuyInfoSync,18973).
-record(pk_GS2U_FundsBuyInfoSync,{
	buy_info = []
	}).

-define(CMD_GS2U_FundsAwardInfoSync,65306).
-record(pk_GS2U_FundsAwardInfoSync,{
	award_info = []
	}).

-define(CMD_GS2U_FundsAllAwardInfoSync,38438).
-record(pk_GS2U_FundsAllAwardInfoSync,{
	award_list = []
	}).

-define(CMD_U2GS_FundsBuyReq,2129).
-record(pk_U2GS_FundsBuyReq,{
	fund_type = 0,
	plan = 0
	}).

-define(CMD_U2GS_FundsBuyRet,13679).
-record(pk_U2GS_FundsBuyRet,{
	err_code = 0,
	data = #pk_FundsBuy{}
	}).

-define(CMD_U2GS_FundsAwardReq,46295).
-record(pk_U2GS_FundsAwardReq,{
	fund_type = 0,
	plan = 0,
	award_id = 0
	}).

-define(CMD_U2GS_FundsAwardRet,57845).
-record(pk_U2GS_FundsAwardRet,{
	err_code = 0,
	fund_type = 0,
	award_id = [],
	plan = 0
	}).

-define(CMD_U2GS_FundsAllAwardReq,63009).
-record(pk_U2GS_FundsAllAwardReq,{
	award_id_list = []
	}).

-define(CMD_GS2U_FundsAllAwardRet,39621).
-record(pk_GS2U_FundsAllAwardRet,{
	err_code = 0,
	award_id_list = []
	}).

-define(CMD_U2GS_FundsDailyGiftReq,45077).
-record(pk_U2GS_FundsDailyGiftReq,{
	}).

-define(CMD_GS2U_FundsDailyGiftRet,64211).
-record(pk_GS2U_FundsDailyGiftRet,{
	error = 0
	}).

-define(CMD_FinancingBuy,6239).
-record(pk_FinancingBuy,{
	type = 0,
	grade = 0,
	lv = 0,
	buy_time = 0,
	count = 0
	}).

-define(CMD_FinancingAward,32065).
-record(pk_FinancingAward,{
	type = 0,
	grade = 0,
	award_id = 0
	}).

-define(CMD_GS2U_FinancingBuyInfoSync,60443).
-record(pk_GS2U_FinancingBuyInfoSync,{
	buy_info = []
	}).

-define(CMD_GS2U_FinancingAwardInfoSync,3659).
-record(pk_GS2U_FinancingAwardInfoSync,{
	award_info = []
	}).

-define(CMD_U2GS_FinancingBuyReq,26787).
-record(pk_U2GS_FinancingBuyReq,{
	type = 0
	}).

-define(CMD_U2GS_FinancingBuyRet,38337).
-record(pk_U2GS_FinancingBuyRet,{
	err_code = 0,
	data = #pk_FinancingBuy{}
	}).

-define(CMD_U2GS_FinancingAwardReq,41933).
-record(pk_U2GS_FinancingAwardReq,{
	type = 0,
	grade = 0,
	award_id = 0
	}).

-define(CMD_U2GS_FinancingAwardRet,53483).
-record(pk_U2GS_FinancingAwardRet,{
	err_code = 0,
	data = #pk_FinancingAward{}
	}).

-define(CMD_U2GS_MouthFinancingDailyGiftReq,29024).
-record(pk_U2GS_MouthFinancingDailyGiftReq,{
	}).

-define(CMD_GS2U_MouthFinancingDailyGiftRet,50757).
-record(pk_GS2U_MouthFinancingDailyGiftRet,{
	error = 0
	}).

-define(CMD_ga_item,28823).
-record(pk_ga_item,{
	ga_id = 0,
	ac_id = 0,
	ac_type = 0,
	item_id = 0,
	bind = 0,
	cur_buy = 0,
	max_buy = 0,
	eq = [],
	bought = false,
	player_name = "",
	times = 0,
	curr_type = 0,
	init_cost = 0,
	add_cost = 0,
	max_cost = 0,
	cost_price = 0,
	can_bid = 0,
	bid_state = 0,
	source_id = 0
	}).

-define(CMD_ga_item_refresh,22870).
-record(pk_ga_item_refresh,{
	ga_id = 0,
	bought = false,
	player_name = "",
	times = 0,
	cur_buy = 0,
	bid_state = 0
	}).

-define(CMD_GS2U_GARedDotShow,26963).
-record(pk_GS2U_GARedDotShow,{
	ac_ids = []
	}).

-define(CMD_U2GS_RequestGAInfo,13487).
-record(pk_U2GS_RequestGAInfo,{
	}).

-define(CMD_ga_ac_info,16000).
-record(pk_ga_ac_info,{
	ac_id = 0,
	player_num = 0,
	self_can_profit = false,
	tax = 0,
	start_time = 0,
	end_time = 0,
	authority_end_time = 0,
	authority_player_id = 0
	}).

-define(CMD_GS2U_RequestGAInfoRet,40652).
-record(pk_GS2U_RequestGAInfoRet,{
	err_code = 0,
	info = [],
	ac_info = []
	}).

-define(CMD_U2GS_CloseGAUI,53718).
-record(pk_U2GS_CloseGAUI,{
	}).

-define(CMD_GS2U_GAItemRefresh,14643).
-record(pk_GS2U_GAItemRefresh,{
	list = []
	}).

-define(CMD_U2GS_GABid,54016).
-record(pk_U2GS_GABid,{
	ga_id = 0,
	times = 0
	}).

-define(CMD_GS2U_GABidRet,55824).
-record(pk_GS2U_GABidRet,{
	err_code = 0
	}).

-define(CMD_GS2U_GABidBeyondMe,45110).
-record(pk_GS2U_GABidBeyondMe,{
	info = #pk_ga_item_refresh{}
	}).

-define(CMD_U2GS_GABuyImmediate,28395).
-record(pk_U2GS_GABuyImmediate,{
	ga_id = 0,
	amount = 0
	}).

-define(CMD_GS2U_GABuyImmediateRet,13339).
-record(pk_GS2U_GABuyImmediateRet,{
	err_code = 0
	}).

-define(CMD_U2GS_GAHistory,53535).
-record(pk_U2GS_GAHistory,{
	ac_id = 0
	}).

-define(CMD_ga_item_record,50448).
-record(pk_ga_item_record,{
	item_id = 0,
	bind = 0,
	eq = [],
	type = 0,
	time = 0,
	player_name = "",
	curr_type = 0,
	curr = 0
	}).

-define(CMD_GS2U_GAHistoryRet,28965).
-record(pk_GS2U_GAHistoryRet,{
	ac_id = 0,
	records = []
	}).

-define(CMD_U2GS_GAProfitHistory,39286).
-record(pk_U2GS_GAProfitHistory,{
	ac_id = 0
	}).

-define(CMD_GS2U_GAProfitHistoryRet,10869).
-record(pk_GS2U_GAProfitHistoryRet,{
	ac_id = 0,
	time = 0,
	curr_list = [],
	player_num = 0,
	self_can_profit = false,
	tax = 0,
	names = []
	}).

-define(CMD_U2GS_GetGaTotalCurr,8236).
-record(pk_U2GS_GetGaTotalCurr,{
	ac_id = 0
	}).

-define(CMD_GS2U_GetGaTotalCurrRet,33885).
-record(pk_GS2U_GetGaTotalCurrRet,{
	ac_id = 0,
	total_curr = []
	}).

-define(CMD_U2GS_set_bid_authority,59158).
-record(pk_U2GS_set_bid_authority,{
	ga_id = 0,
	type = 0,
	player_id_list = []
	}).

-define(CMD_GS2U_set_bid_authority_ret,27628).
-record(pk_GS2U_set_bid_authority_ret,{
	err_code = 0,
	ga_id = 0,
	type = 0,
	player_id_list = []
	}).

-define(CMD_U2GS_get_bid_authority,20618).
-record(pk_U2GS_get_bid_authority,{
	ga_id = 0
	}).

-define(CMD_GS2U_get_bid_authority_ret,14239).
-record(pk_GS2U_get_bid_authority_ret,{
	err_code = 0,
	ga_id = 0,
	type = 0,
	player_id_list = []
	}).

-define(CMD_GS2U_get_authority_red,88).
-record(pk_GS2U_get_authority_red,{
	ac_id = 0,
	ga_id = 0,
	is_operator = 0,
	type = 0
	}).

-define(CMD_U2GS_getTeamAssistant,19307).
-record(pk_U2GS_getTeamAssistant,{
	}).

-define(CMD_team_assistant_member,64940).
-record(pk_team_assistant_member,{
	id = 0,
	rank = 0,
	invite_time = 0,
	ui_info = #pk_LookInfoPlayer4UI{}
	}).

-define(CMD_GS2U_send_team_assistant,3389).
-record(pk_GS2U_send_team_assistant,{
	member_list = []
	}).

-define(CMD_U2GS_invite_team_assistant,32248).
-record(pk_U2GS_invite_team_assistant,{
	id = 0
	}).

-define(CMD_GS2U_invite_team_assistant_result,24828).
-record(pk_GS2U_invite_team_assistant_result,{
	id = 0,
	result = 0
	}).

-define(CMD_U2GS_LifeCardFinish,65192).
-record(pk_U2GS_LifeCardFinish,{
	id = 0,
	type = 0
	}).

-define(CMD_GS2U_LifeCardFinish,12306).
-record(pk_GS2U_LifeCardFinish,{
	id = 0,
	type = 0,
	error = 0
	}).

-define(CMD_U2GS_LifeCardDailyGiftReq,47459).
-record(pk_U2GS_LifeCardDailyGiftReq,{
	}).

-define(CMD_GS2U_LifeCardDailyGiftRet,32350).
-record(pk_GS2U_LifeCardDailyGiftRet,{
	error = 0
	}).

-define(CMD_currency_pair,48054).
-record(pk_currency_pair,{
	id = 0,
	value = 0
	}).

-define(CMD_GS2U_currency_list,9005).
-record(pk_GS2U_currency_list,{
	currencyList = []
	}).

-define(CMD_GS2U_currency_update,46720).
-record(pk_GS2U_currency_update,{
	currency = #pk_currency_pair{}
	}).

-define(CMD_GS2U_StageAwardNowStage,44673).
-record(pk_GS2U_StageAwardNowStage,{
	stage = 0
	}).

-define(CMD_U2GS_GetStageAward,45612).
-record(pk_U2GS_GetStageAward,{
	stage = 0
	}).

-define(CMD_GS2U_GetStageAwardRet,25297).
-record(pk_GS2U_GetStageAwardRet,{
	err_code = 0,
	stage = 0
	}).

-define(CMD_GS2U_FireTheBossList,41311).
-record(pk_GS2U_FireTheBossList,{
	boss_id = []
	}).

-define(CMD_U2GS_FireTheBoss,17651).
-record(pk_U2GS_FireTheBoss,{
	boss_id = 0
	}).

-define(CMD_GS2U_FireTheBoss,38463).
-record(pk_GS2U_FireTheBoss,{
	boss_id = 0
	}).

-define(CMD_U2GS_CPMonthCardBuy,59372).
-record(pk_U2GS_CPMonthCardBuy,{
	}).

-define(CMD_GS2U_CPMonthCardBuy,6486).
-record(pk_GS2U_CPMonthCardBuy,{
	err_code = 0,
	target = 0
	}).

-define(CMD_U2GS_CPMonthCardRequest,17212).
-record(pk_U2GS_CPMonthCardRequest,{
	}).

-define(CMD_GS2U_CPMonthCardRequest,9401).
-record(pk_GS2U_CPMonthCardRequest,{
	err_code = 0,
	target = 0
	}).

-define(CMD_U2GS_CPMonthCardRequestResponse,30009).
-record(pk_U2GS_CPMonthCardRequestResponse,{
	result = 0
	}).

-define(CMD_GS2U_CPMonthCardRequestResponse,40193).
-record(pk_GS2U_CPMonthCardRequestResponse,{
	err_code = 0,
	target = 0,
	result = 0
	}).

-define(CMD_GS2U_CPMonthCardInfoSync,30465).
-record(pk_GS2U_CPMonthCardInfoSync,{
	expire_time = 0,
	award_info = 0,
	expire_time_pair = 0
	}).

-define(CMD_U2GS_CPMonthCardAward,42425).
-record(pk_U2GS_CPMonthCardAward,{
	award_type = 0
	}).

-define(CMD_GS2U_CPMonthCardAward,7487).
-record(pk_GS2U_CPMonthCardAward,{
	err_code = 0,
	award_type = 0
	}).

-define(CMD_U2GS_get_wedding_reward_info,16506).
-record(pk_U2GS_get_wedding_reward_info,{
	}).

-define(CMD_weddingAward,15328).
-record(pk_weddingAward,{
	time = 0,
	get_type = 0,
	award_type = 0,
	id = 0,
	num = 0
	}).

-define(CMD_GS2U_send_wedding_reward_info,22853).
-record(pk_GS2U_send_wedding_reward_info,{
	log_list = []
	}).

-define(CMD_U2GS_getWeddingMarryMapInfo,52341).
-record(pk_U2GS_getWeddingMarryMapInfo,{
	}).

-define(CMD_GS2U_VipGuideAward,52213).
-record(pk_GS2U_VipGuideAward,{
	type = 0
	}).

-define(CMD_LogTimes,12561).
-record(pk_LogTimes,{
	type = 0,
	times = 0
	}).

-define(CMD_GS2U_LogTimesSync,12166).
-record(pk_GS2U_LogTimesSync,{
	list = []
	}).

-define(CMD_U2GS_EnterDungeonDemonCopyMap,19447).
-record(pk_U2GS_EnterDungeonDemonCopyMap,{
	dungeonID = 0,
	is_clr_cd = 0
	}).

-define(CMD_GS2U_BuffObjApperaVoiceSync,24394).
-record(pk_GS2U_BuffObjApperaVoiceSync,{
	type = 0
	}).

-define(CMD_SevenTaskInfo,11516).
-record(pk_SevenTaskInfo,{
	group = 0,
	day = 0,
	page = 0,
	id = 0,
	progress = [],
	is_complete = false,
	is_get = false,
	time = 0
	}).

-define(CMD_SevenDailyInfo,62939).
-record(pk_SevenDailyInfo,{
	group = 0,
	day = 0,
	score = 0,
	get_list = []
	}).

-define(CMD_SevenAwardInfo,48308).
-record(pk_SevenAwardInfo,{
	group = 0,
	id = 0
	}).

-define(CMD_U2GS_SevenGiftInfoReq,59899).
-record(pk_U2GS_SevenGiftInfoReq,{
	}).

-define(CMD_GS2U_SevenGiftInfoSync,13299).
-record(pk_GS2U_SevenGiftInfoSync,{
	create_time = 0,
	group = 0,
	pt = 0,
	task_list = [],
	award_list = [],
	daily_list = []
	}).

-define(CMD_U2GS_SevenGiftBuyReq,21886).
-record(pk_U2GS_SevenGiftBuyReq,{
	group = 0,
	day = 0,
	page = 0,
	id = 0
	}).

-define(CMD_GS2U_SevenGiftBuyRet,34361).
-record(pk_GS2U_SevenGiftBuyRet,{
	err_code = 0,
	group = 0,
	day = 0,
	page = 0,
	id = 0
	}).

-define(CMD_U2GS_SevenTaskAwardReq,26321).
-record(pk_U2GS_SevenTaskAwardReq,{
	group = 0,
	day = 0,
	page = 0,
	id = 0
	}).

-define(CMD_GS2U_SevenTaskAwardRet,45455).
-record(pk_GS2U_SevenTaskAwardRet,{
	err_code = 0,
	group = 0,
	day = 0,
	page = 0,
	id = 0
	}).

-define(CMD_U2GS_SevenDailyAwardReq,42377).
-record(pk_U2GS_SevenDailyAwardReq,{
	group = 0,
	day = 0
	}).

-define(CMD_GS2U_SevenDailyAwardRet,46116).
-record(pk_GS2U_SevenDailyAwardRet,{
	err_code = 0,
	group = 0,
	day = 0
	}).

-define(CMD_U2GS_SevenPtAwardReq,30218).
-record(pk_U2GS_SevenPtAwardReq,{
	group = 0,
	id = 0
	}).

-define(CMD_GS2U_SevenPtAwardRet,42693).
-record(pk_GS2U_SevenPtAwardRet,{
	err_code = 0,
	group = 0,
	id = 0
	}).

-define(CMD_GS2U_EnergyUISync,52756).
-record(pk_GS2U_EnergyUISync,{
	type = 0,
	param = 0
	}).

-define(CMD_U2GS_TaskFlyToDest,29512).
-record(pk_U2GS_TaskFlyToDest,{
	map_cfg_id = 0,
	x = 0,
	y = 0
	}).

-define(CMD_GS2U_TaskFlyToDestRet,38476).
-record(pk_GS2U_TaskFlyToDestRet,{
	err_code = 0
	}).

-define(CMD_U2GS_GuildDepotAutoClearSet,45138).
-record(pk_U2GS_GuildDepotAutoClearSet,{
	enable = false,
	chara = 0,
	star = 0,
	order = 0
	}).

-define(CMD_GS2U_GuildDepotAutoClearSet,17186).
-record(pk_GS2U_GuildDepotAutoClearSet,{
	err_code = 0
	}).

-define(CMD_GS2U_GuildDepotAutoClearStateSync,42715).
-record(pk_GS2U_GuildDepotAutoClearStateSync,{
	enable = false,
	chara = 0,
	star = 0,
	order = 0
	}).

-define(CMD_U2GS_GuildImpeach,30722).
-record(pk_U2GS_GuildImpeach,{
	}).

-define(CMD_GS2U_GuildImpeachRet,6508).
-record(pk_GS2U_GuildImpeachRet,{
	err_code = 0
	}).

-define(CMD_GS2U_WorldServerForeShowInfo,56546).
-record(pk_GS2U_WorldServerForeShowInfo,{
	state = 0,
	time = 0,
	openProgress = 0,
	first_name = ""
	}).

-define(CMD_U2GS_GetWorldServerOpenProgressInfo,45242).
-record(pk_U2GS_GetWorldServerOpenProgressInfo,{
	}).

-define(CMD_GS2U_WorldServerOpenProgressInfo,35425).
-record(pk_GS2U_WorldServerOpenProgressInfo,{
	myKillNum = 0,
	myRank = 0,
	openProgress = 0,
	stageReach = 0,
	stageAward = 0
	}).

-define(CMD_U2GS_GetWorldServerOpenAward,39341).
-record(pk_U2GS_GetWorldServerOpenAward,{
	state = 0
	}).

-define(CMD_GS2U_GetWorldServerOpenAwardResult,60281).
-record(pk_GS2U_GetWorldServerOpenAwardResult,{
	errorCode = 0,
	stageReach = 0,
	stageAward = 0
	}).

-define(CMD_U2GS_GetWorldServerOpenRankList,64647).
-record(pk_U2GS_GetWorldServerOpenRankList,{
	}).

-define(CMD_WorldServerOpenRankInfo,47400).
-record(pk_WorldServerOpenRankInfo,{
	rank = 0,
	playerID = 0,
	name = "",
	sex = 0,
	guildName = "",
	battleValue = 0,
	rankValue = 0,
	head_id = 0,
	frame_id = 0
	}).

-define(CMD_GS2U_GetWorldServerOpenRankList,9294).
-record(pk_GS2U_GetWorldServerOpenRankList,{
	rank_list = []
	}).

-define(CMD_guild_cluster,33704).
-record(pk_guild_cluster,{
	server_id = 0,
	guild_id = 0,
	guild_name = "",
	master_id = 0,
	master_sex = 0,
	master_name = "",
	master_bv = 0
	}).

-define(CMD_U2GS_ClusterServerList,45805).
-record(pk_U2GS_ClusterServerList,{
	}).

-define(CMD_GS2U_ClusterServerList,53388).
-record(pk_GS2U_ClusterServerList,{
	serverList = [],
	serverListNext = [],
	timeNext = 0,
	top_guild = []
	}).

-define(CMD_U2GS_Disassemble,52484).
-record(pk_U2GS_Disassemble,{
	bag_id = 0,
	uid = 0,
	deal_bind = false
	}).

-define(CMD_GS2U_DisassembleRet,5987).
-record(pk_GS2U_DisassembleRet,{
	err_code = 0
	}).

-define(CMD_U2GS_RequestAcBossFirstKillInfo,36687).
-record(pk_U2GS_RequestAcBossFirstKillInfo,{
	}).

-define(CMD_ac_boss_first_kill,63980).
-record(pk_ac_boss_first_kill,{
	id = 0,
	names = [],
	map_id = 0,
	boss_id = 0
	}).

-define(CMD_GS2U_RequestAcBossFirstKillInfo,46871).
-record(pk_GS2U_RequestAcBossFirstKillInfo,{
	info = []
	}).

-define(CMD_U2GS_EnterGuildCamp,8959).
-record(pk_U2GS_EnterGuildCamp,{
	}).

-define(CMD_CampInfo,57594).
-record(pk_CampInfo,{
	guild_ratio = 0,
	personal_ratio = 0,
	exp = 0,
	coin = 0,
	treat_point = 0,
	t1 = 0,
	t2 = 0,
	award_mask = 0,
	guild_money = 0,
	guild_t2 = 0,
	double_times = 0
	}).

-define(CMD_CampInfoUpdate,46641).
-record(pk_CampInfoUpdate,{
	index = 0,
	value = 0
	}).

-define(CMD_GS2U_GuildCampInfoSync,42247).
-record(pk_GS2U_GuildCampInfoSync,{
	start_timestamp = 0,
	boss_timestamp = 0,
	end_timestamp = 0,
	info = []
	}).

-define(CMD_GS2U_GuildCampInfoUpdate,596).
-record(pk_GS2U_GuildCampInfoUpdate,{
	updates = []
	}).

-define(CMD_GS2U_GuildCampInfoExpUpdate,48723).
-record(pk_GS2U_GuildCampInfoExpUpdate,{
	exp = 0
	}).

-define(CMD_U2GS_GuildCampDrink,10159).
-record(pk_U2GS_GuildCampDrink,{
	type = 0
	}).

-define(CMD_GS2U_GuildCampDrinkRet,30060).
-record(pk_GS2U_GuildCampDrinkRet,{
	err_code = 0,
	type = 0
	}).

-define(CMD_U2GS_GuildCampGetSatgeAward,58286).
-record(pk_U2GS_GuildCampGetSatgeAward,{
	stage = 0
	}).

-define(CMD_GS2U_GuildCampGetSatgeAwardRet,59172).
-record(pk_GS2U_GuildCampGetSatgeAwardRet,{
	err_code = 0,
	stage = 0
	}).

-define(CMD_U2GS_GuildCampEnterArea,15292).
-record(pk_U2GS_GuildCampEnterArea,{
	}).

-define(CMD_GS2U_GuildCampEnterAreaRet,34125).
-record(pk_GS2U_GuildCampEnterAreaRet,{
	err_code = 0
	}).

-define(CMD_U2GS_GuildCampExitArea,25505).
-record(pk_U2GS_GuildCampExitArea,{
	}).

-define(CMD_GS2U_GuildCampExitAreaRet,1002).
-record(pk_GS2U_GuildCampExitAreaRet,{
	err_code = 0
	}).

-define(CMD_U2GS_DungeonOrnamentInfo,11013).
-record(pk_U2GS_DungeonOrnamentInfo,{
	}).

-define(CMD_dungeonOrnament,48120).
-record(pk_dungeonOrnament,{
	dungeonID = 0,
	star = 0,
	free = 0
	}).

-define(CMD_GS2U_DungeonOrnamentInfo,54687).
-record(pk_GS2U_DungeonOrnamentInfo,{
	maxFightCount = 0,
	fightCount = 0,
	buyFightCountDay = 0,
	dungeon_list = []
	}).

-define(CMD_GS2U_DungeonOrnamentSettleAccounts,5699).
-record(pk_GS2U_DungeonOrnamentSettleAccounts,{
	dungeonType = 0,
	dungeonID = 0,
	isWin = 0,
	exp = 0,
	star = 0,
	coinList = [],
	itemList = [],
	artiIDList = [],
	settleType = 0,
	isConqAward = 0,
	isFirst3X = 0,
	eq_list = []
	}).

-define(CMD_U2GS_enterDungeonOrnament,31278).
-record(pk_U2GS_enterDungeonOrnament,{
	dungeonID = 0
	}).

-define(CMD_U2GS_OrnamentCallBoss,31482).
-record(pk_U2GS_OrnamentCallBoss,{
	}).

-define(CMD_GS2U_OrnamentCallBossRet,18826).
-record(pk_GS2U_OrnamentCallBossRet,{
	err_code = 0
	}).

-define(CMD_U2GS_OrnamentSweep,10913).
-record(pk_U2GS_OrnamentSweep,{
	dungeon_id = 0,
	is_call_boss = false
	}).

-define(CMD_GS2U_OrnamentSweepRet,41484).
-record(pk_GS2U_OrnamentSweepRet,{
	err_code = 0,
	dungeon_id = 0,
	exp = 0,
	coinList = [],
	itemList = [],
	eq_list = []
	}).

-define(CMD_ornament_pos,59135).
-record(pk_ornament_pos,{
	pos = 0,
	uid = 0,
	cast_prop = [],
	cast_prop_temp = [],
	cast_skill = [],
	cast_skill_temp = []
	}).

-define(CMD_GS2U_OrnamentSync,714).
-record(pk_GS2U_OrnamentSync,{
	orn_list = [],
	orn_pos_list = []
	}).

-define(CMD_GS2U_OrnamentUpdate,40928).
-record(pk_GS2U_OrnamentUpdate,{
	orn_list = []
	}).

-define(CMD_GS2U_OrnamentPosUpdate,59709).
-record(pk_GS2U_OrnamentPosUpdate,{
	orn_pos_list = []
	}).

-define(CMD_U2GS_OrnamentInt,27535).
-record(pk_U2GS_OrnamentInt,{
	uid = 0
	}).

-define(CMD_GS2U_OrnamentIntRet,31900).
-record(pk_GS2U_OrnamentIntRet,{
	err_code = 0,
	uid = 0,
	int_lv = 0
	}).

-define(CMD_U2GS_OrnamentBreak,31798).
-record(pk_U2GS_OrnamentBreak,{
	uid = 0
	}).

-define(CMD_GS2U_OrnamentBreakRet,27002).
-record(pk_GS2U_OrnamentBreakRet,{
	err_code = 0,
	orn = #pk_ornament{}
	}).

-define(CMD_U2GS_OrnamentCast,55651).
-record(pk_U2GS_OrnamentCast,{
	pos = 0,
	op = 0
	}).

-define(CMD_GS2U_OrnamentCast,19301).
-record(pk_GS2U_OrnamentCast,{
	err_code = 0,
	pos = 0,
	op = 0,
	orn_pos = #pk_ornament_pos{}
	}).

-define(CMD_U2GS_OrnamentOp,42061).
-record(pk_U2GS_OrnamentOp,{
	op = 0,
	uid = 0
	}).

-define(CMD_GS2U_OrnamentOpRet,57984).
-record(pk_GS2U_OrnamentOpRet,{
	err_code = 0,
	op = 0,
	uid = 0
	}).

-define(CMD_U2GS_OrnamentOneKeyOp,2463).
-record(pk_U2GS_OrnamentOneKeyOp,{
	op = 0,
	uids = []
	}).

-define(CMD_GS2U_OrnamentOneKeyOpRet,26722).
-record(pk_GS2U_OrnamentOneKeyOpRet,{
	err_code = 0,
	op = 0,
	uids = []
	}).

-define(CMD_U2GS_OrnamentFade,17320).
-record(pk_U2GS_OrnamentFade,{
	uids = [],
	is_double = false
	}).

-define(CMD_GS2U_OrnamentFadeRet,15959).
-record(pk_GS2U_OrnamentFadeRet,{
	err_code = 0
	}).

-define(CMD_horcrux,43057).
-record(pk_horcrux,{
	id = 0,
	page = 0,
	point = 0,
	lv = 0
	}).

-define(CMD_horus_skill,59036).
-record(pk_horus_skill,{
	pos = 0,
	horcrux_id = 0,
	skill_id = 0
	}).

-define(CMD_horus,28465).
-record(pk_horus,{
	lv = 0,
	exp = 0,
	pill1 = 0,
	pill2 = 0,
	pill3 = 0,
	skills = []
	}).

-define(CMD_GS2U_HorcruxSync,35756).
-record(pk_GS2U_HorcruxSync,{
	horcrux_list = [],
	horus = #pk_horus{}
	}).

-define(CMD_GS2U_HorcruxUpdate,36804).
-record(pk_GS2U_HorcruxUpdate,{
	horcrux_list = []
	}).

-define(CMD_GS2U_HorusUpdate,30811).
-record(pk_GS2U_HorusUpdate,{
	horus = #pk_horus{}
	}).

-define(CMD_U2GS_HorcruxAddLv,56317).
-record(pk_U2GS_HorcruxAddLv,{
	horcrux_id = 0
	}).

-define(CMD_GS2U_HorcruxAddLvRet,46365).
-record(pk_GS2U_HorcruxAddLvRet,{
	err_code = 0,
	horcrux_id = 0,
	new_lv = 0
	}).

-define(CMD_U2GS_HorcruxPointBreak,40179).
-record(pk_U2GS_HorcruxPointBreak,{
	horcrux_id = 0
	}).

-define(CMD_GS2U_HorcruxPointBreakRet,17069).
-record(pk_GS2U_HorcruxPointBreakRet,{
	err_code = 0,
	horcrux_id = 0,
	new_point = 0
	}).

-define(CMD_U2GS_HorcruxPageBreak,58795).
-record(pk_U2GS_HorcruxPageBreak,{
	horcrux_id = 0
	}).

-define(CMD_GS2U_HorcruxPageBreakRet,36052).
-record(pk_GS2U_HorcruxPageBreakRet,{
	err_code = 0,
	horcrux_id = 0,
	new_page = 0
	}).

-define(CMD_U2GS_HorusAddLv,18174).
-record(pk_U2GS_HorusAddLv,{
	cost_list = []
	}).

-define(CMD_GS2U_HorusAddLvRet,41924).
-record(pk_GS2U_HorusAddLvRet,{
	err_code = 0,
	new_lv = 0,
	new_exp = 0
	}).

-define(CMD_U2GS_HorusPill,11657).
-record(pk_U2GS_HorusPill,{
	index = 0,
	amount = 0
	}).

-define(CMD_GS2U_HorusPillRet,52144).
-record(pk_GS2U_HorusPillRet,{
	err_code = 0,
	pill = 0
	}).

-define(CMD_U2GS_HorusSkillBoxOpen,35206).
-record(pk_U2GS_HorusSkillBoxOpen,{
	pos = 0
	}).

-define(CMD_GS2U_HorusSkillBoxOpenRet,35912).
-record(pk_GS2U_HorusSkillBoxOpenRet,{
	err_code = 0,
	pos = 0
	}).

-define(CMD_U2GS_HorusSkillOp,43685).
-record(pk_U2GS_HorusSkillOp,{
	op = 0,
	pos = 0,
	skill_id = 0,
	horcrux_id = 0
	}).

-define(CMD_GS2U_HorusSkillOpRet,61143).
-record(pk_GS2U_HorusSkillOpRet,{
	err_code = 0,
	op = 0
	}).

-define(CMD_sb_100,20720).
-record(pk_sb_100,{
	title = "",
	desribe = "",
	desribe_big = "",
	pic_list = [],
	banner_upleft = "",
	banner_lowleft = "",
	banner_upright = "",
	banner_lowright = ""
	}).

-define(CMD_sb_200,46955).
-record(pk_sb_200,{
	id = 0,
	text = "",
	award_eq = [],
	award_item = []
	}).

-define(CMD_GS2U_SwitchBaseType100Sync,30434).
-record(pk_GS2U_SwitchBaseType100Sync,{
	list = [],
	list_2 = []
	}).

-define(CMD_U2GS_get_type_200_award,12312).
-record(pk_U2GS_get_type_200_award,{
	id = 0
	}).

-define(CMD_GS2U_get_type_200_award_ret,64740).
-record(pk_GS2U_get_type_200_award_ret,{
	err_code = 0
	}).

-define(CMD_GS2U_EqReplaceNotice,20604).
-record(pk_GS2U_EqReplaceNotice,{
	ret_cost = []
	}).

-define(CMD_manor,20897).
-record(pk_manor,{
	manor_id = 0,
	guild_id = 0,
	server_id = 0,
	guild_name = "",
	battle_value = 0
	}).

-define(CMD_manor_bid,22092).
-record(pk_manor_bid,{
	guild_id = 0,
	guild_name = "",
	server_id = 0,
	head_icon = 0,
	bid_money = 0
	}).

-define(CMD_manor_map,50263).
-record(pk_manor_map,{
	manor_id = 0,
	state = 0,
	start_time = 0,
	end_time = 0
	}).

-define(CMD_manor_guild,50973).
-record(pk_manor_guild,{
	manor_id = 0,
	guild_id = 0,
	server_id = 0,
	guild_name = "",
	battle_value = 0,
	join_count = 0,
	reborn_id = 0,
	pillar_damage = 0,
	score = 0
	}).

-define(CMD_manor_player,54129).
-record(pk_manor_player,{
	player_id = 0,
	player_name = "",
	player_sex = 0,
	battle_value = 0,
	kill_num = 0,
	pillar_damage = 0,
	score = 0
	}).

-define(CMD_manor_pillar,42164).
-record(pk_manor_pillar,{
	pillar_id = 0,
	pillar_uid = 0,
	guild_id = 0,
	on_fire = 0,
	on_defend = 0,
	on_attack = 0
	}).

-define(CMD_mr_guild,48587).
-record(pk_mr_guild,{
	guild_id = 0,
	server_id = 0,
	guild_name = "",
	head_icon = 0,
	score = 0,
	rank = 0
	}).

-define(CMD_mr_player,56071).
-record(pk_mr_player,{
	player_id = 0,
	player_name = "",
	score = 0,
	rank = 0
	}).

-define(CMD_pillar_guild,37501).
-record(pk_pillar_guild,{
	guild_id = 0,
	server_id = 0,
	guild_name = "",
	damage = 0,
	rank = 0
	}).

-define(CMD_guild_rank_ui,49829).
-record(pk_guild_rank_ui,{
	rank = 0,
	ui_info = #pk_playerModelUI{}
	}).

-define(CMD_GS2U_ManorWarAcStateSync,18942).
-record(pk_GS2U_ManorWarAcStateSync,{
	state = 0,
	start_time = 0,
	wait_time = 0,
	next_time = 0,
	end_time = 0
	}).

-define(CMD_U2GS_GetManorWarInfo,12935).
-record(pk_U2GS_GetManorWarInfo,{
	}).

-define(CMD_GS2U_GetManorWarInfoRet,57094).
-record(pk_GS2U_GetManorWarInfoRet,{
	state = 0,
	start_time = 0,
	wait_time = 0,
	next_time = 0,
	end_time = 0,
	manors = [],
	atk_manor_id = 0,
	def_manor_id = 0,
	cluster_world_lv = 0,
	lv2_allow = false,
	last_atk_id = 0,
	last_def_id = 0,
	last_guild_id = 0,
	award_time = 0
	}).

-define(CMD_U2GS_GetManorBidInfo,31137).
-record(pk_U2GS_GetManorBidInfo,{
	manor_id = 0
	}).

-define(CMD_GS2U_GetManorBidInfoRet,14380).
-record(pk_GS2U_GetManorBidInfoRet,{
	manor_id = 0,
	bid_player = 0,
	guild_money = 0,
	deduct_money = 0,
	bids = [],
	has_guild_money = 0
	}).

-define(CMD_U2GS_ManorBid,62357).
-record(pk_U2GS_ManorBid,{
	manor_id = 0,
	guild_money = 0,
	deduct_money = 0
	}).

-define(CMD_GS2U_ManorBidRet,25970).
-record(pk_GS2U_ManorBidRet,{
	err_code = 0,
	manor_id = 0
	}).

-define(CMD_GS2U_ManorBidSync,1364).
-record(pk_GS2U_ManorBidSync,{
	manor_id = 0
	}).

-define(CMD_GS2U_ManorBidNotify,49437).
-record(pk_GS2U_ManorBidNotify,{
	type = 0
	}).

-define(CMD_U2GS_GetManorWarReport,29648).
-record(pk_U2GS_GetManorWarReport,{
	req_id = 0
	}).

-define(CMD_GS2U_GetManorWarReportRet,33298).
-record(pk_GS2U_GetManorWarReportRet,{
	err_code = 0,
	req_id = 0,
	guilds = [],
	players = []
	}).

-define(CMD_U2GS_ChangeManorRebornId,10199).
-record(pk_U2GS_ChangeManorRebornId,{
	manor_id = 0,
	reborn_id = 0
	}).

-define(CMD_GS2U_ChangeManorRebornIdRet,1706).
-record(pk_GS2U_ChangeManorRebornIdRet,{
	err_code = 0,
	manor_id = 0,
	reborn_id = 0
	}).

-define(CMD_GS2U_ChangeManorRebornIdSync,59897).
-record(pk_GS2U_ChangeManorRebornIdSync,{
	reborn_id = 0
	}).

-define(CMD_U2GS_GetManorMapInfo,61227).
-record(pk_U2GS_GetManorMapInfo,{
	manor_ids = []
	}).

-define(CMD_GS2U_GetManorMapInfoRet,20892).
-record(pk_GS2U_GetManorMapInfoRet,{
	manor_list = []
	}).

-define(CMD_U2GS_EnterManorMap,25644).
-record(pk_U2GS_EnterManorMap,{
	manor_id = 0
	}).

-define(CMD_GS2U_ManorInfoSync,63018).
-record(pk_GS2U_ManorInfoSync,{
	manor_id = 0,
	state = 0,
	next_time = 0,
	type = 0,
	pillars = [],
	inspire = [],
	kill_num = 0,
	score = 0,
	reborn_id = 0
	}).

-define(CMD_GS2U_ManorKillSync,48084).
-record(pk_GS2U_ManorKillSync,{
	kill_num = 0
	}).

-define(CMD_GS2U_ManorScoreSync,4725).
-record(pk_GS2U_ManorScoreSync,{
	type = 0,
	score = 0,
	total_score = 0
	}).

-define(CMD_GS2U_ManorPillarUpdate,64031).
-record(pk_GS2U_ManorPillarUpdate,{
	pillars = []
	}).

-define(CMD_GS2U_ManorPillarHurtSync,123).
-record(pk_GS2U_ManorPillarHurtSync,{
	pillar_id = 0,
	guilds = [],
	my_damage = 0
	}).

-define(CMD_U2GS_ManorEnterArea,26936).
-record(pk_U2GS_ManorEnterArea,{
	monster_uid = 0
	}).

-define(CMD_U2GS_ManorExitArea,61698).
-record(pk_U2GS_ManorExitArea,{
	monster_uid = 0
	}).

-define(CMD_GS2U_ManorScoreGuildRankSync,36862).
-record(pk_GS2U_ManorScoreGuildRankSync,{
	ranks = []
	}).

-define(CMD_GS2U_ManorScorePlayerRankSync,21829).
-record(pk_GS2U_ManorScorePlayerRankSync,{
	ranks = [],
	my_score = 0
	}).

-define(CMD_U2GS_ManorInspire,54641).
-record(pk_U2GS_ManorInspire,{
	type = 0
	}).

-define(CMD_GS2U_ManorInspireRet,40984).
-record(pk_GS2U_ManorInspireRet,{
	err_code = 0,
	type = 0
	}).

-define(CMD_GS2U_ManorInspireSync,5313).
-record(pk_GS2U_ManorInspireSync,{
	inspire = []
	}).

-define(CMD_U2GS_ManorSetCallState,12543).
-record(pk_U2GS_ManorSetCallState,{
	pillar_id = 0,
	state = 0
	}).

-define(CMD_GS2U_ManorSetCallStateRet,42358).
-record(pk_GS2U_ManorSetCallStateRet,{
	err_code = 0,
	pillar_id = 0,
	state = 0
	}).

-define(CMD_U2GS_ManorChariots,54607).
-record(pk_U2GS_ManorChariots,{
	chariot_id = 0
	}).

-define(CMD_GS2U_ManorChariotsRet,6424).
-record(pk_GS2U_ManorChariotsRet,{
	err_code = 0,
	chariot_id = 0
	}).

-define(CMD_U2GS_ManorCancelChariots,29462).
-record(pk_U2GS_ManorCancelChariots,{
	}).

-define(CMD_GS2U_ManorCancelChariotsRet,42777).
-record(pk_GS2U_ManorCancelChariotsRet,{
	err_code = 0
	}).

-define(CMD_GS2U_ManorSettleAccount,22100).
-record(pk_GS2U_ManorSettleAccount,{
	manor_id = 0,
	type = 0,
	winner_id = 0,
	guilds = []
	}).

-define(CMD_U2GS_GetManorWarLord,2466).
-record(pk_U2GS_GetManorWarLord,{
	}).

-define(CMD_GS2U_GetManorWarLordRet,50141).
-record(pk_GS2U_GetManorWarLordRet,{
	guild_name = "",
	server_id = 0,
	overloads = []
	}).

-define(CMD_U2GS_ManorGetDailyAward,58571).
-record(pk_U2GS_ManorGetDailyAward,{
	}).

-define(CMD_GS2U_ManorGetDailyAwardRet,28611).
-record(pk_GS2U_ManorGetDailyAwardRet,{
	err_code = 0,
	award_time = 0
	}).

-define(CMD_U2GS_ManorWarChariots,21250).
-record(pk_U2GS_ManorWarChariots,{
	type = 0,
	chariot_id = 0
	}).

-define(CMD_GS2U_ManorWarChariotsRet,3640).
-record(pk_GS2U_ManorWarChariotsRet,{
	err_code = 0,
	type = 0,
	chariot_id = 0
	}).

-define(CMD_U2GS_ManorWarCancelChariots,20657).
-record(pk_U2GS_ManorWarCancelChariots,{
	}).

-define(CMD_GS2U_ManorWarCancelChariotsRet,15498).
-record(pk_GS2U_ManorWarCancelChariotsRet,{
	err_code = 0
	}).

-define(CMD_mb_pillar,49144).
-record(pk_mb_pillar,{
	pillar_id = 0,
	guild_name = "",
	server_name = ""
	}).

-define(CMD_GS2U_ManorPillarSync,50684).
-record(pk_GS2U_ManorPillarSync,{
	pillars = []
	}).

-define(CMD_GS2U_ManorSthDead,56551).
-record(pk_GS2U_ManorSthDead,{
	monster_id = 0,
	map_data_id = 0,
	player_name = "",
	guild_name = "",
	server_name = ""
	}).

-define(CMD_U2GS_ManorWarSetOnFire,23183).
-record(pk_U2GS_ManorWarSetOnFire,{
	monsterID = 0
	}).

-define(CMD_ManorWarObject,56867).
-record(pk_ManorWarObject,{
	monsterID = 0,
	monsterDataID = 0,
	hpPercent = 0,
	onFire = 0,
	guildID = 0,
	group = 0,
	guild_name = "",
	param = 0
	}).

-define(CMD_GS2U_ManorWarObject,20666).
-record(pk_GS2U_ManorWarObject,{
	door_list = [],
	pillar_list = [],
	flag_list = []
	}).

-define(CMD_auction_goods,7804).
-record(pk_auction_goods,{
	goods_id = 0,
	sold = 0,
	bid_num = 0,
	bid_player_id = 0,
	bid_player_name = "",
	bid_server_name = "",
	item_cfg_id = 0,
	item_amount = 0,
	item_bind = 0,
	equipment_list = [],
	currency_key = 0,
	currency_init = 0,
	currency_add = 0,
	currency_buy = 0,
	limit = 0,
	limit_amount = 0
	}).

-define(CMD_auction_goods_update,26440).
-record(pk_auction_goods_update,{
	group_id = 0,
	goods_id = 0,
	sold = 0,
	bid_num = 0,
	bid_player_id = 0,
	bid_player_name = "",
	bid_server_name = "",
	limit_amount = 0,
	player_bonus = []
	}).

-define(CMD_auction_goods_history,55662).
-record(pk_auction_goods_history,{
	sold = 0,
	player_name = "",
	server_name = "",
	item_cfg_id = 0,
	item_amount = 0,
	item_bind = 0,
	equipment_list = [],
	currency_key = 0,
	currency_value = 0,
	time = 0
	}).

-define(CMD_U2GS_auction_group,4371).
-record(pk_U2GS_auction_group,{
	group_id = 0
	}).

-define(CMD_GS2U_auction_group,62070).
-record(pk_GS2U_auction_group,{
	group_id = 0,
	error = 0,
	state = 0,
	open_time = 0,
	close_time = 0,
	goods_list = [],
	player_bid = 0,
	player_bonus = [],
	has_bonus = 0
	}).

-define(CMD_U2GS_auction_group_notify,55393).
-record(pk_U2GS_auction_group_notify,{
	}).

-define(CMD_GS2U_auction_group_notify,28735).
-record(pk_GS2U_auction_group_notify,{
	group_id = 0,
	state = 0,
	open_time = 0,
	close_time = 0
	}).

-define(CMD_U2GS_auction_goods_bid,37326).
-record(pk_U2GS_auction_goods_bid,{
	group_id = 0,
	goods_id = 0,
	new_bid_num = 0
	}).

-define(CMD_GS2U_auction_goods_bid,44909).
-record(pk_GS2U_auction_goods_bid,{
	error = 0,
	goods_update_list = []
	}).

-define(CMD_U2GS_auction_goods_buy,53801).
-record(pk_U2GS_auction_goods_buy,{
	group_id = 0,
	goods_id = 0,
	item_amount = 0
	}).

-define(CMD_GS2U_auction_goods_buy,61384).
-record(pk_GS2U_auction_goods_buy,{
	error = 0,
	goods_update_list = []
	}).

-define(CMD_U2GS_auction_history,11289).
-record(pk_U2GS_auction_history,{
	group_id = 0
	}).

-define(CMD_GS2U_auction_history,12214).
-record(pk_GS2U_auction_history,{
	group_id = 0,
	error = 0,
	goods_history_list = []
	}).

-define(CMD_U2GS_auction_bonus,4458).
-record(pk_U2GS_auction_bonus,{
	group_id = 0
	}).

-define(CMD_GS2U_auction_bonus,62157).
-record(pk_GS2U_auction_bonus,{
	group_id = 0,
	error = 0,
	state = 0,
	total_bonus = [],
	player_bonus = [],
	has_bonus = 0,
	time = 0,
	player_name_list = [],
	tax_rate = 0
	}).

-define(CMD_GS2U_auction_goods_update,60978).
-record(pk_GS2U_auction_goods_update,{
	goods_update_list = []
	}).

-define(CMD_U2GS_GetAcPlayUI,53578).
-record(pk_U2GS_GetAcPlayUI,{
	ac_id = 0,
	q_id = 0
	}).

-define(CMD_ac_play_drop_record,5914).
-record(pk_ac_play_drop_record,{
	timestamp = 0,
	player_name = "",
	item_name = "",
	tp = 0,
	param = 0
	}).

-define(CMD_GS2U_GetAcPlayUIRet,36138).
-record(pk_GS2U_GetAcPlayUIRet,{
	records = []
	}).

-define(CMD_U2GS_AcPlayBuyTimes,37415).
-record(pk_U2GS_AcPlayBuyTimes,{
	ac_id = 0,
	q_id = 0
	}).

-define(CMD_GS2U_AcPlayBuyTimesRet,4800).
-record(pk_GS2U_AcPlayBuyTimesRet,{
	err_code = 0
	}).

-define(CMD_U2GS_AcPlayEnterMap,61902).
-record(pk_U2GS_AcPlayEnterMap,{
	ac_id = 0,
	q_id = 0
	}).

-define(CMD_ac_play_cost,32525).
-record(pk_ac_play_cost,{
	tp = 0,
	cfg_id = 0,
	num = 0
	}).

-define(CMD_GS2U_GetAcMapInfoSync,4952).
-record(pk_GS2U_GetAcMapInfoSync,{
	map_cfg_id = 0,
	time_exp = 0,
	to_next_cost = [],
	vip_lv = 0,
	now_layer = 0,
	total_layer = 0,
	dead_ret_layer = 0,
	total_exp = 0
	}).

-define(CMD_ac_play_boss,49024).
-record(pk_ac_play_boss,{
	index = 0,
	boss_id = 0,
	level = 0,
	x = 0,
	y = 0,
	timestamp = 0
	}).

-define(CMD_GS2U_AcPlayBossListUpdate,36235).
-record(pk_GS2U_AcPlayBossListUpdate,{
	boss_list = []
	}).

-define(CMD_GS2U_GetAcMapExpUpdate,37629).
-record(pk_GS2U_GetAcMapExpUpdate,{
	total_exp = 0
	}).

-define(CMD_U2GS_AcPlayEnterNextLayer,15149).
-record(pk_U2GS_AcPlayEnterNextLayer,{
	ac_id = 0,
	q_id = 0,
	now_layer = 0
	}).

-define(CMD_GS2U_AcPlaySettleAccounts,8260).
-record(pk_GS2U_AcPlaySettleAccounts,{
	exp = 0,
	coin_list = [],
	item_list = [],
	eq_list = []
	}).

-define(CMD_weapon_make,10243).
-record(pk_weapon_make,{
	weapon_id = 0,
	progress = 0,
	free_num = 0,
	recharge_num = 0
	}).

-define(CMD_weapon,14458).
-record(pk_weapon,{
	weapon_id = 0,
	reopen = 0,
	level = 0,
	star = [],
	g_attr_uid = 0
	}).

-define(CMD_ws_skill,9257).
-record(pk_ws_skill,{
	pos = 0,
	weapon_id = 0,
	skill_id = 0
	}).

-define(CMD_weapon_soul,10278).
-record(pk_weapon_soul,{
	role_id = 0,
	level = 0,
	exp = 0,
	skills = []
	}).

-define(CMD_weapon_fetter,46373).
-record(pk_weapon_fetter,{
	id = 0,
	level = 0
	}).

-define(CMD_GS2U_WeaponSync,20922).
-record(pk_GS2U_WeaponSync,{
	wm_list = [],
	w_list = [],
	ws_list = [],
	wf_list = []
	}).

-define(CMD_GS2U_WeaponMakeUpdate,64790).
-record(pk_GS2U_WeaponMakeUpdate,{
	wm_list = []
	}).

-define(CMD_GS2U_WeaponUpdate,33506).
-record(pk_GS2U_WeaponUpdate,{
	w_list = []
	}).

-define(CMD_GS2U_WeaponSoulUpdate,15155).
-record(pk_GS2U_WeaponSoulUpdate,{
	ws_list = []
	}).

-define(CMD_GS2U_WeaponFetterUpdate,3638).
-record(pk_GS2U_WeaponFetterUpdate,{
	wf_list = []
	}).

-define(CMD_GS2U_WeaponRoleUpdate,11262).
-record(pk_GS2U_WeaponRoleUpdate,{
	role_id = 0,
	w_list = []
	}).

-define(CMD_U2GS_WeaponMakeReq,46632).
-record(pk_U2GS_WeaponMakeReq,{
	weapon_id = 0,
	chara = 0
	}).

-define(CMD_GS2U_WeaponMakeRet,50344).
-record(pk_GS2U_WeaponMakeRet,{
	err_code = 0,
	weapon_id = 0,
	chara = 0
	}).

-define(CMD_U2GS_WeaponActiveReq,19736).
-record(pk_U2GS_WeaponActiveReq,{
	weapon_id = 0
	}).

-define(CMD_GS2U_WeaponActiveRet,32212).
-record(pk_GS2U_WeaponActiveRet,{
	err_code = 0,
	weapon_id = 0
	}).

-define(CMD_U2GS_WeaponReopenReq,5288).
-record(pk_U2GS_WeaponReopenReq,{
	weapon_id = 0
	}).

-define(CMD_GS2U_WeaponReopenRet,17764).
-record(pk_GS2U_WeaponReopenRet,{
	err_code = 0,
	weapon_id = 0,
	new_reopen = 0
	}).

-define(CMD_U2GS_WeaponAddLevelReq,2297).
-record(pk_U2GS_WeaponAddLevelReq,{
	weapon_id = 0
	}).

-define(CMD_GS2U_WeaponAddLevelRet,21431).
-record(pk_GS2U_WeaponAddLevelRet,{
	err_code = 0,
	weapon_id = 0,
	new_level = 0
	}).

-define(CMD_U2GS_WeaponAddStarReq,5858).
-record(pk_U2GS_WeaponAddStarReq,{
	weapon_id = 0,
	part_id = 0
	}).

-define(CMD_GS2U_WeaponAddStarRet,48006).
-record(pk_GS2U_WeaponAddStarRet,{
	err_code = 0,
	weapon_id = 0,
	part_id = 0,
	new_star = 0
	}).

-define(CMD_U2GS_WeaponEquipReq,52258).
-record(pk_U2GS_WeaponEquipReq,{
	weapon_id = 0,
	op = 0
	}).

-define(CMD_GS2U_WeaponEquipRet,10923).
-record(pk_GS2U_WeaponEquipRet,{
	err_code = 0,
	weapon_id = 0,
	op = 0
	}).

-define(CMD_U2GS_WeaponSoulAddLevelReq,37065).
-record(pk_U2GS_WeaponSoulAddLevelReq,{
	role_id = 0,
	cost_list = []
	}).

-define(CMD_GS2U_WeaponSoulAddLevelRet,55989).
-record(pk_GS2U_WeaponSoulAddLevelRet,{
	role_id = 0,
	err_code = 0,
	new_level = 0,
	new_exp = 0
	}).

-define(CMD_U2GS_WeaponSoulPillReq,39738).
-record(pk_U2GS_WeaponSoulPillReq,{
	role_id = 0,
	index = 0,
	amount = 0
	}).

-define(CMD_GS2U_WeaponSoulPillRet,58871).
-record(pk_GS2U_WeaponSoulPillRet,{
	role_id = 0,
	err_code = 0,
	pill = 0
	}).

-define(CMD_U2GS_WeaponSoulSkillBoxOpenReq,55200).
-record(pk_U2GS_WeaponSoulSkillBoxOpenReq,{
	role_id = 0,
	pos = 0
	}).

-define(CMD_GS2U_WeaponSoulSkillBoxOpenRet,59203).
-record(pk_GS2U_WeaponSoulSkillBoxOpenRet,{
	role_id = 0,
	err_code = 0,
	pos = 0
	}).

-define(CMD_U2GS_WeaponSoulSkillOpReq,47401).
-record(pk_U2GS_WeaponSoulSkillOpReq,{
	role_id = 0,
	op = 0,
	pos = 0,
	skill_id = 0,
	weapon_id = 0
	}).

-define(CMD_GS2U_WeaponSoulSkillOpRet,32292).
-record(pk_GS2U_WeaponSoulSkillOpRet,{
	role_id = 0,
	err_code = 0,
	op = 0
	}).

-define(CMD_U2GS_WeaponShow,26245).
-record(pk_U2GS_WeaponShow,{
	role_id = 0,
	is_show = 0
	}).

-define(CMD_GS2U_WeaponShowRet,36523).
-record(pk_GS2U_WeaponShowRet,{
	role_id = 0,
	is_show = 0,
	err_code = 0
	}).

-define(CMD_U2GS_WeaponActiveFetter,57199).
-record(pk_U2GS_WeaponActiveFetter,{
	id = 0,
	level = 0
	}).

-define(CMD_GS2U_WeaponActiveFetterRet,30115).
-record(pk_GS2U_WeaponActiveFetterRet,{
	err_code = 0,
	id = 0,
	level = 0
	}).

-define(CMD_g_attr,9489).
-record(pk_g_attr,{
	uid = 0,
	gid = 0,
	cond_list = [],
	attr_list = []
	}).

-define(CMD_GS2U_GrowthAttrSync,18259).
-record(pk_GS2U_GrowthAttrSync,{
	g_attr_list = []
	}).

-define(CMD_GS2U_GrowthAttrUpdate,51107).
-record(pk_GS2U_GrowthAttrUpdate,{
	g_attr_list = []
	}).

-define(CMD_GS2U_PlayerSkillCdChange,52860).
-record(pk_GS2U_PlayerSkillCdChange,{
	role_id = 0,
	index = 0,
	change_cd = 0
	}).

-define(CMD_GS2U_DamageShieldValue,24479).
-record(pk_GS2U_DamageShieldValue,{
	damage = #pk_Object_Damage{}
	}).

-define(CMD_U2GS_ShareReward,45271).
-record(pk_U2GS_ShareReward,{
	type = 0
	}).

-define(CMD_GS2U_ShareReward,547).
-record(pk_GS2U_ShareReward,{
	type = 0,
	errorCode = 0
	}).

-define(CMD_U2GS_SetGuildLine,17588).
-record(pk_U2GS_SetGuildLine,{
	line = ""
	}).

-define(CMD_GS2U_SetGuildLineRet,12260).
-record(pk_GS2U_SetGuildLineRet,{
	err_code = 0
	}).

-define(CMD_U2GS_GetGuildLine,1005).
-record(pk_U2GS_GetGuildLine,{
	}).

-define(CMD_GS2U_GetGuildLineRet,24826).
-record(pk_GS2U_GetGuildLineRet,{
	line = ""
	}).

-define(CMD_DemonHunterUIParam,44161).
-record(pk_DemonHunterUIParam,{
	server_name = "",
	name = "",
	sex = 0,
	param = 0
	}).

-define(CMD_U2GS_GetDemonHunterUI,43941).
-record(pk_U2GS_GetDemonHunterUI,{
	}).

-define(CMD_GS2U_GetDemonHunterUIRet,17668).
-record(pk_GS2U_GetDemonHunterUIRet,{
	my_rank = 0,
	my_score = 0,
	guild_rank = 0,
	guild_score = 0,
	personal_top3 = [],
	guild_top3 = []
	}).

-define(CMD_U2GS_PraiseReward,2301).
-record(pk_U2GS_PraiseReward,{
	type = 0,
	operation = 0
	}).

-define(CMD_GS2U_PraiseReward,31487).
-record(pk_GS2U_PraiseReward,{
	type = 0,
	operation = 0,
	err_code = 0
	}).

-define(CMD_GS2U_PraiseRewardInfoRet,3443).
-record(pk_GS2U_PraiseRewardInfoRet,{
	goodGift1 = 0,
	goodGift2 = 0,
	goodGift3 = 0,
	goodGift4 = 0
	}).

-define(CMD_GameplayJoinHistory,27500).
-record(pk_GameplayJoinHistory,{
	func_id = 0,
	order = 0,
	end_time = 0
	}).

-define(CMD_GS2U_GameplayJoinHistoryAll,42599).
-record(pk_GS2U_GameplayJoinHistoryAll,{
	history = []
	}).

-define(CMD_GS2U_GameplayJoinHistoryUpdate,62494).
-record(pk_GS2U_GameplayJoinHistoryUpdate,{
	history = []
	}).

-define(CMD_DailyAward,56076).
-record(pk_DailyAward,{
	day = 0,
	currencyList = [],
	itemList = []
	}).

-define(CMD_DirectBuyFund,58568).
-record(pk_DirectBuyFund,{
	group_id = 0,
	buy_id = 0,
	name = "",
	type_group = 0,
	rebate = 0,
	state = 0,
	awardDay = 0,
	openActionID = 0,
	dailyAwardList = []
	}).

-define(CMD_GS2U_DirectBuyFundInfoRet,16848).
-record(pk_GS2U_DirectBuyFundInfoRet,{
	infoList = []
	}).

-define(CMD_U2GS_DirectBuyFundDailyAward,47557).
-record(pk_U2GS_DirectBuyFundDailyAward,{
	group_id = 0,
	buy_id = 0,
	day = 0
	}).

-define(CMD_GS2U_DirectBuyFundUpdateInfo,9739).
-record(pk_GS2U_DirectBuyFundUpdateInfo,{
	info = #pk_DirectBuyFund{}
	}).

-define(CMD_GS2U_DirectBuyFundDailyAwardRet,15578).
-record(pk_GS2U_DirectBuyFundDailyAwardRet,{
	err_code = 0,
	info = #pk_DirectBuyFund{}
	}).

-define(CMD_U2GS_DirectBuyFundDailyAwardOneKey,39020).
-record(pk_U2GS_DirectBuyFundDailyAwardOneKey,{
	}).

-define(CMD_GS2U_DirectBuyFundDailyAwardOneKeyRet,13309).
-record(pk_GS2U_DirectBuyFundDailyAwardOneKeyRet,{
	err_code = 0,
	infoList = []
	}).

-define(CMD_U2GS_AccountBindingAward,39606).
-record(pk_U2GS_AccountBindingAward,{
	}).

-define(CMD_GS2U_AccountBindingAwardRet,58336).
-record(pk_GS2U_AccountBindingAwardRet,{
	err_code = 0
	}).

-define(CMD_U2GS_ChatTranslate,53763).
-record(pk_U2GS_ChatTranslate,{
	requestID = 0,
	requestText = ""
	}).

-define(CMD_GS2U_ChatTranslate,45926).
-record(pk_GS2U_ChatTranslate,{
	errorCode = 0,
	requestID = 0,
	translatedText = ""
	}).

-define(CMD_U2GS_ModifyNationality,13994).
-record(pk_U2GS_ModifyNationality,{
	nationality_id = 0
	}).

-define(CMD_GS2U_ModifyNationalityRet,43505).
-record(pk_GS2U_ModifyNationalityRet,{
	err_code = 0
	}).

-define(CMD_UpdatePushData,4083).
-record(pk_UpdatePushData,{
	id = 0,
	param1 = 0,
	param2 = 0,
	param3 = 0
	}).

-define(CMD_U2GS_UpdatePushShedule,13096).
-record(pk_U2GS_UpdatePushShedule,{
	info = #pk_UpdatePushData{}
	}).

-define(CMD_GS2U_PushShedule,15180).
-record(pk_GS2U_PushShedule,{
	infoList = []
	}).

-define(CMD_U2GS_e_download_award,36844).
-record(pk_U2GS_e_download_award,{
	}).

-define(CMD_GS2U_e_download_award_ret,9037).
-record(pk_GS2U_e_download_award_ret,{
	err_code = 0
	}).

-define(CMD_DemonJoinNum,21594).
-record(pk_DemonJoinNum,{
	type = 0,
	zday_num = 0,
	qday_num = 0
	}).

-define(CMD_GS2U_DemonJoinNumPush,41096).
-record(pk_GS2U_DemonJoinNumPush,{
	infoList = []
	}).

-define(CMD_U2GS_HelperBuy,38756).
-record(pk_U2GS_HelperBuy,{
	}).

-define(CMD_GS2U_HelperBuyRet,27964).
-record(pk_GS2U_HelperBuyRet,{
	err_code = 0
	}).

-define(CMD_U2GS_HelperMopUp,43800).
-record(pk_U2GS_HelperMopUp,{
	type = 0,
	dungeonID = 0,
	mode = 0,
	times = 0,
	callBossNum = 0
	}).

-define(CMD_GS2U_HelperMopUpRet,28738).
-record(pk_GS2U_HelperMopUpRet,{
	err_code = 0,
	dungeonID = 0,
	exp = 0,
	times = 0,
	coinList = [],
	itemList = [],
	eq_list = [],
	double_times = 0
	}).

-define(CMD_U2GS_HelperDailyAward,11890).
-record(pk_U2GS_HelperDailyAward,{
	}).

-define(CMD_GS2U_HelperDailyAwardRet,62526).
-record(pk_GS2U_HelperDailyAwardRet,{
	errorCode = 0
	}).

-define(CMD_U2GS_OneKeyMopUp,42097).
-record(pk_U2GS_OneKeyMopUp,{
	type = 0,
	dungeonID = 0,
	times = 0,
	callBossNum = 0
	}).

-define(CMD_AIHostSettingInfo,19538).
-record(pk_AIHostSettingInfo,{
	hostid = 0,
	setting_int = [],
	setting_bool = []
	}).

-define(CMD_U2GS_UpdateAIHostSetting,45671).
-record(pk_U2GS_UpdateAIHostSetting,{
	setting = []
	}).

-define(CMD_U2GS_SaveAIHostSetting,31675).
-record(pk_U2GS_SaveAIHostSetting,{
	setting = []
	}).

-define(CMD_GS2U_SaveAIHostSetting,39258).
-record(pk_GS2U_SaveAIHostSetting,{
	setting = []
	}).

-define(CMD_dragon_city_border,23697).
-record(pk_dragon_city_border,{
	server_id = 0,
	server_name = ""
	}).

-define(CMD_U2GS_dragon_city_info,46661).
-record(pk_U2GS_dragon_city_info,{
	}).

-define(CMD_GS2U_dragon_city_info,11723).
-record(pk_GS2U_dragon_city_info,{
	error_code = 0,
	border_list = []
	}).

-define(CMD_U2GS_dragon_city_enter,7227).
-record(pk_U2GS_dragon_city_enter,{
	}).

-define(CMD_U2GS_dragon_city_border_enter,42008).
-record(pk_U2GS_dragon_city_border_enter,{
	server_id = 0,
	index = 0
	}).

-define(CMD_dragon_city_statue,25076).
-record(pk_dragon_city_statue,{
	manor_id = 0,
	manor_level = 0,
	server_id = 0,
	server_name = "",
	guild_id = 0,
	guild_name = "",
	chairman_id = 0,
	chairman_ui = #pk_LookInfoPlayer4UI{},
	title_id = 0,
	mount_id = 0,
	guard_id = 0,
	up_num = 0,
	down_num = 0
	}).

-define(CMD_dragon_city_statue_history,41314).
-record(pk_dragon_city_statue_history,{
	time = 0,
	server_id = 0,
	server_name = "",
	guild_id = 0,
	guild_name = "",
	chairman_id = 0,
	chairman_ui = #pk_LookInfoPlayer4UI{},
	title_id = 0,
	mount_id = 0,
	guard_id = 0
	}).

-define(CMD_U2GS_dragon_city_statue_info,3655).
-record(pk_U2GS_dragon_city_statue_info,{
	}).

-define(CMD_GS2U_dragon_city_statue_info,12408).
-record(pk_GS2U_dragon_city_statue_info,{
	error_code = 0,
	statue_list = []
	}).

-define(CMD_U2GS_dragon_city_statue_history_info,2564).
-record(pk_U2GS_dragon_city_statue_history_info,{
	}).

-define(CMD_GS2U_dragon_city_statue_history_info,4398).
-record(pk_GS2U_dragon_city_statue_history_info,{
	error_code = 0,
	history_list = []
	}).

-define(CMD_U2GS_dragon_city_updown,8982).
-record(pk_U2GS_dragon_city_updown,{
	manor_id = 0,
	is_up = false,
	text_id = 0
	}).

-define(CMD_GS2U_dragon_city_updown,1171).
-record(pk_GS2U_dragon_city_updown,{
	manor_id = 0,
	error_code = 0,
	up_num = 0,
	down_num = 0
	}).

-define(CMD_dragon_city_text,10577).
-record(pk_dragon_city_text,{
	index = 0,
	server_id = 0,
	server_name = "",
	player_id = 0,
	player_name = "",
	is_up = false,
	text_id = 0,
	time = 0
	}).

-define(CMD_U2GS_dragon_city_text_info,9442).
-record(pk_U2GS_dragon_city_text_info,{
	manor_id = 0,
	last_index = 0
	}).

-define(CMD_GS2U_dragon_city_text_info,16815).
-record(pk_GS2U_dragon_city_text_info,{
	manor_id = 0,
	error_code = 0,
	text_list = []
	}).

-define(CMD_GS2U_player_enter_server_id,33243).
-record(pk_GS2U_player_enter_server_id,{
	server_id = 0,
	is_union = 0
	}).

-define(CMD_server_info,13936).
-record(pk_server_info,{
	server_name = "",
	server_id = 0,
	score = 0,
	rank = 0,
	buffIDList = [],
	is_union = 0,
	union_server_id = 0
	}).

-define(CMD_war_event,14693).
-record(pk_war_event,{
	timestamp = 0,
	text = ""
	}).

-define(CMD_GS2U_BorderBossRankSync,5887).
-record(pk_GS2U_BorderBossRankSync,{
	damage = 0,
	rank = 0,
	rank_list = []
	}).

-define(CMD_U2GS_border_war_req_info,21079).
-record(pk_U2GS_border_war_req_info,{
	}).

-define(CMD_GS2U_border_war_info_ret,63350).
-record(pk_GS2U_border_war_info_ret,{
	serverInfo = [],
	alive_boss = [],
	big_event = []
	}).

-define(CMD_GS2U_border_war_season_info,23567).
-record(pk_GS2U_border_war_season_info,{
	season = 0,
	season_start_time = 0,
	season_end_time = 0,
	world_lv = 0,
	weekly_season = 0,
	type = 0,
	bp_fix_rate = 0
	}).

-define(CMD_border_war_bp,20010).
-record(pk_border_war_bp,{
	type = 0,
	is_high = 0,
	has_award = [],
	has_high_award = []
	}).

-define(CMD_U2GS_border_war_bp_info_req,22126).
-record(pk_U2GS_border_war_bp_info_req,{
	}).

-define(CMD_GS2U_border_war_bp_info,63369).
-record(pk_GS2U_border_war_bp_info,{
	honorLv = 0,
	honorExp = 0,
	conquerLv = 0,
	conquerExp = 0,
	info = [],
	next_week_reset_time = 0
	}).

-define(CMD_U2GS_border_war_bp_award,50641).
-record(pk_U2GS_border_war_bp_award,{
	type = 0,
	score = 0
	}).

-define(CMD_GS2U_border_war_bp_award_ret,5978).
-record(pk_GS2U_border_war_bp_award_ret,{
	type = 0,
	err_code = 0
	}).

-define(CMD_U2GS_border_war_bp_score_buy,30887).
-record(pk_U2GS_border_war_bp_score_buy,{
	type = 0,
	times = 0
	}).

-define(CMD_GS2U_border_war_bp_score_buy_ret,8588).
-record(pk_GS2U_border_war_bp_score_buy_ret,{
	type = 0,
	times = 0,
	lv = 0,
	exp = 0,
	err_code = 0
	}).

-define(CMD_U2GS_border_war_bp_add_lv,3347).
-record(pk_U2GS_border_war_bp_add_lv,{
	type = 0
	}).

-define(CMD_GS2U_border_war_bp_add_lv_ret,30768).
-record(pk_GS2U_border_war_bp_add_lv_ret,{
	type = 0,
	err_code = 0,
	lv = 0,
	exp = 0
	}).

-define(CMD_border_war_bp_task_info,49568).
-record(pk_border_war_bp_task_info,{
	id = 0,
	progress = 0
	}).

-define(CMD_GS2U_border_war_bp_send_task_info,53616).
-record(pk_GS2U_border_war_bp_send_task_info,{
	task_info_list = [],
	already_awarded_id = []
	}).

-define(CMD_GS2U_border_war_bp_conquer_exp_update,19198).
-record(pk_GS2U_border_war_bp_conquer_exp_update,{
	lv = 0,
	exp = 0,
	awarded_id = [],
	task_info_list = []
	}).

-define(CMD_GS2U_border_war_bp_task_reset,33458).
-record(pk_GS2U_border_war_bp_task_reset,{
	}).

-define(CMD_GS2U_SyncBorderWarCurse,58067).
-record(pk_GS2U_SyncBorderWarCurse,{
	value = 0
	}).

-define(CMD_inviteUnionListInfo,27154).
-record(pk_inviteUnionListInfo,{
	serverName = "",
	server_id = 0,
	rank = 0,
	playerName = ""
	}).

-define(CMD_GS2U_InviteUnionList,56067).
-record(pk_GS2U_InviteUnionList,{
	info_list = []
	}).

-define(CMD_U2GS_RequesetUnion,19109).
-record(pk_U2GS_RequesetUnion,{
	server_id = 0
	}).

-define(CMD_GS2U_RequesetUnionRet,62179).
-record(pk_GS2U_RequesetUnionRet,{
	err_code = 0
	}).

-define(CMD_U2GS_InviteUnionReply,42688).
-record(pk_U2GS_InviteUnionReply,{
	server_id = 0,
	reply = 0
	}).

-define(CMD_GS2U_InviteUnionReplyRet,3517).
-record(pk_GS2U_InviteUnionReplyRet,{
	err_code = 0
	}).

-define(CMD_U2GS_GetServerRankAward,49867).
-record(pk_U2GS_GetServerRankAward,{
	}).

-define(CMD_GS2U_GetServerRankAwardRet,26377).
-record(pk_GS2U_GetServerRankAwardRet,{
	err_code = 0
	}).

-define(CMD_bossSummaryInfo,11613).
-record(pk_bossSummaryInfo,{
	boss_id = 0,
	boss_level = 0,
	is_alive = 0
	}).

-define(CMD_serverBossSummaryInfo,60090).
-record(pk_serverBossSummaryInfo,{
	serverName = "",
	server_id = 0,
	relation = 0,
	info_list = []
	}).

-define(CMD_U2GS_ServerBossSummaryInfo,13405).
-record(pk_U2GS_ServerBossSummaryInfo,{
	}).

-define(CMD_GS2U_ServerBossSummaryInfoRet,28396).
-record(pk_GS2U_ServerBossSummaryInfoRet,{
	info_list = []
	}).

-define(CMD_borderServerReport,21103).
-record(pk_borderServerReport,{
	server_id = 0,
	serverName = "",
	rank = 0,
	relation = 0,
	total_score = 0,
	change_score = 0,
	kill_num = 0,
	boss_kill = []
	}).

-define(CMD_borderPlayerReport,27861).
-record(pk_borderPlayerReport,{
	rank = 0,
	serverName = "",
	playerName = "",
	sex = 0,
	param = 0
	}).

-define(CMD_GS2U_BorderWarReport,35321).
-record(pk_GS2U_BorderWarReport,{
	server_rank_info = [],
	score_rank_info = [],
	kill_rank_info = []
	}).

-define(CMD_U2GS_BorderConveneReq,10861).
-record(pk_U2GS_BorderConveneReq,{
	map_data_id = 0,
	posX = 0,
	posY = 0
	}).

-define(CMD_GS2U_BorderConveneRet,53009).
-record(pk_GS2U_BorderConveneRet,{
	err_code = 0
	}).

-define(CMD_GS2U_BorderConveneNotice,10974).
-record(pk_GS2U_BorderConveneNotice,{
	server_id = 0,
	name = "",
	military_rank = 0,
	map_data_id = 0,
	posX = 0,
	posY = 0
	}).

-define(CMD_U2GS_BorderWarBossKillMsgReq,65083).
-record(pk_U2GS_BorderWarBossKillMsgReq,{
	server_id = 0,
	boss_id = 0
	}).

-define(CMD_GS2U_BorderWarBossKillMsgRet,19851).
-record(pk_GS2U_BorderWarBossKillMsgRet,{
	kill_msg = []
	}).

-define(CMD_dragon_city_border_more,48834).
-record(pk_dragon_city_border_more,{
	server_id = 0,
	group_id = 0,
	local_person_num = 0,
	guild_member_num = 0
	}).

-define(CMD_GS2U_dragon_city_info_more,43652).
-record(pk_GS2U_dragon_city_info_more,{
	error_code = 0,
	more_list = []
	}).

-define(CMD_U2GS_GetDemonsBorderUI,46407).
-record(pk_U2GS_GetDemonsBorderUI,{
	}).

-define(CMD_GS2U_GetDemonsBorderUIRet,31376).
-record(pk_GS2U_GetDemonsBorderUIRet,{
	start_time = 0,
	end_time = 0,
	score = 0
	}).

-define(CMD_GS2U_DemonsBorderState,59732).
-record(pk_GS2U_DemonsBorderState,{
	state = 0,
	start_time = 0
	}).

-define(CMD_U2GS_EnterDemonsBorder,3165).
-record(pk_U2GS_EnterDemonsBorder,{
	}).

-define(CMD_U2GS_ExitDemonsBorder,46320).
-record(pk_U2GS_ExitDemonsBorder,{
	}).

-define(CMD_DemonsBorderBoss,64374).
-record(pk_DemonsBorderBoss,{
	boss_id = 0,
	level = 0,
	x = 0,
	y = 0,
	is_born = false,
	revive_time = 0
	}).

-define(CMD_GS2U_DemonsBorderBossListSync,56092).
-record(pk_GS2U_DemonsBorderBossListSync,{
	boss_list = []
	}).

-define(CMD_GS2U_BorderWarBossListSync,28903).
-record(pk_GS2U_BorderWarBossListSync,{
	boss_list = []
	}).

-define(CMD_GS2U_DemonsBorderBossListUpdate,42697).
-record(pk_GS2U_DemonsBorderBossListUpdate,{
	boss_list = []
	}).

-define(CMD_GS2U_DemonsBorderRankSync,57144).
-record(pk_GS2U_DemonsBorderRankSync,{
	damage = 0,
	rank = 0,
	rank_list = []
	}).

-define(CMD_GS2U_DemonsBorderSettleAccounts,14722).
-record(pk_GS2U_DemonsBorderSettleAccounts,{
	multiple = 0,
	coin_list = [],
	item_list = [],
	eq_list = []
	}).

-define(CMD_ChancelInfo,14151).
-record(pk_ChancelInfo,{
	map_data_id = 0,
	server_id = 0,
	state = 0,
	start_time = 0,
	end_time = 0
	}).

-define(CMD_HolyWarBoss,31383).
-record(pk_HolyWarBoss,{
	map_data_id = 0,
	boss_id = 0,
	level = 0,
	dead_time = 0,
	revive_time = 0,
	is_attention = false
	}).

-define(CMD_HolyWarBox,45540).
-record(pk_HolyWarBox,{
	map_data_id = 0,
	box_id = 0,
	left_num = 0,
	refresh_time = 0
	}).

-define(CMD_U2GS_GetHolyWarUI,52931).
-record(pk_U2GS_GetHolyWarUI,{
	}).

-define(CMD_GS2U_GetHolyWarUIRet,16660).
-record(pk_GS2U_GetHolyWarUIRet,{
	chancel_list = [],
	boss_list = [],
	box_list = [],
	attentions = [],
	times = 0,
	curse = 0
	}).

-define(CMD_U2GS_EnterHolyWar,14325).
-record(pk_U2GS_EnterHolyWar,{
	map_data_id = 0
	}).

-define(CMD_U2GS_HolyWarTransLayer,61786).
-record(pk_U2GS_HolyWarTransLayer,{
	map_data_id = 0,
	index = 0
	}).

-define(CMD_GS2U_HolyWarLimitSync,48925).
-record(pk_GS2U_HolyWarLimitSync,{
	times = 0,
	curse = 0
	}).

-define(CMD_GS2U_HolyWarInfoSync,39676).
-record(pk_GS2U_HolyWarInfoSync,{
	boss_list = [],
	box_list = [],
	chancel_list = []
	}).

-define(CMD_GS2U_HolyWarInfoUpdate,2540).
-record(pk_GS2U_HolyWarInfoUpdate,{
	boss_list = [],
	box_list = [],
	chancel_list = []
	}).

-define(CMD_GS2U_HolyWarRankSync,5029).
-record(pk_GS2U_HolyWarRankSync,{
	damage = 0,
	rank = 0,
	rank_list = []
	}).

-define(CMD_U2GS_one_click_transfer,13244).
-record(pk_U2GS_one_click_transfer,{
	type = 0
	}).

-define(CMD_GS2U_one_click_transfer_ret,19304).
-record(pk_GS2U_one_click_transfer_ret,{
	err_code = 0
	}).

-define(CMD_holy_shield_skill,11763).
-record(pk_holy_shield_skill,{
	skill_id = 0,
	level = 0
	}).

-define(CMD_GS2U_HolyShieldInfo,25715).
-record(pk_GS2U_HolyShieldInfo,{
	level = 0,
	level_exp = 0,
	break = 0,
	stage = 0,
	stage_exp = 0,
	click_attr = [],
	skill_list = []
	}).

-define(CMD_U2GS_HolyShieldUpLevel,26402).
-record(pk_U2GS_HolyShieldUpLevel,{
	cost_list = []
	}).

-define(CMD_GS2U_HolyShieldUpLevelRet,32142).
-record(pk_GS2U_HolyShieldUpLevelRet,{
	error_code = 0
	}).

-define(CMD_U2GS_HolyShieldLvBreak,55302).
-record(pk_U2GS_HolyShieldLvBreak,{
	}).

-define(CMD_GS2U_HolyShieldLvBreakRet,32834).
-record(pk_GS2U_HolyShieldLvBreakRet,{
	error_code = 0
	}).

-define(CMD_U2GS_HolyShieldUpStage,18724).
-record(pk_U2GS_HolyShieldUpStage,{
	is_use_currency = 0
	}).

-define(CMD_GS2U_HolyShieldUpStageRet,9743).
-record(pk_GS2U_HolyShieldUpStageRet,{
	error_code = 0
	}).

-define(CMD_U2GS_HolyShieldUpSkillLevel,43323).
-record(pk_U2GS_HolyShieldUpSkillLevel,{
	skill_id = 0
	}).

-define(CMD_GS2U_HolyShieldUpSkillLevelRet,49119).
-record(pk_GS2U_HolyShieldUpSkillLevelRet,{
	error_code = 0
	}).

-define(CMD_U2GS_HolyShieldDecompose,63077).
-record(pk_U2GS_HolyShieldDecompose,{
	cost_list = []
	}).

-define(CMD_GS2U_HolyShieldDecomposelRet,63521).
-record(pk_GS2U_HolyShieldDecomposelRet,{
	error_code = 0
	}).

-define(CMD_U2GS_GetAbyssFightUI,62026).
-record(pk_U2GS_GetAbyssFightUI,{
	}).

-define(CMD_GS2U_GetAbyssFightUIRet,28032).
-record(pk_GS2U_GetAbyssFightUIRet,{
	ac_start_timestamp = 0,
	ac_end_timestamp = 0,
	my_rank = 0,
	my_time = 0,
	my_grade = 0,
	join_time = 0
	}).

-define(CMD_U2GS_GetAFRoomList,40352).
-record(pk_U2GS_GetAFRoomList,{
	}).

-define(CMD_af_room,57004).
-record(pk_af_room,{
	room_id = 0,
	player_name = "",
	server_name = "",
	player_lv = 0,
	headid = 0,
	head_frame = 0,
	career = 0,
	now_members = 0,
	min_lv = 0,
	max_lv = 0,
	min_battle_value = 0
	}).

-define(CMD_GS2U_GetAFRoomList,32515).
-record(pk_GS2U_GetAFRoomList,{
	rooms = []
	}).

-define(CMD_U2GS_AFCreateRoom,27638).
-record(pk_U2GS_AFCreateRoom,{
	}).

-define(CMD_GS2U_AFCreateRoomRet,43895).
-record(pk_GS2U_AFCreateRoomRet,{
	err_code = 0
	}).

-define(CMD_U2GS_GetAFRoomDetail,39741).
-record(pk_U2GS_GetAFRoomDetail,{
	}).

-define(CMD_af_room_player,8033).
-record(pk_af_room_player,{
	player_id = 0,
	join_time = 0,
	ui_info = #pk_LookInfoPlayer4UI{},
	state = 0
	}).

-define(CMD_GS2U_AFRoomDetail,57695).
-record(pk_GS2U_AFRoomDetail,{
	min_lv = 0,
	max_lv = 0,
	min_battle_value = 0,
	room_id = 0,
	members = []
	}).

-define(CMD_GS2U_AFRoomPlayerUpdate,65149).
-record(pk_GS2U_AFRoomPlayerUpdate,{
	member = #pk_af_room_player{}
	}).

-define(CMD_U2GS_AFRoomSet,21446).
-record(pk_U2GS_AFRoomSet,{
	min_lv = 0,
	max_lv = 0,
	min_battle_value = 0
	}).

-define(CMD_GS2U_AFRoomSetRet,48884).
-record(pk_GS2U_AFRoomSetRet,{
	err_code = 0
	}).

-define(CMD_GS2U_AFRoomSetSync,9156).
-record(pk_GS2U_AFRoomSetSync,{
	min_lv = 0,
	max_lv = 0,
	min_battle_value = 0
	}).

-define(CMD_U2GS_AFRoomOp,4313).
-record(pk_U2GS_AFRoomOp,{
	op = 0,
	room_id = 0
	}).

-define(CMD_GS2U_AFRoomOpRet,35372).
-record(pk_GS2U_AFRoomOpRet,{
	op = 0,
	err_code = 0
	}).

-define(CMD_U2GS_AFRoomOwnerOp,54405).
-record(pk_U2GS_AFRoomOwnerOp,{
	op = 0,
	player_id = 0
	}).

-define(CMD_GS2U_AFRoomOwnerOpRet,14238).
-record(pk_GS2U_AFRoomOwnerOpRet,{
	op = 0,
	player_id = 0,
	err_code = 0
	}).

-define(CMD_U2GS_AFInviteHandle,45151).
-record(pk_U2GS_AFInviteHandle,{
	room_id = 0,
	op = 0
	}).

-define(CMD_GS2U_AFInviteHandleRet,32400).
-record(pk_GS2U_AFInviteHandleRet,{
	err_code = 0,
	op = 0,
	name = ""
	}).

-define(CMD_U2GS_AFRoomMemberOp,52219).
-record(pk_U2GS_AFRoomMemberOp,{
	op = 0
	}).

-define(CMD_GS2U_AFRoomMemberOpRet,1537).
-record(pk_GS2U_AFRoomMemberOpRet,{
	op = 0,
	err_code = 0
	}).

-define(CMD_GS2U_AFRoomMemberInfoSync,60301).
-record(pk_GS2U_AFRoomMemberInfoSync,{
	tp = 0,
	player_id = 0
	}).

-define(CMD_U2GS_AFGetRoomInvateList,9461).
-record(pk_U2GS_AFGetRoomInvateList,{
	}).

-define(CMD_U2GS_AFExitMap,56294).
-record(pk_U2GS_AFExitMap,{
	}).

-define(CMD_af_rank,36910).
-record(pk_af_rank,{
	player_name = "",
	server_name = "",
	rank = 0,
	damage = 0
	}).

-define(CMD_GS2U_AFSettleAccounts,219).
-record(pk_GS2U_AFSettleAccounts,{
	is_win = 0,
	my_time = 0,
	my_grade = 0,
	is_best = 0,
	my_rank = 0,
	rank_list = [],
	exp = 0,
	coin_list = [],
	item_list = [],
	eq_list = []
	}).

-define(CMD_U2GS_AFOpenBox,39150).
-record(pk_U2GS_AFOpenBox,{
	op = 0,
	box_id = 0
	}).

-define(CMD_GS2U_AFOpenBoxRet,22500).
-record(pk_GS2U_AFOpenBoxRet,{
	op = 0,
	box_id = 0,
	err_code = 0
	}).

-define(CMD_constellation_star_soul,7021).
-record(pk_constellation_star_soul,{
	position = 0,
	equipment_id = 0,
	level = 0,
	awaken_lv = 0,
	bless_lv = 0,
	bless_pro_lv = 0
	}).

-define(CMD_constellation_guard,41166).
-record(pk_constellation_guard,{
	position = 0,
	guard_id = 0
	}).

-define(CMD_constellation_skill,51880).
-record(pk_constellation_skill,{
	position = 0,
	id = 0,
	skill_id = 0
	}).

-define(CMD_constellation_gem,27997).
-record(pk_constellation_gem,{
	position = 0,
	uid = 0,
	cfg_id = 0
	}).

-define(CMD_constellation_gem_skill,47925).
-record(pk_constellation_gem_skill,{
	skill_id = 0,
	skill_level = 0,
	state = 0
	}).

-define(CMD_constellation_info,17888).
-record(pk_constellation_info,{
	id = 0,
	star = 0,
	star_soul = [],
	guard = [],
	gem = [],
	gem_skill = #pk_constellation_gem_skill{}
	}).

-define(CMD_GS2U_constellation_info,53036).
-record(pk_GS2U_constellation_info,{
	constellation_list = [],
	constellation_skill = []
	}).

-define(CMD_GS2U_constellation_update_star_soul,52149).
-record(pk_GS2U_constellation_update_star_soul,{
	id = 0,
	star_soul = #pk_constellation_star_soul{}
	}).

-define(CMD_GS2U_constellation_update_guard,34703).
-record(pk_GS2U_constellation_update_guard,{
	id = 0,
	guard = #pk_constellation_guard{}
	}).

-define(CMD_GS2U_constellation_update_skill,45417).
-record(pk_GS2U_constellation_update_skill,{
	skill = #pk_constellation_skill{}
	}).

-define(CMD_GS2U_constellation_update_star,6220).
-record(pk_GS2U_constellation_update_star,{
	id = 0,
	star = 0
	}).

-define(CMD_U2GS_constellation_up_star,47603).
-record(pk_U2GS_constellation_up_star,{
	id = 0
	}).

-define(CMD_GS2U_constellation_up_star_ret,21155).
-record(pk_GS2U_constellation_up_star_ret,{
	id = 0,
	err_code = 0
	}).

-define(CMD_U2GS_constellation_equip_star_soul_equipment,7952).
-record(pk_U2GS_constellation_equip_star_soul_equipment,{
	id = 0,
	star_soul_position_id = 0,
	equipment_id = 0
	}).

-define(CMD_GS2U_constellation_equip_star_soul_equipmen_ret,10744).
-record(pk_GS2U_constellation_equip_star_soul_equipmen_ret,{
	id = 0,
	star_soul_position_id = 0,
	equipment_id = 0,
	err_code = 0
	}).

-define(CMD_U2GS_constellation_remove_star_soul_equipment,15305).
-record(pk_U2GS_constellation_remove_star_soul_equipment,{
	id = 0,
	star_soul_position_id = 0
	}).

-define(CMD_GS2U_constellation_remove_star_soul_equipment_ret,32179).
-record(pk_GS2U_constellation_remove_star_soul_equipment_ret,{
	id = 0,
	star_soul_position_id = 0,
	err_code = 0
	}).

-define(CMD_U2GS_constellation_enhance_star_soul,15674).
-record(pk_U2GS_constellation_enhance_star_soul,{
	id = 0,
	star_soul_position_id = 0
	}).

-define(CMD_GS2U_constellation_enhance_star_soul_ret,33651).
-record(pk_GS2U_constellation_enhance_star_soul_ret,{
	id = 0,
	star_soul_position_id = 0,
	err_code = 0
	}).

-define(CMD_U2GS_constellation_eq_awaken,62224).
-record(pk_U2GS_constellation_eq_awaken,{
	id = 0,
	pos = 0
	}).

-define(CMD_GS2U_constellation_eq_awaken_ret,43928).
-record(pk_GS2U_constellation_eq_awaken_ret,{
	err_code = 0,
	id = 0,
	pos = 0
	}).

-define(CMD_U2GS_constellation_eq_bless,8716).
-record(pk_U2GS_constellation_eq_bless,{
	id = 0,
	pos = 0
	}).

-define(CMD_GS2U_constellation_eq_bless_ret,1389).
-record(pk_GS2U_constellation_eq_bless_ret,{
	err_code = 0,
	id = 0,
	pos = 0
	}).

-define(CMD_U2GS_constellation_eq_bless_pro,24510).
-record(pk_U2GS_constellation_eq_bless_pro,{
	id = 0,
	pos = 0
	}).

-define(CMD_GS2U_constellation_eq_bless_pro_ret,33338).
-record(pk_GS2U_constellation_eq_bless_pro_ret,{
	err_code = 0,
	id = 0,
	pos = 0
	}).

-define(CMD_U2GS_constellation_breakdown_star_soul_equipment,47959).
-record(pk_U2GS_constellation_breakdown_star_soul_equipment,{
	uid_list = []
	}).

-define(CMD_GS2U_constellation_breakdown_star_soul_equipment_ret,31335).
-record(pk_GS2U_constellation_breakdown_star_soul_equipment_ret,{
	err_code = 0
	}).

-define(CMD_U2GS_constellation_battle_guard,5418).
-record(pk_U2GS_constellation_battle_guard,{
	id = 0,
	guard_position_id = 0,
	guard_id = 0
	}).

-define(CMD_GS2U_constellation_battle_guard_ret,39003).
-record(pk_GS2U_constellation_battle_guard_ret,{
	id = 0,
	guard_position_id = 0,
	guard_id = 0,
	err_code = 0
	}).

-define(CMD_U2GS_constellation_remove_guard,16022).
-record(pk_U2GS_constellation_remove_guard,{
	id = 0,
	guard_position_id = 0
	}).

-define(CMD_GS2U_constellation_remove_guard_ret,466).
-record(pk_GS2U_constellation_remove_guard_ret,{
	id = 0,
	guard_position_id = 0,
	err_code = 0
	}).

-define(CMD_U2GS_constellation_unlock_skill_position,22926).
-record(pk_U2GS_constellation_unlock_skill_position,{
	skill_position_id = 0
	}).

-define(CMD_GS2U_constellation_unlock_skill_position_ret,58898).
-record(pk_GS2U_constellation_unlock_skill_position_ret,{
	skill_position_id = 0,
	err_code = 0
	}).

-define(CMD_U2GS_constellation_equip_skill,42758).
-record(pk_U2GS_constellation_equip_skill,{
	skill_position_id = 0,
	id = 0,
	skill_index = 0,
	skill_id = 0
	}).

-define(CMD_GS2U_constellation_equip_skill_ret,53321).
-record(pk_GS2U_constellation_equip_skill_ret,{
	skill_position_id = 0,
	id = 0,
	skill_id = 0,
	err_code = 0
	}).

-define(CMD_U2GS_constellation_remove_skill,26736).
-record(pk_U2GS_constellation_remove_skill,{
	skill_position_id = 0
	}).

-define(CMD_GS2U_constellation_remove_skill_ret,26576).
-record(pk_GS2U_constellation_remove_skill_ret,{
	skill_position_id = 0,
	err_code = 0
	}).

-define(CMD_U2GS_constellation_battle_guard_one,59318).
-record(pk_U2GS_constellation_battle_guard_one,{
	id = 0,
	guard_list = []
	}).

-define(CMD_GS2U_constellation_battle_guard_one_ret,16811).
-record(pk_GS2U_constellation_battle_guard_one_ret,{
	id = 0,
	err_code = 0
	}).

-define(CMD_U2GS_constellation_equip_star_soul_equipment_one,3237).
-record(pk_U2GS_constellation_equip_star_soul_equipment_one,{
	id = 0,
	equipment_id_list = []
	}).

-define(CMD_GS2U_U2GS_constellation_equip_star_soul_equipment_one_ret,46734).
-record(pk_GS2U_U2GS_constellation_equip_star_soul_equipment_one_ret,{
	id = 0,
	err_code = 0
	}).

-define(CMD_GS2U_constellation_equipment_info,44392).
-record(pk_GS2U_constellation_equipment_info,{
	equipment_list = []
	}).

-define(CMD_GS2U_constellation_equipment_update,19224).
-record(pk_GS2U_constellation_equipment_update,{
	equipment_list = []
	}).

-define(CMD_GS2U_constellation_update_gem,15195).
-record(pk_GS2U_constellation_update_gem,{
	id = 0,
	gem = []
	}).

-define(CMD_U2GS_constellation_gem_add_lv,23406).
-record(pk_U2GS_constellation_gem_add_lv,{
	id = 0,
	position = 0,
	cost_list = []
	}).

-define(CMD_GS2U_constellation_gem_add_lv_ret,39762).
-record(pk_GS2U_constellation_gem_add_lv_ret,{
	id = 0,
	position = 0,
	cost_list = [],
	err_code = 0
	}).

-define(CMD_U2GS_constellation_gem_embed,36582).
-record(pk_U2GS_constellation_gem_embed,{
	id = 0,
	position = 0,
	gem_id = 0
	}).

-define(CMD_GS2U_constellation_gem_embed_ret,23642).
-record(pk_GS2U_constellation_gem_embed_ret,{
	id = 0,
	position = 0,
	gem_id = 0,
	err_code = 0
	}).

-define(CMD_U2GS_constellation_gem_remove,39063).
-record(pk_U2GS_constellation_gem_remove,{
	id = 0,
	position = 0
	}).

-define(CMD_GS2U_constellation_gem_remove_ret,43751).
-record(pk_GS2U_constellation_gem_remove_ret,{
	id = 0,
	position = 0,
	err_code = 0
	}).

-define(CMD_U2GS_constellation_gem_embed_one_key,16622).
-record(pk_U2GS_constellation_gem_embed_one_key,{
	id = 0,
	gem_id_list = []
	}).

-define(CMD_GS2U_constellation_gem_embed_one_key_ret,52142).
-record(pk_GS2U_constellation_gem_embed_one_key_ret,{
	id = 0,
	err_code = 0
	}).

-define(CMD_GS2U_constellation_gem_skill_update,30873).
-record(pk_GS2U_constellation_gem_skill_update,{
	id = 0,
	skill = #pk_constellation_gem_skill{}
	}).

-define(CMD_U2GS_constellation_gem_skill_add_lv,15654).
-record(pk_U2GS_constellation_gem_skill_add_lv,{
	id = 0,
	skill_id = 0
	}).

-define(CMD_GS2U_constellation_gem_skill_add_lv_ret,20083).
-record(pk_GS2U_constellation_gem_skill_add_lv_ret,{
	id = 0,
	skill_id = 0,
	err_code = 0
	}).

-define(CMD_U2GS_constellation_gem_skill_reset,46992).
-record(pk_U2GS_constellation_gem_skill_reset,{
	id = 0,
	skill_id = 0
	}).

-define(CMD_GS2U_constellation_gem_skill_reset_ret,40820).
-record(pk_GS2U_constellation_gem_skill_reset_ret,{
	id = 0,
	skill_id = 0,
	err_code = 0
	}).

-define(CMD_GS2U_ancient_holy_equipment_info,18109).
-record(pk_GS2U_ancient_holy_equipment_info,{
	info_list = []
	}).

-define(CMD_ancient_holy_eq_position,62993).
-record(pk_ancient_holy_eq_position,{
	position = 0,
	equipment_id = 0,
	is_locked = 0,
	refresh_awaken_attr = [],
	awaken_attr = [],
	enhancement_level = 0
	}).

-define(CMD_GS2U_ancient_holy_eq_position_info,8880).
-record(pk_GS2U_ancient_holy_eq_position_info,{
	info_list = []
	}).

-define(CMD_U2GS_ancient_holy_eq_equip,47820).
-record(pk_U2GS_ancient_holy_eq_equip,{
	equipment_id_list = []
	}).

-define(CMD_GS2U_ancient_holy_eq_equip_ret,55575).
-record(pk_GS2U_ancient_holy_eq_equip_ret,{
	err_code = 0
	}).

-define(CMD_U2GS_ancient_holy_eq_enhance,46120).
-record(pk_U2GS_ancient_holy_eq_enhance,{
	position = 0
	}).

-define(CMD_GS2U_ancient_holy_eq_enhance_ret,26319).
-record(pk_GS2U_ancient_holy_eq_enhance_ret,{
	position = 0,
	err_code = 0
	}).

-define(CMD_GS2U_ancient_holy_eq_pos_update_enhancement_level,20411).
-record(pk_GS2U_ancient_holy_eq_pos_update_enhancement_level,{
	position = 0,
	enhancement_level = 0
	}).

-define(CMD_U2GS_ancient_holy_eq_awaken,51885).
-record(pk_U2GS_ancient_holy_eq_awaken,{
	position = 0,
	operation = 0
	}).

-define(CMD_GS2U_ancient_holy_eq_awaken_ret,10511).
-record(pk_GS2U_ancient_holy_eq_awaken_ret,{
	position = 0,
	operation = 0,
	err_code = 0
	}).

-define(CMD_GS2U_ancient_holy_eq_pos_update_equipment,60003).
-record(pk_GS2U_ancient_holy_eq_pos_update_equipment,{
	position = 0,
	equipment_id = 0
	}).

-define(CMD_GS2U_ancient_holy_eq_pos_update_awaken,19984).
-record(pk_GS2U_ancient_holy_eq_pos_update_awaken,{
	position = 0,
	awaken_attr = []
	}).

-define(CMD_GS2U_ancient_holy_eq_pos_update_refresh_awaken,31015).
-record(pk_GS2U_ancient_holy_eq_pos_update_refresh_awaken,{
	position = 0,
	refresh_awaken_attr = []
	}).

-define(CMD_U2GS_ancient_holy_eq_breakdown_equipment,45637).
-record(pk_U2GS_ancient_holy_eq_breakdown_equipment,{
	uid_list = []
	}).

-define(CMD_GS2U_ancient_holy_eq_breakdown_equipment_ret,33763).
-record(pk_GS2U_ancient_holy_eq_breakdown_equipment_ret,{
	err_code = 0
	}).

-define(CMD_U2GS_ancient_holy_eq_display,11778).
-record(pk_U2GS_ancient_holy_eq_display,{
	}).

-define(CMD_GS2U_ancient_holy_eq_display_ret,36689).
-record(pk_GS2U_ancient_holy_eq_display_ret,{
	err_code = 0
	}).

-define(CMD_U2GS_getExorcismPlayerCountMsg,25072).
-record(pk_U2GS_getExorcismPlayerCountMsg,{
	map_data_id = 0
	}).

-define(CMD_GS2U_getExorcismPlayerCountMsg,17525).
-record(pk_GS2U_getExorcismPlayerCountMsg,{
	map_data_id = 0,
	err_code = 0,
	line_list = []
	}).

-define(CMD_guildMemberRank,54604).
-record(pk_guildMemberRank,{
	rank = 0,
	name = "",
	playerid = 0,
	career = 0,
	headID = 0,
	frameID = 0,
	battleValue = 0,
	titleID = 0
	}).

-define(CMD_guildRank,49239).
-record(pk_guildRank,{
	rank = 0,
	guildName = "",
	chiefName = "",
	totalBattleValue = 0,
	now_member_num = 0,
	max_member_num = 0
	}).

-define(CMD_top3Info,4528).
-record(pk_top3Info,{
	rank = 0,
	guildName = "",
	member_list = [],
	top1_model = #pk_playerModelUI{}
	}).

-define(CMD_sectionAward,26572).
-record(pk_sectionAward,{
	start_rank = 0,
	titleID = 0,
	titleItem = 0,
	award_item = [],
	award_eq = []
	}).

-define(CMD_GS2U_dragon_honor_info_ret,24710).
-record(pk_GS2U_dragon_honor_info_ret,{
	myGuildRankShow = 0,
	myGuildRank = 0,
	nowMyGuildRank = 0,
	myRank = 0,
	myTitleID = 0,
	lastSettleTime = 0,
	my_member_list = [],
	info_list = [],
	rank_list = []
	}).

-define(CMD_U2GS_dragon_honor_daily,22082).
-record(pk_U2GS_dragon_honor_daily,{
	id = 0
	}).

-define(CMD_GS2U_dragon_honor_daily_ret,11716).
-record(pk_GS2U_dragon_honor_daily_ret,{
	id = 0,
	err = 0
	}).

-define(CMD_GS2U_dragon_honor_info_more,4549).
-record(pk_GS2U_dragon_honor_info_more,{
	describe = "",
	banner1 = "",
	banner2 = "",
	banner3 = "",
	banner4 = "",
	banner5 = "",
	banner6 = "",
	banner7 = "",
	banner8 = "",
	guildRankTime = 0,
	memberRankTime = 0,
	reward_pic = [],
	member_section = [],
	section_award_1 = [],
	section_award_2 = [],
	section_award_3 = [],
	section_award_4 = [],
	section_award_5 = []
	}).

-define(CMD_GS2U_dragon_honor_rank_change,9265).
-record(pk_GS2U_dragon_honor_rank_change,{
	}).

-define(CMD_U2GS_guild_knight_info,17050).
-record(pk_U2GS_guild_knight_info,{
	}).

-define(CMD_GS2U_guild_knight_info_ret,2291).
-record(pk_GS2U_guild_knight_info_ret,{
	index = 0,
	myGuildRankShow = 0,
	myGuildRank = 0,
	nowMyGuildRank = 0,
	myRank = 0,
	myLastRank = 0,
	myTitleID = 0,
	my_member_list = [],
	info_list = [],
	rank_list = [],
	max_index = 0,
	next_guild_time = 0,
	next_member_time = 0,
	start_time = 0
	}).

-define(CMD_GS2U_guild_knight_index_sync,65341).
-record(pk_GS2U_guild_knight_index_sync,{
	index = 0,
	max_index = 0,
	open_time = 0
	}).

-define(CMD_divine_talent,65535).
-record(pk_divine_talent,{
	id = 0,
	star = 0,
	point = 0
	}).

-define(CMD_GS2U_divine_talent_info,53244).
-record(pk_GS2U_divine_talent_info,{
	info_list = [],
	used_point = 0,
	reset_times = 0
	}).

-define(CMD_U2GS_divine_talent_add_point,42623).
-record(pk_U2GS_divine_talent_add_point,{
	id = 0,
	point = 0
	}).

-define(CMD_GS2U_divine_talent_add_point_ret,35585).
-record(pk_GS2U_divine_talent_add_point_ret,{
	id = 0,
	point = 0,
	err_code = 0
	}).

-define(CMD_GS2U_divine_update_talent_point,57537).
-record(pk_GS2U_divine_update_talent_point,{
	id = 0,
	point = 0,
	used_point = 0
	}).

-define(CMD_U2GS_divine_talent_add_star,428).
-record(pk_U2GS_divine_talent_add_star,{
	id = 0,
	star = 0
	}).

-define(CMD_GS2U_divine_talent_add_star_ret,2884).
-record(pk_GS2U_divine_talent_add_star_ret,{
	id = 0,
	star = 0,
	err_code = 0
	}).

-define(CMD_GS2U_divine_update_talent_star,16014).
-record(pk_GS2U_divine_update_talent_star,{
	id = 0,
	star = 0
	}).

-define(CMD_U2GS_divine_talent_reset,12118).
-record(pk_U2GS_divine_talent_reset,{
	}).

-define(CMD_GS2U_divine_talent_reset_ret,9731).
-record(pk_GS2U_divine_talent_reset_ret,{
	err_code = 0
	}).

-define(CMD_divine_god_show,48125).
-record(pk_divine_god_show,{
	playerId = 0,
	headID = 0,
	frame = 0,
	career = 0,
	server_name = "",
	player_name = "",
	gender = 0,
	guild_name = ""
	}).

-define(CMD_divine_god_show_info,31248).
-record(pk_divine_god_show_info,{
	type = 0,
	level = 0,
	show_list = []
	}).

-define(CMD_U2GS_divine_god_show,57125).
-record(pk_U2GS_divine_god_show,{
	}).

-define(CMD_GS2U_divine_god_show_ret,2813).
-record(pk_GS2U_divine_god_show_ret,{
	info_list = []
	}).

-define(CMD_GS2U_divine_god,60590).
-record(pk_GS2U_divine_god,{
	type = 0,
	level = 0,
	used_change_times = 0
	}).

-define(CMD_U2GS_divine_talent_change_type,38816).
-record(pk_U2GS_divine_talent_change_type,{
	type = 0
	}).

-define(CMD_GS2U_divine_talent_change_type_ret,29562).
-record(pk_GS2U_divine_talent_change_type_ret,{
	type = 0,
	err_code = 0
	}).

-define(CMD_bonfirePlayerHurtDetail,12562).
-record(pk_bonfirePlayerHurtDetail,{
	rank = 0,
	player_id = 0,
	career = 0,
	head_id = 0,
	head_frame = 0,
	guild_postion = 0,
	player_name = "",
	battle_value = 0,
	damage = 0
	}).

-define(CMD_bonfireGuildHurt,37663).
-record(pk_bonfireGuildHurt,{
	rank = 0,
	guild_id = 0,
	guild_name = "",
	damage = 0,
	serverName = ""
	}).

-define(CMD_bonfireGuildHurtDetail,30835).
-record(pk_bonfireGuildHurtDetail,{
	rank = 0,
	guild_name = "",
	chairman_name = "",
	damage = 0,
	serverName = ""
	}).

-define(CMD_GS2U_bornfire_boss_refresh_sync,13348).
-record(pk_GS2U_bornfire_boss_refresh_sync,{
	}).

-define(CMD_GS2U_bonfire_player_rank_sync,2612).
-record(pk_GS2U_bonfire_player_rank_sync,{
	my_rank = 0,
	my_damage = 0,
	bin_fill = <<>>,
	rank_list = []
	}).

-define(CMD_GS2U_bonfire_guild_rank_sync,41114).
-record(pk_GS2U_bonfire_guild_rank_sync,{
	my_rank = 0,
	my_damage = 0,
	rank_list = []
	}).

-define(CMD_U2GS_bonfire_detail_rank_req,12869).
-record(pk_U2GS_bonfire_detail_rank_req,{
	type = 0
	}).

-define(CMD_GS2U_bonfire_player_rank_detail,63990).
-record(pk_GS2U_bonfire_player_rank_detail,{
	rank_list = []
	}).

-define(CMD_GS2U_bonfire_guild_rank_detail,50166).
-record(pk_GS2U_bonfire_guild_rank_detail,{
	rank_list = []
	}).

-define(CMD_GS2U_bonfire_end,6764).
-record(pk_GS2U_bonfire_end,{
	my_rank = 0,
	my_guild_rank = 0,
	my_damage = 0,
	my_guild_damage = 0,
	rank_list = [],
	item_list = [],
	eq_list = []
	}).

-define(CMD_U2GS_bonfire_time_req,12089).
-record(pk_U2GS_bonfire_time_req,{
	}).

-define(CMD_GS2U_bonfire_boss_say,26888).
-record(pk_GS2U_bonfire_boss_say,{
	index = 0
	}).

-define(CMD_GS2U_bonfire_boss_event_end,22483).
-record(pk_GS2U_bonfire_boss_event_end,{
	}).

-define(CMD_U2GS_bonfire_set_time,14721).
-record(pk_U2GS_bonfire_set_time,{
	id = 0
	}).

-define(CMD_GS2U_bonfire_set_time_ret,26731).
-record(pk_GS2U_bonfire_set_time_ret,{
	id = 0,
	err_code = 0
	}).

-define(CMD_U2GS_EnterDungeonGod,54764).
-record(pk_U2GS_EnterDungeonGod,{
	dungeon_id = 0
	}).

-define(CMD_U2GS_ExitDungeonGod,24732).
-record(pk_U2GS_ExitDungeonGod,{
	}).

-define(CMD_U2GS_DungeonGodInfo,50500).
-record(pk_U2GS_DungeonGodInfo,{
	}).

-define(CMD_GS2U_DungeonGodInfo,63151).
-record(pk_GS2U_DungeonGodInfo,{
	max_wave = 0,
	max_score = 0
	}).

-define(CMD_GS2U_DungeonGodSettleAccounts,20609).
-record(pk_GS2U_DungeonGodSettleAccounts,{
	isWin = 0,
	wave = 0,
	score = 0,
	exp = 0,
	coinList = [],
	itemList = [],
	settleType = 0,
	isNewScore = 0,
	eq_list = []
	}).

-define(CMD_GodFightPlayer,57234).
-record(pk_GodFightPlayer,{
	player_id = 0,
	name = "",
	sex = 0,
	career = 0,
	head_id = 0,
	head_frame = 0,
	server_name = "",
	guild_name = "",
	eq_list = [],
	wing_id = 0,
	weapon_id = 0,
	weapon_vfx = 0,
	weapon_level = 0,
	weapon_star = 0,
	ancient_eq_id = 0,
	ancient_eq_elv = 0,
	battle_value = 0,
	god_type = 0,
	rank = 0,
	score = 0
	}).

-define(CMD_GodFightRound,30756).
-record(pk_GodFightRound,{
	fight_id = 0,
	type = 0,
	round = 0,
	group = 0,
	player1 = 0,
	player2 = 0,
	start_time = 0,
	end_time = 0,
	winner = 0
	}).

-define(CMD_GodFightTop,62865).
-record(pk_GodFightTop,{
	type = 0,
	topMsg = #pk_topPlayer{}
	}).

-define(CMD_U2GS_GetGodFightInfo,33615).
-record(pk_U2GS_GetGodFightInfo,{
	type = 0
	}).

-define(CMD_GS2U_GetGodFightInfoRet,47659).
-record(pk_GS2U_GetGodFightInfoRet,{
	type = 0,
	next_start = 0,
	players = [],
	rounds = []
	}).

-define(CMD_U2GS_EnterGodFight,49868).
-record(pk_U2GS_EnterGodFight,{
	fight_id = 0,
	is_viewer = 0
	}).

-define(CMD_GS2U_GodFightInfo,51569).
-record(pk_GS2U_GodFightInfo,{
	fight_id = 0,
	is_viewer = 0,
	players = [],
	state = 0,
	end_time = 0
	}).

-define(CMD_U2GS_GodFightTopsReq,56592).
-record(pk_U2GS_GodFightTopsReq,{
	type = 0
	}).

-define(CMD_GS2U_GodFightTopsRet,3531).
-record(pk_GS2U_GodFightTopsRet,{
	tops = [],
	last_tops = []
	}).

-define(CMD_GS2U_GodFightAcStateSync,13158).
-record(pk_GS2U_GodFightAcStateSync,{
	state = 0,
	next_time = 0
	}).

-define(CMD_GS2U_GodFightSettleAccounts,58138).
-record(pk_GS2U_GodFightSettleAccounts,{
	round = 0,
	winner = 0,
	players = [],
	fight_score = [],
	exp = 0,
	coinList = [],
	itemList = [],
	settleType = 0,
	isDirectWin = 0,
	isFinal = 0,
	next_time = 0
	}).

-define(CMD_HolyRuinsBoss,45062).
-record(pk_HolyRuinsBoss,{
	map_data_id = 0,
	boss_id = 0,
	level = 0,
	dead_time = 0,
	revive_time = 0,
	is_attention = false
	}).

-define(CMD_HolyRuinsCollection,61730).
-record(pk_HolyRuinsCollection,{
	map_data_id = 0,
	collection_id = 0,
	left_num = 0,
	next_refresh_time = 0,
	is_attention = false
	}).

-define(CMD_U2GS_GetHolyRuinsUI,64075).
-record(pk_U2GS_GetHolyRuinsUI,{
	}).

-define(CMD_GS2U_GetHolyRuinsUIRet,48114).
-record(pk_GS2U_GetHolyRuinsUIRet,{
	boss_list = [],
	collection_list = []
	}).

-define(CMD_U2GS_EnterHolyRuins,55301).
-record(pk_U2GS_EnterHolyRuins,{
	map_data_id = 0
	}).

-define(CMD_GS2U_HolyRuinsLimitSync,15849).
-record(pk_GS2U_HolyRuinsLimitSync,{
	times = 0,
	curse = 0
	}).

-define(CMD_GS2U_HolyRuinsInfoSync,39809).
-record(pk_GS2U_HolyRuinsInfoSync,{
	boss_list = [],
	collection_list = []
	}).

-define(CMD_GS2U_HolyRuinsInfoUpdate,16625).
-record(pk_GS2U_HolyRuinsInfoUpdate,{
	boss_list = [],
	collection_list = []
	}).

-define(CMD_GS2U_HolyRuinsRankSync,5161).
-record(pk_GS2U_HolyRuinsRankSync,{
	damage = 0,
	rank = 0,
	rank_list = []
	}).

-define(CMD_helper_damage,5172).
-record(pk_helper_damage,{
	playerID = 0,
	playerName = "",
	rank = 0,
	damage = 0
	}).

-define(CMD_helper_info,14810).
-record(pk_helper_info,{
	playerID = 0,
	playerName = "",
	playerLv = 0,
	playerSex = 0,
	vip = 0,
	headid = 0,
	head_frame = 0,
	career = 0
	}).

-define(CMD_helper_msg,10406).
-record(pk_helper_msg,{
	help_id = 0,
	playerID = 0,
	map_data_id = 0,
	map_ai = 0,
	boss_data_id = 0,
	monster_lv = 0,
	x = 0,
	y = 0,
	player_info = #pk_helper_info{}
	}).

-define(CMD_help_red_stc,21789).
-record(pk_help_red_stc,{
	help_id = 0,
	player_id = 0,
	map_data_id = 0,
	open_aciton_id = 0
	}).

-define(CMD_ship_helper_msg,26066).
-record(pk_ship_helper_msg,{
	help_id = 0,
	playerID = 0,
	plunder_id = 0,
	ship_type = 0,
	plunder_guild_name = "",
	plunder_name = "",
	plunder_sex = 0,
	plunder_battlev = 0,
	plunder_list = [],
	retake_list = [],
	player_info = #pk_helper_info{}
	}).

-define(CMD_ship_help_succ,50376).
-record(pk_ship_help_succ,{
	msg_id = 0,
	ship_type = 0,
	index = 0,
	plunder_name = "",
	plunder_sex = 0,
	reward_list = [],
	player_info = #pk_helper_info{}
	}).

-define(CMD_U2GS_requestHelp,51791).
-record(pk_U2GS_requestHelp,{
	map_data_id = 0,
	boss_id = 0
	}).

-define(CMD_GS2U_requestHelpRet,47774).
-record(pk_GS2U_requestHelpRet,{
	err = 0
	}).

-define(CMD_U2GS_requestHelpCommon,14877).
-record(pk_U2GS_requestHelpCommon,{
	openActionID = 0,
	param1 = 0,
	param2 = 0
	}).

-define(CMD_GS2U_requestHelpCommonRet,35586).
-record(pk_GS2U_requestHelpCommonRet,{
	err = 0,
	openActionID = 0,
	param1 = 0,
	param2 = 0
	}).

-define(CMD_U2GS_respondHelp,59251).
-record(pk_U2GS_respondHelp,{
	help_id = 0
	}).

-define(CMD_GS2U_respondHelpRet,21300).
-record(pk_GS2U_respondHelpRet,{
	err = 0
	}).

-define(CMD_U2GS_respondHelpCommon,11260).
-record(pk_U2GS_respondHelpCommon,{
	help_id = 0
	}).

-define(CMD_GS2U_respondHelpCommonRet,54267).
-record(pk_GS2U_respondHelpCommonRet,{
	err = 0
	}).

-define(CMD_U2GS_getHelpBoxAward,22818).
-record(pk_U2GS_getHelpBoxAward,{
	id = 0
	}).

-define(CMD_GS2U_getHelpBoxAwardRet,64131).
-record(pk_GS2U_getHelpBoxAwardRet,{
	err = 0
	}).

-define(CMD_U2GS_getHelpBoxMsg,1476).
-record(pk_U2GS_getHelpBoxMsg,{
	id = 0
	}).

-define(CMD_GS2U_getHelpBoxMsgRet,65226).
-record(pk_GS2U_getHelpBoxMsgRet,{
	err = 0,
	player_info = #pk_helper_info{},
	index = 0
	}).

-define(CMD_U2GS_getHelpDamageInfo,56006).
-record(pk_U2GS_getHelpDamageInfo,{
	}).

-define(CMD_GS2U_getHelpDamageInfoRet,29793).
-record(pk_GS2U_getHelpDamageInfoRet,{
	list = []
	}).

-define(CMD_GS2U_myHelpDamage,58342).
-record(pk_GS2U_myHelpDamage,{
	damage = 0
	}).

-define(CMD_U2GS_getHelpRequst,62161).
-record(pk_U2GS_getHelpRequst,{
	}).

-define(CMD_GS2U_getHelpRequstRet,29770).
-record(pk_GS2U_getHelpRequstRet,{
	err = 0,
	list = [],
	ship_list = []
	}).

-define(CMD_U2GS_getHelpBoxContent,48309).
-record(pk_U2GS_getHelpBoxContent,{
	}).

-define(CMD_GS2U_getHelpBoxContentRet,2628).
-record(pk_GS2U_getHelpBoxContentRet,{
	player_info_list = []
	}).

-define(CMD_U2GS_cancelHelp,61646).
-record(pk_U2GS_cancelHelp,{
	type = 0
	}).

-define(CMD_GS2U_cancelHelpRet,29540).
-record(pk_GS2U_cancelHelpRet,{
	err = 0
	}).

-define(CMD_GS2U_helpState,34011).
-record(pk_GS2U_helpState,{
	state = 0,
	name = ""
	}).

-define(CMD_GS2U_receiveTksMsg,31571).
-record(pk_GS2U_receiveTksMsg,{
	id_list = []
	}).

-define(CMD_GS2U_damagePlayerList,60596).
-record(pk_GS2U_damagePlayerList,{
	id_list = []
	}).

-define(CMD_GS2U_helpSuccess,42284).
-record(pk_GS2U_helpSuccess,{
	err = 0,
	percent = 0,
	score = 0,
	mapDataID = 0,
	monsterID = 0,
	monsterLv = 0,
	playerName = ""
	}).

-define(CMD_GS2U_receiveNewHelpReq,31239).
-record(pk_GS2U_receiveNewHelpReq,{
	help_id = 0,
	map_data_id = 0,
	open_aciton_id = 0
	}).

-define(CMD_GS2U_HelpRedSync,10737).
-record(pk_GS2U_HelpRedSync,{
	red_list = []
	}).

-define(CMD_GS2U_clearNewHelpReq,31453).
-record(pk_GS2U_clearNewHelpReq,{
	help_id = 0
	}).

-define(CMD_GS2U_playerStartHelpU,58281).
-record(pk_GS2U_playerStartHelpU,{
	playerName = ""
	}).

-define(CMD_GS2U_shipHelpFinishMsg,60715).
-record(pk_GS2U_shipHelpFinishMsg,{
	msg_list = []
	}).

-define(CMD_U2GS_helpCommonReward,6626).
-record(pk_U2GS_helpCommonReward,{
	msg_id = 0,
	index = 0
	}).

-define(CMD_GS2U_helpCommonRewardRet,13003).
-record(pk_GS2U_helpCommonRewardRet,{
	err = 0
	}).

-define(CMD_BloodSkill,8483).
-record(pk_BloodSkill,{
	order = 0,
	level = 0
	}).

-define(CMD_Bloodline,46175).
-record(pk_Bloodline,{
	blood_id = 0,
	level = 0,
	exp = 0,
	skills = []
	}).

-define(CMD_GS2U_BloodInfoSync,7851).
-record(pk_GS2U_BloodInfoSync,{
	bloods = []
	}).

-define(CMD_U2GS_ActiveBloodlineReq,39817).
-record(pk_U2GS_ActiveBloodlineReq,{
	blood_id = 0
	}).

-define(CMD_GS2U_ActiveBloodlineRet,43556).
-record(pk_GS2U_ActiveBloodlineRet,{
	err_code = 0,
	blood_id = 0
	}).

-define(CMD_U2GS_BloodlineAddExpReq,25635).
-record(pk_U2GS_BloodlineAddExpReq,{
	blood_id = 0,
	costs = []
	}).

-define(CMD_GS2U_BloodlineAddExpRet,29374).
-record(pk_GS2U_BloodlineAddExpRet,{
	err_code = 0,
	blood_id = 0
	}).

-define(CMD_U2GS_BloodSkillAddLevelReq,51673).
-record(pk_U2GS_BloodSkillAddLevelReq,{
	blood_id = 0,
	order = 0
	}).

-define(CMD_GS2U_BloodSkillAddLevelRet,5061).
-record(pk_GS2U_BloodSkillAddLevelRet,{
	err_code = 0,
	blood_id = 0,
	order = 0
	}).

-define(CMD_ShengJia,11603).
-record(pk_ShengJia,{
	stage = 0,
	is_active = false,
	active_lv = 0,
	level = 0,
	gem_list = []
	}).

-define(CMD_GS2U_ShengJiaInfo,27178).
-record(pk_GS2U_ShengJiaInfo,{
	shengjia_list = [],
	skill_list = []
	}).

-define(CMD_U2GS_ShengJiaLevelUp,49069).
-record(pk_U2GS_ShengJiaLevelUp,{
	skill_id = 0
	}).

-define(CMD_GS2U_ShengJiaUpStarRet,9417).
-record(pk_GS2U_ShengJiaUpStarRet,{
	skill_id = 0,
	level = 0,
	error_code = 0
	}).

-define(CMD_U2GS_ShengJiaOpenPos,39473).
-record(pk_U2GS_ShengJiaOpenPos,{
	stage = 0,
	pos = 0
	}).

-define(CMD_GS2U_ShengJiaOpenPosRet,58736).
-record(pk_GS2U_ShengJiaOpenPosRet,{
	stage = 0,
	pos = 0,
	error_code = 0
	}).

-define(CMD_U2GS_ShengJiaActive,36388).
-record(pk_U2GS_ShengJiaActive,{
	stage = 0
	}).

-define(CMD_GS2U_ShengJiaActiveRet,51755).
-record(pk_GS2U_ShengJiaActiveRet,{
	stage = 0,
	error_code = 0
	}).

-define(CMD_U2GS_ShengJiaGemEquip,42907).
-record(pk_U2GS_ShengJiaGemEquip,{
	stage = 0,
	pos = 0,
	gem_uid = 0
	}).

-define(CMD_GS2U_ShengJiaGemEquipRet,404).
-record(pk_GS2U_ShengJiaGemEquipRet,{
	stage = 0,
	pos = 0,
	gem_uid = 0,
	error_code = 0
	}).

-define(CMD_U2GS_ShengJiaOneKeyGemEquip,9588).
-record(pk_U2GS_ShengJiaOneKeyGemEquip,{
	stage = 0,
	gem_list = []
	}).

-define(CMD_GS2U_ShengJiaOneKeyGemEquipRet,3663).
-record(pk_GS2U_ShengJiaOneKeyGemEquipRet,{
	stage = 0,
	gem_list = [],
	error_code = 0
	}).

-define(CMD_pos_value,53595).
-record(pk_pos_value,{
	pos = 0,
	value = 0
	}).

-define(CMD_GS2U_holy_wing_list,28060).
-record(pk_GS2U_holy_wing_list,{
	wh_list = []
	}).

-define(CMD_GS2U_add_holy_wing,39039).
-record(pk_GS2U_add_holy_wing,{
	wh_list = []
	}).

-define(CMD_GS2U_delete_holy_wing,37738).
-record(pk_GS2U_delete_holy_wing,{
	wh_id_list = []
	}).

-define(CMD_holy_wing_info,1140).
-record(pk_holy_wing_info,{
	level_id = 0,
	equipment_id = 0,
	intensify_lv = 0,
	refine_lv = 0,
	refine_exp = 0,
	awaken_lv = 0,
	awaken_skill = 0,
	rune_pos = []
	}).

-define(CMD_holy_wing_skill,1041).
-record(pk_holy_wing_skill,{
	skill_id = 0,
	level = 0,
	exp = 0
	}).

-define(CMD_GS2U_holy_wing_skill_list,1831).
-record(pk_GS2U_holy_wing_skill_list,{
	initiative_list = [],
	passive_list = []
	}).

-define(CMD_GS2U_holy_wing_skill_pos,18511).
-record(pk_GS2U_holy_wing_skill_pos,{
	initiative_skill_pos = [],
	initiative_pos = 0,
	used_initiative_pos = 0,
	passive_skill_pos = [],
	passive_pos = 0,
	used_passive_pos = 0
	}).

-define(CMD_GS2U_holy_wing_info,30473).
-record(pk_GS2U_holy_wing_info,{
	type = 0,
	info_list = [],
	wings_bonus = [],
	show_id = 0
	}).

-define(CMD_U2GS_holy_wing_choose,64985).
-record(pk_U2GS_holy_wing_choose,{
	type = 0
	}).

-define(CMD_GS2U_holy_wing_choose_ret,42974).
-record(pk_GS2U_holy_wing_choose_ret,{
	type = 0,
	err_code = 0
	}).

-define(CMD_GS2U_update_holy_wing_type,8913).
-record(pk_GS2U_update_holy_wing_type,{
	type = 0
	}).

-define(CMD_U2GS_holy_wing_equip,12921).
-record(pk_U2GS_holy_wing_equip,{
	equipment_id = 0,
	level_id = 0
	}).

-define(CMD_GS2U_holy_wing_equip_ret,7319).
-record(pk_GS2U_holy_wing_equip_ret,{
	equipment_id = 0,
	level_id = 0,
	op = 0,
	err_code = 0
	}).

-define(CMD_GS2U_update_holy_wing_equipment_id,27176).
-record(pk_GS2U_update_holy_wing_equipment_id,{
	level_id = 0,
	equipment_id = 0
	}).

-define(CMD_U2GS_holy_wing_intensify,19533).
-record(pk_U2GS_holy_wing_intensify,{
	level_id = 0,
	add_lv = 0
	}).

-define(CMD_GS2U_holy_wing_intensify_ret,21265).
-record(pk_GS2U_holy_wing_intensify_ret,{
	level_id = 0,
	add_lv = 0,
	err_code = 0
	}).

-define(CMD_GS2U_update_holy_wing_intensify_lv,34218).
-record(pk_GS2U_update_holy_wing_intensify_lv,{
	level_id = 0,
	intensify_lv = 0
	}).

-define(CMD_U2GS_holy_wing_refine,63967).
-record(pk_U2GS_holy_wing_refine,{
	level_id = 0,
	item_list = []
	}).

-define(CMD_GS2U_holy_wing_refine_ret,52703).
-record(pk_GS2U_holy_wing_refine_ret,{
	level_id = 0,
	err_code = 0
	}).

-define(CMD_GS2U_update_holy_wing_refine,33741).
-record(pk_GS2U_update_holy_wing_refine,{
	level_id = 0,
	refine_lv = 0,
	refine_exp = 0
	}).

-define(CMD_U2GS_holy_wing_awaken,58906).
-record(pk_U2GS_holy_wing_awaken,{
	level_id = 0,
	add_lv = 0
	}).

-define(CMD_GS2U_holy_wing_awaken_ret,65142).
-record(pk_GS2U_holy_wing_awaken_ret,{
	level_id = 0,
	add_lv = 0,
	err_code = 0
	}).

-define(CMD_GS2U_update_holy_wing_awaken_lv,44006).
-record(pk_GS2U_update_holy_wing_awaken_lv,{
	level_id = 0,
	awaken_lv = 0
	}).

-define(CMD_U2GS_holy_wing_awaken_skill,38795).
-record(pk_U2GS_holy_wing_awaken_skill,{
	level_id = 0,
	skill_index = 0
	}).

-define(CMD_GS2U_holy_wing_awaken_skill_ret,40800).
-record(pk_GS2U_holy_wing_awaken_skill_ret,{
	level_id = 0,
	skill_index = 0,
	err_code = 0
	}).

-define(CMD_U2GS_holy_wing_rune_equip,36639).
-record(pk_U2GS_holy_wing_rune_equip,{
	level_id = 0,
	pos = 0,
	rune_id = 0
	}).

-define(CMD_GS2U_holy_wing_rune_equip_ret,48034).
-record(pk_GS2U_holy_wing_rune_equip_ret,{
	level_id = 0,
	pos = 0,
	rune_id = 0,
	op = 0,
	err_code = 0
	}).

-define(CMD_GS2U_update_holy_wing_rune_equip,6457).
-record(pk_GS2U_update_holy_wing_rune_equip,{
	level_id = 0,
	pos = 0,
	rune_id = 0
	}).

-define(CMD_U2GS_holy_wing_rune_lv,24607).
-record(pk_U2GS_holy_wing_rune_lv,{
	rune_id = 0
	}).

-define(CMD_GS2U_holy_wing_rune_lv_ret,4914).
-record(pk_GS2U_holy_wing_rune_lv_ret,{
	rune_id = 0,
	err_code = 0
	}).

-define(CMD_U2GS_holy_wing_skill_lv,54162).
-record(pk_U2GS_holy_wing_skill_lv,{
	skill_id = 0,
	cost_list = []
	}).

-define(CMD_GS2U_holy_wing_skill_lv_ret,23270).
-record(pk_GS2U_holy_wing_skill_lv_ret,{
	skill_id = 0,
	err_code = 0
	}).

-define(CMD_GS2U_update_holy_wing_skill,17696).
-record(pk_GS2U_update_holy_wing_skill,{
	skill = #pk_holy_wing_skill{}
	}).

-define(CMD_U2GS_holy_wing_skill_unlock,49770).
-record(pk_U2GS_holy_wing_skill_unlock,{
	type = 0,
	add_num = 0
	}).

-define(CMD_GS2U_holy_wing_skill_unlock_ret,33388).
-record(pk_GS2U_holy_wing_skill_unlock_ret,{
	type = 0,
	add_num = 0,
	err_code = 0
	}).

-define(CMD_GS2U_update_holy_wing_skill_pos,11162).
-record(pk_GS2U_update_holy_wing_skill_pos,{
	type = 0,
	pos_num = 0
	}).

-define(CMD_U2GS_holy_wing_skill_equip,3953).
-record(pk_U2GS_holy_wing_skill_equip,{
	type = 0,
	index = 0,
	skillId = 0
	}).

-define(CMD_GS2U_holy_wing_skill_equip_ret,61194).
-record(pk_GS2U_holy_wing_skill_equip_ret,{
	type = 0,
	index = 0,
	skillId = 0,
	err_code = 0
	}).

-define(CMD_GS2U_update_holy_wing_skill_equip,8205).
-record(pk_GS2U_update_holy_wing_skill_equip,{
	type = 0,
	index = 0,
	skillId = 0
	}).

-define(CMD_U2GS_holy_wing_bouns,45532).
-record(pk_U2GS_holy_wing_bouns,{
	point_index = 0,
	bouns_index = 0
	}).

-define(CMD_GS2U_holy_wing_bouns_ret,63472).
-record(pk_GS2U_holy_wing_bouns_ret,{
	point_index = 0,
	bouns_index = 0,
	err_code = 0
	}).

-define(CMD_U2GS_holy_wing_unlock,3496).
-record(pk_U2GS_holy_wing_unlock,{
	level_id = 0
	}).

-define(CMD_GS2U_holy_wing_unlock_ret,38424).
-record(pk_GS2U_holy_wing_unlock_ret,{
	level_id = 0,
	err_code = 0
	}).

-define(CMD_U2GS_holy_wing_show,32652).
-record(pk_U2GS_holy_wing_show,{
	cfg_id = 0
	}).

-define(CMD_GS2U_holy_wing_show_ret,16628).
-record(pk_GS2U_holy_wing_show_ret,{
	cfg_id = 0,
	err_code = 0
	}).

-define(CMD_U2GS_synthesize_holy_wing,56335).
-record(pk_U2GS_synthesize_holy_wing,{
	id = 0,
	type2 = 0,
	type3 = 0,
	type4 = 0,
	type5 = 0,
	base_cost = [],
	suc_cost = [],
	type_cost = []
	}).

-define(CMD_GS2U_synthesize_holy_wing_ret,55415).
-record(pk_GS2U_synthesize_holy_wing_ret,{
	id = 0,
	type2 = 0,
	type3 = 0,
	type4 = 0,
	type5 = 0,
	cfg_id = 0,
	suc_times = 0,
	result = 0
	}).

-define(CMD_GS2U_synthesize_holy_wing_suc_times,4492).
-record(pk_GS2U_synthesize_holy_wing_suc_times,{
	suc_times_list = []
	}).

-define(CMD_EtArea,65514).
-record(pk_EtArea,{
	totem_uid = 0,
	map_data_id = 0,
	area_id = 0,
	state = 0,
	character = 0,
	refresh_time = 0,
	owner_id = 0,
	owner_name = ""
	}).

-define(CMD_U2GS_GetElementTrialUI,15485).
-record(pk_U2GS_GetElementTrialUI,{
	}).

-define(CMD_GS2U_GetElementTrialUIRet,61586).
-record(pk_GS2U_GetElementTrialUIRet,{
	area_list = [],
	buy_curse = 0,
	day_buy_times = 0,
	used_curse = 0,
	enter_multi = 0
	}).

-define(CMD_U2GS_EnterElementTrial,49210).
-record(pk_U2GS_EnterElementTrial,{
	map_data_id = 0
	}).

-define(CMD_GS2U_ElementTrialCurseSync,29510).
-record(pk_GS2U_ElementTrialCurseSync,{
	buy_curse = 0,
	used_curse = 0,
	curse_time = 0
	}).

-define(CMD_GS2U_ElementTrialAreaSync,59681).
-record(pk_GS2U_ElementTrialAreaSync,{
	area = #pk_EtArea{}
	}).

-define(CMD_U2GS_ElementTrialArea,21653).
-record(pk_U2GS_ElementTrialArea,{
	area_id = 0
	}).

-define(CMD_GS2U_ElementTrialAreaRet,29106).
-record(pk_GS2U_ElementTrialAreaRet,{
	area = #pk_EtArea{}
	}).

-define(CMD_U2GS_ElementTrialBuyCurse,44414).
-record(pk_U2GS_ElementTrialBuyCurse,{
	buy_times = 0
	}).

-define(CMD_GS2U_ElementTrialBuyCurseRet,42687).
-record(pk_GS2U_ElementTrialBuyCurseRet,{
	err_code = 0,
	buy_times = 0,
	buy_curse = 0,
	day_buy_times = 0,
	used_curse = 0
	}).

-define(CMD_U2GS_ElementTrialSettleReq,58260).
-record(pk_U2GS_ElementTrialSettleReq,{
	}).

-define(CMD_GS2U_ElementTrialSettle,59607).
-record(pk_GS2U_ElementTrialSettle,{
	monster_kill_num = 0,
	monster_score = 0,
	totem_score = 0,
	score_efficiency = 0,
	total_score = 0,
	is_new = 0
	}).

-define(CMD_ShengWenPos,10694).
-record(pk_ShengWenPos,{
	pos = 0,
	uid = 0,
	cfg_id = 0,
	intensify_lv = 0,
	gongming_lv = 0
	}).

-define(CMD_ShengWenPosUid,747).
-record(pk_ShengWenPosUid,{
	pos = 0,
	uid = 0
	}).

-define(CMD_GS2U_ShengWenInfo,11034).
-record(pk_GS2U_ShengWenInfo,{
	awaken_list = [],
	suitlist = [],
	equ_list = [],
	shengwen_list = []
	}).

-define(CMD_U2GS_ShengWenUnLock,12563).
-record(pk_U2GS_ShengWenUnLock,{
	pos = 0
	}).

-define(CMD_GS2U_ShengWenUnLockRet,51362).
-record(pk_GS2U_ShengWenUnLockRet,{
	pos = 0,
	error_code = 0
	}).

-define(CMD_U2GS_ShengWenEquipOn,8056).
-record(pk_U2GS_ShengWenEquipOn,{
	pos = 0,
	uid = 0
	}).

-define(CMD_GS2U_ShengWenEquipOnRet,37162).
-record(pk_GS2U_ShengWenEquipOnRet,{
	pos = 0,
	uid = 0,
	error_code = 0
	}).

-define(CMD_U2GS_ShengWenOneKeyEquipOn,56631).
-record(pk_U2GS_ShengWenOneKeyEquipOn,{
	uidlist = []
	}).

-define(CMD_GS2U_ShengWenOneKeyEquipOnRet,42477).
-record(pk_GS2U_ShengWenOneKeyEquipOnRet,{
	error_code = 0
	}).

-define(CMD_U2GS_ShengWenIntensify,36764).
-record(pk_U2GS_ShengWenIntensify,{
	pos = 0
	}).

-define(CMD_GS2U_ShengWenIntensifyRet,50388).
-record(pk_GS2U_ShengWenIntensifyRet,{
	pos = 0,
	error_code = 0
	}).

-define(CMD_U2GS_ShengWenAwaken,6597).
-record(pk_U2GS_ShengWenAwaken,{
	type = 0,
	num = 0
	}).

-define(CMD_GS2U_ShengWenAwakenRet,5289).
-record(pk_GS2U_ShengWenAwakenRet,{
	type = 0,
	error_code = 0
	}).

-define(CMD_U2GS_ShengWenGongMing,12208).
-record(pk_U2GS_ShengWenGongMing,{
	pos = 0
	}).

-define(CMD_GS2U_ShengWenGongMingRet,59055).
-record(pk_GS2U_ShengWenGongMingRet,{
	pos = 0,
	error_code = 0
	}).

-define(CMD_U2GS_ShengWenResolve,24794).
-record(pk_U2GS_ShengWenResolve,{
	uids = []
	}).

-define(CMD_GS2U_ShengWenResolveRet,25516).
-record(pk_GS2U_ShengWenResolveRet,{
	error_code = 0
	}).

-define(CMD_GS2U_ShengwenUpdate,2911).
-record(pk_GS2U_ShengwenUpdate,{
	shengwen_list = []
	}).

-define(CMD_GS2U_ShengWenPosUpdate,46449).
-record(pk_GS2U_ShengWenPosUpdate,{
	posInfoList = []
	}).

-define(CMD_GS2U_ShengWenAwakenUpdate,25659).
-record(pk_GS2U_ShengWenAwakenUpdate,{
	awakenList = []
	}).

-define(CMD_GS2U_ShengWenSuitUpdate,47918).
-record(pk_GS2U_ShengWenSuitUpdate,{
	suitlist = []
	}).

-define(CMD_DarkLordKill,23394).
-record(pk_DarkLordKill,{
	server_name = "",
	player_name = "",
	kill_time = 0
	}).

-define(CMD_DarkLordBoss,3822).
-record(pk_DarkLordBoss,{
	map_data_id = 0,
	boss_id = 0,
	refresh_time = 0,
	is_attention = false,
	kill_history = []
	}).

-define(CMD_U2GS_GetDarkLordUI,53110).
-record(pk_U2GS_GetDarkLordUI,{
	}).

-define(CMD_GS2U_GetDarkLordUIRet,34301).
-record(pk_GS2U_GetDarkLordUIRet,{
	boss_list = [],
	add_times = 0,
	used_times = 0
	}).

-define(CMD_U2GS_EnterDarkLord,46766).
-record(pk_U2GS_EnterDarkLord,{
	map_data_id = 0
	}).

-define(CMD_GS2U_DarkLordTimesSync,30579).
-record(pk_GS2U_DarkLordTimesSync,{
	add_times = 0,
	used_times = 0
	}).

-define(CMD_GS2U_DarkLordInfoSync,54271).
-record(pk_GS2U_DarkLordInfoSync,{
	boss_list = []
	}).

-define(CMD_GS2U_DarkLordInfoUpdate,57256).
-record(pk_GS2U_DarkLordInfoUpdate,{
	boss_list = []
	}).

-define(CMD_GS2U_DarkLordRankSync,19625).
-record(pk_GS2U_DarkLordRankSync,{
	damage = 0,
	rank = 0,
	rank_list = []
	}).

-define(CMD_GS2U_DarkLordHurtNotice,59625).
-record(pk_GS2U_DarkLordHurtNotice,{
	hurt_time = 0
	}).

-define(CMD_GS2U_dark_flame_push_eq_info,43901).
-record(pk_GS2U_dark_flame_push_eq_info,{
	eq_list = []
	}).

-define(CMD_dark_flame_pos,35012).
-record(pk_dark_flame_pos,{
	pos = 0,
	uid = 0,
	forge = [],
	forge_cache = []
	}).

-define(CMD_GS2U_dark_flame_push_pos_info,23976).
-record(pk_GS2U_dark_flame_push_pos_info,{
	pos_list = []
	}).

-define(CMD_U2GS_dark_flame_pos_equip,45584).
-record(pk_U2GS_dark_flame_pos_equip,{
	eq_uid_list = []
	}).

-define(CMD_GS2U_dark_flame_pos_equip_ret,37111).
-record(pk_GS2U_dark_flame_pos_equip_ret,{
	pos_list = [],
	err_code = 0
	}).

-define(CMD_U2GS_dark_flame_pos_forge,2691).
-record(pk_U2GS_dark_flame_pos_forge,{
	pos = 0,
	type = 0
	}).

-define(CMD_GS2U_dark_flame_pos_forge_ret,26031).
-record(pk_GS2U_dark_flame_pos_forge_ret,{
	pos = 0,
	type = 0,
	err_code = 0
	}).

-define(CMD_U2GS_dark_flame_eq_break_down,2216).
-record(pk_U2GS_dark_flame_eq_break_down,{
	eq_uid_list = []
	}).

-define(CMD_GS2U_dark_flame_eq_break_down_ret,19870).
-record(pk_GS2U_dark_flame_eq_break_down_ret,{
	err_code = 0
	}).

-define(CMD_dark_flame_grandmaster,60424).
-record(pk_dark_flame_grandmaster,{
	type = 0,
	level = 0,
	times = 0
	}).

-define(CMD_GS2U_dark_flame_push_grandmaster_info,4629).
-record(pk_GS2U_dark_flame_push_grandmaster_info,{
	grandmaster_list = []
	}).

-define(CMD_DemonRewardInfo,12537).
-record(pk_DemonRewardInfo,{
	type = 0,
	score = 0,
	day_score = 0,
	is_token = 0,
	rewards = []
	}).

-define(CMD_U2GS_GetDemonRewardInfo,46762).
-record(pk_U2GS_GetDemonRewardInfo,{
	type = 0
	}).

-define(CMD_GS2U_GetDemonRewardInfoRet,44080).
-record(pk_GS2U_GetDemonRewardInfoRet,{
	info_list = []
	}).

-define(CMD_U2GS_GetDemonReward,35504).
-record(pk_U2GS_GetDemonReward,{
	type = 0,
	reward_id = 0
	}).

-define(CMD_GS2U_GetDemonRewardRet,22993).
-record(pk_GS2U_GetDemonRewardRet,{
	err_code = 0,
	type = 0,
	reward_id = 0
	}).

-define(CMD_U2GS_BuyDemonRewardToken,31359).
-record(pk_U2GS_BuyDemonRewardToken,{
	type = 0
	}).

-define(CMD_GS2U_BuyDemonRewardTokenRet,34962).
-record(pk_GS2U_BuyDemonRewardTokenRet,{
	err_code = 0,
	type = 0
	}).

-define(CMD_U2GS_GetChapterAward,14019).
-record(pk_U2GS_GetChapterAward,{
	chapterID = 0
	}).

-define(CMD_GS2U_GetChapterAward,14944).
-record(pk_GS2U_GetChapterAward,{
	errorCode = 0
	}).

-define(CMD_rewardIndex,46861).
-record(pk_rewardIndex,{
	index = 0,
	iD = 0,
	poolID = 0,
	number = 0
	}).

-define(CMD_GS2U_SendRewardList,17792).
-record(pk_GS2U_SendRewardList,{
	iD = 0,
	rewardList = [],
	loginTime = 0,
	onlineTime = 0
	}).

-define(CMD_GS2U_SendOnlineDrawTimes,48214).
-record(pk_GS2U_SendOnlineDrawTimes,{
	haveTimes = 0,
	usedTimes = 0
	}).

-define(CMD_U2GS_OnlineRewardDrawTimes,5786).
-record(pk_U2GS_OnlineRewardDrawTimes,{
	times = 0
	}).

-define(CMD_GS2U_SendOnlineRewardDrawResult,6649).
-record(pk_GS2U_SendOnlineRewardDrawResult,{
	err_code = 0
	}).

-define(CMD_GS2U_SendMondayRewardDrawResult,6782).
-record(pk_GS2U_SendMondayRewardDrawResult,{
	rewards = []
	}).

-define(CMD_U2GS_GetMondayRewardInfo,65318).
-record(pk_U2GS_GetMondayRewardInfo,{
	}).

-define(CMD_GS2U_GetMondayRewardInfoRet,55940).
-record(pk_GS2U_GetMondayRewardInfoRet,{
	level = 0,
	rewards = []
	}).

-define(CMD_U2GS_GetMondayReward,36395).
-record(pk_U2GS_GetMondayReward,{
	}).

-define(CMD_GS2U_GetMondayRewardRet,22307).
-record(pk_GS2U_GetMondayRewardRet,{
	err_code = 0
	}).

-define(CMD_domainReportStc,63017).
-record(pk_domainReportStc,{
	rank = 0,
	guild_id = 0,
	guild_name = "",
	joinNum = 0,
	score = 0,
	pillar_list = []
	}).

-define(CMD_domainSettleStc,35276).
-record(pk_domainSettleStc,{
	venue_type = 0,
	rank = 0,
	guild_id = 0,
	guild_name = "",
	joinNum = 0,
	score = 0,
	pillar_list = [],
	new_venue_type = 0,
	new_rank = 0
	}).

-define(CMD_venueStc,57744).
-record(pk_venueStc,{
	type = 0,
	rank = 0,
	guild_name = "",
	head_icon = 0
	}).

-define(CMD_guildScoreRank,41453).
-record(pk_guildScoreRank,{
	rank = 0,
	guild_name = "",
	score = 0
	}).

-define(CMD_playerScoreRankDetail,59729).
-record(pk_playerScoreRankDetail,{
	rank = 0,
	player_id = 0,
	player_name = "",
	head_id = 0,
	frame_id = 0,
	guild_id = 0,
	guild_name = "",
	damage = 0,
	pillar_list = [],
	score = 0
	}).

-define(CMD_pillarHurtRank,24141).
-record(pk_pillarHurtRank,{
	rank = 0,
	guild_id = 0,
	guild_name = "",
	damage = 0
	}).

-define(CMD_pillarBelong,52598).
-record(pk_pillarBelong,{
	id = 0,
	score = 0,
	guild_id = 0,
	guild_name = ""
	}).

-define(CMD_SkyOverlord,35030).
-record(pk_SkyOverlord,{
	rank = 0,
	guild_name = "",
	ui_info = #pk_playerModelUI{}
	}).

-define(CMD_guildPlayerScore,51359).
-record(pk_guildPlayerScore,{
	guild_name = "",
	score = 0
	}).

-define(CMD_U2GS_domainReport,5057).
-record(pk_U2GS_domainReport,{
	}).

-define(CMD_GS2U_domainReportRet,61555).
-record(pk_GS2U_domainReportRet,{
	report_list = []
	}).

-define(CMD_U2GS_domainInfo,62707).
-record(pk_U2GS_domainInfo,{
	}).

-define(CMD_GS2U_domainInfoRet,26052).
-record(pk_GS2U_domainInfoRet,{
	venue_list = []
	}).

-define(CMD_GS2U_domainScoreSync,40231).
-record(pk_GS2U_domainScoreSync,{
	pillar_list = [],
	lead_guild_name = "",
	myScore = 0,
	list = []
	}).

-define(CMD_GS2U_domainaPillarSync,24489).
-record(pk_GS2U_domainaPillarSync,{
	my_guild_rank = 0,
	my_guild_damage = 0,
	list = []
	}).

-define(CMD_U2GS_domainPlayerScoreRank,1674).
-record(pk_U2GS_domainPlayerScoreRank,{
	}).

-define(CMD_GS2U_domainPlayerScoreRankRet,30776).
-record(pk_GS2U_domainPlayerScoreRankRet,{
	guild_rank_list = [],
	list = []
	}).

-define(CMD_U2GS_domainWarSituation,52652).
-record(pk_U2GS_domainWarSituation,{
	}).

-define(CMD_GS2U_domainWarSituationRet,6059).
-record(pk_GS2U_domainWarSituationRet,{
	list = [],
	pillar_belong = []
	}).

-define(CMD_GS2U_domainBattleChange,54968).
-record(pk_GS2U_domainBattleChange,{
	round = 0,
	state = 0,
	reset_time = 0,
	attacker = [],
	defender = []
	}).

-define(CMD_GS2U_domainRoundSettle,52844).
-record(pk_GS2U_domainRoundSettle,{
	round = 0,
	first_name = "",
	my_guild_rank = 0
	}).

-define(CMD_GS2U_domainSettlement,8581).
-record(pk_GS2U_domainSettlement,{
	list = []
	}).

-define(CMD_GS2U_domainSettlementAuction1,10968).
-record(pk_GS2U_domainSettlementAuction1,{
	item_list = [],
	eq_list = []
	}).

-define(CMD_GS2U_domainSettlementAuction2,14818).
-record(pk_GS2U_domainSettlementAuction2,{
	item_list = [],
	eq_list = []
	}).

-define(CMD_GS2U_domainSettlementPerson,59763).
-record(pk_GS2U_domainSettlementPerson,{
	item_list = [],
	coin_list = []
	}).

-define(CMD_GS2U_domainSchedule,58096).
-record(pk_GS2U_domainSchedule,{
	open_time = 0,
	close_time = 0,
	is_end = 0
	}).

-define(CMD_U2GS_domainInspire,50526).
-record(pk_U2GS_domainInspire,{
	type = 0
	}).

-define(CMD_GS2U_domainInspireRet,54617).
-record(pk_GS2U_domainInspireRet,{
	err_code = 0
	}).

-define(CMD_U2GS_domainWarSetOnFire,19323).
-record(pk_U2GS_domainWarSetOnFire,{
	monsterID = 0
	}).

-define(CMD_U2GS_domainCancelChariots,44780).
-record(pk_U2GS_domainCancelChariots,{
	}).

-define(CMD_GS2U_domainCancelChariotsRet,774).
-record(pk_GS2U_domainCancelChariotsRet,{
	err_code = 0
	}).

-define(CMD_GS2U_domainInspireSync,23597).
-record(pk_GS2U_domainInspireSync,{
	inspire = []
	}).

-define(CMD_U2GS_domainFightEnter,18218).
-record(pk_U2GS_domainFightEnter,{
	}).

-define(CMD_GS2U_domainFightEnterRet,10098).
-record(pk_GS2U_domainFightEnterRet,{
	err_code = 0
	}).

-define(CMD_U2GS_skyOverlord,12905).
-record(pk_U2GS_skyOverlord,{
	}).

-define(CMD_GS2U_skyOverlordRet,2442).
-record(pk_GS2U_skyOverlordRet,{
	overloads = [],
	successive = 0
	}).

-define(CMD_U2GS_releaseAward,3257).
-record(pk_U2GS_releaseAward,{
	type = 0
	}).

-define(CMD_GS2U_releaseAwardRet,52093).
-record(pk_GS2U_releaseAwardRet,{
	err_code = 0
	}).

-define(CMD_GS2U_skyOverlordAwardNotice,48899).
-record(pk_GS2U_skyOverlordAwardNotice,{
	is_successive_award = false,
	is_break_successive_award = false
	}).

-define(CMD_GS2U_domain_on_fire,6431).
-record(pk_GS2U_domain_on_fire,{
	guild_rank = 0,
	player_name = "",
	player_sex = 0,
	monster_id = 0
	}).

-define(CMD_GS2U_domainAuctionNotice,14957).
-record(pk_GS2U_domainAuctionNotice,{
	type = 0
	}).

-define(CMD_GS2U_domainMonsterMaxHpSync,3229).
-record(pk_GS2U_domainMonsterMaxHpSync,{
	pillar_list = [],
	door_list = [],
	flag_list = []
	}).

-define(CMD_give_award_info,4834).
-record(pk_give_award_info,{
	id = 0,
	index_list = []
	}).

-define(CMD_GS2U_carnival_give_award_info,19652).
-record(pk_GS2U_carnival_give_award_info,{
	info_list = []
	}).

-define(CMD_U2GS_carnival_give_award,3686).
-record(pk_U2GS_carnival_give_award,{
	id = 0,
	index = 0
	}).

-define(CMD_GS2U_carnival_give_award_ret,44631).
-record(pk_GS2U_carnival_give_award_ret,{
	id = 0,
	index = 0,
	err_code = 0
	}).

-define(CMD_carnival_rea_point,18418).
-record(pk_carnival_rea_point,{
	id = 0,
	is_show = 0,
	type = 0
	}).

-define(CMD_GS2U_carnival_give_award_rea_point,51798).
-record(pk_GS2U_carnival_give_award_rea_point,{
	info_list = []
	}).

-define(CMD_GS2U_carnival_rank_down,30826).
-record(pk_GS2U_carnival_rank_down,{
	id = 0,
	old_rank = 0
	}).

-define(CMD_dragon_badge_player,4585).
-record(pk_dragon_badge_player,{
	id = 0,
	lv = 0,
	exp = 0,
	reward_lv = 0,
	rank_flag = 0,
	daily_reward = 0,
	is_effect = 0,
	daily_comp_condition = [],
	daily_comp_task = [],
	weekly_comp_condition = [],
	weekly_comp_task = [],
	open_time = 0
	}).

-define(CMD_GS2U_DragonBadgePlayerInfo,38612).
-record(pk_GS2U_DragonBadgePlayerInfo,{
	info_list = []
	}).

-define(CMD_U2GS_DragonBadgePlayerReq,8712).
-record(pk_U2GS_DragonBadgePlayerReq,{
	id = 0
	}).

-define(CMD_GS2U_DragonBadgePlayer,10330).
-record(pk_GS2U_DragonBadgePlayer,{
	err_code = 0,
	info = #pk_dragon_badge_player{}
	}).

-define(CMD_U2GS_DragonBadgeAdvance,6393).
-record(pk_U2GS_DragonBadgeAdvance,{
	id = 0,
	type = 0
	}).

-define(CMD_GS2U_DragonBadgeAdvanceRet,2728).
-record(pk_GS2U_DragonBadgeAdvanceRet,{
	id = 0,
	type = 0,
	err_code = 0
	}).

-define(CMD_U2GS_BuyDragonBadgeExp,26899).
-record(pk_U2GS_BuyDragonBadgeExp,{
	id = 0,
	level = 0
	}).

-define(CMD_GS2U_BuyDragonBadgeExpRet,5150).
-record(pk_GS2U_BuyDragonBadgeExpRet,{
	id = 0,
	err_code = 0
	}).

-define(CMD_U2GS_DragonBadgeLvReward,25639).
-record(pk_U2GS_DragonBadgeLvReward,{
	id = 0
	}).

-define(CMD_GS2U_DragonBadgeLvRet,21259).
-record(pk_GS2U_DragonBadgeLvRet,{
	id = 0,
	err_code = 0
	}).

-define(CMD_U2GS_DragonBadgeDaily,2814).
-record(pk_U2GS_DragonBadgeDaily,{
	id = 0
	}).

-define(CMD_GS2U_DragonBadgeDailyReq,14066).
-record(pk_GS2U_DragonBadgeDailyReq,{
	id = 0,
	err_code = 0
	}).

-define(CMD_GS2U_DragonBadgeLvExpChange,60801).
-record(pk_GS2U_DragonBadgeLvExpChange,{
	id = 0,
	lv = 0,
	exp = 0
	}).

-define(CMD_GS2U_DragonSealNotice,13218).
-record(pk_GS2U_DragonSealNotice,{
	level = 0,
	state = 0,
	player_id = 0,
	player_name = "",
	player_career = 0,
	player_head = 0,
	player_frame = 0,
	player_sex = 0,
	is_award = 0
	}).

-define(CMD_U2GS_GetDragonSealUI,45766).
-record(pk_U2GS_GetDragonSealUI,{
	}).

-define(CMD_GS2U_GetDragonSealUIRet,7807).
-record(pk_GS2U_GetDragonSealUIRet,{
	level = 0,
	state = 0,
	open_time = 0,
	release_time = 0,
	player_id = 0,
	player_name = "",
	player_career = 0,
	player_head = 0,
	player_frame = 0,
	player_sex = 0,
	guild_join = 0,
	level_num = 0,
	is_award = 0
	}).

-define(CMD_U2GS_DragonSealBuyTimes,54506).
-record(pk_U2GS_DragonSealBuyTimes,{
	level = 0,
	type = 0,
	times = 0
	}).

-define(CMD_GS2U_DragonSealBuyTimesRet,15728).
-record(pk_GS2U_DragonSealBuyTimesRet,{
	err_code = 0,
	level = 0,
	type = 0,
	times = 0
	}).

-define(CMD_U2GS_DragonSealTimesInfo,6622).
-record(pk_U2GS_DragonSealTimesInfo,{
	level = 0,
	type = 0
	}).

-define(CMD_GS2U_DragonSealTimesInfoRet,33108).
-record(pk_GS2U_DragonSealTimesInfoRet,{
	level = 0,
	type = 0,
	join_times = 0,
	free_times = 0,
	buy_times = 0,
	day_buy_times = 0
	}).

-define(CMD_U2GS_EnterDungeonSeal,47023).
-record(pk_U2GS_EnterDungeonSeal,{
	level = 0,
	type = 0
	}).

-define(CMD_GS2U_DungeonSealSync,51761).
-record(pk_GS2U_DungeonSealSync,{
	rank = 0,
	kill_num = 0,
	cur_num = 0,
	exp = 0
	}).

-define(CMD_GS2U_DungeonSealSettle,57358).
-record(pk_GS2U_DungeonSealSettle,{
	is_win = 0,
	exp = 0,
	items = [],
	coins = [],
	eqs = []
	}).

-define(CMD_U2GS_SealCallBoss,44731).
-record(pk_U2GS_SealCallBoss,{
	}).

-define(CMD_GS2U_SealCallBossRet,46030).
-record(pk_GS2U_SealCallBossRet,{
	err_code = 0,
	call_num = 0,
	next_time = 0
	}).

-define(CMD_U2GS_SealGetReward,19618).
-record(pk_U2GS_SealGetReward,{
	}).

-define(CMD_GS2U_SealGetRewardRet,12536).
-record(pk_GS2U_SealGetRewardRet,{
	err_code = 0
	}).

-define(CMD_god_bless,58224).
-record(pk_god_bless,{
	player_lv = 0,
	level = 0,
	exp = 0
	}).

-define(CMD_GS2U_god_bless_info,49142).
-record(pk_GS2U_god_bless_info,{
	god_bless_list = []
	}).

-define(CMD_U2GS_god_bless_prayer_exp,60491).
-record(pk_U2GS_god_bless_prayer_exp,{
	op_type = 0
	}).

-define(CMD_GS2U_god_bless_prayer_exp_ret,25743).
-record(pk_GS2U_god_bless_prayer_exp_ret,{
	player_lv = 0,
	level = 0,
	exp = 0,
	err_code = 0
	}).

-define(CMD_U2GS_god_bless_prayer_item,16396).
-record(pk_U2GS_god_bless_prayer_item,{
	player_lv = 0,
	cost_list = []
	}).

-define(CMD_GS2U_god_bless_prayer_item_ret,23258).
-record(pk_GS2U_god_bless_prayer_item_ret,{
	player_lv = 0,
	level = 0,
	exp = 0,
	err_code = 0
	}).

-define(CMD_MsPlayerRecord,5778).
-record(pk_MsPlayerRecord,{
	rank = 0,
	name = "",
	sex = 0,
	time = 0
	}).

-define(CMD_MsChapterDiscover,23927).
-record(pk_MsChapterDiscover,{
	chapterID = 0,
	name = "",
	sex = 0,
	time = 0
	}).

-define(CMD_GS2U_MainlineSealSync,18395).
-record(pk_GS2U_MainlineSealSync,{
	id = 0,
	state = 0,
	end_time = 0,
	discoverer_name = "",
	discoverer_sex = 0,
	discoverer_id = 0
	}).

-define(CMD_U2GS_MsMonument,24085).
-record(pk_U2GS_MsMonument,{
	id = 0
	}).

-define(CMD_GS2U_MslMonumentRet,41218).
-record(pk_GS2U_MslMonumentRet,{
	id = 0,
	err_code = 0,
	discoverer = #pk_MsPlayerRecord{},
	top_hunters = []
	}).

-define(CMD_U2GS_MsTop,10827).
-record(pk_U2GS_MsTop,{
	id = 0
	}).

-define(CMD_GS2U_MsTopRet,8831).
-record(pk_GS2U_MsTopRet,{
	id = 0,
	err_code = 0,
	top_list = []
	}).

-define(CMD_U2GS_MsDiscover,16391).
-record(pk_U2GS_MsDiscover,{
	chapterID = 0
	}).

-define(CMD_GS2U_MsDiscoverRet,61961).
-record(pk_GS2U_MsDiscoverRet,{
	discover_list = []
	}).

-define(CMD_U2GS_MsHunterGame,39865).
-record(pk_U2GS_MsHunterGame,{
	id = 0
	}).

-define(CMD_GS2U_MsHunterGameRet,41226).
-record(pk_GS2U_MsHunterGameRet,{
	id = 0,
	err_code = 0,
	my_rank = 0
	}).

-define(CMD_GS2U_MsDisAvailableSeal,3515).
-record(pk_GS2U_MsDisAvailableSeal,{
	id_list = []
	}).

-define(CMD_merchantShip,8451).
-record(pk_merchantShip,{
	player_id = 0,
	player_name = "",
	player_lv = 0,
	player_sex = 0,
	head_id = 0,
	head_frame = 0,
	guild_id = 0,
	guild_name = "",
	ship_type = 0,
	ship_id = 0,
	battle_value = 0,
	danger_classes = 0,
	start_time = 0,
	end_time = 0,
	protect_time = 0
	}).

-define(CMD_merchantShipRobot,7928).
-record(pk_merchantShipRobot,{
	robot_id = 0,
	ship_type = 0,
	ship_id = 0,
	battle_value = 0,
	danger_classes = 0,
	start_time = 0,
	end_time = 0
	}).

-define(CMD_merchantShipPlayer,47532).
-record(pk_merchantShipPlayer,{
	escort_times = 0,
	intercept_times = 0,
	free_refresh_times = 0,
	lucky_value = 0,
	ship_type = 0,
	end_time = 0
	}).

-define(CMD_merchantShipForay,48334).
-record(pk_merchantShipForay,{
	foray_id = 0,
	foray_sex = 0,
	foray_name = "",
	ship_type = 0,
	ship_id = 0,
	battle_value = 0,
	is_seek_help = 0,
	plunder_list = [],
	retake_list = [],
	retake_percent = 0,
	foray_time = 0
	}).

-define(CMD_U2GS_mc_info,41672).
-record(pk_U2GS_mc_info,{
	}).

-define(CMD_GS2U_mc_info_ret,4005).
-record(pk_GS2U_mc_info_ret,{
	ship_player = #pk_merchantShipPlayer{},
	ship_list = [],
	robot_ship_list = []
	}).

-define(CMD_U2GS_mc_foray_info,50570).
-record(pk_U2GS_mc_foray_info,{
	}).

-define(CMD_GS2U_mc_foray_info_ret,61075).
-record(pk_GS2U_mc_foray_info_ret,{
	foray_list = []
	}).

-define(CMD_GS2U_mc_ship_player_update,21546).
-record(pk_GS2U_mc_ship_player_update,{
	ship_player = #pk_merchantShipPlayer{}
	}).

-define(CMD_U2GS_mc_refresh_ship,17409).
-record(pk_U2GS_mc_refresh_ship,{
	is_one_key = 0
	}).

-define(CMD_GS2U_mc_refresh_ship_ret,197).
-record(pk_GS2U_mc_refresh_ship_ret,{
	err_code = 0,
	is_one_key = 0
	}).

-define(CMD_U2GS_mc_start_ship,59572).
-record(pk_U2GS_mc_start_ship,{
	}).

-define(CMD_GS2U_mc_start_ship_ret,27149).
-record(pk_GS2U_mc_start_ship_ret,{
	err_code = 0
	}).

-define(CMD_U2GS_mc_ship_reward_preview,13228).
-record(pk_U2GS_mc_ship_reward_preview,{
	}).

-define(CMD_GS2U_mc_ship_reward_preview_ret,5241).
-record(pk_GS2U_mc_ship_reward_preview_ret,{
	err_code = 0,
	ship_type = 0,
	is_double = 0,
	reward_list = [],
	foray_list = []
	}).

-define(CMD_U2GS_mc_ship_reward,64142).
-record(pk_U2GS_mc_ship_reward,{
	}).

-define(CMD_GS2U_mc_ship_reward_ret,10959).
-record(pk_GS2U_mc_ship_reward_ret,{
	err_code = 0
	}).

-define(CMD_GS2U_ShipSettleAccounts,9448).
-record(pk_GS2U_ShipSettleAccounts,{
	err_code = 0,
	ship_type = 0,
	mode = 0,
	index = 0,
	random_event = 0,
	helper_name = "",
	helper_sex = 0,
	target_bv = 0,
	reward_list = []
	}).

-define(CMD_U2GS_mc_intercept_ship,10580).
-record(pk_U2GS_mc_intercept_ship,{
	target_id = 0
	}).

-define(CMD_GS2U_mc_intercept_ship_ret,12699).
-record(pk_GS2U_mc_intercept_ship_ret,{
	err_code = 0
	}).

-define(CMD_U2GS_mc_recapture_ship,53286).
-record(pk_U2GS_mc_recapture_ship,{
	ship_id = 0
	}).

-define(CMD_GS2U_mc_recapture_ship_ret,20913).
-record(pk_GS2U_mc_recapture_ship_ret,{
	err_code = 0
	}).

-define(CMD_GS2U_mc_foray_report_new,57582).
-record(pk_GS2U_mc_foray_report_new,{
	}).

-define(CMD_GS2U_mc_ship_finish_msg,54230).
-record(pk_GS2U_mc_ship_finish_msg,{
	}).

-define(CMD_GS2U_AwakenRoadInfo,25478).
-record(pk_GS2U_AwakenRoadInfo,{
	reward_list = [],
	bp_reward_list = [],
	bp_list = []
	}).

-define(CMD_U2GS_AwakenRoadReward,3753).
-record(pk_U2GS_AwakenRoadReward,{
	id = 0
	}).

-define(CMD_GS2U_AwakenRoadRewardReq,42264).
-record(pk_GS2U_AwakenRoadRewardReq,{
	id = 0,
	err_code = 0
	}).

-define(CMD_U2GS_AwakenRoad_OneKeyReward,30509).
-record(pk_U2GS_AwakenRoad_OneKeyReward,{
	group_id = 0
	}).

-define(CMD_GS2U_AwakenRoad_OneKeyRewardReq,32729).
-record(pk_GS2U_AwakenRoad_OneKeyRewardReq,{
	group_id = 0,
	id_list = [],
	itemList = [],
	currencyList = [],
	equipmentList = [],
	err_code = 0
	}).

-define(CMD_U2GS_AwakenRoad_BPActive,18433).
-record(pk_U2GS_AwakenRoad_BPActive,{
	group_id = 0
	}).

-define(CMD_GS2U_AwakenRoad_BPActiveReq,189).
-record(pk_GS2U_AwakenRoad_BPActiveReq,{
	group_id = 0,
	err_code = 0
	}).

-define(CMD_GS2U_card_refine_info,10176).
-record(pk_GS2U_card_refine_info,{
	level = 0,
	exp = 0
	}).

-define(CMD_U2GS_card_refine,5731).
-record(pk_U2GS_card_refine,{
	cost_list = []
	}).

-define(CMD_GS2U_card_refine_ret,43837).
-record(pk_GS2U_card_refine_ret,{
	level = 0,
	exp = 0,
	err_code = 0
	}).

-define(CMD_GiftPacksStc,7580).
-record(pk_GiftPacksStc,{
	type = 0,
	group = 0,
	gift_id = 0,
	buy_times = 0
	}).

-define(CMD_GS2U_GiftPacksInfo,22080).
-record(pk_GS2U_GiftPacksInfo,{
	list = []
	}).

-define(CMD_U2GS_buy_gift_packs,14046).
-record(pk_U2GS_buy_gift_packs,{
	type = 0,
	group = 0,
	gift_id = 0
	}).

-define(CMD_GS2U_buy_gift_packs_ret,57026).
-record(pk_GS2U_buy_gift_packs_ret,{
	error = 0,
	type = 0,
	group = 0,
	gift_id = 0,
	buy_times = 0
	}).

-define(CMD_DailySeckillStc,30468).
-record(pk_DailySeckillStc,{
	type = 0,
	buy_list = []
	}).

-define(CMD_GS2U_daily_seckill_info,40579).
-record(pk_GS2U_daily_seckill_info,{
	list = []
	}).

-define(CMD_U2GS_daily_packs_free,33769).
-record(pk_U2GS_daily_packs_free,{
	}).

-define(CMD_GS2U_daily_packs_free_ret,38468).
-record(pk_GS2U_daily_packs_free_ret,{
	error = 0
	}).

-define(CMD_U2GS_daily_packs_award,47813).
-record(pk_U2GS_daily_packs_award,{
	id = 0
	}).

-define(CMD_GS2U_daily_packs_award_ret,58055).
-record(pk_GS2U_daily_packs_award_ret,{
	id = 0,
	error = 0
	}).

-define(CMD_storyStruct,65392).
-record(pk_storyStruct,{
	id = 0,
	list = 0
	}).

-define(CMD_GS2U_sendStoryRewardList,24291).
-record(pk_GS2U_sendStoryRewardList,{
	reward_list = []
	}).

-define(CMD_U2GS_getStoryReward,42912).
-record(pk_U2GS_getStoryReward,{
	id = 0,
	list = 0
	}).

-define(CMD_GS2U_getStoryRewardResult,43996).
-record(pk_GS2U_getStoryRewardResult,{
	id = 0,
	list = 0,
	err_code = 0
	}).

-define(CMD_accompanyStruct,56595).
-record(pk_accompanyStruct,{
	type = 0,
	content = 0
	}).

-define(CMD_GS2U_sendAccompanyRewardList,39778).
-record(pk_GS2U_sendAccompanyRewardList,{
	reward_list = []
	}).

-define(CMD_U2GS_getAccompanyReward,52533).
-record(pk_U2GS_getAccompanyReward,{
	type = 0,
	content = 0
	}).

-define(CMD_GS2U_getAccompanyRewardResult,3819).
-record(pk_GS2U_getAccompanyRewardResult,{
	type = 0,
	content = 0,
	err_code = 0
	}).

-define(CMD_U2GS_getAccompanyCheck,47531).
-record(pk_U2GS_getAccompanyCheck,{
	type = 0,
	content = 0
	}).

-define(CMD_GS2U_getAccompanyCheckResult,38398).
-record(pk_GS2U_getAccompanyCheckResult,{
	type = 0,
	content = 0,
	state = 0,
	now_progress = 0,
	total_progress = 0
	}).

-define(CMD_dg_statue_info,56755).
-record(pk_dg_statue_info,{
	dg_id = 0,
	statue_id = 0,
	level = 0
	}).

-define(CMD_GS2U_dg_statue_push_info,38891).
-record(pk_GS2U_dg_statue_push_info,{
	pos_list = []
	}).

-define(CMD_U2GS_dg_statue_equip,4507).
-record(pk_U2GS_dg_statue_equip,{
	uid_list = []
	}).

-define(CMD_GS2U_dg_statue_equip_ret,62272).
-record(pk_GS2U_dg_statue_equip_ret,{
	err_code = 0
	}).

-define(CMD_U2GS_dg_statue_awaken,61051).
-record(pk_U2GS_dg_statue_awaken,{
	dg_id = 0,
	add_level = 0
	}).

-define(CMD_GS2U_dg_statue_awaken_ret,29178).
-record(pk_GS2U_dg_statue_awaken_ret,{
	dg_id = 0,
	level = 0,
	err_code = 0
	}).

-define(CMD_U2GS_dg_statue_break_down,30670).
-record(pk_U2GS_dg_statue_break_down,{
	eq_uid_list = []
	}).

-define(CMD_GS2U_dg_statue_break_down_ret,23524).
-record(pk_GS2U_dg_statue_break_down_ret,{
	err_code = 0
	}).

-define(CMD_U2GS_synthesize_dg_statue,15307).
-record(pk_U2GS_synthesize_dg_statue,{
	id = 0,
	type2 = 0,
	type3 = 0,
	type4 = 0,
	type5 = 0,
	base_cost = []
	}).

-define(CMD_GS2U_synthesize_dg_statue_ret,63494).
-record(pk_GS2U_synthesize_dg_statue_ret,{
	id = 0,
	type2 = 0,
	type3 = 0,
	type4 = 0,
	type5 = 0,
	cfg_id = 0,
	bind = 0,
	suc_times = 0,
	err_code = 0
	}).

-define(CMD_GS2U_synthesize_dg_statue_suc_times,59447).
-record(pk_GS2U_synthesize_dg_statue_suc_times,{
	suc_times_list = []
	}).

-define(CMD_DungeonPetInfo,44913).
-record(pk_DungeonPetInfo,{
	dungeon_id = 0,
	star = 0,
	stars_index_list = []
	}).

-define(CMD_DungeonPetGroupInfo,6441).
-record(pk_DungeonPetGroupInfo,{
	chapter_id = 0,
	box_list = [],
	dungeon_list = []
	}).

-define(CMD_U2GS_GetDungeonPetInfo,12209).
-record(pk_U2GS_GetDungeonPetInfo,{
	}).

-define(CMD_GS2U_GetDungeonPetInfoRet,27074).
-record(pk_GS2U_GetDungeonPetInfoRet,{
	reduce_time = 0,
	max_time = 0,
	group_list = []
	}).

-define(CMD_U2GS_EnterDungeonPet,34751).
-record(pk_U2GS_EnterDungeonPet,{
	dungeon_id = 0
	}).

-define(CMD_GS2U_DungeonPetResult,1771).
-record(pk_GS2U_DungeonPetResult,{
	dungeon_id = 0,
	cur_star = 0,
	is_open_next = false,
	exp = 0,
	coin_list = [],
	item_list = [],
	eq_list = []
	}).

-define(CMD_U2GS_MopUpDungeonPet,34836).
-record(pk_U2GS_MopUpDungeonPet,{
	chapter_id = 0
	}).

-define(CMD_GS2U_MopUpDungeonPetRet,7067).
-record(pk_GS2U_MopUpDungeonPetRet,{
	err_code = 0,
	chapter_id = 0,
	remain_time = 0,
	buy_time = 0,
	coin_list = [],
	item_list = [],
	double_times = 0,
	exp = 0
	}).

-define(CMD_U2GS_GetDungeonPetStarAward,39693).
-record(pk_U2GS_GetDungeonPetStarAward,{
	chapter_id = 0,
	box_id = 0
	}).

-define(CMD_GS2U_GetDungeonPetStarAwardRet,4406).
-record(pk_GS2U_GetDungeonPetStarAwardRet,{
	err_code = 0,
	chapter_id = 0,
	box_id = 0,
	box_list = [],
	coin_list = [],
	item_list = []
	}).

-define(CMD_FirstDownInfo,19762).
-record(pk_FirstDownInfo,{
	dungeon_id = 0,
	first_player = ""
	}).

-define(CMD_U2GS_GetFirstDownInfo,36379).
-record(pk_U2GS_GetFirstDownInfo,{
	chapter = 0,
	dungeon_list = []
	}).

-define(CMD_GS2U_GetFirstDownInfoRet,41380).
-record(pk_GS2U_GetFirstDownInfoRet,{
	chapter = 0,
	down_list = []
	}).

-define(CMD_GS2U_GetFirstDownInfoUpdate,39248).
-record(pk_GS2U_GetFirstDownInfoUpdate,{
	down_list = []
	}).

-define(CMD_dg_weapon_info,25446).
-record(pk_dg_weapon_info,{
	dg_id = 0,
	weapon1 = 0,
	weapon2 = 0
	}).

-define(CMD_GS2U_dg_weapon_push_info,19216).
-record(pk_GS2U_dg_weapon_push_info,{
	weapon_list = []
	}).

-define(CMD_U2GS_dg_weapon_equip,22733).
-record(pk_U2GS_dg_weapon_equip,{
	eq_uid_list = []
	}).

-define(CMD_GS2U_dg_weapon_equip_ret,42596).
-record(pk_GS2U_dg_weapon_equip_ret,{
	err_code = 0,
	equip_ret = [],
	equip_list = [],
	unload_list = []
	}).

-define(CMD_U2GS_add_weapon_star,39670).
-record(pk_U2GS_add_weapon_star,{
	weapon_id = 0
	}).

-define(CMD_GS2U_add_weapon_star_ret,37652).
-record(pk_GS2U_add_weapon_star_ret,{
	weapon_id = 0,
	star = 0,
	error = 0
	}).

-define(CMD_U2GS_fade_dragon_weapon,58166).
-record(pk_U2GS_fade_dragon_weapon,{
	weapon_list = []
	}).

-define(CMD_GS2U_fade_dragon_weapon_ret,39394).
-record(pk_GS2U_fade_dragon_weapon_ret,{
	del_list = [],
	item_list = [],
	error = 0
	}).

-define(CMD_GS2U_weapon_star_sync,42413).
-record(pk_GS2U_weapon_star_sync,{
	item_list = []
	}).

-define(CMD_GS2U_weapon_star_refresh,53294).
-record(pk_GS2U_weapon_star_refresh,{
	item_list = []
	}).

-define(CMD_bag_item,65289).
-record(pk_bag_item,{
	bag_id = 0,
	item_uid = 0,
	amount = 0
	}).

-define(CMD_bag_item2,14993).
-record(pk_bag_item2,{
	cfg_id = 0,
	amount = 0
	}).

-define(CMD_U2GS_QuickSynthesize,27581).
-record(pk_U2GS_QuickSynthesize,{
	bag_id = 0,
	item_uid = 0,
	materials = []
	}).

-define(CMD_GS2U_QuickSynthesizeRet,62180).
-record(pk_GS2U_QuickSynthesizeRet,{
	err_code = 0,
	bag_id = 0,
	item_uid = 0
	}).

-define(CMD_U2GS_QuickSynthesizeRing,7628).
-record(pk_U2GS_QuickSynthesizeRing,{
	role_id = 0,
	item_uid = 0,
	materials = []
	}).

-define(CMD_GS2U_QuickSynthesizeRingRet,5937).
-record(pk_GS2U_QuickSynthesizeRingRet,{
	role_id = 0,
	item_uid = 0,
	err_code = 0
	}).

-define(CMD_U2GS_QuickSynthesizeSoulStone,7703).
-record(pk_U2GS_QuickSynthesizeSoulStone,{
	bag_id = 0,
	item_uid = 0,
	materials = []
	}).

-define(CMD_GS2U_QuickSynthesizeSoulStoneRet,10261).
-record(pk_GS2U_QuickSynthesizeSoulStoneRet,{
	err_code = 0,
	bag_id = 0,
	item_uid = 0
	}).

-define(CMD_U2GS_QuickSynthesizeGoldContract,45351).
-record(pk_U2GS_QuickSynthesizeGoldContract,{
	type2 = 0,
	type5 = 0,
	uidlist = []
	}).

-define(CMD_GS2U_QuickSynthesizeGoldContractRet,11930).
-record(pk_GS2U_QuickSynthesizeGoldContractRet,{
	err_code = 0,
	type2 = 0,
	type5 = 0,
	itemList = []
	}).

-define(CMD_U2GS_QuickSynthesizeAltarStone,51831).
-record(pk_U2GS_QuickSynthesizeAltarStone,{
	bag_id = 0,
	item_uid = 0,
	materials = []
	}).

-define(CMD_GS2U_QuickSynthesizeAltarStoneRet,45914).
-record(pk_GS2U_QuickSynthesizeAltarStoneRet,{
	err_code = 0,
	bag_id = 0,
	item_uid = 0
	}).

-define(CMD_U2GS_QuickSynthesizeShengWen,32663).
-record(pk_U2GS_QuickSynthesizeShengWen,{
	type2 = 0,
	type5 = 0,
	materials = []
	}).

-define(CMD_GS2U_QuickSynthesizeShengWenRet,28536).
-record(pk_GS2U_QuickSynthesizeShengWenRet,{
	err_code = 0,
	type2 = 0,
	type5 = 0,
	cfg_id = 0
	}).

-define(CMD_U2GS_QuickSynthesizeConstellationEq,26682).
-record(pk_U2GS_QuickSynthesizeConstellationEq,{
	id = 0,
	type2 = 0,
	type3 = 0,
	type4 = 0,
	type5 = 0,
	uidlist = []
	}).

-define(CMD_GS2U_QuickSynthesizeConstellationEqRet,15094).
-record(pk_GS2U_QuickSynthesizeConstellationEqRet,{
	err_code = 0,
	id = 0,
	type2 = 0,
	type3 = 0,
	type4 = 0,
	type5 = 0,
	itemList = []
	}).

-define(CMD_U2GS_QuickSynthesizePetBlessEq,62012).
-record(pk_U2GS_QuickSynthesizePetBlessEq,{
	id = 0,
	type2 = 0,
	type3 = 0,
	type4 = 0,
	type5 = 0,
	uidlist = []
	}).

-define(CMD_GS2U_QuickSynthesizePetBlessEqRet,62940).
-record(pk_GS2U_QuickSynthesizePetBlessEqRet,{
	err_code = 0,
	id = 0,
	type2 = 0,
	type3 = 0,
	type4 = 0,
	type5 = 0,
	itemList = []
	}).

-define(CMD_dg_eq_pos_info,8215).
-record(pk_dg_eq_pos_info,{
	dg_id = 0,
	equip = [],
	skill = [],
	is_complete = 0
	}).

-define(CMD_GS2U_dg_eq_pos_push_info,6767).
-record(pk_GS2U_dg_eq_pos_push_info,{
	eq_pos_list = []
	}).

-define(CMD_GS2U_dg_eq_star_info_ret,45285).
-record(pk_GS2U_dg_eq_star_info_ret,{
	star_list = []
	}).

-define(CMD_U2GS_dg_eq_pos_eq_active,25089).
-record(pk_U2GS_dg_eq_pos_eq_active,{
	dg_id = 0,
	pos = 0
	}).

-define(CMD_GS2U_dg_eq_pos_eq_active_ret,12550).
-record(pk_GS2U_dg_eq_pos_eq_active_ret,{
	dg_id = 0,
	pos = 0,
	err_code = 0
	}).

-define(CMD_U2GS_dg_eq_pos_skill_active,38882).
-record(pk_U2GS_dg_eq_pos_skill_active,{
	dg_id = 0,
	num = 0
	}).

-define(CMD_GS2U_dg_eq_pos_skill_active_ret,17058).
-record(pk_GS2U_dg_eq_pos_skill_active_ret,{
	dg_id = 0,
	num = 0,
	err_code = 0
	}).

-define(CMD_U2GS_dg_eq_pos_eq_star_up,8696).
-record(pk_U2GS_dg_eq_pos_eq_star_up,{
	dg_id = 0,
	pos = 0
	}).

-define(CMD_GS2U_dg_eq_pos_eq_star_up_ret,14301).
-record(pk_GS2U_dg_eq_pos_eq_star_up_ret,{
	dg_id = 0,
	pos = 0,
	err_code = 0
	}).

-define(CMD_U2GS_skill_choose,24405).
-record(pk_U2GS_skill_choose,{
	role_id = 0,
	type = 0,
	id = 0
	}).

-define(CMD_GS2U_skill_choose_ret,56502).
-record(pk_GS2U_skill_choose_ret,{
	role_id = 0,
	type = 0,
	skill_list = []
	}).

-define(CMD_DungeonBpHistory,40245).
-record(pk_DungeonBpHistory,{
	itemID = 0,
	count = 0,
	bind = 0,
	is_equip = false,
	quality = 0,
	star = 0
	}).

-define(CMD_DungeonBpStc,19023).
-record(pk_DungeonBpStc,{
	id = 0,
	open_day = 0,
	join_times = 0,
	condition_times = 0,
	award_times = 0,
	advance_state = 0,
	period_end_time = 0,
	history_award_list = []
	}).

-define(CMD_GS2U_dungeon_bp_info_update,15304).
-record(pk_GS2U_dungeon_bp_info_update,{
	info_list = []
	}).

-define(CMD_U2GS_dungeon_bp_buy,25737).
-record(pk_U2GS_dungeon_bp_buy,{
	id = 0
	}).

-define(CMD_GS2U_dungeon_bp_buy_ret,24035).
-record(pk_GS2U_dungeon_bp_buy_ret,{
	id = 0,
	err_code = 0
	}).

-define(CMD_U2GS_dungeon_bp_award,18780).
-record(pk_U2GS_dungeon_bp_award,{
	id = 0
	}).

-define(CMD_GS2U_dungeon_bp_award_ret,27951).
-record(pk_GS2U_dungeon_bp_award_ret,{
	id = 0,
	err_code = 0
	}).

-define(CMD_GS2U_AutoDungeonInfo,56443).
-record(pk_GS2U_AutoDungeonInfo,{
	dungeonId = 0
	}).

-define(CMD_GS2U_AutoDungeonBlessInfo,9655).
-record(pk_GS2U_AutoDungeonBlessInfo,{
	blessList = [],
	blessPoolList = []
	}).

-define(CMD_GS2U_AutoDungeonReward,16351).
-record(pk_GS2U_AutoDungeonReward,{
	dungeonId = 0,
	newDungeonId = 0,
	blessId = 0,
	itemList = [],
	equipmentList = [],
	coinList = [],
	exp = 0,
	isSecondKill = false
	}).

-define(CMD_U2GS_AutoDungeonUnlockBlessPos,45883).
-record(pk_U2GS_AutoDungeonUnlockBlessPos,{
	pos = 0
	}).

-define(CMD_GS2U_AutoDungeonUnlockBlessPosRet,17030).
-record(pk_GS2U_AutoDungeonUnlockBlessPosRet,{
	error = 0,
	pos = 0
	}).

-define(CMD_U2GS_AutoDungeonBless,25249).
-record(pk_U2GS_AutoDungeonBless,{
	}).

-define(CMD_GS2U_AutoDungeonBlessRet,12574).
-record(pk_GS2U_AutoDungeonBlessRet,{
	error = 0,
	blessId = 0
	}).

-define(CMD_U2GS_AutoDungeonGetBless,64363).
-record(pk_U2GS_AutoDungeonGetBless,{
	pos = 0,
	newBless = 0
	}).

-define(CMD_GS2U_AutoDungeonGetBlessRet,37157).
-record(pk_GS2U_AutoDungeonGetBlessRet,{
	pos = 0,
	newBless = 0,
	deleteBless = 0,
	error = 0
	}).

-define(CMD_U2GS_AutoDungeonGetBlessInPool,38208).
-record(pk_U2GS_AutoDungeonGetBlessInPool,{
	pos = 0,
	bless = 0
	}).

-define(CMD_GS2U_AutoDungeonGetBlessInPoolRet,11070).
-record(pk_GS2U_AutoDungeonGetBlessInPoolRet,{
	pos = 0,
	bless = 0,
	error = 0
	}).

-define(CMD_U2GS_AutoDungeonDeleteBless,35934).
-record(pk_U2GS_AutoDungeonDeleteBless,{
	pos = 0
	}).

-define(CMD_GS2U_AutoDungeonDeleteBlessRet,41340).
-record(pk_GS2U_AutoDungeonDeleteBlessRet,{
	pos = 0,
	error = 0
	}).

-define(CMD_U2GS_MonsterDrop,23472).
-record(pk_U2GS_MonsterDrop,{
	}).

-define(CMD_U2GS_MirrorTeamAdd,32755).
-record(pk_U2GS_MirrorTeamAdd,{
	num = 0,
	playerIdList1 = [],
	playerIdList2 = []
	}).

-define(CMD_GS2U_MirrorTeamAdd,24918).
-record(pk_GS2U_MirrorTeamAdd,{
	errorCode = 0,
	playerList = [],
	objectFixList = []
	}).

-define(CMD_U2GS_MirrorTeamUpdate,48784).
-record(pk_U2GS_MirrorTeamUpdate,{
	playerIdList = []
	}).

-define(CMD_GS2U_MirrorTeamUpdate,13846).
-record(pk_GS2U_MirrorTeamUpdate,{
	errorCode = 0,
	playerList = [],
	objectFixList = []
	}).

-define(CMD_GS2U_game_fcm_notice,3652).
-record(pk_GS2U_game_fcm_notice,{
	type = 0,
	useTime = 0,
	maxTime = 0
	}).

-define(CMD_GS2U_game_fcm_info,24875).
-record(pk_GS2U_game_fcm_info,{
	monthly_recharge = 0,
	useTime = 0,
	maxTime = 0,
	rechargeList = [],
	dailyLoginLimit = #pk_key_value{},
	funcswitch = [],
	timeLimit = #pk_key_value{}
	}).

-define(CMD_U2GS_game_fcm_age,14746).
-record(pk_U2GS_game_fcm_age,{
	age = 0
	}).

-define(CMD_U2GS_TryGetMultiplePlayer,19060).
-record(pk_U2GS_TryGetMultiplePlayer,{
	}).

-define(CMD_GS2U_TryGetMultiplePlayerRet,40511).
-record(pk_GS2U_TryGetMultiplePlayerRet,{
	errorCode = 0,
	playerList = [],
	objectFixList = []
	}).

-define(CMD_U2GS_MultiplePlayerReborn,56500).
-record(pk_U2GS_MultiplePlayerReborn,{
	type = 0,
	reviveID = 0,
	roleID = 0
	}).

-define(CMD_GS2U_MultiplePlayerRebornRet,61012).
-record(pk_GS2U_MultiplePlayerRebornRet,{
	result = 0,
	playerID = 0,
	roleID = 0,
	x = 0,
	y = 0,
	reviveID = 0
	}).

-define(CMD_DemonSeasonTopStc,43052).
-record(pk_DemonSeasonTopStc,{
	playerId = 0,
	rank = 0,
	name = "",
	sex = 0,
	career = 0,
	headID = 0,
	frame = 0,
	star_num = 0,
	chapter = 0,
	order = 0
	}).

-define(CMD_U2GS_DemonSeason,39958).
-record(pk_U2GS_DemonSeason,{
	}).

-define(CMD_GS2U_DemonSeasonRet,15101).
-record(pk_GS2U_DemonSeasonRet,{
	season_id = 0,
	season_index = 0,
	open_time = 0,
	next_time = 0,
	my_star_num = 0,
	my_chapter = 0,
	my_order = 0,
	max_star_num = 0,
	max_chapter = 0,
	max_order = 0,
	top3_list = [],
	my_rank = 0
	}).

-define(CMD_GS2U_DemonSeasonEndSync,63162).
-record(pk_GS2U_DemonSeasonEndSync,{
	season_id = 0,
	season_index = 0,
	top_star_num = 0,
	top_chapter = 0,
	top_order = 0,
	top_player_info = #pk_playerModelUI{},
	my_chapter = 0,
	my_order = 0,
	my_star_num = 0,
	my_percent = 0,
	notice_type = 0
	}).

-define(CMD_U2GS_getDungeonTopModel,60798).
-record(pk_U2GS_getDungeonTopModel,{
	type = 0
	}).

-define(CMD_GS2U_getDungeonTopModelRet,7861).
-record(pk_GS2U_getDungeonTopModelRet,{
	type = 0,
	topPlayers = []
	}).

-define(CMD_GS2U_DemonSeasonReawrdStageChange,36730).
-record(pk_GS2U_DemonSeasonReawrdStageChange,{
	}).

-define(CMD_U2GS_HideStatus,40135).
-record(pk_U2GS_HideStatus,{
	hideStatus = false
	}).

-define(CMD_GS2U_HideStatus,31831).
-record(pk_GS2U_HideStatus,{
	hideStatus = false
	}).

-define(CMD_U2GS_ClientDungeonsEnter,42520).
-record(pk_U2GS_ClientDungeonsEnter,{
	dungeon_id = 0,
	is_second_kill = false
	}).

-define(CMD_GS2U_ClientDungeonsEnterRet,39151).
-record(pk_GS2U_ClientDungeonsEnterRet,{
	dungeon_id = 0,
	error_code = 0,
	is_second_kill = false
	}).

-define(CMD_U2GS_ClientDungeonsSucceed,29315).
-record(pk_U2GS_ClientDungeonsSucceed,{
	dungeon_id = 0
	}).

-define(CMD_GS2U_ClientDungeonsSucceedRet,45783).
-record(pk_GS2U_ClientDungeonsSucceedRet,{
	dungeon_id = 0,
	error_code = 0
	}).

-define(CMD_U2GS_quick_hang_get_info,54721).
-record(pk_U2GS_quick_hang_get_info,{
	}).

-define(CMD_GS2U_quick_hang_get_info_ret,49549).
-record(pk_GS2U_quick_hang_get_info_ret,{
	exp = 0,
	level = 0,
	total_times = 0
	}).

-define(CMD_U2GS_ClientDungeonsFail,24071).
-record(pk_U2GS_ClientDungeonsFail,{
	dungeon_id = 0
	}).

-define(CMD_GS2U_ClientDungeonsFailRet,55441).
-record(pk_GS2U_ClientDungeonsFailRet,{
	dungeon_id = 0,
	error_code = 0
	}).

-define(CMD_chartPlayer,45699).
-record(pk_chartPlayer,{
	ui_info = #pk_playerModelUI{},
	rank = 0,
	value = 0,
	customInt = [],
	time = 0,
	worship_times = 0
	}).

-define(CMD_U2GS_getChart,48387).
-record(pk_U2GS_getChart,{
	type = 0,
	shift = 0
	}).

-define(CMD_GS2U_getChartRet,54966).
-record(pk_GS2U_getChartRet,{
	type = 0,
	shift = 0,
	err_code = 0,
	remain_num = 0,
	my_rank = 0,
	top_list = []
	}).

-define(CMD_GS2U_sendWorshipList,37434).
-record(pk_GS2U_sendWorshipList,{
	worship_list = []
	}).

-define(CMD_role_pill,34302).
-record(pk_role_pill,{
	role_id = 0,
	pill_list = []
	}).

-define(CMD_GS2U_send_all_pill_info,10977).
-record(pk_GS2U_send_all_pill_info,{
	role_pill_list = []
	}).

-define(CMD_U2GS_use_pill_req,23290).
-record(pk_U2GS_use_pill_req,{
	role_id = 0,
	item_list = []
	}).

-define(CMD_GS2U_use_pill_ret,64026).
-record(pk_GS2U_use_pill_ret,{
	role_id = 0,
	item_list = [],
	err_code = 0
	}).

-define(CMD_reincarnate_help_record,8869).
-record(pk_reincarnate_help_record,{
	name = "",
	sex = 0,
	head_id = 0,
	frame_id = 0,
	times = 0
	}).

-define(CMD_U2GS_reincarnate_info_req,52086).
-record(pk_U2GS_reincarnate_info_req,{
	}).

-define(CMD_GS2U_reincarnate_info_sync,45740).
-record(pk_GS2U_reincarnate_info_sync,{
	rein_lv = 0,
	stage = 0,
	point = 0,
	state = 0,
	personal_suppress = 0,
	union_suppress = 0,
	seeker_help_times = 0,
	self_suppress_times = 0,
	last_suppress_time = 0,
	seal_end_time = 0,
	help_record = []
	}).

-define(CMD_U2GS_reincarnate_accept,55026).
-record(pk_U2GS_reincarnate_accept,{
	rein_lv = 0
	}).

-define(CMD_GS2U_reincarnate_accept_ret,51111).
-record(pk_GS2U_reincarnate_accept_ret,{
	rein_lv = 0,
	err_code = 0
	}).

-define(CMD_U2GS_reincarnate_next,58426).
-record(pk_U2GS_reincarnate_next,{
	}).

-define(CMD_GS2U_reincarnate_next_ret,8589).
-record(pk_GS2U_reincarnate_next_ret,{
	rein_lv = 0,
	stage = 0,
	err_code = 0
	}).

-define(CMD_U2GS_reincarnate_requeset_suppress,44402).
-record(pk_U2GS_reincarnate_requeset_suppress,{
	type = 0
	}).

-define(CMD_GS2U_reincarnate_requeset_suppress_ret,16580).
-record(pk_GS2U_reincarnate_requeset_suppress_ret,{
	type = 0,
	err_code = 0
	}).

-define(CMD_GS2U_reincarnate_suppress_msg,56510).
-record(pk_GS2U_reincarnate_suppress_msg,{
	player_id = 0,
	name = "",
	sex = 0,
	rein_lv = 0
	}).

-define(CMD_U2GS_reincarnate_help_suppress,12522).
-record(pk_U2GS_reincarnate_help_suppress,{
	player_id = 0,
	rein_lv = 0
	}).

-define(CMD_GS2U_reincarnate_help_suppress_ret,13686).
-record(pk_GS2U_reincarnate_help_suppress_ret,{
	err_code = 0
	}).

-define(CMD_U2GS_reincarnate_enter_map,39715).
-record(pk_U2GS_reincarnate_enter_map,{
	map_data_id = 0
	}).

-define(CMD_GS2U_reincarnate_enter_map_ret,9117).
-record(pk_GS2U_reincarnate_enter_map_ret,{
	map_data_id = 0,
	err_code = 0
	}).

-define(CMD_eliteDungeonInfo,62153).
-record(pk_eliteDungeonInfo,{
	group_id = 0,
	pass_info = [],
	progress_reward_info = [],
	bp_reward = []
	}).

-define(CMD_GS2U_EliteDungeonInfoList,1777).
-record(pk_GS2U_EliteDungeonInfoList,{
	info_list = []
	}).

-define(CMD_GS2U_UpdateSingleEliteDungeonInfo,1677).
-record(pk_GS2U_UpdateSingleEliteDungeonInfo,{
	info_list = []
	}).

-define(CMD_U2GS_EliteDungeonEnter,35485).
-record(pk_U2GS_EliteDungeonEnter,{
	group_id = 0,
	dungeon_id = 0
	}).

-define(CMD_GS2U_EliteDungeonEnterRet,34747).
-record(pk_GS2U_EliteDungeonEnterRet,{
	group_id = 0,
	dungeon_id = 0,
	error_code = 0
	}).

-define(CMD_GS2U_EliteDungeonResult,25005).
-record(pk_GS2U_EliteDungeonResult,{
	dungeon_id = 0,
	is_win = false,
	old_star = 0,
	new_star = 0
	}).

-define(CMD_U2GS_EliteDungeonProgressReward,22436).
-record(pk_U2GS_EliteDungeonProgressReward,{
	bp_group = 0,
	group_id = 0,
	reward_id = 0,
	ext_data = []
	}).

-define(CMD_GS2U_EliteDungeonProgressRewardRet,38116).
-record(pk_GS2U_EliteDungeonProgressRewardRet,{
	bp_group = 0,
	group_id = 0,
	reward_id = 0,
	ext_data = [],
	error_code = 0
	}).

-define(CMD_U2GS_EliteDungeonBpBuy,29464).
-record(pk_U2GS_EliteDungeonBpBuy,{
	bp_group = 0
	}).

-define(CMD_U2GS_EliteDungeonBpBuyRet,8449).
-record(pk_U2GS_EliteDungeonBpBuyRet,{
	bp_group = 0,
	error_code = 0
	}).

-define(CMD_trading_goods,18292).
-record(pk_trading_goods,{
	goods_id = 0,
	item_id = 0,
	item_character = 0,
	item_star = 0,
	item_amount = 0,
	price_buy = 0,
	expire_time = 0
	}).

-define(CMD_trading_item_bag,6863).
-record(pk_trading_item_bag,{
	bag_id = 0,
	bag_item_id = 0,
	item_amount = 0
	}).

-define(CMD_U2GS_trading_goods_list,7598).
-record(pk_U2GS_trading_goods_list,{
	num_per_page = 0,
	item_id_list = [],
	item_type = 0,
	detailed_type = 0,
	detailed_type2 = 0,
	detailed_type3 = 0,
	item_character = 0,
	item_star = 0,
	item_order = 0,
	rank_price = 0,
	shift = 0,
	has_stock = 0,
	trade_type = 0
	}).

-define(CMD_GS2U_trading_goods_list_ret,19601).
-record(pk_GS2U_trading_goods_list_ret,{
	error = 0,
	shift = 0,
	goods_remain_num = 0,
	goods_list = []
	}).

-define(CMD_U2GS_trading_item_goods_on_shelves_onekey,41059).
-record(pk_U2GS_trading_item_goods_on_shelves_onekey,{
	item_list = [],
	trade_type = 0
	}).

-define(CMD_U2GS_trading_item_goods_on_shelves,39251).
-record(pk_U2GS_trading_item_goods_on_shelves,{
	bag_id = 0,
	bag_item_id = 0,
	item_amount = 0,
	trade_type = 0
	}).

-define(CMD_GS2U_trading_item_goods_on_shelves_ret,34810).
-record(pk_GS2U_trading_item_goods_on_shelves_ret,{
	error = 0
	}).

-define(CMD_U2GS_trading_item_goods_again_on_shelves,18635).
-record(pk_U2GS_trading_item_goods_again_on_shelves,{
	goods_id = 0,
	trade_type = 0
	}).

-define(CMD_GS2U_trading_item_goods_again_on_shelves_ret,37832).
-record(pk_GS2U_trading_item_goods_again_on_shelves_ret,{
	goods_id = 0,
	trade_type = 0,
	error = 0
	}).

-define(CMD_U2GS_trading_item_goods_off_shelves,53781).
-record(pk_U2GS_trading_item_goods_off_shelves,{
	goods_id = 0
	}).

-define(CMD_GS2U_trading_item_goods_off_shelves_ret,51185).
-record(pk_GS2U_trading_item_goods_off_shelves_ret,{
	goods_id = 0,
	error = 0
	}).

-define(CMD_trading_item_goods_shelves,6217).
-record(pk_trading_item_goods_shelves,{
	goods_id = 0,
	item_id = 0,
	item_character = 0,
	item_star = 0,
	state = 0,
	num = 0,
	sell_num = 0,
	time = 0,
	trade_type = 0
	}).

-define(CMD_U2GS_trading_item_my_shelves,25496).
-record(pk_U2GS_trading_item_my_shelves,{
	}).

-define(CMD_GS2U_trading_item_my_shelves_ret,53145).
-record(pk_GS2U_trading_item_my_shelves_ret,{
	list = []
	}).

-define(CMD_U2GS_trading_goods_buy,53229).
-record(pk_U2GS_trading_goods_buy,{
	goods_id = 0,
	amount = 0,
	currency_type = 0,
	currency_num = 0,
	trade_type = 0
	}).

-define(CMD_GS2U_trading_goods_buy_ret,17224).
-record(pk_GS2U_trading_goods_buy_ret,{
	error = 0,
	goods_id = 0,
	num = 0,
	trade_type = 0
	}).

-define(CMD_trading_goods_watch,2747).
-record(pk_trading_goods_watch,{
	item_id = 0,
	item_character = 0,
	item_star = 0
	}).

-define(CMD_U2GS_trading_goods_watch_list,6552).
-record(pk_U2GS_trading_goods_watch_list,{
	}).

-define(CMD_GS2U_trading_goods_watch_list_ret,44033).
-record(pk_GS2U_trading_goods_watch_list_ret,{
	error = 0,
	watch_list = []
	}).

-define(CMD_U2GS_trading_goods_watch_add,6000).
-record(pk_U2GS_trading_goods_watch_add,{
	watch_list = []
	}).

-define(CMD_GS2U_trading_goods_watch_add_ret,598).
-record(pk_GS2U_trading_goods_watch_add_ret,{
	error = 0,
	watch_list = []
	}).

-define(CMD_U2GS_trading_goods_watch_remove,26939).
-record(pk_U2GS_trading_goods_watch_remove,{
	watch_list = []
	}).

-define(CMD_GS2U_trading_goods_watch_remove_ret,27177).
-record(pk_GS2U_trading_goods_watch_remove_ret,{
	error = 0,
	watch_list = []
	}).

-define(CMD_GS2U_trading_goods_watch_notice,45531).
-record(pk_GS2U_trading_goods_watch_notice,{
	goods_id = 0,
	item_id = 0,
	item_character = 0,
	item_star = 0,
	trade_type = 0
	}).

-define(CMD_U2GS_trading_goods_exsit_check,5215).
-record(pk_U2GS_trading_goods_exsit_check,{
	goods_id_list = []
	}).

-define(CMD_GS2U_trading_goods_exsit_check_ret,49436).
-record(pk_GS2U_trading_goods_exsit_check_ret,{
	is_exsit = false
	}).

-define(CMD_trading_goods_history,7987).
-record(pk_trading_goods_history,{
	item_id = 0,
	item_character = 0,
	item_star = 0,
	item_amount = 0,
	currency_type = 0,
	finish_price = 0,
	player_name = "",
	player_sex = 0,
	time = 0,
	trade_type = 0
	}).

-define(CMD_U2GS_trading_goods_history_list,19190).
-record(pk_U2GS_trading_goods_history_list,{
	label_type = 0
	}).

-define(CMD_GS2U_trading_goods_history_list,29373).
-record(pk_GS2U_trading_goods_history_list,{
	label_type = 0,
	error = 0,
	history_list = []
	}).

-define(CMD_U2GS_trading_gold_goods_list,32945).
-record(pk_U2GS_trading_gold_goods_list,{
	}).

-define(CMD_GS2U_trading_gold_goods_list_ret,42883).
-record(pk_GS2U_trading_gold_goods_list_ret,{
	list = []
	}).

-define(CMD_trading_gold_goods_shelves,50496).
-record(pk_trading_gold_goods_shelves,{
	goods_id = 0,
	state = 0,
	price = 0,
	num = 0,
	sell_num = 0,
	time = 0
	}).

-define(CMD_U2GS_trading_gold_my_shelves,8342).
-record(pk_U2GS_trading_gold_my_shelves,{
	}).

-define(CMD_GS2U_trading_gold_my_shelves_ret,46463).
-record(pk_GS2U_trading_gold_my_shelves_ret,{
	list = []
	}).

-define(CMD_U2GS_trading_gold_goods_buy,20881).
-record(pk_U2GS_trading_gold_goods_buy,{
	price = 0,
	num = 0,
	is_server = 0
	}).

-define(CMD_GS2U_trading_gold_goods_buy_ret,64868).
-record(pk_GS2U_trading_gold_goods_buy_ret,{
	price = 0,
	num = 0,
	is_server = 0,
	error = 0
	}).

-define(CMD_U2GS_trading_gold_goods_on_shelves,38054).
-record(pk_U2GS_trading_gold_goods_on_shelves,{
	num = 0,
	price = 0
	}).

-define(CMD_GS2U_trading_gold_goods_on_shelves_ret,45385).
-record(pk_GS2U_trading_gold_goods_on_shelves_ret,{
	num = 0,
	price = 0,
	error = 0
	}).

-define(CMD_U2GS_trading_gold_goods_again_on_shelves,27444).
-record(pk_U2GS_trading_gold_goods_again_on_shelves,{
	goods_id = 0,
	price = 0
	}).

-define(CMD_GS2U_trading_gold_goods_again_on_shelves_ret,38000).
-record(pk_GS2U_trading_gold_goods_again_on_shelves_ret,{
	goods_id = 0,
	price = 0,
	error = 0
	}).

-define(CMD_U2GS_trading_gold_goods_off_shelves,48526).
-record(pk_U2GS_trading_gold_goods_off_shelves,{
	goods_id = 0
	}).

-define(CMD_GS2U_trading_gold_goods_off_shelves_ret,28388).
-record(pk_GS2U_trading_gold_goods_off_shelves_ret,{
	goods_id = 0,
	error = 0
	}).

-define(CMD_U2GS_trading_gold_goods_price,34511).
-record(pk_U2GS_trading_gold_goods_price,{
	}).

-define(CMD_GS2U_trading_gold_goods_price_ret,16919).
-record(pk_GS2U_trading_gold_goods_price_ret,{
	price = 0
	}).

-define(CMD_U2GS_trading_gold_price_trend,12013).
-record(pk_U2GS_trading_gold_price_trend,{
	}).

-define(CMD_GS2U_trading_gold_price_trend_ret,65035).
-record(pk_GS2U_trading_gold_price_trend_ret,{
	list = []
	}).

-define(CMD_U2GS_trading_goods_take_income,55298).
-record(pk_U2GS_trading_goods_take_income,{
	type = 0,
	goods_id = 0
	}).

-define(CMD_GS2U_trading_goods_take_income_ret,39390).
-record(pk_GS2U_trading_goods_take_income_ret,{
	type = 0,
	goods_id = 0,
	revenue = 0,
	error = 0
	}).

-define(CMD_U2GS_trading_goods_take_income_onekey,5017).
-record(pk_U2GS_trading_goods_take_income_onekey,{
	type = 0,
	goods_id_list = []
	}).

-define(CMD_GS2U_trading_goods_take_income_onekey_ret,4703).
-record(pk_GS2U_trading_goods_take_income_onekey_ret,{
	type = 0,
	goods_id_list = [],
	error = 0
	}).

-define(CMD_GS2U_trading_goods_take_income_red,43325).
-record(pk_GS2U_trading_goods_take_income_red,{
	type = 0
	}).

-define(CMD_bounty_task_unit,27684).
-record(pk_bounty_task_unit,{
	type = 0,
	id = 0,
	state = 0
	}).

-define(CMD_bounty_task,37630).
-record(pk_bounty_task,{
	task_id = 0,
	state = 0,
	begin_time = 0,
	unit_list = []
	}).

-define(CMD_U2GS_bounty_task_update_player_req,50005).
-record(pk_U2GS_bounty_task_update_player_req,{
	add_guide_task = false
	}).

-define(CMD_GS2U_bounty_task_update_player,24738).
-record(pk_GS2U_bounty_task_update_player,{
	task_list = [],
	is_special = 0,
	free_refresh_times = 0,
	pay_refresh_times = 0,
	used_dispatch_times = 0,
	accumulated_exp = 0,
	used_add_item_times = 0,
	include_guide_task = false,
	fail_times = 0,
	lock = false
	}).

-define(CMD_U2GS_bounty_task_unit_list_req,25519).
-record(pk_U2GS_bounty_task_unit_list_req,{
	}).

-define(CMD_GS2U_bounty_task_unit_list_ret,29522).
-record(pk_GS2U_bounty_task_unit_list_ret,{
	unit_list = []
	}).

-define(CMD_U2GS_bounty_task_dispatch_req,65113).
-record(pk_U2GS_bounty_task_dispatch_req,{
	task_id = 0,
	unit_list = []
	}).

-define(CMD_GS2U_bounty_task_dispatch_ret,63161).
-record(pk_GS2U_bounty_task_dispatch_ret,{
	task_id = 0,
	unit_list = [],
	err_code = 0
	}).

-define(CMD_U2GS_bounty_task_complete_req,49057).
-record(pk_U2GS_bounty_task_complete_req,{
	task_id = 0
	}).

-define(CMD_GS2U_bounty_task_complete_ret,47104).
-record(pk_GS2U_bounty_task_complete_ret,{
	task_id = 0,
	err_code = 0
	}).

-define(CMD_U2GS_bounty_task_refresh_req,44453).
-record(pk_U2GS_bounty_task_refresh_req,{
	type = 0
	}).

-define(CMD_GS2U_bounty_task_refresh_ret,64756).
-record(pk_GS2U_bounty_task_refresh_ret,{
	type = 0,
	err_code = 0
	}).

-define(CMD_U2GS_bounty_task_accelerate_req,32508).
-record(pk_U2GS_bounty_task_accelerate_req,{
	task_id = 0
	}).

-define(CMD_GS2U_bounty_task_accelerate_ret,54241).
-record(pk_GS2U_bounty_task_accelerate_ret,{
	task_id = 0,
	err_code = 0
	}).

-define(CMD_GS2U_bounty_task_update,56351).
-record(pk_GS2U_bounty_task_update,{
	is_red_point = 0,
	task_num = 0,
	is_special = 0,
	closest_task_time = 0
	}).

-define(CMD_U2GS_bounty_task_lock_req,559).
-record(pk_U2GS_bounty_task_lock_req,{
	target_lock = false
	}).

-define(CMD_GS2U_bounty_task_lock_ret,50986).
-record(pk_GS2U_bounty_task_lock_ret,{
	target_lock = false,
	err_code = 0
	}).

-define(CMD_GS2U_bounty_task_active_special_ret,55711).
-record(pk_GS2U_bounty_task_active_special_ret,{
	num = 0,
	exp = 0,
	err_code = 0
	}).

-define(CMD_collect_pos,21246).
-record(pk_collect_pos,{
	role_id = 0,
	order = 0,
	pos = 0,
	uid = 0,
	reborn_lv = 0,
	reborn_prop = []
	}).

-define(CMD_GS2U_collect_pos_info,16383).
-record(pk_GS2U_collect_pos_info,{
	pos_list = []
	}).

-define(CMD_U2GS_collect_equip_req,43227).
-record(pk_U2GS_collect_equip_req,{
	role_id = 0,
	is_equip = 0,
	order = 0,
	uid_list = []
	}).

-define(CMD_GS2U_collect_equip_ret,62360).
-record(pk_GS2U_collect_equip_ret,{
	role_id = 0,
	is_equip = 0,
	order = 0,
	pos_value_list = [],
	err_code = 0
	}).

-define(CMD_U2GS_collect_reborn_req,1555).
-record(pk_U2GS_collect_reborn_req,{
	role_id = 0,
	order = 0,
	pos = 0
	}).

-define(CMD_GS2U_collect_reborn_ret,5294).
-record(pk_GS2U_collect_reborn_ret,{
	role_id = 0,
	order = 0,
	pos = 0,
	err_code = 0
	}).

-define(CMD_GS2U_guide_dungeon_pass,50081).
-record(pk_GS2U_guide_dungeon_pass,{
	dungeon_id_list = []
	}).

-define(CMD_GS2U_god_ornament_update,44173).
-record(pk_GS2U_god_ornament_update,{
	role_id = 0,
	list = []
	}).

-define(CMD_U2GS_god_ornament_op,49150).
-record(pk_U2GS_god_ornament_op,{
	role_id = 0,
	op = 0,
	type = 0,
	order = 0
	}).

-define(CMD_GS2U_god_ornament_op_ret,16064).
-record(pk_GS2U_god_ornament_op_ret,{
	role_id = 0,
	op = 0,
	type = 0,
	order = 0,
	err_code = 0
	}).

-define(CMD_GS2U_active_book_skill,62392).
-record(pk_GS2U_active_book_skill,{
	item_id = []
	}).

-define(CMD_U2GS_card_equip_req,62631).
-record(pk_U2GS_card_equip_req,{
	role_id = 0,
	card_list = []
	}).

-define(CMD_GS2U_card_equip_ret,21296).
-record(pk_GS2U_card_equip_ret,{
	role_id = 0,
	success_list = [],
	fail_list = [],
	err_code = 0
	}).

-define(CMD_U2GS_card_combine_req,15524).
-record(pk_U2GS_card_combine_req,{
	card_num_list = []
	}).

-define(CMD_GS2U_card_combine_ret,57673).
-record(pk_GS2U_card_combine_ret,{
	card_num_list = [],
	get_card_num_list = [],
	err_code = 0
	}).

-define(CMD_U2GS_card_recast_req,2186).
-record(pk_U2GS_card_recast_req,{
	card_list = []
	}).

-define(CMD_GS2U_card_recast_ret,14661).
-record(pk_GS2U_card_recast_ret,{
	card_list = [],
	new_card_id = 0,
	err_code = 0
	}).

-define(CMD_U2GS_card_quick_combine_req,51748).
-record(pk_U2GS_card_quick_combine_req,{
	role_id = 0,
	hole_card_list = []
	}).

-define(CMD_GS2U_card_quick_combine_ret,35346).
-record(pk_GS2U_card_quick_combine_ret,{
	role_id = 0,
	hole_card_list = [],
	err_code = 0
	}).

-define(CMD_card_recast_cost,35441).
-record(pk_card_recast_cost,{
	key = 0,
	card_list = []
	}).

-define(CMD_U2GS_one_key_card_recast_req,17190).
-record(pk_U2GS_one_key_card_recast_req,{
	key_card_list = []
	}).

-define(CMD_GS2U_one_key_card_recast_ret,37493).
-record(pk_GS2U_one_key_card_recast_ret,{
	key_card_list = [],
	new_card_list = [],
	err_code = 0
	}).

-define(CMD_U2GS_quick_hang_info,14155).
-record(pk_U2GS_quick_hang_info,{
	}).

-define(CMD_GS2U_quick_hang_info_ret,31408).
-record(pk_GS2U_quick_hang_info_ret,{
	daily_reward = [],
	daily_reward_lv = 0,
	total_reward_id = 0,
	total_reward_num = 0,
	total_reward_lv = 0
	}).

-define(CMD_U2GS_quick_hang_get,28840).
-record(pk_U2GS_quick_hang_get,{
	}).

-define(CMD_GS2U_quick_hang_get_ret,14408).
-record(pk_GS2U_quick_hang_get_ret,{
	error_code = 0
	}).

-define(CMD_U2GS_quick_hang_get_big,33399).
-record(pk_U2GS_quick_hang_get_big,{
	}).

-define(CMD_GS2U_quick_hang_get_big_ret,64666).
-record(pk_GS2U_quick_hang_get_big_ret,{
	error_code = 0
	}).

-define(CMD_GS2U_advance_notice_reward_info,17082).
-record(pk_GS2U_advance_notice_reward_info,{
	reward_list = []
	}).

-define(CMD_U2GS_advance_notice_reward,60313).
-record(pk_U2GS_advance_notice_reward,{
	type = 0,
	id = 0
	}).

-define(CMD_GS2U_advance_notice_reward_ret,16457).
-record(pk_GS2U_advance_notice_reward_ret,{
	error_code = 0,
	type = 0,
	id = 0
	}).

-define(CMD_U2GS_demon_buy_fatigue,3897).
-record(pk_U2GS_demon_buy_fatigue,{
	type = 0,
	times = 0
	}).

-define(CMD_GS2U_demon_buy_fatigue_ret,21453).
-record(pk_GS2U_demon_buy_fatigue_ret,{
	error_code = 0,
	type = 0,
	times = 0,
	extra_fatigue = 0
	}).

-define(CMD_GS2U_demon_fresh_notice,39859).
-record(pk_GS2U_demon_fresh_notice,{
	type = 0,
	time = 0
	}).

-define(CMD_U2GS_demon_enter_multi_set,31477).
-record(pk_U2GS_demon_enter_multi_set,{
	type = 0,
	multi = 0
	}).

-define(CMD_GS2U_demon_enter_multi_set_ret,31830).
-record(pk_GS2U_demon_enter_multi_set_ret,{
	error_code = 0,
	type = 0,
	multi = 0
	}).

-define(CMD_GS2U_demon_kill_multi_notice,16518).
-record(pk_GS2U_demon_kill_multi_notice,{
	multi = 0,
	actual_multi = 0
	}).

-define(CMD_GS2U_demon_hp_percent_sync,58941).
-record(pk_GS2U_demon_hp_percent_sync,{
	list = []
	}).

-define(CMD_active_summary_info,59335).
-record(pk_active_summary_info,{
	id = 0,
	type = 0,
	style = 0,
	name = "",
	startTime = 0,
	endTime = 0,
	showStartTime = 0,
	showEndTime = 0,
	level_limit = 0,
	vip_limit = [],
	vip_type = 0,
	isRed = 0,
	enter_show = 0,
	enter_show_Text = "",
	menu_id = 0,
	uIPushType = 0,
	uIPush = [],
	param_list = [],
	vip_condition_open = 0
	}).

-define(CMD_active_entrance_info,19370).
-record(pk_active_entrance_info,{
	ref_id = 0,
	team_type = 0,
	team_name = "",
	icon_id = 0,
	icon_id_show = 0,
	icon_id_mark = 0,
	switch_type = 0,
	active_list = []
	}).

-define(CMD_active_detail_info,57266).
-record(pk_active_detail_info,{
	id = 0,
	group_id = 0,
	group_index = 0,
	title = "",
	top_title = "",
	type = 0,
	style = 0,
	menu_id = 0,
	state = 0,
	startTime = 0,
	endTime = 0,
	showStartTime = 0,
	showEndTime = 0,
	level_limit = 0,
	vip_limit = [],
	vip_type = 0,
	interval_list = [],
	pic_list = [],
	describe = "",
	banner_text = "",
	direct_purchase_id = 0,
	list_pic = []
	}).

-define(CMD_activeConditionInfo,17256).
-record(pk_activeConditionInfo,{
	conditionID = 0,
	targetNum = 0,
	param1 = 0
	}).

-define(CMD_conditionClass,10669).
-record(pk_conditionClass,{
	id = 0,
	vip_limit = 0,
	lv_limit = 0,
	condition_list = [],
	item_list = [],
	limit = [],
	score = 0,
	param = 0,
	free_item_list = []
	}).

-define(CMD_achieveCondition,19338).
-record(pk_achieveCondition,{
	conditionID = 0,
	curNum = 0,
	param = 0
	}).

-define(CMD_achieveParam,45968).
-record(pk_achieveParam,{
	id = 0,
	getRewardTimes = 0
	}).

-define(CMD_activeRedPoint,50880).
-record(pk_activeRedPoint,{
	id = 0,
	type = 0,
	isRed = 0,
	red_list = []
	}).

-define(CMD_ActivityItemSource,10780).
-record(pk_ActivityItemSource,{
	id = 0,
	item_id_list = []
	}).

-define(CMD_arbitraryCharge,57475).
-record(pk_arbitraryCharge,{
	id = 0,
	recharge_num = 0,
	item_list = [],
	limit = 0,
	model_show = 0
	}).

-define(CMD_GS2U_activeEnranceInfo,12266).
-record(pk_GS2U_activeEnranceInfo,{
	active_entrance_list = []
	}).

-define(CMD_U2GS_getTeamActiveList,28298).
-record(pk_U2GS_getTeamActiveList,{
	ref_id = 0
	}).

-define(CMD_GS2U_getTeamActiveListRet,57436).
-record(pk_GS2U_getTeamActiveListRet,{
	ref_id = 0,
	switch_type = 0,
	pic_list = [],
	top_title = "",
	team_active_list = []
	}).

-define(CMD_GS2U_activeFresh,30981).
-record(pk_GS2U_activeFresh,{
	}).

-define(CMD_U2GS_active_info_req,65161).
-record(pk_U2GS_active_info_req,{
	id = 0
	}).

-define(CMD_GS2U_active_info_req_ret,63973).
-record(pk_GS2U_active_info_req_ret,{
	id = 0,
	err = 0
	}).

-define(CMD_GS2U_ActiveBubbleNotice,35571).
-record(pk_GS2U_ActiveBubbleNotice,{
	ac_id = 0,
	title = ""
	}).

-define(CMD_GS2U_conditional_info_ret,31568).
-record(pk_GS2U_conditional_info_ret,{
	id = 0,
	err = 0,
	conditionInfo = [],
	achieveList = [],
	hasAchieveList = []
	}).

-define(CMD_U2GS_get_conditional_award,56948).
-record(pk_U2GS_get_conditional_award,{
	id = 0,
	func_id = 0,
	index = 0
	}).

-define(CMD_GS2U_get_conditional_award_ret,7848).
-record(pk_GS2U_get_conditional_award_ret,{
	id = 0,
	func_id = 0,
	index = 0,
	err = 0,
	achieve_param = #pk_achieveParam{}
	}).

-define(CMD_GS2U_active_red_point_sync,3055).
-record(pk_GS2U_active_red_point_sync,{
	red_point_list = []
	}).

-define(CMD_GS2U_active_temp_red_point_sync,23618).
-record(pk_GS2U_active_temp_red_point_sync,{
	red_point_list = []
	}).

-define(CMD_Questionnaire,47876).
-record(pk_Questionnaire,{
	q_id = 0,
	type = 0,
	subject = "",
	random = 0,
	answer_list = []
	}).

-define(CMD_QuestionnaireAnswer,32037).
-record(pk_QuestionnaireAnswer,{
	q_id = 0,
	answer_index = [],
	answer_str = ""
	}).

-define(CMD_GS2U_questionnaire_info_ret,34644).
-record(pk_GS2U_questionnaire_info_ret,{
	id = 0,
	err = 0,
	text = "",
	question_list = [],
	item_list = [],
	is_finish = 0
	}).

-define(CMD_U2GS_questionnaire_commit,51769).
-record(pk_U2GS_questionnaire_commit,{
	id = 0,
	answer_list = []
	}).

-define(CMD_GS2U_questionnaire_commit_ret,42304).
-record(pk_GS2U_questionnaire_commit_ret,{
	id = 0,
	err = 0
	}).

-define(CMD_GS2U_activity_item_source_from,65152).
-record(pk_GS2U_activity_item_source_from,{
	list = []
	}).

-define(CMD_GS2U_grand_ceremony_ret,60166).
-record(pk_GS2U_grand_ceremony_ret,{
	id = 0,
	err = 0,
	conditionInfo = [],
	achieveList = [],
	hasAchieveList = []
	}).

-define(CMD_U2GS_get_grand_ceremony_award,49788).
-record(pk_U2GS_get_grand_ceremony_award,{
	id = 0,
	func_id = 0,
	index = 0
	}).

-define(CMD_GS2U_get_grand_ceremony_award_ret,63548).
-record(pk_GS2U_get_grand_ceremony_award_ret,{
	id = 0,
	func_id = 0,
	index = 0,
	err = 0,
	achieve_param = #pk_achieveParam{}
	}).

-define(CMD_GS2U_dragon_temple_ret,26036).
-record(pk_GS2U_dragon_temple_ret,{
	id = 0,
	err = 0,
	conditionInfo = [],
	achieveList = [],
	hasAchieveList = [],
	model = []
	}).

-define(CMD_U2GS_get_dragon_temple_award,47978).
-record(pk_U2GS_get_dragon_temple_award,{
	id = 0,
	award_list = []
	}).

-define(CMD_GS2U_get_dragon_temple_award_ret,5765).
-record(pk_GS2U_get_dragon_temple_award_ret,{
	id = 0,
	award_list = [],
	err = 0,
	achieve_param = []
	}).

-define(CMD_GS2U_arbitrary_charge_ret,9332).
-record(pk_GS2U_arbitrary_charge_ret,{
	id = 0,
	err = 0,
	charge_list = [],
	award_list = []
	}).

-define(CMD_U2GS_get_arbitrary_charge_award,24620).
-record(pk_U2GS_get_arbitrary_charge_award,{
	id = 0,
	func_id = 0,
	index = 0
	}).

-define(CMD_GS2U_get_arbitrary_charge_award_ret,49430).
-record(pk_GS2U_get_arbitrary_charge_award_ret,{
	id = 0,
	func_id = 0,
	index = 0,
	err = 0
	}).

-define(CMD_GS2U_continuous_recharge_info_ret,47992).
-record(pk_GS2U_continuous_recharge_info_ret,{
	id = 0,
	err = 0,
	conditionInfo = [],
	achieveList = [],
	hasAchieveList = [],
	extra_award = [],
	item_list = [],
	award_extra_list = [],
	big_item_show = [],
	show1 = 0
	}).

-define(CMD_U2GS_get_continuous_recharge_award,62723).
-record(pk_U2GS_get_continuous_recharge_award,{
	id = 0,
	func_id = 0,
	index = 0
	}).

-define(CMD_GS2U_get_continuous_recharge_award_ret,29310).
-record(pk_GS2U_get_continuous_recharge_award_ret,{
	id = 0,
	func_id = 0,
	index = 0,
	err = 0,
	achieve_param = #pk_achieveParam{}
	}).

-define(CMD_U2GS_get_continuous_recharge_extra_award,53870).
-record(pk_U2GS_get_continuous_recharge_extra_award,{
	id = 0,
	index = 0
	}).

-define(CMD_GS2U_get_continuous_recharge_extra_award_ret,21895).
-record(pk_GS2U_get_continuous_recharge_extra_award_ret,{
	id = 0,
	index = 0,
	err = 0
	}).

-define(CMD_U2GS_active_check_point,3587).
-record(pk_U2GS_active_check_point,{
	variant = 0,
	index = 0
	}).

-define(CMD_GS2U_player_certain_state_sync,55283).
-record(pk_GS2U_player_certain_state_sync,{
	key = 0,
	value = 0
	}).

-define(CMD_retrieve_stc,23454).
-record(pk_retrieve_stc,{
	retrieve_id = 0,
	retrieve_value = 0,
	has_retrieve_value = 0,
	available_value = 0,
	award_list = [],
	eq_list = [],
	exp = 0
	}).

-define(CMD_GS2U_retrieve_info,44100).
-record(pk_GS2U_retrieve_info,{
	list = []
	}).

-define(CMD_GS2U_retrieve_update,847).
-record(pk_GS2U_retrieve_update,{
	info = #pk_retrieve_stc{}
	}).

-define(CMD_GS2U_retrieve_update_list,11334).
-record(pk_GS2U_retrieve_update_list,{
	info_list = []
	}).

-define(CMD_U2GS_retrieve_some,38919).
-record(pk_U2GS_retrieve_some,{
	retrieve_id = 0,
	retrieve_value = 0
	}).

-define(CMD_GS2U_retrieve_some_ret,1474).
-record(pk_GS2U_retrieve_some_ret,{
	retrieve_id = 0,
	retrieve_value = 0,
	err = 0
	}).

-define(CMD_U2GS_ui_op,21164).
-record(pk_U2GS_ui_op,{
	type = 0,
	op = 0
	}).

-define(CMD_King1v1Player,30949).
-record(pk_King1v1Player,{
	player_id = 0,
	name = "",
	sex = 0,
	level = 0,
	head_id = 0,
	head_frame = 0,
	server_name = "",
	guild_name = "",
	battle_value = 0,
	score = 0,
	grade = 0,
	rank = 0,
	role_list = [],
	season_fight_times = 0,
	season_win_times = 0
	}).

-define(CMD_King1v1RoleRank,30490).
-record(pk_King1v1RoleRank,{
	role_id = 0,
	career = 0,
	is_leader = 0
	}).

-define(CMD_King1v1Rank,52016).
-record(pk_King1v1Rank,{
	player_id = 0,
	player_name = "",
	server_name = "",
	sex = 0,
	head_id = 0,
	head_frame = 0,
	level = 0,
	battle_value = 0,
	grade = 0,
	season_fight_times = 0,
	season_win_times = 0,
	rank = 0,
	king_rank = 0,
	role_list = [],
	pet_list = []
	}).

-define(CMD_King1v1Round,64149).
-record(pk_King1v1Round,{
	fight_id = 0,
	round = 0,
	group = 0,
	attacker = #pk_King1v1Rank{},
	defender = #pk_King1v1Rank{},
	start_time = 0,
	end_time = 0,
	result = 0,
	num1 = 0,
	num2 = 0
	}).

-define(CMD_King1v1Record,48378).
-record(pk_King1v1Record,{
	attacker = #pk_King1v1Rank{},
	defender = #pk_King1v1Rank{},
	result = 0,
	end_time = 0
	}).

-define(CMD_King1v1Bet,39051).
-record(pk_King1v1Bet,{
	fight_id = 0,
	result = 0,
	state = 0
	}).

-define(CMD_U2GS_GetKing1v1UI,1360).
-record(pk_U2GS_GetKing1v1UI,{
	}).

-define(CMD_GS2U_GetKing1v1UIRet,3538).
-record(pk_GS2U_GetKing1v1UIRet,{
	state = 0,
	start_time = 0,
	next_time = 0,
	end_time = 0,
	is_active = 0,
	day_buy_times = 0,
	day_fight_times = 0,
	buy_times = 0,
	score = 0,
	grade = 0,
	rank = 0,
	rank_per = 0,
	season_fight_times = 0,
	season_win_times = 0,
	bet_times = 0,
	challenge_times = 0,
	tops = [],
	king_tops = [],
	award_tasks_nm = [],
	bet_info = [],
	rounds = [],
	award_tasks_bp = [],
	bp_season_fight_times = 0,
	cluster_stage = 0,
	bp_times_fix = 0,
	bp_score_fix = 0,
	server_list = [],
	last_match_flag = 0
	}).

-define(CMD_GS2U_sync_1v1_rounds_result,29574).
-record(pk_GS2U_sync_1v1_rounds_result,{
	fight_id = 0,
	result = 0
	}).

-define(CMD_GS2U_King1v1PlayerInfoSync,13245).
-record(pk_GS2U_King1v1PlayerInfoSync,{
	day_buy_times = 0,
	day_fight_times = 0,
	buy_times = 0,
	challenge_times = 0,
	score = 0,
	grade = 0,
	season_fight_times = 0,
	season_win_times = 0,
	award_tasks_nm = [],
	award_tasks_bp = [],
	bp_season_fight_times = 0
	}).

-define(CMD_GS2U_King1v1AcStateSync,49293).
-record(pk_GS2U_King1v1AcStateSync,{
	state = 0,
	next_time = 0,
	cluster_stage = 0,
	bp_times_fix = 0,
	bp_score_fix = 0,
	server_list = [],
	last_match_flag = 0
	}).

-define(CMD_GS2U_King1v1SeasonNumSync,50969).
-record(pk_GS2U_King1v1SeasonNumSync,{
	season_num = 0,
	season_id = 0
	}).

-define(CMD_U2GS_King1v1Match,14559).
-record(pk_U2GS_King1v1Match,{
	target_id = 0
	}).

-define(CMD_GS2U_King1v1MatchRet,5846).
-record(pk_GS2U_King1v1MatchRet,{
	err_code = 0,
	target_id = 0,
	fight_id = 0,
	attacker = #pk_King1v1Rank{},
	defender = #pk_King1v1Rank{}
	}).

-define(CMD_U2GS_King1v1TaskAward,32058).
-record(pk_U2GS_King1v1TaskAward,{
	task_id = []
	}).

-define(CMD_U2GS_King1v1TaskAwardNew,5414).
-record(pk_U2GS_King1v1TaskAwardNew,{
	task_nm = [],
	task_bp = []
	}).

-define(CMD_GS2U_King1v1TaskAwardRet,11404).
-record(pk_GS2U_King1v1TaskAwardRet,{
	err_code = 0,
	task_nm = [],
	task_bp = []
	}).

-define(CMD_U2GS_King1v1GetRecord,993).
-record(pk_U2GS_King1v1GetRecord,{
	type = 0
	}).

-define(CMD_GS2U_King1v1GetRecordRet,56243).
-record(pk_GS2U_King1v1GetRecordRet,{
	type = 0,
	records = []
	}).

-define(CMD_U2GS_EnterKing1v1,37980).
-record(pk_U2GS_EnterKing1v1,{
	fight_id = 0
	}).

-define(CMD_U2GS_King1v1BuyTimes,16796).
-record(pk_U2GS_King1v1BuyTimes,{
	buy_times = 0
	}).

-define(CMD_GS2U_King1v1BuyTimesRet,14234).
-record(pk_GS2U_King1v1BuyTimesRet,{
	err_code = 0,
	buy_times = 0
	}).

-define(CMD_GS2U_sync_day_fight_time,33718).
-record(pk_GS2U_sync_day_fight_time,{
	day_fight_times = 0,
	left_time = 0
	}).

-define(CMD_U2GS_King1v1Bet,18791).
-record(pk_U2GS_King1v1Bet,{
	fight_id = 0,
	result = 0
	}).

-define(CMD_GS2U_King1v1BetRet,51992).
-record(pk_GS2U_King1v1BetRet,{
	err_code = 0,
	fight_id = 0,
	result = 0
	}).

-define(CMD_U2GS_King1v1BetAward,55563).
-record(pk_U2GS_King1v1BetAward,{
	fight_id = 0
	}).

-define(CMD_GS2U_King1v1BetAwardRet,23998).
-record(pk_GS2U_King1v1BetAwardRet,{
	err_code = 0,
	fight_id = 0
	}).

-define(CMD_GS2U_King1v1Info,23763).
-record(pk_GS2U_King1v1Info,{
	fight_id = 0,
	type = 0,
	players = [],
	state = 0,
	end_time = 0,
	round = 0
	}).

-define(CMD_GS2U_King1v1DefNotice,38492).
-record(pk_GS2U_King1v1DefNotice,{
	type = 0,
	day_def_score = 0
	}).

-define(CMD_GS2U_King1v1SettleAccounts,50006).
-record(pk_GS2U_King1v1SettleAccounts,{
	type = 0,
	round = 0,
	result = 0,
	attacker = #pk_King1v1Player{},
	defender = #pk_King1v1Player{},
	records = [],
	exp = 0,
	coinList = [],
	itemList = [],
	isDirect = 0,
	isFinal = 0,
	next_time = 0
	}).

-define(CMD_role_pos,695).
-record(pk_role_pos,{
	role_id = 0,
	type = 0,
	pos = 0
	}).

-define(CMD_U2GS_set_role_pos,34535).
-record(pk_U2GS_set_role_pos,{
	type = 0,
	info_list = []
	}).

-define(CMD_U2GS_get_role_pos,17952).
-record(pk_U2GS_get_role_pos,{
	type = 0
	}).

-define(CMD_GS2U_push_role_pos,11904).
-record(pk_GS2U_push_role_pos,{
	type = 0,
	info_list = []
	}).

-define(CMD_cluster_auction_goods,38712).
-record(pk_cluster_auction_goods,{
	goods_id = 0,
	item_id = 0,
	item_chara = 0,
	item_star = 0,
	item_amount = 0,
	start_time = 0,
	finish_time = 0,
	price_type = 0,
	bid_price = 0,
	bid_price_add = 0,
	bid_price_buy = 0,
	bid_state = 0,
	can_buy = 0,
	open_action = 0
	}).

-define(CMD_U2GS_cluster_auction_goods_list,63111).
-record(pk_U2GS_cluster_auction_goods_list,{
	open_action = 0
	}).

-define(CMD_GS2U_cluster_auction_goods_list,7759).
-record(pk_GS2U_cluster_auction_goods_list,{
	error = 0,
	open_action = 0,
	goods_list = []
	}).

-define(CMD_GS2U_cluster_auction_goods_start_notice,20717).
-record(pk_GS2U_cluster_auction_goods_start_notice,{
	open_action = 0
	}).

-define(CMD_GS2U_cluster_auction_goods_end_notice,45930).
-record(pk_GS2U_cluster_auction_goods_end_notice,{
	open_action = 0
	}).

-define(CMD_GS2U_cluster_auction_goods_update_notice,14595).
-record(pk_GS2U_cluster_auction_goods_update_notice,{
	goods_id = 0,
	bid_price = 0,
	bid_state = 0
	}).

-define(CMD_GS2U_cluster_auction_goods_remove_notice,59498).
-record(pk_GS2U_cluster_auction_goods_remove_notice,{
	goods_id = 0
	}).

-define(CMD_U2GS_cluster_auction_goods_bid,33009).
-record(pk_U2GS_cluster_auction_goods_bid,{
	goods_id = 0,
	price = 0
	}).

-define(CMD_GS2U_cluster_auction_goods_bid,25462).
-record(pk_GS2U_cluster_auction_goods_bid,{
	error = 0
	}).

-define(CMD_U2GS_cluster_auction_goods_buy,49484).
-record(pk_U2GS_cluster_auction_goods_buy,{
	goods_id = 0
	}).

-define(CMD_GS2U_cluster_auction_goods_buy,41937).
-record(pk_GS2U_cluster_auction_goods_buy,{
	error = 0
	}).

-define(CMD_U2GS_cluster_auction_bonus,16936).
-record(pk_U2GS_cluster_auction_bonus,{
	open_action = 0
	}).

-define(CMD_GS2U_cluster_auction_bonus,24310).
-record(pk_GS2U_cluster_auction_bonus,{
	open_action = 0,
	is_join = 0,
	total = [],
	bonus = []
	}).

-define(CMD_cup,41464).
-record(pk_cup,{
	cup_id = 0,
	chara = 0,
	char_exp = 0,
	stage = 0,
	lv = 0,
	exp = 0,
	stamp = 0
	}).

-define(CMD_GS2U_cup_update,8862).
-record(pk_GS2U_cup_update,{
	is_online_sync = 0,
	cup_list = []
	}).

-define(CMD_U2GS_cup_star_info,7710).
-record(pk_U2GS_cup_star_info,{
	}).

-define(CMD_GS2U_cup_star_info_ret,10023).
-record(pk_GS2U_cup_star_info_ret,{
	star_list = []
	}).

-define(CMD_U2GS_cup_level_up_req,26042).
-record(pk_U2GS_cup_level_up_req,{
	cup_id = 0,
	type = 0,
	costs = []
	}).

-define(CMD_GS2U_cup_level_up_ret,2655).
-record(pk_GS2U_cup_level_up_ret,{
	cup_id = 0,
	type = 0,
	is_stage_up = false,
	err_code = 0
	}).

-define(CMD_U2GS_cup_active_stamp_req,2533).
-record(pk_U2GS_cup_active_stamp_req,{
	cup_id = 0
	}).

-define(CMD_GS2U_cup_active_stamp_ret,52960).
-record(pk_GS2U_cup_active_stamp_ret,{
	cup_id = 0,
	err_code = 0
	}).

-define(CMD_U2GS_cup_equip_req,51293).
-record(pk_U2GS_cup_equip_req,{
	cup_id = 0
	}).

-define(CMD_GS2U_cup_equip_ret,55007).
-record(pk_GS2U_cup_equip_ret,{
	cup_id = 0,
	err_code = 0
	}).

-define(CMD_GS2U_update_cup_equip,19571).
-record(pk_GS2U_update_cup_equip,{
	cup_id = 0
	}).

-define(CMD_dg_trail,6981).
-record(pk_dg_trail,{
	id = 0,
	task_list = [],
	received_list = []
	}).

-define(CMD_GS2U_dragon_god_trail_info,27591).
-record(pk_GS2U_dragon_god_trail_info,{
	trail_list = []
	}).

-define(CMD_dg_trail_task,32180).
-record(pk_dg_trail_task,{
	trail_id = 0,
	task_list = []
	}).

-define(CMD_GS2U_dragon_god_trail_task_update,5327).
-record(pk_GS2U_dragon_god_trail_task_update,{
	trail_list = []
	}).

-define(CMD_dg_trail_cfg_base,41432).
-record(pk_dg_trail_cfg_base,{
	id = 0,
	name = "",
	openDate = 0,
	durationDays = 0,
	calss_type = 0,
	recommend = [],
	type = [],
	rewardCond = [],
	rewardCondBase = [],
	rewardBaseText = "",
	rewardShow = [],
	moduleTitle = 0,
	icon = "",
	selectIcon = ""
	}).

-define(CMD_dg_trail_cfg_type,58712).
-record(pk_dg_trail_cfg_type,{
	id = 0,
	type = 0,
	num1 = 0,
	num2 = 0,
	num3 = 0,
	num4 = 0,
	num5 = 0,
	typeDoc = "",
	typeDoc2 = "",
	jump1 = 0,
	jump2 = 0,
	group_id = 0,
	photo = ""
	}).

-define(CMD_dg_trail_item,29011).
-record(pk_dg_trail_item,{
	type = 0,
	item_id = 0,
	bind = 0,
	num = 0
	}).

-define(CMD_dg_trail_eq,21934).
-record(pk_dg_trail_eq,{
	eq_id = 0,
	quality = 0,
	star = 0,
	bind = 0
	}).

-define(CMD_dg_trail_cfg_award,28105).
-record(pk_dg_trail_cfg_award,{
	id = 0,
	order = 0,
	items = [],
	eqs = []
	}).

-define(CMD_dg_trail_cfg_group,32275).
-record(pk_dg_trail_cfg_group,{
	id = 0,
	condition = [],
	number = 0
	}).

-define(CMD_GS2U_dragon_god_trail_cfg,29238).
-record(pk_GS2U_dragon_god_trail_cfg,{
	base_list = [],
	type_list = [],
	award_list = [],
	group_list = []
	}).

-define(CMD_U2GS_dragon_god_trail_receive_award,51859).
-record(pk_U2GS_dragon_god_trail_receive_award,{
	trail_id = 0,
	order = 0
	}).

-define(CMD_GS2U_dragon_god_trail_receive_award_ret,40858).
-record(pk_GS2U_dragon_god_trail_receive_award_ret,{
	trail_id = 0,
	order = 0,
	err_code = 0
	}).

-define(CMD_GS2U_dragon_god_trail_open,46856).
-record(pk_GS2U_dragon_god_trail_open,{
	open_list = []
	}).

-define(CMD_U2GS_dragon_god_trail_get_rank_list,41164).
-record(pk_U2GS_dragon_god_trail_get_rank_list,{
	}).

-define(CMD_dg_trail_player,37064).
-record(pk_dg_trail_player,{
	player_id = 0,
	name = "",
	sex = 0,
	career = 0,
	headID = 0,
	frame = 0,
	guild_name = "",
	point = 0
	}).

-define(CMD_dg_trail_rank,12320).
-record(pk_dg_trail_rank,{
	trail_id = 0,
	rank = []
	}).

-define(CMD_GS2U_dragon_god_trail_get_rank_list_ret,65018).
-record(pk_GS2U_dragon_god_trail_get_rank_list_ret,{
	rank_list = [],
	err_code = 0
	}).

-define(CMD_promotion_present_gift,43224).
-record(pk_promotion_present_gift,{
	num = 0,
	text = "",
	item_list = [],
	coin_type = #pk_key_value{},
	direct_purchase = "",
	discount = 0,
	model_show = #pk_key_value{}
	}).

-define(CMD_GS2U_promotion_present_gift_ret,56284).
-record(pk_GS2U_promotion_present_gift_ret,{
	id = 0,
	err = 0,
	info_list = [],
	buy_list = []
	}).

-define(CMD_U2GS_promotion_present_gift_buy,62207).
-record(pk_U2GS_promotion_present_gift_buy,{
	id = 0,
	num = 0
	}).

-define(CMD_GS2U_promotion_present_gift_buy_ret,63016).
-record(pk_GS2U_promotion_present_gift_buy_ret,{
	id = 0,
	num = 0,
	err = 0
	}).

-define(CMD_DrAwardStc,31468).
-record(pk_DrAwardStc,{
	id = 0,
	condition = #pk_key_2value{},
	item_list = [],
	vip = 0
	}).

-define(CMD_DailyRechargeStc,40857).
-record(pk_DailyRechargeStc,{
	type = 0,
	type_group = 0,
	world_lv = 0,
	order = 0,
	round_id = 0,
	cond_award_list = [],
	end_time = 0,
	image = ""
	}).

-define(CMD_DailyRechargeReachStc,47224).
-record(pk_DailyRechargeReachStc,{
	type = 0,
	type_group = 0,
	reach_list = [],
	finish_id_list = []
	}).

-define(CMD_GS2U_daily_recharge_info,4115).
-record(pk_GS2U_daily_recharge_info,{
	info_list = []
	}).

-define(CMD_GS2U_daily_recharge_condtion_reach,13970).
-record(pk_GS2U_daily_recharge_condtion_reach,{
	reach_list = []
	}).

-define(CMD_U2GS_daily_recharge_award,50552).
-record(pk_U2GS_daily_recharge_award,{
	type = 0,
	type_group = 0,
	id = 0
	}).

-define(CMD_GS2U_daily_recharge_award_ret,61552).
-record(pk_GS2U_daily_recharge_award_ret,{
	type = 0,
	type_group = 0,
	id = 0,
	error_code = 0
	}).

-define(CMD_U2GS_one_key_daily_recharge_award,4607).
-record(pk_U2GS_one_key_daily_recharge_award,{
	type = 0,
	type_group = 0
	}).

-define(CMD_GS2U_one_key_daily_recharge_award_ret,10513).
-record(pk_GS2U_one_key_daily_recharge_award_ret,{
	type = 0,
	type_group = 0,
	error_code = 0
	}).

-define(CMD_glory_carnival_task,59703).
-record(pk_glory_carnival_task,{
	oder2 = 0,
	name = "",
	condition_list = []
	}).

-define(CMD_glory_carnival,24802).
-record(pk_glory_carnival,{
	oder = 0,
	name = "",
	start_time = 0,
	end_time = 0,
	task_list = [],
	score_list = [],
	item_list = [],
	image = 0
	}).

-define(CMD_glory_carnival_get,53357).
-record(pk_glory_carnival_get,{
	oder1 = 0,
	oder2 = 0,
	oder3 = 0,
	num = 0
	}).

-define(CMD_GS2U_glory_carnival_ret,49404).
-record(pk_GS2U_glory_carnival_ret,{
	id = 0,
	err = 0,
	info_list = [],
	achieve_list = [],
	score_list = [],
	get_list = []
	}).

-define(CMD_U2GS_glory_carnival_award,13865).
-record(pk_U2GS_glory_carnival_award,{
	id = 0,
	oder = 0,
	oder2 = 0,
	oder3 = 0
	}).

-define(CMD_GS2U_glory_carnival_award_ret,37019).
-record(pk_GS2U_glory_carnival_award_ret,{
	id = 0,
	oder = 0,
	oder2 = 0,
	oder3 = [],
	score = 0,
	err = 0
	}).

-define(CMD_promotion_treasure_task,30447).
-record(pk_promotion_treasure_task,{
	day = 0,
	condition_list = []
	}).

-define(CMD_item_info_param8,49042).
-record(pk_item_info_param8,{
	index1 = 0,
	index2 = 0,
	type = 0,
	id = 0,
	num = 0,
	bind = 0,
	quality = 0,
	star = 0
	}).

-define(CMD_promotion_treasure_store,60846).
-record(pk_promotion_treasure_store,{
	index = 0,
	name = "",
	cons_list = [],
	show_item = [],
	item_list = [],
	list = []
	}).

-define(CMD_promotion_treasure,61977).
-record(pk_promotion_treasure,{
	task_list = [],
	store_list = []
	}).

-define(CMD_promotion_treasure_player,57465).
-record(pk_promotion_treasure_player,{
	id = 0,
	is_get_big_award = false,
	open_award_list = []
	}).

-define(CMD_GS2U_promotion_treasure_ret,342).
-record(pk_GS2U_promotion_treasure_ret,{
	id = 0,
	err = 0,
	info = #pk_promotion_treasure{},
	achieve_list = [],
	get_list = [],
	get_award_list = []
	}).

-define(CMD_U2GS_promotion_treasure_award,20454).
-record(pk_U2GS_promotion_treasure_award,{
	id = 0,
	type = 0,
	index1 = 0,
	index2 = 0
	}).

-define(CMD_GS2U_promotion_treasure_award_ret,390).
-record(pk_GS2U_promotion_treasure_award_ret,{
	id = 0,
	type = 0,
	index1 = 0,
	index2 = 0,
	award = #pk_key_value{},
	err = 0
	}).

-define(CMD_uiTypeParameter,10477).
-record(pk_uiTypeParameter,{
	id = 0,
	x_shift = 0,
	y_shift = 0,
	z_shift = 0,
	x_rotation = 0,
	y_rotation = 0,
	z_rotation = 0,
	zoom = 0
	}).

-define(CMD_pushSalesStc,31451).
-record(pk_pushSalesStc,{
	id = 0,
	order = 0,
	effects = 0,
	base_map = "",
	ui_type = 0,
	ui_param = [],
	list_ui_param = [],
	show_ui_param = [],
	entrance_icon = "",
	title = "",
	des = "",
	slogan = "",
	slogan_1 = "",
	priority_group = 0,
	curr_type = #pk_key_value{},
	direct_purchase_code = "",
	discount = [],
	award_list = [],
	buy_num = 0,
	has_buy_num = 0,
	push_type = 0,
	time_limit_type = 0,
	end_time = 0,
	shop_id = 0,
	is_platform = 0,
	skill_show = 0
	}).

-define(CMD_GS2U_time_limit_gift_info,65299).
-record(pk_GS2U_time_limit_gift_info,{
	list = []
	}).

-define(CMD_GS2U_time_limit_gift_push,53492).
-record(pk_GS2U_time_limit_gift_push,{
	info = []
	}).

-define(CMD_U2GS_time_limit_gift_buy,34270).
-record(pk_U2GS_time_limit_gift_buy,{
	id = 0,
	order = 0
	}).

-define(CMD_GS2U_time_limit_gift_buy_ret,65084).
-record(pk_GS2U_time_limit_gift_buy_ret,{
	id = 0,
	order = 0,
	error_code = 0
	}).

-define(CMD_U2GS_time_limit_gift_client_tick,53592).
-record(pk_U2GS_time_limit_gift_client_tick,{
	}).

-define(CMD_GS2U_time_limit_gift_remove,2794).
-record(pk_GS2U_time_limit_gift_remove,{
	id = 0,
	order = 0
	}).

-define(CMD_bossFirstKillStc,13140).
-record(pk_bossFirstKillStc,{
	map_data_id = 0,
	boss_data_id = 0,
	type = 0,
	single_award_list = [],
	group_award_list = [],
	is_important = 0,
	killer_id = 0,
	killer_name = "",
	is_award = 0
	}).

-define(CMD_bossFirstKillAwardStc,25492).
-record(pk_bossFirstKillAwardStc,{
	map_data_id = 0,
	boss_data_id = 0,
	killer_id = 0,
	killer_name = ""
	}).

-define(CMD_GS2U_boss_first_kill_ret,39633).
-record(pk_GS2U_boss_first_kill_ret,{
	id = 0,
	err = 0,
	boss_kill_list = []
	}).

-define(CMD_U2GS_boss_first_kill_award,48362).
-record(pk_U2GS_boss_first_kill_award,{
	id = 0,
	type = 0
	}).

-define(CMD_GS2U_boss_first_kill_award_ret,13365).
-record(pk_GS2U_boss_first_kill_award_ret,{
	id = 0,
	type = 0,
	get_list = [],
	error_code = 0
	}).

-define(CMD_GS2U_demon_time_award_info,59822).
-record(pk_GS2U_demon_time_award_info,{
	info_list = []
	}).

-define(CMD_U2GS_demon_time_award_get,10412).
-record(pk_U2GS_demon_time_award_get,{
	info = #pk_key_2value{},
	is_get = false
	}).

-define(CMD_GS2U_demon_time_award_get_ret,10831).
-record(pk_GS2U_demon_time_award_get_ret,{
	info = #pk_key_2value{},
	is_get = false,
	error = 0
	}).

-define(CMD_GS2U_free_account_money,21116).
-record(pk_GS2U_free_account_money,{
	money = 0
	}).

-define(CMD_U2GS_free_account_recharge,50321).
-record(pk_U2GS_free_account_recharge,{
	fgi = 0,
	amount = 0,
	price = 0,
	item_id = "",
	item_code = "",
	comments = "",
	currency_type = ""
	}).

-define(CMD_GS2U_free_account_recharge,57696).
-record(pk_GS2U_free_account_recharge,{
	item_id = "",
	result = 0
	}).

-define(CMD_relic_info,42924).
-record(pk_relic_info,{
	relic_id = 0,
	level = 0,
	grade_lv = 0,
	awaken_lv = 0,
	awaken_skill = 0,
	break_lv = 0
	}).

-define(CMD_relic_illusion_info,22812).
-record(pk_relic_illusion_info,{
	relic_id = 0,
	star_lv = 0,
	rein_lv = 0
	}).

-define(CMD_holy_seal,30615).
-record(pk_holy_seal,{
	role_id = 0,
	career_lv = 0,
	equip_list = [],
	max_index = 0
	}).

-define(CMD_GS2U_relic_player_info,44632).
-record(pk_GS2U_relic_player_info,{
	skill_list = [],
	relic_list = [],
	holy_seal_info = []
	}).

-define(CMD_U2GS_relic_up_level,4260).
-record(pk_U2GS_relic_up_level,{
	relic_id = 0,
	add_level = 0
	}).

-define(CMD_GS2U_relic_up_level_ret,8791).
-record(pk_GS2U_relic_up_level_ret,{
	relic_id = 0,
	add_level = 0,
	err_code = 0
	}).

-define(CMD_GS2U_relic_update_level,52706).
-record(pk_GS2U_relic_update_level,{
	relic_id = 0,
	level = 0
	}).

-define(CMD_U2GS_relic_up_grade_lv,33774).
-record(pk_U2GS_relic_up_grade_lv,{
	relic_id = 0,
	add_level = 0
	}).

-define(CMD_GS2U_relic_up_grade_lv_ret,29172).
-record(pk_GS2U_relic_up_grade_lv_ret,{
	relic_id = 0,
	add_level = 0,
	err_code = 0
	}).

-define(CMD_GS2U_relic_update_grade_lv,32309).
-record(pk_GS2U_relic_update_grade_lv,{
	relic_id = 0,
	level = 0
	}).

-define(CMD_U2GS_relic_up_awaken_lv,65411).
-record(pk_U2GS_relic_up_awaken_lv,{
	relic_id = 0,
	add_level = 0
	}).

-define(CMD_GS2U_relic_up_awaken_lv_ret,42782).
-record(pk_GS2U_relic_up_awaken_lv_ret,{
	relic_id = 0,
	add_level = 0,
	err_code = 0
	}).

-define(CMD_GS2U_relic_update_awaken_lv,61747).
-record(pk_GS2U_relic_update_awaken_lv,{
	relic_id = 0,
	level = 0
	}).

-define(CMD_U2GS_relic_set_awaken_skill,43086).
-record(pk_U2GS_relic_set_awaken_skill,{
	relic_id = 0,
	skill_id = 0
	}).

-define(CMD_GS2U_relic_set_awaken_skill_ret,51093).
-record(pk_GS2U_relic_set_awaken_skill_ret,{
	relic_id = 0,
	skill_id = 0,
	err_code = 0
	}).

-define(CMD_U2GS_relic_awaken_skill_reset_req,13312).
-record(pk_U2GS_relic_awaken_skill_reset_req,{
	career = 0,
	group_id = 0
	}).

-define(CMD_GS2U_relic_awaken_skill_reset_ret,58135).
-record(pk_GS2U_relic_awaken_skill_reset_ret,{
	career = 0,
	group_id = 0,
	relic_id_list = [],
	err_code = 0
	}).

-define(CMD_U2GS_relic_break,49631).
-record(pk_U2GS_relic_break,{
	relic_id = 0
	}).

-define(CMD_GS2U_relic_break_ret,31728).
-record(pk_GS2U_relic_break_ret,{
	relic_id = 0,
	err_code = 0
	}).

-define(CMD_GS2U_relic_update_break_level,5702).
-record(pk_GS2U_relic_update_break_level,{
	relic_id = 0,
	break_level = 0
	}).

-define(CMD_U2GS_relic_holy_seal_equip,48627).
-record(pk_U2GS_relic_holy_seal_equip,{
	role_id = 0,
	career_lv = 0,
	index = 0,
	item_id = 0
	}).

-define(CMD_GS2U_relic_holy_seal_equip_ret,53699).
-record(pk_GS2U_relic_holy_seal_equip_ret,{
	role_id = 0,
	career_lv = 0,
	index = 0,
	item_id = 0,
	err_code = 0
	}).

-define(CMD_HolySealIndex,49658).
-record(pk_HolySealIndex,{
	index = 0,
	item_id = 0
	}).

-define(CMD_U2GS_relic_holy_seal_one_key_equip,25590).
-record(pk_U2GS_relic_holy_seal_one_key_equip,{
	role_id = 0,
	career_lv = 0,
	is_equip = 0,
	holy_seal_list = []
	}).

-define(CMD_GS2U_relic_holy_seal_one_key_equip_ret,46639).
-record(pk_GS2U_relic_holy_seal_one_key_equip_ret,{
	role_id = 0,
	career_lv = 0,
	is_equip = 0,
	holy_seal_list = [],
	err_code = 0
	}).

-define(CMD_GS2U_relic_update_holy_seal_equip,43093).
-record(pk_GS2U_relic_update_holy_seal_equip,{
	role_id = 0,
	career_lv = 0,
	index = 0,
	item_id = 0
	}).

-define(CMD_U2GS_relic_holy_seal_up_level,10598).
-record(pk_U2GS_relic_holy_seal_up_level,{
	holy_seal_id = 0,
	cost_list = []
	}).

-define(CMD_GS2U_relic_holy_seal_up_level_ret,42544).
-record(pk_GS2U_relic_holy_seal_up_level_ret,{
	holy_seal_id = 0,
	cost_list = [],
	err_code = 0
	}).

-define(CMD_U2GS_relic_holy_seal_add_honor,18198).
-record(pk_U2GS_relic_holy_seal_add_honor,{
	role_id = 0,
	career_lv = 0
	}).

-define(CMD_GS2U_relic_holy_seal_equip_add_honor_ret,3737).
-record(pk_GS2U_relic_holy_seal_equip_add_honor_ret,{
	role_id = 0,
	career_lv = 0,
	max_index = 0,
	err_code = 0
	}).

-define(CMD_U2GS_relic_holy_equip_skill_req,18202).
-record(pk_U2GS_relic_holy_equip_skill_req,{
	pos = 0,
	relic_id = 0
	}).

-define(CMD_GS2U_relic_holy_equip_skill_ret,39936).
-record(pk_GS2U_relic_holy_equip_skill_ret,{
	pos = 0,
	relic_id = 0,
	err_code = 0
	}).

-define(CMD_GS2U_relic_update_skill_list,15590).
-record(pk_GS2U_relic_update_skill_list,{
	skill_list = []
	}).

-define(CMD_GS2U_relic_illusion_player_info,38365).
-record(pk_GS2U_relic_illusion_player_info,{
	relic_eq = 0,
	relic_illusion_list = []
	}).

-define(CMD_U2GS_relic_illusion_up_level,41690).
-record(pk_U2GS_relic_illusion_up_level,{
	relic_id = 0,
	add_level = 0
	}).

-define(CMD_GS2U_relic_illusion_up_level_ret,54539).
-record(pk_GS2U_relic_illusion_up_level_ret,{
	relic_id = 0,
	add_level = 0,
	err_code = 0
	}).

-define(CMD_U2GS_relic_illusion_rein,38713).
-record(pk_U2GS_relic_illusion_rein,{
	relic_id = 0
	}).

-define(CMD_GS2U_relic_illusion_rein_ret,48014).
-record(pk_GS2U_relic_illusion_rein_ret,{
	relic_id = 0,
	err_code = 0
	}).

-define(CMD_U2GS_relic_illusion_eq,10108).
-record(pk_U2GS_relic_illusion_eq,{
	relic_id = 0,
	type = 0
	}).

-define(CMD_GS2U_relic_illusion_eq_ret,46128).
-record(pk_GS2U_relic_illusion_eq_ret,{
	relic_id = 0,
	type = 0,
	err_code = 0
	}).

-define(CMD_U2GS_MouthSubscribeDailyGiftReq,63517).
-record(pk_U2GS_MouthSubscribeDailyGiftReq,{
	}).

-define(CMD_GS2U_MouthSubscribeDailyGiftRet,19714).
-record(pk_GS2U_MouthSubscribeDailyGiftRet,{
	error = 0
	}).

-define(CMD_GS2U_LevelSealSync,43119).
-record(pk_GS2U_LevelSealSync,{
	id = 0,
	state = 0,
	player_id = 0,
	player_name = "",
	player_sex = 0,
	is_award = 0,
	open_time = 0,
	release_time = 0
	}).

-define(CMD_U2GS_GetLevelSealUI,38169).
-record(pk_U2GS_GetLevelSealUI,{
	}).

-define(CMD_GS2U_GetLevelSealUIRet,4224).
-record(pk_GS2U_GetLevelSealUIRet,{
	id = 0,
	state = 0,
	open_time = 0,
	release_time = 0,
	player_id = 0,
	player_name = "",
	player_sex = 0,
	leader_role = #pk_roleModel{},
	level_num = 0,
	my_break_level = 0,
	is_award = 0
	}).

-define(CMD_U2GS_LevelSealGetReward,26338).
-record(pk_U2GS_LevelSealGetReward,{
	}).

-define(CMD_GS2U_LevelSealGetRewardRet,22763).
-record(pk_GS2U_LevelSealGetRewardRet,{
	err_code = 0
	}).

-define(CMD_U2GS_GetLevelSealPlayerInfo,11467).
-record(pk_U2GS_GetLevelSealPlayerInfo,{
	}).

-define(CMD_GS2U_GetLevelSealPlayerInfoRet,50935).
-record(pk_GS2U_GetLevelSealPlayerInfoRet,{
	id = 0,
	power = 0,
	challenge_area = [],
	open_area = [],
	shop = []
	}).

-define(CMD_U2GS_EnterLevelSealDungeon,3600).
-record(pk_U2GS_EnterLevelSealDungeon,{
	id = 0,
	type = 0,
	x = 0,
	y = 0
	}).

-define(CMD_GS2U_EnterLevelSealDungeonRet,6153).
-record(pk_GS2U_EnterLevelSealDungeonRet,{
	id = 0,
	type = 0,
	x = 0,
	y = 0,
	err_code = 0
	}).

-define(CMD_GS2U_LevelSealDungeonSync,48343).
-record(pk_GS2U_LevelSealDungeonSync,{
	kill_num = 0,
	cur_num = 0,
	exp = 0
	}).

-define(CMD_GS2U_LevelSealDungeonSettle,24801).
-record(pk_GS2U_LevelSealDungeonSettle,{
	is_win = 0,
	exp = 0,
	energy = 0,
	items = [],
	coins = [],
	eqs = []
	}).

-define(CMD_U2GS_LevelSealResetMap,65489).
-record(pk_U2GS_LevelSealResetMap,{
	id = 0,
	type = 0
	}).

-define(CMD_GS2U_LevelSealResetMapRet,36801).
-record(pk_GS2U_LevelSealResetMapRet,{
	id = 0,
	type = 0,
	challenge_area = [],
	open_area = [],
	err_code = 0
	}).

-define(CMD_U2GS_LevelSealShopping,621).
-record(pk_U2GS_LevelSealShopping,{
	id = 0,
	type = 0,
	item_num = 0
	}).

-define(CMD_GS2U_LevelSealShoppingRet,31980).
-record(pk_GS2U_LevelSealShoppingRet,{
	id = 0,
	type = 0,
	item_num = 0,
	err_code = 0
	}).

-define(CMD_GS2U_LevelSealAddEnergy,53614).
-record(pk_GS2U_LevelSealAddEnergy,{
	item_id = 0,
	use_num = 0,
	add_energy = 0
	}).

-define(CMD_wheelRewardItem,58247).
-record(pk_wheelRewardItem,{
	index = 0,
	tp = 0,
	career = 0,
	bind = 0,
	p1 = 0,
	p2 = 0,
	chara = 0,
	star = 0,
	show_vfx = 0
	}).

-define(CMD_wheelBaseInfo,10994).
-record(pk_wheelBaseInfo,{
	times = [],
	pro_list = [],
	purchase_list = [],
	itemSp_list = [],
	itemCom_list = [],
	sit_list = [],
	probability_text = "",
	show_award_item = [],
	model = [],
	advertising_text = ""
	}).

-define(CMD_wheelChangeInfo,25477).
-record(pk_wheelChangeInfo,{
	index = 0,
	isServer = 0,
	item = #pk_wheelRewardItem{},
	integral = 0,
	changeTimes = 0,
	discount = 0
	}).

-define(CMD_wheelTop,11373).
-record(pk_wheelTop,{
	index = 0,
	startR = 0,
	endR = 0,
	list = []
	}).

-define(CMD_wheelItem,56579).
-record(pk_wheelItem,{
	index = 0,
	type = 0,
	param1 = 0,
	param2 = 0,
	bind = 0,
	chara = 0,
	star = 0,
	times = 0
	}).

-define(CMD_wheelChange,14189).
-record(pk_wheelChange,{
	index = 0,
	isServer = 0,
	times = 0
	}).

-define(CMD_wheeltopRank,11338).
-record(pk_wheeltopRank,{
	playerID = 0,
	name = "",
	head_id = 0,
	frame_id = 0,
	value = 0,
	time = 0
	}).

-define(CMD_wheel_record,44666).
-record(pk_wheel_record,{
	player_text = "",
	type = 0,
	param1 = 0,
	param2 = 0,
	chara = 0,
	star = 0,
	times = 0,
	time = 0
	}).

-define(CMD_treasurePercent,57654).
-record(pk_treasurePercent,{
	percent = 0,
	num = 0
	}).

-define(CMD_treasureRecord,64755).
-record(pk_treasureRecord,{
	time = 0,
	name = "",
	rate = 0,
	num = 0
	}).

-define(CMD_GS2U_lucky_wheel_info_ret,58737).
-record(pk_GS2U_lucky_wheel_info_ret,{
	id = 0,
	err = 0,
	wheel_base_info = #pk_wheelBaseInfo{},
	convPoint = 0,
	changeInfo_list = [],
	changeIntegral = 0,
	itemCount = 0,
	luckyPointPer = 0,
	luckyPointMax = 0,
	luckyIntegral = 0,
	luckyOrder = 0,
	change_list = []
	}).

-define(CMD_GS2U_rank_wheel_info_ret,15154).
-record(pk_GS2U_rank_wheel_info_ret,{
	id = 0,
	err = 0,
	wheel_base_info = #pk_wheelBaseInfo{},
	drawn_times = 0,
	convPoint = 0,
	changeInfo_list = [],
	top_award_list = [],
	show_rank = [],
	changeIntegral = 0,
	itemCount = 0,
	luckyPointPer = 0,
	luckyPointMax = 0,
	luckyIntegral = 0,
	luckyOrder = 0,
	rankBase = 0,
	rankNum = 0,
	top_list = []
	}).

-define(CMD_GS2U_treasure_wheel_info_ret,32880).
-record(pk_GS2U_treasure_wheel_info_ret,{
	id = 0,
	err = 0,
	wheel_base_info = #pk_wheelBaseInfo{},
	drawn_times = 0,
	convPoint = 0,
	changeInfo_list = [],
	top_award_list = [],
	show_rank = [],
	changeIntegral = 0,
	itemCount = 0,
	luckyPointPer = 0,
	luckyPointMax = 0,
	luckyIntegral = 0,
	luckyOrder = 0,
	rankBase = 0,
	rankNum = 0,
	top_list = [],
	wealthTime = 0,
	salIntegral = 0
	}).

-define(CMD_GS2U_maze_wheel_info_ret,49559).
-record(pk_GS2U_maze_wheel_info_ret,{
	id = 0,
	err = 0,
	wheel_base_info = #pk_wheelBaseInfo{},
	drawn_times = 0,
	convPoint = 0,
	changeInfo_list = [],
	top_award_list = [],
	show_rank = [],
	changeIntegral = 0,
	itemCount = 0,
	luckyPointPer = 0,
	luckyPointMax = 0,
	luckyIntegral = 0,
	luckyOrder = 0,
	rankBase = 0,
	rankNum = 0,
	top_list = []
	}).

-define(CMD_GS2U_matrix_wheel_info_ret,47315).
-record(pk_GS2U_matrix_wheel_info_ret,{
	id = 0,
	err = 0,
	wheel_base_info = #pk_wheelBaseInfo{},
	convPoint = 0,
	changeInfo_list = [],
	top_award_list = [],
	show_rank = [],
	changeIntegral = 0,
	itemCount = 0,
	luckyPointPer = 0,
	luckyPointMax = 0,
	luckyIntegral = 0,
	luckyOrder = 0,
	rankBase = 0,
	rankNum = 0,
	top_list = []
	}).

-define(CMD_U2GS_wheelRecordMsgReq,20820).
-record(pk_U2GS_wheelRecordMsgReq,{
	id = 0,
	isServer = 0
	}).

-define(CMD_GS2U_wheelRecordMsg,18449).
-record(pk_GS2U_wheelRecordMsg,{
	id = 0,
	isServer = 0,
	sp_list = [],
	com_list = [],
	mix_list = [],
	limit_list = []
	}).

-define(CMD_U2GS_drawn_wheel,50233).
-record(pk_U2GS_drawn_wheel,{
	id = 0,
	times = 0
	}).

-define(CMD_U2GS_drawn_wheel_ret,22845).
-record(pk_U2GS_drawn_wheel_ret,{
	id = 0,
	err = 0
	}).

-define(CMD_GS2U_drawn_luck_wheel_ret,46579).
-record(pk_GS2U_drawn_luck_wheel_ret,{
	id = 0,
	err = 0,
	times = 0,
	changeIntegral = 0,
	itemCount = 0,
	itemSp_list = [],
	itemCom_list = [],
	luckyIntegral = 0
	}).

-define(CMD_GS2U_drawn_rank_wheel_ret,23429).
-record(pk_GS2U_drawn_rank_wheel_ret,{
	id = 0,
	err = 0,
	times = 0,
	changeIntegral = 0,
	itemCount = 0,
	itemSp_list = [],
	itemCom_list = [],
	luckyIntegral = 0
	}).

-define(CMD_GS2U_drawn_treasure_wheel_ret,724).
-record(pk_GS2U_drawn_treasure_wheel_ret,{
	id = 0,
	err = 0,
	times = 0,
	changeIntegral = 0,
	itemCount = 0,
	itemSp_list = [],
	itemCom_list = [],
	salIntegral = 0,
	per_list = [],
	luckyIntegral = 0
	}).

-define(CMD_GS2U_drawn_maze_wheel_ret,50974).
-record(pk_GS2U_drawn_maze_wheel_ret,{
	id = 0,
	err = 0,
	times = 0,
	changeIntegral = 0,
	itemCount = 0,
	itemSp_list = [],
	itemCom_list = [],
	luckyIntegral = 0
	}).

-define(CMD_GS2U_drawn_matrix_wheel_ret,13432).
-record(pk_GS2U_drawn_matrix_wheel_ret,{
	id = 0,
	err = 0,
	times = 0,
	changeIntegral = 0,
	itemCount = 0,
	itemSp_list = [],
	itemCom_list = [],
	luckyIntegral = 0
	}).

-define(CMD_U2GS_exchange_wheel_item,42431).
-record(pk_U2GS_exchange_wheel_item,{
	id = 0,
	index = 0,
	times = 0
	}).

-define(CMD_GS2U_exchange_wheel_item_ret,22541).
-record(pk_GS2U_exchange_wheel_item_ret,{
	id = 0,
	err = 0,
	index = 0,
	changeIntegral = 0,
	change_list = []
	}).

-define(CMD_U2GS_get_wheel_temp_bag_info,35867).
-record(pk_U2GS_get_wheel_temp_bag_info,{
	id = 0
	}).

-define(CMD_GS2U_get_wheel_temp_bag_info_ret,30422).
-record(pk_GS2U_get_wheel_temp_bag_info_ret,{
	bag_list = []
	}).

-define(CMD_U2GS_get_out_wheel_temp_bag,2209).
-record(pk_U2GS_get_out_wheel_temp_bag,{
	id = 0,
	isAll = 0,
	type = 0,
	param1 = 0,
	param2 = 0,
	bind = 0,
	chara = 0,
	star = 0
	}).

-define(CMD_GS2U_get_out_wheel_temp_bag_ret,15588).
-record(pk_GS2U_get_out_wheel_temp_bag_ret,{
	id = 0,
	err = 0,
	itemCount = 0,
	isAll = 0,
	type = 0,
	param1 = 0,
	param2 = 0,
	bind = 0,
	chara = 0,
	star = 0
	}).

-define(CMD_U2GS_get_out_wheel_temp_bag_all,59044).
-record(pk_U2GS_get_out_wheel_temp_bag_all,{
	id_list = []
	}).

-define(CMD_GS2U_get_out_wheel_temp_bag_all_ret,64432).
-record(pk_GS2U_get_out_wheel_temp_bag_all_ret,{
	id_list = []
	}).

-define(CMD_U2GS_get_wheel_exchange_info,14376).
-record(pk_U2GS_get_wheel_exchange_info,{
	id = 0
	}).

-define(CMD_GS2U_get_wheel_exchange_info_ret,45977).
-record(pk_GS2U_get_wheel_exchange_info_ret,{
	id = 0,
	err = 0,
	change_list = []
	}).

-define(CMD_GS2U_treasure_record_msg,16948).
-record(pk_GS2U_treasure_record_msg,{
	id = 0,
	record_list = []
	}).

-define(CMD_U2GS_get_wheel_top_list,15625).
-record(pk_U2GS_get_wheel_top_list,{
	id = 0
	}).

-define(CMD_GS2U_get_wheel_top_list_ret,28019).
-record(pk_GS2U_get_wheel_top_list_ret,{
	id = 0,
	rankNum = 0,
	top_list = []
	}).

-define(CMD_U2GS_buy_wheel_consume,6378).
-record(pk_U2GS_buy_wheel_consume,{
	id = 0,
	num = 0
	}).

-define(CMD_GS2U_buy_wheel_consume_ret,18556).
-record(pk_GS2U_buy_wheel_consume_ret,{
	id = 0,
	num = 0,
	err = 0
	}).

-define(CMD_GS2U_wheel_top_rank_update,37016).
-record(pk_GS2U_wheel_top_rank_update,{
	id = 0,
	rank = 0
	}).

-define(CMD_GS2U_wheel_top_rank_down,47209).
-record(pk_GS2U_wheel_top_rank_down,{
	id = 0,
	old_rank = 0,
	new_rank = 0
	}).

-define(CMD_GS2U_wheel_drawn_notice,41763).
-record(pk_GS2U_wheel_drawn_notice,{
	id = 0,
	ref_id = 0,
	num = 0
	}).

-define(CMD_IndexAwardCond,43894).
-record(pk_IndexAwardCond,{
	index = 0,
	donate_num = 0,
	type = 0,
	time = 0,
	is_notice = 0
	}).

-define(CMD_donate_roulette,55846).
-record(pk_donate_roulette,{
	task_id = [],
	consWay = [],
	cons_award_item = [],
	serverCond = [],
	serverAward = [],
	serverDrop = [],
	playerCond = [],
	playerAward = [],
	model = []
	}).

-define(CMD_DonateRouletteRecord,18089).
-record(pk_DonateRouletteRecord,{
	name = "",
	coin = [],
	item = [],
	eq = [],
	time = 0
	}).

-define(CMD_GS2U_donate_roulette_ret,60675).
-record(pk_GS2U_donate_roulette_ret,{
	id = 0,
	err = 0,
	info = #pk_donate_roulette{},
	server_donate_sum = 0,
	server_awards = [],
	player_donate_sum = 0,
	player_awards = [],
	convPoint = 0,
	changeInfo_list = [],
	change_list = [],
	change_score = 0
	}).

-define(CMD_U2GS_DonateRouletteDonateReq,39476).
-record(pk_U2GS_DonateRouletteDonateReq,{
	id = 0,
	type = 0,
	times = 0
	}).

-define(CMD_GS2U_DonateRouletteDonateRet,59780).
-record(pk_GS2U_DonateRouletteDonateRet,{
	err_code = 0,
	id = 0,
	type = 0,
	times = 0,
	add_times = 0
	}).

-define(CMD_U2GS_DonateRouletteGetReward,35261).
-record(pk_U2GS_DonateRouletteGetReward,{
	id = 0,
	type = 0,
	index = 0
	}).

-define(CMD_GS2U_DonateRouletteGetReward,44015).
-record(pk_GS2U_DonateRouletteGetReward,{
	id = 0,
	type = 0,
	index = 0,
	err_code = 0
	}).

-define(CMD_U2GS_GetDonateRouletteRecordReq,54128).
-record(pk_U2GS_GetDonateRouletteRecordReq,{
	id = 0
	}).

-define(CMD_GS2U_GetDonateRouletteRecordRet,10325).
-record(pk_GS2U_GetDonateRouletteRecordRet,{
	id = 0,
	record_list = []
	}).

-define(CMD_GS2U_AddDonateRouletteRecord,31021).
-record(pk_GS2U_AddDonateRouletteRecord,{
	id = 0,
	record = #pk_DonateRouletteRecord{}
	}).

-define(CMD_U2GS_donate_roulette_exchange_item,1123).
-record(pk_U2GS_donate_roulette_exchange_item,{
	id = 0,
	index = 0,
	times = 0
	}).

-define(CMD_GS2U_donate_roulette_exchange_item_ret,53654).
-record(pk_GS2U_donate_roulette_exchange_item_ret,{
	id = 0,
	err = 0,
	index = 0,
	change_list = [],
	change_score = 0
	}).

-define(CMD_U2GS_DonateRoulettePlayerInfoReq,34500).
-record(pk_U2GS_DonateRoulettePlayerInfoReq,{
	id = 0
	}).

-define(CMD_GS2U_DonateRoulettePlayerInfoRet,47853).
-record(pk_GS2U_DonateRoulettePlayerInfoRet,{
	err_code = 0,
	id = 0,
	server_donate_sum = 0,
	server_awards = [],
	player_donate_sum = 0,
	player_awards = [],
	change_score = 0
	}).

-define(CMD_Fashion,52574).
-record(pk_Fashion,{
	fashion_id = 0,
	color1 = 0,
	color2 = 0,
	star = 0,
	expire_time = 0
	}).

-define(CMD_FashionRole,38530).
-record(pk_FashionRole,{
	role_id = 0,
	weapon = 0,
	head = 0,
	body = 0,
	ornament = 0,
	suit = 0
	}).

-define(CMD_GS2U_fashion_player,52119).
-record(pk_GS2U_fashion_player,{
	wardrobe_lv = 0,
	wardrobe_exp = 0,
	fashion_list = [],
	fashion_role_list = []
	}).

-define(CMD_GS2U_update_fashion_role,44279).
-record(pk_GS2U_update_fashion_role,{
	fashion_role_list = []
	}).

-define(CMD_GS2U_update_fashion,4373).
-record(pk_GS2U_update_fashion,{
	fashion_list = []
	}).

-define(CMD_U2GS_dress_up_active_fashion_req,53601).
-record(pk_U2GS_dress_up_active_fashion_req,{
	fashion_id = 0
	}).

-define(CMD_GS2U_dress_up_active_fashion_ret,1418).
-record(pk_GS2U_dress_up_active_fashion_ret,{
	fashion_id = 0,
	err_code = 0
	}).

-define(CMD_U2GS_dress_up_active_topic_req,23208).
-record(pk_U2GS_dress_up_active_topic_req,{
	topic_id = 0
	}).

-define(CMD_GS2U_dress_up_active_topic_ret,27211).
-record(pk_GS2U_dress_up_active_topic_ret,{
	topic_id = 0,
	success_list = [],
	err_code = 0
	}).

-define(CMD_U2GS_dress_up_fashion_add_star_req,44902).
-record(pk_U2GS_dress_up_fashion_add_star_req,{
	fashion_id = 0
	}).

-define(CMD_GS2U_dress_up_fashion_add_star_ret,33452).
-record(pk_GS2U_dress_up_fashion_add_star_ret,{
	fashion_id = 0,
	err_code = 0
	}).

-define(CMD_U2GS_dress_up_fashion_dyeing_req,8793).
-record(pk_U2GS_dress_up_fashion_dyeing_req,{
	fashion_id = 0,
	index_color_list = []
	}).

-define(CMD_GS2U_dress_up_fashion_dyeing_ret,22147).
-record(pk_GS2U_dress_up_fashion_dyeing_ret,{
	fashion_id = 0,
	index_color_list = [],
	err_code = 0
	}).

-define(CMD_U2GS_dress_up_fashion_equip_req,38137).
-record(pk_U2GS_dress_up_fashion_equip_req,{
	fashion_id = 0
	}).

-define(CMD_GS2U_dress_up_fashion_equip_ret,59871).
-record(pk_GS2U_dress_up_fashion_equip_ret,{
	fashion_id = 0,
	err_code = 0
	}).

-define(CMD_U2GS_dress_up_fashion_topic_equip_req,27238).
-record(pk_U2GS_dress_up_fashion_topic_equip_req,{
	topic_id = 0,
	is_equip = 0
	}).

-define(CMD_GS2U_dress_up_fashion_topic_equip_ret,64449).
-record(pk_GS2U_dress_up_fashion_topic_equip_ret,{
	topic_id = 0,
	is_equip = 0,
	err_code = 0
	}).

-define(CMD_U2GS_dress_up_appearance_change_req,29445).
-record(pk_U2GS_dress_up_appearance_change_req,{
	role_id = 0,
	change_list = []
	}).

-define(CMD_GS2U_dress_up_appearance_change_ret,32553).
-record(pk_GS2U_dress_up_appearance_change_ret,{
	role_id = 0,
	change_list = [],
	err_code = 0
	}).

-define(CMD_GS2U_dress_up_active_fashion,46826).
-record(pk_GS2U_dress_up_active_fashion,{
	item_id = 0
	}).

-define(CMD_GS2U_dress_up_fashion_expire,32624).
-record(pk_GS2U_dress_up_fashion_expire,{
	fashion_id = 0
	}).

-define(CMD_U2GS_dress_up_set_show_helmet,61337).
-record(pk_U2GS_dress_up_set_show_helmet,{
	is_show = 0
	}).

-define(CMD_dp_player_buy,700).
-record(pk_dp_player_buy,{
	goods_id = 0,
	daily_times = 0,
	total_times = 0
	}).

-define(CMD_dp_stc,9001).
-record(pk_dp_stc,{
	goods_id = 0,
	name = "",
	item_list = [],
	curr_type = #pk_key_value{},
	direct_purchase_code = "",
	discount = 0,
	limit = #pk_key_2value{},
	condition_type = #pk_key_value{},
	show_type = #pk_key_value{},
	character = 0,
	red_dot = 0,
	must_buy_label = 0
	}).

-define(CMD_dp_segment,36124).
-record(pk_dp_segment,{
	day = 0,
	text = "",
	item_show = 0,
	goods_list = [],
	buy_list = []
	}).

-define(CMD_GS2U_dp_summary_info_ret,10336).
-record(pk_GS2U_dp_summary_info_ret,{
	id = 0,
	err = 0,
	item_show = 0,
	goods_list = [],
	buy_list = []
	}).

-define(CMD_GS2U_dp_segment_info_ret,59904).
-record(pk_GS2U_dp_segment_info_ret,{
	id = 0,
	err = 0,
	goods_list = []
	}).

-define(CMD_U2GS_dp_summary_buy,47345).
-record(pk_U2GS_dp_summary_buy,{
	id = 0,
	goods_id = 0
	}).

-define(CMD_GS2U_dp_summary_buy_ret,13853).
-record(pk_GS2U_dp_summary_buy_ret,{
	id = 0,
	err = 0,
	goods_buy_info = #pk_dp_player_buy{}
	}).

-define(CMD_U2GS_dp_segment_buy,64638).
-record(pk_U2GS_dp_segment_buy,{
	id = 0,
	day = 0,
	goods_id = 0
	}).

-define(CMD_GS2U_dp_segment_buy_ret,1900).
-record(pk_GS2U_dp_segment_buy_ret,{
	id = 0,
	day = 0,
	err = 0,
	goods_buy_info = #pk_dp_player_buy{}
	}).

-define(CMD_ChapterBless,4338).
-record(pk_ChapterBless,{
	chapter = 0,
	bless_list = []
	}).

-define(CMD_GS2U_dungeons_bless_send_all_bless_list,7953).
-record(pk_GS2U_dungeons_bless_send_all_bless_list,{
	chapter_bless_list = []
	}).

-define(CMD_GS2U_dungeons_bless_update_pre_pick_bless,31430).
-record(pk_GS2U_dungeons_bless_update_pre_pick_bless,{
	bless_id = 0
	}).

-define(CMD_GS2U_dungeons_bless_send_bless_list,21686).
-record(pk_GS2U_dungeons_bless_send_bless_list,{
	bless_id_1 = 0,
	bless_id_2 = 0,
	bless_id_3 = 0
	}).

-define(CMD_U2GS_dungeons_bless_choose_bless_req,51706).
-record(pk_U2GS_dungeons_bless_choose_bless_req,{
	bless_id = 0
	}).

-define(CMD_GS2U_dungeons_bless_choose_bless_ret,65091).
-record(pk_GS2U_dungeons_bless_choose_bless_ret,{
	bless_id = 0,
	err_code = 0
	}).

-define(CMD_U2GS_getLoopModelShow,39060).
-record(pk_U2GS_getLoopModelShow,{
	id = 0,
	num = 0
	}).

-define(CMD_GS2U_getLoopModelShowRet,25432).
-record(pk_GS2U_getLoopModelShowRet,{
	id = 0,
	num = 0,
	show_list = []
	}).

-define(CMD_GS2U_serverSealSync,44601).
-record(pk_GS2U_serverSealSync,{
	id = 0,
	level = 0,
	unlock_time = 0,
	first_player_name = "",
	first_player_sex = 0,
	last_first_player_id = 0,
	seal_honor_lv = 0,
	seal_honor_exp = 0,
	last_seal_honor_lv = 0,
	recent_id = 0,
	last_id = 0,
	release_level = 0,
	history_list = [],
	last_finish_id = 0
	}).

-define(CMD_U2GS_upSealHonorLv,27792).
-record(pk_U2GS_upSealHonorLv,{
	}).

-define(CMD_GS2U_upSealHonorLvRet,62449).
-record(pk_GS2U_upSealHonorLvRet,{
	err_code = 0,
	new_lv = 0,
	new_exp = 0
	}).

-define(CMD_U2GS_breakServerSeal,42776).
-record(pk_U2GS_breakServerSeal,{
	}).

-define(CMD_GS2U_breakServerSealRet,28503).
-record(pk_GS2U_breakServerSealRet,{
	err_code = 0,
	first_player_id = 0,
	old_seal_honor_lv = 0,
	new_seal_honor_lv = 0,
	old_lv = 0,
	new_lv = 0,
	new_last_id = 0
	}).

-define(CMD_ActiveExchange,63318).
-record(pk_ActiveExchange,{
	index = 0,
	item_new = [],
	discount = 0,
	cost_list = [],
	limit = []
	}).

-define(CMD_GS2U_change_active_ret,44508).
-record(pk_GS2U_change_active_ret,{
	id = 0,
	err = 0,
	exchange_list = [],
	change_list = [],
	follow_list = []
	}).

-define(CMD_U2GS_change_active_exchange_req,17887).
-record(pk_U2GS_change_active_exchange_req,{
	id = 0,
	index = 0,
	times = 0
	}).

-define(CMD_GS2U_change_active_exchange_ret,39622).
-record(pk_GS2U_change_active_exchange_ret,{
	id = 0,
	index = 0,
	times = 0,
	err_code = 0
	}).

-define(CMD_U2GS_change_active_follow_req,52244).
-record(pk_U2GS_change_active_follow_req,{
	id = 0,
	is_follow = 0,
	index = 0
	}).

-define(CMD_GS2U_change_active_follow_ret,50291).
-record(pk_GS2U_change_active_follow_ret,{
	id = 0,
	is_follow = 0,
	index = 0,
	err_code = 0
	}).

-define(CMD_U2GS_feed_back_req,18931).
-record(pk_U2GS_feed_back_req,{
	mail_address = "",
	content = ""
	}).

-define(CMD_GS2U_feed_back_ret,22644).
-record(pk_GS2U_feed_back_ret,{
	err_code = 0
	}).

-define(CMD_glory_badge_base_info,25333).
-record(pk_glory_badge_base_info,{
	buyExp = #pk_key_2value{},
	dailyReward = [],
	advancedConsume = #pk_key_value{},
	directPurchase = "",
	advancedtext = "",
	advancedIconItem = [],
	extremeAdvancedConsume = #pk_key_value{},
	extremeDirectPurchase = "",
	extremeAdvancedtext = "",
	extremeAdvancedIconItem = [],
	battlePassPic = [],
	battlePassPic1 = [],
	battlePassText = "",
	battlePassItem = [],
	lable_banner1 = "",
	lable_banner2 = "",
	lable_banner3 = ""
	}).

-define(CMD_glory_badge_award_item,42383).
-record(pk_glory_badge_award_item,{
	index = 0,
	type = 0,
	itemID = 0,
	count = 0,
	bind = 0,
	effect = 0,
	quality = 0,
	star = 0,
	sort = 0
	}).

-define(CMD_glory_badge_lv_cfg,14257).
-record(pk_glory_badge_lv_cfg,{
	lv = 0,
	exp = 0,
	awardItem1 = [],
	awardItem2 = [],
	awardItem3 = [],
	show = 0
	}).

-define(CMD_glory_badge_goods,30502).
-record(pk_glory_badge_goods,{
	index = 0,
	sort = 0,
	item = #pk_indexTypeItem{},
	curr_type = #pk_key_value{},
	limit = #pk_key_2value{},
	show = 0,
	push = 0,
	condition_type = #pk_key_value{},
	show_type = #pk_key_value{}
	}).

-define(CMD_GS2U_dragon_badge_ret,35129).
-record(pk_GS2U_dragon_badge_ret,{
	id = 0,
	err = 0,
	base_info = #pk_glory_badge_base_info{},
	lv_list = [],
	goods_list = [],
	lv = 0,
	exp = 0,
	rank_flag = 0,
	lv_award = [],
	daily_reward = 0,
	goods_buy = [],
	next_reset_time = 0,
	daily_conditionInfo = [],
	daily_achieveList = [],
	daily_hasAchieveList = [],
	weekly_conditionInfo = [],
	weekly_achieveList = [],
	weekly_hasAchieveList = []
	}).

-define(CMD_U2GS_DragonBadgeActivityAdvance,57419).
-record(pk_U2GS_DragonBadgeActivityAdvance,{
	id = 0,
	type = 0
	}).

-define(CMD_GS2U_DragonBadgeActivityAdvanceRet,56655).
-record(pk_GS2U_DragonBadgeActivityAdvanceRet,{
	id = 0,
	type = 0,
	err_code = 0
	}).

-define(CMD_U2GS_DragonBadgeActivityBuyExp,29788).
-record(pk_U2GS_DragonBadgeActivityBuyExp,{
	id = 0,
	level = 0
	}).

-define(CMD_GS2U_DragonBadgeActivityBuyExpRet,1163).
-record(pk_GS2U_DragonBadgeActivityBuyExpRet,{
	id = 0,
	lv = 0,
	exp = 0,
	err_code = 0
	}).

-define(CMD_U2GS_DragonBadgeActivityLvReward,31792).
-record(pk_U2GS_DragonBadgeActivityLvReward,{
	id = 0
	}).

-define(CMD_GS2U_DragonBadgeActivityLvRet,55112).
-record(pk_GS2U_DragonBadgeActivityLvRet,{
	id = 0,
	lv_award = [],
	err_code = 0
	}).

-define(CMD_U2GS_DragonBadgeActivityDaily,15230).
-record(pk_U2GS_DragonBadgeActivityDaily,{
	id = 0
	}).

-define(CMD_GS2U_DragonBadgeActivityDailyRet,55433).
-record(pk_GS2U_DragonBadgeActivityDailyRet,{
	id = 0,
	err_code = 0
	}).

-define(CMD_U2GS_DragonBadgeActivityBuyGoods,27717).
-record(pk_U2GS_DragonBadgeActivityBuyGoods,{
	id = 0,
	goods_id = 0,
	times = 0
	}).

-define(CMD_GS2U_DragonBadgeActivityBuyGoodsRet,33807).
-record(pk_GS2U_DragonBadgeActivityBuyGoodsRet,{
	id = 0,
	goods_id = 0,
	times = 0,
	err_code = 0
	}).

-define(CMD_server_seal_contest,47373).
-record(pk_server_seal_contest,{
	id = 0,
	order = 0,
	name = "",
	promote = "",
	open_day = 0,
	duration_day = 0,
	reward_cond = [],
	lv_min = 0,
	title_icon = "",
	level = 0,
	rank_show_max = 0
	}).

-define(CMD_server_seal_contest_gift,49414).
-record(pk_server_seal_contest_gift,{
	id = 0,
	order = 0,
	gift_order = 0,
	award_item = []
	}).

-define(CMD_server_seal_contest_gift_personal,3801).
-record(pk_server_seal_contest_gift_personal,{
	id = 0,
	gift_order = 0,
	condition = 0,
	award_item = []
	}).

-define(CMD_server_seal_contest_rank,18720).
-record(pk_server_seal_contest_rank,{
	rank = 0,
	name = "",
	value = 0,
	time = 0
	}).

-define(CMD_GS2U_server_seal_contest_cfg,33598).
-record(pk_GS2U_server_seal_contest_cfg,{
	base_list = [],
	gift_list = [],
	personal_gift_list = [],
	award_p_gift_list = []
	}).

-define(CMD_U2GS_server_seal_contest_info,10563).
-record(pk_U2GS_server_seal_contest_info,{
	id = 0,
	order = 0
	}).

-define(CMD_GS2U_server_seal_contest_info_ret,23764).
-record(pk_GS2U_server_seal_contest_info_ret,{
	id = 0,
	order = 0,
	rank = 0,
	value = 0
	}).

-define(CMD_U2GS_server_seal_contest_top,63984).
-record(pk_U2GS_server_seal_contest_top,{
	id = 0,
	day = 0
	}).

-define(CMD_GS2U_server_seal_contest_top_ret,11958).
-record(pk_GS2U_server_seal_contest_top_ret,{
	id = 0,
	day = 0,
	top_list = [],
	my_rank = 0,
	my_value = 0
	}).

-define(CMD_U2GS_server_seal_contest_p_award,9209).
-record(pk_U2GS_server_seal_contest_p_award,{
	id = 0,
	gift_order = 0
	}).

-define(CMD_GS2U_server_seal_contest_p_award_ret,19036).
-record(pk_GS2U_server_seal_contest_p_award_ret,{
	id = 0,
	gift_order = 0,
	err_code = 0
	}).

-define(CMD_GS2U_server_seal_contest_rank_down,50396).
-record(pk_GS2U_server_seal_contest_rank_down,{
	type = 0
	}).

-define(CMD_career_tower_detail,61595).
-record(pk_career_tower_detail,{
	tower_id = 0,
	layer = 0,
	reward = 0,
	today_challenge_times = 0,
	total_challenge_times = 0
	}).

-define(CMD_GS2U_career_tower_info_sync,5890).
-record(pk_GS2U_career_tower_info_sync,{
	info_list = []
	}).

-define(CMD_GS2U_career_tower_update,47977).
-record(pk_GS2U_career_tower_update,{
	tower_info = #pk_career_tower_detail{}
	}).

-define(CMD_GS2U_career_tower_player_update,50354).
-record(pk_GS2U_career_tower_player_update,{
	reward_id = 0,
	pet_id = 0,
	yesterday_layer = 0,
	super_yesterday_layer = 0
	}).

-define(CMD_U2GS_career_tower_enter_req,61373).
-record(pk_U2GS_career_tower_enter_req,{
	dungeon_id = 0
	}).

-define(CMD_GS2U_career_tower_enter_req,33421).
-record(pk_GS2U_career_tower_enter_req,{
	dungeon_id = 0,
	err_code = 0
	}).

-define(CMD_GS2U_career_tower_settle_result,64610).
-record(pk_GS2U_career_tower_settle_result,{
	dungeon_id = 0,
	is_win = false,
	coinList = [],
	itemList = []
	}).

-define(CMD_U2GS_career_tower_mop_req,26964).
-record(pk_U2GS_career_tower_mop_req,{
	tower_id = 0
	}).

-define(CMD_GS2U_career_tower_mop_ret,11855).
-record(pk_GS2U_career_tower_mop_ret,{
	tower_id = 0,
	start_layer = 0,
	end_layer = 0,
	coinList = [],
	itemList = [],
	exp = 0,
	err_code = 0
	}).

-define(CMD_U2GS_career_tower_reward_req,48636).
-record(pk_U2GS_career_tower_reward_req,{
	tower_id = 0,
	reward_id = 0
	}).

-define(CMD_GS2U_career_tower_reward_ret,3403).
-record(pk_GS2U_career_tower_reward_ret,{
	tower_id = 0,
	reward_id = 0,
	err_code = 0
	}).

-define(CMD_U2GS_career_tower_set_pet_req,5344).
-record(pk_U2GS_career_tower_set_pet_req,{
	pet_id = 0
	}).

-define(CMD_GS2U_career_tower_set_pet_ret,3391).
-record(pk_GS2U_career_tower_set_pet_ret,{
	pet_id = 0,
	err_code = 0
	}).

-define(CMD_U2GS_career_tower_role_battle_value,26497).
-record(pk_U2GS_career_tower_role_battle_value,{
	tower_id = 0
	}).

-define(CMD_GS2U_career_tower_role_battle_value,18056).
-record(pk_GS2U_career_tower_role_battle_value,{
	role_id = 0,
	battle_value = 0,
	error_code = 0
	}).

-define(CMD_career_tower_first_pet,32646).
-record(pk_career_tower_first_pet,{
	pos = 0,
	cfg_id = 0,
	pet_star = 0,
	pet_lv = 0,
	pet_share_flag = 0
	}).

-define(CMD_career_tower_player,28862).
-record(pk_career_tower_player,{
	player_id = 0,
	time = 0,
	battle_value = 0,
	player_level = 0,
	head_id = 0,
	frame_id = 0,
	player_name = "",
	sex = 0,
	pet_list = []
	}).

-define(CMD_career_first_info,19104).
-record(pk_career_first_info,{
	layer = 0,
	is_reward = 0,
	player = #pk_career_tower_player{}
	}).

-define(CMD_U2GS_career_tower_red,55797).
-record(pk_U2GS_career_tower_red,{
	tower_id = 0
	}).

-define(CMD_GS2U_career_tower_redRet,48177).
-record(pk_GS2U_career_tower_redRet,{
	error_code = 0,
	tower_id = 0,
	layer_id = 0,
	max_layer = 0
	}).

-define(CMD_U2GS_career_tower_first_info,31516).
-record(pk_U2GS_career_tower_first_info,{
	tower_id = 0,
	dungeon_id_list = []
	}).

-define(CMD_GS2U_career_tower_first_info,40269).
-record(pk_GS2U_career_tower_first_info,{
	error_code = 0,
	tower_id = 0,
	dungeon_id_list = [],
	info_list = []
	}).

-define(CMD_U2GS_career_tower_first_layer,30568).
-record(pk_U2GS_career_tower_first_layer,{
	tower_id = 0,
	dungeon_id = 0
	}).

-define(CMD_GS2U_career_tower_first_layer,17066).
-record(pk_GS2U_career_tower_first_layer,{
	error_code = 0,
	tower_id = 0,
	dungeon_id = 0,
	info_list = []
	}).

-define(CMD_U2GS_career_tower_first_reward,23707).
-record(pk_U2GS_career_tower_first_reward,{
	tower_id = 0
	}).

-define(CMD_GS2U_career_tower_first_reward,16160).
-record(pk_GS2U_career_tower_first_reward,{
	error_code = 0,
	tower_id = 0,
	dungeon_id_list = []
	}).

-define(CMD_U2GS_career_tower_top,13439).
-record(pk_U2GS_career_tower_top,{
	tower_id = 0,
	dungeon_id = 0,
	num = 0,
	show_model = 0
	}).

-define(CMD_GS2U_career_tower_top_ret,1793).
-record(pk_GS2U_career_tower_top_ret,{
	error_code = 0,
	tower_id = 0,
	dungeon_id = 0,
	num = 0,
	show_model = 0,
	info_list = [],
	model_list = []
	}).

-define(CMD_GS2U_career_super_tower_redbag,413).
-record(pk_GS2U_career_super_tower_redbag,{
	id = 0,
	name = "",
	sex = 0,
	layer = 0
	}).

-define(CMD_U2GS_career_super_tower_redbag_get,53322).
-record(pk_U2GS_career_super_tower_redbag_get,{
	id = 0
	}).

-define(CMD_GS2U_career_super_tower_redbag_get_ret,5545).
-record(pk_GS2U_career_super_tower_redbag_get_ret,{
	error_code = 0,
	id = 0
	}).

-define(CMD_GS2U_cluster_first_open_time,52370).
-record(pk_GS2U_cluster_first_open_time,{
	first_open_time = 0
	}).

-define(CMD_GS2U_ac_weekly_card_info_ret,46113).
-record(pk_GS2U_ac_weekly_card_info_ret,{
	id = 0,
	err = 0,
	is_active = 0,
	type = 0,
	conditions = 0,
	recharge_num = 0,
	direct_purchase_code = "",
	item_list = [],
	award_day = 0
	}).

-define(CMD_U2GS_get_ac_weekly_card_award,64448).
-record(pk_U2GS_get_ac_weekly_card_award,{
	id = 0,
	day = 0
	}).

-define(CMD_GS2U_get_ac_weekly_card_award_ret,5898).
-record(pk_GS2U_get_ac_weekly_card_award_ret,{
	id = 0,
	day = 0,
	err_code = 0
	}).

-define(CMD_GS2U_ac_weekly_card_achieve,39296).
-record(pk_GS2U_ac_weekly_card_achieve,{
	id = 0
	}).

-define(CMD_luck_cat_stc,31507).
-record(pk_luck_cat_stc,{
	times = 0,
	condition = #pk_key_value{},
	consume = []
	}).

-define(CMD_lucky_cat_record,22641).
-record(pk_lucky_cat_record,{
	name = "",
	sex = 0,
	multiple = 0,
	reward = #pk_key_value{}
	}).

-define(CMD_GS2U_lucky_luck_info_ret,3756).
-record(pk_GS2U_lucky_luck_info_ret,{
	id = 0,
	err = 0,
	reward_type = 0,
	multiple = [],
	lucky_list = [],
	reach_cond_list = [],
	has_drawn_times = 0,
	probability_text = ""
	}).

-define(CMD_U2GS_lucky_cat_record,45741).
-record(pk_U2GS_lucky_cat_record,{
	}).

-define(CMD_GS2U_lucky_cat_record_ret,41862).
-record(pk_GS2U_lucky_cat_record_ret,{
	all_record = []
	}).

-define(CMD_U2GS_drawn_luck_cat,41279).
-record(pk_U2GS_drawn_luck_cat,{
	id = 0,
	is_one_key = 0
	}).

-define(CMD_GS2U_drawn_luck_cat_ret,25757).
-record(pk_GS2U_drawn_luck_cat_ret,{
	id = 0,
	err_code = 0,
	index = [],
	reward = []
	}).

-define(CMD_wanted_config,10327).
-record(pk_wanted_config,{
	cost = [],
	directPurchase = "",
	timeBuy = 0,
	nameText = "",
	overTime = 0
	}).

-define(CMD_GS2U_wanted_info_ret,43733).
-record(pk_GS2U_wanted_info_ret,{
	id = 0,
	err = 0,
	info = #pk_wanted_config{},
	is_buy = 0,
	recharge = 0,
	conditionInfo = [],
	achieveList = [],
	hasAchieveList = [],
	free_list = []
	}).

-define(CMD_U2GS_wanted_buy_ticket_req,30688).
-record(pk_U2GS_wanted_buy_ticket_req,{
	id = 0
	}).

-define(CMD_GS2U_wanted_buy_ticket_ret,49612).
-record(pk_GS2U_wanted_buy_ticket_ret,{
	id = 0,
	err = 0
	}).

-define(CMD_U2GS_wanted_get_conditional_award,44570).
-record(pk_U2GS_wanted_get_conditional_award,{
	id = 0,
	func_id = 0,
	index = 0
	}).

-define(CMD_GS2U_wanted_get_conditional_award_ret,24783).
-record(pk_GS2U_wanted_get_conditional_award_ret,{
	id = 0,
	func_id = 0,
	index = 0,
	err = 0,
	achieve_param = #pk_achieveParam{},
	free_list = []
	}).

-define(CMD_U2GS_reset_recharge_first,32887).
-record(pk_U2GS_reset_recharge_first,{
	}).

-define(CMD_GS2U_reset_recharge_first,6229).
-record(pk_GS2U_reset_recharge_first,{
	err_code = 0
	}).

-define(CMD_version_notice_config,14752).
-record(pk_version_notice_config,{
	id = 0,
	num = 0,
	pic = 0,
	item_new = [],
	type = 0,
	banner_text1 = "",
	image_text1 = [],
	banner_text2 = "",
	image_text2 = [],
	banner_text3 = "",
	image_text3 = []
	}).

-define(CMD_GS2U_version_notice,14374).
-record(pk_GS2U_version_notice,{
	id = 0,
	top_tile = "",
	notice_list = [],
	is_award = 0
	}).

-define(CMD_U2GS_version_notice_award,20679).
-record(pk_U2GS_version_notice_award,{
	id = 0
	}).

-define(CMD_GS2U_version_notice_award_ret,33419).
-record(pk_GS2U_version_notice_award_ret,{
	id = 0,
	err = 0
	}).

-define(CMD_ExpeditionHuntBossRankInfo,49292).
-record(pk_ExpeditionHuntBossRankInfo,{
	rank = 0,
	camp_id = 0,
	title_id = 0,
	name = "",
	fight_power = 0,
	use_time = 0,
	fight_time = 0,
	sex = 0,
	server_name = ""
	}).

-define(CMD_hunt_demon_rank_boss,50065).
-record(pk_hunt_demon_rank_boss,{
	camp_id = 0,
	nobility_id = 0,
	fight_power = 0,
	type = 0,
	type_yesterday = 0,
	fight_time = 0,
	yesterday_rank = 0,
	yesterday_time = 0,
	rank_list = []
	}).

-define(CMD_U2GS_GetExpeditionHuntBossRankList,45703).
-record(pk_U2GS_GetExpeditionHuntBossRankList,{
	}).

-define(CMD_GS2U_GetExpeditionHuntBossRankListRet,63041).
-record(pk_GS2U_GetExpeditionHuntBossRankListRet,{
	today_rank_list = [],
	yesterday_rank_list = [],
	my_time = 0,
	my_time_yesterday = 0,
	err_code = 0
	}).

-define(CMD_U2GS_GetExpeditionHuntBossAward,39078).
-record(pk_U2GS_GetExpeditionHuntBossAward,{
	}).

-define(CMD_GS2U_GetExpeditionHuntBossAwardRet,55483).
-record(pk_GS2U_GetExpeditionHuntBossAwardRet,{
	err_code = 0
	}).

-define(CMD_hunt_demon_st,10373).
-record(pk_hunt_demon_st,{
	level = 0,
	is_pass = false,
	is_challenge = false
	}).

-define(CMD_drop_item,14446).
-record(pk_drop_item,{
	itemID = 0,
	num = 0
	}).

-define(CMD_U2GS_get_hunt_demon_panel,50369).
-record(pk_U2GS_get_hunt_demon_panel,{
	}).

-define(CMD_GS2U_hunt_demon_panel,58634).
-record(pk_GS2U_hunt_demon_panel,{
	demon_info = [],
	season = 0,
	level = 0,
	phy_value = 0,
	next_recover_time = 0,
	season_star_score = 0,
	rank_boss = #pk_hunt_demon_rank_boss{}
	}).

-define(CMD_U2GS_challenge_demon_boss,23631).
-record(pk_U2GS_challenge_demon_boss,{
	level = 0
	}).

-define(CMD_GS2U_challenge_demon_boss_ret,54568).
-record(pk_GS2U_challenge_demon_boss_ret,{
	error_code = 0
	}).

-define(CMD_U2GS_sweep_demon_boss,39700).
-record(pk_U2GS_sweep_demon_boss,{
	level = 0,
	times = 0
	}).

-define(CMD_GS2U_sweep_demon_boss_ret,39156).
-record(pk_GS2U_sweep_demon_boss_ret,{
	error_code = 0,
	items = [],
	coins = []
	}).

-define(CMD_GS2U_update_hunt_demon_phy,62895).
-record(pk_GS2U_update_hunt_demon_phy,{
	phy_value = 0,
	next_recover_time = 0
	}).

-define(CMD_GS2U_update_demon_boss_info,62832).
-record(pk_GS2U_update_demon_boss_info,{
	demon_info = #pk_hunt_demon_st{}
	}).

-define(CMD_nobility_rank,32134).
-record(pk_nobility_rank,{
	player_id = 0,
	name = "",
	level = 0,
	headid = 0,
	frame = 0,
	fight = 0,
	vip = 0,
	career = 0,
	sex = 0,
	contribution = 0,
	rank = 0,
	nobility_id = 0,
	title_id = 0,
	award_status = 0,
	box_id = 0
	}).

-define(CMD_U2GS_get_nobility_info,56979).
-record(pk_U2GS_get_nobility_info,{
	}).

-define(CMD_GS2U_get_nobility_info_ret,16037).
-record(pk_GS2U_get_nobility_info_ret,{
	nobility_id = 0,
	contribution = 0,
	is_got = 0,
	director = [],
	score = 0,
	member_num = 0,
	times = 0,
	award_status = 0
	}).

-define(CMD_GS2U_team_member_change,13492).
-record(pk_GS2U_team_member_change,{
	member_num = 0
	}).

-define(CMD_U2GS_nobility_up,60570).
-record(pk_U2GS_nobility_up,{
	}).

-define(CMD_GS2U_nobility_up_ret,39310).
-record(pk_GS2U_nobility_up_ret,{
	error_code = 0,
	nobility_id = 0
	}).

-define(CMD_U2GS_get_team_reward,10814).
-record(pk_U2GS_get_team_reward,{
	}).

-define(CMD_GS2U_get_team_reward_ret,50398).
-record(pk_GS2U_get_team_reward_ret,{
	error_code = 0
	}).

-define(CMD_U2GS_get_salary,3233).
-record(pk_U2GS_get_salary,{
	}).

-define(CMD_GS2U_get_salary_ret,35991).
-record(pk_GS2U_get_salary_ret,{
	error_code = 0
	}).

-define(CMD_U2GS_get_team_rank,41456).
-record(pk_U2GS_get_team_rank,{
	}).

-define(CMD_GS2U_get_team_rank_ret,63577).
-record(pk_GS2U_get_team_rank_ret,{
	items = [],
	rank_list = []
	}).

-define(CMD_U2GS_get_contribution_rank,8160).
-record(pk_U2GS_get_contribution_rank,{
	}).

-define(CMD_GS2U_get_contribution_rank_ret,47223).
-record(pk_GS2U_get_contribution_rank_ret,{
	rank_list = []
	}).

-define(CMD_U2GS_set_team_player_award_status,25781).
-record(pk_U2GS_set_team_player_award_status,{
	player_id = 0,
	status = 0,
	item_id = 0
	}).

-define(CMD_GS2U_set_team_player_award_status_ret,50709).
-record(pk_GS2U_set_team_player_award_status_ret,{
	error_code = 0,
	rank = #pk_nobility_rank{}
	}).

-define(CMD_U2GS_get_global_contribution_rank,40063).
-record(pk_U2GS_get_global_contribution_rank,{
	}).

-define(CMD_GS2U_get_global_contribution_rank_ret,8088).
-record(pk_GS2U_get_global_contribution_rank_ret,{
	rank_list = []
	}).

-define(CMD_U2GS_challenge_other_camp_player,18479).
-record(pk_U2GS_challenge_other_camp_player,{
	player_id = 0
	}).

-define(CMD_GS2U_challenge_other_camp_player_ret,40020).
-record(pk_GS2U_challenge_other_camp_player_ret,{
	error_code = 0
	}).

-define(CMD_expedition_battle_info,29357).
-record(pk_expedition_battle_info,{
	player_id = 0,
	player_name = "",
	career = 0,
	level = 0,
	head_id = 0,
	head_frame = 0,
	camp_id = 0,
	title = 0,
	buff_id_list = [],
	fight = 0,
	role_list = []
	}).

-define(CMD_GS2U_expedition_battle_info,44796).
-record(pk_GS2U_expedition_battle_info,{
	info = []
	}).

-define(CMD_U2GS_exit_fail,6006).
-record(pk_U2GS_exit_fail,{
	}).

-define(CMD_GS2U_pvp_ensure_code,21922).
-record(pk_GS2U_pvp_ensure_code,{
	}).

-define(CMD_U2GS_pvp_ensure_code_ret,41934).
-record(pk_U2GS_pvp_ensure_code_ret,{
	}).

-define(CMD_ExpeditionPlayer,22604).
-record(pk_ExpeditionPlayer,{
	player_id = 0,
	camp_id = 0,
	name = "",
	sex = 0,
	career = 0,
	fight_power = 0,
	score = 0,
	title = 0,
	headid = 0,
	frame = 0,
	damage = 0,
	kill_num = 0,
	explore_num = 0,
	protect_timestamp = 0
	}).

-define(CMD_ExpeditionAwardInfo,41413).
-record(pk_ExpeditionAwardInfo,{
	time = 0,
	area_info_list = [],
	is_receive = 0,
	force_award = 0,
	is_join = 0
	}).

-define(CMD_ExpeditionInfo,54587).
-record(pk_ExpeditionInfo,{
	stage = 0,
	first_camp = 0,
	first_player = #pk_expedition_battle_info{},
	first_camp_title = 0,
	camp_title_list = []
	}).

-define(CMD_ExpeditionCampInfo,16843).
-record(pk_ExpeditionCampInfo,{
	camp_id = 0,
	publish_task_times = 0,
	leader1 = #pk_ExpeditionPlayer{},
	leader2 = #pk_ExpeditionPlayer{},
	leader3 = #pk_ExpeditionPlayer{},
	title = 0
	}).

-define(CMD_ExpeditionGroupInfo,28664).
-record(pk_ExpeditionGroupInfo,{
	group_id = 0,
	camp_id = 0,
	leader_id = 0,
	leader_name = "",
	score = 0,
	exploit = 0,
	power = 0
	}).

-define(CMD_ExpeditionTaskInfo,23916).
-record(pk_ExpeditionTaskInfo,{
	task_id = 0,
	camp_id = 0,
	type1 = 0,
	type2 = 0,
	target_area = 0,
	team_id = 0,
	team_leader_name = "",
	state = 0,
	progress = 0,
	target_score = 0
	}).

-define(CMD_ExpeditionCampFightInfo,4508).
-record(pk_ExpeditionCampFightInfo,{
	id = 0,
	camp_id = 0,
	type = 0,
	area_id = 0,
	time = 0,
	task_type = 0,
	task_score = 0
	}).

-define(CMD_ExpeditionPlayerFightInfo,32334).
-record(pk_ExpeditionPlayerFightInfo,{
	id = 0,
	area_id = 0,
	type = 0,
	enemt_title = 0,
	enemy_name = "",
	energy = 0,
	score = 0,
	time = 0
	}).

-define(CMD_ExpeditionAreaFightHelpInfo,50390).
-record(pk_ExpeditionAreaFightHelpInfo,{
	pos = 0,
	camp = 0,
	fight = false,
	area_info = []
	}).

-define(CMD_ExpeditionScoreRank,22587).
-record(pk_ExpeditionScoreRank,{
	rank = 0,
	name = "",
	sex = 0,
	server_id = 0,
	score = 0
	}).

-define(CMD_U2GS_GetExpeditionHistoryUI,21508).
-record(pk_U2GS_GetExpeditionHistoryUI,{
	}).

-define(CMD_GS2U_GetExpeditionHistoryUIRet,856).
-record(pk_GS2U_GetExpeditionHistoryUIRet,{
	info_list = [],
	err_code = 0
	}).

-define(CMD_U2GS_GetExpeditionUI,2896).
-record(pk_U2GS_GetExpeditionUI,{
	}).

-define(CMD_GS2U_GetExpeditionUIRet,12863).
-record(pk_GS2U_GetExpeditionUIRet,{
	info = #pk_ExpeditionInfo{},
	camp_info = #pk_ExpeditionCampInfo{},
	group_list = [],
	fight_info_list = [],
	title = 0,
	rank = 0,
	score = 0,
	group = 0,
	err_code = 0
	}).

-define(CMD_U2GS_GetExpeditionMapUI,3893).
-record(pk_U2GS_GetExpeditionMapUI,{
	}).

-define(CMD_GS2U_GetExpeditionMapUIRet,52486).
-record(pk_GS2U_GetExpeditionMapUIRet,{
	move_list = [],
	task_list = [],
	area_list = [],
	err_code = 0
	}).

-define(CMD_U2GS_GetExpeditionMoveList,39294).
-record(pk_U2GS_GetExpeditionMoveList,{
	}).

-define(CMD_GS2U_GetExpeditionMoveListRet,3920).
-record(pk_GS2U_GetExpeditionMoveListRet,{
	move_list = [],
	now_area = 0,
	contribution = 0,
	gather_city = 0,
	gather_cd = 0,
	gather_city_team = 0,
	gather_cd_team = 0,
	err_code = 0
	}).

-define(CMD_U2GS_GetExpeditionAreaInfo,40983).
-record(pk_U2GS_GetExpeditionAreaInfo,{
	area_id_list = []
	}).

-define(CMD_GS2U_GetExpeditionAreaInfoRet,28455).
-record(pk_GS2U_GetExpeditionAreaInfoRet,{
	err_code = 0,
	area_info_list = []
	}).

-define(CMD_GS2U_update_expedition_area_info,10395).
-record(pk_GS2U_update_expedition_area_info,{
	area_info = #pk_ExpeditionAreaFightHelpInfo{}
	}).

-define(CMD_U2GS_GetExpeditionAreaUI,61183).
-record(pk_U2GS_GetExpeditionAreaUI,{
	area_id = 0
	}).

-define(CMD_GS2U_GetExpeditionAreaUIRet,6921).
-record(pk_GS2U_GetExpeditionAreaUIRet,{
	area_id = 0,
	hp_rate = 0,
	our_num = [],
	our_buff = 0,
	enemy_num = [],
	err_code = 0
	}).

-define(CMD_GS2U_GetExpeditionAreaInfoSync,36796).
-record(pk_GS2U_GetExpeditionAreaInfoSync,{
	pos = 0,
	camp = 0
	}).

-define(CMD_role_key_value,47511).
-record(pk_role_key_value,{
	role_id = 0,
	fight_power = 0,
	attr = [],
	hp = 0
	}).

-define(CMD_U2GS_GetExpeditionPlayerInfo,47786).
-record(pk_U2GS_GetExpeditionPlayerInfo,{
	}).

-define(CMD_GS2U_GetExpeditionPlayerInfoRet,47957).
-record(pk_GS2U_GetExpeditionPlayerInfoRet,{
	camp_id = 0,
	group_id = 0,
	energy = 0,
	last_reply_time = 0,
	now_area = 0,
	carry_energy = 0,
	all_score = 0,
	week_score = 0,
	time_score = 0,
	time_kill_num = 0,
	fight_power = 0,
	role_attrs = [],
	strong_camp_id = 0,
	time_buy_energy_times = 0,
	err_code = 0
	}).

-define(CMD_U2GS_GetExpeditionFightInfo,38836).
-record(pk_U2GS_GetExpeditionFightInfo,{
	}).

-define(CMD_GS2U_GetExpeditionFightInfoRet,17858).
-record(pk_GS2U_GetExpeditionFightInfoRet,{
	err_code = 0,
	fight_info_list = [],
	player_fight_info_list = []
	}).

-define(CMD_GS2U_GetExpeditionFightInfoSync,4930).
-record(pk_GS2U_GetExpeditionFightInfoSync,{
	type = 0,
	fight_info = #pk_ExpeditionCampFightInfo{}
	}).

-define(CMD_U2GS_GetExpeditionPlayerInfoSync,39482).
-record(pk_U2GS_GetExpeditionPlayerInfoSync,{
	}).

-define(CMD_GS2U_GetExpeditionPlayerInfoSyncRet,22033).
-record(pk_GS2U_GetExpeditionPlayerInfoSyncRet,{
	kill_num = 0,
	score = 0,
	err_code = 0
	}).

-define(CMD_U2GS_ExpeditionJoinCamp,19901).
-record(pk_U2GS_ExpeditionJoinCamp,{
	}).

-define(CMD_GS2U_ExpeditionJoinCampRet,23786).
-record(pk_GS2U_ExpeditionJoinCampRet,{
	camp_id = 0,
	err_code = 0
	}).

-define(CMD_U2GS_ExpeditionBuyEnergy,35407).
-record(pk_U2GS_ExpeditionBuyEnergy,{
	time = 0
	}).

-define(CMD_GS2U_ExpeditionBuyEnergyRet,54810).
-record(pk_GS2U_ExpeditionBuyEnergyRet,{
	time = 0,
	err_code = 0
	}).

-define(CMD_U2GS_ExpeditionPublishTask,59320).
-record(pk_U2GS_ExpeditionPublishTask,{
	type = 0,
	target_area = 0,
	target_score = 0
	}).

-define(CMD_GS2U_ExpeditionPublishTaskRet,37674).
-record(pk_GS2U_ExpeditionPublishTaskRet,{
	type = 0,
	target_area = 0,
	target_score = 0,
	task_id = 0,
	err_code = 0
	}).

-define(CMD_U2GS_ExpeditionModifyTask,43789).
-record(pk_U2GS_ExpeditionModifyTask,{
	task_id = 0,
	type = 0,
	target_area = 0,
	target_score = 0
	}).

-define(CMD_GS2U_ExpeditionModifyTaskRet,30177).
-record(pk_GS2U_ExpeditionModifyTaskRet,{
	type = 0,
	target_area = 0,
	task_id = 0,
	target_score = 0,
	err_code = 0
	}).

-define(CMD_U2GS_ExpeditionReceiveTask,29938).
-record(pk_U2GS_ExpeditionReceiveTask,{
	task_id = 0
	}).

-define(CMD_GS2U_ExpeditionReceiveTaskRet,41381).
-record(pk_GS2U_ExpeditionReceiveTaskRet,{
	task_id = 0,
	err_code = 0
	}).

-define(CMD_GS2U_ExpeditionRefreshTaskRet,64719).
-record(pk_GS2U_ExpeditionRefreshTaskRet,{
	type = 0,
	task_info = #pk_ExpeditionTaskInfo{}
	}).

-define(CMD_GS2U_ExpeditionRefreshInitTask,45955).
-record(pk_GS2U_ExpeditionRefreshInitTask,{
	task_info_list = []
	}).

-define(CMD_U2GS_ExpeditionPlayerCarryEnergy,28418).
-record(pk_U2GS_ExpeditionPlayerCarryEnergy,{
	energy_num = 0
	}).

-define(CMD_GS2U_ExpeditionPlayerCarryEnergyRet,10427).
-record(pk_GS2U_ExpeditionPlayerCarryEnergyRet,{
	energy_num = 0,
	err_code = 0
	}).

-define(CMD_U2GS_ExpeditionPlayerMove,53689).
-record(pk_U2GS_ExpeditionPlayerMove,{
	move_list = [],
	need_send = false
	}).

-define(CMD_GS2U_ExpeditionPlayerMoveRet,8343).
-record(pk_GS2U_ExpeditionPlayerMoveRet,{
	err_code = 0
	}).

-define(CMD_GS2U_ExpeditionOtherPlayerMove,29620).
-record(pk_GS2U_ExpeditionOtherPlayerMove,{
	player_id = 0,
	name = "",
	camp_id = 0,
	career = 0,
	head_id = 0,
	frame = 0,
	honor_lv = 0,
	sex = 0,
	move_list = []
	}).

-define(CMD_GS2U_ExpeditionPlayerArriveRet,56693).
-record(pk_GS2U_ExpeditionPlayerArriveRet,{
	arrived_time = 0,
	area_id = 0,
	need_send = false
	}).

-define(CMD_GS2U_ExpeditionPlayerArriveRet2,39456).
-record(pk_GS2U_ExpeditionPlayerArriveRet2,{
	arrived_time = 0,
	area_id = 0
	}).

-define(CMD_U2GS_ExpeditionPlayerEnter,38074).
-record(pk_U2GS_ExpeditionPlayerEnter,{
	area_id = 0,
	is_1v1 = false
	}).

-define(CMD_GS2U_ExpeditionPlayerEnterRet,20905).
-record(pk_GS2U_ExpeditionPlayerEnterRet,{
	area_id = 0,
	err_code = 0
	}).

-define(CMD_U2GS_ExpeditionPlayerExit,12111).
-record(pk_U2GS_ExpeditionPlayerExit,{
	}).

-define(CMD_GS2U_ExpeditionPlayerExitRet,55883).
-record(pk_GS2U_ExpeditionPlayerExitRet,{
	err_code = 0
	}).

-define(CMD_GS2U_ExpeditionAreaSettlementSuccRet,37243).
-record(pk_GS2U_ExpeditionAreaSettlementSuccRet,{
	area_id = 0,
	camp_id = 0,
	camp_damage = 0,
	kill_player = #pk_ExpeditionPlayer{},
	player_list = [],
	rank = 0,
	damage = 0,
	score = 0,
	get_war_coin = 0,
	get_honor_exp = 0,
	get_conquer_exp = 0
	}).

-define(CMD_GS2U_ExpeditionAreaSettlementFailRet,34099).
-record(pk_GS2U_ExpeditionAreaSettlementFailRet,{
	area_id = 0,
	camp_id = 0
	}).

-define(CMD_GS2U_ExpeditionSettlementRet,7386).
-record(pk_GS2U_ExpeditionSettlementRet,{
	time = 0,
	old_area_info_list = [],
	new_area_info_list = [],
	score = 0,
	get_war_coin = 0,
	get_honor_exp = 0,
	get_conquer_exp = 0
	}).

-define(CMD_GS2U_ExpeditionImperialSettlementRet,45790).
-record(pk_GS2U_ExpeditionImperialSettlementRet,{
	time = 0,
	show_player = [],
	camp_title_list = [],
	score = 0,
	kill_num = 0,
	info = #pk_ExpeditionInfo{},
	get_war_coin = 0,
	get_honor_exp = 0,
	get_conquer_exp = 0
	}).

-define(CMD_U2GS_ExpeditionPlayerGetAward,9380).
-record(pk_U2GS_ExpeditionPlayerGetAward,{
	close_time = 0,
	is_force = 0
	}).

-define(CMD_GS2U_ExpeditionPlayerGetAwardRet,48093).
-record(pk_GS2U_ExpeditionPlayerGetAwardRet,{
	close_time = 0,
	is_force = 0,
	err_code = 0
	}).

-define(CMD_GS2U_ExpeditionMapInfo,884).
-record(pk_GS2U_ExpeditionMapInfo,{
	camp_score_list = [],
	buff = 0,
	kill_num = 0,
	score = 0
	}).

-define(CMD_GS2U_ExpeditionMapInfoSync1,14049).
-record(pk_GS2U_ExpeditionMapInfoSync1,{
	bin_fill = <<>>,
	camp_score_list = [],
	kill_num = 0,
	score = 0
	}).

-define(CMD_GS2U_ExpeditionRoundScoreRank,30715).
-record(pk_GS2U_ExpeditionRoundScoreRank,{
	rank_list = []
	}).

-define(CMD_GS2U_ExpeditionCarryEnergyUpdate,32060).
-record(pk_GS2U_ExpeditionCarryEnergyUpdate,{
	energy = 0
	}).

-define(CMD_GS2U_ExpeditionMapInfoSync4,25599).
-record(pk_GS2U_ExpeditionMapInfoSync4,{
	buff = 0
	}).

-define(CMD_GS2U_ExpeditionPlayerCamp,19414).
-record(pk_GS2U_ExpeditionPlayerCamp,{
	camp_id = 0,
	fight_type = 0,
	fight_time = 0
	}).

-define(CMD_GS2U_ExpeditionPlayerPowerChange,31269).
-record(pk_GS2U_ExpeditionPlayerPowerChange,{
	power = 0
	}).

-define(CMD_U2GS_GetExpeditionPlayerAttrInfo,36133).
-record(pk_U2GS_GetExpeditionPlayerAttrInfo,{
	}).

-define(CMD_GS2U_GetExpeditionPlayerAttrInfoRet,29200).
-record(pk_GS2U_GetExpeditionPlayerAttrInfoRet,{
	nobility_id = 0,
	role_attrs = [],
	err_code = 0
	}).

-define(CMD_GS2U_ExpeditionResetSeason,61009).
-record(pk_GS2U_ExpeditionResetSeason,{
	}).

-define(CMD_GS2U_ExpeditionRedPoint,15834).
-record(pk_GS2U_ExpeditionRedPoint,{
	is_red = false
	}).

-define(CMD_U2GS_ExpeditionGather,65223).
-record(pk_U2GS_ExpeditionGather,{
	type = 0,
	city_id = 0
	}).

-define(CMD_GS2U_ExpeditionGatherRet,12782).
-record(pk_GS2U_ExpeditionGatherRet,{
	type = 0,
	city_id = 0,
	err_code = 0
	}).

-define(CMD_ExpeditionGatherPeopleInfo,42521).
-record(pk_ExpeditionGatherPeopleInfo,{
	player_id = 0,
	title_id = 0,
	leader_id = 0,
	name = "",
	sex = 0
	}).

-define(CMD_U2GS_GetExpeditionGatherInfo,27582).
-record(pk_U2GS_GetExpeditionGatherInfo,{
	type = 0
	}).

-define(CMD_GS2U_GetExpeditionGatherInfoRet,31539).
-record(pk_GS2U_GetExpeditionGatherInfoRet,{
	type = 0,
	area_id = 0,
	hp_rate = 0,
	leader = #pk_ExpeditionGatherPeopleInfo{},
	player_list = [],
	over_time = 0,
	err_code = 0
	}).

-define(CMD_GS2U_ExpeditionGatherInfoSync,30067).
-record(pk_GS2U_ExpeditionGatherInfoSync,{
	type = 0,
	gather_city = 0,
	gather_cd = 0,
	player_info = #pk_ExpeditionGatherPeopleInfo{}
	}).

-define(CMD_GS2U_ExpeditionGatherPersonSync,35786).
-record(pk_GS2U_ExpeditionGatherPersonSync,{
	type = 0,
	player_info = #pk_ExpeditionGatherPeopleInfo{}
	}).

-define(CMD_U2GS_GetExpeditionMiniMapUI,52954).
-record(pk_U2GS_GetExpeditionMiniMapUI,{
	}).

-define(CMD_ExpeditionCityInfo,19508).
-record(pk_ExpeditionCityInfo,{
	city_id = 0,
	our_num = 0,
	enemy_num = 0
	}).

-define(CMD_GS2U_GetExpeditionMiniMapUIRet,27048).
-record(pk_GS2U_GetExpeditionMiniMapUIRet,{
	gather_city = 0,
	gather_city_team = 0,
	city_info = [],
	err_code = 0
	}).

-define(CMD_ExpeditionWeakCampInfo,60657).
-record(pk_ExpeditionWeakCampInfo,{
	area_id = 0,
	camp_id = 0,
	level = 0,
	num = 0
	}).

-define(CMD_U2GS_GetAllExpeditionWeakCampInfo,42665).
-record(pk_U2GS_GetAllExpeditionWeakCampInfo,{
	}).

-define(CMD_GS2U_GetAllExpeditionWeakCampInfoRet,52575).
-record(pk_GS2U_GetAllExpeditionWeakCampInfoRet,{
	info_list = [],
	err_code = 0
	}).

-define(CMD_U2GS_GetExpeditionStrongCampInfo,12472).
-record(pk_U2GS_GetExpeditionStrongCampInfo,{
	}).

-define(CMD_GS2U_GetExpeditionStrongCampInfoRet,55407).
-record(pk_GS2U_GetExpeditionStrongCampInfoRet,{
	type = 0,
	camp_id = 0,
	time = 0,
	notice_camp_id = 0
	}).

-define(CMD_U2GS_GetExpeditionAirShipInfo,58077).
-record(pk_U2GS_GetExpeditionAirShipInfo,{
	}).

-define(CMD_GS2U_GetExpeditionAirShipInfoRet,18135).
-record(pk_GS2U_GetExpeditionAirShipInfoRet,{
	send_time = 0,
	send_player_num = 0,
	recovery_timestamp = 0,
	err_code = 0
	}).

-define(CMD_U2GS_GetExpeditionAirShipSend,13798).
-record(pk_U2GS_GetExpeditionAirShipSend,{
	}).

-define(CMD_GS2U_GetExpeditionAirShipSendRet,36650).
-record(pk_GS2U_GetExpeditionAirShipSendRet,{
	err_code = 0
	}).

-define(CMD_ExpeditionExplore,749).
-record(pk_ExpeditionExplore,{
	city_id = 0,
	type = 0,
	occ_player = #pk_ExpeditionPlayer{},
	protect_timestamp = 0,
	award_timestamp = 0
	}).

-define(CMD_U2GS_GetAllExpeditionExploreInfo,13567).
-record(pk_U2GS_GetAllExpeditionExploreInfo,{
	}).

-define(CMD_GS2U_GetAllExpeditionExploreInfoRet,63511).
-record(pk_GS2U_GetAllExpeditionExploreInfoRet,{
	explore_award_time = 0,
	explore_fight_time = 0,
	restore_explore_fight_timestamp = 0,
	explore_bag_time = 0,
	explore_list = [],
	err_code = 0
	}).

-define(CMD_U2GS_GetExpeditionExploreInfo,6627).
-record(pk_U2GS_GetExpeditionExploreInfo,{
	city_id = 0
	}).

-define(CMD_GS2U_GetExpeditionExploreInfoRet,31743).
-record(pk_GS2U_GetExpeditionExploreInfoRet,{
	explore_list = #pk_ExpeditionExplore{},
	err_code = 0
	}).

-define(CMD_GS2U_ExpeditionExplorePlayerInfoSync,29260).
-record(pk_GS2U_ExpeditionExplorePlayerInfoSync,{
	explore_award_time = 0,
	explore_fight_time = 0,
	restore_explore_fight_timestamp = 0,
	explore_bag_time = 0
	}).

-define(CMD_GS2U_ExpeditionExploreInfoSync,26840).
-record(pk_GS2U_ExpeditionExploreInfoSync,{
	explore_info = []
	}).

-define(CMD_U2GS_ExpeditionExploreRequest,14906).
-record(pk_U2GS_ExpeditionExploreRequest,{
	type = 0,
	city_id = 0
	}).

-define(CMD_GS2U_ExpeditionExploreRequestRet,50918).
-record(pk_GS2U_ExpeditionExploreRequestRet,{
	type = 0,
	city_id = 0,
	err_code = 0
	}).

-define(CMD_GS2U_ExpeditionExploreBattleEnd,58999).
-record(pk_GS2U_ExpeditionExploreBattleEnd,{
	is_win = false
	}).

-define(CMD_ExpeditionExploreFightInfo,6803).
-record(pk_ExpeditionExploreFightInfo,{
	type = 0,
	enemy_server = "",
	enemy_name = "",
	timestamp = 0
	}).

-define(CMD_U2GS_GetAllExpeditionExploreFightInfo,37266).
-record(pk_U2GS_GetAllExpeditionExploreFightInfo,{
	}).

-define(CMD_GS2U_GetAllExpeditionExploreFightInfoRet,33289).
-record(pk_GS2U_GetAllExpeditionExploreFightInfoRet,{
	info_list = [],
	err_code = 0
	}).

-define(CMD_GS2U_ExpeditionExploreFightInfoSync,2009).
-record(pk_GS2U_ExpeditionExploreFightInfoSync,{
	info = #pk_ExpeditionExploreFightInfo{}
	}).

-define(CMD_ExpeditionNotesTaskInfo,21961).
-record(pk_ExpeditionNotesTaskInfo,{
	type_id = 0,
	progress = 0
	}).

-define(CMD_GS2U_ExpeditionNotes,33304).
-record(pk_GS2U_ExpeditionNotes,{
	task_info = [],
	already_awarded_id = []
	}).

-define(CMD_GS2U_ExpeditionNotesTaskUpdate,8870).
-record(pk_GS2U_ExpeditionNotesTaskUpdate,{
	task_info = #pk_ExpeditionNotesTaskInfo{}
	}).

-define(CMD_GS2U_ExpeditionNotesTaskReset,54003).
-record(pk_GS2U_ExpeditionNotesTaskReset,{
	task_info = []
	}).

-define(CMD_U2GS_ExpeditionNotesGetReward,546).
-record(pk_U2GS_ExpeditionNotesGetReward,{
	id = 0
	}).

-define(CMD_GS2U_ExpeditionNotesGetRewardRet,13472).
-record(pk_GS2U_ExpeditionNotesGetRewardRet,{
	id = 0,
	err_code = 0
	}).

-define(CMD_expedition_demon_come_boss,31073).
-record(pk_expedition_demon_come_boss,{
	city_id = 0,
	boss_cfg_id = 0,
	blood_percentage = 0,
	people_num = 0
	}).

-define(CMD_expedition_demon_come_camp_boss_info,28061).
-record(pk_expedition_demon_come_camp_boss_info,{
	camp_id = 0,
	boss_info_list = []
	}).

-define(CMD_expedition_demon_come_city_boss,4938).
-record(pk_expedition_demon_come_city_boss,{
	city_id = 0,
	boss_cfg_id = 0
	}).

-define(CMD_expedition_demon_come_damage_rank_info,37257).
-record(pk_expedition_demon_come_damage_rank_info,{
	rank = 0,
	name = "",
	damage = 0,
	camp_id = 0
	}).

-define(CMD_expedition_demon_come_score_rank_info,44379).
-record(pk_expedition_demon_come_score_rank_info,{
	rank = 0,
	name = "",
	score = 0,
	kill_number = 0
	}).

-define(CMD_U2GS_expedition_demon_come_info,65150).
-record(pk_U2GS_expedition_demon_come_info,{
	}).

-define(CMD_GS2U_expedition_demon_come_info_ret,2172).
-record(pk_GS2U_expedition_demon_come_info_ret,{
	session = 0,
	camp_boss_info_list = [],
	award_times = 0
	}).

-define(CMD_U2GS_expedition_demon_come_info_on_tick,23086).
-record(pk_U2GS_expedition_demon_come_info_on_tick,{
	}).

-define(CMD_GS2U_expedition_demon_come_info_update,48629).
-record(pk_GS2U_expedition_demon_come_info_update,{
	session = 0,
	camp_boss_info_list = []
	}).

-define(CMD_U2GS_expedition_demon_come_enter_map,930).
-record(pk_U2GS_expedition_demon_come_enter_map,{
	city_id = 0
	}).

-define(CMD_GS2U_expedition_demon_come_start,60788).
-record(pk_GS2U_expedition_demon_come_start,{
	city_boss_list = []
	}).

-define(CMD_GS2U_expedition_demon_come_end,19102).
-record(pk_GS2U_expedition_demon_come_end,{
	time = 0
	}).

-define(CMD_GS2U_expedition_demon_come_sync_damage_rank,14581).
-record(pk_GS2U_expedition_demon_come_sync_damage_rank,{
	rank_info = [],
	my_rank = 0,
	my_damage = 0,
	my_camp_id = 0
	}).

-define(CMD_GS2U_expedition_demon_come_sync_score_rank,63588).
-record(pk_GS2U_expedition_demon_come_sync_score_rank,{
	rank_info = [],
	my_rank = 0,
	my_score = 0,
	my_kill_number = 0,
	my_add_score = 0
	}).

-define(CMD_expedition_card,62565).
-record(pk_expedition_card,{
	type = 0,
	level = 0,
	exp = 0,
	fetter_level = 0,
	card_id_list = []
	}).

-define(CMD_GS2U_expedition_card_info,24386).
-record(pk_GS2U_expedition_card_info,{
	suit_lv = 0,
	card_list = []
	}).

-define(CMD_U2GS_expedition_card_active,7832).
-record(pk_U2GS_expedition_card_active,{
	card_id = 0
	}).

-define(CMD_GS2U_expedition_card_active_ret,4560).
-record(pk_GS2U_expedition_card_active_ret,{
	card_id = 0,
	err_code = 0
	}).

-define(CMD_U2GS_expedition_card_swallow,6975).
-record(pk_U2GS_expedition_card_swallow,{
	card_type = 0,
	card_list = []
	}).

-define(CMD_GS2U_expedition_card_swallow_ret,27479).
-record(pk_GS2U_expedition_card_swallow_ret,{
	card_type = 0,
	card_list = [],
	new_level = 0,
	new_exp = 0,
	err_code = 0
	}).

-define(CMD_U2GS_expedition_card_fetter_level_up,50524).
-record(pk_U2GS_expedition_card_fetter_level_up,{
	card_type = 0
	}).

-define(CMD_GS2U_expedition_card_fetter_level_up_ret,62954).
-record(pk_GS2U_expedition_card_fetter_level_up_ret,{
	card_type = 0,
	new_level = 0,
	err_code = 0
	}).

-define(CMD_U2GS_expedition_card_suit_level_up,57609).
-record(pk_U2GS_expedition_card_suit_level_up,{
	}).

-define(CMD_GS2U_expedition_card_suit_level_up_ret,12803).
-record(pk_GS2U_expedition_card_suit_level_up_ret,{
	new_level = 0,
	err_code = 0
	}).

-define(CMD_AshuraServer,37156).
-record(pk_AshuraServer,{
	server_id = 0,
	server_name = "",
	top_list = []
	}).

-define(CMD_U2GS_AshuraCluster,51276).
-record(pk_U2GS_AshuraCluster,{
	}).

-define(CMD_GS2U_AshuraCluster,43439).
-record(pk_GS2U_AshuraCluster,{
	server_list = []
	}).

-define(CMD_U2GS_DestinyGuardCareerSelect,40644).
-record(pk_U2GS_DestinyGuardCareerSelect,{
	career = 0
	}).

-define(CMD_greenBlessInfo,39531).
-record(pk_greenBlessInfo,{
	id = 0,
	free_res = 0,
	bless_time = 0,
	day_count = 0,
	bless_count = 0,
	uncrit_times = 0
	}).

-define(CMD_GS2U_sendGreenBlessData,12544).
-record(pk_GS2U_sendGreenBlessData,{
	bless_list = []
	}).

-define(CMD_U2GS_GreenBlessFree,16269).
-record(pk_U2GS_GreenBlessFree,{
	id = 0
	}).

-define(CMD_GS2U_GreenBressFreeRes,9042).
-record(pk_GS2U_GreenBressFreeRes,{
	id = 0,
	res_free = 0,
	coins = [],
	err_code = 0
	}).

-define(CMD_U2GS_GreenBless,6537).
-record(pk_U2GS_GreenBless,{
	id = 0,
	time = 0
	}).

-define(CMD_GS2U_GreenBressRes,25856).
-record(pk_GS2U_GreenBressRes,{
	id = 0,
	time = 0,
	award_res = [],
	err_code = 0
	}).

-define(CMD_U2GS_HideModel,15544).
-record(pk_U2GS_HideModel,{
	role_id_list = []
	}).

-define(CMD_U2GS_CleanShopRed,60111).
-record(pk_U2GS_CleanShopRed,{
	shopID = 0
	}).

-define(CMD_U2GS_pantheon_boss_kill,57253).
-record(pk_U2GS_pantheon_boss_kill,{
	}).

-define(CMD_GS2U_pantheon_boss_kill_ret,33094).
-record(pk_GS2U_pantheon_boss_kill_ret,{
	total_kill = 0,
	award_list = []
	}).

-define(CMD_U2GS_pantheon_boss_kill_award,58405).
-record(pk_U2GS_pantheon_boss_kill_award,{
	id = 0
	}).

-define(CMD_GS2U_pantheon_boss_kill_award_ret,33678).
-record(pk_GS2U_pantheon_boss_kill_award_ret,{
	id = 0,
	err_code = 0
	}).

-define(CMD_U2GS_GetPantheonBpInfo,10515).
-record(pk_U2GS_GetPantheonBpInfo,{
	}).

-define(CMD_GS2U_GetPantheonBpInfoRet,53305).
-record(pk_GS2U_GetPantheonBpInfoRet,{
	close_time = 0,
	player_lv = 0,
	assist_num = 0,
	score = 0,
	purchase = 0,
	award_list = []
	}).

-define(CMD_U2GS_GetPantheonBpAward,49828).
-record(pk_U2GS_GetPantheonBpAward,{
	}).

-define(CMD_GS2U_GetPantheonBpAwardRet,43196).
-record(pk_GS2U_GetPantheonBpAwardRet,{
	err_code = 0,
	award_list = []
	}).

-define(CMD_guild_ins_zones_node,10393).
-record(pk_guild_ins_zones_node,{
	node_id = 0,
	is_pass = 0,
	is_mark = 0,
	player_num = 0,
	param1 = 0,
	max_hp = 0
	}).

-define(CMD_guild_ins_zones_bag,47814).
-record(pk_guild_ins_zones_bag,{
	node_id = 0,
	item_list = []
	}).

-define(CMD_guild_ins_zones_first_pass,16381).
-record(pk_guild_ins_zones_first_pass,{
	chapter_id = 0,
	first_pass_guild_icon = 0,
	first_pass_guild_name = ""
	}).

-define(CMD_U2GS_guild_ins_zones_info,112).
-record(pk_U2GS_guild_ins_zones_info,{
	}).

-define(CMD_GS2U_guild_ins_zones_info_ret,24670).
-record(pk_GS2U_guild_ins_zones_info_ret,{
	err_code = 0,
	chapter_id = 0,
	pos_node = 0,
	guild_node_list = [],
	personal_node_list = [],
	award_node_list = [],
	use_times = 0,
	max_times = 0,
	progress = 0,
	yesterday_chapter_id = 0,
	yesterday_progress = 0,
	challenge_times = 0,
	is_progress_award = 0,
	times_award_list = [],
	bag_item_list = [],
	first_pass_list = []
	}).

-define(CMD_U2GS_guild_ins_zones_remark,55540).
-record(pk_U2GS_guild_ins_zones_remark,{
	chapter_id = 0,
	node_id = 0,
	is_mark = 0
	}).

-define(CMD_GS2U_guild_ins_zones_remark_ret,36107).
-record(pk_GS2U_guild_ins_zones_remark_ret,{
	chapter_id = 0,
	node_id = 0,
	is_mark = 0,
	err_code = 0
	}).

-define(CMD_U2GS_guild_ins_zones_hit,33944).
-record(pk_U2GS_guild_ins_zones_hit,{
	chapter_id = 0,
	node_id = 0,
	use_item = #pk_key_value{}
	}).

-define(CMD_GS2U_guild_ins_zones_hit_ret,10182).
-record(pk_GS2U_guild_ins_zones_hit_ret,{
	chapter_id = 0,
	node_id = 0,
	use_item = #pk_key_value{},
	err_code = 0
	}).

-define(CMD_GS2U_guild_ins_zones_settle_boss,7815).
-record(pk_GS2U_guild_ins_zones_settle_boss,{
	chapter_id = 0,
	node_id = 0,
	total_damage = 0,
	percent = 0,
	is_kill = 0,
	item_list = [],
	eq_list = [],
	coin_list = []
	}).

-define(CMD_GS2U_guild_ins_zones_settle_collect,44233).
-record(pk_GS2U_guild_ins_zones_settle_collect,{
	chapter_id = 0,
	node_id = 0,
	total_num = 0,
	is_success = 0,
	item_list = [],
	total_item_list = []
	}).

-define(CMD_GS2U_guild_ins_zones_settle_monster,53817).
-record(pk_GS2U_guild_ins_zones_settle_monster,{
	chapter_id = 0,
	node_id = 0,
	is_success = 0,
	num = 0,
	total_num = 0
	}).

-define(CMD_GS2U_guild_ins_zones_settle_welfare,58728).
-record(pk_GS2U_guild_ins_zones_settle_welfare,{
	chapter_id = 0,
	node_id = 0,
	is_success = 0,
	param = 0,
	item_list = [],
	eq_list = [],
	coin_list = []
	}).

-define(CMD_U2GS_guild_ins_zones_welfare_coll_put,9303).
-record(pk_U2GS_guild_ins_zones_welfare_coll_put,{
	}).

-define(CMD_U2GS_guild_ins_zones_maze_pass,25708).
-record(pk_U2GS_guild_ins_zones_maze_pass,{
	chapter_id = 0,
	node_id = 0
	}).

-define(CMD_GS2U_guild_ins_zones_maze_pass_ret,18632).
-record(pk_GS2U_guild_ins_zones_maze_pass_ret,{
	chapter_id = 0,
	node_id = 0,
	err_code = 0
	}).

-define(CMD_U2GS_guild_ins_zones_award,45134).
-record(pk_U2GS_guild_ins_zones_award,{
	type = 0,
	param = 0
	}).

-define(CMD_GS2U_guild_ins_zones_award_ret,21650).
-record(pk_GS2U_guild_ins_zones_award_ret,{
	type = 0,
	param = 0,
	err_code = 0
	}).

-define(CMD_guild_ins_zones_log,60291).
-record(pk_guild_ins_zones_log,{
	type = 0,
	player_id = 0,
	name = "",
	player_lv = 0,
	head_id = 0,
	frame_id = 0,
	chapter_id = 0,
	node_id = 0,
	boss_id = 0,
	boss_lv = 0,
	use_item_id = 0,
	param1 = 0,
	param2 = 0,
	param3 = 0,
	time = 0
	}).

-define(CMD_U2GS_guild_ins_zones_log,56644).
-record(pk_U2GS_guild_ins_zones_log,{
	pages = 0
	}).

-define(CMD_GS2U_guild_ins_zones_log_ret,21456).
-record(pk_GS2U_guild_ins_zones_log_ret,{
	pages = 0,
	total_pages = 0,
	log_list = [],
	err_code = 0
	}).

-define(CMD_guild_ins_zones_node_param,30764).
-record(pk_guild_ins_zones_node_param,{
	chapter_id = 0,
	node_id = 0,
	is_mark = 0,
	is_pass = 0,
	player_num = 0,
	param1 = 0
	}).

-define(CMD_GS2U_guild_ins_zones_node_param_sync,39213).
-record(pk_GS2U_guild_ins_zones_node_param_sync,{
	param_list = []
	}).

-define(CMD_U2GS_guild_ins_zones_enter,17957).
-record(pk_U2GS_guild_ins_zones_enter,{
	chapter_id = 0,
	node_id = 0
	}).

-define(CMD_GS2U_guild_ins_zones_enter_ret,47437).
-record(pk_GS2U_guild_ins_zones_enter_ret,{
	chapter_id = 0,
	node_id = 0,
	err_code = 0
	}).

-define(CMD_U2GS_guild_ins_zones_move,60912).
-record(pk_U2GS_guild_ins_zones_move,{
	chapter_id = 0,
	node_id = 0
	}).

-define(CMD_GS2U_guild_ins_zones_move_ret,20426).
-record(pk_GS2U_guild_ins_zones_move_ret,{
	chapter_id = 0,
	node_id = 0,
	err_code = 0
	}).

-define(CMD_guild_ins_zones_boss_rank,26055).
-record(pk_guild_ins_zones_boss_rank,{
	rank = 0,
	name = "",
	sex = 0,
	damage = 0,
	percent = 0
	}).

-define(CMD_GS2U_guild_ins_zones_boss_rank,10115).
-record(pk_GS2U_guild_ins_zones_boss_rank,{
	rank_list = [],
	my_rank = 0,
	my_damage = 0
	}).

-define(CMD_GS2U_guild_ins_zones_label_info,61766).
-record(pk_GS2U_guild_ins_zones_label_info,{
	chapter_id = 0,
	node_id = 0,
	my_value = 0,
	guild_value = 0,
	player_num = 0
	}).

-define(CMD_guild_assign_award_item,20166).
-record(pk_guild_assign_award_item,{
	item_id = 0,
	source_from = 0,
	is_assign = 0,
	belong_name = ""
	}).

-define(CMD_U2GS_guild_assign_award_list,49959).
-record(pk_U2GS_guild_assign_award_list,{
	type = 0
	}).

-define(CMD_GS2U_guild_assign_award_list_ret,9716).
-record(pk_GS2U_guild_assign_award_list_ret,{
	type = 0,
	list = []
	}).

-define(CMD_U2GS_guild_assign_award_to,21924).
-record(pk_U2GS_guild_assign_award_to,{
	type = 0,
	player_id = 0,
	item_id = 0
	}).

-define(CMD_GS2U_guild_assign_award_to_ret,4831).
-record(pk_GS2U_guild_assign_award_to_ret,{
	type = 0,
	item_id = 0,
	player_id = 0,
	err_code = 0
	}).

-define(CMD_U2GS_guild_assign_award_rule_set,37059).
-record(pk_U2GS_guild_assign_award_rule_set,{
	type = 0,
	rule = 0
	}).

-define(CMD_GS2U_guild_assign_award_rule_set_ret,27754).
-record(pk_GS2U_guild_assign_award_rule_set_ret,{
	type = 0,
	rule = 0,
	err_code = 0
	}).

-define(CMD_guild_assign_award_log,25716).
-record(pk_guild_assign_award_log,{
	type = 0,
	name = "",
	item_id = 0,
	to_name = "",
	time = 0
	}).

-define(CMD_U2GS_guild_assign_award_log,3569).
-record(pk_U2GS_guild_assign_award_log,{
	type = 0
	}).

-define(CMD_GS2U_guild_assign_award_log_ret,33733).
-record(pk_GS2U_guild_assign_award_log_ret,{
	type = 0,
	list = []
	}).

-define(CMD_guild_ins_zones_boss_first_pass,9988).
-record(pk_guild_ins_zones_boss_first_pass,{
	chapter_id = 0,
	node_id = 0,
	guild_name = ""
	}).

-define(CMD_U2GS_guild_ins_zones_boss_first_pass,11426).
-record(pk_U2GS_guild_ins_zones_boss_first_pass,{
	chapter_id = 0
	}).

-define(CMD_GS2U_guild_ins_zones_boss_first_pass_ret,21226).
-record(pk_GS2U_guild_ins_zones_boss_first_pass_ret,{
	list = []
	}).

-define(CMD_mystery_shop_goods,7634).
-record(pk_mystery_shop_goods,{
	id = 0,
	seat = 0,
	item = #pk_ShopItem{},
	currency = #pk_ShopCurrency{},
	equip = #pk_ShopEquip{},
	currency1 = #pk_ShopCurrency{},
	needItem1 = #pk_ShopItem{},
	limitType = 0,
	limitParam = 0,
	buyNum = 0,
	conditionType = 0,
	conditionParam = 0,
	conditionParam2 = 0,
	conditionParam3 = 0,
	recommend = 0,
	show_type = 0,
	show_param = 0,
	show_param2 = 0,
	show_param3 = 0,
	recNum = 0
	}).

-define(CMD_U2GS_mystery_shop,49794).
-record(pk_U2GS_mystery_shop,{
	}).

-define(CMD_GS2U_mystery_shop_ret,58103).
-record(pk_GS2U_mystery_shop_ret,{
	ref_free = 0,
	ref_pay = 0,
	ref_consume = 0,
	pay_refresh_times = 0,
	free_refresh_times = 0,
	next_free_time = 0,
	goods_list = []
	}).

-define(CMD_U2GS_mystery_shop_goods_buy,42110).
-record(pk_U2GS_mystery_shop_goods_buy,{
	id = 0,
	seat = 0,
	buy_num = 0
	}).

-define(CMD_GS2U_mystery_shop_goods_buy_ret,52452).
-record(pk_GS2U_mystery_shop_goods_buy_ret,{
	id = 0,
	seat = 0,
	newPrice1 = 0,
	discount1 = 0,
	newNeedItemCount1 = 0,
	needItemDiscount1 = 0,
	newBuyNum = 0,
	err_code = 0
	}).

-define(CMD_U2GS_mystery_shop_goods_refresh,13143).
-record(pk_U2GS_mystery_shop_goods_refresh,{
	}).

-define(CMD_GS2U_mystery_shop_goods_refresh_ret,62052).
-record(pk_GS2U_mystery_shop_goods_refresh_ret,{
	err_code = 0
	}).

-define(CMD_GS2U_mystery_shop_goods_red,1986).
-record(pk_GS2U_mystery_shop_goods_red,{
	}).

-define(CMD_pet_eq_pos,24133).
-record(pk_pet_eq_pos,{
	pos = 0,
	uid = 0
	}).

-define(CMD_pet_eq_skill,1590).
-record(pk_pet_eq_skill,{
	pos = 0,
	skill_id = 0
	}).

-define(CMD_pet_eq,19576).
-record(pk_pet_eq,{
	uid = 0,
	cfg_id = 0,
	reset_time = 0,
	skill_list = [],
	reset_skill_list = []
	}).

-define(CMD_GS2U_pet_eq_sync,22715).
-record(pk_GS2U_pet_eq_sync,{
	eq_list = []
	}).

-define(CMD_U2GS_pet_add_star_new,58025).
-record(pk_U2GS_pet_add_star_new,{
	pet_uid = 0,
	assist_cost_pet_uid_list = []
	}).

-define(CMD_GS2U_pet_add_star_new_ret,64636).
-record(pk_GS2U_pet_add_star_new_ret,{
	pet_uid = 0,
	err_code = 0
	}).

-define(CMD_U2GS_pet_add_sp_lv,43614).
-record(pk_U2GS_pet_add_sp_lv,{
	pet_uid = 0,
	assist_cost_pet_uid_list = []
	}).

-define(CMD_GS2U_pet_add_sp_lv,35777).
-record(pk_GS2U_pet_add_sp_lv,{
	pet_uid = 0,
	err_code = 0
	}).

-define(CMD_U2GS_pet_add_star_pos,19602).
-record(pk_U2GS_pet_add_star_pos,{
	pet_uid = 0,
	star_pos = 0,
	assist_cost_pet_uid_list = []
	}).

-define(CMD_GS2U_pet_add_star_pos_ret,30829).
-record(pk_GS2U_pet_add_star_pos_ret,{
	pet_uid = 0,
	star_pos = 0,
	err_code = 0
	}).

-define(CMD_pet_quickly_add_cost,14156).
-record(pk_pet_quickly_add_cost,{
	pet_uid = 0,
	assist_cost_pet_uid_list = []
	}).

-define(CMD_U2GS_pet_add_star_new_quickly,48428).
-record(pk_U2GS_pet_add_star_new_quickly,{
	cost_list = []
	}).

-define(CMD_GS2U_pet_add_star_new_quickly_ret,7590).
-record(pk_GS2U_pet_add_star_new_quickly_ret,{
	err_code = 0,
	pet_uid_list = []
	}).

-define(CMD_U2GS_pet_promotion,42092).
-record(pk_U2GS_pet_promotion,{
	pet_uid = 0,
	assist_cost_pet_uid_list = []
	}).

-define(CMD_GS2U_pet_promotion_ret,32100).
-record(pk_GS2U_pet_promotion_ret,{
	pet_uid = 0,
	pet_cfgid = 0,
	err_code = 0
	}).

-define(CMD_U2GS_pet_eq_equip_on,3431).
-record(pk_U2GS_pet_eq_equip_on,{
	pet_pos = 0,
	eq_uid = 0,
	pos = 0
	}).

-define(CMD_GS2U_pet_eq_equip_on_ret,45957).
-record(pk_GS2U_pet_eq_equip_on_ret,{
	pet_pos = 0,
	err_code = 0
	}).

-define(CMD_U2GS_pet_eq_remove,45121).
-record(pk_U2GS_pet_eq_remove,{
	pet_pos = 0,
	pos = 0
	}).

-define(CMD_GS2U_pet_eq_remove_ret,29937).
-record(pk_GS2U_pet_eq_remove_ret,{
	pet_pos = 0,
	err_code = 0
	}).

-define(CMD_U2GS_pet_eq_skill_reset,26986).
-record(pk_U2GS_pet_eq_skill_reset,{
	eq_uid = 0,
	type = 0
	}).

-define(CMD_GS2U_pet_eq_skill_reset_ret,23341).
-record(pk_GS2U_pet_eq_skill_reset_ret,{
	eq_uid = 0,
	type = 0,
	err_code = 0
	}).

-define(CMD_wash_value,27065).
-record(pk_wash_value,{
	type = 0,
	value = 0
	}).

-define(CMD_pet_info,38174).
-record(pk_pet_info,{
	uid = 0,
	pet_cfg_id = 0,
	pet_lv = 0,
	pet_exp = 0,
	break_lv = 0,
	star = 0,
	star_pos = [],
	grade = 0,
	fight_flag = 0,
	fight_pos = 0,
	is_auto_skill = 0,
	wash_list = [],
	is_lock = 0,
	wash_preview = [],
	wash_material = [],
	link_uid = 0,
	been_link_uid = 0,
	appendage_uid = 0,
	been_appendage_uid = 0,
	get_by_egg = 0,
	hatch_id = 0,
	shared_flag = 0,
	pet_lv_original = 0,
	point = 0,
	sp_lv = 0,
	been_link_pet_cfg_id = 0,
	been_link_pet_sp_lv = 0
	}).

-define(CMD_GS2U_pet_update,8145).
-record(pk_GS2U_pet_update,{
	pets = []
	}).

-define(CMD_pet_prop,21767).
-record(pk_pet_prop,{
	uid = 0,
	prop_list = []
	}).

-define(CMD_GS2U_push_pet_prop,32977).
-record(pk_GS2U_push_pet_prop,{
	pet_prop_list = []
	}).

-define(CMD_GS2U_update_pet_prop,26976).
-record(pk_GS2U_update_pet_prop,{
	pet_prop = #pk_pet_prop{}
	}).

-define(CMD_U2GS_show_pet_prop,64887).
-record(pk_U2GS_show_pet_prop,{
	uid = 0
	}).

-define(CMD_GS2U_show_pet_prop,57050).
-record(pk_GS2U_show_pet_prop,{
	error_code = 0,
	pet_prop = #pk_pet_prop{}
	}).

-define(CMD_GS2U_pet_delete,3267).
-record(pk_GS2U_pet_delete,{
	delete_uid_list = []
	}).

-define(CMD_U2GS_pet_upgrade,61026).
-record(pk_U2GS_pet_upgrade,{
	uid = 0,
	item_list = []
	}).

-define(CMD_GS2U_pet_upgrade_ret,41227).
-record(pk_GS2U_pet_upgrade_ret,{
	uid = 0,
	ret_code = 0,
	flag = 0
	}).

-define(CMD_U2GS_pet_set_lock,35).
-record(pk_U2GS_pet_set_lock,{
	uid = 0,
	is_lock = 0
	}).

-define(CMD_GS2U_pet_set_lock_ret,55837).
-record(pk_GS2U_pet_set_lock_ret,{
	uid = 0,
	err_code = 0,
	is_lock = 0
	}).

-define(CMD_U2GS_pet_wash_preview,53007).
-record(pk_U2GS_pet_wash_preview,{
	uid = 0,
	times = 0
	}).

-define(CMD_GS2U_pet_wash_preview_ret,52935).
-record(pk_GS2U_pet_wash_preview_ret,{
	uid = 0,
	ret_code = 0,
	add_attr_list = []
	}).

-define(CMD_U2GS_pet_wash_save,43031).
-record(pk_U2GS_pet_wash_save,{
	uid = 0,
	flag = 0
	}).

-define(CMD_GS2U_pet_wash_save_ret,8238).
-record(pk_GS2U_pet_wash_save_ret,{
	uid = 0,
	ret_code = 0
	}).

-define(CMD_U2GS_pet_break_up,17435).
-record(pk_U2GS_pet_break_up,{
	uid = 0
	}).

-define(CMD_GS2U_pet_break_up_ret,6775).
-record(pk_GS2U_pet_break_up_ret,{
	uid = 0,
	ret_code = 0
	}).

-define(CMD_U2GS_return_pet_material,19285).
-record(pk_U2GS_return_pet_material,{
	uid_list = []
	}).

-define(CMD_GS2U_return_pet_material_ret,13962).
-record(pk_GS2U_return_pet_material_ret,{
	ret_code = 0,
	uid_list = [],
	item_list = [],
	ispop = 0
	}).

-define(CMD_U2GS_pet_cultivation_transfer,36600).
-record(pk_U2GS_pet_cultivation_transfer,{
	uid = 0,
	target_uid = 0
	}).

-define(CMD_GS2U_pet_cultivation_transfer_ret,64228).
-record(pk_GS2U_pet_cultivation_transfer_ret,{
	uid = 0,
	target_uid = 0,
	err_code = 0
	}).

-define(CMD_AtlasInfo,21704).
-record(pk_AtlasInfo,{
	atlas_id = 0,
	stars = 0,
	max_star = 0,
	is_reward = 0
	}).

-define(CMD_GS2U_AtlasUpdate,13273).
-record(pk_GS2U_AtlasUpdate,{
	atlas_list = []
	}).

-define(CMD_U2GS_AtlasActive,43708).
-record(pk_U2GS_AtlasActive,{
	atlas_id = 0
	}).

-define(CMD_GS2U_AtlasActiveRet,49263).
-record(pk_GS2U_AtlasActiveRet,{
	atlas_id = 0,
	err_code = 0
	}).

-define(CMD_U2GS_AtlasLevelUp,18693).
-record(pk_U2GS_AtlasLevelUp,{
	atlas_id = 0
	}).

-define(CMD_GS2U_AtlasLevelUpRet,42186).
-record(pk_GS2U_AtlasLevelUpRet,{
	atlas_id = 0,
	err_code = 0
	}).

-define(CMD_U2GS_AtlasActiveReward,47877).
-record(pk_U2GS_AtlasActiveReward,{
	atlas_id = 0
	}).

-define(CMD_GS2U_AtlasActiveRewardRet,13075).
-record(pk_GS2U_AtlasActiveRewardRet,{
	atlas_id = 0,
	err_code = 0
	}).

-define(CMD_PetPos,31608).
-record(pk_PetPos,{
	type = 0,
	pos = 0,
	uid = 0,
	pet_cfg_id = 0,
	is_auto_skill = 0,
	pos_ring_list = [],
	altar_stone_list = []
	}).

-define(CMD_PetPosDef,24349).
-record(pk_PetPosDef,{
	func_id = 0,
	type = 0,
	pos = 0,
	uid = 0,
	pet_cfg_id = 0
	}).

-define(CMD_GS2U_PetPosSync,55219).
-record(pk_GS2U_PetPosSync,{
	pet_pos = []
	}).

-define(CMD_GS2U_PetPosDefSync,17818).
-record(pk_GS2U_PetPosDefSync,{
	pet_pos = []
	}).

-define(CMD_U2GS_CopyPetPosDef,6437).
-record(pk_U2GS_CopyPetPosDef,{
	func_id = 0
	}).

-define(CMD_GS2U_CopyPetPosDef,64136).
-record(pk_GS2U_CopyPetPosDef,{
	err_code = 0,
	func_id = 0
	}).

-define(CMD_U2GS_PetPosActive,64254).
-record(pk_U2GS_PetPosActive,{
	type = 0,
	pos = 0
	}).

-define(CMD_GS2U_PetPosActive,27903).
-record(pk_GS2U_PetPosActive,{
	type = 0,
	pos = 0,
	err_code = 0
	}).

-define(CMD_U2GS_PetOutFight,39017).
-record(pk_U2GS_PetOutFight,{
	type = 0,
	pos = 0,
	uid = 0
	}).

-define(CMD_GS2U_PetOutFightRet,57992).
-record(pk_GS2U_PetOutFightRet,{
	op = 0,
	type = 0,
	pos = 0,
	uid = 0,
	err_code = 0
	}).

-define(CMD_U2GS_PetOutFightReplace,16489).
-record(pk_U2GS_PetOutFightReplace,{
	type = 0,
	pos = 0,
	uid = 0
	}).

-define(CMD_PetOut,42571).
-record(pk_PetOut,{
	type = 0,
	pos = 0,
	uid = 0
	}).

-define(CMD_U2GS_PetOutFightOneKey,53866).
-record(pk_U2GS_PetOutFightOneKey,{
	list = []
	}).

-define(CMD_GS2U_PetOutFightOneKey,61449).
-record(pk_GS2U_PetOutFightOneKey,{
	err_code = 0
	}).

-define(CMD_U2GS_PetOutDef,14188).
-record(pk_U2GS_PetOutDef,{
	func_id = 0,
	type = 0,
	pos = 0,
	uid = 0
	}).

-define(CMD_GS2U_PetOutDef,53271).
-record(pk_GS2U_PetOutDef,{
	fun_id = 0,
	op = 0,
	type = 0,
	pos = 0,
	uid = 0,
	err_code = 0
	}).

-define(CMD_U2GS_PetOutDefOneKey,23166).
-record(pk_U2GS_PetOutDefOneKey,{
	func_id = 0,
	list = []
	}).

-define(CMD_GS2U_PetOutDefOneKey,24091).
-record(pk_GS2U_PetOutDefOneKey,{
	err_code = 0,
	func_id = 0
	}).

-define(CMD_U2GS_PetOffDefOneKey,41043).
-record(pk_U2GS_PetOffDefOneKey,{
	func_id = 0
	}).

-define(CMD_GS2U_PetOffDefOneKey,41969).
-record(pk_GS2U_PetOffDefOneKey,{
	err_code = 0,
	func_id = 0
	}).

-define(CMD_U2GS_PetAutoSkill,11835).
-record(pk_U2GS_PetAutoSkill,{
	type = 0,
	pos = 0,
	is_auto_skill = 0
	}).

-define(CMD_GS2U_PetAutoSkillRet,2968).
-record(pk_GS2U_PetAutoSkillRet,{
	type = 0,
	pos = 0,
	is_auto_skill = 0,
	uid = 0,
	err_code = 0
	}).

-define(CMD_GS2U_PetMasterUpdate,22619).
-record(pk_GS2U_PetMasterUpdate,{
	lv = 0
	}).

-define(CMD_U2GS_PetMasterActive,7405).
-record(pk_U2GS_PetMasterActive,{
	f_lv = 0
	}).

-define(CMD_GS2U_PetMasterActiveRet,53092).
-record(pk_GS2U_PetMasterActiveRet,{
	f_lv = 0,
	err_code = 0
	}).

-define(CMD_PetDrawConsume,20452).
-record(pk_PetDrawConsume,{
	vip_f = 0,
	vip_c = 0,
	draw_time = 0,
	item = 0,
	num = 0
	}).

-define(CMD_PetWish,12242).
-record(pk_PetWish,{
	type = 0,
	pet_id = 0
	}).

-define(CMD_PetDrawShow,32968).
-record(pk_PetDrawShow,{
	type = 0,
	quality = 0,
	per = 0
	}).

-define(CMD_QualityShow,53996).
-record(pk_QualityShow,{
	index = 0,
	quality = 0
	}).

-define(CMD_PetDrawInfo,18140).
-record(pk_PetDrawInfo,{
	id = 0,
	day_time = 0,
	day_limit = 0,
	all_time = 0,
	wish_time = 0,
	wish_vip = 0,
	can_free = 0,
	free_time = 0,
	cost_item = [],
	cost_coin = [],
	score_cost = #pk_key_value{},
	score_award = [],
	pet_wish = [],
	element = 0,
	switch_time = 0,
	switch_cost = #pk_key_value{},
	show_per = [],
	preview = [],
	per_text = ""
	}).

-define(CMD_PetDrawLibrary,47677).
-record(pk_PetDrawLibrary,{
	id = 0,
	index_item = [],
	quality_show = []
	}).

-define(CMD_PetDrawItem,63985).
-record(pk_PetDrawItem,{
	cfgId = 0,
	amount = 0,
	is_new = 0
	}).

-define(CMD_U2GS_PetDrawInfo,63766).
-record(pk_U2GS_PetDrawInfo,{
	id = 0
	}).

-define(CMD_GS2U_PetDrawInfoRet,31653).
-record(pk_GS2U_PetDrawInfoRet,{
	err_code = 0,
	info = #pk_PetDrawInfo{}
	}).

-define(CMD_U2GS_PetDrawLib,43457).
-record(pk_U2GS_PetDrawLib,{
	id = 0
	}).

-define(CMD_GS2U_PetDrawLibRet,16079).
-record(pk_GS2U_PetDrawLibRet,{
	id = 0,
	err_code = 0,
	lib = []
	}).

-define(CMD_U2GS_PetDraw,50633).
-record(pk_U2GS_PetDraw,{
	id = 0,
	num = 0,
	is_free = 0
	}).

-define(CMD_GS2U_PetDrawRet,43021).
-record(pk_GS2U_PetDrawRet,{
	id = 0,
	num = 0,
	is_free = 0,
	next_free_time = 0,
	draw_item = [],
	draw_coin = [],
	err_code = 0
	}).

-define(CMD_U2GS_PetDrawScoreAward,47684).
-record(pk_U2GS_PetDrawScoreAward,{
	id = 0,
	type = 0,
	num = 0
	}).

-define(CMD_GS2U_PetDrawScoreAwardRet,59283).
-record(pk_GS2U_PetDrawScoreAwardRet,{
	id = 0,
	draw_item = [],
	err_code = 0
	}).

-define(CMD_U2GS_PetDrawSetWish,48888).
-record(pk_U2GS_PetDrawSetWish,{
	id = 0,
	wish_list = []
	}).

-define(CMD_GS2U_PetDrawSetWishRet,31198).
-record(pk_GS2U_PetDrawSetWishRet,{
	err_code = 0,
	id = 0,
	wish_list = []
	}).

-define(CMD_U2GS_ChangeElement,58478).
-record(pk_U2GS_ChangeElement,{
	id = 0,
	type = 0
	}).

-define(CMD_GS2U_ChangeElementRes,14986).
-record(pk_GS2U_ChangeElementRes,{
	id = 0,
	element = 0,
	err_code = 0
	}).

-define(CMD_GS2U_PetDrawRed,46956).
-record(pk_GS2U_PetDrawRed,{
	normal_score = 0,
	normal_free = 0,
	unknown_free = 0,
	normal_ten = 0,
	senior_ten = 0,
	unknown_ten = 0
	}).

-define(CMD_GS2U_PetDrawBubbles,39491).
-record(pk_GS2U_PetDrawBubbles,{
	normal_bubble = 0,
	normal_times = 0,
	senior_bubble = 0,
	senior_times = 0,
	unknown_bubble = 0,
	unknown_times = 0
	}).

-define(CMD_U2GS_PetSubstitutionLow,57761).
-record(pk_U2GS_PetSubstitutionLow,{
	uid = 0,
	tpye = 0
	}).

-define(CMD_U2GS_PetSubstitutionHigh,34498).
-record(pk_U2GS_PetSubstitutionHigh,{
	uid = 0,
	pet_id = 0,
	cost_uid_list = [],
	tpye = 0
	}).

-define(CMD_GS2U_PetSubstitutionRet,9155).
-record(pk_GS2U_PetSubstitutionRet,{
	uid = 0,
	pet_id = 0,
	err_code = 0
	}).

-define(CMD_GS2U_PetGuardSync,21987).
-record(pk_GS2U_PetGuardSync,{
	uid_list = [],
	shared_uid = 0,
	state = 0
	}).

-define(CMD_PetEnter,59309).
-record(pk_PetEnter,{
	pos = 0,
	uid = 0,
	pet_cfg_id = 0,
	cd = 0,
	lv = 0,
	unlock_time = 0
	}).

-define(CMD_GS2U_PetEnterSync,31031).
-record(pk_GS2U_PetEnterSync,{
	pet_enter = []
	}).

-define(CMD_U2GS_PetUnlockPosReq,15448).
-record(pk_U2GS_PetUnlockPosReq,{
	pos = 0
	}).

-define(CMD_GS2U_PetUnlockPosRet,27925).
-record(pk_GS2U_PetUnlockPosRet,{
	pos = 0,
	err_code = 0
	}).

-define(CMD_U2GS_PetEnterReq,42162).
-record(pk_U2GS_PetEnterReq,{
	pos = 0,
	uid = 0
	}).

-define(CMD_GS2U_PetEnterRet,8989).
-record(pk_GS2U_PetEnterRet,{
	pos = 0,
	uid = 0,
	op = 0,
	cd = 0,
	err_code = 0
	}).

-define(CMD_U2GS_ResetPosCDReq,7378).
-record(pk_U2GS_ResetPosCDReq,{
	pos = 0
	}).

-define(CMD_GS2U_ResetPosCDRet,11091).
-record(pk_GS2U_ResetPosCDRet,{
	pos = 0,
	err_code = 0
	}).

-define(CMD_U2GS_PetPosLevelUp,27912).
-record(pk_U2GS_PetPosLevelUp,{
	pos = 0
	}).

-define(CMD_GS2U_PetPosLevelUp,20075).
-record(pk_GS2U_PetPosLevelUp,{
	pos = 0,
	err_code = 0
	}).

-define(CMD_U2GS_PetPosLevelBack,45249).
-record(pk_U2GS_PetPosLevelBack,{
	pos = 0
	}).

-define(CMD_GS2U_PetPosLevelBackRet,27686).
-record(pk_GS2U_PetPosLevelBackRet,{
	pos = 0,
	err_code = 0
	}).

-define(CMD_arena_player,63370).
-record(pk_arena_player,{
	player_id = 0,
	player_name = "",
	server_name = "",
	guild_name = "",
	head_id = 0,
	frame_id = 0,
	sex = 0,
	career = 0,
	battle_value = 0,
	score = 0,
	rank = 0
	}).

-define(CMD_arena_player_model,47019).
-record(pk_arena_player_model,{
	player_model = #pk_playerModelUI{},
	score = 0,
	rank = 0,
	top_times = 0
	}).

-define(CMD_U2GS_arena_info,20658).
-record(pk_U2GS_arena_info,{
	}).

-define(CMD_GS2U_arena_info,12353).
-record(pk_GS2U_arena_info,{
	my_score = 0,
	my_rank = 0,
	player_list = [],
	last_season_time = 0
	}).

-define(CMD_U2GS_arena_rank,49811).
-record(pk_U2GS_arena_rank,{
	}).

-define(CMD_GS2U_arena_rank,41508).
-record(pk_GS2U_arena_rank,{
	my_score = 0,
	my_rank = 0
	}).

-define(CMD_U2GS_arena_top,31956).
-record(pk_U2GS_arena_top,{
	}).

-define(CMD_GS2U_arena_top,5502).
-record(pk_GS2U_arena_top,{
	player_list = []
	}).

-define(CMD_U2GS_arena_match,16954).
-record(pk_U2GS_arena_match,{
	}).

-define(CMD_GS2U_arena_match,37766).
-record(pk_GS2U_arena_match,{
	last_time = 0,
	player_list = []
	}).

-define(CMD_U2GS_arena_refresh,32210).
-record(pk_U2GS_arena_refresh,{
	}).

-define(CMD_GS2U_arena_refresh,24373).
-record(pk_GS2U_arena_refresh,{
	last_time = 0,
	player_list = []
	}).

-define(CMD_U2GS_arena_fight,720).
-record(pk_U2GS_arena_fight,{
	player_id = 0,
	is_skip = false
	}).

-define(CMD_GS2U_arena_fight,21532).
-record(pk_GS2U_arena_fight,{
	error = 0,
	target_model = #pk_playerModelUI{}
	}).

-define(CMD_arena_player_report,12363).
-record(pk_arena_player_report,{
	player = #pk_arena_player{},
	add_score = 0,
	time = 0
	}).

-define(CMD_U2GS_arena_report,22062).
-record(pk_U2GS_arena_report,{
	}).

-define(CMD_GS2U_arena_report,51247).
-record(pk_GS2U_arena_report,{
	player_list = []
	}).

-define(CMD_U2GS_arena_last_season,9810).
-record(pk_U2GS_arena_last_season,{
	}).

-define(CMD_GS2U_arena_last_season,17393).
-record(pk_GS2U_arena_last_season,{
	my_score = 0,
	my_rank = 0,
	season_time = 0,
	player_list = [],
	world_level = 0
	}).

-define(CMD_GS2U_arena_times_notice,283).
-record(pk_GS2U_arena_times_notice,{
	remain = 0
	}).

-define(CMD_GS2U_arena_report_notice,17886).
-record(pk_GS2U_arena_report_notice,{
	time = 0
	}).

-define(CMD_U2GS_PetLink,38225).
-record(pk_U2GS_PetLink,{
	uid = 0,
	target_uid = 0
	}).

-define(CMD_GS2U_PetLinkRet,65503).
-record(pk_GS2U_PetLinkRet,{
	uid = 0,
	target_uid = 0,
	error_code = 0
	}).

-define(CMD_U2GS_CancelPetLink,49209).
-record(pk_U2GS_CancelPetLink,{
	uid = 0,
	target_uid = 0
	}).

-define(CMD_GS2U_CancelPetLinkRet,16857).
-record(pk_GS2U_CancelPetLinkRet,{
	uid = 0,
	target_uid = 0,
	error_code = 0
	}).

-define(CMD_U2GS_PetAppendage,29393).
-record(pk_U2GS_PetAppendage,{
	uid = 0,
	target_uid = 0
	}).

-define(CMD_GS2U_PetAppendageRet,34568).
-record(pk_GS2U_PetAppendageRet,{
	uid = 0,
	target_uid = 0,
	error_code = 0
	}).

-define(CMD_U2GS_CancelPetAppendage,41244).
-record(pk_U2GS_CancelPetAppendage,{
	uid = 0,
	target_uid = 0
	}).

-define(CMD_GS2U_CancelPetAppendageRet,42052).
-record(pk_GS2U_CancelPetAppendageRet,{
	uid = 0,
	target_uid = 0,
	error_code = 0
	}).

-define(CMD_U2GS_GetWingDungeonsPlayerInfo,50719).
-record(pk_U2GS_GetWingDungeonsPlayerInfo,{
	id = 0
	}).

-define(CMD_GS2U_GetWingDungeonsPlayerInfoRet,58330).
-record(pk_GS2U_GetWingDungeonsPlayerInfoRet,{
	id = 0,
	challenge_area = [],
	open_area = [],
	shop = [],
	can_enter = 0,
	is_complete = 0
	}).

-define(CMD_U2GS_GetWingDungeonsMaxId,9636).
-record(pk_U2GS_GetWingDungeonsMaxId,{
	}).

-define(CMD_GS2U_GetWingDungeonsMaxIdRet,50972).
-record(pk_GS2U_GetWingDungeonsMaxIdRet,{
	id = 0
	}).

-define(CMD_U2GS_EnterWingDungeonsDungeon,13527).
-record(pk_U2GS_EnterWingDungeonsDungeon,{
	id = 0,
	x = 0,
	y = 0
	}).

-define(CMD_GS2U_EnterWingDungeonsDungeonRet,51415).
-record(pk_GS2U_EnterWingDungeonsDungeonRet,{
	id = 0,
	x = 0,
	y = 0,
	err_code = 0
	}).

-define(CMD_GS2U_WingDungeonsDungeonSync,2580).
-record(pk_GS2U_WingDungeonsDungeonSync,{
	kill_num = 0,
	cur_num = 0,
	exp = 0
	}).

-define(CMD_GS2U_WingDungeonsDungeonSettle,45763).
-record(pk_GS2U_WingDungeonsDungeonSettle,{
	is_win = 0,
	energy = 0,
	items = [],
	coins = [],
	eqs = []
	}).

-define(CMD_U2GS_WingDungeonsResetMap,43173).
-record(pk_U2GS_WingDungeonsResetMap,{
	id = 0
	}).

-define(CMD_GS2U_WingDungeonsResetMapRet,56573).
-record(pk_GS2U_WingDungeonsResetMapRet,{
	id = 0,
	challenge_area = [],
	open_area = [],
	err_code = 0
	}).

-define(CMD_U2GS_WingDungeonsShopping,43841).
-record(pk_U2GS_WingDungeonsShopping,{
	id = 0,
	item_num = 0
	}).

-define(CMD_GS2U_WingDungeonsShoppingRet,51752).
-record(pk_GS2U_WingDungeonsShoppingRet,{
	id = 0,
	item_num = 0,
	err_code = 0
	}).

-define(CMD_U2GS_WingDungeonsSyncEnergy,12279).
-record(pk_U2GS_WingDungeonsSyncEnergy,{
	}).

-define(CMD_GS2U_WingDungeonsSyncEnergy,49863).
-record(pk_GS2U_WingDungeonsSyncEnergy,{
	energy = 0,
	energy_buy_show = 0
	}).

-define(CMD_GS2U_WingDungeonsAddEnergy,64895).
-record(pk_GS2U_WingDungeonsAddEnergy,{
	item_id = 0,
	use_num = 0,
	add_energy = 0
	}).

-define(CMD_U2GS_WingDungeonsMopup,57880).
-record(pk_U2GS_WingDungeonsMopup,{
	id = 0,
	x = 0,
	y = 0
	}).

-define(CMD_GS2U_WingDungeonsMopupRet,51531).
-record(pk_GS2U_WingDungeonsMopupRet,{
	err_code = 0,
	id = 0,
	x = 0,
	y = 0,
	exp = 0,
	items = [],
	coins = [],
	eqs = []
	}).

-define(CMD_DungeonMountInfo,16403).
-record(pk_DungeonMountInfo,{
	dungeonID = 0,
	freeTimes = 0,
	maxProgress = 0,
	star = 0
	}).

-define(CMD_DungeonMountGroupInfo,20273).
-record(pk_DungeonMountGroupInfo,{
	type = 0,
	maxFightCount = 0,
	fightCount = 0,
	buyFightCountDay = 0,
	dungeonList = []
	}).

-define(CMD_DungeonMountFightCount,11851).
-record(pk_DungeonMountFightCount,{
	type = 0,
	maxFightCount = 0,
	fightCount = 0,
	buyFightCountDay = 0
	}).

-define(CMD_GS2U_DungeonMountFightResult,3664).
-record(pk_GS2U_DungeonMountFightResult,{
	dungeonID = 0,
	progress = 0,
	maxProgress = 0,
	cur_star = 0,
	max_star = 0,
	is_first_star = 0,
	isOpenNext = false,
	exp = 0,
	double_times = 0,
	coinList = [],
	itemList = [],
	eq_list = [],
	max_enter_count = 0,
	enter_count = 0,
	firstCoinList = [],
	firstItemList = [],
	first_eq_list = []
	}).

-define(CMD_U2GS_DungeonMountInfo,39503).
-record(pk_U2GS_DungeonMountInfo,{
	}).

-define(CMD_GS2U_DungeonMountInfo,4566).
-record(pk_GS2U_DungeonMountInfo,{
	groupList = []
	}).

-define(CMD_U2GS_EnterDungeonMount,48631).
-record(pk_U2GS_EnterDungeonMount,{
	dungeonID = 0
	}).

-define(CMD_U2GS_MopupDungeonMount,13344).
-record(pk_U2GS_MopupDungeonMount,{
	dungeonID = 0
	}).

-define(CMD_GS2U_MopupDungeonMount,20927).
-record(pk_GS2U_MopupDungeonMount,{
	dungeonID = 0,
	maxProgress = 0,
	isOpenNext = false,
	exp = 0,
	coinList = [],
	itemList = [],
	eq_list = [],
	double_times = 0,
	star = 0
	}).

-define(CMD_DungeonMountBase,15399).
-record(pk_DungeonMountBase,{
	batch = 0,
	remain_num = 0,
	escape_score = 0
	}).

-define(CMD_GS2U_DungeonMountBaseInfo,49672).
-record(pk_GS2U_DungeonMountBaseInfo,{
	base = #pk_DungeonMountBase{}
	}).

-define(CMD_GS2U_DungeonMountBaseUpdate_Batch,65345).
-record(pk_GS2U_DungeonMountBaseUpdate_Batch,{
	batch = 0
	}).

-define(CMD_GS2U_DungeonMountBaseUpdate_Remain,27663).
-record(pk_GS2U_DungeonMountBaseUpdate_Remain,{
	remain_num = 0
	}).

-define(CMD_GS2U_DungeonMountBaseUpdate_Escape,1875).
-record(pk_GS2U_DungeonMountBaseUpdate_Escape,{
	monsterID = 0,
	escape_score = 0
	}).

-define(CMD_Buff,64529).
-record(pk_Buff,{
	id = 0,
	buff_data_id = 0
	}).

-define(CMD_BuffInfo,31953).
-record(pk_BuffInfo,{
	playerId = 0,
	buffs = []
	}).

-define(CMD_GS2U_BuffInfo,50443).
-record(pk_GS2U_BuffInfo,{
	buffinfo = #pk_BuffInfo{}
	}).

-define(CMD_U2GS_TakeBuffObject,25575).
-record(pk_U2GS_TakeBuffObject,{
	id = 0
	}).

-define(CMD_GS2U_TakeBuffObject,38226).
-record(pk_GS2U_TakeBuffObject,{
	playerID = 0,
	id = 0,
	dataID = 0,
	errorCode = 0
	}).

-define(CMD_U2GS_UseTakeBuffObject,40916).
-record(pk_U2GS_UseTakeBuffObject,{
	id = 0
	}).

-define(CMD_GS2U_UseTakeBuffObject,48499).
-record(pk_GS2U_UseTakeBuffObject,{
	id = 0,
	dataID = 0,
	errorCode = 0
	}).

-define(CMD_mainlineCopyMap,60799).
-record(pk_mainlineCopyMap,{
	dungeon_id = 0,
	times = 0,
	reset_times = 0,
	star = 0
	}).

-define(CMD_mainlineCopyMapChapter,20105).
-record(pk_mainlineCopyMapChapter,{
	chapter_id = 0,
	award_star_list = [],
	list = []
	}).

-define(CMD_U2GS_getMainlineCopyMsg,23453).
-record(pk_U2GS_getMainlineCopyMsg,{
	chapter_list = []
	}).

-define(CMD_GS2U_getMainlineCopyMsgRet,24034).
-record(pk_GS2U_getMainlineCopyMsgRet,{
	list = []
	}).

-define(CMD_GS2U_getMainlineCopyMsgAll,12137).
-record(pk_GS2U_getMainlineCopyMsgAll,{
	list = []
	}).

-define(CMD_U2GS_enterMainlineCopyMap,43958).
-record(pk_U2GS_enterMainlineCopyMap,{
	dungeon_id = 0
	}).

-define(CMD_GS2U_enterMainlineCopyMapRet,12972).
-record(pk_GS2U_enterMainlineCopyMapRet,{
	dungeon_id = 0,
	error_code = 0
	}).

-define(CMD_U2GS_mainlineCopyReultE,21429).
-record(pk_U2GS_mainlineCopyReultE,{
	keyindex = 0,
	info = <<>>
	}).

-define(CMD_U2GS_mainlineCopyReult,46663).
-record(pk_U2GS_mainlineCopyReult,{
	dungeon_id = 0,
	result = 0,
	hp = 0,
	eval_cond_list = []
	}).

-define(CMD_GS2U_mainlineCopyReultRet,28873).
-record(pk_GS2U_mainlineCopyReultRet,{
	dungeon_id = 0,
	result = 0,
	eval_cond_list = [],
	itemList = [],
	equipmentList = [],
	coinList = [],
	firstItemList = [],
	firstEquipmentList = [],
	exp = 0,
	times = 0,
	star = 0,
	error_code = 0
	}).

-define(CMD_U2GS_getMainlineChapterAward,35566).
-record(pk_U2GS_getMainlineChapterAward,{
	chapter_id = 0,
	index = 0
	}).

-define(CMD_GS2U_getMainlineChapterAwardRet,17567).
-record(pk_GS2U_getMainlineChapterAwardRet,{
	chapter_id = 0,
	index = 0,
	error_code = 0
	}).

-define(CMD_MopMainAward,50261).
-record(pk_MopMainAward,{
	itemList = [],
	eq_list = [],
	coinList = [],
	exp = 0
	}).

-define(CMD_U2GS_MopUpMainlineCopyMap,22820).
-record(pk_U2GS_MopUpMainlineCopyMap,{
	dungeon_id = 0,
	count = 0
	}).

-define(CMD_GS2U_MopUpMainlineCopyMapRet,29401).
-record(pk_GS2U_MopUpMainlineCopyMapRet,{
	error_code = 0,
	dungeon_id = 0,
	count = 0,
	itemList = []
	}).

-define(CMD_U2GS_mainlineCopyMapResetTimes,29950).
-record(pk_U2GS_mainlineCopyMapResetTimes,{
	dungeon_id = 0
	}).

-define(CMD_GS2U_mainlineCopyMapResetTimesRet,53951).
-record(pk_GS2U_mainlineCopyMapResetTimesRet,{
	dungeon_id = 0,
	error_code = 0
	}).

-define(CMD_U2GS_mainlineCopyMapSeckill,2809).
-record(pk_U2GS_mainlineCopyMapSeckill,{
	dungeon_id = 0
	}).

-define(CMD_GS2U_mainlineCopyMapSeckillRet,33394).
-record(pk_GS2U_mainlineCopyMapSeckillRet,{
	error_code = 0,
	dungeon_id = 0,
	itemList = [],
	eq_list = [],
	coinList = [],
	exp = 0
	}).

-define(CMD_egg_info,9874).
-record(pk_egg_info,{
	egg_id = 0,
	start_time = 0,
	end_time = 0,
	look_pet = 0,
	is_finish = 0
	}).

-define(CMD_GS2U_DragonEggFuncOpenRet,51961).
-record(pk_GS2U_DragonEggFuncOpenRet,{
	is_open = 0
	}).

-define(CMD_GS2U_DragonEggUpdateRet,64097).
-record(pk_GS2U_DragonEggUpdateRet,{
	eggs = []
	}).

-define(CMD_U2GS_GetDragonEgg,35693).
-record(pk_U2GS_GetDragonEgg,{
	egg_id = 0
	}).

-define(CMD_GS2U_GetDragonEggRet,46977).
-record(pk_GS2U_GetDragonEggRet,{
	egg_id = 0,
	error_code = 0
	}).

-define(CMD_U2GS_LookAfterEgg,63773).
-record(pk_U2GS_LookAfterEgg,{
	egg_id = 0,
	pet_uid = 0
	}).

-define(CMD_GS2U_LookAfterEggRet,26663).
-record(pk_GS2U_LookAfterEggRet,{
	egg_id = 0,
	pet_uid = 0,
	error_code = 0
	}).

-define(CMD_U2GS_HatchComplete,30544).
-record(pk_U2GS_HatchComplete,{
	egg_id = 0
	}).

-define(CMD_GS2U_HatchCompleteRet,62082).
-record(pk_GS2U_HatchCompleteRet,{
	egg_id = 0,
	pet_uid = 0,
	error_code = 0
	}).

-define(CMD_U2GS_EggGrowth,42451).
-record(pk_U2GS_EggGrowth,{
	}).

-define(CMD_GS2U_EggGrowth,15997).
-record(pk_GS2U_EggGrowth,{
	error_code = 0
	}).

-define(CMD_GS2U_hatch_info,10890).
-record(pk_GS2U_hatch_info,{
	eggs = [],
	is_reward = 0,
	ac_list = []
	}).

-define(CMD_U2GS_hatch_add_energy,32885).
-record(pk_U2GS_hatch_add_energy,{
	id = 0,
	type = 0
	}).

-define(CMD_GS2U_hatch_add_energy,63483).
-record(pk_GS2U_hatch_add_energy,{
	error_code = 0,
	id = 0,
	type = 0
	}).

-define(CMD_U2GS_hatch_reward,19608).
-record(pk_U2GS_hatch_reward,{
	}).

-define(CMD_GS2U_hatch_reward,48794).
-record(pk_GS2U_hatch_reward,{
	error_code = 0
	}).

-define(CMD_U2GS_HatchComplete2,24636).
-record(pk_U2GS_HatchComplete2,{
	}).

-define(CMD_GS2U_HatchComplete2,37287).
-record(pk_GS2U_HatchComplete2,{
	error_code = 0,
	pet_uid = 0,
	new_pet_uid = 0
	}).

-define(CMD_U2GS_player_view_base,24741).
-record(pk_U2GS_player_view_base,{
	player_id = 0,
	type = 0,
	server_id = 0
	}).

-define(CMD_GS2U_player_view_base,55340).
-record(pk_GS2U_player_view_base,{
	player_id = 0,
	type = 0,
	error = 0,
	server_id = 0,
	server_name = "",
	head_id = 0,
	sex = 0,
	vip = 0,
	career = 0,
	level = 0,
	team = #pk_team_view{},
	guild = #pk_guild_view{},
	head_frame = 0,
	player_name = "",
	battle_value = 0,
	nationality_id = 0,
	pet_list = [],
	pos_list = [],
	param1 = 0,
	param2 = 0,
	mate_id = 0,
	mate_name = "",
	mate_sex = 0,
	pet_illusion_list = []
	}).

-define(CMD_view_cup,3191).
-record(pk_view_cup,{
	cup_id = 0,
	level = 0
	}).

-define(CMD_view_astro,28613).
-record(pk_view_astro,{
	rare = 0,
	num = 0
	}).

-define(CMD_U2GS_player_view,64010).
-record(pk_U2GS_player_view,{
	player_id = 0,
	type = 0,
	server_id = 0
	}).

-define(CMD_GS2U_player_view,19286).
-record(pk_GS2U_player_view,{
	error = 0,
	player_id = 0,
	type = 0,
	name = "",
	level = 0,
	battle_value = 0,
	head_id = 0,
	head_frame = 0,
	sex = 0,
	vip = 0,
	nationality_id = 0,
	guild = #pk_guild_view{},
	wedding = #pk_wedding_view{},
	role_list = [],
	role_skill_list = [],
	pet_list = [],
	eq_pos = [],
	gem_lv = [],
	shouling_lv = 0,
	yiling_lv = 0,
	mount_list = [],
	wing_list = [],
	constellation_list = [],
	fashion_id = [],
	head_num = 0,
	head_frame_num = 0,
	chat_bubble_num = 0,
	dg_num = 0,
	db_statue_num = 0,
	dg_weaopn_num = 0,
	eq_collection = [],
	relic_list = [],
	cup_list = [],
	weapon_suit = 0,
	weapon_main = 0,
	weapon_sup = 0,
	astro_list = [],
	title_property_list = [],
	mate_id = 0,
	mate_name = "",
	mate_sex = 0,
	pet_illusion_list = [],
	shengjia_stage_list = [],
	shengwenpos_list = [],
	shengwen_list = [],
	keepsake_list = [],
	fazhen_view_list = [],
	shield_skill_list = []
	}).

-define(CMD_GS2U_object_shield,36513).
-record(pk_GS2U_object_shield,{
	object_id = 0,
	value = 0
	}).

-define(CMD_U2GS_draw_vip,24759).
-record(pk_U2GS_draw_vip,{
	}).

-define(CMD_GS2U_draw_vip,13819).
-record(pk_GS2U_draw_vip,{
	error_code = 0,
	type = 0
	}).

-define(CMD_GS2U_servar_group_cfg_sync,62109).
-record(pk_GS2U_servar_group_cfg_sync,{
	type = 0,
	group_id = 0
	}).

-define(CMD_U2GS_sync_active_pass,36648).
-record(pk_U2GS_sync_active_pass,{
	}).

-define(CMD_GS2U_sync_active_pass,1710).
-record(pk_GS2U_sync_active_pass,{
	active = 0,
	free_gift = [],
	pay_gift = [],
	reset_time = 0,
	is_pay = 0,
	player_lv = 0
	}).

-define(CMD_U2GS_get_active_pass_reward,25144).
-record(pk_U2GS_get_active_pass_reward,{
	id = 0
	}).

-define(CMD_GS2U_get_active_pass_reward,62729).
-record(pk_GS2U_get_active_pass_reward,{
	error_code = 0,
	id = 0
	}).

-define(CMD_U2GS_open_active_pass_pay,14616).
-record(pk_U2GS_open_active_pass_pay,{
	id = 0
	}).

-define(CMD_GS2U_open_active_pass_pay,53494).
-record(pk_GS2U_open_active_pass_pay,{
	id = 0,
	error_code = 0,
	is_first = 0
	}).

-define(CMD_WheelLuckDiamond,39207).
-record(pk_WheelLuckDiamond,{
	num = 0,
	condition = 0,
	location = 0,
	award = #pk_key_2value{},
	level = 0
	}).

-define(CMD_WheelGoodFortune,40158).
-record(pk_WheelGoodFortune,{
	condition = 0,
	award_show = [],
	multiple_show = [],
	curr_type = 0,
	max_chance = 0,
	double_award_total = 0,
	probability_text = "",
	double_notice = 0
	}).

-define(CMD_WinRecord,32122).
-record(pk_WinRecord,{
	name = "",
	sex = 0,
	cfg_id = 0,
	amount = 0,
	multiple = 0,
	double_mul = 0
	}).

-define(CMD_GS2U_wheel_luck_diamond_ret,56997).
-record(pk_GS2U_wheel_luck_diamond_ret,{
	err_code = 0,
	id = 0,
	cfg_list = [],
	recharge_num = 0,
	has_drawn_times = 0,
	draw_list = []
	}).

-define(CMD_GS2U_wheel_good_fortune_ret,46346).
-record(pk_GS2U_wheel_good_fortune_ret,{
	err_code = 0,
	id = 0,
	cfg_list = #pk_WheelGoodFortune{},
	recharge_num = 0,
	lucky_value = 0,
	has_drawn_times = 0
	}).

-define(CMD_U2GS_wheel_luck_diamond_draw,19296).
-record(pk_U2GS_wheel_luck_diamond_draw,{
	id = 0,
	one_key = 0
	}).

-define(CMD_GS2U_wheel_luck_diamond_draw_ret,34690).
-record(pk_GS2U_wheel_luck_diamond_draw_ret,{
	err_code = 0,
	id = 0,
	one_key = 0,
	award_times = 0,
	draw_pos = []
	}).

-define(CMD_U2GS_wheel_good_fortune_draw,21703).
-record(pk_U2GS_wheel_good_fortune_draw,{
	id = 0,
	one_key = 0
	}).

-define(CMD_GS2U_wheel_good_fortune_draw_ret,57583).
-record(pk_GS2U_wheel_good_fortune_draw_ret,{
	err_code = 0,
	id = 0,
	one_key = 0,
	lucky_value = 0,
	award = []
	}).

-define(CMD_U2GS_wheel_good_luck_record,62584).
-record(pk_U2GS_wheel_good_luck_record,{
	id = 0,
	type = 0
	}).

-define(CMD_GS2U_wheel_good_luck_record_ret,9691).
-record(pk_GS2U_wheel_good_luck_record_ret,{
	id = 0,
	type = 0,
	record = []
	}).

-define(CMD_PetCityBuild,50460).
-record(pk_PetCityBuild,{
	id = 0,
	lv = 0,
	time = 0,
	param = 0,
	param2 = 0,
	make_time = 0,
	lv_list = [],
	pray_list = [],
	time_start = 0,
	time_func_start = 0
	}).

-define(CMD_PetCityTask,3010).
-record(pk_PetCityTask,{
	task_id = 0,
	progress = 0,
	is_reward = 0
	}).

-define(CMD_U2GS_pet_city_info,1374).
-record(pk_U2GS_pet_city_info,{
	}).

-define(CMD_GS2U_pet_city_info,59073).
-record(pk_GS2U_pet_city_info,{
	build_list = []
	}).

-define(CMD_U2GS_pet_city_task,50387).
-record(pk_U2GS_pet_city_task,{
	}).

-define(CMD_GS2U_pet_city_task,42550).
-record(pk_GS2U_pet_city_task,{
	task_list = []
	}).

-define(CMD_U2GS_pet_city_update,5725).
-record(pk_U2GS_pet_city_update,{
	id = 0
	}).

-define(CMD_GS2U_pet_city_update,6650).
-record(pk_GS2U_pet_city_update,{
	build_list = []
	}).

-define(CMD_GS2U_pet_city_task_update,43602).
-record(pk_GS2U_pet_city_task_update,{
	task_list = []
	}).

-define(CMD_U2GS_pet_city_build_level_up,53400).
-record(pk_U2GS_pet_city_build_level_up,{
	id = 0
	}).

-define(CMD_GS2U_pet_city_build_level_up,62154).
-record(pk_GS2U_pet_city_build_level_up,{
	error_code = 0,
	id = 0
	}).

-define(CMD_U2GS_pet_city_quick_build,25662).
-record(pk_U2GS_pet_city_quick_build,{
	id = 0
	}).

-define(CMD_GS2U_pet_city_quick_build,64540).
-record(pk_GS2U_pet_city_quick_build,{
	error_code = 0,
	id = 0
	}).

-define(CMD_U2GS_pet_city_research,21842).
-record(pk_U2GS_pet_city_research,{
	id = 0,
	pet_id = 0
	}).

-define(CMD_GS2U_pet_city_research,29425).
-record(pk_GS2U_pet_city_research,{
	error_code = 0,
	id = 0,
	pet_id = 0
	}).

-define(CMD_U2GS_pet_city_research_reward,39448).
-record(pk_U2GS_pet_city_research_reward,{
	}).

-define(CMD_GS2U_pet_city_research_reward,25945).
-record(pk_GS2U_pet_city_research_reward,{
	error_code = 0
	}).

-define(CMD_U2GS_pet_city_call,831).
-record(pk_U2GS_pet_city_call,{
	id = 0
	}).

-define(CMD_GS2U_pet_city_call,58530).
-record(pk_GS2U_pet_city_call,{
	error_code = 0,
	id = 0
	}).

-define(CMD_U2GS_pet_city_call_reward,36596).
-record(pk_U2GS_pet_city_call_reward,{
	}).

-define(CMD_GS2U_pet_city_call_reward,9937).
-record(pk_GS2U_pet_city_call_reward,{
	error_code = 0
	}).

-define(CMD_U2GS_pet_city_altar_reward,6096).
-record(pk_U2GS_pet_city_altar_reward,{
	id = 0
	}).

-define(CMD_GS2U_pet_city_alter_reward,2366).
-record(pk_GS2U_pet_city_alter_reward,{
	error_code = 0,
	id = 0
	}).

-define(CMD_U2GS_pet_city_equip_make,60300).
-record(pk_U2GS_pet_city_equip_make,{
	hero_id = 0,
	id = 0
	}).

-define(CMD_GS2U_pet_city_equip_make,38439).
-record(pk_GS2U_pet_city_equip_make,{
	error_code = 0,
	hero_id = 0,
	id = 0
	}).

-define(CMD_U2GS_pet_city_equip_make_reward,3704).
-record(pk_U2GS_pet_city_equip_make_reward,{
	}).

-define(CMD_GS2U_pet_city_equip_make_reward,13887).
-record(pk_GS2U_pet_city_equip_make_reward,{
	error_code = 0
	}).

-define(CMD_U2GS_pet_city_pray,7341).
-record(pk_U2GS_pet_city_pray,{
	pos = 0,
	item = 0
	}).

-define(CMD_GS2U_pet_city_pray,65040).
-record(pk_GS2U_pet_city_pray,{
	error_code = 0,
	pos = 0,
	item = 0
	}).

-define(CMD_U2GS_pet_city_pray2,56185).
-record(pk_U2GS_pet_city_pray2,{
	itemlist = []
	}).

-define(CMD_GS2U_pet_city_pray2,3299).
-record(pk_GS2U_pet_city_pray2,{
	error_code = 0,
	itemlist = []
	}).

-define(CMD_U2GS_pet_city_pray_reward,1459).
-record(pk_U2GS_pet_city_pray_reward,{
	pos = 0
	}).

-define(CMD_GS2U_pet_city_pray_reward,40336).
-record(pk_GS2U_pet_city_pray_reward,{
	error_code = 0,
	pos = 0
	}).

-define(CMD_U2GS_pet_city_task_complete,3424).
-record(pk_U2GS_pet_city_task_complete,{
	id = 0
	}).

-define(CMD_GS2U_pet_city_task_complete,41008).
-record(pk_GS2U_pet_city_task_complete,{
	error_code = 0,
	id = 0
	}).

-define(CMD_U2GS_pet_city_quick_pray,63466).
-record(pk_U2GS_pet_city_quick_pray,{
	pos = 0,
	item = 0,
	num = 0
	}).

-define(CMD_GS2U_pet_city_quick_prayRet,20882).
-record(pk_GS2U_pet_city_quick_prayRet,{
	pos = 0,
	item = 0,
	num = 0,
	error_code = 0
	}).

-define(CMD_bless_eq,286).
-record(pk_bless_eq,{
	uid = 0,
	cfg_id = 0,
	bind = 0,
	int_lv = 0,
	rand_prop = [],
	pos = 0
	}).

-define(CMD_bless_eq_pos,13498).
-record(pk_bless_eq_pos,{
	uid = 0,
	cfg_id = 0,
	pos = 0,
	stage = 0,
	battle_pos = 0,
	cast_prop = [],
	cast_prop_temp = [],
	soul_stone_list = []
	}).

-define(CMD_GS2U_BlessEqSync,37218).
-record(pk_GS2U_BlessEqSync,{
	stage_list = [],
	orn_list = [],
	orn_pos_list = []
	}).

-define(CMD_GS2U_BlessEqUpdate,15023).
-record(pk_GS2U_BlessEqUpdate,{
	op = 0,
	orn_list = []
	}).

-define(CMD_GS2U_BlessEqPosUpdate,55718).
-record(pk_GS2U_BlessEqPosUpdate,{
	orn_pos_list = []
	}).

-define(CMD_U2GS_BlessEqOp,54173).
-record(pk_U2GS_BlessEqOp,{
	op = 0,
	uid = 0,
	stage = 0,
	battle_pos = 0
	}).

-define(CMD_GS2U_BlessEqOpRet,38865).
-record(pk_GS2U_BlessEqOpRet,{
	err_code = 0,
	op = 0,
	uid = 0,
	pos = 0,
	stage = 0,
	battle_pos = 0,
	suitlist = []
	}).

-define(CMD_U2GS_BlessEqOneKeyOp,9995).
-record(pk_U2GS_BlessEqOneKeyOp,{
	op = 0,
	uids = [],
	stage = 0,
	battle_pos = 0
	}).

-define(CMD_GS2U_BlessEqOneKeyOpRet,16723).
-record(pk_GS2U_BlessEqOneKeyOpRet,{
	err_code = 0,
	op = 0,
	uids = [],
	stage = 0,
	battle_pos = 0,
	stagelv = 0,
	suitlist = []
	}).

-define(CMD_U2GS_BlessEqCast,34992).
-record(pk_U2GS_BlessEqCast,{
	pos = 0,
	stage = 0,
	battle_pos = 0,
	op = 0
	}).

-define(CMD_GS2U_BlessEqCastRet,12019).
-record(pk_GS2U_BlessEqCastRet,{
	err_code = 0,
	pos = 0,
	stage = 0,
	battle_pos = 0,
	op = 0,
	bless_eq_pos = #pk_bless_eq_pos{}
	}).

-define(CMD_U2GS_BlessEqSoulStoneOP,18282).
-record(pk_U2GS_BlessEqSoulStoneOP,{
	pos = 0,
	stage = 0,
	battle_pos = 0,
	op = 0,
	op_pos = []
	}).

-define(CMD_GS2U_BlessEqSoulStoneOPRet,50189).
-record(pk_GS2U_BlessEqSoulStoneOPRet,{
	err_code = 0,
	pos = 0,
	stage = 0,
	battle_pos = 0,
	op = 0,
	op_pos = []
	}).

-define(CMD_vipDirectPurchaseStc,48018).
-record(pk_vipDirectPurchaseStc,{
	id = 0,
	type = 0,
	curr_type = #pk_key_value{},
	direct_purchase_code = "",
	discount = [],
	discount2 = 0,
	item_new = [],
	buy_times = 0,
	has_buy_times = 0
	}).

-define(CMD_vipDirectPurchase,29926).
-record(pk_vipDirectPurchase,{
	vip_lv = 0,
	list = []
	}).

-define(CMD_U2GS_vip_direct_purchase_packs,23132).
-record(pk_U2GS_vip_direct_purchase_packs,{
	}).

-define(CMD_GS2U_vip_direct_purchase_packs,15585).
-record(pk_GS2U_vip_direct_purchase_packs,{
	packs_list = []
	}).

-define(CMD_U2GS_vip_direct_purchase_buy,27055).
-record(pk_U2GS_vip_direct_purchase_buy,{
	id = 0
	}).

-define(CMD_GS2U_vip_direct_purchase_buy_ret,3461).
-record(pk_GS2U_vip_direct_purchase_buy_ret,{
	id = 0,
	error_code = 0
	}).

-define(CMD_cloud_lucky_award_record,61829).
-record(pk_cloud_lucky_award_record,{
	name = "",
	sex = 0,
	time = 0,
	item_list = [],
	currency_list = [],
	eq_list = []
	}).

-define(CMD_cloud_lucky_buy_record,65338).
-record(pk_cloud_lucky_buy_record,{
	name = "",
	sex = 0,
	num = 0,
	time = 0
	}).

-define(CMD_GS2U_drawn_cloud_lucky_wheel_ret,49876).
-record(pk_GS2U_drawn_cloud_lucky_wheel_ret,{
	id = 0,
	err = 0,
	times = 0,
	itemCount = 0,
	itemSp_list = [],
	itemCom_list = [],
	lucky_num = [],
	total_times = 0
	}).

-define(CMD_GS2U_cloud_lucky_wheel_info_ret,51609).
-record(pk_GS2U_cloud_lucky_wheel_info_ret,{
	id = 0,
	err = 0,
	is_settle = 0,
	wheel_base_info = #pk_wheelBaseInfo{},
	drawn_times = 0,
	total_drawn_times = 0,
	itemCount = 0,
	single_limit = 0,
	full_limit = 0,
	display_pro = [],
	open_time = 0,
	close_time = 0,
	purchase_time = 0,
	award_item = [],
	model = [],
	cond_para = [],
	award_para_new1 = [],
	total_limit = 0,
	total_cond_para = [],
	award_para_new2 = [],
	lucky_num = [],
	winner_name = "",
	winner_number = 0,
	stage_award_mask = 0
	}).

-define(CMD_U2GS_cloud_lucky_stage_award,26705).
-record(pk_U2GS_cloud_lucky_stage_award,{
	id = 0,
	type = 0
	}).

-define(CMD_GS2U_cloud_lucky_stage_award_ret,19084).
-record(pk_GS2U_cloud_lucky_stage_award_ret,{
	id = 0,
	err_code = 0,
	type = 0,
	stage = []
	}).

-define(CMD_U2GS_cloud_lucky_award_record,17291).
-record(pk_U2GS_cloud_lucky_award_record,{
	id = 0
	}).

-define(CMD_GS2U_cloud_lucky_award_record_ret,15857).
-record(pk_GS2U_cloud_lucky_award_record_ret,{
	id = 0,
	list = []
	}).

-define(CMD_U2GS_cloud_lucky_buy_record,43192).
-record(pk_U2GS_cloud_lucky_buy_record,{
	id = 0
	}).

-define(CMD_GS2U_cloud_lucky_buy_record_ret,21662).
-record(pk_GS2U_cloud_lucky_buy_record_ret,{
	id = 0,
	list = []
	}).

-define(CMD_GS2U_cloud_lucky_settle_sync,19139).
-record(pk_GS2U_cloud_lucky_settle_sync,{
	id = 0,
	total_drawn_times = 0,
	winner_name = "",
	winner_number = 0
	}).

-define(CMD_consume_top_player,14824).
-record(pk_consume_top_player,{
	player_name = "",
	player_sex = 0,
	rank = 0,
	value = 0
	}).

-define(CMD_consume_top_day,24579).
-record(pk_consume_top_day,{
	day = 0,
	top_list = [],
	top_model = []
	}).

-define(CMD_GS2U_consume_top_info_ret,32338).
-record(pk_GS2U_consume_top_info_ret,{
	id = 0,
	err = 0,
	settle_type = 0,
	type = [],
	reward = [],
	my_rank = 0,
	my_value = 0,
	today_top = #pk_consume_top_day{},
	end_time = 0
	}).

-define(CMD_U2GS_consume_top_one_day,49504).
-record(pk_U2GS_consume_top_one_day,{
	id = 0,
	day = 0
	}).

-define(CMD_GS2U_consume_top_one_day_ret,9501).
-record(pk_GS2U_consume_top_one_day_ret,{
	id = 0,
	day = 0,
	today_top = #pk_consume_top_day{}
	}).

-define(CMD_tm_wheel_draw_pool,13055).
-record(pk_tm_wheel_draw_pool,{
	id = 0,
	consWay = 0,
	award = [],
	notice = [],
	probability_text = ""
	}).

-define(CMD_GS2U_tm_wheel_info_ret,15173).
-record(pk_GS2U_tm_wheel_info_ret,{
	id = 0,
	err = 0,
	activitys = [],
	integral = #pk_key_2value{},
	recommend_new = [],
	active_base_id_show = [],
	recommend_show = [],
	recommend_icon = [],
	draw_pool = [],
	draw_id = 0,
	recharge = 0,
	consume_score = 0,
	get_pos = []
	}).

-define(CMD_GS2U_drawn_tm_wheel_ret,34996).
-record(pk_GS2U_drawn_tm_wheel_ret,{
	id = 0,
	err = 0,
	times = 0,
	draw_id = 0,
	consume_score = 0,
	get_pos = []
	}).

-define(CMD_U2GS_tm_wheel_record,20245).
-record(pk_U2GS_tm_wheel_record,{
	id = 0
	}).

-define(CMD_GS2U_tm_wheel_record_ret,24282).
-record(pk_GS2U_tm_wheel_record_ret,{
	id = 0,
	my_record_list = [],
	server_record_list = []
	}).

-define(CMD_GS2U_ReturnStateSync,57952).
-record(pk_GS2U_ReturnStateSync,{
	end_time = 0,
	bind_server_id = 0,
	total_recharge = 0,
	server_list = []
	}).

-define(CMD_U2GS_BindReturnServerReq,53102).
-record(pk_U2GS_BindReturnServerReq,{
	server_id = 0
	}).

-define(CMD_GS2U_BindReturnServerRet,42790).
-record(pk_GS2U_BindReturnServerRet,{
	err_code = 0,
	server_id = 0
	}).

-define(CMD_GS2U_ReturnAcSync,50375).
-record(pk_GS2U_ReturnAcSync,{
	end_time = 0,
	total_recharge = 0,
	award_vip = false,
	award_level = [],
	award_recharge = []
	}).

-define(CMD_U2GS_ReturnAcAwardReq,29202).
-record(pk_U2GS_ReturnAcAwardReq,{
	type = 0,
	task_id = 0
	}).

-define(CMD_GS2U_ReturnAcAwardRet,5814).
-record(pk_GS2U_ReturnAcAwardRet,{
	err_code = 0,
	type = 0,
	task_id = 0
	}).

-define(CMD_GS2U_ReturnAcRedPoint,13276).
-record(pk_GS2U_ReturnAcRedPoint,{
	red_list = []
	}).

-define(CMD_selectgoodItem,29893).
-record(pk_selectgoodItem,{
	index = 0,
	sign = 0,
	type = 0,
	itemID = 0,
	count = 0,
	quality = 0,
	star = 0,
	bind = 0,
	effect = 0,
	islimit = 0
	}).

-define(CMD_selectgoods,60515).
-record(pk_selectgoods,{
	gift_id = 0,
	text = "",
	itemNew2Num = 0,
	fixed_rewards = [],
	select_rewards = [],
	currType = #pk_key_value{},
	directPurchase = "",
	discount = [],
	conditionType = #pk_key_value{},
	showType = #pk_key_value{},
	limit = #pk_key_2value{},
	redDot = 0,
	mustBuyLabel = 0,
	times = 0,
	item_list = [],
	select_item = [],
	last_item_list = []
	}).

-define(CMD_GS2U_selectgoods_info_ret,64800).
-record(pk_GS2U_selectgoods_info_ret,{
	entranceId = 0,
	item = 0,
	gift_list = [],
	error = 0
	}).

-define(CMD_U2GS_selectgoods_item,11863).
-record(pk_U2GS_selectgoods_item,{
	entranceId = 0,
	gift_id = 0,
	selectgoods_item = []
	}).

-define(CMD_GS2U_selectgoods_item_ret,47540).
-record(pk_GS2U_selectgoods_item_ret,{
	entranceId = 0,
	gift_id = 0,
	error = 0
	}).

-define(CMD_U2GS_selectgoods_buy,29929).
-record(pk_U2GS_selectgoods_buy,{
	entranceId = 0,
	gift_id = 0
	}).

-define(CMD_GS2U_selectgoods_buy_ret,55726).
-record(pk_GS2U_selectgoods_buy_ret,{
	entranceId = 0,
	gift_id = 0,
	error = 0
	}).

-define(CMD_ReBpInfo,52386).
-record(pk_ReBpInfo,{
	rein_lv = 0,
	buy = 0,
	score = 0,
	award = [],
	ext = []
	}).

-define(CMD_U2GS_ReBpInfoReq,21523).
-record(pk_U2GS_ReBpInfoReq,{
	}).

-define(CMD_GS2U_ReBpInfoSync,2367).
-record(pk_GS2U_ReBpInfoSync,{
	list = []
	}).

-define(CMD_GS2U_ReBpInfoUpdate,5615).
-record(pk_GS2U_ReBpInfoUpdate,{
	list = []
	}).

-define(CMD_U2GS_ReBpAwardReq,5078).
-record(pk_U2GS_ReBpAwardReq,{
	rein_lv = 0
	}).

-define(CMD_GS2U_ReBpAwardRet,45813).
-record(pk_GS2U_ReBpAwardRet,{
	err_code = 0,
	rein_lv = 0
	}).

-define(CMD_U2GS_ReBpScoreBuyReq,47552).
-record(pk_U2GS_ReBpScoreBuyReq,{
	rein_lv = 0,
	buy_num = 0
	}).

-define(CMD_GS2U_ReBpScoreBuyRet,60027).
-record(pk_GS2U_ReBpScoreBuyRet,{
	err_code = 0,
	rein_lv = 0,
	buy_num = 0
	}).

-define(CMD_CommonBpInfo,20113).
-record(pk_CommonBpInfo,{
	id = 0,
	order = 0,
	lv_index = 0,
	buy = 0,
	score = 0,
	award = [],
	reset_time = 0
	}).

-define(CMD_GS2U_CommonBpInfoSync,58769).
-record(pk_GS2U_CommonBpInfoSync,{
	list = []
	}).

-define(CMD_GS2U_CommonBpInfoUpdate,30833).
-record(pk_GS2U_CommonBpInfoUpdate,{
	list = []
	}).

-define(CMD_U2GS_CommonBpAward,1237).
-record(pk_U2GS_CommonBpAward,{
	id = 0,
	order = 0
	}).

-define(CMD_GS2U_CommonBpAwardRet,36681).
-record(pk_GS2U_CommonBpAwardRet,{
	err_code = 0,
	id = 0,
	order = 0
	}).

-define(CMD_U2GS_CommonBpScoreBuy,30827).
-record(pk_U2GS_CommonBpScoreBuy,{
	id = 0,
	order = 0,
	buy_num = 0
	}).

-define(CMD_GS2U_CommonBpScoreBuyRet,10819).
-record(pk_GS2U_CommonBpScoreBuyRet,{
	err_code = 0,
	id = 0,
	order = 0,
	buy_num = 0
	}).

-define(CMD_GuildWarGuild,62167).
-record(pk_GuildWarGuild,{
	guild_id = 0,
	server_id = 0,
	guild_name = "",
	head_icon = 0,
	battle_value = 0,
	member_count = 0,
	rank_local = 0,
	draw = 0,
	rank = 0,
	victory = 0,
	defeat = 0,
	score = 0,
	kill_num = 0
	}).

-define(CMD_GuildWarRound,61506).
-record(pk_GuildWarRound,{
	fight_id = 0,
	round_id = 0,
	group_id = 0,
	guild_ids = [],
	guild_camp = [],
	start_time = 0,
	end_time = 0,
	winner_id = 0,
	bet_list = []
	}).

-define(CMD_GuildWarBet,45011).
-record(pk_GuildWarBet,{
	fight_id = 0,
	winner_id = 0,
	state = 0
	}).

-define(CMD_GuildWarGuildRecord,49696).
-record(pk_GuildWarGuildRecord,{
	fight_id = 0,
	guild_id = 0,
	server_id = 0,
	guild_name = "",
	head_icon = 0,
	battle_value = 0,
	camp = 0,
	members = [],
	inspire = [],
	score = 0,
	kill_num = 0,
	kill_score = 0,
	ocp_times = 0,
	boss_num = 0
	}).

-define(CMD_GuildWarGuildSeason,30336).
-record(pk_GuildWarGuildSeason,{
	guild_id = 0,
	server_id = 0,
	guild_name = "",
	head_icon = 0,
	rank = 0
	}).

-define(CMD_GuildWarFightGuild,24484).
-record(pk_GuildWarFightGuild,{
	guild_id = 0,
	server_id = 0,
	guild_name = "",
	head_icon = 0,
	battle_value = 0,
	camp = 0,
	members = [],
	inspire = [],
	score = 0,
	kill_num = 0,
	kill_score = 0,
	ocp_times = 0,
	boss_num = 0,
	member_count = 0
	}).

-define(CMD_GuildWarFightPlayer,21512).
-record(pk_GuildWarFightPlayer,{
	player_id = 0,
	server_id = 0,
	guild_id = 0,
	player_name = "",
	player_sex = 0,
	score = 0,
	kill_num = 0,
	kill_score = 0,
	ocp_times = 0,
	boss_num = 0,
	rank = 0
	}).

-define(CMD_GuildWarFlag,29696).
-record(pk_GuildWarFlag,{
	index = 0,
	data_id = 0,
	type = 0,
	x = 0,
	y = 0,
	r = 0,
	uid = 0,
	owner_id = 0
	}).

-define(CMD_GuildWarBoss,8364).
-record(pk_GuildWarBoss,{
	uid = 0,
	data_id = 0,
	level = 0,
	state = 0
	}).

-define(CMD_GS2U_GuildWarAcStateSync,53069).
-record(pk_GS2U_GuildWarAcStateSync,{
	state = 0,
	start_time = 0,
	wait_time = 0,
	next_time = 0,
	end_time = 0,
	timeline = [],
	next_start = 0
	}).

-define(CMD_U2GS_GetGuildWarUI,28167).
-record(pk_U2GS_GetGuildWarUI,{
	}).

-define(CMD_GS2U_GetGuildWarUIRet,22815).
-record(pk_GS2U_GetGuildWarUIRet,{
	state = 0,
	start_time = 0,
	wait_time = 0,
	next_time = 0,
	end_time = 0,
	timeline = [],
	guild_list = [],
	round_list = [],
	bet_list = [],
	record_list = []
	}).

-define(CMD_U2GS_GuildWarRoundDrawReq,33349).
-record(pk_U2GS_GuildWarRoundDrawReq,{
	}).

-define(CMD_GS2U_GuildWarRoundDrawRet,18241).
-record(pk_GS2U_GuildWarRoundDrawRet,{
	err_code = 0,
	fight_id = 0
	}).

-define(CMD_GS2U_GuildWarRoundDrawSync,61020).
-record(pk_GS2U_GuildWarRoundDrawSync,{
	guild_id = 0,
	fight_id = 0
	}).

-define(CMD_U2GS_GuildWarRoundInfoReq,65031).
-record(pk_U2GS_GuildWarRoundInfoReq,{
	fight_list = []
	}).

-define(CMD_GS2U_GuildWarRoundInfoRet,49922).
-record(pk_GS2U_GuildWarRoundInfoRet,{
	round_list = []
	}).

-define(CMD_U2GS_GetGuildWarGuildRecordReq,63481).
-record(pk_U2GS_GetGuildWarGuildRecordReq,{
	key_list = []
	}).

-define(CMD_GS2U_GetGuildWarGuildRecordRet,1948).
-record(pk_GS2U_GetGuildWarGuildRecordRet,{
	record_list = []
	}).

-define(CMD_U2GS_GuildWarBetReq,3437).
-record(pk_U2GS_GuildWarBetReq,{
	fight_id = 0,
	winner_id = 0
	}).

-define(CMD_GS2U_GuildWarBetRet,27639).
-record(pk_GS2U_GuildWarBetRet,{
	err_code = 0,
	fight_id = 0,
	winner_id = 0
	}).

-define(CMD_U2GS_GuildWarBetAwardReq,38086).
-record(pk_U2GS_GuildWarBetAwardReq,{
	fight_id = 0
	}).

-define(CMD_GS2U_GuildWarBetAwardRet,27774).
-record(pk_GS2U_GuildWarBetAwardRet,{
	err_code = 0,
	fight_id = 0
	}).

-define(CMD_U2GS_GuildWarGuildSeasonInfoReq,20111).
-record(pk_U2GS_GuildWarGuildSeasonInfoReq,{
	}).

-define(CMD_GS2U_GuildWarGuildSeasonInfoRet,41844).
-record(pk_GS2U_GuildWarGuildSeasonInfoRet,{
	list = []
	}).

-define(CMD_U2GS_GuildWarEnterMap,43473).
-record(pk_U2GS_GuildWarEnterMap,{
	fight_id = 0
	}).

-define(CMD_GS2U_GuildWarLoadingInfo,50936).
-record(pk_GS2U_GuildWarLoadingInfo,{
	round = #pk_GuildWarRound{},
	guild_list = []
	}).

-define(CMD_U2GS_GuildWarInspireReq,50114).
-record(pk_U2GS_GuildWarInspireReq,{
	fight_id = 0,
	type = 0
	}).

-define(CMD_GS2U_GuildWarInspireRet,53853).
-record(pk_GS2U_GuildWarInspireRet,{
	err_code = 0,
	fight_id = 0,
	type = 0
	}).

-define(CMD_GS2U_GuildWarFightInfoSync,10622).
-record(pk_GS2U_GuildWarFightInfoSync,{
	fight_id = 0,
	round_id = 0,
	start_time = 0,
	boss_time = 0,
	end_time = 0,
	guild_list = [],
	player_list = [],
	flag_list = [],
	boss_list = []
	}).

-define(CMD_GS2U_GuildWarFightGuildUpdate,36690).
-record(pk_GS2U_GuildWarFightGuildUpdate,{
	guild_list = []
	}).

-define(CMD_GS2U_GuildWarFightFlagUpdate,8992).
-record(pk_GS2U_GuildWarFightFlagUpdate,{
	flag_list = []
	}).

-define(CMD_GS2U_GuildWarFightPlayerUpdate,58931).
-record(pk_GS2U_GuildWarFightPlayerUpdate,{
	player_list = []
	}).

-define(CMD_GS2U_GuildWarFightBossUpdate,25273).
-record(pk_GS2U_GuildWarFightBossUpdate,{
	boss_list = []
	}).

-define(CMD_GS2U_GuildWarFightSettle,8318).
-record(pk_GS2U_GuildWarFightSettle,{
	fight_id = 0,
	round_id = 0,
	start_time = 0,
	end_time = 0,
	winner_id = 0,
	guild_list = [],
	player_list = [],
	coin_list = [],
	item_list = [],
	eq_list = [],
	auction_coin_list = [],
	auction_item_list = [],
	auction_eq_list = []
	}).

-define(CMD_guide_notice_config,553).
-record(pk_guide_notice_config,{
	id = 0,
	pic = 0,
	type = 0,
	banner_text1 = "",
	image_text1 = [],
	banner_text2 = "",
	image_text2 = [],
	banner_text3 = "",
	image_text3 = []
	}).

-define(CMD_GS2U_guide_notice_sync,43799).
-record(pk_GS2U_guide_notice_sync,{
	icon = 0,
	notice_list = [],
	item_new = [],
	is_award = 0
	}).

-define(CMD_U2GS_guide_notice_award,43010).
-record(pk_U2GS_guide_notice_award,{
	}).

-define(CMD_GS2U_guide_notice_award_ret,16154).
-record(pk_GS2U_guide_notice_award_ret,{
	err = 0
	}).

-define(CMD_U2GS_ad_exchange_info,20256).
-record(pk_U2GS_ad_exchange_info,{
	}).

-define(CMD_GS2U_ad_exchange_info_ret,38275).
-record(pk_GS2U_ad_exchange_info_ret,{
	cd_time = 0,
	index_list = []
	}).

-define(CMD_U2GS_ad_exchange_get,52697).
-record(pk_U2GS_ad_exchange_get,{
	index = 0
	}).

-define(CMD_GS2U_ad_exchange_get_ret,53318).
-record(pk_GS2U_ad_exchange_get_ret,{
	index = 0,
	err_code = 0
	}).

-define(CMD_share_diamond_record,47164).
-record(pk_share_diamond_record,{
	rank = 0,
	name = "",
	sex = 0,
	server_id = 0,
	code = 0
	}).

-define(CMD_share_diamond_my_code,27826).
-record(pk_share_diamond_my_code,{
	time = 0,
	code = 0,
	rank = 0
	}).

-define(CMD_U2GS_share_diamond_get_code,62381).
-record(pk_U2GS_share_diamond_get_code,{
	}).

-define(CMD_GS2U_share_diamond_get_code_ret,24080).
-record(pk_GS2U_share_diamond_get_code_ret,{
	err_code = 0,
	code_list = []
	}).

-define(CMD_U2GS_share_diamond_record,42824).
-record(pk_U2GS_share_diamond_record,{
	time = 0
	}).

-define(CMD_GS2U_share_diamond_record_ret,58581).
-record(pk_GS2U_share_diamond_record_ret,{
	time = 0,
	err_code = 0,
	list = []
	}).

-define(CMD_U2GS_share_diamond_my_code,16844).
-record(pk_U2GS_share_diamond_my_code,{
	}).

-define(CMD_GS2U_share_diamond_my_code_ret,43629).
-record(pk_GS2U_share_diamond_my_code_ret,{
	err_code = 0,
	list = []
	}).

-define(CMD_U2GS_share_diamond_info,7176).
-record(pk_U2GS_share_diamond_info,{
	}).

-define(CMD_GS2U_share_diamond_info_ret,65331).
-record(pk_GS2U_share_diamond_info_ret,{
	active_value = 0,
	login_state = 0,
	kill_state = 0,
	is_settle = 0
	}).

-define(CMD_GS2U_exclusive_total_recharge_sync,12393).
-record(pk_GS2U_exclusive_total_recharge_sync,{
	recharge_num = 0,
	reset_time = 0,
	rule1 = 0,
	rule2 = 0,
	index_list = []
	}).

-define(CMD_U2GS_exclusive_total_recharge_award,9271).
-record(pk_U2GS_exclusive_total_recharge_award,{
	index = 0
	}).

-define(CMD_GS2U_exclusive_total_recharge_award_ret,34238).
-record(pk_GS2U_exclusive_total_recharge_award_ret,{
	index = 0,
	err_code = 0
	}).

-define(CMD_GS2U_exclusive_total_recharge_update,422).
-record(pk_GS2U_exclusive_total_recharge_update,{
	recharge_num = 0
	}).

-define(CMD_U2GS_PhoneBindAward,10896).
-record(pk_U2GS_PhoneBindAward,{
	}).

-define(CMD_GS2U_PhoneBindAwardRet,10455).
-record(pk_GS2U_PhoneBindAwardRet,{
	err_code = 0
	}).

-define(CMD_U2GS_PreferentialStorage,19192).
-record(pk_U2GS_PreferentialStorage,{
	}).

-define(CMD_GS2U_PreferentialStorageRet,7482).
-record(pk_GS2U_PreferentialStorageRet,{
	err_code = 0,
	pic = ""
	}).

-define(CMD_GS2U_CommonKillInfo,50046).
-record(pk_GS2U_CommonKillInfo,{
	target_id = 0,
	target_server_id = 0,
	target_name = "",
	target_sex = 0,
	attacker_id = 0,
	attacker_server_id = 0,
	attacker_name = "",
	attacker_sex = 0
	}).

-define(CMD_U2GS_vip_free_gift,59575).
-record(pk_U2GS_vip_free_gift,{
	lv = 0
	}).

-define(CMD_GS2U_vip_free_gift_ret,8456).
-record(pk_GS2U_vip_free_gift_ret,{
	lv = 0,
	err_code = 0
	}).

-define(CMD_U2GS_vip_up_gift,60336).
-record(pk_U2GS_vip_up_gift,{
	lv = 0
	}).

-define(CMD_GS2U_vip_up_gift_ret,62322).
-record(pk_GS2U_vip_up_gift_ret,{
	lv = 0,
	err_code = 0
	}).

-define(CMD_GS2U_pet_new,52882).
-record(pk_GS2U_pet_new,{
	list = []
	}).

-define(CMD_HeroNewsRecord,38154).
-record(pk_HeroNewsRecord,{
	type = 0,
	rank = 0,
	ui_info = #pk_playerModelUI{},
	worship_times = 0,
	is_worship = false
	}).

-define(CMD_U2GS_GetHeroNewsInfo,13924).
-record(pk_U2GS_GetHeroNewsInfo,{
	}).

-define(CMD_GS2U_GetHeroNewsInfoRet,20029).
-record(pk_GS2U_GetHeroNewsInfoRet,{
	list = [],
	is_award = false
	}).

-define(CMD_U2GS_GetHeroNewsAward,31962).
-record(pk_U2GS_GetHeroNewsAward,{
	}).

-define(CMD_GS2U_GetHeroNewsAwardRet,13543).
-record(pk_GS2U_GetHeroNewsAwardRet,{
	err_code = 0
	}).

-define(CMD_U2GS_WorshipTarget,22663).
-record(pk_U2GS_WorshipTarget,{
	type = 0,
	target_id = 0
	}).

-define(CMD_GS2U_WorshipTargetRet,20391).
-record(pk_GS2U_WorshipTargetRet,{
	err_code = 0,
	type = 0,
	target_id = 0
	}).

-define(CMD_GS2U_GetHeroNewsRed,10443).
-record(pk_GS2U_GetHeroNewsRed,{
	is_award = false,
	is_hide = false
	}).

-define(CMD_cart_item,41016).
-record(pk_cart_item,{
	shop_id = 0,
	shop_time = 0,
	num = 0,
	data = #pk_ShopData{}
	}).

-define(CMD_U2GS_shop_cart_info,23510).
-record(pk_U2GS_shop_cart_info,{
	}).

-define(CMD_GS2U_shop_cart_info,36160).
-record(pk_GS2U_shop_cart_info,{
	cart_list = []
	}).

-define(CMD_U2GS_shop_cart_add,62248).
-record(pk_U2GS_shop_cart_add,{
	shop_id = 0,
	data_id = 0,
	number = 0
	}).

-define(CMD_GS2U_shop_cart_add,54411).
-record(pk_GS2U_shop_cart_add,{
	shop_id = 0,
	data_id = 0,
	number = 0,
	err_code = 0
	}).

-define(CMD_U2GS_shop_cart_del,13470).
-record(pk_U2GS_shop_cart_del,{
	del_list = []
	}).

-define(CMD_GS2U_shop_cart_del,5633).
-record(pk_GS2U_shop_cart_del,{
	del_list = [],
	err_code = 0
	}).

-define(CMD_U2GS_shop_cart_clean,61822).
-record(pk_U2GS_shop_cart_clean,{
	}).

-define(CMD_GS2U_shop_cart_clean,62748).
-record(pk_GS2U_shop_cart_clean,{
	err_code = 0
	}).

-define(CMD_sacred_eq,52895).
-record(pk_sacred_eq,{
	uid = 0,
	cfg_id = 0,
	bind = 0,
	int_lv = 0,
	base_prop = [],
	rand_prop = [],
	beyond_prop = []
	}).

-define(CMD_sacred_eq_pos,12743).
-record(pk_sacred_eq_pos,{
	uid = 0,
	pos = 0,
	bless_prop = [],
	bless_prop_temp = []
	}).

-define(CMD_GS2U_SacredEqSync,34748).
-record(pk_GS2U_SacredEqSync,{
	masterlv = 0,
	sacred_eq_list = [],
	sacred_eq_pos_list = []
	}).

-define(CMD_GS2U_SacredEqUpdate,65363).
-record(pk_GS2U_SacredEqUpdate,{
	op = 0,
	sacred_eq_list = []
	}).

-define(CMD_GS2U_SacredEqPosUpdate,51172).
-record(pk_GS2U_SacredEqPosUpdate,{
	sacred_eq_pos_list = []
	}).

-define(CMD_U2GS_SacredEqOp,26949).
-record(pk_U2GS_SacredEqOp,{
	op = 0,
	uid = 0
	}).

-define(CMD_GS2U_SacredEqOpRet,37828).
-record(pk_GS2U_SacredEqOpRet,{
	err_code = 0,
	op = 0,
	uid = 0
	}).

-define(CMD_U2GS_SacredEqOneKeyOp,42547).
-record(pk_U2GS_SacredEqOneKeyOp,{
	op = 0,
	uids = []
	}).

-define(CMD_GS2U_SacredEqOneKeyOpRet,51423).
-record(pk_GS2U_SacredEqOneKeyOpRet,{
	err_code = 0,
	op = 0,
	uids = []
	}).

-define(CMD_U2GS_SacredEqLvUp,13173).
-record(pk_U2GS_SacredEqLvUp,{
	uid = 0,
	add_level = 0
	}).

-define(CMD_GS2U_SacredEqLvUpRet,12737).
-record(pk_GS2U_SacredEqLvUpRet,{
	err_code = 0,
	uid = 0,
	pos = 0,
	add_level = 0
	}).

-define(CMD_U2GS_SacredEqStageUp,28271).
-record(pk_U2GS_SacredEqStageUp,{
	uid = 0
	}).

-define(CMD_GS2U_SacredEqStageUpRet,46082).
-record(pk_GS2U_SacredEqStageUpRet,{
	err_code = 0,
	uid = 0,
	pos = 0
	}).

-define(CMD_U2GS_SacredEqCast,24148).
-record(pk_U2GS_SacredEqCast,{
	pos = 0,
	op = 0
	}).

-define(CMD_GS2U_SacredEqCastRet,49246).
-record(pk_GS2U_SacredEqCastRet,{
	err_code = 0,
	pos = 0,
	op = 0,
	sacred_eq_pos = #pk_sacred_eq_pos{}
	}).

-define(CMD_U2GS_SacredEqSuitAdd,41285).
-record(pk_U2GS_SacredEqSuitAdd,{
	newmasterlv = 0
	}).

-define(CMD_GS2U_SacredEqSuitAddRet,3752).
-record(pk_GS2U_SacredEqSuitAddRet,{
	err_code = 0,
	newmasterlv = 0
	}).

-define(CMD_U2GS_SacredEqFade,51353).
-record(pk_U2GS_SacredEqFade,{
	uids = []
	}).

-define(CMD_GS2U_SacredEqFadeRet,14739).
-record(pk_GS2U_SacredEqFadeRet,{
	err_code = 0
	}).

-define(CMD_LavaFightPlayer,52852).
-record(pk_LavaFightPlayer,{
	player_id = 0,
	server_id = 0,
	player_name = "",
	player_sex = 0,
	player_career = 0,
	dungeon_id = 0,
	max_star = 0,
	best_time = 0,
	rank = 0
	}).

-define(CMD_LavaFightDungeon,1536).
-record(pk_LavaFightDungeon,{
	dungeon_id = 0,
	max_star = 0,
	best_time = 0,
	free_time = 0
	}).

-define(CMD_GS2U_LavaFightAcStateSync,44113).
-record(pk_GS2U_LavaFightAcStateSync,{
	cluster = 0,
	state = 0,
	start_time = 0,
	end_time = 0
	}).

-define(CMD_U2GS_GetLavaFightUI,13507).
-record(pk_U2GS_GetLavaFightUI,{
	}).

-define(CMD_GS2U_GetLavaFightUIRet,14465).
-record(pk_GS2U_GetLavaFightUIRet,{
	cluster = 0,
	state = 0,
	start_time = 0,
	end_time = 0,
	player_info = #pk_LavaFightPlayer{},
	reduce_time = 0,
	buy_time = 0,
	max_time = 0,
	dungeon_list = []
	}).

-define(CMD_U2GS_GetLavaFightPlayer,21541).
-record(pk_U2GS_GetLavaFightPlayer,{
	}).

-define(CMD_GS2U_GetLavaFightPlayerRet,33105).
-record(pk_GS2U_GetLavaFightPlayerRet,{
	player_info = #pk_LavaFightPlayer{}
	}).

-define(CMD_U2GS_GetLavaFightRank,5430).
-record(pk_U2GS_GetLavaFightRank,{
	dungeon_id = 0
	}).

-define(CMD_GS2U_GetLavaFightRankRet,35984).
-record(pk_GS2U_GetLavaFightRankRet,{
	rank_list = []
	}).

-define(CMD_GS2U_LavaFightRankChange,39079).
-record(pk_GS2U_LavaFightRankChange,{
	dungeon_id = 0
	}).

-define(CMD_U2GS_EnterLavaDungeon,48443).
-record(pk_U2GS_EnterLavaDungeon,{
	dungeon_id = 0
	}).

-define(CMD_GS2U_DungeonLavaSettle,25663).
-record(pk_GS2U_DungeonLavaSettle,{
	dungeon_id = 0,
	is_win = 0,
	pass_time = 0,
	star = 0,
	is_best = 0,
	exp = 0,
	coin_list = [],
	item_list = [],
	eq_list = [],
	first_coin_list = [],
	first_item_list = [],
	first_eq_list = []
	}).

-define(CMD_U2GS_DungeonLavaMopUp,13745).
-record(pk_U2GS_DungeonLavaMopUp,{
	dungeon_id = 0
	}).

-define(CMD_GS2U_DungeonLavaMopUpRet,9185).
-record(pk_GS2U_DungeonLavaMopUpRet,{
	err_code = 0,
	dungeon_id = 0,
	exp = 0,
	coin_list = [],
	item_list = [],
	eq_list = []
	}).

-define(CMD_U2GS_wedding_info,55770).
-record(pk_U2GS_wedding_info,{
	}).

-define(CMD_GS2U_wedding_info,19419).
-record(pk_GS2U_wedding_info,{
	player_id = 0,
	time = 0,
	divorce_id = 0,
	divorce_time = 0,
	look_info = #pk_playerModelUI{}
	}).

-define(CMD_U2GS_wedding_pre_invite,19646).
-record(pk_U2GS_wedding_pre_invite,{
	player_id = 0
	}).

-define(CMD_GS2U_wedding_pre_invite,11836).
-record(pk_GS2U_wedding_pre_invite,{
	player_id = 0,
	err_code = 0
	}).

-define(CMD_GS2U_wedding_new_pre_invite,32832).
-record(pk_GS2U_wedding_new_pre_invite,{
	player_id = 0
	}).

-define(CMD_U2GS_wedding_pre_invite_reply,62076).
-record(pk_U2GS_wedding_pre_invite_reply,{
	player_id = 0,
	agree = false
	}).

-define(CMD_GS2U_wedding_pre_invite_reply,48574).
-record(pk_GS2U_wedding_pre_invite_reply,{
	player_id = 0,
	agree = false,
	err_code = 0,
	look_info = #pk_playerModelUI{}
	}).

-define(CMD_GS2U_wedding_pre_invite_result,39287).
-record(pk_GS2U_wedding_pre_invite_result,{
	player_id = 0,
	agree = false,
	look_info = #pk_playerModelUI{}
	}).

-define(CMD_U2GS_wedding_cancel_pre_invite,17451).
-record(pk_U2GS_wedding_cancel_pre_invite,{
	player_id = 0
	}).

-define(CMD_GS2U_wedding_cancel_pre_invite,9904).
-record(pk_GS2U_wedding_cancel_pre_invite,{
	player_id = 0,
	err_code = 0
	}).

-define(CMD_GS2U_wedding_cancel_pre_invite_notice,18148).
-record(pk_GS2U_wedding_cancel_pre_invite_notice,{
	player_id = 0
	}).

-define(CMD_U2GS_wedding_invite,15621).
-record(pk_U2GS_wedding_invite,{
	player_id = 0
	}).

-define(CMD_GS2U_wedding_invite,28272).
-record(pk_GS2U_wedding_invite,{
	player_id = 0,
	err_code = 0
	}).

-define(CMD_GS2U_wedding_new_invite,57822).
-record(pk_GS2U_wedding_new_invite,{
	player_id = 0
	}).

-define(CMD_U2GS_wedding_reply_invite,62797).
-record(pk_U2GS_wedding_reply_invite,{
	player_id = 0,
	agree = false
	}).

-define(CMD_GS2U_wedding_reply_invite,36139).
-record(pk_GS2U_wedding_reply_invite,{
	player_id = 0,
	agree = false,
	err_code = 0
	}).

-define(CMD_GS2U_wedding_invite_result,49812).
-record(pk_GS2U_wedding_invite_result,{
	player_id = 0,
	agree = false
	}).

-define(CMD_U2GS_wedding_cancel_invit,9057).
-record(pk_U2GS_wedding_cancel_invit,{
	}).

-define(CMD_GS2U_wedding_cancel_invit,47935).
-record(pk_GS2U_wedding_cancel_invit,{
	err_code = 0
	}).

-define(CMD_GS2U_wedding_cancel_invit_notice,27434).
-record(pk_GS2U_wedding_cancel_invit_notice,{
	player_id = 0
	}).

-define(CMD_GS2U_wedding_success,21986).
-record(pk_GS2U_wedding_success,{
	player_id = 0
	}).

-define(CMD_booking_role,61171).
-record(pk_booking_role,{
	player_id = 0,
	name = "",
	sex = 0
	}).

-define(CMD_wedding_booking,2885).
-record(pk_wedding_booking,{
	id = 0,
	type = 0,
	roles = []
	}).

-define(CMD_U2GS_wedding_get_booking,65502).
-record(pk_U2GS_wedding_get_booking,{
	}).

-define(CMD_GS2U_wedding_get_booking,43640).
-record(pk_GS2U_wedding_get_booking,{
	list = [],
	invitation_list = [],
	req_list = []
	}).

-define(CMD_U2GS_wedding_booking,11885).
-record(pk_U2GS_wedding_booking,{
	date = 0,
	index = 0,
	type = 0,
	id = 0
	}).

-define(CMD_GS2U_wedding_booking,12810).
-record(pk_GS2U_wedding_booking,{
	date = 0,
	index = 0,
	type = 0,
	err_code = 0
	}).

-define(CMD_request_role,7629).
-record(pk_request_role,{
	player_id = 0,
	name = "",
	vip = 0,
	sex = 0,
	level = 0,
	head_id = 0,
	frame = 0,
	offline_time = 0,
	guildName = "",
	battleValue = 0
	}).

-define(CMD_booking_info,26630).
-record(pk_booking_info,{
	id = 0,
	type = 0,
	invitation_num = 0,
	invitations = []
	}).

-define(CMD_U2GS_wedding_booking_info,1297).
-record(pk_U2GS_wedding_booking_info,{
	}).

-define(CMD_GS2U_wedding_booking_info,40173).
-record(pk_GS2U_wedding_booking_info,{
	list = []
	}).

-define(CMD_U2GS_wedding_use_invitation,7909).
-record(pk_U2GS_wedding_use_invitation,{
	id = 0,
	num = 0
	}).

-define(CMD_GS2U_wedding_use_invitationret,16517).
-record(pk_GS2U_wedding_use_invitationret,{
	id = 0,
	num = 0,
	error = 0
	}).

-define(CMD_U2GS_wedding_send_invitation,33286).
-record(pk_U2GS_wedding_send_invitation,{
	id = 0,
	id_list = []
	}).

-define(CMD_GS2U_wedding_send_invitation,42039).
-record(pk_GS2U_wedding_send_invitation,{
	id = 0,
	id_list = [],
	err_code = 0
	}).

-define(CMD_invite_role,48614).
-record(pk_invite_role,{
	player_id = 0,
	name = "",
	sex = 0,
	head_id = 0,
	frame = 0
	}).

-define(CMD_GS2U_wedding_rec_invitation,55100).
-record(pk_GS2U_wedding_rec_invitation,{
	id = 0,
	type = 0,
	roles = []
	}).

-define(CMD_U2GS_wedding_req_invitation,15018).
-record(pk_U2GS_wedding_req_invitation,{
	id = 0
	}).

-define(CMD_GS2U_wedding_req_invitation,52602).
-record(pk_GS2U_wedding_req_invitation,{
	id = 0,
	err_code = 0
	}).

-define(CMD_U2GS_wedding_req_invitation_list,51530).
-record(pk_U2GS_wedding_req_invitation_list,{
	id = 0
	}).

-define(CMD_GS2U_wedding_req_invitation_list,53333).
-record(pk_GS2U_wedding_req_invitation_list,{
	id = 0,
	req_list = []
	}).

-define(CMD_GS2U_wedding_req_invitation_notice,52534).
-record(pk_GS2U_wedding_req_invitation_notice,{
	id = 0,
	player_id = 0
	}).

-define(CMD_U2GS_wedding_req_refuse,27184).
-record(pk_U2GS_wedding_req_refuse,{
	id = 0,
	player_id = 0
	}).

-define(CMD_GS2U_wedding_req_refuse,19373).
-record(pk_GS2U_wedding_req_refuse,{
	id = 0,
	player_id = 0,
	err_code = 0
	}).

-define(CMD_U2GS_wedding_enter_map,28706).
-record(pk_U2GS_wedding_enter_map,{
	index = 0
	}).

-define(CMD_GS2U_wedding_enter_map,36290).
-record(pk_GS2U_wedding_enter_map,{
	index = 0,
	err_code = 0
	}).

-define(CMD_GS2U_wedding_map_schedule,35675).
-record(pk_GS2U_wedding_map_schedule,{
	id = 0,
	id1 = 0,
	id2 = 0,
	type = 0,
	state = 0,
	wave = 0,
	end_time = 0,
	collect_times = 0,
	gift_times = [],
	en_times = []
	}).

-define(CMD_U2GS_wedding_confirm,43416).
-record(pk_U2GS_wedding_confirm,{
	}).

-define(CMD_GS2U_wedding_confirm,44342).
-record(pk_GS2U_wedding_confirm,{
	err_code = 0
	}).

-define(CMD_GS2U_wedding_end_notice,13342).
-record(pk_GS2U_wedding_end_notice,{
	roles = []
	}).

-define(CMD_U2GS_wedding_map_gift,51295).
-record(pk_U2GS_wedding_map_gift,{
	gift_id = 0,
	num = 0
	}).

-define(CMD_GS2U_wedding_map_gift,16357).
-record(pk_GS2U_wedding_map_gift,{
	gift_id = 0,
	num = 0,
	err_code = 0
	}).

-define(CMD_GS2U_wedding_broadcast_gift,39223).
-record(pk_GS2U_wedding_broadcast_gift,{
	name = "",
	sex = 0,
	gift_id = 0,
	num = 0
	}).

-define(CMD_U2GS_wedding_send_envelope,27164).
-record(pk_U2GS_wedding_send_envelope,{
	data_id = 0
	}).

-define(CMD_GS2U_wedding_send_envelope,34538).
-record(pk_GS2U_wedding_send_envelope,{
	data_id = 0,
	err_code = 0
	}).

-define(CMD_U2GS_wedding_get_envelope,38639).
-record(pk_U2GS_wedding_get_envelope,{
	en_id = 0
	}).

-define(CMD_GS2U_wedding_get_envelope,11981).
-record(pk_GS2U_wedding_get_envelope,{
	en_id = 0,
	type = 0,
	num = 0,
	err_code = 0
	}).

-define(CMD_GS2U_wedding_new_envelope,61103).
-record(pk_GS2U_wedding_new_envelope,{
	en_id = 0,
	data_id = 0
	}).

-define(CMD_GS2U_wedding_envelope_info,60858).
-record(pk_GS2U_wedding_envelope_info,{
	en_list = []
	}).

-define(CMD_U2GS_wedding_envelope_money,16427).
-record(pk_U2GS_wedding_envelope_money,{
	en_list = []
	}).

-define(CMD_GS2U_wedding_envelope_money,54011).
-record(pk_GS2U_wedding_envelope_money,{
	en_list = []
	}).

-define(CMD_U2GS_wedding_envelope_1key_open,29558).
-record(pk_U2GS_wedding_envelope_1key_open,{
	en_list = []
	}).

-define(CMD_GS2U_wedding_envelope_1key_open,39742).
-record(pk_GS2U_wedding_envelope_1key_open,{
	en_list = []
	}).

-define(CMD_U2GS_wedding_divorce_req,28374).
-record(pk_U2GS_wedding_divorce_req,{
	type = 0
	}).

-define(CMD_GS2U_wedding_divorce_req,6512).
-record(pk_GS2U_wedding_divorce_req,{
	type = 0,
	err_code = 0
	}).

-define(CMD_GS2U_wedding_divorce_rec,18149).
-record(pk_GS2U_wedding_divorce_rec,{
	}).

-define(CMD_U2GS_wedding_divorce_reply,42156).
-record(pk_U2GS_wedding_divorce_reply,{
	agree = false
	}).

-define(CMD_GS2U_wedding_divorce_reply,49529).
-record(pk_GS2U_wedding_divorce_reply,{
	agree = false,
	err_code = 0
	}).

-define(CMD_GS2U_wedding_divorce_notice,64092).
-record(pk_GS2U_wedding_divorce_notice,{
	}).

-define(CMD_GS2U_wedding_divorce_reply_notice,43298).
-record(pk_GS2U_wedding_divorce_reply_notice,{
	player_id = 0,
	agree = false
	}).

-define(CMD_GS2U_collect_times_sync,64063).
-record(pk_GS2U_collect_times_sync,{
	collectionID = 0,
	times = 0
	}).

-define(CMD_WeddingCard,569).
-record(pk_WeddingCard,{
	player_id = 0,
	couple_id = 0,
	buy_time = 0,
	award_list = []
	}).

-define(CMD_U2GS_WeddingCardInfoReq,32721).
-record(pk_U2GS_WeddingCardInfoReq,{
	}).

-define(CMD_GS2U_WeddingCardInfoRet,36462).
-record(pk_GS2U_WeddingCardInfoRet,{
	list = []
	}).

-define(CMD_GS2U_WeddingCardInfoSync,37169).
-record(pk_GS2U_WeddingCardInfoSync,{
	list = []
	}).

-define(CMD_U2GS_WeddingCardAwardReq,25392).
-record(pk_U2GS_WeddingCardAwardReq,{
	}).

-define(CMD_GS2U_WeddingCardAwardRet,15080).
-record(pk_GS2U_WeddingCardAwardRet,{
	err_code = 0,
	award_day = 0
	}).

-define(CMD_team_player,1085).
-record(pk_team_player,{
	player_id = 0,
	guild_id = 0,
	sex = 0,
	head_id = 0,
	frame_id = 0,
	level = 0,
	career = 0,
	name = "",
	battle_value = 0
	}).

-define(CMD_team_list,14947).
-record(pk_team_list,{
	team_id = 0,
	team_type = 0,
	leader_info = #pk_team_player{},
	member_list = []
	}).

-define(CMD_team_invite_player,31496).
-record(pk_team_invite_player,{
	player = #pk_team_player{},
	is_team = 0
	}).

-define(CMD_team_invite_team,13352).
-record(pk_team_invite_team,{
	player = #pk_team_player{},
	team_id = 0,
	team_type = 0
	}).

-define(CMD_team_member,62051).
-record(pk_team_member,{
	player = #pk_team_player{},
	is_leader = 0,
	is_online = 0,
	mapDataID = 0,
	role_id = 0,
	is_mirror = 0
	}).

-define(CMD_U2GS_team_list,38370).
-record(pk_U2GS_team_list,{
	team_type = 0,
	pages = 0
	}).

-define(CMD_GS2U_team_list_ret,52127).
-record(pk_GS2U_team_list_ret,{
	list = [],
	is_matching = 0,
	remain_num = 0
	}).

-define(CMD_U2GS_my_team_info,26353).
-record(pk_U2GS_my_team_info,{
	}).

-define(CMD_GS2U_my_team_info_ret,13874).
-record(pk_GS2U_my_team_info_ret,{
	list = [],
	is_matching = 0,
	is_auto_agree = 0
	}).

-define(CMD_U2GS_team_quick_match,57655).
-record(pk_U2GS_team_quick_match,{
	team_type = 0,
	is_matching = 0
	}).

-define(CMD_GS2U_team_quick_match_ret,62194).
-record(pk_GS2U_team_quick_match_ret,{
	err_code = 0,
	team_type = 0,
	is_matching = 0
	}).

-define(CMD_U2GS_team_join_apply,61350).
-record(pk_U2GS_team_join_apply,{
	team_id = 0
	}).

-define(CMD_GS2U_team_join_apply_ret,46272).
-record(pk_GS2U_team_join_apply_ret,{
	team_id = 0,
	err_code = 0
	}).

-define(CMD_U2GS_team_invite_list,37970).
-record(pk_U2GS_team_invite_list,{
	type = 0
	}).

-define(CMD_GS2U_team_invite_list_ret,64240).
-record(pk_GS2U_team_invite_list_ret,{
	friend_list = [],
	guild_list = [],
	nearby_list = [],
	assist_list = []
	}).

-define(CMD_U2GS_team_apply_list,31931).
-record(pk_U2GS_team_apply_list,{
	}).

-define(CMD_GS2U_team_apply_list_ret,12815).
-record(pk_GS2U_team_apply_list_ret,{
	list = []
	}).

-define(CMD_U2GS_team_invite_team_list,37784).
-record(pk_U2GS_team_invite_team_list,{
	}).

-define(CMD_GS2U_team_invite_team_list_ret,56503).
-record(pk_GS2U_team_invite_team_list_ret,{
	list = []
	}).

-define(CMD_U2GS_team_invite_player,8919).
-record(pk_U2GS_team_invite_player,{
	player_list = []
	}).

-define(CMD_GS2U_team_invite_player_ret,29450).
-record(pk_GS2U_team_invite_player_ret,{
	player_list = [],
	err_code = 0
	}).

-define(CMD_GS2U_team_invite_player_recv,15408).
-record(pk_GS2U_team_invite_player_recv,{
	from_player = #pk_team_player{},
	team_id = 0,
	team_type = 0
	}).

-define(CMD_U2GS_team_invite_player_repl,7641).
-record(pk_U2GS_team_invite_player_repl,{
	team_id = 0,
	type = 0
	}).

-define(CMD_GS2U_team_player_apply_recv,23615).
-record(pk_GS2U_team_player_apply_recv,{
	from_player = #pk_team_player{}
	}).

-define(CMD_U2GS_team_player_apply_repl,52554).
-record(pk_U2GS_team_player_apply_repl,{
	player_id = 0,
	type = 0,
	is_black = 0
	}).

-define(CMD_U2GS_team_op,22200).
-record(pk_U2GS_team_op,{
	type = 0,
	param = 0
	}).

-define(CMD_GS2U_team_op_ret,18503).
-record(pk_GS2U_team_op_ret,{
	type = 0,
	param = 0,
	err_code = 0
	}).

-define(CMD_GS2U_team_player_apply_leader_recv,51058).
-record(pk_GS2U_team_player_apply_leader_recv,{
	from_player = #pk_team_player{}
	}).

-define(CMD_U2GS_team_player_apply_leader_repl,9509).
-record(pk_U2GS_team_player_apply_leader_repl,{
	player_id = 0,
	type = 0
	}).

-define(CMD_GS2U_current_team_info,776).
-record(pk_GS2U_current_team_info,{
	team_id = 0,
	team_type = 0,
	member_list = []
	}).

-define(CMD_GS2U_team_member_update,19005).
-record(pk_GS2U_team_member_update,{
	team_id = 0,
	member = #pk_team_member{}
	}).

-define(CMD_GS2U_team_event_sync,55254).
-record(pk_GS2U_team_event_sync,{
	type = 0,
	player_id = 0,
	name = "",
	sex = 0
	}).

-define(CMD_GS2U_team_convene_sync,13).
-record(pk_GS2U_team_convene_sync,{
	name = "",
	sex = 0,
	mapDataID = 0,
	pos_x = 0,
	pos_y = 0
	}).

-define(CMD_U2GS_team_leader_locate,13153).
-record(pk_U2GS_team_leader_locate,{
	}).

-define(CMD_GS2U_team_leader_locate_ret,33940).
-record(pk_GS2U_team_leader_locate_ret,{
	mapDataID = 0,
	pos_x = 0,
	pos_y = 0
	}).

-define(CMD_GS2U_intimacy_change_sync,12414).
-record(pk_GS2U_intimacy_change_sync,{
	player_id = 0,
	name = "",
	sex = 0,
	add_value = 0
	}).

-define(CMD_U2GS_team_invite_mirror_player,56441).
-record(pk_U2GS_team_invite_mirror_player,{
	player_list = []
	}).

-define(CMD_GS2U_team_invite_mirror_player_ret,46271).
-record(pk_GS2U_team_invite_mirror_player_ret,{
	player_list = [],
	err_code = 0
	}).

-define(CMD_GS2U_team_enter_map_confirm,60483).
-record(pk_GS2U_team_enter_map_confirm,{
	}).

-define(CMD_GS2U_team_enter_map_confirm_sync,11519).
-record(pk_GS2U_team_enter_map_confirm_sync,{
	player_id = 0,
	is_agree = 0,
	merge_times = 0
	}).

-define(CMD_GS2U_team_warning_notice,8239).
-record(pk_GS2U_team_warning_notice,{
	player_id_list = [],
	reason = 0
	}).

-define(CMD_GS2U_team_member_merge_times_sync,26774).
-record(pk_GS2U_team_member_merge_times_sync,{
	player_id = 0,
	times = 0
	}).

-define(CMD_U2GS_team_focus_fire,60749).
-record(pk_U2GS_team_focus_fire,{
	uid = 0
	}).

-define(CMD_GS2U_team_focus_fire_ret,22191).
-record(pk_GS2U_team_focus_fire_ret,{
	uid = 0
	}).

-define(CMD_GS2U_diamond_first_recharge_ret,22578).
-record(pk_GS2U_diamond_first_recharge_ret,{
	err_code = 0,
	id = 0,
	is_reset = 0
	}).

-define(CMD_U2GS_diamond_first_recharge_reset,14541).
-record(pk_U2GS_diamond_first_recharge_reset,{
	id = 0
	}).

-define(CMD_GS2U_diamond_first_recharge_reset_ret,39667).
-record(pk_GS2U_diamond_first_recharge_reset_ret,{
	id = 0,
	err_code = 0
	}).

-define(CMD_blz_forest_boss,7835).
-record(pk_blz_forest_boss,{
	index = 0,
	boss_id = 0,
	level = 0,
	timestamp = 0
	}).

-define(CMD_GS2U_BlzForestInfoSync,953).
-record(pk_GS2U_BlzForestInfoSync,{
	order = 0,
	start_time = 0,
	end_time = 0
	}).

-define(CMD_U2GS_BlzForestEnterMap,33922).
-record(pk_U2GS_BlzForestEnterMap,{
	}).

-define(CMD_GS2U_GetBlzForestMapInfoSync,44057).
-record(pk_GS2U_GetBlzForestMapInfoSync,{
	fatigued_value = 0
	}).

-define(CMD_GS2U_BlzForestBossListUpdate,50461).
-record(pk_GS2U_BlzForestBossListUpdate,{
	boss_list = []
	}).

-define(CMD_U2GS_BlzForestEnterNextLayer,59499).
-record(pk_U2GS_BlzForestEnterNextLayer,{
	}).

-define(CMD_GS2U_BlzForestSettleAccounts,22485).
-record(pk_GS2U_BlzForestSettleAccounts,{
	exp = 0,
	coin_list = [],
	item_list = [],
	eq_list = []
	}).

-define(CMD_U2GS_BlzForestFlyNpc,34565).
-record(pk_U2GS_BlzForestFlyNpc,{
	}).

-define(CMD_GS2U_BlzForestFlyNpcRet,50710).
-record(pk_GS2U_BlzForestFlyNpcRet,{
	err_code = 0
	}).

-define(CMD_U2GS_BlzForestDropList,7303).
-record(pk_U2GS_BlzForestDropList,{
	}).

-define(CMD_GS2U_BlzForestDropListRet,46228).
-record(pk_GS2U_BlzForestDropListRet,{
	drop_list = []
	}).

-define(CMD_GS2U_ItemNumOverflow,57972).
-record(pk_GS2U_ItemNumOverflow,{
	cfg_id = 0
	}).

-define(CMD_U2GS_BlzForestMyLayerInfo,21015).
-record(pk_U2GS_BlzForestMyLayerInfo,{
	}).

-define(CMD_GS2U_BlzForestMyLayerInfoRet,31763).
-record(pk_GS2U_BlzForestMyLayerInfoRet,{
	info_list = []
	}).

-define(CMD_MainStatue,32604).
-record(pk_MainStatue,{
	func_id = 0,
	rank = 0,
	ui_info = #pk_playerModelUI{}
	}).

-define(CMD_GS2U_GetMainStatue,17546).
-record(pk_GS2U_GetMainStatue,{
	func_id = 0
	}).

-define(CMD_GS2U_GetMainStatueRet,28276).
-record(pk_GS2U_GetMainStatueRet,{
	func_id = 0,
	statue_list = []
	}).

-define(CMD_U2GS_PetPosInlay,61970).
-record(pk_U2GS_PetPosInlay,{
	pos = 0,
	uid_list = []
	}).

-define(CMD_GS2U_PetPosInlayRet,56618).
-record(pk_GS2U_PetPosInlayRet,{
	pos = 0,
	uid_list = [],
	err_code = 0
	}).

-define(CMD_pet_illusion,27905).
-record(pk_pet_illusion,{
	cfg_id = 0,
	pet_cfg_id = 0,
	refine_lv = 0,
	type = 0,
	show_type = false,
	expire_time = 0
	}).

-define(CMD_U2GS_pet_illusion_info,32675).
-record(pk_U2GS_pet_illusion_info,{
	}).

-define(CMD_GS2U_pet_illusion_infoRet,56289).
-record(pk_GS2U_pet_illusion_infoRet,{
	list = [],
	lv = 0,
	exp = 0
	}).

-define(CMD_GS2U_pet_illusion_updata_ret,61668).
-record(pk_GS2U_pet_illusion_updata_ret,{
	list = []
	}).

-define(CMD_U2GS_pet_illusion_active,6727).
-record(pk_U2GS_pet_illusion_active,{
	illusion_id = 0,
	cost = #pk_key_value{}
	}).

-define(CMD_GS2U_pet_illusion_activeRet,9781).
-record(pk_GS2U_pet_illusion_activeRet,{
	illusion_id = 0,
	cost = #pk_key_value{},
	type = 0,
	err_code = 0
	}).

-define(CMD_U2GS_pet_illusionEquip,23449).
-record(pk_U2GS_pet_illusionEquip,{
	illusion_id = 0,
	op = 0
	}).

-define(CMD_GS2U_pet_illusionEquipRet,17472).
-record(pk_GS2U_pet_illusionEquipRet,{
	illusion_id = 0,
	op = 0,
	err_code = 0
	}).

-define(CMD_U2GS_pet_illusionRefine,9040).
-record(pk_U2GS_pet_illusionRefine,{
	illusion_id = 0
	}).

-define(CMD_GS2U_pet_illusionRefineRet,30150).
-record(pk_GS2U_pet_illusionRefineRet,{
	illusion_id = 0,
	err_code = 0
	}).

-define(CMD_U2GS_pet_illusionCollectAddLv,41262).
-record(pk_U2GS_pet_illusionCollectAddLv,{
	costlist = []
	}).

-define(CMD_GS2U_pet_illusionCollectAddLvRet,27696).
-record(pk_GS2U_pet_illusionCollectAddLvRet,{
	lv = 0,
	exp = 0,
	err_code = 0
	}).

-define(CMD_recharge_history,42692).
-record(pk_recharge_history,{
	item_code = "",
	amount = 0,
	time = 0
	}).

-define(CMD_U2GS_RechargeHistory,43942).
-record(pk_U2GS_RechargeHistory,{
	shift = 0
	}).

-define(CMD_GS2U_RechargeHistoryRet,8286).
-record(pk_GS2U_RechargeHistoryRet,{
	shift = 0,
	history_list = [],
	remain_num = 0
	}).

-define(CMD_GS2U_DungeonTeamEqSettleAccounts,21469).
-record(pk_GS2U_DungeonTeamEqSettleAccounts,{
	dungeonType = 0,
	dungeonID = 0,
	isWin = 0,
	quality = 0,
	havetime = 0,
	intimacy = 0,
	name_list = [],
	exp = 0,
	itemList = [],
	coinList = [],
	eq_list = [],
	settleType = 0,
	assistant = 0
	}).

-define(CMD_TeamEqPlayer,8806).
-record(pk_TeamEqPlayer,{
	player_id = 0,
	player_name = "",
	player_sex = 0
	}).

-define(CMD_TeamEqRecord,26235).
-record(pk_TeamEqRecord,{
	record_id = 0,
	dungeon_id = 0,
	members = [],
	server_id = 0,
	best_time = 0,
	rank = 0
	}).

-define(CMD_U2GS_GetTeamEqTop,63817).
-record(pk_U2GS_GetTeamEqTop,{
	dungeon_id = 0,
	shift = 0
	}).

-define(CMD_GS2U_GetTeamEqTopRet,12387).
-record(pk_GS2U_GetTeamEqTopRet,{
	dungeon_id = 0,
	shift = 0,
	remian = 0,
	my_rank = #pk_TeamEqRecord{},
	top_list = []
	}).

-define(CMD_DungeonNumber,20869).
-record(pk_DungeonNumber,{
	group_id = 0,
	max_number = 0,
	used_number = 0,
	buy_number = 0
	}).

-define(CMD_GS2U_DungeonNumberSync,46015).
-record(pk_GS2U_DungeonNumberSync,{
	list = []
	}).

-define(CMD_DungeonFree,59918).
-record(pk_DungeonFree,{
	dungeon_id = 0,
	free_number = 0
	}).

-define(CMD_GS2U_DungeonFreeSync,63944).
-record(pk_GS2U_DungeonFreeSync,{
	list = []
	}).

-define(CMD_entityDraw_record,18856).
-record(pk_entityDraw_record,{
	rank = 0,
	name = "",
	sex = 0,
	server_id = 0,
	code = 0
	}).

-define(CMD_entityDraw_my_code,48476).
-record(pk_entityDraw_my_code,{
	round = 0,
	code = 0,
	is_draw = false,
	rank = 0
	}).

-define(CMD_U2GS_entityDraw_get_code,37000).
-record(pk_U2GS_entityDraw_get_code,{
	}).

-define(CMD_GS2U_entityDraw_get_code_ret,52635).
-record(pk_GS2U_entityDraw_get_code_ret,{
	err_code = 0,
	code_list = []
	}).

-define(CMD_U2GS_entityDraw_record,16111).
-record(pk_U2GS_entityDraw_record,{
	round = 0
	}).

-define(CMD_GS2U_entityDraw_record_ret,65197).
-record(pk_GS2U_entityDraw_record_ret,{
	round = 0,
	err_code = 0,
	list = []
	}).

-define(CMD_U2GS_entityDraw_my_code,25898).
-record(pk_U2GS_entityDraw_my_code,{
	}).

-define(CMD_GS2U_entityDraw_my_code_ret,41577).
-record(pk_GS2U_entityDraw_my_code_ret,{
	err_code = 0,
	list = []
	}).

-define(CMD_U2GS_entityDraw_info,64585).
-record(pk_U2GS_entityDraw_info,{
	}).

-define(CMD_GS2U_entityDraw_info_ret,46041).
-record(pk_GS2U_entityDraw_info_ret,{
	round = 0,
	active_progress = 0,
	login_progress = 0,
	gold_progress = 0,
	active_exchange_count = 0,
	login_exchange_count = 0,
	gold_exchange_count = 0,
	is_settle = 0
	}).

-define(CMD_new_cloud_lucky_award_record,64433).
-record(pk_new_cloud_lucky_award_record,{
	name = "",
	sex = 0,
	time = 0,
	item_list = [],
	currency_list = [],
	eq_list = []
	}).

-define(CMD_GS2U_drawn_new_cloud_lucky_wheel_ret,5023).
-record(pk_GS2U_drawn_new_cloud_lucky_wheel_ret,{
	id = 0,
	err = 0,
	times = 0,
	itemCount = 0,
	itemSp_list = [],
	itemCom_list = [],
	lucky_num = [],
	total_times = 0,
	changeIntegral = 0
	}).

-define(CMD_GS2U_new_cloud_lucky_wheel_info_ret,38905).
-record(pk_GS2U_new_cloud_lucky_wheel_info_ret,{
	id = 0,
	err = 0,
	is_settle = 0,
	round_end_time = 0,
	wheel_base_info = #pk_wheelBaseInfo{},
	drawn_times = 0,
	total_drawn_times = 0,
	itemCount = 0,
	single_limit = 0,
	full_limit = 0,
	display_pro = [],
	open_time = 0,
	close_time = 0,
	purchase_time = 0,
	award_item = [],
	model = [],
	cond_para = [],
	award_para_new1 = [],
	total_limit = 0,
	total_cond_para = [],
	award_para_new2 = [],
	lucky_num = [],
	winner_name = "",
	winner_number = 0,
	stage_award_mask = 0,
	convPoint = 0,
	changeInfo_list = [],
	changeIntegral = 0,
	change_list = []
	}).

-define(CMD_U2GS_new_cloud_lucky_stage_award,15441).
-record(pk_U2GS_new_cloud_lucky_stage_award,{
	id = 0,
	type = 0
	}).

-define(CMD_GS2U_new_cloud_lucky_stage_award_ret,27145).
-record(pk_GS2U_new_cloud_lucky_stage_award_ret,{
	id = 0,
	err_code = 0,
	type = 0,
	stage = []
	}).

-define(CMD_U2GS_new_cloud_lucky_award_record,58279).
-record(pk_U2GS_new_cloud_lucky_award_record,{
	id = 0
	}).

-define(CMD_GS2U_new_cloud_lucky_award_record_ret,13081).
-record(pk_GS2U_new_cloud_lucky_award_record_ret,{
	id = 0,
	list = []
	}).

-define(CMD_GS2U_new_cloud_lucky_settle_sync,924).
-record(pk_GS2U_new_cloud_lucky_settle_sync,{
	id = 0,
	total_drawn_times = 0,
	winner_name = "",
	winner_number = 0
	}).

-define(CMD_skinDraw_record,36430).
-record(pk_skinDraw_record,{
	rank = 0,
	name = "",
	sex = 0,
	server_id = 0,
	code = 0
	}).

-define(CMD_skinDraw_my_code,20184).
-record(pk_skinDraw_my_code,{
	round = 0,
	code = 0,
	is_draw = false,
	rank = 0
	}).

-define(CMD_U2GS_skinDraw_get_code,55743).
-record(pk_U2GS_skinDraw_get_code,{
	}).

-define(CMD_GS2U_skinDraw_get_code_ret,23908).
-record(pk_GS2U_skinDraw_get_code_ret,{
	err_code = 0,
	code_list = []
	}).

-define(CMD_U2GS_skinDraw_record,45430).
-record(pk_U2GS_skinDraw_record,{
	round = 0
	}).

-define(CMD_GS2U_skinDraw_record_ret,39405).
-record(pk_GS2U_skinDraw_record_ret,{
	round = 0,
	err_code = 0,
	list = []
	}).

-define(CMD_U2GS_skinDraw_my_code,43284).
-record(pk_U2GS_skinDraw_my_code,{
	}).

-define(CMD_GS2U_skinDraw_my_code_ret,43545).
-record(pk_GS2U_skinDraw_my_code_ret,{
	err_code = 0,
	list = []
	}).

-define(CMD_U2GS_skinDraw_info,56448).
-record(pk_U2GS_skinDraw_info,{
	}).

-define(CMD_GS2U_skinDraw_info_ret,28693).
-record(pk_GS2U_skinDraw_info_ret,{
	round = 0,
	active_progress = 0,
	login_progress = 0,
	gold_progress = 0,
	active_exchange_count = 0,
	login_exchange_count = 0,
	gold_exchange_count = 0,
	is_settle = 0
	}).

-define(CMD_GS2U_cluster_max_world_lv,12969).
-record(pk_GS2U_cluster_max_world_lv,{
	world_lv = 0
	}).

-endif. %%netmsgRecords
