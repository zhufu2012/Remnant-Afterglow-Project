-ifndef(cfg_loveTokenBreak_hrl).
-define(cfg_loveTokenBreak_hrl, true).

-record(loveTokenBreakCfg, {
	%% 突破ID
	iD,
	%% 突破后信物等级上限
	maxLv,
	%% 需要材料
	needItem,
	%% 附加属性
	attribute
}).

-endif.
