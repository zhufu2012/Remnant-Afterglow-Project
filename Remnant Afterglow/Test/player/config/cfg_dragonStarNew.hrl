-ifndef(cfg_dragonStarNew_hrl).
-define(cfg_dragonStarNew_hrl, true).

-record(dragonStarNewCfg, {
	%% 神像id
	iD,
	%% 星数
	star,
	%% 最大星数
	starMax,
	%% 下一级需要碎片,数量
	%% 不累加
	needItem,
	%% 基础属性提升万分比
	attrIncrease,
	%% 星级奖励属性
	%% {属性ID，属性值}
	attrAdd,
	%% 对SkillInit[DragonBaseNew_1_基础]字段的技能进行修正加强（该处配置的是增加额外效果）
	%% (技能类型1,ID1,学习位1)|
	%% (技能类型2,ID2,学习位2)
	%% 技能类型：
	%% 1为技能(skillBase);
	%% 2为技能修正(SkillCorr)
	%% 学习位：为0时不可直接获得
	%% 7为变身触发技；9为神像普攻
	%% 10为神像技能1；11为神像技能2
	skill
}).

-endif.
