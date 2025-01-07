-ifndef(cfg_expediIllustrBase_hrl).
-define(cfg_expediIllustrBase_hrl, true).

-record(expediIllustrBaseCfg, {
	%% 图鉴id
	iD,
	%% 名字
	%% （texts索引：IllustrationsName1,…）
	name,
	%% 图鉴类型
	%% 1.星座；
	%% 2.城池；
	%% 3.首领；
	%% 4.资源；
	%% 5.爵位
	illustrType,
	%% 稀有度
	%% 0为A
	%% 1为S
	%% 2为SS
	%% 3为SSS
	rareType,
	%% 吞噬经验
	devourExp,
	%% 激活消耗
	%% (碎片道具ID,数量)
	needItem,
	%% 激活奖励属性
	%% (属性ID，属性值)
	attribute,
	%% 显示条件
	%% （组号，条件，参数）
	%% 组号：组号相同的条件需要同时满足，组号不同的条件满足其中一组就行。
	%% 条件1：远征阶段，参数=阶段；
	%% 条件2：开启赛季，参数=赛季
	%% 填0：表示默认显示
	conditionStage
}).

-endif.
