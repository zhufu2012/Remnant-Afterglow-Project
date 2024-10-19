-ifndef(cfg_shengYiWingsAward_hrl).
-define(cfg_shengYiWingsAward_hrl, true).

-record(shengYiWingsAwardCfg, {
	%% 奖励序号
	iD,
	%% 奖励类型
	%% 1固定属性奖励
	%% 2选择属性奖励
	type,
	%% 属性奖励
	%% (属性ID，属性值)
	attrAdd,
	%% 选择奖励
	%% (组，属性ID，属性值)
	attrChoice,
	%% 奖励类型ICON
	icon
}).

-endif.
