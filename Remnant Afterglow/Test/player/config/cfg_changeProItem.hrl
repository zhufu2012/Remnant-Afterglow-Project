-ifndef(cfg_changeProItem_hrl).
-define(cfg_changeProItem_hrl, true).

-record(changeProItemCfg, {
	%% 原职业
	proNow,
	%% 新职业
	proNew,
	%% 原道具
	itemNow,
	%% 索引
	index,
	%% 道具类型
	%% 1、装备
	%% 2、神兵装备（纵思）
	%% 3、套装水晶
	%% 4、神兵（道具）
	%% 5、古神装
	itemType,
	%% 新道具
	itemNew
}).

-endif.
