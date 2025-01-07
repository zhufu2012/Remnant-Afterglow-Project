-ifndef(cfg_monthFinancing_hrl).
-define(cfg_monthFinancing_hrl, true).

-record(monthFinancingCfg, {
	%% 个人等级
	lv,
	%% 月理财档位
	%% 1代表30元月理财
	%% 2代表98元月理财
	grade,
	%% 奖励天数ID
	%% 购买后第几天可以领取该奖励
	%% 1代表购买的当天可以领取
	%% 2代表购买的第二天可以领取
	%% 0代表购买后立即获得，直接发放给玩家
	dayID,
	%% 服务器组
	serverGroup,
	%% 索引
	index,
	%% 月理财
	%% 直购商品ID
	monthFinancing,
	%% 每天领取奖励
	%% 固定为绑钻
	monthGift,
	%% 奖励
	%% (货币类型，货币数量）
	%% 货币奖励领取改到这个字段，程序做好后删除MonthGift字段
	gift
}).

-endif.
