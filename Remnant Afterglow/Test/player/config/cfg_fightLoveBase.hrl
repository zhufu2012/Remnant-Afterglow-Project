-ifndef(cfg_fightLoveBase_hrl).
-define(cfg_fightLoveBase_hrl, true).

-record(fightLoveBaseCfg, {
	%% 排行类型
	%% 1：基础排名
	%% 2：单服排名
	%% 3：全服排名
	%% 明日奖励
	%% 每月奖励
	%% 只能获得一个档次
	%% 积分型官职（1）达到积分就及时更新官职
	%% 排名型官职及（2,3）需要积分型官职（1）达到满级，且符合排名需求，每日固定时间更新
	iD,
	%% 官职
	%% 数字越大官职越高
	num,
	%% 客户端索引
	index,
	%% 官职名称
	name,
	%% 参数1
	%% ID=1，官职类型
	%% ID=2,3，最大排名
	param1,
	%% 参数2
	%% ID=1，官职类型段
	%% ID=2,3，最小排名
	param2,
	%% 提升排名所需积分
	%% ID=1使用
	param3,
	%% 每周物品奖励
	%% {物品ID，数量}
	awardItem,
	%% 每周货币奖励
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
	%% 称号奖励
	%% title表ID
	%% 男性获得称号
	titleID,
	%% 称号奖励
	%% title表ID
	%% 女性获得称号
	titleID2,
	%% 重置等级
	%% 官职类型|官职ID|初始积分
	%% 为0时，及重置为初始状态，初始积分为0
	resetLv,
	%% 段位图片
	photo,
	%% 相同段位图片上阿拉伯数字
	photo1
}).

-endif.
