-ifndef(cfg_shengwenAttri_hrl).
-define(cfg_shengwenAttri_hrl, true).

-record(shengwenAttriCfg, {
	%% 属性ID
	iD,
	%% 阶数
	order,
	%% 索引
	index,
	%% 属性ID，属性值
	attribute,
	%% 属性品质色
	%% 0白色，1蓝色，2紫色，3橙色，4红色，5龙装，6神装，7龙神装
	character,
	%% 评分ID，到EquipScoreIndex表中查询评分值
	starScore
}).

-endif.
