-ifndef(cfg_luckyDiamondTurntable2_hrl).
-define(cfg_luckyDiamondTurntable2_hrl, true).

-record(luckyDiamondTurntable2Cfg, {
	%% 活动id
	%% 活动type 28
	iD,
	%% 最大抽奖次数
	num,
	%% 抽奖条件
	%% （抽奖次数，充值绿钻数量）
	%% 抽奖次数：第几次抽奖
	condition,
	%% 奖励
	%% （奖励序号，参数1，参数2，参数3）
	%% 奖励序号：
	%% 参数1=1为道具，2为货币
	%% 参数2=道具id
	%% 参数3=数量
	award,
	%% 奖励对应的转盘位置
	%% 配置奖励序号
	%% 10|8|5|1|3|9|4|2|6|7：
	%% 第1个位置：奖励序号10；
	%% 第2个位置：奖励序号8；
	%% …
	%% 第10个位置：奖励序号7.
	location,
	%% 抽奖
	%% （抽奖次数，奖励序号，权重）
	%% 同一个奖励序号的只能被抽中一次
	luckDraw,
	%% (奖励序号，是否系统公告，是否抽奖记录）
	show,
	%% （奖励序号，奖励类型）
	%% 0：普通奖励
	%% 1：大奖
	%% 2：特奖
	level
}).

-endif.
