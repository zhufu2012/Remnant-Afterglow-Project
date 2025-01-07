-ifndef(cfg_chariotLevel_hrl).
-define(cfg_chariotLevel_hrl, true).

-record(chariotLevelCfg, {
	%% 科技id
	iD,
	%% 建筑等级
	buildingLv,
	%% 索引
	index,
	%% (最小等级，最大等级）
	gradeInterval
}).

-endif.
