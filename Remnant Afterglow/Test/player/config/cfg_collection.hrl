-ifndef(cfg_collection_hrl).
-define(cfg_collection_hrl, true).

-record(collectionCfg, {
	%% 采集物ID
	iD,
	%% 名称的stringid
	name,
	%% 采集物名称
	namestring,
	%% 注释列，策划自己看，程序不用
	info,
	%% 采集物模型
	model,
	%% 模型缩放
	scale,
	%% 待机时模型上加载的特效
	idleEffect,
	%% 激活后模型性加载的特效
	activeEffect,
	%% 机关激活时播放的声音。只播放一次。罐子，援助机关，宝箱用这个。资源地址跟前面一样
	activeSound,
	%% 半径：
	%% 触发开始采集的范围
	col_Range,
	%% 吟唱时间（毫秒）
	col_Time,
	%% 采集物奖励（任何归属必掉，不想掉配0即可）
	%% {职业，掉落ID，掉落是否绑定,掉落数量，掉落概率}
	%% 职业：0=所有职业的人均可获得该掉落，1004-战士，1005-法师，1006-弓手.（如果是职业一的人，不会掉落职业二的奖励，但是可以获得不分职业的奖励）
	%% 掉落是否绑定：0为非绑 1为绑定
	%% 掉落数量为掉落包的个数，开启时每个包独立开启
	%% 掉落概率值为万分比，上限为10000，下限为0
	drop,
	%% 麒麟洞宝箱掉落
	reward,
	%% 单个采集物最大采集次数
	col_Maxnum,
	%% 采集动作
	col_Active,
	%% 回收时间（秒）
	%% 不回收填0
	delTime
}).

-endif.
