-ifndef(cfg_syntItemHolyWings_hrl).
-define(cfg_syntItemHolyWings_hrl, true).

-record(syntItemHolyWingsCfg, {
	%% 系统分类:
	%% 特殊处理圣翼合成-id=11
	iD,
	%% 合成类型
	%% 1圣翼
	type2,
	%% 圣翼合成
	%% 默认值0
	type3,
	%% 圣翼合成
	%% 默认值0
	type4,
	%% 合成列表序号，必须从1开始且连续
	type5,
	%%    选定前置标签后按顺序罗列合成道具顺序
	index,
	%% 恶魔玩家首次成功合成道具
	%% （序号，权重，道具id）
	%% 恶魔玩家选择的圣翼类型为1
	fristSyntItem1,
	%% 天使玩家首次成功合成道具
	%% （序号，权重，道具id）
	%% 天使玩家选择的圣翼类型为2
	fristSyntItem2,
	%% 古龙玩家首次成功合成道具
	%% （序号，权重，道具id）
	%% 古龙玩家选择的圣翼类型为3
	fristSyntItem3,
	%% 合成道具
	%% （序号，权重，道具id）
	syntItem,
	%% 必定合成高品质道具
	%% （序号，权重，道具id）
	%% 合成成功才会重置次数，进入普通合成
	sureSyntItem,
	%% 必定合成高品质道具
	%% 所需的前置成功合成次数
	%% 各圣翼等级独立计数
	%% 填写前置次数，达成后的下一次读【SureSyntItem】，否则读【SyntItem】
	sureSyntCondi,
	%% 用于寻找对应的预制UI界面，需要和合成界面一一对应 
	%% 排版ID 说明
	%%  
	%% 圣翼合成9
	prefabID,
	%% 作者:
	%% 合成数量
	itemNum,
	%% 所需其他物品
	%% (类型，ID，数量，等级，是否污染绑定）
	%% 类型1：道具-道具id，数量，0，是否污染绑定
	%% 类型2：圣翼-0，数量，圣翼等级，是否污染绑定
	needItem,
	%% 偏向材料
	%% （道具1ID，序号1修正，序号2修正……）|（道具2ID，序号1修正，序号2修正……）
	runItem,
	%% 合成基础成功率，万分比点
	rateBase,
	%% 可用垫脚材料数量
	rateItemNum,
	%% 垫脚材料提升合成成功率
	%% (道具ID，成功率修正）
	rateCorrect,
	%% 合成配方文字展示
	%% 引用text表中的Menu分页id
	%% 例：SynthesisTips1
	showTips,
	%% 可合成的道具是否显示红点，1显示，0不显示
	isShowRed
}).

-endif.
