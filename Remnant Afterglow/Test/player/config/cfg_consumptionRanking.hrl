-ifndef(cfg_consumptionRanking_hrl).
-define(cfg_consumptionRanking_hrl, true).

-record(consumptionRankingCfg, {
	iD,
	%% 类型|参数
	%% 类型=0：活动结束后结算（整个活动只开一场）
	%% 类型=1：每天0点结算和重置（最后1天为活动结束时间结算）
	settlement,
	%% 类型|榜单人数|上榜条件
	%% 类型1=消耗钻石（仅蓝钻）：上榜条件为消耗蓝钻数量
	%% 类型2=消耗绿钻（仅绿钻）：上榜条件为消耗绿钻数量
	type,
	%% 奖励
	%% (排名序号，职业，类型，ID，数量，品质，星级，是否绑定，转圈特效)
	%% 排名序号：1,2,3，…
	%% 职业:
	%% 类型1=道具，ID=道具ID；
	%% 类型2=货币，ID=货币ID
	%% 类型3=装备，ID=装备ID
	%% 品质、星级：对应装备的品质和星级，其他类型无效
	%% 是否绑定：0.非绑  1.绑定
	%% 转圈特效：0=没有，1=有
	reward
}).

-endif.
