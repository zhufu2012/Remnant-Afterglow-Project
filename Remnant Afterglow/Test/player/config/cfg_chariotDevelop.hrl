-ifndef(cfg_chariotDevelop_hrl).
-define(cfg_chariotDevelop_hrl, true).

-record(chariotDevelopCfg, {
	%% 战车ID
	iD,
	%% 部位
	%% 1、主体
	%% 2、技能1
	%% 3、技能2
	%% 4、技能3
	part,
	%% 等级
	level,
	%% 最大等级
	max,
	%% 升到下一级消耗
	%% （道具id，数量）
	needItem,
	%% 所需部位等级
	%% (部位序号,等级)
	%% 升到下级条件，0升1，读0
	needStar,
	%% 战车属性
	attra,
	%% 技能或修正
	%% (技能类型1，ID1，学习位1)|(技能类型2，ID2，学习位2)
	%% 技能类型：1为技能(skillBase);
	%% 2为技能修正(SkillCorr)
	%% 学习位：为0时不可直接获得
	strengthen,
	%% 战车科技等级上限所需战车工坊等级
	lvCondition
}).

-endif.
