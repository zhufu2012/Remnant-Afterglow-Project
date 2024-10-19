-ifndef(cfg_expediIllustrType_hrl).
-define(cfg_expediIllustrType_hrl, true).

-record(expediIllustrTypeCfg, {
	%% 图鉴类型
	%% 1.星座；
	%% 2.建筑；
	%% 3.首领；
	%% 4.资源；
	%% 5.爵位
	iD,
	%% 名字
	%% （texts索引：ExpediIllustrType1,…）
	name,
	%% 图鉴类型中的图鉴
	expediIllustrId
}).

-endif.
