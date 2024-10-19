-ifndef(cfg_dungeon_Teleport_hrl).
-define(cfg_dungeon_Teleport_hrl, true).

-record(dungeon_TeleportCfg, {
	%% 机关ID
	iD,
	%% 传送门是否显示名字
	%% 0不显示
	%% 1显示
	showName,
	%% 名称的stringid
	namestring,
	%% 机关名称
	name,
	%% 0普通门(同地图大圣麒麟洞遗留）
	%% 1进密室门(同地图大圣麒麟洞遗留）
	%% 2出密室门(同地图大圣麒麟洞遗留）
	%% 3同地图传送门
	%% 4不同地图传送门
	type,
	%% 半径:
	%% 触发半径
	range,
	%% 模型
	model,
	%% 传送门出现特效(这个可以是持续特效，开始后一直循环)
	bornEffect,
	%% 传送门结束特效
	dieEffect,
	%% 模型缩放
	scale,
	%% 传送门刷出后最多存在的时间（毫秒）。
	%% 0代表不消失
	time,
	%% 目标地图ID
	%% 同地图传送则填0
	targetMap,
	%% 使用传送阵的最小等级。0代表无限制
	lVmin,
	%% 传送位置
	teleportPosition,
	%% 传送门名字高度（米）
	namePositionY
}).

-endif.
