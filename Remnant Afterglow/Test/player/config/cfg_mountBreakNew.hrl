-ifndef(cfg_mountBreakNew_hrl).
-define(cfg_mountBreakNew_hrl, true).

-record(mountBreakNewCfg, {
	%% 突破ID
	iD,
	%% 突破后宠物等级上限
	maxLv,
	%% 需要材料
	needItem,
	%% 附加属性
	attribute,
	%% 当前突破需要的兽灵等级
	needLv
}).

-endif.
