-ifndef(cfg_dragonGodtrial1_hrl).
-define(cfg_dragonGodtrial1_hrl, true).

-record(dragonGodtrial1Cfg, {
	iD,
	%% admin:
	%% 活动开关
	%% 0=关
	%% 1=开
	switch,
	%% 作者:
	%% {起始服务器id，结束服务器id}
	%% 在这个区间段内的服务器，活动才生效
	serverID,
	%% 开始日期
	startDate,
	%% 结束日期
	endDate,
	%% admin:
	%% 活动名
	name,
	%% 邮件标题
	mailTitle,
	%% 排名奖励结算时，邮件描述
	rewards_Des1,
	%% 积分达成奖励结算时，邮件描述
	rewards_Des2,
	%% 开启时间，根据开服时间来计算的相对时间
	openDate,
	%% 持续天数，开启活动后持续的天数
	durationDays,
	%% 后端记录该活动排行的最大记录数
	rankRecord_MaxNum,
	%% 后端推送给前端该活动排行的最大条数
	rankShow_MaxNum,
	%% 大类型：
	%% 1=经验排行
	%% 2=活跃排行
	%% 3=协助排行
	%% 4=副本排行
	%% 5=BOSS排行
	%% 6=钻石排行
	%% 7=总积分排行
	class,
	%% 积分获取途径
	%% 跳转ID
	recommend,
	%% 获得积分，达成枚举ID
	type,
	%% 阶段排名奖励
	%% {奖励序号,参数1,参数2，参数3}
	%% 奖励序号：各档位，不可重复
	%% 参数1：最大排名
	%% 参数2：最小排名
	%% 参数3：领取该奖励的最低积分要求
	rewardCond,
	%% 达成奖励
	%% {奖励编号，达成积分}
	rewardCondBase,
	%% 达成奖励描述文字
	rewardCondBaseText,
	%% 积分奖励预览
	rewardShow,
	%% 左侧模型称号展示
	%% 称号道具ID（道具表ID）
	modelTitle,
	%% 阶段对应Icon
	icon,
	%% 当前活动选中Icon
	selectIcon
}).

-endif.
