-ifndef(cfg_newLevelLimitCom_hrl).
-define(cfg_newLevelLimitCom_hrl, true).

-record(newLevelLimitComCfg, {
	%% ID
	iD,
	%% 分页序号
	oder,
	index,
	%% {起始服务器id，结束服务器id}
	%% 在这个区间段内的服务器，活动才生效
	serverID,
	%% 活动分页名
	name,
	%% 邮件标题
	mailTitle,
	%% 结算时，1-4档的邮件描述
	rankingEmail,
	%% 冲榜途径那一片的说明文字，文字ID
	promote,
	%% 开启时间，根据开服时间来计算的相对时间
	openDate,
	%% 持续天数，开启活动后持续的天数
	durationDays,
	%% （开始时间，结束时间）
	%% 配置开服天数.
	day,
	%% 后端推送给前端该活动排行的最大条数
	rankShow_MaxNum,
	%% 奖励条件
	%% {奖励序号,参数1,参数2}
	%% 奖励序号：各档位，不可重复
	%% 参数1：最大排名
	%% 参数2：最小排名
	rewardCond,
	%% 标签小图资源
	titleIcon,
	%% 前端判断开启的个人等级，开启后一组的封印比拼就一直开启了
	level
}).

-endif.
