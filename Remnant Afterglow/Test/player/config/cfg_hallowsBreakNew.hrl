-ifndef(cfg_hallowsBreakNew_hrl).
-define(cfg_hallowsBreakNew_hrl, true).

-record(hallowsBreakNewCfg, {
	%% 突破ID
	iD,
	%% 圣物类型1火2水3雷4土
	element,
	%% 客户端索引
	index,
	%% 突破后圣物等级上限
	maxLv,
	%% 需要材料（突破到本级需要的材料）
	needItem,
	%% 附加属性
	attribute,
	%% 当前突破需要的对应圣灵等级
	%% 如：火系圣物突破对应火系圣灵等级
	needLv
}).

-endif.
