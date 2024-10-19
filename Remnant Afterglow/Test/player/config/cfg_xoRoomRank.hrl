-ifndef(cfg_xoRoomRank_hrl).
-define(cfg_xoRoomRank_hrl, true).

-record(xoRoomRankCfg, {
	%% 联服数
	%% 0为单服，其余的数字为联服数。
	%% 比如填1，就是1联服；填4，就是4联服。比如这里最高配到8，实际已经到9联服了，就按8联服奖励来取
	serverType,
	%% 排名参数1
	param1,
	%% 排名参数2
	param2,
	%% 索引
	index,
	%% 排名奖1
	%% （奖励序号，职业，类型，类型ID，掉落是否绑定,掉落数量）
	%% 奖励序号：AshuraBase表中OrderReward字段的奖励序号
	%% 职业：0=所有职业的人均可获得该掉落，1004=战士，1005=法师，1006=弓手.（如果是职业一的人，不会掉落职业二的奖励，但是可以获得不分职业的奖励）
	%% 类型1：道具，类型ID为道具ID
	%% 类型2：货币，类型ID为货币ID
	%% 掉落是否绑定：0为非绑 1为绑定（货币没有绑定或非绑的说法）
	%% 掉落数量：奖励道具的数量
	awardBoxNew
}).

-endif.
