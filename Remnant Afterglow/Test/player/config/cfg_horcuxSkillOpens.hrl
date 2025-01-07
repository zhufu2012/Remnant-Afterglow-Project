-ifndef(cfg_horcuxSkillOpens_hrl).
-define(cfg_horcuxSkillOpens_hrl, true).

-record(horcuxSkillOpensCfg, {
	%% 技能格子ID
	iD,
	%% 等级开启方式
	%% 1为器灵等级
	%% 2为vip等级
	%% 等级取NeedPetLv
	needWay,
	%% 当NeedWay为1时，器灵等级要求
	%% 当NeedWay为2时，vip等级
	needPetLv,
	%% 消耗道具
	%% {道具类型，道具ID，道具数量}
	%% 道具类型：1为道具 2 为货币
	%% 满足NeedWay等级
	needItem
}).

-endif.
