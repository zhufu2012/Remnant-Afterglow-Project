-ifndef(cfg_guildMakeWishLImit_hrl).
-define(cfg_guildMakeWishLImit_hrl, true).

-record(guildMakeWishLImitCfg, {
	%% 道具品质
	%% 对应Item表Character字段
	iD,
	%% 对应品质捐献一次必须捐/收多少个
	times
}).

-endif.
