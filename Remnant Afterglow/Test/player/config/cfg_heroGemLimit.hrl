-ifndef(cfg_heroGemLimit_hrl).
-define(cfg_heroGemLimit_hrl, true).

-record(heroGemLimitCfg, {
	%% 英雄装备部位
	%% 部件1短刃，2铭牌，3头甲，4战盔
	type,
	%% 孔位序号
	num,
	%% Key
	index,
	%% 解锁需要英雄装备品质
	petEquipQuality,
	%% 无穿戴默认获取途径ID
	needGemID,
	%% 可镶嵌的魂石类型
	gemType
}).

-endif.
