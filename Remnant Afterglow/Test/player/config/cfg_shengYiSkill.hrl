-ifndef(cfg_shengYiSkill_hrl).
-define(cfg_shengYiSkill_hrl, true).

-record(shengYiSkillCfg, {
	%% 圣翼技能ID
	%% 同技能书道具id
	iD,
	%% 圣翼技能
	%% （技能类型，id）
	%% 技能类型：1为技能(skillbase),
	%% 2为修正(skillcorr)
	%% 注：skill与Buffcorr同时有时优先显示buffCorr
	skill,
	%% buff修正
	%% (修正类型,修正参数,修正ID)
	%% 修正类型：
	%% 1为BuffType[BuffBase]参数3;修正参数=BuffType[BuffBase]参数3,
	buffCorr,
	%% 是否默认显示
	open,
	%% 技能类型
	%% 1主动技能
	%% 2被动技能
	type,
	%% 技能等级分类
	level,
	%% 消耗技能槽位
	slotPoint,
	%% 技能装配条件
	%% （条件类型，参数）
	%% 类型1：解锁圣翼，参数-圣翼等级
	condition,
	%% 技能经验
	eXP,
	%% 技能装配组
	%% (组，优先级)
	%% 同组的技能不能同时装配，优先级值大的可替换小的，而值小于等于的则不能装配；
	%% 主、被动独立（不影响）
	group
}).

-endif.
