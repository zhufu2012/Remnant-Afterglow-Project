-ifndef(cfg_sceneRoot_hrl).
-define(cfg_sceneRoot_hrl, true).

-record(sceneRootCfg, {
	%% 队伍复活ID.调用复活表Revive_1的ID，同时存在3种复活方式.填0不复活
	reviveID,
	%% 角色复活ID.调用复活表Revive_2的ID，同时存在3种复活方式.填0不复活
	reviveAct
}).

-endif.