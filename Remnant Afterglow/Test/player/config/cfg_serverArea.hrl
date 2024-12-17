-ifndef(cfg_serverArea_hrl).
-define(cfg_serverArea_hrl, true).

-record(serverAreaCfg, {
	%% 地区代码
	index,
	%% 推荐大区
	%% 1：先行服
	%% 2：东南亚
	%% 3：美洲
	%% 4：欧洲
	%% 5：新马奥专服
	areaID
}).

-endif.
