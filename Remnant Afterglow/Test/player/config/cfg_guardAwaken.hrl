-ifndef(cfg_guardAwaken_hrl).
-define(cfg_guardAwaken_hrl, true).

-record(guardAwakenCfg, {
	%% 类型
	%% 1.经验守护
	%% 2.防御守护
	%% 3.3阶守护
	%% 4.4阶守护
	%% ……
	type,
	%% 觉醒等级
	awLevel,
	%% 索引
	index,
	%% 最大觉醒等级
	maxAwankenLv,
	%% 觉醒消耗
	%% (消耗类型，ID，数量)
	%% 消耗类型1：道具-道具id及数量
	%% 消耗类型2：货币-货币枚举及数量
	%% 填0表示不可觉醒
	awakenConsume,
	%% 基础值
	%% 觉醒属性
	%% (属性id，数值)
	attriAwaken,
	%% 高级属性
	%% 觉醒属性
	%% (属性id，数值)
	highAttriAwaken
}).

-endif.
