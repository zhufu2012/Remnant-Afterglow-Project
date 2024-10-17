-ifndef(cfg_cumulativeRechargeNew_hrl).
-define(cfg_cumulativeRechargeNew_hrl, true).

-record(cumulativeRechargeNewCfg, {
	%% 累充奖励ID
	iD,
	%% 第x天
	day,
	index,
	%% 需要累充金额，单位：绿钻
	recharge,
	%% 作者:
	%% 奖励物品
	%% （排序，职业，物品类型，物品ID，物品数量，是否绑定，装备品质，装备星级，特效品质）
	%% 排序：排序为1的奖励显示为大ICON，排序从1开始配置，一个排序占一个位置，显示顺序
	%% 职业：0.所有  1004.战士  1005.法师  1006.弓手  1007.魔剑
	%% 物品类型：1.道具  2.货币  3.装备
	%% 是否绑定：0.非绑  1.绑定
	%% 装备品质、装备星级：除装备以外默认填0
	%% 特效品质：0白(无特效)、1蓝、2紫、3橙、4红、5粉（2/3/4才有资源）
	%% 品质：1白 2蓝 3紫 4橙 5红
	itemNew
}).

-endif.
