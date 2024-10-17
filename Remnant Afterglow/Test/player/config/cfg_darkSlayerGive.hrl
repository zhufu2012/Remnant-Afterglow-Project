-ifndef(cfg_darkSlayerGive_hrl).
-define(cfg_darkSlayerGive_hrl, true).

-record(darkSlayerGiveCfg, {
	%% MapAi
	%% 23、个人BOSS
	%% 101、世界BOSS
	%% 110、死亡地狱BOSS
	%% 121、死亡森林BOSS
	%% 112、诅咒禁地BOSS
	%% 132、恶魔宝藏BOSS
	%% 113、黄金秘境本服
	%% 114、黄金秘境
	iD,
	%% 对应扣除屏障积分
	score
}).

-endif.
