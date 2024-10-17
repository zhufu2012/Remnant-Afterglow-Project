-ifndef(cfg_dHallowsCombAwark_hrl).
-define(cfg_dHallowsCombAwark_hrl, true).

-record(dHallowsCombAwarkCfg, {
	%% 圣物转数
	syLevel,
	%% 组合编号
	combOrder,
	%% 索引
	index,
	%% 组合条件
	%% (品质，数量）
	%% 多个条件需同时达成
	%% 只算当前转职
	combQuality,
	%% 奖励属性
	%% (属性ID，属性值)填对应单个奖励达成后的属性
	attrAward,
	%% 奖励技能
	%% (技能类型1,ID1,学习位1)
	%% 技能类型：1为技能(skillBase)
	%% 2为技能修正(SkillCorr)
	%% 学习位：为0时不可直接获得
	skill
}).

-endif.
