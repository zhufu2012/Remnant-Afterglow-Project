%%%-------------------------------------------------------------------
%%% @author tang
%%% @copyright (C) 2020, double game
%%% @doc
%%%         技能觉醒突破
%%% @end
%%% Created : 25. 12月 2020 13:56
%%%-------------------------------------------------------------------
-module(skill_up).
-author("tang").

-include("global.hrl").
-include("logger.hrl").
-include("db_table.hrl").
-include("netmsgRecords.hrl").
-include("error.hrl").
-include("reason.hrl").
-include("variable.hrl").
-include("record.hrl").
-include("skill.hrl").
-include("cfg_skillUp.hrl").
-include("cfg_skillUpgNew.hrl").
-include("player_task_define.hrl").
-include("prophecy.hrl").
-include("cfg_skillUpgSpecial.hrl").
-include("item.hrl").
-include("top_chart.hrl").
-include("cfg_item.hrl").
-include("activity_new.hrl").
-include("cfg_consumptionTime.hrl").
-include("cfg_skillEquip.hrl").
-include("attainment.hrl").
%% API
-export([on_init/2]).
-export([on_skill_level_up/2, on_skill_state_up/3, is_active_skill/2, get_skill_up/2, find_state_level/2]).
-export([get_skill_list/2, get_buff_list/2, get_skill_attr/1, get_skill_level/2, get_skill_level/3, get_state_level/3, check_broadcast/3,
	active_skill/2, get_item_list/2, exist_skill_book/2, get_role_msg_skill_lv/3]).
-export([list_to_skill/1, skill_to_list/1, reset_skill_back/0, get_careerlv_skill_up_times/1]).
-export([on_get_all_skill_lv_without_attack/0, on_get_all_skill_state_lv/1, on_player_online/0, check_skill_auto_study/1, get_auto_study_skill_list/0, get_skill_up/3,get_active_skill/1,
	get_skill_level2/2]).

%%-define(AutoStudyIndexList, [3, 4, 5, 6]). %% 第一职业自动学
-define(AutoStudyIndexList, []). %% 第一职业自动学

