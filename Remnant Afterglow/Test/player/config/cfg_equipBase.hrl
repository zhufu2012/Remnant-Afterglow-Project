-ifndef(cfg_equipBase_hrl).
-define(cfg_equipBase_hrl, true).

-record(equipBaseCfg, {
	%% Demo临时使用
	iD,
	%% 职业1004为战士，1005为魔法师，1006为弓箭手
	occupation,
	%% 角色穿戴最低等级要求
	lvLimit,
	%% 穿戴转职数要求
	%% （D3无转职需求，只用等级需求。等级转化为X转X级）
	changeRole,
	%% 部位
	%% 1为武器，2为项链，3为护手，4为戒指，5衣服，6头盔，7肩甲，14鞋子，9裤子，10护符，11背饰
	part,
	%% 装备阶数
	order,
	%% 装备类别
	%% 读到0则为无任何套装
	%% 读到1则为特殊套装
	%% 2,3及其之后的就是正常套装
	equipType,
	%% 模型ID
	%% 填写Model表中的ID
	model,
	modelBaseName,
	lowModel,
	%% 品质和星级对应极品属性规则
	%% {装备品质，星级，属性品质库id，属性品质库id，属性品质库id}
	%% 装备品质：0白 1蓝 2紫 3橙 4红 5龙 6神 7龙神
	%% 多个规则用|隔开
	starRule,
	%% 神装和龙神品质和星级对应额外极品属性规则
	%% {装备品质，星级，属性品质库id}
	%% 装备品质：0白 1蓝 2紫 3橙 4红 5龙 6神  7、龙神
	%% 多个规则用|隔开
	starRule1,
	%% 白色基础属性
	%% {属性id，值}
	baseAttribute0,
	%% 蓝色基础属性
	%% {属性id，值}
	baseAttribute1,
	%% 紫色基础属性
	%% {属性id，值}
	baseAttribute2,
	%% 橙色基础属性
	%% {属性id，值}
	baseAttribute3,
	%% 红色基础属性
	%% {属性id，值}
	baseAttribute4,
	%% 龙装基础属性
	%% {属性id，值}
	baseAttribute5,
	%% 粉色基础属性
	%% {属性id，值}
	baseAttribute6,
	%% 神装基础属性
	%% {属性id，值}
	baseAttribute7,
	%% 基础属性评分{基础属性列id，评分}
	%% 评分分别对应前面的基础属性
	score,
	%% 橙色品质蓝色极品属性随机库
	%% {属性id，值，品质，属性评分值，权重值}
	%% 随机属性不能重复，剩余的属性按各自权重再次随机
	%% 品质0白1蓝2紫3橙4红5粉6神
	starAttribute1,
	%% 橙色品质紫色极品属性随机库
	%% {属性id，值，品质，属性评分值,权重值}
	%% 随机属性不能重复，剩余的属性按各自权重再次随机
	%% 品质0白1蓝2紫3橙4红5粉6神
	starAttribute2,
	%% 红色品质紫极品属性随机库
	%% {属性id，值，品质，属性评分值,权重值}
	%% 随机属性不能重复，剩余的属性按各自权重再次随机
	%% 品质0白1蓝2紫3橙4红5粉6神
	starAttribute3,
	%% 红色品质橙色极品属性随机库
	%% {属性id，值，品质，属性评分值,权重值}
	%% 随机属性不能重复，剩余的属性按各自权重再次随机
	%% 品质0白1蓝2紫3橙4红5粉6神
	starAttribute4,
	%% 龙装品质橙色极品属性随机库
	%% {属性id，值，品质，属性评分值,权重值}
	%% 随机属性不能重复，剩余的属性按各自权重再次随机
	%% 品质0白1蓝2紫3橙4红5粉6神
	starAttribute5,
	%% 粉色品质橙色极品属性随机库
	%% {属性id，值，品质，属性评分值,权重值}
	%% 随机属性不能重复，剩余的属性按各自权重再次随机
	%% 品质0白1蓝2紫3橙4红5粉6神
	starAttribute6,
	%% 神装品质橙色极品属性随机库
	%% {属性id，值，品质，属性评分值,权重值}
	%% 随机属性不能重复，剩余的属性按各自权重再次随机
	%% 品质0白1蓝2紫3橙4红5粉6神
	starAttribute7,
	%% 粉色品质额外极品属性库{属性id，值，品质，属性评分值,权重值}
	starAttribute8,
	%% 神装品质额外极品属性库{属性id，值，品质，属性评分值,权重值}
	starAttribute9,
	%% 龙饰品质对应属性
	%% {品质ID，属性ID，初始属性值，成长属性值，品质，评分ID}
	dragonSpecialAttribute,
	%% 基础属性评分
	scoreNew,
	%% 对应随机属性评分1
	starScore1,
	%% 对应随机属性评分2
	starScore2,
	%% 对应随机属性评分3
	starScore3,
	%% 对应随机属性评分4
	starScore4,
	%% 对应随机属性评分5
	starScore5,
	%% 对应随机属性评分6
	starScore6,
	%% 对应随机属性评分7
	starScore7,
	%% 对应随机属性评分8
	starScore8,
	%% 对应随机属性评分9
	starScore9,
	%% 龙饰特殊属性对应评分
	%% (品质ID,评分)
	dragonSpecialScore,
	%% 龙装品质额外极品属性库{属性id，值，品质，属性评分值,权重值}
	starAttribute10,
	%% 预留字段1
	starAttribute11,
	%% 预留字段2
	starAttribute12,
	%% 对应随机属性评分10
	starScore10,
	%% 预览评分1
	starScore11,
	%% 预览评分2
	starScore12,
	%% 神装属性额外属性赋予
	%% {属性id，值，品质}
	specialGodAttr,
	%% 神装属性额外属性赋予的评分ID
	%% 该ID对应EquipScoreIndex_1_装备评分
	specialGodAttrID
}).

-endif.
