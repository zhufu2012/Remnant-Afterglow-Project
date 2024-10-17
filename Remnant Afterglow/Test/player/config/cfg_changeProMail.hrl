-ifndef(cfg_changeProMail_hrl).
-define(cfg_changeProMail_hrl, true).

-record(changeProMailCfg, {
	%% 转职等级
	%% 取小于等于玩家当前转职等级的最大值
	iD,
	%% 装备赠送
	%% （当前职业，装备id，品质，星级，是否绑定）
	mailEq,
	%% 道具赠送
	%% （原职业，转职类型，道具id，是否绑定）
	%% 转职类型：1-普通，2-至尊
	mailItem
}).

-endif.
