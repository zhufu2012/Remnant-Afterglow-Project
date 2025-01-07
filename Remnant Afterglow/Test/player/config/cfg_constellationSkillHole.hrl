-ifndef(cfg_constellationSkillHole_hrl).
-define(cfg_constellationSkillHole_hrl, true).

-record(constellationSkillHoleCfg, {
	%% 技能格子ID
	%% 1-5默认守护技能位：124-133
	%% 11-15默认星石技能位：371-375
	%% 远征默认星石技能位：370
	iD,
	%% 开启方式
	%% 1为所有星座的总星数
	%% 2为vip等级
	%% 等级取
	needWay,
	%% 开启方式参数
	mountLv,
	%% 消耗道具
	%% {道具类型，道具ID，道具数量}
	%% 道具类型：1为道具 2 为货币
	%% 满足NeedWay等级
	needItem
}).

-endif.
