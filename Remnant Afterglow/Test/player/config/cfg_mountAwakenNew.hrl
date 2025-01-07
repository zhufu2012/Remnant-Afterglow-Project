-ifndef(cfg_mountAwakenNew_hrl).
-define(cfg_mountAwakenNew_hrl, true).

-record(mountAwakenNewCfg, {
	%% 坐骑id
	iD,
	%% 觉醒等级
	level,
	%% 客户端索引
	index,
	%% 最大觉醒等级
	lvMax,
	%% 所需坐骑星级
	needLv,
	%% 所需坐骑等级
	needLevel,
	%% 升级所需{道具ID，数量}读下一级，0升1，读1
	needItem,
	%% 属性加值
	attrAdd,
	%% 触发技等级
	skillLv,
	%% 坐骑技能或修正(触发技)
	%% (技能类型1,ID1,学习位1)|
	%% (技能类型2,ID2,学习位2)
	%% 技能类型：1为技能(skillBase);
	%% 2为技能修正(SkillCorr)
	%% 学习位：为0时不可直接获得
	%% 坐骑打造技27-31
	skill,
	%% MountModelinformation_1_模型信息的ID
	modelID,
	%% MountModelinformation_1_模型信息的ID
	modelLowID
}).

-endif.
