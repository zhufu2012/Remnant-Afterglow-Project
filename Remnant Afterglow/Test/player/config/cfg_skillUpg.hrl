-ifndef(cfg_skillUpg_hrl).
-define(cfg_skillUpg_hrl, true).

-record(skillUpgCfg, {
	%% 作者:
	%% 技能等级
	iD,
	%% 技能学习位
	%% 1为普攻
	%% 3-6为基础技能
	seat,
	%% 作者:
	%% 客户端索引
	index,
	%% 作者:
	%% 升至下一级
	%% 所需玩家等级
	needLv,
	%% 作者:
	%% 技能最大等级
	maxLv,
	%% 作者:
	%% 职业技能消耗
	%% (职业,货币类型,货币数量)
	charaCons,
	%% 作者:
	%% 附加属性
	%% (附加属性ID，附加值)
	attribute
}).

-endif.
