-ifndef(cfg_armsAwakenNew_hrl).
-define(cfg_armsAwakenNew_hrl, true).

-record(armsAwakenNewCfg, {
	%% 神像id
	iD,
	%% 觉醒等级
	level,
	%% 客户端索引
	index,
	%% 最大觉醒等级
	lvMax,
	%% 觉醒下级所需道具ID
	needItem,
	%% 属性加值
	attrAdd,
	%% 对SkillInit[DragonBaseNew_1_基础]字段的技能进行修正加强（废弃，移至神像翅膀基础属性）
	%% (技能类型1,ID1,学习位1)|
	%% (技能类型2,ID2,学习位2)
	%% 技能类型：
	%% 1为技能(skillBase);
	%% 2为技能修正(SkillCorr)
	%% 学习位：为0时不可直接获得
	%% 7为神像怒气技
	%% 9为神像普攻
	%% 10为神像技能1
	%% 11为神像技能2
	%% 12为神像公用技能(变身后可用)
	%% 113为神像技能3
	skill,
	%% 提升系统中需要用到的评价该系统养成进度的依据值
	evaluate
}).

-endif.
