-ifndef(cfg_runeType_hrl).
-define(cfg_runeType_hrl, true).

-record(runeTypeCfg, {
	%% 符文ID
	%% 和item表一一对应
	iD,
	%% 是否可用于合成,1是0否
	canSynthesis,
	%% 是否可用于晋升,1是0否
	canUpgrade,
	%% 是否可升星,1是0否
	canUpStar,
	%% 对应符文种类
	runeType,
	%% 是否是核心符文
	%% 1是0否
	ifCore,
	%% 符文分解获得
	%% （类型，id，数量）
	%% 这里填0表示为多/三属性符文，需要先拆解成丹属性符文才能合多
	resolveItem,
	%% 符文拆解消耗
	openItem
}).

-endif.
