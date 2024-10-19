-ifndef(cfg_tradeDiamond_hrl).
-define(cfg_tradeDiamond_hrl, true).

-record(tradeDiamondCfg, {
	iD,
	%% 粉钻出售总限次
	sellPinkDiamondLimit,
	%% 道具整体上架保护期
	%% (上架后N秒不可下架）
	protectTime,
	%% 系统清理下架时长（小时）
	discardTime,
	%% 系统延时回收相关
	%% （时间节点【秒】，出售概率【万分比】）
	%% 即在每次玩家上架后的N秒时会对单个道具进行一次概率判断来收购
	sellChance,
	%% 单份粉钻数额
	%% (货币ID，数量）
	number,
	%% 货币ID，系统供货价格
	systemSell,
	%% 价格
	%% （购买货币ID,标准价格,价格上限，价格下限，出售后获得货币ID）
	playerSell,
	%% 价格变动小时
	%% 统计多少小时的数据
	changeDate,
	%% 价格变动方案ID
	%% ContrastChange_1_对照表的PricePlan"X"
	choosePricePlan
}).

-endif.
