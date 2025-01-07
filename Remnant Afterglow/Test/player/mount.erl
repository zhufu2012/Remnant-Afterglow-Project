%%%-------------------------------------------------------------------
%%% @author cbfan
%%% @copyright (C) 2018, <COMPANY>
%%% @doc
%%%               玩家坐骑
%%% @end
%%% Created : 07. 七月 2018 13:44
%%%-------------------------------------------------------------------
-module(mount).
-author("cbfan").

-include("cfg_mountBaseNew.hrl").
-include("cfg_mountStarNew.hrl").
-include("cfg_mountStarAttrNew.hrl").
-include("cfg_mountLevelNew.hrl").
-include("cfg_mountExpItemNew.hrl").
-include("cfg_mountBreakNew.hrl").
-include("cfg_mountAwakenNew.hrl").
-include("cfg_mountSublimateNew.hrl").
-include("cfg_mountJiBanNew2.hrl").
-include("cfg_mountEqpOpenNew.hrl").
-include("cfg_mountSkillOpenNew.hrl").
-include("cfg_mountSkillOpensNew.hrl").
-include("cfg_mountSkillMakeNew.hrl").
-include("cfg_mountPillAttrNew.hrl").
-include("cfg_mountPillNew.hrl").
-include("cfg_mountSoulLvNew.hrl").
-include("cfg_mountEquip.hrl").
-include("cfg_mountEqpStr.hrl").
-include("cfg_mntSkillMkCostNew.hrl").
-include("cfg_mountEqpBre.hrl").
-include("netmsgRecords.hrl").
-include("record.hrl").
-include("logger.hrl").
-include("item.hrl").
-include("error.hrl").
-include("db_table.hrl").
-include("reason.hrl").
-include("variable.hrl").
-include("skill_new.hrl").
-include("attribute.hrl").
-include("attainment.hrl").
-include("seven_gift_define.hrl").
-include("cfg_item.hrl").
-include("player_task_define.hrl").
-include("cfg_skillBase.hrl").
-include("time_limit_gift_define.hrl").
-include("cfg_equipScoreIndex.hrl").
-include("activity_new.hrl").
-include("cfg_mountReincarnation.hrl").
-include("cfg_mountElementAwaken.hrl").
-include("cfg_mountSoulExpItemNew.hrl").
-include("prophecy.hrl").
-include("cfg_mountUniversalBit.hrl").
-include("cfg_mountSoulBreak.hrl").
-include("cfg_mountEquipStar.hrl").
-include("mount.hrl").
%% API
%%-export([]).

-export([on_item_use_add/2, gm_set_sl_level/2, gm_add_mount_lv/2, gm_add_mount_star/2, gm_add_mount_awaken/2]).
-export([on_load/0, send_all_info/0, on_tick/0, get_mount_list/0]).
-export([on_mount_add_star/2, on_mount_add_lv/2, on_mount_break/1, on_mount_sublimate/1, on_mount_rein/1, on_mount_ele_awaken/2, on_auto_level_up/1]).
-export([on_fetter_active/2, on_shouling_pill/3, on_shouling_add_lv/2, on_shouling_auto_add_lv/1]).
-export([on_skill_p_put_on/4, on_skill_p_put_off/2]).
-export([get_now_used_mount/1]).
-export([get_param_for_attainment/2]).
-export([get_shouling_lv/0]).
-export([on_function_open/1, on_open_skill_box/2]).
-export([on_skill_t_slot_active/2, on_skill_t_make/2, on_mount_equip/3, on_lock_index/3, on_skill_t_off/2]).
-export([get_prop/1, get_max_speed/0, get_mount_speed/2, on_mount_awaken/2, get_count_lv/1,
	get_count_sublimate/1, get_count_awaken/1, get_count/0, get_count2/0, get_star_count_rare/1, is_mount_active/1, get_rein_list/0,
	is_skill_box_open/2, is_skill_t_box_open/1, get_MountID_list/0, get_count_break/1, get_count_star/1, get_sl_skill_p_equip/0, get_count_all_lv/0]).
-export([get_mount_num_rare/1]).
-export([get_skill_list/1,
	get_count_rare/1]).
-export([mount_lv_star_card/1, get_star/1, get_attr/2, get_prop_common/0, get_mirror_star/2, get_mirror_attr/3]).
-export([check_all_mount_rein/0, auto_open_skill_box/1, auto_equip/1, any_mount_lv_up/0, any_mount_break/0, on_shouling_break/1, on_soul_lv_award/2]).
-export([calc_shouling_prop/1, put_prop/0, update_shouling/3, get_shouling/1]).
-export([get_mount_star_cost/2]).
%%%===================================================================
%%% API
%%%===================================================================
on_load() ->
	?metrics(begin
				 PlayerId = player:getPlayerID(),
				 %%	加载所有的坐骑
				 load_mount(PlayerId),
				 %%	加载羁绊信息
				 load_fetter(PlayerId),
				 %%	加载兽灵
				 load_shouling(PlayerId),
				 %%  加载兽灵装备
				 mount_eq:load_shouling_eq(PlayerId),
				 %%  计算属性
				 calc_prop(),
				 ok
			 end).

%% GM设置兽灵等级
gm_set_sl_level(RoleIndex, Lv) ->
	OrderRoleList = role_data:get_order_role_list(),
	{_, Role} = lists:keyfind(RoleIndex, 1, OrderRoleList),
	case get_shouling(Role#role.role_id) of
		#shouling{} = M ->
			update_shouling(Role#role.role_id, M#shouling{lv = Lv}, ?TRUE);
		_ -> ok
	end.

%% GM设置坐骑等级
gm_add_mount_lv(MountId, Lv) ->
	case get_mount(MountId) of
		#mount{} = Mount ->
			CfgList = cfg_mountBreakNew:rows(),
			IdList = [Cfg#mountBreakNewCfg.iD || Cfg <- CfgList, Cfg#mountBreakNewCfg.maxLv >= Lv],
			BreakLv =
				case IdList of
					[] -> lists:max(cfg_mountBreakNew:getKeyList());
					_ -> lists:min(IdList)
				end,
			NewMount = Mount#mount{
				level = Lv,
				break_lv = BreakLv
			},
			update_mount(NewMount);
		_ -> ok
	end.

%% GM设置坐骑星级
gm_add_mount_star(MountId, Lv) ->
	case get_mount(MountId) of
		#mount{} = Mount ->
			NewMount = Mount#mount{
				star = Lv
			},
			update_mount(NewMount);
		_ -> ok
	end.

%% GM设置坐骑觉醒
gm_add_mount_awaken(MountId, Lv) ->
	case get_mount(MountId) of
		#mount{} = Mount ->
			NewMount = Mount#mount{
				awaken_lv = Lv
			},
			update_mount(NewMount);
		_ -> ok
	end.

