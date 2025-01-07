-ifndef(cfg_expeditionBase_hrl).
-define(cfg_expeditionBase_hrl, true).

-record(expeditionBaseCfg, {
	%% 远征阶段
	iD,
	%% 联服数量
	%% 1、单服
	%% 大于1为联服：
	%% 2、2联服
	%% 4、4联服
	%% 8、8联服
	servers
}).

-endif.
