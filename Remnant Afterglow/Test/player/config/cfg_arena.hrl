-ifndef(cfg_arena_hrl).
-define(cfg_arena_hrl, true).

-record(arenaCfg, {
	%% 榜单类型
	%% 1：10-19级
	%% 2：20-39级
	%% 3：40-59级
	%% 4：60-79级
	%% 5：80-99级
	%% 6：100级
	iD,
	%% 排名
	%% 0代表挑战BOSS配置
	rank,
	%% 客户端索引
	index,
	%% 调用副本ID
	dungeonID,
	%% 排名突破奖励
	%% {类型，id，数量}
	%% 1类型为货币
	%% 2类型为一般道具
	%% 货币：
	%% 0为元宝 Gold
	%% 1为铜币 Money
	%% 2为魂玉 SoulValue
	%% 3为声望 Reputation
	%% 4为荣誉 Honor
	%% 5为战魂 WarSpirit
	%% 6为铸魂 EquipSoul
	%% 7为帮会贡献值 GangCont
	%% 8为神器 ArtiSoul
	proAward,
	%% 每日22点结算奖励
	%% {等级，类型，id，数量}
	%% RANK=0时为无排名奖励
	%% 等级=1时，代表1级以上玩家可获得的奖励；等级=360时，代表360级以上的玩家可以额外获得的奖励
	%% 1类型为货币
	%% 2类型为一般道具
	%% 0为元宝 Gold
	%% 1为铜币 Money
	%% 2为魂玉 SoulValue
	%% 3为声望 Reputation
	%% 4为荣誉 Honor
	%% 5为战魂 WarSpirit
	%% 6为铸魂 EquipSoul
	%% 7为帮会贡献值 GangCont
	%% 8为神器 ArtiSoul
	dayAward,
	%% 调用怪物ID
	monsterID,
	%% 怪物参数
	%% (怪物ID,显示等级)
	monsterPara,
	%% 怪物属性参数(依次找到符合要求的配置)
	%% 格式：
	%% (序号,优先级,怪物类型,区分序号,等级方式,等级参数,属性列,特殊情况)
	%% 序号：0为全部
	%% 优先级：0为全部
	%% 怪物类型：0为全部,1为小怪,2为精英
	%% 区分序号：区分同类怪物；0为全部,大于0为区分序号
	%% 等级方式：确定怪物等级获取方式
	%% 0为固定,怪物等级='等级参数'
	%% 1为等同玩家等级,
	%% 怪物等级=（玩家等级/'等级参数'）{向下取整}*'等级参数'
	%% 属性列号：对应取第几种属性列
	%% 字段HpFold,AttrBase[MonsterAttr]
	%% 特殊情况：0为没有
	monsterAttr
}).

-endif.
