%%%-------------------------------------------------------------------
%%% @author zhangrj
%%% @copyright (C) 2018, <COMPANY>
%%% @doc
%%% 战盟科技（玩家进程）
%%% @end
%%% Created : 03. 八月 2018 15:15
%%%-------------------------------------------------------------------
-module(science).
-author("zhangrj").
-include("guild.hrl").
-include("science.hrl").
-include("record.hrl").
-include("cfg_guildscience.hrl").
-include("globalDict.hrl").
-include("db_table.hrl").
-include("error.hrl").
-include("reason.hrl").
-include("netmsgRecords.hrl").
-include("logDefine.hrl").
-include("variable.hrl").

%% API
-export([
	player_online/1,
	check_func_open/0,
	get_science_info/0,
	up_level_science/2,
	get_science_attrs/0,
	on_load/0
]).

on_load() ->
	Ret = case table_player:lookup(db_science, player:getPlayerID()) of
			  [] -> [];
			  List -> [db_to_record(R) || R <- List]
		  end,
	put_science(Ret).
update([]) -> ok;
update(R) ->
	DB_R = case is_list(R) of
			   ?TRUE -> [record_to_db(R0) || R0 <- R];
			   ?FALSE -> record_to_db(R)
		   end,
	table_player:insert(db_science, DB_R).

db_to_record(R) ->
	#science{
		id = R#db_science.science_id,
		level = R#db_science.level
	}.
record_to_db(R) ->
	PlayerID = player:getPlayerID(),
	#db_science{
		player_id = PlayerID,
		science_id = R#science.id,
		level = R#science.level
	}.

%% 数据存储
put_science(List) ->
	put(?PlayerScience, List).
get_science() ->
	case get(?PlayerScience) of
		?UNDEFINED -> [];
		List -> List
	end.
update_science(Info) ->
	List = get_science(),
	NewList = lists:keystore(Info#science.id, #science.id, List, Info),
	put_science(NewList),
	update(Info).
get_science(ID) ->
	List = get_science(),
	case lists:keyfind(ID, #science.id, List) of
		?FALSE -> {};
		R -> R
	end.

player_online(_PlayerID) ->
	check_func_open(),
	ok.

%% 检查是否初始化科技
check_func_open() ->
	case guide:is_open_action(?OpenAction_Science) andalso player:getPlayerProperty(#player.guildID) =/= 0 of
		?TRUE -> init_science();
		?FALSE -> ok
	end.

%% 初始化科技
init_science() ->
	?metrics(begin
	List = cfg_guildscience:getKeyList(),
	InitList = [#science{id = ID} || {ID, Lv} <- List, Lv =:= 1, get_science(ID) =:= {}],
	[update_science(R) || R <- InitList],
	update(InitList),
	[attribute_player:on_prop_change() || InitList =/= []]
	end).

get_science_info() ->
	case is_func_open() of
		?TRUE ->
			List = get_science(),
			Func =
				fun(Info) ->
					#pk_science{
						id = Info#science.id,
						level = Info#science.level
					}
				end,
			player:send(#pk_GS2U_sendGuildScience{science_list = lists:map(Func, List)});
		?FALSE ->
			player:send(#pk_GS2U_sendGuildScience{})
	end.


%% 升级
up_level_science(ID, Times) ->
	try
		?CHECK_THROW(is_func_open(), ?ERROR_FunctionClose),
		Info = get_science(ID),
		case Info of
			{} -> throw(?ErrorCode_Guild_WrongScience);
			_ -> ok
		end,
		GuildID = player:getPlayerProperty(#player.guildID),
		case Info#science.level >= guild_pub:get_attr_value_by_index(GuildID, ?Guild_TecLv) of
			?TRUE -> throw(?ErrorCode_Guild_ScienceMaxLevel);
			?FALSE -> ok
		end,
		#guildscienceCfg{needs = Need, maxLv = MaxLevel, lockLv = LockLv} = cfg_guildscience:getRow(ID, Info#science.level),
		case Info#science.level >= MaxLevel of
			?TRUE -> throw(?ErrorCode_Guild_ScienceMaxLevel);
			?FALSE -> ok
		end,
		case player:getLevel() >= LockLv of
			?TRUE -> ok;
			?FALSE -> throw(?ErrorCode_Guild_science_level)
		end,
		AddLevel = calc_can_up_level(Need, 0, Times),
		NewInfo = Info#science{level = Info#science.level + AddLevel},
		update_science(NewInfo),
		attribute_player:on_prop_change(),
		logdbProc:log_playerAction(?Player_Action_Science, ID, integer_to_list(Info#science.level + AddLevel)),
		player:send(#pk_GS2U_uplevelGuildScience{id = ID, result = 0, times = AddLevel})
	catch
		Result -> player:send(#pk_GS2U_uplevelGuildScience{id = ID, result = Result, times = Times})
	end.
calc_can_up_level(_Cost, Acc, 0) -> Acc;
calc_can_up_level(Cost, Acc, Times) ->
	case currency:delete([Cost], ?Reason_Guild_UpLevelScience) of
		?ERROR_OK ->
			calc_can_up_level(Cost, Acc + 1, Times - 1);
		_ ->
			Acc
	end.

%% 获取战盟科技的属性
get_science_attrs() ->
	List = get_science(),
	Func =
		fun(R, L) ->
			#guildscienceCfg{attribute = Attr} = cfg_guildscience:getRow(R#science.id, R#science.level),
			Attr ++ L
		end,
	attribute:base_prop_from_list(common:listValueMerge(lists:foldl(Func, [], List))).

is_func_open() ->
	variable_world:get_value(?WorldVariant_Switch_Guild) =:= 1 andalso guide:is_open_action(?OpenAction_guild).