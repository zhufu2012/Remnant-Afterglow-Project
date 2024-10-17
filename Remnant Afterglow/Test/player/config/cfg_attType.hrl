-ifndef(cfg_attType_hrl).
-define(cfg_attType_hrl, true).

-record(attTypeCfg, {
	%% 属性ID
	iD,
	%% 标签
	%% 1玩家属性：属性与玩家绑定，对玩家整体生效，多为经济类属性如经验加成
	%% 2角色属性：属性与角色绑定，只对目标角色生效，多为战斗类属性如攻击
	tYPE1
}).

-endif.
