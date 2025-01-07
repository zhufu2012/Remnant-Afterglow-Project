-ifndef(cfg_equipSmelt_hrl).
-define(cfg_equipSmelt_hrl, true).

-record(equipSmeltCfg, {
	%% 炼金等级
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
