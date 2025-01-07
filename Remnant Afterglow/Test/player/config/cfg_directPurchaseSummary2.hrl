-ifndef(cfg_directPurchaseSummary2_hrl).
-define(cfg_directPurchaseSummary2_hrl, true).

-record(directPurchaseSummary2Cfg, {
	%% 商品ID
	iD,
	%% 玩家等级区间
	%% （最小等级，最大等级）
	%% 区间取相等
	%% 最大等级填0，表示：直达目前游戏的最大等级
	lv,
	%% 礼包名称
	text,
	%% 英语
	text_EN,
	%% 印尼
	text_IN,
	%% 泰语
	text_TH,
	%% RU
	text_RU,
	%% FR
	text_FR,
	%% GE
	text_GE,
	%% TR
	text_TR,
	%% SP
	text_SP,
	%% PT
	text_PT,
	%% KR
	text_KR,
	%% TW
	text_TW,
	%% JP
	text_JP,
	%% 作者:
	%% 奖励物品
	%% {序号，职业，类型，ID，数量，品质，星级，是否绑定，是否显示转圈特效是否装备}
	%% 序号，从1开始，选择性，序号填不一样的
	%% 职业:
	%% 类型1=道具，ID=道具ID；
	%% 类型2=货币，ID=货币ID
	%% 类型3=装备，ID=装备ID
	%% 品质、星级：对应装备的品质和星级，其他类型无效
	%% 是否绑定：0.非绑  1.绑定
	%% 是否显示转圈特效：1.显示  0.不显示
	%% 注：显示的前后顺序，按照配置的顺序，第一个道具会额外加大显示
	%% 做好后“coin、item”两字字段删除
	itemNew,
	%% 货币价格
	%% （货币ID，数量）
	%% 货币消耗或者直购商品ID只能配置其中一个
	%% CurrType、DirectPurchase两个字段都配置为0时，表示免费领取
	%% 免费时的红点穿透到外层入口和各个标签、对应商品上，不受到RedDot字段配置影响
	currType,
	%% 直购价格
	%% 直购商品ID
	%% 货币消耗或者直购商品ID只能配置其中一个
	%% 直购1商品ID：
	%% DPSUMMARY_序号
	%% DPSUMMARY_1
	%% DPSUMMARY_2
	%% …
	%% CurrType、DirectPurchase两个字段都配置为0时，表示免费领取
	%% 免费时的红点穿透到外层入口和各个标签、对应商品上，不受到RedDot字段配置影响
	directPurchase,
	%% 2022/1/7改为：
	%% 折扣参数万分比
	%% 1000，表示1折，90%off
	%% 1500，表示1.5折，85%off
	%% 10000，表示：不显示折扣
	discount,
	%% (类型，参数1，参数2）
	%% 填0：表示不限购
	%% 类型1：个人每日限购，参数1=限购次数，参数2=0；
	%% 类型2：个人活动期间限购，参数1=限购次数，参数2=0；
	limit,
	%% 可购买条件
	%% （条件，参数）
	%% 0.代表无需条件
	%% 1.玩家等级，参数=对应等级
	%% 2、vip等级，参数=对应等级
	conditionType,
	%% 可显示条件
	%% （条件，参数）
	%% 0.代表无需条件
	%% 1.玩家等级，参数=对应等级
	%% 2、vip等级，参数=对应等级
	showType,
	%% 限购内容品质
	%% 1：低品质
	%% 2：中品质
	%% 3：高品质
	character,
	%% 购买后是否公告
	notice,
	%% 商品是否有登录红点
	%% 1、有
	%% 0、无
	%% CurrType、DirectPurchase两个字段都配置为0时，表示免费领取
	%% 免费时的红点穿透到外层入口和各个标签、对应商品上，不受到RedDot字段配置影响
	redDot,
	%% 显示必买标签
	%% 1、有
	%% 0、无
	mustBuyLabel
}).

-endif.
