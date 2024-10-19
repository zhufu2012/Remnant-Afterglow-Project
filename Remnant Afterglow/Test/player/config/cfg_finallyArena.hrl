-ifndef(cfg_finallyArena_hrl).
-define(cfg_finallyArena_hrl, true).

-record(finallyArenaCfg, {
	%% 竞技场结算ID
	iD,
	%% 竞技场预告开服天数
	%% （以22点为结算）
	%% 改为：竞技场预告持续天数固定配置，每个服开始预告关闭竞技场的时间点由程序判断.
	finallyTimeShow,
	%% 每日排名转化的积分
	%% （排名，积分）
	%% （1,10)|(2,9)|(4,8)代表排名1转化为10积分，第二名及第三名获得9积分，第四及四以后获得8积分
	%% 必须有参与才会获得积分
	rankMark,
	%% 竞技场排名序号
	%% (序号，排名上限，排名下限，积分限制）
	%% （1,1,1,100）代表排名在上下第一名，并且满足100分的玩家能获得序号1奖励
	%% 不满足则会顺延奖励序号
	rankNum,
	%% 最终结算奖励
	%% （序号，类型，id，数量）
	%% RANK=0时为无排名奖励
	%% 类型：1为道具，填写道具ID，2为货币，填写货币枚举
	finallyDayAward,
	%% 称号展示字段
	%% （序号,ID）
	titleShow
}).

-endif.