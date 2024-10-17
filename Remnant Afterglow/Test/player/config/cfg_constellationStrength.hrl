-ifndef(cfg_constellationStrength_hrl).
-define(cfg_constellationStrength_hrl, true).

-record(constellationStrengthCfg, {
	%% 强化方案
	strengthPlan,
	%% 部位类型
	%% 1为攻击部位1-5
	%% 2为防御部位6-10
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
	needExp,
	%% 评价
	evaluate
}).

-endif.