on_item_use_add(_, 0) -> skip;
on_item_use_add(#itemCfg{useParam1 = MountId, useParam2 = IsTimeLimit, useParam3 = TimeLimit} = ItemCfg, N) ->
	?metrics(begin
				 case cfg_mountBaseNew:getRow(MountId) of
					 #mountBaseNewCfg{consumeStar = ItemId} = BaseCfg ->
						 Mount = get_mount(MountId),%%仅限时和激活的，限时已过期当作未激活
						 NowTime = time:time(),
						 case Mount of
							 {} ->%%未激活过
								 case IsTimeLimit of%%永久激活
									 0 -> add_mount_1(MountId, BaseCfg);
									 _ ->
										 NewExpireTime = time:time_add(NowTime, TimeLimit * ?SECONDS_PER_MINUTE),
										 add_mount_1(MountId, BaseCfg, NewExpireTime)
								 end;
							 #mount{expire_time = 0} when IsTimeLimit =:= 0 ->%%已永久激活,返还碎片
								 StarCfg = get_mount_star_cfg(MountId, 0),
								 ?CHECK_CFG(StarCfg),
								 ItemList = [{ItemId, StarCfg#mountStarAttrNewCfg.needItem * N}],
								 bag_player:add(ItemList, ?REASON_mount_add_repeat),
								 player_item:show_duplicate(1, MountId, [], ItemList);
							 #mount{expire_time = 0} -> ok;%%已永久激活，但IsTimeLimit是限时激活 不管
							 #mount{expire_time = ExTime1} when ExTime1 > NowTime ->%%限时激活
								 case IsTimeLimit of
									 0 ->%%要永久激活
										 add_mount_1(MountId, BaseCfg);
									 1 ->%%要限时激活
										 NewExpireTime2 = time:time_add(ExTime1, TimeLimit * ?SECONDS_PER_MINUTE),
										 add_mount_1(MountId, BaseCfg, NewExpireTime2)
								 end;
							 _ -> ok
						 end,
						 on_item_use_add(ItemCfg, N - 1)
				 end end).

%% 功能开放
on_function_open(RoleIDList) ->
	?metrics(begin
				 lists:foreach(
					 fun(RoleID) ->
						 case get_shouling(RoleID) of
							 {} ->
								 NewSL = #shouling{},
								 update_shouling(RoleID, NewSL, ?TRUE),
								 auto_open_skill_box(RoleID);
							 _ -> ok
						 end
					 end, RoleIDList)
			 end).
%%	check_open_skill_box(RoleID, 1).

%% 上线同步
send_all_info() ->
	?metrics(begin send_all() end).

on_tick() ->
	case variable_world:get_value(?WorldVariant_Switch_Mount) =:= 1 andalso guide:is_open_action(?OpenAction_Mount) of
		?TRUE ->
			NowTime = time:time(),
			RoleId = player:getPlayerProperty(#player.leader_role_id),
			lists:foreach(fun
							  (#mount{mount_id = MountId, expire_time = ExpireTime}) ->%%限时激活
								  case ExpireTime =/= 0 andalso NowTime >= ExpireTime of
									  ?TRUE ->%%修改为过期，过期不激活，限时不激活
										  case role_data:get_role_element(RoleId, #role.mount_id) of
											  0 -> ok;
											  MountId ->%%正好是该坐骑，就卸下该坐骑 改成新的最高品质的坐骑  并且刷新速度
												  MountIDList = get_MountID_list(),%%仅永久和限时坐骑id列表
												  BestMountID = get_best_mount_id(MountIDList),%%选最高品质的
												  case BestMountID of
													  0 ->
														  role_data:set_role_property(RoleId, #role.mount_id, 0),
														  player_refresh:on_refresh_mount([RoleId]);
													  _ -> check_auto_equip(BestMountID)%%穿戴最好的
												  end,
												  player_refresh:on_refresh_mount_speed();
											  _ -> ok
										  end;
									  _ -> ok
								  end
						  end, get_mount_list());
		?FALSE -> ok
	end.

%% 升星  万能碎片 激活
on_mount_add_star(MountId, UseSpec) ->
	?metrics(begin
				 try
					 ?ERROR_CHECK_THROW(check_func_open()),
					 case get_mount(MountId) of
						 #mount{} = Mount ->
							 case get_expire_type(Mount) of
								 2 -> throw(?ErrorCode_mount_time_NoDevelop);%%限时，不能养成
								 _ -> add_star(Mount, UseSpec)%%已永久激活
							 end;
						 _ -> add_mount(MountId)
					 end,
					 constellation:refresh_skill(MountId),
					 player_refresh:on_refresh_mount_speed(),
					 RoleId = role_data:get_leader_id(),
					 case get_shouling(RoleId) of
						 {} -> ok;
						 SL ->
							 player:send(#pk_GS2U_ShoulingUpdate{sl = make_sl_msg(RoleId, SL)}),
							 case SL#shouling.skill_p of
								 [] -> skip;
								 SkillP ->
									 player:send(#pk_GS2U_ShoulingSkillUpdate{role_id = RoleId, skills = [#pk_ShoulingSkill{pos = P,
										 mount_id = MountId2, skill_idx = SkillID} || {P, MountId2, SkillID} <- SkillP]})
							 end,
							 case SL#shouling.skill_t of
								 [] -> skip;
								 SkillT ->
									 player:send(#pk_GS2U_ShoulingTSkillUpdate{role_id = RoleId, skills = [#pk_ShoulingSkill{pos = P,
										 mount_id = MountId2, skill_idx = Index, is_lock = IsLock} || {P, MountId2, Index, IsLock} <- SkillT]})
							 end
					 end,
					 player:send(#pk_GS2U_MountNewAddStarRet{mount_id = MountId, err_code = ?ERROR_OK})
				 catch
					 ErrCode ->
						 player:send(#pk_GS2U_MountNewAddStarRet{mount_id = MountId, err_code = ErrCode})
				 end
			 end).

%% 升级  有一键升级 由客户端计算消耗 将消耗结果发送
on_mount_add_lv(MountId, CostList) ->
	?metrics(begin mount_add_lv(MountId, CostList) end).

%% 突破 更新升级的上限
on_mount_break(MountId) ->
	?metrics(begin mount_break(MountId) end).

%% 羽化   羽化会影响打造的触发技能
on_mount_awaken(MountId, UseSpec) ->
	?metrics(begin mount_awaken(MountId, UseSpec) end).

%% 炼魂
on_mount_sublimate(MountId) ->
	?metrics(begin mount_sublimate(MountId) end).

%% 转生
on_mount_rein(MountId) ->
	?metrics(begin mount_rein(MountId) end).

%% 元素觉醒
on_mount_ele_awaken(MountID, Type) ->
	?metrics(begin mount_ele_awaken(MountID, Type) end).

%% 激活羁绊
on_fetter_active(FetterId, Lv) ->
	?metrics(begin fetter_active(FetterId, Lv) end).

%% 嗑丹
on_shouling_pill(RoleID, Index, Num) ->
	?metrics(begin shouling_pill(RoleID, Index, Num) end).

%% 兽灵升级
on_shouling_add_lv(RoleID, CostList) ->
	?metrics(begin shouling_add_lv(RoleID, CostList) end).

%% 开启技能格子
on_open_skill_box(RoleID, Pos) ->
	?metrics(begin
				 try
					 ?CHECK_THROW(role_data:is_role_exist(RoleID), ?ERROR_NoRole),
					 ?ERROR_CHECK_THROW(check_func_open()),
					 case cfg_mountSkillOpenNew:getRow(Pos) of
						 {} ->
							 throw(?ErrorCode_SL_BoxNotExist);
						 #mountSkillOpenNewCfg{needWay = NeedWay} ->
							 Err = check_open_skill_box(RoleID, Pos, NeedWay),
							 ?ERROR_CHECK_THROW(Err);
						 _ ->
							 throw(?ErrorCode_SL_CannotOpenBox)
					 end,

					 player:send(#pk_GS2U_ShoulingSkillBoxOpenRet{role_id = RoleID, pos = Pos})
				 catch
					 ErrCode ->
						 player:send(#pk_GS2U_ShoulingSkillBoxOpenRet{role_id = RoleID, err_code = ErrCode, pos = Pos})
				 end
			 end).

%% 技能镶嵌
on_skill_p_put_on(RoleID, Pos, MountId, SkillIndex) ->
	?metrics(begin skill_p_put_on(RoleID, Pos, MountId, SkillIndex) end).

%% 技能镶嵌
on_skill_p_put_off(RoleID, Pos) ->
	?metrics(begin skill_p_put_off(RoleID, Pos) end).

%% 触发技能格子开启
on_skill_t_slot_active(RoleID, Index) ->
	?metrics(begin skill_t_slot_active(RoleID, Index, ?TRUE) end).

%% 兽灵触发技能打造
on_skill_t_make(RoleID, LockIndex) ->
	?metrics(begin skill_t_make(RoleID, LockIndex) end).

on_mount_equip(RoleID, T, MountID) ->
	?metrics(begin
				 try
					 ?CHECK_THROW(role_data:is_role_exist(RoleID), ?ERROR_NoRole),
					 ?ERROR_CHECK_THROW(check_func_open()),
					 on_mount_equip_1(RoleID, T, MountID)
				 catch
					 ErrCode ->
						 player:send(#pk_GS2U_GenErrorNotify{errorCode = ErrCode})
				 end
			 end).

%% 正在骑的坐骑id
get_now_used_mount(RoleID) ->
	MountId = role_data:get_role_element(RoleID, #role.mount_id),
	case MountId of
		0 -> {0, 0};
		_ ->
			case get_mount(MountId) of
				{} -> {0, 0};
				#mount{star = Star} -> {MountId, Star}
			end
	end.

%% 最大移动速度
get_max_speed() ->
	Fun = fun(Mount, MaxSpeed) ->
		#mount{mount_id = ItemDataID, star = Star} = Mount,
		MountStarCfg = get_mount_star_cfg(ItemDataID, Star),
		case MountStarCfg =/= {} andalso MountStarCfg#mountStarAttrNewCfg.speed > MaxSpeed of
			?TRUE -> MountStarCfg#mountStarAttrNewCfg.speed;
			?FALSE -> MaxSpeed
		end
		  end,
	lists:foldl(Fun, 0, get_mount_list2()).

get_mount_speed(MountID, Star) ->
	case get_mount_star_cfg(MountID, Star) of
		#mountStarAttrNewCfg{speed = Speed} -> Speed;
		_ -> 0
	end.

%% 成就类
get_param_for_attainment(?Attainments_Type_MountLv, Param) ->
	length([1 || #mount{level = Lv} <- get_always_mount_list(), Lv =:= Param]);
get_param_for_attainment(?Attainments_Type_MountStar, Param) ->
	length([1 || #mount{star = Star} <- get_always_mount_list(), Star >= Param]);
get_param_for_attainment(?Attainments_Type_MountFeather, Param) ->
	length([1 || #mount{awaken_lv = P} <- get_always_mount_list(), P >= Param]);
get_param_for_attainment(?Attainments_Type_MountSublimate, Param) ->
	length([1 || #mount{sublimate_lv = P} <- get_always_mount_list(), P >= Param]);
get_param_for_attainment(?Attainments_Type_MountPill, Param) ->
	case get_shouling(role_data:get_leader_id()) of
		#shouling{pill1 = P1, pill2 = P2, pill3 = P3} ->
			case Param of
				1 -> P1;
				2 -> P2;
				3 -> P3;
				_ -> 0
			end;
		_ -> 0
	end;
get_param_for_attainment(?Attainments_Type_MountSoulLv, _Param) ->
	case get_shouling(role_data:get_leader_id()) of
		#shouling{lv = Lv} ->
			Lv;
		_ -> 0
	end;
get_param_for_attainment(?Attainments_Type_MountCount, Param) ->
	length([1 || #mount{mount_id = CfgId} <- get_always_mount_list(), (BaseCfg = cfg_mountBaseNew:getRow(CfgId)) =/= {}, BaseCfg#mountBaseNewCfg.rareType =:= Param]);
get_param_for_attainment(_, _Param) ->
	0.

get_count_lv(Level) ->
	length([1 || #mount{level = Lv} <- get_always_mount_list(), Lv >= Level]).
get_count_all_lv() ->
	lists:sum([Lv || #mount{level = Lv} <- get_always_mount_list()]).
get_count_break(Level) ->
	length([1 || #mount{break_lv = Lv} <- get_always_mount_list(), Lv >= Level]).
get_count_star(Star) ->
	length([1 || #mount{star = S} <- get_always_mount_list(), S >= Star]).
get_count_sublimate(Level) ->
	length([1 || #mount{sublimate_lv = P} <- get_always_mount_list(), P >= Level]).
get_count_awaken(Level) ->
	length([1 || #mount{awaken_lv = Lv} <- get_always_mount_list(), Lv >= Level]).
get_count() ->
	length(get_mount_list()).
get_count2() ->%%永久激活和限时激活都满足
	length(get_mount_list2()).
get_shouling_lv() ->
	case get_shouling(role_data:get_leader_id()) of
		#shouling{lv = Lv} ->
			Lv;
		_ -> 0
	end.
get_count_rare(Rare) ->
	IsRareType = fun(MountId) ->
		case cfg_mountBaseNew:getRow(MountId) of
			{} -> ?FALSE;
			Cfg -> Cfg#mountBaseNewCfg.rareType == Rare
		end
				 end,
	length([1 || #mount{mount_id = Id} <- get_always_mount_list(), IsRareType(Id)]).
get_star_count_rare(Rare) ->
	F = fun(MountId) ->
		case cfg_mountBaseNew:getRow(MountId) of
			#mountBaseNewCfg{rareType = R} -> R == Rare - 1;
			_ -> ?FALSE
		end
		end,
	lists:sum([S || #mount{mount_id = Id, star = S} <- get_always_mount_list(), Rare == 0 orelse F(Id)]).

%%成就系统-X翅膀转生 343
get_rein_list() -> ?metrics(begin
								length([1 || Mount <- get_always_mount_list(), Mount#mount.is_rein =:= 1]) end).

is_mount_active(MountID) ->
	case lists:keyfind(MountID, #mount.mount_id, get_always_mount_list()) of
		#mount{} -> ?TRUE;
		_ -> ?FALSE
	end.

is_skill_t_box_open(Pos) ->
	case get_shouling(role_data:get_leader_id()) of
		#shouling{skill_t_mask = Mask} -> Mask band (1 bsl Pos) =/= 0;
		_ -> ?FALSE
	end.
is_skill_t_box_open(RoleID, Pos) ->
	case get_shouling(RoleID) of
		#shouling{skill_t_mask = Mask} -> Mask band (1 bsl Pos) =/= 0;
		_ -> ?FALSE
	end.

get_MountID_list() ->
	MountList = get_mount_list2(),%%仅永久和限时的
	[Mount#mount.mount_id || Mount <- MountList].

%% 使用坐骑升级/升星卡
mount_lv_star_card(ItemCfg) ->
	?metrics(begin mount_lv_star_card_1(ItemCfg) end).

on_lock_index(RoleID, Index, TargetLock) ->
	?metrics(begin
				 try
					 ?CHECK_THROW(role_data:(RoleID), ?ERROR_NoRole),
					 ?ERROR_CHECK_THROW(check_func_is_role_existopen()),
					 SL =
						 case get_shouling(RoleID) of
							 #shouling{} = M -> M;
							 _ -> #shouling{}
						 end,
					 Skill_t = SL#shouling.skill_t,
					 {Index, SkillID, SkillIndex, Lock0} =
						 case lists:keyfind(Index, 1, Skill_t) of
							 ?FALSE ->
								 throw(?ErrorCode_SL_BoxNotExist);
							 S ->
								 S
						 end,
					 ?CHECK_THROW(Lock0 =/= TargetLock, ?ErrorCode_SL_AlreadyTargetLock),
					 NewSkill = {Index, SkillID, SkillIndex, TargetLock},
					 NewSkill_t = lists:keystore(Index, 1, Skill_t, NewSkill),
					 update_shouling(RoleID, SL#shouling{skill_t = NewSkill_t}, ?FALSE),
					 player:send(#pk_GS2U_ShoulingLockIndexRet{role_id = RoleID, index = Index, target_lock = TargetLock, err_code = ?ERROR_OK})
				 catch
					 ErrCode ->
						 player:send(#pk_GS2U_ShoulingLockIndexRet{role_id = RoleID, index = Index, target_lock = TargetLock, err_code = ErrCode})
				 end
			 end).

on_skill_t_off(RoleID, Pos) ->
	?metrics(begin
				 try
					 ?ERROR_CHECK_THROW(check_func_open()),
					 SL =
						 case get_shouling(RoleID) of
							 #shouling{} = M -> M;
							 _ -> #shouling{}
						 end,
					 Skill_t = SL#shouling.skill_t,
					 {Pos, _, _, _} =
						 case lists:keyfind(Pos, 1, Skill_t) of
							 ?FALSE ->
								 throw(?ErrorCode_SL_BoxNotExist);
							 S ->
								 S
						 end,
					 NewSkill = {Pos, 0, 0, 0},
					 NewSkill_t = lists:keystore(Pos, 1, Skill_t, NewSkill),
					 update_shouling(RoleID, SL#shouling{skill_t = NewSkill_t}, ?FALSE),
					 refresh_skill(),
					 player:send(#pk_GS2U_ShoulingSkill_T_off_Ret{role_id = RoleID, pos = Pos, err_code = ?ERROR_OK})
				 catch
					 ErrCode ->
						 player:send(#pk_GS2U_ShoulingSkill_T_off_Ret{role_id = RoleID, pos = Pos, err_code = ErrCode})
				 end
			 end).

check_all_mount_rein() ->
	MountList = get_always_mount_list(),
	lists:any(fun(Mount) ->
		ReinCfg = cfg_mountReincarnation:getRow(Mount#mount.mount_id),
		case ReinCfg of
			{} -> ?FALSE;
			_ ->
				check_cond(Mount, ReinCfg#mountReincarnationCfg.condition)
		end end, MountList).

auto_equip(RoleID) ->
	MountIDList = get_MountID_list(),
	UsedMountIDList =
		lists:foldl(
			fun(#role{mount_id = MountID}, Acc) ->
				case MountID of
					0 ->
						Acc;
					_ ->
						[MountID | Acc]
				end end, [], role_data:get_role_list()),
	RestMountIDList = MountIDList -- UsedMountIDList,
	case RestMountIDList of
		[] ->
			skip;
		_ ->
			BestMountID = get_best_mount_id(RestMountIDList),
			role_data:set_role_property(RoleID, #role.mount_id, BestMountID)
	end.

get_sl_skill_p_equip() ->
	lists:any(
		fun(RoleID) ->
			case get_shouling(RoleID) of
				{} ->
					?FALSE;
				#shouling{skill_p = SkillPList} ->
					length([1 || {_, MountId, _} <- SkillPList, MountId =/= 0]) > 0
			end
		end, role_data:get_all_role_id()).

on_auto_level_up(MountID) ->
	?metrics(begin
				 try
					 ?ERROR_CHECK_THROW(check_func_open()),
					 Mount = get_mount(MountID),
					 case get_expire_type(Mount) of
						 2 -> throw(?ErrorCode_mount_time_NoDevelop);%%限时，不能养成
						 _ -> ok
					 end,
					 case Mount =:= {} of ?FALSE -> skip; _ -> throw(?ERROR_Cfg) end,
					 #mount{level = Lv, exp = Exp, break_lv = BreakLv} = Mount,
					 BreakCfg = cfg_mountBreakNew:getRow(BreakLv),
					 ?CHECK_CFG(BreakCfg),
					 #mountBreakNewCfg{maxLv = MaxLv} = BreakCfg,
					 %% 坐骑等级不能超过当前突破等级的等级上限
					 ?CHECK_THROW(Lv < MaxLv, ?ErrorCode_Mount_LvMax),
					 %% 坐骑等级不能超过当前玩家等级
					 ?CHECK_THROW(Lv < player:getLevel(), ?ErrorCode_Mount_LvMax),

					 LvCfg = cfg_mountLevelNew:getRow(Lv),
					 ?CHECK_CFG(LvCfg),
					 #mountLevelNewCfg{exp = AllNeedExp} = LvCfg,

					 CostList = calc_mount_cost_list(lists:reverse(cfg_mountExpItemNew:getKeyList()), AllNeedExp - Exp),

					 F = fun({ItemId, Num}, Ret) ->
						 ExpItemCfg = cfg_mountExpItemNew:getRow(ItemId),
						 case ExpItemCfg =:= {} of ?FALSE -> skip; _ -> throw(?ERROR_Cfg) end,
						 ExpItemCfg#mountExpItemNewCfg.exp * Num + Ret
						 end,
					 AddExp = lists:foldl(F, 0, CostList),
					 case CostList =:= [] orelse AddExp =:= 0 of
						 ?FALSE -> skip; _ -> throw(?ErrorCode_Mount_addLv_NoCost)
					 end,

					 case bag_player:delete_prepare(CostList) of
						 {?ERROR_OK, P} ->
							 {NewLv, NewExp} = calc_mount_exp(MaxLv, Lv, Exp + AddExp),
							 #mountReincarnationCfg{levelMax = {OldMax, NewMax}} = cfg_mountReincarnation:getRow(MountID),
							 case Mount#mount.is_rein of
								 0 -> case NewLv > OldMax of ?FALSE -> skip; _ -> throw(?ErrorCode_Mount_LvMax) end;
								 _ -> case NewLv > NewMax of ?FALSE -> skip; _ -> throw(?ErrorCode_Mount_LvMax) end
							 end,

							 case NewLv > player:getLevel() orelse NewLv > BreakCfg#mountBreakNewCfg.maxLv of
								 ?FALSE -> skip;
								 _ -> throw(?ErrorCode_Mount_LvMax)
							 end,
							 bag_player:delete_finish(P, ?REASON_mount_add_lv),
							 NewMount = Mount#mount{
								 level = NewLv,
								 exp = NewExp
							 },
							 update_mount(NewMount),
							 calc_mount_prop(NewMount),
							 put_prop(),
							 [refresh_skill() || lists:member(MountID, [EqMountID || #role{mount_id = EqMountID} <- role_data:get_role_list()])],
							 attainment:check_attainment(?Attainments_Type_MountLv),
							 time_limit_gift:check_open(?TimeLimitType_MountLv),
							 seven_gift:check_task(?Seven_Type_MountLv),
							 player_task:refresh_task([?Task_Goal_MountLv, ?Task_Goal_MountAllLv]),
							 activity_new_player:on_active_condition_change(?SalesActivity_MountAddLv, 1),
							 log_mount_op(MountID, 1, lists:concat([Mount#mount.level, "(", Mount#mount.exp, ")"]), lists:concat([NewLv, "(", NewExp, ")"]));
						 {CostErr, _} -> throw(CostErr)
					 end,
					 player:send(#pk_GS2U_MountAutoAddLevelRet{mount_id = MountID, err_code = ?ERROR_OK})
				 catch
					 ErrCode ->
						 player:send(#pk_GS2U_MountAutoAddLevelRet{mount_id = MountID, err_code = ErrCode})
				 end
			 end).

on_shouling_auto_add_lv(RoleID) ->
	?metrics(begin
				 try
					 ?CHECK_THROW(role_data:is_role_exist(RoleID), ?ERROR_NoRole),
					 ?ERROR_CHECK_THROW(check_func_open()),
					 Shouling = case get_shouling(RoleID) of #shouling{} = M -> M; _ -> #shouling{} end,
					 #mountSoulBreakCfg{maxLv = MaxLv} = cfg_mountSoulBreak:getRow(Shouling#shouling.break_lv),
					 #shouling{lv = Lv0, exp = Exp} = Shouling,
					 ?CHECK_THROW(Lv0 < MaxLv, ?ErrorCode_SL_LvMax),
					 LvCfg = cfg_mountSoulLvNew:getRow(Lv0),
					 ?CHECK_CFG(LvCfg),
					 #mountSoulLvNewCfg{exp = AllNeedExp} = LvCfg,

					 CostList = calc_sl_cost_list(lists:reverse(cfg_mountSoulExpItemNew:getKeyList()), AllNeedExp - Exp),


					 F = fun({ItemId, Num}, Ret) ->
						 ExpItemCfg = cfg_mountSoulExpItemNew:getRow(ItemId),
						 case ExpItemCfg =:= {} of ?FALSE -> skip; _ -> throw(?ERROR_Cfg) end,
						 ExpItemCfg#mountSoulExpItemNewCfg.exp * Num + Ret
						 end,
					 AddExp = lists:foldl(F, 0, CostList),

					 case CostList =:= [] orelse AddExp =:= 0 of
						 ?FALSE -> skip; _ -> throw(?ErrorCode_Mount_addLv_NoCost)
					 end,

					 case bag_player:delete_prepare(CostList) of
						 {?ERROR_OK, P} ->
							 {NewLv, NewExp} = calc_shouling_exp(Shouling#shouling.lv, Shouling#shouling.exp + AddExp, MaxLv),
							 bag_player:delete_finish(P, ?REASON_Shouling_add_lv),
							 update_shouling(RoleID, Shouling#shouling{
								 lv = NewLv, exp = NewExp
%%					skill_t_mask = fix_skill_t_mask(cfg_mountSkillOpensNew:rows(), NewLv, Shouling#shouling.skill_t_mask)
							 }, ?TRUE),
							 time_limit_gift:check_open(?TimeLimitType_SLSkillTBoxOpen),
							 activity_new_player:on_active_condition_change(?SalesActivity_SLAddLv, 1),

							 OldLevel = Shouling#shouling.lv,
							 PlayerText = player:getPlayerText(),
							 [{First, Next} | _] = df:getGlobalSetupValueList(noticeRule39, [{50, 50}]),
							 F1 = fun(Lv) ->
								 marquee:sendChannelNotice(0, 0, mount_ShouLV,
									 fun(Language) ->
										 language:format(language:get_server_string("Mount_ShouLV", Language),
											 [PlayerText, Lv])
									 end)
								  end,
							 [F1(Lv) || Lv <- lists:seq(OldLevel, NewLv), Lv > OldLevel, Lv >= First, (Lv - First) rem Next =:= 0],

							 %% 检查开启技能格子
%%				case NewLv =/= Shouling#shouling.lv of
%%					?TRUE -> check_open_skill_box(RoleID, 1);
%%					?FALSE -> ok
%%				end,

							 log_mount_op(0, 8, lists:concat([Shouling#shouling.lv, "(", Shouling#shouling.exp, ")"]), lists:concat([NewLv, "(", NewExp, ")"]));
						 {CostErr, _} -> throw(CostErr)
					 end,
					 player:send(#pk_GS2U_ShoulingAutoAddLvRet{role_id = RoleID, add_exp = AddExp, err_code = ?ERROR_OK}),
					 calc_shouling_prop(RoleID),
					 put_prop(),
					 attainment:check_attainment(?Attainments_Type_MountSoulLv),
					 player_task:refresh_task(?Task_Goal_ShoulingLv),
					 seven_gift:check_task(?Seven_Type_ShouLingLv),
					 guide:check_open_func(?OpenFunc_TargetType_MountSoul),
					 genius:check_genius_effect(?Genius_OpenType_ShoulingLv)
				 catch
					 ErrCode ->
						 player:send(#pk_GS2U_ShoulingAutoAddLvRet{role_id = RoleID, add_exp = 0, err_code = ErrCode})
				 end
			 end).

any_mount_lv_up() ->%%永久激活的才算
	TotalExp =
		lists:foldl(
			fun(ItemID, Acc) ->
				ExpCfg = cfg_mountExpItemNew:getRow(ItemID),
				#mountExpItemNewCfg{exp = UnitExp} = ExpCfg,
				Amount = bag_player:get_item_amount(ItemID),
				UnitExp * Amount + Acc
			end, 0, cfg_mountExpItemNew:getKeyList()),
	lists:any(
		fun(#mount{level = Lv, exp = Exp}) ->
			case cfg_mountLevelNew:getRow(Lv) of
				#mountLevelNewCfg{exp = NeedExp} ->
					TotalExp >= (NeedExp - Exp);
				_ ->
					?FALSE
			end
		end, get_always_mount_list()).

any_mount_break() ->%%永久激活的才算
	lists:any(
		fun(#mount{break_lv = BreakLv}) ->
			case cfg_mountBreakNew:getRow(BreakLv + 1) of
				#mountBreakNewCfg{needItem = NeedItem} ->
					{Err, _} = bag_player:delete_prepare(NeedItem),
					Err =:= ?ERROR_OK;
				_ -> ?FALSE
			end
		end, get_always_mount_list()).

on_shouling_break(RoleID) ->
	try
		?CHECK_THROW(role_data:is_role_exist(RoleID), ?ERROR_NoRole),
		case variable_world:get_value(?WorldVariant_Switch_Shouling) == 1 andalso guide:is_open_action(?OpenAction_Shouling) of
			?TRUE -> ok;
			?FALSE -> throw(?ERROR_FunctionClose)
		end,
		Shouling = case get_shouling(RoleID) of #shouling{} = M -> M; _ -> #shouling{} end,
		NewBreakLv = Shouling#shouling.break_lv + 1,
		Cfg = cfg_mountSoulBreak:getRow(NewBreakLv),
		?CHECK_CFG(Cfg),
		#mountSoulBreakCfg{needItem = NeedItem, maxLv = NewMaxLv} = Cfg,
		{DecErr, DecPrepared} = bag_player:delete_prepare(NeedItem),
		?ERROR_CHECK_THROW(DecErr),
		bag_player:delete_finish(DecPrepared, ?REASON_Shouling_Break),
		{NewLv, NewExp} = calc_shouling_exp(Shouling#shouling.lv, Shouling#shouling.exp, NewMaxLv),
		update_shouling(RoleID, Shouling#shouling{break_lv = NewBreakLv, lv = NewLv, exp = NewExp}, ?TRUE),
		log_mount_op(0, 17, Shouling#shouling.break_lv, NewBreakLv),
		player:send(#pk_GS2U_ShoulingBreakRet{role_id = RoleID, err_code = ?ERROR_OK}),
		calc_shouling_prop(RoleID),
		put_prop()
	catch
		ErrCode -> player:send(#pk_GS2U_ShoulingBreakRet{role_id = RoleID, err_code = ErrCode})
	end.

on_soul_lv_award(RoleID, AwardLv) ->
	try
		?CHECK_THROW(role_data:is_role_exist(RoleID), ?ERROR_NoRole),
		case variable_world:get_value(?WorldVariant_Switch_Shouling) == 1 andalso guide:is_open_action(?OpenAction_Shouling) of
			?TRUE -> ok;
			?FALSE -> throw(?ERROR_FunctionClose)
		end,
		Shouling = case get_shouling(RoleID) of #shouling{} = M -> M; _ -> #shouling{} end,
		#shouling{lv = Lv, award_list = AwardList} = Shouling,
		?CHECK_THROW(Lv >= AwardLv andalso not lists:member(AwardLv, AwardList), ?ErrorCode_L_Award),
		LvCfg = cfg_mountSoulLvNew:getRow(AwardLv),
		?CHECK_CFG(LvCfg),
		#mountSoulLvNewCfg{mountIDNew = MountIdNew} = LvCfg,
		?CHECK_THROW(MountIdNew =/= [], ?ErrorCode_L_Award),
		ItemList = [{ItemId, Amount} || {1, ItemId, Amount} <- MountIdNew],
		CurrencyList = [{ItemId, Amount} || {2, ItemId, Amount} <- MountIdNew],
		update_shouling(RoleID, Shouling#shouling{award_list = [AwardLv | AwardList]}, ?TRUE),
		bag_player:add(ItemList, ?REASON_Shouling_Lv),
		currency:add(CurrencyList, ?REASON_Shouling_Lv),
		player_item:show_get_item_dialog(ItemList, CurrencyList, [], 0),
		player:send(#pk_GS2U_ShoulingLvAwardRet{role_id = RoleID, lv = AwardLv, err_code = ?ERROR_OK})
	catch
		Err ->
			player:send(#pk_GS2U_ShoulingLvAwardRet{role_id = RoleID, lv = AwardLv, err_code = Err})
	end.
%%%===================================================================
%%% Internal functions
%%%===================================================================

send_all() ->
	case get_mount_list() of%%所有坐骑列表
		[] -> skip;
		MountList ->
			player:send(#pk_GS2U_MountNewUpdate{mounts = [make_mount_msg(P) || P <- MountList]})
	end,

	lists:foreach(fun(RoleID) ->
		case get_shouling(RoleID) of
			{} -> ok;
			SL ->
				player:send(#pk_GS2U_ShoulingUpdate{sl = make_sl_msg(RoleID, SL)}),
				case SL#shouling.skill_p of
					[] -> skip;
					SkillP ->
						player:send(#pk_GS2U_ShoulingSkillUpdate{role_id = RoleID, skills = [#pk_ShoulingSkill{pos = P,
							mount_id = MountId, skill_idx = SkillID} || {P, MountId, SkillID} <- SkillP]})
				end,
				case SL#shouling.skill_t of
					[] -> skip;
					SkillT ->
						player:send(#pk_GS2U_ShoulingTSkillUpdate{role_id = RoleID, skills = [#pk_ShoulingSkill{pos = P,
							mount_id = MountId, skill_idx = Index, is_lock = IsLock} || {P, MountId, Index, IsLock} <- SkillT]})
				end,
				case SL#shouling.eqs of
					[] -> skip;
					Eqs ->
						player:send(#pk_GS2U_ShoulingEqUpdate{role_id = RoleID, eqs = [#pk_ShoulingEqPos{pos = P,
							uid = U, lv = L, break_lv = B} || {P, U, L, B} <- Eqs]})
				end
		end end, role_data:get_all_role_id()),

	case get_fetter_list() of
		[] -> skip;
		FL ->
			player:send(#pk_GS2U_MountNewFetterUpdate{wfs = [#pk_MountNewFetter{f_id = I, f_lv = V} || {I, V} <- FL]})
	end,
	case mount_eq:get_shouling_eq() of
		[] -> skip;
		MEqs ->
			player:send(#pk_GS2U_SLEqUpdate{eqs = [#pk_EqAddition{
				eq_Uid = Eq#eq_addition.eq_uid,
				cfg_id = Eq#eq_addition.cfg_id,
				rand_props = [#pk_RandProp{index = I, value = V, character = C, p_index = P} || {I, V, C, P} <- Eq#eq_addition.rand_prop]
			} || Eq <- MEqs]})
	end.

update_shouling(RoleID, Shouling, IsSync) ->
	table_player:insert(db_shouling, #db_shouling{
		player_id = player:getPlayerID(),
		role_id = RoleID,
		lv = Shouling#shouling.lv,
		exp = Shouling#shouling.exp,
		break_lv = Shouling#shouling.break_lv,
		skill_p = gamedbProc:term_to_dbstring(Shouling#shouling.skill_p),
		skill_t_mask = Shouling#shouling.skill_t_mask,
		skill_t = gamedbProc:term_to_dbstring(Shouling#shouling.skill_t),
		eqs = gamedbProc:term_to_dbstring(Shouling#shouling.eqs),
		pill1 = Shouling#shouling.pill1,
		pill2 = Shouling#shouling.pill2,
		pill3 = Shouling#shouling.pill3,
		award_list = gamedbProc:term_to_dbstring(Shouling#shouling.award_list)
	}),
	set_shouling(RoleID, Shouling),
	[player:send(#pk_GS2U_ShoulingUpdate{sl = make_sl_msg(RoleID, Shouling)}) || IsSync].

load_fetter(PlayerId) ->
	FetterList = table_player:lookup(db_mount_fetter, PlayerId),
	set_fetter_list([{FId, FLv} || #db_mount_fetter{fetter_id = FId, fetter_lv = FLv} <- FetterList]).
load_mount(PlayerId) ->
	DbMountList = table_player:lookup(db_mount, PlayerId),
	set_mount_list([db_mount2mount(DbMount) || DbMount <- DbMountList]).
load_shouling(PlayerId) ->
	[set_shouling(DbYL#db_shouling.role_id, #shouling{
		lv = DbYL#db_shouling.lv,
		exp = DbYL#db_shouling.exp,
		break_lv = DbYL#db_shouling.break_lv,
		skill_p = gamedbProc:dbstring_to_term(DbYL#db_shouling.skill_p),
		skill_t_mask = DbYL#db_shouling.skill_t_mask,
		skill_t = gamedbProc:dbstring_to_term(DbYL#db_shouling.skill_t),
		eqs = gamedbProc:dbstring_to_term(DbYL#db_shouling.eqs),
		pill1 = DbYL#db_shouling.pill1,
		pill2 = DbYL#db_shouling.pill2,
		pill3 = DbYL#db_shouling.pill3,
		award_list = gamedbProc:dbstring_to_term(DbYL#db_shouling.award_list)
	}) || DbYL <- table_player:lookup(db_shouling, PlayerId)].


%% 检查开启技能格子 way:1等级开放，2vip等级开放
%%check_open_skill_box(RoleID, Way) ->
%%	[check_open_skill_box(RoleID, Pos, Way) ||
%%		#mountSkillOpenNewCfg{iD = Pos, needWay = NeedWay} <- cfg_mountSkillOpenNew:rows(), NeedWay =:= Way].
check_open_skill_box(RoleID, Pos, _Way) ->
	try
		Shouling = case get_shouling(RoleID) of
					   {} -> #shouling{};
					   SL -> SL
				   end,
		case is_skill_box_open(RoleID, Pos) of
			?TRUE ->
				throw(?ErrorCode_SL_BoxAlreadyOpen);
			?FALSE ->
				Err = open_skill_box(RoleID, Pos, Shouling#shouling.lv),
				?ERROR_CHECK_THROW(Err)
		end,
		?ERROR_OK
	catch
		ErrCode -> ErrCode
	end.

open_skill_box(RoleID, Pos, Lv) ->
	try
		case cfg_mountSkillOpenNew:getRow(Pos) of
			#mountSkillOpenNewCfg{needWay = 1, mountLv = SLLv} ->
				case Lv >= SLLv of
					?TRUE ->
						Shouling = case get_shouling(RoleID) of
									   {} -> #shouling{};
									   SL -> SL
								   end,
						SkillBox = {Pos, 0, 0},
						NewSkillList = lists:keystore(Pos, 1, Shouling#shouling.skill_p, SkillBox),
						update_shouling(RoleID, Shouling#shouling{skill_p = NewSkillList}, ?FALSE),
						calc_shouling_prop(RoleID),
						put_prop(),
						player:send(#pk_GS2U_ShoulingSkillUpdate{role_id = RoleID, skills =
						[#pk_ShoulingSkill{pos = P, mount_id = MI, skill_idx = SI} || {P, MI, SI} <- NewSkillList]});
					?FALSE ->
						throw(?ErrorCode_SL_lvNotMeet)
				end;
			#mountSkillOpenNewCfg{needWay = 2, mountLv = VipLv, needItem = NeedItem} ->
				case vip:get_vip_lv() >= VipLv of
					?TRUE ->
						{ItemList, CoinList} = lists:foldl(
							fun({T, I, A}, {IL, CL}) ->
								case T of
									1 -> {[{I, A} | IL], CL};
									2 -> {IL, [{I, A} | CL]};
									_ -> {IL, CL}
								end
							end, {[], []}, NeedItem),
						Err = player:delete_cost(ItemList, CoinList, ?REASON_Shouling_open_skillbox),
						?ERROR_CHECK_THROW(Err),
						Shouling = case get_shouling(RoleID) of
									   {} -> #shouling{};
									   SL -> SL
								   end,
						SkillBox = {Pos, 0, 0},
						NewSkillList = lists:keystore(Pos, 1, Shouling#shouling.skill_p, SkillBox),
						update_shouling(RoleID, Shouling#shouling{skill_p = NewSkillList}, ?FALSE),
						calc_shouling_prop(RoleID),
						put_prop(),
						player:send(#pk_GS2U_ShoulingSkillUpdate{role_id = RoleID, skills =
						[#pk_ShoulingSkill{pos = P, mount_id = MI, skill_idx = SI} || {P, MI, SI} <- NewSkillList]});
					?FALSE ->
						throw(?ErrorCode_SL_VipLvNotEnough)
				end;
			{} ->
				throw(?ErrorCode_SL_BoxNotExist);
			_ ->
				throw(?ERROR_Cfg)
		end,
		?ERROR_OK
	catch
		ErrCode -> ErrCode
	end.

is_skill_box_open(RoleID, Pos) ->
	Shouling = case get_shouling(RoleID) of
				   {} -> #shouling{};
				   SL -> SL
			   end,
	case lists:keyfind(Pos, 1, Shouling#shouling.skill_p) of
		?FALSE -> ?FALSE;
		_ -> ?TRUE
	end.

skill_t_slot_active(RoleID, Index, IsSync) ->
	try
		?CHECK_THROW(role_data:is_role_exist(RoleID), ?ERROR_NoRole),
		?ERROR_CHECK_THROW(check_func_open()),
		Shouling = case get_shouling(RoleID) of #shouling{} = M -> M; _ -> #shouling{} end,
		case (Shouling#shouling.skill_t_mask bsr Index) band 1 =:= 0 of
			?TRUE -> skip;
			_ -> throw(?ErrorCode_SL_SkillTISOpen)
		end,
		Cfg = cfg_mountSkillOpensNew:getRow(Index),
		case Cfg =:= {} of ?FALSE -> skip; _ -> throw(?ERROR_Cfg) end,
		case player:getVip() >= Cfg#mountSkillOpensNewCfg.vIPLv of
			?TRUE -> skip;
			_ -> throw(?ErrorCode_Eq_CastExtendFail_Vip)
		end,
		CostErr = player:delete_cost(Cfg#mountSkillOpensNewCfg.needItem, Cfg#mountSkillOpensNewCfg.needCoin, ?REASON_Shouling_SkillTOpen),
		?ERROR_CHECK_THROW(CostErr),
		NewShouling = Shouling#shouling{skill_t = lists:keystore(Index, 1, Shouling#shouling.skill_t, {Index, 0, 0, 0}), skill_t_mask = Shouling#shouling.skill_t_mask bor (1 bsl Index)},
		time_limit_gift:check_open(?TimeLimitType_SLSkillTBoxOpen),
		update_shouling(RoleID, NewShouling, ?TRUE),
		calc_shouling_prop(RoleID),
		put_prop(),
		IsSync andalso player:send(#pk_GS2U_ShoulingSkill_T_Slot_OpenRet{role_id = RoleID, err_code = ?ERROR_OK}),
		log_mount_op(0, 13, Index, lists:concat([Shouling#shouling.skill_t_mask, "->", NewShouling#shouling.skill_t_mask]))
	catch
		ErrCode ->
			IsSync andalso player:send(#pk_GS2U_ShoulingSkill_T_Slot_OpenRet{role_id = RoleID, err_code = ErrCode})
	end.

skill_t_make(RoleID, LockIndex) ->
%%  获取所有的触发技能  获取技能槽位   开始打造  根据锁定的条目计算  同类型技能不能重复
	try
		?CHECK_THROW(role_data:is_role_exist(RoleID), ?ERROR_NoRole),
		?ERROR_CHECK_THROW(check_func_open()),
		Shouling = #shouling{skill_t_mask = Mask} = case get_shouling(RoleID) of #shouling{} = M -> M; _ ->
			#shouling{} end,
		Indexes = [Index || Index <- lists:seq(1, 5), (Mask bsr Index) band 1 =:= 1] -- LockIndex,

		AllMountID = [Id1 || #mount{mount_id = Id1} <- get_always_mount_list()],%%打造技能时，避开限时坐骑或限时过期
		AllSkillList =
			lists:foldl(fun(MountID_, Acc) ->
				Mount_ = get_mount(MountID_),
				case Mount_ of
					{} ->
						Acc;
					#mount{level = Lv_, star = Star_} ->
						case cfg_mountStarNew:getRow(MountID_, Star_) of
							{} ->
								Acc;
							#mountStarNewCfg{skill = SkillList_} ->
								MountIDIndexList_ = get_mount_index_list(SkillList_, MountID_, Lv_),
								MountIDIndexList_ ++ Acc
						end
				end
						end, [], AllMountID),
		UsedSkillList = get_other_used_skill_list(RoleID),
		%% [{MoundID, Index}]
		RestSkillList = AllSkillList -- UsedSkillList,
		case Indexes =:= [] orelse RestSkillList =:= [] of
			?FALSE -> skip;
			_ -> throw(?ErrorCode_SL_SkillTCannotMK)
		end,

		CheckLockFun = fun(Index) ->
			case lists:keyfind(Index, 1, Shouling#shouling.skill_t) of
				?FALSE ->
					?FALSE;
				S ->
					element(4, S) =:= ?Lock_Locking
			end
					   end,
		?CHECK_THROW(lists:all(CheckLockFun, LockIndex), ?ErrorCode_SL_IndexUnlock),

		%% 检查消耗
		Cfg = cfg_mntSkillMkCostNew:getRow(length(LockIndex)),
		case Cfg =:= {} of ?FALSE -> skip; _ -> throw(?ERROR_Cfg) end,
		CostErr = player:delete_cost(Cfg#mntSkillMkCostNewCfg.needItem, Cfg#mntSkillMkCostNewCfg.needCoin, ?REASON_Shouling_SkillTMake),
		?ERROR_CHECK_THROW(CostErr),

		%% 开始打造
		LockSkillList = [{P1, P2, P3} || {P1, P2, P3, _} <- Shouling#shouling.skill_t, lists:member(P1, LockIndex)],

		{Skill_t, {SuccessTimes, FailTimes}} = rand_skill_t_list(Indexes, RestSkillList, LockSkillList),
		NewSkill_t = lists:foldl(fun({Pos_, {MountID_, Index_}}, Ret) ->
			lists:keystore(Pos_, 1, Ret, {Pos_, MountID_, Index_, 0}) end, Shouling#shouling.skill_t, Skill_t),
		update_shouling(RoleID, Shouling#shouling{skill_t = NewSkill_t}, ?FALSE),
		refresh_skill(),
		calc_shouling_prop(RoleID),
		put_prop(),
		SkillMsg = #pk_GS2U_ShoulingTSkillUpdate{role_id = RoleID, skills = [#pk_ShoulingSkill{pos = P, mount_id = MountId_, skill_idx = Index_} || {P, {MountId_, Index_}} <- Skill_t]},
		player:send(SkillMsg),
		player:send(#pk_GS2U_ShoulingSkill_T_MakeRet{role_id = RoleID, err_code = ?ERROR_OK, fail_times = FailTimes, success_times = SuccessTimes}),
		case Skill_t =:= [] of
			?TRUE ->%%打造一次都不成功
				skip;
			?FALSE ->
				BroadCastFun = fun({_I, {MountId, Pos}}, Ret) ->
					case get_mount(MountId) of
						#mount{star = Star} ->
							#mountStarNewCfg{skill = SkillList} = cfg_mountStarNew:getRow(MountId, Star),
							{_, _, _, SkillID, _} = lists:nth(Pos, SkillList),
							SkillCfg = cfg_skillBase:row(SkillID),
							Char = common:getTernaryValue(SkillCfg =/= {}, SkillCfg#skillBaseCfg.skillCharacter, 1),
							[{SkillID, Char} | Ret];
						_ -> Ret
					end end,
				SkillNameParameList = lists:foldl(BroadCastFun, [], Skill_t),
				PlayerText = player:getPlayerText(),
				marquee:sendChannelNotice(0, 0, mount_ShouSkillLV2,
					fun(Language) ->
						Fun = fun({SkillID, Char}, Ret) ->
							NameText = language:get_skill_name(SkillID, Language),
							[richText:getColorText(NameText, Char) | Ret]
							  end,
						SkillNameList = lists:foldl(Fun, [], SkillNameParameList),
						language:format(language:get_server_string("Mount_ShouSkillLV2", Language),
							[PlayerText, string:join(SkillNameList, language:get_server_string("D2X_FengMo_UI_text21", Language))])
					end)
		end,
		log_mount_op(0, 14, gamedbProc:term_to_dbstring(Shouling#shouling.skill_t), gamedbProc:term_to_dbstring(NewSkill_t))
	catch
		Err -> player:send(#pk_GS2U_ShoulingSkill_T_MakeRet{role_id = RoleID, err_code = Err})
	end.

%% 出战
on_mount_equip_1(RoleID, 0, MountId) ->
	Mount = get_mount(MountId),
	case Mount =:= {} of ?FALSE -> skip; _ -> throw(?ErrorCode_Mount_No) end,
	role_data:set_role_property(RoleID, #role.mount_id, MountId),
	player_refresh:on_refresh_mount([RoleID]);
%% 收回
on_mount_equip_1(RoleID, 1, MountId) ->
	Mount = get_mount(MountId),
	case Mount =:= {} of ?FALSE -> skip; _ -> throw(?ErrorCode_Mount_No) end,
	role_data:set_role_property(RoleID, #role.mount_id, 0),
	player_refresh:on_refresh_mount([RoleID]).

%% 所有坐骑列表
get_mount_list() -> get('mount_list').
set_mount_list(List) -> put('mount_list', List).

%%坐骑列表 仅永久激活
get_always_mount_list() ->
	case get('mount_list') of
		?UNDEFINED -> [];
		L -> [Mount || #mount{expire_time = ExTime} = Mount <- L, ExTime =:= 0]
	end.
%%坐骑列表 永久激活和限时激活
get_mount_list2() ->
	case get('mount_list') of
		?UNDEFINED -> [];
		L ->
			NowTime = time:time(),
			[Mount || #mount{expire_time = ExTime} = Mount <- L, ExTime =:= 0 orelse ExTime > NowTime]
	end.

get_shouling(RoleID) ->
	case get({'shouling', RoleID}) of
		?UNDEFINED -> {};
		R -> R
	end.
set_shouling(RoleID, M) -> put({'shouling', RoleID}, M).

get_fetter_list() -> get('mount_fetter').
set_fetter_list(M) -> put('mount_fetter', M).

%%仅限时和永久激活可查询到
get_mount(MountId) ->
	case lists:keyfind(MountId, #mount.mount_id, get_mount_list2()) of
		#mount{} = P -> P;
		_ -> {}
	end.

get_star(MountId) ->
	case get_mount(MountId) of
		#mount{star = S} -> S;
		_ -> 0
	end.

get_mirror_star(PlayerID, MountId) ->
	MountList = table_player:lookup(db_mount, PlayerID),
	case lists:keyfind(MountId, #db_mount.mount_id, MountList) of #db_mount{star = S} -> S;_ -> 0 end.

get_attr(Type, GuardId) ->
	Guard = get_mount(GuardId),
	get_attr_(Type, Guard).
get_mirror_attr(PlayerID, Type, MountId) ->
	case table_player:lookup(db_mount, PlayerID, [MountId]) of
		[DB] -> get_attr_(Type, db_mount2mount(DB));
		_ -> []
	end.

get_attr_('active', Mount) ->
	%% 激活
	#mountBaseNewCfg{attrBase = BaseAttr} = cfg_mountBaseNew:getRow(Mount#mount.mount_id),
	StarPer = case get_mount_star_cfg(Mount#mount.mount_id, Mount#mount.star) of
				  {} -> 0;
				  #mountStarAttrNewCfg{attrIncrease = P1} -> P1
			  end,
	[{K, trunc(V * (10000 + StarPer) / 10000)} || {K, V} <- BaseAttr];
get_attr_('up_level', Mount) ->
	%% 升级
	#mountLevelNewCfg{attrAdd = LvAttr} = cfg_mountLevelNew:getRow(Mount#mount.level),
	LvAttr;
get_attr_('break', Mount) ->
	%% 突破
	#mountBreakNewCfg{attribute = BreakAttr} = cfg_mountBreakNew:getRow(Mount#mount.break_lv),
	BreakAttr;
get_attr_('up_star', Mount) ->
	%% 升星
	case get_mount_star_cfg(Mount#mount.mount_id, Mount#mount.star) of
		#mountStarAttrNewCfg{attrAdd = StarAttr} -> StarAttr;
		{} -> []
	end;
get_attr_('awaken', Mount) ->
	%% 觉醒
	#mountAwakenNewCfg{attrAdd = AwakenAttr} = cfg_mountAwakenNew:getRow(Mount#mount.mount_id, Mount#mount.awaken_lv),
	AwakenAttr;
get_attr_('sublimate', Mount) ->
	%% 炼魂
	#mountSublimateNewCfg{attrAdd = APAttr, attrAdd2 = _APAttr2} = cfg_mountSublimateNew:getRow(Mount#mount.sublimate_lv),
	APAttr.

update_mount(Mount) ->
	table_player:insert(db_mount, mount2db_mount(Mount)),
	MountList = get_mount_list(),
	NewMountList = lists:keystore(Mount#mount.mount_id, #mount.mount_id, MountList, Mount),
	set_mount_list(NewMountList),
	player:send(#pk_GS2U_MountNewUpdate{mounts = [make_mount_msg(Mount)]}).

update_fetter(Fid, Flv) ->
	table_player:insert(db_mount_fetter, #db_mount_fetter{
		player_id = player:getPlayerID(),
		fetter_id = Fid,
		fetter_lv = Flv
	}),
	NewList = lists:keystore(Fid, 1, get_fetter_list(), {Fid, Flv}),
	set_fetter_list(NewList),
	player:send(#pk_GS2U_MountNewFetterUpdate{wfs = [#pk_MountNewFetter{f_lv = Flv, f_id = Fid}]}).

make_mount_msg(Mount) ->
	#pk_MountNew{
		mount_id = Mount#mount.mount_id,
		mount_lv = Mount#mount.level,
		mount_exp = Mount#mount.exp,
		break_lv = Mount#mount.break_lv,
		star = Mount#mount.star,
		awaken_lv = Mount#mount.awaken_lv,
		sublimate_lv = Mount#mount.sublimate_lv,
		is_rein = Mount#mount.is_rein,
		ele_awaken = Mount#mount.ele_awaken,
		expire_time = Mount#mount.expire_time
	}.

make_sl_msg(RoleID, SL) ->
	#pk_Shouling{
		role_id = RoleID,
		lv = SL#shouling.lv,
		exp = SL#shouling.exp,
		break_lv = SL#shouling.break_lv,
		skill_t_mask = SL#shouling.skill_t_mask,
		pill1 = SL#shouling.pill1,
		pill2 = SL#shouling.pill2,
		pill3 = SL#shouling.pill3,
		award_list = SL#shouling.award_list
	}.

db_mount2mount(#db_mount{} = DbMount) ->
	#mount{
		mount_id = DbMount#db_mount.mount_id,
		level = DbMount#db_mount.mount_lv,
		exp = DbMount#db_mount.mount_exp,
		star = DbMount#db_mount.star,
		break_lv = DbMount#db_mount.break_lv,
		awaken_lv = DbMount#db_mount.awaken_lv,
		sublimate_lv = DbMount#db_mount.sublimate_lv,
		is_rein = DbMount#db_mount.is_rein,
		ele_awaken = DbMount#db_mount.ele_awaken,
		expire_time = DbMount#db_mount.expire_time
	}.

mount2db_mount(#mount{} = Mount) ->
	#db_mount{
		player_id = player:getPlayerID(),
		mount_id = Mount#mount.mount_id,
		mount_lv = Mount#mount.level,
		mount_exp = Mount#mount.exp,
		break_lv = Mount#mount.break_lv,
		star = Mount#mount.star,
		awaken_lv = Mount#mount.awaken_lv,
		sublimate_lv = Mount#mount.sublimate_lv,
		is_rein = Mount#mount.is_rein,
		ele_awaken = Mount#mount.ele_awaken,
		expire_time = Mount#mount.expire_time
	}.

add_star(#mount{star = Star, mount_id = MountId, is_rein = IsRein} = Mount, UseSpec) ->
	#mountReincarnationCfg{starMax = {OldMax, NewMax}} = cfg_mountReincarnation:getRow(MountId),
	case IsRein of
		0 -> case Star >= OldMax of ?FALSE -> skip; _ -> throw(?ErrorCode_Mount_StarMax) end;
		_ -> case Star >= NewMax of ?FALSE -> skip; _ -> throw(?ErrorCode_Mount_StarMax) end
	end,
	StarCfg = cfg_mountStarNew:getRow(MountId, Star + 1),
	case StarCfg =:= {} of ?FALSE -> skip; _ -> throw(?ERROR_Cfg) end,
	MountCfg = cfg_mountBaseNew:getRow(MountId),
	?CHECK_THROW(MountCfg =/= {}, ?ERROR_Cfg),
	Char = MountCfg#mountBaseNewCfg.rareType,
	SpecialItemCfg = cfg_mountUniversalBit:getRow(Char),
	?CHECK_THROW(SpecialItemCfg =/= {}, ?ERROR_Cfg),
	SpecialItemID = SpecialItemCfg#mountUniversalBitCfg.itemID,
	{CostErr, _DecItemList} = pet:dec_cost_when_add_star(get_mount_star_cost(MountId, Star + 1), SpecialItemID, ?REASON_mount_add_star, UseSpec),
	?ERROR_CHECK_THROW(CostErr),
	NewMount = Mount#mount{star = Star + 1},
	update_mount(NewMount),
	case cfg_mountStarNew:getRow(MountId, Star) of
		#mountStarNewCfg{skillLv = L} when L =/= StarCfg#mountStarNewCfg.skillLv ->
			star_refresh_skill(MountId);
		_ -> skip
	end,
	calc_mount_prop(NewMount),
	put_prop(),
	attainment:check_attainment(?Attainments_Type_MountStar),
	activity_new_player:on_active_condition_change(?SalesActivity_MountAddStar, 1),
	player_refresh:on_refresh_mount([RoleID || #role{role_id = RoleID, mount_id = EqMountID} <- role_data:get_role_list(), EqMountID =:= MountId]),
	log_mount_op(MountId, 3, Star, Star + 1),
	[{First, Next} | _] = df:getGlobalSetupValueList(noticeRule36, [{1, 1}]),
	case Star + 1 >= First andalso (Star + 1 - First) rem Next =:= 0 of
		?TRUE ->
			PlayerText = player:getPlayerText(),
			marquee:sendChannelNotice(0, 0, mount_StarUp,
				fun(Language) ->
					language:format(language:get_server_string("Mount_StarUp", Language),
						[PlayerText, richText:getItemText(MountId, Language), Star + 1])
				end);
		_ -> skip
	end,
	player_task:refresh_task(?Task_Goal_MountStar).

%% 如果坐骑的觉醒技能被兽灵装配 需要刷新技能列表
star_refresh_skill(MountId) ->
	Func = fun(RoleID) ->
		ShouLing = case get_shouling(RoleID) of #shouling{} = M -> M; _ -> #shouling{} end,
		lists:keymember(MountId, 2, ShouLing#shouling.skill_p)
		   end,
	case lists:any(Func, role_data:get_all_role_id()) of
		?FALSE -> skip;
		_ -> refresh_skill()
	end.

add_mount(MountId) ->
	BaseCfg = cfg_mountBaseNew:getRow(MountId),
	case BaseCfg =:= {} of ?FALSE -> skip; _ -> throw(?ERROR_Cfg) end,
	CostErr = player:delete_cost(BaseCfg#mountBaseNewCfg.consume, [], ?REASON_mount_add_star),
	?ERROR_CHECK_THROW(CostErr),
	add_mount_1(MountId, BaseCfg),
	ok.

add_mount_1(MountId, BaseCfg) ->
	add_mount_1(MountId, BaseCfg, 0).
add_mount_1(MountId, BaseCfg, ExpireTime) ->
	Mount = #mount{
		mount_id = MountId, star = BaseCfg#mountBaseNewCfg.starIniti, expire_time = ExpireTime
	},
	update_mount(Mount),
	calc_mount_prop(Mount),
	put_prop(),
	attainment:check_attainment([?Attainments_Type_MountCount, ?Attainments_Type_MountAllCount]),
	player_task:refresh_task([?Task_Goal_MountCount, ?Task_Goal_MountActive, ?Task_Goal_MountAllLv]),
	time_limit_gift:check_open(?TimeLimitType_GetMount),
	guide:check_open_func(?OpenFunc_TargetType_Mount),
	activity_new_player:on_func_open_check(?ActivityOpenType_GetMount, {MountId}),
	prophecy:refresh_task_by_type(0, ?TaskType_companion, ?TaskType_companion_Mount),

	playerMap:send_protocol(#pk_U2GS_MountChangeStatus{mountStatus = 1}),
	player_refresh:on_refresh_mount_speed(),
	log_mount_op(MountId, 0, 0, 0),
	%% 获得S级以上的广播
	case BaseCfg#mountBaseNewCfg.rareType >= 0 andalso not lists:keymember(MountId, 1, df:getGlobalSetupValueList(mount_No, []))
		andalso (ExpireTime =:= 0 orelse MountId =/= 1210465) of%%限时天马不要公告
		?TRUE ->
			PlayerText = player:getPlayerText(),
			marquee:sendChannelNotice(0, 0, mount_GetNew,
				fun(Language) ->
					language:format(language:get_server_string("Mount_GetNew", Language),
						[PlayerText, richText:getItemText(MountId, Language)])
				end);
		_ -> skip
	end,
	check_auto_equip(MountId),
	ItemList = df:getGlobalSetupValueList(buyingtipsParam, [{12, 1210486}, {12, 1210483}, {11, 1210401}, {11, 1220404}]),
	case lists:keyfind(MountId, 2, ItemList) of
		{ShopID, _} -> player_shop:send_buy_notify(ShopID, ?TRUE, 4);
		_ -> skip
	end.

%% 等级
calc_mount_exp(MaxLv, Lv, AddExp) when Lv >= MaxLv ->
	{Lv, AddExp};
calc_mount_exp(MaxLv, Lv, AddExp) ->
	case cfg_mountLevelNew:getRow(Lv) of
		#mountLevelNewCfg{exp = 0} ->
			{Lv, AddExp};
		#mountLevelNewCfg{exp = Exp} when AddExp >= Exp ->
			calc_mount_exp(MaxLv, Lv + 1, AddExp - Exp);
		#mountLevelNewCfg{} ->
			{Lv, AddExp};
		_ ->
			?LOG_ERROR("calc_mount_exp no mountLevelNewCfg, level :~p", [Lv]),
			{Lv, AddExp}
	end.

%% 等级
calc_shouling_exp(Lv, AddExp, MaxLv) when Lv >= MaxLv -> {Lv, AddExp};
calc_shouling_exp(Lv, AddExp, MaxLv) ->
	case cfg_mountSoulLvNew:getRow(Lv) of
		#mountSoulLvNewCfg{exp = 0} ->
			{Lv, AddExp};
		#mountSoulLvNewCfg{exp = Exp} when AddExp >= Exp ->
			calc_shouling_exp(Lv + 1, AddExp - Exp, MaxLv);
		#mountSoulLvNewCfg{} ->
			{Lv, AddExp};
		_ ->
			?LOG_ERROR("calc_shouling_exp no mountSoulLvNewCfg, level :~p", [Lv]),
			{Lv, AddExp}
	end.

%% 取指定稀有度坐骑数量
get_mount_num_rare(Type) ->
	Fun =
		fun(Mount, Acc) ->
			case get_expire_type(Mount) of
				1 ->
					#mountBaseNewCfg{rareType = RareType} = cfg_mountBaseNew:getRow(Mount#mount.mount_id),
					case RareType == Type of
						?TRUE -> Acc + 1;
						_ -> Acc
					end;
				_ -> Acc
			end
		end,
	lists:foldl(Fun, 0, get_always_mount_list()).

get_rare(FetterId) ->
	case FetterId of
		1 -> 2;
		2 -> 3;
		3 -> 4;
		4 -> 5;
		_ -> 6
	end.

get_pill_max([{Lv, Max} | _T], PLv) when PLv =< Lv -> Max;
get_pill_max([{_, Max}], _PLv) -> Max;
get_pill_max([_ | T], PLv) -> get_pill_max(T, PLv).

calc_prop() ->
	calc_mount_prop(),
	calc_fetter_prop(),
	[calc_shouling_prop(ID) || ID <- role_data:get_all_role_id()],
	put_prop(?TRUE).

calc_mount_prop() ->
	lists:foreach(fun calc_mount_prop/1, get_always_mount_list()).
calc_mount_prop(Mount) ->
	%% 基础
	#mountBaseNewCfg{rareType = Rare, attrBase = BaseAttr} = cfg_mountBaseNew:getRow(Mount#mount.mount_id),
	%% 转生
	ReinAttr =
		case Mount#mount.is_rein of
			0 -> [];
			_ ->
				#mountReincarnationCfg{attrAdd = RAttr} = cfg_mountReincarnation:getRow(Mount#mount.mount_id),
				RAttr
		end,
	%% 等级
	#mountLevelNewCfg{attrAdd = LvAttr} = cfg_mountLevelNew:getRow(Mount#mount.level),
	%% 突破
	#mountBreakNewCfg{attribute = BreakAttr} = cfg_mountBreakNew:getRow(Mount#mount.break_lv),
	%% 升星
	#mountStarAttrNewCfg{attrIncrease = StarPer, attrAdd = StarAttr} = get_mount_star_cfg(Mount#mount.mount_id, Mount#mount.star),
	%% 觉醒
	#mountAwakenNewCfg{attrAdd = AwakenAttr} = cfg_mountAwakenNew:getRow(Mount#mount.mount_id, Mount#mount.awaken_lv),
	%% 炼魂
	#mountSublimateNewCfg{attrAdd = APAttr, attrAdd2 = APAttr2, mountUpBreak = UpBreakPer} = cfg_mountSublimateNew:getRow(Mount#mount.sublimate_lv),
	%% 元素觉醒
	F1 = fun(#mountElementAwakenCfg{mountType = RareType, awakenType = EleAwakenType, attrAdd = EleAwakenAttr}, Ret) ->
		case RareType == Rare + 1 andalso variant:isBitOn(Mount#mount.ele_awaken, EleAwakenType) of
			?TRUE -> EleAwakenAttr ++ Ret;
			?FALSE -> Ret
		end
		 end,
	EleAwakenAttr = lists:foldl(F1, [], cfg_mountElementAwaken:rows()),
	OtherProp = attribute:base_prop_from_list(APAttr ++ APAttr2 ++ AwakenAttr ++ StarAttr ++ ReinAttr ++ EleAwakenAttr) ++
		attribute:base_value_multi(attribute:base_prop_from_list(BreakAttr ++ LvAttr), UpBreakPer),
	BaseProp = [#prop{index = P, base = V, add = V * StarPer / 10000} || {P, V} <- BaseAttr],
	set_mount_prop(Mount#mount.mount_id, {common:listValueMerge(LvAttr ++ BaseAttr), attribute:prop_merge(OtherProp, BaseProp)}).

calc_fetter_prop() ->
	List = lists:foldl(fun({Index, Lv}, Ret) ->
		#mountJiBanNew2Cfg{attrAdd = FetterAttr} = cfg_mountJiBanNew2:getRow(Index, Lv),
		Ret ++ FetterAttr end, [], get_fetter_list()),
	set_fetter_prop(attribute:base_prop_from_list(common:listValueMerge(List))).

calc_shouling_prop(RoleID) ->
	case get_shouling(RoleID) of
		#shouling{skill_t = Skill_t, skill_p = Skill_p, eqs = EqsList} = Shouling ->
			%%坐骑装备 星级套装属性
			StarSuitAttr = mount_eq:get_mount_star_suit(EqsList),
			{StarSuit_1, StarSuit_2} = attribute:partition_attribute(StarSuitAttr),
			%%{坐骑装备角色属性 各部分基础及卓越角色属性，各部分强化角色属性，坐骑装备玩家属性}
			{EqAttr, EqPartBase, EqPartInt, CommonProp1} =
				lists:foldl(fun
								(({_, 0, _, _}), {Ret1, Ret3, Ret4, Ret5}) ->%%卸下装备
									{Ret1, Ret3, Ret4, Ret5};
								({_, EqUid, IntensityLv, BreakLv}, {Ret1, Ret3, Ret4, Ret5}) ->
									{?ERROR_OK, [#item{cfg_id = CfgId}]} = bag_player:get_bag_item(?BAG_SL_EQ_EQUIP, EqUid),
									#eq_addition{rand_prop = RandProp} = lists:keyfind(EqUid, #eq_addition.eq_uid, mount_eq:get_shouling_eq()),
									RandAttr = [{I, V} || {I, V, _C, _} <- RandProp],
									#mountEquipStarCfg{equipID = EquipCfgId, baseAdd = BaseAdd, starAttributeAdd = StarAttrAdd} =
										cfg_mountEquipStar:getRow(CfgId),
									#mountEquipCfg{attribute = Attr, type = Type, part = Part} = cfg_mountEquip:getRow(EquipCfgId),
									case cfg_mountEqpStr:getRow(Type, IntensityLv) of
										#mountEqpStrCfg{attribute = AttrIn} ->
											Attr1 = AttrIn;
										_ -> Attr1 = []
									end,
									case cfg_mountEqpBre:getRow(Type, BreakLv) of
										#mountEqpBreCfg{attribute = AttrB} ->
											Attr2 = AttrB;
										_ -> Attr2 = []
									end,
									RandAttrList = [Prop#prop{base = round(V * StarAttrAdd / 10000)} || #prop{base = V} = Prop <- attribute:base_prop_from_list(RandAttr)],%%卓越属性
									BaseAttrList = [Prop#prop{base = round(V * BaseAdd / 10000)} || #prop{base = V} = Prop <- attribute:base_prop_from_list(Attr)],%%基础属性
									LvAttrList = attribute:base_prop_from_list(Attr1),%%强化属性
									BreakAttrList = attribute:base_prop_from_list(Attr2),%%突破属性
									{RandAttr_1, RandAttr_2} = attribute:partition_attribute(RandAttrList),
									{Attr_1, Attr_2} = attribute:partition_attribute(BaseAttrList),
									{Attr1_1, Attr1_2} = attribute:partition_attribute(LvAttrList),
									{Attr2_1, Attr2_2} = attribute:partition_attribute(BreakAttrList),
									{attribute:prop_merge(RandAttr_2 ++ Attr_2 ++ Attr1_2 ++ Attr2_2, Ret1),
										[{Part, Attr_2 ++ RandAttr_2} | Ret3], [{Part, Attr1_2} | Ret4],
										attribute:prop_merge(RandAttr_1 ++ Attr_1 ++ Attr1_1 ++ Attr2_1, Ret5)}
							end, {[], [], [], []}, Shouling#shouling.eqs),
			%% 兽灵等级
			#mountSoulLvNewCfg{attrAdd = SlBase} = cfg_mountSoulLvNew:getRow(Shouling#shouling.lv),
			%% 兽灵突破
			#mountSoulBreakCfg{attribute = SlBreakAttr} = cfg_mountSoulBreak:getRow(Shouling#shouling.break_lv),
			%% 技能格子
			Skill_p_attr = lists:foldl(fun({Pos, _, _}, Acc) ->
				case cfg_mountSkillOpenNew:getRow(Pos) of
					{} ->
						[];
					#mountSkillOpenNewCfg{attrAdd = Attr} ->
						Attr ++ Acc
				end
									   end, [], Skill_p),
			Skill_t_attr = lists:foldl(fun({Pos, _, _, _}, Acc) ->
				case cfg_mountSkillOpensNew:getRow(Pos) of
					{} ->
						[];
					#mountSkillOpensNewCfg{attrAdd = Attr} ->
						Attr ++ Acc
				end
									   end, [], Skill_t),

			{SlBase_1, SlBase_2} = attribute:partition_attribute(attribute:base_prop_from_list(common:listValueMerge(SlBase ++ Skill_p_attr ++ Skill_t_attr ++ SlBreakAttr))),
			CommonProp = attribute:prop_merge(CommonProp1, SlBase_1 ++ StarSuit_1),
			EqAttr2 = attribute:prop_merge(EqAttr, StarSuit_2),
			set_shouling_prop(RoleID, {EqAttr2, SlBase_2, EqPartBase, EqPartInt}),
			set_common_prop(RoleID, CommonProp);
		_ ->
			set_shouling_prop(RoleID, {[], [], [], []}),
			set_common_prop(RoleID, [])
	end.

put_prop() -> put_prop(?FALSE).
put_prop(IsOnline) ->
	{AL1, SL1, SSL1, SSSL1, OL1} = lists:foldl(fun(#mount{mount_id = PetID}, {AL, SL, SSL, SSSL, OL}) ->
		case get_mount_prop(PetID) of
			?UNDEFINED -> {AL, SL, SSL, SSSL, OL};
			{W, O} ->
				#mountBaseNewCfg{rareType = T} = cfg_mountBaseNew:getRow(PetID),
				case T of
					2 -> {common:listValueMerge(W ++ AL), SL, SSL, SSSL, attribute:prop_merge(O, OL)};
					3 -> {AL, common:listValueMerge(W ++ SL), SSL, SSSL, attribute:prop_merge(O, OL)};
					4 -> {AL, SL, common:listValueMerge(W ++ SSL), SSSL, attribute:prop_merge(O, OL)};
					5 -> {AL, SL, SSL, common:listValueMerge(W ++ SSSL), attribute:prop_merge(O, OL)};
					_ -> {AL, SL, SSL, SSSL, OL}
				end
		end end, {[], [], [], [], []}, get_always_mount_list()),%%仅永久

	FetterProp = get_fetter_prop(),

	put('mount_prop', {FetterProp, AL1, SL1, SSL1, SSSL1, OL1}),
	[attribute_player:on_prop_change() || not IsOnline].
get_prop(RoleID) ->
	get_shouling_prop(RoleID).
get_prop_common() ->
	case get('mount_prop') of
		?UNDEFINED -> {[], [], [], [], [], [], []};
		{P1, P2, P3, P4, P5, P6} ->
			SlCommon = lists:foldl(fun(ID, Ret) ->
				get_common_prop(ID) ++ Ret end, [], role_data:get_all_role_id()),
			{P1, P2, P3, P4, P5, P6, SlCommon}
	end.

get_mount_prop(MountId) -> get({'mount_prop', MountId}).
set_mount_prop(MountId, P) -> put({'mount_prop', MountId}, P).

get_fetter_prop() -> get('mount_fetter_prop').
set_fetter_prop(M) -> put('mount_fetter_prop', M).

get_shouling_prop(RoleID) ->
	case get({'shouling_prop', RoleID}) of
		?UNDEFINED -> {[], [], [], []};
		R -> R
	end.
%% {[装备角色属性（包含星级角色属性）],[兽灵角色属性],[各部分的基础角色属性和卓越属性],[各部位强化属性]}
set_shouling_prop(RoleID, M) -> put({'shouling_prop', RoleID}, M).

get_common_prop(RoleID) ->
	case get({'shouling_common_prop', RoleID}) of
		?UNDEFINED -> [];
		R -> R
	end.
set_common_prop(RoleID, M) -> put({'shouling_common_prop', RoleID}, M).


mount_add_lv(MountId, CostList) ->
	try
		?ERROR_CHECK_THROW(check_func_open()),
		Mount = get_mount(MountId),
		case get_expire_type(Mount) of
			2 -> throw(?ErrorCode_mount_time_NoDevelop);%%限时，不能养成
			_ -> ok
		end,
		case Mount =:= {} of ?FALSE -> skip; _ -> throw(?ERROR_Cfg) end,
		F = fun({ItemId, Num}, Ret) ->
			ExpItemCfg = cfg_mountExpItemNew:getRow(ItemId),
			case ExpItemCfg =:= {} of ?FALSE -> skip; _ -> throw(?ERROR_Cfg) end,
			ExpItemCfg#mountExpItemNewCfg.exp * Num + Ret
			end,
		AddExp = lists:foldl(F, 0, CostList),
		case CostList =:= [] orelse AddExp =:= 0 of
			?FALSE -> skip; _ -> throw(?ErrorCode_Mount_addLv_NoCost)
		end,

		case bag_player:delete_prepare(CostList) of
			{?ERROR_OK, P} ->
				BreakCfg = cfg_mountBreakNew:getRow(Mount#mount.break_lv),
				case BreakCfg =:= {} of ?FALSE -> skip; _ -> throw(?ERROR_Cfg) end,
				{NewLv, NewExp} = calc_mount_exp(BreakCfg#mountBreakNewCfg.maxLv, Mount#mount.level, Mount#mount.exp + AddExp),
				#mountReincarnationCfg{levelMax = {OldMax, NewMax}} = cfg_mountReincarnation:getRow(MountId),
				case Mount#mount.is_rein of
					0 -> case NewLv > OldMax of ?FALSE -> skip; _ -> throw(?ErrorCode_Mount_LvMax) end;
					_ -> case NewLv > NewMax of ?FALSE -> skip; _ -> throw(?ErrorCode_Mount_LvMax) end
				end,

				case NewLv > player:getLevel() orelse NewLv > BreakCfg#mountBreakNewCfg.maxLv of
					?FALSE -> skip;
					_ -> throw(?ErrorCode_Mount_LvMax)
				end,
				bag_player:delete_finish(P, ?REASON_mount_add_lv),
				NewMount = Mount#mount{
					level = NewLv,
					exp = NewExp
				},
				update_mount(NewMount),
				calc_mount_prop(NewMount),
				put_prop(),
				[refresh_skill() || lists:member(MountId, [EqMountID || #role{mount_id = EqMountID} <- role_data:get_role_list()])],
				attainment:check_attainment(?Attainments_Type_MountLv),
				time_limit_gift:check_open(?TimeLimitType_MountLv),
				seven_gift:check_task(?Seven_Type_MountLv),
				player_task:refresh_task([?Task_Goal_MountLv, ?Task_Goal_MountAllLv]),
				activity_new_player:on_active_condition_change(?SalesActivity_MountAddLv, 1),
				log_mount_op(MountId, 1, lists:concat([Mount#mount.level, "(", Mount#mount.exp, ")"]), lists:concat([NewLv, "(", NewExp, ")"]));
			{CostErr, _} -> throw(CostErr)
		end,
		player:send(#pk_GS2U_MountNewAddLevelRet{mount_id = MountId, err_code = ?ERROR_OK})
	catch
		ErrCode -> player:send(#pk_GS2U_MountNewAddLevelRet{mount_id = MountId, err_code = ErrCode})
	end.

mount_break(MountId) ->
	try
		throw(?ERROR_FunctionClose), %% TODO 暂不开
		?ERROR_CHECK_THROW(check_func_open()),
		Mount = get_mount(MountId),
		case get_expire_type(Mount) of
			2 -> throw(?ErrorCode_mount_time_NoDevelop);%%限时，不能养成
			_ -> ok
		end,
		case Mount =:= {} of ?FALSE -> skip; _ -> throw(?ERROR_Cfg) end,
		MountLv = Mount#mount.level,
		case cfg_mountBreakNew:getRow(Mount#mount.break_lv) of
			#mountBreakNewCfg{maxLv = MountLv} -> skip;
			_ -> throw(?ErrorCode_Mount_CannotBreak)
		end,
		BreakCfg = cfg_mountBreakNew:getRow(Mount#mount.break_lv + 1),

		case BreakCfg =:= {} of ?FALSE -> skip; _ -> throw(?ERROR_Cfg) end,

		ShouLing = case get_shouling(role_data:get_leader_id()) of #shouling{} = M -> M; _ -> #shouling{} end,
		case ShouLing#shouling.lv >= BreakCfg#mountBreakNewCfg.needLv of ?TRUE -> skip; _ ->
			throw(?ErrorCode_Mount_BreakLingLvLimit) end,

		CostErr = player:delete_cost(BreakCfg#mountBreakNewCfg.needItem, [], ?REASON_mount_break),
		?ERROR_CHECK_THROW(CostErr),
		{NewLv, NewExp} = calc_mount_exp(BreakCfg#mountBreakNewCfg.maxLv, MountLv, Mount#mount.exp),
		NewMount = Mount#mount{break_lv = Mount#mount.break_lv + 1, level = NewLv, exp = NewExp},
		update_mount(NewMount),
		player:send(#pk_GS2U_MountNewAddBreakRet{mount_id = MountId, err_code = ?ERROR_OK}),
		calc_mount_prop(NewMount),
		put_prop(),
		PlayerText = player:getPlayerText(),
		marquee:sendChannelNotice(0, 0, mount_MountLV,
			fun(Language) ->
				language:format(language:get_server_string("Mount_MountLV", Language),
					[PlayerText, richText:getItemText(MountId, Language), MountLv])
			end),
		player_task:refresh_task(?Task_Goal_MountBreak),
		log_mount_op(MountId, 2, Mount#mount.break_lv, NewMount#mount.break_lv)
	catch
		ErrCode -> player:send(#pk_GS2U_MountNewAddBreakRet{mount_id = MountId, err_code = ErrCode})
	end.

mount_awaken(MountId, UseSpec) ->
	try
		?ERROR_CHECK_THROW(check_func_open()),
		Mount = get_mount(MountId),
		case get_expire_type(Mount) of
			2 -> throw(?ErrorCode_mount_time_NoDevelop);%%限时，不能养成
			_ -> ok
		end,
		case Mount =:= {} of ?FALSE -> skip; _ -> throw(?ERROR_Cfg) end,
		#mountReincarnationCfg{awakenMax = {OldMax, NewMax}} = cfg_mountReincarnation:getRow(MountId),
		case Mount#mount.is_rein of
			0 -> case Mount#mount.awaken_lv >= OldMax of ?FALSE -> skip; _ -> throw(?ErrorCode_Mount_CannotAwaken) end;
			_ -> case Mount#mount.awaken_lv >= NewMax of ?FALSE -> skip; _ -> throw(?ErrorCode_Mount_CannotAwaken) end
		end,

		AwakenCfg = cfg_mountAwakenNew:getRow(MountId, Mount#mount.awaken_lv + 1),
		case AwakenCfg =:= {} of ?FALSE -> skip; _ -> throw(?ERROR_Cfg) end,

		case Mount#mount.star >= AwakenCfg#mountAwakenNewCfg.needLv of
			?TRUE -> skip;
			_ -> throw(?ErrorCode_Mount_CannotAwaken)
		end,

		case Mount#mount.level >= AwakenCfg#mountAwakenNewCfg.needLevel of
			?TRUE -> skip;
			_ -> throw(?ErrorCode_Mount_CannotAwaken)
		end,

		SpecialItemID = cfg_globalSetup:wanneng_suipian1(),
		{CostErr, _DecItemList} = pet:dec_cost_when_add_star(AwakenCfg#mountAwakenNewCfg.needItem, SpecialItemID, ?REASON_mount_awaken, UseSpec),
		?ERROR_CHECK_THROW(CostErr),
		NewMount = Mount#mount{
			awaken_lv = Mount#mount.awaken_lv + 1
		},
		update_mount(NewMount),
		NowLv = AwakenCfg#mountAwakenNewCfg.skillLv,
		case cfg_mountAwakenNew:getRow(MountId, Mount#mount.awaken_lv) of
			#mountAwakenNewCfg{skillLv = NowLv} -> skip;
			_ -> awaken_refresh_skill(MountId)
		end,
		calc_mount_prop(NewMount),
		refresh_skill(),
		calc_shouling_prop(role_data:get_leader_id()),
		put_prop(),
		player:send(#pk_GS2U_MountNewAddAwakenRet{mount_id = MountId, err_code = ?ERROR_OK}),
		attainment:check_attainment(?Attainments_Type_MountFeather),
		time_limit_gift:check_open(?TimeLimitType_MountAwaken),
		activity_new_player:on_active_condition_change(?SalesActivity_MountAwake, 1),
		PlayerText = player:getPlayerText(),
		[{First, Next} | _] = df:getGlobalSetupValueList(noticeRule37, [{10, 10}]),
		case NewMount#mount.awaken_lv >= First andalso (NewMount#mount.awaken_lv - First) rem Next =:= 0 of
			?TRUE ->
				marquee:sendChannelNotice(0, 0, mount_Awaken,
					fun(Language) ->
						language:format(language:get_server_string("Mount_Awaken", Language), [PlayerText, richText:getItemText(MountId, Language), NewMount#mount.awaken_lv])
					end);
			_ -> skip
		end,
		log_mount_op(MountId, 4, Mount#mount.awaken_lv, NewMount#mount.awaken_lv),
		player_task:refresh_task(?Task_Goal_MountAwaken)
	catch
		ErrCode -> player:send(#pk_GS2U_MountNewAddAwakenRet{mount_id = MountId, err_code = ErrCode})
	end.

awaken_refresh_skill(MountId) ->
	Func = fun(RoleID) ->
		ShouLing = case get_shouling(RoleID) of #shouling{} = M -> M; _ -> #shouling{} end,
		lists:keymember(MountId, 2, ShouLing#shouling.skill_p)
		   end,
	case lists:any(Func, role_data:get_all_role_id()) of
		?FALSE -> skip;
		_ -> refresh_skill()
	end.

mount_sublimate(MountId) ->
	try
		?ERROR_CHECK_THROW(check_func_open()),
		Mount = get_mount(MountId),
		case get_expire_type(Mount) of
			2 -> throw(?ErrorCode_mount_time_NoDevelop);%%限时，不能养成
			_ -> ok
		end,
		case Mount =:= {} of ?FALSE -> skip; _ -> throw(?ERROR_Cfg) end,
		Cfg = cfg_mountSublimateNew:getRow(Mount#mount.sublimate_lv + 1),
		case Cfg =:= {} of ?FALSE -> skip; _ -> throw(?ERROR_Cfg) end,

		case Mount#mount.level >= Cfg#mountSublimateNewCfg.needLevel of
			?TRUE -> skip;
			_ -> throw(?ErrorCode_Mount_MountLvNotMeet)
		end,

		CostErr = player:delete_cost(Cfg#mountSublimateNewCfg.needItem, [], ?REASON_mount_sublimate),
		?ERROR_CHECK_THROW(CostErr),
		NewMount = Mount#mount{sublimate_lv = Mount#mount.sublimate_lv + 1},
		update_mount(NewMount),
		player:send(#pk_GS2U_MountNewAddsublimateRet{mount_id = MountId, err_code = ?ERROR_OK}),
		calc_mount_prop(NewMount),
		put_prop(),
		attainment:check_attainment(?Attainments_Type_MountSublimate),
		time_limit_gift:check_open(?TimeLimitType_MountSublimate),
		player_task:refresh_task(?Task_Goal_MountSublimate),
		activity_new_player:on_active_condition_change(?SalesActivity_MountSublimate, 1),
		PlayerText = player:getPlayerText(),
		[{First, Next} | _] = df:getGlobalSetupValueList(noticeRule38, [{20, 20}]),
		case NewMount#mount.sublimate_lv >= First andalso (NewMount#mount.sublimate_lv - First) rem Next =:= 0 of
			?TRUE ->
				marquee:sendChannelNotice(0, 0, mount_Soul,
					fun(Language) ->
						language:format(language:get_server_string("Mount_Soul", Language), [PlayerText, richText:getItemText(MountId, Language), NewMount#mount.sublimate_lv])
					end);
			_ -> skip
		end,
		log_mount_op(MountId, 5, Mount#mount.sublimate_lv, NewMount#mount.sublimate_lv)
	catch
		ErrCode -> player:send(#pk_GS2U_MountNewAddsublimateRet{mount_id = MountId, err_code = ErrCode})
	end.

%% 转生
mount_rein(MountId) ->
	try
		?ERROR_CHECK_THROW(check_func_open()),
		Mount = get_mount(MountId),
		case get_expire_type(Mount) of
			2 -> throw(?ErrorCode_mount_time_NoDevelop);%%限时，不能养成
			_ -> ok
		end,
		case Mount =:= {} of ?FALSE -> skip; _ -> throw(?ERROR_Cfg) end,
		case Mount#mount.is_rein of
			0 -> skip;
			_ -> throw(?ErrorCode_Mount_Rein)
		end,
		ReinCfg = cfg_mountReincarnation:getRow(MountId),
		case ReinCfg =:= {} of ?FALSE -> skip; _ -> throw(?ERROR_Cfg) end,
		IsCond = check_cond(Mount, ReinCfg#mountReincarnationCfg.condition),
		case IsCond of ?TRUE -> skip; _ -> throw(?ErrorCode_Condition_Rein) end,
		check_consume(ReinCfg#mountReincarnationCfg.consume),
		NewMount = Mount#mount{is_rein = 1},
		update_mount(NewMount),
		calc_mount_prop(NewMount),
		put_prop(),
		attainment:check_attainment(?Attainments_Type_MountReinCount),
		player:send(#pk_GS2U_MountReincarnationRet{mount_id = MountId, err_code = ?ERROR_OK}),
		log_mount_op(MountId, 15, Mount#mount.is_rein, NewMount#mount.is_rein)
	catch
		ErrCode -> player:send(#pk_GS2U_MountReincarnationRet{mount_id = MountId, err_code = ErrCode})
	end.

%% 检查转生条件
check_cond(Mount, ConList) ->
	OrderList = common:group_by(ConList, 1),
	Func =
		fun({_, List}) ->
			Func0 =
				fun({K, V}) ->
					case K of
						1 -> Mount#mount.level >= V;
						2 -> Mount#mount.star >= V;
						3 -> Mount#mount.awaken_lv >= V;
						4 -> Mount#mount.sublimate_lv >= V;
						_ -> ?FALSE
					end
				end,
			lists:all(Func0, List)
		end,
	lists:any(Func, OrderList).

%% 检查转生消耗
check_consume(Consume) ->
	%% 检查消耗是否足够
	Func0 =
		fun({Way, P1, P2}) ->
			case Way of
				1 -> %% 消耗物品
					case bag_player:get_item_amount(P1) >= P2 of
						?TRUE ->
							ok;
						?FALSE ->
							throw(?ErrorCode_Consume_Rein)
					end;
				2 -> %% 消耗货币
					case currency:get_today_delete_max(P1) >= P2 of
						?TRUE ->
							ok;
						?FALSE ->
							throw(?ErrorCode_Consume_Rein)
					end;
				_ -> ok
			end
		end,
	lists:foreach(Func0, Consume),
	%% 扣除消耗
	Func =
		fun({Way, P1, P2}) ->
			case Way of
				1 -> %% 消耗物品
					player:delete_cost([{P1, P2}], [], ?REASON_mount_rein);
				2 -> %% 消耗货币
					player:delete_cost([], [{P1, P2}], ?REASON_mount_rein);
				_ -> ok
			end
		end,
	lists:foreach(Func, Consume).

%% 元素觉醒
mount_ele_awaken(MountId, Type) ->
	try
		?ERROR_CHECK_THROW(check_func_open()),
		Mount = get_mount(MountId),
		case get_expire_type(Mount) of
			2 -> throw(?ErrorCode_mount_time_NoDevelop);%%限时，不能养成
			_ -> ok
		end,
		case Mount =:= {} of ?FALSE -> skip; _ -> throw(?ERROR_Cfg) end,
		case variant:isBitOn(Mount#mount.ele_awaken, Type) of
			?TRUE -> throw(?ErrorCode_Wing_EleDuplicateActive);
			?FALSE -> ok
		end,
		{Err1, CostPrepare} = check_ele_awaken(Mount, Type),
		?ERROR_CHECK_THROW(Err1),
		NewMount = Mount#mount{ele_awaken = variant:setBit(Mount#mount.ele_awaken, Type, 1)},
		player:delete_cost_finish(CostPrepare, ?REASON_mount_ele_awaken),
		update_mount(NewMount),
		calc_mount_prop(NewMount),
		put_prop(),
		log_mount_op(MountId, 16, Type, lists:concat([Mount#mount.ele_awaken, " -> ", NewMount#mount.ele_awaken])),
		player:send(#pk_GS2U_MountNewEleAwakenRet{mount_id = MountId, type = Type}),
		case Type of
			6 ->
				PlayerText = player:getPlayerText(),
				marquee:sendChannelNotice(0, 0, zqWmjx_gonggao,
					fun(Language) ->
						language:format(language:get_server_string("ZqWmjx_gonggao", Language), [PlayerText, richText:getItemText(MountId, Language)])
					end);
			_ -> ok
		end
	catch
		ErrCode ->
			player:send(#pk_GS2U_MountNewEleAwakenRet{mount_id = MountId, type = Type, err_code = ErrCode})
	end.

check_ele_awaken(#mount{mount_id = MountId, ele_awaken = EleAwaken}, Type) ->
	case cfg_mountBaseNew:getRow(MountId) of
		#mountBaseNewCfg{rareType = Rare} ->
			case cfg_mountElementAwaken:getRow(Rare + 1, Type) of
				#mountElementAwakenCfg{condition = Condition, consume = Consume} ->
					case lists:all(fun(Idx) -> variant:isBitOn(EleAwaken, Idx) end, Condition) of
						?TRUE -> player:delete_cost_prepare([Consume], []);
						?FALSE -> {?ErrorCode_Wing_EleActiveCondition, {}}
					end;
				_ -> {?ERROR_Cfg, {}}
			end;
		_ ->
			{?ERROR_Cfg, {}}
	end.

fetter_active(FetterId, Lv) ->
	try
		?ERROR_CHECK_THROW(check_func_open()),
		LvCheck = case lists:keyfind(FetterId, 1, get_fetter_list()) of
					  {FetterId, Lv1} -> Lv =:= Lv1 + 1;
					  ?FALSE -> Lv =:= 1
				  end,
		case LvCheck of ?TRUE -> skip; _ -> throw(?ErrorCode_Mount_FetterCannotActive) end,

		Cfg = cfg_mountJiBanNew2:getRow(FetterId, Lv),
		case Cfg =:= {} of ?FALSE -> skip; _ -> throw(?ERROR_Cfg) end,

		RareType = get_rare(FetterId),
		case RareType =:= 6 of ?FALSE -> skip; _ -> throw(?ERROR_Param) end,
		MountNum = get_mount_num_rare(RareType),%%限时激活，未激活不算羁绊
		case MountNum >= Cfg#mountJiBanNew2Cfg.num of
			?TRUE -> skip;
			_ -> throw(?ErrorCode_Mount_FetterCannotActive)
		end,
		update_fetter(FetterId, Lv),
		player:send(#pk_GS2U_MountNewFetterActiveRet{err_code = ?ERROR_OK}),
		calc_fetter_prop(),
		put_prop(),
		PlayerId = player:getPlayerID(),
		player_push:mount_fetter_level(PlayerId, Cfg#mountJiBanNew2Cfg.name, Lv),
		log_mount_op(FetterId, 6, Lv - 1, Lv)
	catch
		ErrCode -> player:send(#pk_GS2U_MountNewFetterActiveRet{err_code = ErrCode})
	end.

shouling_pill(RoleID, Index, Num) ->
	try
		?CHECK_THROW(role_data:is_role_exist(RoleID), ?ERROR_NoRole),
		?ERROR_CHECK_THROW(check_func_open()),
		Shouling = case get_shouling(RoleID) of #shouling{} = M -> M; _ -> #shouling{} end,
		NowUse = case Index of
					 1 -> Shouling#shouling.pill1;
					 2 -> Shouling#shouling.pill2;
					 3 -> Shouling#shouling.pill3;
					 _ -> throw(?ERROR_Cfg)
				 end,
		#mountPillAttrNewCfg{itemID = PillItemId} = cfg_mountPillAttrNew:getRow(Index),
		PlayerLv = player:getLevel(),
		MaxUseNum = get_pill_max([{Id, Max} || #mountPillNewCfg{iD = Id, itemID = I, max = Max} <- cfg_mountPillNew:rows(), I =:= PillItemId], PlayerLv),
		case NowUse + Num > MaxUseNum of ?FALSE -> skip; _ -> throw(?ErrorCode_Mount_PillMax) end,
		CostErr = player:delete_cost([{PillItemId, Num}], [], ?REASON_Shouling_soul_pill),
		?ERROR_CHECK_THROW(CostErr),
		NowShouling = case Index of
						  1 -> Shouling#shouling{pill1 = Shouling#shouling.pill1 + Num};
						  2 -> Shouling#shouling{pill2 = Shouling#shouling.pill2 + Num};
						  3 -> Shouling#shouling{pill3 = Shouling#shouling.pill3 + Num}
					  end,
		update_shouling(RoleID, NowShouling, ?TRUE),
		player:send(#pk_GS2U_ShoulingEatPillRet{role_id = RoleID, err_code = ?ERROR_OK}),
		calc_shouling_prop(RoleID),
		put_prop(),
		attainment:check_attainment(?Attainments_Type_MountPill),
		activity_new_player:on_active_condition_change(?SalesActivity_SLPill, 1),
		log_mount_op(0, 7,
			gamedbProc:term_to_dbstring([Shouling#shouling.pill1, Shouling#shouling.pill2, Shouling#shouling.pill3]),
			gamedbProc:term_to_dbstring([NowShouling#shouling.pill1, NowShouling#shouling.pill2, NowShouling#shouling.pill3]))
	catch
		ErrCode -> player:send(#pk_GS2U_ShoulingEatPillRet{role_id = RoleID, err_code = ErrCode})
	end.

shouling_add_lv(RoleID, CostList) ->
	try
		?CHECK_THROW(role_data:is_role_exist(RoleID), ?ERROR_NoRole),
		?ERROR_CHECK_THROW(check_func_open()),
		Shouling = case get_shouling(RoleID) of #shouling{} = M -> M; _ -> #shouling{} end,
		#mountSoulBreakCfg{maxLv = MaxLv} = cfg_mountSoulBreak:getRow(Shouling#shouling.break_lv),
		F = fun({ItemId, Num}, Ret) ->
			ExpItemCfg = cfg_mountSoulExpItemNew:getRow(ItemId),
			case ExpItemCfg =:= {} of ?FALSE -> skip; _ -> throw(?ERROR_Cfg) end,
			ExpItemCfg#mountSoulExpItemNewCfg.exp * Num + Ret
			end,
		AddExp = lists:foldl(F, 0, CostList),

		case bag_player:delete_prepare(CostList) of
			{?ERROR_OK, P} ->
				{NewLv, NewExp} = calc_shouling_exp(Shouling#shouling.lv, Shouling#shouling.exp + AddExp, MaxLv),
				bag_player:delete_finish(P, ?REASON_Shouling_add_lv),
				update_shouling(RoleID, Shouling#shouling{
					lv = NewLv, exp = NewExp
%%					skill_t_mask = fix_skill_t_mask(cfg_mountSkillOpensNew:rows(), NewLv, Shouling#shouling.skill_t_mask)
				}, ?TRUE),
				time_limit_gift:check_open(?TimeLimitType_SLSkillTBoxOpen),
				activity_new_player:on_active_condition_change(?SalesActivity_SLAddLv, 1),

				OldLevel = Shouling#shouling.lv,
				PlayerText = player:getPlayerText(),
				[{First, Next} | _] = df:getGlobalSetupValueList(noticeRule39, [{50, 50}]),
				F1 = fun(Lv) ->
					marquee:sendChannelNotice(0, 0, mount_ShouLV,
						fun(Language) ->
							language:format(language:get_server_string("Mount_ShouLV", Language),
								[PlayerText, Lv])
						end)
					 end,
				[F1(Lv) || Lv <- lists:seq(OldLevel, NewLv), Lv > OldLevel, Lv >= First, (Lv - First) rem Next =:= 0],

				%% 检查开启技能格子
%%				case NewLv =/= Shouling#shouling.lv of
%%					?TRUE -> check_open_skill_box(RoleID, 1);
%%					?FALSE -> ok
%%				end,

				log_mount_op(0, 8, lists:concat([Shouling#shouling.lv, "(", Shouling#shouling.exp, ")"]), lists:concat([NewLv, "(", NewExp, ")"]));
			{CostErr, _} -> throw(CostErr)
		end,
		player:send(#pk_GS2U_ShoulingAddLvRet{role_id = RoleID, err_code = ?ERROR_OK}),
		calc_shouling_prop(RoleID),
		put_prop(),
		attainment:check_attainment(?Attainments_Type_MountSoulLv),
		player_task:refresh_task(?Task_Goal_ShoulingLv),
		seven_gift:check_task(?Seven_Type_ShouLingLv),
		guide:check_open_func(?OpenFunc_TargetType_MountSoul),
		genius:check_genius_effect(?Genius_OpenType_ShoulingLv)
	catch
		ErrCode -> player:send(#pk_GS2U_ShoulingAddLvRet{role_id = RoleID, err_code = ErrCode})
	end.


%%fix_skill_t_mask([], _, Ret) -> Ret;
%%fix_skill_t_mask([#mountSkillOpensNewCfg{needLv = Lv, vIPLv = VipLv, needItem = Cost, needCoin = NeedCoin, iD = Index} | T], YLLv, Ret) ->
%%	case YLLv >= Lv andalso (Ret bsr Index) band 1 == 0 andalso VipLv =:= 0 andalso Cost =:= [] andalso NeedCoin =:= [] of
%%		?TRUE -> fix_skill_t_mask(T, YLLv, Ret bor (1 bsl Index));
%%		_ -> fix_skill_t_mask(T, YLLv, Ret)
%%	end.

skill_p_put_on(RoleID, Pos, MountId, _SkillIndex) ->
	try
		?CHECK_THROW(role_data:is_role_exist(RoleID), ?ERROR_NoRole),
		?ERROR_CHECK_THROW(check_func_open()),
		Mount = get_mount(MountId),
		case get_expire_type(Mount) of
			2 -> throw(?ErrorCode_mount_time_NoSkill);%%限时，技能属性不生效，无法镶嵌
			_ -> ok
		end,
		case Mount =:= {} of ?FALSE -> skip; _ -> throw(?ERROR_Cfg) end,
		Shouling = case get_shouling(RoleID) of #shouling{} = M -> M; _ -> #shouling{} end,

		#mountAwakenNewCfg{skill = Skill} = cfg_mountAwakenNew:getRow(MountId, Mount#mount.awaken_lv),

		%% 注意数据类型
		%% 获得skill_p中技能ID列表
		SkillIdList = get_skill_p_list(Shouling#shouling.skill_p, []),
		case skill_player:check_skill_assembling_type(element(2, Skill), SkillIdList) of
			?TRUE -> skip;
			_ -> throw(?ErrorCode_Skill_TypeRepeat)
		end,
		case is_skill_box_open(RoleID, Pos) of
			?TRUE -> ok;
			?FALSE -> throw(?ErrorCode_Mount_NoSkillPos)
		end,

		%% 若已装备在其他角色上则先卸下
		RoleIDList = role_data:get_all_role_id(),
		F = fun(RoleID0) ->
			SL = get_shouling(RoleID0),
			SkillPList = SL#shouling.skill_p,
			SkillInfoList = [SkillInfo || {_, M, _} = SkillInfo <- SkillPList, M =:= MountId],
			case SkillInfoList of
				[{Pos0, MountId, _} | _] ->
					skill_p_put_off(RoleID0, Pos0);
				[] ->
					skip
			end
			end,
		lists:foreach(F, RoleIDList -- [RoleID]),

		NewShouling = Shouling#shouling{skill_p = lists:keystore(Pos, 1, Shouling#shouling.skill_p, {Pos, MountId, 0})},
		update_shouling(RoleID, NewShouling, ?FALSE),
		player:send(#pk_GS2U_ShoulingSkillUpdate{role_id = RoleID, skills = [#pk_ShoulingSkill{pos = Pos, mount_id = MountId}]}),
		player:send(#pk_GS2U_ShoulingSkillOpRet{role_id = RoleID, err_code = ?ERROR_OK, type = 0}),
		refresh_skill(),
		calc_shouling_prop(RoleID),
		put_prop(),
		player_task:refresh_task([?Task_Goal_MountSkillP]),
		log_mount_op(0, 9, gamedbProc:term_to_dbstring(Shouling#shouling.skill_p), gamedbProc:term_to_dbstring(NewShouling#shouling.skill_p))
	catch
		ErrCode -> player:send(#pk_GS2U_ShoulingSkillOpRet{role_id = RoleID, err_code = ErrCode, type = 0})
	end.

get_skill_p_list([], Ret) -> Ret;
get_skill_p_list([{_, 0, _} | T], Ret) -> get_skill_p_list(T, Ret);
get_skill_p_list([{_, MountId, _} | T], Ret) ->
	try
		Mount = get_mount(MountId),
		case Mount =:= {} of ?FALSE -> skip; _ -> throw(?ERROR_Cfg) end,
		#mountAwakenNewCfg{skill = {_, SkillId, _}} = cfg_mountAwakenNew:getRow(MountId, Mount#mount.awaken_lv),
		get_skill_p_list(T, [SkillId | Ret])
	catch
		ErrCode ->
			?LOG_ERROR("mount get_skill_p_list err :~p", [ErrCode]),
			get_skill_p_list(T, Ret)
	end.

skill_p_put_off(RoleID, Pos) ->
	try
		?CHECK_THROW(role_data:is_role_exist(RoleID), ?ERROR_NoRole),
		?ERROR_CHECK_THROW(check_func_open()),
		Shouling = case get_shouling(RoleID) of #shouling{} = M -> M; _ -> #shouling{} end,
		case is_skill_box_open(RoleID, Pos) of
			?TRUE -> ok;
			?FALSE -> throw(?ErrorCode_Mount_NoSkillPos)
		end,
		NewShouling = Shouling#shouling{skill_p = lists:keyreplace(Pos, 1, Shouling#shouling.skill_p, {Pos, 0, 0})},
		update_shouling(RoleID, NewShouling, ?FALSE),
		player:send(#pk_GS2U_ShoulingSkillUpdate{role_id = RoleID, skills = [#pk_ShoulingSkill{pos = Pos, mount_id = 0}]}),
		player:send(#pk_GS2U_ShoulingSkillOpRet{role_id = RoleID, err_code = ?ERROR_OK, type = 1}),
		refresh_skill(),
		calc_shouling_prop(RoleID),
		put_prop(),
		player_task:refresh_task([?Task_Goal_MountSkillP]),
		log_mount_op(0, 9, gamedbProc:term_to_dbstring(Shouling#shouling.skill_p), gamedbProc:term_to_dbstring(NewShouling#shouling.skill_p))
	catch
		ErrCode -> player:send(#pk_GS2U_ShoulingSkillOpRet{role_id = RoleID, err_code = ErrCode, type = 1})
	end.

%% 原来的技能打造使用的逻辑
%%sort_make_skill(MountIdList) ->
%%	F = fun(MountId) ->
%%		try
%%			#mount{awaken_lv = AwakenLv} = get_mount(MountId),
%%			#mountAwakenNewCfg{skill = {_, SkillId, _}} = cfg_mountAwakenNew:getRow(MountId, AwakenLv),
%%			#skillBaseCfg{skillCharacter = C} = cfg_skillBase:getRow(SkillId),
%%			{MountId, C}
%%		catch
%%			Class:ExcReason:Stacktrace ->
%%				?LOG_ERROR(?LOG_STACKTRACE(Class, ExcReason, Stacktrace)),
%%				{MountId, 0}
%%		end
%%		end,
%%	NewList = lists:map(F, MountIdList),
%%	New = lists:reverse(lists:keysort(2, NewList)),
%%	[I || {I, _} <- New].
%%
%%%% Ret 最终结果  Ret1 打造成功\失败次数
%%skill_t_make([], _, Ret, Ret1) -> {Ret, Ret1};
%%skill_t_make([Index | T], MountIdList, Ret, {R1, R2}) ->
%%	case skill_t_make_1(MountIdList, Ret) of
%%		0 -> skill_t_make(T, MountIdList, [{Index, 0} | Ret], {R1 + 1, R2});
%%		MountID ->
%%			NewMountIdList = lists:delete(MountID, MountIdList),
%%			skill_t_make(T, NewMountIdList, [{Index, MountID} | Ret], {R1, R2 + 1})
%%	end.

%%skill_t_make_1([], _Exists) -> 0;
%%skill_t_make_1([MountId | T], Exists) ->
%%	case lists:keyfind(MountId, 2, Exists) of
%%		?FALSE ->
%%			Rand = rand:uniform(10000),
%%			case cfg_mountSkillMakeNew:getRow(MountId) of
%%				#mountSkillMakeNewCfg{makePercent = P} when Rand < P -> MountId;
%%				_ -> skill_t_make_1(T, Exists)
%%			end;
%%		_ -> skill_t_make_1(T, Exists)
%%	end.

rand_skill_t_list(Indexes, MountIDIndexList, LockSkillList) ->
	F = fun({MountId, Index}, MapAcc) ->
		#mount{level = Level, star = Star} = get_mount(MountId),
		%% 注意数据类型
		#mountStarNewCfg{skill = SkillList} = cfg_mountStarNew:getRow(MountId, Star),
		{Type, Param, _, SkillID, _} = lists:nth(Index, SkillList),
		case Type of
			0 ->
				#skillBaseCfg{skillCharacter = Char} = cfg_skillBase:getRow(SkillID),
				case lists:any(fun({_, MountID_, Index_}) ->
					MountId =:= MountID_ andalso Index =:= Index_ end, LockSkillList) of
					?FALSE ->
						MountList0 = maps:get(Char, MapAcc, []),
						maps:put(Char, [{MountId, Index} | MountList0], MapAcc);
					_ ->
						MapAcc
				end;
			1 ->
				case Level >= Param of
					?TRUE ->
						#skillBaseCfg{skillCharacter = Char} = cfg_skillBase:getRow(SkillID),
						case lists:any(fun({_, MountID_, Index_}) ->
							MountId =:= MountID_ andalso Index =:= Index_ end, LockSkillList) of
							?FALSE ->
								MountList0 = maps:get(Char, MapAcc, []),
								maps:put(Char, [{MountId, Index} | MountList0], MapAcc);
							_ ->
								MapAcc
						end;
					?FALSE ->
						MapAcc
				end;
			_ ->
				MapAcc
		end
		end,
	CharMountMap = lists:foldl(F, maps:new(), MountIDIndexList),
	%% [{Char, MountIDList}]
	CharMountList = lists:reverse(lists:keysort(1, maps:to_list(CharMountMap))),
	MountIDNum = lists:foldl(fun(CharMountIDList, Acc) ->
		length(element(2, CharMountIDList)) + Acc end, 0, CharMountList),
	LockMountList = [{P1, P2} || {_, P1, P2} <- LockSkillList],
	{ChosenMountIDList, SuccessTimes} = rand_skill_t_list(CharMountList, length(Indexes), 0, [], LockMountList),
	FixChosenMountIDList =
		case length(ChosenMountIDList) < length(Indexes) of
			?TRUE ->
				ChosenMountIDList ++ lists:duplicate(length(Indexes) - length(ChosenMountIDList), {0, 0});
			?FALSE ->
				ChosenMountIDList
		end,
	FailTimes =
		case MountIDNum < length(Indexes) of
			?TRUE ->
				MountIDNum - SuccessTimes;
			?FALSE ->
				length(Indexes) - SuccessTimes
		end,
	{lists:zip(Indexes, FixChosenMountIDList), {SuccessTimes, FailTimes}}.

rand_skill_t_list([], _, SuccessTimes, MountIDListAcc, _) ->
	{MountIDListAcc, SuccessTimes};
rand_skill_t_list(_, 0, SuccessTimes, MountIDListAcc, _) ->
	{MountIDListAcc, SuccessTimes};
rand_skill_t_list([{Char, MountIDList} | T], MaxRandTimes, SuccessTimesAcc, MountIDListAcc, LockMountList) ->
	TypeList = [get_AssemblingType(N) || N <- MountIDListAcc ++ LockMountList],
	%%去除重复类型技能后的列表
	MountIDList2 = [N || N <- MountIDList, not lists:member(get_AssemblingType(N), TypeList)],
	case length(MountIDList2) =:= 0 of
		?TRUE ->%%如果id为空，直接下一品质库
			rand_skill_t_list(T, MaxRandTimes, SuccessTimesAcc, MountIDListAcc, LockMountList);
		?FALSE ->
			%%失败次数，length(ChosenMountIDList)-FailNum 就是列表中真实存在的id数  这里ChosenMountIDList长度不可能为0
			%% 因为前面判断了不为空，另外ChosenMountIDList返回前已倒置
			ChosenMountIDList = choose_rand_id_list(MountIDList2, MaxRandTimes, TypeList),
			F = fun(_, Acc1) ->
				Rand = rand:uniform(10000),
				P =
					case cfg_mountSkillMakeNew:getRow(Char) of
						{} ->
							0;
						#mountSkillMakeNewCfg{makePercent = P1} ->
							P1
					end,
				case Rand < P of
					?TRUE ->
						Acc1 + 1;
					?FALSE ->
						Acc1
				end
				end,
			RandTimes = length(ChosenMountIDList),%%本轮打造的次数
			SuccessTimes = lists:foldl(F, 0, lists:seq(1, RandTimes)),%%本轮打造成功的次数
			case SuccessTimes =:= 0 of
				?TRUE ->%%本轮没有打造成功任何技能，直接下一品质库
					rand_skill_t_list(T, MaxRandTimes, SuccessTimesAcc, MountIDListAcc, LockMountList);
				?FALSE ->%%本轮打造成功过技能，SuccessTimes不可能比可以使用的ChosenMountIDList更长
					NewChosenMountIDList = lists:sublist(ChosenMountIDList, 1, SuccessTimes),
					rand_skill_t_list(T, MaxRandTimes - SuccessTimes, SuccessTimesAcc + SuccessTimes, NewChosenMountIDList ++ MountIDListAcc, LockMountList)
			end
	end.

choose_rand_id_list(IDList, Num, TypeList) ->
	choose_rand_id_list(IDList, Num, [], TypeList).

choose_rand_id_list([], _, Acc, _) ->
	lists:reverse(Acc);
choose_rand_id_list(_, 0, Acc, _) ->
	lists:reverse(Acc);
choose_rand_id_list(IDList, Num, Acc, TypeList) ->
	WKList = [{1, {W, P}} || {W, P} <- IDList, not lists:member(get_AssemblingType({W, P}), TypeList)],
	ChosenID = common:getRandomValueFromWeightList(WKList, {0, 0}),
	case ChosenID =:= {0, 0} of
		?TRUE ->
			choose_rand_id_list(lists:delete(ChosenID, IDList), Num - 1, Acc, TypeList);
		?FALSE ->
			choose_rand_id_list(lists:delete(ChosenID, IDList), Num - 1, [ChosenID | Acc], [get_AssemblingType(ChosenID) | TypeList])
	end.

%%获取坐骑被动技能类型
get_AssemblingType({MountId, P}) ->
	#mount{star = Star} = get_mount(MountId),
	#mountStarNewCfg{skill = SkillList} = cfg_mountStarNew:getRow(MountId, Star),
	{_, _, _, SkillId, _} = lists:nth(P, SkillList),
	#skillBaseCfg{assemblingType = AssemblingType} = cfg_skillBase:getRow(SkillId),
	AssemblingType.


%% 获取装配的被动技能
refresh_skill() -> skill_player:on_skill_change().

get_skill_list(RoleId) ->
	Shouling = case get_shouling(RoleId) of
				   #shouling{} = M -> M;
				   _ -> #shouling{}
			   end,

	GetSkillPIndexFun = fun
							(1) -> ?SkillPos_22;
							(2) -> ?SkillPos_23;
							(3) -> ?SkillPos_24;
							(4) -> ?SkillPos_25;
							(5) -> ?SkillPos_26
						end,

	Fun = fun({Pos, MountId, _}, Ret) ->
		case get_mount(MountId) of
			#mount{awaken_lv = Awaken, expire_time = 0} ->
				case cfg_mountAwakenNew:getRow(MountId, Awaken) of
					#mountAwakenNewCfg{skill = {_, SkillId, _}} ->
						[{1, SkillId, GetSkillPIndexFun(Pos)} | Ret];
					_ -> Ret
				end;
			_ -> Ret
		end
		  end,
	S1 = lists:foldl(Fun, [], Shouling#shouling.skill_p),

	GetSkillTIndexFun = fun
							(1) -> ?SkillPos_27;
							(2) -> ?SkillPos_28;
							(3) -> ?SkillPos_29;
							(4) -> ?SkillPos_30;
							(5) -> ?SkillPos_31
						end,

	Fun1 = fun({Pos, MountId, SkillIdx, _}, Ret) ->
		case get_mount(MountId) of
			#mount{level = Lv, star = Star, expire_time = 0} ->
				#mountStarNewCfg{skill = SkillList} = cfg_mountStarNew:getRow(MountId, Star),
				case SkillIdx =< length(SkillList) of
					?FALSE -> Ret;
					?TRUE ->
						{Type, Param, 1, SkillId, _} = lists:nth(SkillIdx, SkillList),
						case Type of
							0 ->
								[{1, SkillId, GetSkillTIndexFun(Pos)} | Ret];
							1 ->
								case Lv >= Param of
									?TRUE ->
										[{1, SkillId, GetSkillTIndexFun(Pos)} | Ret];
									?FALSE ->
										Ret
								end;
							_ ->
								Ret
						end
				end;
			_ -> Ret
		end
		   end,
	S2 = lists:foldl(Fun1, [], Shouling#shouling.skill_t),
	S1 ++ S2.


%% 操作 0-add 1-升级 2-突破 3-升星 4-羽化 5-炼魂 6-羁绊激活 7-魔灵吃药 8-魔灵升级
%% 9-魔灵技能装配 10-魔灵装备 11-魔灵装备升级 12-魔灵装备突破 13-开启触发技能格子 14-触发技能打造 15-转生 16-元素觉醒 17-突破 18-升星道具-激活 19-升星道具-升星 20-升星道具-升级
log_mount_op(Id, Op, P1, P2) ->
	table_log:insert_row(log_mount_op, [player:getPlayerID(), time:time(), Id, Op, P1, P2]).


%% 坐骑使用升级升星卡
mount_lv_star_card_1(ItemCfg) ->
	#itemCfg{useParam1 = MountID, useParam2 = ToLv, useParam3 = ToStar, useParam4 = ExpItemId} = ItemCfg,
	%% 判断激活 没有激活则激活(Sign 用来判断坐骑是玩家激活还是道具卡激活；0 玩家激活则升星需要返还道具，1 不需要返还)
	NowTime = time:time(),
	{Mount, Sign} = case get_mount(MountID) of
						#mount{expire_time = ExTime} when ExTime > NowTime ->%%限时激活不能养成
							throw(?ErrorCode_mount_time_NoDevelop);
						#mount{expire_time = 0} = M -> {M, 0};%%永久
						_ ->%%未激活
							%% 初始化坐骑 存入进程字典
							BaseCfg = cfg_mountBaseNew:getRow(MountID),
							case BaseCfg =:= {} of ?FALSE -> skip; _ -> throw(?ERROR_Cfg) end,
							#mountBaseNewCfg{starIniti = StarIniti, rareType = RareType} = BaseCfg,
							Mount1 = #mount{
								mount_id = MountID, star = StarIniti
							},
							MountList = get_mount_list(),
							NewMountList = lists:keystore(Mount1#mount.mount_id, #mount.mount_id, MountList, Mount1),
							set_mount_list(NewMountList),
%%							on_mount_equip(0, MountID),
							log_mount_op(MountID, 18, 0, 0),
							player_task:refresh_task([?Task_Goal_MountCount, ?Task_Goal_MountActive, ?Task_Goal_MountAllLv]),
							time_limit_gift:check_open(?TimeLimitType_GetMount),
							activity_new_player:on_func_open_check(?ActivityOpenType_GetMount, {MountID}),
							prophecy:refresh_task_by_type(0, ?TaskType_companion, ?TaskType_companion_Mount),
							%% 获得S级以上的广播
							case RareType >= 0 andalso not lists:keymember(MountID, 1, df:getGlobalSetupValueList(mount_No, [])) of
								?TRUE ->
									PlayerText = player:getPlayerText(),
									marquee:sendChannelNotice(0, 0, mount_GetNew,
										fun(Language) ->
											language:format(language:get_server_string("Mount_GetNew", Language),
												[PlayerText, richText:getItemText(MountID, Language)])
										end);
								_ -> skip
							end,
							{Mount1, 1}
					end,
	case ToLv > cfg_mountLevelNew:keys_length() of ?TRUE -> throw(?ERROR_Cfg);_ -> skip end, %% 不能超过最大等级
	#mountStarAttrNewCfg{starMax = MaxStar} = get_mount_star_cfg(MountID, Mount#mount.star),
	case ToStar > MaxStar of ?TRUE -> throw(?ERROR_Cfg);_ -> skip end, %% 不能超过最大星级
	ItemList1 = case ToLv of
					0 -> [];
					_ ->
						case Mount#mount.level >= ToLv of
							%% 等级已经达到卡片配置 返回经验道具
							?TRUE ->
								%% 返还升到卡片配置等级的经验道具
								[{ItemID}] = ExpItemId,
								LvItemList = get_level_item(ToLv, ItemID, 0),
								%% 返还升到卡片配置等级所消耗的突破道具
								BreakLv = get_break(ToLv),
								BreakItemList = get_break_item(BreakLv),
								%% 返回道具
								item:item_merge(LvItemList) ++ item:item_merge(BreakItemList);
							_ ->
								item_add_lv(ItemCfg, Mount#mount.star)
						end
				end,
	ItemList2 = case ToStar of
					0 ->
						case Sign of
							0 -> get_star_item(MountID, 1); %% 只使用升级卡，返还激活消耗的碎片
							_ -> []
						end;
					_ ->
						case Mount#mount.star >= ToStar of
							?TRUE ->
								%% 已经达到卡片配置星级，返还升星道具
								StarItemList = get_star_item(MountID, ToStar),
								%% 返回道具
								item:item_merge(StarItemList);
							_ ->
								%% 卡片道具升星
								item_add_star(ItemCfg, Mount#mount.level, Sign)
						end
				end,
	guide:check_open_func(?OpenFunc_TargetType_Mount),
	ItemList = ItemList1 ++ ItemList2,
	attainment:check_attainment([?Attainments_Type_MountCount, ?Attainments_Type_MountAllCount]),
	case ItemList of
		[] -> ok;
		_ ->
			player_item:reward(ItemList, [], [], ?REASON_mount_add_item),
			player_item:show_get_item_dialog(item:item_merge(ItemList), [], [], 0, 4)
	end.

%% 坐骑使用道具卡升级
item_add_lv(ItemCfg, OldStar) ->
	#itemCfg{useParam1 = MountID, useParam2 = ToLv, useParam3 = ToStar, useParam4 = ExpItemId} = ItemCfg,
	try
		Mount = get_mount(MountID),
		%% 返还升到当前等级的经验道具
		[{ItemID}] = ExpItemId,
		LvItemList = get_level_item(Mount#mount.level, ItemID, Mount#mount.exp),
		%% 返还升到当前等级所消耗的突破道具,
		BreakItemList = get_break_item(Mount#mount.break_lv),
		%% 道具返还
		ItemList = item:item_merge(LvItemList) ++ item:item_merge(BreakItemList),
		%% 更新坐骑信息
		BreakLv1 = get_break(ToLv),
		NewMount = Mount#mount{level = ToLv, exp = 0, break_lv = BreakLv1},
		%% 判断是否进行道具升星
		case OldStar >= ToStar of
			?TRUE ->
				update_mount(NewMount),
				player:send(#pk_GS2U_MountNewAddLevelRet{mount_id = MountID, err_code = ?ERROR_OK});
			?FALSE ->
				%% 存入进程字典
				MountList = get_mount_list(),
				NewMountList = lists:keystore(NewMount#mount.mount_id, #mount.mount_id, MountList, NewMount),
				set_mount_list(NewMountList)
		end,
		calc_mount_prop(NewMount),
		put_prop(),
		[refresh_skill() || lists:member(MountID, [EqMountID || #role{mount_id = EqMountID} <- role_data:get_role_list()])],
		attainment:check_attainment(?Attainments_Type_MountLv),
		time_limit_gift:check_open(?TimeLimitType_MountLv),
		seven_gift:check_task(?Seven_Type_MountLv),
		player_task:refresh_task([?Task_Goal_MountLv, ?Task_Goal_MountAllLv]),
		activity_new_player:on_active_condition_change(?SalesActivity_MountAddLv, 1),
		log_mount_op(MountID, 20, lists:concat([Mount#mount.level, "(", Mount#mount.exp, ")"]), lists:concat([ToLv])),
		%% 返回道具
		ItemList
	catch
		ErrCode -> ErrCode
	end.

%% 坐骑使用道具卡升星
item_add_star(ItemCfg, OldLv, Sign) ->
	#itemCfg{useParam1 = MountID, useParam2 = ToLv, useParam3 = ToStar} = ItemCfg,
	try
		Mount = get_mount(MountID),
		StarCfg = cfg_mountStarNew:getRow(MountID, Mount#mount.star),
		%% 返还坐骑升到当前星级的消耗道具
		StarItem1 = case Sign of
						0 -> get_star_item(MountID, Mount#mount.star);
						1 -> []
					end,
		NewMount = Mount#mount{star = ToStar},
		%% 更新
		update_mount(NewMount),
		%% 刷新被动技（升星影响被动技）
		case cfg_mountStarNew:getRow(MountID, ToStar) of%%新星级
			#mountStarNewCfg{skillLv = L} when L =/= StarCfg#mountStarNewCfg.skillLv ->
				star_refresh_skill(MountID);
			_ -> skip
		end,
		calc_mount_prop(NewMount),
		put_prop(),
		attainment:check_attainment(?Attainments_Type_MountStar),
		activity_new_player:on_active_condition_change(?SalesActivity_MountAddStar, 1),
		player_refresh:on_refresh_mount([RoleID || #role{role_id = RoleID, mount_id = EqMountID} <- role_data:get_role_list(), EqMountID =:= MountID]),
		log_mount_op(MountID, 19, Mount#mount.star, ToStar),
		[{First, Next} | _] = df:getGlobalSetupValueList(noticeRule36, [{1, 1}]),
		case ToStar >= First andalso (ToStar - First) rem Next =:= 0 of
			?TRUE ->
				PlayerText = player:getPlayerText(),
				marquee:sendChannelNotice(0, 0, mount_StarUp,
					fun(Language) ->
						language:format(language:get_server_string("Mount_StarUp", Language),
							[PlayerText, richText:getItemText(MountID, Language), ToStar])
					end);
			_ -> skip
		end,
		%% 判断是否进行过道具升级
		case OldLv >= ToLv of
			?TRUE -> skip;
			?FALSE ->
				player:send(#pk_GS2U_MountNewAddLevelRet{mount_id = MountID, err_code = ?ERROR_OK})
		end,
		player:send(#pk_GS2U_MountNewAddStarRet{mount_id = MountID, err_code = ?ERROR_OK}),
		item:item_merge(StarItem1)
	catch
		ErrCode -> player:send(#pk_GS2U_MountNewAddStarRet{mount_id = MountID, err_code = ErrCode})
	end.

%% 升到指定等级需要消耗的经验道具
get_level_item(Lv, ItemID, Exp1) ->
	ItemExp = case cfg_mountExpItemNew:getRow(ItemID) of
				  {} -> throw(?ERROR_Param);
				  #mountExpItemNewCfg{exp = E1} -> E1
			  end,
	AllExp = get_level_item_1(Lv, 0) + Exp1,
	ItemNum = ceil(AllExp / ItemExp),%% 返还的经验道具数量
	[{ItemID, ItemNum, 1}].
get_level_item_1(1, Ret) -> Ret;
get_level_item_1(Lv, Ret) ->
	%% 获得升到Lv级需要的经验
	Exp = case cfg_mountLevelNew:getRow(Lv - 1) of
			  {} -> 0;
			  #mountLevelNewCfg{exp = E} -> E
		  end,
	get_level_item_1(Lv - 1, Ret + Exp).

%% 获得指定等级下的最大突破等级
get_break(Level) ->
	get_break_1(Level, 0).
get_break_1(Lv, N) ->
	#mountBreakNewCfg{maxLv = MaxLv} = cfg_mountBreakNew:getRow(N),
	case Lv > MaxLv of
		?TRUE -> get_break_1(Lv, N + 1);
		_ -> N
	end.

%% 获得指定突破等级所消耗的所有突破道具
get_break_item(BreakLv) ->
	get_break_item(BreakLv, []).
get_break_item(0, Ret) -> Ret;
get_break_item(BreakLv, Ret) ->
	#mountBreakNewCfg{needItem = NeedItem} = cfg_mountBreakNew:getRow(BreakLv),
	Item = [{X, Y, 1} || {X, Y} <- NeedItem],
	get_break_item(BreakLv - 1, Ret ++ Item).


%% 获得升到指定星级需要的消耗道具
get_star_item(MountID, Star) ->
	get_star_item(MountID, Star, []).

get_star_item(_MountID, 0, Ret) -> Ret;
get_star_item(MountID, Star, Ret) ->
	case get_mount_star_cost(MountID, Star) of
		[] -> get_star_item(MountID, Star - 1, Ret);
		NeedItem -> get_star_item(MountID, Star - 1, Ret ++ [{X, Y, 1} || {X, Y} <- NeedItem])
	end.

%% TODO 仅坐骑 部分功能需特殊检测
check_func_open() ->
	player:check_func_open(?WorldVariant_Switch_Mount, ?OpenAction_Mount).

get_other_used_skill_list(RoleID) ->
	RoleIDList = lists:delete(RoleID, role_data:get_all_role_id()),
	F = fun(PriRoleID, Ret) ->
		SL = get_shouling(PriRoleID),
		[{MountID, Index} || {_, MountID, Index, _} <- SL#shouling.skill_t, MountID =/= 0] ++ Ret
		end,
	lists:foldl(F, [], RoleIDList).

check_auto_equip(MountId) ->
	RoleList = role_data:get_role_list(),
	SortRoleList = role_data:leader_first(RoleList),
	check_auto_equip(SortRoleList, MountId, ?FALSE).

check_auto_equip([], _, _) ->
	ok;
check_auto_equip(_, _, ?TRUE) ->
	ok;
check_auto_equip([Role | T], MountID, _) ->
	IsUse =
		case Role#role.mount_id of
			0 ->
				on_mount_equip_1(Role#role.role_id, 0, MountID),
				?TRUE;
			MountID ->
				on_mount_equip_1(Role#role.role_id, 0, MountID),
				?TRUE;
			OldMountID ->%%目前装配的
				NowTime = time:time(),
				case get_mount(OldMountID) of
					#mount{expire_time = ExTime} when ExTime > NowTime ->%%目前装配的坐骑是限时的，并且未过期，就不修改
						skip;
					_ ->%%过期了  或者永久的，就装配为新的坐骑
						on_mount_equip_1(Role#role.role_id, 0, MountID),
						?TRUE
				end
		end,
	check_auto_equip(T, MountID, IsUse).

%%检查该坐骑当前激活状态，0未激活 1 已永久激活 2 限时激活
get_expire_type(MountId) when is_integer(MountId) ->
	case get_mount(MountId) of%%仅限时和永久可直接查到
		{} -> 0;
		Mount -> get_expire_type(Mount)
	end;
get_expire_type(#mount{expire_time = ExpireTime}) ->
	NowTime = time:time(),
	case ExpireTime of
		0 -> 1;
		Time when Time > NowTime -> 2;
		_ -> 0
	end.

get_mount_index_list(SkillList, MountID, Lv) ->
	get_mount_index_list(SkillList, MountID, Lv, 1, []).

get_mount_index_list([], _, _, _, Acc) ->
	Acc;
get_mount_index_list([{Type, Param, _, _, _} | T], MountID, Lv, Index, Acc) ->
	case Type of
		0 ->
			get_mount_index_list(T, MountID, Lv, Index + 1, [{MountID, Index} | Acc]);
		1 ->
			case Lv >= Param of
				?TRUE ->
					get_mount_index_list(T, MountID, Lv, Index + 1, [{MountID, Index} | Acc]);
				?FALSE ->
					get_mount_index_list(T, MountID, Lv, Index + 1, Acc)
			end;
		_ ->
			get_mount_index_list(T, MountID, Lv, Index + 1, Acc)
	end.

%% attrAdd字段为空则视为需自动开启
auto_open_skill_box(RoleID) ->
	Shouling = case get_shouling(RoleID) of
				   {} -> #shouling{};
				   SL -> SL
			   end,

	F1 = fun(Index) ->
		IsNotOpen = not is_skill_box_open(RoleID, Index),
		case cfg_mountSkillOpenNew:getRow(Index) of
			#mountSkillOpenNewCfg{attrAdd = []} when IsNotOpen ->
				%% 无需处理错误
				_Err = open_skill_box(RoleID, Index, Shouling#shouling.lv);
			_ ->
				skip
		end
		 end,
	lists:foreach(F1, cfg_mountSkillOpenNew:getKeyList()),
	F2 = fun(Index) ->
		IsNotOpen = not is_skill_t_box_open(RoleID, Index),
		case cfg_mountSkillOpensNew:getRow(Index) of
			#mountSkillOpensNewCfg{attrAdd = []} when IsNotOpen ->
				skill_t_slot_active(RoleID, Index, ?FALSE);
			_ ->
				skip
		end
		 end,
	lists:foreach(F2, cfg_mountSkillOpensNew:getKeyList()).

get_best_mount_id(MountIDList) ->
	get_best_mount_id(MountIDList, -1, 0).

get_best_mount_id([], _, MountIDAcc) ->
	MountIDAcc;
get_best_mount_id([MountID | T], RareAcc, MountIDAcc) ->
	case cfg_mountBaseNew:getRow(MountID) of
		{} ->
			get_best_mount_id(T, RareAcc, MountIDAcc);
		#mountBaseNewCfg{rareType = Rare} ->
			case Rare > RareAcc of
				?TRUE ->
					get_best_mount_id(T, Rare, MountID);
				?FALSE ->
					get_best_mount_id(T, RareAcc, MountIDAcc)
			end
	end.

%%根据坐骑id和星级获取对应星级配置
get_mount_star_cfg(MountId, Star) ->
	case cfg_mountBaseNew:getRow(MountId) of
		#mountBaseNewCfg{rareType = RareType} ->
			cfg_mountStarAttrNew:getRow(RareType, Star);
		_ -> {}
	end.

%%获取坐骑id的升星消耗数据
get_mount_star_cost(MountId, Star) ->
	case cfg_mountBaseNew:getRow(MountId) of
		#mountBaseNewCfg{rareType = RareType, consumeStar = ItemId} ->
			case cfg_mountStarAttrNew:getRow(RareType, Star) of
				#mountStarAttrNewCfg{needItem = Num} -> [{ItemId, Num}];
				_ -> []
			end;
		_ -> []
	end.

calc_mount_cost_list(ExpItemIDList, RestExp) ->
	calc_mount_cost_list(ExpItemIDList, RestExp, []).

calc_mount_cost_list([], _, CostListAcc) ->
	CostListAcc;
calc_mount_cost_list(_, RestExp, CostListAcc) when RestExp =< 0 ->
	CostListAcc;
calc_mount_cost_list([ItemID | ExpItemIDList], RestExp, CostListAcc) ->
	ExpCfg = cfg_mountExpItemNew:getRow(ItemID),
	#mountExpItemNewCfg{exp = UnitExp} = ExpCfg,
	Amount = bag_player:get_item_amount(ItemID),
	case Amount of
		0 ->
			calc_mount_cost_list(ExpItemIDList, RestExp, CostListAcc);
		_ ->
			AllExp = UnitExp * Amount,
			case AllExp >= RestExp of
				?TRUE ->
					UseAmount = ceil(RestExp / UnitExp),
					calc_mount_cost_list(ExpItemIDList, RestExp - UnitExp * UseAmount, [{ItemID, UseAmount} | CostListAcc]);
				?FALSE ->
					calc_mount_cost_list(ExpItemIDList, RestExp - AllExp, [{ItemID, Amount} | CostListAcc])
			end
	end.

calc_sl_cost_list(ExpItemIDList, RestExp) ->
	calc_sl_cost_list(ExpItemIDList, RestExp, []).

calc_sl_cost_list([], _, CostListAcc) ->
	CostListAcc;
calc_sl_cost_list(_, RestExp, CostListAcc) when RestExp =< 0 ->
	CostListAcc;
calc_sl_cost_list([ItemID | ExpItemIDList], RestExp, CostListAcc) ->
	ExpCfg = cfg_mountSoulExpItemNew:getRow(ItemID),
	#mountSoulExpItemNewCfg{exp = UnitExp} = ExpCfg,
	Amount = bag_player:get_item_amount(ItemID),
	case Amount of
		0 ->
			calc_sl_cost_list(ExpItemIDList, RestExp, CostListAcc);
		_ ->
			AllExp = UnitExp * Amount,
			case AllExp >= RestExp of
				?TRUE ->
					UseAmount = ceil(RestExp / UnitExp),
					calc_sl_cost_list(ExpItemIDList, RestExp - UnitExp * UseAmount, [{ItemID, UseAmount} | CostListAcc]);
				?FALSE ->
					calc_sl_cost_list(ExpItemIDList, RestExp - AllExp, [{ItemID, Amount} | CostListAcc])
			end
	end.