-ifndef(cfg_chatEmoji_hrl).
-define(cfg_chatEmoji_hrl, true).

-record(chatEmojiCfg, {
	%% 表情ID
	%% (和表情资源ID一一对应)
	iD,
	%% 分组
	group
}).

-endif.
