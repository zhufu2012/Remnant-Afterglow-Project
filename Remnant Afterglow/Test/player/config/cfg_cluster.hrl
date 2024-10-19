-ifndef(cfg_cluster_hrl).
-define(cfg_cluster_hrl, true).

-record(clusterCfg, {
	%% 游戏服ID
	iD,
	%% 游戏服内网IP
	iP,
	%% 世界服ID
	clusterID,
	%% 开启时间  格式：年月日
	%% 同世界服组的只认第一个时间
	linkTime,
	%% 交易行分组
	%% 这里配置该玩法的主机服务器ID，主机相同的为一玩法小联服组
	jiaoYiGroup,
	%% 炎魔试炼分组
	%% 这里配置该玩法的主机服务器ID，主机相同的为一玩法小联服组
	yanMoGroup,
	%% 恶魔深渊分组
	%% 这里配置该玩法的主机服务器ID，主机相同的为一玩法小联服组
	shenYuanGroup,
	%% 永恒战场分组
	%% 这里配置该玩法的主机服务器ID，主机相同的为一玩法小联服组
	yongHengGroup
}).

-endif.
