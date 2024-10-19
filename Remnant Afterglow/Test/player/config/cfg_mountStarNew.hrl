-ifndef(cfg_mountStarNew_hrl).
-define(cfg_mountStarNew_hrl, true).

-record(mountStarNewCfg, {
	%% 坐骑id
	iD,
	%% 星数
	star,
	%% 被动技的技能等级
	skillLv,
	%% 坐骑技能或修正
	%% (激活条件1,激活参数1,技能类型1,ID1,学习位1)
	%% |(激活条件2,激活参数2,技能类型2,ID2,学习位2)
	%% 激活条件：
	%% 0为不需要条件
	%% 1为坐骑等级激活,参数为坐骑等级
	%% 技能类型：1为技能(skillBase);
	%% 2为技能修正(SkillCorr)
	%% 学习位：为0时不可直接获得
	%% 坐骑装配技22-26
	skill
}).

-endif.