-ifndef(cfg_dHallowsCombLv_hrl).
-define(cfg_dHallowsCombLv_hrl, true).

-record(dHallowsCombLvCfg, {
	%% 转数
	syLevel,
	%% 全身圣印最低等级（该转职可镶嵌的所有圣印）
	runeLv,
	%% 索引
	index,
	%% 奖励属性
	%% (属性ID，属性值)
	%% 填达成单次等级目标的奖励
	attrAward
}).

-endif.
