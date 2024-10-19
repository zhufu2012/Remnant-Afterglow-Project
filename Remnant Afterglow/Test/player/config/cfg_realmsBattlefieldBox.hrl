-ifndef(cfg_realmsBattlefieldBox_hrl).
-define(cfg_realmsBattlefieldBox_hrl, true).

-record(realmsBattlefieldBoxCfg, {
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
	%% 宝箱公会掉落包
	%% （宝箱类型，职业，掉落ID，掉落是否绑定,掉落数量，掉落概率）
	%% 宝箱类型：0所有宝箱，1小宝箱，2中宝箱，3大宝箱，4至尊宝箱
	boxGuildDropNew
}).

-endif.
