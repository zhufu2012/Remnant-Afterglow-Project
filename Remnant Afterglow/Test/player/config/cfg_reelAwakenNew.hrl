-ifndef(cfg_reelAwakenNew_hrl).
-define(cfg_reelAwakenNew_hrl, true).

-record(reelAwakenNewCfg, {
	%% 龙神id
	iD,
	%% 觉醒等级
	level,
	%% 客户端索引
	index,
	%% 最大觉醒等级
	lvMax,
	%% 觉醒下级所需道具ID
	needItem,
	%% 属性加值
	attrAdd,
	%% 龙神秘典技能或修正
	%% (技能类型1,ID1,学习位1)|
	%% (技能类型2,ID2,学习位2)
	%% 技能类型：
	%% 1为技能(skillBase);
	%% 2为技能修正(SkillCorr)
	%% 学习位：为0时不可直接获得
	%% 42-53为龙神秘典
	skill
}).

-endif.
