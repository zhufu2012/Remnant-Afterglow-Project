-ifndef(cfg_dungeonReward).
-define(cfg_dungeonReward, 1).

-record(dungeonRewardCfg, {
	%% 作者:
	%% mapsetting地图ID
	%% 每个难度对应一个ID
	iD,
	%% 作者:
	%% 副本名称
	name,
	%% 作者:
	%% 副本获取主角经验系数
	expTeam,
	%% 作者:
	%% 英雄获得经验
	%% {1,20}1表示简单难度20表示获得经验
	expHero,
	%% 作者:
	%% 获得铜币
	money,
	%% 作者:
	%% 翻牌掉落包ID
	%% {次数,VIP等级,消耗元宝,掉落包ID}
	dropInfo
}).

-endif.
