-ifndef(cfg_dragonStatueBase_hrl).
-define(cfg_dragonStatueBase_hrl, true).

-record(dragonStatueBaseCfg, {
	%% 和item表中的神像翅膀装备id一一对应
	iD,
	%% 神像翅膀用于神像翅膀升级消耗时折合的经验
	exp,
	%% 对应的神像ID
	dragonHave,
	%% 装备品质
	%% 品质0白1蓝2紫3橙4红5龙6神7神像
	order,
	%% 装备星级
	star,
	%% 分解可得对应的数量
	decomposition,
	%% 基础属性
	%% （属性id，值）
	baseAttribute,
	%% 基础属性评分
	score,
	%% 极品属性
	%% （属性id，值，品质，评分值）
	%% 品质0白1蓝2紫3橙4红5龙6神7神像
	onlyAttribute,
	%% 卓越属性
	%% （属性id，值，品质，评分值）
	%% 品质0白1蓝2紫3橙4红5龙6神7神像
	excellence,
	%% 对SkillInit[DragonBaseNew_1_基础]字段的技能进行修正加强（该处配置的是增加伤害系数）
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
	skill
}).

-endif.
