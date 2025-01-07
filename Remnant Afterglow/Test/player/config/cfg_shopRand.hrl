-ifndef(cfg_shopRand_hrl).
-define(cfg_shopRand_hrl, true).

-record(shopRandCfg, {
	%% 作者:
	%% 随机商店编号，最大99
	iD,
	%% 作者:
	%% 位置序列，最大99
	seat,
	index,
	%% 作者:
	%% 随机组ID
	%% ShopRandomNew
	setID
}).

-endif.
