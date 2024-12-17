-ifndef(cfg_guild_level).
-define(cfg_guild_level, 1).

-record(guild_levelCfg, {
	%% 微软用户:
	%% 仙盟等级，从1开始，最高10级
	level,

	%% 微软用户:
	%% 该等级下最大成员数量
	maxmember,

	%% 微软用户:
	%% 等级经验
	exp,

	%% 微软用户:
	%% 副盟主个数
	vicechairmancount,

	%% 微软用户:
	%% 长老个数
	eldercount
}).

-endif.
