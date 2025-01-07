-ifndef(cfg_petEquipNew_hrl).
-define(cfg_petEquipNew_hrl, true).

-record(petEquipNewCfg, {
	%% 【OB4】
	%% 装备ID
	iD,
	%% 装备属性-魔宠资质
	%% {资源属性id，值}
	%% 资质类型：同【PetBase_1_基础和模型】基础资质
	quali,
	%% 基础评分
	%% 装备总评分还需计算携带技能的评分
	baseScore,
	%% 装备技能数
	%% 学习位：按实际拥有的装备技能编号678-686（装备位序号+位上装备技能序号）
	skillNum,
	%% 技能品质
	%% （品质，权重）
	%% 装备生成或技能重置时，按该配置确定技能品质
	skillQualLimim,
	%% 技能重置消耗
	%% （消耗类型，类型参数，数量）
	%% 类型1：道具，参数为道具id
	%% 类型2：货币，参数为货币枚举
	needItem
}).

-endif.
