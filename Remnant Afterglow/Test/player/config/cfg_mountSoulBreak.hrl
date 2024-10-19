-ifndef(cfg_mountSoulBreak_hrl).
-define(cfg_mountSoulBreak_hrl, true).

-record(mountSoulBreakCfg, {
	%% 兽灵等级
	iD,
	%% 突破后宠物等级上限
	maxLv,
	%% 需要材料
	needItem,
	%% 附加属性
	%% 累加值
	attribute
}).

-endif.
