-ifndef(cfg_shopCharacterDyn_hrl).
-define(cfg_shopCharacterDyn_hrl, true).

-record(shopCharacterDynCfg, {
	%% 角色限购编号
	iD,
	%% 单角色限购次数
	character1,
	%% 双角色限购次数
	character2,
	%% 三角色限购次数
	character3
}).

-endif.
