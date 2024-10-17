-ifndef(cfg_promotionTypeT_hrl).
-define(cfg_promotionTypeT_hrl, true).

-record(promotionTypeTCfg, {
	iD,
	%% 位数：1个位，2十位，3百位
	order,
	index,
	%% 初始抽卡值及权重
	startDraw,
	%% 重置序号条件
	%% （重置序号，条件类型，参数）
	%% 重置序号：对应重置权重序号；
	%% 条件类型：1，当天累计充值非绑，参数=0时，表示充值任意金额
	resetCondi,
	%% 充值抽卡权重
	%% （重置序号，值，权重）
	%% 重置序号：重置序号条件；
	resetDraw,
	%% 奖励货币
	awardsType
}).

-endif.
