-ifndef(cfg_illustrationsSmelt_hrl).
-define(cfg_illustrationsSmelt_hrl, true).

-record(illustrationsSmeltCfg, {
	%% 熔炼等级
	iD,
	%% 到下一级需要经验值
	needExp,
	%% 最大等级
	maxLv,
	%% 附带当前等级属性
	%% (属性id，数量)
	attribute
}).

-endif.
