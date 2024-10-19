-ifndef(cfg_rouletteTime_hrl).
-define(cfg_rouletteTime_hrl, true).

-record(rouletteTimeCfg, {
	%% 热点ID
	iD,
	%% 作者:
	%% {奖励序号,所需次数}
	condPara,
	%% 新加字段
	%% 依次可切换分页数量
	%% 控制读取AwardParaNew1/AwardParaNew2/AwardParaNew3个字段
	num,
	%% 新加字段
	%% (奖励序列,职业，类型，类型ID，是否绑定，数量)
	%% 职业：0=所有职业的人均可获得该掉落，1004=战士，1005=法师，1006=弓手.(如果是职业一的人，不会掉落职业二的奖励，但是可以获得不分职业的奖励)
	%% 类型1：道具，类型ID为道具ID
	%% 类型2：货币，类型ID为货币ID
	%% 是否绑定：0为非绑 1为绑定(货币没有绑定或非绑的说法)
	%% 数量：奖励道具的数量
	awardParaNew1,
	%% 新加字段
	%% (奖励序列,职业，类型，类型ID，是否绑定，数量)
	%% 职业：0=所有职业的人均可获得该掉落，1004=战士，1005=法师，1006=弓手.(如果是职业一的人，不会掉落职业二的奖励，但是可以获得不分职业的奖励)
	%% 类型1：道具，类型ID为道具ID
	%% 类型2：货币，类型ID为货币ID
	%% 是否绑定：0为非绑 1为绑定(货币没有绑定或非绑的说法)
	%% 数量：奖励道具的数量
	awardParaNew2,
	%% 需要显示道具表的ID，然后通过道具表查找到对应功能表，再查找出对应的模型，依次对应AwardParaNew1/AwardParaNew2/AwardParaNew3个字段
	showitem
}).

-endif.
