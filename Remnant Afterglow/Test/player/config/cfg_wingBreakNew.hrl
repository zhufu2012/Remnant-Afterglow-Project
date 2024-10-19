-ifndef(cfg_wingBreakNew_hrl).
-define(cfg_wingBreakNew_hrl, true).

-record(wingBreakNewCfg, {
	%% 突破ID
	iD,
	%% 突破后翅膀等级上限
	maxLv,
	%% 需要材料
	needItem,
	%% 附加属性
	attribute,
	%% 当前突破需要的翼灵等级
	needLv
}).

-endif.
