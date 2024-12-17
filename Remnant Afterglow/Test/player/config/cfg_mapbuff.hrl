-ifndef(cfg_mapbuff_hrl).
-define(cfg_mapbuff_hrl, true).

-record(mapbuffCfg, {
	%% 地图id
	%% 2开头7位数id
	%% 详情见数值表id分段
	iD,
	%% 等级
	lEVEL,
	%% index
	index,
	%% 地图buff
	buffID,
	%% 是否使用联服的最大世界等级
	%% 1，是（如果没有联服，还是用本服）
	%% 0，否（无论联服都用本服）
	jointService
}).

-endif.
