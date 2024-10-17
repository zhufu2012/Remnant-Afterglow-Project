-ifndef(cfg_unionGuildFight6_hrl).
-define(cfg_unionGuildFight6_hrl, true).

-record(unionGuildFight6Cfg, {
	%% 竞猜类型
	%% 1、8强赛
	%% 2、4强赛
	%% 3，季军赛竞猜
	%% 4，冠军赛竞猜
	iD,
	%% 可竞猜次数
	num,
	%% 竞猜奖励
	%% （物品类型,物品id，数量，是否绑定）
	%% 类型：1=道具，2=货币
	reward
}).

-endif.
