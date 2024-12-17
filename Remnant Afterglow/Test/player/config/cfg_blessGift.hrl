-ifndef(cfg_blessGift_hrl).
-define(cfg_blessGift_hrl, true).

-record(blessGiftCfg, {
	%% 序号
	iD,
	%% 免费祈福
	%% {每天免费祈福次数，免费祈福间隔（单位秒）}
	%% 配0代表不能免费祈福
	timeDif,
	%% 祈福奖励
	%% (奖励类型，奖励参数)
	%% 奖励类型：1为金币奖励，2为经验奖励
	%% 奖励参数：
	%% 金币奖励：直接读取
	%% 经验奖励：参数*StandardExp(ExpDistribution表)取玩家自身等级
	gift,
	%% 祈福消耗
	%% (当日祈福次数，道具类型，道具ID，道具数量)
	%% 祈福次数：即当前为第几次祈福
	%% 道具类型：1为道具，2为货币
	blessCost,
	%% 每天祈福总次数
	%% 填在vipfun表，跟随玩家vip等级走
	%% 这里填写vipfun id
	blessTime,
	%% 祈福暴击几率万分比
	%% 填写Vip参数
	%% VIPFUN表ID字段
	blessCrit,
	%% 祈福必定暴击次数
	%% 如配置为5：前四次如果都不暴击，则第五次必定暴击
	critSuccess,
	%% 暴击倍率
	%% (暴击倍率,对应权重）
	%% 暴击倍率：祈福暴击时会获得多少倍的奖励
	%% 对应权重：填在vipfun表，这里填写ID
	crit,
	%% 多少次祈福获得一次永久加成奖励
	%% 例：这里填10，则每十次经验祈福获得一次加成
	%% 金币额外加成则=CoinGift*EveryGift（注：金币第10次祈福结束后加成显示，第11次祈福时获得金币额外加成）
	%% 经验永久加成直接取每十层的buff进行替换
	everyGift,
	%% 每次祈福额外获得祈福金币加成数量
	%% 当Gift字段奖励类型参数为1时读取该字段
	coinGift,
	%% 祈福金币额外加成数量累计上限
	coinGiftMax
}).

-endif.
