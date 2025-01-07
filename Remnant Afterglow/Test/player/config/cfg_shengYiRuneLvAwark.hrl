-ifndef(cfg_shengYiRuneLvAwark_hrl).
-define(cfg_shengYiRuneLvAwark_hrl, true).

-record(shengYiRuneLvAwarkCfg, {
	%% 圣翼等级
	%% 同【ShengYiBaseUnlock_1_圣翼解锁】SyLevel
	syLevel,
	%% 全部符文等级
	%% 只算当前圣翼等级的
	runeLv,
	%% 索引
	index,
	%% 奖励属性
	%% (属性ID，属性值)
	%% 叠加
	attrAward
}).

-endif.
