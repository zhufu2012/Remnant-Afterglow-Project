-ifndef(cfg_itemShortcutShop_hrl).
-define(cfg_itemShortcutShop_hrl, true).

-record(itemShortcutShopCfg, {
	%% 可快捷购买的道具ID
	iD,
	%% 快捷购买商店ID
	shopId
}).

-endif.
