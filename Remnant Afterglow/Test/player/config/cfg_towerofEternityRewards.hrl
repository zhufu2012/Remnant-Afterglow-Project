-ifndef(cfg_towerofEternityRewards_hrl).
-define(cfg_towerofEternityRewards_hrl, true).

-record(towerofEternityRewardsCfg, {
	%% 奖励ID
	%% 99.总体进度奖
	%% 98.主塔每日进度奖
	%% 1.主塔阶段奖
	%% 2.战士塔阶段奖
	%% 3.法师塔阶段奖
	%% 4.弓手塔阶段奖
	%% 5.圣职塔阶段奖
	%% 6.超级塔阶段奖
	%% 97.超级塔每日奖
	rewardID,
	%% 顺序
	%% 第几个奖励
	order,
	%% 索引
	index,
	%% 奖励上限
	orderMax,
	%% 所需层数
	floors,
	%% 奖励
	%% (顺序，职业，类型，道具id，数量)
	stageReward,
	%% 计算范围
	%% 哪些职业塔参与计算
	%% 配置职业塔ID
	range,
	%% 提示文字
	%% 有配置的需要在对应的道具部分展示具体的文字提示。
	%% 玩家创建二职业后该文字不展示 *代码写死条件
	%% 配置了的道具在创建二职业前无法被领取
	tipsText
}).

-endif.
