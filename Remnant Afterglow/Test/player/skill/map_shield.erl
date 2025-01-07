%%%-------------------------------------------------------------------
%%% @author cbfan
%%% @copyright (C) 2019, <COMPANY>
%%% @doc
%%%				地图内圣盾相关逻辑处理
%%% @end
%%% Created : 29. 九月 2019 10:58
%%%-------------------------------------------------------------------
-module(map_shield).
-author("cbfan").
-include("global.hrl").
-include("attribute.hrl").
-include("logger.hrl").
-include("cfg_buffBase.hrl").
-include("buff.hrl").
-include("record.hrl").
-include("netmsgRecords.hrl").
-include("id_generator.hrl").
-include("gameMap.hrl").

%% API
-export([on_damage_shield/5, on_enter_map/1, add_max_sd/1, add_max_sd/2, fix_obj_sd/4, on_tick/1, check_buff_enable/3,
	delete_obj_sd/2, change_player_sd/3, send_player_sd/1, send_player_sd/2, on_enter_map/2,
	get_obj_sd/1, get_obj_sd/2, set_obj_sd/3, set_obj_sd_max/1, set_obj_sd_max/2, get_obj_sd_max/1, get_obj_sd_max/2, get_obj_sd_i/2]).

%% TODO
%% 每5秒  每个玩家恢复一些圣盾值, 服务器根据当前玩家是否处于状态
%% 每次属性改变的时候刷新一次圣盾值上限属性  155号属性  在面板上显示的是圣盾系统带来的基础属性  在战斗中为最大上限  原理和生命值一样
%% 切换地图圣盾值是否继承
%% 伤害结算的最后一步插入圣盾值的计算
%% 当前圣盾值的改变广播
%% 当前圣盾值的进程字段存储
%% buff效果直接添加圣盾值
%% 某类(添加属性)buff在玩家圣盾值大于0的时候生效


%% 【原始伤害】：原公式扣除生命前所计算的伤害(护盾吸收伤害之后)
%% 【生命伤害】：【原始伤害】受到圣盾吸收后所需扣除生命的伤害
%% 【圣盾伤害】：【原始伤害】被圣盾吸收后对圣盾值造成的伤害
on_damage_shield(_P1, _RoleId1, _P2, _RoleId2, DecHP) when DecHP =< 0 -> DecHP;  %% 治疗直接返回
on_damage_shield(AtkId, AtkRoleId, TargetId, TargetRoleId, OldDamage) ->
%%	OldDamage = -DecHP,
	NowShield = get_obj_sd(TargetId, TargetRoleId),
	case NowShield of
		0 -> OldDamage;
		_ ->
			P1 = attribute_map:get_attribute(AtkId, AtkRoleId),
			P2 = attribute_map:get_attribute(TargetId, TargetRoleId),

			%% 【圣盾吸收比】=max(min((P2.圣盾吸伤比-P1.圣盾穿伤比)/10^4,1),0)
			ShengDunXiShouBi = max(min((?MAP(P2, ?P_ShengDunXSB) - ?MAP(P1, ?P_ShengDunCSB)) / 10000, 1), 0),

			%% 【圣盾伤害修正】=max(min((10000-P2.圣盾伤害减免+P1.圣盾伤害加成)/10^4,1),0)
			ShengDunShangHaiXiuZhen = max(min((10000 - ?MAP(P2, ?P_ShengDunSHJM) + ?MAP(P1, ?P_ShengDunSHJC)) / 10000, 1), 0),

			%% 【圣盾伤害】=min(【原始伤害】*【圣盾吸收比】*【圣盾伤害修正】，当前圣盾值)
			ShieldDamage = trunc(min(OldDamage * ShengDunXiShouBi * ShengDunShangHaiXiuZhen, NowShield)),

			%% 【圣盾抵御伤害】：如果【圣盾伤害修正】=0时，则【圣盾抵御伤害】为0，否则【圣盾抵御伤害】=【圣盾伤害】/【圣盾伤害修正】
			ShengDunDiYuShangHai = case ShengDunShangHaiXiuZhen of
									   0 -> 0;
									   _ -> ShieldDamage / ShengDunShangHaiXiuZhen
								   end,
			%% 【生命伤害】=max(【原始伤害】-【圣盾抵御伤害】,0)
			Damage = trunc(max(OldDamage - ShengDunDiYuShangHai, 0)),
			change_player_sd(TargetId, TargetRoleId, -ShieldDamage),
			Damage
	end.

