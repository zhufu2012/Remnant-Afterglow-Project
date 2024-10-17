-ifndef(cfg_yunyingMonster_hrl).
-define(cfg_yunyingMonster_hrl, true).

-record(yunyingMonsterCfg, {
	%% 地图id
	iD,
	%% 序号
	num,
	%% 索引
	index,
	%% 触发类型1          
	%%  活动正式开始后指定时间刷（准备时间不算，秒）             
	%% 第一波刷完后，服务器维持怪物数量和种类总数不变，既杀了一个怪后这个怪物一定时间内重生。
	bornType,
	%% 触发参数：(触发参数)          
	%% 触发类型1                         指定时间（秒）        
	%% 触发类型2                          0
	born,
	%% 地图刷怪序号，ID，复活时间
	%% (怪物序号,怪物ID,复活时间秒）
	monster,
	%% 刷怪坐标
	%% (怪物序号,X坐标,Z坐标,朝向)
	monsterBorn,
	%% 怪物属性参数(依次找到符合要求的配置)
	%% 格式：
	%% (序号,优先级,怪物类型,区分序号,等级方式,等级参数,属性列,特殊情况)
	%% 序号：怪物序号,0为全部
	%% 优先级：
	%% 怪物类型：0为全部,1为小怪,2为精英
	%% 区分序号：区分同类怪物；0为全部,大于0为区分序号
	%% 等级方式：确定怪物等级获取方式
	%% 0为固定,怪物等级='等级参数'
	%% 1为等同玩家等级,
	%% 怪物等级=（玩家等级/'等级参数'）{向下取整}*'等级参数'
	%% 2为世界等级,怪物等级=世界等级；3为传输等级
	%% 属性列号：对应取第几种属性列
	%% 字段HpFold,AttrBase[MonsterAttr]
	%% 特殊情况：0为没有；1为按某玩家生成一份怪物'属性',其他玩家生成一份怪物'生命值'叠加到怪物上；2为组队进入副本中时，按照等级最高的玩家来对应生成怪物属性
	monsterAttr,
	%% (序号,怪物类型,区分序号,经验等级获取方式,等级参数,经验列)
	%% 序号：该功能为刷怪波数，0为全部波数,大于0为对应波数
	%% 怪物类型：0为全部,1为小怪,2为精英
	%% 区分序号：区分同类怪物；0为全部,大于0为区分序号
	%% 经验等级获取方式:0固定等级,等级参数：等级
	%% 经验等级获取方式:1读取怪物等级，等级参数：填“0”（系统自动判断怪物等级）
	%% 经验等级获取方式:2读取玩家等级，等级参数：填“0”（系统自动判断玩家等级）
	%% 经验列：读取[MonsterExp表]中字段Exp1/Exp2/Exp3…
	%%   经验列1表示：Exp1[MonsterExp表]
	%%   经验列2表示：Exp2[MonsterExp表]
	%%   …
	monsterExp
}).

-endif.