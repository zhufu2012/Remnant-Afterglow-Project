-ifndef(cfg_guildchariot_hrl).
-define(cfg_guildchariot_hrl, true).

-record(guildchariotCfg, {
	%% 战车ID
	iD,
	%% 变身：
	%% 使用战车时的变身buffID
	transformModel,
	%% 基础建造时间（秒）
	time,
	%% 建造资金
	%% 数量，公会资金
	needs,
	%% 解锁对应战车科技(ID,等级）
	science
}).

-endif.
