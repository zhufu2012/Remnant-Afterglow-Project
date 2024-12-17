-ifndef(cfg_taskChapter_hrl).
-define(cfg_taskChapter_hrl, true).

-record(taskChapterCfg, {
	%% 作者:
	%% 翅膀ID
	iD,
	%% 作者:
	%% 章节名称，读取text表
	chaptername,
	%% 章节效果界面的章节描述
	chapterslogan,
	%% 作者:
	%% 章节描述
	chaptedescriber,
	%% 作者:
	%% 章节属性奖励（主角属性）
	%% {属性ID，属性值}
	rewardattri,
	%% 作者:
	%% 章节内任务数量
	number
}).

-endif.
