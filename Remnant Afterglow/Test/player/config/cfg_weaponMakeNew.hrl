-ifndef(cfg_weaponMakeNew_hrl).
-define(cfg_weaponMakeNew_hrl, true).

-record(weaponMakeNewCfg, {
	%% 打造id
	iD,
	%% 进度上限
	rateMax,
	%% 打造增加进度值
	%% (打造品质,增加进度值)
	%% 品质1：最差
	%% 品质2：一般
	%% 品质3：完美
	rate,
	%% 每日免费打造次数
	freeNum,
	%% 充值进度值
	%% (每充额度,增加进度值)
	%% 每充额度为每次累计充值的需要达到的钻石数
	recRate
}).

-endif.
