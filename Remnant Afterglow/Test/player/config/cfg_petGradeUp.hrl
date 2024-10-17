-ifndef(cfg_petGradeUp_hrl).
-define(cfg_petGradeUp_hrl, true).

-record(petGradeUpCfg, {
	%% 魔宠id
	iD,
	%% 稀有度
	%% 0为A
	%% 1为S
	%% 2为SS
	%% 3为SSS
	%% 若没有对应的配置，则表示该魔宠不可升品
	rareType,
	%% 索引
	index,
	%% 升品后魔宠ID
	%% 仅用于资源显示（只配置基础表，程序处理：修改显示id）
	upID,
	%% 基础稀有度
	%% 羁绊计算：基础稀有度->当前稀有度都算
	rareTypeBase,
	%% 最大稀有度
	rareTypeLimit,
	%% 升品消耗
	%% 升到下一级的消耗
	%% 填0表示不可到达上限，不可继续升级
	needItem,
	%% 升品属性
	%% 属性奖励不叠加，直接取当前配置
	attrAdd
}).

-endif.
