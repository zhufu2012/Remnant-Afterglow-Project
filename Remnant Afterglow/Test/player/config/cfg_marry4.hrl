-ifndef(cfg_marry4_hrl).
-define(cfg_marry4_hrl, true).

-record(marry4Cfg, {
	%% ID
	iD,
	%% 红包名称
	name,
	%% 单场婚礼发红包的次数限制
	limit,
	%% 发红包的消耗
	%% (货币ID，数量）
	cons,
	%% 发红包的人获得奖励
	%% （奖励类型,参数1,参数2)
	%% 奖励类型：
	%% 1为道具,参数1：道具ID，参数2：道具数量
	%% 2为货币,参数1：货币ID，参数2：货币数量
	award,
	%% 瓜分红包
	%% （货币类型，货币总数，红包个数）
	redP
}).

-endif.
