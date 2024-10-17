-ifndef(cfg_rndname_hrl).
-define(cfg_rndname_hrl, true).

-record(rndnameCfg, {
	iD,
	%% 性别：随机名字前缀
	%% 0：男
	%% 1：女
	firstname_sex,
	%% 性别：随机名字后缀
	%% 0：男
	%% 1：女
	oneprofession_sex,
	%% 索引
	index,
	%% 随机名字前缀
	firstname,
	%% 随机名字后缀
	oneprofession
}).

-endif.
