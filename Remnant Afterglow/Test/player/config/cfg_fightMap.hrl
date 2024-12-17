-ifndef(cfg_fightMap_hrl).
-define(cfg_fightMap_hrl, true).

-record(fightMapCfg, {
	%% 没有实际意义
	iD,
	%% 区域ID，天龙积分区，圆心位置x，圆心位置z，半径（米）
	%% ID1天龙
	%% ID2凤凰
	%% ID3麒麟
	areaDragon,
	%% 据点id,无人占领的天龙特效
	%% 特效填的是地图文件里的机关门id
	dragonVFX,
	%% {据点id,蓝方占领进度1,蓝方占领进度2,蓝方占领进度3,蓝方占领进度4,蓝方占领进度5,蓝方占领进度6,蓝方占领进度7,蓝方占领进度8,黄方占领进度1,黄方占领进度2,黄方占领进度3,黄方占领进度4,黄方占领进度5,黄方占领进度6,黄方占领进度7,黄方占领进度8}
	%% 特效填的是地图文件里的机关门id
	occupyVFX,
	%% 三个据点的ID，名字
	nameString,
	%% buff球id|活动开始后第一次刷出的时间（秒）|之后刷新间隔时间（秒）
	buffObject1,
	%% BuffObject1配置的buff球刷新的位置。有几个位置刷几个。
	position1,
	%% buff球id|活动开始后第一次刷出的时间（秒）|之后刷新间隔时间（秒）
	buffObject2,
	%% BuffObject1配置的buff球刷新的位置。有几个位置刷几个。
	position2,
	%% 准备时间结束，正式开始时激活的客户端trigger，包括了传送trigger，传送特效，机关门，箭头特效，彩虹桥特效
	activeTrigger,
	%% {蓝队路点id}|{黄队路点id}用来标识跟踪地图上的蓝队黄队标识位置
	teamPoint
}).

-endif.
