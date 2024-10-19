-ifndef(cfg_equipTypeAttr_hrl).
-define(cfg_equipTypeAttr_hrl, true).

-record(equipTypeAttrCfg, {
	%% 阶数
	order,
	%% 类型
	%% （装备类/饰品类）
	type,
	%% 装备类别
	equipType,
	%% 品质
	quality,
	%% 星级
	star,
	%% 件数
	num,
	%% 索引
	index,
	%% 套装属性
	%% （属性ID，值）
	linkAttr,
	%% 特殊套套装属性
	%% （属性ID，值）
	specialLinkAttr,
	%% 普通套技能
	%% (职业，技能类型,ID,学习位)
	%% 技能类型：
	%% 1为技能(skillBase);
	%% 2为技能修正(SkillCorr)
	%% 学习位：为0时不可直接获
	skill,
	%% 特殊套技能
	%% (职业，技能类型,ID,学习位)
	%% 技能类型：
	%% 1为技能(skillBase);
	%% 2为技能修正(SkillCorr)
	%% 学习位：为0时不可直接获
	specialSkill
}).

-endif.
