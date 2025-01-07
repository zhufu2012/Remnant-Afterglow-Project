-ifndef(cfg_pointAcquire_hrl).
-define(cfg_pointAcquire_hrl, true).

-record(pointAcquireCfg, {
	%% 积分ID
	iD,
	%% 分差
	%% （序号，分差值上限，分差值下限）
	%% 分差值=敌人积分减去自己积分
	subtraction,
	%% （序号，积分）
	%% 赢就加这么多
	point,
	%% 扣分比例
	%% 赢了正常加积分，输的扣分要乘以这个系数
	proportion
}).

-endif.
