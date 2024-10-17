-ifndef(cfg_mountPoint_hrl).
-define(cfg_mountPoint_hrl, true).

-record(mountPointCfg, {
	%% 坐骑品质0 N白
	%% 1 R蓝
	%% 2 SR紫
	%% 3 SSR橙
	%% 4 SP 红
	%% 5 UR 粉
	iD,
	%% 对应解锁评分
	point
}).

-endif.
