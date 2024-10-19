-ifndef(cfg_wingCopy1_hrl).
-define(cfg_wingCopy1_hrl, true).

-record(wingCopy1Cfg, {
	%% 翅膀副本ID
	iD,
	%% 翅膀副本名称
	name,
	%% 进入等级限制.
	%% 0表示无等级限制
	openLv,
	%% 前置副本ID
	%% 0表示无需前置副本通关.
	unlockCopy,
	%% 推荐战力
	battlePoint,
	%% 副本主界面奖励预览
	%% （物品ID，是否绑定）
	sealDungeonView,
	%% 出生点坐标
	%% (横坐标，纵坐标）
	bornPositon,
	%% 死亡复活时，消耗的能量
	revive
}).

-endif.
