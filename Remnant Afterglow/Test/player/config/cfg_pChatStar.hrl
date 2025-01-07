-ifndef(cfg_pChatStar_hrl).
-define(cfg_pChatStar_hrl, true).

-record(pChatStarCfg, {
	%% 头像ID
	iD,
	%% 星级
	star,
	%% 索引
	index,
	%% 最大星级
	starMax,
	%% 升星属性
	%% (附加属性ID，附加值)
	attribute
}).

-endif.
