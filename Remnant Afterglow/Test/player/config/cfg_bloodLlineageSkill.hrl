-ifndef(cfg_bloodLlineageSkill_hrl).
-define(cfg_bloodLlineageSkill_hrl, true).

-record(bloodLlineageSkillCfg, {
	%% 血脉ID
	bloodID,
	%% 技能序号
	%% 与对应血脉的配置【BloodLlineageBase_1_血脉基础】Skill对应
	skillOrder,
	%% 技能等级
	skillLevel,
	%% 索引
	index,
	%% 等级上限
	maxLv,
	%% 升下一级消耗
	%% （道具id，数量）
	consume,
	%% 血脉技能
	%% （技能类型，ID，学习位)
	%% 类型1为技能，
	%% 类型2为技能修正
	skill
}).

-endif.
