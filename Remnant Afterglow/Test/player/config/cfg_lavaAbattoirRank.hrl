-ifndef(cfg_lavaAbattoirRank_hrl).
-define(cfg_lavaAbattoirRank_hrl, true).

-record(lavaAbattoirRankCfg, {
	%% 关卡ID
	dungeonId,
	%% 名次下限
	limit,
	%% 名次上限
	max,
	%% Key
	index,
	%% 奖励(道具/货币)
	%% (职业,类型,类型ID,是否绑定,数量)
	%% 奖励序号：OrderReward字段的奖励序号
	%% 职业：0=所有职业的人均可获得该掉落,1004=战士,1005=法师,1006=弓手.(如果是职业一的人,不会掉落职业二的奖励,但是可以获得不分职业的奖励)
	%% 类型1：道具,类型ID为道具ID
	%% 类型2：货币,类型ID为货币ID
	%% 是否绑定：0为非绑 1为绑定(货币没有绑定或非绑的说法)
	%% 数量：奖励道具的数量
	award
}).

-endif.