on_enter_map(PlayerId) ->
	%% TODO RoleId
	RoleIdList = map_role:get_role_id_list(PlayerId),
	Time = time:time(),
	lists:foreach(
		fun(RoleId) ->
			set_obj_sd_max(PlayerId, RoleId),
			set_obj_sd_time(PlayerId, Time)
		end, RoleIdList).
on_enter_map(PlayerId, RoleId) ->
	set_obj_sd_max(PlayerId, RoleId),
	set_obj_sd_time(PlayerId, time:time()).

add_max_sd(PlayerId) ->
	%% TODO RoleId
	RoleIdList = map_role:get_role_id_list(?ID_TYPE_Player, PlayerId),
	lists:foreach(
		fun(RoleId) ->
			MaxValue = get_obj_sd_max(PlayerId, RoleId),
			change_player_sd(PlayerId, RoleId, MaxValue)
		end, RoleIdList).
add_max_sd(PlayerId, RoleId) ->
	MaxValue = get_obj_sd_max(PlayerId, RoleId),
	change_player_sd(PlayerId, RoleId, MaxValue).

fix_obj_sd(PlayerId, RoleId, Shield, ShieldMax) ->
	MaxSD = get_obj_sd_max(PlayerId, RoleId),
	FixSD = if
				ShieldMax == 0 -> 0;
				MaxSD == 0 -> 0;
				MaxSD =< Shield -> MaxSD;
				?TRUE -> trunc(Shield / ShieldMax * MaxSD)
			end,
	set_obj_sd(PlayerId, RoleId, FixSD),
	[send_player_sd(PlayerId, RoleId) || FixSD =/= Shield].

on_tick(TimeStamp) ->
	on_tick_1(mapdb:get_player_role_id_list(), TimeStamp).

%% 玩家圣盾值改变
change_player_sd(PlayerId, RoleId, Value) ->
	NowValue = get_obj_sd(PlayerId, RoleId),
	MaxValue = get_obj_sd_max(PlayerId, RoleId),

	NewValue = common:get_suitable_value(0, MaxValue, NowValue + Value),

	case (NowValue =:= 0 andalso NewValue > 0) orelse (NowValue > 0 andalso NewValue =:= 0) of
		?TRUE -> buff_map:sd_change_buff_enable(PlayerId, RoleId, NewValue > 0);
		_ -> skip
	end,
	set_obj_sd(PlayerId, RoleId, NewValue),
	[send_player_sd(PlayerId, RoleId) || NewValue =/= NowValue].


%% buff(非)圣盾状态效果生效,否则buff效果不生效
%% EffectType[BuffBase]参数1=9,参数为0时非圣盾状态生效buff
%% EffectType[BuffBase]参数1=9,参数大于0时圣盾状态生效buff
check_buff_enable(PlayerId, RoleId, BuffId) ->
	case cfg_buffBase:getRow(BuffId) of
		#buffBaseCfg{effectType = {9, S, _}} ->
			NowSD = get_obj_sd(PlayerId, RoleId),
			common:getTernaryValue(S > 0, NowSD > 0, NowSD =:= 0);
		_ ->
			?TRUE
	end.

send_player_sd(PlayerId) ->
	case map:getMapAI() of
		?MapAI_ClientDungeons -> ok;
		?MapAI_MainlineGuide -> ok;
		?MapAI_51 -> ok;
		?MapAI_52 -> ok;
		_ ->
			RoleIdList = map_role:get_enable_role_id_list(PlayerId),
			lists:map(
				fun(RoleId) ->
					Value = get_obj_sd(PlayerId, RoleId),
					Msg = #pk_GS2U_ObjectShield{code = RoleId, value = Value},
					mapView:broadcastByView_client(Msg, PlayerId, 0)
				end, RoleIdList)
	end.
