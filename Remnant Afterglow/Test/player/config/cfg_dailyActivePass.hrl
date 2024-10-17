-ifndef(cfg_dailyActivePass_hrl).
-define(cfg_dailyActivePass_hrl, true).

-record(dailyActivePassCfg, {
	iD,
	%% 首次开通赠送奖励
	%% （道具ID，数量）
	%% 聊天框
	firstOpenGift,
	%% 直购ID
	directPurchase,
	%% 持续时长
	%% 倒计时结束后奖励/积分/活跃度统计/付费奖励购买都重置
	lastTime
}).

-endif.
