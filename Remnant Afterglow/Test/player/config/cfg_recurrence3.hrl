-ifndef(cfg_recurrence3_hrl).
-define(cfg_recurrence3_hrl, true).

-record(recurrence3Cfg, {
	%% 老号充值绿钻额度分段
	%% ·最后一档的返利：50%*返利总数（向上取整）-非最后一档的所有档次返利绿钻之和
	%% ·自己在老服的充值额度替换最后一档的充值要求
	%% ·比如在老服充值了501绿钻，玩家会有60/180/501档次的充值要求，获得30/60/161绿钻的返钻，其中161=ROUND（50%*501,0）-（30+60）
	iD,
	%% 返利绿钻数量
	rebate
}).

-endif.
