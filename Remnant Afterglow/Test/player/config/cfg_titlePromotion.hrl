-ifndef(cfg_titlePromotion_hrl).
-define(cfg_titlePromotion_hrl, true).

-record(titlePromotionCfg, {
	%% 职业ID
	%% 职业1004为战士，1005为魔法师，1006为弓箭手
	iD,
	%% 头衔等级
	strengthLv,
	%% 索引
	index,
	%% 名字
	name,
	%% 最大头衔等级
	maxLv,
	%% 头衔icon
	headPic,
	%% 到下一级消耗道具
	%% {道具id，数量}
	consumeItem,
	%% 提升战力需求
	power,
	%% 当前等级附带属性
	%% {属性id，数量}
	attribute,
	%% 头衔文字颜色
	%% 第一个是字体自身颜色
	%% 第二个是字体外发光的颜色
	%% （仅全球版使用）
	color
}).

-endif.
