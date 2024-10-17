%%%-------------------------------------------------------------------
%%% @author cbfan
%%% @copyright (C) 2018, <COMPANY>
%%% @doc
%%%		XO房间头文件(斯芬克斯房间)
%%% @end
%%% Created : 14. 十二月 2018 14:56
%%%-------------------------------------------------------------------
-author("cbfan").
-ifndef(xo_room_hrl).
-define(xo_room_hrl, true).

-include("logger.hrl").
-include("record.hrl").
-include("error.hrl").

-record(xo_player_info, {
	id = 0,
	pid = 0,
	map_pid = 0,
	name = 0,
	guild_name = 0,
	server_id = 0,
	server_name = "",
	sex = 0,
	answer = 0,  %% 0-没有作答  1-选对 2-选择错
	right_num = 0, %% 答对的数量
	point = 0,
	exp = 0,
	is_exit = ?FALSE,   %% 是否退出地图
	is_viewer = ?FALSE,   %% 是否是观众
	bet_info = [],    %% 竞猜信息
	nationality_id = 0 %% 国籍
}).

-define(XoStateNotOpen, 0).
-define(XoStatePrepare, 1). %% 准备阶段
-define(XoStateAnswer, 2). %% 答题阶段
-define(XoStateWaitAnswerPublic, 3). %% 等待公布答案
-define(XoStateWaitAnswer, 4). %% 等待答题
-define(XoStateAnswerFinish, 5). %% 所有的题都答完了

-record(xo_state, {
	state = 0,
	question = {0, 0, 0},  %% {Index， key1， key2}
	next_time = 0,  %% 下一个阶段开始的时间
	end_time = 0    %% 下一个阶段开始的时间
}).

-endif.