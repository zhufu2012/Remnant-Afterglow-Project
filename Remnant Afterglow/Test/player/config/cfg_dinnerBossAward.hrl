-ifndef(cfg_dinnerBossAward_hrl).
-define(cfg_dinnerBossAward_hrl, true).

-record(dinnerBossAwardCfg, {
	%% 世界等级编号
	%% 取值【DinnerBossBase_1_篝火boss基础】WLOrder
	worldLevel,
	%% 序号
	%% 对应基础表DinnerBossBase的序号
	iD,
	%% 索引
	index,
	%% 采集物奖励
	%% (阶段，采集物id，职业，掉落ID，是否绑定，掉落数量，掉落概率)
	%% 阶段、采集物id：对应基础表DinnerBossBase的配置
	%% 是否绑定：0为非绑，1为绑定
	%% 掉落概率：万分比
	collectionDrop,
	%% Boss结算奖励
	%% (战盟内伤害排名序号，职业，类型，类型ID，是否绑定，掉落数量)
	%% 战盟内伤害排名序号：【DinnerBossBase_1_篝火boss基础】HurtOrder
	%% 类型：1道具，2货币
	%% 是否绑定：0为非绑，1为绑定
	bossAward
}).

-endif.
