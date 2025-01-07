-ifndef(cfg_horcuxBase_hrl).
-define(cfg_horcuxBase_hrl, true).

-record(horcuxBaseCfg, {
	%% 魂器ID
	iD,
	%% 是否生效
	open,
	%% 名字
	name,
	%% 魂器激活条件
	%% （激活方式,参数2）
	%% 激活方式为1时根据功能开放，参数2为功能开启ID
	%% 激活方式为2时根据等级开放，参数2为等级
	openWay,
	%% 排序ID
	orderId
}).

-endif.
