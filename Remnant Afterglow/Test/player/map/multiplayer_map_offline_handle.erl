%%%-------------------------------------------------------------------
%%% @author wangdaobin
%%% @copyright (C) 2018, Double Game
%%% @doc
%%%  多人玩法掉线处理
%%%  1, 玩法进程启动时创建对应ets表
%%%  2, 玩家通过玩法进入地图的, 将玩家信息加入到对应ets表中
%%%  3, 玩家从其他地方进入的, 则坚持其合法性
%%% @end
%%% Created : 2018/11/16
%%%-------------------------------------------------------------------
-module(multiplayer_map_offline_handle).


-include("multiplayer_map_offline_handle.hrl").


%% API
-export([create_table/1, update_table/2, clean_table/1, get_multiplayer/2]).

%%%====================================================================
%%% API functions
%%%====================================================================
%% 创建表
create_table(TableName) ->
	ets:new(TableName, [set, public, named_table, {keypos, 2}]).

%% 更新表
update_table(TableName, #multiplayer{} = NewMultiplayer) ->
	ets:insert(TableName, NewMultiplayer).

%% 清理表
%% 活动开启和结束时都清理一下
clean_table(TableName) ->
	ets:delete_all_objects(TableName).

%% 获得一条数据
get_multiplayer(TableName, Key) ->
	case ets:lookup(TableName, Key) of
		[] ->
			illegal;
		[MultiPlayer | _] ->
			MultiPlayer
	end.


%%%===================================================================
%%% Internal functions
%%%===================================================================

