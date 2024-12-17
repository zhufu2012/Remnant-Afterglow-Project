-ifndef(cfg_cityModleShow_hrl).
-define(cfg_cityModleShow_hrl, true).

-record(cityModleShowCfg, {
	%% 地图id，同mapsetting中的地图id
	iD,
	%% 地图名，策划自己看
	name,
	%% 地图演员的等级段限制
	level
}).

-endif.
