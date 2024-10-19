-ifndef(cfg_hallowsAwakenNew_hrl).
-define(cfg_hallowsAwakenNew_hrl, true).

-record(hallowsAwakenNewCfg, {
	%% 圣物id
	iD,
	%% 精炼等级
	level,
	%% 客户端索引
	index,
	%% 最大觉醒等级
	lvMax,
	%% 所需圣物星级
	needLv,
	%% 精炼所需道具ID，数量
	needItem,
	%% 属性加值
	attrAdd,
	%% 圣物被动技能
	%% (技能类型1,ID1,学习位1)
	%% 技能类型：1为技能(skillBase)
	%% 2为技能修正(SkillCorr)
	%% 学习位：为0时不可直接获得
	%% 圣物被动技73-88
	skill
}).

-endif.
