-ifndef(cfg_guildCopyItem_hrl).
-define(cfg_guildCopyItem_hrl, true).

-record(guildCopyItemCfg, {
	%% 道具ID
	iD,
	%% 单次使用道具数据
	num,
	%% 使用一次后一个进度boss掉血万分比
	proportion
}).

-endif.
