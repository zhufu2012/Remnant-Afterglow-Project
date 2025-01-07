-ifndef(cfg_changeList_hrl).
-define(cfg_changeList_hrl, true).

-record(changeListCfg, {
	%% ID
	iD,
	%% 对应战士ID
	change1,
	%% 对应法师ID
	change2,
	%% 对应弓手ID
	change3,
	%% 对应圣职ID
	change4
}).

-endif.
