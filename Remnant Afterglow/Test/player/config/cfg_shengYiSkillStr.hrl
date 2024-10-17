-ifndef(cfg_shengYiSkillStr_hrl).
-define(cfg_shengYiSkillStr_hrl, true).

-record(shengYiSkillStrCfg, {
	%% 技能类型
	%% 1主动技能
	%% 2被动技能
	type,
	%% 技能等级分类
	level,
	%% 技能强化等级
	strLevel,
	%% 索引
	index,
	%% 升到下一级需要的经验
	%% 技能强化等级上限在每个技能的配置里，而这里的配置需保证大于等于该类型下所有技能的等级上限
	eXP
}).

-endif.
