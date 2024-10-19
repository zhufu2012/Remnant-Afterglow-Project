-ifndef(cfg_slayerGive_hrl).
-define(cfg_slayerGive_hrl, true).

-record(slayerGiveCfg, {
	%% MapAi
	%% 23、个人BOSS
	%% 101、世界BOSS
	%% 110、死亡地狱BOSS
	%% 121、死亡森林BOSS
	%% 112、诅咒禁地BOSS
	%% 132、恶魔宝藏BOSS
	iD,
	%% 对应扣除屏障积分
	score
}).

-endif.
