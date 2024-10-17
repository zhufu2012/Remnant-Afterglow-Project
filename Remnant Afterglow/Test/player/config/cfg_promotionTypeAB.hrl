-ifndef(cfg_promotionTypeAB_hrl).
-define(cfg_promotionTypeAB_hrl, true).

-record(promotionTypeABCfg, {
	%% 活动id
	%% 活动type 125
	iD,
	%% 抽奖次数
	num,
	%% 索引
	index,
	%% 抽奖条件
	%% 充值龙钻数量
	condition,
	%% 奖励对应的转盘位置
	location,
	%% 奖励
	%% （参数1，参数2，参数3,）
	%% 参数1=1为道具，2为货币
	%% 参数2=道具id
	%% 参数3=数量
	award,
	%% (是否系统公告，是否抽奖记录）
	show,
	%% 0：普通奖励
	%% 1：大奖
	%% 2：特奖
	level
}).

-endif.
