-ifndef(cfg_borderRankAward_hrl).
-define(cfg_borderRankAward_hrl, true).

-record(borderRankAwardCfg, {
	%% 世界等级
	%% 取小于等于玩家服务器的最大值
	worldLevel,
	%% 赛季
	season,
	%% 等级
	lv,
	%% 索引
	index,
	%% 征服点
	%% 累计点数
	rank,
	%% 最大等级
	lvMax,
	%% 普通奖励：
	%% （职业，类型，类型ID，掉落是否绑定,掉落数量）
	%% 职业：0=所有职业的人均可获得该掉落，1004=战士，1005=法师，1006=弓手.（如果是职业一的人，不会掉落职业二的奖励，但是可以获得不分职业的奖励）
	%% 类型1：道具，类型ID为道具ID
	%% 类型2：货币，类型ID为货币ID
	%% 掉落是否绑定：0为非绑 1为绑定（货币没有绑定或非绑的说法）
	%% 掉落数量：奖励道具的数量
	commonAward,
	%% 高级奖励：
	%% （职业，类型，类型ID，掉落是否绑定,掉落数量）
	%% 职业：0=所有职业的人均可获得该掉落，1004=战士，1005=法师，1006=弓手.（如果是职业一的人，不会掉落职业二的奖励，但是可以获得不分职业的奖励）
	%% 类型1：道具，类型ID为道具ID
	%% 类型2：货币，类型ID为货币ID
	%% 掉落是否绑定：0为非绑 1为绑定（货币没有绑定或非绑的说法）
	%% 掉落数量：奖励道具的数量
	highAward
}).

-endif.