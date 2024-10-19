-ifndef(cfg_rcneType_hrl).
-define(cfg_rcneType_hrl, true).

-record(rcneTypeCfg, {
	%% 符文ID
	%% 和item表一一对应
	iD,
	%% 符文评分
	rcneScore,
	%% 是否可用于合成,1是0否
	canSynthesis,
	%% 是否可用于晋升,1是0否
	canUpgrade,
	%% 是否可升星,1是0否
	canUpStar,
	%% 对应符文种类
	runeType,
	%% 符文分解获得
	%% （类型，id，数量）
	%% 类型1：道具
	%% 类型2：货币
	%% 这里填0表示为多/三属性符文，需要先拆解成单属性符文才能合多
	resolveItem,
	%% 符文拆解获得
	%% （类型，id，数量）
	%% 1类型为道具
	%% 2类型为货币
	openItem
}).

-endif.
