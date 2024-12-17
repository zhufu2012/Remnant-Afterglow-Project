-ifndef(cfg_shengwenStrength_hrl).
-define(cfg_shengwenStrength_hrl, true).

-record(shengwenStrengthCfg, {
	%% 部位ID
	iD,
	%% 强化等级
	lv,
	%% 索引
	index,
	%% 强化最大等级
	%% 实际共鸣等级上限受当前圣纹阶控制-配置“ShengwenStrLimit_1_强化限制”
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
