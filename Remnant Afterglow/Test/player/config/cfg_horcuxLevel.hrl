-ifndef(cfg_horcuxLevel_hrl).
-define(cfg_horcuxLevel_hrl, true).

-record(horcuxLevelCfg, {
	%% 阶数
	page,
	%% 点数
	point,
	%% 等级
	lv,
	%% 魂器ID
	horcuxID,
	%% 客户端索引
	index,
	%% 标识
	%% 1.为普通升级，读attradd字段+itemadd字段
	%% 2.为普通突破，读attradd字段+itemadd字段
	%% 3.为翻页突破，读attradd字段+技能字段
	mark,
	%% 需要材料（升级到本级需要的材料）
	needItem,
	%% 升级等级奖励属性
	%% {属性ID，属性值}
	attrAdd,
	%% 突破物品奖励
	%% {职业，道具类型，道具ID，道具绑定状态，道具数量}
	itemAdd,
	%% 器灵等级限制
	lvLimit,
	%% 最大阶数
	pageMax,
	%% 最大点数
	pointMax,
	%% 最大等级
	lvMax,
	%% 魂器技能
	%% (技能类型1,ID1,学习位1)|
	%% (技能类型2,ID2,学习位2)
	%% 技能类型：1为技能(skillBase);
	%% 2为技能修正(SkillCorr)
	%% 学习位：为0时不可直接获得
	%% 魂器装配114-117
	skill,
	%% 魂器技能或修正，此字段为被动技
	%% (技能类型,ID,学习位)
	%% 技能类型：1为技能(skillBase);
	%% 2为技能修正(SkillCorr)
	%% 学习位：为0时不可直接获得
	%% 魂器装配114-117
	passiveSkill
}).

-endif.
