-ifndef(cfg_changeRoleFate_hrl).
-define(cfg_changeRoleFate_hrl, true).

-record(changeRoleFateCfg, {
	%% 命星ID
	iD,
	%% 前置命星ID
	%% 填“0”表示没有前置命星
	start,
	%% 后置命星ID
	%% 填“0”表示没有后置命星
	endId,
	%% 名称索引
	%% texts表menu分页
	name,
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
