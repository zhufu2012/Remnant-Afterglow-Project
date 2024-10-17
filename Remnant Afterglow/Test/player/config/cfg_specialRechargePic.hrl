-ifndef(cfg_specialRechargePic_hrl).
-define(cfg_specialRechargePic_hrl, true).

-record(specialRechargePicCfg, {
	%% 玩家等级段
	%% 向前取
	%% ·需要支持热更，修改等级段和图片后能立即判断生效
	%% ·举例：
	%% 1、A
	%% 201、B
	%% 1≤等级＜201级，取A图片
	%% 201≤等级，取B图片
	iD,
	%% 特惠储值调佣的图片资源
	pic
}).

-endif.
