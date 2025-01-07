-ifndef(cfg_hornBubble_hrl).
-define(cfg_hornBubble_hrl, true).

-record(hornBubbleCfg, {
	%% 喇叭气泡ID
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
