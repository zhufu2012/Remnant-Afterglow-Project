-ifndef(cfg_xoRoomQ_hrl).
-define(cfg_xoRoomQ_hrl, true).

-record(xoRoomQCfg, {
	%% 题目
	iD,
	%% 题库取题
	%% (题目分组，取组权重)
	getQuestion
}).

-endif.
