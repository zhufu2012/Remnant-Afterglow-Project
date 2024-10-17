-ifndef(cfg_noticeItem_hrl).
-define(cfg_noticeItem_hrl, true).

-record(noticeItemCfg, {
	%% 道具ID
	iD,
	%% 公告文字ID
	notice,
	%% 需要被公告的道具ID
	%% (奖励序号,职业，ID)
	%% 1004=战士，1005=法师，1006=弓手
	item
}).

-endif.
