-ifndef(cfg_faZhenType_hrl).
-define(cfg_faZhenType_hrl, true).

-record(faZhenTypeCfg, {
	%% 法阵ID
	iD,
	%% 镶嵌的符文类型|镶嵌的符文类型
	%% (位置，类型）
	runeType,
	%% 法阵品质
	quality,
	%% 法阵评分
	rcneScore,
	%% 对应部位
	%% （1武器，2项链，3护手，4戒指，5胸甲，6头盔，7护肩，9护腿，10护符,14副手）
	position,
	%% 法阵分解获得
	%% 法阵升星=0时才可以分解
	%% （类型，id，数量）
	%% 1道具 2货币
	resolveItem
}).

-endif.
