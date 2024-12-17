-ifndef(cfg_equipShouChang5_hrl).
-define(cfg_equipShouChang5_hrl, true).

-record(equipShouChang5Cfg, {
	%% 属性库ID
	iD,
	%% （属性id，值，属性品质色）
	%% 属性品质色：0白 1蓝 2紫 3橙 4红 5龙 6神  7、龙神
	regenerateAttr,
	%% 属性标识
	%% 1.低级
	%% 2.高级
	%% 3.极品
	type
}).

-endif.
