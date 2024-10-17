-ifndef(cfg_lMatch1v1Quiz_hrl).
-define(cfg_lMatch1v1Quiz_hrl, true).

-record(lMatch1v1QuizCfg, {
	%% 竞猜类型
	%% 1，32进16竞猜
	%% 2，16进8竞猜
	%% 3，8进4竞猜
	%% 4，4进2竞猜
	%% 5，季军赛竞猜
	%% 6，冠军赛竞猜
	iD,
	%% 次数
	num,
	%% 竞猜奖励
	%% （物品类型,物品id，数量，是否绑定）
	%% 类型：1=道具，2=货币
	reward
}).

-endif.
