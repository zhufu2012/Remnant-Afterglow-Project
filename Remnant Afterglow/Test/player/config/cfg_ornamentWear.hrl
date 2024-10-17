-ifndef(cfg_ornamentWear_hrl).
-define(cfg_ornamentWear_hrl, true).

-record(ornamentWearCfg, {
	%% 阶
	iD,
	%% 可穿戴改阶配饰的条件：
	%% （组，条件类型，参数）
	%% 组：同组条件必须同时满足，不同组条件只要满足其中1组就可。
	%% 条件类型：1玩家等级，参数为：等级
	%% 条件类型：2通关副本（不限三星），参数为：副本ID
	%% 如果没有穿戴限制则填“0”
	ornamentDungeon
}).

-endif.
