-ifndef(cfg_rndnamenew_hrl).
-define(cfg_rndnamenew_hrl, true).

-record(rndnamenewCfg, {
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
	%% 简体前缀
	firstname,
	%% 英语
	firstname_EN,
	%% 印度尼西亚语
	firstname_ID,
	%% 泰语
	firstname_TH,
	%% RU
	firstname_RU,
	%% FR
	firstname_FR,
	%% GE
	firstname_GE,
	%% TR
	firstname_TR,
	%% SP
	firstname_SP,
	%% PT
	firstname_PT,
	%% KR
	firstname_KR,
	%% TW
	firstname_TW,
	%% JP
	firstname_JP,
	%% 简体后缀
	oneprofession,
	%% 英语
	oneprofession_EN,
	%% 印度尼西亚语
	oneprofession_ID,
	%% 泰语
	oneprofession_TH,
	%% RU
	oneprofession_RU,
	%% FR
	oneprofession_FR,
	%% GE
	oneprofession_GE,
	%% TR
	oneprofession_TR,
	%% SP
	oneprofession_SP,
	%% PT
	oneprofession_PT,
	%% KR
	oneprofession_KR,
	%% TW
	oneprofession_TW,
	%% JP
	oneprofession_JP
}).

-endif.
