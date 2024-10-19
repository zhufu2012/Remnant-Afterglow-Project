-ifndef(cfg_dinnerBossAuct_hrl).
-define(cfg_dinnerBossAuct_hrl, true).

-record(dinnerBossAuctCfg, {
	%% 世界等级编号
	%% 取值【DinnerBossBase_1_篝火boss基础】WLOrder
	worldLevel,
	%% 序号
	%% 对应基础表DinnerBossBase的序号
	iD,
	%% 索引
	index,
	%% 拍卖真实掉落
	%% （本战盟参与人数区间，序号）
	%% 本战盟参与人数区间：向前取
	%% 例如(1，A)|((5，B)|(10，C)： 
	%% 1≤人数＜5，取A
	%% 5≤人数＜10，取B
	%% 10≤人数，取C
	numberOrder,
	%% 拍卖掉落
	%% (战盟排名，序号，职业，掉落ID，是否绑定，掉落数量，掉落概率)
	%% 战盟排名序号：【DinnerBossBase_1_篝火boss基础】GuildOrder
	%% 序号：NumberOrder字段对应的序号.
	%% 是否绑定：0为非绑，1为绑定
	%% 掉落概率：万分比
	dinnerAuct,
	%% 拍卖掉落-个人限购
	%% (战盟排名，职业，掉落ID，是否绑定，掉落数量，掉落概率)
	%% 战盟排名序号：【DinnerBossBase_1_篝火boss基础】GuildOrder
	%% 是否绑定：0为非绑，1为绑定
	%% 掉落概率：万分比
	dinnerAuctPerson
}).

-endif.
