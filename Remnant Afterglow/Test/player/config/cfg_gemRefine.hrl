-ifndef(cfg_gemRefine_hrl).
-define(cfg_gemRefine_hrl, true).

-record(gemRefineCfg, {
	%% 宝石精炼分类
	%% 1为攻击
	%% 2为防御
	iD,
	%% 精炼等级
	lv,
	%% 索引
	index,
	%% 升级下一级需要exp
	needExp,
	%% 提升单件装备上所有宝石总属性万分比
	percent,
	%% 宝石精炼提升基础属性
	%% (属性id，数量)
	attribute
}).

-endif.
