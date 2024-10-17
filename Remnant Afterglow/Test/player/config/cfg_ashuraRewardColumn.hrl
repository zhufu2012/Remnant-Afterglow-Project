-ifndef(cfg_ashuraRewardColumn_hrl).
-define(cfg_ashuraRewardColumn_hrl, true).

-record(ashuraRewardColumnCfg, {
	%% ID
	iD,
	%% 排名奖2(指定道具）,奖励列-列1
	%% 做成可以热更的类型字段
	%% （奖励序号，职业，类型，类型ID，掉落是否绑定,掉落数量）
	%% 奖励序号：AshuraBase表中OrderReward字段的奖励序号
	%% 职业：0=所有职业的人均可获得该掉落，1004=战士，1005=法师，1006=弓手.（如果是职业一的人，不会掉落职业二的奖励，但是可以获得不分职业的奖励）
	%% 类型1：道具，类型ID为道具ID
	%% 类型2：货币，类型ID为货币ID
	%% 掉落是否绑定：0为非绑 1为绑定（货币没有绑定或非绑的说法）
	%% 掉落数量：奖励道具的数量
	awardBoxTwo1,
	%% 排名奖2(指定道具）,奖励列-列2
	awardBoxTwo2,
	%% 排名奖2(指定道具）,奖励列-列3
	awardBoxTwo3,
	%% 排名奖2(指定道具）,奖励列-列4
	awardBoxTwo4,
	%% 排名奖2(指定道具）,奖励列-列5
	awardBoxTwo5,
	%% 排名奖2(指定道具）,奖励列-列6
	awardBoxTwo6,
	%% 排名奖2(指定道具）,奖励列-列7
	awardBoxTwo7,
	%% 排名奖2(指定道具）,奖励列-列8
	awardBoxTwo8,
	%% 排名奖2(指定道具）,奖励列-列9
	awardBoxTwo9,
	%% 排名奖2(指定道具）,奖励列-列10
	awardBoxTwo10,
	%% 排名奖2(指定道具）,奖励列-列11
	awardBoxTwo11,
	%% 排名奖2(指定道具）,奖励列-列12
	awardBoxTwo12,
	%% 排名奖2(指定道具）,奖励列-列13
	awardBoxTwo13,
	%% 排名奖2(指定道具）,奖励列-列14
	awardBoxTwo14,
	%% 排名奖2(指定道具）,奖励列-列15
	awardBoxTwo15,
	%% 排名奖2(指定道具）,奖励列-列16
	awardBoxTwo16,
	%% 排名奖2(指定道具）,奖励列-列17
	awardBoxTwo17,
	%% 排名奖2(指定道具）,奖励列-列18
	awardBoxTwo18,
	%% 排名奖2(指定道具）,奖励列-列19
	awardBoxTwo19,
	%% 排名奖2(指定道具）,奖励列-列20
	awardBoxTwo20,
	%% 排名奖2(指定道具）,奖励列-列21
	awardBoxTwo21,
	%% 排名奖2(指定道具）,奖励列-列22
	awardBoxTwo22,
	%% 排名奖2(指定道具）,奖励列-列23
	awardBoxTwo23,
	%% 排名奖2(指定道具）,奖励列-列24
	awardBoxTwo24,
	%% 排名奖2(指定道具）,奖励列-列25
	awardBoxTwo25,
	%% 排名奖2(指定道具）,奖励列-列26
	awardBoxTwo26,
	%% 排名奖2(指定道具）,奖励列-列27
	awardBoxTwo27,
	%% 排名奖2(指定道具）,奖励列-列28
	awardBoxTwo28,
	%% 排名奖2(指定道具）,奖励列-列29
	awardBoxTwo29,
	%% 排名奖2(指定道具）,奖励列-列30
	awardBoxTwo30,
	%% 排名奖2(指定道具）,奖励列-列31
	awardBoxTwo31,
	%% 排名奖2(指定道具）,奖励列-列32
	awardBoxTwo32,
	%% 排名奖2(指定道具）,奖励列-列33
	awardBoxTwo33,
	%% 排名奖2(指定道具）,奖励列-列34
	awardBoxTwo34,
	%% 排名奖2(指定道具）,奖励列-列35
	awardBoxTwo35,
	%% 排名奖2(指定道具）,奖励列-列36
	awardBoxTwo36,
	%% 排名奖2(指定道具）,奖励列-列37
	awardBoxTwo37,
	%% 排名奖2(指定道具）,奖励列-列38
	awardBoxTwo38,
	%% 排名奖2(指定道具）,奖励列-列39
	awardBoxTwo39,
	%% 排名奖2(指定道具）,奖励列-列40
	awardBoxTwo40,
	%% 排名奖2(指定道具）,奖励列-列41
	awardBoxTwo41,
	%% 排名奖2(指定道具）,奖励列-列42
	awardBoxTwo42,
	%% 排名奖2(指定道具）,奖励列-列43
	awardBoxTwo43,
	%% 排名奖2(指定道具）,奖励列-列44
	awardBoxTwo44,
	%% 排名奖2(指定道具）,奖励列-列45
	awardBoxTwo45,
	%% 排名奖2(指定道具）,奖励列-列46
	awardBoxTwo46,
	%% 排名奖2(指定道具）,奖励列-列47
	awardBoxTwo47,
	%% 排名奖2(指定道具）,奖励列-列48
	awardBoxTwo48,
	%% 排名奖2(指定道具）,奖励列-列49
	awardBoxTwo49,
	%% 排名奖2(指定道具）,奖励列-列50
	awardBoxTwo50,
	%% 排名奖2(指定道具）,奖励列-列51
	awardBoxTwo51,
	%% 排名奖2(指定道具）,奖励列-列52
	awardBoxTwo52,
	%% 排名奖2(指定道具）,奖励列-列53
	awardBoxTwo53,
	%% 排名奖2(指定道具）,奖励列-列54
	awardBoxTwo54,
	%% 排名奖2(指定道具）,奖励列-列55
	awardBoxTwo55,
	%% 排名奖2(指定道具）,奖励列-列56
	awardBoxTwo56,
	%% 排名奖2(指定道具）,奖励列-列57
	awardBoxTwo57,
	%% 排名奖2(指定道具）,奖励列-列58
	awardBoxTwo58,
	%% 排名奖2(指定道具）,奖励列-列59
	awardBoxTwo59,
	%% 排名奖2(指定道具）,奖励列-列60
	awardBoxTwo60,
	%% 排名奖2(指定道具）,奖励列-列61
	awardBoxTwo61,
	%% 排名奖2(指定道具）,奖励列-列62
	awardBoxTwo62
}).

-endif.
