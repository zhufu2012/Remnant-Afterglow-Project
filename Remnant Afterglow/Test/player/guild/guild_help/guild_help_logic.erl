%%%-------------------------------------------------------------------
%%% @author suw
%%% @copyright (C) 2020, DoubleGame
%%% @doc
%%%
%%% @end
%%% Created : 25. 4月 2020 13:51
%%%-------------------------------------------------------------------
-module(guild_help_logic).
-author("suw").

-include("record.hrl").
-include("guild_help.hrl").
-include("db_table.hrl").
-include("id_generator.hrl").

%% API
-export([get_helper_seeker/3, is_in_help/1, is_in_help_req/1, is_in_help_monster_area/3, is_in_help_common/1,
	is_in_help_req_common/1, help_msg_list_2_record/1, help_msg_record_2_list/1, make_new_help_msg_common/3, is_help_enter_map/2]).

%% 获取求助者信息
get_helper_seeker(PlayerID, MapAI, MapDataID) ->
	case etsBaseFunc:readRecord(?ETS_GuildHelpRelation, PlayerID) of
		#guild_help_relation{help_seeker_id = HelpSeekerID, map_data_id = MapDataID, map_ai = MapAI, monster_data_id = MonsterDataId} ->
			{HelpSeekerID, MonsterDataId};
		_ ->
			case etsBaseFunc:readRecord(?ETS_GuildHelpRequest, PlayerID) of
				#guild_help_request{map_data_id = MapDataID, monster_data_id = MonsterDataID} ->
					{PlayerID, MonsterDataID};
				_ ->
					{}
			end
	end.

%% 协助
is_in_help(PlayerID) ->
	etsBaseFunc:member(?ETS_GuildHelpRelation, PlayerID).

is_in_help_common(PlayerID) ->
	etsBaseFunc:member(?ETS_GuildHelpRelationCommon, PlayerID).

%% 求助
is_in_help_req(PlayerID) ->
	etsBaseFunc:member(?ETS_GuildHelpRequest, PlayerID).

is_in_help_req_common(ID) ->
	etsBaseFunc:member(?ETS_GuildHelpRequestCommon, ID).

%% 进入的协助区域
is_in_help_monster_area(PlayerID, MapDataID, MonsterDataID) ->
	Pred1 = case etsBaseFunc:readRecord(?ETS_GuildHelpRelation, PlayerID) of
				#guild_help_relation{map_data_id = MapDataID, monster_data_id = MonsterDataID} ->
					?TRUE;
				_ ->
					?FALSE
			end,
	Pred2 = case etsBaseFunc:readRecord(?ETS_GuildHelpRequest, PlayerID) of
				#guild_help_request{map_data_id = MapDataID, monster_data_id = MonsterDataID} ->
					?TRUE;
				_ ->
					?FALSE
			end,
	Pred1 orelse Pred2.

is_help_enter_map(PlayerID, MapDataID) ->
	case etsBaseFunc:readRecord(?ETS_GuildHelpRelation, PlayerID) of
		#guild_help_relation{map_data_id = MapDataID} ->
			?TRUE;
		_ ->
			?FALSE
	end.

help_msg_list_2_record(List) ->
	Record = list_to_tuple([help_msg_common | List]),
	Record#help_msg_common{
		param = gamedbProc:dbstring_to_term(Record#help_msg_common.param)
	}.

help_msg_record_2_list(Record) ->
	tl(tuple_to_list(Record#help_msg_common{
		param = gamedbProc:term_to_dbstring(Record#help_msg_common.param)
	})).

make_new_help_msg_common(PlayerID, OpenAction, Param) ->
	#help_msg_common{
		player_id = PlayerID,
		id = id_generator:generate(?ID_TYPE_Help_Msg),
		open_action_id = OpenAction,
		param = Param
	}.