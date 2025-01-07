-ifndef(cfg_shengwenSuitStr_hrl).
-define(cfg_shengwenSuitStr_hrl, true).

-record(shengwenSuitStrCfg, {
	%% 部位ID
	iD,
	%% 强化等级
	lv,
	%% 索引
	index,
	%% 共鸣最大等级
	%% 实际共鸣等级上限受当前圣纹阶控制，例：5阶圣纹的共鸣等级上限为5
	maxLv,
	%% 共鸣基础属性
	%% （属性id，值）
	strBaseAttri,
	%% 共鸣套装加成
	%% （属性id，值）
	strSuitAttri,
	%% 升级到下1级所需
	%% （类型，ID，值）
	%% 类型：1道具，2货币
	needExp
}).

-endif.
