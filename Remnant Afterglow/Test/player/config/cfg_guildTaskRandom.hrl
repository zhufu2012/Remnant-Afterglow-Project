-ifndef(cfg_guildTaskRandom_hrl).
-define(cfg_guildTaskRandom_hrl, true).

-record(guildTaskRandomCfg, {
	%% 任务品质
	%% 品质：0、A；1、S；2、SS；3、SSS
	iD,
	%% 随机权重ID
	weightID,
	index,
	%% 随机权重
	weight,
	%% 具体任务ID
	taskID,
	%% 任务列表上的底图
	taskPic
}).

-endif.
