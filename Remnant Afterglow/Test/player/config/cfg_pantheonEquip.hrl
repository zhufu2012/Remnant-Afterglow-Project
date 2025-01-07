-ifndef(cfg_pantheonEquip_hrl).
-define(cfg_pantheonEquip_hrl, true).

-record(pantheonEquipCfg, {
	%% 和item表中的神兽装备id一一对应
	iD,
	%% 中文描述
	dEC,
	%% 卓越属性品质按个数配置
	%% {卓越品质1，卓越品质2，卓越品质3}
	%% 蓝品质卓越属性：1
	%% 紫品质卓越属性：2
	%% 橙品质卓越属性：3
	starRule,
	%% 基础属性
	%% {属性id，值}
	baseAttribute,
	%% 基础属性评分值
	score,
	%% 卓越属性随机蓝色属性库
	%% {属性id，值，品质，评分值，权重值}
	%% 随机属性不能重复，剩余的属性按各自权重再次随机
	%% 品质0白1蓝2紫3橙4红5龙6神7龙神
	starAttribute1,
	%% 卓越属性随机紫色属性库
	%% {属性id，值，品质，评分值，权重值}
	%% 随机属性不能重复，剩余的属性按各自权重再次随机
	%% 品质0白1蓝2紫3橙4红5龙6神7龙神
	starAttribute2,
	%% 卓越属性随机橙色属性库
	%% {属性id，值，品质，评分值，权重值}
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
