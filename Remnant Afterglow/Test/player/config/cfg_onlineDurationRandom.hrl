-ifndef(cfg_onlineDurationRandom_hrl).
-define(cfg_onlineDurationRandom_hrl, true).

-record(onlineDurationRandomCfg, {
	%% ID记录用
	iD,
	%% 奖励库ID
	rewardPool,
	%% 数量ID
	number,
	index,
	%% 权重
	%% 同一次抽取的8个物品不能重复
	weight,
	%% (职业，物品类型，物品ID，物品数量，是否绑定，是否显示转圈特效，装备品质,星级)
	%% 1、职业ID：1004战 1005法 1006弓 1007魔剑
	%% 2、物品类型：1道具，2货币，3装备
	%% 3、物品ID：对应ID
	%% 4、物品数量：对应数量
	%% 5、是否绑定：0.非绑  1.绑定
	%% 6、是否显示转圈特效：1.显示  0.不显示
	%% 7、装备品类：是装备就填，不是装备默认填0.
	item
}).

-endif.
