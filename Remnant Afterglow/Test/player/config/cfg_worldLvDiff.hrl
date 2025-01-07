-ifndef(cfg_worldLvDiff_hrl).
-define(cfg_worldLvDiff_hrl, true).

-record(worldLvDiffCfg, {
	%% 等级差
	%% 玩家等级与世界等级的等级差
	%% 若等级差大于配置的最大等级差
	%% 取配置的最大等级差加成buff
	iD,
	%% 加成buff
	%% (玩家等级,加成buff)
	%% 玩家等级向前取等级，即(0,1)|(100,2)，此时玩家等级为92级，向前取0级加成ID为1的buff
	addBuff
}).

-endif.
