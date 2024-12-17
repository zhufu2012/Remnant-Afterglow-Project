-ifndef(cfg_hatcheEggsReward_hrl).
-define(cfg_hatcheEggsReward_hrl, true).

-record(hatcheEggsRewardCfg, {
	%% 孵化ID
	iD,
	%% 孵化类型
	%% 1水
	%% 2火
	%% 3土
	type,
	%% 文字表ID
	textName,
	%% 宠物ID
	petID,
	%% 宠物星级
	petStar,
	%% 孵化加速
	%% （宠物类型，加速万分比）
	%% 1风
	%% 2火
	%% 3土
	fastAcquire
}).

-endif.
