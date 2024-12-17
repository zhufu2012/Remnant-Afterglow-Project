-ifndef(cfg_petEquip_hrl).
-define(cfg_petEquip_hrl, true).

-record(petEquipCfg, {
	%% 装备ID
	iD,
	%% 部件1短刃，2铭牌，3头甲，4战盔
	part,
	%% 穿戴需要魔灵等级
	%% （删除）
	lvLimit,
	%% 品质
	%% 0白
	%% 1蓝
	%% 2紫
	%% 3橙
	%% 4红
	%% 5幻彩
	%% 6暗金
	%% 7炫彩
	quality,
	%% 星级
	star,
	%% 攻防类型1攻击2防御
	type,
	%% 基础属性
	attribute,
	%% 基础属性评分值
	score,
	%% 极品属性品质按个数配置
	%% {极品品质1|极品品质2|极品品质3}
	%% 极品属性1：1
	%% 极品属性2：2
	%% 极品属性3：3
	starRule,
	%% 极品属性1随机属性库
	%% {属性id，值，品质，评分值，权重值}
	%% 属性ID为0时表示该次随机没有获得极品属性
	%% 随机属性不能重复，剩余的属性按各自权重再次随机
	%% 品质0白1蓝2紫3橙4红5龙6神7龙神
	starAttribute1,
	%% 极品属性1随机属性库
	%% {属性id，值，品质，评分值，权重值}
	%% 属性ID为0时表示该次随机没有获得极品属性
	%% 随机属性不能重复，剩余的属性按各自权重再次随机
	%% 品质0白1蓝2紫3橙4红5龙6神7龙神
	starAttribute2,
	%% 极品属性1随机属性库
	%% {属性id，值，品质，评分值，权重值}
	%% 属性ID为0时表示该次随机没有获得极品属性
	%% 随机属性不能重复，剩余的属性按各自权重再次随机
	%% 品质0白1蓝2紫3橙4红5龙6神7龙神
	starAttribute3,
	%% StarScore对应StarAttribute中的属性
	starScore1,
	%% StarScore对应StarAttribute中的属性
	starScore2,
	%% StarScore对应StarAttribute中的属性
	starScore3
}).

-endif.
