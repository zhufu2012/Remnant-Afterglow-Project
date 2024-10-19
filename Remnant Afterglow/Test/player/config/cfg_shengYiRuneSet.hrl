-ifndef(cfg_shengYiRuneSet_hrl).
-define(cfg_shengYiRuneSet_hrl, true).

-record(shengYiRuneSetCfg, {
	%% 圣翼等级
	%% 同【ShengYiBaseUnlock_1_圣翼解锁】SyLevel
	syLevel,
	%% 符文槽位
	runeSet,
	%% 索引
	index,
	%% 槽位可镶嵌符文的最高品质
	qualityMax
}).

-endif.
