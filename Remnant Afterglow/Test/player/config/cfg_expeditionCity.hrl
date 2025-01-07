-ifndef(cfg_expeditionCity_hrl).
-define(cfg_expeditionCity_hrl, true).

-record(expeditionCityCfg, {
	%% 城池编号
	%% 与地图机关设置同步
	iD,
	%% 远征阶段
	stage,
	%% 城池名字
	name,
	%% 城池类型
	%% 1领地
	%% 2要塞
	%% 3堡垒
	%% 4基地
	%% 5城墙
	%% 6皇城
	%% 7浮空岛（强阵营玩法）
	%% 普通战开1-4
	%% 皇城战开5-6
	city,
	%% 城池地图
	mapID,
	%% 联通城池编号
	connectCity,
	%% 赛季初始所属阵营
	%% 1红色
	%% 2蓝色
	%% 3绿色
	%% 0中立（无阵营）
	initCamp,
	%% 能否争夺
	%% 0不可争夺
	%% 1可争夺
	canFight,
	%% 城池位置-缩略图
	%% （x位移,y位移）
	cityPosi,
	%% 玩家单挑地图
	%% 城战
	pKMapID,
	%% 巨魔地图
	monsMapID,
	%% 能否探险
	%% 0不可探险
	%% 1可探险
	canExplore,
	%% 玩家单挑地图
	%% 探险
	ePKMapID,
	%% 城池所属区域-地图分区
	%% 1风灵,2陨石,3雷暴
	%% 填0表示无限弱阵营判断
	%% 区域名：
	%% ExpeditionArea+编号
	areaID
}).

-endif.
