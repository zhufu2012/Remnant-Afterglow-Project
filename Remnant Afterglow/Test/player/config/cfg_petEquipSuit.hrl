-ifndef(cfg_petEquipSuit_hrl).
-define(cfg_petEquipSuit_hrl, true).

-record(petEquipSuitCfg, {
	%% 套装数（这里最大为总个数）
	iD,
	%% (序号，品级，星级）
	qualityStarSort,
	%% （序号，属性ID，值）
	attributeSort
}).

-endif.
