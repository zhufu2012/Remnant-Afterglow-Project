-ifndef(cfg_skillUp_hrl).
-define(cfg_skillUp_hrl, true).

-record(skillUpCfg, {
	%% 技能位
	iD,
	%% 类型
	%% 1突破，2觉醒
	%% 同一类技能高等级覆盖低等级/不同类技能叠加
	skillState,
	%% 突破或觉醒的等级（填0表示为未激活）
	lv,
	%% 客户端索引
	index,
	%% 当前状态技能最大等级
	skillMax,
	%% 前置条件
	%% 对应技能等级达到多少
	preposition,
	%% 突破条件
	%% 对应角色转职达到条件可以突破到下一级
	preposition2,
	%% 升至下级所消耗的道具（职业ID，道具ID，数量）（当等级为0时，表示激活道具）
	%% 职业：1004战士
	%% 1005法师
	%% 1006弓手
	%% 1007魔剑 
	%% 0通用
	useItem,
	%% 战士
	%% 技能或修正
	%% (类型,ID,参数2)
	%% 技能类型：
	%% 1为技能(skillBase);
	%%  ID为技能ID（SkillBase表）
	%%  参数2为学习技能位 
	%% 2为技能修正(SkillCorr)
	%%   ID为技能修正ID（SkillCorr表）
	%%  参数为修正技能位
	%% 3为根据类型修正buff
	%%   ID为buff修正ID（buffCorr）
	%%   参数2为被修正的Buff类型(BuffType参数3)
	%% 4为根据buffID修正buff
	%%    ID为buff修正ID（buffCorr）
	%%    参数2为被修正的buffID（BuffBase）
	%% 5为根据类型修正buff
	%%   ID为buff修正ID（buffCorr）
	%%   参数2为被修正的Buff类型(BuffType参数2)
	%% 当学习位为0时，后端不学习此技能
	skill1004,
	%% 法师
	%% 技能或修正
	%% (类型,ID,参数2)
	%% 技能类型：
	%% 1为技能(skillBase);
	%%  ID为技能ID（SkillBase表）
	%%  参数2为学习技能位 
	%% 2为技能修正(SkillCorr)
	%%   ID为技能修正ID（SkillCorr表）
	%%  参数为修正技能位
	%% 3为根据类型修正buff
	%%   ID为buff修正ID（buffCorr）
	%%   参数2为被修正的Buff类型(BuffType参数3)
	%% 4为根据buffID修正buff
	%%    ID为buff修正ID（buffCorr）
	%%    参数2为被修正的buffID（BuffBase）
	%% 5为根据类型修正buff
	%%   ID为buff修正ID（buffCorr）
	%%   参数2为被修正的Buff类型(BuffType参数2)
	%% 当学习位为0时，后端不学习此技能
	skill1005,
	%% 弓手
	%% 技能或修正
	%% (类型,ID,参数2)
	%% 技能类型：
	%% 1为技能(skillBase);
	%%  ID为技能ID（SkillBase表）
	%%  参数2为学习技能位 
	%% 2为技能修正(SkillCorr)
	%%   ID为技能修正ID（SkillCorr表）
	%%  参数为修正技能位
	%% 3为根据类型修正buff
	%%   ID为buff修正ID（buffCorr）
	%%   参数2为被修正的Buff类型(BuffType参数3)
	%% 4为根据buffID修正buff
	%%    ID为buff修正ID（buffCorr）
	%%    参数2为被修正的buffID（BuffBase）
	%% 5为根据类型修正buff
	%%   ID为buff修正ID（buffCorr）
	%%   参数2为被修正的Buff类型(BuffType参数2)
	%% 当学习位为0时，后端不学习此技能
	skill1006,
	%% 圣职
	%% 技能或修正
	%% (类型,ID,参数2)
	%% 技能类型：
	%% 1为技能(skillBase);
	%%  ID为技能ID（SkillBase表）
	%%  参数2为学习技能位 
	%% 2为技能修正(SkillCorr)
	%%   ID为技能修正ID（SkillCorr表）
	%%  参数为修正技能位
	%% 3为根据类型修正buff
	%%   ID为buff修正ID（buffCorr）
	%%   参数2为被修正的Buff类型(BuffType参数3)
	%% 4为根据buffID修正buff
	%%    ID为buff修正ID（buffCorr）
	%%    参数2为被修正的buffID（BuffBase）
	%% 5为根据类型修正buff
	%%   ID为buff修正ID（buffCorr）
	%%   参数2为被修正的Buff类型(BuffType参数2)（buffCorr）
	%%    参数2为被修正的buffID（BuffBase）
	%% 当学习位为0时，后端不学习此技能
	skill1007,
	%% 是否公告（1.是，0.否）
	ifCall,
	%% 当前等级奖励属性
	%% {属性ID，属性值}
	attrAdd
}).

-endif.
