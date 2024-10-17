-ifndef(cfg_changeRoleDragonSpirit_hrl).
-define(cfg_changeRoleDragonSpirit_hrl, true).

-record(changeRoleDragonSpiritCfg, {
	%% 龙魂阶段ID
	%% 1龙魂归为
	%% 2龙魂重塑
	%% 3龙魂觉醒
	iD,
	%% 龙魂ID
	dragonSpiritID,
	%% 双索引
	index,
	%% 最大龙魂ID
	dragonSpiritMax,
	%% 前置阶段ID
	%% 填“0”表示前置阶段ID
	startID,
	%% 后置阶段ID
	%% 填“0”表示没有后置ID，表示最大阶段
	endID,
	%% 前置龙魂ID
	%% 填“0”表示没有前置ID
	startDragonID,
	%% 后置龙魂ID
	%% 填“0”表示没有后置ID
	endDragonID,
	%% 激活条件
	%% （方案，类型，参数1，参数2）
	%% 类型：1道具，参数1=道具ID，参数2=道具数量
	%% 类型：2自身经验，参数1填“0”，参数2=经验值
	%% 同“方案”的条件要求都达到，才算该“条件方案”要求达到；
	%% 满足一个条件方案就有资格进入副本
	activationCond,
	%% 命星激活后后一次性属性提升
	%% (属性ID，属性值)
	attrAdd,
	%% 激活等级限制
	lvLimit
}).

-endif.
