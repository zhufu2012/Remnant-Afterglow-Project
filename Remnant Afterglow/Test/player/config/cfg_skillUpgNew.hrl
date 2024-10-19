-ifndef(cfg_skillUpgNew_hrl).
-define(cfg_skillUpgNew_hrl, true).

-record(skillUpgNewCfg, {
	%% 技能位
	%% 普攻1
	%% 基础技能3-6
	%% 特殊大技能:8
	%% 200+：主动技能
	%% 300+：被动技能
	iD,
	%% 总等级
	lv,
	%% 客户端索引
	index,
	%% 技能最大等级
	lvMax,
	%% 前置条件1
	%% 配置，天赋表天赋等级.[GeniusLv]表的(ID,Num,Lv)
	geniusBaseID,
	%% 激活或升级前置条件
	%% *这里配的是下一等级
	%% （转职等级，转生等级，玩家等级）
	%% 1、普攻默认激活
	%% 2、基础技能3-6，先判断SkillActi[Character_Ambit]【Character相关.xlsm】，在判断该字段.
	%% 3、转职技能92-94，先判断Skill[ChangeRole_1_转职]，在判断该字段.
	%% 4、天赋技能100-105，先判断天赋是否点亮，再判断该字段.
	%% 5、89-91追击技能默认激活
	%% 满足对应条件后，再通过UseItem字段消耗道具来激活
	preposition,
	%% 激活和升至下级所消耗的道具
	%% （职业ID，类型，ID，数量）（当等级为0时，表示激活道具）
	%% 类型：1道具 2货币
	%% 职业：1004战士，1005法师，1006弓手，1007魔剑 ，0通用
	%% ·0级消耗为激活消耗，激活后为1级；等级大于0的消耗为升级消耗，最后一级没有消耗.
	%% ·字段Lv=0时，激活消耗填0表示默认激活
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