%% 创建角色
on_init(PlayerId, RoleId) ->
%% 初始化玩家技能
	InitIndexList = [Index || {Index, 0} <- cfg_skillUpgNew:getKeyList()],
	F = fun(Index, Ret) ->
		case cfg_skillUpgNew:getRow(Index, 0) of
			#skillUpgNewCfg{lvMax = MaxLv, useItem = []} when MaxLv >= 1 ->
				[#skill_up{player_id = PlayerId, role_id = RoleId, index = Index, level = 1} | Ret];
			_ -> Ret
		end
		end,
	InitSkillList = lists:foldl(F, [], InitIndexList),
	update_skill_up(InitSkillList),
	ok.

on_player_online() ->
	calc_auto_study_skill_list().

%% 获取技能列表
get_skill_list(RoleId, Career) ->
	SkillList = [Skill || #skill_up{role_id = RoleId0} = Skill <- get_skill_up(), RoleId0 == RoleId],
	get_skill_list_1(SkillList, Career, []).

get_skill_list_1([], _Career, Ret) -> Ret;
get_skill_list_1([#skill_up{index = Index, level = Level, states = States} | T], Career, Ret) ->
	case cfg_skillUpgNew:getRow(Index, 0) of
		#skillUpgNewCfg{geniusBaseID = GeniusKey} ->
			case genius:is_genius_open(GeniusKey) of
				?TRUE ->
					case cfg_skillUpgNew:getRow(Index, Level) of
						#skillUpgNewCfg{skill1004 = Skills} when Career == 1004 ->
							NewSkills = [st_fix(Skill) || {ST, _, _} = Skill <- Skills, st_filter(1, ST)],
							NewRet = get_skill_list_2(States, Index, Career, NewSkills ++ Ret),
							get_skill_list_1(T, Career, NewRet);
						#skillUpgNewCfg{skill1005 = Skills} when Career == 1005 ->
							NewSkills = [st_fix(Skill) || {ST, _, _} = Skill <- Skills, st_filter(1, ST)],
							NewRet = get_skill_list_2(States, Index, Career, NewSkills ++ Ret),
							get_skill_list_1(T, Career, NewRet);
						#skillUpgNewCfg{skill1006 = Skills} when Career == 1006 ->
							NewSkills = [st_fix(Skill) || {ST, _, _} = Skill <- Skills, st_filter(1, ST)],
							NewRet = get_skill_list_2(States, Index, Career, NewSkills ++ Ret),
							get_skill_list_1(T, Career, NewRet);
						#skillUpgNewCfg{skill1007 = Skills} when Career == 1007 ->
							NewSkills = [st_fix(Skill) || {ST, _, _} = Skill <- Skills, st_filter(1, ST)],
							NewRet = get_skill_list_2(States, Index, Career, NewSkills ++ Ret),
							get_skill_list_1(T, Career, NewRet);
						_ ->
							get_skill_list_1(T, Career, Ret)
					end;
				?FALSE ->
					get_skill_list_1(T, Career, Ret)
			end;
		_ ->
			case cfg_skillUpgSpecial:getRow(Index, Level) of
				#skillUpgSpecialCfg{skill1004 = Skills} when Career == 1004 ->
					NewSkills = [st_fix(Skill) || {ST, _, _} = Skill <- Skills, st_filter(1, ST)],
					get_skill_list_1(T, Career, NewSkills ++ Ret);
				#skillUpgSpecialCfg{skill1005 = Skills} when Career == 1005 ->
					NewSkills = [st_fix(Skill) || {ST, _, _} = Skill <- Skills, st_filter(1, ST)],
					get_skill_list_1(T, Career, NewSkills ++ Ret);
				#skillUpgSpecialCfg{skill1006 = Skills} when Career == 1006 ->
					NewSkills = [st_fix(Skill) || {ST, _, _} = Skill <- Skills, st_filter(1, ST)],
					get_skill_list_1(T, Career, NewSkills ++ Ret);
				#skillUpgSpecialCfg{skill1007 = Skills} when Career == 1007 ->
					NewSkills = [st_fix(Skill) || {ST, _, _} = Skill <- Skills, st_filter(1, ST)],
					get_skill_list_1(T, Career, NewSkills ++ Ret);
				_ ->
					get_skill_list_1(T, Career, Ret)
			end
	end;
get_skill_list_1([_ | T], Career, Ret) ->
	get_skill_list_1(T, Career, Ret).

get_skill_list_2([], _Index, _Career, Ret) -> Ret;
get_skill_list_2([{State, Level} | T], Index, Career, Ret) ->
	case cfg_skillUp:getRow(Index, State, Level) of
		#skillUpCfg{skill1004 = Skills} when Career == 1004 ->
			NewSkills = [st_fix(Skill) || {ST, _, _} = Skill <- Skills, st_filter(1, ST)],
			get_skill_list_2(T, Index, Career, NewSkills ++ Ret);
		#skillUpCfg{skill1005 = Skills} when Career == 1005 ->
			NewSkills = [st_fix(Skill) || {ST, _, _} = Skill <- Skills, st_filter(1, ST)],
			get_skill_list_2(T, Index, Career, NewSkills ++ Ret);
		#skillUpCfg{skill1006 = Skills} when Career == 1006 ->
			NewSkills = [st_fix(Skill) || {ST, _, _} = Skill <- Skills, st_filter(1, ST)],
			get_skill_list_2(T, Index, Career, NewSkills ++ Ret);
		#skillUpCfg{skill1007 = Skills} when Career == 1007 ->
			NewSkills = [st_fix(Skill) || {ST, _, _} = Skill <- Skills, st_filter(1, ST)],
			get_skill_list_2(T, Index, Career, NewSkills ++ Ret);
		_ ->
			get_skill_list_2(T, Index, Career, Ret)
	end;
get_skill_list_2([_ | T], Index, Career, Ret) ->
	get_skill_list_2(T, Index, Career, Ret).

%% 获取buff列表
get_buff_list(RoleId, Career) ->
	SkillList = [Skill || #skill_up{role_id = RoleId0} = Skill <- get_skill_up(), RoleId0 == RoleId],
	get_buff_list_1(SkillList, Career, []).

get_buff_list_1([], _Career, Ret) -> Ret;
get_buff_list_1([#skill_up{index = Index, level = Level, states = States} | T], Career, Ret) ->
	case cfg_skillUpgNew:getRow(Index, 0) of
		#skillUpgNewCfg{geniusBaseID = GeniusKey} ->
			case genius:is_genius_open(GeniusKey) of
				?TRUE ->
					case cfg_skillUpgNew:getRow(Index, Level) of
						#skillUpgNewCfg{skill1004 = Skills} when Career == 1004 ->
							NewSkills = [st_fix(Skill) || {ST, _, _} = Skill <- Skills, st_filter(2, ST)],
							NewRet = get_buff_list_2(States, Index, Career, NewSkills ++ Ret),
							get_buff_list_1(T, Career, NewRet);
						#skillUpgNewCfg{skill1005 = Skills} when Career == 1005 ->
							NewSkills = [st_fix(Skill) || {ST, _, _} = Skill <- Skills, st_filter(2, ST)],
							NewRet = get_buff_list_2(States, Index, Career, NewSkills ++ Ret),
							get_buff_list_1(T, Career, NewRet);
						#skillUpgNewCfg{skill1006 = Skills} when Career == 1006 ->
							NewSkills = [st_fix(Skill) || {ST, _, _} = Skill <- Skills, st_filter(2, ST)],
							NewRet = get_buff_list_2(States, Index, Career, NewSkills ++ Ret),
							get_buff_list_1(T, Career, NewRet);
						#skillUpgNewCfg{skill1007 = Skills} when Career == 1007 ->
							NewSkills = [st_fix(Skill) || {ST, _, _} = Skill <- Skills, st_filter(2, ST)],
							NewRet = get_buff_list_2(States, Index, Career, NewSkills ++ Ret),
							get_buff_list_1(T, Career, NewRet);
						_ ->
							get_buff_list_1(T, Career, Ret)
					end;
				?FALSE ->
					get_buff_list_1(T, Career, Ret)
			end;
		_ ->
			case cfg_skillUpgSpecial:getRow(Index, Level) of
				#skillUpgSpecialCfg{skill1004 = Skills} when Career == 1004 ->
					NewSkills = [st_fix(Skill) || {ST, _, _} = Skill <- Skills, st_filter(2, ST)],
					get_buff_list_1(T, Career, NewSkills ++ Ret);
				#skillUpgSpecialCfg{skill1005 = Skills} when Career == 1005 ->
					NewSkills = [st_fix(Skill) || {ST, _, _} = Skill <- Skills, st_filter(2, ST)],
					get_buff_list_1(T, Career, NewSkills ++ Ret);
				#skillUpgSpecialCfg{skill1006 = Skills} when Career == 1006 ->
					NewSkills = [st_fix(Skill) || {ST, _, _} = Skill <- Skills, st_filter(2, ST)],
					get_buff_list_1(T, Career, NewSkills ++ Ret);
				#skillUpgSpecialCfg{skill1007 = Skills} when Career == 1007 ->
					NewSkills = [st_fix(Skill) || {ST, _, _} = Skill <- Skills, st_filter(2, ST)],
					get_buff_list_1(T, Career, NewSkills ++ Ret);
				_ ->
					get_buff_list_1(T, Career, Ret)
			end
	end;
get_buff_list_1([_ | T], Career, Ret) ->
	get_buff_list_1(T, Career, Ret).

get_buff_list_2([], _Index, _Career, Ret) -> Ret;
get_buff_list_2([{State, Level} | T], Index, Career, Ret) ->
	case cfg_skillUp:getRow(Index, State, Level) of
		#skillUpCfg{skill1004 = Skills} when Career == 1004 ->
			NewSkills = [st_fix(Skill) || {ST, _, _} = Skill <- Skills, st_filter(2, ST)],
			get_buff_list_2(T, Index, Career, NewSkills ++ Ret);
		#skillUpCfg{skill1005 = Skills} when Career == 1005 ->
			NewSkills = [st_fix(Skill) || {ST, _, _} = Skill <- Skills, st_filter(2, ST)],
			get_buff_list_2(T, Index, Career, NewSkills ++ Ret);
		#skillUpCfg{skill1006 = Skills} when Career == 1006 ->
			NewSkills = [st_fix(Skill) || {ST, _, _} = Skill <- Skills, st_filter(2, ST)],
			get_buff_list_2(T, Index, Career, NewSkills ++ Ret);
		#skillUpCfg{skill1007 = Skills} when Career == 1007 ->
			NewSkills = [st_fix(Skill) || {ST, _, _} = Skill <- Skills, st_filter(2, ST)],
			get_buff_list_2(T, Index, Career, NewSkills ++ Ret);
		_ ->
			get_buff_list_2(T, Index, Career, Ret)
	end;
get_buff_list_2([_ | T], Index, Career, Ret) ->
	get_buff_list_2(T, Index, Career, Ret).

%%st_fix(1) -> 1;
%%st_fix(2) -> 2;
%%st_fix(3) -> 1;
%%st_fix(4) -> 2;
%%st_fix(5) -> 3;
%%st_fix(ST) -> ST.

st_fix({1, SI, SP}) -> {1, SI, SP};
st_fix({2, SI, SP}) -> {2, SI, SP};
st_fix({3, SI, SP}) -> {1, SP, SI};
st_fix({4, SI, SP}) -> {2, SP, SI};
st_fix({5, SI, SP}) -> {3, SP, SI};
st_fix({ST, SI, SP}) -> {ST, SI, SP}.

st_filter(1, 1) -> ?TRUE;
st_filter(1, 2) -> ?TRUE;
st_filter(2, 3) -> ?TRUE;
st_filter(2, 4) -> ?TRUE;
st_filter(2, 5) -> ?TRUE;
st_filter(_, _) -> ?FALSE.

%% 获取属性
get_skill_attr(RoleId) ->
	SkillList = [Skill || #skill_up{role_id = RoleId0} = Skill <- get_skill_up(), RoleId0 == RoleId],
	AttrList = get_skill_attr_1(SkillList, []),
	common:listValueMerge(AttrList).

get_skill_attr_1([], Ret) -> Ret;
get_skill_attr_1([#skill_up{index = Index, level = Level, states = States} | T], Ret) ->
	case cfg_skillUpgNew:getRow(Index, 0) of
		#skillUpgNewCfg{geniusBaseID = GeniusKey} ->
			case genius:is_genius_open(GeniusKey) of
				?TRUE ->
					case cfg_skillUpgNew:getRow(Index, Level) of
						#skillUpgNewCfg{attrAdd = Attr} ->
							NewRet = get_skill_attr_2(States, Index, Attr ++ Ret),
							get_skill_attr_1(T, NewRet);
						_ ->
							get_skill_attr_1(T, Ret)
					end
			end;
		_ ->
			case cfg_skillUpgSpecial:getRow(Index, Level) of
				#skillUpgSpecialCfg{attrAdd = Attr} ->
					get_skill_attr_1(T, Attr ++ Ret);
				_ ->
					get_skill_attr_1(T, Ret)
			end
	end;
get_skill_attr_1([_ | T], Ret) ->
	get_skill_attr_1(T, Ret).

get_skill_attr_2([], _Index, Ret) -> Ret;
get_skill_attr_2([{State, Level} | T], Index, Ret) ->
	case cfg_skillUp:getRow(Index, State, Level) of
		#skillUpCfg{attrAdd = Attr} ->
			get_skill_attr_2(T, Index, Attr ++ Ret);
		_ ->
			get_skill_attr_2(T, Index, Ret)
	end;
get_skill_attr_2([_ | T], Index, Ret) ->
	get_skill_attr_2(T, Index, Ret).

%% 获取技能等级
get_skill_level(RoleId, Index) ->
	Skill = get_skill_up(RoleId, Index),
	Skill#skill_up.level.
get_skill_level(PlayerId, RoleId, Index) ->
	Skill = get_skill_up(PlayerId, RoleId, Index),
	Skill#skill_up.level.

%% 整理玩家等级技能信息
get_role_msg_skill_lv(PlayerId, [#pk_role_skill{role_id = RoleId, skill_list = SkillList} = Role | List], Ret) ->
	NewSkillList = [S#pk_SkillBase{skill_level = get_skill_level(PlayerId, RoleId, Index)} || #pk_SkillBase{index = Index} = S <- SkillList],
	get_role_msg_skill_lv(PlayerId, List, [Role#pk_role_skill{skill_list = NewSkillList} | Ret]);
get_role_msg_skill_lv(_, _, Ret) -> Ret.

%% 获取状态等级
get_state_level(RoleId, Index, State) ->
	Skill = get_skill_up(RoleId, Index),
	find_state_level(Skill, State).

%% 其他系统激活技能
active_skill(_RoleId, 0) -> ok;
active_skill(RoleId, Index) ->
	case cfg_skillUpgNew:getRow(Index, 0) of
		#skillUpgNewCfg{lvMax = MaxLv, geniusBaseID = GeniusKey} when MaxLv >= 1 ->
			case genius:is_genius_open(GeniusKey) of
				?TRUE ->
					Skill = get_skill_up(RoleId, Index),
					NewSkill = Skill#skill_up{level = max(1, Skill#skill_up.level)},
					update_skill_up(NewSkill),
					skill_player:on_skill_change(),
					player:send(#pk_GS2U_SkillLevelUpRet{role_id = RoleId, skill_index = Index, skill_lv = NewSkill#skill_up.level}),
					check_auto_bind(NewSkill),
					check_broadcast(RoleId, Index, 0),
					log_skill_up_op(1, Index, 0, NewSkill#skill_up.level, ""),
					ok;
				?FALSE -> ok
			end;
		_ -> ok
	end.

%% 升级
on_skill_level_up(RoleId, Index) ->
	?metrics(begin
				 try
					 ?CHECK_THROW(role_data:is_role_exist(RoleId), ?ERROR_NoRole),
					 PlayerLv = player:getLevel(),
					 Career = role_data:get_role_element(RoleId, #role.career),
					 CareerLv = change_role:get_career_lv(RoleId),
					 {Err1, NewSkill, {CostItem, CostCoin}} = check_level_up(RoleId, Index, Career, CareerLv, PlayerLv),
					 ?ERROR_CHECK_THROW(Err1),
					 case NewSkill#skill_up.level =:= 1 andalso lists:keymember(Index, 1, df:getGlobalSetupValueList(jinengjihuo, [])) of
						 ?TRUE -> ok;
						 ?FALSE ->
							 Err2 = player:delete_cost(CostItem, CostCoin, ?Reason_Skill_LevelUp),
							 ?ERROR_CHECK_THROW(Err2)
					 end,
					 update_skill_up(NewSkill),
					 WithFunc = fun() ->
						 skill_player:send_skill_msg(),
						 player:send(#pk_GS2U_SkillLevelUpRet{role_id = RoleId, skill_index = Index, skill_lv = NewSkill#skill_up.level})
								end,
					 skill_player:on_skill_change(WithFunc),
					 %%成就系统 %%激活奥义*XXX技能 309 %%奥义XXX技能升级到XX级 310 %%奥义XXX技能升级到XX级 229
					 attainment:check_attainment([?Attainments_Type_ActivationSkill,?Attainments_Type_ActivationSkillLv,?Attainments_Type_SkillLv]),
					 check_auto_bind(NewSkill),
					 calc_auto_study_skill_list(),
					 check_broadcast(RoleId, Index, 0),
					 log_skill_up_op(1, Index, 0, NewSkill#skill_up.level, ""),
					 player_task:refresh_task([?Task_Goal_SkillLv, ?Task_Goal_ActiveSkill, ?Task_Goal_TargetSkillLv, ?Task_Goal_ChangeCareerSkillNum]),
					 role_task:refresh_task(RoleId, [?Task_Goal_SkillLv2, ?Task_Goal_RoleActiveSkill, ?Task_Goal_ChangeCareerSkillNum, ?Task_Goal_SkillUpTimes]),
					 prophecy:refresh_task_by_type(RoleId, ?TaskType_Skill),
					 top_chart_common:add_to_top_chart(?TopCharTypeSkillLv, player:getPlayerID(), get_all_skill_lv()),
					 activity_new_player:on_active_condition_change(?SalesActivity_SkillTotalLv_181, get_all_skill_lv_without_attack())
				 catch
					 ErrCode ->
						 player:send(#pk_GS2U_SkillLevelUpRet{err_code = ErrCode, role_id = RoleId, skill_index = Index})
				 end end).

%% 突破、觉醒
on_skill_state_up(RoleId, Index, State) ->
	?metrics(begin
				 try
					 ?CHECK_THROW(role_data:is_role_exist(RoleId), ?ERROR_NoRole),
					 ?CHECK_THROW(is_func_open(State), ?ERROR_FunctionClose),
					 Career = role_data:get_role_element(RoleId, #role.career),
					 Skill = get_skill_up(RoleId, Index),
					 {Err1, NewSkill, CostItem} = check_state_up(RoleId, Skill, State, Career),
					 ?ERROR_CHECK_THROW(Err1),
					 Err2 = player:delete_cost(CostItem, [], ?Reason_Skill_LevelUp),
					 ?ERROR_CHECK_THROW(Err2),
					 update_skill_up(NewSkill),
					 NewStateLv = case State =:= 3 of
									  ?TRUE ->
										  max(NewSkill#skill_up.level - Skill#skill_up.level, 0); %% 修炼类型发提升的等级
									  ?FALSE -> find_state_level(NewSkill, State)
								  end,
					 WithFunc = fun() ->
						 skill_player:send_skill_msg(),
						 player:send(#pk_GS2U_SkillStateUpRet{role_id = RoleId, index = Index, state = State, level = NewStateLv})
								end,
					 skill_player:on_skill_change(WithFunc),
					 case State of
						 %% 1 突破
						 1 ->
							 activity_new_player:on_active_condition_change(?SalesActivity_SkillBreakLvTotal_188, get_all_skill_state_lv(State));
						 %% 2 觉醒
						 2 ->
							 activity_new_player:on_active_condition_change(?SalesActivity_SkillAwakenLvTotal_189, get_all_skill_state_lv(State));
						 _ ->
							 skip
					 end,
					 check_broadcast(RoleId, Index, State),
					 attainment:check_attainment([?Attainments_Type_SkillBreachLv,?Attainments_Type_SkillawakenLvCount]),
					 log_skill_up_op(2, Index, State, NewStateLv, "")
				 catch
					 ErrCode ->
						 player:send(#pk_GS2U_SkillStateUpRet{err_code = ErrCode, role_id = RoleId, index = Index, state = State})
				 end end).

on_get_all_skill_lv_without_attack() ->
	get_all_skill_lv_without_attack().

on_get_all_skill_state_lv(State) ->
	get_all_skill_state_lv(State).

%% 转换
list_to_skill(List) ->
	Record = list_to_tuple([skill_up | List]),
	Record#skill_up{
		states = gamedbProc:dbstring_to_term(Record#skill_up.states)
	}.
skill_to_list(Record) ->
	tl(tuple_to_list(Record#skill_up{
		states = gamedbProc:term_to_dbstring(Record#skill_up.states)
	})).

is_active_skill(RoleID, Index) ->
	table_player:member(db_skill_up, player:getPlayerID(), {RoleID, Index}).

%% 获取该技能可以升到的等级,所需道具
get_item_list(Career, Index) ->
	case role_data:get_career_role_id(Career) of
		0 -> [];
		RoleID ->
			CareerLv = change_role:get_career_lv(RoleID),
			get_item_list_1(#skill_up{index = Index, level = 0}, Career, CareerLv, player:getLevel(), [])
	end.

get_item_list_1(Skill, Career, CareerLv, PlayerLv, Ret) ->
	case check_add_lv_shop(Skill, Career, CareerLv, PlayerLv) of
		{?ERROR_OK, NewSkill, UseItem} -> get_item_list_1(NewSkill, Career, CareerLv, PlayerLv, UseItem ++ Ret);
		{_, _, _} -> Ret
	end.
check_add_lv_shop(#skill_up{index = Index, level = Lv} = Skill, Career, CareerLv, PlayerLv) ->
	case cfg_skillUpgNew:getRow(Index, Lv) of
		#skillUpgNewCfg{preposition = {NeedCareerLv, _, NeedPlayerLv}, useItem = UseItem} when CareerLv >= NeedCareerLv, PlayerLv >= NeedPlayerLv ->
			CostItem = [{I, N} || {C, 1, I, N} <- UseItem, C == 0 orelse C == Career],
			{?ERROR_OK, Skill#skill_up{level = Lv + 1}, CostItem};
		_ ->
			{?ERROR_Cfg, Skill, []}
	end.

exist_skill_book(Career, Index) ->
	lists:any(fun(#item{cfg_id = CfgID}) ->
		case cfg_item:getRow(CfgID) of
			#itemCfg{detailedType3 = Career, useParam3 = Index} -> ?TRUE;
			_ -> ?FALSE
		end
			  end, bag_player:get_bag_item_list(?BAG_PLAYER)).

check_skill_auto_study(ItemList) ->
	try
		case get_auto_study_skill_list() of
			[] -> ok;
			List ->
				RoleId = role_data:get_nth_role_id(1),
				lists:foreach(fun({ItemID, Num, Index}) ->
					case lists:keyfind(ItemID, #item.cfg_id, ItemList) of
						#item{amount = N} when N >= Num ->
							on_skill_level_up(RoleId, Index);
						_ -> ok
					end
							  end, List)
		end
	catch
		Class:ExcReason:Stacktrace ->
			?LOG_ERROR(?LOG_STACKTRACE(Class, ExcReason, Stacktrace))
	end.

get_skill_up(PlayerId, RoleId, Index) ->
	case table_player:lookup(db_skill_up, PlayerId, [{RoleId, Index}]) of
		[Skill | _] -> Skill;
		_ -> #skill_up{player_id = PlayerId, role_id = RoleId, index = Index}
	end.
%%成就系统-激活奥义*XXX技能-309
get_active_skill(Param1) ->
	RoleId = role_data:get_leader_id(),
	case get_skill_level(RoleId, Param1) of
		0 -> 0;
		_ -> Param1
	end.
%%成就系统-奥义XXX技能升级到XX级 310
get_skill_level2(RoleId, Index) ->
	Skill = get_skill_up(RoleId, Index),
	case cfg_skillUpgNew:getRow(Index, 1) of
		#skillUpgNewCfg{} -> Skill#skill_up.level;
		{} -> ((Skill#skill_up.level - 1) div 10) + 1
	end.
%% -------------------------------- Internal Function --------------------------------
%% 数据操作
get_skill_up() ->
	PlayerId = player:getPlayerID(),
	table_player:lookup(db_skill_up, PlayerId).
get_skill_up(RoleId, Index) ->
	PlayerId = player:getPlayerID(),
	case table_player:lookup(db_skill_up, PlayerId, [{RoleId, Index}]) of
		[Skill | _] -> Skill;
		_ -> #skill_up{player_id = PlayerId, role_id = RoleId, index = Index}
	end.
update_skill_up(SkillOrList) ->
	table_player:insert(db_skill_up, SkillOrList).

find_state_level(#skill_up{states = States}, State) ->
	case lists:keyfind(State, 1, States) of
		{_, Lv} -> Lv;
		_ -> 0
	end.
store_state_level(#skill_up{states = States} = Skill, State, Level) ->
	NewStates = lists:keystore(State, 1, States, {State, Level}),
	Skill#skill_up{states = NewStates}.

%% 功能是否开启
is_func_open(1) ->
	variable_world:get_value(?WorldVariant_Switch_Skill2) == 1 andalso guide:is_open_action(?OpenAction_Skill2);
is_func_open(2) ->
	variable_world:get_value(?WorldVariant_Switch_Skill3) == 1 andalso guide:is_open_action(?OpenAction_Skill3);
is_func_open(3) ->
	?TRUE;
is_func_open(_) ->
	?FALSE.

%% 技能升级检查
check_level_up(RoleId, Index, Career, CareerLv, PlayerLv) ->
	Skill = get_skill_up(RoleId, Index),
	check_level_up_1(Skill, Career, CareerLv, PlayerLv).
check_level_up_1(#skill_up{index = Index, level = Level} = Skill, Career, CareerLv, PlayerLv) ->
	case cfg_skillUpgNew:getRow(Index, Level) of
		#skillUpgNewCfg{preposition = {NeedCareerLv, _, NeedPlayerLv}} when CareerLv < NeedCareerLv; PlayerLv < NeedPlayerLv ->
			{?ErrorCode_Skill_Pre, Skill, {[], []}};
		#skillUpgNewCfg{lvMax = MaxLv} when Level >= MaxLv ->
			{?ErrorCode_Skill_MaxLv, Skill, {[], []}};
		#skillUpgNewCfg{geniusBaseID = {0, 0, 0}, useItem = UseItem} ->
			CostItem = [{I, N} || {C, 1, I, N} <- UseItem, C =:= 0 orelse C =:= Career],
			CostCoin = [{I, N} || {C, 2, I, N} <- UseItem, C =:= 0 orelse C =:= Career],
			{?ERROR_OK, Skill#skill_up{level = Level + 1}, {CostItem, CostCoin}};
		#skillUpgNewCfg{} ->
			{?ErrorCode_Skill_Pre, Skill, {[], []}};
		_ ->
			case cfg_skillUpgSpecial:getRow(Index, Level) of
				#skillUpgSpecialCfg{lv = Lv, eXP = Exp, breakItem = UseItem} when Lv =:= 0 orelse Exp =:= 0 ->
					CostItem = [{I, N} || {C, I, N} <- UseItem, C =:= 0 orelse C == Career],
					{?ERROR_OK, Skill#skill_up{level = Level + 1}, {CostItem, []}};
				_ ->
					{?ERROR_Cfg, Skill, {[], []}}
			end
	end.

%% 技能升级检查
check_state_up(RoleId, Index, State, Career) when is_integer(Index) ->
	Skill = get_skill_up(RoleId, Index),
	check_state_up(RoleId, Skill, State, Career);
check_state_up(RoleId, #skill_up{index = Index, level = Level} = Skill, State, Career) ->
	CareerLv = change_role:get_career_lv(RoleId),
	StateLv = find_state_level(Skill, State),
	case cfg_skillUp:getRow(Index, State, StateLv) of
		#skillUpCfg{skillMax = MaxLv} when StateLv >= MaxLv ->
			{?ErrorCode_Skill_MaxLv, Skill, []};
		#skillUpCfg{preposition2 = NeedCareerLv} when CareerLv < NeedCareerLv ->
			{?ErrorCode_Skill_Pre, Skill, []};
		#skillUpCfg{useItem = UseItem} ->
			CostItem = [{I, N} || {C, I, N} <- UseItem, C == 0 orelse C == Career],
			NewSkill = store_state_level(Skill, State, StateLv + 1),
			{?ERROR_OK, NewSkill, CostItem};
		_ ->
			case cfg_skillUpgSpecial:getRow(Index, Level) of
				#skillUpgSpecialCfg{itemEXP = {ItemID, PerExp}, eXP = Exp, maxLv = MaxLv} when Level > 0 andalso Exp > 0 andalso MaxLv > Level ->
					OldExp = find_state_level(Skill, 3),
					NextLvNeed = ceil((Exp - OldExp) / PerExp),
					UseNum = min(bag_player:get_item_amount(?BAG_PLAYER, ItemID), NextLvNeed),
					GetExp = PerExp * UseNum,
					{NewLv, NewExp} = case (OldExp + GetExp) >= Exp of
										  ?TRUE -> {Level + 1, OldExp + GetExp - Exp};
										  ?FALSE -> {Level, OldExp + GetExp}
									  end,
					NewSkill = store_state_level(Skill, 3, NewExp),
					{?ERROR_OK, NewSkill#skill_up{level = NewLv}, [{ItemID, UseNum}]};
				_ ->
					{?ERROR_Cfg, Skill, []}
			end
	end.

%% 自动装配
check_auto_bind(#skill_up{role_id = RoleId, index = Index, level = 1}) ->
	skill_player:auto_bind_skill(RoleId, Index),
	skill_player:auto_bind_skill_by_hand(RoleId, Index);
check_auto_bind(_) -> ok.

%% 检查公告
check_broadcast(RoleId, Index, State) ->
	PlayerText = player:getPlayerText(),
	Career = player:getCareer(RoleId),
	CareerLV = get_skill_need_career_lv(Index),
	Skill = get_skill_up(RoleId, Index),
	case is_broadcast(Skill, State) of
		?TRUE when State =:= 0 ->
			case cfg_skillUpgSpecial:getRow(Skill#skill_up.index, Skill#skill_up.level) of
				#skillUpgSpecialCfg{showLv = ShowLv} ->
					case Skill#skill_up.level =:= 1 of
						?TRUE ->
							marquee:sendChannelNotice(0, 0, realSkills_01,
								fun(Language) ->
									language:format(language:get_server_string("RealSkills_01", Language),
										[PlayerText, get_skill_name(Skill, Career, Language)])
								end);
						_ ->
							marquee:sendChannelNotice(0, 0, realSkills_02,
								fun(Language) ->
									language:format(language:get_server_string("RealSkills_02", Language),
										[PlayerText, get_skill_name(Skill, Career, Language), ShowLv])
								end)
					end;
				_ ->
					case Skill#skill_up.level =:= 1 of
						?TRUE ->
							%% 指定技能解锁公告
							marquee:sendChannelNotice(0, 0, skill_gonggao0,
								fun(Language) ->
									language:format(language:get_server_string("skill_gonggao0", Language),
										[PlayerText, richText:get_career_name(Career, CareerLV, Language), get_skill_name(Skill, Career, Language)])
								end);
						_ ->
							marquee:sendChannelNotice(0, 0, skill_gonggao1,
								fun(Language) ->
									language:format(language:get_server_string("skill_gonggao1", Language),
										[PlayerText, richText:get_career_name(Career, CareerLV, Language), get_skill_name(Skill, Career, Language), Skill#skill_up.level])
								end)
					end
			end;
		?TRUE when State =:= 1 ->
			marquee:sendChannelNotice(0, 0, skill_gonggao2,
				fun(Language) ->
					language:format(language:get_server_string("skill_gonggao2", Language),
						[PlayerText, richText:get_career_name(Career, CareerLV, Language), get_skill_name(Skill, Career, Language), find_state_level(Skill, State)])
				end);
		?TRUE when State =:= 2 ->
			marquee:sendChannelNotice(0, 0, skill_gonggao3,
				fun(Language) ->
					language:format(language:get_server_string("skill_gonggao3", Language),
						[PlayerText, richText:get_career_name(Career, CareerLV, Language), get_skill_name(Skill, Career, Language)])
				end);
		_ -> ok
	end.

%% 是否公告
is_broadcast(#skill_up{index = Index, level = SkillLv}, 0) ->
	case cfg_skillUpgNew:getRow(Index, SkillLv) of
		#skillUpgNewCfg{ifCall = 1} -> ?TRUE;
		_ ->
			case cfg_skillUpgSpecial:getRow(Index, SkillLv) of
				#skillUpgSpecialCfg{ifCall = 1} -> ?TRUE;
				_ -> ?FALSE
			end
	end;
is_broadcast(#skill_up{index = Index} = Skill, 1) ->
	StateLv = find_state_level(Skill, 1),
	case cfg_skillUp:getRow(Index, 1, StateLv) of
		#skillUpCfg{ifCall = 1} -> ?TRUE;
		_ -> ?FALSE
	end;
is_broadcast(#skill_up{index = Index} = Skill, 2) ->
	StateLv = find_state_level(Skill, 2),
	case cfg_skillUp:getRow(Index, 2, StateLv) of
		#skillUpCfg{ifCall = 1} -> ?TRUE;
		_ -> ?FALSE
	end;
is_broadcast(#skill_up{index = Index, level = Level}, 3) ->
	case cfg_skillUpgSpecial:getRow(Index, Level) of
		#skillUpgSpecialCfg{ifCall = 1} -> ?TRUE;
		_ -> ?FALSE
	end.

%% 拼装技能名
get_skill_name(#skill_up{index = Index, level = SkillLv} = Skill, Career, Language) ->
	SkillId = case cfg_skillUpgNew:getRow(Index, SkillLv) of
				  #skillUpgNewCfg{skill1004 = [{_, SkillId4, _} | _]} when Career =:= 1004 -> SkillId4;
				  #skillUpgNewCfg{skill1005 = [{_, SkillId5, _} | _]} when Career =:= 1005 -> SkillId5;
				  #skillUpgNewCfg{skill1006 = [{_, SkillId6, _} | _]} when Career =:= 1006 -> SkillId6;
				  #skillUpgNewCfg{skill1007 = [{_, SkillId7, _} | _]} when Career =:= 1007 -> SkillId7;
				  _ ->
					  case cfg_skillUpgSpecial:getRow(Index, SkillLv) of
						  #skillUpgSpecialCfg{skill1004 = [{_, SkillId4, _} | _]} when Career =:= 1004 -> SkillId4;
						  #skillUpgSpecialCfg{skill1005 = [{_, SkillId5, _} | _]} when Career =:= 1005 -> SkillId5;
						  #skillUpgSpecialCfg{skill1006 = [{_, SkillId6, _} | _]} when Career =:= 1006 -> SkillId6;
						  #skillUpgSpecialCfg{skill1007 = [{_, SkillId7, _} | _]} when Career =:= 1007 -> SkillId7;
						  _ -> 0
					  end
			  end,
	State1Lv = find_state_level(Skill, 1),
	State2Lv = find_state_level(Skill, 2),
	Stem = language:get_skill_name(SkillId, Language),
	Prefix1 = case State1Lv > 0 of
				  ?TRUE -> language:get_tongyong_string("ExSkillName1", Language);
				  ?FALSE -> ""
			  end,
	Prefix2 = case State2Lv > 0 of
				  ?TRUE -> language:get_tongyong_string("ExSkillName2", Language);
				  ?FALSE -> ""
			  end,
	Point = if
				Prefix1 =/= "" -> "·";
				Prefix2 =/= "" -> "·";
				?TRUE -> ""
			end,
	Prefix1 ++ Prefix2 ++ Point ++ Stem.

%% 日志 Op:1-升级 2-突破觉醒
%% state:1-突破 2-觉醒
log_skill_up_op(Op, Index, State, Level, Params) ->
	table_log:insert_row(log_skill_up_op, [player:getPlayerID(), Op, Index, State, Level, Params, time:time()]).

get_skill_need_career_lv(Index) ->
	case cfg_skillUpgNew:getRow(Index, 0) of
		#skillUpgNewCfg{preposition = {NeedCareerLv, _, _}} -> NeedCareerLv;
		_ -> 0
	end.

get_all_skill_lv() ->
	lists:foldl(fun(#skill_up{index = Index, level = Level}, Ret) ->
		case cfg_skillUpgSpecial:getRow(Index, Level) of
			#skillUpgSpecialCfg{showLv = Slv} -> Ret + Slv;
			_ -> Ret + Level
		end
				end, 0, get_skill_up()).

%% 排除普攻的技能总等级
get_all_skill_lv_without_attack() ->
	lists:foldl(fun(#skill_up{index = Index, level = Level}, Ret) ->
		case Index of
			1 ->
				Ret;
			_ ->
				case cfg_skillUpgSpecial:getRow(Index, Level) of
					#skillUpgSpecialCfg{showLv = Slv} ->
						Ret + Slv;
					_ -> Ret + Level
				end
		end
				end, 0, get_skill_up()).

%% 技能总 突破/觉醒 等级
%% 1 突破 2 觉醒
get_all_skill_state_lv(State) ->
	lists:foldl(fun(#skill_up{states = StateList}, Ret) ->
		case lists:keyfind(State, 1, StateList) of
			?FALSE ->
				Ret;
			{_, Lv} ->
				Lv + Ret
		end
				end, 0, get_skill_up()).

get_auto_study_skill_list() ->
	case get({?MODULE, auto_study_skill_list}) of
		?UNDEFINED -> [];
		L -> L
	end.
calc_auto_study_skill_list() ->
	RoleID = role_data:get_nth_role_id(1),
	Career = role_data:get_nth_career(1),
	List = common:listsFiterMap(fun(Index) ->
		case is_active_skill(RoleID, Index) of
			?TRUE -> ok;
			?FALSE ->
				#skillUpgNewCfg{useItem = UseItemList} = cfg_skillUpgNew:getRow(Index, 0),
				case lists:keyfind(Career, 1, UseItemList) of
					?FALSE -> ok;
					{_, _, ItemID, Num} -> {ItemID, Num, Index}
				end
		end
								end, ?AutoStudyIndexList),
	put({?MODULE, auto_study_skill_list}, List).

reset_skill_back() ->
	try
		ConsumeList = lists:keysort(1, common:listValueTupleMerge([{N, {Type, ID, Num}} || {N, Type, ID, Num} <- df:getGlobalSetupValueList(resetSkillPay, [])])),
		{RetItemList, RetCoinList, RetUpdateSkillList} = lists:foldl(fun(#skill_up{role_id = RoleID, index = Index, level = Lv} = Info, {Ret1, Ret2, Ret3}) ->
			case cfg_skillEquip:getRow(Index) of
				#skillEquipCfg{type = 1} when Lv > 1 ->
					Career = role_data:get_role_element(RoleID, #role.career),
					{ItemList, CoinList} = get_skill_up_total_cost(Index, Career, 1, Lv, {[], []}),
					{ItemList ++ Ret1, CoinList ++ Ret2, [Info#skill_up{level = 1} | Ret3]};
				_ -> {Ret1, Ret2, Ret3}
			end
																	 end, {[], [], []}, get_skill_up()),
		ItemList = common:listValueMerge(RetItemList),
		CurrList = common:listValueMerge(RetCoinList),
		TotalNum = lists:sum([N || {_, N} <- ItemList]),
		{_, FindConsumeList} = common:getValueByInterval4(TotalNum, ConsumeList, {0, []}),
		DecErr = player:delete_cost(FindConsumeList, ?Reason_Skill_Reset),
		?ERROR_CHECK_THROW(DecErr),
		update_skill_up(RetUpdateSkillList),
		player:add_rewards(ItemList, CurrList, ?Reason_Skill_Reset),
		player_item:show_get_item_dialog(ItemList, CurrList, [], 0, 0),
		WithFunc = fun() ->
			skill_player:send_skill_msg(),
			player:send(#pk_GS2U_SkillResetRet{err_code = ?ERROR_OK})
				   end,
		attainment:add_attain_progress(?Attainments_Type_SkillReset,{1,0,0,0,0}),%%成就系统-重置技能X次 311
		skill_player:on_skill_change(WithFunc)
	catch
		Err -> player:send(#pk_GS2U_SkillResetRet{err_code = Err})
	end.

get_skill_up_total_cost(_Index, _Career, Lv, ToLv, Ret) when Lv >= ToLv -> Ret;
get_skill_up_total_cost(Index, Career, Lv, ToLv, {R1, R2}) ->
	case cfg_skillUpgNew:getRow(Index, Lv) of
		#skillUpgNewCfg{useItem = UseItem} ->
			CostItem = [{I, N} || {C, 1, I, N} <- UseItem, C =:= 0 orelse C =:= Career],
			CostCoin = [{I, N} || {C, 2, I, N} <- UseItem, C =:= 0 orelse C =:= Career],
			get_skill_up_total_cost(Index, Career, Lv + 1, ToLv, {CostItem ++ R1, CostCoin ++ R2});
		{} -> get_skill_up_total_cost(Index, Career, Lv + 1, ToLv, {R1, R2})
	end.

get_careerlv_skill_up_times(CareerLv) ->
	IndexList = [Index || #skillEquipCfg{iD = Index, changeRole = Lv} <- cfg_skillEquip:rows(), Lv =:= CareerLv],
	lists:sum([Level - 1 || #skill_up{index = Index, level = Level} <- get_skill_up(), lists:member(Index, IndexList)]).