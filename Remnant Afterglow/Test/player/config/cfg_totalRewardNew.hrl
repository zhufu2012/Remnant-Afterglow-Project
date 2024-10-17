-ifndef(cfg_totalRewardNew_hrl).
-define(cfg_totalRewardNew_hrl, true).

-record(totalRewardNewCfg, {
	%% 累计奖励组别ID
	number,
	%% 达到签到天数
	days,
	%% 索引
	index,
	%% 等级分段
	%% (1,10)|(2,20)表示：
	%% 序列1=1~10级、序列2=11~20级
	lvStage,
	%% 奖励
	%% (序号,道具类型,道具ID,数量,是否绑定_货币和不分绑定道具忽略)
	%% 奖励对应LvStage字段的的序号，道具类型1为道具，2为货币,0为非绑，1为绑定
	reward
}).

-endif.
