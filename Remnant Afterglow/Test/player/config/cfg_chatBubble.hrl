-ifndef(cfg_chatBubble_hrl).
-define(cfg_chatBubble_hrl, true).

-record(chatBubbleCfg, {
	%% 聊天气泡ID
	iD,
	%% 开启条件
	%% 1=等级
	%% 2=VIP等级
	%% 3=道具激活
	open,
	%% 属性
	atr
}).

-endif.
