%%%-------------------------------------------------------------------
%%% @author admin
%%% @copyright (C) 2022, <COMPANY>
%%% @doc
%%%  孵蛋流程
%%% @end
%%% Created : 14. 7月 2022 10:00
%%%-------------------------------------------------------------------
-module(pet_hatch).
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
-include("cfg_hatcheEggsBase.hrl").
-include("cfg_hatcheEggsReward.hrl").
-include("db_table.hrl").
-include("id_generator.hrl").
-include("player_task_define.hrl").
-include("cfg_hatcheEggs2Base.hrl").
-include("cfg_hatcheEggs2Reward.hrl").
-include("activity_new.hrl").

-record(pet_egg, {
	hatch_id = 0,
	hatch_time = 0,
	start_time = 0,
	end_time = 0,
	look_pet = 0,
	is_finish = 0, %% 0孵蛋未完成，1幼龙完成，2二期完成
	is_reward = 0,
	ac_list = [], %% {Id, QteType}
	ac_reward = []
}).

-define(HATCH2, 100). %% 孵化2期

%% API
-export([on_load/0, send_egg_info/0, start_hatch/1, hatch_look_after/2, complete_hatch/1]).
-export([on_tick/0, looking_pet_cost/2, looking_pet_trans/3, check_func_open/0, gm_complete_hatch/1, calc_google_push_time/1, has_egg/0]).
-export([on_egg_growth/0, on_add_energy/2, on_get_reward/0, on_hatch_complete2/0, on_reset/0, gm_hatch_end/0]).

%% TODO 完成孵化推送手机后台消息

%% 加载龙蛋信息
on_load() ->
	PlayerID = player:getPlayerID(),
	DBEggs = table_player:lookup(db_pet_egg, PlayerID),
	set_egg_list([db_eggs2eggs(DBEgg) || DBEgg <- DBEggs]),
	case get_egg_list() of
		[] ->
			put('is_first_open', 1);
		_ ->
			skip
	end.

