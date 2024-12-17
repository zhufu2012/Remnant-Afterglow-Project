%%%-------------------------------------------------------------------
%%% @author suw
%%% @copyright (C) 2020, DoubleGame
%%% @doc
%%%
%%% @end
%%% Created : 09. 三月 2020 19:58
%%%-------------------------------------------------------------------
-module(bonfire_boss_logic).
-author("suw").

-include("record.hrl").
-include("logger.hrl").
-include("bonfire_boss.hrl").
-include("error.hrl").
-include("cfg_guildDinneDrink.hrl").
-include("netmsgRecords.hrl").
-include("variable.hrl").
-include("cfg_dinnerBossBase.hrl").


%% API
-export([set_bonfire_boss_data/1, get_bonfire_boss_data/0, get_schedule_time/1, is_bonfire_func_open/0, is_boss_func_open/0,
	get_guild_drink_info/1, is_drink_active/0, drink_limit_check/3, get_bonfire_time/0, get_rank_list/1, get_guild_rank_list/1,
	make_guild_rank_msg/1, make_player_rank_msg/1, get_stage/0, make_guild_rank_detail/0, make_player_rank_detail/1, get_member_class/2,
	get_schedule_boss_time/1, un_merge_item/1, boss_refresh_broadcast/0]).

%% 活动数据
set_bonfire_boss_data(Data) ->
	d:storage_put('bonefire_boss_ac_data', Data).
