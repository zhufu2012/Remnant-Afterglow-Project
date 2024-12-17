-ifndef(cfg_darkSlayerScore_hrl).
-define(cfg_darkSlayerScore_hrl, true).

-record(darkSlayerScoreCfg, {
	%% 个人目标阶段奖励
	iD,
	%% 个人目标阶段所需奖励积分
	param,
	%% 个人目标奖励
	%% （职业，类型，类型ID，掉落是否绑定,掉落数量）
	%% 职业：0=所有职业的人均可获得该掉落，1004=战士，1005=法师，1006=弓手.（如果是职业一的人，不会掉落职业二的奖励，但是可以获得不分职业的奖励）
	%% 类型1：道具，类型ID为道具ID
	%% 类型2：货币，类型ID为货币ID
	%% 掉落是否绑定：0为非绑 1为绑定（货币没有绑定或非绑的说法）
	%% 掉落数量：奖励道具的数量
	awardBoxNew
}).

-endif.
