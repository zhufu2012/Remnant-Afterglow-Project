-ifndef(cfg_worldLvDiff2_hrl).
-define(cfg_worldLvDiff2_hrl, true).

-record(worldLvDiff2Cfg, {
	%% 联服世界等级
	%% 等级差
	%% 玩家等级与世界等级的等级差
	%% 若等级差大于配置的最大等级差
	%% 取配置的最大等级差加成buff
	iD,
	%% 加成buff
	%% (玩家等级,加成buff)
	%% 玩家等级向前取等级，即(0,1)|(100,2)，此时玩家等级为92级，向前取0级加成ID为1的buff
	%% 这里略有不同的是，配置0表示无论玩家多少级，在对应的联服世界等级差里都没有经验加成
	addBuff
}).

-endif.
