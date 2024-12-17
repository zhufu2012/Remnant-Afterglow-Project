%%%-------------------------------------------------------------------
%%% @author mozhenxian
%%% @copyright (C) 2022, <double_game>
%%% @doc
%%% 宠物战斗相关
%%% @end
%%% Created : 12. 7月 2022 19:59
%%%-------------------------------------------------------------------
-module(pet_battle).
-author("mozhenxian").

-include("record.hrl").
-include("logger.hrl").
-include("item.hrl").
-include("error.hrl").
-include("db_table.hrl").
-include("reason.hrl").
-include("variable.hrl").
-include("attribute.hrl").
-include("skill_new.hrl").
-include("attainment.hrl").
-include("cfg_petBase.hrl").
-include("netmsgRecords.hrl").
-include("cfg_petGradeUp.hrl").
-include("cfg_petWash.hrl").
-include("cfg_petStar.hrl").
-include("cfg_petEquipNew.hrl").
-include("util.hrl").
-include("cfg_petBreak.hrl").
-include("cfg_skillBase.hrl").
-include("cfg_skillCorr.hrl").
-include("top_chart.hrl").
-include("carnival.hrl").
-include("gameMap.hrl").
-include("pet_new.hrl").

-define(PET_INDEX_START, 20000).

%% API
-export([
	get_all_pets/1
	, make_map_pets/2
	, get_equip_pet/0
	, to_pk_map_pet/2
	, get_out_fight_pet_id_list/0
	, get_available_pet_skill_list/1
	, get_available_pet_skill_and_attr/3
	, get_available_pet_skill_and_attr/5
	, get_available_pet_attr/3
	, get_player_add_attr/1
	, get_out_and_assist_pet_id_list/1
	, get_player_add_fight/0
	, calc_player_add_fight/0
	, cal_pet_score/1
	, sync_to_top/1
	, sync_to_top/2
	, get_assist_pet_uid_list/1
	, cal_pet_score/0
	, get_pet_attr/4
	, send_all_pet_attr/0
	, send_pet_attr/2
	, set_send_attr_flag/1
	, get_send_attr_flag/0
	, on_player_upgrade/0
	, get_out_fight_pets/1, cal_single_pet_score/1, cal_single_pet_score/2, calc_pet_wash_aptitude/1
	, calc_qual/3]).
-export([get_player_pet_attr/1, get_pet_attr_pure/7, get_show_attr/1, get_available_aid_pet_attr/3, get_available_aid_pet_attr/4]).

%% 用于宠物使用的可用主动技能
get_available_pet_skill_list(PlayerId) ->
	ServerSealSkill = server_seal_player:get_pet_skill(PlayerId),
	PetSacredSkill = pet_sacred_eq:get_pet_skill_list(PlayerId),
	PetAidUidPosList = get_aid_fight_pet_id_and_pos_list(PlayerId),
	PetUidPosList = get_out_fight_pet_id_and_pos_list(PlayerId),
	BeenLinkUidList = [{BLinkUid, 0} || BLinkUid <- pet_base:get_been_link_uid_list(PlayerId, [PetUid || {PetUid, _FightPos} <- PetUidPosList])],
	F = fun({PetUid, FightPos}) ->
		case FightPos > 0 of
			?TRUE ->
				SkillList = get_pet_skill(PetUid, PlayerId),
				AddSkillList = pet_illusion:get_pet_skill(PlayerId, PetUid),
				AidSkillList = pet_pos:get_aid_skill(PlayerId, FightPos, PetAidUidPosList),
				PlayerSkillList = skill_player:make_player_skill(SkillList ++ ServerSealSkill ++ PetSacredSkill ++ AddSkillList ++ AidSkillList),
				{PetUid, skill_player:make_skill_fix_list(PlayerSkillList)};
			?FALSE ->
				{PetUid, []}
		end
		end,
	lists:map(F, BeenLinkUidList ++ PetUidPosList).

get_available_pet_skill_and_attr(PlayerId, MapDataID, PlayerAttrList) ->
	get_available_pet_skill_and_attr(PlayerId, MapDataID, PlayerAttrList, get_out_fight_pet_id_and_pos_list(PlayerId), get_aid_fight_pet_id_and_pos_list(PlayerId)).
get_available_pet_skill_and_attr(PlayerId, MapDataID, PlayerAttrList, PetUidPosList, PetAidUidPosList) ->
	MapAi = playerCopyMap:get_map_ai_by_map_data_id(MapDataID),
	ServerSealSkill = server_seal_player:get_pet_skill(PlayerId),
	PetSacredSkill = pet_sacred_eq:get_pet_skill_list(PlayerId),
	IsExpeditionMap = lists:member(MapAi, ?ExpeditionMapAIList),
	BeenLinkUidList = [{BLinkUid, 0} || BLinkUid <- pet_base:get_been_link_uid_list(PlayerId, [PetUid || {PetUid, _FightPos} <- PetUidPosList])],
	F = fun({PetUid, FightPos}) ->
		PlayerSkillList = case FightPos > 0 of
							  ?TRUE ->
								  SkillList = get_pet_skill(PetUid, PlayerId),
								  AddSkillList = pet_illusion:get_pet_skill(PlayerId, PetUid),
								  AidSkillList = pet_pos:get_aid_skill(PlayerId, FightPos, PetAidUidPosList),
								  skill_player:make_player_skill(SkillList ++ ServerSealSkill ++ PetSacredSkill ++ AddSkillList ++ AidSkillList);
							  ?FALSE ->
								  []
						  end,
		NewPetAttr = if
						 IsExpeditionMap ->
							 ChangeAttr = df:getGlobalSetupValueList(expeditionPetArri, []),
							 lists:map(fun({K, V}) ->
								 case lists:keyfind(K, 1, ChangeAttr) of
									 ?FALSE -> {K, V};
									 {_, W} -> {K, trunc(V * W / 10000)}
								 end
									   end, PlayerAttrList);
						 true ->
							 PlayerPetAttr = get_player_pet_attr(PlayerAttrList),
							 PetAttr1 = get_pet_attr(PlayerId, PetUid, PlayerPetAttr, ?FALSE),
							 case MapAi of
								 ?MapAI_CareerTower_Main ->
									 common:listValueMerge([{?P_ShangHaiJiaChen, career_tower:get_pet_damage_up(MapDataID)} | PetAttr1]);
								 ?MapAI_CareerTower_Super ->
									 common:listValueMerge([{?P_ShangHaiJiaChen, career_tower:get_pet_damage_up(MapDataID)} | PetAttr1]);
								 _ -> PetAttr1
							 end
					 end,
		{PetUid, skill_player:make_skill_fix_list(PlayerSkillList), NewPetAttr}
		end,
	lists:map(F, BeenLinkUidList ++ PetUidPosList).

