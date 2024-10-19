-ifndef(cfg_fashionShow4_hrl).
-define(cfg_fashionShow4_hrl, true).

-record(fashionShow4Cfg, {
	%% 主题ID
	iD,
	%% 默认是否开启
	%% 1，开启
	%% 0，不开启(如果激活了部件ID的任意一个，就自动开启)
	open,
	%% 主题名称
	themeName,
	%% 所属职业
	%% 1004战士
	%% 1005法师
	%% 1006弓箭手
	character,
	%% 部件ID
	themePosition,
	%% 技能学习
	%% (技能类型1,ID1,学习位1，技能等级)|
	%% (技能类型2,ID2,学习位2，技能等级)
	%% 技能等级:主题时装的技能等级为该时装所有部件中星级最低的部件星级
	%% 技能类型：
	%% 1为技能(skillBase);
	%% 2为技能修正(SkillCorr)
	%% 学习位：为0时不可直接获得
	skill
}).

-endif.
