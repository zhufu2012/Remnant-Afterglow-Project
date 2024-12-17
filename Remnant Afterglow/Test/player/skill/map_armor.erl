%%%-------------------------------------------------------------------
%%% @author tang
%%% @copyright (C) 2020, double game
%%% @doc
%%%
%%% @end
%%% Created : 04. 9月 2020 13:51
%%%-------------------------------------------------------------------
-module(map_armor).
-author("tang").

-include("global.hrl").
-include("logger.hrl").
-include("attribute.hrl").
-include("record.hrl").
-include("netmsgRecords.hrl").
-include("cfg_buffBase.hrl").
-include("gameMap.hrl").
-include("cfg_shengjiaactivate.hrl").


%% API
-export([on_tick/1, on_enter_map/2, delete_object/1]).
-export([on_sync_view/2, check_armor_effect/3, on_sj_buff_change/2, send_player_armor/2]).
-export([get_obj_armor_max/1, get_obj_armor_value/1]).

%% 每秒触发
on_tick(TimeStamp) ->
	MapPlayerList = mapdb:getMapPlayerList(),
	on_tick_1(MapPlayerList, TimeStamp),
	MirrorPlayerList = mapdb:getMapMirrorPlayerList(),
	on_tick_1(MirrorPlayerList, TimeStamp),
	ok.

%% 玩家进图
on_enter_map(PlayerId, BuffList) ->
	set_object_armor(PlayerId, 0, 0, 0),
	set_object_view(PlayerId, 0, 0),
	sj_buff_list(PlayerId, {BuffList, []}),
	send_player_armor(PlayerId, map_role:get_leader_id(PlayerId)),
	ok.

%% 销毁对象
delete_object(PlayerId) ->
	erase_object_armor(PlayerId),
	erase_object_view(PlayerId),
	erase_sj_buff_list(PlayerId),
	ok.

on_sj_buff_change(PlayerId, NewBuffList) ->
	{WaitList, EffectList} = sj_buff_list(PlayerId),
	NewWaitList = [E || E <- WaitList, lists:member(E, NewBuffList)],
	RemoveList = EffectList--NewBuffList,
	NewEffectList = EffectList--RemoveList,
	AddList = (NewBuffList--WaitList)--EffectList,
	RoleID = map_role:get_leader_id(PlayerId),
	[buff_map:remove_buff(PlayerId, RoleID, BuffDataID) || {_, _, BuffDataID} <- RemoveList],
	sj_buff_list(PlayerId, {AddList ++ NewWaitList, NewEffectList}),
	{Armor, Percent, _} = get_object_armor(PlayerId),
	check_buff_effect(PlayerId, RoleID, Armor, Percent).

%% 客户端同步周围人数
on_sync_view(PlayerId, ViewNum) ->
	case mapdb:getMapPlayer(PlayerId) of
		#mapPlayer{} ->
			{_OldNum, CheckTime} = get_object_view(PlayerId),
			set_object_view(PlayerId, ViewNum, CheckTime);
		_ ->
			ok
	end,
	ok.

%% 检查圣甲效果
check_armor_effect(PlayerId, ActiveEffect, Type) ->
	case lists:keyfind(Type, 1, ActiveEffect) of
		{6, NeedPercent, _, _, _} ->
			{_Armor, Percent, _} = get_object_armor(PlayerId),
			Percent >= NeedPercent;
		_ -> ?FALSE
	end.

%% 同步圣甲值
send_player_armor(PlayerId, RoleID) ->
	case map:getMapAI() of
		?MapAI_ClientDungeons -> ok;
		?MapAI_MainlineGuide -> ok;
		?MapAI_51 -> ok;
		?MapAI_52 -> ok;
		?MapAI_Main -> ok;
		_ ->
			{Armor, _, _} = get_object_armor(PlayerId),
			Msg = #pk_GS2U_ObjectArmor{code = RoleID, value = Armor},
			mapView:broadcastByView_client(Msg, PlayerId, 0)
	end.

