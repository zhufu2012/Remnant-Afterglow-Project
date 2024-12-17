-ifndef(cfg_loveLv_hrl).
-define(cfg_loveLv_hrl, true).

-record(loveLvCfg, {
	%% 作者:
	%% 亲密度等级
	%% 最后一列为最大等级
	iD,
	%% 作者:
	%% 所需亲密度
	%% 升级不被扣除
	exp,
	%% 不同亲密度等级的好友组队增加的buff，
	%% 多人组队时取亲密度等级最高的buff
	buffID,
	%% 亲密度名称
	loveLvText
}).

-endif.
