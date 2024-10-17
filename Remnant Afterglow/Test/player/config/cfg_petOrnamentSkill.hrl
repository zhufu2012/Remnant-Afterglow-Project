-ifndef(cfg_petOrnamentSkill_hrl).
-define(cfg_petOrnamentSkill_hrl, true).

-record(petOrnamentSkillCfg, {
	%% 技能ID
	iD,
	%% 技能品质色
	%% 0白色，1蓝色，2紫色，3橙色，4红色，5龙装，6神装，7龙神装
	character,
	%% 判断是否公告（海神祝福用）
	%% 0.不公告
	%% 1.高级属性公告
	%% 2.专属属性公告
	notice,
	%% 配饰淬炼属性前缀文字名称
	%% 没有就填“0”
	prefix,
	%% 描述
	skilltext,
	%% 配饰修正
	%% (技能类型1,ID1,学习位1)|
	%% (技能类型2,ID2,学习位2)
	%% 技能类型：
	%% 1为技能(skillBase);
	%% 2为技能修正(SkillCorr)
	%% 学习位：为0时不可直接获得
	skill,
	%% buff修正
	%% (修正类型,修正参数,修正ID)
	%% 修正类型：
	%% 1为BuffType[BuffBase]参数3;修正参数=BuffType[BuffBase]参数3,
	%% 修正ID为ID[BuffCorr]
	buffCorr
}).

-endif.
