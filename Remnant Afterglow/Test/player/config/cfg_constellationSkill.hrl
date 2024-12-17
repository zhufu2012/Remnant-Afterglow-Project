-ifndef(cfg_constellationSkill_hrl).
-define(cfg_constellationSkill_hrl, true).

-record(constellationSkillCfg, {
	%% 星座ID
	iD,
	%% 守护总星数
	%% 取小于等于上阵总星数的最大配置
	guardStar,
	%% 索引
	index,
	%% 星座技能及激活条件
	%% （技能类型，技能id，学习位，技能等级，激活条件类型，条件参数，技能组）|……
	%% 技能类型：1为技能(skillBase);
	%% 2为技能修正(SkillCorr)
	%% 学习位：为0时不可直接获得
	%% 星座装配位：默认124-133
	%% 激活条件类型：1为本星座上阵守护数量，参数为上阵守护数
	%% 技能组：技能等级变化时，可通过该分组找到该技能的其他等级技能，以便自动替换
	skillId
}).

-endif.
