-ifndef(cfg_hatcheEggs2Base_hrl).
-define(cfg_hatcheEggs2Base_hrl, true).

-record(hatcheEggs2BaseCfg, {
	%% 英雄ID
	iD,
	%% 进化最终ID
	%% （英雄ID）
	petID,
	%% 孵蛋二期总持续时间（秒）
	persistTime
}).

-endif.
