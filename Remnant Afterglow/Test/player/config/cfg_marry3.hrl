-ifndef(cfg_marry3_hrl).
-define(cfg_marry3_hrl, true).

-record(marry3Cfg, {
	%% 贺礼ID
	iD,
	%% 贺礼名称
	name,
	%% 贺礼消耗
	%% （货币，数量)
	cons,
	%% 赠送者获得奖励
	%% （奖励类型,参数1,参数2)
	%% 奖励类型：
	%% 1为道具,参数1：道具ID，参数2：道具数量
	%% 2为货币,参数1：货币ID，参数2：货币数量
	award1,
	%% 次数限制
	%% 每场可以赠送的次数
	timeLimit,
	%% 对应text表里sever页的ID
	%% ·配置公告文字ID
	%% ·填0表示：无公告
	noticeText
}).

-endif.
