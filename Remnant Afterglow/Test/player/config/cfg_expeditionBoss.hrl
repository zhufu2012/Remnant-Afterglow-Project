-ifndef(cfg_expeditionBoss_hrl).
-define(cfg_expeditionBoss_hrl, true).

-record(expeditionBossCfg, {
	%% 赛季
	season,
	%% 猎魔等级
	level,
	%% 索引
	index,
	%% 地图ID
	mapID,
	%% 进入需要星魂评分
	%% 改为：进入需要的评价（装备基础评价+强化评价+觉醒评价+祝福评价）
	scoreNeed,
	%% 体力消耗
	spiritNeed,
	%% boss掉落
	%% （职业，DropItem的id，掉落是否绑定，掉落数量，掉落几率）
	drop
}).

-endif.
