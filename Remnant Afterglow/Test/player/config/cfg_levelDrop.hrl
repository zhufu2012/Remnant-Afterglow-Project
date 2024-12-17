-ifndef(cfg_levelDrop_hrl).
-define(cfg_levelDrop_hrl, true).

-record(levelDropCfg, {
	%% 作者:
	%% 1为普通副本-取消
	%% 2为妖魔来袭-取消
	%% 3为组队副本-取消
	%% 4为神器副本-取消
	%% 5为战魂副本
	%% 6为掠夺
	%% 7位竞技场
	%% 101为家园铜宝箱
	%% 102为银宝箱
	%% 103为金宝箱
	%% 104为双修分时奖励
	%% 111-116为仙船分时奖励
	iD,
	%% 作者:
	%% 玩家等级
	level,
	%% 作者:
	%% 翻牌系统：翻牌次数
	num,
	%% 作者:
	%% 客户端索引
	index,
	%% 作者:
	%% 消耗货币类型
	%% 0为元宝 Gold
	%% 1为铜币 Money
	%% 2为魂玉 SoulValue
	%% 3为声望 Reputation
	%% 4为荣誉 Honor
	%% 5为战魂 WarSpirit
	%% 6为铸魂 EquipSoul
	%% 7为帮会贡献值 GangCont
	%% 8为神器 ArtiSoul
	costCurrType,
	%% 作者:
	%% 消耗量
	costCurrCons,
	%% 作者:
	%% 调用Drop的概率
	%% 否则，调用直接给货币
	dropPro,
	%% 作者:
	%% 掉落包ID
	dropID,
	%% 作者:
	%% 获得货币类型
	%% 0为元宝 Gold
	%% 1为铜币 Money
	%% 2为魂玉 SoulValue
	%% 3为声望 Reputation
	%% 4为荣誉 Honor
	%% 5为战魂 WarSpirit
	%% 6为铸魂 EquipSoul
	%% 7为帮会贡献值 GangCont
	%% 8为神器 ArtiSoul
	currType,
	%% 作者:
	%% 获得货币最小值
	currMin,
	%% 作者:
	%% 获得货币最大值
	currMax
}).

-endif.
