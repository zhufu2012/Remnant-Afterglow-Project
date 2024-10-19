-ifndef(cfg_guildHelpAward_hrl).
-define(cfg_guildHelpAward_hrl, true).

-record(guildHelpAwardCfg, {
	%% 奖励类型
	%% 1求助者
	%% 2协助者
	type,
	%% 玩家等级
	%% 取小于等级玩家等级的最大配置值
	plevel,
	%% 索引
	index,
	%% 每日奖励次数
	num,
	%% 奖励
	%% (奖励类型，ID，数量)
	%% 类型1：道具-道具id，数量
	%% 类型2：货币-货币枚举，数量
	award
}).

-endif.
