-ifndef(cfg_barbecue_hrl).
-define(cfg_barbecue_hrl, true).

-record(barbecueCfg, {
	%% 篝火等级
	iD,
	%% 篝火升级经验
	exp,
	%% 升级所需公会等级
	needLv,
	%% 主角经验
	%% {经验类型，经验参数}
	%% 经验类型：
	%% 1为固定型 
	%% 获得经验=经验参数
	%% 2为动态型
	%% 获得经验=经验参数*玩家等级
	playerExp
}).

-endif.
