-ifndef(cfg_gameAssetsData_hrl).
-define(cfg_gameAssetsData_hrl, true).

-record(gameAssetsDataCfg, {
	iD,
	%% MonsterID
	%% LevelMap
	%% Sound
	%% TaskID
	%% VFX
	%% dikuai
	assetType,
	%% 分段：只填0-30级，31-100级内容；后面不填
	data,
	packIndex,
	levelLimit,
	task_des
}).

-endif.
