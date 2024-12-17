-ifndef(cfg_hallowsExpItemNew_hrl).
-define(cfg_hallowsExpItemNew_hrl, true).

-record(hallowsExpItemNewCfg, {
	%% 道具ID和Item表一一对应
	iD,
	%% 圣物类型1火2水3雷4土
	element,
	%% 每个道具提供的经验值
	exp
}).

-endif.