send_player_sd(PlayerId, RoleId) ->
	case map:getMapAI() of
		?MapAI_ClientDungeons -> ok;
		?MapAI_MainlineGuide -> ok;
		?MapAI_51 -> ok;
		?MapAI_52 -> ok;
		_ ->
			case map_role:is_role_enable(PlayerId, RoleId) of
				?TRUE ->
					Value = get_obj_sd(PlayerId, RoleId),
					Msg = #pk_GS2U_ObjectShield{code = RoleId, value = Value},
					mapView:broadcastByView_client(Msg, PlayerId, 0);
				?FALSE -> ok
			end
	end.

get_obj_sd(PlayerId) ->
	%% TODO RoleId
	RoleId = map_role:get_leader_id(PlayerId),
	get_obj_sd(PlayerId, RoleId).

set_obj_sd_max(PlayerId) ->
	%% TODO RoleId
	RoleIdList = map_role:get_role_id_list(PlayerId),
	lists:foreach(
		fun(RoleId) ->
			set_obj_sd_max(PlayerId, RoleId)
		end, RoleIdList).
set_obj_sd_max(PlayerId, RoleId) ->
	set_obj_sd(PlayerId, RoleId, get_obj_sd_max(PlayerId, RoleId)).

get_obj_sd_max(PlayerId) ->
	%% TODO RoleId
	RoleId = map_role:get_leader_id(PlayerId),
	get_obj_sd_max(PlayerId, RoleId).
get_obj_sd_max(PlayerId, RoleId) ->
	attribute_map:get_object_property_value(PlayerId, RoleId, ?P_ShengDun).

get_obj_sd_i(PlayerId, RoleId) ->
	ShieldMax = get_obj_sd_max(PlayerId, RoleId),
	Shield = get_obj_sd(PlayerId, RoleId),
	{Shield, ShieldMax}.

%%%===================================================================
%%% Internal functions
%%%===================================================================

%% 玩家圣盾值
set_obj_sd(PlayerId, RoleId, Value) ->
	put({map_obj_shengdun, PlayerId, RoleId}, max(0, Value)).
get_obj_sd(PlayerId, RoleId) ->
	case get({map_obj_shengdun, PlayerId, RoleId}) of ?UNDEFINED -> 0;V -> V end.

%% 玩家上一次恢复圣盾的时间
set_obj_sd_time(PlayerId, Value) ->
	put({map_obj_shengdun_time, PlayerId}, Value).
get_obj_sd_time(PlayerId) ->
	case get({map_obj_shengdun_time, PlayerId}) of ?UNDEFINED -> 0;V -> V end.

delete_obj_sd(PlayerId, RoleId) ->
	erase({map_obj_shengdun_time, PlayerId}),
	erase({map_obj_shengdun, PlayerId, RoleId}).


on_tick_1([], _TimeStamp) -> skip;
on_tick_1([{PlayerId, RoleId} | T], TimeStamp) ->
	DiffTime = TimeStamp - get_obj_sd_time(PlayerId),
	NowValue = get_obj_sd(PlayerId, RoleId),
	case get_obj_sd_max(PlayerId, RoleId) of
		MaxValue when MaxValue > 0 andalso MaxValue > NowValue andalso DiffTime >= 5 ->
			set_obj_sd_time(PlayerId, TimeStamp),
			time_add_player_sd(PlayerId, RoleId);
		_ ->
			on_tick_1(T, TimeStamp)
	end.

%% 圣盾自然恢复
time_add_player_sd(PlayerId, RoleId) ->
	MaxValue = get_obj_sd_max(PlayerId, RoleId),
	P_ShengDunHFB = attribute_map:get_object_property_value(PlayerId, RoleId, ?P_ShengDunHFB),
	P_ShengDunZHFB = attribute_map:get_object_property_value(PlayerId, RoleId, ?P_ShengDunZHFB),
	ChangeValue = case mapdb:getMapPlayerProperty(PlayerId, #mapPlayer.battleStatus) of
					  1 ->
						  %% (战斗状态)=【最大圣盾值】*max(P1.非战斗圣盾恢复比/10^4*P1.战斗圣盾恢复比/10^4,0)
						  max(MaxValue * P_ShengDunHFB / 10000 * P_ShengDunZHFB / 10000, 0);
					  _ ->
						  %% (非战斗状态)=【最大圣盾值】*max(P1.非战斗圣盾恢复比/10^4,0)
						  max(MaxValue * P_ShengDunHFB / 10000, 0)
				  end,
	change_player_sd(PlayerId, RoleId, trunc(ChangeValue)).