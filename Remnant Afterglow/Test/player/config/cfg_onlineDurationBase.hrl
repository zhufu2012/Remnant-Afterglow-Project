-ifndef(cfg_onlineDurationBase_hrl).
-define(cfg_onlineDurationBase_hrl, true).

-record(onlineDurationBaseCfg, {
	%% ID记录用
	iD,
	%% 个人等级区间
	%% （等级下限，等级上限）取等
	lv,
	%% 次数对应时长
	%% (抽取次数，累计每日在线时长分钟)
	ordertime,
	%% (位置序号，库ID)
	%% 1、序号,
	%% 2、库ID：【OnlineDurationRandomItem_1_库】表的ID
	randomItemId
}).

-endif.
