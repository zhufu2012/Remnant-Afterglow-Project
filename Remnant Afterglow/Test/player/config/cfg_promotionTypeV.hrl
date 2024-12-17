-ifndef(cfg_promotionTypeV_hrl).
-define(cfg_promotionTypeV_hrl, true).

-record(promotionTypeVCfg, {
	%% ID
	iD,
	%% 基础重置次数
	resetNum,
	%% 活动描述
	resetText,
	%% 活动描述
	resetText_EN,
	%% 印尼
	resetText_IN,
	%% 泰语
	resetText_TH
}).

-endif.
