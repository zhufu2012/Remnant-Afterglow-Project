-ifndef(cfg_guildscience_hrl).
-define(cfg_guildscience_hrl, true).

-record(guildscienceCfg, {
	%% 技能ID
	iD,
	%% 技能等级
	level,
	%% 技能等级上限
	maxLv,
	%% 升到下一级消耗
	%% {货币，数量}
	needs,
	%% 作者:
	%% 属性
	attribute,
	%% 解锁等级
	%% 玩家到达该等级时再解锁对应的技能
	lockLv
}).

-endif.
