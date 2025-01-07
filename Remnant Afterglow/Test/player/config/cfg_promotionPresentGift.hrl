-ifndef(cfg_promotionPresentGift_hrl).
-define(cfg_promotionPresentGift_hrl, true).

-record(promotionPresentGiftCfg, {
	iD,
	%% 进度顺序
	num,
	%% 索引
	index,
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
	currType,
	%% 直购价格
	%% 直购商品ID
	%% 货币消耗或者直购商品ID只能配置其中一个
	directPurchase,
	%% 原价
	%% 直接配置原价价格（钻石与直购，钻石填钻石原价，直购填直购价格*100）
	discount,
	%% 礼包模型配置（ID，缩放比例）
	%% ID：0~5：预设好的宝箱模型，0钻石宝箱，1黄金宝箱，2白银宝箱，3青铜宝箱，4青色书本，5绿色书本
	%% ·10以上视为道具ID ，只能填写带模型的道具ID
	%%  ·根据道具id查找item表对应类型，显示对应的模型 
	%% ·如果没有找到模型，则默认显示ID为0的模型
	%% 缩放比例：100描述缩放为100%
	modelShow,
	%% 购买后是否公告
	notice
}).

-endif.
