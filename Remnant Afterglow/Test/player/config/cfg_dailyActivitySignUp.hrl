-ifndef(cfg_dailyActivitySignUp_hrl).
-define(cfg_dailyActivitySignUp_hrl, true).

-record(dailyActivitySignUpCfg, {
	%% 功能ID
	iD,
	%% 报名活动类型
	%% 1、一天一场的活动
	%% 2、一天多场且可参加多场的活动
	%% 3、一天多场且只能参加一场的活动
	%% 类型1和2：报名和低保奖励，每场各管各的，每场都可能会拿到报名奖励和低保奖励。
	%% 类型3：报名后，当天最多只会拿到一次报名奖励和低保奖励，报名和低保要考虑当天整体的情况。
	%% ·如第1场之前报名，第1场未参与，第2场参与，则第2场结束后拿到报名奖励和活动奖励。
	%% ·如第1场之前报名，第1场未参与，第2场参与，…最后一场也未参与，则最后一场结束后拿报名奖励和低保奖励。
	signUpType,
	%% 报名时间
	%% 填秒，换算成具体时间点
	%% (对应场次，活动开启当天的开始时间点，结束时间点）|(对应场次，活动开启当天的开始时间点，结束时间点）
	%% 对应场次与FunctionFore_1_每日功能预览（周历）表的Oder字段相匹配
	%% 填0时，表示不能报名
	signUpTime,
	%% 报名奖励等级分段
	%% (个人等级、报名奖励序号）
	%% (1,1)|(100,2)表示：玩家等级为1-99级取序号为1的奖励，等级>=100级取序号为2的奖励.
	%% (1,1)表示：等级>=1级取序号为1的奖励.
	signUpGrade,
	%% 报名奖励
	%% （报名奖励序号，类型，ID，数量，是否绑定，装备品质，装备星级）
	%% 类型：1道具、ID=道具ID
	%% 类型：2货币、ID=货币ID
	%% 类型：3装备、ID=装备ID
	%% 是否绑定：1绑定，0非绑
	%% 装备品质，装备星级：类型3时填写，其他填0.
	signUpAward1,
	%% 低保奖励
	%% 报名未参加活动的奖励
	%% （报名奖励序号，类型，ID，数量，是否绑定，装备品质，装备星级）
	%% 类型：1道具、ID=道具ID
	%% 类型：2货币、ID=货币ID
	%% 类型：3装备、ID=装备ID
	%% 是否绑定：1绑定，0非绑
	%% 装备品质，装备星级：类型3时填写，其他填0.
	signUpAward2,
	%% 报名奖励邮
	%% 件标题，文字表ID
	signUpMailTitle1,
	%% 报名奖励邮
	%% 件描述文字，文字表ID
	signUpMailDes1,
	%% 报名低保奖励
	%% 邮件标题，文字表ID
	signUpMailTitle2,
	%% 报名低保奖励
	%% 邮件描述文字，文字表ID
	signUpMailDes2
}).

-endif.