-ifndef(cfg_elementTrialTotems_hrl).
-define(cfg_elementTrialTotems_hrl, true).

-record(elementTrialTotemsCfg, {
	%% 图腾品质ID
	iD,
	%% 图腾怪物掉落加成
	%% 填写万分点
	dropBonus,
	%% 图腾采集物ID
	%% Collection_1_采集物
	collection,
	%% 图腾占领后展示机关ID
	%% Dungeon_machine
	showID
}).

-endif.
