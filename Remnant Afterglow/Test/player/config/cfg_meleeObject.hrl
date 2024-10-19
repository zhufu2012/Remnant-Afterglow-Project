-ifndef(cfg_meleeObject_hrl).
-define(cfg_meleeObject_hrl, true).

-record(meleeObjectCfg, {
	%% 作者:
	%% ID
	iD,
	%% 作者:
	%% 活动开启后时间，秒
	activeTime,
	%% 作者:
	%% 本波刷的类型
	%% 1刷buff球(这个类型只保留最后一波，刷新波的时候删掉上波）
	%% 2刷宝箱
	%% 3刷任意门
	%% 4密室刷buff球(这个类型只保留最后一波，刷新波的时候删掉上波）
	%% 5密室刷宝箱(这个类型只保留最后一波，刷新波的时候删掉上波）
	%% 6刷怪
	%% 7密室里刷出来的门（这个类型不公告）
	type,
	%% 作者:
	%% 刷的数量.
	%% {在组1随机的数量，在组2随机的数量，在组3随机的数量}
	nUM,
	%% 作者:
	%% 刷东西的位置随机组1，不会重复选出
	position1,
	%% 作者:
	%% 刷东西的位置随机组2，不会重复选出
	position2,
	%% 作者:
	%% 刷东西的位置随机组3，不会重复选出
	position3,
	%% 作者:
	%% 特殊组队buff球id或者密室门id
	%% 这里为0时不刷特殊组物体.也不累积概率
	specialBuffObject,
	%% 作者:
	%% 好的buff或者传送门随机库。不会重复选出
	%% {这个库占总数百分比}|{随机库里的buff球/传送门}
	%% ----------------------------------------
	%% 概率乘以总数后向上取整
	goodBuffObject,
	%% 作者:
	%% 坏的buff/传送门随机库。不会重复选出
	%% {这个库占总数百分比}|{随机库里的buff球/传送门}
	%% --------------------------------------------
	%% 这里的数量是总数-特殊组数量-好的组数量
	badBuffObject,
	%% 作者:
	%% 宝箱id
	collection,
	%% 作者:
	%% 怪物id
	monster,
	%% 怪物属性参数(依次找到符合要求的配置)
	%% 格式：
	%% (序号,优先级,怪物类型,区分序号,等级方式,等级参数,属性列,特殊情况)
	%% 序号：无实际意义
	%% 优先级：无实际意义
	%% 怪物类型：0为全部,1为小怪,2为精英
	%% 区分序号：区分同类怪物；0为全部,大于0为区分序号
	%% 等级方式：确定怪物等级获取方式
	%% 0为固定,怪物等级='等级参数'
	%% 1为等同玩家等级,
	%% 怪物等级=（玩家等级/'等级参数'）{向下取整}*'等级参数'
	%% 2为世界等级,怪物等级=max(世界等级,等级参数)；3为传输等级
	%% 属性列号：对应取第几种属性列
	%% 字段HpFold,AttrBase[MonsterAttr]
	%% 特殊情况：0为没有；1为按某玩家生成一份怪物'属性',其他玩家生成一份怪物'生命值'叠加到怪物上；2为组队进入副本中时，按照等级最高的玩家来对应生成怪物属性
	monsterAttr
}).

-endif.