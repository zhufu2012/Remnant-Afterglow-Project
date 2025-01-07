-ifndef(cfg_hallowsSkillOpenNew_hrl).
-define(cfg_hallowsSkillOpenNew_hrl, true).

-record(hallowsSkillOpenNewCfg, {
	%% 技能格子ID
	iD,
	%% 圣灵类型1火灵2水灵3雷灵4土灵
	element,
	%% 客户端索引
	index,
	%% 等级开启方式
	%% 1为圣灵等级
	%% 2为vip等级
	%% 等级取NeedPetLv
	needWay,
	%% 圣灵等级要求
	mountLv,
	%% 消耗道具
	%% {道具类型，道具ID，道具数量}
	%% 道具类型：1为道具 2 为货币
	%% 满足NeedWay等级
	needItem
}).

-endif.
