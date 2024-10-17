-ifndef(cfg_promotionTypeH_hrl).
-define(cfg_promotionTypeH_hrl, true).

-record(promotionTypeHCfg, {
	iD,
	%% 作者:
	%% 天魔boss重生时间修正
	%% {mapID，boss顺序，重生时间修正比例}
	%% mapID：demon表中的ID字段填写才生效
	%% boss顺序：demon表中的MonsterBorn字段填写的boss顺序，填0表示该地图全部
	%% 重生时间修正比例：对demon表中的MonsterBorn字段填写的刷新时间进行修正，值为万分比；
	%% 例子：5000，表示boss重生时间间隔=原重生时间间隔*5000/10000，即重生时间减半
	timeReset,
	titleText,
	titleText_EN,
	%% 印尼
	titleText_IN,
	%% 泰语
	titleText_TH,
	desText,
	desText_EN,
	%% 印尼
	desText_IN,
	%% 泰语
	desText_TH
}).

-endif.
