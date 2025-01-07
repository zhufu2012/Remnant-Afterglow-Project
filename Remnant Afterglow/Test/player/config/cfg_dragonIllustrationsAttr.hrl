-ifndef(cfg_dragonIllustrationsAttr_hrl).
-define(cfg_dragonIllustrationsAttr_hrl, true).

-record(dragonIllustrationsAttrCfg, {
	%% 奖励序号
	iD,
	%% 点亮所需彩星数量
	%% （星级为BattleType=2，3的主线副本获得的星级）
	needColorStar,
	%% 属性奖励
	%% (属性ID，属性值)
	%% 填单级属性，每次获得的属性值
	attr,
	%% ICON上的展示文字ID
	title
}).

-endif.
