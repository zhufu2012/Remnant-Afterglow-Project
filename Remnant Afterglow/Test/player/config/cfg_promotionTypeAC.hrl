-ifndef(cfg_promotionTypeAC_hrl).
-define(cfg_promotionTypeAC_hrl, true).

-record(promotionTypeACCfg, {
	%% ID
	%% 活动type 126
	iD,
	%% 抽奖次数获得条件
	%% 充值龙钻数量
	condition,
	%% 奖励
	%% （奖励数量，奖励倍数，万分比)
	awardWeight,
	%% 暴击值获得概率
	%% 暴击值满后，下一次抽奖获得的钻石数量翻倍
	%% （权重，每次抽奖后获得的暴击值)
	doubleAward,
	%% 暴击总值
	doubleAwardTotal,
	%% 转盘外圈钻石数量
	award,
	%% 转配内圈倍数
	multiple,
	%% 奖励货币类型
	%% 11：龙钻（原非绑)
	%% 0：钻石（原绑钻)
	currency,
	%% 抽奖次数上限
	maxChance,
	%% 走马灯阈值
	%% 当获得的总钻石数达到目标则显示走马灯
	notice
}).

-endif.
