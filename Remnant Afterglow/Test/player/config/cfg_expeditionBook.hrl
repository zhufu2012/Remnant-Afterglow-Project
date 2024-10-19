-ifndef(cfg_expeditionBook_hrl).
-define(cfg_expeditionBook_hrl, true).

-record(expeditionBookCfg, {
	%% 手册成就ID
	%% 可以不连续，方便配置分段及后续扩展
	iD,
	%% 成就名称
	%% 读texts表索引
	name,
	%% 成就说明文字
	%% 读texts表索引
	contentstring,
	%% 类型
	%% 1猎魔
	%% 2远征
	%% 类型文字：ExpeditionBookType1_类型编号
	type,
	%% 条件
	%% （条件类型，参数）
	%% 类型：1猎魔体力消耗，2猎魔等级，3猎魔排名，4累积功勋，5爵位，6玩家单挑次数，7战队积分
	conditon,
	%% 奖励
	%% （赛季，职业，类型，ID，掉落是否绑定,数量）
	%% 赛季：玩家个人当前赛季
	%% 职业：0=所有职业的人均可获得该掉落，1004=战士，1005=法师，1006=弓手.（如果是职业一的人，不会掉落职业二的奖励，但是可以获得不分职业的奖励）
	%% 类型：1物品，ID为：道具ID
	%% 类型：2货币，ID为：货币ID
	%% 掉落是否绑定：0为非绑 1为绑定
	award
}).

-endif.
