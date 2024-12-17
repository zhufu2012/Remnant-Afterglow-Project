-ifndef(cfg_taskLuckDraw_hrl).
-define(cfg_taskLuckDraw_hrl, true).

-record(taskLuckDrawCfg, {
	%% 人物等级限制下限
	levelLimDown,
	%% 人物等级限制上限
	levelLimUp,
	%% 序号
	%% 如果玩家的等级没有对应的配置，为了避免出错，向前取最近的等级段的抽奖奖励配置
	index,
	%% 奖励随机明细
	%% （奖励显示序号，奖励类型，奖励ID，是否绑定，奖励数量，随机权重）
	%% 奖励显示序号一共8个，顺时针显示。
	%% 奖励类型：共用规则，1为道具，2为货币
	%% 奖励ID：Item表中对应ID，如果是货币，填写货币枚举，前端+1000转化为item读取信息
	%% 是否绑定：0非绑，1绑定
	%% 奖励数量，
	%% 随机权重：一定会随机到一个道具奖励，填写的为其权重
	randAward
}).

-endif.
