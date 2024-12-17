-ifndef(cfg_lovePointTimeGive_hrl).
-define(cfg_lovePointTimeGive_hrl, true).

-record(lovePointTimeGiveCfg, {
	%% 对应可以获得亲密度的MapAi
	iD,
	%% 处在地图内获得的亲密度
	%% （时间【秒】，亲密度值）
	lovePoint
}).

-endif.
