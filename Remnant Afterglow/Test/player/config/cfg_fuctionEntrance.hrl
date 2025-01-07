-ifndef(cfg_fuctionEntrance_hrl).
-define(cfg_fuctionEntrance_hrl, true).

-record(fuctionEntranceCfg, {
	%% 功能ID
	%% 日常ID
	iD,
	%% 类型
	%% 1=个人副本
	%% 2=组队副本
	%% 3=限时玩法
	type,
	%% openaction功能开放ID   
	%% 填0代表不受功能开放限制
	openaction,
	%% 图标
	icon,
	%% 跳转ID（界面跳转表）
	jumpId,
	%% 可购买次数对应副本ID
	%% 填0则为不可购买次数
	dungeonBaseId
}).

-endif.
