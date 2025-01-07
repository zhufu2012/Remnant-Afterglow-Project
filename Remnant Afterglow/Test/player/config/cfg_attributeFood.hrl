-ifndef(cfg_attributeFood_hrl).
-define(cfg_attributeFood_hrl, true).

-record(attributeFoodCfg, {
	%% 属性丹ID
	iD,
	%% 属性丹品质
	%% 道具品质
	%% 0为普通白
	%% 1为优秀蓝
	%% 2为史诗紫
	%% 3为传说橙
	%% 4为神话红
	%% 5为龙
	%% 6为神装
	%% 7龙神装
	quality,
	%% 属性丹展示排序
	%% 数字越小，排序越靠前
	sort,
	%% 基础属性
	%% （属性id，值）
	%% 属性是替换的
	attribute,
	%% 触发技能
	%% (技能ID，技能位)
	%% 属性是替换的
	%% 需要程序记录吃的丹个数，每一个丹相当于SkillBase的LvValue值增加一次
	%% 激活为1级
	foodSkill
}).

-endif.
