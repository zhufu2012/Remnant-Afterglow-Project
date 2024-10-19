-ifndef(cfg_character_Skill_hrl).
-define(cfg_character_Skill_hrl, true).

-record(character_SkillCfg, {
	%% 职业枚举
	%% 1004为战士，1005为法师，1006为弓手，其他的暂时没有用
	iD,
	%% TYPE                             VALUE       
	%% 1、等级                         具体等级
	%% 2、品质                         具体品质
	%% 3、时装                         套装的ID
	%% 4、羁绊编号                   羁绊的编号
	tYPE,
	%% TYPE                             VALUE       
	%% 1、等级                         具体等级
	%% 2、品质                         具体品质
	%% 3、时装                         套装的ID
	%% 4、羁绊编号                   羁绊的编号
	vALUE,
	%% 前3个的组合
	index,
	%% 学会的技能ID
	%% 1：普攻（Characrer_Skill)
	%% 2：翻滚
	skillID,
	%% 技能
	%% 1：普攻;2：翻滚;3：主动技能;4：主动技能;5：主动技能;6：怒气技能;7：主动技能
	%% 8：组队技能;21：火法灵技能;22：水法灵技能;23：雷法灵技能
	%% 1.普通;2.翻滚;3-6.基础主动技能;7.变身怒气技能;8为宠物增援技;9-11为转职技能;
	skillIdx
}).

-endif.
