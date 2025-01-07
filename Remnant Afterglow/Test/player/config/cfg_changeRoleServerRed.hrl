-ifndef(cfg_changeRoleServerRed_hrl).
-define(cfg_changeRoleServerRed_hrl, true).

-record(changeRoleServerRedCfg, {
	%% 任务ID
	iD,
	%% 红点类型
	%% 1.前往法老宝库
	%% 2.击杀世界BOSS
	%% 3.前往商船
	%% 4.前往英雄塔（OB4）
	type
}).

-endif.
