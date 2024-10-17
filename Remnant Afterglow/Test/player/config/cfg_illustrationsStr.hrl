-ifndef(cfg_illustrationsStr_hrl).
-define(cfg_illustrationsStr_hrl, true).

-record(illustrationsStrCfg, {
	%% 图鉴id
	iD,
	%% 星数
	%% 注1:初始星数由base表控制
	star,
	%% 最大星数
	starMax,
	%% 激活/升星消耗
	%% (碎片ID,数量)
	%% 注1:初始星数对应的这条数据，表示该图鉴激活所需，后面的为升星所需
	%% 注2:不累加
	needItem,
	%% 属性(属性ID，属性值)
	%% 注1:初始星数对应的这条数据，表示该图鉴的初始属性，后面的为升星属性
	%% 注2：属性不累加
	attribute,
	%% 特殊属性
	%% 属性(属性ID，属性值)
	%% 注1:初始星数对应的这条数据，表示该图鉴的初始属性，后面的为升星属性
	%% 注2：属性不累加
	specialAttribute,
	%% 提升系统中需要用到的评价该系统养成进度的依据值
	evaluate
}).

-endif.
