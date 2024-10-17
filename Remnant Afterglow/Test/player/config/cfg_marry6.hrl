-ifndef(cfg_marry6_hrl).
-define(cfg_marry6_hrl, true).

-record(marry6Cfg, {
	iD,
	%% 每次发送弹幕消耗
	%% {货币ID，数值}
	price,
	%% 结婚两个人发送弹幕的价格
	%% 0：免费发送
	ownersPrice
}).

-endif.
