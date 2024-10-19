-ifndef(cfg_active_hrl).
-define(cfg_active_hrl, true).

-record(activeCfg, {
	%% ID序列
	%% 奖励序列
	%% 或任务序列
	iD,
	%% 类型
	%% 1为宝箱
	%% 2为任务
	type,
	%% 所需活跃度
	%% 产生活跃度
	activeVal,
	%% 完成活跃奖励次数
	%% 达到这个次数后，不再产出活跃度
	activeMAX,
	%% 开启等级
	needLevel,
	%% {货币类型，数量}
	%% 货币类型 
	%% 0为元宝 Gold
	%% 1为铜币 Money
	%% 2为魂玉 SoulValue
	%% 3为声望 Reputation
	%% 4为荣誉 Honor
	%% 5为战魂 WarSpirit
	%% 6为铸魂 EquipSoul
	%% 7为帮会贡献值 GangCont
	%% 8为神器 ArtiSoul
	awardCoin,
	%% 宝箱奖励
	%% {物品ID，数量}
	awardItem,
	%% openaction功能开放ID   
	%% 填0代表不受功能开放限制
	openaction,
	%% 产出预览
	%% {产出1，产出2，产出3}
	rewardPre,
	%% 星级
	commendStar,
	%% 产出类型
	%% 1.经验
	%% 2.货币
	%% 3.道具
	%% 4.英雄
	%% 5.装备
	%% 6.神器
	%% 最多只填5个，超出两个客户端也只显示前2个
	outputType,
	%% 是否为限时活动
	limitTimeActive,
	%% 排序
	%% 优先按照数字排序，数字越小的排在越前，数字相同按钮星级，星级相同按照ID顺序
	turn
}).

-endif.
