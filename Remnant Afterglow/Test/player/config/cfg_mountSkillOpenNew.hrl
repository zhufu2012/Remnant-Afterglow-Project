-ifndef(cfg_mountSkillOpenNew_hrl).
-define(cfg_mountSkillOpenNew_hrl, true).

-record(mountSkillOpenNewCfg, {
	%% 技能格子ID
	iD,
	%% 等级开启方式
	%% 1为兽灵等级
	%% 2为vip等级
	%% 等级取NeedMountLv
	needWay,
	%% 兽灵等级要求
	mountLv,
	%% 消耗道具
	%% {道具类型，道具ID，道具数量}
	%% 道具类型：1为道具 2 为货币
	%% 满足NeedWay等级
	needItem,
	%% 解锁格子奖励属性
	attrAdd
}).

-endif.
