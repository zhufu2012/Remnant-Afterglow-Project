-ifndef(cfg_illustrationsBase_hrl).
-define(cfg_illustrationsBase_hrl, true).

-record(illustrationsBaseCfg, {
	%% 图鉴id
	iD,
	%% 名字
	%% （texts索引：IllustrationsName1,…）
	name,
	%% 稀有度
	%% 0为A
	%% 1为S
	%% 2为SS
	%% 3为SSS
	rareType,
	%% 初始星数
	star,
	%% 初始升品等级
	quality,
	%% 激活对应玩家等级
	playerLv,
	%% 图鉴熔炼，提供的熔炼经验
	%% 满星图鉴才可进行熔炼
	provideExp
}).

-endif.
