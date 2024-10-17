-ifndef(cfg_dropLimit_hrl).
-define(cfg_dropLimit_hrl, true).

-record(dropLimitCfg, {
	%% 限制掉落ID
	%% ID不可重复使用
	%% 除非清数据库
	%% 1.测试数据
	iD,
	%% 调用限制掉落最小公倍数
	%% 0为限制掉落无效
	%% 例如：300，
	%% 每逢300的倍数,则调用限制掉落
	%% 直到限制掉落次数用完DropLiNum
	dropLiLCM,
	%% 本服限制掉落次数
	dropLiNum,
	%% 限制掉落物品
	%% {物品ID,物品数量}
	dropLiItem,
	%% 限制掉落货币
	%% {货币类型，货币数量}
	%% 货币类型：
	%% 0为元宝 Gold
	%% 1为铜币 Money
	%% 2为魂玉 SoulValue
	%% 3为声望 Reputation
	%% 4为荣誉 Honor
	%% 5为战魂 WarSpirit
	%% 6为铸魂 EquipSoul
	%% 7为帮会贡献值 GangCont
	%% 8为神器 ArtiSoul
	%% 9为爱心
	%% 10为血玉
	dropLiCoin,
	%% 当限制掉落不成功时，才调用普通掉落
	%% 普通掉落权值万分比分布
	%% {奖励序号，权值}
	%% 例如：{1,2500}|{2,1500}|{3,1000}
	%% 奖励1：2000/(2500+1500+1000)=50%概率调用奖励1配置
	%% 奖励2：30%概率调用奖励2配置
	%% 奖励3：20%概率调用奖励2配置
	%% 注：若奖励3没有配置则为空
	dropPro,
	%% 限制掉落物品
	%% {奖励序号,物品ID,物品数量}
	dropItem,
	%% 限制掉落货币
	%% {奖励序号，货币类型，货币数量}
	%% 货币类型：
	%% 0为元宝 Gold
	%% 1为铜币 Money
	%% 2为魂玉 SoulValue
	%% 3为声望 Reputation
	%% 4为荣誉 Honor
	%% 5为战魂 WarSpirit
	%% 6为铸魂 EquipSoul
	%% 7为帮会贡献值 GangCont
	%% 8为神器 ArtiSoul
	%% 9为爱心
	%% 10为血玉
	dropCoin,
	%% 可触发走马灯的货币/道具序号
	%% 1|2
	%% 可填多个序号，填0表示该礼包里面没有可触发走马灯的道具
	special,
	%% 有效时间
	%% 对DropItem字段中对应顺位的道具生效！！注意是顺位不是序号！！（顺位：从左到右）
	%% {类型,参数}
	%% 类型为1：相对时间（分）
	%% 类型为2：绝对时间 （年月日时分）(注意数字长度不要超)
	%% 当该字段为0时，及所有道具都是非限时道具
	%% 例如：
	%% {1,120}|{0,0}|{2,1805111830}
	%% 第一个道具为道具生成时,有效时间120分
	%% 第二个道具为非时限道具
	%% 第三个道具为2018年5月11日18时30分0秒前有效
	%% 第三个道具后都为非时限道具
	validTime
}).

-endif.