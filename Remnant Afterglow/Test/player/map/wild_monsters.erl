%%%-------------------------------------------------------------------
%%% @author wangdaobin
%%% @copyright (C) 2018, Double Game
%%% @doc  刷怪
%%% @end
%%% Created : 2018/9/23
%%%-------------------------------------------------------------------
-module(wild_monsters).

-include("global.hrl").
-include("logger.hrl").

-record(wild_monsters, {
    monster_uid = 0, %% 怪物uid
    monster_sid = 0, %% 怪物sid
	monster_attr = {},
    attr_index = 1,
	monster_exp = [],
    born_x = 0, %% 出生地x坐标
    born_y = 0, %% 出生地y坐标
    rotw = 0, %% 朝向
    recover_time = 0, %% 重生间隔时间
    dead_time = 0 %% 死亡时间
}).

%% API
-export([init_monster/4, onDead/1, on_tick/0]).


%% 心跳
on_tick() ->
    WildMonsterInfoList = get_wild_monsters_info(),
    NowMillseconds = map:milliseconds(),
    Fun = fun
              (WildMonster = #wild_monsters{dead_time = 0}) -> %% 该怪物未死亡
                  WildMonster;
              (WildMonster = #wild_monsters{dead_time = DeadTime, recover_time = RecoverTime, monster_sid = MonsterSid, attr_index = Index,
				  monster_attr = MonsterAttr, monster_exp = MonsterExp,born_x = X, born_y = Y, rotw = Rotw}) when NowMillseconds >= DeadTime + RecoverTime -> %% 该怪物死亡并且到了重生时间

                  NewMonsterUid = monsterMgr:addMonster(MonsterAttr, MonsterExp, Index, 1, 1, 0, MonsterSid, X, Y, Rotw, 0, 0, 0, 0), %% 添加怪物到地图
                  WildMonster#wild_monsters{monster_uid = NewMonsterUid, dead_time = 0};
              (WildMonster) ->
                  WildMonster
          end,
    NewWidlMonstersInfo = lists:map(Fun, WildMonsterInfoList),
    set_wild_monsters_info(NewWidlMonstersInfo) .


%% 死亡
onDead(MonsterUiD) ->
    WildMonstersInfo = get_wild_monsters_info(),
    case lists:keyfind(MonsterUiD, #wild_monsters.monster_uid, WildMonstersInfo) of
        WildMonster = #wild_monsters{} ->
            NewWildMonstersInfo = lists:keyreplace(MonsterUiD, #wild_monsters.monster_uid,
                WildMonstersInfo, WildMonster#wild_monsters{dead_time = map:milliseconds()}),
            set_wild_monsters_info(NewWildMonstersInfo);
        _ ->
            skip
    end .

%% 添加怪物
init_monster(MonsterList, MonsterBornList, MonsterAttr, MonsterExp) ->
    Fun = fun({Index, X, Y, RotW}, Acc) ->
                  case lists:keyfind(Index, 1, MonsterList) of
                      {_, DataId, Seconds} ->
                          MonsterUid = monsterMgr:addMonster(MonsterAttr, MonsterExp, Index, 1, 1, 0, DataId, X, Y, RotW, 0, 0, 0, 0), %% 添加怪物到地图
                          WildMonster = #wild_monsters{
                              monster_uid = MonsterUid,
                              monster_sid = DataId,
                              attr_index = Index,
							  monster_attr = MonsterAttr,
							  monster_exp = MonsterExp,
                              born_x = X,
                              born_y = Y,
                              rotw = RotW,
                              recover_time = Seconds * 1000
                          },
                          [WildMonster | Acc];
                      _ ->
                          Acc
                  end
          end,
    NewWildMonstersInfo = lists:foldl(Fun, [], MonsterBornList),
    set_wild_monsters_info(NewWildMonstersInfo) .


%%%===================================================================
%%% Internal functions
%%%===================================================================
%% return:
get_wild_monsters_info() ->
    case get(wild_monsters_info) of
        ?UNDEFINED ->
            [];
        WildMonstersInfo ->
            WildMonstersInfo
    end.

set_wild_monsters_info(WildMonstersInfo) ->
    put(wild_monsters_info, WildMonstersInfo).