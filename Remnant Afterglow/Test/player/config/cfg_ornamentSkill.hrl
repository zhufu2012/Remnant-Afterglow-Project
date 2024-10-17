-ifndef(cfg_ornamentSkill_hrl).
-define(cfg_ornamentSkill_hrl, true).

-record(ornamentSkillCfg, {
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
	%% 技能或修正
	%% (区分主角和英雄,职业,技能类型1,ID1,学习位1)
	%% 区分主角和英雄
	%% 1主角获得，2英雄获得
	%% 职业
	%% 如果是主角，职业 0不区分，1004战士，1005法师，1006弓手，1007是圣职
	%% 如果是英雄，填0，不分类
	%% 技能类型
	%% 1为技能(skillBase);
	%% 2为技能修正(SkillCorr)
	%% 学习位
	%% 为0时不可直接获得
	skill,
	%% buff修正
	%% (修正类型,修正参数,修正ID)
	%% 修正类型：
	%% 1为根据类型（详细标识）修正buff
	%%   参数1为被修正的Buff类型(BuffType参数3详细标识)
	%%   参数2为buff修正ID（buffCorr）
	%% 2为根据buffID修正buff
	%%    参数1为被修正的buffID（BuffBase）
	%%    参数2为buff修正ID（buffCorr）
	%% 3为根据类型（Buff分类）修正buff
	%%   参数1为被修正的Buff类型(BuffType参数2)
	%%   参数2为buff修正ID（buffCorr）
	buffCorr,
	%% 祝福属性评分
	point
}).

-endif.
