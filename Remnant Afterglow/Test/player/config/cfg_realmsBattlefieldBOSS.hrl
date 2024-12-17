-ifndef(cfg_realmsBattlefieldBOSS_hrl).
-define(cfg_realmsBattlefieldBOSS_hrl, true).

-record(realmsBattlefieldBOSSCfg, {
	%% 地图ID
	%% 条件2竞争
	%% 条件1竞争
	%% 无条件竞争
	%% 和平
	%% ID为1时，代表任务
	mapID,
	%% 世界等级
	orderReward,
	%% 奖励序号2
	%% 符文评分
	rcneReward,
	%% 索引
	index,
	%% 怪物个人掉落包
	%% （怪物类型，职业，掉落ID，掉落是否绑定,掉落数量，掉落概率）
	monsterDropNew
}).

-endif.
