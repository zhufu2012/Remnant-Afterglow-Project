-ifndef(cfg_dHallowsQuality_hrl).
-define(cfg_dHallowsQuality_hrl, true).

-record(dHallowsQualityCfg, {
	%% 圣物id
	iD,
	%% 品数等级
	grade,
	%% 客户端索引
	index,
	%% 最大品数等级
	gradeMax,
	%% 0为普通白
	%% 1为优秀蓝
	%% 2为史诗紫
	%% 3为传说橙
	%% 4为神话红
	%% 5为粉色
	%% 6为神装
	character,
	%% 新增
	%% 对应品质
	%% 0 N白
	%% 1 R蓝
	%% 2 SR紫
	%% 3 SSR橙
	%% 4 SP 红
	%% 5 UR 粉
	rareType,
	%% 升到下一级消耗的材料
	%% （道具ID，数量）
	needItem,
	%% 升品提供属性
	%% （属性ID,值）
	%% （填的是累计增加的数据）
	attrAdd,
	%% 圣物技
	%% (技能类型1,ID1,学习位1)
	%% 技能类型：1为技能(skillBase)
	%% 2为技能修正(SkillCorr)
	%% 学习位：为0时不可直接获得
	skill
}).

-endif.
