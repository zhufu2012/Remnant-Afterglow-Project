-ifndef(cfg_divinityStrength_hrl).
-define(cfg_divinityStrength_hrl, true).

-record(divinityStrengthCfg, {
	%% 部位ID
	%% 1头盔2战甲
	%% 3护手4护腿
	%% 5战靴6武器
	%% 7护肩8项链
	%% 9戒指10护符
	iD,
	%% 强化等级
	lv,
	%% 索引
	index,
	%% 能强化的最大等级
	maxLv,
	%% 强化获得的属性
	%% （对应强化等级）
	strengthAttribute,
	%% 升级到下1级所需
	%% （类型，ID，值）
	%% 类型：1道具，2货币
	needExp
}).

-endif.
