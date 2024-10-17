-ifndef(cfg_useChange_hrl).
-define(cfg_useChange_hrl, true).

-record(useChangeCfg, {
	%% 类型
	%% 1.礼包
	%% （其他的填MAP AI）
	%% 2 挂机
	iD,
	%% ID
	%% 1.对应的礼包ID
	%% 2-5 如果是MAP AI这里填0
	%% 挂机类型的ID为1
	typeID,
	%% Key
	index
}).

-endif.
