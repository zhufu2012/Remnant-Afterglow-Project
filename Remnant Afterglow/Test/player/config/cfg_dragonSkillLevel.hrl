-ifndef(cfg_dragonSkillLevel_hrl).
-define(cfg_dragonSkillLevel_hrl, true).

-record(dragonSkillLevelCfg, {
	%% 神像id
	iD,
	%% 等阶段显示，主要是客户端显示用
	showStairs,
	%% 对SkillInit[DragonBaseNew_1_基础]字段的技能进行修正加强（该处配置的是增加固定值伤害）
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
