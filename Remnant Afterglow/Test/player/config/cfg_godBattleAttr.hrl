-ifndef(cfg_godBattleAttr_hrl).
-define(cfg_godBattleAttr_hrl, true).

-record(godBattleAttrCfg, {
	%% 外显类型
	%% 1坐骑
	%% 2魔宠
	%% 3翅膀
	%% 4圣物
	%% 5主龙神
	%% 6精灵龙
	%% 7神兵
	type,
	%% 外显品质
	%% 0-所有
	%% 大于0-对应系统的品质值+1
	quality,
	%% 索引
	index,
	%% 每1星级加成的属性万分比
	%% （属性ID,单星加成万分比,加成方式)
	%% 加成方式：1加值,2加比例
	%% 对玩家进入地图时的总属性进行加成
	%% 只算激活的外显
	%% 加成的属性只在神力战场中生效
	%% 龙神提供的星级需+1（因为激活后初始是0星）
	%% 神兵加成由“升阶”提供
	battleAttr
}).

-endif.
