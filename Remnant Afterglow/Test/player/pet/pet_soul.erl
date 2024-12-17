%%%-------------------------------------------------------------------
%%% @author admin
%%% @copyright (C) 2022, <COMPANY>
%%% @doc
%%%		宠物幻兽
%%% @end
%%% Created : 08. 7月 2022 16:24
%%%-------------------------------------------------------------------
-module(pet_soul).
-author("admin").

-include("cfg_heroSubstitute1.hrl").
-include("cfg_heroSubstitute2.hrl").
-include("cfg_heroSubstitute3.hrl").
-include("cfg_petBase.hrl").
-include("record.hrl").
-include("error.hrl").
-include("variable.hrl").
-include("reason.hrl").
-include("cfg_item.hrl").
-include("netmsgRecords.hrl").
-include("cfg_globalSetupText.hrl").
-include("db_table.hrl").
-include("cfg_petStar.hrl").
-include("skill_new.hrl").
-include("pet_new.hrl").
-include("time_limit_gift_define.hrl").
-include("recharge_gift_packs.hrl").

-define(TYPE_SOUL_WAR, [4]).
-define(STAR_MIN, 6).

%% API
-export([pet_link/2, cancel_pet_link/2, pet_appendage/2, cancel_pet_appendage/2, get_skill_list/2, sync_link_pet/1, check_is_soul/1, link_pet/2, get_sp_type/1, get_pet_link_uid/1]).

