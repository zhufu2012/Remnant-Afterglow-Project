-ifndef(cfg_constellationStoneBase_hrl).
-define(cfg_constellationStoneBase_hrl, true).

-record(constellationStoneBaseCfg, {
	%% 咒印ID
	iD,
	%% 基础属性
	attr1,
	%% 极品属性
	attr2,
	%% 卓越属性
	attr3,
	%% 对应的下一级咒印ID
	%% 填0表示没下一级
	gemID,
	%% 对应换算的一级咒印数量（道具ID，数量）
	gemNumber,
	%% 边境远征-星石基础属性
	%% (属性ID，属性值)
	%% 边境远征玩法中，星石属性需统一
	expeditionAttr1
}).

-endif.
