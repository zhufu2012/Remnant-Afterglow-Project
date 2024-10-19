-ifndef(cfg_weaponSuit_hrl).
-define(cfg_weaponSuit_hrl, true).

-record(weaponSuitCfg, {
	%% 神兵分组
	%% 套装ID
	%% 策划备注：
	%% 10*：战士
	%% 20*：法师
	%% 30*：弓手
	%% 40*：圣职
	%% 一主一副
	%% 为一组
	iD,
	%% 套装等级
	level,
	index,
	%% 套装最大等级
	levelMax,
	%% 套装名字
	name,
	%% 神兵ID组
	group,
	%% 神兵ID组对应的阶
	needLv,
	%% 套装属性
	attrAdd
}).

-endif.
