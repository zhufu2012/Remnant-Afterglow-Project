-ifndef(cfg_guildKnightsAttr_hrl).
-define(cfg_guildKnightsAttr_hrl, true).

-record(guildKnightsAttrCfg, {
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
	%% 每次合服时，加给玩家的属性，当前玩家有几个角色就加几个角色。
	%% （属性ID，值）
	%% 纵轴：根据ID来变；
	%% 横轴：取记录的当前最大ID的；
	attribute1,
	attribute2,
	attribute3,
	attribute4
}).

-endif.
