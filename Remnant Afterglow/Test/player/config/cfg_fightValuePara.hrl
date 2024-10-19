-ifndef(cfg_fightValuePara_hrl).
-define(cfg_fightValuePara_hrl, true).

-record(fightValueParaCfg, {
	%% 属性分类
	%% 1：类型1-基础伤害值
	%% 2：类型2-基础系数
	%% 3：类型3-部分基础系数
	%% 4：类型4-部分技能系数
	%% 5：类型5-部分伤害值
	%% 6：类型6-转系数值
	%% 7：类型7-最终系数
	%% 8：类型8-依附系数
	%% 9：类型9-最终系数
	%% 10：系数额外类型1-系数附带固定战力
	%% 11：系数额外类型2-系数附带固定战力
	%% 12：系数额外类型3-系数附带固定战力
	%% 13：其他战力类型-战力属性
	iD,
	%% 属性ID
	attributeId,
	%% 索引
	index,
	%% 战斗力计算参数值
	fightValuePara
}).

-endif.
