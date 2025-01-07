-ifndef(cfg_chatEmojiGroup_hrl).
-define(cfg_chatEmojiGroup_hrl, true).

-record(chatEmojiGroupCfg, {
	%% 表情包ID
	%% ID=1是默认已激活表情
	iD,
	%% 激活道具ID
	open,
	%% 属性
	atr
}).

-endif.
