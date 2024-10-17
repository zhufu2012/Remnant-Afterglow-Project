-ifndef(cfg_exclusiveRecharge2_hrl).
-define(cfg_exclusiveRecharge2_hrl, true).

-record(exclusiveRecharge2Cfg, {
	%% 档位
	iD,
	%% 开服天数序号
	oder1,
	%% 个人等级序号
	oder2,
	%% 索引
	index,
	%% 最大档位
	maxID,
	%% 需要累充金额，单位：绿钻
	%% （仅计入第三方mover平台储值绿钻额度，仅计入Mover平台储值额度，不包含iOS/Google储值）
	recharge,
	%% VIP等级可见限制
	%% ·如果达成条件不满足，则需要满足VIP等级后才可见具体的达成列表
	%% ·如果达成条件已满足，则无视VIP等级限制，直接可见接下来的那一档列表.
	vIPlimit,
	%% 奖励物品
	%% （职业，物品类型，物品ID，物品数量，是否绑定，装备品质，装备星级）
	%% 职业：0.所有  1004.战士  1005.法师  1006.弓手  1007.魔剑
	%% 物品类型：1.道具  2.货币  3.装备
	%% 是否绑定：0.非绑  1.绑定
	%% 装备品质、装备星级：除装备以外默认填0
	%% 显示顺序：按照配置的从左至右显示.
	itemNew
}).

-endif.
