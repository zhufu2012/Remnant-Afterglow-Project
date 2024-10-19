-ifndef(cfg_weaponExpItemNew_hrl).
-define(cfg_weaponExpItemNew_hrl, true).

-record(weaponExpItemNewCfg, {
	%% 道具ID和Item表一一对应
	iD,
	%% 每个道具提供的经验值
	exp
}).

-endif.
