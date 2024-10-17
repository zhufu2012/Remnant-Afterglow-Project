-ifndef(cfg_newGuideShow_hrl).
-define(cfg_newGuideShow_hrl, true).

-record(newGuideShowCfg, {
	%% MapAI
	iD,
	%% 玩法教程图
	battleGuideImage,
	%% 上方标题文字
	battleGuideTitleText,
	%% 玩法教程图中文字
	battleGuideText,
	%% 教程播出等级区间
	showGuideLV
}).

-endif.
