-ifndef(cfg_hallowsSoulLvNew_hrl).
-define(cfg_hallowsSoulLvNew_hrl, true).

-record(hallowsSoulLvNewCfg, {
	%% 圣灵等级
	iD,
	%% 圣灵类型1火灵2水灵3雷灵4土灵
	element,
	%% 客户端索引
	index,
	%% 升下一级需要经验
	exp,
	%% 圣灵最大等级
	maxLevel,
	%% 等级奖励属性
	%% {属性ID，属性值}
	attrAdd,
	%% 圣灵普攻
	%% (技能类型1,ID1,学习位1)
	%% 技能类型：1为技能(skillBase)
	%% 2为技能修正(SkillCorr)
	%% 学习位：为0时不可直接获得
	%% 圣物普攻69-72
	skill
}).

-endif.