on_reset() ->
	case get_egg() of
		#pet_egg{is_finish = 1, end_time = EndTime} = Egg ->
			case time:time() < EndTime of
				?TRUE ->
					PlayerId = player:getPlayerID(),
					check_ac_reward_send(PlayerId, Egg),
					update_egg(Egg#pet_egg{ac_list = [], ac_reward = []});
				_ -> skip
			end;
		_ -> skip
	end.

send_egg_info() ->
	case get_egg_list() of
		[] ->
			case check_func_open() of
				?TRUE ->
					player:send(#pk_GS2U_DragonEggFuncOpenRet{is_open = 1}),
					put('is_first_open', 0);
				?FALSE ->
					skip
			end;
		EggList ->
			case lists:all(fun(Egg) -> Egg#pet_egg.is_finish =:= 1 end, EggList) of
				?TRUE -> skip;
				?FALSE ->
					player:send(#pk_GS2U_DragonEggFuncOpenRet{is_open = 1}),
					put('is_first_open', 0)
			end,
			Msg = #pk_GS2U_DragonEggUpdateRet{eggs = [make_eggs_info(Egg) || Egg <- EggList]},
			player:send(Msg),
			case get_egg() of %% 只有进入了二期才发
				#pet_egg{is_finish = Finish, start_time = StartTime} = Egg2 when StartTime > 0 andalso Finish >= 1 orelse Finish =:= 2 ->
					player:send(make_hatch2_info(Egg2));
				_ -> skip
			end
	end.
%% 获取龙蛋
start_hatch(HatchId) -> ?metrics(begin
									 try
										 ?CHECK_THROW(check_func_open(), ?ERROR_FunctionClose),
										 HatchIdList = cfg_hatcheEggsReward:getKeyList(),
										 ?CHECK_THROW(lists:member(HatchId, HatchIdList), ?ERROR_Param),
										 ?CHECK_THROW(get_egg_list() =:= [], ?ErrorCode_PetHatch_EggIsExist),
										 HatchCfg = cfg_hatcheEggsBase:first_row(),
										 StartTime = time:time(),
										 Time5 = time:daytime5() + ?DayTick_Seconds * 1,
										 TimeOff1 = Time5 - StartTime,%%到第二天五点的时间，与总持续时间的最大值，作为持续时间
										 EndPersistTime = max(HatchCfg#hatcheEggsBaseCfg.persistTime, TimeOff1),
										 NewEgg = #pet_egg{
											 hatch_id = HatchId,
											 start_time = StartTime,
											 end_time = time:time_add(StartTime, EndPersistTime)
										 },
										 update_egg(NewEgg),
										 player:send(#pk_GS2U_GetDragonEggRet{egg_id = HatchId}),
										 player_task:refresh_task(?Task_Goal_ChooseDragonEgg),
										 ok
									 catch
										 Err ->
											 player:send(#pk_GS2U_GetDragonEggRet{egg_id = HatchId, error_code = Err})
									 end
								 end).

%% 宠物照看
hatch_look_after(HatchId, PetUid) -> ?metrics(begin
												  try
													  ?CHECK_THROW(check_func_open(), ?ERROR_FunctionClose),
													  HatchIdList = cfg_hatcheEggsReward:getKeyList(),
													  ?CHECK_THROW(lists:member(HatchId, HatchIdList), ?ERROR_Param),
													  Pet = pet_new:get_pet(PetUid),
													  ?CHECK_THROW(Pet =/= {}, ?ErrorCode_Pet_No),
													  ?CHECK_THROW(Pet#pet_new.hatch_id =:= 0, ?ErrorCode_PetHatch_PetIsLooking),
													  PetBase = cfg_petBase:getRow(Pet#pet_new.pet_cfg_id),
													  ?CHECK_THROW(PetBase =/= {}, ?ERROR_Cfg),
													  Egg = get_egg(HatchId),
													  ?CHECK_THROW(Egg =/= {}, ?ErrorCode_PetHatch_EggIsNotExist),
													  #pet_egg{start_time = OldStartTime, hatch_time = HatchTime} = Egg,
													  EggReward = cfg_hatcheEggsReward:getRow(HatchId),
													  ?CHECK_THROW(EggReward =/= {}, ?ERROR_Cfg),
													  HatchCfg = cfg_hatcheEggsBase:first_row(),
													  ?CHECK_THROW(HatchCfg =/= {}, ?ERROR_Cfg),
													  NewFastRatio = case lists:keyfind(PetBase#petBaseCfg.elemType, 1, EggReward#hatcheEggsRewardCfg.fastAcquire) of
																		 ?FALSE ->
																			 throw(?ErrorCode_PetHatch_PetCanNotAccelerate);
																		 R -> element(2, R)
																	 end,
													  {OldFastRatio, OldPet} = case Egg#pet_egg.look_pet of
																				   0 -> {0, {}};
																				   Uid ->
																					   LookPet = pet_new:get_pet(Uid),
																					   ?CHECK_THROW(LookPet =/= {}, ?ErrorCode_Pet_No),
																					   LookPetBase = cfg_petBase:getRow(LookPet#pet_new.pet_cfg_id),
																					   ?CHECK_THROW(LookPetBase =/= {}, ?ERROR_Cfg),
																					   case lists:keyfind(LookPetBase#petBaseCfg.elemType, 1, EggReward#hatcheEggsRewardCfg.fastAcquire) of
																						   ?FALSE ->
																							   throw(?ErrorCode_PetHatch_PetCanNotAccelerate);
																						   R1 ->
																							   {element(2, R1), LookPet}
																					   end
																			   end,
													  NowTime = time:time(),
													  ?CHECK_THROW(NowTime < Egg#pet_egg.end_time, ?ErrorCode_PetHatch_HatchComplete),
													  UseTime = (NowTime - OldStartTime) * (10000 + OldFastRatio) / 10000,
													  CompleteTime = HatchCfg#hatcheEggsBaseCfg.persistTime - UseTime - HatchTime,
													  ?CHECK_THROW(CompleteTime > 0, ?ERROR_Param),
													  FixCompleteTime = CompleteTime / (10000 + NewFastRatio) * 10000,
													  NewEgg = Egg#pet_egg{
														  hatch_time = Egg#pet_egg.hatch_time + UseTime,
														  start_time = NowTime,
														  end_time = time:time_add(NowTime, round(FixCompleteTime)),
														  look_pet = PetUid
													  },
													  NewPet = Pet#pet_new{hatch_id = HatchId},
													  update_egg(NewEgg),
													  pet_new:update_pet(NewPet),
%%													 原来照看的宠物照看修改
													  case OldPet of
														  #pet_new{} = P ->
															  pet_new:update_pet(P#pet_new{hatch_id = 0});
														  _ -> skip
													  end,
													  player:send(#pk_GS2U_LookAfterEggRet{egg_id = HatchId, pet_uid = PetUid})
												  catch Err ->
													  player:send(#pk_GS2U_LookAfterEggRet{egg_id = HatchId, pet_uid = PetUid, error_code = Err})
												  end

											  end).
%% 孵化完成
complete_hatch(HatchId) -> ?metrics(begin
										try
											?CHECK_THROW(check_func_open(), ?ERROR_FunctionClose),
											HatchIdList = cfg_hatcheEggsReward:getKeyList(),
											?CHECK_THROW(lists:member(HatchId, HatchIdList), ?ERROR_Param),
											Egg = get_egg(HatchId),
											?CHECK_THROW(Egg =/= {}, ?ErrorCode_PetHatch_EggIsNotExist),
											?CHECK_THROW(Egg#pet_egg.is_finish =:= 0, ?ErrorCode_PetHatch_HatchComplete),
											EggReward = cfg_hatcheEggsReward:getRow(HatchId),
											?CHECK_THROW(EggReward =/= {}, ?ERROR_Cfg),
											NowTime = time:time(),
											case NowTime >= Egg#pet_egg.end_time of
												?TRUE -> skip;
												?FALSE -> throw(?ERROR_UNKNOWN)
											end,
											NewEgg = Egg#pet_egg{
												is_finish = 1,
												look_pet = 0,
												start_time = 0,
												end_time = 0
											},
%%											TODO 发送其他奖励 有的话
											PetBase = cfg_petBase:getRow(EggReward#hatcheEggsRewardCfg.petID),
											?CHECK_THROW(PetBase =/= {}, ?ERROR_Cfg),
											ByEgg = case variable_world:get_value(?WorldVariant_Switch_PetHatch2) =:= 1 of%%检查是否 孵蛋2期后台是否开启，开启需要标识孵蛋来源
														?TRUE -> 1;
														_ -> 0
													end,
											Pet = #pet_new{
												uid = id_generator:generate(?ID_TYPE_MY_PET),
												pet_cfg_id = EggReward#hatcheEggsRewardCfg.petID,
												star = EggReward#hatcheEggsRewardCfg.petStar,
												pet_lv = 1,
												grade = PetBase#petBaseCfg.rareType,
												get_by_egg = ByEgg,
												wash = pet_base:get_base_wash_attr(EggReward#hatcheEggsRewardCfg.petID)
											},
											NewPet = Pet#pet_new{},
											update_egg(NewEgg),
											pet_new:update_pet(NewPet),
											pet_atlas:check_get(NewPet#pet_new.pet_cfg_id, NewPet#pet_new.star),
											guide:check_open_func(?OpenFunc_TargetType_Pet),
											activity_new_player:on_func_open_check(?ActivityOpenType_GetPet, {EggReward#hatcheEggsRewardCfg.petID}),
											pet_battle:send_pet_attr(player:getPlayerID(), Pet#pet_new.uid),
											player:send(#pk_GS2U_HatchCompleteRet{egg_id = HatchId, pet_uid = NewPet#pet_new.uid})
										catch Err ->
											player:send(#pk_GS2U_HatchCompleteRet{egg_id = HatchId, error_code = Err})
										end end).


%% 功能开启推送
on_tick() ->
	case get_egg_list() of
		[] ->
			case check_func_open() of
				?TRUE ->
					case get('is_first_open') of
						1 ->
							player:send(#pk_GS2U_DragonEggFuncOpenRet{is_open = 1}),
							put('is_first_open', 0);
						0 -> skip
					end;
				?FALSE -> skip
			end;
		_ ->
			skip
	end.


set_egg_list(Eggs) ->
	put('egg_list', Eggs).

get_egg_list() ->
	get('egg_list').

get_egg() ->
	case get_egg_list() of
		[#pet_egg{} = Egg | _] -> Egg;
		_ -> {}
	end.
get_egg(HatchID) ->
	EggList = get_egg_list(),
	case lists:keyfind(HatchID, #pet_egg.hatch_id, EggList) of
		#pet_egg{} = Egg -> Egg;
		_ -> {}
	end.


db_eggs2eggs(Db_Eggs) ->
	#pet_egg{
		hatch_id = Db_Eggs#db_pet_egg.hatch_id,
		hatch_time = Db_Eggs#db_pet_egg.hatch_time,
		start_time = Db_Eggs#db_pet_egg.start_time,
		end_time = Db_Eggs#db_pet_egg.end_time,
		look_pet = Db_Eggs#db_pet_egg.look_pet,
		is_finish = Db_Eggs#db_pet_egg.is_finish,
		is_reward = Db_Eggs#db_pet_egg.is_reward,
		ac_list = gamedbProc:dbstring_to_term(Db_Eggs#db_pet_egg.ac_list),
		ac_reward = gamedbProc:dbstring_to_term(Db_Eggs#db_pet_egg.ac_reward)
	}.

eggs2_db_eggs(Eggs) ->
	#db_pet_egg{
		player_id = player:getPlayerID(),
		hatch_id = Eggs#pet_egg.hatch_id,
		hatch_time = Eggs#pet_egg.hatch_time,
		start_time = Eggs#pet_egg.start_time,
		end_time = Eggs#pet_egg.end_time,
		look_pet = Eggs#pet_egg.look_pet,
		is_finish = Eggs#pet_egg.is_finish,
		is_reward = Eggs#pet_egg.is_reward,
		ac_list = gamedbProc:term_to_dbstring(Eggs#pet_egg.ac_list),
		ac_reward = gamedbProc:term_to_dbstring(Eggs#pet_egg.ac_reward)
	}.

make_eggs_info(Eggs) ->
	#pk_egg_info{
		egg_id = Eggs#pet_egg.hatch_id,
		start_time = Eggs#pet_egg.start_time,
		end_time = Eggs#pet_egg.end_time,
		look_pet = Eggs#pet_egg.look_pet,
		is_finish = Eggs#pet_egg.is_finish
	}.

update_egg(Egg) ->
	table_player:insert(db_pet_egg, eggs2_db_eggs(Egg)),
	EggList = get_egg_list(),
	NewEggList = lists:keystore(Egg#pet_egg.hatch_id, #pet_egg.hatch_id, EggList, Egg),
	set_egg_list(NewEggList),
	player:send(make_hatch_info(Egg)).
%% 二期开始多一个协议
update_egg2(Egg) ->
	table_player:insert(db_pet_egg, eggs2_db_eggs(Egg)),
	EggList = get_egg_list(),
	NewEggList = lists:keystore(Egg#pet_egg.hatch_id, #pet_egg.hatch_id, EggList, Egg),
	set_egg_list(NewEggList),
	player:send(make_hatch2_info(Egg)).

make_hatch_info(Egg) ->
	#pk_GS2U_DragonEggUpdateRet{eggs = [make_eggs_info(Egg)]}.
make_hatch2_info(Egg) ->
	#pk_GS2U_hatch_info{eggs = [make_eggs_info(Egg)], is_reward = is_ac_reward(Egg), ac_list = [I || {I, _} <- Egg#pet_egg.ac_list]}.

is_ac_reward(#pet_egg{ac_list = AcList0, ac_reward = AcReward}) ->
	AcList = [I || {I, _} <- AcList0],
	LastReward = AcList -- AcReward,
	case LastReward of
		[] -> 0;
		_ -> 1
	end;
is_ac_reward(_) -> 0.

%% 功能开启
check_func_open() ->
	NowOnlineTime = (player:getPlayerProperty(#player.onlineTime)) + (time:time()) - (player:getPlayerProperty(#player.logintime)),
	HatchCfg = cfg_hatcheEggsBase:first_row(),
	is_func_open() andalso NowOnlineTime >= HatchCfg#hatcheEggsBaseCfg.openTime.

%% 宠物照看时被消耗掉
looking_pet_cost(PetCfgId, HatchId) -> ?metrics(begin
													try
														?CHECK_THROW(check_func_open(), ?ERROR_FunctionClose),
														HatchIdList = cfg_hatcheEggsReward:getKeyList(),
														?CHECK_THROW(lists:member(HatchId, HatchIdList), ?ERROR_Param),
														OldPetBase = cfg_petBase:getRow(PetCfgId),
														?CHECK_THROW(OldPetBase =/= {}, ?ERROR_Cfg),
														Egg = get_egg(HatchId),
														?CHECK_THROW(Egg =/= {}, ?ErrorCode_PetHatch_EggIsNotExist),
														#pet_egg{start_time = OldStartTime, hatch_time = HatchTime} = Egg,
														EggReward = cfg_hatcheEggsReward:getRow(HatchId),
														?CHECK_THROW(EggReward =/= {}, ?ERROR_Cfg),
														HatchCfg = cfg_hatcheEggsBase:first_row(),
														NewFastRatio = 0,
														OldFastRatio = case lists:keyfind(OldPetBase#petBaseCfg.elemType, 1, EggReward#hatcheEggsRewardCfg.fastAcquire) of
																		   ?FALSE ->
																			   throw(?ErrorCode_PetHatch_PetCanNotAccelerate);
																		   R1 -> element(2, R1)
																	   end,
														NowTime = time:time(),
														?CHECK_THROW(NowTime < Egg#pet_egg.end_time, ?ErrorCode_PetHatch_HatchComplete),
														UseTime = (NowTime - OldStartTime) * (10000 + OldFastRatio) / 10000,
														CompleteTime = HatchCfg#hatcheEggsBaseCfg.persistTime - UseTime - HatchTime,
														?CHECK_THROW(CompleteTime > 0, ?ERROR_Param),
														FixCompleteTime = CompleteTime / (10000 + NewFastRatio) * 10000,
														NewEgg = Egg#pet_egg{
															hatch_time = Egg#pet_egg.hatch_time + UseTime,
															start_time = NowTime,
															end_time = time:time_add(NowTime, round(FixCompleteTime)),
															look_pet = 0
														},
														update_egg(NewEgg),
														player:send(#pk_GS2U_LookAfterEggRet{egg_id = HatchId, pet_uid = 0})
													catch Err ->
														player:send(#pk_GS2U_LookAfterEggRet{egg_id = HatchId, pet_uid = 0, error_code = Err})
													end

												end).

%% 宠物照看时被高星转换为了 其他系别宠物
looking_pet_trans(OldPetCfgId, PetUid, HatchId) -> ?metrics(begin
																try

																	?CHECK_THROW(check_func_open(), ?ERROR_FunctionClose),
																	HatchIdList = cfg_hatcheEggsReward:getKeyList(),
																	?CHECK_THROW(lists:member(HatchId, HatchIdList), ?ERROR_Param),
																	Pet = pet_new:get_pet(PetUid),
																	?CHECK_THROW(Pet =/= {}, ?ErrorCode_Pet_No),
																	NewPetBase = cfg_petBase:getRow(Pet#pet_new.pet_cfg_id),
																	?CHECK_THROW(NewPetBase =/= {}, ?ERROR_Cfg),
																	Egg = get_egg(HatchId),
																	?CHECK_THROW(Egg =/= {}, ?ErrorCode_PetHatch_EggIsNotExist),
																	?CHECK_THROW(Egg#pet_egg.look_pet =:= PetUid, ?ERROR_Param),
																	OldPetBase = cfg_petBase:getRow(OldPetCfgId),
																	?CHECK_THROW(OldPetBase =/= {}, ?ERROR_Cfg),
																	case Pet#pet_new.pet_cfg_id =:= OldPetCfgId of
																		?TRUE -> skip;
																		?FALSE ->
																			#pet_egg{start_time = OldStartTime, hatch_time = HatchTime} = Egg,
																			EggReward = cfg_hatcheEggsReward:getRow(HatchId),
																			?CHECK_THROW(EggReward =/= {}, ?ERROR_Cfg),
																			HatchCfg = cfg_hatcheEggsBase:first_row(),
																			NewFastRatio = case lists:keyfind(NewPetBase#petBaseCfg.elemType, 1, EggReward#hatcheEggsRewardCfg.fastAcquire) of
																							   ?FALSE ->
																								   throw(?ERROR_Param);
																							   R -> element(2, R)
																						   end,
																			OldFastRatio = case lists:keyfind(OldPetBase#petBaseCfg.elemType, 1, EggReward#hatcheEggsRewardCfg.fastAcquire) of
																							   ?FALSE ->
																								   throw(?ERROR_Param);
																							   R1 ->
																								   element(2, R1)
																						   end,
																			NowTime = time:time(),
																			?CHECK_THROW(NowTime < Egg#pet_egg.end_time, ?ErrorCode_PetHatch_HatchComplete),
																			UseTime = (NowTime - OldStartTime) * (10000 + OldFastRatio) / 10000,
																			CompleteTime = HatchCfg#hatcheEggsBaseCfg.persistTime - UseTime - HatchTime,
																			?CHECK_THROW(CompleteTime > 0, ?ERROR_Param),
																			FixCompleteTime = CompleteTime / (10000 + NewFastRatio) * 10000,
																			NewEgg = Egg#pet_egg{
																				hatch_time = Egg#pet_egg.hatch_time + UseTime,
																				start_time = NowTime,
																				end_time = time:time_add(NowTime, round(FixCompleteTime))
																			},
																			update_egg(NewEgg),
																			player:send(#pk_GS2U_LookAfterEggRet{egg_id = HatchId, pet_uid = PetUid})
																	end
																catch Err ->
																	player:send(#pk_GS2U_LookAfterEggRet{egg_id = HatchId, pet_uid = PetUid, error_code = Err})
																end

															end).

is_func_open() ->
	variable_world:get_value(?WorldVariant_Switch_PetHatch) =:= 1 andalso guide:is_open_action(?OpenAction_PetHatch).
is_func_open2() ->
	variable_world:get_value(?WorldVariant_Switch_PetHatch2) =:= 1 andalso guide:is_open_action(?OpenAction_PetHatch2).


%% 计算推送时间
calc_google_push_time(PlayerId) ->
	try

		EggList = table_player:lookup(db_pet_egg, PlayerId),
		Egg = case EggList of
				  [] -> throw(0);
				  [Eg | _T] -> Eg
			  end,
		case Egg#db_pet_egg.is_finish >= 1 of
			?TRUE ->
				throw(0);
			?FALSE ->
				skip
		end,
		EndTime = Egg#db_pet_egg.end_time,
		EndTime
	catch
		T -> T

	end.


%% gm孵化完成
gm_complete_hatch(HatchId) -> ?metrics(begin
										   try
											   ?CHECK_THROW(check_func_open(), ?ERROR_FunctionClose),
											   Egg = get_egg(HatchId),
											   ?CHECK_THROW(Egg =/= {}, ?ErrorCode_PetHatch_EggIsNotExist),
											   ?CHECK_THROW(Egg#pet_egg.is_finish =:= 0, ?ErrorCode_PetHatch_HatchComplete),
											   EggReward = cfg_hatcheEggsReward:getRow(HatchId),
											   ?CHECK_THROW(EggReward =/= {}, ?ERROR_Cfg),
											   NewEgg = Egg#pet_egg{end_time = time:time()},
											   update_egg(NewEgg)
										   catch
											   Err -> ?LOG_ERROR("gm_complete_hatch Err:~p", [Err])
										   end end).

has_egg() -> get_egg_list() =/= [].

%% 开始二期孵蛋
on_egg_growth() ->
	try
		?CHECK_THROW(is_func_open2(), ?ERROR_FunctionClose),
		Egg = get_egg(),
		?CHECK_THROW(Egg =/= {}, ?ErrorCode_PetHatch_EggIsNotExist),
		?CHECK_THROW(Egg#pet_egg.is_finish =:= 1, ?ErrorCode_PetHatch_HatchComplete),
		CfgBase = cfg_hatcheEggsReward:getRow(Egg#pet_egg.hatch_id),
		?CHECK_CFG(CfgBase),
		Cfg2 = cfg_hatcheEggs2Base:getRow(CfgBase#hatcheEggsRewardCfg.petID),
		?CHECK_CFG(Cfg2),
		update_egg2(Egg#pet_egg{hatch_time = 0, start_time = time:time(), end_time = time:time_add(time:time(), Cfg2#hatcheEggs2BaseCfg.persistTime), look_pet = 0}),
		player:send(#pk_GS2U_EggGrowth{error_code = ?ERROR_OK})
	catch
		Err -> player:send(#pk_GS2U_EggGrowth{error_code = Err})
	end.

%% 点亮龙晶加速
on_add_energy(Id, Type) ->
	try
		?CHECK_THROW(is_func_open2(), ?ERROR_FunctionClose),
		Egg = get_egg(),
		?CHECK_THROW(Egg =/= {}, ?ErrorCode_PetHatch_EggIsNotExist),
		#pet_egg{end_time = EndTime, ac_list = AcList} = Egg,
		?CHECK_THROW(lists:keyfind(Id, 1, AcList) =:= ?FALSE, ?ErrorCode_PetHatch_AcOn),
		Cfg = cfg_hatcheEggs2Reward:getRow(Id),
		?CHECK_CFG(Cfg),
		ActiveVal = daily_task:get_activity_value(),
		?CHECK_THROW(ActiveVal >= Cfg#hatcheEggs2RewardCfg.liveness, ?ErrorCode_PetHatch_ActiveVal),
		DecTime = case lists:keyfind(Type, 1, Cfg#hatcheEggs2RewardCfg.qTEFast) of
					  {Type, Time} -> Time;
					  _ -> throw(?ErrorCode_PetHatch_QTE)
				  end,
		update_egg2(Egg#pet_egg{end_time = time:time_add(EndTime, - DecTime), ac_list = [{Id, Type} | AcList]}),
		player:send(#pk_GS2U_hatch_add_energy{error_code = ?ERROR_OK, id = Id, type = Type})
	catch
		Err -> player:send(#pk_GS2U_hatch_add_energy{error_code = Err, id = Id, type = Type})
	end.

%% 获取龙晶奖励
on_get_reward() ->
	try
		?CHECK_THROW(is_func_open2(), ?ERROR_FunctionClose),
		Egg = get_egg(),
		?CHECK_THROW(Egg =/= {}, ?ErrorCode_PetHatch_EggIsNotExist),
		#pet_egg{ac_list = AcList, ac_reward = RewardList} = Egg,
		{Item, Coin, NewRewardList} = calc_ac_reward(AcList, RewardList),
		update_egg2(Egg#pet_egg{ac_reward = NewRewardList}),
		player_item:reward(Item, [], Coin, ?REASON_pet_hatch2Active),
		player_item:show_get_item_dialog(Item, Coin, [], 0),
		player:send(#pk_GS2U_hatch_reward{error_code = ?ERROR_OK})
	catch
		Err -> player:send(#pk_GS2U_hatch_reward{error_code = Err})
	end.

calc_ac_reward(AcList, RewardList) ->
	lists:foldl(fun({Id, Qte}, {ItemAcc, CoinAcc, ReAcc}) ->
		case lists:member(Id, RewardList) of
			?TRUE -> {ItemAcc, CoinAcc, ReAcc};
			_ -> %% False
				Cfg = cfg_hatcheEggs2Reward:getRow(Id),
				?CHECK_CFG(Cfg),
				Item = [{I, N} || {Q, T, I, N} <- Cfg#hatcheEggs2RewardCfg.qTEGift, Q =:= Qte, T =:= 1],
				Coin = [{I, N} || {Q, T, I, N} <- Cfg#hatcheEggs2RewardCfg.qTEGift, Q =:= Qte, T =:= 2],
				{Item ++ ItemAcc, Coin ++ CoinAcc, [Id | ReAcc]}
		end end, {[], [], RewardList}, AcList).

%% 二期孵蛋完成
on_hatch_complete2() ->
	try
		?CHECK_THROW(is_func_open2(), ?ERROR_FunctionClose),
		Egg = get_egg(),
		?CHECK_THROW(Egg =/= {}, ?ErrorCode_PetHatch_EggIsNotExist),
		#pet_egg{end_time = EndTime, is_finish = Finish} = Egg,
		?CHECK_THROW(time:time() >= EndTime andalso EndTime =/= 0 andalso Finish =:= 1, ?ErrorCode_PetHatch_NotEnd),
		CfgBase = cfg_hatcheEggsReward:getRow(Egg#pet_egg.hatch_id),
		?CHECK_CFG(CfgBase),
		Cfg2 = cfg_hatcheEggs2Base:getRow(CfgBase#hatcheEggsRewardCfg.petID),
		?CHECK_CFG(Cfg2),
		#hatcheEggs2BaseCfg{iD = OldPetCfgId, petID = NewPetCfgId} = Cfg2,
		NewPetCfg = cfg_petBase:getRow(NewPetCfgId),
		?CHECK_CFG(NewPetCfg),
		Pet = pet_new:get_one_cfg_pet(OldPetCfgId),
		?CHECK_THROW(Pet =/= {}, ?ErrorCode_PetNotExist),
		PlayerId = player:getPlayerID(),
		check_ac_reward_send(PlayerId, Egg),
		SharedPetBase = pet_base:get_base_wash_attr(OldPetCfgId), %% 继承资质
		AddWash = pet_base:compare_attr(SharedPetBase, Pet#pet_new.wash),
		PetBase = pet_base:get_base_wash_attr(NewPetCfgId),
		NewWash = pet_base:merge_wash_attr(PetBase, AddWash),
		NewPetObject = Pet#pet_new{pet_cfg_id = NewPetCfgId, wash = NewWash, grade = NewPetCfg#petBaseCfg.rareType, get_by_egg = 0},
		pet_new:update_pet(NewPetObject),
		pet_atlas:check_get(NewPetCfgId, Pet#pet_new.star),
		guide:check_open_func(?OpenFunc_TargetType_Pet),
		activity_new_player:on_func_open_check(?ActivityOpenType_GetPet, {NewPetCfgId}),
		pet_base:refresh_pet_and_skill([Pet#pet_new.uid]),
		update_egg2(Egg#pet_egg{is_finish = 2, start_time = 0, end_time = 0, ac_list = [], ac_reward = []}),
		player:send(#pk_GS2U_HatchComplete2{error_code = ?ERROR_OK, pet_uid = Pet#pet_new.uid, new_pet_uid = Pet#pet_new.uid})
	catch
		Err -> player:send(#pk_GS2U_HatchComplete2{error_code = Err})
	end.

gm_hatch_end() ->
	try
		Egg = get_egg(),
		?CHECK_THROW(Egg =/= {}, ?ErrorCode_PetHatch_EggIsNotExist),
		update_egg2(Egg#pet_egg{end_time = time:time()})
	catch
		_ -> skip
	end.

check_ac_reward_send(PlayerId, Egg) ->
	#pet_egg{ac_list = AcList, ac_reward = RewardList} = Egg,
	{Item, Coin, _} = calc_ac_reward(AcList, RewardList), %% 点亮龙晶没领的奖励要发邮件
	case Item =:= [] andalso Coin =:= [] of
		?TRUE -> skip;
		_ ->
			Language = language:get_player_language(PlayerId),
			mail:send_mail(#mailInfo{
				player_id = PlayerId,
				title = language:get_server_string("DragonGift01", Language),
				describe = language:get_server_string("DragonGift02", Language),
				itemList = [#itemInfo{itemID = I, num = N} || {I, N} <- common:listValueMerge(Item)],
				coinList = [#coinInfo{type = I, num = N} || {I, N} <- common:listValueMerge(Coin)],
				attachmentReason = ?REASON_pet_hatch2Active
			})
	end.
