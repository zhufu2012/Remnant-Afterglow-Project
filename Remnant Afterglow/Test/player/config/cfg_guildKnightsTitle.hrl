-ifndef(cfg_guildKnightsTitle_hrl).
-define(cfg_guildKnightsTitle_hrl, true).

-record(guildKnightsTitleCfg, {
	%% 序号ID
	iD,
	%% 战盟排名
	guildRank,
	%% 战盟内玩家排名1
	memberRank1,
	%% 战盟内玩家排名2
	memberRank2,
	%% 索引
	index,
	%% 称号奖励
	%% 称号id
	%% 称号头顶图用于界面展示
	%% 结算直接发称号id，并给玩家激活
	%% 纵轴：根据ID来变；
	%% 横轴：取记录的当前最大ID的；
	title1,
	%% 称号奖励
	%% 称号道具id
	%% 道具ID用于获取称号的tips，实际不发道具
	titleItem1,
	%% 称号奖励
	%% 称号id
	%% 称号头顶图用于界面展示
	%% 结算直接发称号id，并给玩家激活
	title2,
	%% 称号奖励
	%% 称号道具id
	%% 道具ID用于获取称号的tips，实际不发道具
	titleItem2,
	%% 称号奖励
	%% 称号id
	%% 称号头顶图用于界面展示
	%% 结算直接发称号id，并给玩家激活
	title3,
	%% 称号奖励
	%% 称号道具id
	%% 道具ID用于获取称号的tips，实际不发道具
	titleItem3,
	%% 称号奖励
	%% 称号id
	%% 称号头顶图用于界面展示
	%% 结算直接发称号id，并给玩家激活
	title4,
	%% 称号奖励
	%% 称号道具id
	%% 道具ID用于获取称号的tips，实际不发道具
	titleItem4
}).

-endif.
