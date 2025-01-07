-ifndef(cfg_grade_promotion_hrl).
-define(cfg_grade_promotion_hrl, true).

-record(grade_promotionCfg, {
	%% 序号
	iD,
	%% 功能ID
	functionID,
	title,
	%% 文字描述
	sDesc
}).

-endif.
