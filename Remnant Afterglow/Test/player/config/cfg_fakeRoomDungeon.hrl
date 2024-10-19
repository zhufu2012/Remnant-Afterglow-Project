-ifndef(cfg_fakeRoomDungeon_hrl).
-define(cfg_fakeRoomDungeon_hrl, true).

-record(fakeRoomDungeonCfg, {
	%% 玩家等级
	index,
	%% 0：该等级不创建组队房间
	%% {副本id1，副本id2……副本idn}：1~n的副本随机
	dungeonId,
	%% 大圣之路等级
	%% 22：绿品——30级
	%% 69：蓝品——50级
	%% 123：紫品——72级
	%% 195：橙品——104级
	character
}).

-endif.
