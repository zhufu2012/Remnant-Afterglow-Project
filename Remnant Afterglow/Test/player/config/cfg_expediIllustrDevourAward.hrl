-ifndef(cfg_expediIllustrDevourAward_hrl).
-define(cfg_expediIllustrDevourAward_hrl, true).

-record(expediIllustrDevourAwardCfg, {
	%% 奖励id
	iD,
	%% 最大奖励等级
	lvMax,
	%% 激活所需吞噬总等级
	needLv,
	%% 激活奖励
	%% (属性ID，属性值)
	%% 总效果累加
	attrAdd
}).

-endif.
