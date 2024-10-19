-ifndef(cfg_newrecharge_hrl).
-define(cfg_newrecharge_hrl, true).

-record(newrechargeCfg, {
	%% ID
	iD,
	%% 序号，无意义
	oder,
	%% 轮换ID
	award,
	%% 索引
	index,
	%% 个人等级
	%% （等级下限，等级上限）取等
	lv,
	%% 作者:
	%% 开服时间在这个日期区间内的服务器，才生效
	%% {起始GSID,结束GSID}|{起始GSID,结束GSID}
	serverID,
	%% 类型
	%% 1、每日重置
	%% 2、累计天数
	type,
	%% Type=2时的档位
	type1,
	%% 本轮持续时间
	%% 计玩家个人身上
	activityDays,
	%% 开服时间
	startTime,
	%% 开服时间
	endTime,
	%% 达标的累计充值天数
	rechargeDays,
	%% 奖励轮换
	%% 轮换期数|下一轮轮换ID
	rotation,
	%% 【Newrecharge2_1_新每日累充奖励】表ID
	activitys,
	image
}).

-endif.
