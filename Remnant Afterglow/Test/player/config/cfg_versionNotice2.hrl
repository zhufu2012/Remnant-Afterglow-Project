-ifndef(cfg_versionNotice2_hrl).
-define(cfg_versionNotice2_hrl, true).

-record(versionNotice2Cfg, {
	iD,
	%% 个人等级
	%% （等级下限，等级上限）取等
	lv,
	%% 个人版本预告奖励，根基玩家等级变化，每日5点时判断等级情况刷新奖励.
	%% （职业，类型，ID，数量，品质，星级，是否绑定）
	%% 职业:0=所有职业，1004=战士，1005=法师，1006=弓手，1007=圣职
	%% 类型1=道具，ID=道具ID；
	%% 类型2=货币，ID=货币ID
	%% 类型3=装备，ID=装备ID
	%% 品质、星级：对应装备的品质和星级，其他类型无效
	%% 是否绑定：0.非绑  1.绑定
	awardItem
}).

-endif.
