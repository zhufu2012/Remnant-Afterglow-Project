-ifndef(cfg_weaponReopenNew_hrl).
-define(cfg_weaponReopenNew_hrl, true).

-record(weaponReopenNewCfg, {
	%% 神兵id
	iD,
	%% 解封等级
	order,
	%% 索引
	index,
	%% 最大等级
	levelMax,
	%% 解封消耗
	%% (道具id，数量)
	%% 例：1级升2级，读取1级配置
	needItem,
	%% 解封属性
	%% (属性ID，属性值)
	reopenAttr,
	%% 是否开启变形
	isShape
}).

-endif.
