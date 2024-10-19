-ifndef(cfg_registerRewardNew_hrl).
-define(cfg_registerRewardNew_hrl, true).

-record(registerRewardNewCfg, {
	%% 签到累计天数
	iD,
	%% 等级分段
	%% (1,10)|(2,20)表示：
	%% 序列1=1~10级、序列2=11~20级
	lvStage,
	%% 奖励
	%% (序号,道具类型,道具ID,数量,是否绑定_货币和不分绑定道具忽略)
	%% 奖励对应LvStage字段的的序号，道具类型1为道具，2为货币,0为非绑，1为绑定
	%% 0是月份轮换奖励，需要读MonthRewardNew表补位
	reward,
	%% VIP等级可多倍领取
	%% VIPn|倍数
	vIP_Multiple
}).

-endif.
