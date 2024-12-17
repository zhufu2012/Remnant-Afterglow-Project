-ifndef(cfg_xoRoomA_hrl).
-define(cfg_xoRoomA_hrl, true).

-record(xoRoomACfg, {
	%% 题目分组
	%% 1.D2玩法类
	%% 2.D2养成类
	%% 3.D2世界观类
	%% 4.百科类
	%% 5.娱乐类
	%% 6.科技类
	%% 7.八卦类
	%% 8.二次元
	type,
	%% 组内号
	%% 同一个组，7天内不可有通用的ID，若抽取到同样的就重新抽取 
	typeId,
	%% 索引
	index,
	%% 题目文字表索引
	question,
	%% 题目答案
	%% (1代表正确，2代表错误)
	answer
}).

-endif.
