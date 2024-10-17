-ifndef(cfg_guardBless_hrl).
-define(cfg_guardBless_hrl, true).

-record(guardBlessCfg, {
	%% 类型
	%% 1.经验守护
	%% 2.防御守护
	%% 3.3阶守护
	%% 4.4阶守护
	%% ……
	type,
	%% 护佑联动等级
	blLevel,
	%% 索引
	index,
	%% 联动条件
	%% (条件类型，参数1，参数2，参数3)
	%% 类型1：精炼龙升星升阶，参数1-精灵id，参数2-阶级，参数3-星级
	blessCondition,
	%% 护佑联动属性
	%% (属性id，数值)
	%% 不叠加，前端计算
	attriBless
}).

-endif.
