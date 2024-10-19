-ifndef(cfg_bountyaskTeam_hrl).
-define(cfg_bountyaskTeam_hrl, true).

-record(bountyaskTeamCfg, {
	%% ID
	iD,
	%% 分段积分
	segment,
	%% 派遣外显、角色品质提供积分
	%% 0：A   1：S  2：SS  3：SSS  4：主角
	segmentPoint
}).

-endif.
