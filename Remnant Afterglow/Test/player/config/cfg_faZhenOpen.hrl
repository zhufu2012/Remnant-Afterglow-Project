-ifndef(cfg_faZhenOpen_hrl).
-define(cfg_faZhenOpen_hrl, true).

-record(faZhenOpenCfg, {
	%% 部位ID
	%% （1武器，2项链，3护手，4戒指，5胸甲，6头盔，7护肩，9护腿，10护符,14副手）
	iD,
	%% 开启转生
	openreincarnate,
	%% 开启需要符文评分
	%% 与开启转生共同判断
	faZhenOpen
}).

-endif.
