-ifndef(cfg_lMatch1v1CupGradeUp_hrl).
-define(cfg_lMatch1v1CupGradeUp_hrl, true).

-record(lMatch1v1CupGradeUpCfg, {
	%% 奖杯ID
	iD,
	%% 品质
	%% 1为铜
	%% 2为银
	%% 3为金
	%% 4铂金
	%% 5钻石
	rareType,
	%% 索引
	index,
	%% 奖杯道具ID（仅用于前端tips取icon和品质色）
	showID,
	%% 最大品质
	rareTypeLimit,
	%% 升品经验
	consume,
	%% 升品属性
	%% 奖杯基础属性包括段位基础属性+品质基础属性
	%% 属性奖励不叠加，直接取当前配置
	attrAdd,
	%% 技能等级
	skillLv,
	%% 奖杯属性技能或修正
	%% (技能类型1,ID1)|
	%% (技能类型2,ID2)
	%% 技能类型：1为技能(skillBase);
	%% 2为技能修正(SkillCorr)
	%% 学习位（指定xx、yy）装配生效
	skill1,
	%% 奖杯触发技能或修正
	%% (技能类型1,ID1)|
	%% (技能类型2,ID2)
	%% 技能类型：1为技能(skillBase);
	%% 2为技能修正(SkillCorr)
	%% 学习位（指定xx、yy）装配生效
	skill2,
	%% 材料返还
	%% 奖杯基础属性包括段位基础属性+品质基础属性
	return
}).

-endif.
