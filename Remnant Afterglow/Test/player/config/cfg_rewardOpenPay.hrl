-ifndef(cfg_rewardOpenPay_hrl).
-define(cfg_rewardOpenPay_hrl, true).

-record(rewardOpenPayCfg, {
	%% ID
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
	%% 需要显示“额外”标签的位置（从左至右一次123456...）
	show,
	%% 购买方式
	%% 1、货币
	%% 2、直购
	%% 3、免费
	type,
	%% 货币价格
	%% （货币ID，数量）
	currType,
	%% 直购价格
	%% 直购商品ID
	%% 商品ID：
	%% CARNIVALBUY_序号
	%% CARNIVALBUY_1
	%% CARNIVALBUY_2
	%% …
	directPurchase,
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
	%% 条件枚举同商城表：ConditionType【ShopMallNew】的枚举保持一致
	%% 0.代表无需条件
	%% 1.玩家等级，参数=对应等级
	%% 2、vip等级，参数=对应等级
	%% ….详见商城表
	conditionType,
	%% 可显示条件
	%% （条件，参数）
	%% 条件枚举同商城表：ShowType【ShopMallNew】的枚举保持一致
	%% 0.代表无需条件
	%% 1.玩家等级，参数=对应等级
	%% 2、vip等级，参数=对应等级
	%% 2、vip等级，参数=对应等级
	%% ….详见商城表
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
	redDot,
	%% 显示必买标签
	%% 1、有
	%% 0、无
	mustBuyLabel
}).

-endif.
