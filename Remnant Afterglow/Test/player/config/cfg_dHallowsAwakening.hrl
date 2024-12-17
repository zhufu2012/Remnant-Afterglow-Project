-ifndef(cfg_dHallowsAwakening_hrl).
-define(cfg_dHallowsAwakening_hrl, true).

-record(dHallowsAwakeningCfg, {
	%% 圣物id
	iD,
	%% 觉醒等级
	awakenLv,
	%% 客户端索引
	index,
	%% 最大觉醒等级数
	awakenMax,
	%% 下一级觉醒消耗材料
	%% （道具ID，数量）
	needItem,
	%% 从0级开始
	%% 升至本级的增加属性（属性ID，值）（填的是累计增加的属性）
	attrAdd,
	%% 升至当前等级后的激活属性（属性ID，值）
	activation,
	%% 觉醒技能(技能类型1,ID1,学习位1)|
	%% (技能类型2,ID2,学习位2)
	%% 技能类型：
	%% 1为技能(skillBase);
	%% 2为技能修正(SkillCorr)
	%% 学习位：为0时不可直接获得
	%% 当觉醒等级=最大觉醒等级数时，玩家可以进行多选一操作；其余等级玩家可以进行预览操作（预览最大觉醒等级的值）
	awakenSkill
}).

-endif.
