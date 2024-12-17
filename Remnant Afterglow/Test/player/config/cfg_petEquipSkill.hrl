-ifndef(cfg_petEquipSkill_hrl).
-define(cfg_petEquipSkill_hrl, true).

-record(petEquipSkillCfg, {
	%% 【OB4】
	%% 技能品质
	%% 1初级
	%% 2中级
	%% 3高级
	quali,
	%% 序号
	order,
	%% 索引
	index,
	%% 技能生成权重
	weight,
	%% 技能编号：
	%% 相同编号的技能在同一个戒指中不能同时出现，
	%% 即同一个编号的技能在同一个戒指中最多随中1次
	weightGroup,
	%% 装备技能
	%% （技能类型，id，学习位）
	%% 技能类型：1为技能(skillbase),
	%% 2为修正(skillcorr)
	%% 学习位：按实际拥有的装备技能编号678-686
	skill,
	%% buff修正
	%% (修正类型,修正参数,修正ID)
	%% 修正类型：
	%% 1为BuffType[BuffBase]参数3;修正参数=BuffType[BuffBase]参数3,
	%% 修正ID为ID[BuffCorr]
	%% 注：skill与Buffcorr同时有时优先显示buffCorr
	buffCorr
}).

-endif.
