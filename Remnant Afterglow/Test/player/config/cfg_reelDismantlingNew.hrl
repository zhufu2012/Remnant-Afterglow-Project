-ifndef(cfg_reelDismantlingNew_hrl).
-define(cfg_reelDismantlingNew_hrl, true).

-record(reelDismantlingNewCfg, {
	%% 秘典碎片道具id
	iD,
	%% 单个道具分解必然可获得的货币{道具id，数量}
	certainItem,
	%% 可能获得的道具和几率{道具id，数量，概率万分比}
	maybeItem
}).

-endif.
