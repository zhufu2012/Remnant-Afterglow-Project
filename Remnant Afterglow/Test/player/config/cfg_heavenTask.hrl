-ifndef(cfg_heavenTask_hrl).
-define(cfg_heavenTask_hrl, true).

-record(heavenTaskCfg, {
	%% 成就ID
	iD,
	%% 0为不可重置
	%% 1为每日重置
	resetType,
	%% 完成条件
	%% 条件
	%% 条件：
	%% 1.参与次数；参数：次数
	%% 2.单场击杀人数；参数：人数
	%% 3.累计击杀人数；参数：人数
	%% 4.累计击杀BOSS；参数：次数
	%% 5.单场最大积分；参数：积分
	%% 6.累计积分；参数：积分
	%% 7.累计获得采集物3；参数：数量
	condPara1,
	%% 参数
	condPara2,
	%% {奖励类型,参数1,参数2}
	%% 类型：
	%% 1为物品，参数1为道具ID，参数2为数量
	%% 2为货币，参数1为货币ID，参数2为数量
	awardPara
}).

-endif.
