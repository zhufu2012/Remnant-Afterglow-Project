-ifndef(cfg_subscribe_hrl).
-define(cfg_subscribe_hrl, true).

-record(subscribeCfg, {
	%% 特权ID1：订阅专属称号；Privilege参数：称号ID 
	%% 特权ID2：挂机经验；Privilege参数：ID【vipFun表】
	%% 特权ID3：极品装备掉落；Privilege参数：ID【vipFun表】
	%% 特权ID4：每日协助令牌获得上限；Privilege参数：获得上限增加值
	%% 特权ID5：卡片许愿和获得次数；Privilege参数：许愿和获得上限增加值
	%% 特权ID6：公会宝箱钻石上限增加值；Privilege参数：公会宝箱钻石上限增加值
	iD,
	%% 特权参数（30天的）
	%% 具体特权的文字信息配置在文字表
	privilege,
	%% 特权参数（90天的）
	%% 具体特权的文字信息配置在文字表
	privilege1
}).

-endif.
