-ifndef(cfg_guildSacrifice_hrl).
-define(cfg_guildSacrifice_hrl, true).

-record(guildSacrificeCfg, {
	%% ID
	iD,
	%% 战盟祭祀奖励类型
	%% 1、进度宝箱奖励
	%% 2、祭祀选项奖励
	sacriType,
	%% 当SacriType=2，可祭祀的次数走VIP相关表vipFun_1_VIP具体特权
	%% 这里填的是vipFun的ID
	sacrificeTimes,
	%% 积分宝箱奖励进度需要
	%% (无用字段，进度)，消耗类型没有作用，
	%% 祭祀选项消耗货币
	%% (货币类型，数量)
	needNumber,
	%% 祭祀消耗道具
	%% {道具ID，数量}
	needItem,
	%% 奖励等级序号
	%% （个人等级，序号）
	%% 个人等级向后取
	%% （1,1）|（201,2）：1-200级序号为1的奖励；≥201级序号为2的奖励。
	%% 功能做好后删除"ItemReward,CurrencyReward"字段
	rewardOder,
	%% 奖励
	%% （序号，职业，类型，ID，数量）
	%% 序号:RewardOder字段的序号.
	%% 职业：
	%% 类型：1道具，ID=道具ID；
	%% 类型：2货币，ID=货币ID.
	%% 功能做好后删除"ItemReward,CurrencyReward"字段
	reward,
	%% 祭祀进度
	%% (开服天数，祭祀进度)
	%% 向前读取开服天数
	%% 例：如配置为(1,1)|(7,2)|(14,3)
	%% 当前开服天数为2时，此时读取（1,1）
	integralNew,
	%% 任务道具奖励
	%% (任务ID，ID，数量，是否绑定，持续时间)
	taskAward
}).

-endif.
