-ifndef(cfg_rouletteRuneChange_hrl).
-define(cfg_rouletteRuneChange_hrl, true).

-record(rouletteRuneChangeCfg, {
	iD,
	%% 转换后的龙印ID
	%% 针对老服外网玩家，如果外网玩家龙神塔层数已达到要求，但是对于的等级未达到，那么寻宝库不降低。但是如果寻到ID对应的龙印，则转换成该字段配置的龙印发给玩家。
	%% 新服没影响
	%% ID1|ID2|ID3...
	%% 1260103|1260107|1260115 表示：在这三个道具中平均随机替换一个.
	itemId
}).

-endif.
