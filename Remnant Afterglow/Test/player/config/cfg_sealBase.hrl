-ifndef(cfg_sealBase_hrl).
-define(cfg_sealBase_hrl, true).

-record(sealBaseCfg, {
	%% 封印次数id
	iD,
	%% 起始章节：
	%% 该封印阶段的起始章节
	startChapter,
	%% 完成章节：
	%% 任一玩家通关完成章节的最后一个关卡时触发，封印下一章节第一个主线副本
	sealChapter,
	%% 起始副本id
	startID,
	%% 结束副本id
	finishID,
	%% 封印时间：
	%% 触发封印到最近的凌晨0点为1天，到第二近的凌晨0点为2天
	sealTime,
	%% 本次封印总星数：
	%% 本封印阶段内的主线副本包含的总星数
	sealStars
}).

-endif.
