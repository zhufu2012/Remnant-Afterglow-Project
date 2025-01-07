-ifndef(cfg_recurrence2_hrl).
-define(cfg_recurrence2_hrl, true).

-record(recurrence2Cfg, {
	%% 老号充值绿钻额度分段，向前取等
	%% 例如 1、201：
	%% 1≤充值<201，取1的数据
	%% 201≤充值，取201的数据
	iD,
	%% 领取奖励的序号
	oder,
	index,
	%% 最大序号
	oderMax,
	%% 达成等级
	grade,
	%% ·当前返利万分比
	%% ·最大序号一档为：累计返利万分比.
	rebate,
	%% 计算结果取整方式
	%% ·配置：参数
	%% ·老号充值绿钻*返利万分比，向下舍入到所需倍数的数值，参数=倍数。
	%% ·另外最大序号一档为：（老号充值绿钻*返利万分比,向上取整的值）-前面计算出来的所有值之和.
	roundingType
}).

-endif.
