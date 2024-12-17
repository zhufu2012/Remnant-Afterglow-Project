-ifndef(cfg_wingEquip_hrl).
-define(cfg_wingEquip_hrl, true).

-record(wingEquipCfg, {
	%% 装备ID
	iD,
	%% 部件1面甲，2座鞍，3脚蹬，4铁蹄
	part,
	%% 穿戴需要兽灵等级
	lvLimit,
	%% 品质
	quality,
	%% 攻防类型1攻击2防御
	type,
	%% 基础属性
	attribute,
	%% 基础属性评分值
	score,
	%% 卓越属性品质按个数配置
	%% {卓越品质1|卓越品质2|卓越品质3}
	%% 卓越属性1：1
	%% 卓越属性2：2
	%% 卓越属性3：3
	starRule,
	%% 卓越属性1随机属性库
	%% {属性id，值，品质，评分值，权重值}
	%% 属性ID为0时表示该次随机没有获得极品属性
	%% 随机属性不能重复，剩余的属性按各自权重再次随机
	%% 品质0白1蓝2紫3橙4红5龙6神7龙神
	starAttribute1,
	%% 卓越属性1随机属性库
	%% {属性id，值，品质，评分值，权重值}
	%% 属性ID为0时表示该次随机没有获得极品属性
	%% 随机属性不能重复，剩余的属性按各自权重再次随机
	%% 品质0白1蓝2紫3橙4红5龙6神7龙神
	starAttribute2,
	%% 卓越属性1随机属性库
	%% {属性id，值，品质，评分值，权重值}
	%% 属性ID为0时表示该次随机没有获得极品属性
	%% 随机属性不能重复，剩余的属性按各自权重再次随机
	%% 品质0白1蓝2紫3橙4红5龙6神7龙神
	starAttribute3,
	%% StarScore对应StarAttribute中的属性
	%% 评分ID
	starScore1,
	%% StarScore对应StarAttribute中的属性
	%% 评分ID
	starScore2,
	%% StarScore对应StarAttribute中的属性
	%% 评分ID
	starScore3
}).

-endif.
