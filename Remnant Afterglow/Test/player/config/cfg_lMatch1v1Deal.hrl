-ifndef(cfg_lMatch1v1Deal_hrl).
-define(cfg_lMatch1v1Deal_hrl, true).

-record(lMatch1v1DealCfg, {
	%% 赛季ID
	%% 与奖杯ID对应
	iD,
	%% 开启时间为周几
	week,
	%% 索引
	index,
	%% 拍卖掉落&拍卖行页面展示
	%% （道具id，数量，是否绑定）
	%% 数量默认1，实际拍卖掉落不会用到该值，而每个链表读取一份拍卖
	%% 相同ID只配一次
	dealItem
}).

-endif.
