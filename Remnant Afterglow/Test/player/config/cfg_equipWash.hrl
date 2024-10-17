-ifndef(cfg_equipWash_hrl).
-define(cfg_equipWash_hrl, true).

-record(equipWashCfg, {
	%% 装备部位
	%% （1武器，2项链，3护手，4戒指，5衣服，6头盔，7护肩，8鞋子，9裤子，10护符）
	iD,
	%% 洗练条目编号
	number,
	%% 索引
	index,
	%% 洗练开启玩家等级限制
	lvLimit,
	%% 开启是否花费道具，0不花，填多少就花多少
	%% {道具id，数量}
	unlockConsume,
	%% 开启是否花费元宝，0不花，填多少就花多少
	%% {货币id，数量}
	unlockCost,
	%% 开启对应条目的最低VIP等级
	vIPLv,
	%% 开启条目时属性各品质权重
	%% 0白，1蓝，2紫，3橙，4红，5粉
	qualityRandom1,
	%% 基础洗练时属性各品质权重
	%% 0白，1蓝，2紫，3橙，4红，5粉
	qualityRandom2,
	%% 钻石洗练（单条）时属性品质权重
	%% 0白，1蓝，2紫，3橙，4红，5粉
	qualityRandom3,
	%% 高级橙色洗练（单条）时属性各品质权重
	%% 0白，1蓝，2紫，3橙，4红，5粉
	qualityRandom4,
	%% 高级红色洗练（单条）时属性各品质权重
	%% 0白，1蓝，2紫，3橙，4红，5粉
	qualityRandom5,
	%% 白色属性库
	%% {属性id,下限值,上限值,权重}
	white,
	%% 蓝色属性库
	%% {属性id,下限值,上限值,权重}
	blue,
	%% 紫色属性库
	%% {属性id,下限值,上限值,权重}
	purple,
	%% 橙色属性库
	%% {属性id,下限值,上限值,权重}
	orange,
	%% 红色属性库
	%% {属性id,下限值,上限值,权重}
	red
}).

-endif.
