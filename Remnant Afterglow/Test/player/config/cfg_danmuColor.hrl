-ifndef(cfg_danmuColor_hrl).
-define(cfg_danmuColor_hrl, true).

-record(danmuColorCfg, {
	iD,
	name,
	%% 类型
	%% 1=结婚礼物，结婚弹幕时调用
	colorValue,
	%% 每次发送弹幕消耗
	%% {货币ID，数值}
	price,
	%% 结婚两个人发送弹幕的价格
	%% 0：免费发送
	ownersPrice,
	%% 每个颜色的弹幕速度
	%% 参考值：100
	speed
}).

-endif.