%% 战魂链接
pet_link(Uid, TargetUid) -> ?metrics(begin
										 try
											 ?CHECK_THROW(is_link_func_open(), ?ERROR_FunctionClose),
											 Soul = pet_new:get_pet(Uid),
											 Pet = pet_new:get_pet(TargetUid),
											 ?CHECK_THROW(Soul =/= {} andalso Pet =/= {}, ?ErrorCode_Pet_No),
%%										检测是宠物还是战魂
											 ?CHECK_THROW(check_is_soul(Soul), ?ERROR_Param),
											 IsSpecialLink = get_sp_type(Soul) =:= 3 andalso get_trans_type(Pet) =:= 1,
											 ?CHECK_THROW(not(check_is_soul(Pet)) orelse IsSpecialLink, ?ERROR_Param),
%%										检测宠物是否链接，是否主动附灵
											 ?CHECK_THROW(check_link(Soul), ?ErrorCode_PetSoul_Linked),
											 ?CHECK_THROW(check_has_been_link(Pet), ?ErrorCode_PetSoul_Linked),
											 ?CHECK_THROW(check_appendage(Soul), ?ErrorCode_PetSoul_Appendage),
											 ?CHECK_THROW(Pet#pet_new.star >= ?STAR_MIN orelse IsSpecialLink, ?ErrorCode_PetSoul_StarNotEnough),
											 FightPet = Pet#pet_new.fight_flag,
											 FightSoul = Soul#pet_new.fight_flag,
%%										不能同时出战或助战
											 ?CHECK_THROW(FightPet =:= 0 orelse FightSoul =:= 0, ?ErrorCode_PetSoul_FightCantLink),
											 ?CHECK_THROW(check_sp_type(Soul, Pet), ?ErrorCode_PetPosOn),
											 NewPet = Pet#pet_new{
												 been_link_uid = Uid
											 },
											 NewSoul = Soul#pet_new{
												 link_uid = TargetUid
											 },
											 pet_new:update_pet(NewPet),
											 pet_new:update_pet(NewSoul),
											 Soul#pet_new.been_link_uid > 0 andalso player:send(#pk_GS2U_pet_update{pets = [pet_new:make_pet_msg(pet_new:get_pet(Soul#pet_new.been_link_uid))]}),
											 pet_battle:calc_player_add_fight(),
											 pet_base:save_pet_sys_attr_by_uid([Uid, TargetUid]),
											 pet_base:refresh_pet_and_skill([Soul#pet_new.been_link_uid || Soul#pet_new.been_link_uid > 0] ++ [Uid, TargetUid]),
											 player:send(#pk_GS2U_PetLinkRet{uid = Uid, target_uid = TargetUid}),
											 recharge_gift_packs:on_open_condition_change([?RechargeGiftPacksCond_PetStar]),
											 time_limit_gift:check_open(?TimeLimitType_PetStar),
											 ok
										 catch Err ->
											 player:send(#pk_GS2U_PetLinkRet{uid = Uid, target_uid = TargetUid, error_code = Err})
										 end
									 end).
%% 取消链接
cancel_pet_link(Uid, TargetUid) ->
	cancel_pet_link(Uid, TargetUid, ?TRUE).
cancel_pet_link(Uid, TargetUid, IsCost) -> ?metrics(begin
														try
															?CHECK_THROW(is_link_func_open(), ?ERROR_FunctionClose),
															Soul = pet_new:get_pet(Uid),
															Pet = pet_new:get_pet(TargetUid),
															?CHECK_THROW(Soul =/= {} andalso Pet =/= {}, ?ErrorCode_Pet_No),
															IsSpecialLink = get_sp_type(Soul) =:= 3 andalso get_trans_type(Pet) =:= 1,
															?CHECK_THROW(check_is_soul(Soul), ?ERROR_Param),
															?CHECK_THROW(not(check_is_soul(Pet)) orelse IsSpecialLink, ?ERROR_Param),
%%												链接是否存在
															PetLinkedId = Pet#pet_new.been_link_uid,
															SoulLinkId = Soul#pet_new.link_uid,
															case PetLinkedId =:= Uid andalso SoulLinkId =:= TargetUid of
																?TRUE -> skip;
																?FALSE -> throw(?ERROR_Param)
															end,
															NewPet = Pet#pet_new{
																been_link_uid = 0
															},
															NewSoul = Soul#pet_new{
																link_uid = 0
															},
%%												取消链接的消耗
															case IsCost of
																?TRUE ->
																	CostList = df:getGlobalSetupValueList(petRelieveNeed1, [{0, 200}]),
																	DelErr = currency:delete(CostList, ?Reason_PetCancelLink),
																	?ERROR_CHECK_THROW(DelErr);
																?FALSE -> ok
															end,
%%												修改宠物信息
															pet_new:update_pet(NewSoul),
															pet_new:update_pet(NewPet),
															Soul#pet_new.been_link_uid > 0 andalso player:send(#pk_GS2U_pet_update{pets = [pet_new:make_pet_msg(pet_new:get_pet(Soul#pet_new.been_link_uid))]}),
															pet_battle:calc_player_add_fight(),
															pet_base:save_pet_sys_attr_by_uid([Uid, TargetUid]),
															pet_base:refresh_pet_and_skill([Soul#pet_new.been_link_uid || Soul#pet_new.been_link_uid > 0] ++ [Uid, TargetUid]),
															player:send(#pk_GS2U_CancelPetLinkRet{uid = Uid, target_uid = TargetUid}),
															Soul#pet_new.been_link_uid > 0 andalso cancel_pet_link(Soul#pet_new.been_link_uid, Uid, ?FALSE)
														catch Err ->
															player:send(#pk_GS2U_CancelPetLinkRet{uid = Uid, target_uid = TargetUid, error_code = Err})
														end
													end).

%% 宠物附灵
pet_appendage(Uid, TargetUid) -> ?metrics(begin
											  try
%%											 功能开启
												  ?CHECK_THROW(is_appendage_func_open(), ?ERROR_FunctionClose),
%%											 宠物非空
												  ?CHECK_THROW(Uid =/= TargetUid, ?ErrorCode_PetSoul_CanNotAppendageSelf),
												  Soul = pet_new:get_pet(Uid),
												  Pet = pet_new:get_pet(TargetUid),
												  ?CHECK_THROW(Soul =/= {} andalso Pet =/= {}, ?ErrorCode_Pet_No),
												  ?CHECK_THROW(check_is_soul(Soul), ?ERROR_Param),
												  ?CHECK_THROW(check_appendage(Soul), ?ErrorCode_PetSoul_Appendage),
												  ?CHECK_THROW(check_has_been_appendage(Pet), ?ErrorCode_PetSoul_Appendage),
												  ?CHECK_THROW(check_link(Soul), ?ErrorCode_PetSoul_Linked),
%%											  检测要主动附灵的幻兽的出战情况，
												  ?CHECK_THROW(Soul#pet_new.fight_flag =:= 0, ?ErrorCode_PetSoul_Fight),
												  NewPet = Pet#pet_new{
													  been_appendage_uid = Uid
												  },
												  NewSoul = Soul#pet_new{
													  appendage_uid = TargetUid
												  },
												  pet_new:update_pet(NewSoul),
												  pet_new:update_pet(NewPet),
												  pet_base:refresh_pet_and_skill([Uid, TargetUid]),
												  player:send(#pk_GS2U_PetAppendageRet{uid = Uid, target_uid = TargetUid})
											  catch Err ->
												  player:send(#pk_GS2U_PetAppendageRet{uid = Uid, target_uid = TargetUid, error_code = Err})
											  end
										  end).


%% 取消宠物附灵
cancel_pet_appendage(Uid, TargetUid) -> ?metrics(begin
													 try
														 ?CHECK_THROW(is_appendage_func_open(), ?ERROR_FunctionClose),
														 Soul = pet_new:get_pet(Uid),
														 Pet = pet_new:get_pet(TargetUid),
														 ?CHECK_THROW(Soul =/= {} andalso Pet =/= {}, ?ErrorCode_Pet_No),
														 ?CHECK_THROW(Soul#pet_new.fight_flag =:= 0, ?ErrorCode_PetSoul_Fight),
														 ?CHECK_THROW(check_is_soul(Soul), ?ERROR_Param),
%%												链接是否存在
														 PetAppendageId = Pet#pet_new.been_appendage_uid,
														 SouAppendageId = Soul#pet_new.appendage_uid,
														 case PetAppendageId =:= Uid andalso SouAppendageId =:= TargetUid of
															 ?TRUE -> skip;
															 ?FALSE -> throw(?ERROR_Param)
														 end,
														 NewPet = Pet#pet_new{
															 been_appendage_uid = 0
														 },
														 NewSoul = Soul#pet_new{
															 appendage_uid = 0
														 },
%%												取消链接的消耗
														 CostList = df:getGlobalSetupValueList(petRelieveNeed2, [{0, 200}]),
														 DelErr = currency:delete(CostList, ?Reason_PetCancelAppendage),
														 ?ERROR_CHECK_THROW(DelErr),
%%												修改宠物信息
														 pet_new:update_pet(NewSoul),
														 pet_new:update_pet(NewPet),
														 pet_base:refresh_pet_and_skill([Uid, TargetUid]),
														 player:send(#pk_GS2U_CancelPetAppendageRet{uid = Uid, target_uid = TargetUid})
													 catch Err ->
														 player:send(#pk_GS2U_CancelPetAppendageRet{uid = Uid, target_uid = TargetUid, error_code = Err})
													 end
												 end).



is_link_func_open() ->
	variable_world:get_value(?WorldVariant_Switch_PetLink) =:= 1 andalso guide:is_open_action(?OpenAction_PetLink).

is_appendage_func_open() ->
	variable_world:get_value(?WorldVariant_Switch_PetAppendage) =:= 1 andalso guide:is_open_action(?OpenAction_PetAppendage).
%% 检测是宠物还是战魂
check_is_soul(Pet) ->
	PetBase = cfg_petBase:getRow(Pet#pet_new.pet_cfg_id),
	case PetBase of
		{} -> ?FALSE;
		_ -> lists:member(PetBase#petBaseCfg.elemType, ?TYPE_SOUL_WAR)
	end.

%% 获取技能
get_skill_list(PetUid, PlayerId) ->
	%% 升星技能+宠物装备技能
	case PlayerId == player:getPlayerID() of
		?TRUE ->
			get_pet_skill(PetUid);
		_ ->
			get_pet_skill(PetUid, PlayerId)
	end.
get_pet_skill(PetUid) ->
	case lists:keyfind(PetUid, #pet_new.uid, pet_new:get_pet_list()) of
		#pet_new{pet_cfg_id = PetCfgID, been_appendage_uid = BaUid, been_link_uid = LinkUid} = Pet ->
			PlayerID = player:getPlayerID(),
			#pet_new{star = Star} = link_pet(PlayerID, Pet),
			BaSkill = case BaUid of
						  0 -> [];
						  _ -> case pet_new:get_pet(BaUid) of
								   #pet_new{pet_cfg_id = CfgID, appendage_uid = PetUid} ->
									   case cfg_petBase:getRow(CfgID) of
										   #petBaseCfg{addSoulSkill = SoulSkill} ->
											   SoulSkill;
										   _ ->
											   ?LOG_ERROR("PetCfg Error:~p", [CfgID]),
											   []
									   end;
								   _ ->
									   ?LOG_ERROR("PetSoul Not Exist:~p", [BaUid]),
									   []
							   end
					  end,
			LinkSkill = case LinkUid of
							0 -> [];
							_ -> case pet_new:get_pet(LinkUid) of
									 #pet_new{pet_cfg_id = CfgID1, link_uid = PetUid} ->
										 case cfg_petStar:getRow(CfgID1, Star) of
											 #petStarCfg{} = StarCfg ->
												 PetBaseCfg = cfg_petBase:getRow(PetCfgID),
												 LinkIllusionSkill = [E || E <- pet_illusion:get_pet_skill(PlayerID, LinkUid), lists:member(element(3, E), [?SkillPos_689, ?SkillPos_694])
													 orelse (element(3, E) =:= ?SkillPos_13 andalso get_trans_type(CfgID1) =:= 0 andalso get_trans_type(PetCfgID) =:= 1)],
												 lists:foldl(fun({T, P, SkillType, SkillId, SkillIndex, _}, Ret) ->
													 case T of
														 0 ->
															 common:getTernaryValue(lists:member(SkillIndex, [?SkillPos_689, ?SkillPos_690, ?SkillPos_691, ?SkillPos_692, ?SkillPos_693]) andalso PetBaseCfg#petBaseCfg.transType =/= 1, [{SkillType, SkillId, SkillIndex} | Ret], Ret);
														 1 ->
															 common:getTernaryValue(Star >= P andalso lists:member(SkillIndex, [?SkillPos_689, ?SkillPos_690, ?SkillPos_691, ?SkillPos_692, ?SkillPos_693]) andalso PetBaseCfg#petBaseCfg.transType =/= 1, [{SkillType, SkillId, SkillIndex} | Ret], Ret);
														 2 ->
															 common:getTernaryValue(PetBaseCfg#petBaseCfg.transType =:= 1, [{SkillType, SkillId, SkillIndex} | Ret], Ret)
													 end
															 end, [], StarCfg#petStarCfg.skill) ++ LinkIllusionSkill;
											 _ ->
												 ?LOG_ERROR("cfg_petStar Error:~p", [CfgID1]),
												 []
										 end;
									 _ ->
										 ?LOG_ERROR("PetLink Not Exist:~p", [LinkUid]),
										 []
								 end
						end,
			BaSkill ++ LinkSkill ++ get_pet_passive_skill(LinkUid);
		_ -> []
	end.
%% 主要用于链接SP的SP提供被动属性技
get_pet_passive_skill(0) -> [];
get_pet_passive_skill(PetUid) ->
	case lists:keyfind(PetUid, #pet_new.uid, pet_new:get_pet_list()) of
		#pet_new{been_link_uid = LinkUid, star = Star} when LinkUid > 0 ->
			PassiveSkill = case pet_new:get_pet(LinkUid) of
							   #pet_new{pet_cfg_id = CfgID1, link_uid = PetUid} ->
								   case cfg_petStar:getRow(CfgID1, Star) of
									   #petStarCfg{} = StarCfg ->
										   lists:foldl(fun({T, P, SkillType, SkillId, SkillIndex, _}, Ret) ->
											   case T of
												   0 ->
													   common:getTernaryValue(lists:member(SkillIndex, [?SkillPos_690, ?SkillPos_693]), [{SkillType, SkillId, SkillIndex} | Ret], Ret);
												   1 ->
													   common:getTernaryValue(Star >= P andalso lists:member(SkillIndex, [?SkillPos_690, ?SkillPos_693]), [{SkillType, SkillId, SkillIndex} | Ret], Ret);
												   2 ->
													   common:getTernaryValue(lists:member(SkillIndex, [?SkillPos_690, ?SkillPos_693]), [{SkillType, SkillId, SkillIndex} | Ret], Ret)
											   end
													   end, [], StarCfg#petStarCfg.skill);
									   _ ->
										   ?LOG_ERROR("cfg_petStar Error:~p", [CfgID1]),
										   []
								   end;
							   _ ->
								   ?LOG_ERROR("PetLink Not Exist:~p", [LinkUid]),
								   []
						   end,
			PassiveSkill;
		_ -> []
	end.

%% 其他进程 获取宠物附灵技能
get_pet_skill(PetUid, PlayerId) ->
	case pet_new:get_pet(PlayerId, PetUid) of
		#pet_new{pet_cfg_id = PetCfgID, been_appendage_uid = BaUid, been_link_uid = LinkUid} = Pet ->
			#pet_new{star = Star} = link_pet(PlayerId, Pet),
			BaSkill = case BaUid of
						  0 -> [];
						  _ -> case table_player:lookup(db_pet_new, PlayerId, [BaUid]) of
								   [#db_pet_new{pet_cfg_id = CfgID, appendage_uid = PetUid} | _] ->
									   case cfg_petBase:getRow(CfgID) of
										   #petBaseCfg{addSoulSkill = SoulSkill} ->
											   SoulSkill;
										   _ ->
											   ?LOG_ERROR("PetCfg Error:~p", [CfgID]),
											   []
									   end;
								   _ ->
									   ?LOG_ERROR("PetSoul Not Exist:~p", [BaUid]),
									   []
							   end
					  end,
			LinkSkill = case LinkUid of
							0 -> [];
							_ -> case table_player:lookup(db_pet_new, PlayerId, [LinkUid]) of
									 [#db_pet_new{pet_cfg_id = CfgID1, link_uid = PetUid} | _] ->
										 case cfg_petStar:getRow(CfgID1, Star) of
											 #petStarCfg{} = StarCfg ->
												 PetBaseCfg = cfg_petBase:getRow(PetCfgID),
												 LinkIllusionSkill = [E || E <- pet_illusion:get_pet_skill(PlayerId, LinkUid), lists:member(element(3, E), [?SkillPos_689, ?SkillPos_694])
													 orelse (element(3, E) =:= ?SkillPos_13 andalso get_trans_type(CfgID1) =:= 0 andalso get_trans_type(PetCfgID) =:= 1)],
												 lists:foldl(fun({T, P, SkillType, SkillId, SkillIndex, _}, Ret) ->
													 case T of
														 0 ->
															 common:getTernaryValue(lists:member(SkillIndex, [?SkillPos_689, ?SkillPos_690, ?SkillPos_691, ?SkillPos_692]) andalso PetBaseCfg#petBaseCfg.transType =/= 1, [{SkillType, SkillId, SkillIndex} | Ret], Ret);
														 1 ->
															 common:getTernaryValue(Star >= P andalso lists:member(SkillIndex, [?SkillPos_689, ?SkillPos_690, ?SkillPos_691, ?SkillPos_692]) andalso PetBaseCfg#petBaseCfg.transType =/= 1, [{SkillType, SkillId, SkillIndex} | Ret], Ret);
														 2 ->
															 common:getTernaryValue(PetBaseCfg#petBaseCfg.transType =:= 1, [{SkillType, SkillId, SkillIndex} | Ret], Ret)
													 end
															 end, [], StarCfg#petStarCfg.skill) ++ LinkIllusionSkill;
											 _ ->
												 ?LOG_ERROR("cfg_petStar Error:~p", [CfgID1]),
												 []
										 end;
									 _ ->
										 ?LOG_ERROR("PetLink Not Exist:~p", [BaUid]),
										 []
								 end
						end,
			BaSkill ++ LinkSkill ++ get_pet_passive_skill(LinkUid, PlayerId);
		_ -> []
	end.
get_pet_passive_skill(0, _PlayerId) -> [];
get_pet_passive_skill(PetUid, PlayerId) ->
	case table_player:lookup(db_pet_new, PlayerId, [PetUid]) of
		[#db_pet_new{been_appendage_uid = BaUid, been_link_uid = LinkUid, star = Star} | _] when LinkUid > 0 ->
			PassiveSkill = case table_player:lookup(db_pet_new, PlayerId, [LinkUid]) of
							   [#db_pet_new{pet_cfg_id = CfgID1, link_uid = PetUid} | _] ->
								   case cfg_petStar:getRow(CfgID1, Star) of
									   #petStarCfg{} = StarCfg ->
										   lists:foldl(fun({T, P, SkillType, SkillId, SkillIndex, _}, Ret) ->
											   case T of
												   0 ->
													   common:getTernaryValue(lists:member(SkillIndex, [?SkillPos_690, ?SkillPos_693]), [{SkillType, SkillId, SkillIndex} | Ret], Ret);
												   1 ->
													   common:getTernaryValue(Star >= P andalso lists:member(SkillIndex, [?SkillPos_690, ?SkillPos_693]), [{SkillType, SkillId, SkillIndex} | Ret], Ret);
												   2 ->
													   common:getTernaryValue(lists:member(SkillIndex, [?SkillPos_690, ?SkillPos_693]), [{SkillType, SkillId, SkillIndex} | Ret], Ret)
											   end
													   end, [], StarCfg#petStarCfg.skill);
									   _ ->
										   ?LOG_ERROR("cfg_petStar Error:~p", [CfgID1]),
										   []
								   end;
							   _ ->
								   ?LOG_ERROR("PetLink Not Exist:~p", [BaUid]),
								   []
						   end,
			PassiveSkill;
		_ -> []
	end.

%% 检测宠物是否主动链接
check_link(Pet) ->
	Pet#pet_new.link_uid =:= 0.
%% 检测宠物是否被链接
check_has_been_link(Pet) ->
	Pet#pet_new.been_link_uid =:= 0.
%% 检测宠物是否主动附灵
check_appendage(Pet) ->
	Pet#pet_new.appendage_uid =:= 0.

%% 检测宠物是否被附灵
check_has_been_appendage(Pet) ->
	Pet#pet_new.been_appendage_uid =:= 0.

%% 宠物提升评分的操作调用，同步链接幻兽的评分 在update 之后调用。
sync_link_pet(PetUid) ->
	sync_link_pet(pet_new:get_pet(PetUid), [], []).
sync_link_pet(#pet_new{been_link_uid = 0}, UidList, MsgList) ->
	UidList =/= [] andalso pet_base:refresh_pet_and_skill(UidList),
	MsgList =/= [] andalso player:send(#pk_GS2U_pet_update{pets = MsgList}),
	UidList;
sync_link_pet(#pet_new{been_link_uid = SoulUid}, UidList, MsgList) ->
	PetSoul = pet_new:get_pet(SoulUid),
	sync_link_pet(PetSoul, [SoulUid | UidList], [pet_new:make_pet_msg(PetSoul) | MsgList]).

link_pet(PlayerId, Pet) ->
	try
		#pet_new{link_uid = LinkUid, been_link_uid = BeenLinkUid} = Pet,
		case {LinkUid > 0, BeenLinkUid > 0} of
			%%		未连接
			{?FALSE, ?FALSE} ->
				Pet;
			%%		普通宠物
			{?FALSE, ?TRUE} ->
				Pet;
			%%		天神宠物
			{?TRUE, _} ->
				link_pet(PlayerId, pet_new:get_pet(PlayerId, LinkUid))
		end
	catch
		_Err ->
			Pet
	end.

check_sp_type(#pet_new{pet_cfg_id = PetCfgID}, #pet_new{uid = Uid, fight_flag = FightType, fight_pos = Pos}) ->
	case cfg_petBase:getRow(PetCfgID) of
		#petBaseCfg{sPType = SpType} when SpType =:= 1 orelse SpType =:= 3 ->
			Flag1 =
				case FightType =:= ?STATUS_FIGHT of
					?TRUE ->
						lists:all(fun(#pet_pos{uid = CheckUid, type = CheckType, pos = CheckPos}) ->
							case CheckType =:= ?STATUS_FIGHT andalso Pos =/= CheckPos andalso CheckUid > 0 andalso pet_new:get_pet(CheckUid) of
								#pet_new{been_link_uid = PosBeenLinkUid} when PosBeenLinkUid > 0 ->
									case pet_new:get_pet(PosBeenLinkUid) of
										#pet_new{pet_cfg_id = PetCfgID} -> ?FALSE;
										_ -> ?TRUE
									end;
								_ -> ?TRUE
							end
								  end, pet_pos:get_pet_pos_list());
					?FALSE -> ?TRUE
				end,

			DefPosList = pet_pos:get_pet_pos_def_list(),
			Flag1 andalso lists:all(fun({F, _T, P}) ->
				FightPosList = [{T_, P_, U_} || {{F_, T_, P_}, U_} <- DefPosList, F =:= F_],
				lists:all(fun({T_, P_, U_}) ->
					case T_ =:= ?STATUS_FIGHT andalso P_ =/= P andalso U_ > 0 andalso pet_new:get_pet(U_) of
						#pet_new{been_link_uid = DefPosBeenLinkUid} when DefPosBeenLinkUid > 0 ->
							case pet_new:get_pet(DefPosBeenLinkUid) of
								#pet_new{pet_cfg_id = PetCfgID} -> ?FALSE;
								_ -> ?TRUE
							end;
						_ -> ?TRUE
					end
						  end, FightPosList) end, [FTP || {FTP, U} <- DefPosList, Uid =:= U]);
		_ -> ?TRUE
	end.

get_sp_type(#pet_new{pet_cfg_id = PetCfgID}) ->
	get_sp_type(PetCfgID);
get_sp_type(PetCfgID) ->
	PetBase = cfg_petBase:getRow(PetCfgID),
	case PetBase of
		{} -> 0;
		_ -> PetBase#petBaseCfg.sPType
	end.

get_trans_type(#pet_new{pet_cfg_id = PetCfgID}) ->
	get_trans_type(PetCfgID);
get_trans_type(PetCfgID) ->
	PetBase = cfg_petBase:getRow(PetCfgID),
	case PetBase of
		{} -> 0;
		_ -> PetBase#petBaseCfg.transType
	end.

%%获取与对应英雄有链接的其他英雄
get_pet_link_uid(#pet_new{uid = Uid} = Pet) ->
	PlayerID = player:getPlayerID(),
	LinkUidList = case pet_soul:link_pet(PlayerID, Pet) of
					  #pet_new{been_link_uid = BeenLinkUid, uid = LinkUid} when BeenLinkUid =/= 0 ->
						  case pet_new:get_pet(BeenLinkUid) of
							  #pet_new{been_link_uid = BeenBeenLinkUid} when BeenBeenLinkUid =/= 0 ->
								  [BeenBeenLinkUid, BeenLinkUid, Uid, LinkUid];
							  _ -> [BeenLinkUid, Uid, LinkUid]
						  end;
					  _ -> [Uid]
				  end,
	lists:usort(LinkUidList).