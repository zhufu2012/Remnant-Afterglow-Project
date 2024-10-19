-ifndef(cfg_petTrain_hrl).
-define(cfg_petTrain_hrl, true).

-record(petTrainCfg, {
	%% 【OB4】
	%% 大师等级
	iD,
	%% 大师等级上限
	maxLv,
	%% 名字
	name,
	%% 激活条件
	%% （条件类型，类型参数1，参数2）
	%% 类型1：激活魔宠图鉴，参数1为品质要求，参数2为数量
	%% 类型2：上阵魔宠，参数1为星级要求，参数为数量
	condition,
	%% 奖励属性
	%% (属性ID，值）
	attrAdd
}).

-endif.
