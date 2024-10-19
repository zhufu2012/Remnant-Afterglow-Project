-ifndef(cfg_petGo_hrl).
-define(cfg_petGo_hrl, true).

-record(petGoCfg, {
	%% 出战位置
	iD,
	%% 解锁条件
	%% （类型，参数1，参数2）
	%% 类型0，没任何条件直接解锁
	%% 类型1，玩家等级解锁，参数1=玩家等级，参数2=0；
	%% 类型2，转职等级，参数1=转职数，参数2=0；
	%% 类型3，VIP等级，参数1=VIP等级，参数2=0.
	needWay
}).

-endif.