get_available_pet_attr(PlayerId, MapDataID, PlayerAttrList) ->
	PlayerPetAttr = get_player_pet_attr(PlayerAttrList),
	MapAi = playerCopyMap:get_map_ai_by_map_data_id(MapDataID),
	PetUidList = get_out_fight_pet_id_list(PlayerId),
	BeenLinkUidList = pet_base:get_been_link_uid_list(PlayerId, PetUidList),
	F = fun(PetUid) ->
		case lists:member(MapAi, ?ExpeditionMapAIList) of
			?FALSE ->
				PetAttr1 = get_pet_attr(PlayerId, PetUid, PlayerPetAttr, get_send_attr_flag()),
				NewPetAttr = case MapAi of
								 ?MapAI_CareerTower_Main ->
									 common:listValueMerge([{?P_ShangHaiJiaChen, career_tower:get_pet_damage_up(MapDataID)} | PetAttr1]);
								 ?MapAI_CareerTower_Super ->
									 common:listValueMerge([{?P_ShangHaiJiaChen, career_tower:get_pet_damage_up(MapDataID)} | PetAttr1]);
								 _ -> PetAttr1
							 end,
				{PetUid, NewPetAttr};
			?TRUE ->
				ChangeAttr = df:getGlobalSetupValueList(expeditionPetArri, []),
				PetAttr = lists:map(fun({K, V}) ->
					case lists:keyfind(K, 1, ChangeAttr) of
						?FALSE -> {K, V};
						{_, W} -> {K, trunc(V * W / 10000)}
					end
									end, PlayerAttrList),
				{PetUid, PetAttr}
		end
		end,
	lists:map(F, BeenLinkUidList ++ PetUidList).

get_available_aid_pet_attr(PlayerId, MapDataID, PlayerAttrList) ->
	get_available_aid_pet_attr(PlayerId, MapDataID, PlayerAttrList, pet_pos:get_aid_uid_and_pos_list()).
get_available_aid_pet_attr(PlayerId, MapDataID, PlayerAttrList, AidPosList) ->
	PlayerPetAttr = get_player_pet_attr(PlayerAttrList),
	MapAi = playerCopyMap:get_map_ai_by_map_data_id(MapDataID),
	F = fun({PetUid, Pos}) ->
		case lists:member(MapAi, ?ExpeditionMapAIList) of
			?FALSE ->
				AltarEffectList = pet_pos:get_pet_pos_altar_effect(PlayerId, ?STATUS_AID, Pos),
				PetAttr1 = get_pet_attr_aid(PlayerId, PetUid, PlayerPetAttr, AltarEffectList),
				NewPetAttr = case MapAi of
								 ?MapAI_CareerTower_Main ->
									 common:listValueMerge([{?P_ShangHaiJiaChen, career_tower:get_pet_damage_up(MapDataID)} | PetAttr1]);
								 ?MapAI_CareerTower_Super ->
									 common:listValueMerge([{?P_ShangHaiJiaChen, career_tower:get_pet_damage_up(MapDataID)} | PetAttr1]);
								 _ -> PetAttr1
							 end,
				{PetUid, NewPetAttr};
			?TRUE ->
				ChangeAttr = df:getGlobalSetupValueList(expeditionPetArri, []),
				PetAttr = lists:map(fun({K, V}) ->
					case lists:keyfind(K, 1, ChangeAttr) of
						?FALSE -> {K, V};
						{_, W} -> {K, trunc(V * W / 10000)}
					end
									end, PlayerAttrList),
				{PetUid, PetAttr}
		end
		end,
	lists:map(F, AidPosList).

%% 玩家等级提升
on_player_upgrade() ->
	player_refresh:on_refresh_pet_attr(?FALSE),
	ok.

set_send_attr_flag(Flag) ->
	?PUT(attr_send_flag, Flag).
get_send_attr_flag() ->
	?GET(attr_send_flag, ?TRUE).

send_pet_attr(PlayerId, PetUid) when is_integer(PetUid) ->
	send_pet_attr(PlayerId, [PetUid]);