get_bonfire_boss_data() ->
	d:storage_get('bonefire_boss_ac_data', #bonfire_data{}).

get_stage() ->
	#bonfire_data{stage = Stage} = bonfire_boss_logic:get_bonfire_boss_data(),
	Stage.

get_schedule_time(NowTime) ->
	case common:get_action_time(?OpenAction_GuildCamp, NowTime) of
		{} ->
			?LOG_ERROR("no cfg time ~p", [{?OpenAction_GuildCamp, NowTime}]),
			{0, 4294967295, 4294967295};
		R -> R
	end.
get_schedule_boss_time(NowTime) ->
	case common:get_action_time(?OpenAction_BonfireBoss, NowTime) of
		{} ->
			?LOG_ERROR("no cfg time ~p", [{?OpenAction_BonfireBoss, NowTime}]),
			{0, 4294967295, 0};
		R -> R
	end.

get_guild_drink_info(GuildID) ->
	case etsBaseFunc:readRecord(?ETS_BonfireBoss, GuildID) of
		{} -> [];
		#bonfire_boss{player_drink_info = R} -> R
	end.

%% 功能开启
is_bonfire_func_open() -> variable_world:get_value(?WorldVariant_Switch_GuildCamp) =:= 1.
is_boss_func_open() -> variable_world:get_value(?WorldVariant_Switch_BonfireBoss) =:= 1.

is_drink_active() ->
	#bonfire_data{stage = Stage} = bonfire_boss_logic:get_bonfire_boss_data(),
	Stage =:= ?Bonfire_Drink_Stage orelse Stage =:= ?Bonfire_Exp_Stage orelse Stage =:= ?Bonfire_Boss_Stage.

%% 喝酒限制
drink_limit_check(1, #bonfire_player_drink{t1 = T1} = Info, T) when T1 + 1 =< T ->
	{?ERROR_OK, Info#bonfire_player_drink{t1 = T1 + 1}};
drink_limit_check(2, #bonfire_player_drink{t2 = T2} = Info, T) when T2 + 1 =< T ->
	{?ERROR_OK, Info#bonfire_player_drink{t2 = T2 + 1}};
drink_limit_check(_, _, _) ->
	{?ErrorCode_GCamp_DrinkTimesLimit, {}}.


%% 活动时间
get_bonfire_time() ->
	#bonfire_data{open_time = OpenTime, close_time = CloseTime} = bonfire_boss_logic:get_bonfire_boss_data(),
	{OpenTime, CloseTime}.

get_rank_list(DamageList) ->
	List = lists:reverse(lists:keysort(#playerDamageInfo.damage, DamageList)),
	Func = fun(R, N) ->
		{{N, R}, N + 1}
		   end,
	{RandList, _} = lists:mapfoldl(Func, 1, List),
	RandList.

get_guild_rank_list(List) ->
	NewList = lists:reverse(lists:keysort(#bonfire_cluster_top.total_damage, List)),
	Func = fun(R, N) ->
		{{N, R}, N + 1}
		   end,
	{RandList, _} = lists:mapfoldl(Func, 1, NewList),
	RandList.

make_guild_rank_msg(Data) ->
	lists:map(fun({Rank, #bonfire_cluster_top{guild_id = GuidID, server_id = ServerID, guild_name = GuildName,
		total_damage = TotalDamage}}) ->
		#pk_bonfireGuildHurt{
			rank = Rank,
			guild_id = GuidID,
			guild_name = GuildName,
			damage = TotalDamage,
			serverName = player:enter_server_name(ServerID)
		}
			  end, Data).

make_player_rank_msg(Data) ->
	lists:map(fun({Rank, #playerDamageInfo{player_id = PlayerID, player_name = Name, damage = Damage, server_name = ServerName}}) ->
		#pk_demonRankInfo{
			playerID = PlayerID,
			name = Name,
			isAward = 0,
			damage = Damage,
			rank = Rank,
			serverName = ServerName
		}
			  end, Data).

make_player_rank_detail(GuildID) ->
	case etsBaseFunc:readRecord(?ETS_BonfireBoss, GuildID) of
		{} -> [];
		#bonfire_boss{guild_player_rank_list = RankList} ->
			MemberClassList = guild_pub:get_guild_member_list(GuildID),
			lists:map(fun({Rank, #playerDamageInfo{player_id = PlayerID, career = Career, player_name = PlayerName, battle_value = Bt, damage = Damage}}) ->
				#pk_bonfirePlayerHurtDetail{
					rank = Rank,
					player_id = PlayerID,
					career = Career,
					head_id = mirror_player:get_player_equip_head(PlayerID),
					head_frame = mirror_player:get_player_equip_frame(PlayerID),
					guild_postion = get_member_class(PlayerID, MemberClassList),
					player_name = PlayerName,
					battle_value = Bt,
					damage = Damage
				}
					  end, RankList)
	end.

make_guild_rank_detail() ->
	Data = etsBaseFunc:getAllRecord(?ETS_BonfireClusterTop),
	GuildTopList = bonfire_boss_logic:get_guild_rank_list(Data),
	lists:map(fun({R, #bonfire_cluster_top{guild_name = GuildName, chairman_name = ChairmanName, total_damage = Damage, server_id = ServerID}}) ->
		#pk_bonfireGuildHurtDetail{
			rank = R,
			guild_name = GuildName,
			chairman_name = ChairmanName,
			damage = Damage,
			serverName = player:enter_server_name(ServerID)
		}
			  end, GuildTopList).

%% 玩家职位
get_member_class(PlayerID, MemberClassList) ->
	case lists:keyfind(PlayerID, 1, MemberClassList) of
		{_, R} -> R;
		_ -> 0
	end.

un_merge_item(List) ->
	{Split, Left} = lists:partition(fun({_, N, _, _}) -> N > 1 end, List),
	SplitList = lists:foldl(fun({ID, Num, Bind, Ex}, Ret) ->
		lists:duplicate(Num, {ID, 1, Bind, Ex}) ++ Ret
							end, [], Split),
	SplitList ++ Left.

boss_refresh_broadcast() ->
	Week = time:day_of_week(time:get_localtime()),
	case cfg_dinnerBossBase:getRow(Week) of
		#dinnerBossBaseCfg{boss = [{_, DataID} | _]} ->
			Text = fun(Language) ->
				language:format(language:get_server_string("GuildStationBOSS_gonggao1", Language), [richText:getMonsterText(DataID, Language)]) end,
			marquee:sendConditionNotice(0, 1, 0, [{?OpenAction_BonfireBoss, guildStationBOSS_gonggao1, Text}]);
		_ ->
			?LOG_ERROR("no find cfg key ~p", [Week])
	end.