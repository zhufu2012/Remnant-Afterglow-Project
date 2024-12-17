-ifndef(cfg_mntSkillMkCostNew_hrl).
-define(cfg_mntSkillMkCostNew_hrl, true).

-record(mntSkillMkCostNewCfg, {
	%% 锁定格子数
	iD,
	%% 打造所需道具ID，数量
	needItem,
	%% 打造所需货币ID，数量
	needCoin
}).

-endif.
