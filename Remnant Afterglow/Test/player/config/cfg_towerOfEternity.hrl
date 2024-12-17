-ifndef(cfg_towerOfEternity_hrl).
-define(cfg_towerOfEternity_hrl, true).

-record(towerOfEternityCfg, {
	%% 职业塔ID
	iD,
	%% 职业ID
	profession,
	%% 开放时间
	%% 每周几开放，填0表示无限制
	%% 刷新时间为凌晨5点
	openingTime,
	%% 封顶楼层
	%% 第四职业开启前最多能够到达的层数，填0表示无封顶楼层
	cap,
	%% 解锁条件
	%% 填主塔层数
	%% 填0表示无解锁条件
	unlock,
	%% 层数开放规则
	%% (开放次数,层数上限)
	%% 高塔每次开放，可挑战的层数上限不同；主塔永久开放，即算作每天都开放1次
	floorLimit,
	%% 通关唯一称号ID
	%% 这里配的是道具ID，道具ID开头减掉14则为称号ID
	onlyTitle
}).

-endif.
