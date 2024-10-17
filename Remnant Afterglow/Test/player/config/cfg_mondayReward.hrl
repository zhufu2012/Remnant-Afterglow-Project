-ifndef(cfg_mondayReward_hrl).
-define(cfg_mondayReward_hrl, true).

-record(mondayRewardCfg, {
	%% ID记录用
	iD,
	%% (职业，物品类型，物品ID，物品数量，是否绑定，装备品质,星级)
	%% 1、职业ID：1004战 1005法 1006弓 1007魔剑
	%% 2、物品类型：1道具，2货币，3装备
	%% 3、物品ID：对应ID
	%% 4、物品数量：对应数量
	%% 5、是否绑定：0.非绑  1.绑定
	%% 6、是否显示转圈特效：1.显示  0.不显示
	%% 7、装备品类：是装备就填，不是装备默认填0.
	item,
	%% 该库内容抽中了是否要从本周抽奖中剔除
	%% 1.剔除
	%% 2.不剔除
	deleteReward
}).

-endif.
