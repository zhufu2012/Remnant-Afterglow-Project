-ifndef(cfg_skillUpgSpecial_hrl).
-define(cfg_skillUpgSpecial_hrl, true).

-record(skillUpgSpecialCfg, {
	%% 技能位
	iD,
	%% 技能等级
	%% 技能位：89
	lv,
	%% 索引
	index,
	%% 等级上限
	maxLv,
	%% 修炼到下一级需要经验
	eXP,
	%% 等级段显示，主要是客户端显示用
	showLv,
	%% 星星数显示，主要是客户端显示用
	showStars,
	%% 最大星数
	maxStars,
	%% 技能激活突破消耗
	%% {职业，道具id，数量}
	breakItem,
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
	%% 当前等级奖励属性
	%% 配置累计值
	%% {属性ID，属性值}
	attrAdd,
	%% 是否公告（1.是，0.否）
	ifCall,
	%% 升级道具经验
	%% (道具id，经验)
	itemEXP
}).

-endif.
