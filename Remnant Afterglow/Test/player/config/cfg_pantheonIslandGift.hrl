-ifndef(cfg_pantheonIslandGift_hrl).
-define(cfg_pantheonIslandGift_hrl, true).

-record(pantheonIslandGiftCfg, {
	%% 奖励序号ID
	iD,
	%% 击杀BOSS数目
	%% 这里的BOSS击杀数是神魔战场+神魔幻域共享个数的，做累加。在神魔战场+神魔幻域上都有按钮展示，奖励终身一次
	num,
	%% 奖励
	%% (类型，ID，数量）
	%% 类型：1道具，2货币
	gift
}).

-endif.
