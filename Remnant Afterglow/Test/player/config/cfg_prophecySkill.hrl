-ifndef(cfg_prophecySkill_hrl).
-define(cfg_prophecySkill_hrl, true).

-record(prophecySkillCfg, {
	%% ID
	%% 风暴传承
	%% 智慧传承
	%% 雷霆传承
	%% 复仇传承
	%% 守护传承
	%% 灵魂传承
	%% 战争传承
	%% 对应ID[Prophecy]
	iD,
	%% 顺序
	num,
	%% Key
	index,
	%% 达成任务数
	taskMax,
	%% 所有条件达成后，可激活的技能ID
	%% 技能或修正
	%% (职业，技能类型1,ID1,学习位1)
	%% 技能类型：1为技能(skillBase);
	%% 2为技能修正(SkillCorr)
	%% 学习位：为0时不可直接获得
	%% 预言之书1-5:95-99
	%% 预言之书6:112
	%% 预言之书7:90
	skill
}).

-endif.
