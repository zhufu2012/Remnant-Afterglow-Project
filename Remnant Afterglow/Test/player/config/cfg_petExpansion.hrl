-ifndef(cfg_petExpansion_hrl).
-define(cfg_petExpansion_hrl, true).

-record(petExpansionCfg, {
	%% 装备阶段
	iD,
	%% 解锁条件
	%% （序号ID，参数1，参数2，参数3）
	%% 序号ID=1 装备需求：参数1=装备品质；参数2=装备星级；参数3=件数
	%% 序号ID=2 出战英雄需求： 参数1=英雄星数；参数2、3=0
	%% 填0为默认解锁
	unlock
}).

-endif.
