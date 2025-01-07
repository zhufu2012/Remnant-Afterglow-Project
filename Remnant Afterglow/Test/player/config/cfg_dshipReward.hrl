-ifndef(cfg_dshipReward_hrl).
-define(cfg_dshipReward_hrl, true).

-record(dshipRewardCfg, {
	%% 商船品质
	%% 0为普通白
	%% 1为优秀蓝
	%% 2为史诗紫
	%% 3为传说橙
	%% 4为神话红
	%% 5为粉色
	%% 6为神装
	iD,
	%% 护送过程中是否被掠夺成功(填0否，填1是)
	ifPlunder,
	%% 索引
	index,
	%% 获得道具奖励
	%% (类型，ID，数量)
	%% 类型：1.道具；
	%% 2.货币；
	award,
	%% 任务道具奖励
	%% (任务ID，ID，数量，是否绑定，持续时间)
	taskAward
}).

-endif.