%% 周围人数check
on_tick_1([], _TimeStamp) -> ok;
on_tick_1([#mapPlayer{id = PlayerId, sj_level = Level, leader_role_id = LeaderRoleID} | T], TimeStamp) ->
	case cfg_shengjiaactivate:getRow(Level) of
		#shengjiaactivateCfg{shengjiaPar = {_, Num, _}} ->
			case get_object_view(PlayerId) of
				{ViewNum, _CheckTime} when ViewNum >= Num ->
					set_object_view(PlayerId, ViewNum, TimeStamp);
				_ ->
					ok
			end;
		_ ->
			ok
	end,
	armor_change_tick(PlayerId, Level, LeaderRoleID, TimeStamp),
	on_tick_1(T, TimeStamp);
on_tick_1([#mapMirrorPlayer{id = PlayerId, sj_level = Level, leader_role_id = LeaderRoleID} | T], TimeStamp) ->
	case cfg_shengjiaactivate:getRow(Level) of
		#shengjiaactivateCfg{shengjiaPar = {_, Num, _}} ->
			case get_object_view(PlayerId) of
				{ViewNum, _CheckTime} when 1 >= Num -> %% TODO 镜像默认1人 ,后面有需要再改
					set_object_view(PlayerId, ViewNum, TimeStamp);
				_ ->
					ok
			end;
		_ ->
			ok
	end,
	armor_change_tick(PlayerId, Level, LeaderRoleID, TimeStamp),
	on_tick_1(T, TimeStamp);
on_tick_1([_ | T], TimeStamp) ->
	on_tick_1(T, TimeStamp).


%% 圣甲值增加/衰减
armor_change_tick(PlayerId, Level, LeaderRoleID, TimeStamp) ->
	%% 1、圣甲值增长：在pvp中，玩家附近-【触发范围】内的敌方玩家数达到【触发敌人数】，增加一次圣甲值
	%%   增加值=最大【圣甲值】*【圣甲增长率】/ 10000，四舍五入，增加不超过最大值
	%% 2、圣甲值衰减：圣甲值大于0时，以下（abc）任一状态持续时间达到【衰减延时】，则减少一次圣甲值
	%%   a、玩家附近-【触发范围】内的敌方玩家数不足【触发敌人数】
	%%   b、不攻击
	%%   c、未受伤
	%%   减少值=max(最大【圣甲值】/【圣甲韧性】,1)，四舍五入，减少不能小于0
	%% 3、圣甲天赋技能[触发属性技]：圣甲达到指定数值或百分比时激活天赋，降低到该数值/百分比之下时关闭
	%% 注：圣甲变化每秒判断一次
	%% 优先级减少>增加
	case cfg_shengjiaactivate:getRow(Level) of
		#shengjiaactivateCfg{shengjiaPar = {_, _, Time}} ->
			{_, ViewCheckTime} = get_object_view(PlayerId),
			AttackCheckTime = skill_map:get_object_attack_time(PlayerId),
			{OldArmor, _, ArmorTime} = get_object_armor(PlayerId),
			if
				(TimeStamp >= ViewCheckTime + Time orelse TimeStamp >= AttackCheckTime + Time) ->
					case OldArmor > 0 of
						?TRUE ->
							%% 衰减
							Prop = attribute_map:get_attribute(PlayerId, LeaderRoleID),
							PShengJiaBase = ?MAP(Prop, ?P_ShengJiaBase),
							MinusVal = max(round(PShengJiaBase / max(?MAP(Prop, ?P_ShengJiaRX), 1)), 1),
							NewArmor = max(OldArmor - MinusVal, 0),
							NewPercent = trunc(NewArmor / max(PShengJiaBase, 1) * 10000),
							set_object_armor(PlayerId, NewArmor, NewPercent, TimeStamp),
							check_buff_un_effect(PlayerId, LeaderRoleID, NewArmor, NewPercent),
							[send_player_armor(PlayerId, LeaderRoleID) || NewArmor =/= OldArmor];
						?FALSE -> ok
					end,
					ok;
				TimeStamp > ArmorTime ->
					%% 增加
					Prop = attribute_map:get_attribute(PlayerId, LeaderRoleID),
					PShengJiaBase = ?MAP(Prop, ?P_ShengJiaBase),
					case OldArmor < PShengJiaBase of
						?TRUE ->
							AddVal = max(round(PShengJiaBase * max(1, ?MAP(Prop, ?P_ShengJiaZZ)) / 10000), 1),
							NewArmor = min(OldArmor + AddVal, PShengJiaBase),
							NewPercent = trunc(NewArmor / max(PShengJiaBase, 1) * 10000),
							set_object_armor(PlayerId, NewArmor, NewPercent, TimeStamp),
							check_buff_effect(PlayerId, LeaderRoleID, NewArmor, NewPercent),
							[send_player_armor(PlayerId, LeaderRoleID) || NewArmor =/= OldArmor];
						?FALSE ->
							ok
					end,
					ok;
				true ->
					ok
			end;
		_ ->
			ok
	end.

%% 进程字典
set_object_armor(PlayerId, Armor, Percent, Time) ->
	put({map_obj_armor, PlayerId}, {max(Armor, 0), Percent, Time}).
get_object_armor(PlayerId) ->
	case get({map_obj_armor, PlayerId}) of ?UNDEFINED -> {0, 0, 0}; V -> V end.
erase_object_armor(PlayerId) ->
	erase({map_obj_armor, PlayerId}).

set_object_view(PlayerId, ViewNum, CheckTime) ->
	put({map_obj_armor_view, PlayerId}, {ViewNum, CheckTime}).
get_object_view(PlayerId) ->
	case get({map_obj_armor_view, PlayerId}) of ?UNDEFINED -> {0, 0}; V -> V end.
erase_object_view(PlayerId) ->
	erase({map_obj_armor_view, PlayerId}).

%% {待触发,已触发}
sj_buff_list(PlayerId, BuffTuple) ->
	?P_DIC_PUT(PlayerId, BuffTuple).
sj_buff_list(PlayerId) ->
	?P_DIC_GET(PlayerId, {[], []}).
erase_sj_buff_list(PlayerId) ->
	?P_DIC_ERASE(sj_buff_list, PlayerId).

get_obj_armor_max(PlayerId) ->
	RoleId = map_role:get_leader_id(PlayerId),
	attribute_map:get_object_property_value(PlayerId, RoleId, ?P_ShengJiaBase).

get_obj_armor_value(PlayerId) ->
	{Armor, _, _} = get_object_armor(PlayerId),
	Armor.

check_buff_effect(PlayerId, RoleID, NewArmor, NewPercent) ->
	{WaitList, EffectList} = sj_buff_list(PlayerId),
	{AddEffectList, NewWaitList} = lists:partition(fun
													   ({1, Value, _BuffID}) when NewArmor >= Value -> ?TRUE;
													   ({2, Value, _BuffID}) when NewPercent >= Value -> ?TRUE;
													   (_) -> ?FALSE
												   end, WaitList),
	[buff_map:add_buffer2(PlayerId, RoleID, PlayerId, RoleID, BuffDataID, 0) || {_, _, BuffDataID} <- AddEffectList],
	sj_buff_list(PlayerId, {NewWaitList, AddEffectList ++ EffectList}).
check_buff_un_effect(PlayerId, RoleID, NewArmor, NewPercent) ->
	{WaitList, EffectList} = sj_buff_list(PlayerId),
	{NewEffectList, NewWaitList} = lists:partition(fun
													   ({1, Value, _BuffID}) when NewArmor >= Value -> ?TRUE;
													   ({2, Value, _BuffID}) when NewPercent >= Value -> ?TRUE;
													   (_) -> ?FALSE
												   end, EffectList),
	[buff_map:remove_buff(PlayerId, RoleID, BuffDataID) || {_, _, BuffDataID} <- NewWaitList],
	sj_buff_list(PlayerId, {NewWaitList ++ WaitList, NewEffectList}).