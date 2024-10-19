-ifndef(cfg_manorWar_hrl).
-define(cfg_manorWar_hrl, true).

-record(manorWarCfg, {
	%% 作者:
	%% 领地ID
	iD,
	%% 作者:
	%% 刷怪。例如：{怪物id,怪物x坐标,怪物z坐标,朝向}|{怪物id,怪物x坐标,怪物z坐标,朝向}
	monster,
	%% 作者:
	%% 领地分级
	%% 3级最高
	%% 2级中等
	%% 1级最低
	level,
	%% 作者:
	%% 领地地图
	mapID,
	%% 作者:
	%% {连接该领地的高一级的领地ID，征战营地的triggerid}
	connect1,
	%% 作者:
	%% 连接该领地的低一级的领地ID
	connect2,
	%% 作者:
	%% 领地名称
	name,
	%% 作者:
	%% 征战营地序列
	%% {征战营地1的Trigger ID，出生点X，出生点Y}|{征战营地2的Trigger ID，出生点X，出生点Y}|{征战营地3的Trigger ID，出生点X，出生点Y}|{征战营地4的Trigger ID，出生点X，出生点Y}|
	fightGround,
	%% 作者:
	%% 防守大营序列
	%% {防守大营的Trigger ID,出生点X，出生点Y}
	defendGround,
	%% 作者:
	%% 神柱序列
	%% {神柱1ID,积分}|{神柱2ID,积分}|{神柱3ID,积分}
	pillarId,
	%% 作者:
	%% 神柱位置
	%% {神柱1坐标（x,z,朝向）}|{神柱2坐标（x,z,朝向）}|{神柱3坐标（x,z,朝向）}
	pillar,
	%% 作者:
	%% {北城门id，城门摧毁后触发的triggerid}|{中城门id，城门摧毁后触发的triggerid}|{南城门id，城门摧毁后触发的triggerid}
	doorId,
	%% 作者:
	%% 城门序列
	%% {北城门坐标X，坐标z，朝向}|{中城门坐标X，坐标z，朝向}|{南城门坐标X，坐标z，朝向}
	door,
	%% 作者:
	%% 可宣战数量（宣战名额）
	challengeNum,
	%% 作者:
	%% 积分获得值
	%% 时间积分|杀人积分|伤害积分|伤害单位值
	%% 总积分=时间积分*时间段+杀人积分*杀人数+伤害积分*伤害总量/伤害单位值
	%% 时间配在全局表：ManorWarScoreTime
	getScore,
	%% 作者:
	%% 基础经验
	%% 获得经验间隔与积分时间获得间隔相同
	%% 每次获得经验=基础经验*开服天数对应等级OpenDayLv[teamBase]
	%% 若找不到开服天数对应配置 则取最后一条数据
	expBase,
	%% 作者:
	%% 领地界面图标
	iconShow,
	%% 安全区域配置
	%% [{标识triggerid，安全区名称，安全区异地图传送triggerid（复活点变化后传送点相应改变）}]
	triggerName,
	%% 作者:
	%% 防守方城门传送triggerid
	doorTeleportId,
	%% 作者:
	%% 神柱和城门的加血范围
	%% 配置方式：{神柱或城门id，中心X坐标，中心z坐标，矩形x轴size的一半，矩形z轴size的一半}
	range,
	%% 作者:
	%% 征战营地加无敌buff区域
	%% {中心X坐标，中心z坐标，矩形x轴size的一半，矩形z轴size的一半}
	fightArea,
	%% 作者:
	%% 防守大营加无敌buff区域
	%% {中心X坐标，中心z坐标，矩形x轴size的一半，矩形z轴size的一半}
	defendArea
}).

-endif.
