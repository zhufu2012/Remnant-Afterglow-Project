-ifndef(cfg_newDungeonGrade_hrl).
-define(cfg_newDungeonGrade_hrl, true).

-record(newDungeonGradeCfg, {
	%% 【OB4】
	%% 难度序号
	iD,
	%% 最大难度
	mAX,
	%% 难度名称
	name,
	%% 初始章节
	chapterInitID,
	%% 最大章节
	chapterMAX,
	%% 难度开启条件-通关指定关卡
	%% 填0表示模式开启
	open
}).

-endif.
