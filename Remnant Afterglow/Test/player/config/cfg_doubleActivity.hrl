-ifndef(cfg_doubleActivity_hrl).
-define(cfg_doubleActivity_hrl, true).

-record(doubleActivityCfg, {
	%% 道具ID
	itemID,
	%% 玩法功能开启id
	openID,
	%% 索引
	index,
	%% 对应编号
	no,
	%% 道具类型
	%% 0为经验，
	%% 1为货币，
	%% 2为道具
	itemType
}).

-endif.
