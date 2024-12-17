-ifndef(cfg_constellationAttri_hrl).
-define(cfg_constellationAttri_hrl, true).

-record(constellationAttriCfg, {
	%% 属性ID
	iD,
	%% 阶数
	order,
	%% 索引
	index,
	%% 主角属性
	%% 属性ID，属性值
	attribute,
	%% 属性品质色
	%% 0白色，1蓝色，2紫色，3橙色，4红色，5龙装，6神装，7龙神装
	character,
	%% 评分ID，到EquipScoreIndex表中查询评分值
	starScore
}).

-endif.
