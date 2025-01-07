-ifndef(cfg_gemExpItem_hrl).
-define(cfg_gemExpItem_hrl, true).

-record(gemExpItemCfg, {
	%% 道具ID和Item表一一对应
	iD,
	%% 每个道具提供的经验值
	exp,
	%% 水晶类型
	%% 1.攻击红水晶
	%% 2.防御蓝水晶
	type
}).

-endif.
