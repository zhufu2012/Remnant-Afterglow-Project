-ifndef(cfg_expeditionLevy_hrl).
-define(cfg_expeditionLevy_hrl, true).

-record(expeditionLevyCfg, {
	%% 赛季
	season,
	%% 猎魔等级
	level,
	%% 索引
	index,
	%% 奖励掉落
	%% （职业，DropItem的id，掉落是否绑定，掉落数量，掉落几率）
	dropAward
}).

-endif.
