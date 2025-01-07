-ifndef(cfg_dungeon_Team).
-define(cfg_dungeon_Team, 1).

-record(dungeon_TeamCfg, {
	%% 作者:
	%% 推图id
	teamDungeon_Id,
	%% 作者:
	%% String字段
	nameInfo_String,
	%% 作者:
	%% 组队副本名称
	teamDungeon_Name,
	%% 作者:
	%% 组队副本开启需要通过的主线关卡ID
	open_SceneID,
	%% 作者:
	%% 组队副本开启需要通过的组队副本ID
	open_TeamDungeonId,
	%% 作者:
	%% 关卡地图ID
	teamDungeon_SceneID,
	%% 作者:
	%% 通关消耗次数
	costTimes,
	%% 作者:
	%% 挑战推荐战力显示
	recommend_battlepoint,
	%% 关卡图标模型
	model,
	%% 奖励显示道具
	item
}).

-endif.
