-ifndef(cfg_changeRoleDemonSource_hrl).
-define(cfg_changeRoleDemonSource_hrl, true).

-record(changeRoleDemonSourceCfg, {
	%% 魔源ID
	%% 与任务参数对应
	iD,
	%% 魔源激活点
	%% 按该顺序依次激活，全部点激活时，就激活对应元素
	order,
	%% 双索引
	index,
	%% 魔源最大激活点
	num,
	%% 前置魔源激活点
	%% 填“0”表示没有前置
	startOrder,
	%% 后置魔源激活点
	%% 填“0”表示没有后置
	endOrder,
	%% 激活条件
	%% （方案，类型，参数1，参数2）
	%% 类型：1道具，参数1=道具ID，参数2=道具数量
	%% 类型：2自身经验，参数1填“0”，参数2=经验值
	%% 同“方案”的条件要求都达到，才算该“条件方案”要求达到；
	%% 满足一个条件方案就有资格进入副本
	activationCond,
	%% 魔源激活后的等级属性
	%% (属性ID，属性值)
	%% 出于界面展示效果，该属性为等级属性，不叠加
	attrAdd,
	%% 激活等级限制
	lvLimit,
	%% 对应任务ID
	%% 需要接取任务才能激活魔源
	taskID
}).

-endif.
