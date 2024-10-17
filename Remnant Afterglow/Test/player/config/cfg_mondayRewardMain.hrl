-ifndef(cfg_mondayRewardMain_hrl).
-define(cfg_mondayRewardMain_hrl, true).

-record(mondayRewardMainCfg, {
	%% ID记录用
	iD,
	%% 个人等级区间
	%% （等级下限，等级上限）取等
	lv,
	%% 周一奖励中奖次数及对应的权重分布
	%% （一天抽中次数，对应在线抽奖的第几次，对应的权重分布）
	%% 如数据(1,1,10)|(1,2,10)|(1,3,10)|(2,5,10)|(2,6,10)|(2,7,10)表示：第一次抽中分布在1/2/3次在线抽奖中，1/2/3次在线抽奖中获得当日的第一次奖励的权重分别为10；
	%%     第二次抽中分布在5/6/7次在线抽奖中，5/6/7次在线抽奖中获得当日的第二次奖励的权重分别为10；
	onlineFrequency,
	%% 每次中奖的特殊中奖规则
	%% （一周内中奖次数，库ID，对应库权重） 
	%% 如数据
	%% (1,1,30)|(1,2,1)|(2,1,30)|(2,2,1)|(3,1,30)|(3,2,1)表示：第1次抽奖中的库ID1/库ID2的权重分别为30/1；第2次抽奖中的库ID1/库ID2的权重分别为30/1；第3次抽奖中的库ID1/库ID2的权重分别为30/1.
	%% 注意这里的特殊中奖规则要和库奖励的剔除规则联动起来
	weight
}).

-endif.