-ifndef(cfg_shengYiRest_hrl).
-define(cfg_shengYiRest_hrl, true).

-record(shengYiRestCfg, {
	%% 攻方圣翼类型
	%% 1恶魔2天使3古龙
	%% 同圣翼解锁类型【ShengYiUnlock_1_圣翼解锁】SyType
	%% 该配置废弃，采用地图buff实现【StarrySkyRuins】ShengYiBuff
	syTypeAtt,
	%% 防方圣翼类型
	syTypeDef,
	%% 索引
	index,
	%% 攻方属性加成
	attrAtt,
	%% 防方属性加成
	attrDef
}).

-endif.
