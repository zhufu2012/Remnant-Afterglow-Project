-ifndef(cfg_reviveAct_hrl).
-define(cfg_reviveAct_hrl, true).

-record(reviveActCfg, {
	%% 复活ID
	iD,
	%% 角色复活方式
	%% 1单个角色不可复活
	%% 2单个角色可自然时间复活
	%% 3单个角色死亡后，不使用道具队伍立即复活
	%% 4单个角色死亡后，使用道具队伍立即复活
	reviveType,
	%% 自然复活时间毫秒
	reviveTime,
	%% 立即复活消耗{消耗类型，ID，数量}。
	%% 参数1为类型(1道具，2货币)，
	%% ID：参数1为1时，填写道具ID，参数1为2时填写货币枚举，见道具相关
	%% 数量为其对应数量
	%% 无消耗填0
	reviveConsume,
	%% 每次复活增加消耗（每次增加消耗类型，每次增加消耗道具ID，每次增加的具体数目的IDReviveAdd表）
	addConsume,
	%% 复活点类型
	%% 1固定点
	%% 2原地
	%% 3随机
	%% 4主城
	%% 5领队身边
	revivePointType,
	%% 累计被杀增加复活时间.参数1为被杀次数，参数2为增加到的时间，毫秒，参数3为清除增加时间的时间间隔，毫秒
	deathAddReviveTime,
	%% 复活之后增加buff
	reviveBuff,
	%% 第几次踢出副本
	%% （0代表没有次数）
	revivequit
}).

-endif.
