-ifndef(cfg_guildTitle_hrl).
-define(cfg_guildTitle_hrl, true).

-record(guildTitleCfg, {
	%% 头衔等级
	iD,
	%% 需求声望（总声望）
	%% （ID=45）
	consume,
	%% 头衔文字
	titleName,
	%% 世界等级区间
	%% (起始等级、奖励序号）
	%% (1,1)|(100,2)表示：玩家等级为1-99级取序号为1的奖励，等级>=100级取序号为2的奖励.
	%% (1,1)表示：等级>=1级取序号为1的奖励.
	wroldLv,
	%% 声望奖励
	%% （等级奖励序号，职业，物品类型，物品ID，物品数量，是否绑定）
	%% 类型=1，物品
	%% 类型=2，货币
	translateGift
}).

-endif.
