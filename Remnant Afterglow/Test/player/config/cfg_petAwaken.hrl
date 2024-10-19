-ifndef(cfg_petAwaken_hrl).
-define(cfg_petAwaken_hrl, true).

-record(petAwakenCfg, {
	%% 宠物id
	iD,
	%% 觉醒等级
	level,
	%% 客户端索引
	index,
	%% 最大觉醒等级
	lvMax,
	%% 所需宠物星级
	needLv,
	%% 所需英雄等级
	needLevel,
	%% 升级所需道具ID
	needItem,
	%% 属性加值
	attrAdd,
	%% 魔灵技等级
	skillLv,
	%% 魔宠技能或修正
	%% (技能类型1,ID1,学习位1)
	%% 技能类型：1为技能(skillBase);
	%% 2为技能修正(SkillCorr)
	%% 学习位：为0时不可直接获得
	%% 魔宠装配技17-21
	skill,
	%% 提升系统中需要用到的评价该系统养成进度的依据值
	evaluate,
	%% 魔宠技能或修正
	%% (技能类型1,ID1,学习位1)
	%% 魔宠升品优化后，根据当前品级替换对应字段的技能
	skill1,
	%% 魔宠技能或修正
	%% (技能类型1,ID1,学习位1)
	%% 魔宠升品优化后，根据当前品级替换对应字段的技能
	skill2,
	%% 魔宠技能或修正
	%% (技能类型1,ID1,学习位1)
	%% 魔宠升品优化后，根据当前品级替换对应字段的技能
	skill3
}).

-endif.
