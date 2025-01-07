-ifndef(cfg_godSystem_hrl).
-define(cfg_godSystem_hrl, true).

-record(godSystemCfg, {
	%% 神系编号
	iD,
	%% 神系名字
	name,
	%% 是否默认开放
	open,
	%% 最大神位
	maxSteps,
	%% 神级天赋ID
	%% 对应天赋类型【GeniusBase】ID
	geniusID,
	%% 参与主神争夺的条件
	%% 最低拍卖|最低神位
	godFightCondition
}).

-endif.
