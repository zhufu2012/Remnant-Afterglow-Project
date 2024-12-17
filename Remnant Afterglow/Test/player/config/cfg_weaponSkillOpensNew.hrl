-ifndef(cfg_weaponSkillOpensNew_hrl).
-define(cfg_weaponSkillOpensNew_hrl, true).

-record(weaponSkillOpensNewCfg, {
	%% 技能格子ID
	iD,
	%% 器灵等级要求
	needLv,
	%% 解锁消耗道具
	%% (物品id,数量)
	needItem,
	%% 解锁奖励属性
	%% (属性ID，属性值)
	attrAdd
}).

-endif.
