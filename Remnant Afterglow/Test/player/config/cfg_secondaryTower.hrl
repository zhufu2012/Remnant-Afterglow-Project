-ifndef(cfg_secondaryTower_hrl).
-define(cfg_secondaryTower_hrl, true).

-record(secondaryTowerCfg, {
	%% 关卡ID
	iD,
	%% 对应职业
	occupation,
	%% 等级要求
	levelLimit,
	%% 限定技能（佩带的技能SkillEquip表）
	%% 配置技能位
	qualifiedSkills,
	%% 技能强化
	%% (枚举，技能位，指定等级，SkillCorrID)
	%% 可配置多个，用 | 分隔
	%% 枚举：
	%% 1.技能等级达到指定等级
	%% 2.技能突破达到指定等级
	%% 3.技能觉醒达到指定等级
	%% 技能强化：当技能达到指定等级时，为该技能位技能附加临时技能修正（SkillCorr）
	strengthenSkills,
	%% 每层奖励
	%% (类型，道具id，数量)
	normalReward,
	%% 分段
	%% (分段序号，转生数）
	stage,
	%% 实际通关掉落
	%% （序号，掉落ID，掉落数量，掉落概率）
	%% 转生往下取，只有满足转生条件的包会增加，采用覆盖是
	%% 序号：序号与Stage字段的序号一一对应。只取最满足的序号做掉落
	dropReward,
	%% 怪物模型展示
	%% (X偏移，Y偏移，Z偏移，X旋转，Y旋转，Z旋转，缩放)
	modelTransform1,
	%% 主角模型展示
	%% (X偏移，Y偏移，Z偏移，X旋转，Y旋转，Z旋转，缩放)
	modelTransform2,
	%% 英雄模型展示
	%% (X偏移，Y偏移，Z偏移，X旋转，Y旋转，Z旋转，缩放)
	modelTransform3,
	%% 秒杀条件
	%% 当前战力>推荐战力时，可秒杀至最高层数-配置关数
	seckill,
	%% 按照开服天数增加boss的生命和伤害
	%% （开服天数
	%% boss生命加成，boss最终伤害 加成，开服天数结束，每天递减生命加成，每天递减最终伤害加成)
	%% 开服天数:从这天开始增加boss生命与伤害
	%% boss生命加成:第"开服天数"时，增加的生命加成
	%% boss最终伤害加成:第"开服天数"时，增加的最终伤害加成
	%% 开服天数结束:到达该天数时，该加成清零
	%% 每天递减生命加成:开服天数+N天时，最终生命加成= (boss生命加成-N*每天递减生命加成)
	%% 每天递减最终伤害加成:开服天数+N天时，最终伤害加成=(boss生命加成-N*每天递减伤害加成)
	bossStr
}).

-endif.
