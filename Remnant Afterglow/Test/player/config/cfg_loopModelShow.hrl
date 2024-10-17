-ifndef(cfg_loopModelShow_hrl).
-define(cfg_loopModelShow_hrl, true).

-record(loopModelShowCfg, {
	%% 风格包组ID
	iD,
	%% 地图演员的等级段限制
	level,
	%% 循环关剧情地块显示演员数量，也是向服务器请求的演员数量
	maxNum
}).

-endif.