send_pet_attr(PlayerId, PetList) ->
	PlayerPetAttr = get_player_pet_attr(attribute_player:get_player_attr()),
	F = fun(Uid) ->
		Attr = get_pet_attr(PlayerId, Uid, PlayerPetAttr),
		#pk_pet_prop{uid = Uid, prop_list = [#pk_BattleProp{index = Key, value = Value} || {Key, Value} <- Attr, Key > 0]}
		end,
	PetPropList = lists:map(F, PetList),
	player:send(#pk_GS2U_push_pet_prop{pet_prop_list = PetPropList}),
	ok.

%% 宠物系统给玩家增加的虚拟战力
%% 出战宠物属性、技能变化时调用, 提示玩家战力变化
%% 1、宠物非基础属性（只算出战的），计算出的战力需要乘以系数
%% 2、出战宠物技能，直接读取配置point第二个参数
get_player_add_fight() ->
	case get({?MODULE, pet_ex_add_battle_value}) of
		?UNDEFINED -> pet_battle:calc_player_add_fight();
		V -> V
	end.

calc_player_add_fight() ->
	PlayerId = player:getPlayerID(),
	OutFightPets = pet_pos:get_fight_uid_list(),
	AidPets = pet_pos:get_aid_uid_and_pos_list(),
	FightScale = cfg_globalSetup:mCZZFightCoef(),
	F = fun(Uid) ->
		[{T, V * FightScale / 10000} || {T, V} <- get_pet_attr(PlayerId, Uid, []), not lists:member(T, [1, 3, 4, 5])]
		end,
	OutFightSpecialAttr = [{T + ?PET_INDEX_START, trunc(V)} || {T, V} <- common:listValueMerge(lists:flatten(lists:map(F, OutFightPets)))],
	{SpecialFight, _, _} = attribute_player:calc_battle_value_global(OutFightSpecialAttr, {0, 0, 0}),

	F2 = fun(Uid) ->
		[get_skill_fight(SkillType, SkillId) || {SkillType, SkillId, _} <- get_pet_skill(Uid, PlayerId)]
		 end,
	SkillFight = lists:sum(lists:flatten(lists:map(F2, pet_pos:get_fight_uid_list_with_passive_pet()))),

	F3 = fun({Uid, Pos}) ->
		AltarEffectList = pet_pos:get_pet_pos_altar_effect(PlayerId, ?STATUS_AID, Pos),
		[{T, V * FightScale / 10000} || {T, V} <- get_pet_attr_aid(PlayerId, Uid, [], AltarEffectList), not lists:member(T, [1, 3, 4, 5])]
		 end,
	AidSpecialAttr = [{T + ?PET_INDEX_START, trunc(V)} || {T, V} <- common:listValueMerge(lists:flatten(lists:map(F3, AidPets)))],
	{AidSpecialFight, _, _} = attribute_player:calc_battle_value_global(AidSpecialAttr, {0, 0, 0}),

	AddValue = SpecialFight + SkillFight + AidSpecialFight,
	put({?MODULE, pet_ex_add_battle_value}, AddValue),
	AddValue.

%%%% 获取宠物抗性(20000+类型属性)战斗力
%%get_pet_def_fight() ->
%%	PlayerAttrs = attribute_player:get_player_attr(),
%%	PetDefAttrs = get_player_pet_def_attr(PlayerAttrs),
%%	{Fight, _, _} = attribute_player:calc_battle_value_global(PetDefAttrs, {0, 0, 0}),
%%	Fight.

%%get_player_pet_def_attr(PlayerAttrList) ->
%%	[{Type - ?PET_INDEX_START, V} || {Type, V} <- common:listValueMerge(PlayerAttrList), Type > ?PET_INDEX_START].

get_skill_fight(1, SkillId) ->
	#skillBaseCfg{point = {_, Fight, _}} = cfg_skillBase:getRow(SkillId),
	Fight;
get_skill_fight(2, SkillId) ->
	#skillCorrCfg{point = {_, Fight, _}} = cfg_skillCorr:getRow(SkillId),
	Fight.

get_skill_score(1, SkillId) ->
	#skillBaseCfg{point = {_, _Fight, Score}} = cfg_skillBase:getRow(SkillId),
	Score;
get_skill_score(2, SkillId) ->
	#skillCorrCfg{point = {_, _Fight, Score}} = cfg_skillCorr:getRow(SkillId),
	Score.

%% 宠物系统给玩家增加的属性(调用：星级变化、洗髓、出战\助战变化、突破)
%% 1、出战宠物基础属性换算
%% 2、助战宠物基础属性换算
%% 3、援战宠物基础属性换算
get_player_add_attr(PlayerId) ->
	OutFightPets = get_out_fight_pets(PlayerId),
	F = fun({#pet_new{uid = Uid} = Pet, _}, Acc) ->
		LinkPet = pet_soul:link_pet(PlayerId, Pet),
		SSBreakLv = pet_shengshu:shared_pet_break_lv(LinkPet, pet_new:get_pet_list(), pet_shengshu:get_pet_guard(), pet_shengshu:get_pet_pos_list()), %% TODO 按玩家进程处理的，其他进程要用的话需要处理下
		#petBreakCfg{fightScaler = FixScale} = cfg_petBreak:getRow(SSBreakLv),
		[{T, V * FixScale / 10000} || {T, V} <- get_pet_attr(PlayerId, Uid, []), lists:member(T, [1, 3, 4, 5])] ++ Acc
		end,
	OutFightBaseAttr = lists:foldl(F, [], OutFightPets),

	AssistPets = get_assist_pets(PlayerId),
	F2 = fun(#pet_new{uid = Uid, pet_cfg_id = PetCfgId} = Pet, Acc) ->
		LinkPet = pet_soul:link_pet(PlayerId, Pet),
		SSBreakLv = pet_shengshu:shared_pet_break_lv(LinkPet, pet_new:get_pet_list(), pet_shengshu:get_pet_guard(), pet_shengshu:get_pet_pos_list()),
		#petBreakCfg{fightScaler = FixScale} = cfg_petBreak:getRow(SSBreakLv),
		#petStarCfg{fightScaler = StarScale} = cfg_petStar:getRow(PetCfgId, LinkPet#pet_new.star),
		[{T, V * FixScale / 10000 * StarScale / 10000} || {T, V} <- get_pet_attr_assist(PlayerId, Uid, []), lists:member(T, [1, 3, 4, 5])] ++ Acc
		 end,
	AssistBaseAttr = lists:foldl(F2, [], AssistPets),

	AidPets = get_aid_pets(PlayerId),
	F3 = fun(#pet_new{uid = Uid, fight_flag = FightFlag, fight_pos = FightPos}, Acc) ->
		case lists:keymember(FightPos, 2, OutFightPets) of
			?TRUE ->
				AlterEffectList = pet_pos:get_pet_pos_altar_effect(PlayerId, FightFlag, FightPos),
				Scale = pet_pos:get_altar_effect_rate(AlterEffectList),
				[{T, V * Scale / 10000} || {T, V} <- get_pet_attr_aid(PlayerId, Uid, [], AlterEffectList), lists:member(T, [1, 3, 4, 5])] ++ Acc;
			?FALSE -> Acc
		end
		 end,
	AidBaseAttr = lists:foldl(F3, [], AidPets),
	[{T, trunc(V)} || {T, V} <- common:listValueMerge(OutFightBaseAttr ++ AssistBaseAttr ++ AidBaseAttr)].

%% ============ lib
get_assist_pet_uid_list(PlayerId) ->
	case player:getPlayerID() == PlayerId of
		?TRUE -> pet_pos:get_assist_id_list();
		_ -> pet_pos:on_get_assist_list(PlayerId)
	end.

get_assist_pets(PlayerId) ->
	case player:getPlayerID() == PlayerId of
		?TRUE -> [pet_new:get_pet(Uid) || Uid <- pet_pos:get_assist_id_list()];
		_ ->
			PetUids = pet_pos:on_get_assist_list(PlayerId),
			[pet_new:db_pet2pet(DbPet) || DbPet <- table_player:lookup(db_pet_new, PlayerId, PetUids)]
	end.

get_aid_pets(PlayerId) ->
	case player:getPlayerID() == PlayerId of
		?TRUE -> [pet_new:get_pet(Uid) || Uid <- pet_pos:get_aid_uid_list()];
		_ ->
			PetUids = pet_pos:on_get_aid_uid_list(PlayerId),
			[pet_new:db_pet2pet(DbPet) || DbPet <- table_player:lookup(db_pet_new, PlayerId, PetUids)]
	end.

%% 获取宠物技能
get_pet_skill(PetUid, PlayerId) ->
	Skill = pet_eq_and_star:get_skill_list(PetUid, PlayerId),
	SoulSkill = pet_soul:get_skill_list(PetUid, PlayerId),
	SoulSkill ++ Skill.
%%	#pet_new{pet_cfg_id = PetCfgId} = pet_new:get_pet(PetUid),
%%	#petBaseCfg{} = cfg_petBase:getRow(PetCfgId),
%%	[]. %% @todo [{SkillType, SkillId, SkillIndex}]

%% 特殊处理 每个属性ID-20000
%% 宠物总属性 = 宠物基础表属性 + （基础表*(1+升星表万分比+星位万分比/10000)、洗髓表、宠物装备表）资质汇总换算成四维属性, + 玩家身上所有20000+属性 + 宠物装备属性
%% 资质换算公式：
get_pet_attr(PlayerId, Uid, PlayerPetAttrList) ->
	get_pet_attr(PlayerId, Uid, PlayerPetAttrList, ?FALSE).
get_pet_attr(PlayerId, Uid, PlayerPetAttrList, IsSend) -> %% IsSend 是否发送协议同步属性
	get_pet_attr(PlayerId, Uid, PlayerPetAttrList, IsSend, ?TRUE).
get_pet_attr(PlayerId, Uid, PlayerPetAttrList, IsSend, IsShared) -> %% IsShared 圣树计算
	get_pet_attr(PlayerId, Uid, PlayerPetAttrList, IsSend, IsShared, ?FALSE).
get_pet_attr(PlayerId, Uid, PlayerPetAttrList, IsSend, IsShared, IsShow) -> %% IsShow 是否用于展示 是-不添加隐藏属性/否-加上隐藏属性
	#pet_new{pet_cfg_id = PetCfgId, fight_flag = FightType, fight_pos = FightPos} = Pet = pet_new:get_pet(PlayerId, Uid),
	#pet_new{shared_flag = SharedFlag, uid = RealUid, pet_cfg_id = PetCfgId2, wash = QualWash1, star = PetStar,
		pet_lv = PetLv1, star_pos = StarPos} = LinkPet = pet_soul:link_pet(PlayerId, Pet),
	{QualWash, PetLv} =
		case SharedFlag =:= 1 andalso IsShared of
			?TRUE -> pet_shengshu:shared_pet_wash_and_lv(PlayerId, LinkPet);
			_ -> {QualWash1, PetLv1}
		end,
	#petBaseCfg{attrBase = CfgAttrBase, attrBaseHide = AttrHide, qualBase = QualBase, elemType = ElemType} = cfg_petBase:getRow(PetCfgId),
	#petBaseCfg{qualBase = QualBase2} = cfg_petBase:getRow(PetCfgId2),
	IsShowAttr = ?IF(IsShow, [], AttrHide),
	PetCityAttrQual = ?IF(FightType =:= ?STATUS_FIGHT, pet_city:get_pet_attr_and_qual(PlayerId), []),
	{PetCityQual, PetCityAttr} = lists:partition(fun({Id, _}) ->
		lists:member(Id - ?PET_INDEX_START, ?P_PET_QUALITY_LIST) end, PetCityAttrQual),
	AttrBase = IsShowAttr ++ CfgAttrBase ++ PetCityAttr,
	#petStarCfg{qualiIncrease = QualAddPercent} = cfg_petStar:getRow(PetCfgId, PetStar),
	#petStarCfg{linkBonus = LinkBonus, qualiIncrease = QualAddPercent2} = cfg_petStar:getRow(PetCfgId2, PetStar),
	StarPosAddPercent = pet_eq_and_star:get_star_pos_qual(StarPos, PetCfgId),
	NewQualBase = calc_qual(QualBase, QualAddPercent, StarPosAddPercent),
	EqList = pet_pos:get_pet_pos_ring_eq_list(PlayerId, FightType, FightPos),
	QualEq = pet_eq_and_star:get_eq_quality(PlayerId, EqList),

	%% 装备里的技能属性
	SkillList = get_pet_skill(RealUid, PlayerId),
	PlayerSkillList = skill_player:make_player_skill(SkillList),
	SkillAttr = skill_player:calc_skill_attr(PlayerSkillList),
	SkillBaseAttr = [E#prop{index = T - ?PET_INDEX_START} || #prop{index = T} = E <- SkillAttr],
	SkillQualityAddList = get_skill_quality_add(SkillAttr),

	%%英雄装备属性数据
	{BlessEqQual, BlessEqAttr} = ?IF(FightType =:= ?STATUS_FIGHT, pet_bless_eq:get_prop(PlayerId, FightPos), {[], []}),
	%%英雄圣装属性数据
	{SacredPetPropList, _, _} = ?IF(FightType =:= ?STATUS_FIGHT, pet_sacred_eq:get_prop(PlayerId), {[], [], []}),

	%%英雄幻化属性数据{资质列表,属性列表}
	LinkPetCfgIDList = common:uniq([PetCfgId2 | [T#pet_new.pet_cfg_id || U <- pet_base:get_been_link_uid_list(PlayerId, [RealUid]),
		(T = pet_new:get_pet(PlayerId, U)) =/= {}]]),
	IllusionQualityList = pet_illusion:get_pet_prop(PlayerId, LinkPetCfgIDList),
	QualWashAdd = get_qual_wash(QualWash, QualBase2),
	LinkAdd = case Uid =/= RealUid andalso LinkBonus > 0 of
				  ?TRUE ->
					  StarPosAddPercent2 = pet_eq_and_star:get_star_pos_qual(StarPos, PetCfgId2),
					  [{K, V * LinkBonus / 10000} || {K, V} <- calc_qual(QualBase2, QualAddPercent2, StarPosAddPercent2) ++ QualWashAdd];
				  ?FALSE -> []
			  end,
	AllQuality = [{Type - ?PET_INDEX_START, Value} || {Type, Value} <-
		common:listValueMerge(NewQualBase ++ QualWashAdd ++ QualEq ++ PetCityQual ++ SkillQualityAddList ++ BlessEqQual
			++ IllusionQualityList ++ LinkAdd)],
	QualityAttrList = get_base_quality_with_add_percent(PetLv, AllQuality),
	NewAttrBase = [{Type - ?PET_INDEX_START, Value} || {Type, Value} <- AttrBase],
	RetAttr = common:listValueMerge(NewAttrBase ++ QualityAttrList ++ PlayerPetAttrList),
	AllAttr = attribute:prop_merge([#prop{index = Index, base = V} || {Index, V} <- RetAttr] ++ SkillBaseAttr ++ BlessEqAttr, SacredPetPropList),
	PropW_L = attribute_player:calc_prop_w(AllAttr),
	TotalAttr = common:listValueMerge([{Index, V} || {Index, _, V} <- attribute_player:calc_prop_final(AllAttr, PropW_L, [])]),
	IsSend andalso save_pet_attr(Uid, TotalAttr),
	[{?P_RoleId, Uid}, {?P_ObjectID, PlayerId}, {?P_ObjectType, ?ObjectType_Player}, {?P_PetElem, ElemType} | TotalAttr].
%% 纯公式计算
get_pet_attr_pure(Pet, LinkPet, PlayerPetAttrList, PetWash, PetLv, EqQuality, SkillList) ->
	#pet_new{pet_cfg_id = PetCfgId, star_pos = StarPos, fight_flag = FightType, fight_pos = FightPos} = Pet,
	#pet_new{pet_cfg_id = PetCfgId2, star = PetStar} = LinkPet,
	#petBaseCfg{attrBase = CfgAttrBase, attrBaseHide = AttrHide, qualBase = QualBase} = cfg_petBase:getRow(PetCfgId),
	#petBaseCfg{qualBase = QualBase2} = cfg_petBase:getRow(PetCfgId2),
	AttrBase = AttrHide ++ CfgAttrBase,
	#petStarCfg{qualiIncrease = QualAddPercent} = cfg_petStar:getRow(PetCfgId, PetStar),
	StarPosAddPercent = pet_eq_and_star:get_star_pos_qual(StarPos, PetCfgId),
	NewQualBase = calc_qual(QualBase, QualAddPercent, StarPosAddPercent),
	PetWash2 = common:listValueMerge(PetWash),
	AllQuality = [{Type - ?PET_INDEX_START, Value} || {Type, Value} <- common:listValueMerge(NewQualBase ++ get_qual_wash(PetWash2, QualBase2) ++ EqQuality)],
	QualityAttrList = get_base_quality_with_add_percent(PetLv, AllQuality),
	NewAttrBase = [{Type - ?PET_INDEX_START, Value} || {Type, Value} <- AttrBase],
	%%英雄圣装属性
	{SacredPetPropList, _, _} = ?IF(FightType =:= ?STATUS_FIGHT, pet_sacred_eq:get_prop(), {[], [], []}),
	RetAttr = common:listValueMerge(NewAttrBase ++ QualityAttrList ++ PlayerPetAttrList),
	%% 装备里的技能属性
	PlayerSkillList = skill_player:make_player_skill(SkillList),
	SkillAttr = skill_player:calc_skill_attr(PlayerSkillList),
	SkillBaseAttr = [E#prop{index = T - ?PET_INDEX_START} || #prop{index = T} = E <- SkillAttr],

	{_, BlessEqAttr} = ?IF(FightType =:= ?STATUS_FIGHT, pet_bless_eq:get_prop(FightPos), {[], []}),%%英雄装备属性数据

	AllAttr = attribute:prop_merge([#prop{index = Index, base = V} || {Index, V} <- RetAttr] ++ SkillBaseAttr ++ BlessEqAttr, SacredPetPropList),
	PropW_L = attribute_player:calc_prop_w(AllAttr),
	TotalAttr = common:listValueMerge([{Index, V} || {Index, _, V} <- attribute_player:calc_prop_final(AllAttr, PropW_L, [])]),
	TotalAttr.

calc_qual(QualBase, QualAddPercent, StarPosAddPercent) ->
	common:listValueMerge(
		lists:foldl(fun({Type, Value}, Acc) ->
			case lists:keyfind(Type + 4, 1, StarPosAddPercent) of %% 基础资质25080-25083对应万分比加成25084-25087
				{_, StarValue} -> [{Type, Value * (1 + (QualAddPercent + StarValue) / 10000)} | Acc];
				_ -> [{Type, Value * (1 + QualAddPercent / 10000)} | Acc]
			end end, [], QualBase)).

%% 助战宠物属性 只影响 给玩家增加的属性以及评分计算
get_pet_attr_assist(PlayerId, Uid, PlayerPetAttrList) ->
	get_pet_attr_assist(PlayerId, Uid, PlayerPetAttrList, ?TRUE).
get_pet_attr_assist(PlayerId, Uid, PlayerPetAttrList, IsShared) ->
	#pet_new{pet_cfg_id = PetCfgId, pet_lv = PetLv1, fight_flag = FightType, fight_pos = FightPos} = Pet = pet_pos:assist_pet_change(PlayerId, pet_new:get_pet(PlayerId, Uid)),
	#pet_new{shared_flag = SharedFlag, uid = RealUid, pet_cfg_id = PetCfgId2, wash = QualWash1, star = PetStar,
		pet_lv = PetLv2, star_pos = StarPos} = LinkPet = pet_soul:link_pet(PlayerId, Pet),
	{QualWash, PetLv3} = case SharedFlag =:= 1 andalso IsShared of
							 ?TRUE -> pet_shengshu:shared_pet_wash_and_lv(PlayerId, LinkPet);
							 _ -> {QualWash1, PetLv2}
						 end,
	PetLv = max(PetLv1, PetLv3),
	#petBaseCfg{attrBase = CfgAttrBase, attrBaseHide = AttrHide, qualBase = QualBase} = cfg_petBase:getRow(PetCfgId),
	#petBaseCfg{qualBase = QualBase2} = cfg_petBase:getRow(PetCfgId2),
	AttrBase = AttrHide ++ CfgAttrBase,
	#petStarCfg{qualiIncrease = QualAddPercent} = cfg_petStar:getRow(PetCfgId, PetStar),
	#petStarCfg{linkBonus = LinkBonus, qualiIncrease = QualAddPercent2} = cfg_petStar:getRow(PetCfgId2, PetStar),
	StarPosAddPercent = pet_eq_and_star:get_star_pos_qual(StarPos, PetCfgId),
	NewQualBase = calc_qual(QualBase, QualAddPercent, StarPosAddPercent),
	EqList = pet_pos:get_pet_pos_ring_eq_list(PlayerId, FightType, FightPos),
	QualEq = pet_eq_and_star:get_eq_quality(PlayerId, EqList),
	%% 装备里的技能属性
	SkillList = get_pet_skill(RealUid, PlayerId),
	PlayerSkillList = skill_player:make_player_skill(SkillList),
	SkillAttr = skill_player:calc_skill_attr(PlayerSkillList),
	SkillQualityAddList = get_skill_quality_add(SkillAttr),
	LinkPetCfgIDList = common:uniq([PetCfgId2 | [T#pet_new.pet_cfg_id || U <- pet_base:get_been_link_uid_list(PlayerId, [RealUid]),
		(T = pet_new:get_pet(PlayerId, U)) =/= {}]]),
	IllusionQualityList = pet_illusion:get_pet_prop(PlayerId, LinkPetCfgIDList),
	QualWashAdd = get_qual_wash(QualWash, QualBase2),
	LinkAdd = case Uid =/= RealUid andalso LinkBonus > 0 of
				  ?TRUE ->
					  StarPosAddPercent2 = pet_eq_and_star:get_star_pos_qual(StarPos, PetCfgId2),
					  [{K, V * LinkBonus / 10000} || {K, V} <- calc_qual(QualBase2, QualAddPercent2, StarPosAddPercent2) ++ QualWashAdd];
				  ?FALSE -> []
			  end,
	AllQuality = [{Type - ?PET_INDEX_START, Value} || {Type, Value} <-
		common:listValueMerge(NewQualBase ++ QualWashAdd ++ QualEq ++ SkillQualityAddList ++ IllusionQualityList ++ LinkAdd)],
	QualityAttrList = get_base_quality_with_add_percent(PetLv, AllQuality),
	NewAttrBase = [{Type - ?PET_INDEX_START, Value} || {Type, Value} <- AttrBase],
	RetAttr = common:listValueMerge(NewAttrBase ++ QualityAttrList ++ PlayerPetAttrList),

	SkillBaseAttr = [E#prop{index = T - ?PET_INDEX_START} || #prop{index = T} = E <- SkillAttr],
	AllAttr = [#prop{index = Index, base = V} || {Index, V} <- RetAttr] ++ SkillBaseAttr,

	PropW_L = attribute_player:calc_prop_w(AllAttr),
	TotalAttr = [{Index, V} || {Index, _, V} <- attribute_player:calc_prop_final(AllAttr, PropW_L, [])],
	TotalAttr.

%% 援战宠物属性
get_pet_attr_aid(PlayerId, Uid, PlayerPetAttrList, AltarEffectList) ->
	#pet_new{pet_cfg_id = PetCfgId} = Pet = pet_new:get_pet(PlayerId, Uid),
	#pet_new{shared_flag = SharedFlag, uid = RealUid, pet_cfg_id = PetCfgId2, wash = QualWash1, star = PetStar1,
		pet_lv = PetLv1, star_pos = StarPos} = LinkPet = pet_soul:link_pet(PlayerId, Pet),
	{QualWash, PetLv2} = case SharedFlag =:= 1 of
							 ?TRUE -> pet_shengshu:shared_pet_wash_and_lv(PlayerId, LinkPet);
							 _ -> {QualWash1, PetLv1}
						 end,
	AltarLv = pet_pos:get_altar_effect_level(AltarEffectList),
	AltarStar = pet_pos:get_altar_effect_star(AltarEffectList),
	PetLv = min(PetLv2, AltarLv),
	PetStar = min(PetStar1, AltarStar),
	#petBaseCfg{attrBase = CfgAttrBase, attrBaseHide = AttrHide, qualBase = QualBase} = cfg_petBase:getRow(PetCfgId),
	#petBaseCfg{qualBase = QualBase2} = cfg_petBase:getRow(PetCfgId2),
	AttrBase = AttrHide ++ CfgAttrBase,
	#petStarCfg{qualiIncrease = QualAddPercent} = cfg_petStar:getRow(PetCfgId, PetStar),
	#petStarCfg{linkBonus = LinkBonus, qualiIncrease = QualAddPercent2} = cfg_petStar:getRow(PetCfgId2, PetStar),
	StarPosAddPercent = pet_eq_and_star:get_star_pos_qual([E || {_, S} = E <- StarPos, S =< PetStar], PetCfgId),
	NewQualBase = calc_qual(QualBase, QualAddPercent, StarPosAddPercent),

	SkillList = get_pet_skill(RealUid, PlayerId),
	PlayerSkillList = skill_player:make_player_skill(SkillList),
	SkillAttr = skill_player:calc_skill_attr(PlayerSkillList),
	SkillQualityAddList = get_skill_quality_add(SkillAttr),
	LinkPetCfgIDList = common:uniq([PetCfgId2 | [T#pet_new.pet_cfg_id || U <- pet_base:get_been_link_uid_list(PlayerId, [RealUid]),
		(T = pet_new:get_pet(PlayerId, U)) =/= {}]]),
	IllusionQualityList = pet_illusion:get_pet_prop(PlayerId, LinkPetCfgIDList),
	QualWashAdd = get_qual_wash(QualWash, QualBase2),
	LinkAdd = case Uid =/= RealUid andalso LinkBonus > 0 of
				  ?TRUE ->
					  StarPosAddPercent2 = pet_eq_and_star:get_star_pos_qual(StarPos, PetCfgId2),
					  [{K, V * LinkBonus / 10000} || {K, V} <- calc_qual(QualBase2, QualAddPercent2, StarPosAddPercent2) ++ QualWashAdd];
				  ?FALSE -> []
			  end,
	AllQuality = [{Type - ?PET_INDEX_START, Value} || {Type, Value} <-
		common:listValueMerge(NewQualBase ++ QualWashAdd ++ SkillQualityAddList ++ IllusionQualityList ++ LinkAdd)],
	QualityAttrList = get_base_quality_with_add_percent(PetLv, AllQuality),
	NewAttrBase = [{Type - ?PET_INDEX_START, Value} || {Type, Value} <- AttrBase],
	RetAttr = common:listValueMerge(NewAttrBase ++ QualityAttrList ++ PlayerPetAttrList),

	SkillBaseAttr = [E#prop{index = T - ?PET_INDEX_START} || #prop{index = T} = E <- SkillAttr],
	AllAttr = [#prop{index = Index, base = V} || {Index, V} <- RetAttr] ++ SkillBaseAttr,

	PropW_L = attribute_player:calc_prop_w(AllAttr),
	TotalAttr = [{Index, V} || {Index, _, V} <- attribute_player:calc_prop_final(AllAttr, PropW_L, [])],
	[{?P_RoleId, Uid}, {?P_ObjectID, PlayerId}, {?P_ObjectType, ?ObjectType_Player} | TotalAttr].

%% SP英雄技能提供资质百分比加成
get_skill_quality_add(SkillBaseAttr) ->
	lists:foldl(fun(#prop{index = I, base = B}, Acc) ->
		case lists:member(I - ?PET_INDEX_START, ?P_PET_QUALITY_LIST) of
			?TRUE -> [{I, B} | Acc];
			?FALSE -> Acc
		end end, [], SkillBaseAttr).

%% 用于宠物属性展示
get_show_attr(Uid) ->
	try
		?CHECK_THROW(pet_new:get_pet(Uid) =/= {}, ?ErrorCode_PetNotExist),
		PlayerId = player:getPlayerID(),
		PlayerPetAttrList = get_player_pet_attr(attribute_player:get_player_attr()),
		Attr = get_pet_attr(PlayerId, Uid, PlayerPetAttrList, ?FALSE, ?TRUE, ?TRUE),
		AttrMsg = #pk_pet_prop{uid = Uid, prop_list = [#pk_BattleProp{index = Key, value = Value} || {Key, Value} <- Attr, Key > 0]},
		player:send(#pk_GS2U_show_pet_prop{error_code = ?ERROR_OK, pet_prop = AttrMsg})
	catch
		Err -> player:send(#pk_GS2U_show_pet_prop{error_code = Err})
	end.

get_qual_wash(Wash, BaseQual) ->
	F = fun({Type, V}) ->
		{_, Base} = lists:keyfind(Type, 1, BaseQual),
		{Type, V - Base}
		end,
	lists:map(F, Wash).

%% 获取玩家中投放的的魔宠属性&公用属性（7-14）
get_player_pet_attr(PlayerAttrList) ->
	[?IF(Type < ?PET_INDEX_START, {Type, V}, {Type - ?PET_INDEX_START, V}) || {Type, V} <- common:listValueMerge(PlayerAttrList),
		Type > ?PET_INDEX_START orelse lists:member(Type, lists:seq(7, 14))].

%% 把资质换算成对应四维属性
get_base_quality_with_add_percent(PetLv, QualityList) ->
	[attr_transform(PetLv, attr_percent_add(E, QualityList)) || E <- QualityList].


%% lib
get_quality_percent(Type, QualityList) ->
	case lists:keyfind(Type, 1, QualityList) of
		{_, V} -> V / 10000;
		_ -> 0
	end.

attr_percent_add({?P_PET_QUALITY_HP = Type, V}, AttrList) ->
	{Type, V * (1 + get_quality_percent(?P_PET_QUALITY_PERCENT_HP, AttrList))};
attr_percent_add({?P_PET_QUALITY_ATK = Type, V}, AttrList) ->
	{Type, V * (1 + get_quality_percent(?P_PET_QUALITY_PERCENT_ATK, AttrList))};
attr_percent_add({?P_PET_QUALITY_DEF = Type, V}, AttrList) ->
	{Type, V * (1 + get_quality_percent(?P_PET_QUALITY_PERCENT_DEF, AttrList))};
attr_percent_add({?P_PET_QUALITY_BRO = Type, V}, AttrList) ->
	{Type, V * (1 + get_quality_percent(?P_PET_QUALITY_PERCENT_BRO, AttrList))};
attr_percent_add({Type, V}, _AttrList) ->
	{Type, V}.

%% 换算属性=（等级-1）*round(资质*对应资质转换系数/10000)
attr_transform(PetLv, {?P_PET_QUALITY_HP, V}) ->
	{?P_ShengMing, (PetLv - 1) * round(V * df:get_pet_hp_transform() / 10000)};
attr_transform(PetLv, {?P_PET_QUALITY_ATK, V}) ->
	{?P_GongJi, (PetLv - 1) * round(V * df:get_pet_atk_transform() / 10000)};
attr_transform(PetLv, {?P_PET_QUALITY_DEF, V}) ->
	{?P_FangYu, (PetLv - 1) * round(V * df:get_pet_def_transform() / 10000)};
attr_transform(PetLv, {?P_PET_QUALITY_BRO, V}) ->
	{?P_PoJia, (PetLv - 1) * round(V * df:get_pet_bro_transform() / 10000)};
attr_transform(_PetLv, {Type, V}) ->
	{Type, V}.


get_out_fight_pet_id_list() ->
	get_out_fight_pet_id_list(player:getPlayerID()).
get_out_fight_pet_id_list(PlayerId) ->
	case PlayerId == player:getPlayerID() of
		?TRUE -> pet_pos:get_fight_uid_list();
		_ -> pet_pos:get_fight_uid_list(PlayerId)
	end.

get_out_and_assist_pet_id_list(PlayerId) ->
	get_out_fight_pet_id_list(PlayerId) ++ get_assist_pet_uid_list(PlayerId).

get_out_fight_pets(PlayerId) ->
	case PlayerId == player:getPlayerID() of
		?TRUE ->
			[{pet_new:get_pet(Uid), Pos} || {Uid, Pos} <- pet_pos:get_fight_uid_and_pos_list()];
		_ ->
			OutPetUids = pet_pos:get_fight_uid_list_with_pos(PlayerId),
			DbPetList = table_player:lookup(db_pet_new, PlayerId),
			F = fun({Uid, Pos}, Acc) ->
				DbPet = lists:keyfind(Uid, #db_pet_new.uid, DbPetList),
				[{pet_new:db_pet2pet(DbPet), Pos} | Acc]
				end,
			lists:foldl(F, [], OutPetUids)
	end.

get_out_fight_pet_id_and_pos_list(PlayerId) ->
	case PlayerId == player:getPlayerID() of
		?TRUE -> pet_pos:get_fight_uid_and_pos_list();
		_ -> pet_pos:get_fight_uid_list_with_pos(PlayerId)
	end.
get_aid_fight_pet_id_and_pos_list(PlayerId) ->
	case PlayerId == player:getPlayerID() of
		?TRUE -> pet_pos:get_aid_uid_and_pos_list();
		_ -> pet_pos:on_get_aid_uid_and_pos_list(PlayerId)
	end.

get_equip_pet() -> make_map_pets(player:getPlayerID(), 0).
make_map_pets(PlayerId, FuncId) ->
	FightOutPetList0 = pet_new:get_fight_out_pet(PlayerId, FuncId),
	FightOutPetList = case FuncId =/= 0 andalso FightOutPetList0 =:= [] of %% 如果阵容
						  ?TRUE -> pet_new:get_fight_out_pet(PlayerId, 0);
						  ?FALSE -> FightOutPetList0
					  end,
	[#map_pet{object_id = Uid, pet_id = PetId, pet_star = PetStar, pet_grade = Grade, pet_pos = Pos, pet_sp_lv = SpLv, been_link_uid = BeenLinkUid,
		been_link_pet_cfg_id = BLinkPetCfgID, been_link_pet_sp_lv = BLinkSpLv, illusion_id = pet_illusion:get_illusion_cfg(PlayerId, PetId), pet_lv = PetLv,
		is_fight = common:bool_to_int(Pos > 0)} ||
		#pk_pet_info{uid = Uid, pet_cfg_id = PetId, star = PetStar, grade = Grade, fight_pos = Pos, sp_lv = SpLv, been_link_uid = BeenLinkUid, pet_lv = PetLv,
			been_link_pet_cfg_id = BLinkPetCfgID, been_link_pet_sp_lv = BLinkSpLv} <- FightOutPetList].

get_all_pets(PlayerId) ->
	DbPetList = table_player:lookup(db_pet_new, PlayerId),
	[pet_new:db_pet2pet(DbPet) || DbPet <- DbPetList].

to_pk_map_pet(ID, #map_pet{object_id = ObjectId, pet_id = PetId, pet_star = PetStar, pet_grade = 0, pet_pos = PetPos, pet_sp_lv = SpLv, been_link_pet_cfg_id = BeLinkPetCfgID, illusion_id = IllusionId, is_fight = IsFight}) ->
	#pk_map_pet{pet_object_id = ObjectId, pet_id = PetId, pet_star = PetStar, pet_pos = PetPos, pet_sp_lv = SpLv, been_link_pet_cfg_id = BeLinkPetCfgID, transform_id = mapdb:getObjectTransFormInfo(ID, ObjectId),
		illusion_id = IllusionId, is_fight = map_pet:get_is_fight_flag(ID, ObjectId, IsFight)};
to_pk_map_pet(ID, #map_pet{object_id = ObjectId, pet_id = PetId, pet_star = PetStar, pet_grade = PetGrade, pet_pos = PetPos, pet_sp_lv = SpLv, been_link_pet_cfg_id = BeLinkPetCfgID, illusion_id = Illusion, is_fight = IsFight}) ->
	case cfg_petGradeUp:getRow(PetId, PetGrade) of
		#petGradeUpCfg{upID = ShowPetId} ->
			#pk_map_pet{pet_object_id = ObjectId, pet_id = ShowPetId, pet_star = PetStar, pet_pos = PetPos, pet_sp_lv = SpLv, been_link_pet_cfg_id = BeLinkPetCfgID,
				transform_id = mapdb:getObjectTransFormInfo(ID, ObjectId), illusion_id = Illusion, is_fight = map_pet:get_is_fight_flag(ID, ObjectId, IsFight)};
		_ ->
			#pk_map_pet{pet_object_id = ObjectId, pet_id = PetId, pet_star = PetStar, pet_pos = PetPos, pet_sp_lv = SpLv, been_link_pet_cfg_id = BeLinkPetCfgID,
				transform_id = mapdb:getObjectTransFormInfo(ID, ObjectId), illusion_id = Illusion, is_fight = map_pet:get_is_fight_flag(ID, ObjectId, IsFight)}
	end;
to_pk_map_pet(ID, L) ->
	[to_pk_map_pet(ID, E) || E <- L].

sync_to_top(Uid) ->
	sync_to_top(Uid, ?FALSE).
sync_to_top(Uid, IsForce) ->
	case player:getLevel() =< 65 of
		?TRUE -> skip;
		_ ->
			PlayerId = player:getPlayerID(),
			case IsForce orelse lists:member(Uid, get_out_and_assist_pet_id_list(PlayerId)) of
				?TRUE ->
					Value = cal_pet_score(PlayerId),
					OutFightPets = lists:append([[PetCfgId, Star] || #pk_pet_info{pet_cfg_id = PetCfgId, star = Star} <- pet_new:get_fight_out_pet_show(0)]),
					top_chart_common:add_to_top_chart(?TopCharTypePetBv, PlayerId, Value, OutFightPets),
					carnival:on_add_to_top_list([{?Carnival_Type_PetScore, Value}]);
				_ -> skip
			end
	end,
	ok.

send_all_pet_attr() ->
	PlayerAttrList = attribute_player:get_player_attr(),
	PlayerPetAttr = get_player_pet_attr(PlayerAttrList),
	PetList = pet_new:get_pet_list(),
	PlayerId = player:getPlayerID(),
	F = fun(#pet_new{uid = Uid}) ->
		Attr = get_pet_attr(PlayerId, Uid, PlayerPetAttr),
		#pk_pet_prop{uid = Uid, prop_list = [#pk_BattleProp{index = Key, value = Value} || {Key, Value} <- Attr, Key > 0]}
		end,
	PetPropList = lists:map(F, PetList),
	Num = length(PetPropList),
	LimitNum = 200,
	case Num > LimitNum of
		?TRUE ->
			F2 = fun(_, Acc) ->
				{SendL, LeftL} = common:split(LimitNum, Acc),
				SendL =/= [] andalso player:send(#pk_GS2U_push_pet_prop{pet_prop_list = SendL}),
				LeftL
				 end,
			lists:foldl(F2, PetPropList, lists:seq(1, Num div LimitNum + 1));
		_ ->
			player:send(#pk_GS2U_push_pet_prop{pet_prop_list = PetPropList})
	end,

	ok.

save_pet_attr(Uid, Attr) ->
	Prop = #pk_pet_prop{uid = Uid, prop_list = [#pk_BattleProp{index = Key, value = Value} || {Key, Value} <- Attr, Key > 0]},
	player:send(#pk_GS2U_push_pet_prop{pet_prop_list = [Prop]}).

%% 评分
cal_pet_score() ->
	cal_pet_score(player:getPlayerID()).
cal_pet_score(PlayerId) ->
	%% 出战评分计算
	OutFightPets = [Pet || {Pet, _Pos} <- get_out_fight_pets(PlayerId)],
	OutFightPetIds = [Uid || #pet_new{uid = Uid} <- OutFightPets],
	SkillScore = get_pet_skill_fight(OutFightPetIds, PlayerId),
	BaseAttrScore = lists:sum([cal_pet_base_attr_score(PlayerId, Pet) || Pet <- OutFightPets]),
	SpecialAttrScore = lists:sum([cal_pet_special_attr_score(PlayerId, Pet) || Pet <- OutFightPets]),
	Score = SkillScore + BaseAttrScore + SpecialAttrScore,
	%% 助战评分计算
	AssistPets = get_assist_pets(PlayerId),
	AssistScore = lists:sum([cal_assist_pet_attr_score(PlayerId, Pet) || Pet <- AssistPets]),
	trunc(Score + AssistScore).

cal_single_pet_score(Pet) ->
	cal_single_pet_score(Pet, ?TRUE).
cal_single_pet_score(Pet, IsShared) ->
	PlayerId = player:getPlayerID(),
	SkillScore = get_pet_skill_fight([Pet#pet_new.uid], PlayerId),
	BaseAttrScore = cal_pet_base_attr_score(PlayerId, Pet, IsShared),
	SpecialAttrScore = cal_pet_special_attr_score(PlayerId, Pet, IsShared),

	trunc(SkillScore + BaseAttrScore + SpecialAttrScore).

cal_pet_base_attr_score(PlayerId, #pet_new{uid = Uid} = Pet) ->
	cal_pet_base_attr_score(PlayerId, #pet_new{uid = Uid} = Pet, ?TRUE).
cal_pet_base_attr_score(PlayerId, #pet_new{uid = Uid} = Pet, IsShared) ->
	AttrList = get_pet_attr(PlayerId, Uid, [], ?FALSE, IsShared),
	{BaseFight, _, _} = attribute_player:calc_battle_value_global([{Type + ?PET_INDEX_START, V} || {Type, V} <- AttrList, lists:member(Type, [1, 3, 4, 5])], {0, 0, 0}),
	LinkPet = pet_soul:link_pet(PlayerId, Pet),
	SSBreakLv = pet_shengshu:shared_pet_break_lv(LinkPet, pet_new:get_pet_list(), pet_shengshu:get_pet_guard(), pet_shengshu:get_pet_pos_list()), %% TODO 按玩家进程处理的，其他进程要用的话需要处理下
	#petBreakCfg{fightScaler = FixScale} = cfg_petBreak:getRow(SSBreakLv),
	BaseFight * FixScale / 10000 * cfg_globalSetup:mCZZScoreCoef() / 10000.

cal_pet_special_attr_score(PlayerId, #pet_new{uid = Uid}) ->
	cal_pet_special_attr_score(PlayerId, #pet_new{uid = Uid}, ?TRUE).
cal_pet_special_attr_score(PlayerId, #pet_new{uid = Uid}, IsShared) ->
	AttrList = get_pet_attr(PlayerId, Uid, [], ?FALSE, IsShared),
	{BaseFight, _, _} = attribute_player:calc_battle_value_global([{Type + ?PET_INDEX_START, V} || {Type, V} <- AttrList, not lists:member(Type, [1, 3, 4, 5])], {0, 0, 0}),
	BaseFight * cfg_globalSetup:mCZZFightCoef() / 10000 * cfg_globalSetup:mCZZScoreCoef() / 10000.

cal_assist_pet_attr_score(PlayerId, #pet_new{uid = Uid, pet_cfg_id = PetCfgId} = Pet) ->
	AttrList = get_pet_attr_assist(PlayerId, Uid, []),
	#pet_new{star = Star} = LinkPet = pet_soul:link_pet(PlayerId, Pet),
	SSBreakLv = pet_shengshu:shared_pet_break_lv(LinkPet, pet_new:get_pet_list(), pet_shengshu:get_pet_guard(), pet_shengshu:get_pet_pos_list()), %% TODO 按玩家进程处理的，其他进程要用的话需要处理下
	#petBreakCfg{fightScaler = FixScale} = cfg_petBreak:getRow(SSBreakLv),
	{BaseFight, _, _} = attribute_player:calc_battle_value_global([{Type + ?PET_INDEX_START, V} || {Type, V} <- AttrList, lists:member(Type, [1, 3, 4, 5])], {0, 0, 0}),
	#petStarCfg{fightScaler = StarScale} = cfg_petStar:getRow(PetCfgId, Star),
	BaseFight * FixScale / 10000 * StarScale / 10000 * cfg_globalSetup:mCZZScoreCoef() / 10000.


get_pet_skill_fight(PetIds, PlayerId) ->
	F2 = fun(Uid) ->
		[get_skill_score(SkillType, SkillId) || {SkillType, SkillId, _} <- get_pet_skill(Uid, PlayerId)]
		 end,
	lists:sum(lists:flatten(lists:map(F2, PetIds))).

calc_pet_wash_aptitude(Pet) ->
	#pet_new{pet_cfg_id = PetCfgId, wash = QualWash} = Pet,
	#petBaseCfg{qualBase = QualBase} = cfg_petBase:getRow(PetCfgId),
	trunc(lists:sum([Value || {_, Value} <- common:listValueMerge(get_qual_wash(QualWash, QualBase))])).