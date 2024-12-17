-ifndef(cfg_petSkinBase_hrl).
-define(cfg_petSkinBase_hrl, true).

-record(petSkinBaseCfg, {
	%% 幻化ID
	iD,
	%% 名字
	name,
	%% 新增
	%% 对应品质
	%% 0 N白
	%% 1 R蓝
	%% 2 SR紫
	%% 3 SSR橙
	%% 4 SP 红
	%% 5 UR 粉
	rareType,
	%% 幻化对应的英雄id
	hero,
	%% 晋升后对应幻化的英雄id
	rareUpHero,
	%% 激活后获得资质属性
	%% {资质属性id,值}
	%% 资质类型：25080生命资质,25081攻击资质,25082防御资质,25083破甲资质
	skinAttrBase,
	%% 排序ID
	orderBy,
	%% 提升系统中需要用到的评价该系统养成进度的依据值
	evaluate,
	%% 幻化类型
	%% 1风-暗影
	%% 2火-审批
	%% 3土-黎明
	%% 4幻兽
	elemType,
	%% 宠物特殊性
	%% 0为默认
	%% 1为能为被链接的一方提供技能的英雄
	%% 2为附身怪类型【哈迪斯】
	%% 3、海拉类：可链接SP英雄和SSR英雄
	sPType,
	%% 宠物是否是变身/附身主角的类型，0为否，
	%% 1为是
	%% 用来判定触发海拉技能
	transType,
	%% 临时激活道具
	%% （道具id，数量）
	temporary,
	%% 永久激活道具
	%% （道具id，数量）
	permanent
}).

-endif.
