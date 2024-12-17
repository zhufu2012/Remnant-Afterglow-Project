-ifndef(cfg_gloryCarnival1_hrl).
-define(cfg_gloryCarnival1_hrl, true).

-record(gloryCarnival1Cfg, {
	%% 活动ID
	iD,
	%% 大标签活动ID
	%% 对应[GloryCarnival2_1_荣耀狂欢达成]表的ID
	oder1,
	%% 索引
	index,
	%% 大标签名称名称
	name,
	%% 大标签名称名称
	name_EN,
	%% 大标签名称名称
	name_IN,
	%% 大标签名称名称
	name_TH,
	%% RU
	name_RU,
	%% FR
	name_FR,
	%% GE
	name_GE,
	%% TR
	name_TR,
	%% SP
	name_SP,
	%% PT
	name_PT,
	%% KR
	name_KR,
	%% TW
	name_TW,
	%% JP
	name_JP,
	%% 该大标签活动在该轮活动开启后的开始时间
	startday,
	%% 该大标签活动在该轮活动开启后的结束时间
	endday,
	%% 大标签底板资源
	image
}).

-endif.
