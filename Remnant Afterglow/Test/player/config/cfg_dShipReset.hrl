-ifndef(cfg_dShipReset_hrl).
-define(cfg_dShipReset_hrl, true).

-record(dShipResetCfg, {
	%% 商船品质
	%% 0为普通白
	%% 1为优秀蓝
	%% 2为史诗紫
	%% 3为传说橙
	%% 4为神话红
	%% 5为粉色
	%% 6为神装
	iD,
	%% (权值，提升到品质)
	%% 例如
	%% (500,1)|(9500,3)
	%% 即有5%的概率为1级
	%% 95%概率为3级
	promotionWeight,
	%% 刷新消耗
	%% (消耗类型，ID，数量)
	%% 消耗类型：1.道具；
	%% 2.货币。
	usePromotion,
	%% 每次通过PromotionWeight字段随机到自己等级的时候，护送值增加值
	add,
	%% 当Add字段增加的总值等于护送值上限，则自动升为下一级;并且重新从0开始记Add值
	addLimit,
	%% 一键刷新消耗
	%% (消耗类型，ID，数量)
	%% 消耗类型：1.道具；
	%% 2.货币。
	%% 这里的一键刷新指从当前品质直接升级成最大品质的消耗。
	addMat
}).

-endif.
